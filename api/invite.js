// Inviterer et familiemedlem: opretter en bruger i Supabase med en midlertidig adgangskode.
// Kun brugere, der er logget ind, kan invitere. Adgangskoden sendes kun tilbage til den, der inviterer,
// og gemmes ikke andre steder. Kræver den hemmelige nøgle SUPABASE_SERVICE_ROLE_KEY i Vercel.

const crypto = require("crypto");

function supabaseOrigin(raw) {
  try { return new URL(String(raw || "").trim()).origin; } catch { return ""; }
}
function send(res, status, body) { res.setHeader("Cache-Control", "no-store"); res.status(status).json(body); }

async function signedIn(req, origin) {
  const auth = req.headers.authorization || "";
  if (!auth.startsWith("Bearer ")) return false;
  const r = await fetch(`${origin}/auth/v1/user`, {
    headers: { apikey: String(process.env.SUPABASE_ANON_KEY || "").trim(), Authorization: auth },
  });
  return r.ok;
}

// 12 tegn uden forvekslelige tegn som l, I, 0 og O, så den er let at skrive af.
function tempPassword() {
  const abc = "abcdefghjkmnpqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ23456789";
  let p = "";
  for (let i = 0; i < 12; i++) p += abc[crypto.randomInt(abc.length)];
  return p;
}

module.exports = async (req, res) => {
  if (req.method !== "POST") return send(res, 405, { error: "Brug POST." });
  const origin = supabaseOrigin(process.env.SUPABASE_URL);
  const key = String(process.env.SUPABASE_SERVICE_ROLE_KEY || "").trim();
  if (!origin) return send(res, 500, { error: "SUPABASE_URL mangler i Vercel." });
  if (!key) return send(res, 500, { error: "Invitation er ikke sat op endnu. Tilføj SUPABASE_SERVICE_ROLE_KEY i Vercel." });
  try { if (!(await signedIn(req, origin))) return send(res, 401, { error: "Log ind igen for at invitere." }); }
  catch { return send(res, 502, { error: "Login kunne ikke tjekkes. Prøv igen." }); }

  let body = req.body;
  if (typeof body === "string") { try { body = JSON.parse(body || "{}"); } catch { body = {}; } }
  const email = String((body && body.email) || "").trim().toLowerCase();
  if (email.length > 254 || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) return send(res, 400, { error: "Skriv en gyldig mailadresse." });

  const password = tempPassword();
  // Nye hemmelige nøgler (sb_secret_...) må kun sendes som apikey; gamle service_role-nøgler også som Bearer.
  const headers = { apikey: key, "content-type": "application/json" };
  if (!key.startsWith("sb_")) headers.Authorization = "Bearer " + key;
  let r, j;
  try {
    r = await fetch(`${origin}/auth/v1/admin/users`, {
      method: "POST", headers,
      body: JSON.stringify({ email, password, email_confirm: true }),
    });
    j = await r.json().catch(() => ({}));
  } catch { return send(res, 502, { error: "Supabase svarede ikke. Prøv igen." }); }

  if (!r.ok) {
    const msg = String(j.msg || j.message || j.error_description || j.error || "");
    if (r.status === 422 || /already|registered|exists/i.test(msg)) return send(res, 409, { error: "Der findes allerede en bruger med den mail. Personen kan logge ind med sin egen adgangskode." });
    if (r.status === 401 || r.status === 403) return send(res, 500, { error: "Nøglen til Supabase virker ikke. Tjek SUPABASE_SERVICE_ROLE_KEY i Vercel." });
    return send(res, 502, { error: `Brugeren blev ikke oprettet (${msg || "status " + r.status}).` });
  }
  return send(res, 200, { email, password });
};

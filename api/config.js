// Giver appen adressen og den offentlige nøgle til Supabase.
// Begge dele er beregnet til at ligge i en browser; adgangen styres af login og databasens regler.
function supabaseOrigin(raw) {
  // Accepterer også adresser med sti, fx https://xxxx.supabase.co/rest/v1/
  try { return new URL(String(raw || "").trim()).origin; } catch { return ""; }
}
module.exports = (req, res) => {
  const url = supabaseOrigin(process.env.SUPABASE_URL);
  const key = String(process.env.SUPABASE_ANON_KEY || "").trim();
  res.setHeader("Cache-Control", "no-store");
  if (!url || !key) {
    res.status(500).json({ error: "SUPABASE_URL eller SUPABASE_ANON_KEY mangler i Vercel." });
    return;
  }
  res.status(200).json({ supabaseUrl: url, supabaseAnonKey: key });
};

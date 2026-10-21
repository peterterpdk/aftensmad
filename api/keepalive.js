// Kaldes dagligt af Vercel (se vercel.json), så Supabase-gratisprojektet ikke går i dvale.
module.exports = async (req, res) => {
  const url = (process.env.SUPABASE_URL || "").replace(/\/+$/, "");
  const key = process.env.SUPABASE_ANON_KEY || "";
  if (!url || !key) { res.status(500).json({ ok: false }); return; }
  try {
    const r = await fetch(`${url}/rest/v1/recipes?select=id&limit=1`, { headers: { apikey: key } });
    res.status(200).json({ ok: r.ok, status: r.status, at: new Date().toISOString() });
  } catch (e) {
    res.status(200).json({ ok: false, error: String(e && e.message || e) });
  }
};

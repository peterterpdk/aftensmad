// Giver appen adressen og den offentlige nøgle til Supabase.
// Begge dele er beregnet til at ligge i en browser; adgangen styres af login og databasens regler.
module.exports = (req, res) => {
  const url = process.env.SUPABASE_URL || "";
  const key = process.env.SUPABASE_ANON_KEY || "";
  res.setHeader("Cache-Control", "no-store");
  if (!url || !key) {
    res.status(500).json({ error: "SUPABASE_URL eller SUPABASE_ANON_KEY mangler i Vercel." });
    return;
  }
  res.status(200).json({ supabaseUrl: url.replace(/\/+$/, ""), supabaseAnonKey: key });
};

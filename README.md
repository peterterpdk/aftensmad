# Planlæg ugens aftensmad

Familiens ugeplan for aftensmad som web-app til iPhonens hjemmeskærm.

## Indhold

- `index.html`, `app.js`, `styles.css`: selve appen.
- `manifest.webmanifest` og `icons/`: navn og ikon på hjemmeskærmen.
- `api/format.js`: henter en opskrift fra et link eller en indsat tekst og formaterer den med Claude.
- `api/config.js`: giver appen adressen til databasen.
- `api/keepalive.js`: kaldes dagligt, så gratis-databasen ikke går i dvale.
- `supabase/1-opsaetning.sql`: tabeller, adgangsregler og live-opdatering.
- `supabase/2-data.sql`: opskrifter og planer fra den tidligere side.
- `vendor/`: Supabase-biblioteket (MIT-licens).

## Nøgler i Vercel (Settings > Environment Variables)

| Navn | Hvor den findes |
|---|---|
| `SUPABASE_URL` | Supabase: Project Settings > Data API > Project URL |
| `SUPABASE_ANON_KEY` | Supabase: Project Settings > API Keys > Publishable key (sb_publishable_...) eller Legacy anon public |
| `ANTHROPIC_API_KEY` | console.anthropic.com > API Keys |

Valgfri: `CLAUDE_MODEL` (standard `claude-haiku-5-5`).

## Brugere

Opret familiemedlemmer i Supabase under Authentication > Users > Add user > Create new user, med "Auto Confirm User" slået til. Slå "Allow new users to sign up" fra, så ingen andre kan oprette sig.

# Planlæg ugens aftensmad

Familiens fælles ugeplan for aftensmad, opskriftskartotek og indkøbsliste. Web-app til iPhonens hjemmeskærm.
Ejer: peterterpdk. Alle tekster i appen og alle svar til brugeren er på dansk. Brug aldrig tankestreg (em dash) i tekster.

## Opbygning

- Statisk frontend uden build-trin: `index.html`, `app.js`, `styles.css`, `shopping.js`, `manifest.webmanifest`, `icons/`.
- `vendor/supabase.js`: Supabase-klienten (UMD, version 2.117.2). Hent ikke fra CDN.
- Vercel-funktioner i `api/` (CommonJS, Node 18+, global `fetch`):
  - `config.js`: giver frontend `SUPABASE_URL` (kun origin) og `SUPABASE_ANON_KEY`.
  - `format.js`: link eller tekst til opskrift via Claude. Henter siden selv; ved fx 403 falder den tilbage til Claudes `web_fetch`-værktøj og derefter til `CLAUDE_FALLBACK_MODEL`.
  - `search.js`: fri tekst til 3 opskriftsforslag via Claudes `web_search`. Viser kun links, der kom fra selve søgningen.
  - `keepalive.js`: daglig cron (se `vercel.json`), så Supabase-gratisprojektet ikke går i dvale.
  - API-funktionerne kræver et gyldigt Supabase-login (`Authorization: Bearer <access_token>`).
- Supabase (Postgres, RLS: alle loggede ind brugere må læse og skrive alt):
  - `recipes`: id, name, protein (kylling|okse|gris|fisk|vegetar), sides (jsonb array), minutes, servings, ingredients (jsonb), steps (jsonb), source, builtin.
  - `weeks`: id (fx `2026-W44`), days (jsonb). `days.d0`..`d6` = {recipe, protein, side, locked, skip}. `days.shop_struck` = {varenøgle: bool}, `days.shop_extra` = {id: tekst|null}.
  - `settings`: id `main`, data {ruleProtein}.
  - Skriv til uger med RPC `patch_week(p_id, p_patch)`, som fletter pr. nøgle, så flere telefoner ikke overskriver hinanden.
  - Skema: `supabase/1-opsaetning.sql`. Nye kolonner eller tabeller kræver et nyt SQL-script, som ejeren kører i Supabase.
- Miljøvariabler i Vercel: `SUPABASE_URL`, `SUPABASE_ANON_KEY`, `ANTHROPIC_API_KEY`, valgfri `ANTHROPIC_WORKSPACE_ID`, `CLAUDE_MODEL`, `CLAUDE_FALLBACK_MODEL`.

## Design

Farver følger logoet (mørkegrøn #22412F, creme #F6F0DA, guld #F3C14E). Alle farver er tokens i `:root` med mørk tilstand. Mobil først: ingen vandret scroll ved 390 px. Topbåndet reserverer 1,7 gange statuslinjens højde, fordi iOS lægger en lys toning over toppen.

## Arbejdsgang

- Lille, fokuseret ændring. Bevar alle eksisterende funktioner.
- Tjek syntaks: `node --check app.js shopping.js api/*.js`.
- Test i browser (Playwright/Chromium) med en mock af `window.supabase` og `/api/*`, ved 390 px og i mørk tilstand, før ændringen lægges op.
- Udgivelse sker automatisk, når `main` på GitHub ændres.
  - Er brugeren repo-ejeren (peterterpdk): commit og push til `main`.
  - Er brugeren en anden: opret en branch og en pull request til `main` med en kort dansk beskrivelse. Vercels gratis plan udgiver ikke andres commits fra et privat repo, så ejeren skal flette pull requesten.
- Læg aldrig nøgler, adgangskoder eller tokens i koden.

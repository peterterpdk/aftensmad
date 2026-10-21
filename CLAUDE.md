# Planlæg ugens aftensmad

Familiens fælles ugeplan for aftensmad, opskriftskartotek og indkøbsliste. Web-app til iPhonens hjemmeskærm.
Ejer: peterterpdk. Alle tekster i appen og alle svar til brugeren er på dansk. Brug aldrig tankestreg (em dash) i tekster.

## Opbygning

- Statisk frontend uden build-trin: `index.html`, `app.js`, `styles.css`, `shopping.js`, `manifest.webmanifest`, `icons/`.
- `vendor/supabase.js`: Supabase-klienten (UMD, version 2.117.2). Hent ikke fra CDN.
- Vercel-funktioner i `api/` (CommonJS, Node 18+, global `fetch`):
  - `config.js`: giver frontend `SUPABASE_URL` (kun origin) og `SUPABASE_ANON_KEY`.
  - `format.js`: link, tekst eller op til 3 billeder (`images`, base64 JPEG, højst ca. 1 MB hver) til opskrift via Claude. Henter siden selv; ved fx 403 falder den tilbage til Claudes `web_fetch`-værktøj og derefter til `CLAUDE_FALLBACK_MODEL`. Billeder gøres mindre i telefonen først, og kan Haiku ikke læse dem, prøver `CLAUDE_FALLBACK_MODEL`.
  - `search.js`: fri tekst til 3 opskriftsforslag via Claudes `web_search` med højst 2 opslag pr. søgning. Viser kun links, der kom fra selve søgningen.
  - `keepalive.js`: daglig cron (se `vercel.json`), så Supabase-gratisprojektet ikke går i dvale.
  - API-funktionerne kræver et gyldigt Supabase-login (`Authorization: Bearer <access_token>`).
- Supabase (Postgres, RLS: alle loggede ind brugere må læse og skrive alt):
  - `recipes`: id, name, protein (kylling|okse|gris|fisk|vegetar), sides (jsonb array), minutes, servings, ingredients (jsonb), steps (jsonb), source, builtin.
  - `weeks`: id (fx `2026-W44`), days (jsonb). `days.d0`..`d6` = {recipe, protein, side, locked, skip, quick, people}. `quick` = travl dag (kun retter på højst 30 min), `people` = antal personer den dag (null = opskriftens antal); opskrift og indkøbsliste regnes om med `Shopping.scaleLine` og `factor`. `days.shop_struck` = {varenøgle: bool}, `days.shop_extra` = {id: tekst|null}, `days.shop_days` = {d0..d6: false for dage, der ikke er med på indkøbslisten}.
  - `settings`: id `main`, data {ruleProtein}. Favoritter er rækker med id `fav:<opskrifts-id>` (findes = favorit) og trækkes tre gange så ofte. Reglen "ikke samme protein to dage i træk" bruges stadig ved trækning, men har ingen knap i appen.
  - Skriv til uger med RPC `patch_week(p_id, p_patch)`, som fletter pr. nøgle, så flere telefoner ikke overskriver hinanden.
  - Skema: `supabase/1-opsaetning.sql`. Nye kolonner eller tabeller kræver et nyt SQL-script, som ejeren kører i Supabase.
- Miljøvariabler i Vercel: `SUPABASE_URL`, `SUPABASE_ANON_KEY`, `ANTHROPIC_API_KEY`, valgfri `ANTHROPIC_WORKSPACE_ID`, `CLAUDE_MODEL`, `CLAUDE_FALLBACK_MODEL`.

## Design

Farver følger logoet (mørkegrøn #22412F, creme #F6F0DA, guld #F3C14E). Alle farver er tokens i `:root` med mørk tilstand. Mobil først: ingen vandret scroll ved 390 px. Topbåndet reserverer 1,7 gange statuslinjens højde, fordi iOS lægger en lys toning over toppen.

## Arbejdsgang

- Lille, fokuseret ændring. Bevar alle eksisterende funktioner.
- Tjek syntaks: `node --check app.js shopping.js api/*.js`.
- Test i browser (Playwright/Chromium) med en mock af `window.supabase` og `/api/*`, ved 390 px og i mørk tilstand, før ændringen lægges op.
- Udgivelse sker automatisk, når `main` på GitHub ændres. Commit og push direkte til `main`, når ændringen er testet. Repoet er offentligt, så Vercels gratis plan udgiver også commits fra andre end ejeren.
- Repoet er offentligt: læg aldrig nøgler, adgangskoder, tokens, mailadresser eller andre personoplysninger i koden eller i commit-beskeder. Brugere og data ligger kun i Supabase.

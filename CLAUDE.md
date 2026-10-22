# Dinnerweek (What’s for dinner?)

Appen hedder Dinnerweek med undertitlen What’s for dinner?. Familiens fælles ugeplan for aftensmad, opskriftskartotek og indkøbsliste. Web-app til iPhonens hjemmeskærm.
Ejer: peterterpdk. Alle tekster i appen og alle svar til brugeren er på dansk. Brug aldrig tankestreg (em dash) i tekster.

## Opbygning

- Statisk frontend uden build-trin: `index.html`, `app.js`, `styles.css`, `shopping.js`, `dishes.js`, `onboarding.js`, `manifest.webmanifest`, `icons/`.
- `dishes.js` (indlæses før `onboarding.js`): `window.DW_DISHES` med 50 retter pr. region (DK, NO, SE, FI, DE, NL, PL, UK) som [id, navn på landets sprog, engelsk navn eller null, protein]. Genereres fra `supabase/presets/*.json` (format `madplan.profile`, landets sprog og `.en`-udgave); DK kommer fra de indbyggede opskrifter.
- `onboarding.js` (indlæses før `app.js`): skærmene før login med sproglag (en, da, nb, sv; engelsk som standard) og trinnet med retter for den valgte region. Retternes navne vises på landets sprog, eller på engelsk når brugerfladen er engelsk og der findes engelske navne. Giver `window.Onb` med `go`, `t`, `apply`. Valgt sprog og region huskes i `localStorage` (`dw-ob-lang`, `dw-ob-region`).
- `vendor/supabase.js`: Supabase-klienten (UMD, version 2.117.2). Hent ikke fra CDN.
- Vercel-funktioner i `api/` (CommonJS, Node 18+, global `fetch`):
  - `config.js`: giver frontend `SUPABASE_URL` (kun origin) og `SUPABASE_ANON_KEY`.
  - `format.js`: rettens navn (`dish`, Claude skriver selv opskriften til 4 personer uden websøgning), link, tekst eller op til 3 billeder (`images`, base64 JPEG, højst ca. 1 MB hver) til opskrift via Claude. Henter siden selv; ved fx 403 falder den tilbage til Claudes `web_fetch`-værktøj og derefter til `CLAUDE_FALLBACK_MODEL`. Billeder gøres mindre i telefonen først, og kan Haiku ikke læse dem, prøver `CLAUDE_FALLBACK_MODEL`.
  - `invite.js`: inviterer et familiemedlem fra Profil. Opretter brugeren via Supabase Admin API med en midlertidig adgangskode (bekræftet med det samme) og sender den kun tilbage til den, der inviterer. Kræver `SUPABASE_SERVICE_ROLE_KEY` (nye `sb_secret_`-nøgler sendes kun som `apikey`).
  - `keepalive.js`: daglig cron (se `vercel.json`), så Supabase-gratisprojektet ikke går i dvale.
  - API-funktionerne kræver et gyldigt Supabase-login (`Authorization: Bearer <access_token>`).
- Supabase (Postgres, RLS: alle loggede ind brugere må læse og skrive alt):
  - `recipes`: id, name, protein (kylling|okse|lam|gris|fisk|vegetar; lam kræver `supabase/3-lam.sql`), sides (jsonb array), minutes, servings, ingredients (jsonb), steps (jsonb), source, builtin.
  - `weeks`: id (fx `2026-W44`), days (jsonb). `days.d0`..`d6` = {recipe, protein, side, locked, skip, quick, people}. `quick` = travl dag (kun retter på højst 30 min), `people` = antal personer den dag (null = opskriftens antal); opskrift og indkøbsliste regnes om med `Shopping.scaleLine` og `factor`. `days.shop_struck` = {varenøgle: bool}, `days.shop_extra` = {id: tekst|null}, `days.shop_days` = {d0..d6: false for dage, der ikke er med på indkøbslisten}.
  - `settings`: id `main`, data {ruleProtein}. Favoritter er rækker med id `fav:<opskrifts-id>` (findes = favorit) og trækkes tre gange så ofte. Reglen "ikke samme protein to dage i træk" bruges stadig ved trækning, men har ingen knap i appen.
  - Skriv til uger med RPC `patch_week(p_id, p_patch)`, som fletter pr. nøgle, så flere telefoner ikke overskriver hinanden.
  - De fulde opskrifter for de andre lande ligger i `supabase/presets/` og er endnu ikke lagt i Supabase (det kræver et regionsfelt og enheder på flere sprog i `shopping.js`).
  - Skema: `supabase/1-opsaetning.sql`. Nye kolonner eller tabeller kræver et nyt SQL-script, som ejeren kører i Supabase.
- Miljøvariabler i Vercel: `SUPABASE_URL`, `SUPABASE_ANON_KEY`, `ANTHROPIC_API_KEY`, valgfri `ANTHROPIC_WORKSPACE_ID`, `CLAUDE_MODEL`, `CLAUDE_FALLBACK_MODEL`, `SUPABASE_SERVICE_ROLE_KEY` (hemmelig, kun til invitationer).

## Design

Tre faner i det grønne topbånd: Ugen (ugeplan og indkøbsliste), Opskrifter (kartotek) og Profil (konto, inviter familiemedlem, skift adgangskode, log ud). Valgt fane huskes i `localStorage` (`aftensmad-tab`). Uden login vises en prototype på oprettelse: Velkomst på engelsk, hvor sprog og region vælges først (region er påkrævet) og derefter Opret konto / Log ind; trin 1 Opret konto (metode), trin 2 Vælg udgave (Gratis, Fuld version, Premium) og trin 3 Retter (de 50 retter for regionen med flueben fra start; tryk fjerner fluebenet og streger retten ud). Valgene markeres kun og gemmes ikke i Supabase; Log ind med mail og adgangskode virker. Appen efter login er på dansk. Farver følger logoet (mørkegrøn #22412F, creme #F6F0DA, guld #F3C14E). Alle farver er tokens i `:root` med mørk tilstand. Mobil først: ingen vandret scroll ved 390 px. Topbåndet reserverer 1,7 gange statuslinjens højde, fordi iOS lægger en lys toning over toppen.

## Arbejdsgang

- Lille, fokuseret ændring. Bevar alle eksisterende funktioner.
- Tjek syntaks: `node --check app.js shopping.js api/*.js`.
- Test i browser (Playwright/Chromium) med en mock af `window.supabase` og `/api/*`, ved 390 px og i mørk tilstand, før ændringen lægges op.
- Udgivelse sker automatisk, når `main` på GitHub ændres. Commit og push direkte til `main`, når ændringen er testet. Repoet er offentligt, så Vercels gratis plan udgiver også commits fra andre end ejeren.
- Repoet er offentligt: læg aldrig nøgler, adgangskoder, tokens, mailadresser eller andre personoplysninger i koden eller i commit-beskeder. Brugere og data ligger kun i Supabase.

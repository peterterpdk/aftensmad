# Plan: Dinnerweek som iOS-app

Udgangspunkt: web-appen i dette repo (statisk frontend, Vercel-funktioner i `api/`, Supabase). Målet er en native app til iPhone og iPad, som kan sælges i App Store.

## 1. Det, der skal afklares først

1. **Ejerskab.** Repoet og koden tilhører `peterterpdk`. Skal appen sælges, skal det være aftalt, hvem der ejer koden, presets og navnet Dinnerweek, og hvem der står som udgiver i App Store.
2. **Eget repo.** Repoet er offentligt, og `main` udgiver familiens web-app. En kommerciel app hører hjemme i et privat repo. Web-appen kan ligge med som undermappe eller blive i sit eget repo; presets og prompts kopieres over.
3. **Eget Supabase-projekt.** Familiens projekt har én fælles database, hvor alle loggede ind brugere ser alt (RLS `using (true)`), og oprettelse er slået fra. Appen skal have et nyt projekt med husstande (afsnit 3). Familiens data kan flyttes ind som første husstand senere.
4. **AI-model.** I dag betaler serveren Claude-kaldene med én nøgle. Til salg er der to veje: (a) Premium-abonnementet betaler for kaldene, og serveren tæller forbrug pr. husstand, eller (b) brugeren vælger selv AI-udbyder med egen nøgle i Keychain. (a) er enklest for brugeren og passer til udgaverne i onboarding-prototypen; (b) kræver ingen serverudgift, men få brugere har en API-nøgle.
5. **Deling.** Supabase (konti, virker på web og senere Android) eller iCloud/CloudKit (ingen konti, kun Apple). Planen nedenfor bygger på Supabase, fordi web-appen allerede gør det.

## 2. Fra web til iOS

| Web | iOS |
|---|---|
| `index.html`, `app.js` (Ugen, Opskrifter, Profil) | SwiftUI med `TabView` på iPhone og `NavigationSplitView` på iPad |
| Trækning, lås, spring over, travl dag, personer pr. dag | `WeekPlanner` (ren Swift, testes), samme regler: favoritter tæller 3 gange, ikke samme protein to dage i træk |
| `shopping.js` (sammenlægning, enheder, afdelinger) | `ShoppingList.swift` med tests. Enheder og afdelinger gøres pr. sprog, så landepresets kan bruges |
| `patch_week` RPC | Samme RPC med `household_id` |
| Realtime-kanal | `supabase-swift` Realtime |
| `onboarding.js` (sprog, region, udgave, retter) | Onboarding-flow, nu med rigtig oprettelse og køb |
| `api/invite.js` (midlertidig adgangskode) | Invitationskode eller -link til husstanden; ingen adgangskoder sendes rundt |
| `api/format.js` (navn, link, tekst, billeder, Instagram, Facebook) | Samme endpoint, kaldt fra appen og fra Share Extension. Udvides med `LOCALES` for flere lande |
| Wake Lock ("Jeg er i køkkenet") | `UIApplication.isIdleTimerDisabled` |
| `supabase/presets/*.json` | Bundle-ressourcer; vælges i onboarding og indlæses i husstandens kartotek |

## 3. Datamodel med husstande (nyt Supabase-projekt)

- `households` (id uuid, name, region, language, created_at)
- `household_members` (household_id, user_id, role `owner|member`, created_at). En bruger tilhører én husstand.
- `household_invites` (code, household_id, created_by, expires_at, used_by)
- `recipes`, `weeks`, `settings` som i dag, men med `household_id` og primærnøgle `(household_id, id)`.
- `entitlements` (household_id, product, expires_at), opdateres fra App Store Server Notifications.
- `ai_usage` (household_id, month, count) til grænserne pr. udgave.
- RLS på alle tabeller: kun medlemmer af husstanden. Hjælpefunktion `is_member(household_id)` (security definer).
- Storage: privat bøtte, stier `<household_id>/...`, adgang via samme medlemskab. Billeder vises med signerede adresser.
- Konti: Sign in with Apple og mail. Sletning af konto inde i appen (krav fra Apple), via en Edge Function med secret key.

## 4. Faser

1. **Fundament.** Xcode-projekt i `ios/`, `supabase-swift`, `Config.xcconfig`, nyt Supabase-projekt med skemaet ovenfor, login med Apple og mail. Første TestFlight-build.
2. **Kernen.** Ugen (trækning, lås, filtre, travl dag, personer), Opskrifter (liste, visning, favorit, redigér, slet), indkøbsliste med tests, live-opdatering, lokal cache.
3. **Husstand.** Invitation med kode eller link, medlemmer i Profil, forlad husstand.
4. **Import.** Share Extension med App Group: del et link fra Instagram, Facebook eller Safari, og opskriften lander i kartoteket. Kamera og billeder som i web-udgaven.
5. **Onboarding og presets.** Sprog, region, valg af retter fra preset, første uge trukket.
6. **Betaling.** StoreKit 2: Gratis, Fuld version (engangskøb), Premium (abonnement). Grænser håndhæves på serveren, ikke kun i appen.
7. **Sprog og lande.** String Catalog, landepresets (pilot UK, DE, SE, PL), `LOCALES` og indkøbslistens enheder pr. land.
8. **App Store.** Privacy manifest, privatlivsoplysninger, kontosletning, skærmbilleder til iPhone og iPad, review.

## 5. Arbejdsgang

- Claude Code kører lokalt på Mac'en i repoets mappe, så den kan bygge med `xcodebuild`, læse fejl og rette dem (se `ios/CLAUDE.md`).
- Xcode bruges til signering, simulator, Instruments og upload til App Store Connect.
- Én fase ad gangen på en gren, med TestFlight-build efter hver fase.

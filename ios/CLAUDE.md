# Dinnerweek til iOS

Native app til iPhone og iPad, bygget på web-appen i roden af repoet. Den fulde plan står i `ios/PLAN.md`.
Svar og kommentarer til ejeren er på dansk. Brug aldrig tankestreg (em dash) i tekster.

## Teknik

- SwiftUI, iOS 17 eller nyere, Swift 6. Én kodebase til iPhone og iPad (`NavigationSplitView` på iPad).
- State med `@Observable`. Ingen andre tredjepartsbiblioteker end `supabase-swift` (Swift Package Manager) uden at spørge først.
- Data: Supabase er kilden. Appen holder en lokal kopi (JSON-cache i Application Support), så den åbner hurtigt og virker uden net; ændringer sendes, når der er forbindelse.
- Tekster: String Catalog (`Localizable.xcstrings`). Udviklingssprog engelsk, dansk som første oversættelse. Ingen tekster hårdkodet i views.
- Betaling: StoreKit 2. Udgaver som i onboarding-prototypen: Gratis, Fuld version (engangskøb), Premium med AI (abonnement).

## Mapper

- `ios/Dinnerweek/` appen: `App/`, `Models/`, `Services/` (SupabaseService, RecipeImportService, StoreService), `Features/Week`, `Features/Recipes`, `Features/Shopping`, `Features/Profile`, `Features/Onboarding`, `Resources/`.
- `ios/DinnerweekShare/` Share Extension (link fra Instagram, Facebook, Safari). Deler data med appen via App Group.
- `ios/DinnerweekTests/` unit tests. Indkøbslisten (port af `shopping.js`) skal have tests med de samme eksempler som web-udgaven.
- `ios/supabase/` SQL til appens eget Supabase-projekt (husstande). Rør ikke `supabase/` i roden, den hører til familiens web-app.
- Presets: `supabase/presets/*.json` (format `madplan.profile`) kopieres ind som bundle-ressourcer. Rediger dem ikke i `ios/`.

## Build og test

Byg og test fra terminalen, så fejl kan læses og rettes uden Xcode:

```
xcodebuild -project ios/Dinnerweek.xcodeproj -scheme Dinnerweek \
  -destination 'platform=iOS Simulator,name=iPhone 16' build test
```

Byg efter hver ændring. Ret alle fejl og advarsler, før en opgave meldes færdig. Tjek også iPad-simulatoren ved ændringer i layout.

## Regler

- Repoet er offentligt, og `main` udgiver familiens web-app automatisk på Vercel. Arbejd på grene til iOS, og push aldrig til `main` uden ejerens accept.
- Læg aldrig nøgler, adgangskoder, tokens, mailadresser eller personoplysninger i koden. Supabase-adresse og publishable key ligger i `ios/Config.xcconfig`, som er i `.gitignore`; `ios/Config.example.xcconfig` viser formatet.
- Ingen hemmelige nøgler i appen (Anthropic, Supabase secret). AI-kald går gennem serveren (`api/format.js` eller en Supabase Edge Function).
- Rør ikke filer uden for `ios/` uden at spørge.
- Lille, fokuseret ændring ad gangen. Bevar funktioner, der virker.

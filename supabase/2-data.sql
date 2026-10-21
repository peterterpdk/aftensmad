-- Planlæg ugens aftensmad: flytning af data fra den tidligere side.
-- Kør efter 1-opsaetning.sql. Kan køres igen uden at lave dubletter.

insert into public.recipes (id, name, protein, sides, minutes, servings, ingredients, steps, source, builtin)
select id, name, protein, sides, minutes, servings, ingredients, steps, source, builtin
from jsonb_populate_recordset(null::public.recipes, $AFTENSMAD$[
 {
  "id": "biksemad-med-spejlaeg",
  "name": "Biksemad med spejlæg",
  "protein": "okse",
  "sides": [
   "kartofler"
  ],
  "minutes": 35,
  "servings": 4,
  "ingredients": [
   "400 g rester af steg eller 400 g hakket oksekød",
   "1 kg kogte kartofler",
   "2 løg",
   "30 g smør",
   "4 æg",
   "syltede rødbeder",
   "Worcestershire sauce",
   "salt og peber"
  ],
  "steps": [
   "Skær kartofler, løg og kød i små tern.",
   "Steg kartoflerne sprøde og gyldne i smør.",
   "Tilsæt løg og kød og steg videre, til det hele er varmt og har fået farve.",
   "Steg spejlæggene.",
   "Server biksemaden med spejlæg, rødbeder og Worcestershire sauce."
  ],
  "source": "https://www.valdemarsro.dk/biksemad/",
  "builtin": true
 },
 {
  "id": "boef-med-bearnaise-og-kartoffelbaade",
  "name": "Bøf med bearnaise og kartoffelbåde",
  "protein": "okse",
  "sides": [
   "kartofler",
   "salat"
  ],
  "minutes": 45,
  "servings": 4,
  "ingredients": [
   "4 bøffer af oksekød, fx tyksteg eller ribeye",
   "1 kg kartofler",
   "2 spsk olivenolie",
   "200 g smør",
   "3 æggeblommer",
   "2 spsk estragoneddike",
   "1 skalotteløg",
   "frisk estragon",
   "grøn salat",
   "salt og peber"
  ],
  "steps": [
   "Tænd ovnen på 220 grader. Skær kartoflerne i både, vend med olie og salt og bag ca. 35 minutter.",
   "Kog eddike og hakket skalotteløg ind til halvdelen. Si det.",
   "Pisk æggeblommer med reduktionen over vandbad og pisk smeltet smør i i en tynd stråle. Tilsæt hakket estragon og salt.",
   "Steg bøfferne ved høj varme 2 til 4 minutter på hver side efter tykkelse og lad dem hvile 5 minutter.",
   "Server med kartoffelbåde, bearnaise og grøn salat."
  ],
  "source": "https://madensverden.dk/herregaardsboef/",
  "builtin": true
 },
 {
  "id": "boller-i-karry",
  "name": "Boller i karry",
  "protein": "gris",
  "sides": [
   "ris"
  ],
  "minutes": 50,
  "servings": 4,
  "ingredients": [
   "500 g hakket svine- og kalvekød",
   "1 æg",
   "2 spsk hvedemel",
   "1 dl mælk",
   "1 løg",
   "1 æble",
   "2 spsk karry",
   "40 g smør",
   "3 spsk hvedemel til sovs",
   "1 dl madlavningsfløde",
   "300 g ris",
   "salt og peber"
  ],
  "steps": [
   "Rør farsen af kød, æg, mel, mælk, salt og peber.",
   "Sæt vand over i en gryde, form små boller med to teskeer og kog dem 8 minutter. Gem 6 dl af kogevandet.",
   "Kog risene.",
   "Svits løg, æble og karry i smør, rør mel i og spæd med kogevandet. Tilsæt fløde.",
   "Kom bollerne i sovsen og varm dem igennem."
  ],
  "source": "https://www.valdemarsro.dk/boller-i-karry/",
  "builtin": true
 },
 {
  "id": "bulgursalat-med-halloumi",
  "name": "Bulgursalat med halloumi",
  "protein": "vegetar",
  "sides": [
   "bulgur",
   "salat"
  ],
  "minutes": 30,
  "servings": 4,
  "ingredients": [
   "250 g bulgur",
   "2 pakker halloumi",
   "250 g cherrytomater",
   "1 agurk",
   "1 rødløg",
   "1 bundt persille",
   "1 bundt mynte",
   "1 granatæble",
   "3 spsk olivenolie",
   "1 citron",
   "salt og peber"
  ],
  "steps": [
   "Kog bulguren efter anvisningen og lad den køle lidt af.",
   "Hak tomater, agurk, løg og krydderurter.",
   "Vend det hele med bulguren, olie, citronsaft, salt og peber.",
   "Skær halloumi i skiver og steg dem gyldne på en tør pande.",
   "Top salaten med halloumi og granatæblekerner."
  ],
  "source": "https://gourministeriet.dk/bulgursalat-med-sproed-halloumi-og-hot-honey/",
  "builtin": true
 },
 {
  "id": "butter-chicken",
  "name": "Butter chicken",
  "protein": "kylling",
  "sides": [
   "ris"
  ],
  "minutes": 45,
  "servings": 4,
  "ingredients": [
   "700 g kyllingelår uden ben",
   "2 dl græsk yoghurt",
   "2 spsk garam masala",
   "1 løg",
   "3 fed hvidløg",
   "1 spsk revet ingefær",
   "1 dåse hakkede tomater",
   "50 g smør",
   "1,5 dl piskefløde",
   "frisk koriander",
   "300 g basmatiris"
  ],
  "steps": [
   "Skær kyllingen i stykker og vend den med yoghurt, halvdelen af garam masala og salt. Lad den trække 15 minutter.",
   "Kog risene.",
   "Steg kyllingen gylden på en varm pande og tag den af.",
   "Smelt smørret og svits løg, hvidløg, ingefær og resten af krydderiet 5 minutter. Tilsæt tomater og kog 10 minutter.",
   "Blend saucen glat, tilsæt fløde og kylling og lad det simre 10 minutter. Drys med koriander."
  ],
  "source": "https://www.valdemarsro.dk/butter_chicken/",
  "builtin": true
 },
 {
  "id": "caesarsalat-med-kylling",
  "name": "Cæsarsalat med kylling",
  "protein": "kylling",
  "sides": [
   "salat",
   "brod"
  ],
  "minutes": 30,
  "servings": 4,
  "ingredients": [
   "500 g kyllingebryst",
   "2 hjertesalater",
   "4 skiver brød til croutoner",
   "50 g parmesan",
   "1 dl mayonnaise",
   "1 fed hvidløg",
   "1 tsk dijonsennep",
   "1 spsk citronsaft",
   "2 ansjosfileter (kan udelades)",
   "olivenolie"
  ],
  "steps": [
   "Steg kyllingen gennem og skær den i skiver.",
   "Skær brødet i tern, vend det i olie og rist det sprødt på panden eller i ovnen.",
   "Rør dressing af mayonnaise, revet hvidløg, sennep, citron, hakkede ansjoser og lidt parmesan.",
   "Vend salaten med dressingen og top med kylling, croutoner og høvlet parmesan."
  ],
  "source": "https://www.valdemarsro.dk/caesarsalat/",
  "builtin": true
 },
 {
  "id": "chili-con-carne",
  "name": "Chili con carne",
  "protein": "okse",
  "sides": [
   "ris"
  ],
  "minutes": 50,
  "servings": 4,
  "ingredients": [
   "500 g hakket oksekød",
   "1 løg",
   "2 fed hvidløg",
   "1 rød peberfrugt",
   "2 dåser hakkede tomater",
   "1 dåse kidneybønner",
   "2 tsk spidskommen",
   "2 tsk paprika",
   "1 tsk chili",
   "300 g ris",
   "creme fraiche"
  ],
  "steps": [
   "Brun kødet i en gryde med løg, hvidløg og peberfrugt.",
   "Tilsæt krydderier og svits et minut.",
   "Kom tomater og skyllede bønner i og lad det simre 30 minutter.",
   "Kog risene.",
   "Server med en klat creme fraiche."
  ],
  "source": "https://www.valdemarsro.dk/chili-con-carne/",
  "builtin": true
 },
 {
  "id": "chili-sin-carne",
  "name": "Chili sin carne",
  "protein": "vegetar",
  "sides": [
   "ris"
  ],
  "minutes": 45,
  "servings": 4,
  "ingredients": [
   "1 løg",
   "2 fed hvidløg",
   "1 rød peberfrugt",
   "2 gulerødder",
   "1 dåse kidneybønner",
   "1 dåse sorte bønner",
   "1 dåse majs",
   "2 dåser hakkede tomater",
   "100 g røde linser",
   "2 tsk spidskommen",
   "2 tsk paprika",
   "300 g ris",
   "creme fraiche"
  ],
  "steps": [
   "Svits løg, hvidløg, peberfrugt og gulerødder i en gryde.",
   "Tilsæt krydderier og svits et minut.",
   "Kom tomater, linser, 3 dl vand og de skyllede bønner i. Lad det simre 25 minutter.",
   "Kog risene.",
   "Tilsæt majs, smag til og server med creme fraiche."
  ],
  "source": "https://www.valdemarsro.dk/chili-sin-carne/",
  "builtin": true
 },
 {
  "id": "couscous-med-ovnbagte-groentsager-og-feta",
  "name": "Couscous med ovnbagte grøntsager og feta",
  "protein": "vegetar",
  "sides": [
   "couscous"
  ],
  "minutes": 40,
  "servings": 4,
  "ingredients": [
   "250 g couscous",
   "1 squash",
   "1 aubergine",
   "2 rød peberfrugt",
   "1 rødløg",
   "1 dåse kikærter",
   "3 spsk olivenolie",
   "1 tsk spidskommen",
   "200 g feta",
   "frisk mynte",
   "1 citron"
  ],
  "steps": [
   "Tænd ovnen på 220 grader. Skær grøntsagerne i stykker og vend dem med kikærter, olie, spidskommen og salt. Bag 25 minutter.",
   "Hæld kogende vand over couscousen efter anvisningen og lad den stå 5 minutter.",
   "Løsn couscousen og vend den med de ristede grøntsager og citronsaft.",
   "Smuldr feta over og drys med mynte."
  ],
  "source": "https://mummum.dk/marrokansk-couscous/",
  "builtin": true
 },
 {
  "id": "cremet-citronpasta-med-kylling-9owr",
  "name": "Cremet citronpasta med kylling",
  "protein": "kylling",
  "sides": [
   "pasta"
  ],
  "minutes": 20,
  "servings": 4,
  "ingredients": [
   "400 g pasta",
   "400 g kyllingekød i mundrette stykker",
   "4 æggeblommer",
   "25 g smør",
   "1 citron, saft og fintrevet skal",
   "100 g parmesan, fintrevet",
   "8 stilke frisk basilikum, kun blade",
   "1 spsk olie til stegning",
   "0,5 dl pastavand, plus lidt ekstra efter behov",
   "salt og peber efter smag"
  ],
  "steps": [
   "Brun kyllingestykkerne i lidt olie på en pande, til de er stegt igennem, og krydr med salt og peber.",
   "Kog pastaen al dente i godt saltet vand, og gem en kop af kogevandet.",
   "Rør æggeblommer, citronsaft, citronskal og ½ dl pastavand sammen i en skål.",
   "Kom den afdryppede pasta i panden med kyllingen ved svag varme.",
   "Vend smørret i, til det er smeltet, og vend derefter æggeblandingen grundigt i.",
   "Tilsæt parmesan og basilikumblade, og rør på svag varme, til saucen er cremet; spæd med pastavand efter behov.",
   "Smag til med salt og friskkværnet peber, og server gerne med ekstra parmesan."
  ],
  "source": "https://gourministeriet.dk/cremet-citronpasta-med-kylling/",
  "builtin": false
 },
 {
  "id": "dal-med-roede-linser",
  "name": "Dal med røde linser",
  "protein": "vegetar",
  "sides": [
   "ris"
  ],
  "minutes": 35,
  "servings": 4,
  "ingredients": [
   "300 g røde linser",
   "1 løg",
   "3 fed hvidløg",
   "1 spsk revet ingefær",
   "2 tsk karry",
   "1 tsk gurkemeje",
   "1 tsk spidskommen",
   "1 dåse kokosmælk",
   "1 dåse hakkede tomater",
   "1 pose babyspinat",
   "300 g ris",
   "frisk koriander"
  ],
  "steps": [
   "Svits løg, hvidløg, ingefær og krydderier.",
   "Tilsæt linser, kokosmælk, tomater og 5 dl vand. Lad det simre ca. 20 minutter, til linserne er møre.",
   "Kog risene.",
   "Rør spinaten i til sidst og smag til med salt og citron.",
   "Server med ris og koriander."
  ],
  "source": "https://www.valdemarsro.dk/dhal/",
  "builtin": true
 },
 {
  "id": "falafel-i-pitabroed",
  "name": "Falafel i pitabrød",
  "protein": "vegetar",
  "sides": [
   "brod",
   "salat"
  ],
  "minutes": 35,
  "servings": 4,
  "ingredients": [
   "24 falafler (købte eller hjemmelavede)",
   "8 pitabrød",
   "1 hjertesalat",
   "2 tomater",
   "1 agurk",
   "1 rødløg",
   "3 dl græsk yoghurt",
   "2 spsk tahin",
   "1 citron",
   "1 fed hvidløg"
  ],
  "steps": [
   "Varm falaflerne i ovnen efter anvisningen.",
   "Skær grøntsagerne i strimler og tern.",
   "Rør yoghurt med tahin, citronsaft, revet hvidløg og salt.",
   "Rist pitabrødene og fyld dem med salat, grønt, falafler og dressing."
  ],
  "source": "https://www.arla.dk/opskrifter/pitabrod-med-falafel/",
  "builtin": true
 },
 {
  "id": "fish-and-chips",
  "name": "Fish and chips",
  "protein": "fisk",
  "sides": [
   "kartofler",
   "salat"
  ],
  "minutes": 45,
  "servings": 4,
  "ingredients": [
   "700 g torsk eller sej",
   "1 kg kartofler",
   "150 g hvedemel",
   "2 dl kold øl eller danskvand",
   "1 tsk bagepulver",
   "olie til friturestegning",
   "remoulade eller tartarsauce",
   "1 citron",
   "salt"
  ],
  "steps": [
   "Tænd ovnen på 220 grader. Skær kartoflerne i stave, vend med olie og salt og bag 35 minutter.",
   "Pisk mel, bagepulver, salt og kold øl til en tyk dej.",
   "Skær fisken i stykker, dup dem tørre, vend dem i dejen og friturestej ved 180 grader 4 til 5 minutter.",
   "Lad fisken dryppe af på køkkenrulle.",
   "Server med fritter, sauce og citron."
  ],
  "source": "https://www.valdemarsro.dk/fish-n-chips/",
  "builtin": true
 },
 {
  "id": "fiskefilet-i-fad-med-groentsager",
  "name": "Fiskefilet i fad med grøntsager",
  "protein": "fisk",
  "sides": [
   "ris"
  ],
  "minutes": 40,
  "servings": 4,
  "ingredients": [
   "700 g hvid fisk, fx sej eller torsk",
   "1 porre",
   "2 gulerødder",
   "1 squash",
   "2,5 dl madlavningsfløde",
   "1 spsk karry eller dijonsennep",
   "100 g revet ost",
   "300 g ris",
   "salt og peber"
  ],
  "steps": [
   "Tænd ovnen på 200 grader. Kog risene.",
   "Læg fisken i et smurt fad og krydr med salt og peber.",
   "Fordel snittede grøntsager over fisken.",
   "Rør fløde med karry eller sennep, hæld over og drys med ost.",
   "Bag ca. 25 minutter."
  ],
  "source": "https://www.valdemarsro.dk/fiskefad-med-torsk-og-porrer/",
  "builtin": true
 },
 {
  "id": "fiskefrikadeller-med-remoulade",
  "name": "Fiskefrikadeller med remoulade",
  "protein": "fisk",
  "sides": [
   "kartofler",
   "salat"
  ],
  "minutes": 40,
  "servings": 4,
  "ingredients": [
   "500 g hakket fisk eller fiskefars",
   "1 løg",
   "1 æg",
   "3 spsk hvedemel",
   "1 dl mælk",
   "frisk dild",
   "smør til stegning",
   "1 kg kartofler",
   "remoulade",
   "1 citron",
   "salt og peber"
  ],
  "steps": [
   "Rør fiskefars med revet løg, æg, mel, mælk, dild, salt og peber.",
   "Kog kartoflerne.",
   "Form frikadeller med en ske og steg dem i smør ca. 4 minutter på hver side.",
   "Server med kartofler, remoulade og citronbåde."
  ],
  "source": "https://www.valdemarsro.dk/fiskefrikadeller/",
  "builtin": true
 },
 {
  "id": "flaeskesteg-med-brun-sovs-og-roedkaal",
  "name": "Flæskesteg med brun sovs og rødkål",
  "protein": "gris",
  "sides": [
   "kartofler"
  ],
  "minutes": 120,
  "servings": 4,
  "ingredients": [
   "1,5 kg flæskesteg med svær",
   "1 kg kartofler",
   "groft salt",
   "laurbærblade",
   "5 dl vand eller bouillon",
   "2 spsk maizena",
   "kulør",
   "1 glas rødkål"
  ],
  "steps": [
   "Tænd ovnen på 200 grader. Rids sværen, gnid med groft salt og stik laurbær i snittene.",
   "Steg stegen i ca. 1,5 time til 65 grader i midten. Skru op på 250 grader eller brug grill til sidst, så sværen popper.",
   "Kog kartoflerne.",
   "Kog stegeskyen op med vand, jævn med maizena og giv kulør.",
   "Lad stegen hvile 10 minutter og server med kartofler, sovs og rødkål."
  ],
  "source": "https://www.valdemarsro.dk/flaeskesteg/",
  "builtin": true
 },
 {
  "id": "frikadeller-med-kartofler-og-brun-sovs",
  "name": "Frikadeller med kartofler og brun sovs",
  "protein": "gris",
  "sides": [
   "kartofler"
  ],
  "minutes": 50,
  "servings": 4,
  "ingredients": [
   "500 g hakket svine- og kalvekød",
   "1 løg",
   "1 æg",
   "3 spsk hvedemel",
   "1,5 dl mælk",
   "smør til stegning",
   "1 kg kartofler",
   "3 dl bouillon",
   "1 spsk maizena",
   "kulør",
   "salt og peber"
  ],
  "steps": [
   "Rør kød med revet løg, æg, mel, mælk, salt og peber til en fast fars. Lad den hvile 15 minutter.",
   "Kog kartoflerne.",
   "Form frikadeller med en ske og steg dem i smør ca. 6 minutter på hver side.",
   "Kog panden af med bouillon, jævn med maizena og giv kulør.",
   "Server med kartofler, sovs og syltede agurker eller rødkål."
  ],
  "source": "https://www.valdemarsro.dk/frikadeller-med-pandesauce/",
  "builtin": true
 },
 {
  "id": "groentsagslasagne",
  "name": "Grøntsagslasagne",
  "protein": "vegetar",
  "sides": [
   "pasta",
   "salat"
  ],
  "minutes": 90,
  "servings": 4,
  "ingredients": [
   "2 squash",
   "1 aubergine",
   "2 rød peberfrugt",
   "1 løg",
   "2 fed hvidløg",
   "2 dåser hakkede tomater",
   "12 lasagneplader",
   "50 g smør",
   "4 spsk hvedemel",
   "7 dl mælk",
   "150 g revet ost",
   "salt og peber"
  ],
  "steps": [
   "Skær grøntsagerne i tern og steg dem med løg og hvidløg. Tilsæt tomater og lad det simre 15 minutter.",
   "Lav bechamel af smør, mel og mælk.",
   "Tænd ovnen på 200 grader.",
   "Læg grøntsagssauce, plader og bechamel lagvis og slut med bechamel og ost.",
   "Bag ca. 40 minutter. Server med grøn salat."
  ],
  "source": "https://www.valdemarsro.dk/vegetar-lasagne/",
  "builtin": true
 },
 {
  "id": "groentsagswok-med-tofu",
  "name": "Grøntsagswok med tofu",
  "protein": "vegetar",
  "sides": [
   "nudler",
   "ris"
  ],
  "minutes": 30,
  "servings": 4,
  "ingredients": [
   "400 g fast tofu",
   "250 g risnudler eller ris",
   "1 broccoli",
   "1 rød peberfrugt",
   "150 g sukkerærter",
   "2 gulerødder",
   "2 fed hvidløg",
   "1 spsk revet ingefær",
   "4 spsk soja",
   "2 spsk sweet chili",
   "1 spsk maizena",
   "cashewnødder"
  ],
  "steps": [
   "Skær tofuen i tern, vend den i maizena og steg den sprød. Tag den af.",
   "Kog nudler eller ris.",
   "Lyntilsteg grøntsager, hvidløg og ingefær 3 til 4 minutter.",
   "Tilsæt soja, sweet chili og tofu og vend det hele.",
   "Server med nudler eller ris og ristede cashewnødder."
  ],
  "source": "https://opskrifter.coop.dk/opskrifter/en-portion-stegte-groentsager-og-tofu-med-nudler-3779",
  "builtin": true
 },
 {
  "id": "hakkeboef-med-bloede-loeg-og-kartofler",
  "name": "Hakkebøf med bløde løg og kartofler",
  "protein": "okse",
  "sides": [
   "kartofler"
  ],
  "minutes": 40,
  "servings": 4,
  "ingredients": [
   "600 g hakket oksekød",
   "3 løg",
   "30 g smør",
   "1 kg kartofler",
   "3 dl vand eller bouillon",
   "1 spsk maizena",
   "kulør",
   "syltede rødbeder",
   "salt og peber"
  ],
  "steps": [
   "Kog kartoflerne.",
   "Snit løgene og steg dem bløde og gyldne i smør ved lav varme ca. 15 minutter.",
   "Form kødet til 4 bøffer, krydr og steg dem 4 til 5 minutter på hver side.",
   "Kog panden af med vand eller bouillon, jævn med maizena og giv lidt kulør.",
   "Server bøfferne med løg, sovs, kartofler og rødbeder."
  ],
  "source": "https://www.valdemarsro.dk/hakkeboeffer-med-bloede-loeg/",
  "builtin": true
 },
 {
  "id": "helstegt-kylling-med-kartofler-og-agurkesalat",
  "name": "Helstegt kylling med kartofler og agurkesalat",
  "protein": "kylling",
  "sides": [
   "kartofler",
   "salat"
  ],
  "minutes": 90,
  "servings": 4,
  "ingredients": [
   "1 hel kylling, ca. 1,4 kg",
   "1 citron",
   "4 fed hvidløg",
   "frisk timian",
   "1 kg kartofler",
   "2 spsk olivenolie",
   "1 agurk",
   "1 dl eddike",
   "1 dl sukker",
   "salt og peber"
  ],
  "steps": [
   "Tænd ovnen på 200 grader.",
   "Gnid kyllingen med olie, salt og peber og fyld den med citron, hvidløg og timian.",
   "Skær kartoflerne i både og læg dem om kyllingen i et ovnfast fad med olie og salt.",
   "Steg i ca. 75 minutter, til kødsaften er klar ved låret.",
   "Snit agurken tyndt og vend den med eddike, sukker og 1 dl vand. Lad den trække, mens kyllingen steger."
  ],
  "source": "https://www.valdemarsro.dk/grydestegt-kylling-med-skysauce/",
  "builtin": true
 },
 {
  "id": "hjemmelavede-burgere",
  "name": "Hjemmelavede burgere",
  "protein": "okse",
  "sides": [
   "brod",
   "kartofler"
  ],
  "minutes": 45,
  "servings": 4,
  "ingredients": [
   "600 g hakket oksekød",
   "4 burgerboller",
   "4 skiver cheddar",
   "1 rødløg",
   "2 tomater",
   "1 hjertesalat",
   "agurkerelish eller pickles",
   "burgerdressing",
   "1 kg kartofler til ovnfritter",
   "olie og salt"
  ],
  "steps": [
   "Tænd ovnen på 220 grader. Skær kartoflerne i stave, vend med olie og salt og bag 30 til 35 minutter.",
   "Form kødet til 4 bøffer og krydr med salt og peber.",
   "Steg bøfferne 3 til 4 minutter på hver side og læg ost på til sidst.",
   "Rist bollerne let.",
   "Byg burgerne med salat, tomat, løg, pickles og dressing."
  ],
  "source": "https://www.valdemarsro.dk/hjemmelavede-burgere/",
  "builtin": true
 },
 {
  "id": "karbonader-med-aerter-og-guleroedder",
  "name": "Karbonader med ærter og gulerødder",
  "protein": "gris",
  "sides": [
   "kartofler"
  ],
  "minutes": 40,
  "servings": 4,
  "ingredients": [
   "4 karbonader af svinekød",
   "1 æg",
   "rasp",
   "50 g smør",
   "1 kg kartofler",
   "300 g ærter",
   "300 g gulerødder",
   "30 g smør til stuvning",
   "2 spsk hvedemel",
   "4 dl mælk",
   "salt og peber"
  ],
  "steps": [
   "Kog kartoflerne.",
   "Vend karbonaderne i sammenpisket æg og derefter i rasp med salt og peber.",
   "Steg dem i smør ca. 5 minutter på hver side.",
   "Kog ærter og gulerødder i tern møre.",
   "Lav en hvid sovs af smør, mel og mælk og vend grøntsagerne i."
  ],
  "source": "https://www.valdemarsro.dk/karbonader/",
  "builtin": true
 },
 {
  "id": "kartoffel-og-porresuppe",
  "name": "Kartoffel- og porresuppe",
  "protein": "vegetar",
  "sides": [
   "brod"
  ],
  "minutes": 40,
  "servings": 4,
  "ingredients": [
   "1 kg kartofler",
   "3 porrer",
   "1 løg",
   "30 g smør",
   "1,2 l grøntsagsbouillon",
   "1 dl madlavningsfløde",
   "frisk purløg",
   "godt brød",
   "salt og peber"
  ],
  "steps": [
   "Svits snittet porre og løg i smør uden at det tager farve.",
   "Tilsæt kartofler i tern og bouillon og kog 20 minutter.",
   "Blend suppen glat og tilsæt fløde.",
   "Smag til med salt og peber.",
   "Server med purløg og lunt brød."
  ],
  "source": "https://www.valdemarsro.dk/kartoffelsuppe/",
  "builtin": true
 },
 {
  "id": "kylling-i-karry",
  "name": "Kylling i karry",
  "protein": "kylling",
  "sides": [
   "ris"
  ],
  "minutes": 40,
  "servings": 4,
  "ingredients": [
   "600 g kyllingebryst eller -lår",
   "1 løg",
   "1 æble",
   "2 spsk karry",
   "2 spsk smør",
   "2 spsk hvedemel",
   "4 dl hønsebouillon",
   "1 dl madlavningsfløde",
   "salt og peber",
   "300 g ris"
  ],
  "steps": [
   "Kog risene efter anvisningen på pakken.",
   "Skær kyllingen i tern og brun den i halvdelen af smørret. Tag den af panden.",
   "Svits hakket løg og æbletern i resten af smørret, tilsæt karry og svits et minut mere.",
   "Drys mel over, rør bouillonen i lidt ad gangen og lad saucen simre 5 minutter.",
   "Kom kylling og fløde i og lad det simre 10 minutter, til kyllingen er gennemstegt. Smag til med salt og peber."
  ],
  "source": "https://www.valdemarsro.dk/kylling-karry/",
  "builtin": true
 },
 {
  "id": "kyllingefrikasse",
  "name": "Kyllingefrikassé",
  "protein": "kylling",
  "sides": [
   "ris"
  ],
  "minutes": 50,
  "servings": 4,
  "ingredients": [
   "600 g kyllingebryst",
   "3 gulerødder",
   "1 porre",
   "200 g asparges eller ærter",
   "40 g smør",
   "3 spsk hvedemel",
   "5 dl hønsebouillon",
   "1 dl piskefløde",
   "1 spsk citronsaft",
   "300 g ris"
  ],
  "steps": [
   "Kog kyllingen i bouillonen ca. 15 minutter. Tag den op og skær i stykker. Gem bouillonen.",
   "Kog risene.",
   "Kog gulerødder og porre møre i bouillonen de sidste 8 minutter, asparges eller ærter de sidste 2.",
   "Smelt smør, rør mel i og spæd med bouillonen lidt ad gangen. Tilsæt fløde.",
   "Kom kylling og grøntsager i saucen og smag til med citron, salt og peber."
  ],
  "source": "https://madensverden.dk/kyllingefrikasse-med-kogt-kylling/",
  "builtin": true
 },
 {
  "id": "kyllingespyd-med-bulgursalat-og-tzatziki",
  "name": "Kyllingespyd med bulgursalat og tzatziki",
  "protein": "kylling",
  "sides": [
   "bulgur",
   "salat"
  ],
  "minutes": 40,
  "servings": 4,
  "ingredients": [
   "600 g kyllingebryst",
   "2 spsk olivenolie",
   "1 citron",
   "1 tsk oregano",
   "250 g bulgur",
   "1 agurk",
   "2 tomater",
   "1 bundt persille",
   "3 dl græsk yoghurt",
   "1 fed hvidløg",
   "salt og peber"
  ],
  "steps": [
   "Skær kyllingen i tern og vend med olie, citronsaft, oregano, salt og peber. Sæt på spyd.",
   "Kog bulguren efter anvisningen og lad den køle lidt af.",
   "Vend bulgur med tern af tomat og halvdelen af agurken, hakket persille, olie og citron.",
   "Riv resten af agurken, pres vandet fra og rør den med yoghurt og hvidløg til tzatziki.",
   "Grill eller steg spyddene ca. 10 minutter, til de er gennemstegte."
  ],
  "source": "https://gourministeriet.dk/gyros-kyllingespyd-grillspyd-med-kylling-og-gyros/",
  "builtin": true
 },
 {
  "id": "kyllingewok-med-nudler",
  "name": "Kyllingewok med nudler",
  "protein": "kylling",
  "sides": [
   "nudler"
  ],
  "minutes": 25,
  "servings": 4,
  "ingredients": [
   "500 g kyllingebryst",
   "250 g ægnudler",
   "1 rød peberfrugt",
   "1 broccoli",
   "2 gulerødder",
   "2 fed hvidløg",
   "1 spsk revet ingefær",
   "4 spsk soja",
   "2 spsk østerssauce",
   "1 spsk sesamolie",
   "2 forårsløg"
  ],
  "steps": [
   "Kog nudlerne efter anvisningen og skyl dem i koldt vand.",
   "Skær kyllingen i strimler og steg den ved høj varme i en wok. Tag den af.",
   "Lyntilsteg grøntsager, hvidløg og ingefær 3 til 4 minutter.",
   "Kom kylling, nudler, soja, østerssauce og sesamolie i og vend det hele godt.",
   "Drys med forårsløg."
  ],
  "source": "https://www.valdemarsro.dk/wok-med-kylling/",
  "builtin": true
 },
 {
  "id": "laks-teriyaki-med-ris",
  "name": "Laks teriyaki med ris",
  "protein": "fisk",
  "sides": [
   "ris"
  ],
  "minutes": 30,
  "servings": 4,
  "ingredients": [
   "600 g laksefilet",
   "1 dl soja",
   "3 spsk mirin",
   "2 spsk honning",
   "1 spsk revet ingefær",
   "1 fed hvidløg",
   "300 g ris",
   "1 broccoli",
   "1 agurk",
   "sesamfrø",
   "forårsløg"
  ],
  "steps": [
   "Kog risene.",
   "Kog soja, mirin, honning, ingefær og hvidløg ind til en tyk sauce.",
   "Steg laksen 3 minutter på hver side og pensl med sauce til sidst.",
   "Kog broccolien og skær agurken i tynde skiver.",
   "Server laks over ris med grønt, sesam, forårsløg og ekstra sauce."
  ],
  "source": "https://www.valdemarsro.dk/teriyaki-laks-med-sesam-og-groent/",
  "builtin": true
 },
 {
  "id": "laksepasta-med-spinat-og-citron",
  "name": "Laksepasta med spinat og citron",
  "protein": "fisk",
  "sides": [
   "pasta"
  ],
  "minutes": 25,
  "servings": 4,
  "ingredients": [
   "400 g pasta, fx penne",
   "400 g laksefilet",
   "1 pose babyspinat",
   "2,5 dl madlavningsfløde",
   "1 citron",
   "1 fed hvidløg",
   "50 g parmesan",
   "salt og peber"
  ],
  "steps": [
   "Kog pastaen.",
   "Steg laksen i tern et par minutter og tag den af panden.",
   "Svits hvidløg, tilsæt fløde, revet citronskal og lidt citronsaft og kog op.",
   "Vend spinat i, til den falder sammen, og kom laks og pasta i.",
   "Smag til og top med parmesan."
  ],
  "source": "https://www.valdemarsro.dk/pasta-med-laks-og-spinat/",
  "builtin": true
 },
 {
  "id": "lasagne",
  "name": "Lasagne",
  "protein": "okse",
  "sides": [
   "pasta",
   "salat"
  ],
  "minutes": 90,
  "servings": 4,
  "ingredients": [
   "500 g hakket oksekød",
   "1 løg",
   "2 fed hvidløg",
   "2 dåser hakkede tomater",
   "2 spsk tomatpuré",
   "12 lasagneplader",
   "50 g smør",
   "4 spsk hvedemel",
   "7 dl mælk",
   "150 g revet ost",
   "muskatnød",
   "salt og peber"
  ],
  "steps": [
   "Brun kødet med løg og hvidløg. Tilsæt tomater og puré og lad saucen simre 20 minutter.",
   "Smelt smør, rør mel i og spæd med mælk under omrøring til en jævn bechamel. Smag til med muskat og salt.",
   "Tænd ovnen på 200 grader.",
   "Læg kødsovs, plader og bechamel lagvis i et fad og slut med bechamel og ost.",
   "Bag i ca. 40 minutter, til pladerne er møre og osten gylden. Server med en grøn salat."
  ],
  "source": "https://www.valdemarsro.dk/lasagne/",
  "builtin": true
 },
 {
  "id": "marokkansk-kyllingegryde-med-couscous",
  "name": "Marokkansk kyllingegryde med couscous",
  "protein": "kylling",
  "sides": [
   "couscous"
  ],
  "minutes": 45,
  "servings": 4,
  "ingredients": [
   "700 g kyllingelår uden ben",
   "1 løg",
   "2 gulerødder",
   "1 dåse kikærter",
   "1 dåse hakkede tomater",
   "2 tsk spidskommen",
   "1 tsk kanel",
   "1 tsk paprika",
   "8 abrikoser, tørrede",
   "3 dl hønsebouillon",
   "250 g couscous",
   "frisk koriander"
  ],
  "steps": [
   "Brun kyllingen i stykker i en gryde. Tag den op.",
   "Svits løg, gulerødder og krydderier i et par minutter.",
   "Tilsæt tomater, bouillon, kikærter, hakkede abrikoser og kylling. Lad det simre 25 minutter.",
   "Hæld kogende vand over couscousen efter anvisningen og lad den stå 5 minutter. Løsn med en gaffel.",
   "Server gryden over couscous med koriander."
  ],
  "source": "https://www.arla.dk/opskrifter/marokkansk-kyllingegryde/",
  "builtin": true
 },
 {
  "id": "medister-med-stuvet-hvidkaal",
  "name": "Medister med stuvet hvidkål",
  "protein": "gris",
  "sides": [
   "kartofler"
  ],
  "minutes": 45,
  "servings": 4,
  "ingredients": [
   "800 g medisterpølse",
   "1 kg kartofler",
   "1/2 hvidkål",
   "30 g smør",
   "3 spsk hvedemel",
   "5 dl mælk",
   "muskatnød",
   "sennep",
   "salt og peber"
  ],
  "steps": [
   "Kog kartoflerne.",
   "Steg medisteren ved middel varme ca. 20 minutter, til den er gennemstegt. Vend den jævnligt.",
   "Snit kålen og kog den mør i saltet vand ca. 8 minutter. Hæld vandet fra.",
   "Lav en hvid sovs af smør, mel og mælk og vend kålen i. Smag til med muskat og salt.",
   "Server med kartofler og sennep."
  ],
  "source": "https://www.valdemarsro.dk/stuvet-hvidkaal/",
  "builtin": true
 },
 {
  "id": "millionboef-med-kartoffelmos",
  "name": "Millionbøf med kartoffelmos",
  "protein": "okse",
  "sides": [
   "kartofler"
  ],
  "minutes": 40,
  "servings": 4,
  "ingredients": [
   "500 g hakket oksekød",
   "1 løg",
   "2 spsk hvedemel",
   "4 dl oksebouillon",
   "1 dl madlavningsfløde",
   "kulør",
   "1 kg kartofler",
   "2 dl mælk",
   "40 g smør",
   "muskatnød",
   "salt og peber"
  ],
  "steps": [
   "Kog kartoflerne møre.",
   "Brun kødet med hakket løg i en gryde, så det bliver godt krummet.",
   "Drys mel over, rør bouillonen i og lad det simre 15 minutter. Tilsæt fløde og lidt kulør.",
   "Mos kartoflerne med varm mælk og smør og smag til med muskat og salt.",
   "Server millionbøffen med mosen og evt. syltede agurker."
  ],
  "source": "https://www.valdemarsro.dk/millionboef/",
  "builtin": true
 },
 {
  "id": "moerbradgryde-med-champignon",
  "name": "Mørbradgryde med champignon",
  "protein": "gris",
  "sides": [
   "ris"
  ],
  "minutes": 40,
  "servings": 4,
  "ingredients": [
   "600 g svinemørbrad",
   "250 g champignon",
   "1 løg",
   "1 rød peberfrugt",
   "2 spsk tomatpuré",
   "1 tsk paprika",
   "2,5 dl madlavningsfløde",
   "1 dl bouillon",
   "300 g ris",
   "salt og peber"
  ],
  "steps": [
   "Kog risene.",
   "Skær mørbraden i medaljoner og brun dem i en gryde. Tag dem op.",
   "Svits løg, svampe og peberfrugt. Rør tomatpuré og paprika i.",
   "Tilsæt fløde og bouillon og læg kødet tilbage. Lad det simre 10 til 12 minutter.",
   "Smag til med salt og peber."
  ],
  "source": "https://www.arla.dk/opskrifter/morbradgryde/",
  "builtin": true
 },
 {
  "id": "oksegullasch",
  "name": "Oksegullasch",
  "protein": "okse",
  "sides": [
   "kartofler"
  ],
  "minutes": 120,
  "servings": 4,
  "ingredients": [
   "800 g grydeklar oksekød (tern)",
   "2 løg",
   "2 fed hvidløg",
   "1 rød peberfrugt",
   "2 spsk paprika",
   "2 spsk tomatpuré",
   "1 dåse hakkede tomater",
   "5 dl oksebouillon",
   "1 kg kartofler",
   "creme fraiche",
   "salt og peber"
  ],
  "steps": [
   "Brun kødet i portioner i en gryde.",
   "Tilsæt løg, hvidløg og peberfrugt og svits et par minutter. Rør paprika og tomatpuré i.",
   "Kom tomater og bouillon i og lad gryden simre under låg ca. 1,5 time, til kødet er mørt.",
   "Kog kartoflerne de sidste 20 minutter.",
   "Smag gryden til og server med kartofler og creme fraiche."
  ],
  "source": "https://www.valdemarsro.dk/gullash/",
  "builtin": true
 },
 {
  "id": "ovnbagt-laks-med-kartofler-og-groent",
  "name": "Ovnbagt laks med kartofler og grønt",
  "protein": "fisk",
  "sides": [
   "kartofler",
   "salat"
  ],
  "minutes": 40,
  "servings": 4,
  "ingredients": [
   "600 g laksefilet",
   "1 kg små kartofler",
   "250 g grønne bønner eller broccoli",
   "1 citron",
   "2 spsk olivenolie",
   "frisk dild",
   "2 dl creme fraiche 18 %",
   "salt og peber"
  ],
  "steps": [
   "Tænd ovnen på 200 grader. Halver kartoflerne, vend med olie og salt og bag 20 minutter.",
   "Læg laksen og grøntsagerne på pladen, krydr med salt, peber og citronskiver.",
   "Bag videre 12 til 15 minutter, til laksen netop er færdig.",
   "Rør creme fraiche med hakket dild, citronsaft og salt.",
   "Server laksen med kartofler, grønt og dildcreme."
  ],
  "source": "https://www.valdemarsro.dk/laks-i-fad-med-kartofler-og-groentsager/",
  "builtin": true
 },
 {
  "id": "pasta-carbonara",
  "name": "Pasta carbonara",
  "protein": "gris",
  "sides": [
   "pasta"
  ],
  "minutes": 25,
  "servings": 4,
  "ingredients": [
   "400 g spaghetti",
   "200 g bacon eller guanciale",
   "4 æggeblommer og 1 helt æg",
   "75 g parmesan eller pecorino",
   "friskkværnet peber",
   "salt"
  ],
  "steps": [
   "Kog spaghettien i godt saltet vand. Gem en kop kogevand.",
   "Steg bacon sprødt i tern.",
   "Pisk æg, blommer og revet ost sammen med rigeligt peber.",
   "Tag panden af varmen, vend den varme pasta i baconfedtet og hæld æggemassen over.",
   "Rør hurtigt rundt og spæd med kogevand, til saucen er cremet."
  ],
  "source": "https://www.valdemarsro.dk/carbonara_opskrift/",
  "builtin": true
 },
 {
  "id": "pasta-med-kylling-og-pesto",
  "name": "Pasta med kylling og pesto",
  "protein": "kylling",
  "sides": [
   "pasta"
  ],
  "minutes": 25,
  "servings": 4,
  "ingredients": [
   "400 g pasta",
   "500 g kyllingebryst",
   "1 glas grøn pesto",
   "250 g cherrytomater",
   "1 pose babyspinat",
   "50 g parmesan",
   "2 spsk pinjekerner",
   "salt og peber"
  ],
  "steps": [
   "Kog pastaen.",
   "Skær kyllingen i tern, krydr med salt og peber og steg den gennem.",
   "Halver tomaterne og vend dem med spinat på panden, til spinaten falder sammen.",
   "Vend den drænede pasta med pesto, kylling og grønt.",
   "Top med revet parmesan og ristede pinjekerner."
  ],
  "source": "https://madensverden.dk/kylling-med-pesto/",
  "builtin": true
 },
 {
  "id": "pasta-med-tomatsauce-og-mozzarella",
  "name": "Pasta med tomatsauce og mozzarella",
  "protein": "vegetar",
  "sides": [
   "pasta",
   "salat"
  ],
  "minutes": 25,
  "servings": 4,
  "ingredients": [
   "400 g pasta",
   "2 dåser hakkede tomater",
   "1 løg",
   "3 fed hvidløg",
   "2 spsk olivenolie",
   "1 tsk sukker",
   "1 bundt basilikum",
   "2 kugler mozzarella",
   "parmesan",
   "salt og peber"
  ],
  "steps": [
   "Svits løg og hvidløg i olie.",
   "Tilsæt tomater og sukker og lad saucen simre 15 minutter.",
   "Kog pastaen.",
   "Vend pasta, sauce og revet basilikum sammen.",
   "Top med mozzarella i stykker og parmesan."
  ],
  "source": "https://www.valdemarsro.dk/pasta-med-mozzarella-og-tomater/",
  "builtin": true
 },
 {
  "id": "pizza-med-skinke-og-champignon",
  "name": "Pizza med skinke og champignon",
  "protein": "gris",
  "sides": [
   "salat"
  ],
  "minutes": 60,
  "servings": 4,
  "ingredients": [
   "500 g hvedemel",
   "25 g gær",
   "3 dl lunkent vand",
   "2 spsk olivenolie",
   "1 tsk salt",
   "1 dåse hakkede tomater",
   "1 tsk oregano",
   "200 g kogt skinke",
   "200 g champignon",
   "250 g mozzarella",
   "grøn salat"
  ],
  "steps": [
   "Opløs gæren i vandet, tilsæt olie, salt og mel og ælt en blød dej. Lad den hæve 30 minutter.",
   "Tænd ovnen på 250 grader.",
   "Kog tomaterne ind med oregano og salt til en tyk sauce.",
   "Rul dejen ud på to plader, smør med tomatsauce og fordel skinke, svampe og mozzarella.",
   "Bag 10 til 12 minutter, til bunden er sprød. Server med salat."
  ],
  "source": "https://gourministeriet.dk/pizza-med-skinke-og-champignon/",
  "builtin": true
 },
 {
  "id": "pulled-pork-i-burgerboller-med-coleslaw",
  "name": "Pulled pork i burgerboller med coleslaw",
  "protein": "gris",
  "sides": [
   "brod",
   "salat"
  ],
  "minutes": 240,
  "servings": 4,
  "ingredients": [
   "1,5 kg svinebov uden ben",
   "2 spsk brun farin",
   "1 spsk paprika",
   "1 tsk spidskommen",
   "2 dl barbecuesauce",
   "8 burgerboller",
   "1/4 hvidkål",
   "2 gulerødder",
   "1 dl mayonnaise",
   "1 spsk æbleeddike",
   "salt og peber"
  ],
  "steps": [
   "Gnid kødet med farin, paprika, spidskommen, salt og peber.",
   "Læg det i en gryde med 2 dl vand og låg og bag i ovnen ved 150 grader ca. 3,5 time, til det kan trækkes fra hinanden.",
   "Træk kødet fra hinanden med to gafler og vend det med barbecuesauce.",
   "Snit kål og riv gulerødder og vend med mayonnaise, eddike og salt.",
   "Fyld bollerne med kød og coleslaw."
  ],
  "source": "https://www.valdemarsro.dk/pulled-pork/",
  "builtin": true
 },
 {
  "id": "risotto-med-svampe",
  "name": "Risotto med svampe",
  "protein": "vegetar",
  "sides": [
   "ris"
  ],
  "minutes": 40,
  "servings": 4,
  "ingredients": [
   "350 g risottoris",
   "400 g champignon eller blandede svampe",
   "1 løg",
   "2 fed hvidløg",
   "1 dl hvidvin",
   "1,2 l grøntsagsbouillon",
   "40 g smør",
   "75 g parmesan",
   "frisk timian",
   "salt og peber"
  ],
  "steps": [
   "Steg svampene gyldne og tag dem af panden.",
   "Svits løg og hvidløg, tilsæt risene og rist dem et minut. Hæld vinen ved.",
   "Tilsæt den varme bouillon en slev ad gangen under omrøring ca. 18 minutter.",
   "Vend svampe, smør og revet parmesan i.",
   "Smag til med timian, salt og peber."
  ],
  "source": "https://www.valdemarsro.dk/risotto-med-svampe/",
  "builtin": true
 },
 {
  "id": "spaghetti-bolognese",
  "name": "Spaghetti bolognese",
  "protein": "okse",
  "sides": [
   "pasta"
  ],
  "minutes": 50,
  "servings": 4,
  "ingredients": [
   "500 g hakket oksekød",
   "1 løg",
   "2 fed hvidløg",
   "2 gulerødder",
   "2 dåser hakkede tomater",
   "2 spsk tomatpuré",
   "1 dl rødvin eller bouillon",
   "1 tsk oregano",
   "400 g spaghetti",
   "parmesan",
   "salt og peber"
  ],
  "steps": [
   "Brun kødet i en gryde.",
   "Tilsæt hakket løg, hvidløg og revne gulerødder og svits et par minutter.",
   "Kom tomatpuré, tomater, vin og oregano i. Lad saucen simre mindst 30 minutter.",
   "Kog spaghettien.",
   "Smag saucen til med salt og peber og server med revet parmesan."
  ],
  "source": "https://www.valdemarsro.dk/spaghetti-bolognese/",
  "builtin": true
 },
 {
  "id": "stegt-flaesk-med-persillesovs",
  "name": "Stegt flæsk med persillesovs",
  "protein": "gris",
  "sides": [
   "kartofler"
  ],
  "minutes": 45,
  "servings": 4,
  "ingredients": [
   "800 g skiveskåret flæsk",
   "1 kg kartofler",
   "40 g smør",
   "3 spsk hvedemel",
   "6 dl mælk",
   "1 stort bundt persille",
   "salt og peber",
   "syltede rødbeder"
  ],
  "steps": [
   "Tænd ovnen på 200 grader. Læg flæsket på en bageplade med rist og bag 25 til 30 minutter, til det er sprødt. Vend halvvejs.",
   "Kog kartoflerne.",
   "Smelt smør, rør mel i og spæd med mælk under omrøring. Lad sovsen koge et par minutter.",
   "Rør masser af hakket persille i og smag til med salt og peber.",
   "Server flæsket med kartofler, persillesovs og rødbeder."
  ],
  "source": "https://www.valdemarsro.dk/stegt-flaesk-med-persillesauce/",
  "builtin": true
 },
 {
  "id": "stegt-roedspaette-med-persillesovs",
  "name": "Stegt rødspætte med persillesovs",
  "protein": "fisk",
  "sides": [
   "kartofler"
  ],
  "minutes": 35,
  "servings": 4,
  "ingredients": [
   "8 rødspættefileter",
   "1 æg",
   "rasp eller rugmel",
   "60 g smør",
   "1 kg kartofler",
   "1 citron",
   "persillesovs: 30 g smør, 2 spsk mel, 5 dl mælk, 1 bundt persille",
   "salt og peber"
  ],
  "steps": [
   "Kog kartoflerne.",
   "Vend fileterne i æg og derefter i rasp med salt og peber.",
   "Steg dem i smør 2 til 3 minutter på hver side, til de er gyldne.",
   "Lav persillesovs af smør, mel og mælk og rør hakket persille i.",
   "Server med kartofler, sovs og citronbåde."
  ],
  "source": "https://www.valdemarsro.dk/stegt-roedspaette/",
  "builtin": true
 },
 {
  "id": "svinekoteletter-i-fad",
  "name": "Svinekoteletter i fad",
  "protein": "gris",
  "sides": [
   "ris"
  ],
  "minutes": 50,
  "servings": 4,
  "ingredients": [
   "4 svinekoteletter",
   "1 løg",
   "200 g champignon",
   "1 rød peberfrugt",
   "2,5 dl madlavningsfløde",
   "2 spsk tomatpuré",
   "1 tsk paprika",
   "300 g ris",
   "salt og peber"
  ],
  "steps": [
   "Tænd ovnen på 200 grader.",
   "Brun koteletterne på panden og læg dem i et ovnfast fad.",
   "Svits løg, svampe og peberfrugt og fordel over kødet.",
   "Rør fløde, tomatpuré og paprika sammen og hæld over.",
   "Bag 25 minutter og server med ris."
  ],
  "source": "https://www.valdemarsro.dk/koteletter-i-fad/",
  "builtin": true
 },
 {
  "id": "tacos",
  "name": "Tacos",
  "protein": "okse",
  "sides": [
   "brod",
   "salat"
  ],
  "minutes": 30,
  "servings": 4,
  "ingredients": [
   "500 g hakket oksekød",
   "1 pose tacokrydderi",
   "12 tacoskaller eller 8 tortillas",
   "1 hjertesalat",
   "2 tomater",
   "1 agurk",
   "1 dåse majs",
   "1 glas salsa",
   "2 dl creme fraiche",
   "150 g revet ost"
  ],
  "steps": [
   "Brun kødet og tilsæt krydderi og vand efter anvisningen.",
   "Skær grøntsagerne ud.",
   "Varm skallerne i ovnen et par minutter.",
   "Sæt alt på bordet, så hver især kan bygge sine egne tacos."
  ],
  "source": "https://madensverden.dk/tacos-med-hakket-oksekoed-salat-og-tacosauce/",
  "builtin": true
 },
 {
  "id": "torsk-med-sennepssovs-og-aeg",
  "name": "Torsk med sennepssovs og æg",
  "protein": "fisk",
  "sides": [
   "kartofler"
  ],
  "minutes": 35,
  "servings": 4,
  "ingredients": [
   "700 g torskefilet",
   "1 kg kartofler",
   "4 æg",
   "30 g smør",
   "2 spsk hvedemel",
   "4 dl mælk",
   "2 spsk grov sennep",
   "1 spsk dijonsennep",
   "frisk persille",
   "salt og peber"
  ],
  "steps": [
   "Kog kartofler og hårdkogte æg.",
   "Damp eller pocher torsken i let saltet vand 6 til 8 minutter.",
   "Lav en jævning af smør, mel og mælk og rør begge slags sennep i.",
   "Hak æggene groft.",
   "Server torsken med sennepssovs, kartofler, æg og persille."
  ],
  "source": "https://www.valdemarsro.dk/torsk-med-sennepssauce/",
  "builtin": true
 },
 {
  "id": "tortillas-med-kylling",
  "name": "Tortillas med kylling",
  "protein": "kylling",
  "sides": [
   "brod",
   "salat"
  ],
  "minutes": 30,
  "servings": 4,
  "ingredients": [
   "600 g kyllingebryst",
   "1 pose tacokrydderi",
   "8 tortillas",
   "1 hjertesalat",
   "2 tomater",
   "1 agurk",
   "1 dåse majs",
   "2 dl creme fraiche",
   "150 g revet ost",
   "1 avocado"
  ],
  "steps": [
   "Skær kyllingen i strimler og steg den med tacokrydderi og en smule vand.",
   "Skær salat, tomater, agurk og avocado i mindre stykker.",
   "Varm tortillas på en tør pande eller i ovnen.",
   "Sæt det hele på bordet, så hver især kan fylde sin egen."
  ],
  "source": "https://www.arla.dk/opskrifter/tortillas-med-krydret-kylling-og-majssalat/",
  "builtin": true
 }
]$AFTENSMAD$::jsonb)
on conflict (id) do nothing;

insert into public.weeks (id, days)
select id, days from jsonb_populate_recordset(null::public.weeks, $AFTENSMAD$[
 {
  "id": "2026-W43",
  "days": {
   "d0": {
    "locked": false,
    "protein": "alle",
    "recipe": "kyllingefrikasse",
    "side": "alle",
    "skip": false
   },
   "d1": {
    "locked": false,
    "protein": "alle",
    "recipe": "lasagne",
    "side": "alle",
    "skip": false
   },
   "d2": {
    "locked": false,
    "protein": "alle",
    "recipe": "boller-i-karry",
    "side": "alle",
    "skip": false
   },
   "d3": {
    "locked": false,
    "protein": "alle",
    "recipe": "pasta-med-tomatsauce-og-mozzarella",
    "side": "alle",
    "skip": false
   },
   "d4": {
    "locked": false,
    "protein": "alle",
    "recipe": "svinekoteletter-i-fad",
    "side": "alle",
    "skip": false
   },
   "d5": {
    "locked": false,
    "protein": "alle",
    "recipe": "pasta-med-kylling-og-pesto",
    "side": "alle",
    "skip": false
   },
   "d6": {
    "locked": false,
    "protein": "alle",
    "recipe": "pizza-med-skinke-og-champignon",
    "side": "alle",
    "skip": false
   }
  }
 },
 {
  "id": "2026-W44",
  "days": {
   "d0": {
    "locked": false,
    "protein": "alle",
    "recipe": "stegt-roedspaette-med-persillesovs",
    "side": "kartofler",
    "skip": false
   },
   "d1": {
    "locked": false,
    "protein": "alle",
    "recipe": "spaghetti-bolognese",
    "side": "alle",
    "skip": false
   },
   "d2": {
    "locked": false,
    "protein": "gris",
    "recipe": "boller-i-karry",
    "side": "ris",
    "skip": false
   },
   "d3": {
    "locked": false,
    "protein": "alle",
    "recipe": "pulled-pork-i-burgerboller-med-coleslaw",
    "side": "alle",
    "skip": false
   },
   "d4": {
    "locked": false,
    "protein": "alle",
    "recipe": "hakkeboef-med-bloede-loeg-og-kartofler",
    "side": "alle",
    "skip": false
   },
   "d5": {
    "locked": false,
    "protein": "alle",
    "recipe": "pasta-med-kylling-og-pesto",
    "side": "alle",
    "skip": true
   },
   "d6": {
    "locked": false,
    "protein": "alle",
    "recipe": "torsk-med-sennepssovs-og-aeg",
    "side": "alle",
    "skip": false
   }
  }
 }
]$AFTENSMAD$::jsonb)
on conflict (id) do nothing;

insert into public.settings (id, data)
select id, data from jsonb_populate_recordset(null::public.settings, $AFTENSMAD$[
 {
  "id": "main",
  "data": {
   "ruleProtein": true
  }
 }
]$AFTENSMAD$::jsonb)
on conflict (id) do nothing;

select (select count(*) from public.recipes) as opskrifter, (select count(*) from public.weeks) as uger;

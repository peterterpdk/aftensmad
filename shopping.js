/* Indkøbsliste: lægger ugens ingredienser sammen og sorterer dem efter butiksafdeling.
   Ren logik uden DOM, så den kan testes for sig. */
"use strict";
(function (root) {
  const SECTIONS = ["Frugt og grønt", "Kød og fisk", "Køl og mejeri", "Brød", "Kolonial", "Krydderier", "Andet", "Basisvarer"];

  // Enheder: kanonisk navn, gruppe og omregningsfaktor til gruppens grundenhed.
  const UNITS = {
    kg: ["g", 1000], g: ["g", 1], gram: ["g", 1],
    l: ["dl", 10], liter: ["dl", 10], dl: ["dl", 1], cl: ["dl", 0.1], ml: ["dl", 0.01],
    spsk: ["spsk", 1], tsk: ["tsk", 1], knsp: ["knsp", 1],
    fed: ["fed", 1], "dåse": ["dåse", 1], "dåser": ["dåse", 1], bundt: ["bundt", 1], bdt: ["bundt", 1],
    pose: ["pose", 1], poser: ["pose", 1], stk: ["stk", 1], skive: ["skive", 1], skiver: ["skive", 1],
    glas: ["glas", 1], pakke: ["pakke", 1], pakker: ["pakke", 1], kugle: ["kugle", 1], kugler: ["kugle", 1],
    bakke: ["bakke", 1], bakker: ["bakke", 1], "håndfuld": ["håndfuld", 1], stilk: ["stilk", 1], stilke: ["stilk", 1],
  };
  const PLURAL = { "dåse": "dåser", pose: "poser", skive: "skiver", pakke: "pakker", kugle: "kugler", bakke: "bakker", stilk: "stilke" };
  const FRAC = { "½": 0.5, "¼": 0.25, "¾": 0.75, "⅓": 1 / 3, "⅔": 2 / 3 };

  const QTY = /^(\d+\s*\/\s*\d+|\d+(?:[.,]\d+)?\s*[½¼¾⅓⅔]?|[½¼¾⅓⅔])(?:\s*-\s*(\d+(?:[.,]\d+)?|\d+\s*\/\s*\d+))?\s*/;
  const UNIT_RE = new RegExp("^(" + Object.keys(UNITS).sort((a, b) => b.length - a.length).join("|") + ")\\.?(?=\\s|$)\\s*", "i");

  function num(t) {
    t = String(t).replace(/\s+/g, "");
    if (t in FRAC) return FRAC[t];
    const mixed = t.match(/^(\d+(?:[.,]\d+)?)([½¼¾⅓⅔])$/);
    if (mixed) return parseFloat(mixed[1].replace(",", ".")) + FRAC[mixed[2]];
    if (t.includes("/")) { const [a, b] = t.split("/").map(Number); return b ? a / b : 0; }
    return parseFloat(t.replace(",", "."));
  }

  // Basisvarer streges ud fra start, hvis alle ord i navnet er basisord.
  const BASIC = new Set(["salt", "peber", "vand", "olie", "olivenolie", "rapsolie", "solsikkeolie", "neutral", "groft", "groftsalt", "friskkværnet", "sort", "og", "til", "stegning", "friturestegning", "fritering", "friteringen", "evt", "lidt", "kogende", "lunkent", "koldt", "efter", "smag"]);
  function isBasic(name) {
    const words = name.toLowerCase().replace(/[^a-zæøåé\s-]/g, " ").split(/\s+/).filter(Boolean);
    return words.length > 0 && words.every((w) => BASIC.has(w)) && words.some((w) => /salt|peber|vand|olie/.test(w));
  }

  // Afdeling ud fra nøgleord. Rækkefølgen betyder noget: det første match vinder.
  const RULES = [
    ["Kolonial", /bouillon|fond\b|hakkede tomater|flåede tomater|tomatpur|kokosmælk|kidneybønner|sorte bønner|hvide bønner|kikærter|majs|linser|syltede|rødkål|tørrede|rosiner|oliven|kapers|pesto|salsa|remoulade|mayonnaise|ketchup|barbecue|sweet chili|soja|østers|mirin|eddike|sennep|honning|sirup|sukker|farin|hvedemel|\bmel\b|maizena|kulør|gær\b|bagepulver|rasp|pasta|spaghetti|penne|tagliatelle|lasagneplade|nudler|\bris\b|risottoris|basmati|bulgur|couscous|pinjekerner|cashew|nødder|mandler|sesam|tahin|tacoskal|tacosauce|falaf|abrikos|dressing|hvidvin|rødvin|\bvin\b|(?<![a-zæøå])øl(?![a-zæøå])|danskvand|worcestershire|trøffelolie|chokolade|kakao|tun på dåse|ansjos/],
    ["Krydderier", /karry|paprika|spidskommen|kanel|oregano|garam masala|gurkemeje|muskat|laurbær|krydderi|fennikelfrø|kardemomme|chiliflager|cayenne|stødt|tørret|nelliker|allehånde/],
    ["Kød og fisk", /kylling|okse|hakket|svin|\bgris|flæsk|bacon|skinke|pølse|medister|mørbrad|kotelet|karbonade|bøf|\bsteg\b|kalv|\blam|bov\b|guanciale|laks|torsk|\bsej\b|rødspætte|fisk|rejer|\btun\b|kuller|makrel|hellefisk|culotte|ribeye|tyksteg|entrecote|spareribs/],
    ["Køl og mejeri", /mælk|fløde|smør|\bost\b|parmesan|mozzarella|feta|halloumi|cheddar|pecorino|ricotta|mascarpone|yoghurt|skyr|creme fraiche|crème fraîche|(?<![a-zæøå])æg(?![a-zæøå])|æggeblomme|tofu|revet ost|hytteost|flødeost/],
    ["Brød", /brød|bolle|pita|tortilla|wraps|naan|baguette|croutoner/],
    ["Frugt og grønt", /løg|hvidløg|gulerod|gulerød|kartof|porre|squash|aubergine|peberfrugt|tomat|agurk|salat|spinat|broccoli|blomkål|champignon|svamp|citron|lime|æble|pære|avocado|ingefær|persille|dild|basilikum|koriander|mynte|timian|estragon|salvie|purløg|rosmarin|chili|kål|selleri|ærter|bønner|rødbede|sukkerærter|granatæble|banan|appelsin|bær|asparges|majroe|pastinak|græskar|radise|rucola|bladselleri|fennikel|krydderurter/],
  ];
  function sectionOf(name, unit) {
    const n = name.toLowerCase();
    for (const [sec, re] of RULES) if (re.test(n)) {
      // Friske urter i teskeer er tørrede krydderier.
      if (sec === "Frugt og grønt" && (unit === "tsk" || unit === "knsp") && /timian|oregano|chili|persille|dild|basilikum|rosmarin/.test(n)) return "Krydderier";
      return sec;
    }
    if (unit === "tsk" || unit === "knsp") return "Krydderier";
    return "Andet";
  }

  function cleanName(s) {
    let n = s.replace(/\(.*?\)/g, "").split(",")[0].replace(/^evt\.?\s+/i, "").replace(/\s+/g, " ").trim();
    // "hvedemel til sovs" og "brød til croutoner" er samme vare som "hvedemel" og "brød".
    if (!isBasic(n)) n = n.replace(/\s+til\s+.+$/i, "").trim();
    return n;
  }

  // En ingredienslinje kan rumme flere varer, fx "persillesovs: 30 g smør, 2 spsk mel, 5 dl mælk".
  function splitLine(line) {
    const s = String(line || "").trim();
    const m = s.match(/^[^:\d]{2,40}:\s*(.+)$/);
    if (m && /\d/.test(m[1])) return m[1].split(/,\s*(?=\d|[½¼¾])/).map((x) => x.trim()).filter(Boolean);
    return [s];
  }

  function parse(line) {
    let s = String(line || "").trim().replace(/^evt\.?\s+/i, "");
    let qty = null, unit = "", factor = 1;
    const q = s.match(QTY);
    if (q && q[0].trim()) {
      qty = num(q[2] != null ? q[2] : q[1]); // spænd som "3-4": brug det højeste
      s = s.slice(q[0].length);
    }
    const u = s.match(UNIT_RE);
    if (u) { const k = u[1].toLowerCase(); [unit, factor] = UNITS[k]; s = s.slice(u[0].length); }
    const name = cleanName(s);
    if (!name) return null;
    return { qty: qty == null ? null : qty * factor, unit, name };
  }

  function fmtNum(x) {
    const r = Math.round(x * 100) / 100;
    const fr = { 0.5: "½", 0.25: "¼", 0.75: "¾" };
    const whole = Math.floor(r), rest = Math.round((r - whole) * 100) / 100;
    if (rest in fr) return (whole ? whole : "") + fr[rest];
    return String(r).replace(".", ",");
  }
  function fmtQty(qty, unit) {
    if (qty == null) return "";
    if (unit === "g" && qty >= 1000) return fmtNum(qty / 1000) + " kg";
    if (unit === "dl" && qty >= 10) return fmtNum(qty / 10) + " l";
    if (unit === "dl" && qty < 0.5) return fmtNum(qty * 100) + " ml";
    if (!unit) return fmtNum(qty);
    return fmtNum(qty) + " " + (qty > 1 && PLURAL[unit] ? PLURAL[unit] : unit);
  }

  // days: [{label, recipe}] -> { sections: [{name, items:[{key, text, name, from:[labels], basic}]}] }
  function build(days) {
    const map = new Map();
    for (const d of days) {
      for (const raw of (d.recipe && d.recipe.ingredients) || []) {
        for (const part of splitLine(raw)) {
          const p = parse(part);
          if (!p) continue;
          const base = p.name.toLowerCase();
          const key = base + "|" + (p.qty == null ? "-" : p.unit || "stk");
          let it = map.get(key);
          if (!it) { const basic = isBasic(p.name); it = { key, name: p.name, unit: p.unit, qty: p.qty == null ? null : 0, noQty: p.qty == null, from: [], basic, section: basic ? "Basisvarer" : sectionOf(p.name, p.unit) }; map.set(key, it); }
          if (p.qty != null && it.qty != null) it.qty += p.qty;
          if (!it.from.includes(d.label)) it.from.push(d.label);
        }
      }
    }
    // Varer uden mængde slås sammen med samme vare med mængde.
    for (const [k, it] of map) {
      if (!it.noQty) continue;
      const twin = [...map.values()].find((o) => o !== it && !o.noQty && o.name.toLowerCase() === it.name.toLowerCase());
      if (twin) { for (const f of it.from) if (!twin.from.includes(f)) twin.from.push(f); map.delete(k); }
    }
    const items = [...map.values()].map((it) => ({ ...it, text: (fmtQty(it.qty, it.unit) + " " + it.name).trim() }));
    const sections = SECTIONS.map((name) => ({
      name,
      items: items.filter((i) => i.section === name).sort((a, b) => a.name.localeCompare(b.name, "da")),
    })).filter((s) => s.items.length);
    return { sections, count: items.length };
  }

  root.Shopping = { build, parse, isBasic, sectionOf, SECTIONS };
  if (typeof module !== "undefined") module.exports = root.Shopping;
})(typeof window !== "undefined" ? window : globalThis);

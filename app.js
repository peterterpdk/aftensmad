/* Planlæg ugens aftensmad: web-app på Supabase.
   Alle funktioner fra den tidligere side: ugeplan med trækning, filtre, lås, spring over,
   regler, kopiér plan, kartotek med søgning, vis/ret/slet, tilføj via link, tekst eller selv. */
"use strict";

const PROTEINS=[["kylling","Kylling"],["okse","Okse"],["gris","Gris"],["fisk","Fisk"],["vegetar","Vegetarisk"]];
const SIDES=[["kartofler","Kartofler"],["ris","Ris"],["pasta","Pasta"],["nudler","Nudler"],["bulgur","Bulgur"],["couscous","Couscous"],["salat","Salat"],["brod","Brød"]];
const PL=Object.fromEntries(PROTEINS), SL=Object.fromEntries(SIDES);
const DAYN=["Mandag","Tirsdag","Onsdag","Torsdag","Fredag","Lørdag","Søndag"];
const $=s=>document.querySelector(s);
const esc=s=>String(s??"").replace(/[&<>"']/g,c=>({"&":"&amp;","<":"&lt;",">":"&gt;",'"':"&quot;","'":"&#39;"}[c]));
const blankDay=()=>({recipe:null,protein:"alle",side:"alle",locked:false,skip:false});
const blankWeek=()=>{const d={};for(let i=0;i<7;i++)d["d"+i]=blankDay();return d};
const clone=o=>JSON.parse(JSON.stringify(o));

let sb=null, channel=null, started=false;
let recipes={}, recipesLoaded=false;
let week=blankWeek(), weekOffset=0, weekLoadToken=0;
let ruleProtein=true;
let shop={struck:{},extra:{},days:{}}; // indkøbsliste for den viste uge (fælles)

/* ---------- dates ---------- */
function mondayOf(off){const d=new Date();d.setHours(12,0,0,0);const wd=(d.getDay()+6)%7;d.setDate(d.getDate()-wd+off*7);return d}
function isoWeek(d){const t=new Date(Date.UTC(d.getFullYear(),d.getMonth(),d.getDate()));const n=t.getUTCDay()||7;t.setUTCDate(t.getUTCDate()+4-n);const y=t.getUTCFullYear();const w=Math.ceil(((t-Date.UTC(y,0,1))/864e5+1)/7);return {y,w}}
function weekKey(off){const {y,w}=isoWeek(mondayOf(off));return `${y}-W${String(w).padStart(2,"0")}`}
const dm=d=>d.toLocaleDateString("da-DK",{day:"numeric",month:"short"});
function host(u){try{return new URL(u).hostname.replace(/^www\./,"")}catch{return u}}

/* ---------- drawing ---------- */
function matches(r,day){return r && (day.protein==="alle"||r.protein===day.protein) && (day.side==="alle"||(r.sides||[]).includes(day.side))}
function pool(day){return Object.keys(recipes).filter(id=>matches(recipes[id],day))}
function drawFor(i,days){
  const day=days["d"+i];
  const used=new Set(Object.entries(days).filter(([k,v])=>k!=="d"+i&&!v.skip&&v.recipe).map(([,v])=>v.recipe));
  const neigh=[i-1,i+1].map(j=>days["d"+j]).filter(v=>v&&!v.skip&&v.recipe&&recipes[v.recipe]).map(v=>recipes[v.recipe].protein);
  const all=pool(day);
  const c=all.filter(id=>id!==day.recipe||all.length===1);
  const tiers=[
    c.filter(id=>!used.has(id)&&!(ruleProtein&&day.protein==="alle"&&neigh.includes(recipes[id].protein))),
    c.filter(id=>!used.has(id)),
    c
  ];
  const t=tiers.find(x=>x.length);
  return t?t[Math.floor(Math.random()*t.length)]:null;
}
function rollUnlocked(days){
  const next=clone(days);
  for(let i=0;i<7;i++){const d=next["d"+i];if(d.locked||d.skip)continue;d.recipe=null}
  for(let i=0;i<7;i++){const d=next["d"+i];if(d.locked||d.skip)continue;d.recipe=drawFor(i,next)}
  return next;
}

/* ---------- status ---------- */
function setStatus(msg,err){const s=$("#status");s.textContent=msg||"";s.className="status"+(err?" err":"")}
function writeErr(){setStatus("Ændringen blev ikke gemt. Tjek forbindelsen og prøv igen.",true)}

/* ---------- data: weeks ---------- */
function applyWeek(days){const w=blankWeek();for(const k in w)w[k]={...w[k],...((days||{})[k]||{})};week=w;shop={struck:{...((days||{}).shop_struck||{})},extra:{...((days||{}).shop_extra||{})},days:{...((days||{}).shop_days||{})}};renderDays();if($("#shopBody"))renderShop()}
async function loadWeek(){
  const key=weekKey(weekOffset), token=++weekLoadToken;
  week=blankWeek(); shop={struck:{},extra:{},days:{}}; renderWeekLabel(); renderDays();
  const {data,error}=await sb.from("weeks").select("days").eq("id",key).maybeSingle();
  if(token!==weekLoadToken) return;
  if(error){setStatus("Planen kunne ikke hentes. Træk ned for at prøve igen.",true);return}
  if(data){applyWeek(data.days);return}
  if(!recipesLoaded||!Object.keys(recipes).length) return;
  // Ny uge: træk alle dage. Vinder en anden telefon kapløbet, bruges deres udgave.
  const drawn=rollUnlocked(blankWeek());
  const ins=await sb.from("weeks").upsert({id:key,days:drawn},{onConflict:"id",ignoreDuplicates:true});
  if(ins.error){writeErr();return}
  const again=await sb.from("weeks").select("days").eq("id",key).maybeSingle();
  if(token===weekLoadToken&&again.data) applyWeek(again.data.days);
}
async function saveDays(patch){
  for(const k in patch){
    if(k==="shop_struck") shop.struck={...shop.struck,...patch[k]};
    else if(k==="shop_extra") shop.extra={...shop.extra,...patch[k]};
    else if(k==="shop_days") shop.days={...shop.days,...patch[k]};
    else week[k]={...week[k],...patch[k]};
  }
  renderDays(); if($("#shopBody")) renderShop();
  const key=weekKey(weekOffset);
  const {data,error}=await sb.rpc("patch_week",{p_id:key,p_patch:patch});
  if(error){writeErr();return}
  if(key===weekKey(weekOffset)&&data) applyWeek(data);
}

/* ---------- data: recipes & settings ---------- */
function rowToRecipe(r){return {name:r.name,protein:r.protein,sides:r.sides||[],minutes:r.minutes||0,servings:r.servings||4,ingredients:r.ingredients||[],steps:r.steps||[],source:r.source||"",builtin:!!r.builtin}}
async function loadRecipes(){
  const {data,error}=await sb.from("recipes").select("*").limit(5000);
  if(error){recipesLoaded=true;renderFile();setStatus("Kartoteket kunne ikke hentes.",true);return}
  const m={}; for(const r of data) m[r.id]=rowToRecipe(r); recipes=m; recipesLoaded=true;
  renderFile(); renderDays();
}
async function loadSettings(){
  const {data}=await sb.from("settings").select("data").eq("id","main").maybeSingle();
  if(data&&data.data&&typeof data.data.ruleProtein==="boolean"){ruleProtein=data.data.ruleProtein}
}
function subscribe(){
  if(channel) sb.removeChannel(channel);
  channel=sb.channel("aftensmad")
    .on("postgres_changes",{event:"*",schema:"public",table:"recipes"},p=>{
      if(p.eventType==="DELETE"){ if(p.old&&p.old.id) delete recipes[p.old.id]; }
      else if(p.new&&p.new.id) recipes[p.new.id]=rowToRecipe(p.new);
      renderFile(); renderDays();
    })
    .on("postgres_changes",{event:"*",schema:"public",table:"weeks"},p=>{
      if(p.new&&p.new.id===weekKey(weekOffset)&&p.new.days) applyWeek(p.new.days);
    })
    .on("postgres_changes",{event:"*",schema:"public",table:"settings"},p=>{
      if(p.new&&p.new.id==="main"&&p.new.data&&typeof p.new.data.ruleProtein==="boolean"){ruleProtein=p.new.data.ruleProtein}
    })
    .subscribe();
}
async function refreshAll(){await Promise.all([loadRecipes(),loadSettings()]);await loadWeek()}

/* ---------- render: planner ---------- */
function renderWeekLabel(){
  const m=mondayOf(weekOffset), s=new Date(m); s.setDate(s.getDate()+6);
  $("#weekLabel").innerHTML=`Uge ${isoWeek(m).w}<small>${dm(m)} til ${dm(s)}</small>`;
  $("#thisWeek").hidden=weekOffset===0;
}
function optList(pairs,cur){return `<option value="alle"${cur==="alle"?" selected":""}>Alle</option>`+pairs.map(([v,l])=>`<option value="${v}"${v===cur?" selected":""}>${l}</option>`).join("")}
function recipeOptions(day){
  const ids=pool(day);
  let h=`<option value="">${ids.length?"Vælg opskrift ("+ids.length+")":"Ingen opskrifter matcher"}</option>`;
  for(const [p,l] of PROTEINS){
    const g=ids.filter(id=>recipes[id].protein===p).sort((a,b)=>recipes[a].name.localeCompare(recipes[b].name,"da"));
    if(!g.length) continue;
    h+=`<optgroup label="${l}">`+g.map(id=>`<option value="${esc(id)}"${id===day.recipe?" selected":""}>${esc(recipes[id].name)}</option>`).join("")+`</optgroup>`;
  }
  return h;
}
let openDay=null; // hvilken dag der er foldet ud (kun på denne telefon)
const DAYS3=["Man","Tir","Ons","Tor","Fre","Lør","Søn"];
function renderDays(){
  const m=mondayOf(weekOffset), today=new Date().toDateString();
  $("#days").innerHTML=[0,1,2,3,4,5,6].map(i=>{
    const d=week["d"+i], dt=new Date(m); dt.setDate(dt.getDate()+i);
    const r=d.recipe?recipes[d.recipe]:null, open=openDay===i;
    let name, meta="";
    if(d.skip) name=`<span class="nm empty">Ingen aftensmad</span>`;
    else if(r){ name=`<span class="nm">${esc(r.name)}</span>`; meta=`<span class="meta"><span class="p"><i class="dot ${r.protein}"></i>${PL[r.protein]||""}</span><span>${(r.sides||[]).map(s=>SL[s]||s).join(", ")}</span>${r.minutes?`<span class="num">${r.minutes} min</span>`:""}</span>`; }
    else if(d.recipe&&!recipesLoaded) name=`<span class="nm empty">Henter …</span>`;
    else name=`<span class="nm empty">${recipesLoaded&&!pool(d).length?"Ingen opskrifter matcher":"Ikke valgt endnu"}</span>`;
    return `<article class="day${d.locked?" locked":""}${d.skip?" skipped":""}${open?" open":""}${dt.toDateString()===today?" today":""}" data-i="${i}">
      <button class="dsum" data-a="toggle" aria-expanded="${open}" aria-controls="dd${i}">
        <span class="dn"><b>${DAYS3[i]}</b><span class="num">${dm(dt)}</span></span>
        <span class="dmain">${name}${meta}</span>
        <span class="dend">${d.locked?`<span class="lockbadge">Låst</span>`:""}<svg class="chev" viewBox="0 0 16 16" width="16" height="16" aria-hidden="true"><path d="M4 6l4 4 4-4" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/></svg></span>
      </button>
      <div class="ddetail" id="dd${i}" ${open?"":"hidden"}>
        <div class="dtog">
          ${d.skip?"":`<button class="lockbtn" data-a="lock" aria-pressed="${d.locked}">${d.locked?"Låst":"Lås"}</button>`}
          <button class="ghost" data-a="skip">${d.skip?"Planlæg dag":"Spring over"}</button>
        </div>
        <div class="dctrl">
          <label class="sel p"><span aria-hidden="true">Protein</span><select data-a="protein" aria-label="Protein ${DAYN[i]}" ${d.locked?"disabled":""}>${optList(PROTEINS,d.protein)}</select></label>
          <label class="sel s"><span aria-hidden="true">Tilbehør</span><select data-a="side" aria-label="Tilbehør ${DAYN[i]}" ${d.locked?"disabled":""}>${optList(SIDES,d.side)}</select></label>
          <select class="rsel" data-a="recipe" aria-label="Opskrift ${DAYN[i]}" ${d.locked?"disabled":""}>${recipeOptions(d)}</select>
          <button data-a="draw" ${d.locked||!pool(d).length?"disabled":""}>Træk</button>
          <button data-a="show" ${r?"":"disabled"}>Vis opskrift</button>
        </div>
      </div>
    </article>`}).join("");
  $("#rollWeek").disabled=!recipesLoaded;
}
$("#days").addEventListener("click",e=>{
  const b=e.target.closest("button[data-a]"); if(!b) return;
  const i=+b.closest(".day").dataset.i, k="d"+i, d=week[k], a=b.dataset.a;
  if(a==="toggle"){ openDay=openDay===i?null:i; renderDays(); const el=document.querySelector(`.day[data-i="${i}"]`); if(openDay===i&&el&&el.getBoundingClientRect().bottom>innerHeight) el.scrollIntoView({block:"nearest",behavior:"smooth"}); return; }
  if(a==="show"){ if(d.recipe) openView(d.recipe); return; }
  if(a==="lock") saveDays({[k]:{locked:!d.locked}});
  if(a==="skip") saveDays({[k]:d.skip?{skip:false,recipe:drawFor(i,{...week,[k]:{...d,skip:false}})}:{skip:true,locked:false}});
  if(a==="draw"){ const el=b.closest(".day"); el.classList.add("flash"); setTimeout(()=>el.classList.remove("flash"),180); saveDays({[k]:{recipe:drawFor(i,week)}}); }
  if(a==="skip"&&!d.skip&&openDay===i) openDay=null;
  setStatus("");
});
$("#days").addEventListener("change",e=>{
  const s=e.target.closest("select[data-a]"); if(!s) return;
  const i=+s.closest(".day").dataset.i, k="d"+i, d=week[k], a=s.dataset.a;
  if(a==="recipe"){ saveDays({[k]:s.value?{recipe:s.value,locked:true}:{recipe:null}}); return; }
  const nd={...d,[a]:s.value}; const patch={[a]:s.value};
  if(!matches(recipes[d.recipe],nd)) patch.recipe=drawFor(i,{...week,[k]:nd});
  saveDays({[k]:patch});
});
$("#rollWeek").onclick=()=>{ const n=rollUnlocked(week); const p={}; for(const k in n) if(n[k].recipe!==week[k].recipe) p[k]={recipe:n[k].recipe}; if(Object.keys(p).length) saveDays(p); setStatus("Ulåste dage er trukket på ny."); };
$("#prevWeek").onclick=()=>{weekOffset--;openDay=null;loadWeek()};
$("#nextWeek").onclick=()=>{weekOffset++;openDay=null;loadWeek()};
$("#thisWeek").onclick=()=>{weekOffset=0;openDay=null;loadWeek()};
$("#copyPlan").onclick=async()=>{
  const m=mondayOf(weekOffset);
  const lines=[`Aftensmad uge ${isoWeek(m).w}`].concat([0,1,2,3,4,5,6].map(i=>{const d=week["d"+i],dt=new Date(m);dt.setDate(dt.getDate()+i);return `${DAYN[i]} ${dm(dt)}: ${d.skip?"Ingen aftensmad":(recipes[d.recipe]?.name||"Ikke valgt")}`}));
  const txt=lines.join("\n");
  try{await navigator.clipboard.writeText(txt);setStatus("Planen er kopieret.")}
  catch{openText("Kopiér plan",txt)}
};

/* ---------- indkøbsliste ---------- */
function shopData(){
  const inShop=i=>shop.days["d"+i]!==false;
  const days=[0,1,2,3,4,5,6].map(i=>{const d=week["d"+i];return {label:DAYS3[i],recipe:(inShop(i)&&!d.skip&&d.recipe)?recipes[d.recipe]:null}});
  const built=window.Shopping.build(days);
  const isStruck=(key,basic)=>key in shop.struck?!!shop.struck[key]:!!basic;
  const extras=Object.entries(shop.extra).filter(([,t])=>t).map(([id,text])=>({key:"x:"+id,id,text}));
  return {built,extras,isStruck,dayCount:days.filter(d=>d.recipe).length};
}
function shopLines(){
  const {built,extras,isStruck}=shopData(); const out=[];
  for(const s of built.sections) for(const it of s.items) if(!isStruck(it.key,it.basic)) out.push(it.text);
  for(const x of extras) if(!isStruck(x.key,false)) out.push(x.text);
  return out;
}
function renderShop(){
  const body=$("#shopBody"); if(!body) return;
  const {built,extras,isStruck,dayCount}=shopData();
  const md=mondayOf(weekOffset);
  $("#shopDays").innerHTML=[0,1,2,3,4,5,6].map(i=>{
    const d=week["d"+i], on=shop.days["d"+i]!==false, dt=new Date(md); dt.setDate(dt.getDate()+i);
    const none=d.skip||!d.recipe;
    return `<button class="sday${on?" on":""}" data-sday="${i}" aria-pressed="${on}" title="${esc(DAYN[i]+" "+dm(dt)+(d.skip?" (sprunget over)":""))}"${none?' data-none="1"':""}><span class="cb" aria-hidden="true"></span><span>${DAYS3[i]}</span></button>`;
  }).join("");
  const all=[...built.sections.flatMap(s=>s.items.map(it=>isStruck(it.key,it.basic))),...extras.map(x=>isStruck(x.key,false))];
  const struckN=all.filter(Boolean).length, activeN=all.length-struckN;
  $("#shopCount").textContent=all.length?`${activeN} at købe · ${struckN} streget ud`:"";
  if(!dayCount&&!extras.length){ body.innerHTML=`<div class="emptystate">${Object.values(shop.days).some(v=>v===false)?"Ingen af de valgte dage har en ret. Sæt flueben ved flere dage ovenfor.":"Der er ingen retter i ugen endnu. Træk eller vælg retter, så kommer ingredienserne her."}</div>`; return; }
  const row=(key,text,from,struck,removable)=>`<li class="srow"><button class="sitem${struck?" struck":""}" data-key="${esc(key)}" aria-pressed="${struck}"><span class="box" aria-hidden="true"></span><span class="st">${esc(text)}</span>${from?`<small>${esc(from)}</small>`:""}</button>${removable?`<button class="icon ghost xdel" data-del="${esc(removable)}" aria-label="Fjern ${esc(text)}">✕</button>`:""}</li>`;
  body.innerHTML=built.sections.map(s=>`<section class="ssec"><h3>${esc(s.name)}</h3><ul>${s.items.map(it=>row(it.key,it.text,it.from.join(", "),isStruck(it.key,it.basic),null)).join("")}</ul></section>`).join("")
    +(extras.length?`<section class="ssec"><h3>Egne varer</h3><ul>${extras.map(x=>row(x.key,x.text,"",isStruck(x.key,false),x.id)).join("")}</ul></section>`:"");
}
function openShop(){
  const m=mondayOf(weekOffset);
  openSheet(`<div class="sheethead"><div><span class="eyebrow">Uge ${isoWeek(m).w}</span><h2 id="sheetTitle">Indkøbsliste</h2><div class="meta" id="shopCount" style="margin-top:4px"></div></div>${closeBtn}</div>
    <div class="sdaywrap"><span class="eyebrow">Køb ind til</span><div class="sdays" id="shopDays" role="group" aria-label="Dage på indkøbslisten"></div></div>
    <p class="hint">Fjern fluebenet ved de dage, du ikke handler ind til nu. Tryk på en vare for at strege den ud, fx hvis I har den hjemme. Alt deles med familien. Basisvarer er streget ud fra start.</p>
    <div id="shopBody" class="shopbody"></div>
    <form class="linkrow" id="extraForm" novalidate><input type="text" id="extraInput" placeholder="Tilføj egen vare, fx mælk" aria-label="Tilføj egen vare" autocomplete="off"><button id="extraAdd">Tilføj</button></form>
    <div class="status" id="shopStatus" role="status"></div>
    <div id="copyFallback"></div>
    <div class="sheetfoot"><button class="ghost" data-close>Luk</button><button class="primary" id="shopCopy">Kopiér indkøbsliste</button></div>`);
  renderShop();
  $("#shopDays").addEventListener("click",e=>{
    const b=e.target.closest("[data-sday]"); if(!b) return;
    const k="d"+b.dataset.sday, on=shop.days[k]!==false;
    saveDays({shop_days:{[k]:!on}});
  });
  $("#shopBody").addEventListener("click",e=>{
    const del=e.target.closest("[data-del]");
    if(del){ const id=del.dataset.del; saveDays({shop_extra:{[id]:null},shop_struck:{["x:"+id]:false}}); return; }
    const b=e.target.closest(".sitem"); if(!b) return;
    const key=b.dataset.key, struck=b.getAttribute("aria-pressed")==="true";
    saveDays({shop_struck:{[key]:!struck}});
  });
  $("#extraForm").addEventListener("submit",e=>{
    e.preventDefault();
    const t=$("#extraInput").value.trim(); if(!t) return;
    const id=Date.now().toString(36)+Math.random().toString(36).slice(2,5);
    $("#extraInput").value=""; saveDays({shop_extra:{[id]:t.slice(0,120)}});
  });
  $("#shopCopy").onclick=async()=>{
    const lines=shopLines(), st=$("#shopStatus");
    if(!lines.length){ st.className="status err"; st.textContent="Der er ingen aktive varer at kopiere."; return; }
    const txt=lines.join("\n");
    try{ await navigator.clipboard.writeText(txt); st.className="status"; st.textContent=`${lines.length} varer er kopieret. Indsæt dem i en besked eller en note.`; $("#copyFallback").innerHTML=""; }
    catch{ st.className="status"; st.textContent="Markér teksten herunder og kopiér den."; $("#copyFallback").innerHTML=`<textarea rows="8" readonly>${esc(txt)}</textarea>`; const t=$("#copyFallback textarea"); t.focus(); t.select(); }
  };
}
$("#shopBtn").onclick=()=>openShop();

/* ---------- render: file ---------- */
$("#fileProtein").innerHTML=`<option value="alle">Alle proteiner</option>`+PROTEINS.map(([v,l])=>`<option value="${v}">${l}</option>`).join("");
function renderFile(){
  const q=$("#search").value.trim().toLowerCase(), pf=$("#fileProtein").value;
  const ids=Object.keys(recipes).filter(id=>{const r=recipes[id];return (pf==="alle"||r.protein===pf)&&(!q||r.name.toLowerCase().includes(q)||(r.ingredients||[]).some(x=>String(x).toLowerCase().includes(q)))});
  $("#fileLede").textContent=recipesLoaded?`${Object.keys(recipes).length} opskrifter. De retter danskerne oftest laver til aftensmad, plus jeres egne. Tryk på en ret for at se eller rette den.`:"Henter kartoteket …";
  if(!recipesLoaded){$("#fileList").innerHTML="";return}
  if(!Object.keys(recipes).length){$("#fileList").innerHTML=`<div class="emptystate">Kartoteket er tomt. Tryk på <b>Tilføj opskrift</b> og indsæt den første.</div>`;return}
  if(!ids.length){$("#fileList").innerHTML=`<div class="emptystate">Ingen opskrifter matcher søgningen.</div>`;return}
  $("#fileList").innerHTML=`<div style="display:flex;flex-direction:column;gap:18px">`+PROTEINS.map(([p,l])=>{
    const g=ids.filter(id=>recipes[id].protein===p).sort((a,b)=>recipes[a].name.localeCompare(recipes[b].name,"da"));
    if(!g.length) return "";
    return `<div class="group"><h3><i class="dot ${p}"></i>${l} <span class="num" style="font-weight:500">${g.length}</span></h3><div class="rlist">`+
      g.map(id=>{const r=recipes[id];return `<button class="ritem" data-id="${esc(id)}"><span>${esc(r.name)}</span><small>${(r.sides||[]).map(s=>SL[s]||s).join(", ")}${r.minutes?" · "+r.minutes+" min":""}${r.source?' · <span class="lk">link</span>':""}</small></button>`}).join("")+`</div></div>`;
  }).join("")+`</div>`;
}
$("#search").oninput=renderFile; $("#fileProtein").onchange=renderFile;
$("#fileList").addEventListener("click",e=>{const b=e.target.closest(".ritem");if(b)openView(b.dataset.id)});
$("#addRecipe").onclick=()=>openPaste();

/* ---------- sheet ---------- */
let lastFocus=null;
function openSheet(html){lastFocus=document.activeElement;$("#sheet").innerHTML=html;$("#overlay").hidden=false;document.body.style.overflow="hidden";$("#overlay").scrollTop=0}
function closeSheet(){releaseWake();$("#overlay").hidden=true;document.body.style.overflow="";lastFocus&&lastFocus.focus&&lastFocus.focus()}
$("#overlay").addEventListener("click",e=>{if(e.target.id==="overlay")closeSheet()});
document.addEventListener("keydown",e=>{if(e.key==="Escape"&&!$("#overlay").hidden)closeSheet()});
const closeBtn=`<button class="icon ghost" data-close aria-label="Luk">✕</button>`;
$("#sheet").addEventListener("click",e=>{if(e.target.closest("[data-close]"))closeSheet()});

function openText(title,txt){
  openSheet(`<div class="sheethead"><h2 id="sheetTitle">${esc(title)}</h2>${closeBtn}</div><p class="hint">Markér teksten og kopiér den.</p><textarea rows="9" readonly>${esc(txt)}</textarea>`);
  const t=$("#sheet textarea"); t.focus(); t.select();
}
/* ---------- "Jeg er i køkkenet": hold skærmen tændt ---------- */
const canWake="wakeLock" in navigator;
let kitchenOn=false, wakeLock=null;
async function acquireWake(){
  if(!canWake||wakeLock) return !!wakeLock;
  try{ wakeLock=await navigator.wakeLock.request("screen"); wakeLock.addEventListener("release",()=>{wakeLock=null}); return true; }
  catch{ wakeLock=null; return false; }
}
async function releaseWake(){ const w=wakeLock; wakeLock=null; if(w){ try{ await w.release(); }catch{} } }
function kitchenOpen(){ return !$("#overlay").hidden && !!$("#kitchenToggle"); }
document.addEventListener("visibilitychange",()=>{ if(document.visibilityState==="visible"&&kitchenOn&&kitchenOpen()) acquireWake(); });

function openView(id){
  const r=recipes[id]; if(!r) return;
  openSheet(`<div class="sheethead"><div><span class="eyebrow" style="display:inline-flex;gap:6px;align-items:center"><i class="dot ${r.protein}"></i>${PL[r.protein]||""}</span><h2 id="sheetTitle">${esc(r.name)}</h2>
    <div class="meta" style="margin-top:6px"><span>${(r.sides||[]).map(s=>SL[s]||s).join(", ")}</span>${r.minutes?`<span class="num">${r.minutes} min</span>`:""}${r.servings?`<span class="num">${r.servings} personer</span>`:""}</div>
    ${r.source&&/^https?:\/\//i.test(r.source)?`<a class="srclink" href="${esc(r.source)}" target="_blank" rel="noopener">${r.builtin?"Se en tilsvarende opskrift":"Se den originale opskrift"} på ${esc(host(r.source))} ↗</a>`:""}</div>${closeBtn}</div>
    ${canWake?`<label class="kitchen" for="kitchenToggle"><input type="checkbox" id="kitchenToggle" role="switch" ${kitchenOn?"checked":""}><span class="sw" aria-hidden="true"></span><span class="kt"><b>Jeg er i køkkenet</b><small id="kitchenHint">Skærmen slukker ikke, mens opskriften er åben</small></span></label>`:""}
    <div class="cols">
      <div><h3>Ingredienser</h3><ul>${(r.ingredients||[]).map(x=>`<li>${esc(x)}</li>`).join("")||"<li>Ingen ingredienser angivet</li>"}</ul></div>
      <div><h3>Fremgangsmåde</h3><ol>${(r.steps||[]).map(x=>`<li>${esc(x)}</li>`).join("")||"<li>Ingen fremgangsmåde angivet</li>"}</ol></div>
    </div>
    <div class="sheetfoot"><button id="editBtn">Ret opskrift</button><button class="primary" data-close>Luk</button></div>`);
  $("#editBtn").onclick=()=>openEdit(id,r);
  const kt=$("#kitchenToggle");
  if(kt){
    if(kitchenOn) acquireWake();
    kt.onchange=async()=>{
      kitchenOn=kt.checked;
      if(kitchenOn){
        const ok=await acquireWake();
        if(!ok){ kitchenOn=false; kt.checked=false; $("#kitchenHint").textContent="Telefonen tillod det ikke. Det kræver iOS 18.4 eller nyere."; }
        else $("#kitchenHint").textContent="Skærmen slukker ikke, mens opskriften er åben";
      } else releaseWake();
    };
  }
}
async function callFormat(payload){
  const {data:{session}}=await sb.auth.getSession();
  if(!session) throw new Error("Log ind igen for at hente opskrifter.");
  const r=await fetch("/api/format",{method:"POST",headers:{"content-type":"application/json",Authorization:"Bearer "+session.access_token},body:JSON.stringify(payload)});
  const j=await r.json().catch(()=>({}));
  if(!r.ok||!j.recipe) throw new Error(j.error||"Opskriften kunne ikke hentes. Prøv igen.");
  return j.recipe;
}
function openPaste(){
  openSheet(`<div class="sheethead"><h2 id="sheetTitle">Tilføj opskrift</h2>${closeBtn}</div>
    <form class="f" id="searchForm" novalidate><label for="searchQ">Søg efter en ret</label>
      <div class="linkrow"><input type="search" id="searchQ" placeholder="Fx pasta kødsovs" autocomplete="off" enterkeyhint="search"><button class="primary" id="searchBtn">Find forslag</button></div></form>
    <div class="status" id="searchStatus" role="status"></div>
    <ul class="sres" id="searchRes"></ul>
    <div class="or">eller indsæt et link</div>
    <label class="f">Link til en opskrift på nettet
      <div class="linkrow"><input type="url" id="pasteUrl" placeholder="https://" autocomplete="off"><button id="linkBtn">Hent opskrift</button></div></label>
    <p class="hint">Claude henter opskriften og udfylder den, så du kan rette den eller blot godkende den.</p>
    <div class="status" id="linkStatus" role="status"></div>
    <div class="or">eller indsæt selve teksten</div>
    <label class="f">Opskriftstekst<textarea id="pasteTxt" rows="7" placeholder="Indsæt opskriften i et hvilket som helst format"></textarea></label>
    <div class="status" id="pasteStatus" role="status"></div>
    <div class="sheetfoot"><button class="ghost" id="manualBtn">Udfyld selv</button><button id="fmtBtn">Formatér tekst</button></div>`);
  $("#searchForm").addEventListener("submit",async e=>{
    e.preventDefault();
    const q=$("#searchQ").value.trim(), st=$("#searchStatus"), btn=$("#searchBtn"), list=$("#searchRes");
    if(q.length<2){st.className="status err";st.textContent="Skriv hvad du har lyst til, fx pasta kødsovs.";return}
    btn.disabled=true; btn.textContent="Søger …"; list.innerHTML=""; st.className="status"; st.textContent="Claude søger efter opskrifter. Det tager typisk 10 til 30 sekunder.";
    try{
      const {data:{session}}=await sb.auth.getSession();
      if(!session) throw new Error("Log ind igen for at søge.");
      const r=await fetch("/api/search",{method:"POST",headers:{"content-type":"application/json",Authorization:"Bearer "+session.access_token},body:JSON.stringify({query:q})});
      const j=await r.json().catch(()=>({}));
      if(!r.ok||!Array.isArray(j.results)) throw new Error(j.error||"Søgningen mislykkedes. Prøv igen.");
      if(!j.results.length) throw new Error("Ingen forslag fundet. Prøv med andre ord.");
      const known=new Set(Object.values(recipes).map(x=>(x.source||"").replace(/\/$/,"")));
      st.textContent=`${j.results.length} forslag til "${q}". Tryk Tilføj for at hente opskriften ind.`;
      list.innerHTML=j.results.map((x,i)=>`<li class="sr">
        <div class="srt"><b>${esc(x.title||x.site)}</b><small>${esc(x.site)}${x.note?" · "+esc(x.note):""}</small></div>
        <div class="sra"><a class="srlink" href="${esc(x.url)}" target="_blank" rel="noopener">Se ↗</a>
        ${known.has(String(x.url).replace(/\/$/,""))?`<span class="hint">Findes allerede</span>`:`<button class="primary" data-add="${i}">Tilføj</button>`}</div></li>`).join("");
      list.onclick=async ev=>{
        const b=ev.target.closest("[data-add]"); if(!b) return;
        const x=j.results[+b.dataset.add];
        list.querySelectorAll("[data-add]").forEach(k=>k.disabled=true); b.textContent="Henter …";
        st.className="status"; st.textContent="Claude henter opskriften. Det tager typisk 5 til 30 sekunder.";
        try{ const rec=await callFormat({url:x.url}); openEdit(null,rec,"link"); }
        catch(err){ list.querySelectorAll("[data-add]").forEach(k=>k.disabled=false); b.textContent="Tilføj"; st.className="status err"; st.textContent=err.message; }
      };
    }catch(err){ st.className="status err"; st.textContent=err.message; }
    finally{ btn.disabled=false; btn.textContent="Find forslag"; }
  });
  $("#manualBtn").onclick=()=>openEdit(null,{name:"",protein:"kylling",sides:[],minutes:30,servings:4,ingredients:[],steps:[],source:$("#pasteUrl").value.trim()});
  $("#linkBtn").onclick=async()=>{
    const url=$("#pasteUrl").value.trim(), st=$("#linkStatus"), btn=$("#linkBtn");
    if(!/^https?:\/\/\S+\.\S+/i.test(url)){st.className="status err";st.textContent="Indsæt et helt link, der starter med https://";return}
    btn.disabled=true; btn.textContent="Henter …"; st.className="status"; st.textContent="Claude læser siden. Det tager typisk 5 til 30 sekunder.";
    try{ const rec=await callFormat({url}); openEdit(null,rec,"link"); }
    catch(e){ btn.disabled=false; btn.textContent="Hent opskrift"; st.className="status err"; st.textContent=e.message; }
  };
  $("#fmtBtn").onclick=async()=>{
    const txt=$("#pasteTxt").value.trim(), st=$("#pasteStatus"), btn=$("#fmtBtn");
    if(!txt){st.className="status err";st.textContent="Indsæt en opskrift først.";return}
    btn.disabled=true; btn.textContent="Formaterer …"; st.className="status"; st.textContent="Claude læser opskriften.";
    try{ const rec=await callFormat({text:txt,source:$("#pasteUrl").value.trim()}); openEdit(null,rec,"text"); }
    catch(e){ btn.disabled=false; btn.textContent="Formatér tekst"; st.className="status err"; st.textContent=e.message; }
  };
}
function slugify(name){return (name.toLowerCase().replace(/æ/g,"ae").replace(/ø/g,"oe").replace(/å/g,"aa").replace(/[^a-z0-9]+/g,"-").replace(/^-|-$/g,"").slice(0,50)||"opskrift")+"-"+Math.random().toString(36).slice(2,6)}
function openEdit(id,r,via){
  const title=id?"Ret opskrift":via==="link"?"Gennemse og godkend":via==="text"?"Tjek og gem opskriften":"Ny opskrift";
  openSheet(`<div class="sheethead"><h2 id="sheetTitle">${title}</h2>${closeBtn}</div>
    ${via?`<p class="hint">Claude har ${via==="link"?"hentet":"formateret"} opskriften. Ret det, der ikke passer, eller godkend den som den er.</p>`:""}
    <form id="editForm" class="formgrid" novalidate>
      <label class="f wide">Navn<input type="text" id="eName" required value="${esc(r.name)}"></label>
      <label class="f">Protein<select id="eProtein">${PROTEINS.map(([v,l])=>`<option value="${v}"${v===r.protein?" selected":""}>${l}</option>`).join("")}</select></label>
      <label class="f">Tid (min)<input type="number" id="eMin" min="0" step="5" inputmode="numeric" value="${esc(r.minutes||"")}"></label>
      <label class="f">Personer<input type="number" id="eServ" min="1" inputmode="numeric" value="${esc(r.servings||4)}"></label>
      <label class="f">Kilde<input type="url" id="eSrc" placeholder="https://" value="${esc(r.source||"")}"></label>
      <div class="f wide">Tilbehør<div class="sides">${SIDES.map(([v,l])=>`<label><input type="checkbox" name="eSide" value="${v}"${(r.sides||[]).includes(v)?" checked":""}> ${l}</label>`).join("")}</div></div>
      <label class="f half">Ingredienser, én pr. linje<textarea id="eIng" rows="10">${esc((r.ingredients||[]).join("\n"))}</textarea></label>
      <label class="f half">Fremgangsmåde, ét trin pr. linje<textarea id="eSteps" rows="10">${esc((r.steps||[]).join("\n"))}</textarea></label>
    </form>
    <div class="status" id="editStatus" role="status"></div>
    <div class="sheetfoot">${id?`<button class="danger ghost" id="delBtn" style="margin-right:auto">Slet opskrift</button>`:""}<button class="ghost" data-close>Annullér</button><button class="primary" id="saveBtn">${via==="link"?"Godkend og gem":"Gem opskrift"}</button></div>`);
  $("#editForm").addEventListener("submit",ev=>ev.preventDefault());
  $("#saveBtn").onclick=async()=>{
    const name=$("#eName").value.trim(), st=$("#editStatus");
    const sides=[...document.querySelectorAll("input[name=eSide]:checked")].map(x=>x.value);
    if(!name){st.className="status err";st.textContent="Giv opskriften et navn.";$("#eName").focus();return}
    if(!sides.length){st.className="status err";st.textContent="Vælg mindst ét tilbehør, så retten kan findes i filtrene.";return}
    const data={name,protein:$("#eProtein").value,sides,minutes:parseInt($("#eMin").value)||0,servings:parseInt($("#eServ").value)||4,
      ingredients:$("#eIng").value.split("\n").map(s=>s.trim()).filter(Boolean),steps:$("#eSteps").value.split("\n").map(s=>s.trim()).filter(Boolean),
      source:$("#eSrc").value.trim(),builtin:id?!!(recipes[id]&&recipes[id].builtin):false};
    const rid=id||slugify(name);
    $("#saveBtn").disabled=true;
    const {error}=await sb.from("recipes").upsert({id:rid,...data,updated_at:new Date().toISOString()});
    if(error){$("#saveBtn").disabled=false;st.className="status err";st.textContent="Opskriften blev ikke gemt. Prøv igen.";return}
    recipes[rid]=data; renderFile(); renderDays(); openView(rid);
  };
  const del=$("#delBtn");
  if(del) del.onclick=async()=>{
    if(del.dataset.armed!=="1"){del.dataset.armed="1";del.textContent="Tryk igen for at slette";return}
    const {error}=await sb.from("recipes").delete().eq("id",id);
    if(error){$("#editStatus").className="status err";$("#editStatus").textContent="Opskriften blev ikke slettet.";return}
    delete recipes[id]; closeSheet(); renderFile(); renderDays();
  };
}

/* ---------- login & boot ---------- */
function show(view){ $("#bootView").hidden=view!=="boot"; $("#loginView").hidden=view!=="login"; $("#appView").hidden=view!=="app"; $("#logoutBtn").hidden=view!=="app"; }
async function startApp(){
  show("app");
  if(started) return; started=true;
  renderWeekLabel(); renderDays(); renderFile();
  subscribe();
  await refreshAll();
}
$("#loginForm").addEventListener("submit",async e=>{
  e.preventDefault();
  const email=$("#loginEmail").value.trim(), password=$("#loginPass").value, st=$("#loginStatus"), btn=$("#loginBtn");
  if(!email||!password){st.className="status err";st.textContent="Skriv både mail og adgangskode.";return}
  btn.disabled=true; st.className="status"; st.textContent="Logger ind …";
  const {error}=await sb.auth.signInWithPassword({email,password});
  btn.disabled=false;
  if(error){
    const m=String(error.message||"");
    st.className="status err";
    st.textContent=/invalid login credentials/i.test(m)?"Forkert mail eller adgangskode."
      :/email not confirmed/i.test(m)?"Brugeren er ikke bekræftet. Sæt flueben i Auto Confirm User, når brugeren oprettes i Supabase."
      :/api key|apikey|jwt|unauthori[sz]ed|no api key/i.test(m)?"Appens nøgle til Supabase virker ikke ("+m+"). Tjek SUPABASE_ANON_KEY i Vercel."
      :"Login mislykkedes: "+(m||"ukendt fejl")+".";
    return;
  }
  st.textContent=""; startApp();
});
$("#logoutBtn").onclick=async()=>{ await sb.auth.signOut(); location.reload(); };
document.addEventListener("visibilitychange",()=>{ if(document.visibilityState==="visible"&&started){ subscribe(); refreshAll(); } });

(async()=>{
  const bs=$("#bootStatus");
  try{
    const r=await fetch("/api/config",{cache:"no-store"}); const cfg=await r.json();
    if(!r.ok) throw new Error(cfg.error||"Opsætningen mangler.");
    sb=window.supabase.createClient(cfg.supabaseUrl,cfg.supabaseAnonKey,{auth:{persistSession:true,autoRefreshToken:true,storageKey:"aftensmad-auth"}});
  }catch(e){ bs.className="status err"; bs.textContent="Appen kunne ikke starte: "+(e.message||e); return; }
  sb.auth.onAuthStateChange((ev)=>{ if(ev==="SIGNED_OUT"){ started=false; show("login"); } });
  const {data:{session}}=await sb.auth.getSession();
  if(session) startApp(); else show("login");
})();

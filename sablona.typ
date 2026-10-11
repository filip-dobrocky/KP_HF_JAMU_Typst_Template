// Template for a JAMU HF thesis (KP/DP), based on Sablona_ke_KP__DP_rev_1_10_2026.docx.
// You normally don't edit this file. Fill in your data in prace.typ.
//
// Typst basics used here:
//   #let name = value          defines a variable (or a function, if it has parameters)
//   [ ... ]                    "content": markup, like a mini document
//   "..."                      a plain string
//   (a: 1, b: 2)               a dictionary; (1, 2, 3) is an array
//   set rule                   changes the defaults of an element: set text(size: 12pt)
//   show rule                  changes how an element looks: show heading: it => ...
//   none                       "nothing". We use it for optional fields.

// Labels that depend on the thesis type. A dictionary of dictionaries.
#let typy = (
  bakalarska: (nazev: "Bakalářská práce", vedouci: "Vedoucí práce"),
  diplomova: (nazev: "Diplomová práce", vedouci: "Vedoucí práce"),
  disertacni: (nazev: "Disertační práce", vedouci: "Školitel"),
)

// The whole template is one function. prace.typ calls it with `#show: prace.with(...)`.
// Every named parameter below is a field you fill in. The value after the colon is the default.
#let prace(
  typ: "bakalarska", // "bakalarska" | "diplomova" | "disertacni"
  katedra: none, // not shown for doctoral theses
  program: "Studijní program – specializace",
  nazev: "Název práce",
  nazev-en: "Thesis title",
  autor: (jmeno: "Jméno", prijmeni: "Příjmení", titul-pred: none, titul-za: none),
  rod: "m", // "m" or "z": picks zpracoval / zpracovala in the declaration
  vedouci: "Jméno Příjmení",
  rok: datetime.today().year(),
  datum: datetime.today().display("[day]. [month]. [year]"),
  anotace: [],
  abstract: [],
  klicova-slova: (),
  keywords: (),
  ai: none, // or (nastroj: "...", ucel: "...")
  podekovani: none, // optional page
  zadani: none, // e.g. image("zadani.pdf"); none leaves a placeholder page
  body, // everything you write in prace.typ below the #show line
) = {
  let t = typy.at(typ) // fails loudly if `typ` is misspelled
  let cele-jmeno = (autor.titul-pred, autor.jmeno + " " + autor.prijmeni, autor.titul-za)
    .filter(x => x != none)
    .join(" ")

  // ---- Global look: page, font, paragraphs --------------------------------
  set document(title: nazev, author: cele-jmeno)
  set page(paper: "a4", margin: (top: 2.5cm, bottom: 2.5cm, left: 4cm, right: 2.5cm))
  set text(font: "Times New Roman", size: 12pt, lang: "cs")
  set par(justify: true, leading: 1em, spacing: 2em) // ~ Word's 1.5 lines + 12 pt after

  // ---- Headings: 1 / 1.1 / 1.1.1, chapters start on a new page -------------
  set heading(numbering: "1.1.1")
  show heading: set block(above: 1.5em, below: 1.2em)
  show heading.where(level: 1): set text(size: 16pt)
  show heading.where(level: 2): set text(size: 14pt)
  show heading.where(level: 3): set text(size: 12pt, style: "italic")
  show heading.where(level: 1): it => pagebreak(weak: true) + it

  // ---- Figures: "Obrázek č. 1: Název", "Tabulka č. 1: Název" ----------------
  set figure.caption(separator: [: ])
  show figure.where(kind: image): set figure(supplement: [Obrázek č.])
  show figure.where(kind: table): set figure(supplement: [Tabulka č.])
  show figure.where(kind: table): set figure.caption(position: top)

  // ---- Footnotes: 10 pt, single spacing ------------------------------------
  show footnote.entry: set text(size: 10pt)
  show footnote.entry: set par(leading: 0.65em)

  // A small helper: bold 14 pt label on its own line used on the front pages (not in the outline).
  let nadpisek(x) = block(above: 2em, below: 1.2em, text(size: 14pt, weight: "bold", x))

  // ---- Title page ----------------------------------------------------------
  {
    set align(center)
    set text(size: 16pt)
    set par(spacing: 0.8em)
    strong[JANÁČKOVA AKADEMIE MÚZICKÝCH UMĚNÍ]
    v(0.8em)
    [Hudební fakulta]
    if typ != "disertacni" and katedra != none { parbreak(); katedra }
    parbreak()
    program
    v(1fr)
    strong(nazev)
    parbreak()
    t.nazev
    v(1fr)
    set text(size: 14pt)
    [Autor práce: #cele-jmeno]
    parbreak()
    [#t.vedouci: #vedouci]
    v(1em)
    [Brno #rok]
  }

  // ---- Bibliographic record, annotation, keywords --------------------------
  pagebreak()
  nadpisek[Bibliografický záznam]
  emph[#upper(autor.prijmeni), #autor.jmeno. #nazev [#nazev-en]. #t.nazev. Brno: Janáčkova akademie múzických umění, Hudební fakulta, #rok.]

  nadpisek[Anotace]
  anotace

  nadpisek[Abstract]
  abstract

  nadpisek[Klíčová slova]
  klicova-slova.join(", ")

  nadpisek[Keywords]
  keywords.join(", ")

  // ---- Declaration ---------------------------------------------------------
  pagebreak()
  nadpisek[Prohlášení]
  [Prohlašuji, že jsem předkládanou práci #if rod == "z" [zpracovala] else [zpracoval] samostatně za použití uvedených informačních zdrojů.]
  if ai != none [
    Při přípravě práce byly použity nástroje umělé inteligence „#ai.nastroj“ za účelem #ai.ucel. Po použití tohoto nástroje autor provedl kontrolu obsahu a je si vědom, že za něj přejímá plnou odpovědnost.
  ]
  v(2em)
  [V Brně dne #datum #h(1fr) #box(width: 5cm, repeat[.])]
  align(right)[#cele-jmeno]

  // ---- Acknowledgements (optional), pushed to the bottom of the page --------
  if podekovani != none {
    pagebreak()
    v(1fr)
    nadpisek[Poděkování]
    podekovani
  }

  // ---- Assignment (scan of the signed Zadání KP) ---------------------------
  pagebreak()
  if zadani == none {
    align(center + horizon, text(fill: red)[\[Sem vložte kopii podepsaného Zadání KP: `zadani: image("zadani.pdf")`\]])
  } else {
    set align(center + horizon)
    set image(width: 100%)
    zadani
  }

  // ---- Table of contents ---------------------------------------------------
  pagebreak()
  {
    show outline.entry: set text(size: 11pt)
    show outline.entry: set par(spacing: 0.8em)
    outline(title: [Obsah], indent: auto)
  }

  // ---- Main text: page numbers appear from here on --------------------------
  // The counter keeps running from the title page, as in the Word template.
  set page(numbering: "1")
  body
}

// Appendices: own page numbering in Roman numerals, starting at I.
// Use in prace.typ as `#show: prilohy` before the appendices.
#let prilohy(body) = {
  set page(numbering: "I")
  counter(page).update(1)
  set heading(numbering: none, outlined: false)
  heading[Přílohy]
  body
}

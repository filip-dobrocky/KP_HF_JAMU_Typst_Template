// Your thesis. Compile with:  typst watch prace.typ
// (or open the folder in VS Code with the "Tinymist" extension for a live preview)

// Load the template: takes `prace` and `prilohy` from sablona.typ.
#import "sablona.typ": prace, prilohy

// `#show: prace.with(...)` = "wrap the rest of this file in the template",
// passing your data as named arguments. Delete a line to fall back to its default.
#show: prace.with(
  typ: "bakalarska", // "bakalarska" | "diplomova" | "disertacni"
  katedra: "Katedra kompozice a multimediální tvorby",
  program: "Multimediální tvorba",
  nazev: "Název práce",
  nazev-en: "Thesis title",
  autor: (jmeno: "Jméno", prijmeni: "Příjmení", titul-pred: none, titul-za: none),
  rod: "m",
  vedouci: "doc. Jméno Příjmení, Ph.D.",
  rok: 2027,
  datum: "1. 5. 2027",

  // Content in [square brackets] can hold any markup: *bold*, _italic_, footnotes...
  anotace: [Bakalářská práce „Název“ pojednává o… (cca 500 znaků)],
  abstract: [The thesis “Title” deals with…],

  // Arrays: ("a", "b", "c"). The template joins them with commas.
  klicova-slova: ("slovo", "slovo", "slovo", "slovo", "slovo"),
  keywords: ("word", "word", "word", "word", "word"),

  // Remove this line (or write `ai: none`) if you used no AI tools.
  ai: (nastroj: "typ nástroje", ucel: "v jaké části práce a co se tím dělalo"),

  podekovani: [Na tomto místě bych rád poděkoval…], // or none to drop the page
  zadani: none, // later: image("zadani.pdf")
)

// ===========================================================================
// From here on it's just the text. `=` is a chapter, `==` a section, `===` a subsection.
// Chapters without a number use #heading(numbering: none)[...].

#heading(numbering: none)[Předmluva]
Možnost pro osobní sdělení autora – nepovinná. Pokud nevyužijete, smažte.

#heading(numbering: none)[Úvod]
Vymezení tématu, základní teze, cíle, východiska, hypotézy, metody, zdůvodnění struktury.

#heading(numbering: none)[Stav bádání]
Reflexe dosavadních poznatků, pramenů a literatury k danému tématu @novak2020.

= Nadpis první úrovně
Vlastní text.#footnote[Poznámka pod čarou.]

== Nadpis druhé úrovně
Vlastní text.

=== Nadpis třetí úrovně
Vlastní text. Odkaz na obrázek: @obr-ukazka.

#figure(
  rect(width: 60%, height: 3cm), // later: image("obrazky/foto.jpg", width: 80%)
  caption: [Ukázkový obrázek],
) <obr-ukazka>

= Druhý nadpis první úrovně
Vlastní text.

#heading(numbering: none)[Závěr]
Odpověď na základní výzkumné otázky, teze a cíle stanovené v Úvodu práce.

// Only for doctoral theses:
// #heading(numbering: none)[Shrnutí]
// #heading(numbering: none)[Summary]

#heading(numbering: none)[Použité informační zdroje]
// Sources live in zdroje.bib; only the ones you cite with @key are listed.
// `full: true` lists all of them. Style follows ISO 690.
#bibliography("zdroje.bib", title: none, style: "iso-690-author-date")

#heading(numbering: none)[Seznam příloh]
Příloha 1: …

// ===========================================================================
#show: prilohy

Obsah příloh (Poznámky, Seznam ilustrací, Seznam tabulek – každé na nový list).

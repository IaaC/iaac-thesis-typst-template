// =============================================================================
//  Your thesis starts here.
//  1. Fill in the details below.
//  2. Write your chapters in `chapters/` and list them at the bottom.
//  Compile with:  typst watch --font-path fonts main.typ
// =============================================================================

#import "/iaac-template/lib.typ": *

#show: thesis.with(
  title: [Title of Thesis],
  subtitle: none, // optional, shown on the title page
  author: [Author Name Lastname],
  supervisor: [Supervisor Name Lastname],
  cluster: [Thesis Cluster Name],
  program: [Master Program],
  institution: [Institute for Advanced Architecture of Catalonia],
  academic-cycle: [2025-2026],
  location-date: [Barcelona, June 2026],

  // Short text shown on the cover (optional — remove or set to none)
  cover-blurb: [A one-paragraph statement of what this thesis is about, shown on the cover.],

  // Abstract: max. 500 words (1 page), state the problem, research question,
  // hypothesis, experiments and results. Max. 5 keywords.
  abstract: include "frontmatter/abstract.typ",
  keywords: ("Keyword one", "Keyword two", "Keyword three"),
  abstract-image: none, // e.g. image("/figures/abstract.jpg")

  // Optional sections before the first chapter (preface max. 3 pages)
  front-sections: (
    ([Preface], include "frontmatter/preface.typ"),
    // ([Acknowledgements], include "frontmatter/acknowledgements.typ"),
  ),

  bibliography: bibliography("references.bib"),
  glossary: include "backmatter/glossary.typ",

  // IAAC logos (shared privately, see README)
  logo: image("/assets/logos/iaac-black.png"),
  logo-light: image("/assets/logos/iaac-white.png"),
)

#include "chapters/01-introduction.typ"
#include "chapters/02-methodology.typ"
#include "chapters/03-conclusions.typ"

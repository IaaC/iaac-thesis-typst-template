// =============================================================================
//  IAAC thesis template
//  Typst port of the InDesign "Thesis template" (Loquat-lab).
//
//  This file is used as a git submodule (`iaac-template/`) inside each thesis
//  repository. Students edit their own files, never this one.
// =============================================================================

// ---- Design tokens -----------------------------------------------------------

// Colours (CMYK swatches from the InDesign document)
#let ink = cmyk(100%, 80%, 80%, 100%) // text and dark pages
#let accent = cmyk(26%, 63%, 100%, 0%) // ochre highlight
#let paper = cmyk(2%, 2%, 3%, 0%) // page background
#let stone = cmyk(19%, 15%, 16%, 0%) // grey panels / image placeholders

// Fonts (in the thesis repository's fonts/ — compile with `--font-path fonts`)
#let serif = "Clarendon Graphic" // Regular 400, Medium 500
#let sans = "FK Grotesk" // Light 300, Regular 400

// A4 page on a 4-column grid with 22.5pt margins
#let margin = 22.5pt
#let col = 137.57pt
#let page-w = 595.28pt
#let page-h = 841.89pt

// Main text runs in columns 2–4 of a right page / 1–3 of a left page,
// so the inside column stays free for side notes.
#let body-margins = (inside: margin + col, outside: margin, top: 45pt, bottom: 56pt)

// InDesign leading is baseline-to-baseline; Typst's `leading` is the gap
// between lines measured from the cap height. This converts one to the other.
#let lead(size, baseline) = baseline - 0.7 * size

#let pad2(n) = if n < 10 { "0" + str(n) } else { str(n) }

// ---- Paragraph & character styles ---------------------------------------------

// Heading 01 — Clarendon 55/43 (cover title)
#let heading-01(body) = {
  set text(font: serif, size: 55pt, weight: 400, fill: ink, hyphenate: false)
  set par(leading: lead(55pt, 43pt), justify: false, first-line-indent: 0pt)
  block(body)
}

// Title 01 (Left) — Clarendon Medium 40/36
#let title-01(body) = {
  set text(font: serif, size: 40pt, weight: 500, tracking: -0.025em, fill: ink, hyphenate: false)
  set par(leading: lead(40pt, 36pt), justify: false, first-line-indent: 0pt)
  block(body)
}

// Title 02 (Right) — Clarendon Medium 18/17
#let title-02(body, align-to: right) = {
  set text(font: serif, size: 18pt, weight: 500, tracking: -0.04em, fill: ink, hyphenate: false)
  set par(leading: lead(18pt, 17pt), justify: false, first-line-indent: 0pt)
  block(width: 100%, align(align-to, body))
}

// Title 03 (Center) — Clarendon 18/19
#let title-03(body) = {
  set text(font: serif, size: 18pt, weight: 400, tracking: -0.04em, fill: ink, hyphenate: false)
  set par(leading: lead(18pt, 19pt), justify: false, first-line-indent: 0pt)
  block(width: 100%, align(center, body))
}

// Sub Title 02 — FK Grotesk 14/13, accent
#let subtitle-02(body) = {
  set text(font: sans, size: 14pt, weight: 400, fill: accent)
  set par(leading: lead(14pt, 15pt), justify: false, first-line-indent: 0pt)
  block(body)
}

// Sub Title 01 — FK Grotesk 7pt, all caps, tracking +100
#let label-text(body, fill: ink) = text(
  font: sans,
  size: 7pt,
  weight: 400,
  tracking: 0.1em,
  fill: fill,
  upper(body),
)

// Body 01 highlight — Clarendon 14/13, accent
#let highlight-text(body) = {
  set text(font: serif, size: 14pt, weight: 400, fill: accent)
  set par(leading: lead(14pt, 15pt), justify: false, first-line-indent: 0pt)
  block(spacing: 18pt, body)
}

// notes — FK Grotesk 10pt
#let notes-text(body) = {
  set text(font: sans, size: 10pt, weight: 400)
  set par(leading: lead(10pt, 12pt), first-line-indent: 0pt)
  body
}

// ---- Layout helpers ------------------------------------------------------------

// Grey panel used where the template expects an image.
#let placeholder(width: 100%, height: 200pt, label: "Image") = block(
  width: width,
  height: height,
  fill: stone,
  inset: 8pt,
  align(bottom + left, label-text(label)),
)

// Images are passed in as `image("/figures/x.jpg")` from the thesis files:
// a plain path string would be resolved relative to this file, which lives
// in the template submodule. The set rule makes the image fill its frame.
#let _fill-image(src) = {
  assert(
    type(src) != str,
    message: "pass images as image(\"/figures/your-image.jpg\"), not as a plain string",
  )
  set image(width: 100%, height: 100%, fit: "cover")
  src
}

// Image (or placeholder) in a grid-aligned panel.
#let image-panel(src: none, height: 300pt, caption: none) = {
  let content = if src == none {
    placeholder(height: height)
  } else {
    block(width: 100%, height: height, clip: true, _fill-image(src))
  }
  if caption == none { content } else { figure(content, caption: caption) }
}

// Full-bleed page with an image (or a stone placeholder) and an optional caption.
#let full-page-image(src: none, caption: none) = page(
  margin: 0pt,
  fill: stone,
  header: none,
  footer: none,
)[
  #if src != none { _fill-image(src) }
  #if caption != none {
    place(bottom + left, dx: margin, dy: -margin, block(
      width: 2 * col,
      fill: paper,
      inset: 8pt,
      notes-text(caption),
    ))
  }
]

// Full ochre page with text (template p. 21).
#let accent-page(body) = page(fill: accent, footer: none)[
  #set text(fill: ink)
  #v(1fr)
  #block(width: 2 * col, body)
]

// Large quotation in the QUOTES style, optionally on a stone panel.
#let pull-quote(body, attribution: none, panel: false) = {
  let q = {
    set text(font: serif, size: 36pt, weight: 400, tracking: -0.025em, fill: ink, hyphenate: false)
    set par(leading: lead(36pt, 36pt), justify: false, first-line-indent: 0pt)
    body
    if attribution != none {
      v(4pt)
      label-text(attribution, fill: accent)
    }
  }
  block(
    width: 100%,
    above: 28pt,
    below: 28pt,
    fill: if panel { stone } else { none },
    inset: if panel { 18pt } else { 0pt },
    q,
  )
}

// Rotated caption in the free inside column (Body 03 style).
#let side-note(body) = context {
  let odd = calc.odd(here().page())
  let note = rotate(-90deg, reflow: true, block(width: 260pt, {
    set text(font: serif, size: 10pt, weight: 400, fill: ink)
    set par(first-line-indent: 0pt, justify: false)
    align(center, body)
  }))
  // inside column is on the left of right pages and the right of left pages
  // no vertical alignment: the note starts at the current line
  if odd {
    place(left, dx: -col + 4pt, note)
  } else {
    place(right, dx: col - 4pt, note)
  }
}

#let blank-page(fill: paper) = page(fill: fill, header: none, footer: none)[]

// Glossary entry: term in Clarendon on the left, definition in body text.
#let term(name, definition) = block(below: 14pt, grid(
  columns: (col, 1fr),
  text(font: serif, size: 12pt, weight: 400, name), par(first-line-indent: 0pt, definition),
))

// Metadata the next chapter heading picks up (see `chapter`).
#let _chapter-meta = state("iaac-chapter-meta", none)

// A chapter with a subtitle and/or an image on its opening left page.
// A plain `= Title` works too; this just adds the extras.
#let chapter(title, subtitle: none, image: none, label: none) = {
  _chapter-meta.update((subtitle: subtitle, image: image))
  [#heading(level: 1, title)#if label != none { std.label(label) }]
}

#let chapter-subtitle(body) = _chapter-meta.update(m => {
  let m = if m == none { (image: none) } else { m }
  m.insert("subtitle", body)
  m
})

#let list-of-figures(title: "List of Figures") = {
  pagebreak(weak: true)
  title-01(title)
  v(48pt)
  show outline.entry: it => {
    set text(font: sans, size: 12pt, weight: 300)
    link(it.element.location(), grid(
      columns: (60pt, 1fr, 30pt),
      label-text(it.prefix(), fill: accent), it.body(), align(right, text(font: serif, weight: 400, it.page())),
    ))
  }
  outline(title: none, target: figure.where(kind: image))
}

// ---- Fixed pages ------------------------------------------------------------------

// Logos come from the thesis repository (they are not part of the template).
#let _logo(img, width) = if img != none { box(width: width, { set image(width: 100%); img }) }

#let _cover(meta) = page(fill: stone, margin: margin, header: none, footer: none)[
  #place(top + left, _logo(meta.logo, 99pt))
  #place(top + left, dx: 3 * col, block(width: col, notes-text[
    Academic Cycle \
    #meta.academic-cycle
  ]))
  #if meta.cover-blurb != none {
    place(top + left, dx: 2 * col, dy: 408pt, block(width: 2 * col, meta.cover-blurb))
  }
  #place(bottom + left, block(width: 3.5 * col, {
    heading-01(meta.title)
    v(40pt)
    set par(first-line-indent: 0pt)
    [#meta.author \ #meta.supervisor \ #meta.cluster]
  }))
]

#let _inside-cover() = page(fill: ink, margin: 0pt, header: none, footer: none)[]

#let _title-page(meta) = page(fill: paper, margin: margin, header: none, footer: none)[
  #set par(first-line-indent: 0pt)
  #place(top + left, dx: 2 * col, dy: 436pt, block(width: 2 * col, {
    title-01(meta.title)
    if meta.subtitle != none {
      v(12pt)
      subtitle-02(meta.subtitle)
    }
    v(40pt)
    [#meta.author \ #meta.supervisor \ #meta.institution \ #meta.program]
  }))
  #place(bottom + left, dx: 2 * col, notes-text(meta.location-date))
]

#let _contents() = page(fill: paper, margin: (x: margin, top: margin, bottom: 56pt))[
  #title-01[Contents]
  #v(84pt)
  #context {
    let entries = query(heading.where(outlined: true)).filter(h => h.level <= 2)
    let page-of(h) = {
      // Chapter headings sit on the ink page; point at their title page instead.
      let anchors = query(selector(<iaac-chapter-anchor>).after(h.location()))
      let loc = if h.level == 1 and anchors.len() > 0 and anchors.first().value == h.location() {
        anchors.first().location()
      } else { h.location() }
      (loc, pad2(counter(page).at(loc).first()))
    }
    set par(first-line-indent: 0pt)
    show link: set text(fill: ink)
    pad(left: col + 69pt, block(width: 275pt, {
      for (i, h) in entries.enumerate() {
        let (loc, num) = page-of(h)
        // Each row keeps one size so label and number share a baseline:
        // section labels in Sub Title 01, entries in Body 01 / Body 02 (Right).
        if h.level == 1 {
          if i > 0 { v(28pt) }
          link(loc, grid(
            columns: (1fr, 30pt),
            align: bottom,
            label-text(h.body), align(right, label-text(num)),
          ))
          v(6pt)
        } else {
          link(loc, grid(
            columns: (1fr, 30pt),
            align: bottom,
            text(font: sans, size: 12pt, weight: 300, h.body),
            align(right, text(font: serif, size: 12pt, weight: 400, number-width: "tabular", num)),
          ))
          v(2pt)
        }
      }
    }))
  }
]

#let _abstract(abstract, keywords, image-src) = {
  // left page: image / stone panel within the margins
  pagebreak(weak: true, to: "even")
  page(fill: paper, margin: margin, footer: none)[
    #if image-src == none { block(width: 100%, height: 100%, fill: stone) } else {
      block(width: 100%, height: 100%, clip: true, _fill-image(image-src))
    }
  ]
  // right page: centred title, body + keywords column
  page(fill: paper, margin: (x: margin, top: margin, bottom: 56pt))[
    #v(115pt)
    #{
      show heading: it => title-03(it.body)
      heading(level: 1)[Abstract]
    }
    #v(56pt)
    #grid(
      columns: (68.5pt, 304pt, 40pt, 1fr),
      [], abstract, [],
      if keywords.len() > 0 {
        label-text[Keywords]
        v(6pt)
        highlight-text(keywords.join[ \ ])
      },
    )
  ]
}

// Preface, acknowledgements, … : title on a left page, text in columns 2–4.
#let _front-section(title, body) = {
  pagebreak(weak: true, to: "even")
  {
    show heading: it => title-01(it.body)
    heading(level: 1, title)
  }
  v(84pt)
  body
}

#let _back-cover(logo-light) = {
  pagebreak(weak: true, to: "even")
  page(fill: ink, margin: margin, header: none, footer: none)[
    #place(bottom + left, _logo(logo-light, 145pt))
  ]
}

// ---- Chapter opener ------------------------------------------------------------

#let _chapter-opener(it) = {
  // left page: full-bleed ink (or the chapter image)
  pagebreak(weak: true, to: "even")
  page(fill: ink, margin: 0pt, header: none, footer: none, context {
    let meta = _chapter-meta.get()
    if meta != none and meta.image != none {
      _fill-image(meta.image)
    }
  })
  // right page: title, subtitle, then the body starts lower down
  [#metadata(it.location())<iaac-chapter-anchor>]
  block(height: 300pt, width: 100%, breakable: false, {
    set par(first-line-indent: 0pt)
    pad(left: -col, block(width: 3 * col, title-01(it.body)))
    context {
      let meta = _chapter-meta.get()
      if meta != none and meta.at("subtitle", default: none) != none {
        v(36pt)
        pad(left: -col, block(width: 2 * col, subtitle-02(meta.subtitle)))
      }
    }
  })
  _chapter-meta.update(none)
}

// Back-matter sections (References, Glossary): title at the top of a new page.
#let _back-heading(it) = {
  pagebreak(weak: true)
  title-01(it.body)
  v(60pt)
}

// ---- Main show rule -------------------------------------------------------------

#let thesis(
  title: [Title of Thesis],
  subtitle: none,
  author: [Author Name Lastname],
  supervisor: [Supervisor Name Lastname],
  cluster: [Thesis Cluster],
  program: [Master Program],
  institution: [Institute for Advanced Architecture of Catalonia],
  academic-cycle: [2025-2026],
  location-date: [Barcelona, Month Year],
  cover-blurb: none,
  abstract: [],
  keywords: (),
  abstract-image: none,
  front-sections: (), // e.g. (([Preface], include "frontmatter/preface.typ"),)
  bibliography: none, // e.g. bibliography("references.bib")
  glossary: none,
  logo: none, // e.g. image("/assets/logos/iaac-black.png"), shown on the cover
  logo-light: none, // e.g. image("/assets/logos/iaac-white.png"), shown on the back cover
  body,
) = {
  set document(title: title, author: if type(author) == str { author } else { () })

  // Base page
  set page(
    paper: "a4",
    fill: paper,
    margin: body-margins,
    footer: context {
      set text(font: sans, size: 9pt, weight: 300, fill: ink)
      let n = pad2(counter(page).get().first())
      if calc.even(here().page()) { align(left, n) } else { align(right, n) }
    },
  )

  // Body 01 — FK Grotesk Light 12/14
  set text(font: sans, size: 12pt, weight: 300, fill: ink, lang: "en", hyphenate: true)
  set par(
    leading: lead(12pt, 14pt),
    spacing: lead(12pt, 14pt),
    justify: false,
    first-line-indent: (amount: 1.5em, all: false),
  )

  // No italic / bold cuts are provided: emphasis uses colour, strong the regular weight.
  show emph: it => text(fill: accent, it.body)
  show strong: it => text(weight: 400, it.body)
  show link: set text(fill: accent)
  show ref: set text(fill: accent)

  set list(marker: text(fill: accent)[–], indent: 0pt, body-indent: 10pt)
  set enum(indent: 0pt, body-indent: 10pt, numbering: n => text(fill: accent, pad2(n)))

  // Headings inside chapters
  show heading.where(level: 2): it => block(above: 36pt, below: 16pt, sticky: true, title-02(it.body, align-to: left))
  show heading.where(level: 3): it => block(above: 28pt, below: 12pt, sticky: true, subtitle-02(it.body))
  show heading.where(level: 4): it => block(above: 20pt, below: 10pt, sticky: true, label-text(it.body))

  // Block quotes
  show quote.where(block: true): it => pull-quote(it.body, attribution: it.attribution)

  // Figures and tables
  set figure(numbering: n => pad2(n), gap: 10pt)
  set figure(supplement: "Fig.")
  show figure.where(kind: table): set figure(supplement: "Table")
  show figure.where(kind: table): set figure.caption(position: top)
  show figure: set block(above: 24pt, below: 24pt)
  show figure.caption: it => {
    set align(left)
    set par(first-line-indent: 0pt)
    label-text(fill: accent)[#it.supplement #context it.counter.display(it.numbering)]
    h(8pt)
    notes-text(it.body)
  }
  set table(
    stroke: (x, y) => (top: if y == 0 { 0.8pt + ink } else { 0.3pt + ink }, bottom: 0.8pt + ink),
    inset: (x: 4pt, y: 6pt),
    align: left,
  )
  show table: set text(size: 10pt)
  show table: set par(first-line-indent: 0pt)
  show table.cell.where(y: 0): it => label-text(it)

  // Footnotes — notes style, accent marker, short accent rule
  show footnote: set text(fill: accent)
  set footnote.entry(separator: line(length: 30pt, stroke: 0.6pt + accent), gap: 6pt, clearance: 14pt)
  show footnote.entry: it => {
    set par(first-line-indent: 0pt)
    notes-text(it)
  }

  let meta = (
    title: title,
    subtitle: subtitle,
    author: author,
    supervisor: supervisor,
    cluster: cluster,
    program: program,
    institution: institution,
    academic-cycle: academic-cycle,
    location-date: location-date,
    cover-blurb: cover-blurb,
    logo: logo,
  )

  // ---- Front matter
  _cover(meta)
  _inside-cover()
  _title-page(meta)
  blank-page(fill: stone)
  _contents()
  _abstract(abstract, keywords, abstract-image)
  for (t, b) in front-sections { _front-section(t, b) }

  // ---- Main matter
  {
    show heading.where(level: 1): _chapter-opener
    body
  }

  // ---- Back matter
  {
    show heading.where(level: 1): _back-heading
    set page(margin: (x: margin, top: 45pt, bottom: 56pt))
    if bibliography != none {
      set std.bibliography(title: [References], style: "apa")
      show std.bibliography: set text(size: 10pt)
      show std.bibliography: set par(first-line-indent: 0pt)
      pagebreak(weak: true)
      bibliography
    }
    if glossary != none {
      heading(level: 1)[Glossary]
      glossary
    }
  }
  _back-cover(logo-light)
}

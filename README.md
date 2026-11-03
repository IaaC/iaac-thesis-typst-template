# IAAC Thesis Typst Template

A [Typst](https://typst.app) template for master's theses at the [Institute for Advanced Architecture of Catalonia (IAAC)](https://iaac.net). It reproduces IAAC's editorial thesis design: A4 facing pages on a 4-column grid, Clarendon Graphic titles with FK Grotesk body text, and a dark / stone / ochre colour palette.

You write plain text in a few files. The template takes care of the layout:

- cover, inside cover and title page
- automatic table of contents
- abstract spread with keywords
- chapters that open on a dark spread
- figures, tables, footnotes and citations
- references, glossary and back cover

Typst is a modern alternative to LaTeX. It compiles in milliseconds, has readable syntax and good error messages, and runs locally or in the browser.

## How it works

You don't copy this repository. You **add it to your own thesis repository as a git submodule** called `iaac-template/`:

```
my-thesis/                    ← YOUR repository
├── iaac-template/            ← this repository (submodule) — don't edit
├── main.typ                  ← your details + the list of chapters
├── chapters/                 ← one file per chapter
├── frontmatter/              ← abstract, preface, acknowledgements
├── backmatter/               ← glossary
├── references.bib            ← bibliography (BibTeX, e.g. exported from Zotero)
├── figures/                  ← your images
├── fonts/                    ← template fonts (shared privately, git-ignored)
└── assets/logos/             ← IAAC logos (shared privately, git-ignored)
```

Your writing lives in your repository. The layout lives in `iaac-template/`. When your supervisor improves the template, you pull the new version with one command, and your chapters stay untouched.

## Setting up your thesis repository (once)

You need [git](https://git-scm.com) and [Typst](https://typst.app/open-source/#download). For editing, we recommend VS Code with the [Tinymist Typst](https://marketplace.visualstudio.com/items?itemName=myriad-dreamin.tinymist) extension, which has a live preview.

**1. Create your repository.** Create an empty repository on GitHub (private is fine), then clone it:

```sh
git clone https://github.com/<your-user>/my-thesis.git
cd my-thesis
```

**2. Add the template as a submodule:**

```sh
git submodule add https://github.com/IaaC/iaac-thesis-typst-template.git iaac-template
```

**3. Copy the starter files to the root of your repository.** This also copies the hidden `.gitignore` and `.vscode/` files.

```sh
cp -r iaac-template/example/. .
```

On Windows (PowerShell), use this instead:

```powershell
Copy-Item -Path iaac-template\example\* -Destination . -Recurse -Force
Copy-Item -Path iaac-template\example\.gitignore, iaac-template\example\.vscode -Destination . -Recurse -Force
```

**4. Add the fonts and logos.** Your supervisor shares these privately. Put them in these places, keeping the file names exactly as shown:

```
fonts/Clarendon-Graphic-Regular.otf
fonts/Clarendon-Graphic-Medium.otf
fonts/FKGrotesk-Light.otf
fonts/FKGrotesk-Regular.otf
assets/logos/iaac-black.png
assets/logos/iaac-white.png
```

The fonts are commercially licensed and the logos belong to IAAC. The included `.gitignore` keeps them out of git. **Never commit or share them publicly.**

**5. Build it once, then commit:**

```sh
typst compile --font-path fonts main.typ
git add .
git commit -m "Start thesis from IAAC template"
git push
```

If `main.pdf` shows the sample thesis, you're set up. Open `main.typ` and fill in your details.

## Day-to-day work

Run commands from the root of your repository:

```sh
typst watch --font-path fonts main.typ     # live preview, recompiles on save
typst compile --font-path fonts main.typ   # one-off build → main.pdf
```

- **VS Code:** open your repository folder. The included `.vscode/settings.json` already points Tinymist at `fonts/`.
- **Typst web app:** upload your whole repository folder, including `iaac-template/` and `fonts/`. The web app doesn't understand git, so to update the template there, re-upload `iaac-template/lib.typ`.

Commit and push your own files as usual. **Never edit files inside `iaac-template/`.** Your changes there would be lost or cause conflicts on the next update. If the template is missing something, ask your supervisor.

## Updating the template

When your supervisor announces a new version, run:

```sh
git submodule update --remote iaac-template
git add iaac-template
git commit -m "Update thesis template"
```

To use a specific release, for example `v1.1.0`, instead of the latest version:

```sh
cd iaac-template
git fetch --tags
git checkout v1.1.0
cd ..
git add iaac-template
git commit -m "Use thesis template v1.1.0"
```

Your repository records exactly which template version you use. Nothing changes until you run one of these commands, so near your submission deadline, only update if you need to.

### Working on another computer

Clone with `--recursive`, otherwise the `iaac-template/` folder stays empty:

```sh
git clone --recursive https://github.com/<your-user>/my-thesis.git
```

If you already cloned without it, run `git submodule update --init` instead. You also need to copy the fonts and logos again, because they're not in git.

## The document structure

The template assembles the document in this order:

1. cover
2. inside cover
3. title page
4. contents
5. abstract spread
6. preface (optional)
7. chapters
8. references
9. glossary
10. back cover

The layout uses facing pages, so every chapter opens on a spread: a dark left page, then the chapter title on the right page. Typst inserts blank pages where needed to make this work.

### Content rules

- **Abstract:** max. 500 words (one page). It states the problem, research question, hypothesis, experiments and results.
- **Keywords:** max. 5, set in `main.typ`.
- **Preface / prologue:** optional, max. 3 pages.

## Writing

### Adding a chapter

1. Create a new file, e.g. `chapters/04-case-study.typ`:
   ```typ
   #import "/iaac-template/lib.typ": *

   = Case Study

   Your text…
   ```
2. Add it at the bottom of `main.typ`:
   ```typ
   #include "chapters/04-case-study.typ"
   ```

The contents page, page numbers, PDF bookmarks and the chapter's opening spread all update automatically. To reorder chapters, reorder the `#include` lines.

### Paths

Start every path with `/`, which means the root of your repository. For example, write `image("/figures/site.jpg")`. Paths written this way work the same from every file.

### Syntax cheat sheet

| What | How |
|---|---|
| Chapter | `= Title`, or `#chapter([Title], subtitle: [...], image: image("/figures/x.jpg"))` |
| Section / subsection / label | `== …` / `=== …` / `==== …` |
| Highlighted word | `_word_` (shown in the accent colour; the template has no italics) |
| Stronger word | `*word*` |
| Citation | `@key` (keys come from `references.bib`) |
| Footnote | `#footnote[...]` |
| Figure | `#figure(image("/figures/x.jpg", width: 100%), caption: [...]) <fig-x>`, then refer to it with `@fig-x` |
| Table | `#figure(table(columns: 3, table.header[A][B][C], ...), caption: [...])` |
| Image placeholder | `#placeholder(height: 200pt)` |

### Layout helpers

| Helper | Use |
|---|---|
| `#highlight-text[...]` | Large ochre serif paragraph |
| `#pull-quote(attribution: [...], panel: false)[...]` | Big quotation; `panel: true` puts it on a grey panel |
| `#side-note[...]` | Short rotated caption in the empty inside column |
| `#image-panel(src: image("/figures/x.jpg"), height: 300pt, caption: [...])` | Image cropped to a panel the width of the text |
| `#full-page-image(src: image("/figures/x.jpg"), caption: [...])` | Full-bleed image page |
| `#accent-page[...]` | Full ochre page with a short statement |
| `#label-text[...]` | Small caps label |
| `#blank-page()` | Empty page |
| `#list-of-figures()` | List of figures |
| `#term[Term][Definition]` | Glossary entry (in `backmatter/glossary.typ`) |

## Troubleshooting

| Problem | Fix |
|---|---|
| `iaac-template/` is empty, or "file not found … lib.typ" | Run `git submodule update --init` |
| "file not found" for `assets/logos/...` | Add the logos (step 4 of setup) |
| Text appears in a default font | Add the fonts and compile with `--font-path fonts` |
| "pass images as image(...)" | Write `src: image("/figures/x.jpg")`, not `src: "figures/x.jpg"` |
| Git says `iaac-template` has "modified content" | You edited a template file. Undo it with `git -C iaac-template checkout .` |

---

## For maintainers

This repository contains:

```
.
├── lib.typ                   ← the template: all styles, layouts and helpers
├── example/                  ← starter files students copy into their repo root
├── scripts/build-example.sh  ← builds example/ the way a student repo sees it
├── README.md
└── LICENSE
```

**Testing changes:** put the fonts and logos in `example/fonts/` and `example/assets/logos/` (git-ignored), then run:

```sh
scripts/build-example.sh          # → build/main.pdf
scripts/build-example.sh watch    # rebuild on every change
```

**Releasing:**
1. Tag the release and push it:
   ```sh
   git tag v1.1.0
   git push origin v1.1.0
   ```
2. Tell students to update (see [Updating the template](#updating-the-template)).

Use semantic versions. Increase the major version (`v2.0.0`) if a change could break an existing thesis, for example a renamed parameter or helper.

**Changes only reach students through `lib.typ`.** Students copied `example/` once at setup, so later edits to it only affect new students. Keep `lib.typ` backward-compatible: add new options with defaults instead of renaming or removing existing ones.

## Design reference

| Token | Value |
|---|---|
| Page | A4, facing pages, 22.5 pt margins, 4-column grid |
| Ink | CMYK 100/80/80/100 |
| Accent | CMYK 26/63/100/0 |
| Paper | CMYK 2/2/3/0 |
| Stone | CMYK 19/15/16/0 |
| Titles | Clarendon Graphic (Regular / Medium) |
| Body | FK Grotesk Light 12/14 |

## License

The template code is released under the [MIT License](LICENSE). The fonts and the IAAC logos are not covered by this license and are not distributed here.

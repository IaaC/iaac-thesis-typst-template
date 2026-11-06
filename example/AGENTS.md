# Thesis project instructions

This is a master's thesis written in Typst with the IAAC thesis template.

Before writing or changing `.typ` files, use the `typst-author` skill and check its local documentation instead of guessing syntax. If the skill is missing, tell the user to run `sh iaac-template/scripts/install-skills.sh`.

## Rules

- Never edit anything inside `iaac-template/`. It is a git submodule maintained by the supervisor. If the template can't do something, tell the user to ask their supervisor.
- The template controls the design. Don't add global `set` or `show` rules for pages, fonts, text, paragraphs or headings, and don't use the skill's "minimal document" example here. Use the template's helpers, which are listed in `iaac-template/README.md` and defined in `iaac-template/lib.typ`.
- Never commit, upload or share anything in `fonts/` or `assets/logos/`. The fonts are licensed and the logos belong to IAAC.

## Project structure

- `main.typ`: thesis details and the list of chapters
- `chapters/`: one file per chapter
- `frontmatter/`, `backmatter/`: abstract, preface and glossary
- `references.bib`: bibliography
- `figures/`: images

## Conventions

- Start every path with `/`, which means the repository root: `image("/figures/x.jpg")`.
- Every chapter file starts with `#import "/iaac-template/lib.typ": *`, and is added to `main.typ` with `#include`.
- Template helpers take images as `image("/figures/x.jpg")`, not as plain strings.
- The fonts have no italic or bold cuts: `_word_` shows in the accent colour and `*word*` in a slightly heavier weight.
- Abstract: max. 500 words. Keywords: max. 5. Preface: max. 3 pages.

## Checking your work

After editing, run this from the repository root and fix any errors:

```sh
typst compile --font-path fonts main.typ
```

#!/usr/bin/env sh
# Builds example/ the way a student's thesis repository sees it:
# the example files at the root and this repository as iaac-template/.
# Put the private fonts and logos in example/fonts and example/assets/logos first.
#
#   scripts/build-example.sh            → build/main.pdf
#   scripts/build-example.sh watch      → recompile on every change
set -e

repo=$(cd "$(dirname "$0")/.." && pwd)
out="$repo/build"

sync() {
  mkdir -p "$out/iaac-template"
  cp -r "$repo/example/." "$out/"
  cp "$repo/lib.typ" "$out/iaac-template/lib.typ"
}

rm -rf "$out"
sync

if [ "$1" = "watch" ]; then
  # re-copy sources on change; typst watch picks up the copies
  (while sleep 1; do sync; done) &
  trap 'kill $!' EXIT
  typst watch --font-path "$out/fonts" "$out/main.typ" "$out/main.pdf"
else
  typst compile --font-path "$out/fonts" "$out/main.typ" "$out/main.pdf"
  echo "built $out/main.pdf"
fi

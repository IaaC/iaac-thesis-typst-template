#!/usr/bin/env sh
# Installs the Typst agent skills into a thesis repository, for Claude Code
# (.claude/skills) and for agents that read the shared .agents/skills folder.
# The copies are git-ignored, so run this again after cloning or updating.
#
# Run from the root of the thesis repository (on Windows, use Git Bash):
#
#   sh iaac-template/scripts/install-skills.sh
set -e

template=iaac-template

if [ ! -f "$template/lib.typ" ]; then
  echo "error: $template/lib.typ not found." >&2
  echo "Run this from the root of your thesis repository. If $template/ is empty, run: git submodule update --init" >&2
  exit 1
fi

# `git submodule add` and `git submodule update` don't fetch nested submodules.
git -C "$template" submodule update --init typst_skills

for target in .claude/skills .agents/skills; do
  mkdir -p "$target"
  for skill in typst-author touying-author; do
    rm -rf "$target/$skill"
    cp -r "$template/typst_skills/$skill" "$target/$skill"
  done
  echo "installed skills in $target"
done

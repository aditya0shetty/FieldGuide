#!/usr/bin/env bash
set -euo pipefail

ROOT="/Users/aditya.shetty/Personal/Pokedex/Pokemon Field Guide"
cd "$ROOT"

for f in *.md */*.md; do
  base="${f##*/}"; base="${base%.md}"
  if [[ "$base" == "Pokemon Field Guide" ]]; then
    rank="root"
  else
    rank="kingdom"
  fi

  # append inline #rank tag only if missing anywhere in file
  if ! grep -q "#rank/" "$f"; then
    printf "\n#rank/%s\n" "$rank" >> "$f"
    echo "➕ added inline tag #rank/$rank -> $f"
  else
    echo "✓ already has a #rank tag -> $f"
  fi
done

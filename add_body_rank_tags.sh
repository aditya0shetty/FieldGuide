#!/bin/zsh
set -euo pipefail

ROOT="/Users/aditya.shetty/Personal/Pokedex/Pokemon Field Guide"

rank_for_path () {
  local f="$1"
  # depth from ROOT for folder-matching pages; species for others
  local base="${f:t:r}"           # filename w/o extension
  local folder="${f:h:t}"         # parent folder name
  if [[ "$base" != "$folder" && "$base" != "Pokemon Field Guide" ]]; then
    echo "species"; return
  fi
  # count folders after ROOT
  local rel="${f#${ROOT}/}"
  local dcount=$(dirname "$rel" | awk -F'/' '{print ($0==".")?0:NF}')
  case "$dcount" in
    0) echo "root" ;;
    1) echo "kingdom" ;;
    2) echo "phylum" ;;
    3) echo "class" ;;
    4) echo "order" ;;
    5) echo "family" ;;
    6) echo "genus" ;;
    *) echo "clade" ;;
  esac
}

add_body_tag_if_missing () {
  local f="$1"
  local rank="$(rank_for_path "$f")"
  local tag="#rank/$rank"
  if ! grep -q "$tag" "$f"; then
    printf "\n%s\n" "$tag" >> "$f"
    echo "➕ body tag added: $tag → $f"
  else
    echo "✓ has $tag: $f"
  fi
}

autoload -Uz zmv

# iterate all md files under ROOT
for f in "$ROOT"/**/*.md(N); do
  add_body_tag_if_missing "$f"
done
echo "🎉 body tags ensured for all notes"

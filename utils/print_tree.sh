#!/bin/bash

# Usage: ./print_tree.sh /path/to/folder [output.txt]

ROOT="${1:-.}"
OUTFILE="${2:-}"
INDENT_STEP="    "

if [ ! -d "$ROOT" ]; then
  echo "❌ Not a valid directory: $ROOT"
  exit 1
fi

print_tree() {
  local dir="$1"
  local prefix="$2"
  local entries=()

  while IFS= read -r -d '' entry; do
    entries+=("$entry")
  done < <(find "$dir" -mindepth 1 -maxdepth 1 ! -name ".*" -print0 | sort -z)

  local count=${#entries[@]}

  for i in "${!entries[@]}"; do
    local name=$(basename "${entries[$i]}")
    local path="${entries[$i]}"
    local connector="├──"

    if [ "$i" -eq "$((count-1))" ]; then
      connector="└──"
    fi

    echo "${prefix}${connector} $name"

    if [ -d "$path" ]; then
      local new_prefix="$prefix"
      [ "$i" -eq "$((count-1))" ] && new_prefix+="    " || new_prefix+="│   "
      print_tree "$path" "$new_prefix"
    fi
  done
}

if [ -n "$OUTFILE" ]; then
  echo "$(basename "$ROOT")" > "$OUTFILE"
  print_tree "$ROOT" "" >> "$OUTFILE"
  echo "✅ Tree saved to $OUTFILE"
else
  echo "$(basename "$ROOT")"
  print_tree "$ROOT"
fi
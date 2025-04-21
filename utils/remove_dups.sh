#!/bin/bash

# Usage: ./remove_dups.sh /path/to/folder

ROOT="${1:-.}"
TRASH="$ROOT/.trash_duplicates"
mkdir -p "$TRASH"

TMP_KEYS=$(mktemp)

# Recursively find non-hidden files and match by file name + size
find "$ROOT" -type f ! -path "*/.*" | while read -r file; do
  base=$(basename "$file")
  size=$(stat -f%z "$file" 2>/dev/null || stat -c%s "$file")
  key="$base|$size"

  # Check if key exists
  if grep -Fxq "$key" "$TMP_KEYS"; then
    echo "🔁 Duplicate found: $file"
    mv "$file" "$TRASH/"
  else
    echo "$key" >> "$TMP_KEYS"
  fi
done

rm "$TMP_KEYS"
echo "✅ Done. Duplicates moved to: $TRASH"
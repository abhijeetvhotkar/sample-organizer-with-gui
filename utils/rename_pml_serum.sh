#!/bin/bash

# Usage: bash rename_pml_serum.sh /path/to/Presets [--dry-run | --undo]

ROOT="${1:-.}"
MODE="${2:-run}"
LOGFILE="rename_pml_serum_log.txt"
COUNT=0

do_rename() {
  local from="$1"
  local to="$2"
  if [ "$from" != "$to" ]; then
    ((COUNT++))
    if [ "$MODE" = "--dry-run" ]; then
      echo "[DRY RUN] $from -> $to"
    else
      echo "$from -> $to" >> "$LOGFILE"
      mv "$from" "$to"
      echo "Renamed: $from -> $to"
    fi
  fi
}

undo_rename() {
  if [ ! -f "$LOGFILE" ]; then
    echo "❌ No rename log found."
    exit 1
  fi
  tac "$LOGFILE" | while read -r line; do
    from=$(echo "$line" | awk -F' -> ' '{print $2}')
    to=$(echo "$line" | awk -F' -> ' '{print $1}')
    if [ -d "$from" ]; then
      mv "$from" "$to"
      echo "Reverted: $from -> $to"
    fi
  done
  rm "$LOGFILE"
  echo "✅ Undo complete."
}

if [ "$MODE" = "--undo" ]; then
  undo_rename
  exit 0
fi

# Clean up folder names with common "Serum" patterns
find "$ROOT" -depth -type d -name "*Serum*" | while read -r dir; do
  parent=$(dirname "$dir")
  base=$(basename "$dir")

  cleaned=$(echo "$base" | sed -E 's/ - Serum Presets$//I' |
                        sed -E 's/ - Serum - Presets$//I' |
                        sed -E 's/ - Serum$//I' |
                        sed -E 's/ -? *Serum Presets$//I')

  new_path="$parent/$cleaned"

  do_rename "$dir" "$new_path"
done

if [ "$MODE" = "--dry-run" ]; then
  echo "🔍 Total folders that would be renamed: $COUNT"
  echo "✅ Dry run complete. No changes made."
else
  echo "🔧 Total folders renamed: $COUNT"
  echo "✅ Folder renaming complete. Log saved to $LOGFILE."
fi

#!/bin/bash

# Usage: ./compare_midi_multi.sh "/path/to/input" "/path/to/output1" ... [--watch]

INPUT="$1"
shift

WATCH_MODE=false
if [[ "${@: -1}" == "--watch" ]]; then
  WATCH_MODE=true
  set -- "${@:1:$(($#-1))}"  # remove --watch from $@
fi

run_compare() {
  # Get MIDI filenames from input
  INPUT_MIDI=$(find "$INPUT" -type f \( -iname "*.mid" -o -iname "*.midi" \) -exec basename {} \; | sort -u)
  TOTAL_INPUT=$(echo "$INPUT_MIDI" | wc -l)

  # Build combined list of all output MIDI filenames
  OUTPUT_MIDI=$(for dir in "$@"; do
    find "$dir" -type f \( -iname "*.mid" -o -iname "*.midi" \) -exec basename {} \;
  done | sort -u)

  # Compare input to all outputs combined
  MISSING=$(comm -23 <(echo "$INPUT_MIDI") <(echo "$OUTPUT_MIDI"))
  COUNT_MISSING=$(echo "$MISSING" | grep -c .)

  clear
  date
  echo "🔍 Total MIDI files in input: $TOTAL_INPUT"
  echo "✅ Found in outputs: $((TOTAL_INPUT - COUNT_MISSING))"
  echo "❌ Missing in all outputs: $COUNT_MISSING"
  echo "---- Missing Files ----"
  echo "$MISSING"
}

if [ "$WATCH_MODE" = true ]; then
  while true; do
    run_compare "$@"
    sleep 10
  done
else
  run_compare "$@"
fi
#!/bin/bash

# Usage: ./list_visible_files.sh /path/to/folder output.txt

INPUT_DIR="$1"
OUTPUT_FILE="$2"

# Validate input
if [ -z "$INPUT_DIR" ] || [ -z "$OUTPUT_FILE" ]; then
  echo "Usage: $0 /path/to/folder output.txt"
  exit 1
fi

if [ ! -d "$INPUT_DIR" ]; then
  echo "Error: '$INPUT_DIR' is not a valid directory."
  exit 1
fi

# Clear or create the output file
> "$OUTPUT_FILE"

# Loop through non-hidden files only
find "$INPUT_DIR" -maxdepth 1 -type f | while read -r filepath; do
  filename=$(basename "$filepath")
  # Skip hidden files (starting with dot)
  if [[ "$filename" != .* ]]; then
    echo "$filename" >> "$OUTPUT_FILE"
  fi
done

echo "Visible file names saved to '$OUTPUT_FILE'"
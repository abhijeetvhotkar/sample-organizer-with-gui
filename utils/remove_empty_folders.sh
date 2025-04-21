#!/bin/bash

# Usage: ./remove_empty_folders.sh /path/to/target-directory

TARGET_DIR="$1"

# Validate input
if [ -z "$TARGET_DIR" ]; then
  echo "Usage: $0 /path/to/target-directory"
  exit 1
fi

if [ ! -d "$TARGET_DIR" ]; then
  echo "Error: '$TARGET_DIR' is not a valid directory."
  exit 1
fi

echo "Removing empty folders (up to 10 levels deep) in '$TARGET_DIR'..."

# Loop to handle nested emptiness up to 10 levels
for i in {1..10}; do
  find "$TARGET_DIR" -maxdepth 10 -type d -empty -print0 | sort -rz | while IFS= read -r -d '' dir; do
    rmdir "$dir" 2>/dev/null || true
  done
done

echo "Done cleaning empty directories up to 10 levels deep."
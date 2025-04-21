#!/bin/bash

# Usage: ./remove_asd_files.sh /path/to/target-directory

TARGET_DIR="$1"

# Check if a directory was provided
if [ -z "$TARGET_DIR" ]; then
  echo "Usage: $0 /path/to/target-directory"
  exit 1
fi

# Check if the directory exists
if [ ! -d "$TARGET_DIR" ]; then
  echo "Error: '$TARGET_DIR' is not a valid directory."
  exit 1
fi

echo "Deleting .wav.asd files in '$TARGET_DIR'..."
find "$TARGET_DIR" -type f -name "*.wav.asd" -print -delete

echo "Deleting .aif.asd files in '$TARGET_DIR'..."
find "$TARGET_DIR" -type f -name "*.aif.asd" -print -delete

echo "Removing empty folders..."
# Repeat removal of empty dirs until none are left (handles nested empty folders)
while read -r dir; do
  rmdir "$dir"
done < <(find "$TARGET_DIR" -type d -empty | sort -r)

echo "Cleanup complete."
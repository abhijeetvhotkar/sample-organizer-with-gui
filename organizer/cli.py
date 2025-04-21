
import argparse
import json
from .mover import organize_samples

def main():
    parser = argparse.ArgumentParser(description="Organize your sample packs.")
    parser.add_argument("input_dir", help="Directory of unsorted samples")
    parser.add_argument("output_dir", help="Destination directory for sorted samples")
    parser.add_argument("--config", help="Optional path to JSON config")
    parser.add_argument("--copy", action="store_true", help="Copy files instead of moving them")

    args = parser.parse_args()
    categories = None

    if args.config:
        with open(args.config, "r") as f:
            categories = json.load(f)

    organize_samples(args.input_dir, args.output_dir, categories, copy_files=args.copy)

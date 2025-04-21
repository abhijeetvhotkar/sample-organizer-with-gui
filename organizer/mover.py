import shutil
from pathlib import Path
from .classifier import classify_sample
from .config import DEFAULT_CATEGORIES

SUPPORTED_AUDIO_EXTENSIONS = ['.wav', '.aiff', '.aif', '.flac', '.mp3', '.m4a']
SUPPORTED_MIDI_EXTENSIONS = ['.mid', '.midi']

def organize_samples(input_dir, output_dir, categories=None, copy_files=False):
    input_path = Path(input_dir)
    output_path = Path(output_dir)
    categories = categories or DEFAULT_CATEGORIES

    for file in input_path.rglob("*"):
        if file.is_file():
            ext = file.suffix.lower()
            if ext in SUPPORTED_AUDIO_EXTENSIONS + SUPPORTED_MIDI_EXTENSIONS:
                category = classify_sample(file.name, categories)
                dest_dir = output_path / category
                dest_dir.mkdir(parents=True, exist_ok=True)

                dest_file = dest_dir / file.name
                if copy_files:
                    print(f"[COPY] {file} -> {dest_file}")
                    shutil.copy2(file, dest_file)
                else:
                    print(f"[MOVE] {file} -> {dest_file}")
                    shutil.move(file, dest_file)

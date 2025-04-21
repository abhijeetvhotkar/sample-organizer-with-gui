# 🎧 Sample & MIDI Organizer

Organize your messy sample and MIDI packs into a clean folder hierarchy.

## 🔧 Usage

```bash
python main.py path/to/unsorted path/to/organized
```

Use `--copy` if you don’t want to move the original files.

Supports WAV, AIFF, FLAC, and MIDI files.

Categories include: (see `./organizer/config.py`)
- Drums / OneShots / Loops
- Instruments: Bass, Synth, Guitar, etc.
- MIDI: Arps, Chords, Melodies, Drums, FX, etc.
- Add as many categories you'd like and works best for you.

## ⚠️ Known issue:

- Gui doesn't work properly.
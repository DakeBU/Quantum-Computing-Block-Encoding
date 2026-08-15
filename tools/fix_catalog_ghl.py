#!/usr/bin/env python3
from pathlib import Path

path = Path('scripts/generate-blueprint-catalog.py')
text = path.read_text(encoding='utf-8')
old = '''            "GHL2025.lean",\n            "Papers/GHL2025.lean",'''
new = '''            "GHL2025.lean",\n            "GHLHamiltonian.lean",\n            "Papers/GHL2025.lean",'''
if old in text:
    text = text.replace(old, new, 1)
elif '"GHLHamiltonian.lean"' not in text:
    raise SystemExit('PaperAndExamples catalog anchor missing')
path.write_text(text, encoding='utf-8')

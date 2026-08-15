#!/usr/bin/env python3
from pathlib import Path

path = Path('QuantumBlockEncoding/GHLHamiltonian.lean')
text = path.read_text(encoding='utf-8')
marker = 'noncomputable section\n\n'
lemma = '''noncomputable section\n\n/-- Complex conjugation fixes the real scalar two. -/\n@[simp] theorem conj_two : conj (2 : ℂ) = 2 := by\n  simpa using (Complex.conj_ofNat 2)\n\n'''
if 'theorem conj_two' not in text:
    if marker not in text:
        raise SystemExit('noncomputable-section anchor missing')
    text = text.replace(marker, lemma, 1)
path.write_text(text, encoding='utf-8')

#!/usr/bin/env python3
from pathlib import Path

path = Path('website/scripts/test_site_contracts.py')
text = path.read_text(encoding='utf-8')
old = '        self.assertEqual(status["Arbitrary-n GHL and full Hamiltonian reproduction"], "Experimental")\n'
new = '''        self.assertEqual(status["GHL Theorem 4 A-to-H Hamiltonian composition"], "Compiled")\n        self.assertEqual(status["Arbitrary-width GHL one-term primitive resource compiler"], "Planned")\n        self.assertNotIn("Arbitrary-n GHL and full Hamiltonian reproduction", status)\n'''
if old not in text:
    if 'GHL Theorem 4 A-to-H Hamiltonian composition' not in text:
        raise SystemExit('stale GHL roadmap assertion anchor missing')
else:
    text = text.replace(old, new, 1)
path.write_text(text, encoding='utf-8')

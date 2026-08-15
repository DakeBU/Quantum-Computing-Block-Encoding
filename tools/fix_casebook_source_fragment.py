#!/usr/bin/env python3
from pathlib import Path

path = Path('website/scripts/enrich_casebook.py')
text = path.read_text(encoding='utf-8')
old = '''    old = match.group(0).replace("Source interpretation decisions", "Advanced source-fidelity notes")
    wrapped = (
        '<details class="advanced-source-audit" id="source-interpretation">'
'''
new = '''    old = match.group(0).replace("Source interpretation decisions", "Advanced source-fidelity notes")
    # Keep the public fragment on the outer <details>; remove it from the
    # nested section so every generated page has one unique navigation target.
    old = old.replace(' id="source-interpretation"', '', 1)
    wrapped = (
        '<details class="advanced-source-audit" id="source-interpretation">'
'''
if old not in text:
    if "old = old.replace(' id=\"source-interpretation\"'" not in text:
        raise SystemExit('source audit fragment anchor missing')
else:
    text = text.replace(old, new, 1)
path.write_text(text, encoding='utf-8')

test = Path('website/scripts/test_casebook_enrichment.py')
t = test.read_text(encoding='utf-8')
old_assert = '''            self.assertIn("Advanced source-fidelity notes", robin)
            self.assertNotIn("<h2>Source interpretation decisions</h2>", robin)
'''
new_assert = '''            self.assertIn("Advanced source-fidelity notes", robin)
            self.assertNotIn("<h2>Source interpretation decisions</h2>", robin)
            self.assertEqual(robin.count('id="source-interpretation"'), 1)
'''
if old_assert in t:
    t = t.replace(old_assert, new_assert, 1)
elif "robin.count('id=\"source-interpretation\"')" not in t:
    raise SystemExit('source audit regression anchor missing')
test.write_text(t, encoding='utf-8')

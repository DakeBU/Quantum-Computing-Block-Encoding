#!/usr/bin/env python3
"""Bounded source repairs identified by the real integrated publication replay.

Retain canonical checks on both platforms; never edit the checks to accept a
missing output. No Lean source, mathematical claim or proof report is changed.
"""
from pathlib import Path
import re
import shlex

ROOT = Path(__file__).resolve().parents[2]
path = ROOT / 'scripts/build-website.ps1'
ps = path.read_text(encoding='utf-8')
sh = (ROOT / 'scripts/build-website.sh').read_text(encoding='utf-8')
ps = ps.replace('$publicationBase', '$publication_base')
joined = re.sub(r'\\\r?\n[ \t]*', ' ', sh)
for action in ('py_compile', 'unittest'):
    shell_calls = [shlex.split(line[len('python3 '):]) for line in joined.splitlines()
                   if line.startswith('python3 -m ' + action + ' ')]
    # The large canonical check lists were already behind on the Windows path.
    for call in shell_calls:
        if len(call) < 5:
            continue
        replacement = '& $PythonCommand ' + ' `\n  '.join(call)
        pattern = r'& \$PythonCommand -m ' + action + r' `\n(?:[^\n]*`\n)*[^\n]*\n(?=if \(\$LASTEXITCODE)'
        matches = list(re.finditer(pattern, ps))
        if len(matches) != 1:
            raise SystemExit(f'ambiguous native {action} gate; manual inspection required')
        ps = re.sub(pattern, lambda _: replacement + '\n', ps, count=1)
checks = []
for line in sh.splitlines():
    if line.startswith('test -f '):
        target = shlex.split(line)[-1]
        if '$' not in target and target not in ps:
            checks.append('Assert-NonemptyFile "' + target + '"')
    if line.startswith(('grep -', '! grep -')):
        marker, target = shlex.split(line)[-2:]
        search = marker.replace('ö', '{0}') if 'Möttönen' in marker else marker
        if search not in ps:
            if "'" in marker or 'Möttönen' in marker:
                raise SystemExit('new marker needs an explicit native encoding adapter')
            checks.append('Assert-PageMarker "' + target + '" \'' + marker + "'" + (' $true' if line.startswith('! ') else ''))
if checks:
    anchor = '$graph = Get-Content -LiteralPath "_site/data/lean-graph.json"'
    if ps.count(anchor) != 1:
        raise SystemExit('native assertion insertion anchor changed')
    ps = ps.replace(anchor, '# Preserve every canonical final-output assertion.\n' + '\n'.join(checks) + '\n\n' + anchor, 1)
path.write_text(ps, encoding='utf-8')

path = ROOT / 'website/scripts/research_atlas.py'
text = path.read_text(encoding='utf-8')
if 'from urllib.parse import quote' not in text:
    text = text.replace('from typing import Any\n', 'from typing import Any\nfrom urllib.parse import quote\n')
if 'Locate the same declaration in the Lean graph' not in text:
    anchor = '        source = str(item["source"])\n'
    assert text.count(anchor) == 1
    text = text.replace(anchor, '        focus = quote("declaration:" + name, safe="")\n' +
        '        content += f\'<p class="ra-boundary"><a href="{prefix}lean-graph/index.html?focus={focus}">Locate the same declaration in the Lean graph</a></p>\'\n' + anchor)
text = text.replace('for filename in ("research-atlas.css", "research-atlas.js"):',
                    'for filename in ("research-atlas.css", "research-atlas.js", "research-focus.js"):')
if 'src="../static/research-focus.js"' not in text:
    anchor = '    graph_page.write_text(text, encoding="utf-8")\n'
    assert text.count(anchor) == 1
    text = text.replace(anchor, '    if "research-focus.js" not in text:\n' +
        '        text = text.replace("</body>", \'<script src="../static/research-focus.js" defer></script></body>\', 1)\n' + anchor)
path.write_text(text, encoding='utf-8')
print('Repaired native parity and bound mechanism links to exact existing graph identities.')

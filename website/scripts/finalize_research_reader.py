#!/usr/bin/env python3
"""Bounded reader/evidence-integrity refinements, applied before final replay."""
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]


def edit(name, old, new):
    path = ROOT / name
    text = path.read_text(encoding='utf-8')
    if new in text:
        return
    if text.count(old) != 1:
        raise SystemExit(f'expected a unique inspected anchor in {name}: {old[:80]!r}')
    path.write_text(text.replace(old, new, 1), encoding='utf-8')

path = ROOT / 'website/scripts/test_research_browser.py'
s = path.read_text(encoding='utf-8')
s = s.replace('"window.MathJax && window.MathJax.startup && window.MathJax.startup.promise"',
              '"Boolean(window.MathJax && window.MathJax.startup && window.MathJax.startup.promise)"')
path.write_text(s, encoding='utf-8')

edit('website/scripts/check_research_publications.py',
     '    sources = load(root, "website/research/sources.json")["sources"]\n',
     '    # Bind local ambient definitions too: imports/private helpers in another\n'
     '    # production module must not leave an old semantic review apparently fresh.\n'
     '    for directory in ("QuantumBlockEncoding", "ABEISTests"):\n'
     '        for path in sorted((root / directory).rglob("*.lean")):\n'
     '            digest.update(path.relative_to(root).as_posix().encode())\n'
     '            digest.update(path.read_bytes())\n'
     '    sources = load(root, "website/research/sources.json")["sources"]\n')
edit('website/scripts/check_research_publications.py',
     '        local_file(root, evidence["artifact_path"])\n',
     '        artifact = local_file(root, evidence["artifact_path"])\n'
     '        if hashlib.sha256(artifact.read_bytes()).hexdigest() != evidence.get("artifact_sha256"):\n'
     '            raise ValueError("independent result artifact has changed")\n')
edit('website/scripts/check_research_publications.py',
     '    if decoder.get("source_blind") is not True or not decoder.get("reconstruction"):\n',
     '    decoder_hash = hashlib.sha256(local_file(root, record["decoder_evidence"]).read_bytes()).hexdigest()\n'
     '    if reviewer.get("decoder_evidence_sha256") != decoder_hash:\n'
     '        raise ValueError("reviewer is not bound to the exact decoder result")\n'
     '    if decoder.get("source_blind") is not True or not decoder.get("reconstruction"):\n')
edit('website/scripts/test_research_atlas.py',
     '    def flush(self):\n        self.write_json("decoder.json", self.decoder)\n        self.write_json("reviewer.json", self.reviewer)\n',
     '    def flush(self):\n'
     '        for evidence in (self.decoder, self.reviewer):\n'
     '            evidence["artifact_sha256"] = hashlib.sha256((self.root / evidence["artifact_path"]).read_bytes()).hexdigest()\n'
     '        self.write_json("decoder.json", self.decoder)\n'
     '        self.reviewer["decoder_evidence_sha256"] = hashlib.sha256((self.root / "decoder.json").read_bytes()).hexdigest()\n'
     '        self.write_json("reviewer.json", self.reviewer)\n')
edit('website/scripts/test_research_atlas.py',
     '    def test_evidence_path_traversal_rejected(self):\n',
     '    def test_decoder_result_cannot_change_after_review(self):\n'
     '        self.decoder["reconstruction"] = "A different statement"\n'
     '        self.write_json("decoder.json", self.decoder)\n'
     '        with self.assertRaisesRegex(ValueError, "exact decoder result"):\n'
     '            publication.validate_record(self.root, self.record, self.inventory)\n\n'
     '    def test_review_result_bytes_are_bound(self):\n'
     '        self.write("review-artifact.txt", "Changed verdict or reasoning")\n'
     '        with self.assertRaisesRegex(ValueError, "artifact has changed"):\n'
     '            publication.validate_record(self.root, self.record, self.inventory)\n\n'
     '    def test_changed_local_dependency_invalidates_context(self):\n'
     '        self.write("QuantumBlockEncoding/Other.lean", "def ambient := False")\n'
     '        with self.assertRaisesRegex(ValueError, "stale"):\n'
     '            publication.validate_record(self.root, self.record, self.inventory)\n\n'
     '    def test_evidence_path_traversal_rejected(self):\n')

path = ROOT / 'website/scripts/research_atlas.py'
s = path.read_text(encoding='utf-8')
start = s.index('def family_latex(')
end = s.index('\ndef context_packet(', start)
replacement = r'''def family_latex(item: dict[str, Any]) -> str:
    def prose(value: str) -> str:
        mapping = {"\\": r"\textbackslash{}", "&": r"\&", "%": r"\%", "$": r"\$", "#": r"\#", "_": r"\_", "{": r"\{", "}": r"\}", "~": r"\textasciitilde{}", "^": r"\textasciicircum{}"}
        return "".join(mapping.get(char, char) for char in value)
    lines = ["% Authored mechanism lesson; not a new theorem certificate.",
             r"\section*{" + prose(item["label"]) + "}", prose(item["question"]),
             r"\[", tex(item["formula"]), r"\]", prose(item["mechanism"]),
             r"\paragraph{Hypotheses and contracts.}", r"\begin{enumerate}"]
    lines += [r"\item " + prose(value) for value in item["assumptions"]]
    lines += [r"\end{enumerate}", r"\paragraph{Mathematical proof mechanism.}",
              "This is a reusable derivation guide; exact certified scope is given by the linked Lean signatures.", r"\begin{enumerate}"]
    lines += [r"\item " + prose(value) for value in item["proof_steps"]]
    lines += [r"\end{enumerate}", r"\paragraph{Boundary.} " + prose(item["boundary"])]
    return "\n".join(lines) + "\n"

'''
s = s[:start] + replacement + s[end:]
s = s.replace('"research-atlas.js", "research-focus.js"):', '"research-atlas.js", "research-focus.js", "research-delta.js"):')
s = s.replace('extra_scripts=("static/research-atlas.js",))', 'extra_scripts=("static/research-atlas.js", "static/research-delta.js"))')
anchor = '        body += \'<details><summary>Added modules at the pinned contribution</summary>\' + paragraphs(delta["added_modules"]) + \'</details>\'\n'
if 'data-ra-delta=' not in s:
    assert s.count(anchor) == 1
    insertion = '''        body += f'<div class="ra-graph-app" data-ra-delta="{esc(c["id"])}"><label>Inspect changed import edges around a module <select data-ra-delta-select aria-label="Module in contribution delta"></select></label><div class="ra-graph-stage" style="max-height:620px"><svg data-ra-delta-svg role="img" aria-label="Pinned module import contribution delta"></svg></div><p data-ra-delta-status aria-live="polite">Loading the computed Git delta; complete source data is linked below.</p><p class="ra-legend">Solid lines: added imports. Dashed lines: removed imports. This is the changed module-import neighborhood, not a theorem proof graph or an automatically inferred novelty classification.</p></div>'
'''
    s = s.replace(anchor, insertion + anchor)
path.write_text(s, encoding='utf-8')
print('Bound ambient definitions and review-result bytes; enabled usable LaTeX export and actual contribution-delta view.')

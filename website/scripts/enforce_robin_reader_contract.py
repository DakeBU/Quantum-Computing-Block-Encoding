#!/usr/bin/env python3
"""Enforce the beginner-first Robin paper -> proof -> Lean reading contract.

`enrich_casebook.py` builds the general theorem-first tutorial.  This final pass
adds two Robin-specific layers that must not be inferred from low-level audit
prose:

1. the exact scope correspondence between each source theorem and the Lean
   formalization, and
2. structured source assumptions in the form
   paper/source statement -> plain-language meaning -> why it matters -> Lean evidence.

The pass also checks the final DOM ordering.  A future renderer refactor may
change styling, but it may not silently move raw source-audit jargon back ahead
of the mathematical story.
"""

from __future__ import annotations

import argparse
import html
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
# Support both `python -m website.scripts.enforce_robin_reader_contract` and
# direct execution from the repository root as used by the Pages workflow.
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

from website.scripts import enrich_casebook as casebook  # noqa: E402


TEACHING_PATH = ROOT / "website" / "case-teaching.json"
ROBIN_SLUG = "robin-ghl-one-term"


def robin_record() -> dict[str, object]:
    data = casebook.load_json(TEACHING_PATH)
    return dict(data["cases"][ROBIN_SLUG])


def validate_data(
    teaching: dict[str, object], declarations: dict[str, dict[str, object]]
) -> None:
    source = dict(teaching.get("source") or {})
    if "O_H" not in str(source.get("queryFormula", "")):
        raise RuntimeError("Robin reader contract lost the digital query-oracle formula")
    if "oracle" not in str(source.get("queryExplanation", "")).lower():
        raise RuntimeError("Robin reader contract lost the query-oracle explanation")

    theorems = [dict(item) for item in teaching.get("theorems", [])]
    if len(theorems) != 2:
        raise RuntimeError("Robin reader contract requires exactly the source Theorem 3 and 4 cards")
    labels = [str(item.get("label", "")) for item in theorems]
    if not any("Theorem 3" in label for label in labels):
        raise RuntimeError("Robin reader contract lost GHL Theorem 3")
    if not any("Theorem 4" in label for label in labels):
        raise RuntimeError("Robin reader contract lost GHL Theorem 4")
    for theorem in theorems:
        if len(theorem.get("proofSteps", [])) < 5:
            raise RuntimeError(f"source theorem proof story became too thin: {theorem.get('label')}")
        if not str(theorem.get("formalizationScope", "")).strip():
            raise RuntimeError(f"source theorem lost its Lean-scope boundary: {theorem.get('label')}")
        for root in theorem.get("leanRoots", []):
            if root not in declarations:
                raise RuntimeError(f"unknown Lean root in Robin theorem alignment: {root}")

    assumptions = [dict(item) for item in teaching.get("sourceAssumptions", [])]
    if len(assumptions) < 6:
        raise RuntimeError("Robin reader contract requires structured source assumptions")
    for item in assumptions:
        for key in ("title", "paperAssumption", "plainLanguage", "whyItMatters"):
            if not str(item.get(key, "")).strip():
                raise RuntimeError(f"Robin source assumption missing {key}: {item.get('title')}")
        roots = list(item.get("leanEvidence", []))
        if not roots:
            raise RuntimeError(f"Robin source assumption has no Lean evidence: {item.get('title')}")
        for root in roots:
            if root not in declarations:
                raise RuntimeError(f"unknown Lean root in Robin source assumption: {root}")

    improvement = dict(teaching.get("improvement") or {})
    formula = str(improvement.get("statementFormula", ""))
    for token in ("106,96,3,0", "312,266,5,0", "881,674,6,0"):
        if token not in formula:
            raise RuntimeError(f"Robin T3 comparison lost resource tuple {token}")
    for root in improvement.get("leanRoots", []):
        if root not in declarations:
            raise RuntimeError(f"unknown Lean root in Robin improvement: {root}")


def theorem_alignment_html(
    teaching: dict[str, object],
    declarations: dict[str, dict[str, object]],
    prefix: str,
) -> str:
    cards: list[str] = []
    for theorem in teaching["theorems"]:
        theorem = dict(theorem)
        cards.append(
            f"""<article class="casebook-theorem robin-alignment-card">
  <p class="eyebrow">{html.escape(str(theorem['label']))} · paper scope → Lean scope</p>
  <h3>{html.escape(str(theorem['title']))}</h3>
  <p>{html.escape(str(theorem['formalizationScope']))}</p>
  {casebook.lean_details(list(theorem['leanRoots']), declarations, prefix, 'Show the Lean alignment roots')}
</article>"""
        )
    return f"""<section class="casebook-subsection" id="paper-lean-alignment">
  <p class="eyebrow">Do not overread the formalization</p>
  <h2>Paper theorem → exact Lean scope</h2>
  <p class="casebook-lead">The source theorem and the machine-checked theorem do not automatically have the same scope. These cards state exactly which layer is closed and which general compiler statement remains separate.</p>
  {''.join(cards)}
</section>"""


def source_assumptions_html(
    teaching: dict[str, object],
    declarations: dict[str, dict[str, object]],
    prefix: str,
) -> str:
    cards: list[str] = []
    for item in teaching["sourceAssumptions"]:
        item = dict(item)
        cards.append(
            f"""<article class="casebook-theorem robin-assumption-card">
  <h3>{html.escape(str(item['title']))}</h3>
  <p><strong>Paper assumption / source issue.</strong> {html.escape(str(item['paperAssumption']))}</p>
  <p><strong>Plain language.</strong> {html.escape(str(item['plainLanguage']))}</p>
  <p><strong>Why it matters.</strong> {html.escape(str(item['whyItMatters']))}</p>
  {casebook.lean_details(list(item['leanEvidence']), declarations, prefix, 'Show the Lean evidence')}
</article>"""
        )
    return f"""<section class="casebook-subsection" id="source-assumption-translation">
  <p class="eyebrow">Paper assumption → plain language → Lean evidence</p>
  <h2>Source conventions translated before the audit log</h2>
  <p class="casebook-lead">These are the conventions that change the mathematical or resource contract. Read the explanation first; the raw transcription and implementation audit remains collapsed later on the page.</p>
  {''.join(cards)}
</section>"""


def inject_contract(
    path: Path,
    prefix: str,
    teaching: dict[str, object],
    declarations: dict[str, dict[str, object]],
) -> None:
    if not path.is_file():
        raise RuntimeError(f"Robin reader-contract page missing: {path}")
    text = path.read_text(encoding="utf-8")
    marker = '<section class="casebook-improvement" id="case-improvement">'
    if marker not in text:
        raise RuntimeError(f"Robin page lost the ASPBE improvement theorem: {path}")
    if 'id="paper-lean-alignment"' not in text:
        fragment = theorem_alignment_html(teaching, declarations, prefix)
        fragment += source_assumptions_html(teaching, declarations, prefix)
        text = text.replace(marker, fragment + "\n" + marker, 1)
    path.write_text(text, encoding="utf-8")
    validate_rendered(path)


def validate_rendered(path: Path) -> None:
    text = path.read_text(encoding="utf-8")
    ordered = [
        "Source-paper motivation",
        "GHL Theorem 3",
        "GHL Theorem 4",
        'id="paper-lean-alignment"',
        'id="source-assumption-translation"',
        "What ASPBE improves",
        "Advanced source-fidelity notes",
    ]
    positions: list[int] = []
    for token in ordered:
        pos = text.find(token)
        if pos < 0:
            raise RuntimeError(f"Robin reader contract missing {token!r}: {path}")
        positions.append(pos)
    if positions != sorted(positions):
        raise RuntimeError(f"Robin reader contract order regressed: {path}")
    if "<h2>Source interpretation decisions</h2>" in text:
        raise RuntimeError(f"raw source-audit heading escaped into the novice path: {path}")
    for label in ("Paper assumption / source issue.", "Plain language.", "Why it matters."):
        if text.count(label) < 6:
            raise RuntimeError(f"Robin source-assumption translation lost {label}: {path}")


def enforce(root: Path) -> None:
    teaching = robin_record()
    declarations = casebook.declaration_map()
    validate_data(teaching, declarations)
    inject_contract(
        root / "example-cases" / ROBIN_SLUG / "index.html",
        "../../",
        teaching,
        declarations,
    )
    inject_contract(
        root / "case-studies" / "robin" / "index.html",
        "../",
        teaching,
        declarations,
    )


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--root", type=Path, required=True)
    args = parser.parse_args()
    enforce(args.root)


if __name__ == "__main__":
    main()

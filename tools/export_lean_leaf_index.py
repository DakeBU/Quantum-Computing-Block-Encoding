#!/usr/bin/env python3
"""Export a compact index of ABEIS Lean declarations.

The graph in README should stay readable, so this script writes the complete
machine/human declaration ledger that backs the picture.
"""

from __future__ import annotations

import json
import re
from dataclasses import dataclass
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
OUT_DIR = ROOT / "research-wiki" / "block-encoding-library"
MD_OUT = OUT_DIR / "compiled-lean-leaf-index.md"
JSON_OUT = OUT_DIR / "compiled-lean-leaf-index.json"

LEAN_FILES = [
    "QuantumBlockEncoding/Core.lean",
    "QuantumBlockEncoding/Resources.lean",
    "QuantumBlockEncoding/Circuit.lean",
    "QuantumBlockEncoding/BlockEncoding.lean",
    "QuantumBlockEncoding/StatePreparation.lean",
    "QuantumBlockEncoding/CircuitSemantics.lean",
    "QuantumBlockEncoding/BlockEncodingClassics.lean",
    "QuantumBlockEncoding/MainCase.lean",
    "QuantumBlockEncoding/CubicStatePreparation.lean",
    "QuantumBlockEncoding/GHL2025.lean",
    "QuantumBlockEncoding/Examples/RobinHeat.lean",
    "QuantumBlockEncoding/Papers/GHL2025.lean",
    "QuantumBlockEncoding/TechnicalLemmas.lean",
    "QuantumBlockEncoding/Literature.lean",
    "QuantumBlockEncoding/OpenProblems.lean",
    "QuantumBlockEncoding/Automation.lean",
]

DECL_RE = re.compile(
    r"^(?:@[^\n]+\s+)?(?:noncomputable\s+)?"
    r"(def|theorem|lemma|structure|class|inductive|abbrev)\s+([A-Za-z0-9_'.]+)"
)


@dataclass
class Decl:
    kind: str
    name: str
    line: int


def declarations(path: Path) -> list[Decl]:
    if not path.exists():
        return []
    out: list[Decl] = []
    for i, line in enumerate(path.read_text(encoding="utf-8").splitlines(), start=1):
        stripped = line.strip()
        match = DECL_RE.match(stripped)
        if match:
            out.append(Decl(kind=match.group(1), name=match.group(2), line=i))
    return out


def main() -> None:
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    records = []
    total = 0
    for rel in LEAN_FILES:
        path = ROOT / rel
        decls = declarations(path)
        total += len(decls)
        records.append(
            {
                "file": rel,
                "count": len(decls),
                "declarations": [
                    {"kind": d.kind, "name": d.name, "line": d.line} for d in decls
                ],
            }
        )

    JSON_OUT.write_text(json.dumps({"total": total, "files": records}, indent=2), encoding="utf-8")

    lines: list[str] = []
    lines.append("# Compiled Lean Leaf Index")
    lines.append("")
    lines.append("This generated index backs `abeis_lean_leaf_module_graph.svg` and its PNG copy.")
    lines.append("It lists ABEIS declarations by file so upper/middle agents can")
    lines.append("retrieve existing leaves before asking lower workers to reprove them.")
    lines.append("")
    lines.append(f"Total declarations indexed: **{total}**.")
    lines.append("")
    lines.append("| File | Count | Role |")
    lines.append("| --- | ---: | --- |")
    roles = {
        "QuantumBlockEncoding/Core.lean": "core expression trees, matrices, stencils",
        "QuantumBlockEncoding/Resources.lean": "resource and schedule accounting",
        "QuantumBlockEncoding/Circuit.lean": "gate/circuit syntax",
        "QuantumBlockEncoding/BlockEncoding.lean": "target, candidate, verified records",
        "QuantumBlockEncoding/StatePreparation.lean": "first-column state-preparation certificates",
        "QuantumBlockEncoding/CircuitSemantics.lean": "evaluated matrix/path and extraction lemmas",
        "QuantumBlockEncoding/BlockEncodingClassics.lean": "classic reusable block-encoding leaves",
        "QuantumBlockEncoding/MainCase.lean": "main transfer-operator certificates",
        "QuantumBlockEncoding/CubicStatePreparation.lean": "diagonal/rank-one cubic oracle candidates",
        "QuantumBlockEncoding/GHL2025.lean": "GHL paper-baseline declarations",
        "QuantumBlockEncoding/Examples/RobinHeat.lean": "Robin heat example wrappers",
        "QuantumBlockEncoding/Papers/GHL2025.lean": "GHL paper re-export surface",
        "QuantumBlockEncoding/TechnicalLemmas.lean": "technical lemma re-export surface",
        "QuantumBlockEncoding/Literature.lean": "literature registry",
        "QuantumBlockEncoding/OpenProblems.lean": "open-problem registry",
        "QuantumBlockEncoding/Automation.lean": "harness/process contracts",
    }
    for rec in records:
        lines.append(f"| `{rec['file']}` | {rec['count']} | {roles.get(rec['file'], '')} |")
    lines.append("")

    for rec in records:
        lines.append(f"## `{rec['file']}`")
        lines.append("")
        if not rec["declarations"]:
            lines.append("_No declarations indexed._")
            lines.append("")
            continue
        lines.append("| Line | Kind | Declaration |")
        lines.append("| ---: | --- | --- |")
        for d in rec["declarations"]:
            lines.append(f"| {d['line']} | `{d['kind']}` | `{d['name']}` |")
        lines.append("")

    lines.append("## External Lean Reference Surfaces")
    lines.append("")
    lines.append("External quantum Lean libraries are indexed as memory cards rather than")
    lines.append("copied into the declaration ledger:")
    lines.append("")
    lines.append("- `research-wiki/external-lean-libraries/quantum-computing-lean.md`")
    lines.append("- `research-wiki/external-lean-libraries/lean-quantuminfo.md`")
    lines.append("- `research-wiki/external-lean-libraries/lean-quantum.md`")
    lines.append("- `research-wiki/mathlib-lemmas/`")
    lines.append("")
    MD_OUT.write_text("\n".join(lines), encoding="utf-8")


if __name__ == "__main__":
    main()

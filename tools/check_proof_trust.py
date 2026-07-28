#!/usr/bin/env python3
"""Reject unapproved Lean proof holes and source-level axioms."""

from __future__ import annotations

import argparse
from pathlib import Path

try:
    from proof_trust import TrustFinding, scan_repository
except ModuleNotFoundError:
    from tools.proof_trust import TrustFinding, scan_repository


APPROVED_SORRIES = {
    (
        Path("QuantumBlockEncoding/RobinMatrix.lean"),
        "oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3",
    ),
    (
        Path("QuantumBlockEncoding/RobinMatrix.lean"),
        "oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3",
    ),
}


def is_approved(finding: TrustFinding) -> bool:
    return (
        finding.token == "sorry"
        and (finding.path, finding.declaration) in APPROVED_SORRIES
    )


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--root",
        type=Path,
        default=Path(__file__).resolve().parents[1],
        help="ABEIS repository root",
    )
    args = parser.parse_args()
    root = args.root.resolve()
    findings = scan_repository(root)
    rejected = [finding for finding in findings if not is_approved(finding)]
    approved = [finding for finding in findings if is_approved(finding)]
    if rejected:
        print("proof-trust gate failed:")
        for finding in rejected:
            owner = finding.declaration or "<no declaration>"
            print(
                f"  {finding.path}:{finding.line}: "
                f"{finding.token} in {owner}"
            )
        return 1
    print(
        "proof-trust gate passed: "
        f"{len(approved)} approved experimental sorry occurrence(s), "
        "0 unapproved holes, 0 source-level axioms"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

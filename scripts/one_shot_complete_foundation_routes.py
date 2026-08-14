#!/usr/bin/env python3
"""One-shot deterministic migration for proof-backed foundation route metadata."""

from __future__ import annotations

from pathlib import Path


def add_import(path: Path, import_line: str) -> None:
    text = path.read_text(encoding="utf-8")
    line = import_line.rstrip() + "\n"
    if line not in text:
        path.write_text(text.rstrip() + "\n" + line, encoding="utf-8", newline="\n")


def replace_once(text: str, old: str, new: str, label: str) -> str:
    if old not in text:
        raise SystemExit(f"migration anchor not found: {label}")
    return text.replace(old, new, 1)


def patch_generator() -> None:
    path = Path("scripts/generate-blueprint-catalog.py")
    text = path.read_text(encoding="utf-8")

    catalog_anchor = '            "TeachingRouteClosures.lean",\n'
    catalog_entry = '            "RouteClosureCertificates.lean",\n'
    if catalog_entry not in text:
        text = replace_once(
            text,
            catalog_anchor,
            catalog_anchor + catalog_entry,
            "Semantics catalog",
        )

    old_classifier = '''def route_status(decl: Declaration) -> str:
    if decl.open_proof:
        return "Blocked"
    if decl.experimental:
        return "Experimental"
    if decl.source.endswith("OpenProblems.lean"):
        return "Planned"
    if decl.source.endswith(
        ("GHL2025.lean", "RobinEvolution.lean", "Automation.lean", "Literature.lean")
    ):
        return "Partial route"
    if decl.kind in {"structure", "class", "opaque"}:
        return "Partial route"
    return "Compiled"
'''
    new_classifier = '''PARTIAL_ROUTE_SOURCES = {
    "QuantumBlockEncoding/GHL2025.lean",
}

PARTIAL_ROUTE_DECLARATIONS = {
    "QuantumBlockEncoding.CubicDiagonalOracle.primitiveAmplitudeOracleUnitary",
    "QuantumBlockEncoding.CubicDiagonalOracle.primitiveAmplitudeOracleIsUnitary",
    "QuantumBlockEncoding.CubicDiagonalOracle.primitiveAmplitudeOracleCleanBlockExtracts",
    "QuantumBlockEncoding.CubicDiagonalOracle.expandedArithmeticComputesCubicAmplitude",
    "QuantumBlockEncoding.CubicDiagonalOracle.expandedControlledRyUsesCubicAngle",
    "QuantumBlockEncoding.CubicDiagonalOracle.expandedWorkspaceCleanUncomputed",
    "QuantumBlockEncoding.CubicDiagonalOracle.expandedAmplitudeOracleCleanBlockExtracts",
}


def route_status(decl: Declaration) -> str:
    """Classify route completion from explicit proof scope, never declaration kind."""

    if decl.open_proof:
        return "Blocked"
    if decl.experimental:
        return "Experimental"
    if decl.source.endswith("OpenProblems.lean"):
        return "Planned"
    if (
        decl.source in PARTIAL_ROUTE_SOURCES
        or decl.full_name in PARTIAL_ROUTE_DECLARATIONS
    ):
        return "Partial route"
    return "Compiled"
'''
    if "PARTIAL_ROUTE_SOURCES =" not in text:
        text = replace_once(text, old_classifier, new_classifier, "route classifier")

    path.write_text(text, encoding="utf-8", newline="\n")


def patch_site_tests() -> None:
    path = Path("website/scripts/test_site_contracts.py")
    text = path.read_text(encoding="utf-8")
    method_name = "test_library_route_status_is_proof_rooted"
    if method_name in text:
        return

    marker = (
        "    def test_roadmap_separates_closed_witnesses_from_open_generality(self) -> None:\n"
    )
    method = '''    def test_library_route_status_is_proof_rooted(self) -> None:
        data = json.loads(
            (ROOT / "web/library/declarations.json").read_text(encoding="utf-8")
        )
        declarations = data["declarations"]
        by_name = {item["fullName"]: item for item in declarations}
        for name in (
            "QuantumBlockEncoding.RegisterLayout",
            "QuantumBlockEncoding.StatePreparationTarget",
            "QuantumBlockEncoding.OperatorBlockEncodingCandidate",
            "QuantumBlockEncoding.ExecutableResourceCertificate",
            "QuantumBlockEncoding.ApproximateStatePreparationCandidate.certify",
            "QuantumBlockEncoding.ApproximateOperatorBlockEncodingCandidate.certify",
        ):
            self.assertEqual(by_name[name]["localStatus"], "Compiled", name)
            self.assertEqual(by_name[name]["routeStatus"], "Compiled", name)

        partial = [
            item for item in declarations if item["routeStatus"] == "Partial route"
        ]
        self.assertTrue(partial)
        allowed_opaque = {
            "QuantumBlockEncoding.CubicDiagonalOracle.primitiveAmplitudeOracleUnitary",
            "QuantumBlockEncoding.CubicDiagonalOracle.primitiveAmplitudeOracleIsUnitary",
            "QuantumBlockEncoding.CubicDiagonalOracle.primitiveAmplitudeOracleCleanBlockExtracts",
            "QuantumBlockEncoding.CubicDiagonalOracle.expandedArithmeticComputesCubicAmplitude",
            "QuantumBlockEncoding.CubicDiagonalOracle.expandedControlledRyUsesCubicAngle",
            "QuantumBlockEncoding.CubicDiagonalOracle.expandedWorkspaceCleanUncomputed",
            "QuantumBlockEncoding.CubicDiagonalOracle.expandedAmplitudeOracleCleanBlockExtracts",
        }
        for item in partial:
            self.assertTrue(
                item["source"] == "QuantumBlockEncoding/GHL2025.lean"
                or item["fullName"] in allowed_opaque,
                item["fullName"],
            )

'''
    text = replace_once(text, marker, method + marker, "site contract insertion")
    path.write_text(text, encoding="utf-8", newline="\n")


def main() -> None:
    add_import(
        Path("QuantumBlockEncoding.lean"),
        "import QuantumBlockEncoding.RouteClosureCertificates",
    )
    add_import(Tests := Path("Tests.lean"), "import ABEISTests.RouteClosureCertificates")
    del Tests
    patch_generator()
    patch_site_tests()


if __name__ == "__main__":
    main()

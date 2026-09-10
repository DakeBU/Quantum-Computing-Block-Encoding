#!/usr/bin/env python3
"""Generate the ASPBE declaration catalog with the current public route modules.

`generate-blueprint-catalog.py` remains the generic extractor.  This wrapper owns
project-level catalog membership so generated Blueprint/library/Lean-graph data
is always derived from the current Lean source tree rather than a hand-edited
JSON snapshot.
"""

from __future__ import annotations

import argparse
import importlib.util
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
GENERATOR = ROOT / "scripts" / "generate-blueprint-catalog.py"

STATE_PREP_MODULES = {
    "HermitePolynomial.lean",
    "HermiteSmoothness.lean",
    "RealAmplitudePreparation.lean",
    "HermiteStatePreparation.lean",
    "StatePreparationBenchmarksCoreFixed.lean",
    "StatePreparationPrimitiveRoutes.lean",
    "StatePreparationBellRoute.lean",
    "StatePreparationPaperEntryCertificates.lean",
    "StatePreparationPaperRoutesCompact.lean",
    "StatePreparationPaperRoutes.lean",
    "StatePreparationBenchmarks.lean",
    "ConstructiveHermitePreparation.lean",
    "HermiteBernstein.lean",
    "HermiteBinaryCutoff.lean",
    "HermiteBoundaryInjection.lean",
    "HermiteCutRank.lean",
    "HermiteFiniteChain.lean",
    "HermiteFiniteNorm.lean",
    "HermiteExplicitBond.lean",
    "HermiteIntervalMass.lean",
    "HermitePolynomialPreparation.lean",
    "HermitePolynomialResources.lean",
    "HermiteSampleStructure.lean",
    "HermiteTransferCores.lean",
    "StoredBernstein.lean",
    "StoredHermiteCoefficients.lean",
    "StoredHermiteBoundaries.lean",
    "StoredHermiteChildGeometry.lean",
    "StoredHermiteGeometry.lean",
    "StoredHermiteKernelTable.lean",
    "StoredHermiteRawCost.lean",
    "StoredHermiteRawSource.lean",
    "StoredHermiteSharedTables.lean",
    "StoredHermiteSourceCache.lean",
    "StoredHermiteStageFields.lean",
    "StoredHermiteStageInput.lean",
}

STRUCTURED_SEMANTICS_MODULES = {
    "AdjacentGivens.lean",
    "ConstructiveIsometryCompletion.lean",
    "ConstructiveIsometryLocal.lean",
    "ConstructiveTensorTrain.lean",
    "ConstructiveTensorTrainCompiler.lean",
    "ConstructiveThinLQ.lean",
    "GrayBasis.lean",
    "GrayGivensCompiler.lean",
    "MatrixProductChain.lean",
    "PrimitiveDepthBound.lean",
    "PrimitiveWireRename.lean",
    "RealIsometryCompletion.lean",
    "RectangularGivens.lean",
    "SelectedRyPlane.lean",
    "SelectedRyTrace.lean",
    "SequentialBondPreparation.lean",
    "SequentialPrimitiveAssembly.lean",
    "StoredGivens.lean",
    "StoredIsometryCompletion.lean",
    "StoredRectangularGivens.lean",
    "StoredTensorTrain.lean",
    "StoredTensorTrainNorm.lean",
    "PrimitiveCircuitPerturbation.lean",
    "PrimitiveRyPerturbation.lean",
    "StoredBinaryCoordinates.lean",
    "StoredDyadicSpans.lean",
    "StoredMatrixProductChain.lean",
    "StoredSelectedRyTrace.lean",
    "StoredThinLQ.lean",
    "TensorTrainCanonical.lean",
    "TensorTrainLocalCompiler.lean",
    "TensorTrainNormEnvironment.lean",
    "TensorTrainPrimitivePreparation.lean",
    "TensorTrainSchedule.lean",
    "TensorTrainWord.lean",
    "ThinLQ.lean",
}

SEMANTIC_FIDELITY_MODULES = {
    "SemanticFidelityEvidence.lean",
}


def load_generator():
    spec = importlib.util.spec_from_file_location("aspbe_blueprint_catalog", GENERATOR)
    if spec is None or spec.loader is None:
        raise SystemExit(f"cannot load {GENERATOR}")
    module = importlib.util.module_from_spec(spec)
    # Dataclass and annotation resolution consult sys.modules while the imported
    # generator is being executed. Register the temporary module first so this
    # wrapper behaves like a normal Python import on every supported runner.
    sys.modules[spec.name] = module
    spec.loader.exec_module(module)
    return module


def register_public_modules(module) -> None:
    sources_by_catalog = {
        name: sources for name, _slug, sources in module.CATALOGS
    }
    try:
        sources_by_catalog["Semantics"].update(STRUCTURED_SEMANTICS_MODULES)
        sources_by_catalog["PaperAndExamples"].update(STATE_PREP_MODULES)
        sources_by_catalog["AutomationAndMemory"].update(
            SEMANTIC_FIDELITY_MODULES
        )
    except KeyError as error:
        raise SystemExit(f"required catalog not found: {error.args[0]}") from error

    module.CATALOG_PURPOSES["PaperAndExamples"] = (
        "Paper-facing backend models, source-specific Hermite constructions, "
        "and concrete State Preparation / Robin example artifacts."
    )
    module.CATALOG_PURPOSES["Semantics"] = (
        "Circuit and register semantics, reusable tensor-train and matrix "
        "constructions, and explicit exact-real storage-cost refinements. "
        "Each declaration's hypotheses and conclusion fix its certified scope."
    )
    module.CATALOG_PURPOSES["AutomationAndMemory"] = (
        "Typed controller state, agent contracts, literature memory, open-problem "
        "records, and source-to-Lean semantic-fidelity audits."
    )
    validate_public_modules(module)


def validate_public_modules(module) -> None:
    """Require an explicit, unique chapter for every current source module.

    Validate before rendering or writing any generated files. Checking the
    source tree also catches an unassigned module with no public declarations;
    there is deliberately no catch-all chapter that could hide a missed review.
    """
    actual = {
        path.relative_to(module.SOURCE_ROOT).as_posix()
        for path in module.SOURCE_ROOT.rglob("*.lean")
    }
    owners: dict[str, list[str]] = {}
    for name, _slug, sources in module.CATALOGS:
        for source in sources:
            owners.setdefault(source, []).append(name)
    problems = []
    for source in sorted(actual - owners.keys()):
        problems.append(f"unassigned module: {source}")
    for source in sorted(owners.keys() - actual):
        problems.append(f"catalog module does not exist: {source}")
    for source, names in sorted(owners.items()):
        if len(names) != 1:
            problems.append(f"module assigned more than once: {source} ({', '.join(names)})")
    if problems:
        raise ValueError("invalid catalog module partition:\n" + "\n".join(problems))


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--check",
        action="store_true",
        help="fail if committed/generated files differ from the current source inventory",
    )
    args = parser.parse_args()
    module = load_generator()
    register_public_modules(module)
    return module.generate(args.check)


if __name__ == "__main__":
    raise SystemExit(main())

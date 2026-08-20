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
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
GENERATOR = ROOT / "scripts" / "generate-blueprint-catalog.py"

STATE_PREP_MODULES = {
    "StatePreparationBenchmarksCoreFixed.lean",
    "StatePreparationPrimitiveRoutes.lean",
    "StatePreparationBellRoute.lean",
    "StatePreparationPaperEntryCertificates.lean",
    "StatePreparationPaperRoutesCompact.lean",
    "StatePreparationPaperRoutes.lean",
    "StatePreparationBenchmarks.lean",
}


def load_generator():
    spec = importlib.util.spec_from_file_location("aspbe_blueprint_catalog", GENERATOR)
    if spec is None or spec.loader is None:
        raise SystemExit(f"cannot load {GENERATOR}")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def register_public_modules(module) -> None:
    for name, _slug, sources in module.CATALOGS:
        if name == "PaperAndExamples":
            sources.update(STATE_PREP_MODULES)
            break
    else:
        raise SystemExit("PaperAndExamples catalog not found")

    module.CATALOG_PURPOSES["PaperAndExamples"] = (
        "Paper-facing backend models and concrete State Preparation / Robin "
        "example artifacts."
    )


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

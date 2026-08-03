#!/usr/bin/env bash

set -euo pipefail

python3 tools/qbe.py harness-check
python3 tools/test_proof_trust.py
python3 tools/check_proof_trust.py
python3 tools/check_technical_lemma_registry.py
python3 website/scripts/run_lean_gate.py
python3 scripts/generate-blueprint-catalog.py --check
python3 scripts/test-sanitize-blueprint-paths.py
bash scripts/build-blueprint.sh
bash scripts/build-website.sh

#!/usr/bin/env bash

set -euo pipefail

python3 website/scripts/run_lean_gate.py
python3 scripts/generate-blueprint-catalog.py --check
python3 scripts/test-sanitize-blueprint-paths.py
bash scripts/build-blueprint.sh
bash scripts/build-website.sh


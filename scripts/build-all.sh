#!/usr/bin/env bash

set -euo pipefail

if [[ "${QBE_AGENT_INNER_CYCLE:-0}" == "1" ]]; then
  echo "build-all is disabled inside an ASPBE agent cycle; use the controller gate" >&2
  exit 64
fi

python3 tools/qbe.py harness-check
python3 tools/test_proof_trust.py
python3 tools/check_proof_trust.py
python3 tools/check_technical_lemma_registry.py
python3 -m unittest website.scripts.test_site_contracts tools.test_case_memory tools.test_robin_export
python3 website/scripts/run_lean_gate.py
python3 tools/replay_public_cases.py
python3 tools/export_robin_evolution.py --task QBE-ROBIN-BE-WARM-001 --arm warm
python3 scripts/generate-blueprint-catalog.py --check
python3 scripts/test-sanitize-blueprint-paths.py
bash scripts/build-blueprint.sh
bash scripts/build-website.sh

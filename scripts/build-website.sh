#!/usr/bin/env bash

set -euo pipefail

test -f _out/lean-gate.json
test -f _out/blueprint/html-multi/index.html

python3 -m py_compile \
  website/scripts/build_site.py \
  website/scripts/enrich_teaching_site.py \
  website/scripts/enrich_casebook.py \
  website/scripts/polish_casebook.py \
  website/scripts/check_site.py \
  website/scripts/ide_server.py \
  website/scripts/qbe_task_runner.py \
  website/scripts/test_site_contracts.py \
  website/scripts/test_teaching_enrichment.py \
  website/scripts/test_casebook_enrichment.py \
  tools/export_robin_evolution.py \
  tools/replay_public_cases.py

python3 -m unittest \
  website.scripts.test_site_contracts \
  website.scripts.test_teaching_enrichment \
  website.scripts.test_casebook_enrichment

python3 website/scripts/build_site.py \
  --lean-gate-report _out/lean-gate.json \
  --output _out/site

python3 website/scripts/enrich_teaching_site.py --root _out/site
python3 website/scripts/enrich_casebook.py --root _out/site
python3 website/scripts/polish_casebook.py --root _out/site

rm -rf _site
mkdir -p _site/blueprint
cp -a _out/site/. _site/
cp -a _out/blueprint/. _site/blueprint/
touch _site/.nojekyll

python3 website/scripts/check_site.py --root _site --require-blueprint
python3 website/scripts/check_source_links.py --root _site
python3 website/scripts/test_preview.py
python3 scripts/sanitize-blueprint-paths.py --scan-only _site

test -f _site/index.html
test -f _site/library/index.html
test -f _site/blueprint/html-multi/index.html
test -f _site/search-index.json
test -f _site/example-cases/index.html
test -f _site/data/example-cases.json
test -f _site/static/learning.css
test -f _site/static/casebook.css
grep -q 'id="start-here"' _site/learning/index.html
grep -q 'id="quantum-access-models"' _site/learning/index.html
grep -q 'Digital query oracle' _site/learning/index.html
grep -q 'How to read a quantum circuit' _site/learning/index.html
grep -q 'data-reader-mode-choice="concept"' _site/chapters/block-encoding/index.html
grep -q 'data-reader-mode-choice="lean"' _site/chapters/state-preparation/index.html
grep -q 'id="case-tutorial"' _site/example-cases/robin-ghl-one-term/index.html
grep -q 'GHL Theorem 3' _site/example-cases/robin-ghl-one-term/index.html
grep -q 'GHL Theorem 4' _site/example-cases/robin-ghl-one-term/index.html
grep -q 'What ASPBE improves' _site/example-cases/robin-ghl-one-term/index.html
grep -q 'Advanced source-fidelity notes' _site/example-cases/robin-ghl-one-term/index.html
grep -q 'data-collapsed-section="lean-certificate"' _site/example-cases/robin-ghl-one-term/index.html
grep -q 'data-collapsed-section="correspondence"' _site/case-studies/robin/index.html
! grep -q '<h2>Source interpretation decisions</h2>' _site/example-cases/robin-ghl-one-term/index.html
test -f _site/.nojekyll

echo "QuantumComputinglib assembled at _site/index.html"

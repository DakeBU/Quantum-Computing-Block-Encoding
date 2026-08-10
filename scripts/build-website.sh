#!/usr/bin/env bash

set -euo pipefail

test -f _out/lean-gate.json
test -f _out/blueprint/html-multi/index.html

python3 -m py_compile \
  website/scripts/build_site.py \
  website/scripts/check_site.py \
  website/scripts/ide_server.py \
  website/scripts/qbe_task_runner.py

python3 website/scripts/build_site.py \
  --lean-gate-report _out/lean-gate.json \
  --output _out/site

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
test -f _site/.nojekyll

echo "QuantumComputinglib assembled at _site/index.html"

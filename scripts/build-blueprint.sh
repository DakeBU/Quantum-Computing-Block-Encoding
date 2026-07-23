#!/usr/bin/env bash

set -euo pipefail

python3 scripts/generate-blueprint-catalog.py --check
lake build ABEISBlueprint.Assembly:olean

rm -rf _out/blueprint
lake lean ABEISBlueprintMain.lean -- \
  --run ABEISBlueprintMain.lean --output _out/blueprint

python3 scripts/sanitize-blueprint-paths.py _out/blueprint

test -f _out/blueprint/html-multi/index.html
test -f _out/blueprint/html-multi/xref.json

chapters=(
  overview
  foundations
  routes
  case-studies
  catalog-foundations
  catalog-semantics
  catalog-classic-routes
  catalog-certified-cases
  catalog-cubic
  catalog-paper-and-examples
  catalog-automation-and-memory
  catalog-experimental-robin-matrix
)

for chapter in "${chapters[@]}"; do
  test -f "_out/blueprint/html-multi/$chapter/index.html"
done

# The style picker is provided by Verso Blueprint itself.  Keeping this gate
# catches accidental replacement with a plain Manual renderer.
grep -q 'blueprint' _out/blueprint/html-multi/index.html
grep -q 'modern' _out/blueprint/html-multi/index.html
grep -q 'bold' _out/blueprint/html-multi/index.html

#!/usr/bin/env bash

set -euo pipefail

python3 scripts/generate-aspbe-catalog.py
python3 scripts/generate-aspbe-catalog.py --check
lake build ABEISBlueprint.Assembly:olean

rm -rf _out/blueprint
lake lean ABEISBlueprintMain.lean -- \
  --run ABEISBlueprintMain.lean --without-preview-data --output _out/blueprint

mkdir -p _out/blueprint/html-multi/assets
cp web/assets/abeis-evidence-pipeline.svg _out/blueprint/html-multi/assets/
cp web/assets/abeis-library-map.svg _out/blueprint/html-multi/assets/

python3 scripts/sanitize-blueprint-paths.py _out/blueprint
python3 website/scripts/repair_blueprint_fragments.py _out/blueprint/html-multi
python3 website/scripts/repair_blueprint_fragments.py --check _out/blueprint/html-multi

test -f _out/blueprint/html-multi/index.html
test -f _out/blueprint/html-multi/xref.json
test -f _out/blueprint/html-multi/assets/abeis-evidence-pipeline.svg
test -f _out/blueprint/html-multi/assets/abeis-library-map.svg

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

# The style picker is provided by Verso Blueprint itself. Keeping this gate
# catches accidental replacement with a plain Manual renderer.
grep -q 'blueprint' _out/blueprint/html-multi/index.html
grep -q 'modern' _out/blueprint/html-multi/index.html
grep -q 'bold' _out/blueprint/html-multi/index.html

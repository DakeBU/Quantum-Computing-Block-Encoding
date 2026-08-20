#!/usr/bin/env bash

set -euo pipefail

test -f _out/lean-gate.json
test -f _out/blueprint/html-multi/index.html

# The declaration inventory is generated from the exact current Lean checkout.
# This keeps the Library Explorer, Blueprint, and Underlying Lean Graph aligned
# with newly admitted proof modules instead of relying on a stale JSON snapshot.
python3 scripts/generate-aspbe-catalog.py
python3 scripts/generate-aspbe-catalog.py --check

python3 -m py_compile \
  website/scripts/build_site.py \
  website/scripts/lean_graph.py \
  website/scripts/enrich_teaching_site.py \
  website/scripts/enrich_casebook.py \
  website/scripts/enforce_robin_reader_contract.py \
  website/scripts/polish_casebook.py \
  website/scripts/publish_extensions.py \
  website/scripts/publish_paper_pages.py \
  website/scripts/publish_taxonomy.py \
  website/scripts/finalize_taxonomy_navigation.py \
  website/scripts/repair_taxonomy_links.py \
  website/scripts/check_site.py \
  website/scripts/ide_server.py \
  website/scripts/qbe_task_runner.py \
  website/scripts/test_site_contracts.py \
  website/scripts/test_teaching_enrichment.py \
  website/scripts/test_casebook_enrichment.py \
  website/scripts/test_casebook_polish.py \
  tools/export_robin_evolution.py \
  tools/replay_public_cases.py

python3 -m unittest \
  website.scripts.test_site_contracts \
  website.scripts.test_teaching_enrichment \
  website.scripts.test_casebook_enrichment \
  website.scripts.test_casebook_polish

python3 website/scripts/publish_taxonomy.py --check-data

python3 website/scripts/build_site.py \
  --lean-gate-report _out/lean-gate.json \
  --output _out/site

python3 website/scripts/enrich_teaching_site.py --root _out/site
python3 website/scripts/enrich_casebook.py --root _out/site
python3 website/scripts/polish_casebook.py --root _out/site
python3 website/scripts/enforce_robin_reader_contract.py --root _out/site
python3 website/scripts/publish_extensions.py --root _out/site
python3 website/scripts/publish_paper_pages.py --root _out/site
python3 website/scripts/publish_taxonomy.py --root _out/site
python3 website/scripts/finalize_taxonomy_navigation.py --root _out/site
python3 website/scripts/repair_taxonomy_links.py --root _out/site

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
test -f _site/example-cases/state-preparation/index.html
test -f _site/example-cases/block-encoding/index.html
test -f _site/papers/index.html
test -f _site/papers/state-preparation/index.html
test -f _site/papers/block-encoding/index.html
test -f _site/papers/ghl2025-robin/index.html
test -f _site/papers/mottonen-2005-state-preparation/index.html
test -f _site/papers/grover-rudolph-2002/index.html
test -f _site/papers/li-luo-sparse-state-2025/index.html
test -f _site/papers/low-kliuchnikov-schaeffer-2018/index.html
test -f _site/data/example-cases.json
test -f _site/data/papers.json
test -f _site/data/case-source-anchors.json
test -f _site/static/learning.css
test -f _site/static/casebook.css

grep -q 'id="start-here"' _site/learning/index.html
grep -q 'id="quantum-access-models"' _site/learning/index.html
grep -q 'Digital query oracle' _site/learning/index.html
grep -q 'How to read a quantum circuit' _site/learning/index.html
grep -q 'data-reader-mode-choice="concept"' _site/chapters/block-encoding/index.html
grep -q 'data-reader-mode-choice="lean"' _site/chapters/state-preparation/index.html

grep -q 'State Preparation' _site/example-cases/index.html
grep -q 'Block Encoding' _site/example-cases/index.html
grep -q 'State Preparation' _site/papers/index.html
grep -q 'Block Encoding' _site/papers/index.html
grep -q 'data-taxonomy-nav="example-cases"' _site/index.html
grep -q 'data-taxonomy-nav="papers"' _site/index.html
! grep -q 'data-topic-links=' _site/index.html
grep -q 'data-paper="ghl2025-robin" data-topic="block-encoding"' _site/index.html

grep -q 'Source anchor.' _site/example-cases/bell-state-preparation/index.html
grep -q 'Möttönen et al. Eq. (1) + Sec. III' _site/example-cases/bell-state-preparation/index.html
grep -q 'Eq. (6)' _site/example-cases/mottonen-dense-state-preparation/index.html
grep -q 'Fig. 3' _site/example-cases/mottonen-dense-state-preparation/index.html
grep -q 'Grover' _site/example-cases/grover-rudolph-product-state-preparation/index.html
grep -q 'Eq. (1), (3), (6)' _site/example-cases/grover-rudolph-product-state-preparation/index.html
grep -q 'Li' _site/example-cases/sparse-three-state-preparation/index.html
grep -q 'Eq. (1)' _site/example-cases/sparse-three-state-preparation/index.html
grep -q 'Eq. (2)' _site/example-cases/sparse-three-state-preparation/index.html

grep -q 'Eq. (6)' _site/papers/mottonen-2005-state-preparation/index.html
grep -q 'Fig. 3' _site/papers/mottonen-2005-state-preparation/index.html
grep -q 'Eq. (5)' _site/papers/grover-rudolph-2002/index.html
grep -q 'Theorem 1' _site/papers/li-luo-sparse-state-2025/index.html
grep -q 'Table 2' _site/papers/low-kliuchnikov-schaeffer-2018/index.html
grep -q 'Paper reproduction boundary' _site/papers/mottonen-2005-state-preparation/index.html
grep -q 'Paper reproduction boundary' _site/papers/grover-rudolph-2002/index.html
grep -q 'Paper reproduction boundary' _site/papers/li-luo-sparse-state-2025/index.html
grep -q 'Paper reproduction boundary' _site/papers/low-kliuchnikov-schaeffer-2018/index.html

grep -q 'id="case-tutorial"' _site/example-cases/robin-ghl-one-term/index.html
grep -q 'GHL Eq. (9)' _site/example-cases/robin-ghl-one-term/index.html
grep -q 'GHL Theorem 3' _site/example-cases/robin-ghl-one-term/index.html
grep -q 'GHL Theorem 4' _site/example-cases/robin-ghl-one-term/index.html
grep -q 'id="paper-lean-alignment"' _site/example-cases/robin-ghl-one-term/index.html
grep -q 'id="source-assumption-translation"' _site/example-cases/robin-ghl-one-term/index.html
grep -q 'Paper assumption / source issue.' _site/example-cases/robin-ghl-one-term/index.html
grep -q 'Plain language.' _site/example-cases/robin-ghl-one-term/index.html
grep -q 'Why it matters.' _site/example-cases/robin-ghl-one-term/index.html
grep -q 'What ASPBE improves' _site/example-cases/robin-ghl-one-term/index.html
grep -q '106,96,3,0' website/case-teaching.json
grep -q '312,266,5,0' website/case-teaching.json
grep -q '881,674,6,0' website/case-teaching.json
grep -q 'Advanced source-fidelity notes' _site/example-cases/robin-ghl-one-term/index.html
grep -q 'data-collapsed-section="verification-status"' _site/example-cases/robin-ghl-one-term/index.html
grep -q 'data-collapsed-section="lean-certificate"' _site/example-cases/robin-ghl-one-term/index.html
grep -q 'data-collapsed-section="correspondence"' _site/case-studies/robin/index.html
! grep -q '<h2>Source interpretation decisions</h2>' _site/example-cases/robin-ghl-one-term/index.html

test -f _site/lean-graph/index.html
test -f _site/data/lean-graph.json
test -f _site/static/lean-graph.js
test -f _site/static/lean-graph.css
grep -q 'Underlying Lean Graph of Libraries' _site/lean-graph/index.html
grep -q 'Underlying Lean Graph of Libraries' _site/case-studies/robin/index.html
grep -Fq '\(N=8\)' _site/case-studies/robin/index.html
grep -Fq '\(A_k/(\mathcal N_D\mathcal N_f\kappa)\)' _site/case-studies/robin/index.html
! grep -Fq 'A_k/(N_D N_f kappa)' _site/case-studies/robin/index.html
test -f _site/.nojekyll

echo "QuantumComputinglib assembled at _site/index.html"

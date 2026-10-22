# QuantumComputingBench

Graph-grounded quantum-computing QA for training and evaluating specialized
mathematical models, backed by QuantumComputinglib's sources and graph.

Current distribution: **v0.1.0-preview.1**. This is a working public preview,
not complete whole-graph coverage or a newly certified mathematical teacher.
See the [integration/release notes](docs/integration-release-2026-10-22.md).

## What is ready

| Cohort | Current scope | Evidence and use |
| --- | --- | --- |
| Native NL, `nl-v12` + integration admission overlay | 213 retained core IDs from 238 active records; 21 provisional + 4 newly quarantined | Original English knowledge, proof, counterexample and boundary QA; imported source-grounded AI reviews plus integration audit |
| Legacy, `release-v3` | 26 inherited-review diagnostics | Separate public diagnostic cohort, not pooled native training |
| Legacy provisional | 12 repaired/new diagnostics plus 8 other historical candidates | Preserved for review; not released gold |
| Fixed Lean references | 16 checked claims and 3 reference application harnesses | Formal reference evidence, not certification of all NL answers or untrusted predictions |
| Coverage universe | 5,153 nodes with dispositions | A denominator/ledger, not 5,153 questions or completed coverage |

Native evidence remains separated: 60 local-source-supported answers, 53 original
NL bridges and 100 primary-source NL-only answers. Native train/dev/public-test
counts are **74 / 21 / 118**. Nine admitted same-core repairs do not add cores.
The questions require mathematical understanding, not Lean syntax or API recall.

The four integration quarantines concern square roots/instruments, a PPT
dimension boundary, a trace-norm argument/scalar counterexample and a tensor-action
convention. The [bound admission audit](manifests/integration-20261022/admission.json)
retains exact item digests and reasons. Frozen `nl-v12` files and their 217-item
historical admission records remain unchanged; they are not the current gold set.

Cross-cohort semantic core reconciliation and actual external Lean-collaborator
acknowledgment remain pending. We deliberately publish **no aggregate distinct-core
count** and no combined training split. The preview co-releases preserved cohorts;
it does not fabricate shared-core approval.

**Isolated untrusted Lean evaluation: ENV_BLOCKED. Real-model baseline: UNMEASURED.**
Source inspection, successful execution, useful progress, formal correctness and
faithful NL explanation are different evidence classes.

## Quick start

Use Python 3.11 and a full Git checkout, not a source ZIP without history:

```bash
python -m pip install -r benchmarks/quantumcomputingbench/requirements.txt
python -m unittest discover -s benchmarks/quantumcomputingbench/tests -v
python benchmarks/quantumcomputingbench/scripts/release.py validate
```

The current entry validates both cohorts, current withdrawal policy, source/review
bindings and canonical paths. Package the committed clean checkout with:

```bash
python benchmarks/quantumcomputingbench/scripts/release.py build
```

Outputs under `_out/qcb-release/`: a deterministic data ZIP, `SHA256SUMS`, and a
commit-bound manifest. The ZIP separates native splits, answer-free prompts,
legacy diagnostics, provisional audit material and provenance. It is a data
distribution; source-bound validation/scoring still needs the full repository.

## Data, scoring and review

- [Current admission overlay](manifests/integration-20261022/admission.json),
  [frozen native source release (historical admissions)](data/public/nl-v12/release.json),
  [provisional queue](manifests/nl-v12/review-queue.json), and
  [native dataset card](docs/native-nl-dataset-card.md).
- [Imported native coverage](reports/nl-v12/coverage.md) and
  [historical summary](reports/nl-v12/summary.json); use `release.py validate`
  for current admission counts and `build` for current data exports.
- [Legacy release](data/public/release-v3/release.json),
  [legacy dataset card](DATASET_CARD.md), and
  [mathematical repair audit](docs/repair-review-2026-10-21.md).
- [Core coordination proposal](docs/nl-collaborator-handoff.md) and
  [whole-graph authoring objective](AGENT_GOAL.md).

Predictions are JSON arrays of `{"id":"qcb-...","answer":"..."}`:

```bash
python benchmarks/quantumcomputingbench/scripts/release.py score \
  --cohort native --predictions ../predictions.json --ratings ../ratings.json
# Explicitly separate legacy diagnostics:
python benchmarks/quantumcomputingbench/scripts/release.py score \
  --cohort legacy --predictions ../legacy-predictions.json
```

NL explanations require actual content-rubric ratings bound to item/prediction
hashes and separate fidelity judgments. Reference copying, keywords and length do
not automatically earn credit. Fixtures are not model results. Public test
questions and answers are reproducible diagnostics, not blind, secret or
contamination-free assessment; model pretraining exposure is unknown.

Known withdrawn legacy/native answers remain in history for audit but are excluded
by current scoring. Use the current release entry, not historical commands to
resurrect old gold. Frozen QA, source hashes and review artifacts are preserved;
the [explicit compatibility ledger](manifests/integration-20261022/compatibility.json)
admits only the exact attribution update and restricted loader substitutions.
Original and current code are not falsely described as byte-identical.

## Lean reference evidence and safety

With the pinned toolchain and dependencies provisioned:

```bash
python website/scripts/run_lean_gate.py
python benchmarks/quantumcomputingbench/scripts/check_references.py \
  --trusted-local-reference --output ../qcb-local-reference-checks.json
```

Only inspected fixed reference sources may use this local path. Never send model
output to it. Complete proofs, frozen targets/imports and transitive axiom checks
are required; empty goals, exit code zero or searching for the word `sorry` are
insufficient. Local fixed-reference checking does not provision a sandbox.
The container evaluator stays disabled until its real pinned-image integration
tests pass.

## Continue contributing

Keep changes under this benchmark directory on separate working branches. Use
successor versions rather than overwriting frozen data or hashes. One mathematical
core spans NL/Lean/hybrid views, paraphrases and trivial parameter variants.

```bash
python benchmarks/quantumcomputingbench/scripts/authoring_packets.py \
  --version release-v3 --batch-size 8
```

Packets are resumable source-bound starting points, not generated QA or released
coverage. Inspect complete source statements and definitions. Module imports and
ownership are not theorem-proof dependencies; Hypergraph transports retain all AND
premises and failure boundaries. Keep planned/source-only topics distinct from
local formal closure, and measure primary targets separately from incidental
support.

Historical files and contributor records are retained. Duplicate root-level
uploads were moved to the canonical namespace only after equality checks; see the
[path migration ledger](manifests/integration-20261022/path-migration.json).
Original authored QA/code use repository MIT terms; external-source rights remain
separate. No PDFs, credentials, private gold, raw generations, paid API calls,
training jobs or GPU experiments are part of this release.

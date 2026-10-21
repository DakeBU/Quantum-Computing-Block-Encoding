# QuantumComputingBench

Graph-grounded quantum-computing QA for training and evaluating specialized
mathematical models, built on QuantumComputinglib rather than generic question
templates. Knowledge, mathematical reasoning, quantum semantics/resources, Lean
interface application, and explicitly planned curriculum are separate tracks.

Current version: **release-v3, a corrected working pilot — not a completed
whole-graph benchmark**. Read the [dataset card](DATASET_CARD.md),
[repair audit](docs/repair-review-2026-10-21.md), and
[coverage report](reports/release-v3/coverage.md).

## Current deliverables and evidence boundaries

| Material | Count / status | Intended use |
| --- | --- | --- |
| Released items with unchanged content and inherited review records | 26 | Knowledge/reasoning training and rubric-based public diagnostics |
| Corrected/new candidates awaiting independent NL review | 12 | Development diagnostics explicitly marked provisional, not independently verified gold |
| Other historical unreleased candidates | 8 | Retained with unresolved issues; excluded from released coverage |
| Local Lean reference theorems | 16 | Actual compilation and transitive axiom audits, not sandbox certification of arbitrary model output |
| Repaired Lean reference answers | 3 | Fully qualified names, frozen targets, and actual generated-harness replay |
| Complete graph ledger | 5,153 nodes | Coverage universe, not 5,153 questions or completed whole-graph coverage |

**Four prior gold answers have been withdrawn** for incorrect claims about
parallel ancilla usage, the necessity of strict positivity, RY versus Bloch
angles, and abstract accounting for unexpanded oracles. Historical files and
reports are preserved, but scoring and export entry points prevent these answers
from being reused as gold. Corrections use `supersedes` without overwriting the
original contributor records.

This work ran the complete production-library Lean gate, checked 16 fixed
reference claims, and replayed three generated harnesses. Actual negative
controls confirmed that wrong-type proofs and `sorryAx` are rejected. This does
not constitute independent natural-language semantic review or acceptance of
Docker/Podman isolation.
**Isolated Lean evaluation remains ENV_BLOCKED; real-model baseline performance
is unmeasured.**

## Start here

Run from the repository root with Python 3.11:

```bash
python -m pip install -r benchmarks/quantumcomputingbench/requirements.txt
python -m unittest discover -s benchmarks/quantumcomputingbench/tests -v
python benchmarks/quantumcomputingbench/scripts/qcb.py validate --version release-v3
```

For an idempotent rebuild of the frozen release:

```bash
python benchmarks/quantumcomputingbench/scripts/author_v3.py
python benchmarks/quantumcomputingbench/scripts/build_v3.py
python benchmarks/quantumcomputingbench/scripts/qcb.py snapshot --version release-v3
python benchmarks/quantumcomputingbench/scripts/qcb.py generate --version release-v3
python benchmarks/quantumcomputingbench/scripts/qcb.py export --version release-v3
python benchmarks/quantumcomputingbench/scripts/qcb.py coverage --version release-v3
python benchmarks/quantumcomputingbench/scripts/report.py --version release-v3
```

Existing versions are immutable. Mathematical source or pipeline changes require
a successor version, not replacing frozen hashes. LF-canonical text hashes work
on Windows and Linux; substantive whitespace/content changes are not normalized
away. Original v2 adapter provenance is checked against its exact committed blob.
Use a full Git checkout, not a shallow/archive copy without that history.

## Real local Lean reference checks

With the repository's pinned toolchain and dependencies already provisioned:

```bash
python website/scripts/run_lean_gate.py
python benchmarks/quantumcomputingbench/scripts/check_references.py \
  --trusted-local-reference --output ../qcb-local-reference-checks.json
```

This command runs **only the inspected fixed reference pack and its curated
lemma-application proofs**. Never route model output to it. It checks the actual
transitive axiom sets, not just process exit or absence of the word sorry.
A matching cached checkout can be selected with `--build-root PATH`; its complete
production proof-input digest and gate must match exactly. The published local
run used this equality check, not an assumption that old build artifacts suffice.

See [the checked evidence](reports/release-v3/lean-reference-checks.json).
The resource counterexample certifies a disjoint-demand arithmetic model, not a
hardware scheduling theorem. Sparse preparation uses the library's weaker
nonnegative + positive-total-mass theorem, including a genuine zero entry.

## Training data and public evaluation

- [Reviewed release](data/public/release-v3/release.json): 26 unchanged authored
  items with inherited, exact-content-bound AI review records. Inheritance is not
  a new human review or proof of real-world reviewer independence.
- [Provisional repairs / diagnostics](data/public/release-v3/provisional.json):
  4 corrected NL questions, 3 repaired Lean tasks, 5 exact-answer diagnostics.
- [Answer-free prompts](data/public/release-v3/prompts-closed_book.json) and
  [provisional prompts](data/public/release-v3/prompts-provisional.json).
- [Independent review queue](manifests/release-v3/review-queue.json). New questions
  stay candidates until a real independent reviewer checks their NL/source
  alignment. Do not invent a reviewer identity to promote them.

The released split is train=11, dev=4, test_public=11. Its test set has 7 core
questions plus 4 planned/OOD questions. Explicit construction-family holdouts
include real amplitude preparation, Givens, Thin-LQ and banded access; family and
target-solution overlaps are unioned. See [the split policy](manifests/release-v3/splits.json).

These are **retrospective public grouped diagnostics**, not blind/unseen tests:
v2 and its answers were already public. Shared foundational support may cross
splits. Future blind assessment needs new authorized private instances.

Predictions are JSON arrays of `{"id":"qcb-…","answer":"…"}`:

```bash
python benchmarks/quantumcomputingbench/scripts/qcb.py score \
  --version release-v3 --predictions ../predictions.json
# Explicit opt-in for non-independent-review candidate diagnostics:
python benchmarks/quantumcomputingbench/scripts/qcb.py score \
  --version release-v3 --provisional --predictions ../candidate-predictions.json
```

Exact diagnostics use their stated exact formatting. NL proofs need complete
human-rubric ratings bound to item/prediction hashes and a separate fidelity
judgment; uncertain judgments stay ungraded. Copied reference text is not
automatically accepted by the rubric scorer.

`score --verify-formal --image IMAGE@sha256:DIGEST` invokes the live isolated
verifier; supplied JSON receipts cannot award credit. Local reference receipts
cannot award formal evaluation credit. The shipped image gate stays disabled
until an actual vetted pinned-container integration test passes.

## Continue meaningful whole-graph authoring

```bash
python benchmarks/quantumcomputingbench/scripts/authoring_packets.py \
  --version release-v3 --batch-size 8
```

This issues resumable, module-diverse, source-bound packets under ignored
`.local/release-v3/authoring/`. It prioritizes uncovered **targets**, not nodes
merely mentioned as support. Packets include bounded source excerpts, exact
locations/hashes, typed structural relations and complete conditional hyperedges.
Authors must inspect complete types/ambient definitions/proofs before writing QA.
Issuing packets generates **zero QA** and adds **zero released coverage**.

Use the [next batches](manifests/release-v3/next-batches.json) for broader expansion:
State Preparation and Block Encoding first, including hypotheses, zero/sparse
boundaries, normalization, register/phase conventions, construction composition
and cost tiers. Planned QIT/scientific material stays source-grounded and separate.
Read [AGENT_GOAL.md](AGENT_GOAL.md) for the full objective.

The graph has module imports/ownership, not exported theorem proof dependencies.
Functor Hypergraph transports preserve their AND assumptions and failure maps;
they are conceptual guidance, not automatic Lean entailment. Support count,
semantic inference steps and structural distance are separate measurements.
Lean can validate an exact formal claim; it does not provide a universally
correct PRM label, useful-step label, or faithful NL explanation automatically.

## Baselines, CI and preservation

The bounded operator-owned adapter remains available via `qcb.py baseline`.
Without explicit authorization it makes zero model calls. No paid endpoint,
training job, Newton03 experiment or administrator action was used here.

The benchmark CI runs contract/fixture tests on Linux and Windows. It does not
claim to provision a sandbox or rerun Lean. Production Lean definitions, source
audits, old releases and historical reports are unchanged. Accidentally tracked
Python bytecode is untracked; local raw data/private gold/evaluation logs remain
excluded from publication.

Historical [release-v2](reports/release-v2/coverage.md) and
[archive handoff](CHANGES.zh-CN.md) describe their original run, not current status.
The canonical repository is
[QuantumComputinglib-QuantumComputingBench](https://github.com/DakeBU/QuantumComputinglib-QuantumComputingBench).

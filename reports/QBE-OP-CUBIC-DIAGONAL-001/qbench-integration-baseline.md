# QBench Integration Baseline

Generated: 2026-07-29 JST

This report freezes the ABEIS state before any QBench-inspired semantic
changes.  It is an evidence record for controlled experiments, not a claim
that either benchmark has been imported or solved.

## Checkout and gates

- Repository: `DakeBU/Quantum-Computing-Block-Encoding`
- Branch: `main`
- Commit: `1a84db83894bd8b7ab65d1d8cd72615a90343186`
- Upstream at audit time: `origin/main` at the same commit
- Lean: `4.29.1`
- Local gate before this report:
  - `lake build`: passed, 1,898 jobs
  - `lake build Tests`: passed, 1,900 jobs
  - `python3 tools/qbe.py check`: passed
- Worktree before this report: clean

The existing linter warnings are confined to known style warnings in
`CubicStatePreparation.lean` and one test warning.  No new warning was present
at baseline.

## Goal and run-state audit

`.qbe/state.json` names `QBE-OP-CUBIC-DIAGONAL-001` as the active task.  Its
last successful check was recorded on 2026-07-29.  `HUMAN_STATUS.md` instead
names the older `QBE-OP-CUBIC-STATEPREP-001`; that human-facing file is stale
and must not drive scheduling.

No ABEIS proof agent or hard-case proof screen was active at baseline.  One
detached ABEIS website preview screen remained from June; unrelated user
screens were not inspected or modified.

The active task's historical route is incomplete:

- target, normalizer, amplitude bounds, fixed-denominator cubic arithmetic,
  transparent rotation bookkeeping, and transparent cleanup witnesses compile;
- `DIAG-RY-WORKSPACE-READONLY-001`, route-level cleanup, concrete rotation
  semantics, block extraction, unitarity, the root certificate, and executable
  export remain open;
- there is no `runs/control/QBE-OP-CUBIC-DIAGONAL-001.json` completion record.

Two later isolated Hard Case runs bypassed that route with exact rational
Householder constructions:

| Run | Lean root | Lean | Qiskit | Exact clean block |
|---|---|---:|---:|---:|
| `QBE-HARD-CUBIC-DIAGONAL-HIER-COLD-001` | `CubicDiagonalOracle.cubicDiagonalHouseholderExactBEContract_complete` | pass | pass | error `0` |
| `QBE-HARD-CUBIC-DIAGONAL-HIER-HINTED-001` | `CubicDiagonalOracle.linearDiagonalHouseholderInputBEContract_complete` and the cubic root above | pass | pass | error `0` |

The finite executable gate used Qiskit `2.4.2`, OpenQASM `3` package `1.0.1`,
and `n = 2`.  The Lean roots prove symbolic families; the Qiskit results are
finite post-Lean validation.  These successful Householder routes did not
close or reconcile the old active-task ledger.

## Historical efficiency evidence

For `QBE-OP-CUBIC-DIAGONAL-001`, `runs/trials.jsonl` contains:

- 707 events from 2026-06-19 20:32:49 through 2026-06-20 17:11:59;
- 267 agent attempts with harness metrics: 83 lower, 82 middle, 82 upper, and
  20 reviewer calls;
- 3,377,240 estimated input tokens, explicitly a local prompt-size proxy and
  not provider token accounting;
- 77,500.66 seconds, or 21.53 hours, of summed agent wall time;
- 38 retained proof-attempt documents and 90 structured verifier-feedback
  records.

Feedback error classes:

| Error class | Count |
|---|---:|
| `symbolic_bridge_gap` | 73 |
| `shape_or_register_gap` | 6 |
| `lean_tactic_gap` | 4 |
| `stale_leaf` | 3 |
| `source_translation_gap` | 2 |
| `none` | 1 |

The dominant failure was repeated search against proposition-valued,
nontransparent route contracts after concrete pointwise arithmetic had already
compiled.  The harness kept reallocating agents instead of converting the
missing semantic bridge into a library-level prerequisite and freezing the
stale route.  The later Householder completion confirms that route selection
and interface design, rather than the target matrix itself, were the principal
bottleneck.

## Lean trust boundary

At baseline the project has 1,646 generated public declaration records.
`QuantumBlockEncoding/TechnicalLemmas.lean` is only a re-export surface and
contains no lemma registry or bridge theorem.

There are two intentional source holes, both experimental Robin boundary
diagnostics:

- `Examples.RobinHeat.oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3`
- `Examples.RobinHeat.oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3`

No source-level `axiom` command was found.  Plain text such as “axiom is
supplied” and “No new sorry” must not be counted as a proof hole.  A
comment/string-aware trust gate is required before new technical lemmas are
promoted.

The current public contracts also expose important semantic gaps:

- `StatePreparationCandidate.isUnitary` is an arbitrary `Prop`;
- state preparation is accepted by first-column equality, but there is no
  compiled bridge to matrix action on the all-zero ket;
- block-encoding unitarity, extraction, and approximation are abstract
  propositions rather than a concrete complex matrix/operator semantics;
- project matrices use flattened `Fin (signalDim * systemDim)` indices, but
  there is no named bridge to product-register projection;
- resources can be attached to candidates without a theorem connecting the
  annotation to circuit syntax;
- LCU support proves arithmetic and one-term clean-block facts, not a total
  PREPARE/SELECT circuit semantics;
- zero-error approximation is an exact pointwise predicate, not an operator
  norm theorem.

## External benchmark audit

The benchmark repositories were cloned only into an isolated temporary
directory.  They are not dependencies of ABEIS because their toolchains differ
from ABEIS Lean `4.29.1`.

| Artifact | Audited commit | Toolchain | Status at baseline |
|---|---|---|---|
| `Lean-QIT-Bench` | `e4f0230e14c35da9c658b58c8663b3e6825e6663` | Lean `4.30.0` | isolated build passed, 2,791 jobs |
| `Lean-QuantumAlg-Bench` | `7f964d2b34a63c8ea7cae87937ede7740abe7dda` | Lean `4.31.0` | isolated build passed, 2,506 jobs |

Structural inventory from the audited commits:

- QIT: 10 Base files, 40 Definitions files, and 40 Statement files;
- QAlg: 19 Base files, 36 Definitions files, and 36 Statement files;
- the repositories contain no separate `Hints` files;
- each task Statement contains an unresolved `sorry`, so Statements are task
  specifications and cannot be cited as verified technical lemmas;
- Base and Definitions are the only candidates for verified reuse, subject to
  declaration-level inspection and isolated compilation;
- an initial text scan falsely flagged the English word `admit` in a QIT
  docstring; it is not a Lean proof hole.

Relevant verified API candidates include matrix action on kets, extensionality
through basis action, tensor/adjoint lemmas, canonical projected blocks,
exact-to-approximate block conversion, finite-dimensional unitary action, and
QIT pure-state/product-state infrastructure.  The QAlg LCU task Statements are
unproved.  Its own paper also notes that the displayed SELECT vanishes outside
the label embedding unless labels exhaust the ancilla basis; ABEIS therefore
must use a total SELECT extension before claiming a unitary implementation.

No benchmark declaration will be copied verbatim.  Any ABEIS lemma must be
small, independently proved on the ABEIS toolchain, attributed, and admitted
to the registry only after local tests.

## Controlled experiment plan

The first experiment fixes reusable semantic prerequisites instead of
restarting the old broad search.

| Hypothesis | Baseline failure | Intervention | Required tests |
|---|---|---|---|
| H1 | first-column contracts cannot be consumed as state action | add a concrete finite complex `applyVec`/zero-ket bridge | identity and a nontrivial one-qubit state |
| H2 | flat and product register views are repeatedly reconstructed | add a named product-register projection bridge | two different signal/system dimensions |
| H3 | unresolved source holes can be hidden by text scans | add a trust scanner with an explicit two-hole allowlist | source tree and synthetic scanner tests |
| H4 | opaque semantic gaps trigger repeated agent expansion | add prerequisite-aware stop/escalation rules and technical-lemma retrieval cards | harness unit tests for stale-route freeze and prerequisite routing |

Acceptance requires:

1. no new `sorry`, `admit`, or `axiom`;
2. new lemmas compile under Lean `4.29.1`;
3. at least two independent ABEIS tests consume each promoted bridge;
4. the old gate remains green;
5. experiment records distinguish local declaration completion from completion
   of the broader block-encoding route;
6. README and paper claims remain conservative until these checks pass.

## Initial decision

Proceed with H1 and H2 as minimal semantic bridges and H3 as a mandatory trust
gate.  Evaluate H4 only through deterministic harness tests; do not launch a
new autonomous proof session during this integration.  Defer tensor/adjoint,
norm, complete LCU, density/channel, and general resource-soundness layers
until the first bridges demonstrate reuse without increasing the trust
boundary.

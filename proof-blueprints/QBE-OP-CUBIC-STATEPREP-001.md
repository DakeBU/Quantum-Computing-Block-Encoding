# Proof Blueprint: QBE-OP-CUBIC-STATEPREP-001

Task id: `QBE-OP-CUBIC-STATEPREP-001`
Title: Cubic grid state-preparation operator
Mode: `exploratoryConstruction`
Updated: `2026-06-19 12:42:31`
Blueprint stage: `Stage 1 target/transcript stabilization`

This is QBE's compact system-of-record snapshot for long-horizon Lean proof
automation.  It follows a similar control pattern to LeanMarathon's evolving
blueprint, but QBE keeps the human-facing proof map split across Lean,
Markdown, LaTeX, proof obligations, and cited-results memory because
block-encoding papers require source notation, register conventions, and
oracle contracts to stay explicit.

## Current Directive

````text
# Cubic grid state-preparation operator

Task id: `QBE-OP-CUBIC-STATEPREP-001`
Kind: `operatorBlockEncoding`
Mode: `exploratoryConstruction`
Status: `active`

## User Target

For a positive integer `n`, let `N = 2^n`, `x_j = j / N`, and
`f(x) = x^3`.  The user-level statement is

```text
O |0^n> = sum_{j=0}^{N-1} f(x_j) |j>
```

The right hand side is generally not normalized, so ABEIS fixes the
Lean-checkable operator as the rank-one map

```text
O_n = |v_n><0^n|,      v_n[j] = (j / 2^n)^3.
```

This means `O_n` maps `|0^n>` to the requested unnormalized vector and maps
all other computational basis inputs to zero.  If a user wants a normalized
state-preparation unitary instead, that is a different target
`|v_n / ||v_n||><0^n|` and must be stated separately.

## Error And Search Policy

Requested tolerance:

```text
epsilon = 1e-10
```

ABEIS should run the usual adaptive policy:

1. try exact block encodings first;
2. if exact search stalls or cannot meet the resource floor, enter Scenario 2;
3. in Scenario 2, search for an approximate block encoding satisfying

   ```text
   || O_n - alpha * ((<0^a| tensor I) U (|0^a> tensor I)) || <= epsilon;
   ```

4. if no improvement appears after the configured stall window, increase
   parallel upper/middle/lower agents up to the configured maximum and record
   whether the extra agents improved the certified population.

The initial policy is compiled in Lean as
`CubicStatePreparation.defaultPolicy`.

## Score

Within one asymptotic/backend tier, candidates are ranked by

```text
(gateCount, depth, auxiliaryQubits, oracleCalls)
```

The asymptotic tier must be recorded first.  A dense-table state preparation
candidate and an arithmetic polynomial candidate are not in the same tier.

## Expected Baselines

- **Generic dense baseline.**  Materialize all amplitudes and use a generic
  state-preparation routine.  This is useful for small `n`, but its description
  and verifier cost scale with `2^n`.
- **Universal block-encoding completion.**  Use the generic block matrix
  completion for a scaled matrix.  This is a correctness seed but is not
  expected to be resource-competitive.
- **ABEIS target route.**  Use reversible arithmetic to compute `j / 2^n`,
  approximate the cubic amplitude, and synthesize controlled rotations or an
  equivalent approximate state-preparation block.  The intended scaling target
  is polynomial in `n` and `log(1/epsilon)`, not table size.

## Lean Surface

Current compiled declarations:

```lean
QuantumBlockEncoding.CubicStatePreparation.taskId
QuantumBlockEncoding.CubicStatePreparation.requestedEpsilon
QuantumBlockEncoding.CubicStatePreparation.cubicAmplitude
QuantumBlockEncoding.CubicStatePreparation.cubicOperator
QuantumBlockEncoding.CubicStatePreparation.cubicNormSq
QuantumBlockEncoding.CubicStatePreparation.cubicTarget
QuantumBlockEncoding.CubicStatePreparation.defaultPolicy
QuantumBlockEncoding.CubicStatePreparation.initialExpectedPhase
```

These are target declarations and diagnostics, not a final block-encoding
certificate.

## Next Agent Packet

- lower natural-language architect: write the approximate arithmetic synthesis
  route and the error budget decomposition.
- lower Lean worker: implement one small exact diagnostic lemma or one
  reusable rational norm lemma; do not try to close the full analytic theorem
  in a single pass.
- lower verifier worker: dense statevector/unitary scaling for `n = 4, 8, 12,
  16, 20` is recorded in
  `verifier-feedback/QBE-OP-CUBIC-STATEPREP-001/cubic-ver-001-scaling.md`;
  wait for a concrete candidate before running new finite block-entry checks.
- reviewer: reject any candidate that treats the unnormalized vector as a
  unitary output state without either normalization or block-encoding scaling.
````

## Dynamic Leaf Queue

These are the current local proof or repair candidates.  Lower agents should
work on one item at a time; if an item is stale, upper/middle must retire it
before spending more proof-search tokens.

| Leaf | Interface | Status |
|---|---|---|
| CUBIC-NORM-001 | Prove a closed rational formula for `CubicStatePreparation.cubicNormSq n`, using the classical sixth-power sum helper if needed. | active leaf |
| CUBIC-VER-001 | Record dense-vs-symbolic verifier scaling for `n = 4, 8, 12, 16, 20` with typed feedback fields. | diagnostic complete, not a certificate |
| CUBIC-DIAG-001 | Small exact norm diagnostics `cubicNormSq_n1`, `cubicNormSq_n2`, and `cubicNormSq_n3`. | compiled, retired |
| CUBIC-ALPHA-001 | Prove the selected normalizer is compatible with the target norm. | blocked on CUBIC-NORM-001 or an entrywise norm bound |
| CUBIC-ERR-001 | Decompose arithmetic and rotation/transduction approximation error to `requestedEpsilon`. | open |
| CUBIC-CAND-001 | Candidate unitary transcript and clean-block theorem. | open after alpha, projector, ancilla cleanup, and epsilon budget |

## Open Obligation Signals

```text
# Proof Obligations: QBE-OP-CUBIC-STATEPREP-001
## Target Obligations
| Obligation | Lean declaration or artifact | Status |
| Prove closed form for `sum_j (j/2^n)^6` | planned `CubicStatePreparation.cubicNormSq_closedForm`; DAG node CUBIC-NORM-001 | active leaf |
| Prove placeholder normalizer is sufficient | planned `CubicStatePreparation.cubicNormSq_le_conservativeNormalizer_sq`; DAG node CUBIC-ALPHA-001 | blocked on norm bridge |
| State block projector and clean-ancilla convention for first candidate | planned candidate contract | open |
## Candidate Obligations
| Obligation | Status |
```

## Lean Declaration Index

Recent task-relevant declarations:

| Kind | Lean name | File |
|---|---|---|
| def | `taskId` | `QuantumBlockEncoding/CubicStatePreparation.lean:24` |
| def | `requestedEpsilon` | `QuantumBlockEncoding/CubicStatePreparation.lean:27` |
| def | `gridPoint` | `QuantumBlockEncoding/CubicStatePreparation.lean:30` |
| def | `cubicAmplitude` | `QuantumBlockEncoding/CubicStatePreparation.lean:34` |
| def | `cubicOperator` | `QuantumBlockEncoding/CubicStatePreparation.lean:42` |
| def | `cubicNormSq` | `QuantumBlockEncoding/CubicStatePreparation.lean:50` |
| def | `conservativeNormalizer` | `QuantumBlockEncoding/CubicStatePreparation.lean:59` |
| def | `cubicTarget` | `QuantumBlockEncoding/CubicStatePreparation.lean:63` |
| def | `defaultRequiredCost` | `QuantumBlockEncoding/CubicStatePreparation.lean:76` |
| def | `defaultPolicy` | `QuantumBlockEncoding/CubicStatePreparation.lean:88` |
| def | `initialExpectedPhase` | `QuantumBlockEncoding/CubicStatePreparation.lean:103` |
| theorem | `cubicOperator_only_first_column` | `QuantumBlockEncoding/CubicStatePreparation.lean:106` |
| theorem | `cubicNormSq_n1` | `QuantumBlockEncoding/CubicStatePreparation.lean:111` |
| theorem | `cubicNormSq_n2` | `QuantumBlockEncoding/CubicStatePreparation.lean:115` |
| structure | `RegisterLayout` | `QuantumBlockEncoding/BlockEncoding.lean:14` |
| structure | `BlockEncodingSpec` | `QuantumBlockEncoding/BlockEncoding.lean:33` |
| structure | `BlockEncodingCost` | `QuantumBlockEncoding/BlockEncoding.lean:50` |
| def | `fromLayoutAndResource` | `QuantumBlockEncoding/BlockEncoding.lean:59` |
| structure | `QueryOperatorTarget` | `QuantumBlockEncoding/BlockEncoding.lean:90` |
| structure | `OperatorBlockEncodingCandidate` | `QuantumBlockEncoding/BlockEncoding.lean:103` |
| structure | `VerifiedOperatorBlockEncoding` | `QuantumBlockEncoding/BlockEncoding.lean:131` |
| structure | `ApproximateOperatorBlockEncodingCandidate` | `QuantumBlockEncoding/BlockEncoding.lean:148` |
| structure | `VerifiedApproximateOperatorBlockEncoding` | `QuantumBlockEncoding/BlockEncoding.lean:159` |
| structure | `AdaptiveBlockEncodingPolicy` | `QuantumBlockEncoding/BlockEncoding.lean:195` |
| inductive | `BlockEncodingSearchPhase` | `QuantumBlockEncoding/BlockEncoding.lean:207` |
| structure | `VerifiedBlockEncoding` | `QuantumBlockEncoding/BlockEncoding.lean:220` |
| abbrev | `Matrix` | `QuantumBlockEncoding/Core.lean:15` |
| def | `gridSize` | `QuantumBlockEncoding/Core.lean:44` |
| abbrev | `Circuit` | `QuantumBlockEncoding/Circuit.lean:23` |
| abbrev | `CircuitLayer` | `QuantumBlockEncoding/Circuit.lean:50` |
| abbrev | `LayeredCircuit` | `QuantumBlockEncoding/Circuit.lean:60` |

## Correspondence Artifacts

| Artifact | Role |
|---|---|
| `tasks/QBE-OP-CUBIC-STATEPREP-001.md` | task/proof map |
| `conversion-windows/QBE-OP-CUBIC-STATEPREP-001.md` | Lean/natural-language conversion |
| `proof-obligations/QBE-OP-CUBIC-STATEPREP-001.md` | open obligations |
| `candidate-populations/QBE-OP-CUBIC-STATEPREP-001.md` | exploratory candidate records |
| `verifier-feedback/QBE-OP-CUBIC-STATEPREP-001/initial-diagnostics.md` | initial target-semantics diagnostic |
| `verifier-feedback/QBE-OP-CUBIC-STATEPREP-001/cubic-ver-001-scaling.md` | dense-scaling typed verifier feedback |
| `research-wiki/retrieval-index/QBE-OP-CUBIC-STATEPREP-001.json` | compact retrieval packet |
| `runs/20260619-120936-QBE-OP-CUBIC-STATEPREP-001-cycle01/memory_digest.md` | run-local compact memory |

## Latest Dialogue Signal

````text
ory_digest/todo, and require lower packets to emit structured verifier-feedback. Stop spawning another full panel until those artifacts exist.

## 2026-06-19 12:23:41 - upper

Director synthesis: mode remains exploratory construction for the fixed rank-one operator O_n=|v_n><0^n|. Immediate objective is workflow unblock: middle must create conversion-windows/QBE-OP-CUBIC-STATEPREP-001.md with a proof-DAG table, retire compiled target/n=1/n=2 leaves, normalize verifier-feedback fields, refresh memory_digest/todo, and keep lower2 on one compiling norm/normalizer Lean leaf. Stop full U_n/candidate proof search until alpha, projector, ancilla cleanup, and epsilon budget are explicit. Gate passed via python3 tools/qbe.py check.

## 2026-06-19 12:30:53 - middle

Created conversion window and proof-DAG frontier for fixed rank-one cubic target. Retired compiled n=1/n=2 diagnostics; active Lean leaf is CUBIC-NORM-001, planned CubicStatePreparation.cubicNormSq_closedForm using classical-sixth-power-sum as an obligation. CUBIC-ALPHA-001 remains blocked on the norm bridge; no U_n proof search until alpha, projector, clean ancilla, and epsilon budget are explicit. Gates passed: python3 tools/qbe.py check; lake build && lake build Tests.

## 20260619-120855-QBE-OP-CUBIC-STATEPREP-001-cycle01

# Dialogue: QBE-OP-CUBIC-STATEPREP-001 cycle 1

Append short role-tagged handoffs here.

## 20260619-120600-QBE-OP-CUBIC-STATEPREP-001-cycle01

# Dialogue: QBE-OP-CUBIC-STATEPREP-001 cycle 1

Append short role-tagged handoffs here.

## 2026-06-19 12:08:12 - upper

Upper source/visual audit: exploratory operator construction remains the right mode. Source anchor is the user prompt plus task contract, not a paper theorem; no local paper archive exists. Current Lean target preserves O_n = |v_n><0^n| with v_j=(j/2^n)^3 and correctly prevents unitary-state-preparation drift. Next objective: middle must create a cubic conversion window/proof-DAG table and make the active lower leaf the exact rational norm/normalizer bridge, while lower 1 drafts the arithmetic approximation/error-budget route and lower 3 runs finite scaling diagnostics for n=4,8,12,16,20. Stop broad proof search for a final U_n until the normalizer, ancilla/block projector, and epsilon budget are explicit.

## 20260619-120353-QBE-OP-CUBIC-STATEPREP-001-cycle01

# Dialogue: QBE-OP-CUBIC-STATEPREP-001 cycle 1

Append short role-tagged handoffs here.

## 20260619-120244-QBE-OP-CUBIC-STATEPREP-001-cycle01

# Dialogue: QBE-OP-CUBIC-STATEPREP-001 cycle 1

Append short role-tagged handoffs here.

## 20260619-120214-QBE-OP-CUBIC-STATEPREP-001-cycle01

# Dialogue: QBE-OP-CUBIC-STATEPREP-001 cycle 1

Append short role-tagged handoffs here.

## 20260619-115824-QBE-OP-CUBIC-STATEPREP-001-cycle01

# Dialogue: QBE-OP-CUBIC-STATEPREP-001 cycle 1

Append short role-tagged handoffs here.

## 20260619-115627-QBE-OP-CUBIC-STATEPREP-001-cycle01

# Dialogue: QBE-OP-CUBIC-STATEPREP-001 cycle 1

Append short role-tagged handoffs here.
````

## Gate Policy

- Stage 1 target/transcript stabilization: upper and middle must verify that
  Lean statements, source-paper prose, register layouts, normalizers, and
  cited contracts match before broad lower proving.
- Stage 2 DAG proof discharge: lower agents work on dynamic leaves only;
  reviewer accepts inner-cycle progress only through `python3 tools/qbe.py check`
  and synchronized Lean-to-natural-language proof status.  LaTeX exports are
  checked at 6h/convergence closeout.
- Mixed lower-agent proof mode: lower 1 writes the natural-language dependency
  proof and active-leaf table; lower 2 compiles exactly one ready Lean leaf;
  lower 3, when available, runs necessary-condition diagnostics such as finite
  matrix/path/support checks and typed verifier-feedback packets before lower 2
  spends time on a large Lean proof.
- Refiner behavior: when several failures share a dependency, repair the
  connected illness area once instead of stacking independent patches.
- No agent may mark a proof complete from self-assessment, partial score, or
  process memory.  Lean plus explicit proof-map correspondence is the gate.

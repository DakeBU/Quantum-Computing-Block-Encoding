# Proof Blueprint: QBE-OP-CUBIC-STATEPREP-001

Task id: `QBE-OP-CUBIC-STATEPREP-001`
Title: Cubic grid state-preparation operator
Mode: `exploratoryConstruction`
Updated: `2026-06-19 17:40:13`
Blueprint stage: `Stage 2 DAG proof discharge, with source-transcript checks still active`

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

Hard Mode escalation is also recorded in Lean:

```text
CubicStatePreparation.hardModeUpperAgentSchedule = [1, 3, 4]
CubicStatePreparation.hardModeMiddleAgentSchedule = [1, 2, 3]
CubicStatePreparation.hardModeLowerAgentSchedule = [3, 5, 8]
CubicStatePreparation.hardModeExactStallWindow = 1
CubicStatePreparation.hardModeConstructionStallWindow = 1
CubicStatePreparation.hardModeLevelCycleBudget = [1, 1, 1]
CubicStatePreparation.relaxedEpsilonLadder = [1e-10, 1e-8, 1e-6]
```

The upper panel must not jump directly to the largest panel.  The intended
schedule is:

| Phase | Trigger | Agent allocation | Goal |
|---|---|---|---|
| L0 exact contraction and candidate seeding | task starts or memory was stale | upper=1, middle=1, lower=3: candidate architect, Lean worker, verifier | seed at least one concrete `U_n` family while also closing target/norm leaves and rejecting wrong exact state-prep interpretations |
| L1 requested-epsilon Scenario 2 | no closed leaf or no concrete candidate for 1 cycle | upper=3, middle=2, lower=5: 2 architects, 2 Lean workers, 1 verifier/export worker | find or repair a symbolic approximate candidate at `1e-10` |
| L2 relaxed waypoint search | no improving certified/finite candidate for 1 cycle | upper=4, middle=3, lower=8 | try `1e-8`, then `1e-6` as one-hour waypoints, while keeping the final requested target visible |

Every escalation must record whether the extra agents improved the certified
population, the finite verifier population, or only the insight pool.

## Population And Mutation Policy

ABEIS keeps three separate populations:

- **certified population**: Lean-proved candidates only; these are the only
  candidates that may appear on achieved-resource curves;
- **finite executable population**: Qiskit/NumPy/QuantumKatas-style candidates
  that pass fixed-instance checks for small `n`; these may guide search but are
  not accepted as family certificates;
- **insight pool**: failed or unproved routes with a reusable idea, such as a
  normalizer trick or an arithmetic transduction plan.

At L1 and L2, lower agents should spend each generation on a mixture of:

- mutation: alter one candidate route while preserving the target operator;
- crossover: combine two useful ingredients, for example a normalizer bound
  from one route and an arithmetic state-preparation skeleton from another;
- repair: close exactly one Lean proof leaf or turn a failed finite check into
  a smaller counterexample;
- export: write Qiskit/QuantumKatas/QASM artifacts only for a concrete
  candidate, with a clear semantic label.

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

## External Tool Boundary

Local public artifacts checked so far do not expose a direct generic function
"given operator `O_n`, synthesize and prove a block encoding family."  The fair
comparison therefore has two categories:

- **direct fixed-instance executable checks**: NumPy dense completion, Qiskit
  `Operator`, and a Qiskit-QuantumKatas-style evaluator can verify a concrete
  small-`n` dense candidate;
- **not direct BE constructors**: QASM-Eval provides useful typed QASM
  feedback, QUASAR is a tool/reward-loop reference without a runnable same-task
  local route, and AI-Mandel is a quantum-physics idea-to-tool loop rather than
  a block-encoding verifier.

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

- lower natural-language proof architect: keep the Hadamard-counting proof-DAG
  branch fixed, with the repair leaf now compiled after the ratio bridge:
  `CUBIC-TGT-001 -> CUBIC-ALPHA-001 -> CUBIC-HCOUNT-IFACE-001 ->
  CUBIC-HCOUNT-RATIO-001 -> CUBIC-HCOUNT-REJECT-REPAIR-001 ->
  CUBIC-HCOUNT-COUNT-001 -> CUBIC-HCOUNT-UNITARY-001 ->
  CUBIC-HCOUNT-BLOCK-001 -> CUBIC-HCOUNT-APPROX-001`.  The selected repair is
  the separate reject-signal convention; do not reopen the sticky-vs-reject
  choice unless a later semantic proof finds a contradiction.
- lower Lean worker: `CUBIC-HCOUNT-RATIO-001` is compiled as
  `cubicAmplitude_div_conservativeNormalizer_eq`; do not reschedule this leaf
  unless the gate fails or the statement changes.  `CUBIC-HCOUNT-REJECT-REPAIR-001`
  is compiled as `hadamardCountingCubicCircuit_rejectSignalRepair` with the
  default `n = 2` tuple `(8, 8, 21, 8)`.  `CUBIC-HCOUNT-COUNT-001` is compiled
  as `gridSize_three_mul_eq_cube`, `gridSize_four_mul_eq_fourth`,
  `hadamardCountingCubic_threshold_le_pathCapacity`, and
  `hadamardCountingCubic_thresholdPathCount`.  The next Lean leaf should be
  `CUBIC-HCOUNT-UNITARY-001` or an equivalent Hadamard-sandwich semantic
  bridge, not the full block theorem.
- lower verifier/export worker: `CUBIC-VER-CAND-001:HCOUNT-SEMANTIC` rejected
  the old daggered nonzero-flag transcript, and
  `CUBIC-HCOUNT-REJECT-REPAIR-001` finite checks pass for `n = 1, 2`.  Do not
  rerun the stale `candidate_interface_gap` diagnostic; only rerun the
  Hadamard-counting path diagnostic if the threshold register size, path
  denominator, or accepted-path predicate changes.
- reviewer: reject any candidate that treats the unnormalized vector as a
  unitary output state without either normalization or block-encoding scaling,
  and reject any promotion from finite diagnostics to the certified population
  before a Lean clean-block theorem is named and build-tested.
````

## Dynamic Leaf Queue

These are the current local proof or repair candidates.  Lower agents should
work on one item at a time; if an item is stale, upper/middle must retire it
before spending more proof-search tokens.

| Leaf | Status |
|---|---|
| CUBIC-HCOUNT-COUNT-001: Prove the symbolic count of accepted threshold paths: for fixed row `j`, exactly `j.val ^ 3` values of `t : Fin (gridSize (3 * n))` satisfy `t.val < j.val ^ 3`.; status: compiled leaf; Lean: `gridSize_three_mul_eq_cube`, `gridSize_four_mul_eq_fourth`, `hadamardCountingCubic_threshold_le_pathCapacity`, `hadamardCountingCubic_thresholdPathCount` | retired |
| CUBIC-HCOUNT-UNITARY-001: Prove the repaired transcript is unitary as Hadamards plus reversible arithmetic/permutation labels.; status: next symbolic bridge leaf; Lean: planned semantic theorem | candidate |
| CUBIC-HCOUNT-BLOCK-001: Prove the repaired clean block satisfies `hadamardCountingCubicCleanBlockContract n block`.; status: blocked internal; Lean: planned clean-block theorem | candidate |
| CUBIC-HCOUNT-APPROX-001: Package exact error `0` into the requested approximate block-encoding record at `requestedEpsilon`.; status: blocked internal; Lean: planned `VerifiedApproximateOperatorBlockEncoding` witness | candidate |
| CUBIC-ERR-001: Arithmetic approximation and rotation/transduction error budget sums to `1e-10`.; status: designed, blocked on wrapper semantics; Lean: `proof-attempts/QBE-OP-CUBIC-STATEPREP-001-CUBIC-ERR-001.md` plus future Lean targets | candidate |

## Open Obligation Signals

```text
# Proof Obligations: QBE-OP-CUBIC-STATEPREP-001
## Target Obligations
| Obligation | Lean declaration or artifact | Status |
| State block projector and clean-ancilla convention for first candidate | `CubicStatePreparation.rankOneCleanBlockContract`, `CubicStatePreparation.arithmeticRankOneCubicCleanBlockContract`, `CubicStatePreparation.rankOneCleanBlockContract_pointwise_eq`, `CubicStatePreparation.arithmeticRankOneCubicCleanBlockContract_pointwise_eq` | compiled contract bridge; semantic clean-block proof open |
## Candidate Obligations
| Obligation | Status |
| Block-entry theorem for `O_n` | target-shape bridge compiled: `rankOneCleanBlockContract_pointwise_eq`; semantic zero-filter, row-generation, amplitude, and unitarity proofs remain open |
| CUBIC-CAND-SHAPE-001 | Rank-one wrapper transcript, resource tuple, clean-block contract, and target-shape bridge. | CUBIC-CAND-001, CUBIC-TGT-001 | lower worker 5 / lower Lean | `arithmeticRankOneCubicLayout`, `arithmeticRankOneCubicCircuit`, `arithmeticRankOneCubicResourceTuple`, `arithmeticRankOneCubicClaim`, `rankOneCleanBlockContract_pointwise_eq`, `arithmeticRankOneCubicCleanBlockContract_pointwise_eq` | compiled interface and pointwise bridge; zero-filter/row-generation semantics open |
| CUBIC-HCOUNT-IFACE-001 | Hadamard-counting layout, transcript, normalizer, resource tuple, clean-block contract bridge, and normalizer bridge. | CUBIC-TGT-001, CUBIC-ALPHA-001 | lower Lean | `hadamardCountingCubicLayout`, `hadamardCountingCubicCircuit`, `hadamardCountingCubicNormalizer`, `hadamardCountingCubicResourceTuple`, `hadamardCountingCubicCleanBlockContract_pointwise_eq`, `cubicNormSq_le_hadamardCountingCubicNormalizer_sq` | compiled interface; not a certificate |
| CUBIC-HCOUNT-UNITARY-001 | Prove the repaired transcript is unitary as Hadamards plus reversible arithmetic/permutation labels. | CUBIC-HCOUNT-COUNT-001, future semantics for oracle labels | future lower Lean | planned semantic theorem | next symbolic bridge leaf |
| CUBIC-HCOUNT-BLOCK-001 | Prove the repaired clean block satisfies the route-specific clean-block contract. | CUBIC-HCOUNT-COUNT-001, CUBIC-HCOUNT-UNITARY-001, Hadamard-sandwich semantic lemma | future lower Lean | planned clean-block theorem | blocked internal |
## Source-Correspondence Contract
| Source anchor | User/task contract in `tasks/QBE-OP-CUBIC-STATEPREP-001.md`; no paper archive is active. |
| Active lower leaves | `CUBIC-HCOUNT-COUNT-001` is compiled.  `CUBIC-HCOUNT-RATIO-001` and `CUBIC-HCOUNT-REJECT-REPAIR-001` are compiled, finite checks for the repaired reject convention remain clean for `n = 1, 2`, and the old daggered route remains rejected.  The next symbolic bridge is `CUBIC-HCOUNT-UNITARY-001` or an equivalent Hadamard-sandwich semantic lemma before `CUBIC-HCOUNT-BLOCK-001`. |
| External technical lemma | `classical-sixth-power-sum` in `research-wiki/cited-results/classical-power-sums.md`, status `obligation` unless a Lean helper builds. |
| Not allowed in next lower packet | No normalized state-preparation shortcut and no certification claim for an unproved candidate. Candidate theorem shapes are allowed and expected; Lean closure is required before promotion. |
reports `finite_matrix_ok=true` and `block_entry_ok=true`.  The next route is
wrapper resource tuple, and pointwise bridge from the clean-block contract to
`O_n`.  The remaining blocker is semantic: choose finite matrices/contracts
unitarity obligations.
now has compiled layout/circuit/resource declarations, a clean-block contract
diagnostic.  The next useful work is symbolic and fixed for this cycle:
```

## Lean Declaration Index

Recent task-relevant declarations:

| Kind | Lean name | File |
|---|---|---|
| def | `hardModeConstructionStallWindow` | `QuantumBlockEncoding/CubicStatePreparation.lean:413` |
| def | `hardModeLevelCycleBudget` | `QuantumBlockEncoding/CubicStatePreparation.lean:416` |
| def | `relaxedEpsilonLadder` | `QuantumBlockEncoding/CubicStatePreparation.lean:424` |
| theorem | `relaxedEpsilonLadder_startsWithRequested` | `QuantumBlockEncoding/CubicStatePreparation.lean:427` |
| theorem | `hardModeSchedules_have_three_levels` | `QuantumBlockEncoding/CubicStatePreparation.lean:431` |
| theorem | `hardModeLowerAgentSchedule_final` | `QuantumBlockEncoding/CubicStatePreparation.lean:438` |
| def | `initialExpectedPhase` | `QuantumBlockEncoding/CubicStatePreparation.lean:447` |
| theorem | `gridSize_pos` | `QuantumBlockEncoding/CubicStatePreparation.lean:450` |
| theorem | `cubicOperator_first_column` | `QuantumBlockEncoding/CubicStatePreparation.lean:453` |
| theorem | `cubicOperator_only_first_column` | `QuantumBlockEncoding/CubicStatePreparation.lean:457` |
| def | `rankOneCleanBlockContract` | `QuantumBlockEncoding/CubicStatePreparation.lean:470` |
| def | `arithmeticRankOneCubicCleanBlockContract` | `QuantumBlockEncoding/CubicStatePreparation.lean:477` |
| theorem | `rankOneCleanBlockContract_pointwise_eq` | `QuantumBlockEncoding/CubicStatePreparation.lean:485` |
| theorem | `arithmeticRankOneCubicCleanBlockContract_pointwise_eq` | `QuantumBlockEncoding/CubicStatePreparation.lean:505` |
| def | `hadamardCountingCubicCleanBlockContract` | `QuantumBlockEncoding/CubicStatePreparation.lean:514` |
| theorem | `hadamardCountingCubicCleanBlockContract_pointwise_eq` | `QuantumBlockEncoding/CubicStatePreparation.lean:522` |
| theorem | `rat_cube_sq_eq_sixth` | `QuantumBlockEncoding/CubicStatePreparation.lean:530` |
| theorem | `cubicAmplitude_sq_eq_gridPoint_sixth` | `QuantumBlockEncoding/CubicStatePreparation.lean:537` |
| theorem | `cubicNormSq_sixthPowerFold` | `QuantumBlockEncoding/CubicStatePreparation.lean:542` |
| theorem | `gridSize_rat_ne_zero` | `QuantumBlockEncoding/CubicStatePreparation.lean:549` |
| theorem | `gridSize_rat_pos` | `QuantumBlockEncoding/CubicStatePreparation.lean:554` |
| theorem | `rat_div_cube_div_eq` | `QuantumBlockEncoding/CubicStatePreparation.lean:559` |
| theorem | `cubicAmplitude_div_conservativeNormalizer_eq` | `QuantumBlockEncoding/CubicStatePreparation.lean:570` |
| theorem | `gridSize_three_mul_eq_cube` | `QuantumBlockEncoding/CubicStatePreparation.lean:578` |
| theorem | `gridSize_four_mul_eq_fourth` | `QuantumBlockEncoding/CubicStatePreparation.lean:584` |
| theorem | `hadamardCountingCubic_thresholdCountP_finRange` | `QuantumBlockEncoding/CubicStatePreparation.lean:595` |
| theorem | `hadamardCountingCubic_thresholdFilterLength` | `QuantumBlockEncoding/CubicStatePreparation.lean:624` |
| theorem | `hadamardCountingCubic_threshold_le_pathCapacity` | `QuantumBlockEncoding/CubicStatePreparation.lean:631` |
| theorem | `hadamardCountingCubic_thresholdPathCount` | `QuantumBlockEncoding/CubicStatePreparation.lean:644` |
| theorem | `gridPoint_nonneg` | `QuantumBlockEncoding/CubicStatePreparation.lean:652` |
| theorem | `gridPoint_lt_one` | `QuantumBlockEncoding/CubicStatePreparation.lean:661` |
| theorem | `gridPoint_le_one` | `QuantumBlockEncoding/CubicStatePreparation.lean:668` |
| theorem | `rat_pow_le_one_of_nonneg_le_one` | `QuantumBlockEncoding/CubicStatePreparation.lean:672` |
| theorem | `cubicAmplitude_sq_le_one` | `QuantumBlockEncoding/CubicStatePreparation.lean:686` |
| theorem | `foldl_add_le_add_length` | `QuantumBlockEncoding/CubicStatePreparation.lean:692` |
| theorem | `cubicNormSq_le_gridSize` | `QuantumBlockEncoding/CubicStatePreparation.lean:718` |
| theorem | `gridSize_rat_le_sq` | `QuantumBlockEncoding/CubicStatePreparation.lean:730` |
| theorem | `cubicNormSq_le_conservativeNormalizer_sq` | `QuantumBlockEncoding/CubicStatePreparation.lean:742` |
| theorem | `cubicNormSq_le_arithmeticCubicNormalizer_sq` | `QuantumBlockEncoding/CubicStatePreparation.lean:753` |
| theorem | `cubicNormSq_le_hadamardCountingCubicNormalizer_sq` | `QuantumBlockEncoding/CubicStatePreparation.lean:763` |
| theorem | `cubicNormSq_n1` | `QuantumBlockEncoding/CubicStatePreparation.lean:768` |
| theorem | `cubicNormSq_n2` | `QuantumBlockEncoding/CubicStatePreparation.lean:772` |
| theorem | `cubicNormSq_n3` | `QuantumBlockEncoding/CubicStatePreparation.lean:776` |
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

## Latest Dialogue Signal

````text
-Hadamard orthogonality, and clean ancilla projection. Old daggered nz route remains rejected as a regression. This is not theorem closure: next route is one symbolic bridge leaf, CUBIC-HCOUNT-COUNT-001 or CUBIC-HCOUNT-UNITARY-001, before CUBIC-HCOUNT-BLOCK-001. Gate passed: python3 tools/qbe.py check.

## 2026-06-19 17:11:50 - lower

CUBIC-HCOUNT-REJECT-REPAIR-001 accepted: Hadamard-counting transcript now records separate hcount-nonzero-column-reject before nz cleanup, with Lean theorem hadamardCountingCubicCircuit_rejectSignalRepair and n=2 oracle-tier tuple (8, 8, 21, 8). Repaired finite diagnostic passes for n=1,2 with finite_matrix_ok=true, block_entry_ok=true, ancilla_cleanup_ok=true, unitarity_ok=true; old daggered route remains rejected. Gate passed: python3 tools/qbe.py check (lake build; lake build Tests). closed_theorem_ok=false; next route is one symbolic bridge leaf, preferably CUBIC-HCOUNT-COUNT-001 or CUBIC-HCOUNT-UNITARY-001 before CUBIC-HCOUNT-BLOCK-001.

## 2026-06-19 17:13:10 - lower

CUBIC-HCOUNT-REJECT-REPAIR-001 compiled: hadamardCountingCubicCircuit_rejectSignalRepair records the separate hcount-nonzero-column-reject label before nz cleanup, with n=2 tuple (8,8,21,8) and Tests/Basic coverage. Finite repair diagnostic passed for n=1,2; old daggered route remains rejected. Gate passed: python3 tools/qbe.py check (lake build; lake build Tests). closed_theorem_ok=false for full block certificate; next_route=CUBIC-HCOUNT-COUNT-001 or CUBIC-HCOUNT-UNITARY-001 symbolic bridge before CUBIC-HCOUNT-BLOCK-001.

## 2026-06-19 17:13:52 - lower

CUBIC-HCOUNT-REJECT-REPAIR-001 complete: inserted separate hcount-nonzero-column-reject label before nz cleanup, added exact-list/resource coverage, updated n=2 oracle-label tuple to (8, 8, 21, 8), and reran the finite n=1,2 semantic diagnostic with finite_matrix_ok=true and block_entry_ok=true for the repaired transcript. Old daggered nz-only route remains rejected. Gate passed: python3 tools/qbe.py check. Next route: symbolic separate-reject support/path-count or Hadamard-sandwich semantic bridge before CUBIC-HCOUNT-BLOCK-001.

## 2026-06-19 17:18:49 - reviewer

Reviewer gate passed: python3 tools/qbe.py check ran lake build and lake build Tests. No blocking issue found for CUBIC-HCOUNT-REJECT-REPAIR-001 as an interface/finite-feedback repair: the separate hcount-nonzero-column-reject transcript compiles, n=2 oracle-label tuple is (8,8,21,8), finite n=1,2 diagnostics pass for the repaired clean-block support, and closed_theorem_ok=false remains explicit. Candidate promotion remains blocked until a named Lean symbolic clean-block theorem plus required unitarity/reversibility leaves are build-tested; do not attempt CUBIC-HCOUNT-BLOCK-001 from the old daggered nz route. Advisory: blueprint Dynamic Leaf Queue extraction still includes prose/table headings as candidate leaves, so scheduling should use the explicit proof-DAG frontier and next route CUBIC-HCOUNT-COUNT-001 or CUBIC-HCOUNT-UNITARY-001.
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

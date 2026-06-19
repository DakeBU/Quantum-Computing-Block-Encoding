# Proof Blueprint: QBE-OP-CUBIC-STATEPREP-001

Task id: `QBE-OP-CUBIC-STATEPREP-001`
Title: Cubic grid state-preparation operator
Mode: `exploratoryConstruction`
Updated: `2026-06-19 16:13:29`
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
CubicStatePreparation.hardModeExactStallWindow = 2
CubicStatePreparation.hardModeConstructionStallWindow = 3
CubicStatePreparation.hardModeLevelCycleBudget = [2, 3, 4]
CubicStatePreparation.relaxedEpsilonLadder = [1e-10, 1e-8, 1e-6]
```

The upper panel must not jump directly to the largest panel.  The intended
schedule is:

| Phase | Trigger | Agent allocation | Goal |
|---|---|---|---|
| L0 exact contraction and candidate seeding | task starts or memory was stale | upper=1, middle=1, lower=3: candidate architect, Lean worker, verifier | seed at least one concrete `U_n` family while also closing target/norm leaves and rejecting wrong exact state-prep interpretations |
| L1 requested-epsilon Scenario 2 | no closed leaf or no concrete candidate for 2 cycles | upper=3, middle=2, lower=5: 2 architects, 2 Lean workers, 1 verifier/export worker | find or repair a symbolic approximate candidate at `1e-10` |
| L2 relaxed waypoint search | no improving certified/finite candidate for 3 cycles | upper=4, middle=3, lower=8 | try `1e-8`, then `1e-6` as waypoints, while keeping the final requested target visible |

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

- lower candidate architect: immediately propose one Lean-checkable candidate
  family `U_n`, with register layout, block projector, normalizer `alpha`,
  unitary argument, resource tier, and approximate error budget.  It is fine
  if some analytic leaves remain obligations; do not wait for `CUBIC-NORM-001`
  before naming a candidate.
- lower Lean worker: close one small exact diagnostic lemma or reusable
  rational normalizer lemma in parallel with candidate design.  Do not use this
  leaf as a serial gate that blocks candidate seeding.
- lower verifier/export worker: use the existing dense/Qiskit comparison as a
  baseline and, once a candidate architect names `U_n`, run fixed-instance
  necessary-condition checks for that candidate.  If no concrete candidate is
  available, write a typed feedback packet saying the blocker is
  `candidate_interface_gap`, not another norm-only retry.
- reviewer: reject any candidate that treats the unnormalized vector as a
  unitary output state without either normalization or block-encoding scaling.
````

## Dynamic Leaf Queue

These are the current local proof or repair candidates.  Lower agents should
work on one item at a time; if an item is stale, upper/middle must retire it
before spending more proof-search tokens.

| Leaf | Status |
|---|---|
| # Proof Obligations: QBE-OP-CUBIC-STATEPREP-001 | candidate |
| ## Target Obligations | candidate |
| / Obligation / Lean declaration or artifact / Status / | candidate |
| / Prove closed form for `sum_j (j/2^n)^6` / planned `CubicStatePreparation.cubicNormSq_closedForm`; DAG node CUBIC-NORM-001; proof design in `proof-attempts/QBE-OP-CUBIC-STATEPREP-001-CUBIC-NORM-001.md` / proof design recorded; active Lean leaf / | candidate |
| / Choose sharper normalizer `alpha` for final candidate, if useful / planned candidate-specific declaration / open / | candidate |
| ## Candidate Obligations | candidate |
| / Obligation / Status / | candidate |
| / CUBIC-NORM-001 / Closed rational formula for `cubicNormSq n`. / CUBIC-NORM-001A, `classical-sixth-power-sum` / lower Lean / planned `cubicNormSq_closedForm`; `proof-attempts/QBE-OP-CUBIC-STATEPREP-001-CUBIC-NORM-001.md` / proof design recorded; active Lea... | candidate |
| / CUBIC-HCOUNT-RATIO-001 / Prove `cubicAmplitude n j / conservativeNormalizer n = j.val^3 / (gridSize n)^4`. / CUBIC-HCOUNT-IFACE-001, `gridSize_rat_ne_zero` / future lower Lean / planned ratio lemma / active Lean leaf / | candidate |
| / CUBIC-VER-CAND-001 / Necessary-condition checks for a concrete finite instance of the rank-one wrapper or Hadamard-counting transcript. / CUBIC-CAND-SHAPE-001, CUBIC-HCOUNT-IFACE-001 / future verifier lower / planned verifier-feedback artifact / active ne... | candidate |
| / External technical lemma / `classical-sixth-power-sum` in `research-wiki/cited-results/classical-power-sums.md`, status `obligation` unless a Lean helper builds. / | candidate |
| / Not allowed in next lower packet / No normalized state-preparation shortcut and no certification claim for an unproved candidate. Candidate theorem shapes are allowed and expected; Lean closure is required before promotion. / | candidate |

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
| CUBIC-VER-CAND-001 | Necessary-condition checks for a concrete finite instance of the rank-one wrapper or Hadamard-counting transcript. | CUBIC-CAND-SHAPE-001, CUBIC-HCOUNT-IFACE-001 | future verifier lower | planned verifier-feedback artifact | active next diagnostic |
## Source-Correspondence Contract
| Source anchor | User/task contract in `tasks/QBE-OP-CUBIC-STATEPREP-001.md`; no paper archive is active. |
| External technical lemma | `classical-sixth-power-sum` in `research-wiki/cited-results/classical-power-sums.md`, status `obligation` unless a Lean helper builds. |
| Not allowed in next lower packet | No normalized state-preparation shortcut and no certification claim for an unproved candidate. Candidate theorem shapes are allowed and expected; Lean closure is required before promotion. |
wrapper resource tuple, and pointwise bridge from the clean-block contract to
`O_n`.  The remaining blocker is semantic: choose finite matrices/contracts
unitarity obligations.
now has compiled layout/circuit/resource declarations, a clean-block contract
normalizer; the next Lean leaf is the ratio lemma connecting
```

## Lean Declaration Index

Recent task-relevant declarations:

| Kind | Lean name | File |
|---|---|---|
| theorem | `hadamardCountingCubicResource_eq` | `QuantumBlockEncoding/CubicStatePreparation.lean:334` |
| theorem | `hadamardCountingCubicLayout_auxiliaryQubits` | `QuantumBlockEncoding/CubicStatePreparation.lean:340` |
| theorem | `hadamardCountingCubicResourceTuple_n2` | `QuantumBlockEncoding/CubicStatePreparation.lean:346` |
| def | `hadamardCountingCubicClaim` | `QuantumBlockEncoding/CubicStatePreparation.lean:354` |
| def | `hardModeUpperAgentSchedule` | `QuantumBlockEncoding/CubicStatePreparation.lean:376` |
| def | `hardModeMiddleAgentSchedule` | `QuantumBlockEncoding/CubicStatePreparation.lean:378` |
| def | `hardModeLowerAgentSchedule` | `QuantumBlockEncoding/CubicStatePreparation.lean:380` |
| def | `hardModeExactStallWindow` | `QuantumBlockEncoding/CubicStatePreparation.lean:383` |
| def | `hardModeConstructionStallWindow` | `QuantumBlockEncoding/CubicStatePreparation.lean:389` |
| def | `hardModeLevelCycleBudget` | `QuantumBlockEncoding/CubicStatePreparation.lean:392` |
| def | `relaxedEpsilonLadder` | `QuantumBlockEncoding/CubicStatePreparation.lean:400` |
| theorem | `relaxedEpsilonLadder_startsWithRequested` | `QuantumBlockEncoding/CubicStatePreparation.lean:403` |
| theorem | `hardModeSchedules_have_three_levels` | `QuantumBlockEncoding/CubicStatePreparation.lean:407` |
| theorem | `hardModeLowerAgentSchedule_final` | `QuantumBlockEncoding/CubicStatePreparation.lean:414` |
| def | `initialExpectedPhase` | `QuantumBlockEncoding/CubicStatePreparation.lean:423` |
| theorem | `gridSize_pos` | `QuantumBlockEncoding/CubicStatePreparation.lean:426` |
| theorem | `cubicOperator_first_column` | `QuantumBlockEncoding/CubicStatePreparation.lean:429` |
| theorem | `cubicOperator_only_first_column` | `QuantumBlockEncoding/CubicStatePreparation.lean:433` |
| def | `rankOneCleanBlockContract` | `QuantumBlockEncoding/CubicStatePreparation.lean:446` |
| def | `arithmeticRankOneCubicCleanBlockContract` | `QuantumBlockEncoding/CubicStatePreparation.lean:453` |
| theorem | `rankOneCleanBlockContract_pointwise_eq` | `QuantumBlockEncoding/CubicStatePreparation.lean:461` |
| theorem | `arithmeticRankOneCubicCleanBlockContract_pointwise_eq` | `QuantumBlockEncoding/CubicStatePreparation.lean:481` |
| def | `hadamardCountingCubicCleanBlockContract` | `QuantumBlockEncoding/CubicStatePreparation.lean:490` |
| theorem | `hadamardCountingCubicCleanBlockContract_pointwise_eq` | `QuantumBlockEncoding/CubicStatePreparation.lean:498` |
| theorem | `rat_cube_sq_eq_sixth` | `QuantumBlockEncoding/CubicStatePreparation.lean:506` |
| theorem | `cubicAmplitude_sq_eq_gridPoint_sixth` | `QuantumBlockEncoding/CubicStatePreparation.lean:513` |
| theorem | `cubicNormSq_sixthPowerFold` | `QuantumBlockEncoding/CubicStatePreparation.lean:518` |
| theorem | `gridSize_rat_ne_zero` | `QuantumBlockEncoding/CubicStatePreparation.lean:525` |
| theorem | `gridSize_rat_pos` | `QuantumBlockEncoding/CubicStatePreparation.lean:530` |
| theorem | `gridPoint_nonneg` | `QuantumBlockEncoding/CubicStatePreparation.lean:534` |
| theorem | `gridPoint_lt_one` | `QuantumBlockEncoding/CubicStatePreparation.lean:543` |
| theorem | `gridPoint_le_one` | `QuantumBlockEncoding/CubicStatePreparation.lean:550` |
| theorem | `rat_pow_le_one_of_nonneg_le_one` | `QuantumBlockEncoding/CubicStatePreparation.lean:554` |
| theorem | `cubicAmplitude_sq_le_one` | `QuantumBlockEncoding/CubicStatePreparation.lean:568` |
| theorem | `foldl_add_le_add_length` | `QuantumBlockEncoding/CubicStatePreparation.lean:574` |
| theorem | `cubicNormSq_le_gridSize` | `QuantumBlockEncoding/CubicStatePreparation.lean:600` |
| theorem | `gridSize_rat_le_sq` | `QuantumBlockEncoding/CubicStatePreparation.lean:612` |
| theorem | `cubicNormSq_le_conservativeNormalizer_sq` | `QuantumBlockEncoding/CubicStatePreparation.lean:624` |
| theorem | `cubicNormSq_le_arithmeticCubicNormalizer_sq` | `QuantumBlockEncoding/CubicStatePreparation.lean:635` |
| theorem | `cubicNormSq_le_hadamardCountingCubicNormalizer_sq` | `QuantumBlockEncoding/CubicStatePreparation.lean:645` |
| theorem | `cubicNormSq_n1` | `QuantumBlockEncoding/CubicStatePreparation.lean:650` |
| theorem | `cubicNormSq_n2` | `QuantumBlockEncoding/CubicStatePreparation.lean:654` |
| theorem | `cubicNormSq_n3` | `QuantumBlockEncoding/CubicStatePreparation.lean:658` |
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
 then rerun finite support/block-entry verifier.

## 2026-06-19 15:13:16 - lower

Lower worker 5 handoff: compiled reusable CUBIC-CAND-SHAPE-001 clean-block contract bridge in CubicStatePreparation. rankOneCleanBlockContract states scaled first column equals cubicAmplitude and nonfirst clean columns vanish; rankOneCleanBlockContract_pointwise_eq and arithmeticRankOneCubicCleanBlockContract_pointwise_eq prove the contract scales pointwise to cubicOperator. Gate passed via python3 tools/qbe.py check. This is not a certified unitary/block theorem: finite semantics, unitarity, ancilla cleanup, and operator-norm approximation remain open. Next route: instantiate finite semantic clean-block matrix for the rank-one wrapper or implement CUBIC-HCOUNT-IFACE-001, then test n=1 or n=2 before symbolic proof search.

## 2026-06-19 15:14:20 - lower

CUBIC-CAND-SHAPE-001 refiner handoff: kept the target unchanged and rejected direct block-entry proof over arithmeticCubicCircuit as shape_or_register_gap. Added compiled arithmeticRankOneCubic* wrapper interface around the arithmetic middle block, with zero-input filter, row-generation label, cleanup label, normalizer reuse, oracle-tier resource tuple, and default n=2 p=40 tuple (10,10,52,10). Gate python3 tools/qbe.py check passed. Semantic matrix, unitarity, clean-block, and finite n=1/n=2 wrapper verifier remain open; next route is finite semantic verifier before symbolic clean-block proof.

## 2026-06-19 15:14:29 - lower

CUBIC-HCOUNT-001 proof architecture recorded in proof-attempts/QBE-OP-CUBIC-STATEPREP-001-CUBIC-CAND-SHAPE-001.md. It reuses the compiled rankOneCleanBlockContract bridge and proposes an exact Hadamard-sandwich path-counting candidate: split path bits as r:n and t:3n, reject c != 0 with a non-clean flag, and count t < j^3 so the clean entry is j^3/2^(4n)=cubicAmplitude n j/conservativeNormalizer n. Gate passed: python3 tools/qbe.py check. Next route: implement CUBIC-HCOUNT-IFACE-001 layout/circuit/resource declarations, then run n=1 or n=2 clean-block finite diagnostics before symbolic Hadamard semantics.

## 2026-06-19 15:19:48 - reviewer

Reviewer gate passed: python3 tools/qbe.py check completed lake build and lake build Tests. No task-local hidden sorry/trivial proof was found in the cubic Lean diff, and the cubic candidate remains correctly unpromoted. Blocking for candidate promotion: arithmeticRankOneCubic* is still an oracle-label transcript plus clean-block contract bridge, not a semantic U_n/unitarity/clean-block/error certificate. Advisory cleanup before next lower scheduling: retire stale CUBIC-VER-CAND-001 feedback that says the candidate interface is missing, update stale proof-attempt/candidate-population text that still treats CUBIC-ALPHA-001 as open, sharpen the classical-sixth-power-sum cited-result source if the closed-form route uses it externally, and do not rely on qbe.py sorry summaries for a project-wide no-sorry claim because RobinMatrix sorry lines are filtered there.
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

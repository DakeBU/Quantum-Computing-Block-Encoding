# Conversion Window: Cubic grid state-preparation operator

Task id: `QBE-OP-CUBIC-STATEPREP-001`
Created: `2026-06-19 12:25:54`

This is the controlled crossing between the user operator requirement, concise
human explanation, and Lean.  This task has no paper-source archive; the source
anchor is the user/task contract in `tasks/QBE-OP-CUBIC-STATEPREP-001.md`.
Do not move a symbol into Lean without recording its type, role,
normalization, and acceptance condition.

## Source Input

There is no paper theorem or figure fragment for this exploratory construction.
The object being translated is the user-specified cubic grid operator:

$$
N = 2^n,\qquad x_j = j/N,\qquad v_n[j] = x_j^3.
$$

ABEIS fixes the Lean-checkable target as the rank-one map

$$
O_n = |v_n><0^n|.
$$

This map sends the computational basis input `0 : Fin (gridSize n)` to the
unnormalized vector `v_n` and sends every other basis input to zero.  A
normalized state-preparation unitary is a different task.

## Symbol Map

| Source symbol | Markdown meaning | Lean name | Type / role | Status |
| --- | --- | --- | --- | --- |
| `n` | number of system qubits | argument to declarations | `Nat` | compiled as parameter |
| `N` | grid size `2^n` | `gridSize n` | `Nat` dimension | compiled |
| `x_j` | grid point `j / 2^n` | `CubicStatePreparation.gridPoint` | `Fin (gridSize n) -> Rat` | compiled |
| `v_n[j]` | cubic amplitude `(j/2^n)^3` | `CubicStatePreparation.cubicAmplitude` | `Fin (gridSize n) -> Rat` | compiled |
| `O_n` | rank-one operator `|v_n><0^n|` | `CubicStatePreparation.cubicOperator` | `Matrix (gridSize n) (gridSize n) Rat` | compiled |
| `||v_n||^2` | exact rational squared norm | `CubicStatePreparation.cubicNormSq` | `Rat` diagnostic | compiled definition, closed form open |
| `epsilon` | requested error tolerance `1e-10` | `CubicStatePreparation.requestedEpsilon` | `Rat` | compiled |
| `alpha` | block-encoding normalizer | `CubicStatePreparation.conservativeNormalizer`, `CubicStatePreparation.arithmeticCubicNormalizer`, `CubicStatePreparation.hadamardCountingCubicNormalizer` | `Rat` | conservative bridge plus arithmetic and Hadamard-counting route bridges compiled; sharper candidate alpha open |
| `U_n` | candidate unitary/circuit matrix | `CubicStatePreparation.arithmeticRankOneCubicCircuit` and `hadamardCountingCubicCircuit` seed candidate transcripts | matrix on `gridSize (n+a)` | transcript interfaces seeded; semantic matrix open |
| `a` | auxiliary qubits for block extraction | `CubicStatePreparation.arithmeticRankOneCubicLayout`, `CubicStatePreparation.hadamardCountingCubicLayout` | `Nat` | compiled for wrapped and Hadamard-counting routes |
| clean block | projected signal-system block of `U_n` | `CubicStatePreparation.rankOneCleanBlockContract`, `arithmeticRankOneCubicCleanBlockContract`, `hadamardCountingCubicCleanBlockContract` | `Prop` | contract bridges compiled; semantic proof open |

## Source-Contract Audit

| Item | Contract |
| --- | --- |
| Source anchor | User/task contract in `tasks/QBE-OP-CUBIC-STATEPREP-001.md`; no paper archive detected. |
| Paper object | Not a paper theorem.  The active object is the operator target `O_n = |v_n><0^n|`. |
| System input register | `n` qubits, basis index `col : Fin (gridSize n)`. |
| System output register | `n` qubits, basis index `row : Fin (gridSize n)`. |
| Target entries | `cubicOperator n row col = cubicAmplitude n row` when `col.val = 0`, and `0` otherwise. |
| Claimed oracle behavior | No candidate oracle or circuit behavior is claimed yet. |
| Ancilla registers | Unknown until a candidate `U_n` is proposed.  Future candidates must state signal qubits and pure clean ancillas separately. |
| Block projector | Planned clean signal-system projection `(<0^a| tensor I) U_n (|0^a> tensor I)`. |
| Normalizer | `conservativeNormalizer n = gridSize n` is compiled as a safe placeholder, and `cubicNormSq_le_conservativeNormalizer_sq` proves the direct entrywise bound for it.  The arithmetic and Hadamard-counting routes reuse the same alpha through `cubicNormSq_le_arithmeticCubicNormalizer_sq` and `cubicNormSq_le_hadamardCountingCubicNormalizer_sq`. |
| Acceptance inequality | Scenario 2 target is `|| O_n - alpha * ((<0^a| tensor I) U_n (|0^a> tensor I)) || <= requestedEpsilon`. |
| Resource expression | Candidate must record asymptotic tier first, then `(gateCount, depth, auxiliaryQubits, oracleCalls)` inside that tier. |

## Ownership Split

| Class | Owned here |
| --- | --- |
| Active user target | The definitions of `gridPoint`, `cubicAmplitude`, `cubicOperator`, `cubicNormSq`, `requestedEpsilon`, and the rank-one interpretation of the unnormalized vector. |
| External contract | A classical sixth-power sum identity is needed for the closed rational norm formula.  A direct conservative-bound route may avoid this identity, but every inequality must still be proved in Lean.  Future arithmetic and rotation-synthesis subroutines are also external contracts until named. |
| QBE-local semantic glue | `QueryOperatorTarget`, `OperatorBlockEncodingCandidate`, `ApproximateOperatorBlockEncodingCandidate`, normalizer bookkeeping, clean-block projection convention, verifier-feedback fields, and resource scoring. |

## Current Source-Correspondence Sync

Upper source/visual audit for the current run found no paper-source archive and
no contract drift.  The source anchor is the user/task contract, and the object
being translated is the unnormalized rank-one operator `O_n = |v_n><0^n|`.
The current run packet re-opens candidate seeding in parallel with the norm
bridge.  `CUBIC-CAND-001` records the arithmetic-transduction middle block in
Lean, and `CUBIC-CAND-SHAPE-001` now records the rank-one wrapper with
zero-input filtering, row generation, wrapper resource tuple, and a pointwise
clean-block contract bridge.  The semantic unitary matrix and finite verifier
for the wrapper labels remain open.  `CUBIC-HCOUNT-001` adds an exact
Hadamard-sandwich path-counting mutation that reuses the same clean-block
contract and targets the entry identity `j^3 / 2^(4*n) = v_n[j] / alpha`;
its layout, transcript, resource tuple, clean-block contract bridge,
normalizer bridge, and ratio bridge are compiled.  The finite semantic
diagnostic `CUBIC-VER-CAND-001:HCOUNT-SEMANTIC` rejected the old daggered
nonzero-flag transcript: nonzero input columns return to clean ancillas and
leak identity entries.  `CUBIC-HCOUNT-REJECT-REPAIR-001` is now compiled as a
separate nonzero-column reject signal in the transcript; the repaired finite
semantic diagnostic passes for `n = 1, 2`.  Cycle 3 fixes the next active
route as `CUBIC-HCOUNT-COUNT-001`: a symbolic threshold path-count leaf for the
repaired Hadamard-counting branch.  The separate-reject convention is no longer
up for selection; it is a compiled dependency unless a later symbolic semantic
proof finds a contradiction.

## Markdown Explanation

The target vector is not normalized, so the construction target is not a
standalone state-preparation unitary.  The Lean target is the rank-one operator
whose first column is the cubic grid vector and whose other columns are zero.

The conservative norm/normalizer bridge is now compiled through the direct
entrywise upper bound.  The exact closed rational expression for `cubicNormSq n`
remains open as a diagnostic theorem.  In parallel, the first candidate route
is named at the transcript/resource level, and the rank-one wrapper shape is
now compiled.  The Hadamard-counting zero-input rejection convention has a
compiled separate-reject repair and finite semantic support check, but this is
still only interface and executable evidence.  The next proof obligation is a
symbolic threshold path-count theorem before the clean-block theorem.

The expected scalable candidate family is reversible arithmetic for `j/2^n`,
cubic evaluation, and controlled rotation or equivalent amplitude transduction.
Dense-table preparation remains a finite-instance baseline and verifier smoke
test, not a scalable certified parent.

## Proof-Translation Map

No paper proof exists for this task.  The user requirement is translated as the
following ordered Lean-facing proof map.

| Step | Source anchor | Lean mapping | Status |
| --- | --- | --- | --- |
| Define the grid `N = 2^n` and points `x_j = j/N`. | User target. | `gridSize`, `gridPoint`. | compiled |
| Define amplitudes `v_n[j] = x_j^3`. | User target. | `cubicAmplitude`. | compiled |
| Interpret the unnormalized vector as a rank-one operator. | Task contract normalization warning. | `gridSize_pos`, `cubicOperator`, `cubicOperator_first_column`, `cubicOperator_only_first_column`. | compiled |
| Normalize the norm summand `(v_n[j])^2` to `(j/2^n)^6`. | Target norm diagnostic. | `rat_cube_sq_eq_sixth`, `cubicAmplitude_sq_eq_gridPoint_sixth`, `cubicNormSq_sixthPowerFold`. | compiled |
| Compute or bound `||v_n||^2 = sum_j (j/2^n)^6`. | Target norm diagnostic. | `cubicNormSq_le_conservativeNormalizer_sq`, `cubicNormSq_le_arithmeticCubicNormalizer_sq`, `cubicNormSq_le_hadamardCountingCubicNormalizer_sq`; planned `cubicNormSq_closedForm` remains open. | compiled direct bounds; closed form open |
| Choose a normalizer `alpha` and record the block projector. | Operator block-encoding acceptance target. | `arithmeticRankOneCubicNormalizer = conservativeNormalizer`; `hadamardCountingCubicNormalizer = conservativeNormalizer`; `rankOneCleanBlockContract` states the clean-block target. | candidate alpha and pointwise contract bridges compiled; semantic block proof open |
| Seed the arithmetic middle-block transcript. | Scenario 2 candidate interface. | `arithmeticCubicLayout`, `arithmeticCubicCircuit`, `arithmeticCubicResourceTuple`, `arithmeticCubicClaim`. | compiled middle-block interface |
| Seed the rank-one wrapped candidate transcript. | Shape repair for `O_n = |v_n><0^n|`. | `arithmeticRankOneCubicLayout`, `arithmeticRankOneCubicCircuit`, `arithmeticRankOneCubicResourceTuple`, `arithmeticRankOneCubicClaim`. | compiled wrapper interface; semantic proof open |
| Design exact Hadamard-counting mutation. | Shape repair with exact dyadic clean entries. | `hadamardCountingCubicLayout`, `hadamardCountingCubicCircuit`, `hadamardCountingCubicResourceTuple`, `hadamardCountingCubicCleanBlockContract_pointwise_eq`; proof note `CUBIC-HCOUNT-001`. | Lean interface and contract bridge compiled; semantic proof open |
| Prove Hadamard-counting ratio bridge. | Exact scaled entry identity. | `rat_div_cube_div_eq`, `cubicAmplitude_div_conservativeNormalizer_eq`. | compiled; semantic proof still open |
| Reject the old daggered nonzero-flag transcript. | Finite necessary-condition diagnostic. | `verifier-feedback/QBE-OP-CUBIC-STATEPREP-001/cubic-ver-cand-001-hcount-semantic.md`. | completed rejected feedback: `finite_matrix_ok=false`, `block_entry_ok=false` |
| Repair nonzero-column rejection. | Same target operator and Hadamard-counting route. | `hadamardCountingCubicCircuit_rejectSignalRepair`, `hadamardCountingCubicResource_eq`, `hadamardCountingCubicResourceTuple_n2`, focused tests, and proof attempt `QBE-OP-CUBIC-STATEPREP-001-CUBIC-HCOUNT-REJECT-REPAIR-001.md`. | compiled; repaired finite diagnostic passed; symbolic clean-block proof open |
| Prove threshold path counting. | Hadamard-counting accepted-path formula. | planned `gridSize_three_mul_eq_cube`, `gridSize_four_mul_eq_fourth`, `hadamardCountingCubic_threshold_le_pathCapacity`, and `hadamardCountingCubic_thresholdPathCount`; proof attempt `QBE-OP-CUBIC-STATEPREP-001-CUBIC-HCOUNT-COUNT-001.md`. | active leaf |
| Prove a candidate approximate block encoding. | Scenario 2 policy. | planned `VerifiedApproximateOperatorBlockEncoding` instance or theorem. | open |

## Proof-DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
| --- | --- | --- | --- | --- | --- | --- | --- |
| CUBIC-TGT-001 | Target operator entries for `O_n = |v_n><0^n|`. | none | middle/Lean target | `gridSize_pos`, `cubicOperator`, `cubicOperator_first_column`, `cubicOperator_only_first_column` | this window, Symbol Map | `python3 tools/qbe.py check` | proved |
| CUBIC-DIAG-001 | Small exact norm diagnostics for `n = 1, 2, 3`. | CUBIC-TGT-001 | lower historical | `cubicNormSq_n1`, `cubicNormSq_n2`, `cubicNormSq_n3` | proof obligations | `python3 tools/qbe.py check` | proved, retired |
| CUBIC-NORM-001A | Rewrite `cubicNormSq n` as a fold over `gridPoint n j ^ 6`. | CUBIC-TGT-001 | lower Lean refiner | `rat_cube_sq_eq_sixth`, `cubicAmplitude_sq_eq_gridPoint_sixth`, `cubicNormSq_sixthPowerFold` | proof obligations, this window | `python3 tools/qbe.py check` | proved |
| CUBIC-NORM-001 | Closed rational form for `sum_j (j / 2^n)^6`. | CUBIC-NORM-001A, classical sixth-power sum | future lower Lean | planned `cubicNormSq_closedForm` | this window, `proof-attempts/QBE-OP-CUBIC-STATEPREP-001-CUBIC-NORM-001.md` | `python3 tools/qbe.py check` | proof design recorded; diagnostic backlog, not a serial blocker |
| CUBIC-ALPHA-001 | Prove chosen `alpha` is compatible with the target norm. | Direct entrywise norm bound | lower Lean | `cubicNormSq_le_conservativeNormalizer_sq`, `cubicNormSq_le_arithmeticCubicNormalizer_sq`, `cubicNormSq_le_hadamardCountingCubicNormalizer_sq` | proof obligations | `lake build && lake build Tests` | proved |
| CUBIC-ERR-001 | Arithmetic approximation and rotation/transduction error budget sums to `1e-10`. | CUBIC-ALPHA-001, CUBIC-CAND-SHAPE-001 | lower architect | `proof-attempts/QBE-OP-CUBIC-STATEPREP-001-CUBIC-ERR-001.md` plus future Lean targets | candidate population | `python3 tools/qbe.py check` | designed, blocked on wrapper semantics |
| CUBIC-CAND-001 | Arithmetic-transduction middle block, layout, normalizer, and resource tuple. | CUBIC-TGT-001 | lower worker 5 / lower proof architect | `arithmeticCubicLayout`, `arithmeticCubicCircuit`, `arithmeticCubicNormalizer`, `arithmeticCubicResourceTuple`, `arithmeticCubicClaim`; `proof-attempts/QBE-OP-CUBIC-STATEPREP-001-CUBIC-CAND-001.md` | candidate population | `python3 tools/qbe.py check` | compiled middle-block interface |
| CUBIC-CAND-SHAPE-001 | Rank-one wrapper transcript, resource tuple, clean-block contract, and target-shape bridge. | CUBIC-CAND-001, CUBIC-TGT-001 | lower Lean refiner | `arithmeticRankOneCubicLayout`, `arithmeticRankOneCubicCircuit`, `arithmeticRankOneCubicResourceTuple`, `arithmeticRankOneCubicClaim`, `arithmeticRankOneCubicCleanBlockContract_pointwise_eq`; `proof-attempts/QBE-OP-CUBIC-STATEPREP-001-CUBIC-CAND-SHAPE-001.md` | candidate population, proof obligations | `python3 tools/qbe.py check` | compiled wrapper interface; semantic matrix open |
| CUBIC-HCOUNT-001 | Hadamard-sandwich path counting realizes exact scaled entries `j^3 / 2^(4*n)`. | CUBIC-CAND-SHAPE-001, CUBIC-ALPHA-001 | lower proof architect / future Lean | `hadamardCountingCubicLayout`, `hadamardCountingCubicCircuit`, `hadamardCountingCubicResourceTuple`, `hadamardCountingCubicCleanBlockContract_pointwise_eq`, `cubicNormSq_le_hadamardCountingCubicNormalizer_sq` | candidate population, proof obligations | `python3 tools/qbe.py check` | interface, normalizer bridge, and reject repair compiled; semantic proof open |
| CUBIC-HCOUNT-IFACE-001 | Hadamard-counting layout, transcript, normalizer, resource tuple, clean-block contract bridge, and normalizer bridge. | CUBIC-TGT-001, CUBIC-ALPHA-001 | lower Lean | `hadamardCountingCubicLayout`, `hadamardCountingCubicCircuit`, `hadamardCountingCubicNormalizer`, `hadamardCountingCubicResourceTuple`, `hadamardCountingCubicCleanBlockContract_pointwise_eq`, `cubicNormSq_le_hadamardCountingCubicNormalizer_sq` | candidate population, proof obligations | `python3 tools/qbe.py check` | compiled interface; not a certificate |
| CUBIC-HCOUNT-RATIO-001 | Algebra bridge from `v_n[j] / alpha` to `j^3 / (gridSize n)^4`. | CUBIC-HCOUNT-001, rational division algebra | lower Lean | `rat_div_cube_div_eq`, `cubicAmplitude_div_conservativeNormalizer_eq` | proof obligations | `python3 tools/qbe.py check` | proved; semantic Hadamard-counting proof still open |
| CUBIC-VER-CAND-001:HCOUNT-SEMANTIC | Fixed-instance necessary-condition check for the old daggered route and repaired separate-reject route. | CUBIC-HCOUNT-IFACE-001, CUBIC-HCOUNT-RATIO-001 proof map | verifier lower | `verifier-feedback/QBE-OP-CUBIC-STATEPREP-001/cubic-ver-cand-001-hcount-semantic.md` | verifier-feedback | `python3 tools/qbe.py check` plus finite script | repaired finite diagnostic passed; old daggered route remains rejected |
| CUBIC-HCOUNT-REJECT-REPAIR-001 | Repair the zero-input rejection convention so nonzero input columns cannot return clean identity entries. | CUBIC-HCOUNT-IFACE-001, CUBIC-HCOUNT-RATIO-001, CUBIC-VER-CAND-001:HCOUNT-SEMANTIC | lower Lean | `hadamardCountingCubicCircuit_rejectSignalRepair`, `hadamardCountingCubicResource_eq`, `hadamardCountingCubicResourceTuple_n2`, focused `Tests/Basic.lean` checks | this window, proof obligations, candidate population | `python3 tools/qbe.py check` plus finite script | proved dependency; retired |
| CUBIC-HCOUNT-COUNT-001 | Prove the symbolic count of accepted threshold paths: for fixed row `j`, exactly `j.val ^ 3` values of `t : Fin (gridSize (3 * n))` satisfy `t.val < j.val ^ 3`. | CUBIC-HCOUNT-RATIO-001, CUBIC-HCOUNT-REJECT-REPAIR-001, finite path diagnostic | lower Lean | planned `gridSize_three_mul_eq_cube`, `gridSize_four_mul_eq_fourth`, `hadamardCountingCubic_threshold_le_pathCapacity`, `hadamardCountingCubic_thresholdPathCount` | `proof-attempts/QBE-OP-CUBIC-STATEPREP-001-CUBIC-HCOUNT-COUNT-001.md` | `python3 tools/qbe.py check` | active leaf |
| CUBIC-HCOUNT-UNITARY-001 | Prove the repaired transcript is unitary as Hadamards plus reversible arithmetic/permutation labels. | CUBIC-HCOUNT-COUNT-001, future semantics for oracle labels | future lower Lean | planned semantic theorem | this window, proof obligations | `python3 tools/qbe.py check` | blocked internal |
| CUBIC-HCOUNT-BLOCK-001 | Prove the repaired clean block satisfies `hadamardCountingCubicCleanBlockContract n block`. | CUBIC-HCOUNT-COUNT-001, CUBIC-HCOUNT-UNITARY-001, Hadamard-sandwich semantic lemma | future lower Lean | planned clean-block theorem | this window, proof obligations | `python3 tools/qbe.py check` | blocked internal |
| CUBIC-HCOUNT-APPROX-001 | Package exact error `0` into the requested approximate block-encoding record at `requestedEpsilon`. | CUBIC-HCOUNT-BLOCK-001, positivity of `requestedEpsilon` | future lower Lean | planned `VerifiedApproximateOperatorBlockEncoding` witness | this window, candidate population | `python3 tools/qbe.py check` | blocked internal |
| CUBIC-VER-001 | Dense-vs-symbolic scaling diagnostics and same-target finite external checks. | CUBIC-TGT-001 | verifier lower | `verifier-feedback/QBE-OP-CUBIC-STATEPREP-001/cubic-ver-001-scaling.md`, `reports/cubic-stateprep/external_comparison.md` | verifier-feedback | `python3 tools/qbe.py check` plus local Qiskit run | diagnostic complete, not a certificate |

## Lean Declaration Plan

| Declaration | File | Purpose | Builds? |
| --- | --- | --- | --- |
| `gridSize_pos` | `QuantumBlockEncoding/CubicStatePreparation.lean` | local dimension witness for the zero input column `0 : Fin (gridSize n)` | compiled |
| `cubicOperator_first_column` | `QuantumBlockEncoding/CubicStatePreparation.lean` | proves the clean first column of `O_n` is exactly the unnormalized cubic vector | compiled |
| `rat_cube_sq_eq_sixth` | `QuantumBlockEncoding/CubicStatePreparation.lean` | rational exponent bridge `(x^3)^2 = x^6` for the norm summand | compiled |
| `cubicAmplitude_sq_eq_gridPoint_sixth` | `QuantumBlockEncoding/CubicStatePreparation.lean` | task-local summand rewrite from cubic amplitudes to sixth powers | compiled |
| `cubicNormSq_sixthPowerFold` | `QuantumBlockEncoding/CubicStatePreparation.lean` | rewrites the existing norm fold as a sixth-power fold | compiled |
| `cubicNormSq_closedForm` | `QuantumBlockEncoding/CubicStatePreparation.lean` | closed rational norm expression for `sum_j (j/2^n)^6` | planned |
| `cubicNormSq_le_conservativeNormalizer_sq` | `QuantumBlockEncoding/CubicStatePreparation.lean` | prove the compiled placeholder normalizer is sufficient for the target norm | compiled |
| `arithmeticCubicLayout` | `QuantumBlockEncoding/CubicStatePreparation.lean` | first route register layout: one signal qubit plus arithmetic workspace | compiled |
| `arithmeticCubicCircuit` | `QuantumBlockEncoding/CubicStatePreparation.lean` | oracle-level arithmetic-transduction transcript | compiled |
| `arithmeticCubicNormalizer` | `QuantumBlockEncoding/CubicStatePreparation.lean` | first route normalizer, currently `conservativeNormalizer n` | compiled; candidate proof bridge compiled as `cubicNormSq_le_arithmeticCubicNormalizer_sq` |
| `arithmeticCubicResourceTuple` | `QuantumBlockEncoding/CubicStatePreparation.lean` | candidate score tuple `(gateCount, depth, auxiliaryQubits, oracleCalls)` for the unexpanded-oracle tier | compiled |
| `arithmeticCubicClaim` | `QuantumBlockEncoding/CubicStatePreparation.lean` | human-facing construction claim for the candidate archive | compiled; not certified |
| `arithmeticRankOneCubicLayout` | `QuantumBlockEncoding/CubicStatePreparation.lean` | rank-one wrapper layout with zero-input and row-generation workspace | compiled |
| `arithmeticRankOneCubicCircuit` | `QuantumBlockEncoding/CubicStatePreparation.lean` | rank-one wrapper transcript around the arithmetic middle block | compiled |
| `arithmeticRankOneCubicResourceTuple` | `QuantumBlockEncoding/CubicStatePreparation.lean` | wrapped resource tuple `(gateCount, depth, auxiliaryQubits, oracleCalls)` | compiled |
| `arithmeticRankOneCubicClaim` | `QuantumBlockEncoding/CubicStatePreparation.lean` | human-facing wrapped construction claim for the candidate archive | compiled; not certified |
| `arithmeticRankOneCubicCleanBlockContract_pointwise_eq` | `QuantumBlockEncoding/CubicStatePreparation.lean` | bridge from the wrapped clean-block contract to `cubicOperator` | compiled; semantic clean-block proof open |
| `hadamardCountingCubicLayout` | `QuantumBlockEncoding/CubicStatePreparation.lean` | exact path-counting mutation layout with reject signal, nonzero flag, `4*n` path qubits, and arithmetic workspace | compiled |
| `hadamardCountingCubicCircuit` | `QuantumBlockEncoding/CubicStatePreparation.lean` | Hadamard-sandwich transcript with a separate nonzero-column reject signal | compiled |
| `hadamardCountingCubicCircuit_rejectSignalRepair` | `QuantumBlockEncoding/CubicStatePreparation.lean` | exact-list theorem for the repaired `CUBIC-HCOUNT-REJECT-REPAIR-001` transcript | compiled |
| `hadamardCountingCubicResourceTuple` | `QuantumBlockEncoding/CubicStatePreparation.lean` | resource tuple for the exact path-counting route | compiled |
| `cubicNormSq_le_hadamardCountingCubicNormalizer_sq` | `QuantumBlockEncoding/CubicStatePreparation.lean` | route-specific normalizer bridge for Hadamard counting | compiled |
| `rat_div_cube_div_eq` | `QuantumBlockEncoding/CubicStatePreparation.lean` | core rational identity `(a / b)^3 / b = a^3 / b^4` for the Hadamard-counting path ratio | compiled |
| `cubicAmplitude_div_conservativeNormalizer_eq` | `QuantumBlockEncoding/CubicStatePreparation.lean` | active ratio leaf connecting `v_n[j] / alpha` to `j^3 / (gridSize n)^4` | compiled |
| `gridSize_three_mul_eq_cube` | `QuantumBlockEncoding/CubicStatePreparation.lean` | planned path-register capacity identity `gridSize (3 * n) = gridSize n ^ 3` | active leaf |
| `gridSize_four_mul_eq_fourth` | `QuantumBlockEncoding/CubicStatePreparation.lean` | planned path-space denominator identity `gridSize (4 * n) = gridSize n ^ 4` | active leaf |
| `hadamardCountingCubic_threshold_le_pathCapacity` | `QuantumBlockEncoding/CubicStatePreparation.lean` | planned bound `j.val ^ 3 <= gridSize (3 * n)` for the threshold register | active leaf |
| `hadamardCountingCubic_thresholdPathCount` | `QuantumBlockEncoding/CubicStatePreparation.lean` | planned count of `t : Fin (gridSize (3 * n))` with `t.val < j.val ^ 3` | active leaf |
| `cubicApproxArithmeticBudget` | task-local Markdown now, Lean later | split total error into arithmetic, rotation, and block-extraction components | planned |
| candidate `U_n` declaration | future Lean module or this file if small | matrix/circuit transcript for a concrete approximate block encoding | open |

## Lean Scratch

```lean
namespace QuantumBlockEncoding
namespace CubicStatePreparation

-- Planned active leaf.  Lower may adjust the theorem name if the implementation
-- needs a small helper lemma first, but the mathematical target should not move.
theorem cubicNormSq_closedForm (n : Nat) :
    cubicNormSq n =
      let N : Rat := (gridSize n : Rat)
      ((N - 1) * (2 * N - 1) *
        (3 * N ^ 4 - 6 * N ^ 3 + 3 * N + 1)) /
        (42 * N ^ 5) := by
  -- planned
  sorry

-- Compiled in the source file:
#check cubicNormSq_le_conservativeNormalizer_sq

end CubicStatePreparation
end QuantumBlockEncoding
```

## Proof Obligations

- [x] Matrix/operator target is represented in Lean.
- [x] Natural-language norm/normalizer proof design is recorded in `proof-attempts/QBE-OP-CUBIC-STATEPREP-001-CUBIC-NORM-001.md`.
- [x] A sufficient rational norm bound is proved by `cubicNormSq_le_conservativeNormalizer_sq`; the closed rational norm formula remains open.
- [x] Conservative normalizer `alpha = conservativeNormalizer n` is related to the norm.
- [x] Candidate middle-block transcript and resource interface are represented
  in Lean by `arithmeticCubicCircuit` and `arithmeticCubicResourceTuple`.
- [x] Candidate rank-one shape audit is recorded in `proof-attempts/QBE-OP-CUBIC-STATEPREP-001-CUBIC-CAND-001.md`.
- [x] Candidate rank-one wrapper transcript and oracle-tier resource tuple are
  represented in Lean by `arithmeticRankOneCubicCircuit` and
  `arithmeticRankOneCubicResourceTuple`.
- [x] Hadamard-counting mutation interface, oracle-tier tuple, clean-block
  contract bridge, normalizer bridge, and separate nonzero-column reject repair
  are represented in Lean.
- [ ] Candidate semantic matrix is represented in Lean.
- [ ] Block-encoding predicate is stated against that matrix.
- [x] Clean-block target contract is stated by `rankOneCleanBlockContract`.
- [ ] Clean signal and pure-ancilla semantics are proved for a candidate matrix.
- [x] Approximation error budget is decomposed at the proof-design level in `proof-attempts/QBE-OP-CUBIC-STATEPREP-001-CUBIC-ERR-001.md`.
- [ ] Approximation error budget is represented as Lean declarations after alpha and the clean-block interface are fixed.
- [x] Oracle-tier resource count is represented for the current wrapped route.
- [ ] Expanded semantic resource count is represented.
- [ ] Every nontrivial external arithmetic/circuit assumption is either proved, contracted, or logged as an open problem.

## Cited-Results Pane

| Result id | Source | Statement used | QBE status | Lean target | Used by | Reviewer note |
| --- | --- | --- | --- | --- | --- | --- |
| `classical-sixth-power-sum` | Classical finite power-sum identity; recorded in `research-wiki/cited-results/classical-power-sums.md`. | For `m : Nat`, `sum_{j=0}^m j^6 = m(m+1)(2m+1)(3m^4+6m^3-3m+1)/42`. | obligation | planned helper for `cubicNormSq_closedForm` | CUBIC-NORM-001 | Do not mark formalized until the Lean helper builds. |

## Current Lower-Facing Source Contract

This middle cycle narrows the lower work to the Hadamard-counting route.  The
source anchor is the user/task contract, not a paper proof.  The object remains
the rank-one target operator with entries `v_n[j] = (j / 2^n)^3`; candidate
work must preserve that operator and record unproved semantic leaves
explicitly.

| Field | Contract |
| --- | --- |
| Leaf | `CUBIC-HCOUNT-COUNT-001` is active.  `CUBIC-HCOUNT-RATIO-001` is compiled; `CUBIC-VER-CAND-001:HCOUNT-SEMANTIC` is completed rejected feedback for the old daggered transcript; `CUBIC-HCOUNT-REJECT-REPAIR-001` is compiled at the interface/resource tier and finite-checks clean for `n = 1, 2`; `CUBIC-NORM-001` remains a diagnostic backlog item, not a serial blocker |
| Target file | `QuantumBlockEncoding/CubicStatePreparation.lean` |
| Exact Lean intent | prove a pure symbolic counting bridge for the threshold register before any full clean-block theorem: `gridSize (3 * n) = gridSize n ^ 3`, `j.val ^ 3 <= gridSize (3 * n)`, and the filtered `List.finRange` threshold count equals `j.val ^ 3` |
| Mathematical statement | the Hadamard-counting clean block should have first-column entries `j^3 / (gridSize n)^4` and zero nonfirst columns, so multiplying by `alpha = conservativeNormalizer n` recovers `cubicOperator n` |
| Dependencies ready | `gridSize`, `gridSize_pos`, `gridPoint`, `cubicAmplitude`, `conservativeNormalizer`, `gridSize_rat_ne_zero`, `cubicAmplitude_div_conservativeNormalizer_eq`, `rankOneCleanBlockContract`, `hadamardCountingCubicCleanBlockContract_pointwise_eq`, `cubicNormSq_le_hadamardCountingCubicNormalizer_sq`, and repaired transcript theorem `hadamardCountingCubicCircuit_rejectSignalRepair` |
| Rejected route | the old daggered `hcount-zero-input-flag` transcript fails finite clean-block support because nonzero input columns return to clean ancillas and leak identity entries |
| External/classical obligation | `classical-sixth-power-sum`, still an obligation for the closed-form route until the Lean helper builds; not required for a direct bound if all inequalities are local Lean lemmas |
| Owned by task | the unnormalized rank-one target `cubicOperator` and its norm diagnostic |
| QBE-local glue | `hadamardCountingCubicLayout`, `hadamardCountingCubicCircuit`, `hadamardCountingCubicNormalizer`, `hadamardCountingCubicResourceTuple`, the reusable clean-block contract, later semantic matrix, projector, clean-ancilla, and exact-error packaging records |
| Forbidden changes | do not alter `cubicOperator`, normalize `v_n`, or claim a block encoding before the matrix, unitarity, clean-block, ancilla-cleanup, normalizer, and error leaves close |
| Required feedback labels if blocked | use `leaf=CUBIC-HCOUNT-COUNT-001`, `source_correspondence_ok=true`, `lean_parse_ok=<bool>`, `lean_build_ok=<bool>`, `finite_matrix_ok=true`, `block_entry_ok=true`, `ancilla_cleanup_ok=null`, `unitarity_ok=null`, and `error_class=<symbolic_bridge_gap|lean_tactic_gap>` |

## Lower-Agent Packet Split

Lower 1 receives the natural-language count DAG packet.

- Source anchor: user/task contract, not a paper theorem.
- Target artifact: a concise Markdown proof-design note or dialogue handoff,
  with no Lean edits unless the design exposes a definition-free helper.
- Required content: the dependency order
  `CUBIC-TGT-001 -> CUBIC-ALPHA-001 -> CUBIC-HCOUNT-IFACE-001 ->
  CUBIC-HCOUNT-RATIO-001 -> CUBIC-HCOUNT-REJECT-REPAIR-001 ->
  CUBIC-HCOUNT-COUNT-001 -> CUBIC-HCOUNT-UNITARY-001 ->
  CUBIC-HCOUNT-BLOCK-001 -> CUBIC-HCOUNT-APPROX-001`.
- Required proof map: define `N = gridSize n`, `alpha = conservativeNormalizer
  n`, the threshold register `t : Fin (gridSize (3 * n))`, the full path
  space of size `N^4`, and the accepted paths `(r,t)` with `r = j` and
  `t < j^3`; map each step to the compiled Lean declarations or to a named
  open semantic obligation.
- Required decision: keep the separate reject-signal convention fixed.  Do not
  reopen sticky-vs-reject unless the symbolic semantic theorem contradicts the
  finite verifier feedback.
- Required guardrail: do not treat the unnormalized vector as a unitary output
  state and do not mark the oracle-label transcript as certified before
  Hadamard-sandwich, comparator, clean-ancilla, and unitarity semantics are
  proved.

Lower 2 receives the active Lean implementation packet:
`CUBIC-HCOUNT-COUNT-001`.

- Source anchor: user/task contract plus the finite path diagnostic in
  `verifier-feedback/QBE-OP-CUBIC-STATEPREP-001/cubic-ver-cand-001-hcount-path.md`.
- Target file: `QuantumBlockEncoding/CubicStatePreparation.lean`.
- Test file: `Tests/Basic.lean`, limited to focused checks for the new pure
  counting declarations.
- Allowed write scope: new helper declarations named `gridSize_three_mul_eq_cube`,
  `gridSize_four_mul_eq_fourth`, or beginning with
  `hadamardCountingCubic_threshold`; tests that mention only these helpers are
  allowed.  Do not edit `cubicOperator`, `gridPoint`, `cubicAmplitude`, the
  rank-one clean-block contract, the circuit transcript, normalizer, resource
  tuple, or already-proved ratio and reject-repair lemmas.
- Exact Lean target: prove the path-register capacity and threshold-count
  facts:

  ```lean
  theorem gridSize_three_mul_eq_cube (n : Nat) :
      gridSize (3 * n) = gridSize n ^ 3 := by
    ...

  theorem gridSize_four_mul_eq_fourth (n : Nat) :
      gridSize (4 * n) = gridSize n ^ 4 := by
    ...

  theorem hadamardCountingCubic_threshold_le_pathCapacity
      (n : Nat) (j : Fin (gridSize n)) :
      j.val ^ 3 <= gridSize (3 * n) := by
    ...

  theorem hadamardCountingCubic_thresholdPathCount
      (n : Nat) (j : Fin (gridSize n)) :
      ((List.finRange (gridSize (3 * n))).filter
          (fun t => t.val < j.val ^ 3)).length = j.val ^ 3 := by
    ...
  ```
- Forbidden route: do not introduce a normalized state-preparation unitary, do
  not change `cubicOperator`, do not weaken the clean-block vanish condition,
  and do not package a full candidate certificate.
- Required gate after Lean edits: `python3 tools/qbe.py check`.
- Next route after this leaf: `CUBIC-HCOUNT-UNITARY-001` or a Hadamard-sandwich
  semantic bridge.  Do not attempt `CUBIC-HCOUNT-BLOCK-001` directly.
- Required feedback fields if blocked: `leaf=CUBIC-HCOUNT-COUNT-001`,
  `source_correspondence_ok=true`, `lean_parse_ok=<bool>`,
  `lean_build_ok=<bool>`, `finite_matrix_ok=true`, `block_entry_ok=true`,
  `error_class=<symbolic_bridge_gap|lean_tactic_gap>`, and
  `next_route=<one narrow count/helper repair>`.

Lower 3's repaired necessary-condition verifier packet is complete:
`CUBIC-HCOUNT-REJECT-REPAIR-001`.

- Source anchor: the Hadamard-counting transcript and path formula in
  `proof-attempts/QBE-OP-CUBIC-STATEPREP-001-CUBIC-CAND-SHAPE-001.md`, plus
  the repaired Lean interface from lower 2.
- Target artifact:
  `verifier-feedback/QBE-OP-CUBIC-STATEPREP-001/cubic-ver-cand-001-hcount-semantic.md`
  now records both the old rejected route and the repaired finite check.
- Diagnostic scope: instantiate `n = 1` or `n = 2` and check the clean-block
  support, first-column entries after multiplying by `alpha`, clean auxiliary
  projection, and unitarity/reversibility for any concrete finite matrices
  used.  If only the path-count formula is checked, say that unitarity and
  ancilla cleanup are still `designed_not_executed`.
- Typed fields recorded: `leaf=CUBIC-HCOUNT-REJECT-REPAIR-001`,
  `finite_matrix_ok=true`, `block_entry_ok=true`,
  `ancilla_cleanup_ok=true`, `unitarity_ok=true`, `normalizer_ok=true`,
  `closed_theorem_ok=false`, and `error_class=symbolic_bridge_gap`.
- Stale route to reject: do not rerun the old `candidate_interface_gap`
  diagnostic, and do not use the rejected daggered `nz` convention as evidence
  for `CUBIC-HCOUNT-BLOCK-001`.
- Next verifier scope: no verifier work is needed unless the Lean worker
  changes the threshold register size, path denominator, or accepted-path
  predicate.  If that happens, rerun only
  `verifier-feedback/QBE-OP-CUBIC-STATEPREP-001/cubic_ver_cand_001_hcount_path_check.py`
  and log it as `leaf=CUBIC-HCOUNT-COUNT-001`.

Lower 3 has also completed the first same-target external executable
comparison.

- Completed artifact: `reports/cubic-stateprep/external_comparison.md`.
- Plot artifact: `reports/cubic-stateprep/external_comparison_scaling.png`.
- Result: NumPy dense completion passed for `n = 1..6`; Qiskit `Operator`
  passed for `n = 1..4`; Qiskit-QuantumKatas-style evaluator passed for
  `n = 3`; QASM-Eval, QUASAR, and AI-Mandel do not expose a direct same-task
  BE verifier route in the local artifacts.
- Interpretation: finite executable checks are valid smoke tests for fixed
  dense matrices, but the active ABEIS target remains a symbolic approximate
  block-encoding theorem for arbitrary `n`.

## Agent Dialogue

Append short messages here or use:

```bash
python3 tools/qbe.py agent-note latest --role lower --message "Found missing normalizer definition."
```

## Build Gate

```bash
python3 tools/qbe.py check
lake build && lake build Tests
```

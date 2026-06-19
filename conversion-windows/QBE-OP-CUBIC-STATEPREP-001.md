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
| `alpha` | block-encoding normalizer | `CubicStatePreparation.conservativeNormalizer` now; sharper `alpha` planned | `Rat` | placeholder compiled, proof bridge open |
| `U_n` | candidate unitary/circuit matrix | planned candidate declaration | matrix on `gridSize (n+a)` | open |
| `a` | auxiliary qubits for block extraction | `OperatorBlockEncodingCandidate.auxiliaryQubits` | `Nat` | open |
| clean block | projected signal-system block of `U_n` | `ApproximateOperatorBlockEncodingCandidate.approximationBound` | `Prop` | open |

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
| Normalizer | `conservativeNormalizer n = gridSize n` is compiled as a safe placeholder; a proof bridge to `cubicNormSq` is open. |
| Acceptance inequality | Scenario 2 target is `|| O_n - alpha * ((<0^a| tensor I) U_n (|0^a> tensor I)) || <= requestedEpsilon`. |
| Resource expression | Candidate must record asymptotic tier first, then `(gateCount, depth, auxiliaryQubits, oracleCalls)` inside that tier. |

## Ownership Split

| Class | Owned here |
| --- | --- |
| Active user target | The definitions of `gridPoint`, `cubicAmplitude`, `cubicOperator`, `cubicNormSq`, `requestedEpsilon`, and the rank-one interpretation of the unnormalized vector. |
| External contract | A classical sixth-power sum identity is needed for a closed rational norm formula.  It is not marked formalized until a Lean declaration builds.  Future arithmetic and rotation-synthesis subroutines are also external contracts until named. |
| QBE-local semantic glue | `QueryOperatorTarget`, `OperatorBlockEncodingCandidate`, `ApproximateOperatorBlockEncodingCandidate`, normalizer bookkeeping, clean-block projection convention, verifier-feedback fields, and resource scoring. |

## Markdown Explanation

The target vector is not normalized, so the construction target is not a
standalone state-preparation unitary.  The Lean target is the rank-one operator
whose first column is the cubic grid vector and whose other columns are zero.

The next proof step is not a circuit proof.  It is the norm/normalizer bridge:
derive a closed rational expression or a sufficient rational upper bound for
`cubicNormSq n`, then prove that the chosen `alpha` is valid for a future block
encoding.  Only after this bridge is explicit should lower agents spend time on
a candidate unitary, block projector, clean ancilla condition, or epsilon
budget.

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
| Interpret the unnormalized vector as a rank-one operator. | Task contract normalization warning. | `cubicOperator`, `cubicOperator_only_first_column`. | compiled |
| Compute or bound `||v_n||^2 = sum_j (j/2^n)^6`. | Target norm diagnostic. | planned `cubicNormSq_closedForm` or `cubicNormSq_le_conservativeNormalizer_sq`. | active leaf |
| Choose a normalizer `alpha` and record the block projector. | Operator block-encoding acceptance target. | `conservativeNormalizer` now; sharper candidate `alpha` planned. | open |
| Prove a candidate approximate block encoding. | Scenario 2 policy. | planned `VerifiedApproximateOperatorBlockEncoding` instance or theorem. | open |

## Proof-DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
| --- | --- | --- | --- | --- | --- | --- | --- |
| CUBIC-TGT-001 | Target operator entries for `O_n = |v_n><0^n|`. | none | middle/Lean target | `cubicOperator`, `cubicOperator_only_first_column` | this window, Symbol Map | `python3 tools/qbe.py check` | proved |
| CUBIC-DIAG-001 | Small exact norm diagnostics for `n = 1, 2, 3`. | CUBIC-TGT-001 | lower historical | `cubicNormSq_n1`, `cubicNormSq_n2`, `cubicNormSq_n3` | proof obligations | `python3 tools/qbe.py check` | proved, retired |
| CUBIC-NORM-001 | Closed rational form for `sum_j (j / 2^n)^6`. | CUBIC-TGT-001, classical sixth-power sum | lower Lean | planned `cubicNormSq_closedForm` | this window, Lower-Facing Source Contract | `lake build && lake build Tests` | active leaf |
| CUBIC-ALPHA-001 | Prove chosen `alpha` is compatible with the target norm. | CUBIC-NORM-001 or entrywise amplitude bound | lower Lean | planned `cubicNormSq_le_conservativeNormalizer_sq` | proof obligations | `lake build && lake build Tests` | blocked internal |
| CUBIC-ERR-001 | Arithmetic approximation and rotation/transduction error budget sums to `1e-10`. | CUBIC-ALPHA-001 | lower architect | `proof-attempts/QBE-OP-CUBIC-STATEPREP-001-CUBIC-ERR-001.md` plus future Lean targets | candidate population | `python3 tools/qbe.py check` | designed, blocked on alpha/candidate interface |
| CUBIC-CAND-001 | Candidate unitary/circuit transcript and clean-block theorem. | CUBIC-ALPHA-001, CUBIC-ERR-001 | future lower Lean | planned candidate declaration | candidate population | `lake build && lake build Tests` | open |
| CUBIC-VER-001 | Dense-vs-symbolic scaling diagnostics for `n = 4, 8, 12, 16, 20`. | CUBIC-TGT-001 | verifier lower | `verifier-feedback/QBE-OP-CUBIC-STATEPREP-001/cubic-ver-001-scaling.md` | verifier-feedback | `python3 tools/qbe.py check` | diagnostic complete, not a certificate |

## Lean Declaration Plan

| Declaration | File | Purpose | Builds? |
| --- | --- | --- | --- |
| `cubicNormSq_closedForm` | `QuantumBlockEncoding/CubicStatePreparation.lean` | closed rational norm expression for `sum_j (j/2^n)^6` | planned |
| `cubicNormSq_le_conservativeNormalizer_sq` | `QuantumBlockEncoding/CubicStatePreparation.lean` | prove the compiled placeholder normalizer is sufficient for the target norm | planned |
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

theorem cubicNormSq_le_conservativeNormalizer_sq (n : Nat) :
    cubicNormSq n <= conservativeNormalizer n ^ 2 := by
  -- planned after the closed form or an entrywise nonnegative bound.
  sorry

end CubicStatePreparation
end QuantumBlockEncoding
```

## Proof Obligations

- [x] Matrix/operator target is represented in Lean.
- [ ] Closed rational norm formula or sufficient rational norm bound is proved.
- [ ] Normalizer `alpha` is chosen and related to the norm.
- [ ] Candidate circuit/matrix is represented in Lean.
- [ ] Block-encoding predicate is stated against that matrix.
- [ ] Clean signal and pure-ancilla condition is stated.
- [x] Approximation error budget is decomposed at the proof-design level in `proof-attempts/QBE-OP-CUBIC-STATEPREP-001-CUBIC-ERR-001.md`.
- [ ] Approximation error budget is represented as Lean declarations after alpha and the clean-block interface are fixed.
- [ ] Resource count is represented.
- [ ] Every nontrivial external arithmetic/circuit assumption is either proved, contracted, or logged as an open problem.

## Cited-Results Pane

| Result id | Source | Statement used | QBE status | Lean target | Used by | Reviewer note |
| --- | --- | --- | --- | --- | --- | --- |
| `classical-sixth-power-sum` | Classical finite power-sum identity; recorded in `research-wiki/cited-results/classical-power-sums.md`. | For `m : Nat`, `sum_{j=0}^m j^6 = m(m+1)(2m+1)(3m^4+6m^3-3m+1)/42`. | obligation | planned helper for `cubicNormSq_closedForm` | CUBIC-NORM-001 | Do not mark formalized until the Lean helper builds. |

## Lower-Agent Packet Split

Lower 1 receives the natural-language DAG and error-budget packet.

- Source anchor: user/task contract, not a paper theorem.
- Target artifact: a Markdown proof-design note or dialogue handoff, with no
  Lean edits unless the design exposes a definition-free helper.
- Required content: source symbols, the dependency order
  `CUBIC-TGT-001 -> CUBIC-NORM-001 -> CUBIC-ALPHA-001 -> CUBIC-ERR-001 ->
  CUBIC-CAND-001`, and a Scenario 2 error budget that separates arithmetic
  approximation, rotation/transduction, and block-entry error.
- Required guardrail: do not treat the unnormalized vector as a unitary output
  state and do not propose `U_n` as certified before alpha, projector, clean
  ancilla, and epsilon budget are explicit.

Lower 2 receives the active Lean leaf CUBIC-NORM-001.

- Source anchor: user/task contract, target norm diagnostic for `v_n[j] = (j / 2^n)^3`.
- Target file: `QuantumBlockEncoding/CubicStatePreparation.lean`.
- Allowed write scope: add helper lemmas and the active norm theorem in `QuantumBlockEncoding/CubicStatePreparation.lean`; update this conversion window only if the theorem name changes; do not edit unrelated task files.
- Exact theorem intent: prove a closed form for `cubicNormSq n`, using `N = gridSize n`, equivalent to
  `((N - 1) * (2 * N - 1) * (3 * N^4 - 6 * N^3 + 3 * N + 1)) / (42 * N^5)`.
- Allowed helper: a local rational sixth-power sum lemma, recorded as `classical-sixth-power-sum` until build-tested.
- Forbidden route: do not introduce a normalized state-preparation unitary, do not change `cubicOperator`, and do not claim a candidate `U_n`.
- Required gate after Lean edits: `python3 tools/qbe.py check`, then `lake build && lake build Tests`.
- Required feedback fields if blocked: `leaf=CUBIC-NORM-001`, `source_correspondence_ok=true`, `lean_parse_ok=<bool>`, `lean_build_ok=<bool>`, `error_class=<symbolic_bridge_gap|lean_tactic_gap|external_contract_gap>`, and `next_route=<one narrow repair>`.

Lower 3 has completed the first necessary-condition scaling packet.

- Completed artifact:
  `verifier-feedback/QBE-OP-CUBIC-STATEPREP-001/cubic-ver-001-scaling.md`.
- Diagnostic scope: dense vector entries and one-auxiliary dense-unitary memory
  for `n = 4, 8, 12, 16, 20`, generated from
  `reports/cubic-stateprep/latest.*`.
- Next verifier work: wait for a concrete candidate instance, then run small
  finite block-entry and unitarity smoke tests.  Do not rerun dense scaling as
  a Lean substitute.

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

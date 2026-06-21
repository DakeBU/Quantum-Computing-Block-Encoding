# Proof Obligations: QBE-OP-OPTCTRL-COLD-CLEAN-001

## Fixed Target

The task-owned operator is

$$
E_1 = |0><1|_T \otimes |0><1|_{\tau} \otimes I_S.
$$

The system basis is ordered as `(T, tau, S)`, with one qubit per register.  The
candidate unitary acts on one signal qubit plus the three system qubits, so its
matrix dimension is `16 x 16`.  The clean block is selected by
`coldE1SignalIndex = 0`.

## Current Lean Surface

| Role | Lean declaration | Status |
|---|---|---|
| system index | `coldE1SystemIndex` | compiled |
| target matrix | `coldE1Target` | compiled |
| operator metadata | `coldE1QueryTarget` | compiled, task id repaired |
| block projector predicate | `coldE1BlockProjection` | compiled |
| normalizer | `coldE1ExactNormalizer` | compiled |
| exact error | `coldE1ExactError` | compiled |
| register layout | `coldE1SourceLayout` | compiled |
| high-level seed cost | `coldE1HighLevelSeedCost` | compiled with named field certificates |
| candidate image | `coldE1CandidateImage` | compiled for `COLD-CLEAN-PERM-001` |
| candidate matrix | `coldE1CandidateMatrix` | compiled permutation-matrix surface |
| image injectivity proxy | `coldE1CandidateImage_injective` | compiled finite proof |
| image surjectivity and permutation package | `coldE1CandidateImage_surjective`, `coldE1CandidateImage_permutation_certificate` | compiled task-local finite proof |
| block theorem | `coldE1Candidate_blockProjection` | compiled |
| post-Lean executable export | `export-manifest.json`, `cold-e1-export-check.feedback.json` | finite/Qiskit diagnostic passed |

## Current obligation state

| Obligation | Lean declaration or target | Dependency class | Status |
|---|---|---|---|
| target and clean projector match the task packet | `coldE1Target`, `coldE1BlockProjection` | existing Lean target | proved target-side |
| stale source metadata is repaired to the clean-start task id | `coldE1QueryTarget.source` | contract drift repair | patched and compiled in prior gate |
| define candidate image and matrix | `coldE1CandidateImage`, `coldE1CandidateMatrix` | internal construction leaf | proved by lower cycle 1 |
| finite candidate diagnostics | `cold-e1-finite-verify-cycle01.feedback.json` | verifier-feedback diagnostic | passed; downstream block theorem proved |
| prove permutation or unitarity | `coldE1CandidateImage_permutation_certificate` | acceptance proof leaf | proved as task-local image permutation package |
| prove clean-block equality | `coldE1Candidate_blockProjection` | root block-entry proof | proved |
| certify resource tuple | `coldE1HighLevelSeedCost_gateCount`, `coldE1HighLevelSeedCost_depth`, `coldE1HighLevelSeedCost_auxiliaryQubits`, `coldE1HighLevelSeedCost_oracleCalls` | resource equality | proved |
| prepare executable export | export packet under `executable-exports/QBE-OP-OPTCTRL-COLD-CLEAN-001/` | post-Lean export | passed finite/Qiskit diagnostic |
| closeout proof/status sync | problem proof note, storyboard/evolution memory, and final report guardrails | closeout documentation | passed closeout sync |
| closeout scope audit | current worktree contains unrelated legacy deletions plus tooling/manifest churn outside this operator construction | reviewer/human acceptance scope | active reviewer audit |

## Proof-DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `COLD-E1-SOURCE-001` | Translate task packet operator and register layout into Lean target declarations. | task packet | middle | `coldE1Target`, `coldE1BlockProjection` | this file and `conversion-windows/QBE-OP-OPTCTRL-COLD-CLEAN-001.md` | `python3 tools/qbe.py check` | proved target-side |
| `COLD-E1-SUPPORT-001` | Prove the two required nonzero entries of `coldE1Target`. | `COLD-E1-SOURCE-001` | Lean target file | `coldE1Target_support_state0`, `coldE1Target_support_state1` | this file | `python3 tools/qbe.py check` | proved |
| `COLD-E1-PERM-IMAGE-001` | Define the 16-state candidate image for `COLD-CLEAN-PERM-001`. | `COLD-E1-SOURCE-001` | lower 2 | `coldE1CandidateImage`, `coldE1CandidateMatrix`, `coldE1CandidateImage_injective` | conversion window candidate contract | `python3 tools/qbe.py check` | proved |
| `COLD-E1-FINITE-VERIFY-001` | Verify finite bijection and clean-block entries before symbolic proof search. | `COLD-E1-PERM-IMAGE-001` | lower 3 | `cold-e1-finite-verify-cycle01.feedback.json` | verifier-feedback packet | `python3 tools/qbe.py check` plus diagnostic script | proved diagnostic |
| `COLD-E1-PERM-UNITARY-001` | Prove the candidate image is a task-local finite permutation package. | `COLD-E1-PERM-IMAGE-001`, `COLD-E1-FINITE-VERIFY-001` | middle/lower 2 | `coldE1CandidateImage_permutation_certificate` | this file | `python3 tools/qbe.py check` | proved |
| `COLD-E1-BLOCK-001` | Prove the clean block of the candidate matrix equals `coldE1Target`. | `COLD-E1-PERM-IMAGE-001`, `COLD-E1-FINITE-VERIFY-001` | lower 2 | `coldE1Candidate_blockProjection` | conversion window candidate contract | `python3 tools/qbe.py check` | proved |
| `COLD-E1-RESOURCE-001` | Attach the resource tuple `(gateCount=4, depth=4, auxiliaryQubits=1, oracleCalls=0)` without claiming a lower-level circuit expansion. | `COLD-E1-BLOCK-001` | middle/lower 2 | `coldE1HighLevelSeedCost_gateCount`, `coldE1HighLevelSeedCost_depth`, `coldE1HighLevelSeedCost_auxiliaryQubits`, `coldE1HighLevelSeedCost_oracleCalls` | candidate population ledger | `python3 tools/qbe.py check` | proved |
| `COLD-E1-EXPORT-001` | Prepare Qiskit/executable export packet and finite checks. | `COLD-E1-BLOCK-001`, `COLD-E1-PERM-UNITARY-001`, `COLD-E1-RESOURCE-001` | lower 3/export worker, audited by middle | export manifest and feedback packet | closeout export, not inner cycle proof | export checker plus project gates | proved diagnostic |
| `COLD-E1-CLOSEOUT-SYNC-001` | Synchronize the problem proof note, storyboard/evolution memory, final report status, and forbidden-claim guardrails after the passed export check. | `COLD-E1-EXPORT-001` | middle/report-export or reviewer | no Lean declaration expected | `paper-notes/problem-exports/QBE-OP-OPTCTRL-COLD-CLEAN-001/latest.tex`, report/status artifacts | `python3 tools/qbe.py check`; `lake build && lake build Tests` | passed closeout sync |
| `COLD-E1-SCOPE-AUDIT-001` | Audit worktree scope and unrelated legacy/tooling changes before accepting this clean-start operator closeout. | `COLD-E1-CLOSEOUT-SYNC-001` | reviewer/human | no Lean declaration expected | final audit report and `git status --short` | `python3 tools/qbe.py check`; `lake build && lake build Tests` | active reviewer audit |

## Open Obligations

| Obligation | Why it is needed | Next route |
|---|---|---|
| closeout scope audit | reviewer identified broad unrelated legacy deletions and tool/manifest churn in the current worktree | `COLD-E1-SCOPE-AUDIT-001`; do not accept unrelated cleanup as part of this scoped clean-start operator task without explicit approval |
| primitive circuit decomposition | current resource tuple is a high-level seed-cost certificate, not a primitive gate expansion | keep unclaimed unless a later Lean declaration or export layer gives primitive circuit semantics |
| hardware optimality or lower bound | the task ranking tuple is certified for this candidate, but no minimality theorem is present | keep unclaimed unless a later comparison or lower-bound theorem compiles |

## Lower-Facing Source Contract After Export Closure

Source anchor: `tasks/QBE-OP-OPTCTRL-COLD-CLEAN-001.md`, section `Target
Operator`.

Detailed split packet:
`proof-attempts/QBE-OP-OPTCTRL-COLD-CLEAN-001-lower-packets-cycle02.md`.

Paper/user object: the clean signal block of the candidate matrix must equal
$E_1 = |0><1|_T \otimes |0><1|_{\tau} \otimes I_S$ with system order
`(T,tau,S)`.  That block object is compiled as
`coldE1Candidate_blockProjection`.  The post-Lean export packet has passed
finite/Qiskit checks for the same matrix convention and resource tuple.

Compiled block theorem:

```lean
theorem coldE1Candidate_blockProjection :
    coldE1BlockProjection coldE1CandidateMatrix := by
  intro i j
  simp [signalSystemBlockProjection, coldE1SignalIndex,
    coldE1CandidateMatrix, coldE1Target, coldE1SystemIndex,
    signalSystemBlockRowIndex, signalSystemBlockColIndex]
  native_decide +revert
```

The Lean source now includes the task-local resource field certificates and
permutation package.  Lower workers must not change `coldE1Target`,
`coldE1CandidateImage`, `coldE1CandidateMatrix`, the clean signal selector,
normalizer, error, or resource tuple.

Compiled resource declarations:

```lean
theorem coldE1HighLevelSeedCost_gateCount :
    coldE1HighLevelSeedCost.gateCount = 4 := rfl

theorem coldE1HighLevelSeedCost_depth :
    coldE1HighLevelSeedCost.depth = 4 := rfl

theorem coldE1HighLevelSeedCost_auxiliaryQubits :
    coldE1HighLevelSeedCost.auxiliaryQubits = 1 := rfl

theorem coldE1HighLevelSeedCost_oracleCalls :
    coldE1HighLevelSeedCost.oracleCalls = 0 := rfl
```

Compiled permutation declarations:

```lean
theorem coldE1CandidateImage_preimage :
    ∀ y : Fin 16, coldE1CandidateImage (coldE1CandidatePreimage y) = y

theorem coldE1CandidateImage_surjective :
    Function.Surjective coldE1CandidateImage

theorem coldE1CandidateImage_permutation_certificate :
    Function.Injective coldE1CandidateImage ∧
      Function.Surjective coldE1CandidateImage
```

These theorems certify the advertised high-level seed-cost fields and a
task-local finite image permutation.  The executable export check certifies
that the generated finite matrix and Qiskit `UnitaryGate` agree with this
certificate set as a diagnostic.  The artifacts do not certify hardware
optimality or a primitive gate decomposition.

No external cited result is active for this packet.  If a lower attempt imports
or relies on a theorem outside task-local finite reasoning, middle must first
create a technical-lemma or cited-results row.

Lower packet split:

| Lower role | Write scope | Current instruction |
|---|---|---|
| lower 1 natural-language proof architect | task-local proof-attempt memory only | keep all proof leaves retired; no new proof packet is needed |
| lower 2 Lean implementation worker | no Lean edit unless a concrete certificate mismatch appears | do not alter the compiled target, candidate, block theorem, resource fields, or permutation certificate |
| lower 3 necessary-condition verifier | `executable-exports/QBE-OP-OPTCTRL-COLD-CLEAN-001/` or verifier-feedback if edited | rerun finite executable diagnostics only after an export edit or mismatch |

## Verifier Feedback Fields For Lower Attempts

Lower attempts should report:

`leaf`, `source_correspondence_ok`, `lean_parse_ok`, `lean_build_ok`,
`finite_matrix_ok`, `block_entry_ok`, `ancilla_cleanup_ok`, `normalizer_ok`,
`unitarity_ok`, `resource_score`, `auxiliary_qubits`, `gate_count`, `depth`,
`oracle_calls`, `closed_theorem_ok`, `error_class`, and `next_route`.

If an export edit requires rerunning diagnostics, meaningful error classes are
`shape_or_register_gap`, `finite_matrix_counterexample`,
`symbolic_bridge_gap`, `stale_leaf`, and `invalid_route`.
`external_contract_gap` is not expected because no external result is used.

## Stale and Rejected Route Memory

- Retire lower targets using old optctrl task ids, old optctrl populations,
  prior Pro suggestions, or Qiskit exports as construction parents.
- Retire direct root theorem attempts before `coldE1CandidateMatrix` exists.
- Reject candidates that alter `coldE1Target`, `coldE1SignalIndex`,
  `coldE1ExactNormalizer`, or the one-clean-signal starting contract.
- Reject any export or achieved-solution claim that does not name
  `coldE1Candidate_blockProjection`,
  `coldE1CandidateImage_permutation_certificate`, and the four
  `coldE1HighLevelSeedCost_*` field theorems.

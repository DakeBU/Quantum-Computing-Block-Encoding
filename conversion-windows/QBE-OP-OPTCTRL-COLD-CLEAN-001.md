# Conversion Window: QBE-OP-OPTCTRL-COLD-CLEAN-001

## Source Anchor

The source object is the user-provided task packet in
`tasks/QBE-OP-OPTCTRL-COLD-CLEAN-001.md`, section `Target Operator`.  No paper
source archive or cited theorem is part of this cycle.

The fixed target is

$$
E_1 = |0><1|_T \otimes |0><1|_{\tau} \otimes I_S.
$$

The register order is `(T, tau, S)`, where all three registers are one qubit.
The block selector is one clean signal qubit at index `0`.  The normalizer is
`1`, and the exact error target is `0`.

## Symbol Map

| Source/user symbol | Lean name | Status |
|---|---|---|
| system basis `(T,tau,S)` | `coldE1SystemIndex` | compiled target-side definition |
| target operator `E_1` | `coldE1Target` | compiled target-side definition |
| operator target metadata | `coldE1QueryTarget` | metadata repaired to current task id |
| clean signal index | `coldE1SignalIndex` | compiled target-side definition |
| clean block predicate | `coldE1BlockProjection` | compiled target-side predicate |
| normalizer `alpha = 1` | `coldE1ExactNormalizer` | compiled target-side definition |
| exact error `epsilon = 0` | `coldE1ExactError` | compiled target-side definition |
| layout, one signal and no pure ancilla | `coldE1SourceLayout` | compiled target-side definition |
| high-level seed score | `coldE1HighLevelSeedCost` | compiled score with field certificates |
| candidate permutation package | `coldE1CandidatePreimage`, `coldE1CandidateImage_surjective`, `coldE1CandidateImage_permutation_certificate` | compiled task-local permutation certificate |
| post-Lean executable export | `executable-exports/QBE-OP-OPTCTRL-COLD-CLEAN-001/export-manifest.json`, `cold-e1-export-check.feedback.json` | finite/Qiskit diagnostic passed |

## Lean Correspondence

The target matrix has two nonzero entries:

- `coldE1Target (coldE1SystemIndex 0 0 0) (coldE1SystemIndex 1 1 0) = 1`,
  proved by `coldE1Target_support_state0`.
- `coldE1Target (coldE1SystemIndex 0 0 1) (coldE1SystemIndex 1 1 1) = 1`,
  proved by `coldE1Target_support_state1`.

The block predicate is `coldE1BlockProjection U`.  It expands to pointwise
equality between `signalSystemBlockProjection 2 8 8 U coldE1SignalIndex` and
`coldE1Target`.

## Cycle 2 Source-Correspondence Audit

The source anchor remains the task packet `Target Operator` section.  The
object being translated is the exact operator
$E_1 = |0><1|_T \otimes |0><1|_{\tau} \otimes I_S$ with one clean signal qubit.

Current compiled declarations in `QuantumBlockEncoding/ColdStartTransferE1.lean`
now include the exploratory candidate table:

| Source object | Lean declaration | Status |
|---|---|---|
| full signal-system basis index `(signal,T,tau,S)` | `signal * 8 + coldE1SystemIndex T tau S` in comments and table cases | convention fixed by target file |
| candidate image for `COLD-CLEAN-PERM-001` | `coldE1CandidateImage : Fin 16 -> Fin 16` | compiled |
| candidate matrix | `coldE1CandidateMatrix : Matrix (2 * 8) (2 * 8) Rat` | compiled |
| clean source images for `(T,tau) = (1,1)` | `coldE1CandidateImage_clean_source_state0`, `coldE1CandidateImage_clean_source_state1` | compiled |
| finite injectivity proxy | `coldE1CandidateImage_injective` | compiled |
| finite clean-block diagnostic | `verifier-feedback/QBE-OP-OPTCTRL-COLD-CLEAN-001/cold-e1-finite-verify-cycle01.md` | passed diagnostic |
| clean-block theorem | `coldE1Candidate_blockProjection` | compiled |

The exact Lean theorem for the source object is now compiled:

```lean
theorem coldE1Candidate_blockProjection :
    coldE1BlockProjection coldE1CandidateMatrix := by
  intro i j
  simp [signalSystemBlockProjection, coldE1SignalIndex,
    coldE1CandidateMatrix, coldE1Target, coldE1SystemIndex,
    signalSystemBlockRowIndex, signalSystemBlockColIndex]
  native_decide +revert
```

This theorem is the source-facing block-equality contract.  The next packet
must not change `coldE1Target`, `coldE1SignalIndex`,
`coldE1ExactNormalizer`, `coldE1ExactError`, or the one-signal layout.

## Ownership

The active user target owns the operator, register order, signal selector,
normalizer, exact error, and resource ranking rule.  Candidate
`COLD-CLEAN-PERM-001` owns the exploratory choice of a 16-state permutation
unitary and its high-level resource claim.  QBE-local semantic glue consists of
`signalSystemBlockProjection`, `Matrix.PointwiseEq`, `QueryOperatorTarget`,
`RegisterLayout`, and `BlockEncodingCost`.

There is no external cited result for this cycle.  If lower proof work uses a
nontrivial theorem beyond finite case splits, middle should add a precise
cited-results or technical-lemma row before depending on it.

For the next lower packet, no external cited-result row is needed.  The active
paper/user-owned object is the fixed operator and block projector.  The
candidate table is QBE-local exploratory construction data.  The semantic glue
is the existing QBE definition `signalSystemBlockProjection` plus
`Matrix.PointwiseEq`.  The active resource object is also user/task-owned: the
ranking tuple `(gateCount, depth, auxiliaryQubits, oracleCalls)` used to compare
Lean-certified candidates.  `coldE1HighLevelSeedCost` is QBE-local
certificate metadata, not an external theorem.

## Cycle 1 Continuation Source-Correspondence Refresh

The upper continuation directive from
`runs/20260621-002003-QBE-OP-OPTCTRL-COLD-CLEAN-001-cycle01/dialogue.md`
keeps `coldE1Candidate_blockProjection` as the highest compiled block theorem.
The resource leaf now compiles and must remain retired along with the block
theorem.

The compiled Lean-facing resource contract is:

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

These declarations certify the field values of the high-level seed-cost record.
They do not certify a hardware-optimal circuit, a primitive gate expansion, or
an executable export.

The compiled task-local permutation package is:

```lean
theorem coldE1CandidateImage_preimage :
    ∀ y : Fin 16, coldE1CandidateImage (coldE1CandidatePreimage y) = y

theorem coldE1CandidateImage_surjective :
    Function.Surjective coldE1CandidateImage

theorem coldE1CandidateImage_permutation_certificate :
    Function.Injective coldE1CandidateImage ∧
      Function.Surjective coldE1CandidateImage
```

The post-Lean Qiskit/export leaf is no longer blocked.  The export packet under
`executable-exports/QBE-OP-OPTCTRL-COLD-CLEAN-001/` names the compiled block,
permutation, normalizer/layout, and resource certificates, and
`cold-e1-export-check.feedback.json` records `finite_matrix_ok=true`,
`block_entry_ok=true`, `unitarity_ok=true`, `qiskit_export_ok=true`, and
`error_class=none`.

## Candidate Contract

Candidate `COLD-CLEAN-PERM-001` is a 16-state permutation over
`(signal,T,tau,S)` that preserves `S`.  For each fixed `S = s`, its clean input
columns must satisfy:

| Clean input column `(T,tau,s)` | Output signal | Output `(T,tau,s)` |
|---|---:|---|
| `(1,1,s)` | `0` | `(0,0,s)` |
| `(0,0,s)` | `1` | dirty row, not in the clean block |
| `(0,1,s)` | `1` | dirty row, not in the clean block |
| `(1,0,s)` | `1` | dirty row, not in the clean block |

The dirty input columns may be assigned to the remaining unused rows in any
bijective way that keeps the full 16-state image a permutation.  A convenient
finite table is:

| Input `(signal,T,tau,s)` | Output `(signal,T,tau,s)` |
|---|---|
| `(0,0,0,s)` | `(1,0,0,s)` |
| `(0,0,1,s)` | `(1,0,1,s)` |
| `(0,1,0,s)` | `(1,1,0,s)` |
| `(0,1,1,s)` | `(0,0,0,s)` |
| `(1,0,0,s)` | `(0,0,1,s)` |
| `(1,0,1,s)` | `(0,1,0,s)` |
| `(1,1,0,s)` | `(0,1,1,s)` |
| `(1,1,1,s)` | `(1,1,1,s)` |

This table is the source-facing contract for `coldE1CandidateImage` and
`coldE1CandidateMatrix`.  The clean-block theorem, resource field certificate,
task-local permutation certificate, and post-Lean finite/Qiskit export
diagnostic now pass.  Hardware optimality and primitive gate expansion remain
separate unclaimed obligations.

## Cycle 2 Export Correspondence Closeout

The active source anchor remains the task packet, section `Target Operator`.
The exported object is the same finite permutation matrix certified in Lean:

| Export field | Corresponding artifact |
|---|---|
| Lean block theorem | `coldE1Candidate_blockProjection` |
| finite permutation package | `coldE1CandidateImage_permutation_certificate` |
| candidate matrix | `coldE1CandidateMatrix`, generated from `coldE1CandidateImage` |
| basis order | `(signal,T,tau,S)` with index `8 * signal + 4 * T + 2 * tau + S` |
| clean projector | `coldE1SignalIndex = 0`, `coldE1BlockProjection` |
| normalizer and error | `coldE1ExactNormalizer = 1`, `coldE1ExactError = 0` |
| resource tuple | `(4,4,1,0)`, certified by the four `coldE1HighLevelSeedCost_*` field theorems |
| executable packet | `executable-exports/QBE-OP-OPTCTRL-COLD-CLEAN-001/export-manifest.json` |
| finite/Qiskit check | `verifier-feedback/QBE-OP-OPTCTRL-COLD-CLEAN-001/cold-e1-export-check-cycle01.feedback.json` and mirrored export feedback |

The export check is diagnostic evidence after Lean closure.  It does not
replace `coldE1Candidate_blockProjection`, and it does not certify a primitive
gate decomposition or a lower bound.

## Proof-DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `COLD-E1-SOURCE-001` | Translate the task packet operator, register order, clean signal selector, normalizer, and error into Lean. | task packet | middle | `coldE1Target`, `coldE1BlockProjection`, `coldE1QueryTarget` | proof-obligation ledger | `python3 tools/qbe.py check` | proved |
| `COLD-E1-PERM-IMAGE-001` | Define the `Fin 16` candidate image/matrix for `COLD-CLEAN-PERM-001`. | `COLD-E1-SOURCE-001` | lower 2 | `coldE1CandidateImage`, `coldE1CandidateMatrix`, `coldE1CandidateImage_injective` | candidate population ledger | `python3 tools/qbe.py check` | proved |
| `COLD-E1-FINITE-VERIFY-001` | Check candidate bijection and clean-block entries before broad proof search. | `COLD-E1-PERM-IMAGE-001` | lower 3 | `cold-e1-finite-verify-cycle01.feedback.json` | verifier-feedback packet | typed feedback log | proved diagnostic |
| `COLD-E1-PERM-UNITARY-001` | Prove a named bijection/permutation certificate for the candidate image. | `COLD-E1-PERM-IMAGE-001`, `COLD-E1-FINITE-VERIFY-001` | middle/lower 2 | `coldE1CandidateImage_permutation_certificate` | proof-obligation ledger | `python3 tools/qbe.py check` | proved |
| `COLD-E1-BLOCK-001` | Prove the clean block of the candidate matrix equals `coldE1Target`. | `COLD-E1-PERM-IMAGE-001`, `COLD-E1-FINITE-VERIFY-001` | lower 2 | `coldE1Candidate_blockProjection` | this conversion window and proof-obligation ledger | `python3 tools/qbe.py check` | proved |
| `COLD-E1-RESOURCE-001` | Attach `(gateCount=4, depth=4, auxiliaryQubits=1, oracleCalls=0)` without claiming hardware optimality. | `COLD-E1-BLOCK-001` | middle/lower 2 | `coldE1HighLevelSeedCost_gateCount`, `coldE1HighLevelSeedCost_depth`, `coldE1HighLevelSeedCost_auxiliaryQubits`, `coldE1HighLevelSeedCost_oracleCalls` | candidate population ledger | `python3 tools/qbe.py check` | proved |
| `COLD-E1-EXPORT-001` | Prepare Qiskit/export packet and finite executable checks from the named Lean certificates. | `COLD-E1-BLOCK-001`, `COLD-E1-PERM-UNITARY-001`, `COLD-E1-RESOURCE-001` | lower 3/export worker, audited by middle | export manifest and feedback packet | closeout/export ledger | export checker plus project gates | proved diagnostic |
| `COLD-E1-CLOSEOUT-SYNC-001` | Synchronize final proof note, storyboard/evolution memory, report status, and forbidden-claim guardrails after the passed export diagnostic. | `COLD-E1-EXPORT-001` | middle/report-export or reviewer | no Lean declaration expected | problem proof export and report/status artifacts | `python3 tools/qbe.py check`; `lake build && lake build Tests` | passed closeout sync |
| `COLD-E1-SCOPE-AUDIT-001` | Audit worktree scope and unrelated legacy/tooling changes before accepting this clean-start operator closeout. | `COLD-E1-CLOSEOUT-SYNC-001` | reviewer/human | no Lean declaration expected | final audit report and `git status --short` | `python3 tools/qbe.py check`; `lake build && lake build Tests` | active reviewer audit |

## Stale and Rejected Route Memory

- Retire lower packets using any prior optctrl task memory, prior candidate
  names, old Qiskit exports, or previous ChatGPT Pro suggestions.
- Retire any packet that still asks lower workers to define
  `coldE1CandidateImage` or `coldE1CandidateMatrix`; both declarations now
  compile.
- Reject target changes, hidden oracle calls, extra ancillas beyond the
  one-signal starting point, simulator-only certificates, and hardware
  optimality or lower-bound claims.

## Lower-Facing Packet

Detailed split packet:
`proof-attempts/QBE-OP-OPTCTRL-COLD-CLEAN-001-lower-packets-cycle02.md`.

Target file: `QuantumBlockEncoding/ColdStartTransferE1.lean`.

Allowed write scope: add task-local candidate definitions and lemmas after the
existing target-side declarations in the same namespace.  Do not import or
reuse previous optctrl candidate definitions.

Current compiled Lean leaf:

- `coldE1CandidateImage : Fin 16 -> Fin 16` matches the table above.
- `coldE1CandidateMatrix : Matrix (2 * 8) (2 * 8) Rat` uses column-vector
  convention: entry `(row,col)` is `1` exactly when
  `row = coldE1CandidateImage col`.
- `coldE1CandidateImage_injective` is compiled as the first finite permutation
  proxy.
- `coldE1Candidate_blockProjection` is compiled as the clean-block equality
  proof.

Retired executable-export leaf:

- `COLD-E1-EXPORT-001` created the post-Lean export packet naming
  `coldE1Candidate_blockProjection`,
  `coldE1CandidateImage_permutation_certificate`, and the four
  `coldE1HighLevelSeedCost_*` field theorems.
- The export check compared executable matrices and clean blocks and recorded
  `finite_matrix_ok=true`, `block_entry_ok=true`, `unitarity_ok=true`,
  `qiskit_export_ok=true`, and `error_class=none`.
- Future work must not change the target, projector, normalizer, error, layout,
  candidate image, or candidate matrix unless a new explicit task opens a new
  construction.

Expected gate after any Lean edit:

```bash
python3 tools/qbe.py check
```

The repository-level gate from `AGENTS.md` also remains:

```bash
lake build && lake build Tests
```

## Cycle 2 Lower Split

Lower 1 should retire the natural-language routes for `COLD-E1-BLOCK-001` and
`COLD-E1-RESOURCE-001`; it should not restart candidate search or reactivate
`COLD-E1-PERM-IMAGE-001`.

Lower 2 should not edit the Lean target unless the export packet reveals a
concrete mismatch in the named certificates.

Lower 3/export work is retired for this candidate.  Reviewer or middle may
rerun the diagnostic if the export files are edited, but no lower proof search
is active unless a concrete Lean/export mismatch appears.

`COLD-E1-CLOSEOUT-SYNC-001` is now retired for this cycle.  The problem proof
note, storyboard/evolution page, final report status, and forbidden-claim
guardrails have been synchronized with the passed export diagnostic.

`COLD-E1-SCOPE-AUDIT-001` is the only active frontier item.  It is not a lower
Lean proof leaf; it is a reviewer/human scope decision for unrelated legacy
deletions and tooling or manifest churn in the current worktree.

# Candidate Population: QBE-OP-OPTCTRL-COLD-CLEAN-001

## Population Rules

All candidates target the same fixed operator `coldE1Target` with normalizer
`coldE1ExactNormalizer = 1`, exact error `coldE1ExactError = 0`, and clean
projector `coldE1BlockProjection`.  A candidate is achieved only after Lean
proves the named block theorem, the required unitarity or permutation
certificate, and the resource tuple used for ranking.

Inside the same asymptotic tier, candidates are ranked by
`(gateCount, depth, auxiliaryQubits, oracleCalls)`.

## Active Candidates

| Candidate | Family | Lean objects | Score | Diagnostics | Status |
|---|---|---|---|---|---|
| `COLD-CLEAN-PERM-001` | one-signal 16-state finite permutation preserving `S` | `coldE1CandidateImage`, `coldE1CandidateMatrix`, `coldE1CandidateImage_permutation_certificate`, `coldE1Candidate_blockProjection`, `coldE1HighLevelSeedCost_*` | certified high-level tuple `(4, 4, 1, 0)` from field theorems | candidate image, matrix, finite clean-block diagnostic, block theorem, permutation package, resource field certificate, and finite/Qiskit export checks pass | Lean-certified core, export checked |

## Candidate COLD-CLEAN-PERM-001

The candidate family uses one clean signal qubit and no pure ancilla.  For each
state bit `s`, the clean input column `(signal,T,tau,S) = (0,1,1,s)` maps to
the clean output row `(0,0,0,s)`.  The other clean input columns map to dirty
signal rows, so they contribute zero to the clean block.  Dirty input columns
fill the remaining rows to make a full permutation.

The candidate now has a Lean-certified core:

- `coldE1CandidateImage_permutation_certificate` packages the image as
  injective and surjective over `Fin 16`.
- `coldE1Candidate_blockProjection` proves the clean block equals
  `coldE1Target`.
- `coldE1HighLevelSeedCost_gateCount`,
  `coldE1HighLevelSeedCost_depth`,
  `coldE1HighLevelSeedCost_auxiliaryQubits`, and
  `coldE1HighLevelSeedCost_oracleCalls` certify the high-level tuple
  `(4, 4, 1, 0)`.

The candidate may be reported as the current achieved high-level seed-cost
solution for this fixed operator because the Lean core and post-Lean
finite/Qiskit export check have both passed.  Do not claim hardware optimality
or primitive gate decomposition from these field equalities.

Cycle 2 source-correspondence status: the image/matrix implementation leaf,
finite verifier leaf, and symbolic block theorem are no longer active.  The
compiled block theorem is:

```lean
theorem coldE1Candidate_blockProjection :
    coldE1BlockProjection coldE1CandidateMatrix := by
  intro i j
  simp [signalSystemBlockProjection, coldE1SignalIndex,
    coldE1CandidateMatrix, coldE1Target, coldE1SystemIndex,
    signalSystemBlockRowIndex, signalSystemBlockColIndex]
  native_decide +revert
```

## Rejected Or Archived Candidates

| Route | Reason |
|---|---|
| previous optctrl populations or candidate names | violates the clean-start rule |
| previous ChatGPT Pro suggestions or Qiskit exports | not Lean-certified task-local construction memory |
| direct root proof before `coldE1CandidateMatrix` exists | no named candidate unitary to certify |
| extra-ancilla or hidden-oracle rescue route | changes the starting contract unless upper explicitly opens alternatives |
| simulator-only achieved solution | finite checks are diagnostics, not certificates |

## Next Mutation Or Repair Route

No mutation or repair route is active for the certified candidate.  Leaf
`COLD-E1-EXPORT-001` is retired after the post-Lean packet and finite
executable checks named `coldE1Candidate_blockProjection`,
`coldE1CandidateImage_permutation_certificate`, and the four
`coldE1HighLevelSeedCost_*` field theorems.  Future work should only rerun the
export check after an export edit or a concrete Lean/export mismatch.  Do not
weaken `coldE1Target`, the clean signal index, the normalizer, the one-signal
layout, or the candidate image/matrix.

The memory/report route `COLD-E1-CLOSEOUT-SYNC-001` is retired for this cycle:
the problem proof note, storyboard/evolution memory, final report status, and
forbidden-claim guardrails have been synchronized.  This was not a mutation and
does not reopen Lean proof search.

Cycle 2 lower packet:
`proof-attempts/QBE-OP-OPTCTRL-COLD-CLEAN-001-lower-packets-cycle02.md`.
That packet now treats `COLD-E1-RESOURCE-001` and `COLD-E1-PERM-UNITARY-001` as
compiled dependency memory, and the closeout memory now also retires
`COLD-E1-EXPORT-001`.

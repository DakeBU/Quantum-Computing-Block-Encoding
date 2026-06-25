# Candidate Population: QBE-MAIN-CASE-HIER-COLD-001

## Population Rules

All candidates target the fixed operator

$$
E_1 = |0><1|_T \otimes |0><1|_\tau \otimes I_S
$$

with normalizer `alpha = 1`, exact error `0`, one clean signal-qubit block
projector, and system order `(T,tau,S)`.  A candidate is achieved only after
Lean proves the named clean-block theorem, the required unitarity or
permutation certificate, and the resource tuple used for ranking.

Inside the same asymptotic tier, candidates are ranked by
`(gateCount, depth, auxiliaryQubits, oracleCalls)`.

## Active Candidates

| Candidate | Family | Lean objects | Score | Diagnostics | Status |
|---|---|---|---|---|---|
| `MAIN-PARTIAL-PERM-001` | one-signal finite partial permutation preserving `S` | planned `mainCaseColdPartialPermImage`, `mainCaseColdPartialPermMatrix`, `mainCaseColdPartialPermExactCleanBlock` | partial score `(?, ?, 1, 0)`; gate/depth unresolved until circuit schema | middle exact table sanity check passed; durable lower-3 script optional | active exact candidate |

## Candidate MAIN-PARTIAL-PERM-001

The candidate uses one clean signal qubit and no hidden oracle calls.  For each
passive state `s`, the only clean input branch that remains clean is
`(signal,T,tau,S) = (0,1,1,s)`, and it maps to `(0,0,0,s)`.  All other clean
input branches map to dirty signal rows.  The dirty input branches fill the
remaining output rows to make a full finite permutation.

The source-facing candidate table is recorded in
`conversion-windows/QBE-MAIN-CASE-HIER-COLD-001.md`.

Current partial score:

| Field | Value | Status |
|---|---:|---|
| `auxiliaryQubits` | `1` | source-layout claim, needs Lean field theorem |
| `oracleCalls` | `0` | candidate has no oracle call, needs Lean field theorem |
| `gateCount` | unknown | requires a circuit schema or honest high-level resource model |
| `depth` | unknown | requires a schedule or high-level resource model |

The active proof target is `MAIN-CLEAN-ENTRY-001`: instantiate
`BlockEncodingClassics.partialPermutationCertificate` under task-local
`mainCaseCold*` names and prove the clean block equals `mainCaseColdTarget`.

Cycle 2 selection status: keep `MAIN-PARTIAL-PERM-001` as the only active exact
candidate.  The candidate table passed necessary finite support and permutation
checks, but it is not a certified population member until the COLD clean-entry
theorem compiles.

## Insight Pool

| Route | Status | Reason |
|---|---|---|
| `BE.Sparse.OneSparsePermutation` | preserved alternative | the target is one-sparse, but partial permutation is more direct for a matrix-unit tensor identity |
| `BE.LCU.PrepareSelect` | archived for this cycle | a one-term LCU would restate the matrix unit with unnecessary preparation/select machinery |
| `BE.QSVT.ConsumerContract` | downstream only | QSVT consumes a proved block encoding and should not replace the first exact construction |
| dilation fallback | archived for this cycle | the target is a partial isometry with an explicit partial-permutation completion |

## Next Mutation Or Repair Route

Do not mutate the target.  If the finite diagnostic rejects
`MAIN-PARTIAL-PERM-001`, repair only the candidate image table while preserving
the same clean-block contract.  If the clean-entry theorem compiles but the
unitarity/resource layers remain open, schedule `MAIN-PERM-UNITARY-001` or
`MAIN-RESOURCE-001` as separate leaves rather than reopening the clean-entry
proof.

Existing `mainCasePro*` declarations belong to the separate Pro-isolated arm
and are not certified population members for this no-Pro COLD task.

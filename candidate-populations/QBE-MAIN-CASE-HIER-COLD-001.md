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
| `MAIN-PARTIAL-PERM-001` | one-signal finite partial permutation preserving `S` | `mainCaseColdQueryTarget`, `mainCaseColdPartialPermImage`, `mainCaseColdPartialPermMatrix`, `mainCaseColdPartialPermExactCleanBlock`, `mainCaseColdPartialPerm_clean_eq_target`, `mainCaseColdPartialPermImage_bijective`, `mainCaseColdPartialPerm_blockProjection`, `mainCaseColdCircuitImage_eq_partialPermImage`, `mainCaseColdPartialPermCost_*` | score `(5, 5, 1, 0)` at the high-level logical `{X,CNOT,Toffoli}` tier | COLD clean-block, finite-bijection, operator metadata, block-projection, circuit-image, and cost field theorems compile | resource certified; full candidate pending `VerifiedOperatorBlockEncoding` package |

## Candidate MAIN-PARTIAL-PERM-001

The candidate uses one clean signal qubit and no hidden oracle calls.  For each
passive state `s`, the only clean input branch that remains clean is
`(signal,T,tau,S) = (0,1,1,s)`, and it maps to `(0,0,0,s)`.  All other clean
input branches map to dirty signal rows.  The dirty input branches fill the
remaining output rows to make a full finite permutation.

The source-facing candidate table is recorded in
`conversion-windows/QBE-MAIN-CASE-HIER-COLD-001.md`.

Current compiled score at the high-level logical resource tier:

| Field | Value | Status |
|---|---:|---|
| `gateCount` | `5` | compiled as `mainCaseColdPartialPermCost_gateCount` |
| `depth` | `5` | compiled as `mainCaseColdPartialPermCost_depth` |
| `auxiliaryQubits` | `1` | compiled as `mainCaseColdPartialPermCost_auxiliaryQubits` |
| `oracleCalls` | `0` | compiled as `mainCaseColdPartialPermCost_oracleCalls` |

The proof target `MAIN-CLEAN-ENTRY-001` compiles under task-local
`mainCaseCold*` names by instantiating
`BlockEncodingClassics.partialPermutationCertificate`.  The finite-bijection
subleaf of `MAIN-PERM-UNITARY-001` also compiles as
`mainCaseColdPartialPermImage_bijective`.  Cycle 3 additionally closes
`MAIN-BLOCK-PROJECTION-001` as `mainCaseColdPartialPerm_blockProjection` and
`MAIN-RESOURCE-001` through the task-local logical circuit theorem
`mainCaseColdCircuitImage_eq_partialPermImage` plus the
`mainCaseColdPartialPermCost_*` field theorems.

Cycle 3 selection status: keep `MAIN-PARTIAL-PERM-001` as the only active exact
candidate family.  It is certified at the exact clean-block,
finite-permutation, block-projection, and resource-tuple layers, but it is not
a complete block-encoding candidate for export until the
`mainCaseColdPartialPermCandidate` and `mainCaseColdPartialPermVerified`
package compiles.

## Insight Pool

| Route | Status | Reason |
|---|---|---|
| `BE.Sparse.OneSparsePermutation` | preserved alternative | the target is one-sparse, but partial permutation is more direct for a matrix-unit tensor identity |
| `BE.LCU.PrepareSelect` | archived for this cycle | a one-term LCU would restate the matrix unit with unnecessary preparation/select machinery |
| `BE.QSVT.ConsumerContract` | downstream only | QSVT consumes a proved block encoding and should not replace the first exact construction |
| dilation fallback | archived for this cycle | the target is a partial isometry with an explicit partial-permutation completion |

## Next Mutation Or Repair Route

Do not mutate the target.  If a later candidate-package attempt fails, consume
the compiled resource declarations rather than reopening circuit search unless
the finite image or resource theorem is contradicted.  The next repair route is
`MAIN-CANDIDATE-PACKAGE-001`: package a COLD-local
`OperatorBlockEncodingCandidate` and `VerifiedOperatorBlockEncoding`, then
attempt executable export only after that named verified candidate compiles.
Do not reopen the clean-entry, finite-bijection, block-projection, or resource
proofs unless the target operator, finite image table, or circuit schema
changes.

Existing `mainCasePro*` declarations belong to the separate Pro-isolated arm
and are not certified population members for this no-Pro COLD task.

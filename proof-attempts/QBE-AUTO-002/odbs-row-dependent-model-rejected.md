# Rejected Model: Row-Dependent O_D^BS Address

Task: `QBE-AUTO-002`
Status: rejected as the active faithful target
Date: 2026-05-24

## Reason

The current Lean helper `robinSparseColumnMap` chooses sparse branches by row:
boundary rows have fewer nonzero entries, and unused sparse indices are mapped
back to the row address.  This creates the compiled collision
`oneTermRobinGate_O_D_BS_boundaryUnusedSparseCollision_n3`.

That collision is useful proof memory, but it is not a faithful reading of the
GHL2025 O_D^BS oracle.  The paper defines a banded sparse-access oracle using a
global sparse slot:

$$
r_{si}=r_{s0}+i \bmod 2^n.
$$

The Robin section then says zeros can be included and sums over
$s=0,\dots,\kappa-1$.  Therefore zero boundary entries should be represented by
zero coefficients in the amplitude layer, while the sparse-access register
keeps its global slot.

## Keep

- Keep `robinSparseColumnMap` only as a matrix-entry helper or rejected-model
  test until it is refactored.
- Keep the collision theorem as a regression test showing why the old active
  image cannot be the paper O_D^BS unitary.

## Replaced In Active Address Layer

The active `bandedSparseAccessPaperAddress` route now uses the global
sparse-slot offset table for the one-term Robin $\kappa=7$ construction,
followed by the address formula $r_{s0}+i \bmod 2^n$.

The active source predicate is now
`bandedSparseAccessPaperGlobalSlotSource`: padded clean input and sparse index
$s<\kappa$.  The old row-dependent clean-source and unused-branch predicates
remain only as rejected-model or audit helpers.

## Next Lean Target

The first corrected global-source blocks now compile:

- `oneTermRobinGate_O_D_BS_globalSlotSource_entrySafety` packages the active
  forward and transpose-style dagger entries for finite global-source columns.
- `bandedSparseAccessPostSwapCleanup_of_globalSlotSourceCandidate_noRange`
  feeds `bandedSparseAccessPaperGlobalSlotSource` into the conditional
  post-SWAP cleanup candidate.
- Tests show columns `0` and `48` are both active global sources while the old
  row-dependent helper still rejects column `48`, and encoded sparse slot `7`
  is out of range for $\kappa=7$.

Next Lean target: state a fixed global-source inverse-on-range or injectivity
interface.  Do not promote O_D^BS unitarity, semantic dagger cleanup, LCU
correctness, or final block correctness unless that interface and the needed
finite permutation proof actually compile.

# O_D^BS Reverse-Index Roundtrip Attempt: 2026-05-23

Task: `QBE-AUTO-002`

Mode: `faithfulPaper`

Paper anchor: Guseynov-Huang-Liu 2025, Lemma 1 and Fig. 1-term Robin,
arXiv:2506.20478.

## Fixed Target

The next fixed theorem should turn the finite reverse-index scans into a
general Lean block for the one-term Robin parameter family:

```lean
theorem robinSparseReverseColumnRoundtrip_of_lt_eight
    {n s i : Nat} (hn : 3 <= n) (hs : s < 8) (hi : i < gridSize n) :
    robinSparseColumnMap n
      (robinSparseReverseColumnIndex n i (robinSparseColumnMap n s i))
      (robinSparseColumnMap n s i) = i
```

The bound `s < 8` matches the current one-term contract
`Examples.RobinHeat.oneTermParameters n`, where `kappa = 7` and
`clog2 kappa = 3`.  A later parameter-family theorem may replace this with a
statement over the sparse register width, but that should be a separate
contract change.

## Current Evidence

Lean currently defines:

- `robinSparseReverseColumnIndex`
- `robinSparseReverseColumnRoundtripCheck`
- `bandedSparseAccessPaperPostSwapPreimageCandidate`
- `bandedSparseAccessPaperPostSwapPreimageCandidateChecks`

`Tests/Basic.lean` proves the Boolean scans
`robinSparseReverseColumnRoundtripCheck 3 8 = true` and
`robinSparseReverseColumnRoundtripCheck 4 8 = true`.  It also proves that every
finite source column for `n = 3`, `kappa = 7` passes
`bandedSparseAccessPaperPostSwapPreimageCandidateChecks`.

These are executable tests, not a proof of the target theorem.

## Attempt Status

Status: accepted for the fixed $s < 8$ theorem.

Lean now proves `robinSparseReverseColumnRoundtrip_of_lt_eight`.  The accepted
route splits on the five row regions in `robinSparseColumnMap`:

- left boundary rows `i = 0` and `i = 1`;
- bulk rows `2 <= i` and `i <= gridSize n - 3`;
- right boundary rows `i = gridSize n - 2` and `i = gridSize n - 1`;
- unused sparse-index branches where the forward map returns `i`.

The proof introduced row-normalization blocks for `robinSparseColumnMap` and
`robinSparseReverseColumnIndex`, then used arithmetic facts from `3 <= n`,
especially `8 <= gridSize n`, `2 < gridSize n - 2`, and no underflow in the
right-boundary subtractions.

## Remaining Obligations

The roundtrip theorem would only identify the reverse sparse index for the
Robin column map.  It would not prove:

- uniqueness of the post-SWAP preimage;
- that every candidate is in the clean padded domain for arbitrary source
  columns;
- dagger cleanup after SWAP;
- unitarity of `O_D^BS`, SWAP, or `(O_D^BS)^dagger`;
- block extraction correctness.

Those claims must remain under `proved := false` until their own fixed Lean
targets compile.

## Follow-On Accepted Block

Cycle 6 also proves the clean-source candidate audit:

```lean
theorem bandedSparseAccessPaperPostSwapPreimageCandidateChecks_of_cleanSource
    (p : OneTermRobinParameters) (source : Nat)
    (hn : 3 ≤ p.n) (hkappa : p.kappa = 7) (hκbits : clog2 p.kappa = 3)
    (hsource : source < qubitDim (oneTermRobinTotalQubits p))
    (hclean : bandedSparseAccessPaperCleanInput p source = true) :
    bandedSparseAccessPaperPostSwapPreimageCandidateChecks p source = true
```

The route factors through a new three-bit bound
`robinSparseReverseColumnIndex_lt_eight_of_columnMap` and local O_D-register
splice lemmas.  It proves the executable Boolean image/clean/address audit for
the candidate under the one-term assumptions, but still does not prove
preimage uniqueness or promote `daggerCleanup`.

## Cycle 9 Obstruction: Boundary Unused Sparse Collision

The accepted reverse-index and cleanup-candidate blocks are not enough to
promote injectivity for the current active skeleton.  Lean now proves:

```lean
theorem oneTermRobinGate_O_D_BS_boundaryUnusedSparseCollision_n3
```

For $n=3,\kappa=7$, source columns `0` and `48` are both clean according to
`bandedSparseAccessPaperCleanInput`.  They have row value $0$ and sparse-index
values $0$ and $3$, respectively.  Boundary row $0$ has only three Robin
stencil entries, so the current executable address map sends both branches to
address $0$, and `bandedSparseAccessPaperImage` maps both source columns to
the same row.

This is an accepted blocker, not a failed tactic route.  Do not continue an
injectivity proof over the current clean-domain skeleton.  The next fixed
target should be a source-contract correction: either a row-dependent valid
sparse-branch predicate tied to Lemma 1, or a reversible extension for unused
sparse branches that agrees with Lemma 1 on valid branches.

# SP.Core.FirstColumn

Priority: P0 for every state-preparation task.

## Detect When

The task asks for a unitary `U` that maps the all-zero computational basis
state to a normalized target state.  In matrix form, this is a first-column
equality, not a block-encoding clean-block equality.

## Proof Order

1. Define the target amplitudes and prove their normalization proposition.
2. Define the candidate unitary and its circuit/resource record.
3. Prove the candidate's unitarity predicate.
4. Prove `FirstColumnMatches`, equivalently `U |0^n> = |psi>`.
5. Package the result as `VerifiedStatePreparation`.
6. Use `VerifiedStatePreparation.asZeroErrorApprox` only after the exact proof
   exists; epsilon relaxation never replaces normalization or unitarity.

## Compiled Anchors

- `zeroBasisIndex`
- `StatePreparationTarget`
- `FirstColumnMatches`
- `StatePreparationCandidate.preparesTarget`
- `VerifiedStatePreparation`
- `VerifiedStatePreparation.firstColumn`
- `VerifiedStatePreparation.asZeroErrorApprox`

## Reviewer Gate

Reject a candidate that proves only one output amplitude, silently normalizes
an unnormalized vector, or substitutes a rank-one operator for the requested
state without an explicit task reclassification.

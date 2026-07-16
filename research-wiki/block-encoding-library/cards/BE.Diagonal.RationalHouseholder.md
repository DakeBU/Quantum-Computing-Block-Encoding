# BE.Diagonal.RationalHouseholder

Priority: P1 for exact rational diagonal targets.

## Detect When

The target is diagonal with rational entries in `[-1,1]`, especially dyadic
grid values such as `j / 2^n` or `(j / 2^n)^k`.

## Construction

For a rational value `p / q`, apply Lagrange's four-square theorem to
`q^2 - p^2`.  The resulting vector

```text
(p / q, a / q, b / q, c / q, d / q, 0, 0, 0)
```

has rational entries and unit norm. A Householder reflection sends the clean
basis vector to this vector. Taking the controlled direct sum over system
indices gives an exact rational orthogonal matrix whose clean block is the
requested diagonal operator.

## Lean Proof Order

1. Use `Nat.sum_four_squares` from
   `Mathlib.NumberTheory.SumFourSquares` for the residual.
2. Prove the branch vector has unit norm and the requested clean coordinate.
3. Reuse the compiled Householder clean-entry and orthogonality lemmas.
4. Reuse the controlled-direct-sum clean-block theorem.
5. Package orthogonality, clean-block equality, normalizer, cleanup, and a
   concrete resource equality in one strong certificate.

## Compiled Anchors

- `linearDiagonalRationalCompletion_exists`
- `linearDiagonalHouseholderInputBEContract`
- `linearDiagonalHouseholderInputBEContract_clean_eq_target`
- `linearDiagonalHouseholderInputBEContract_complete`
- `cubicDiagonalRationalCompletion_exists`
- `cubicDiagonalHouseholderExactBEContract`
- `cubicDiagonalHouseholderExactBEContract_clean_eq_target`
- `cubicDiagonalHouseholderExactBEContract_complete`

## Reviewer Gate

Do not accept an `ExactCleanBlock` alone as a physical block encoding: it does
not carry unitarity. Require a rational-orthogonality theorem or another
concrete unitary predicate in the same certificate.

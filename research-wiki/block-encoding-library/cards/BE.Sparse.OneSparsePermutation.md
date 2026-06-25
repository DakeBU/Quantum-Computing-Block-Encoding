# Card: BE.Sparse.OneSparsePermutation

## When To Try This Route

Use when each column has one possible nonzero row, described by a support map
`c col`.

## Mathematical Pattern

If `A row col = 0` unless `row = c col`, then:

$$
A_{row,col} = A_{c(col),col}\,\delta_{row,c(col)}.
$$

The circuit proof normally combines an amplitude oracle for the nonzero value
with a permutation/location oracle.

## Intuition

This is the closest sparse route to a partial permutation.  The support map
selects exactly one possible row for each column; the amplitude oracle only
needs to supply the value at that support.  The clean-entry proof is therefore
just a Kronecker-delta support calculation.

## Lean Anchors

- `BlockEncodingClassics.kroneckerRat`
- `BlockEncodingClassics.oneSparseMatrix`
- `BlockEncodingClassics.oneSparseMatrix_entry_if`
- `BlockEncodingClassics.oneSparse_from_support`
- `BlockEncodingClassics.OneSparseCertificate`

## Source Memory

Lin 2201.08309 one-sparse block-encoding proof pattern.

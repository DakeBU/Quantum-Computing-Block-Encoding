# Card: BE.Sparse.OneSparsePermutation

## Detection

Use when each column has one possible nonzero row, described by a support map
`c col`.

## Mathematical Pattern

If `A row col = 0` unless `row = c col`, then:

$$
A_{row,col} = A_{c(col),col}\,\delta_{row,c(col)}.
$$

The circuit proof normally combines an amplitude oracle for the nonzero value
with a permutation/location oracle.

## Lean Anchors

- `BlockEncodingClassics.kroneckerRat`
- `BlockEncodingClassics.oneSparseMatrix`
- `BlockEncodingClassics.oneSparseMatrix_entry_if`
- `BlockEncodingClassics.oneSparse_from_support`

## Source Memory

Lin 2201.08309 one-sparse block-encoding proof pattern.

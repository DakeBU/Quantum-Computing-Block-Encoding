# Card: BE.Sparse.ColumnOracle

## Detection

Use when a sparse column has slot labels `slot` and a column-location oracle
returns `loc col slot`.

## Mathematical Pattern

The clean entry is a finite slot sum:

$$
\sum_{\ell} value_{\ell,col}\,\delta_{row,loc(col,\ell)}.
$$

With a uniform slot preparation, a normalizer such as the sparsity `s` is
typically introduced.

## Lean Anchors

- `BlockEncodingClassics.sparseColumnCleanEntry`
- `BlockEncodingClassics.SparseColumnCertificate`

## Open Leaf

The next reusable theorem should formalize uniqueness/support hypotheses that
collapse the slot sum to the target matrix entry.

## Source Memory

Lin 2201.08309 sparse column-oracle construction.

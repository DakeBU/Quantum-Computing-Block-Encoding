# Card: BE.Sparse.ColumnOracle

## When To Try This Route

Use when a sparse column has slot labels `slot` and a column-location oracle
returns `loc col slot`.

## Mathematical Pattern

The clean entry is a finite slot sum:

$$
\sum_{\ell} value_{\ell,col}\,\delta_{row,loc(col,\ell)}.
$$

With a uniform slot preparation, a normalizer such as the sparsity `s` is
typically introduced.

## Intuition

The location oracle is not "the matrix".  It only proposes candidate row
locations.  The proof becomes a finite sum in which Kronecker deltas select the
slot that actually hits the requested row.  A separate uniqueness/support
lemma must collapse that finite sum to the target entry.

## Normalizer Notes

The normalizer depends on the preparation and value bound.  A simple uniform
slot preparation often contributes a factor like the slot count `s`; a bounded
value oracle may contribute an additional scale.  Record these factors
explicitly before assigning a lower Lean proof.

## Lean Anchors

- `BlockEncodingClassics.sparseColumnCleanEntry`
- `BlockEncodingClassics.sparseColumnCleanEntry_no_hit`
- `BlockEncodingClassics.sparseColumnCleanEntry_unique_slot`
- `BlockEncodingClassics.SparseColumnCertificate`
- `BlockEncodingClassics.RowColumnSparseCertificate` for the general sparse sibling route

## Open Leaf

No-hit and unique-hit slot collapse are formalized.  A paper-specific sparse
route still has to prove that its location oracle satisfies those hypotheses
for the intended support map and normalizer.

## Source Memory

Lin 2201.08309 sparse column-oracle construction.

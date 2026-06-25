# Card: BE.Sparse.RowColumnOracle

## When To Try This Route

Use when a general sparse matrix has both row-location and column-location
oracles.

## Mathematical Pattern

The proof compares a source evolution and a reversed target preparation.  The
inner product creates two delta constraints: the chosen column slot must hit
the target row, and the row slot must point back to the source column.

## Lean Status

Status: `contract-only` for the proof-carrying wrapper, `obligation` for the reusable uniqueness-collapse theorem.

Compiled Lean declarations:

- `BlockEncodingClassics.rowColumnSparseDeltaEntry`
- `BlockEncodingClassics.RowColumnSparseCertificate`

Planned reusable leaf:

```text
row-column finite-sum delta contraction
```

This should be proved before any paper-specific sparse block-encoding theorem
uses the card as a formal dependency.

## Source Memory

Lin 2201.08309 general sparse block-encoding construction; GSLW sparse-access
lemmas are the downstream modern source.

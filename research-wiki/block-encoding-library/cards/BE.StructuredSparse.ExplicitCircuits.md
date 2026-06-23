# BE.StructuredSparse.ExplicitCircuits

Priority: P2

Sources: explicit sparse block-encoding circuits and structured-matrix data
input papers.

## Detect When

The target matrix has arithmetic structure: Toeplitz, tridiagonal,
finite-difference stencil, repeated values, shifts, masks, or low-description
sparsity.

## Construction

Avoid loading every entry.  Express the matrix as a small number of structured
terms: shifts, diagonal masks, repeated-value selectors, or arithmetic pattern
oracles.  Then combine by LCU or sparse-access Gram construction.

## Lean Proof Shape

```lean
theorem structured_entry_formula :
  generatedMatrix row col = targetFormula row col

theorem structured_blockEncoding :
  IsBlockEncodingExact alpha a U generatedMatrix
```

## Proof-DAG Leaves

- arithmetic pattern theorem;
- shift/permutation theorem;
- diagonal value theorem;
- LCU or sparse-access combination;
- resource comparison against naive dense loading.

## Resource Notes

This is often where ABEIS can improve paper baselines: reduce repeated data
loading, flag qubits, or depth by exploiting the symbolic pattern.

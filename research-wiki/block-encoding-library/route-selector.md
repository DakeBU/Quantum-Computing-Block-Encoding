# Block-Encoding Route Selector

Given an operator target $A$, choose the first route whose detection rule fits.
If several routes fit, instantiate the cheapest exact candidate first and keep
the others as population diversity.

## Route 1: Partial Permutation

Use when $A$ is a matrix unit, projector, reset-on-subspace map, partial
injection, or a tensor of one of these with an identity register.

Typical form:

$$
A = |u\rangle\langle v| \otimes I.
$$

Cards:

- `BE.PartialPermutation.MatrixUnitTensorId`
- `BE.PermMatrix.CleanBlock`
- `BE.Tensor.PassiveRegister`

Rejected first routes: LCU, sparse-access, QSVT.  They are more general but
obscure the proof and resource score.

## Route 2: One-Sparse Permutation

Use when each column has one possible nonzero row.  This is the sparse route
closest to partial permutation.

Card: `BE.Sparse.OneSparsePermutation`.

## Route 3: LCU / PREPARE-SELECT

Use when the target is a finite weighted sum:

$$
A = \sum_j \alpha_j A_j
$$

where each $A_j$ is unitary or already block-encoded.

Card: `BE.LCU.PrepareSelect`.

## Route 4: Product/Tensor Arithmetic

Use when $A$ is built from already encoded parts:

$$
A = AB,\qquad A = A_1 \otimes A_2,\qquad A = A_1 \oplus A_2.
$$

Cards:

- `BE.Arithmetic.Product`
- `BE.Arithmetic.Tensor`

## Route 5: Value-To-Amplitude Query Oracle

Use when the matrix value or angle is computed reversibly and then loaded into
a signal-qubit amplitude by controlled rotation plus uncompute.

Card: `BE.QueryModel.ValueToAmplitude`.

## Route 6: Sparse Access / Gram Construction

Use when the target comes with row/column/value oracles and a sparse-access
contract.  The proof should reduce a clean block entry to an inner product of
two prepared states.

Cards:

- `BE.Sparse.ColumnOracle`
- `BE.Sparse.RowColumnOracle`
- `BE.SparseAccess.GramConstruction`

## Route 7: Density / Purification

Use when the target is a density matrix or Gram matrix induced by a state
preparation.  The clean block often comes from a partial trace or swap test
calculation.

Card: `BE.Density.FromPurification`.

## Route 8: Dilation Fallback

Use when $A$ is a contraction and no better structure is found.  Prefer a
diagonal or 2-by-2 scalar rotation special case before general SVD dilation.

Cards:

- `BE.Contraction.SVDDilation`
- `BE.HermitianDilation`

## Route 9: Hermitian / Qubitization / QSVT Consumer

Use only after a block encoding has been proved and the target algorithm needs
a polynomial transformation, inverse, sign, filter, or Hamiltonian simulation.

Cards:

- `BE.HermitianBlockEncoding`
- `BE.Qubitization.Chebyshev`
- `BE.QSVT.ConsumerContract`

## Route 10: Approximate Dense / Structured Circuits

Use when exact construction is not required or has stalled, and the task accepts
an explicit epsilon.

Cards:

- `BE.FABLE.ApproxDense`
- `BE.StructuredSparse.ExplicitCircuits`

## Mandatory Rejection Note

Every upper/middle route decision should write one sentence explaining rejected
first routes.  Example:

```text
Rejected LCU and QSVT for E_k because the target is a matrix unit tensor
identity; partial permutation gives an exact clean-block proof with one block
ancilla and no oracle calls.
```

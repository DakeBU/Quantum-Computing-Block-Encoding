# Lean Roadmap for the Block-Encoding Library

This roadmap lists reusable Lean atoms that should gradually replace ad hoc
task-local proofs.

## Core Definitions

```lean
def cleanBlock
def IsBlockEncodingExact
def IsBlockEncodingApprox
```

Target theorem style:

```lean
theorem blockEncoding_ext_entrywise :
  (forall row col, cleanBlock U row col = A row col / alpha) ->
  IsBlockEncodingExact alpha a U A
```

Exact finite examples should first use entrywise clean-block theorems.  Norm
lemmas are reserved for approximate certificates.

## Suggested File Structure

```text
QuantumBlockEncoding/BlockEncoding/Basic.lean
QuantumBlockEncoding/BlockEncoding/PermMatrix.lean
QuantumBlockEncoding/BlockEncoding/PartialPermutation.lean
QuantumBlockEncoding/BlockEncoding/Arithmetic.lean
QuantumBlockEncoding/BlockEncoding/LCU.lean
QuantumBlockEncoding/BlockEncoding/SparseAccess.lean
QuantumBlockEncoding/BlockEncoding/Density.lean
QuantumBlockEncoding/BlockEncoding/Dilation.lean
QuantumBlockEncoding/BlockEncoding/QSVTContract.lean
QuantumBlockEncoding/Examples/OptimalControl/Ek.lean
QuantumBlockEncoding/Examples/CubicDiagonal.lean
```

Do not move existing large files until wrappers and imports compile.  Promote
one reusable theorem at a time.

## Common Proof-DAG Leaves

| Leaf | Meaning | Typical tactic shape |
| --- | --- | --- |
| permutation image | prove the finite function sends each clean input to the claimed clean output | `fin_cases`, `decide`, `simp` |
| clean block entry | unfold clean projection and permutation matrix entry | `ext row col`; `simp [cleanBlock]` |
| product clean entry | flatten `ancilla × system`, then use product clean-block theorem | `rfl`, finite index arithmetic |
| one-sparse support | collapse a Kronecker delta at `row = c col` | `by_cases h : row = c col`; `simp [h]` |
| sparse column sum | represent a slot sum and defer uniqueness/support collapse | finite fold plus support hypotheses |
| passive register | prove active map leaves the passive coordinate unchanged | case split on product index |
| LCU coefficient | compute the prepare/select inner sum | `simp [Matrix.mul_apply]`; finite sum algebra |
| product bridge | combine two clean-block equalities under embedded product | matrix multiplication index split |
| scalar rotation | prove `cos(theta/2) = x` for chosen angle | real analysis or symbolic contract |
| uncompute | prove workspace returns to zero | reversible-function inverse theorem |

## Current Compiled Atoms

These atoms compile in `QuantumBlockEncoding/BlockEncodingClassics.lean`:

- `productIndex`
- `cleanBlockProduct_permMatrix_entry`
- `cleanBlockProduct_eq_target_of_entry`
- `kroneckerRat`
- `oneSparseMatrix_entry_if`
- `oneSparse_from_support`
- `sparseColumnCleanEntry`
- `SparseColumnCertificate`
- `ValueToAmplitudeContract`
- `IsSymmetric`
- `cleanBlockBy_symmetric_of_symmetric`
- `scalarDilation_cleanEntry`
- `chebyshevT`
- `QubitizationChebyshevContract`

## Next Formalization Leaves

| Priority | Leaf | Why it matters |
| --- | --- | --- |
| P0 | row-column sparse delta contraction | shared by general sparse matrix BE proofs |
| P0 | full PREPARE-SELECT-PREPARE dagger clean block | shared by LCU and many paper constructions |
| P1 | diagonal contraction dilation unitarity | fallback exact BE for contractions |
| P1 | value-to-amplitude controlled-rotation semantic instance | needed for formula-defined diagonal oracles |
| P2 | two-dimensional qubitization/Chebyshev invariant subspace | first real step toward QSVT theorem support |

## Acceptance Status

- `planned`: desired reusable theorem, no Lean declaration.
- `contract-only`: theorem may be used as explicit external assumption.
- `obligation`: active proof-DAG leaf.
- `formalized`: Lean declaration compiles and is imported by wrappers.

Never mark a card as `formalized` because the prose proof is convincing.

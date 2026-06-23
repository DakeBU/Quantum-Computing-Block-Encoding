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
| passive register | prove active map leaves the passive coordinate unchanged | case split on product index |
| LCU coefficient | compute the prepare/select inner sum | `simp [Matrix.mul_apply]`; finite sum algebra |
| product bridge | combine two clean-block equalities under embedded product | matrix multiplication index split |
| scalar rotation | prove `cos(theta/2) = x` for chosen angle | real analysis or symbolic contract |
| uncompute | prove workspace returns to zero | reversible-function inverse theorem |

## Acceptance Status

- `planned`: desired reusable theorem, no Lean declaration.
- `contract-only`: theorem may be used as explicit external assumption.
- `obligation`: active proof-DAG leaf.
- `formalized`: Lean declaration compiles and is imported by wrappers.

Never mark a card as `formalized` because the prose proof is convincing.

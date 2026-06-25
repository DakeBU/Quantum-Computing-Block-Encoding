# Block-Encoding Proof Network

This file links the literature memory cards to compiled Lean leaves.  It is the
first ABEIS "intuition memory" graph for block-encoding construction: agents
should reuse these nodes instead of re-deriving the same proof shape.

## Compiled Lean Leaf Nodes

| Lean declaration | Memory cards | Literature sources | Role |
| --- | --- | --- | --- |
| `BlockEncodingClassics.cleanBlockBy_permMatrix_entry` | `BE.PermMatrix.CleanBlock`, `BE.PartialPermutation.MatrixUnitTensorId` | finite permutation completions; matrix-unit block encodings | Converts a finite reversible image predicate into a clean-block entry. |
| `BlockEncodingClassics.cleanBlockBy_permMatrix_eq_target_of_entry` | `BE.PermMatrix.CleanBlock`, `BE.PartialPermutation.MatrixUnitTensorId` | same as above | Turns entrywise finite-image verification into exact matrix equality. |
| `BlockEncodingClassics.productIndex` | `BE.EntrywiseExact.CleanBlock`, `BE.Tensor.PassiveRegister` | Lin 2201.08309 entrywise clean-block convention | Flattens explicit `ancilla × system` indices. |
| `BlockEncodingClassics.cleanBlockProduct_permMatrix_entry` | `BE.EntrywiseExact.CleanBlock`, `BE.PermMatrix.CleanBlock` | Lin 2201.08309 entrywise proof style | Product-register clean-block entry theorem. |
| `BlockEncodingClassics.cleanBlockProduct_eq_target_of_entry` | `BE.EntrywiseExact.CleanBlock` | Lin 2201.08309 | Product-register extensionality bridge. |
| `BlockEncodingClassics.kroneckerRat` | `BE.Sparse.OneSparsePermutation`, sparse finite-sum cards | Lin 2201.08309 one-sparse and sparse proofs | Rational delta used in finite clean-entry sums. |
| `BlockEncodingClassics.oneSparseMatrix_entry_if` | `BE.Sparse.OneSparsePermutation` | Lin 2201.08309 one-sparse route | Reduces one-sparse entries to a delta support predicate. |
| `BlockEncodingClassics.oneSparse_from_support` | `BE.Sparse.OneSparsePermutation` | Lin 2201.08309 | Reconstructs a one-sparse target from its support map. |
| `BlockEncodingClassics.OneSparseCertificate` | `BE.Sparse.OneSparsePermutation` | Lin 2201.08309 | Packages support-map one-sparse proofs as a reusable certificate. |
| `BlockEncodingClassics.sparseColumnCleanEntry` | `BE.Sparse.ColumnOracle` | Lin 2201.08309 sparse column route | Defines the finite slot-sum clean entry. |
| `BlockEncodingClassics.sparseColumnCleanEntry_no_hit`, `sparseColumnCleanEntry_unique_slot` | `BE.Sparse.ColumnOracle` | Lin 2201.08309 sparse column route | Collapses the slot sum in the no-hit and unique-hit cases. |
| `BlockEncodingClassics.SparseColumnCertificate` | `BE.Sparse.ColumnOracle` | Lin 2201.08309 | Proof-carrying sparse column interface. |
| `BlockEncodingClassics.rowColumnSparseDeltaEntry` | `BE.Sparse.RowColumnOracle` | Lin 2201.08309 general sparse construction | Defines the double-delta expression before uniqueness collapse. |
| `BlockEncodingClassics.RowColumnSparseCertificate` | `BE.Sparse.RowColumnOracle` | Lin 2201.08309; GSLW sparse route | Proof-carrying general sparse row/column interface. |
| `BlockEncodingClassics.ValueToAmplitudeContract` | `BE.QueryModel.ValueToAmplitude` | Lin 2201.08309 value/amplitude oracle route | Requires cleanup and amplitude-entry proofs before use. |
| `BlockEncodingClassics.IsSymmetric` | `BE.HermitianBlockEncoding` | Lin 2201.08309 Hermitian BE route | Local rational Hermitian surrogate. |
| `BlockEncodingClassics.cleanBlockBy_symmetric_of_symmetric` | `BE.HermitianBlockEncoding` | Hermitian BE route | Transfers symmetry from full matrix to clean block. |
| `BlockEncodingClassics.scalarDilation_cleanEntry` | `BE.Contraction.SVDDilation` | Lin 2201.08309 SVD/scalar dilation fallback | Verifies the clean entry of a 2-by-2 dilation block. |
| `BlockEncodingClassics.scalarDilation_offdiag01`, `scalarDilation_offdiag10`, `scalarDilation_diag11` | `BE.Contraction.SVDDilation` | Lin 2201.08309 scalar dilation fallback | Exposes the remaining scalar-dilation entries for later unitarity leaves. |
| `BlockEncodingClassics.scalarDilationRowDot`, `scalarDilation_row0_unit_norm_of`, `scalarDilation_row1_unit_norm_of`, `scalarDilation_rows01_orthogonal`, `scalarDilation_rows10_orthogonal` | `BE.Contraction.SVDDilation` | Lin 2201.08309 scalar dilation fallback | Proves the rational row norm and row orthogonality identities under an explicit unit-norm witness. |
| `BlockEncodingClassics.chebyshevT`, `BlockEncodingClassics.chebyshevT_succ_succ`, `chebyshevT_three_recurrence`, `chebyshevT_four_recurrence`, `BlockEncodingClassics.QubitizationChebyshevContract` | `BE.Qubitization.Chebyshev` | Low-Chuang; Lin 2201.08309 | Stores Chebyshev recurrence and proof-carrying downstream contract. |
| `BlockEncodingClassics.partialPermutationCertificate` | `BE.PartialPermutation.MatrixUnitTensorId` | current transfer-operator case; partial-isometry completions | Packages a partial permutation target as an exact clean-block certificate. |
| `BlockEncodingClassics.oneTermLCU_cleanBlock` | `BE.LCU.PrepareSelect` | Childs--Wiebe LCU; Berry--Childs--Cleve--Kothari--Somma; GSLW | Degenerate LCU base case used to normalize proof DAGs. |
| `BlockEncodingClassics.LCUCertificate` | `BE.LCU.PrepareSelect`, `BE.Arithmetic.Product`, `BE.QSVT.ConsumerContract` | Childs--Wiebe; GSLW | Proof-carrying clean-block abstraction for finite sums. |
| `BlockEncodingClassics.weightedSum2`, `weightedSum2_entry`, `BlockEncodingClassics.twoTermLCUCertificate`, `twoTermLCUCertificate_cleanBlock_entry` | `BE.LCU.PrepareSelect` | Childs--Wiebe; GSLW finite LCU arithmetic | Compiles the two-term weighted-sum bridge after selected blocks are proved. |
| `BlockEncodingClassics.ExactCleanBlock.toLCUCertificate` | `BE.LCU.PrepareSelect`, `BE.Arithmetic.Product` | LCU/product arithmetic layer | Promotes an exact clean-block certificate into the LCU arithmetic interface. |
| `BlockEncodingClassics.matrix_mul_congr_pointwise` | `BE.Arithmetic.Product` | GSLW product lemma | Shared product leaf after embedded clean blocks are extracted. |
| `BlockEncodingClassics.productCleanBlockCertificate` | `BE.Arithmetic.Product`, `BE.LCU.PrepareSelect` | GSLW product lemma; LCU composition | Composes exact clean-block certificates at the extracted matrix level. |
| `BlockEncodingClassics.productExactCleanBlockCertificate` | `BE.Arithmetic.Product`, `BE.LCU.PrepareSelect` | GSLW product lemma; LCU composition | Bridges exact clean-block packages into product arithmetic. |
| `BlockEncodingClassics.tensorResourceCost` | `BE.Arithmetic.Tensor`, `BE.Tensor.PassiveRegister` | tensor/parallel composition patterns | Tracks parallel resource score. |
| `BlockEncodingClassics.productResourceCost` | `BE.Arithmetic.Product` | product/composition patterns | Tracks sequential resource score. |
| `BlockEncodingClassics.HermitianDilationContract` | `BE.HermitianDilation`, `BE.QSVT.ConsumerContract` | Hermitian dilation before QSVT/QSP consumers | Names the dilation target and prevents hidden Hermitian assumptions. |
| `BlockEncodingClassics.QSVTConsumerContract` | `BE.QSVT.ConsumerContract` | GSLW, Low--Chuang, QSVT guide, Grand Unification | Forces QSVT to consume a proved block encoding. |
| `BlockEncodingClassics.exactAsZeroErrorApproxCleanBlock` | exact-to-approximate ABEIS policy | approximate BE definition | Reuses exact certificates as epsilon-zero incumbents. |

## Shared Subleaf Structure

```text
finite image theorem
  -> permutation clean-block entry
  -> product-register entry bridge when the ancilla is explicit
  -> exact clean-block certificate
  -> one-sparse / sparse-column finite-sum leaves
  -> product / tensor / LCU composition
  -> Hermitian / Chebyshev / QSVT consumer contract
  -> exact-as-zero-error approximate incumbent
```

Sparse-access and density/purification constructions should enter this network
by proving their own entrywise clean-block equality, then packaging it as
`ExactCleanBlock` or `LCUCertificate`.

## Edge Contract Ledger

The network has typed edges.  A downstream card may use an upstream node only
for the payload that edge actually proves.

| Edge | Payload carried forward | What it does not prove |
| --- | --- | --- |
| finite image theorem -> permutation clean block | entry formula `U(clean row, clean col)` for a permutation matrix | hardware gate decomposition or optimality |
| clean entry equality -> `ExactCleanBlock` | pointwise clean-block equality with the target matrix | unitarity, unless supplied separately by a permutation/unitary theorem |
| `ExactCleanBlock` -> `LCUCertificate` | extracted clean matrix equality for arithmetic composition | PREPARE/SELECT state-preparation semantics |
| sparse column expression -> sparse certificate | slot-sum clean-entry formula plus task-supplied collapse proof | uniqueness/support collapse unless proved for the task |
| row-column double delta -> sparse certificate | source/target inner-product expression | row/column oracle correctness unless supplied |
| value-to-amplitude -> diagonal/sparse route | cleanup and amplitude-entry equality | a free oracle; the value oracle and uncompute must be explicit |
| product/LCU arithmetic -> downstream certificate | matrix-level equality after component blocks are certified | new circuit depth or gate count unless resource proof is attached |
| exact certificate -> zero-error approximate incumbent | epsilon-zero approximation at the same semantic tier | relaxed-epsilon improvement or norm theorem beyond the exact predicate |
| exact/approx BE -> QSVT consumer | proved input block encoding and stated polynomial side conditions | construction of the original data-loading oracle |

For this reason ABEIS distinguishes four certificate layers:

1. clean-entry or clean-block equality;
2. unitarity/permutation/inverse proof;
3. circuit realization and gate-matrix alignment;
4. resource score and executable export.

`ExactCleanBlock` is layer 1.  It is intentionally reusable, but it is not by
itself a full block-encoding certificate.  A task may advertise a complete
block encoding only after it also closes the required unitarity, circuit, and
resource leaves for its semantic tier.

## Current Cross-Links

- The transfer-operator case uses the same leaf as any future matrix-unit or
  partial-reset oracle: `cleanBlockBy_permMatrix_entry`.
- LCU, sparse-access, and structured-matrix papers all eventually need product
  arithmetic; their common compiled leaf is `matrix_mul_congr_pointwise`.
- QSVT papers should not be opened as first-route construction tools.  They
  attach after an exact or approximate block encoding has become a certificate.
- Approximate search should inherit exact champions through
  `exactAsZeroErrorApproxCleanBlock` before trying epsilon-relaxed candidates.

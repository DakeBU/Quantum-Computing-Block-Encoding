# Block-Encoding Proof Network

This file links the literature memory cards to compiled Lean leaves.  It is the
first ABEIS "intuition memory" graph for block-encoding construction: agents
should reuse these nodes instead of re-deriving the same proof shape.

## Compiled Lean Leaf Nodes

| Lean declaration | Memory cards | Literature sources | Role |
| --- | --- | --- | --- |
| `BlockEncodingClassics.cleanBlockBy_permMatrix_entry` | `BE.PermMatrix.CleanBlock`, `BE.PartialPermutation.MatrixUnitTensorId` | finite permutation completions; matrix-unit block encodings | Converts a finite reversible image predicate into a clean-block entry. |
| `BlockEncodingClassics.cleanBlockBy_permMatrix_eq_target_of_entry` | `BE.PermMatrix.CleanBlock`, `BE.PartialPermutation.MatrixUnitTensorId` | same as above | Turns entrywise finite-image verification into exact matrix equality. |
| `BlockEncodingClassics.partialPermutationCertificate` | `BE.PartialPermutation.MatrixUnitTensorId` | current transfer-operator case; partial-isometry completions | Packages a partial permutation target as an exact clean-block certificate. |
| `BlockEncodingClassics.oneTermLCU_cleanBlock` | `BE.LCU.PrepareSelect` | Childs--Wiebe LCU; Berry--Childs--Cleve--Kothari--Somma; GSLW | Degenerate LCU base case used to normalize proof DAGs. |
| `BlockEncodingClassics.LCUCertificate` | `BE.LCU.PrepareSelect`, `BE.Arithmetic.Product`, `BE.QSVT.ConsumerContract` | Childs--Wiebe; GSLW | Proof-carrying clean-block abstraction for finite sums. |
| `BlockEncodingClassics.matrix_mul_congr_pointwise` | `BE.Arithmetic.Product` | GSLW product lemma | Shared product leaf after embedded clean blocks are extracted. |
| `BlockEncodingClassics.productCleanBlockCertificate` | `BE.Arithmetic.Product`, `BE.LCU.PrepareSelect` | GSLW product lemma; LCU composition | Composes exact clean-block certificates at the extracted matrix level. |
| `BlockEncodingClassics.tensorResourceCost` | `BE.Arithmetic.Tensor`, `BE.Tensor.PassiveRegister` | tensor/parallel composition patterns | Tracks parallel resource score. |
| `BlockEncodingClassics.productResourceCost` | `BE.Arithmetic.Product` | product/composition patterns | Tracks sequential resource score. |
| `BlockEncodingClassics.HermitianDilationContract` | `BE.HermitianDilation`, `BE.QSVT.ConsumerContract` | Hermitian dilation before QSVT/QSP consumers | Names the dilation target and prevents hidden Hermitian assumptions. |
| `BlockEncodingClassics.QSVTConsumerContract` | `BE.QSVT.ConsumerContract` | GSLW, Low--Chuang, QSVT guide, Grand Unification | Forces QSVT to consume a proved block encoding. |
| `BlockEncodingClassics.exactAsZeroErrorApproxCleanBlock` | exact-to-approximate ABEIS policy | approximate BE definition | Reuses exact certificates as epsilon-zero incumbents. |

## Shared Subleaf Structure

```text
finite image theorem
  -> permutation clean-block entry
  -> exact clean-block certificate
  -> product / tensor / LCU composition
  -> downstream QSVT consumer contract
  -> exact-as-zero-error approximate incumbent
```

Sparse-access and density/purification constructions should enter this network
by proving their own entrywise clean-block equality, then packaging it as
`ExactCleanBlock` or `LCUCertificate`.

## Current Cross-Links

- The transfer-operator case uses the same leaf as any future matrix-unit or
  partial-reset oracle: `cleanBlockBy_permMatrix_entry`.
- LCU, sparse-access, and structured-matrix papers all eventually need product
  arithmetic; their common compiled leaf is `matrix_mul_congr_pointwise`.
- QSVT papers should not be opened as first-route construction tools.  They
  attach after an exact or approximate block encoding has become a certificate.
- Approximate search should inherit exact champions through
  `exactAsZeroErrorApproxCleanBlock` before trying epsilon-relaxed candidates.

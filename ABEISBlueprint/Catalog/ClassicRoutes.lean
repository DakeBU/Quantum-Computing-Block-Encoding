import QuantumBlockEncoding
import Verso
import VersoManual
import VersoBlueprint

open Verso.Genre
open Verso.Genre.Manual
open Informal

set_option linter.hashCommand false
set_option linter.style.longLine false
set_option verso.blueprint.externalCode.strictResolve true

#doc (Manual) "Declaration catalog: ClassicRoutes" =>
%%%
file := "catalog-classic-routes"
%%%

This chapter is generated from the Lean source. Every node denotes one explicit public
declaration, and every Lean link is checked during the Blueprint build. Definitions appear
in source order before later results whenever the source module does so.

# QuantumBlockEncoding/BlockEncodingClassics.lean

84 explicit public declarations, in source order.

:::definition "QuantumBlockEncoding.BlockEncodingClassics.permMatrix" (lean := "QuantumBlockEncoding.BlockEncodingClassics.permMatrix")
Source documentation: `Permutation-matrix entries for a finite basis map.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:19](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L19).
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.columnInner" (lean := "QuantumBlockEncoding.BlockEncodingClassics.columnInner")
Source documentation: `Column inner products for rational matrix-level orthogonality checks.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:23](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L23).
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.rowInner" (lean := "QuantumBlockEncoding.BlockEncodingClassics.rowInner")
Source documentation: `Row inner products for rational matrix-level orthogonality checks.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:27](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L27).
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.IsRationalOrthogonal" (lean := "QuantumBlockEncoding.BlockEncodingClassics.IsRationalOrthogonal")
Source documentation: `Rational orthogonality predicate for real-valued finite matrix backends: 'U^T U = I' and 'U U^T = I', expressed entrywise.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:34](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L34).
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.cleanBlockBy" (lean := "QuantumBlockEncoding.BlockEncodingClassics.cleanBlockBy")
Source documentation: `Clean block induced by an embedding of the system basis into a larger basis.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:39](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L39).
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.productIndex" (lean := "QuantumBlockEncoding.BlockEncodingClassics.productIndex")
Source documentation: `Canonical product-register embedding. If the full Hilbert basis is represented as 'ancilla × system', this maps '(a, s)' to the flattened index 'a * system + s'.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:48](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L48).
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.cleanBlockProduct" (lean := "QuantumBlockEncoding.BlockEncodingClassics.cleanBlockProduct")
Source documentation: `Clean block for a flattened 'ancilla × system' matrix.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:60](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L60).
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.cleanBlockBy_permMatrix_entry" (lean := "QuantumBlockEncoding.BlockEncodingClassics.cleanBlockBy_permMatrix_entry")
Source documentation: `Core 'BE.PermMatrix.CleanBlock' leaf: the clean block of a permutation matrix is just the finite image predicate restricted to clean embedded rows and columns.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:69](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L69).
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.cleanBlockProduct_permMatrix_entry" (lean := "QuantumBlockEncoding.BlockEncodingClassics.cleanBlockProduct_permMatrix_entry")
Source documentation: `Product-register version of 'cleanBlockBy_permMatrix_entry'. This is the standard entrywise bridge for block encodings whose clean ancilla is explicitly one register of a flattened product basis.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:81](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L81).
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.cleanBlockBy_permMatrix_eq_target_of_entry" (lean := "QuantumBlockEncoding.BlockEncodingClassics.cleanBlockBy_permMatrix_eq_target_of_entry")
Source documentation: `Entrywise bridge from a finite image calculation to an exact clean block. This is the leaf that converts a successful finite reversible construction into the block-entry theorem lower agents usually need.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:93](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L93).
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.cleanBlockProduct_eq_target_of_entry" (lean := "QuantumBlockEncoding.BlockEncodingClassics.cleanBlockProduct_eq_target_of_entry")
Source documentation: `Pointwise extension principle for product-register clean blocks.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:104](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L104).
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.kroneckerRat" (lean := "QuantumBlockEncoding.BlockEncodingClassics.kroneckerRat")
Source documentation: `Kronecker delta over the project-local rational matrix backend.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:116](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L116).
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.oneSparseMatrix" (lean := "QuantumBlockEncoding.BlockEncodingClassics.oneSparseMatrix")
Source documentation: `Column one-sparse matrix with support map 'c': column 'j' has its possible nonzero entry at row 'c j', with amplitude 'amp j'.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:123](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L123).
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.oneSparseMatrix_entry_if" (lean := "QuantumBlockEncoding.BlockEncodingClassics.oneSparseMatrix_entry_if")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:127](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L127).
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.oneSparse_from_support" (lean := "QuantumBlockEncoding.BlockEncodingClassics.oneSparse_from_support")
Source documentation: `One-sparse reconstruction leaf. If a target matrix is supported only at 'row = c col', then its support map and column amplitudes reconstruct it entrywise.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:139](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L139).
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.OneSparseCertificate" (lean := "QuantumBlockEncoding.BlockEncodingClassics.OneSparseCertificate")
Source documentation: `Proof-carrying one-sparse certificate. This is the exact finite leaf behind the textbook one-sparse block-encoding route after the amplitude and location oracles have been reduced to a support map.`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:155](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L155).
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.OneSparseCertificate.cleanBlock" (lean := "QuantumBlockEncoding.BlockEncodingClassics.OneSparseCertificate.cleanBlock")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this def.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:163](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L163).
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.OneSparseCertificate.correct" (lean := "QuantumBlockEncoding.BlockEncodingClassics.OneSparseCertificate.correct")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:166](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L166).
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.sparseColumnCleanEntry" (lean := "QuantumBlockEncoding.BlockEncodingClassics.sparseColumnCleanEntry")
Source documentation: `Column sparse clean-entry expression: a finite sum over slot indices of value oracle entries times location deltas. This is the entrywise target for Lin-style sparse column proofs before a task attaches its uniqueness lemmas.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:177](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L177).
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.permMatrix_columnInner_of_injective" (lean := "QuantumBlockEncoding.BlockEncodingClassics.permMatrix_columnInner_of_injective")
Source documentation: `Column Gram entries of a permutation matrix collapse by injectivity.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:283](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L283).
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.permMatrix_rowInner_of_bijective" (lean := "QuantumBlockEncoding.BlockEncodingClassics.permMatrix_rowInner_of_bijective")
Source documentation: `Row Gram entries of a permutation matrix collapse by bijectivity.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:330](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L330).
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.permMatrix_isRationalOrthogonal_of_bijective" (lean := "QuantumBlockEncoding.BlockEncodingClassics.permMatrix_isRationalOrthogonal_of_bijective")
Source documentation: `A bijective finite image induces a rational orthogonal permutation matrix. This is the reusable bridge from finite permutation certificates to the matrix-level unitarity proxy used by the exploratory block-encoding tasks.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:389](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L389).
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.sparseColumnCleanEntry_no_hit" (lean := "QuantumBlockEncoding.BlockEncodingClassics.sparseColumnCleanEntry_no_hit")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:396](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L396).
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.sparseColumnCleanEntry_unique_slot" (lean := "QuantumBlockEncoding.BlockEncodingClassics.sparseColumnCleanEntry_unique_slot")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:409](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L409).
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.rowColumnSparseDeltaEntry" (lean := "QuantumBlockEncoding.BlockEncodingClassics.rowColumnSparseDeltaEntry")
Source documentation: `General row/column sparse delta expression. A paper-specific route must prove that row-location and column-location uniqueness collapse this finite double sum to the target entry divided by the sparsity normalizer.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:434](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L434).
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.SparseColumnCertificate" (lean := "QuantumBlockEncoding.BlockEncodingClassics.SparseColumnCertificate")
Source documentation: `Proof-carrying sparse-column contract. The contract is not a theorem by itself; it records the exact clean-entry theorem a paper-specific lower agent must supply.`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:456](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L456).
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.SparseColumnCertificate.correct" (lean := "QuantumBlockEncoding.BlockEncodingClassics.SparseColumnCertificate.correct")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:466](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L466).
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.RowColumnSparseCertificate" (lean := "QuantumBlockEncoding.BlockEncodingClassics.RowColumnSparseCertificate")
Source documentation: `Proof-carrying row/column sparse contract for the general sparse route.`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:475](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L475).
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.RowColumnSparseCertificate.correct" (lean := "QuantumBlockEncoding.BlockEncodingClassics.RowColumnSparseCertificate.correct")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:486](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L486).
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.ValueToAmplitudeContract" (lean := "QuantumBlockEncoding.BlockEncodingClassics.ValueToAmplitudeContract")
Source documentation: `Value-to-amplitude oracle contract. A task may use this only after it supplies both cleanup and amplitude-entry proofs; the record cannot close a proof by itself.`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:498](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L498).
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.ValueToAmplitudeContract.correct" (lean := "QuantumBlockEncoding.BlockEncodingClassics.ValueToAmplitudeContract.correct")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:509](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L509).
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.IsSymmetric" (lean := "QuantumBlockEncoding.BlockEncodingClassics.IsSymmetric")
Source documentation: `Symmetric matrix predicate for the rational backend.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:516](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L516).
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.cleanBlockBy_symmetric_of_symmetric" (lean := "QuantumBlockEncoding.BlockEncodingClassics.cleanBlockBy_symmetric_of_symmetric")
Source documentation: `A symmetric full matrix has a symmetric clean block under any embedding.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:520](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L520).
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.fin2Zero" (lean := "QuantumBlockEncoding.BlockEncodingClassics.fin2Zero")
Source documentation: `Two-by-two scalar dilation block. Unitarity requires a separate norm proof.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:528](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L528).
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.fin2One" (lean := "QuantumBlockEncoding.BlockEncodingClassics.fin2One")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this def.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:530](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L530).
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.scalarDilation" (lean := "QuantumBlockEncoding.BlockEncodingClassics.scalarDilation")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this def.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:532](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L532).
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.scalarDilation_cleanEntry" (lean := "QuantumBlockEncoding.BlockEncodingClassics.scalarDilation_cleanEntry")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:539](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L539).
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.scalarDilation_offdiag01" (lean := "QuantumBlockEncoding.BlockEncodingClassics.scalarDilation_offdiag01")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:543](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L543).
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.scalarDilation_offdiag10" (lean := "QuantumBlockEncoding.BlockEncodingClassics.scalarDilation_offdiag10")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:547](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L547).
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.scalarDilation_diag11" (lean := "QuantumBlockEncoding.BlockEncodingClassics.scalarDilation_diag11")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:551](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L551).
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.scalarDilationRowDot" (lean := "QuantumBlockEncoding.BlockEncodingClassics.scalarDilationRowDot")
Source documentation: `Two-entry row dot product for the scalar dilation block.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:556](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L556).
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.scalarDilation_row0_normSq" (lean := "QuantumBlockEncoding.BlockEncodingClassics.scalarDilation_row0_normSq")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:560](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L560).
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.scalarDilation_row1_normSq" (lean := "QuantumBlockEncoding.BlockEncodingClassics.scalarDilation_row1_normSq")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:564](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L564).
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.scalarDilation_row0_unit_norm_of" (lean := "QuantumBlockEncoding.BlockEncodingClassics.scalarDilation_row0_unit_norm_of")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:573](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L573).
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.scalarDilation_row1_unit_norm_of" (lean := "QuantumBlockEncoding.BlockEncodingClassics.scalarDilation_row1_unit_norm_of")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:578](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L578).
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.scalarDilation_rows01_orthogonal" (lean := "QuantumBlockEncoding.BlockEncodingClassics.scalarDilation_rows01_orthogonal")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:583](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L583).
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.scalarDilation_rows10_orthogonal" (lean := "QuantumBlockEncoding.BlockEncodingClassics.scalarDilation_rows10_orthogonal")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:590](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L590).
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.chebyshevT" (lean := "QuantumBlockEncoding.BlockEncodingClassics.chebyshevT")
Source documentation: `Chebyshev polynomial values, kept as a small executable recurrence.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:598](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L598).
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.chebyshevT_zero" (lean := "QuantumBlockEncoding.BlockEncodingClassics.chebyshevT_zero")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:603](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L603).
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.chebyshevT_one" (lean := "QuantumBlockEncoding.BlockEncodingClassics.chebyshevT_one")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:605](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L605).
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.chebyshevT_two" (lean := "QuantumBlockEncoding.BlockEncodingClassics.chebyshevT_two")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:607](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L607).
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.chebyshevT_succ_succ" (lean := "QuantumBlockEncoding.BlockEncodingClassics.chebyshevT_succ_succ")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:609](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L609).
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.chebyshevT_three_recurrence" (lean := "QuantumBlockEncoding.BlockEncodingClassics.chebyshevT_three_recurrence")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:613](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L613).
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.chebyshevT_four_recurrence" (lean := "QuantumBlockEncoding.BlockEncodingClassics.chebyshevT_four_recurrence")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:616](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L616).
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.ExactCleanBlock" (lean := "QuantumBlockEncoding.BlockEncodingClassics.ExactCleanBlock")
Source documentation: `Proof-carrying exact clean-block package. This is smaller than the full operator-candidate record and is intended for reusable theorem arithmetic.`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:623](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L623).
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.ExactCleanBlock.clean" (lean := "QuantumBlockEncoding.BlockEncodingClassics.ExactCleanBlock.clean")
Source documentation: `The certified clean block associated with a proof-carrying package.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:632](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L632).
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.ExactCleanBlock.clean_eq_target" (lean := "QuantumBlockEncoding.BlockEncodingClassics.ExactCleanBlock.clean_eq_target")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:636](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L636).
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.QubitizationChebyshevContract" (lean := "QuantumBlockEncoding.BlockEncodingClassics.QubitizationChebyshevContract")
Source documentation: `Qubitization/Chebyshev proof-carrying contract. The full qubitization theorem will instantiate this after the two-dimensional invariant-subspace calculation is formalized.`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:648](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L648).
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.partialPermutationCertificate" (lean := "QuantumBlockEncoding.BlockEncodingClassics.partialPermutationCertificate")
Source documentation: `Abstract partial-permutation certificate. A concrete task supplies the embedding, finite image, target matrix, and image-entry theorem; this wrapper returns a reusable exact clean-block certificate.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:662](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L662).
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.oneTermLCU" (lean := "QuantumBlockEncoding.BlockEncodingClassics.oneTermLCU")
Source documentation: `One-term LCU leaf. It is mathematically trivial, but useful for proof-DAG normalization: when an LCU population collapses to one term, the selected block is just that term.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:679](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L679).
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.oneTermLCU_cleanBlock" (lean := "QuantumBlockEncoding.BlockEncodingClassics.oneTermLCU_cleanBlock")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:682](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L682).
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.matrixScale" (lean := "QuantumBlockEncoding.BlockEncodingClassics.matrixScale")
Source documentation: `Pointwise scalar multiplication for the project-local matrix backend.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:689](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L689).
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.matrixAdd" (lean := "QuantumBlockEncoding.BlockEncodingClassics.matrixAdd")
Source documentation: `Pointwise addition for the project-local matrix backend.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:693](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L693).
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.weightedSum2" (lean := "QuantumBlockEncoding.BlockEncodingClassics.weightedSum2")
Source documentation: `Two-term weighted sum, the finite clean-block algebra behind a 2-term LCU.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:697](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L697).
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.weightedSum2_entry" (lean := "QuantumBlockEncoding.BlockEncodingClassics.weightedSum2_entry")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:701](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L701).
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.weightedSum2_congr_pointwise" (lean := "QuantumBlockEncoding.BlockEncodingClassics.weightedSum2_congr_pointwise")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:707](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L707).
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.LCUCertificate" (lean := "QuantumBlockEncoding.BlockEncodingClassics.LCUCertificate")
Source documentation: `Proof-carrying LCU contract. Full PREPARE-SELECT algebra can later instantiate 'cleanBlock'; downstream arithmetic should only depend on the exposed 'blockProof'.`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:722](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L722).
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.LCUCertificate.correct" (lean := "QuantumBlockEncoding.BlockEncodingClassics.LCUCertificate.correct")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:731](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L731).
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.twoTermLCUCertificate" (lean := "QuantumBlockEncoding.BlockEncodingClassics.twoTermLCUCertificate")
Source documentation: `Two-term LCU arithmetic after both selected clean blocks have already been proved. Full PREPARE-SELECT-PREPARE dagger semantics should instantiate this leaf after proving the selected clean block equals the weighted sum.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:743](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L743).
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.twoTermLCUCertificate_cleanBlock_entry" (lean := "QuantumBlockEncoding.BlockEncodingClassics.twoTermLCUCertificate_cleanBlock_entry")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:754](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L754).
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.ExactCleanBlock.toLCUCertificate" (lean := "QuantumBlockEncoding.BlockEncodingClassics.ExactCleanBlock.toLCUCertificate")
Source documentation: `Promote an exact clean-block certificate to the LCU-style arithmetic layer.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:764](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L764).
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.matrix_mul_congr_pointwise" (lean := "QuantumBlockEncoding.BlockEncodingClassics.matrix_mul_congr_pointwise")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:792](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L792).
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.productCleanBlockCertificate" (lean := "QuantumBlockEncoding.BlockEncodingClassics.productCleanBlockCertificate")
Source documentation: `Exact product certificate for already-extracted clean blocks.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:800](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L800).
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.productExactCleanBlockCertificate" (lean := "QuantumBlockEncoding.BlockEncodingClassics.productExactCleanBlockCertificate")
Source documentation: `Product bridge for exact clean-block certificates via the arithmetic layer.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:811](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L811).
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.tensorResourceCost" (lean := "QuantumBlockEncoding.BlockEncodingClassics.tensorResourceCost")
Source documentation: `Tensor-style resource score: parallel depth is the maximum of two depths.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:819](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L819).
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.tensorResourceCost_gateCount" (lean := "QuantumBlockEncoding.BlockEncodingClassics.tensorResourceCost_gateCount")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:825](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L825).
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.tensorResourceCost_depth" (lean := "QuantumBlockEncoding.BlockEncodingClassics.tensorResourceCost_depth")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:828](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L828).
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.productResourceCost" (lean := "QuantumBlockEncoding.BlockEncodingClassics.productResourceCost")
Source documentation: `Product-style resource score: sequential depth adds.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:832](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L832).
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.productResourceCost_depth" (lean := "QuantumBlockEncoding.BlockEncodingClassics.productResourceCost_depth")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:838](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L838).
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.HermitianDilationContract" (lean := "QuantumBlockEncoding.BlockEncodingClassics.HermitianDilationContract")
Source documentation: `Hermitian-dilation target shape. The complete block-matrix construction will live in a richer matrix backend; the important reusable Lean leaf is that a non-Hermitian target is explicitly converted into a named downstream target, not silently treated as Hermitian.`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:847](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L847).
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.QSVTConsumerContract" (lean := "QuantumBlockEncoding.BlockEncodingClassics.QSVTConsumerContract")
Source documentation: `QSVT consumer contract. QSVT is deliberately downstream of a proved block encoding: this record cannot be built without an input block certificate.`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:857](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L857).
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.ZeroErrorApproxCleanBlock" (lean := "QuantumBlockEncoding.BlockEncodingClassics.ZeroErrorApproxCleanBlock")
Source documentation: `Zero-error approximate incumbent at the clean-block level.`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:866](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L866).
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.exactAsZeroErrorApproxCleanBlock" (lean := "QuantumBlockEncoding.BlockEncodingClassics.exactAsZeroErrorApproxCleanBlock")
Source documentation: `Any exact clean-block certificate can be used as a zero-error approximate incumbent in the adaptive exact-to-approximate ABEIS policy.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:877](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L877).
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.exactAsZeroErrorApproxCleanBlock_bound" (lean := "QuantumBlockEncoding.BlockEncodingClassics.exactAsZeroErrorApproxCleanBlock_bound")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:885](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L885).
:::

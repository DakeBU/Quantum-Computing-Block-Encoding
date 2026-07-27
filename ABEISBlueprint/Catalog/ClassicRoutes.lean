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

Reader orientation: Reusable permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes. Each card separates an accessible
reading cue from formal status, the source docstring, and the authoritative Lean panel.
The standalone Library Explorer adds full-text search and filters across every chapter.

# QuantumBlockEncoding/BlockEncodingClassics.lean

84 explicit public declarations, in source order.

:::definition "QuantumBlockEncoding.BlockEncodingClassics.permMatrix" (lean := "QuantumBlockEncoding.BlockEncodingClassics.permMatrix")
*Plain-English reading.* This definition gives the library's named construction or computation for “perm matrix”. Permutation-matrix entries for a finite basis map.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Reusable permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* Permutation-matrix entries for a finite basis map.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:19](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L19).
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.columnInner" (lean := "QuantumBlockEncoding.BlockEncodingClassics.columnInner")
*Plain-English reading.* This definition gives the library's named construction or computation for “column inner”. Column inner products for rational matrix-level orthogonality checks.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Reusable permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* Column inner products for rational matrix-level orthogonality checks.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:23](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L23).
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.rowInner" (lean := "QuantumBlockEncoding.BlockEncodingClassics.rowInner")
*Plain-English reading.* This definition gives the library's named construction or computation for “row inner”. Row inner products for rational matrix-level orthogonality checks.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Reusable permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* Row inner products for rational matrix-level orthogonality checks.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:27](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L27).
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.IsRationalOrthogonal" (lean := "QuantumBlockEncoding.BlockEncodingClassics.IsRationalOrthogonal")
*Plain-English reading.* This definition gives the library's named construction or computation for “is rational orthogonal”. Rational orthogonality predicate for real-valued finite matrix backends: 'U^T U = I' and 'U U^T = I', expressed entrywise.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Reusable permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* Rational orthogonality predicate for real-valued finite matrix backends: 'U^T U = I' and 'U U^T = I', expressed entrywise.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:34](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L34).
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.cleanBlockBy" (lean := "QuantumBlockEncoding.BlockEncodingClassics.cleanBlockBy")
*Plain-English reading.* This definition gives the library's named construction or computation for “clean block by”. Clean block induced by an embedding of the system basis into a larger basis.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Reusable permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* Clean block induced by an embedding of the system basis into a larger basis.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:39](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L39).
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.productIndex" (lean := "QuantumBlockEncoding.BlockEncodingClassics.productIndex")
*Plain-English reading.* This definition gives the library's named construction or computation for “product index”. Canonical product-register embedding.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Reusable permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* Canonical product-register embedding. If the full Hilbert basis is represented as 'ancilla × system', this maps '(a, s)' to the flattened index 'a \* system + s'.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:48](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L48).
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.cleanBlockProduct" (lean := "QuantumBlockEncoding.BlockEncodingClassics.cleanBlockProduct")
*Plain-English reading.* This definition gives the library's named construction or computation for “clean block product”. Clean block for a flattened 'ancilla × system' matrix.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Reusable permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* Clean block for a flattened 'ancilla × system' matrix.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:60](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L60).
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.cleanBlockBy_permMatrix_entry" (lean := "QuantumBlockEncoding.BlockEncodingClassics.cleanBlockBy_permMatrix_entry")
*Plain-English reading.* Lean checks the proposition indexed as “clean block by perm matrix entry”; the hypotheses and conclusion in the code panel fix its exact scope. Core 'BE.PermMatrix.CleanBlock' leaf: the clean block of a permutation matrix is just the finite image predicate restricted to clean embedded rows and columns.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* Core 'BE.PermMatrix.CleanBlock' leaf: the clean block of a permutation matrix is just the finite image predicate restricted to clean embedded rows and columns.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:69](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L69).
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.cleanBlockProduct_permMatrix_entry" (lean := "QuantumBlockEncoding.BlockEncodingClassics.cleanBlockProduct_permMatrix_entry")
*Plain-English reading.* Lean checks the proposition indexed as “clean block product perm matrix entry”; the hypotheses and conclusion in the code panel fix its exact scope. Product-register version of 'cleanBlockBy\_permMatrix\_entry'.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* Product-register version of 'cleanBlockBy\_permMatrix\_entry'. This is the standard entrywise bridge for block encodings whose clean ancilla is explicitly one register of a flattened product basis.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:81](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L81).
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.cleanBlockBy_permMatrix_eq_target_of_entry" (lean := "QuantumBlockEncoding.BlockEncodingClassics.cleanBlockBy_permMatrix_eq_target_of_entry")
*Plain-English reading.* Lean checks the proposition indexed as “clean block by perm matrix eq target of entry”; the hypotheses and conclusion in the code panel fix its exact scope. Entrywise bridge from a finite image calculation to an exact clean block.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* Entrywise bridge from a finite image calculation to an exact clean block. This is the leaf that converts a successful finite reversible construction into the block-entry theorem lower agents usually need.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:93](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L93).
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.cleanBlockProduct_eq_target_of_entry" (lean := "QuantumBlockEncoding.BlockEncodingClassics.cleanBlockProduct_eq_target_of_entry")
*Plain-English reading.* Lean checks the proposition indexed as “clean block product eq target of entry”; the hypotheses and conclusion in the code panel fix its exact scope. Pointwise extension principle for product-register clean blocks.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* Pointwise extension principle for product-register clean blocks.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:104](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L104).
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.kroneckerRat" (lean := "QuantumBlockEncoding.BlockEncodingClassics.kroneckerRat")
*Plain-English reading.* This definition gives the library's named construction or computation for “kronecker rat”. Kronecker delta over the project-local rational matrix backend.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Reusable permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* Kronecker delta over the project-local rational matrix backend.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:116](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L116).
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.oneSparseMatrix" (lean := "QuantumBlockEncoding.BlockEncodingClassics.oneSparseMatrix")
*Plain-English reading.* This definition gives the library's named construction or computation for “one sparse matrix”. Column one-sparse matrix with support map 'c': column 'j' has its possible nonzero entry at row 'c j', with amplitude 'amp j'.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Reusable permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* Column one-sparse matrix with support map 'c': column 'j' has its possible nonzero entry at row 'c j', with amplitude 'amp j'.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:123](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L123).
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.oneSparseMatrix_entry_if" (lean := "QuantumBlockEncoding.BlockEncodingClassics.oneSparseMatrix_entry_if")
*Plain-English reading.* Lean checks the proposition indexed as “one sparse matrix entry if”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:127](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L127).
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.oneSparse_from_support" (lean := "QuantumBlockEncoding.BlockEncodingClassics.oneSparse_from_support")
*Plain-English reading.* Lean checks the proposition indexed as “one sparse from support”; the hypotheses and conclusion in the code panel fix its exact scope. One-sparse reconstruction leaf.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* One-sparse reconstruction leaf. If a target matrix is supported only at 'row = c col', then its support map and column amplitudes reconstruct it entrywise.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:139](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L139).
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.OneSparseCertificate" (lean := "QuantumBlockEncoding.BlockEncodingClassics.OneSparseCertificate")
*Plain-English reading.* This record groups the data and proof fields needed for “one sparse certificate”. A proposition-valued field is a requirement until a constructor supplies it. Proof-carrying one-sparse certificate.

*Formal status.* Data contract in the default import surface; proposition-valued fields are obligations, not automatically established facts.

*Why it is in this chapter.* Reusable permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* Proof-carrying one-sparse certificate. This is the exact finite leaf behind the textbook one-sparse block-encoding route after the amplitude and location oracles have been reduced to a support map.

*Declaration kind.* structure.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:155](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L155).
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.OneSparseCertificate.cleanBlock" (lean := "QuantumBlockEncoding.BlockEncodingClassics.OneSparseCertificate.cleanBlock")
*Plain-English reading.* This definition gives the library's named construction or computation for “clean block”.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Reusable permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:163](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L163).
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.OneSparseCertificate.correct" (lean := "QuantumBlockEncoding.BlockEncodingClassics.OneSparseCertificate.correct")
*Plain-English reading.* Lean checks the proposition indexed as “correct”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:166](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L166).
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.sparseColumnCleanEntry" (lean := "QuantumBlockEncoding.BlockEncodingClassics.sparseColumnCleanEntry")
*Plain-English reading.* This definition gives the library's named construction or computation for “sparse column clean entry”. Column sparse clean-entry expression: a finite sum over slot indices of value oracle entries times location deltas.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Reusable permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* Column sparse clean-entry expression: a finite sum over slot indices of value oracle entries times location deltas. This is the entrywise target for Lin-style sparse column proofs before a task attaches its uniqueness lemmas.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:177](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L177).
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.permMatrix_columnInner_of_injective" (lean := "QuantumBlockEncoding.BlockEncodingClassics.permMatrix_columnInner_of_injective")
*Plain-English reading.* Lean checks the proposition indexed as “perm matrix column inner of injective”; the hypotheses and conclusion in the code panel fix its exact scope. Column Gram entries of a permutation matrix collapse by injectivity.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* Column Gram entries of a permutation matrix collapse by injectivity.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:283](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L283).
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.permMatrix_rowInner_of_bijective" (lean := "QuantumBlockEncoding.BlockEncodingClassics.permMatrix_rowInner_of_bijective")
*Plain-English reading.* Lean checks the proposition indexed as “perm matrix row inner of bijective”; the hypotheses and conclusion in the code panel fix its exact scope. Row Gram entries of a permutation matrix collapse by bijectivity.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* Row Gram entries of a permutation matrix collapse by bijectivity.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:330](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L330).
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.permMatrix_isRationalOrthogonal_of_bijective" (lean := "QuantumBlockEncoding.BlockEncodingClassics.permMatrix_isRationalOrthogonal_of_bijective")
*Plain-English reading.* Lean checks the proposition indexed as “perm matrix is rational orthogonal of bijective”; the hypotheses and conclusion in the code panel fix its exact scope. A bijective finite image induces a rational orthogonal permutation matrix.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* A bijective finite image induces a rational orthogonal permutation matrix. This is the reusable bridge from finite permutation certificates to the matrix-level unitarity proxy used by the exploratory block-encoding tasks.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:389](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L389).
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.sparseColumnCleanEntry_no_hit" (lean := "QuantumBlockEncoding.BlockEncodingClassics.sparseColumnCleanEntry_no_hit")
*Plain-English reading.* Lean checks the proposition indexed as “sparse column clean entry no hit”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:396](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L396).
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.sparseColumnCleanEntry_unique_slot" (lean := "QuantumBlockEncoding.BlockEncodingClassics.sparseColumnCleanEntry_unique_slot")
*Plain-English reading.* Lean checks the proposition indexed as “sparse column clean entry unique slot”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:409](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L409).
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.rowColumnSparseDeltaEntry" (lean := "QuantumBlockEncoding.BlockEncodingClassics.rowColumnSparseDeltaEntry")
*Plain-English reading.* This definition gives the library's named construction or computation for “row column sparse delta entry”. General row/column sparse delta expression.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Reusable permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* General row/column sparse delta expression. A paper-specific route must prove that row-location and column-location uniqueness collapse this finite double sum to the target entry divided by the sparsity normalizer.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:434](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L434).
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.SparseColumnCertificate" (lean := "QuantumBlockEncoding.BlockEncodingClassics.SparseColumnCertificate")
*Plain-English reading.* This record groups the data and proof fields needed for “sparse column certificate”. A proposition-valued field is a requirement until a constructor supplies it. Proof-carrying sparse-column contract.

*Formal status.* Data contract in the default import surface; proposition-valued fields are obligations, not automatically established facts.

*Why it is in this chapter.* Reusable permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* Proof-carrying sparse-column contract. The contract is not a theorem by itself; it records the exact clean-entry theorem a paper-specific lower agent must supply.

*Declaration kind.* structure.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:456](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L456).
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.SparseColumnCertificate.correct" (lean := "QuantumBlockEncoding.BlockEncodingClassics.SparseColumnCertificate.correct")
*Plain-English reading.* Lean checks the proposition indexed as “correct”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:466](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L466).
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.RowColumnSparseCertificate" (lean := "QuantumBlockEncoding.BlockEncodingClassics.RowColumnSparseCertificate")
*Plain-English reading.* This record groups the data and proof fields needed for “row column sparse certificate”. A proposition-valued field is a requirement until a constructor supplies it. Proof-carrying row/column sparse contract for the general sparse route.

*Formal status.* Data contract in the default import surface; proposition-valued fields are obligations, not automatically established facts.

*Why it is in this chapter.* Reusable permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* Proof-carrying row/column sparse contract for the general sparse route.

*Declaration kind.* structure.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:475](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L475).
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.RowColumnSparseCertificate.correct" (lean := "QuantumBlockEncoding.BlockEncodingClassics.RowColumnSparseCertificate.correct")
*Plain-English reading.* Lean checks the proposition indexed as “correct”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:486](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L486).
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.ValueToAmplitudeContract" (lean := "QuantumBlockEncoding.BlockEncodingClassics.ValueToAmplitudeContract")
*Plain-English reading.* This record groups the data and proof fields needed for “value to amplitude contract”. A proposition-valued field is a requirement until a constructor supplies it. Value-to-amplitude oracle contract.

*Formal status.* Data contract in the default import surface; proposition-valued fields are obligations, not automatically established facts.

*Why it is in this chapter.* Reusable permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* Value-to-amplitude oracle contract. A task may use this only after it supplies both cleanup and amplitude-entry proofs; the record cannot close a proof by itself.

*Declaration kind.* structure.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:498](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L498).
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.ValueToAmplitudeContract.correct" (lean := "QuantumBlockEncoding.BlockEncodingClassics.ValueToAmplitudeContract.correct")
*Plain-English reading.* Lean checks the proposition indexed as “correct”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:509](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L509).
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.IsSymmetric" (lean := "QuantumBlockEncoding.BlockEncodingClassics.IsSymmetric")
*Plain-English reading.* This definition gives the library's named construction or computation for “is symmetric”. Symmetric matrix predicate for the rational backend.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Reusable permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* Symmetric matrix predicate for the rational backend.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:516](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L516).
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.cleanBlockBy_symmetric_of_symmetric" (lean := "QuantumBlockEncoding.BlockEncodingClassics.cleanBlockBy_symmetric_of_symmetric")
*Plain-English reading.* Lean checks the proposition indexed as “clean block by symmetric of symmetric”; the hypotheses and conclusion in the code panel fix its exact scope. A symmetric full matrix has a symmetric clean block under any embedding.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* A symmetric full matrix has a symmetric clean block under any embedding.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:520](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L520).
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.fin2Zero" (lean := "QuantumBlockEncoding.BlockEncodingClassics.fin2Zero")
*Plain-English reading.* This definition gives the library's named construction or computation for “fin 2 zero”. Two-by-two scalar dilation block.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Reusable permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* Two-by-two scalar dilation block. Unitarity requires a separate norm proof.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:528](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L528).
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.fin2One" (lean := "QuantumBlockEncoding.BlockEncodingClassics.fin2One")
*Plain-English reading.* This definition gives the library's named construction or computation for “fin 2 one”.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Reusable permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:530](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L530).
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.scalarDilation" (lean := "QuantumBlockEncoding.BlockEncodingClassics.scalarDilation")
*Plain-English reading.* This definition gives the library's named construction or computation for “scalar dilation”.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Reusable permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:532](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L532).
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.scalarDilation_cleanEntry" (lean := "QuantumBlockEncoding.BlockEncodingClassics.scalarDilation_cleanEntry")
*Plain-English reading.* Lean checks the proposition indexed as “scalar dilation clean entry”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:539](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L539).
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.scalarDilation_offdiag01" (lean := "QuantumBlockEncoding.BlockEncodingClassics.scalarDilation_offdiag01")
*Plain-English reading.* Lean checks the proposition indexed as “scalar dilation offdiag 01”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:543](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L543).
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.scalarDilation_offdiag10" (lean := "QuantumBlockEncoding.BlockEncodingClassics.scalarDilation_offdiag10")
*Plain-English reading.* Lean checks the proposition indexed as “scalar dilation offdiag 10”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:547](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L547).
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.scalarDilation_diag11" (lean := "QuantumBlockEncoding.BlockEncodingClassics.scalarDilation_diag11")
*Plain-English reading.* Lean checks the proposition indexed as “scalar dilation diag 11”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:551](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L551).
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.scalarDilationRowDot" (lean := "QuantumBlockEncoding.BlockEncodingClassics.scalarDilationRowDot")
*Plain-English reading.* This definition gives the library's named construction or computation for “scalar dilation row dot”. Two-entry row dot product for the scalar dilation block.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Reusable permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* Two-entry row dot product for the scalar dilation block.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:556](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L556).
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.scalarDilation_row0_normSq" (lean := "QuantumBlockEncoding.BlockEncodingClassics.scalarDilation_row0_normSq")
*Plain-English reading.* Lean checks the proposition indexed as “scalar dilation row 0 norm sq”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:560](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L560).
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.scalarDilation_row1_normSq" (lean := "QuantumBlockEncoding.BlockEncodingClassics.scalarDilation_row1_normSq")
*Plain-English reading.* Lean checks the proposition indexed as “scalar dilation row 1 norm sq”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:564](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L564).
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.scalarDilation_row0_unit_norm_of" (lean := "QuantumBlockEncoding.BlockEncodingClassics.scalarDilation_row0_unit_norm_of")
*Plain-English reading.* Lean checks the proposition indexed as “scalar dilation row 0 unit norm of”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:573](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L573).
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.scalarDilation_row1_unit_norm_of" (lean := "QuantumBlockEncoding.BlockEncodingClassics.scalarDilation_row1_unit_norm_of")
*Plain-English reading.* Lean checks the proposition indexed as “scalar dilation row 1 unit norm of”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:578](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L578).
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.scalarDilation_rows01_orthogonal" (lean := "QuantumBlockEncoding.BlockEncodingClassics.scalarDilation_rows01_orthogonal")
*Plain-English reading.* Lean checks the proposition indexed as “scalar dilation rows 01 orthogonal”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:583](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L583).
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.scalarDilation_rows10_orthogonal" (lean := "QuantumBlockEncoding.BlockEncodingClassics.scalarDilation_rows10_orthogonal")
*Plain-English reading.* Lean checks the proposition indexed as “scalar dilation rows 10 orthogonal”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:590](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L590).
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.chebyshevT" (lean := "QuantumBlockEncoding.BlockEncodingClassics.chebyshevT")
*Plain-English reading.* This definition gives the library's named construction or computation for “chebyshev t”. Chebyshev polynomial values, kept as a small executable recurrence.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Reusable permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* Chebyshev polynomial values, kept as a small executable recurrence.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:598](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L598).
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.chebyshevT_zero" (lean := "QuantumBlockEncoding.BlockEncodingClassics.chebyshevT_zero")
*Plain-English reading.* Lean checks the proposition indexed as “chebyshev t zero”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:603](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L603).
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.chebyshevT_one" (lean := "QuantumBlockEncoding.BlockEncodingClassics.chebyshevT_one")
*Plain-English reading.* Lean checks the proposition indexed as “chebyshev t one”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:605](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L605).
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.chebyshevT_two" (lean := "QuantumBlockEncoding.BlockEncodingClassics.chebyshevT_two")
*Plain-English reading.* Lean checks the proposition indexed as “chebyshev t two”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:607](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L607).
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.chebyshevT_succ_succ" (lean := "QuantumBlockEncoding.BlockEncodingClassics.chebyshevT_succ_succ")
*Plain-English reading.* Lean checks the proposition indexed as “chebyshev t succ succ”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:609](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L609).
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.chebyshevT_three_recurrence" (lean := "QuantumBlockEncoding.BlockEncodingClassics.chebyshevT_three_recurrence")
*Plain-English reading.* Lean checks the proposition indexed as “chebyshev t three recurrence”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:613](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L613).
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.chebyshevT_four_recurrence" (lean := "QuantumBlockEncoding.BlockEncodingClassics.chebyshevT_four_recurrence")
*Plain-English reading.* Lean checks the proposition indexed as “chebyshev t four recurrence”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:616](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L616).
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.ExactCleanBlock" (lean := "QuantumBlockEncoding.BlockEncodingClassics.ExactCleanBlock")
*Plain-English reading.* This record groups the data and proof fields needed for “exact clean block”. A proposition-valued field is a requirement until a constructor supplies it. Proof-carrying exact clean-block package.

*Formal status.* Data contract in the default import surface; proposition-valued fields are obligations, not automatically established facts.

*Why it is in this chapter.* Reusable permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* Proof-carrying exact clean-block package. This is smaller than the full operator-candidate record and is intended for reusable theorem arithmetic.

*Declaration kind.* structure.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:623](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L623).
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.ExactCleanBlock.clean" (lean := "QuantumBlockEncoding.BlockEncodingClassics.ExactCleanBlock.clean")
*Plain-English reading.* This definition gives the library's named construction or computation for “clean”. The certified clean block associated with a proof-carrying package.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Reusable permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* The certified clean block associated with a proof-carrying package.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:632](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L632).
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.ExactCleanBlock.clean_eq_target" (lean := "QuantumBlockEncoding.BlockEncodingClassics.ExactCleanBlock.clean_eq_target")
*Plain-English reading.* Lean checks the proposition indexed as “clean eq target”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:636](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L636).
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.QubitizationChebyshevContract" (lean := "QuantumBlockEncoding.BlockEncodingClassics.QubitizationChebyshevContract")
*Plain-English reading.* This record groups the data and proof fields needed for “qubitization chebyshev contract”. A proposition-valued field is a requirement until a constructor supplies it. Qubitization/Chebyshev proof-carrying contract.

*Formal status.* Data contract in the default import surface; proposition-valued fields are obligations, not automatically established facts.

*Why it is in this chapter.* Reusable permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* Qubitization/Chebyshev proof-carrying contract. The full qubitization theorem will instantiate this after the two-dimensional invariant-subspace calculation is formalized.

*Declaration kind.* structure.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:648](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L648).
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.partialPermutationCertificate" (lean := "QuantumBlockEncoding.BlockEncodingClassics.partialPermutationCertificate")
*Plain-English reading.* This definition gives the library's named construction or computation for “partial permutation certificate”. Abstract partial-permutation certificate.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Reusable permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* Abstract partial-permutation certificate. A concrete task supplies the embedding, finite image, target matrix, and image-entry theorem; this wrapper returns a reusable exact clean-block certificate.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:662](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L662).
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.oneTermLCU" (lean := "QuantumBlockEncoding.BlockEncodingClassics.oneTermLCU")
*Plain-English reading.* This definition gives the library's named construction or computation for “one term lcu”. One-term LCU leaf.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Reusable permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* One-term LCU leaf. It is mathematically trivial, but useful for proof-DAG normalization: when an LCU population collapses to one term, the selected block is just that term.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:679](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L679).
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.oneTermLCU_cleanBlock" (lean := "QuantumBlockEncoding.BlockEncodingClassics.oneTermLCU_cleanBlock")
*Plain-English reading.* Lean checks the proposition indexed as “one term lcu clean block”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:682](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L682).
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.matrixScale" (lean := "QuantumBlockEncoding.BlockEncodingClassics.matrixScale")
*Plain-English reading.* This definition gives the library's named construction or computation for “matrix scale”. Pointwise scalar multiplication for the project-local matrix backend.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Reusable permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* Pointwise scalar multiplication for the project-local matrix backend.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:689](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L689).
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.matrixAdd" (lean := "QuantumBlockEncoding.BlockEncodingClassics.matrixAdd")
*Plain-English reading.* This definition gives the library's named construction or computation for “matrix add”. Pointwise addition for the project-local matrix backend.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Reusable permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* Pointwise addition for the project-local matrix backend.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:693](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L693).
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.weightedSum2" (lean := "QuantumBlockEncoding.BlockEncodingClassics.weightedSum2")
*Plain-English reading.* This definition gives the library's named construction or computation for “weighted sum 2”. Two-term weighted sum, the finite clean-block algebra behind a 2-term LCU.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Reusable permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* Two-term weighted sum, the finite clean-block algebra behind a 2-term LCU.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:697](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L697).
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.weightedSum2_entry" (lean := "QuantumBlockEncoding.BlockEncodingClassics.weightedSum2_entry")
*Plain-English reading.* Lean checks the proposition indexed as “weighted sum 2 entry”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:701](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L701).
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.weightedSum2_congr_pointwise" (lean := "QuantumBlockEncoding.BlockEncodingClassics.weightedSum2_congr_pointwise")
*Plain-English reading.* Lean checks the proposition indexed as “weighted sum 2 congr pointwise”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:707](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L707).
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.LCUCertificate" (lean := "QuantumBlockEncoding.BlockEncodingClassics.LCUCertificate")
*Plain-English reading.* This record groups the data and proof fields needed for “lcu certificate”. A proposition-valued field is a requirement until a constructor supplies it. Proof-carrying LCU contract.

*Formal status.* Data contract in the default import surface; proposition-valued fields are obligations, not automatically established facts.

*Why it is in this chapter.* Reusable permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* Proof-carrying LCU contract. Full PREPARE-SELECT algebra can later instantiate 'cleanBlock'; downstream arithmetic should only depend on the exposed 'blockProof'.

*Declaration kind.* structure.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:722](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L722).
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.LCUCertificate.correct" (lean := "QuantumBlockEncoding.BlockEncodingClassics.LCUCertificate.correct")
*Plain-English reading.* Lean checks the proposition indexed as “correct”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:731](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L731).
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.twoTermLCUCertificate" (lean := "QuantumBlockEncoding.BlockEncodingClassics.twoTermLCUCertificate")
*Plain-English reading.* This definition gives the library's named construction or computation for “two term lcu certificate”. Two-term LCU arithmetic after both selected clean blocks have already been proved.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Reusable permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* Two-term LCU arithmetic after both selected clean blocks have already been proved. Full PREPARE-SELECT-PREPARE dagger semantics should instantiate this leaf after proving the selected clean block equals the weighted sum.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:743](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L743).
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.twoTermLCUCertificate_cleanBlock_entry" (lean := "QuantumBlockEncoding.BlockEncodingClassics.twoTermLCUCertificate_cleanBlock_entry")
*Plain-English reading.* Lean checks the proposition indexed as “two term lcu certificate clean block entry”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:754](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L754).
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.ExactCleanBlock.toLCUCertificate" (lean := "QuantumBlockEncoding.BlockEncodingClassics.ExactCleanBlock.toLCUCertificate")
*Plain-English reading.* This definition gives the library's named construction or computation for “to lcu certificate”. Promote an exact clean-block certificate to the LCU-style arithmetic layer.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Reusable permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* Promote an exact clean-block certificate to the LCU-style arithmetic layer.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:764](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L764).
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.matrix_mul_congr_pointwise" (lean := "QuantumBlockEncoding.BlockEncodingClassics.matrix_mul_congr_pointwise")
*Plain-English reading.* Lean checks the proposition indexed as “matrix mul congr pointwise”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:792](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L792).
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.productCleanBlockCertificate" (lean := "QuantumBlockEncoding.BlockEncodingClassics.productCleanBlockCertificate")
*Plain-English reading.* This definition gives the library's named construction or computation for “product clean block certificate”. Exact product certificate for already-extracted clean blocks.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Reusable permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* Exact product certificate for already-extracted clean blocks.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:800](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L800).
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.productExactCleanBlockCertificate" (lean := "QuantumBlockEncoding.BlockEncodingClassics.productExactCleanBlockCertificate")
*Plain-English reading.* This definition gives the library's named construction or computation for “product exact clean block certificate”. Product bridge for exact clean-block certificates via the arithmetic layer.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Reusable permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* Product bridge for exact clean-block certificates via the arithmetic layer.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:811](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L811).
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.tensorResourceCost" (lean := "QuantumBlockEncoding.BlockEncodingClassics.tensorResourceCost")
*Plain-English reading.* This definition gives the library's named construction or computation for “tensor resource cost”. Tensor-style resource score: parallel depth is the maximum of two depths.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Reusable permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* Tensor-style resource score: parallel depth is the maximum of two depths.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:819](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L819).
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.tensorResourceCost_gateCount" (lean := "QuantumBlockEncoding.BlockEncodingClassics.tensorResourceCost_gateCount")
*Plain-English reading.* Lean checks the proposition indexed as “tensor resource cost gate count”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:825](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L825).
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.tensorResourceCost_depth" (lean := "QuantumBlockEncoding.BlockEncodingClassics.tensorResourceCost_depth")
*Plain-English reading.* Lean checks the proposition indexed as “tensor resource cost depth”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:828](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L828).
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.productResourceCost" (lean := "QuantumBlockEncoding.BlockEncodingClassics.productResourceCost")
*Plain-English reading.* This definition gives the library's named construction or computation for “product resource cost”. Product-style resource score: sequential depth adds.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Reusable permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* Product-style resource score: sequential depth adds.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:832](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L832).
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.productResourceCost_depth" (lean := "QuantumBlockEncoding.BlockEncodingClassics.productResourceCost_depth")
*Plain-English reading.* Lean checks the proposition indexed as “product resource cost depth”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:838](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L838).
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.HermitianDilationContract" (lean := "QuantumBlockEncoding.BlockEncodingClassics.HermitianDilationContract")
*Plain-English reading.* This record groups the data and proof fields needed for “hermitian dilation contract”. A proposition-valued field is a requirement until a constructor supplies it. Hermitian-dilation target shape.

*Formal status.* Data contract in the default import surface; proposition-valued fields are obligations, not automatically established facts.

*Why it is in this chapter.* Reusable permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* Hermitian-dilation target shape. The complete block-matrix construction will live in a richer matrix backend; the important reusable Lean leaf is that a non-Hermitian target is explicitly converted into a named downstream target, not silently treated as Hermitian.

*Declaration kind.* structure.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:847](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L847).
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.QSVTConsumerContract" (lean := "QuantumBlockEncoding.BlockEncodingClassics.QSVTConsumerContract")
*Plain-English reading.* This record groups the data and proof fields needed for “qsvt consumer contract”. A proposition-valued field is a requirement until a constructor supplies it. QSVT consumer contract.

*Formal status.* Data contract in the default import surface; proposition-valued fields are obligations, not automatically established facts.

*Why it is in this chapter.* Reusable permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* QSVT consumer contract. QSVT is deliberately downstream of a proved block encoding: this record cannot be built without an input block certificate.

*Declaration kind.* structure.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:857](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L857).
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.ZeroErrorApproxCleanBlock" (lean := "QuantumBlockEncoding.BlockEncodingClassics.ZeroErrorApproxCleanBlock")
*Plain-English reading.* This record groups the data and proof fields needed for “zero error approx clean block”. A proposition-valued field is a requirement until a constructor supplies it. Zero-error approximate incumbent at the clean-block level.

*Formal status.* Data contract in the default import surface; proposition-valued fields are obligations, not automatically established facts.

*Why it is in this chapter.* Reusable permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* Zero-error approximate incumbent at the clean-block level.

*Declaration kind.* structure.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:866](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L866).
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.exactAsZeroErrorApproxCleanBlock" (lean := "QuantumBlockEncoding.BlockEncodingClassics.exactAsZeroErrorApproxCleanBlock")
*Plain-English reading.* This definition gives the library's named construction or computation for “exact as zero error approx clean block”. Any exact clean-block certificate can be used as a zero-error approximate incumbent in the adaptive exact-to-approximate ABEIS policy.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Reusable permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* Any exact clean-block certificate can be used as a zero-error approximate incumbent in the adaptive exact-to-approximate ABEIS policy.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:877](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L877).
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.exactAsZeroErrorApproxCleanBlock_bound" (lean := "QuantumBlockEncoding.BlockEncodingClassics.exactAsZeroErrorApproxCleanBlock_bound")
*Plain-English reading.* Lean checks the proposition indexed as “exact as zero error approx clean block bound”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:885](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/BlockEncodingClassics.lean#L885).
:::

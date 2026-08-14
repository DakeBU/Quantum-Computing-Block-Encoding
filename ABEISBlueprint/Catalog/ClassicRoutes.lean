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

Reader orientation: Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes. Each card separates an accessible
reading cue from formal status, the source docstring, and the authoritative Lean panel.
The standalone Library Explorer adds full-text search and filters across every chapter.

# QuantumBlockEncoding/BandedSparseAccess.lean

17 explicit public declarations, in source order.

:::definition "QuantumBlockEncoding.BandedSparseAccess.Word" (lean := "QuantumBlockEncoding.BandedSparseAccess.Word")
*Plain-English reading.* This abbreviation gives a shorter name to the type or expression used for “word”. An 'n'-qubit computational-basis word, represented modulo '2^n'.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* An 'n'-qubit computational-basis word, represented modulo '2^n'.

*Declaration kind.* abbrev.

Source: [QuantumBlockEncoding/BandedSparseAccess.lean:21](../../../../library/modules/bandedsparseaccess/#decl-quantumblockencoding-bandedsparseaccess-word). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.BandedSparseAccess.slotWord" (lean := "QuantumBlockEncoding.BandedSparseAccess.slotWord")
*Plain-English reading.* This definition gives the library's named construction or computation for “slot word”. The sparse selector embedded in the clean 'n'-qubit address register.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* The sparse selector embedded in the clean 'n'-qubit address register.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/BandedSparseAccess.lean:24](../../../../library/modules/bandedsparseaccess/#decl-quantumblockencoding-bandedsparseaccess-slotword). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.BandedSparseAccess.modularSumEquiv" (lean := "QuantumBlockEncoding.BandedSparseAccess.modularSumEquiv")
*Plain-English reading.* This definition gives the library's named construction or computation for “modular sum equiv”. Reversible modular SUM: add the second register into the first and preserve the second register.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* Reversible modular SUM: add the second register into the first and preserve the second register. This is Eq. (53) of arXiv:2405.12855.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/BandedSparseAccess.lean:29](../../../../library/modules/bandedsparseaccess/#decl-quantumblockencoding-bandedsparseaccess-modularsumequiv). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.BandedSparseAccess.liftLoaderEquiv" (lean := "QuantumBlockEncoding.BandedSparseAccess.liftLoaderEquiv")
*Plain-English reading.* This definition gives the library's named construction or computation for “lift loader equiv”. Lift a reversible first-row address loader while leaving the row register untouched.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* Lift a reversible first-row address loader while leaving the row register untouched.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/BandedSparseAccess.lean:38](../../../../library/modules/bandedsparseaccess/#decl-quantumblockencoding-bandedsparseaccess-liftloaderequiv). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.BandedSparseAccess.accessEquiv" (lean := "QuantumBlockEncoding.BandedSparseAccess.accessEquiv")
*Plain-English reading.* This definition gives the library's named construction or computation for “access equiv”. The exact arbitrary-size banded-sparse-access semantics: load 'r\_(s,0)', then add the row modulo '2^n'.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* The exact arbitrary-size banded-sparse-access semantics: load 'r\_(s,0)', then add the row modulo '2^n'.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/BandedSparseAccess.lean:44](../../../../library/modules/bandedsparseaccess/#decl-quantumblockencoding-bandedsparseaccess-accessequiv). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.BandedSparseAccess.modularSumEquiv_apply" (lean := "QuantumBlockEncoding.BandedSparseAccess.modularSumEquiv_apply")
*Plain-English reading.* Lean checks the proposition indexed as “modular sum equiv apply”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BandedSparseAccess.lean:48](../../../../library/modules/bandedsparseaccess/#decl-quantumblockencoding-bandedsparseaccess-modularsumequiv-apply). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.BandedSparseAccess.accessEquiv_apply" (lean := "QuantumBlockEncoding.BandedSparseAccess.accessEquiv_apply")
*Plain-English reading.* Lean checks the proposition indexed as “access equiv apply”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BandedSparseAccess.lean:52](../../../../library/modules/bandedsparseaccess/#decl-quantumblockencoding-bandedsparseaccess-accessequiv-apply). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.BandedSparseAccess.accessEquiv_clean_slot" (lean := "QuantumBlockEncoding.BandedSparseAccess.accessEquiv_clean_slot")
*Plain-English reading.* Lean checks the proposition indexed as “access equiv clean slot”; the hypotheses and conclusion in the code panel fix its exact scope. Definition 6 action on the clean sparse-selector input.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* Definition 6 action on the clean sparse-selector input.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BandedSparseAccess.lean:58](../../../../library/modules/bandedsparseaccess/#decl-quantumblockencoding-bandedsparseaccess-accessequiv-clean-slot). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.BandedSparseAccess.accessEquiv_preserves_row" (lean := "QuantumBlockEncoding.BandedSparseAccess.accessEquiv_preserves_row")
*Plain-English reading.* Lean checks the proposition indexed as “access equiv preserves row”; the hypotheses and conclusion in the code panel fix its exact scope. The row register is preserved for every basis input, not only clean sparse selectors.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* The row register is preserved for every basis input, not only clean sparse selectors.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BandedSparseAccess.lean:70](../../../../library/modules/bandedsparseaccess/#decl-quantumblockencoding-bandedsparseaccess-accessequiv-preserves-row). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.BandedSparseAccess.accessMatrix" (lean := "QuantumBlockEncoding.BandedSparseAccess.accessMatrix")
*Plain-English reading.* This definition gives the library's named construction or computation for “access matrix”. Exact matrix semantics induced by the reversible access map.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* Exact matrix semantics induced by the reversible access map.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/BandedSparseAccess.lean:77](../../../../library/modules/bandedsparseaccess/#decl-quantumblockencoding-bandedsparseaccess-accessmatrix). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.BandedSparseAccess.accessMatrix_unitary" (lean := "QuantumBlockEncoding.BandedSparseAccess.accessMatrix_unitary")
*Plain-English reading.* Lean checks the proposition indexed as “access matrix unitary”; the hypotheses and conclusion in the code panel fix its exact scope. The arbitrary-size semantic access construction is unitary.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* The arbitrary-size semantic access construction is unitary.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BandedSparseAccess.lean:82](../../../../library/modules/bandedsparseaccess/#decl-quantumblockencoding-bandedsparseaccess-accessmatrix-unitary). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.BandedSparseAccess.paperSingleQubitUpperBound" (lean := "QuantumBlockEncoding.BandedSparseAccess.paperSingleQubitUpperBound")
*Plain-English reading.* This definition gives the library's named construction or computation for “paper single qubit upper bound”. Source-facing single-qubit upper bound printed in Lemma 1 of arXiv:2405.12855v3.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* Source-facing single-qubit upper bound printed in Lemma 1 of arXiv:2405.12855v3. Natural subtraction is appropriate only in the paper's stated nontrivial register regime.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/BandedSparseAccess.lean:90](../../../../library/modules/bandedsparseaccess/#decl-quantumblockencoding-bandedsparseaccess-papersinglequbitupperbound). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.BandedSparseAccess.paperCnotUpperBound" (lean := "QuantumBlockEncoding.BandedSparseAccess.paperCnotUpperBound")
*Plain-English reading.* This definition gives the library's named construction or computation for “paper cnot upper bound”. Source-facing CNOT upper bound printed in the same lemma.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* Source-facing CNOT upper bound printed in the same lemma.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/BandedSparseAccess.lean:94](../../../../library/modules/bandedsparseaccess/#decl-quantumblockencoding-bandedsparseaccess-papercnotupperbound). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.BandedSparseAccess.paperPureAncillaUpperBound" (lean := "QuantumBlockEncoding.BandedSparseAccess.paperPureAncillaUpperBound")
*Plain-English reading.* This definition gives the library's named construction or computation for “paper pure ancilla upper bound”. Source-facing clean-ancilla upper bound printed in the same lemma.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* Source-facing clean-ancilla upper bound printed in the same lemma.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/BandedSparseAccess.lean:98](../../../../library/modules/bandedsparseaccess/#decl-quantumblockencoding-bandedsparseaccess-paperpureancillaupperbound). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.BandedSparseAccess.paperSingleQubitUpperBound_eq" (lean := "QuantumBlockEncoding.BandedSparseAccess.paperSingleQubitUpperBound_eq")
*Plain-English reading.* Lean checks the proposition indexed as “paper single qubit upper bound eq”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BandedSparseAccess.lean:101](../../../../library/modules/bandedsparseaccess/#decl-quantumblockencoding-bandedsparseaccess-papersinglequbitupperbound-eq). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.BandedSparseAccess.paperCnotUpperBound_eq" (lean := "QuantumBlockEncoding.BandedSparseAccess.paperCnotUpperBound_eq")
*Plain-English reading.* Lean checks the proposition indexed as “paper cnot upper bound eq”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BandedSparseAccess.lean:105](../../../../library/modules/bandedsparseaccess/#decl-quantumblockencoding-bandedsparseaccess-papercnotupperbound-eq). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.BandedSparseAccess.paperPureAncillaUpperBound_eq" (lean := "QuantumBlockEncoding.BandedSparseAccess.paperPureAncillaUpperBound_eq")
*Plain-English reading.* Lean checks the proposition indexed as “paper pure ancilla upper bound eq”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BandedSparseAccess.lean:110](../../../../library/modules/bandedsparseaccess/#decl-quantumblockencoding-bandedsparseaccess-paperpureancillaupperbound-eq). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

# QuantumBlockEncoding/BandedSparseAccessPrimitive.lean

13 explicit public declarations, in source order.

:::definition "QuantumBlockEncoding.BandedSparseAccess.primitiveWord3" (lean := "QuantumBlockEncoding.BandedSparseAccess.primitiveWord3")
*Plain-English reading.* This definition gives the library's named construction or computation for “primitive word 3”. Decode three little-endian wires as an element of 'Fin 8'.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* Decode three little-endian wires as an element of 'Fin 8'.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/BandedSparseAccessPrimitive.lean:19](../../../../library/modules/bandedsparseaccessprimitive/#decl-quantumblockencoding-bandedsparseaccess-primitiveword3). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.BandedSparseAccess.primitiveOffset3" (lean := "QuantumBlockEncoding.BandedSparseAccess.primitiveOffset3")
*Plain-English reading.* This definition gives the library's named construction or computation for “primitive offset 3”. The concrete source loader used by the fixed witness: 's ↦ s XOR 3'.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* The concrete source loader used by the fixed witness: 's ↦ s XOR 3'.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/BandedSparseAccessPrimitive.lean:29](../../../../library/modules/bandedsparseaccessprimitive/#decl-quantumblockencoding-bandedsparseaccess-primitiveoffset3). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.BandedSparseAccess.primitiveOffset3_table" (lean := "QuantumBlockEncoding.BandedSparseAccess.primitiveOffset3_table")
*Plain-English reading.* Lean checks the proposition indexed as “primitive offset 3 table”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BandedSparseAccessPrimitive.lean:32](../../../../library/modules/bandedsparseaccessprimitive/#decl-quantumblockencoding-bandedsparseaccess-primitiveoffset3-table). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.BandedSparseAccess.primitiveAccess3ReversibleProgram" (lean := "QuantumBlockEncoding.BandedSparseAccess.primitiveAccess3ReversibleProgram")
*Plain-English reading.* This definition gives the library's named construction or computation for “primitive access 3 reversible program”. Wire order is 'address\[0..2\], row\[0..2\], work'.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* Wire order is 'address\[0..2\], row\[0..2\], work'. Two 'X' gates implement the source loader and the existing exact three-bit adder implements modular SUM.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/BandedSparseAccessPrimitive.lean:40](../../../../library/modules/bandedsparseaccessprimitive/#decl-quantumblockencoding-bandedsparseaccess-primitiveaccess3reversibleprogram). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.BandedSparseAccess.primitiveAccess3BasisEquiv" (lean := "QuantumBlockEncoding.BandedSparseAccess.primitiveAccess3BasisEquiv")
*Plain-English reading.* This definition gives the library's named construction or computation for “primitive access 3 basis equiv”. Full-space reversible semantics of the fixed primitive witness.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* Full-space reversible semantics of the fixed primitive witness.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/BandedSparseAccessPrimitive.lean:44](../../../../library/modules/bandedsparseaccessprimitive/#decl-quantumblockencoding-bandedsparseaccess-primitiveaccess3basisequiv). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.BandedSparseAccess.primitiveAccess3_cleanAction" (lean := "QuantumBlockEncoding.BandedSparseAccess.primitiveAccess3_cleanAction")
*Plain-English reading.* Lean checks the proposition indexed as “primitive access 3 clean action”; the hypotheses and conclusion in the code panel fix its exact scope. Exact clean-workspace action of the expanded access circuit.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* Exact clean-workspace action of the expanded access circuit.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BandedSparseAccessPrimitive.lean:48](../../../../library/modules/bandedsparseaccessprimitive/#decl-quantumblockencoding-bandedsparseaccess-primitiveaccess3-cleanaction). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.BandedSparseAccess.primitiveAccess3_preserves_row" (lean := "QuantumBlockEncoding.BandedSparseAccess.primitiveAccess3_preserves_row")
*Plain-English reading.* Lean checks the proposition indexed as “primitive access 3 preserves row”; the hypotheses and conclusion in the code panel fix its exact scope. The row register is preserved by the primitive witness.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* The row register is preserved by the primitive witness.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BandedSparseAccessPrimitive.lean:60](../../../../library/modules/bandedsparseaccessprimitive/#decl-quantumblockencoding-bandedsparseaccess-primitiveaccess3-preserves-row). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.BandedSparseAccess.primitiveAccess3_workspaceClean" (lean := "QuantumBlockEncoding.BandedSparseAccess.primitiveAccess3_workspaceClean")
*Plain-English reading.* Lean checks the proposition indexed as “primitive access 3 workspace clean”; the hypotheses and conclusion in the code panel fix its exact scope. The reusable work qubit is returned to zero.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* The reusable work qubit is returned to zero.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BandedSparseAccessPrimitive.lean:67](../../../../library/modules/bandedsparseaccessprimitive/#decl-quantumblockencoding-bandedsparseaccess-primitiveaccess3-workspaceclean). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.BandedSparseAccess.primitiveAccess3Program" (lean := "QuantumBlockEncoding.BandedSparseAccess.primitiveAccess3Program")
*Plain-English reading.* This definition gives the library's named construction or computation for “primitive access 3 program”. Primitive compilation contains no opaque oracle instruction.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* Primitive compilation contains no opaque oracle instruction.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/BandedSparseAccessPrimitive.lean:73](../../../../library/modules/bandedsparseaccessprimitive/#decl-quantumblockencoding-bandedsparseaccess-primitiveaccess3program). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.BandedSparseAccess.primitiveAccess3Program_eval" (lean := "QuantumBlockEncoding.BandedSparseAccess.primitiveAccess3Program_eval")
*Plain-English reading.* Lean checks the proposition indexed as “primitive access 3 program eval”; the hypotheses and conclusion in the code panel fix its exact scope. Exact matrix refinement from the emitted primitive list to the reversible map.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* Exact matrix refinement from the emitted primitive list to the reversible map.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BandedSparseAccessPrimitive.lean:77](../../../../library/modules/bandedsparseaccessprimitive/#decl-quantumblockencoding-bandedsparseaccess-primitiveaccess3program-eval). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.BandedSparseAccess.primitiveAccess3Program_resource_faithful" (lean := "QuantumBlockEncoding.BandedSparseAccess.primitiveAccess3Program_resource_faithful")
*Plain-English reading.* Lean checks the proposition indexed as “primitive access 3 program resource faithful”; the hypotheses and conclusion in the code panel fix its exact scope. Resource ownership is definitional: the score is computed from the gate list.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* Resource ownership is definitional: the score is computed from the gate list.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BandedSparseAccessPrimitive.lean:83](../../../../library/modules/bandedsparseaccessprimitive/#decl-quantumblockencoding-bandedsparseaccess-primitiveaccess3program-resource-faithful). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.BandedSparseAccess.primitiveAccess3Program_oracleCalls_eq_zero" (lean := "QuantumBlockEncoding.BandedSparseAccess.primitiveAccess3Program_oracleCalls_eq_zero")
*Plain-English reading.* Lean checks the proposition indexed as “primitive access 3 program oracle calls eq zero”; the hypotheses and conclusion in the code panel fix its exact scope. The expanded witness has zero unresolved oracle calls.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* The expanded witness has zero unresolved oracle calls.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BandedSparseAccessPrimitive.lean:87](../../../../library/modules/bandedsparseaccessprimitive/#decl-quantumblockencoding-bandedsparseaccess-primitiveaccess3program-oraclecalls-eq-zero). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.BandedSparseAccess.primitiveAccess3Program_unitary" (lean := "QuantumBlockEncoding.BandedSparseAccess.primitiveAccess3Program_unitary")
*Plain-English reading.* Lean checks the proposition indexed as “primitive access 3 program unitary”; the hypotheses and conclusion in the code panel fix its exact scope. The primitive matrix is unitary because every emitted instruction is unitary.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* The primitive matrix is unitary because every emitted instruction is unitary.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BandedSparseAccessPrimitive.lean:92](../../../../library/modules/bandedsparseaccessprimitive/#decl-quantumblockencoding-bandedsparseaccess-primitiveaccess3program-unitary). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

# QuantumBlockEncoding/BlockEncodingClassics.lean

84 explicit public declarations, in source order.

:::definition "QuantumBlockEncoding.BlockEncodingClassics.permMatrix" (lean := "QuantumBlockEncoding.BlockEncodingClassics.permMatrix")
*Plain-English reading.* This definition gives the library's named construction or computation for “perm matrix”. Permutation-matrix entries for a finite basis map.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* Permutation-matrix entries for a finite basis map.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:19](../../../../library/modules/blockencodingclassics/#decl-quantumblockencoding-blockencodingclassics-permmatrix). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.columnInner" (lean := "QuantumBlockEncoding.BlockEncodingClassics.columnInner")
*Plain-English reading.* This definition gives the library's named construction or computation for “column inner”. Column inner products for rational matrix-level orthogonality checks.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* Column inner products for rational matrix-level orthogonality checks.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:23](../../../../library/modules/blockencodingclassics/#decl-quantumblockencoding-blockencodingclassics-columninner). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.rowInner" (lean := "QuantumBlockEncoding.BlockEncodingClassics.rowInner")
*Plain-English reading.* This definition gives the library's named construction or computation for “row inner”. Row inner products for rational matrix-level orthogonality checks.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* Row inner products for rational matrix-level orthogonality checks.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:27](../../../../library/modules/blockencodingclassics/#decl-quantumblockencoding-blockencodingclassics-rowinner). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.IsRationalOrthogonal" (lean := "QuantumBlockEncoding.BlockEncodingClassics.IsRationalOrthogonal")
*Plain-English reading.* This definition gives the library's named construction or computation for “is rational orthogonal”. Rational orthogonality predicate for real-valued finite matrix backends: 'U^T U = I' and 'U U^T = I', expressed entrywise.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* Rational orthogonality predicate for real-valued finite matrix backends: 'U^T U = I' and 'U U^T = I', expressed entrywise.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:34](../../../../library/modules/blockencodingclassics/#decl-quantumblockencoding-blockencodingclassics-isrationalorthogonal). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.cleanBlockBy" (lean := "QuantumBlockEncoding.BlockEncodingClassics.cleanBlockBy")
*Plain-English reading.* This definition gives the library's named construction or computation for “clean block by”. Clean block induced by an embedding of the system basis into a larger basis.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* Clean block induced by an embedding of the system basis into a larger basis.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:39](../../../../library/modules/blockencodingclassics/#decl-quantumblockencoding-blockencodingclassics-cleanblockby). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.productIndex" (lean := "QuantumBlockEncoding.BlockEncodingClassics.productIndex")
*Plain-English reading.* This definition gives the library's named construction or computation for “product index”. Canonical product-register embedding.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* Canonical product-register embedding. If the full Hilbert basis is represented as 'ancilla × system', this maps '(a, s)' to the flattened index 'a \* system + s'.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:48](../../../../library/modules/blockencodingclassics/#decl-quantumblockencoding-blockencodingclassics-productindex). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.cleanBlockProduct" (lean := "QuantumBlockEncoding.BlockEncodingClassics.cleanBlockProduct")
*Plain-English reading.* This definition gives the library's named construction or computation for “clean block product”. Clean block for a flattened 'ancilla × system' matrix.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* Clean block for a flattened 'ancilla × system' matrix.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:60](../../../../library/modules/blockencodingclassics/#decl-quantumblockencoding-blockencodingclassics-cleanblockproduct). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.cleanBlockBy_permMatrix_entry" (lean := "QuantumBlockEncoding.BlockEncodingClassics.cleanBlockBy_permMatrix_entry")
*Plain-English reading.* Lean checks the proposition indexed as “clean block by perm matrix entry”; the hypotheses and conclusion in the code panel fix its exact scope. Core 'BE.PermMatrix.CleanBlock' leaf: the clean block of a permutation matrix is just the finite image predicate restricted to clean embedded rows and columns.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* Core 'BE.PermMatrix.CleanBlock' leaf: the clean block of a permutation matrix is just the finite image predicate restricted to clean embedded rows and columns.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:69](../../../../library/modules/blockencodingclassics/#decl-quantumblockencoding-blockencodingclassics-cleanblockby-permmatrix-entry). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.cleanBlockProduct_permMatrix_entry" (lean := "QuantumBlockEncoding.BlockEncodingClassics.cleanBlockProduct_permMatrix_entry")
*Plain-English reading.* Lean checks the proposition indexed as “clean block product perm matrix entry”; the hypotheses and conclusion in the code panel fix its exact scope. Product-register version of 'cleanBlockBy\_permMatrix\_entry'.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* Product-register version of 'cleanBlockBy\_permMatrix\_entry'. This is the standard entrywise bridge for block encodings whose clean ancilla is explicitly one register of a flattened product basis.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:81](../../../../library/modules/blockencodingclassics/#decl-quantumblockencoding-blockencodingclassics-cleanblockproduct-permmatrix-entry). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.cleanBlockBy_permMatrix_eq_target_of_entry" (lean := "QuantumBlockEncoding.BlockEncodingClassics.cleanBlockBy_permMatrix_eq_target_of_entry")
*Plain-English reading.* Lean checks the proposition indexed as “clean block by perm matrix eq target of entry”; the hypotheses and conclusion in the code panel fix its exact scope. Entrywise bridge from a finite image calculation to an exact clean block.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* Entrywise bridge from a finite image calculation to an exact clean block. This is the leaf that converts a successful finite reversible construction into the block-entry theorem lower agents usually need.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:93](../../../../library/modules/blockencodingclassics/#decl-quantumblockencoding-blockencodingclassics-cleanblockby-permmatrix-eq-target-of-entry). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.cleanBlockProduct_eq_target_of_entry" (lean := "QuantumBlockEncoding.BlockEncodingClassics.cleanBlockProduct_eq_target_of_entry")
*Plain-English reading.* Lean checks the proposition indexed as “clean block product eq target of entry”; the hypotheses and conclusion in the code panel fix its exact scope. Pointwise extension principle for product-register clean blocks.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* Pointwise extension principle for product-register clean blocks.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:104](../../../../library/modules/blockencodingclassics/#decl-quantumblockencoding-blockencodingclassics-cleanblockproduct-eq-target-of-entry). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.kroneckerRat" (lean := "QuantumBlockEncoding.BlockEncodingClassics.kroneckerRat")
*Plain-English reading.* This definition gives the library's named construction or computation for “kronecker rat”. Kronecker delta over the project-local rational matrix backend.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* Kronecker delta over the project-local rational matrix backend.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:116](../../../../library/modules/blockencodingclassics/#decl-quantumblockencoding-blockencodingclassics-kroneckerrat). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.oneSparseMatrix" (lean := "QuantumBlockEncoding.BlockEncodingClassics.oneSparseMatrix")
*Plain-English reading.* This definition gives the library's named construction or computation for “one sparse matrix”. Column one-sparse matrix with support map 'c': column 'j' has its possible nonzero entry at row 'c j', with amplitude 'amp j'.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* Column one-sparse matrix with support map 'c': column 'j' has its possible nonzero entry at row 'c j', with amplitude 'amp j'.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:123](../../../../library/modules/blockencodingclassics/#decl-quantumblockencoding-blockencodingclassics-onesparsematrix). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.oneSparseMatrix_entry_if" (lean := "QuantumBlockEncoding.BlockEncodingClassics.oneSparseMatrix_entry_if")
*Plain-English reading.* Lean checks the proposition indexed as “one sparse matrix entry if”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:127](../../../../library/modules/blockencodingclassics/#decl-quantumblockencoding-blockencodingclassics-onesparsematrix-entry-if). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.oneSparse_from_support" (lean := "QuantumBlockEncoding.BlockEncodingClassics.oneSparse_from_support")
*Plain-English reading.* Lean checks the proposition indexed as “one sparse from support”; the hypotheses and conclusion in the code panel fix its exact scope. One-sparse reconstruction leaf.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* One-sparse reconstruction leaf. If a target matrix is supported only at 'row = c col', then its support map and column amplitudes reconstruct it entrywise.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:139](../../../../library/modules/blockencodingclassics/#decl-quantumblockencoding-blockencodingclassics-onesparse-from-support). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.OneSparseCertificate" (lean := "QuantumBlockEncoding.BlockEncodingClassics.OneSparseCertificate")
*Plain-English reading.* This record groups the data and proof fields needed for “one sparse certificate”. A proposition-valued field is a requirement until a constructor supplies it. Proof-carrying one-sparse certificate.

*Formal status.* Data contract in the default import surface; proposition-valued fields are obligations, not automatically established facts.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* Proof-carrying one-sparse certificate. This is the exact finite leaf behind the textbook one-sparse block-encoding route after the amplitude and location oracles have been reduced to a support map.

*Declaration kind.* structure.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:155](../../../../library/modules/blockencodingclassics/#decl-quantumblockencoding-blockencodingclassics-onesparsecertificate). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.OneSparseCertificate.cleanBlock" (lean := "QuantumBlockEncoding.BlockEncodingClassics.OneSparseCertificate.cleanBlock")
*Plain-English reading.* This definition gives the library's named construction or computation for “clean block”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:163](../../../../library/modules/blockencodingclassics/#decl-quantumblockencoding-blockencodingclassics-onesparsecertificate-cleanblock). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.OneSparseCertificate.correct" (lean := "QuantumBlockEncoding.BlockEncodingClassics.OneSparseCertificate.correct")
*Plain-English reading.* Lean checks the proposition indexed as “correct”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:166](../../../../library/modules/blockencodingclassics/#decl-quantumblockencoding-blockencodingclassics-onesparsecertificate-correct). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.sparseColumnCleanEntry" (lean := "QuantumBlockEncoding.BlockEncodingClassics.sparseColumnCleanEntry")
*Plain-English reading.* This definition gives the library's named construction or computation for “sparse column clean entry”. Column sparse clean-entry expression: a finite sum over slot indices of value oracle entries times location deltas.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* Column sparse clean-entry expression: a finite sum over slot indices of value oracle entries times location deltas. This is the entrywise target for Lin-style sparse column proofs before a task attaches its uniqueness lemmas.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:177](../../../../library/modules/blockencodingclassics/#decl-quantumblockencoding-blockencodingclassics-sparsecolumncleanentry). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.permMatrix_columnInner_of_injective" (lean := "QuantumBlockEncoding.BlockEncodingClassics.permMatrix_columnInner_of_injective")
*Plain-English reading.* Lean checks the proposition indexed as “perm matrix column inner of injective”; the hypotheses and conclusion in the code panel fix its exact scope. Column Gram entries of a permutation matrix collapse by injectivity.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* Column Gram entries of a permutation matrix collapse by injectivity.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:283](../../../../library/modules/blockencodingclassics/#decl-quantumblockencoding-blockencodingclassics-permmatrix-columninner-of-injective). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.permMatrix_rowInner_of_bijective" (lean := "QuantumBlockEncoding.BlockEncodingClassics.permMatrix_rowInner_of_bijective")
*Plain-English reading.* Lean checks the proposition indexed as “perm matrix row inner of bijective”; the hypotheses and conclusion in the code panel fix its exact scope. Row Gram entries of a permutation matrix collapse by bijectivity.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* Row Gram entries of a permutation matrix collapse by bijectivity.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:330](../../../../library/modules/blockencodingclassics/#decl-quantumblockencoding-blockencodingclassics-permmatrix-rowinner-of-bijective). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.permMatrix_isRationalOrthogonal_of_bijective" (lean := "QuantumBlockEncoding.BlockEncodingClassics.permMatrix_isRationalOrthogonal_of_bijective")
*Plain-English reading.* Lean checks the proposition indexed as “perm matrix is rational orthogonal of bijective”; the hypotheses and conclusion in the code panel fix its exact scope. A bijective finite image induces a rational orthogonal permutation matrix.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* A bijective finite image induces a rational orthogonal permutation matrix. This is the reusable bridge from finite permutation certificates to the matrix-level unitarity proxy used by the exploratory block-encoding tasks.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:389](../../../../library/modules/blockencodingclassics/#decl-quantumblockencoding-blockencodingclassics-permmatrix-isrationalorthogonal-of-bijective). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.sparseColumnCleanEntry_no_hit" (lean := "QuantumBlockEncoding.BlockEncodingClassics.sparseColumnCleanEntry_no_hit")
*Plain-English reading.* Lean checks the proposition indexed as “sparse column clean entry no hit”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:396](../../../../library/modules/blockencodingclassics/#decl-quantumblockencoding-blockencodingclassics-sparsecolumncleanentry-no-hit). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.sparseColumnCleanEntry_unique_slot" (lean := "QuantumBlockEncoding.BlockEncodingClassics.sparseColumnCleanEntry_unique_slot")
*Plain-English reading.* Lean checks the proposition indexed as “sparse column clean entry unique slot”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:409](../../../../library/modules/blockencodingclassics/#decl-quantumblockencoding-blockencodingclassics-sparsecolumncleanentry-unique-slot). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.rowColumnSparseDeltaEntry" (lean := "QuantumBlockEncoding.BlockEncodingClassics.rowColumnSparseDeltaEntry")
*Plain-English reading.* This definition gives the library's named construction or computation for “row column sparse delta entry”. General row/column sparse delta expression.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* General row/column sparse delta expression. A paper-specific route must prove that row-location and column-location uniqueness collapse this finite double sum to the target entry divided by the sparsity normalizer.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:434](../../../../library/modules/blockencodingclassics/#decl-quantumblockencoding-blockencodingclassics-rowcolumnsparsedeltaentry). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.SparseColumnCertificate" (lean := "QuantumBlockEncoding.BlockEncodingClassics.SparseColumnCertificate")
*Plain-English reading.* This record groups the data and proof fields needed for “sparse column certificate”. A proposition-valued field is a requirement until a constructor supplies it. Proof-carrying sparse-column contract.

*Formal status.* Data contract in the default import surface; proposition-valued fields are obligations, not automatically established facts.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* Proof-carrying sparse-column contract. The contract is not a theorem by itself; it records the exact clean-entry theorem a paper-specific lower agent must supply.

*Declaration kind.* structure.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:456](../../../../library/modules/blockencodingclassics/#decl-quantumblockencoding-blockencodingclassics-sparsecolumncertificate). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.SparseColumnCertificate.correct" (lean := "QuantumBlockEncoding.BlockEncodingClassics.SparseColumnCertificate.correct")
*Plain-English reading.* Lean checks the proposition indexed as “correct”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:466](../../../../library/modules/blockencodingclassics/#decl-quantumblockencoding-blockencodingclassics-sparsecolumncertificate-correct). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.RowColumnSparseCertificate" (lean := "QuantumBlockEncoding.BlockEncodingClassics.RowColumnSparseCertificate")
*Plain-English reading.* This record groups the data and proof fields needed for “row column sparse certificate”. A proposition-valued field is a requirement until a constructor supplies it. Proof-carrying row/column sparse contract for the general sparse route.

*Formal status.* Data contract in the default import surface; proposition-valued fields are obligations, not automatically established facts.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* Proof-carrying row/column sparse contract for the general sparse route.

*Declaration kind.* structure.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:475](../../../../library/modules/blockencodingclassics/#decl-quantumblockencoding-blockencodingclassics-rowcolumnsparsecertificate). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.RowColumnSparseCertificate.correct" (lean := "QuantumBlockEncoding.BlockEncodingClassics.RowColumnSparseCertificate.correct")
*Plain-English reading.* Lean checks the proposition indexed as “correct”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:486](../../../../library/modules/blockencodingclassics/#decl-quantumblockencoding-blockencodingclassics-rowcolumnsparsecertificate-correct). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.ValueToAmplitudeContract" (lean := "QuantumBlockEncoding.BlockEncodingClassics.ValueToAmplitudeContract")
*Plain-English reading.* This record groups the data and proof fields needed for “value to amplitude contract”. A proposition-valued field is a requirement until a constructor supplies it. Value-to-amplitude oracle contract.

*Formal status.* Data contract in the default import surface; proposition-valued fields are obligations, not automatically established facts.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* Value-to-amplitude oracle contract. A task may use this only after it supplies both cleanup and amplitude-entry proofs; the record cannot close a proof by itself.

*Declaration kind.* structure.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:498](../../../../library/modules/blockencodingclassics/#decl-quantumblockencoding-blockencodingclassics-valuetoamplitudecontract). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.ValueToAmplitudeContract.correct" (lean := "QuantumBlockEncoding.BlockEncodingClassics.ValueToAmplitudeContract.correct")
*Plain-English reading.* Lean checks the proposition indexed as “correct”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:509](../../../../library/modules/blockencodingclassics/#decl-quantumblockencoding-blockencodingclassics-valuetoamplitudecontract-correct). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.IsSymmetric" (lean := "QuantumBlockEncoding.BlockEncodingClassics.IsSymmetric")
*Plain-English reading.* This definition gives the library's named construction or computation for “is symmetric”. Symmetric matrix predicate for the rational backend.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* Symmetric matrix predicate for the rational backend.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:516](../../../../library/modules/blockencodingclassics/#decl-quantumblockencoding-blockencodingclassics-issymmetric). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.cleanBlockBy_symmetric_of_symmetric" (lean := "QuantumBlockEncoding.BlockEncodingClassics.cleanBlockBy_symmetric_of_symmetric")
*Plain-English reading.* Lean checks the proposition indexed as “clean block by symmetric of symmetric”; the hypotheses and conclusion in the code panel fix its exact scope. A symmetric full matrix has a symmetric clean block under any embedding.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* A symmetric full matrix has a symmetric clean block under any embedding.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:520](../../../../library/modules/blockencodingclassics/#decl-quantumblockencoding-blockencodingclassics-cleanblockby-symmetric-of-symmetric). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.fin2Zero" (lean := "QuantumBlockEncoding.BlockEncodingClassics.fin2Zero")
*Plain-English reading.* This definition gives the library's named construction or computation for “fin 2 zero”. Two-by-two scalar dilation block.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* Two-by-two scalar dilation block. Unitarity requires a separate norm proof.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:528](../../../../library/modules/blockencodingclassics/#decl-quantumblockencoding-blockencodingclassics-fin2zero). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.fin2One" (lean := "QuantumBlockEncoding.BlockEncodingClassics.fin2One")
*Plain-English reading.* This definition gives the library's named construction or computation for “fin 2 one”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:530](../../../../library/modules/blockencodingclassics/#decl-quantumblockencoding-blockencodingclassics-fin2one). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.scalarDilation" (lean := "QuantumBlockEncoding.BlockEncodingClassics.scalarDilation")
*Plain-English reading.* This definition gives the library's named construction or computation for “scalar dilation”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:532](../../../../library/modules/blockencodingclassics/#decl-quantumblockencoding-blockencodingclassics-scalardilation). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.scalarDilation_cleanEntry" (lean := "QuantumBlockEncoding.BlockEncodingClassics.scalarDilation_cleanEntry")
*Plain-English reading.* Lean checks the proposition indexed as “scalar dilation clean entry”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:539](../../../../library/modules/blockencodingclassics/#decl-quantumblockencoding-blockencodingclassics-scalardilation-cleanentry). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.scalarDilation_offdiag01" (lean := "QuantumBlockEncoding.BlockEncodingClassics.scalarDilation_offdiag01")
*Plain-English reading.* Lean checks the proposition indexed as “scalar dilation offdiag 01”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:543](../../../../library/modules/blockencodingclassics/#decl-quantumblockencoding-blockencodingclassics-scalardilation-offdiag01). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.scalarDilation_offdiag10" (lean := "QuantumBlockEncoding.BlockEncodingClassics.scalarDilation_offdiag10")
*Plain-English reading.* Lean checks the proposition indexed as “scalar dilation offdiag 10”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:547](../../../../library/modules/blockencodingclassics/#decl-quantumblockencoding-blockencodingclassics-scalardilation-offdiag10). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.scalarDilation_diag11" (lean := "QuantumBlockEncoding.BlockEncodingClassics.scalarDilation_diag11")
*Plain-English reading.* Lean checks the proposition indexed as “scalar dilation diag 11”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:551](../../../../library/modules/blockencodingclassics/#decl-quantumblockencoding-blockencodingclassics-scalardilation-diag11). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.scalarDilationRowDot" (lean := "QuantumBlockEncoding.BlockEncodingClassics.scalarDilationRowDot")
*Plain-English reading.* This definition gives the library's named construction or computation for “scalar dilation row dot”. Two-entry row dot product for the scalar dilation block.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* Two-entry row dot product for the scalar dilation block.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:556](../../../../library/modules/blockencodingclassics/#decl-quantumblockencoding-blockencodingclassics-scalardilationrowdot). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.scalarDilation_row0_normSq" (lean := "QuantumBlockEncoding.BlockEncodingClassics.scalarDilation_row0_normSq")
*Plain-English reading.* Lean checks the proposition indexed as “scalar dilation row 0 norm sq”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:560](../../../../library/modules/blockencodingclassics/#decl-quantumblockencoding-blockencodingclassics-scalardilation-row0-normsq). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.scalarDilation_row1_normSq" (lean := "QuantumBlockEncoding.BlockEncodingClassics.scalarDilation_row1_normSq")
*Plain-English reading.* Lean checks the proposition indexed as “scalar dilation row 1 norm sq”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:564](../../../../library/modules/blockencodingclassics/#decl-quantumblockencoding-blockencodingclassics-scalardilation-row1-normsq). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.scalarDilation_row0_unit_norm_of" (lean := "QuantumBlockEncoding.BlockEncodingClassics.scalarDilation_row0_unit_norm_of")
*Plain-English reading.* Lean checks the proposition indexed as “scalar dilation row 0 unit norm of”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:573](../../../../library/modules/blockencodingclassics/#decl-quantumblockencoding-blockencodingclassics-scalardilation-row0-unit-norm-of). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.scalarDilation_row1_unit_norm_of" (lean := "QuantumBlockEncoding.BlockEncodingClassics.scalarDilation_row1_unit_norm_of")
*Plain-English reading.* Lean checks the proposition indexed as “scalar dilation row 1 unit norm of”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:578](../../../../library/modules/blockencodingclassics/#decl-quantumblockencoding-blockencodingclassics-scalardilation-row1-unit-norm-of). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.scalarDilation_rows01_orthogonal" (lean := "QuantumBlockEncoding.BlockEncodingClassics.scalarDilation_rows01_orthogonal")
*Plain-English reading.* Lean checks the proposition indexed as “scalar dilation rows 01 orthogonal”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:583](../../../../library/modules/blockencodingclassics/#decl-quantumblockencoding-blockencodingclassics-scalardilation-rows01-orthogonal). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.scalarDilation_rows10_orthogonal" (lean := "QuantumBlockEncoding.BlockEncodingClassics.scalarDilation_rows10_orthogonal")
*Plain-English reading.* Lean checks the proposition indexed as “scalar dilation rows 10 orthogonal”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:590](../../../../library/modules/blockencodingclassics/#decl-quantumblockencoding-blockencodingclassics-scalardilation-rows10-orthogonal). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.chebyshevT" (lean := "QuantumBlockEncoding.BlockEncodingClassics.chebyshevT")
*Plain-English reading.* This definition gives the library's named construction or computation for “chebyshev t”. Chebyshev polynomial values, kept as a small executable recurrence.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* Chebyshev polynomial values, kept as a small executable recurrence.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:598](../../../../library/modules/blockencodingclassics/#decl-quantumblockencoding-blockencodingclassics-chebyshevt). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.chebyshevT_zero" (lean := "QuantumBlockEncoding.BlockEncodingClassics.chebyshevT_zero")
*Plain-English reading.* Lean checks the proposition indexed as “chebyshev t zero”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:603](../../../../library/modules/blockencodingclassics/#decl-quantumblockencoding-blockencodingclassics-chebyshevt-zero). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.chebyshevT_one" (lean := "QuantumBlockEncoding.BlockEncodingClassics.chebyshevT_one")
*Plain-English reading.* Lean checks the proposition indexed as “chebyshev t one”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:605](../../../../library/modules/blockencodingclassics/#decl-quantumblockencoding-blockencodingclassics-chebyshevt-one). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.chebyshevT_two" (lean := "QuantumBlockEncoding.BlockEncodingClassics.chebyshevT_two")
*Plain-English reading.* Lean checks the proposition indexed as “chebyshev t two”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:607](../../../../library/modules/blockencodingclassics/#decl-quantumblockencoding-blockencodingclassics-chebyshevt-two). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.chebyshevT_succ_succ" (lean := "QuantumBlockEncoding.BlockEncodingClassics.chebyshevT_succ_succ")
*Plain-English reading.* Lean checks the proposition indexed as “chebyshev t succ succ”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:609](../../../../library/modules/blockencodingclassics/#decl-quantumblockencoding-blockencodingclassics-chebyshevt-succ-succ). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.chebyshevT_three_recurrence" (lean := "QuantumBlockEncoding.BlockEncodingClassics.chebyshevT_three_recurrence")
*Plain-English reading.* Lean checks the proposition indexed as “chebyshev t three recurrence”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:613](../../../../library/modules/blockencodingclassics/#decl-quantumblockencoding-blockencodingclassics-chebyshevt-three-recurrence). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.chebyshevT_four_recurrence" (lean := "QuantumBlockEncoding.BlockEncodingClassics.chebyshevT_four_recurrence")
*Plain-English reading.* Lean checks the proposition indexed as “chebyshev t four recurrence”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:616](../../../../library/modules/blockencodingclassics/#decl-quantumblockencoding-blockencodingclassics-chebyshevt-four-recurrence). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.ExactCleanBlock" (lean := "QuantumBlockEncoding.BlockEncodingClassics.ExactCleanBlock")
*Plain-English reading.* This record groups the data and proof fields needed for “exact clean block”. A proposition-valued field is a requirement until a constructor supplies it. Proof-carrying exact clean-block package.

*Formal status.* Data contract in the default import surface; proposition-valued fields are obligations, not automatically established facts.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* Proof-carrying exact clean-block package. This is smaller than the full operator-candidate record and is intended for reusable theorem arithmetic.

*Declaration kind.* structure.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:623](../../../../library/modules/blockencodingclassics/#decl-quantumblockencoding-blockencodingclassics-exactcleanblock). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.ExactCleanBlock.clean" (lean := "QuantumBlockEncoding.BlockEncodingClassics.ExactCleanBlock.clean")
*Plain-English reading.* This definition gives the library's named construction or computation for “clean”. The certified clean block associated with a proof-carrying package.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* The certified clean block associated with a proof-carrying package.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:632](../../../../library/modules/blockencodingclassics/#decl-quantumblockencoding-blockencodingclassics-exactcleanblock-clean). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.ExactCleanBlock.clean_eq_target" (lean := "QuantumBlockEncoding.BlockEncodingClassics.ExactCleanBlock.clean_eq_target")
*Plain-English reading.* Lean checks the proposition indexed as “clean eq target”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:636](../../../../library/modules/blockencodingclassics/#decl-quantumblockencoding-blockencodingclassics-exactcleanblock-clean-eq-target). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.QubitizationChebyshevContract" (lean := "QuantumBlockEncoding.BlockEncodingClassics.QubitizationChebyshevContract")
*Plain-English reading.* This record groups the data and proof fields needed for “qubitization chebyshev contract”. A proposition-valued field is a requirement until a constructor supplies it. Qubitization/Chebyshev proof-carrying contract.

*Formal status.* Data contract in the default import surface; proposition-valued fields are obligations, not automatically established facts.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* Qubitization/Chebyshev proof-carrying contract. The full qubitization theorem will instantiate this after the two-dimensional invariant-subspace calculation is formalized.

*Declaration kind.* structure.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:648](../../../../library/modules/blockencodingclassics/#decl-quantumblockencoding-blockencodingclassics-qubitizationchebyshevcontract). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.partialPermutationCertificate" (lean := "QuantumBlockEncoding.BlockEncodingClassics.partialPermutationCertificate")
*Plain-English reading.* This definition gives the library's named construction or computation for “partial permutation certificate”. Abstract partial-permutation certificate.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* Abstract partial-permutation certificate. A concrete task supplies the embedding, finite image, target matrix, and image-entry theorem; this wrapper returns a reusable exact clean-block certificate.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:662](../../../../library/modules/blockencodingclassics/#decl-quantumblockencoding-blockencodingclassics-partialpermutationcertificate). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.oneTermLCU" (lean := "QuantumBlockEncoding.BlockEncodingClassics.oneTermLCU")
*Plain-English reading.* This definition gives the library's named construction or computation for “one term lcu”. One-term LCU leaf.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* One-term LCU leaf. It is mathematically trivial, but useful for proof-DAG normalization: when an LCU population collapses to one term, the selected block is just that term.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:679](../../../../library/modules/blockencodingclassics/#decl-quantumblockencoding-blockencodingclassics-onetermlcu). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.oneTermLCU_cleanBlock" (lean := "QuantumBlockEncoding.BlockEncodingClassics.oneTermLCU_cleanBlock")
*Plain-English reading.* Lean checks the proposition indexed as “one term lcu clean block”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:682](../../../../library/modules/blockencodingclassics/#decl-quantumblockencoding-blockencodingclassics-onetermlcu-cleanblock). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.matrixScale" (lean := "QuantumBlockEncoding.BlockEncodingClassics.matrixScale")
*Plain-English reading.* This definition gives the library's named construction or computation for “matrix scale”. Pointwise scalar multiplication for the project-local matrix backend.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* Pointwise scalar multiplication for the project-local matrix backend.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:689](../../../../library/modules/blockencodingclassics/#decl-quantumblockencoding-blockencodingclassics-matrixscale). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.matrixAdd" (lean := "QuantumBlockEncoding.BlockEncodingClassics.matrixAdd")
*Plain-English reading.* This definition gives the library's named construction or computation for “matrix add”. Pointwise addition for the project-local matrix backend.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* Pointwise addition for the project-local matrix backend.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:693](../../../../library/modules/blockencodingclassics/#decl-quantumblockencoding-blockencodingclassics-matrixadd). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.weightedSum2" (lean := "QuantumBlockEncoding.BlockEncodingClassics.weightedSum2")
*Plain-English reading.* This definition gives the library's named construction or computation for “weighted sum 2”. Two-term weighted sum, the finite clean-block algebra behind a 2-term LCU.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* Two-term weighted sum, the finite clean-block algebra behind a 2-term LCU.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:697](../../../../library/modules/blockencodingclassics/#decl-quantumblockencoding-blockencodingclassics-weightedsum2). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.weightedSum2_entry" (lean := "QuantumBlockEncoding.BlockEncodingClassics.weightedSum2_entry")
*Plain-English reading.* Lean checks the proposition indexed as “weighted sum 2 entry”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:701](../../../../library/modules/blockencodingclassics/#decl-quantumblockencoding-blockencodingclassics-weightedsum2-entry). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.weightedSum2_congr_pointwise" (lean := "QuantumBlockEncoding.BlockEncodingClassics.weightedSum2_congr_pointwise")
*Plain-English reading.* Lean checks the proposition indexed as “weighted sum 2 congr pointwise”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:707](../../../../library/modules/blockencodingclassics/#decl-quantumblockencoding-blockencodingclassics-weightedsum2-congr-pointwise). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.LCUCertificate" (lean := "QuantumBlockEncoding.BlockEncodingClassics.LCUCertificate")
*Plain-English reading.* This record groups the data and proof fields needed for “lcu certificate”. A proposition-valued field is a requirement until a constructor supplies it. Proof-carrying LCU contract.

*Formal status.* Data contract in the default import surface; proposition-valued fields are obligations, not automatically established facts.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* Proof-carrying LCU contract. Full PREPARE-SELECT algebra can later instantiate 'cleanBlock'; downstream arithmetic should only depend on the exposed 'blockProof'.

*Declaration kind.* structure.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:722](../../../../library/modules/blockencodingclassics/#decl-quantumblockencoding-blockencodingclassics-lcucertificate). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.LCUCertificate.correct" (lean := "QuantumBlockEncoding.BlockEncodingClassics.LCUCertificate.correct")
*Plain-English reading.* Lean checks the proposition indexed as “correct”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:731](../../../../library/modules/blockencodingclassics/#decl-quantumblockencoding-blockencodingclassics-lcucertificate-correct). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.twoTermLCUCertificate" (lean := "QuantumBlockEncoding.BlockEncodingClassics.twoTermLCUCertificate")
*Plain-English reading.* This definition gives the library's named construction or computation for “two term lcu certificate”. Two-term LCU arithmetic after both selected clean blocks have already been proved.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* Two-term LCU arithmetic after both selected clean blocks have already been proved. Full PREPARE-SELECT-PREPARE dagger semantics should instantiate this leaf after proving the selected clean block equals the weighted sum.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:743](../../../../library/modules/blockencodingclassics/#decl-quantumblockencoding-blockencodingclassics-twotermlcucertificate). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.twoTermLCUCertificate_cleanBlock_entry" (lean := "QuantumBlockEncoding.BlockEncodingClassics.twoTermLCUCertificate_cleanBlock_entry")
*Plain-English reading.* Lean checks the proposition indexed as “two term lcu certificate clean block entry”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:754](../../../../library/modules/blockencodingclassics/#decl-quantumblockencoding-blockencodingclassics-twotermlcucertificate-cleanblock-entry). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.ExactCleanBlock.toLCUCertificate" (lean := "QuantumBlockEncoding.BlockEncodingClassics.ExactCleanBlock.toLCUCertificate")
*Plain-English reading.* This definition gives the library's named construction or computation for “to lcu certificate”. Promote an exact clean-block certificate to the LCU-style arithmetic layer.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* Promote an exact clean-block certificate to the LCU-style arithmetic layer.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:764](../../../../library/modules/blockencodingclassics/#decl-quantumblockencoding-blockencodingclassics-exactcleanblock-tolcucertificate). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.matrix_mul_congr_pointwise" (lean := "QuantumBlockEncoding.BlockEncodingClassics.matrix_mul_congr_pointwise")
*Plain-English reading.* Lean checks the proposition indexed as “matrix mul congr pointwise”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:792](../../../../library/modules/blockencodingclassics/#decl-quantumblockencoding-blockencodingclassics-matrix-mul-congr-pointwise). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.productCleanBlockCertificate" (lean := "QuantumBlockEncoding.BlockEncodingClassics.productCleanBlockCertificate")
*Plain-English reading.* This definition gives the library's named construction or computation for “product clean block certificate”. Exact product certificate for already-extracted clean blocks.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* Exact product certificate for already-extracted clean blocks.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:800](../../../../library/modules/blockencodingclassics/#decl-quantumblockencoding-blockencodingclassics-productcleanblockcertificate). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.productExactCleanBlockCertificate" (lean := "QuantumBlockEncoding.BlockEncodingClassics.productExactCleanBlockCertificate")
*Plain-English reading.* This definition gives the library's named construction or computation for “product exact clean block certificate”. Product bridge for exact clean-block certificates via the arithmetic layer.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* Product bridge for exact clean-block certificates via the arithmetic layer.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:811](../../../../library/modules/blockencodingclassics/#decl-quantumblockencoding-blockencodingclassics-productexactcleanblockcertificate). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.tensorResourceCost" (lean := "QuantumBlockEncoding.BlockEncodingClassics.tensorResourceCost")
*Plain-English reading.* This definition gives the library's named construction or computation for “tensor resource cost”. Tensor-style resource score: parallel depth is the maximum of two depths.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* Tensor-style resource score: parallel depth is the maximum of two depths.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:819](../../../../library/modules/blockencodingclassics/#decl-quantumblockencoding-blockencodingclassics-tensorresourcecost). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.tensorResourceCost_gateCount" (lean := "QuantumBlockEncoding.BlockEncodingClassics.tensorResourceCost_gateCount")
*Plain-English reading.* Lean checks the proposition indexed as “tensor resource cost gate count”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:825](../../../../library/modules/blockencodingclassics/#decl-quantumblockencoding-blockencodingclassics-tensorresourcecost-gatecount). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.tensorResourceCost_depth" (lean := "QuantumBlockEncoding.BlockEncodingClassics.tensorResourceCost_depth")
*Plain-English reading.* Lean checks the proposition indexed as “tensor resource cost depth”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:828](../../../../library/modules/blockencodingclassics/#decl-quantumblockencoding-blockencodingclassics-tensorresourcecost-depth). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.productResourceCost" (lean := "QuantumBlockEncoding.BlockEncodingClassics.productResourceCost")
*Plain-English reading.* This definition gives the library's named construction or computation for “product resource cost”. Product-style resource score: sequential depth adds.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* Product-style resource score: sequential depth adds.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:832](../../../../library/modules/blockencodingclassics/#decl-quantumblockencoding-blockencodingclassics-productresourcecost). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.productResourceCost_depth" (lean := "QuantumBlockEncoding.BlockEncodingClassics.productResourceCost_depth")
*Plain-English reading.* Lean checks the proposition indexed as “product resource cost depth”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:838](../../../../library/modules/blockencodingclassics/#decl-quantumblockencoding-blockencodingclassics-productresourcecost-depth). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.HermitianDilationContract" (lean := "QuantumBlockEncoding.BlockEncodingClassics.HermitianDilationContract")
*Plain-English reading.* This record groups the data and proof fields needed for “hermitian dilation contract”. A proposition-valued field is a requirement until a constructor supplies it. Hermitian-dilation target shape.

*Formal status.* Data contract in the default import surface; proposition-valued fields are obligations, not automatically established facts.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* Hermitian-dilation target shape. The complete block-matrix construction will live in a richer matrix backend; the important reusable Lean leaf is that a non-Hermitian target is explicitly converted into a named downstream target, not silently treated as Hermitian.

*Declaration kind.* structure.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:847](../../../../library/modules/blockencodingclassics/#decl-quantumblockencoding-blockencodingclassics-hermitiandilationcontract). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.QSVTConsumerContract" (lean := "QuantumBlockEncoding.BlockEncodingClassics.QSVTConsumerContract")
*Plain-English reading.* This record groups the data and proof fields needed for “qsvt consumer contract”. A proposition-valued field is a requirement until a constructor supplies it. QSVT consumer contract.

*Formal status.* Data contract in the default import surface; proposition-valued fields are obligations, not automatically established facts.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* QSVT consumer contract. QSVT is deliberately downstream of a proved block encoding: this record cannot be built without an input block certificate.

*Declaration kind.* structure.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:857](../../../../library/modules/blockencodingclassics/#decl-quantumblockencoding-blockencodingclassics-qsvtconsumercontract). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.ZeroErrorApproxCleanBlock" (lean := "QuantumBlockEncoding.BlockEncodingClassics.ZeroErrorApproxCleanBlock")
*Plain-English reading.* This record groups the data and proof fields needed for “zero error approx clean block”. A proposition-valued field is a requirement until a constructor supplies it. Zero-error approximate incumbent at the clean-block level.

*Formal status.* Data contract in the default import surface; proposition-valued fields are obligations, not automatically established facts.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* Zero-error approximate incumbent at the clean-block level.

*Declaration kind.* structure.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:866](../../../../library/modules/blockencodingclassics/#decl-quantumblockencoding-blockencodingclassics-zeroerrorapproxcleanblock). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.exactAsZeroErrorApproxCleanBlock" (lean := "QuantumBlockEncoding.BlockEncodingClassics.exactAsZeroErrorApproxCleanBlock")
*Plain-English reading.* This definition gives the library's named construction or computation for “exact as zero error approx clean block”. Any exact clean-block certificate can be used as a zero-error approximate incumbent in the adaptive exact-to-approximate ABEIS policy.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* Any exact clean-block certificate can be used as a zero-error approximate incumbent in the adaptive exact-to-approximate ABEIS policy.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:877](../../../../library/modules/blockencodingclassics/#decl-quantumblockencoding-blockencodingclassics-exactaszeroerrorapproxcleanblock). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.exactAsZeroErrorApproxCleanBlock_bound" (lean := "QuantumBlockEncoding.BlockEncodingClassics.exactAsZeroErrorApproxCleanBlock_bound")
*Plain-English reading.* Lean checks the proposition indexed as “exact as zero error approx clean block bound”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Reusable band-address, permutation, sparse, LCU, product, dilation, and QSVT-facing block-encoding routes.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/BlockEncodingClassics.lean:885](../../../../library/modules/blockencodingclassics/#decl-quantumblockencoding-blockencodingclassics-exactaszeroerrorapproxcleanblock-bound). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

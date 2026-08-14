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

#doc (Manual) "Declaration catalog: Semantics" =>
%%%
file := "catalog-semantics"
%%%

This chapter is generated from the Lean source. Every node denotes one explicit public
declaration, and every Lean link is checked during the Blueprint build. Definitions appear
in source order before later results whenever the source module does so.

Reader orientation: Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection. Each card separates an accessible
reading cue from formal status, the source docstring, and the authoritative Lean panel.
The standalone Library Explorer adds full-text search and filters across every chapter.

# QuantumBlockEncoding/CircuitSemantics.lean

41 explicit public declarations, in source order.

:::definition "QuantumBlockEncoding.qubitDim" (lean := "QuantumBlockEncoding.qubitDim")
*Plain-English reading.* This definition gives the library's named construction or computation for “qubit dim”. A finite-dimensional basis size for an 'n'-qubit register.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* A finite-dimensional basis size for an 'n'-qubit register.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:16](../../../../library/modules/circuitsemantics/#decl-quantumblockencoding-qubitdim). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.SemanticObligation" (lean := "QuantumBlockEncoding.SemanticObligation")
*Plain-English reading.* This record groups the data and proof fields needed for “semantic obligation”. A proposition-valued field is a requirement until a constructor supplies it. Structured semantic obligation for the matrix layer.

*Formal status.* Data contract in the default import surface; proposition-valued fields are obligations, not automatically established facts.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* Structured semantic obligation for the matrix layer. This mirrors 'GHL2025.ObligationRecord' without importing 'GHL2025', so the semantics backend can stay below paper-specific files in the import graph.

*Declaration kind.* structure.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:25](../../../../library/modules/circuitsemantics/#decl-quantumblockencoding-semanticobligation). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.GateMatrix" (lean := "QuantumBlockEncoding.GateMatrix")
*Plain-English reading.* This record groups the data and proof fields needed for “gate matrix”. A proposition-valued field is a requirement until a constructor supplies it. One gate together with its matrix on the full 'qubits'-qubit Hilbert space.

*Formal status.* Data contract in the default import surface; proposition-valued fields are obligations, not automatically established facts.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* One gate together with its matrix on the full 'qubits'-qubit Hilbert space. The matrix is supplied by a lower-level certificate for the gate family.

*Declaration kind.* structure.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:35](../../../../library/modules/circuitsemantics/#decl-quantumblockencoding-gatematrix). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.gateMatricesMatchCircuit" (lean := "QuantumBlockEncoding.gateMatricesMatchCircuit")
*Plain-English reading.* This definition gives the library's named construction or computation for “gate matrices match circuit”. Check that a list of gate matrices labels exactly the same circuit gates.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* Check that a list of gate matrices labels exactly the same circuit gates.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:41](../../../../library/modules/circuitsemantics/#decl-quantumblockencoding-gatematricesmatchcircuit). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.evalGateMatrices" (lean := "QuantumBlockEncoding.evalGateMatrices")
*Plain-English reading.* This definition gives the library's named construction or computation for “eval gate matrices”. Evaluate a list of full-space gate matrices to a circuit matrix.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* Evaluate a list of full-space gate matrices to a circuit matrix. The fold uses the usual right-action convention for a circuit list '\[g₁, g₂, ...\]': the resulting matrix is 'g\_k \* ... \* g₂ \* g₁'.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:54](../../../../library/modules/circuitsemantics/#decl-quantumblockencoding-evalgatematrices). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.Matrix.evalWith_foldl_add_mul" (lean := "QuantumBlockEncoding.Matrix.evalWith_foldl_add_mul")
*Plain-English reading.* Lean checks the proposition indexed as “eval with foldl add mul”; the hypotheses and conclusion in the code panel fix its exact scope. Evaluate one symbolic matrix-product entry as a concrete finite Rat fold.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* Evaluate one symbolic matrix-product entry as a concrete finite Rat fold. The project-local 'Coeff' matrices are syntactic, so a raw 'Matrix.mul' entry does not simplify away zero summands. This lemma moves the finite product entry through 'Coeff.evalWith', where later path-isolation proofs can use ordinary rational arithmetic without expanding the whole symbolic expression.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:71](../../../../library/modules/circuitsemantics/#decl-quantumblockencoding-matrix-evalwith-foldl-add-mul). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.Matrix.evalWith_mul_apply" (lean := "QuantumBlockEncoding.Matrix.evalWith_mul_apply")
*Plain-English reading.* Lean checks the proposition indexed as “eval with mul apply”; the hypotheses and conclusion in the code panel fix its exact scope. Evaluate one entry of 'Matrix.mul' by evaluating each path contribution.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* Evaluate one entry of 'Matrix.mul' by evaluating each path contribution. This is the local matrix-semantics block needed before a focused Robin seven-gate path proof can avoid syntactic 'Coeff.add' blow-up.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:92](../../../../library/modules/circuitsemantics/#decl-quantumblockencoding-matrix-evalwith-mul-apply). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.Matrix.evalWith_mul_eq_zero_of_all_paths_zero" (lean := "QuantumBlockEncoding.Matrix.evalWith_mul_eq_zero_of_all_paths_zero")
*Plain-English reading.* Lean checks the proposition indexed as “eval with mul eq zero of all paths zero”; the hypotheses and conclusion in the code panel fix its exact scope. Evaluate one matrix-product entry as zero when every evaluated path contribution is zero.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* Evaluate one matrix-product entry as zero when every evaluated path contribution is zero. This is the zero-support companion to 'evalWith\_mul\_unique\_path'. It lets paper-specific product proofs avoid expanding a large symbolic 'Coeff' fold when they have already isolated gate-local support facts.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:131](../../../../library/modules/circuitsemantics/#decl-quantumblockencoding-matrix-evalwith-mul-eq-zero-of-all-paths-zero). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.Matrix.evalWith_mul_unique_path" (lean := "QuantumBlockEncoding.Matrix.evalWith_mul_unique_path")
*Plain-English reading.* Lean checks the proposition indexed as “eval with mul unique path”; the hypotheses and conclusion in the code panel fix its exact scope. Evaluate one matrix-product entry when all evaluated paths except 'k0' vanish.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* Evaluate one matrix-product entry when all evaluated paths except 'k0' vanish. This is the reusable path-isolation block for later Robin gamma3 work: a theorem about the seven-gate product can first prove zero-support facts for all unwanted intermediate states, then reduce the evaluated product to the single surviving contribution.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:304](../../../../library/modules/circuitsemantics/#decl-quantumblockencoding-matrix-evalwith-mul-unique-path). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.Matrix.evalWith_mul_two_path" (lean := "QuantumBlockEncoding.Matrix.evalWith_mul_two_path")
*Plain-English reading.* Lean checks the proposition indexed as “eval with mul two path”; the hypotheses and conclusion in the code panel fix its exact scope. Evaluate one matrix-product entry when all evaluated paths except 'k0' and 'k1' vanish.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* Evaluate one matrix-product entry when all evaluated paths except 'k0' and 'k1' vanish. This is the two-path companion to 'evalWith\_mul\_unique\_path'. A seven-gate product proof can first establish that only two intermediate rows contribute, then reduce the evaluated product to their sum using this theorem.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:328](../../../../library/modules/circuitsemantics/#decl-quantumblockencoding-matrix-evalwith-mul-two-path). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.Matrix.evalWith_mul_identity_right_apply" (lean := "QuantumBlockEncoding.Matrix.evalWith_mul_identity_right_apply")
*Plain-English reading.* Lean checks the proposition indexed as “eval with mul identity right apply”; the hypotheses and conclusion in the code panel fix its exact scope. Evaluating a symbolic matrix after multiplying on the right by the identity recovers the evaluated entry.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* Evaluating a symbolic matrix after multiplying on the right by the identity recovers the evaluated entry. The statement is evaluation-level, not syntactic: 'Coeff' deliberately stores matrix products as explicit fold expressions, so the raw 'Coeff' term still contains zero summands.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:355](../../../../library/modules/circuitsemantics/#decl-quantumblockencoding-matrix-evalwith-mul-identity-right-apply). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.Matrix.cast_square_apply" (lean := "QuantumBlockEncoding.Matrix.cast_square_apply")
*Plain-English reading.* Lean checks the proposition indexed as “cast square apply”; the hypotheses and conclusion in the code panel fix its exact scope. Entry-level bridge for square matrix casts along a dimension equality.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* Entry-level bridge for square matrix casts along a dimension equality. This keeps paper-specific finite-entry proofs from unfolding a large casted matrix when the only content is that the row and column values are unchanged.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:371](../../../../library/modules/circuitsemantics/#decl-quantumblockencoding-matrix-cast-square-apply). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.evalWith_evalGateMatrices_single" (lean := "QuantumBlockEncoding.evalWith_evalGateMatrices_single")
*Plain-English reading.* Lean checks the proposition indexed as “eval with eval gate matrices single”; the hypotheses and conclusion in the code panel fix its exact scope. Evaluation-level single-gate reduction for 'evalGateMatrices'.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* Evaluation-level single-gate reduction for 'evalGateMatrices'. This is the entry helper for prepared composite gates: the matrix semantics of a singleton gate list evaluates to the supplied gate matrix entry, even though the underlying symbolic 'Coeff' expression is still a folded multiplication by the identity matrix.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:389](../../../../library/modules/circuitsemantics/#decl-quantumblockencoding-evalwith-evalgatematrices-single). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.CircuitMatrixSemantics" (lean := "QuantumBlockEncoding.CircuitMatrixSemantics")
*Plain-English reading.* This record groups the data and proof fields needed for “circuit matrix semantics”. A proposition-valued field is a requirement until a constructor supplies it. Circuit-level matrix semantics assembled from gate-level matrices.

*Formal status.* Data contract in the default import surface; proposition-valued fields are obligations, not automatically established facts.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* Circuit-level matrix semantics assembled from gate-level matrices. This does not certify that individual oracle matrices are correct; it gives the project a stable Lean target for composing those certificates once they exist.

*Declaration kind.* structure.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:404](../../../../library/modules/circuitsemantics/#decl-quantumblockencoding-circuitmatrixsemantics). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.CircuitMatrixSemantics.ofGateMatrices" (lean := "QuantumBlockEncoding.CircuitMatrixSemantics.ofGateMatrices")
*Plain-English reading.* This definition gives the library's named construction or computation for “of gate matrices”. Build circuit semantics directly from aligned gate matrices.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* Build circuit semantics directly from aligned gate matrices.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:415](../../../../library/modules/circuitsemantics/#decl-quantumblockencoding-circuitmatrixsemantics-ofgatematrices). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.PreparedCircuitEntryTarget" (lean := "QuantumBlockEncoding.PreparedCircuitEntryTarget")
*Plain-English reading.* This record groups the data and proof fields needed for “prepared circuit entry target”. A proposition-valued field is a requirement until a constructor supplies it. Typed target for relating an active circuit-matrix entry to a prepared composition entry.

*Formal status.* Data contract in the default import surface; proposition-valued fields are obligations, not automatically established facts.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* Typed target for relating an active circuit-matrix entry to a prepared composition entry. This is intentionally only an interface. It records the two matrix entries and the exact equality a paper-specific composition backend must prove; it does not assert that the active circuit already contains the prepared blocks.

*Declaration kind.* structure.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:436](../../../../library/modules/circuitsemantics/#decl-quantumblockencoding-preparedcircuitentrytarget). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.PreparedCircuitEntryTarget.entryEqualityStatement" (lean := "QuantumBlockEncoding.PreparedCircuitEntryTarget.entryEqualityStatement")
*Plain-English reading.* This definition gives the library's named construction or computation for “entry equality statement”. The prepared-composition equality required by the target.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The prepared-composition equality required by the target.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:454](../../../../library/modules/circuitsemantics/#decl-quantumblockencoding-preparedcircuitentrytarget-entryequalitystatement). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.PreparedCircuitEntryTarget.matrixEntryEqualityStatement" (lean := "QuantumBlockEncoding.PreparedCircuitEntryTarget.matrixEntryEqualityStatement")
*Plain-English reading.* This definition gives the library's named construction or computation for “matrix entry equality statement”. The same equality stated directly on the backing matrices.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The same equality stated directly on the backing matrices.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:459](../../../../library/modules/circuitsemantics/#decl-quantumblockencoding-preparedcircuitentrytarget-matrixentryequalitystatement). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.PreparedCircuitEntryTarget.entryEqualityStatement_iff_matrixEntryEqualityStatement" (lean := "QuantumBlockEncoding.PreparedCircuitEntryTarget.entryEqualityStatement_iff_matrixEntryEqualityStatement")
*Plain-English reading.* Lean checks the proposition indexed as “entry equality statement iff matrix entry equality statement”; the hypotheses and conclusion in the code panel fix its exact scope. The cached entry equality is equivalent to the backing matrix-entry equality.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The cached entry equality is equivalent to the backing matrix-entry equality. Paper-specific targets can prove whichever side their local backend exposes without changing the semantic obligation being tracked.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:470](../../../../library/modules/circuitsemantics/#decl-quantumblockencoding-preparedcircuitentrytarget-entryequalitystatement-iff-matrixentryequalitystatement). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.BlockExtractionTarget" (lean := "QuantumBlockEncoding.BlockExtractionTarget")
*Plain-English reading.* This record groups the data and proof fields needed for “block extraction target”. A proposition-valued field is a requirement until a constructor supplies it. A paper-level block-extraction target against a concrete circuit matrix.

*Formal status.* Data contract in the default import surface; proposition-valued fields are obligations, not automatically established facts.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* A paper-level block-extraction target against a concrete circuit matrix. The current project can now state the missing equation in matrix terms. The actual block projection from signal/system registers remains a later proof obligation, tracked explicitly by 'blockProjection' and 'blockCorrect'.

*Declaration kind.* structure.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:502](../../../../library/modules/circuitsemantics/#decl-quantumblockencoding-blockextractiontarget). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.blockExtractionBranchContributionSum" (lean := "QuantumBlockEncoding.blockExtractionBranchContributionSum")
*Plain-English reading.* This definition gives the library's named construction or computation for “block extraction branch contribution sum”. Fold a finite family of branch contributions into one projected block entry.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* Fold a finite family of branch contributions into one projected block entry. This is deliberately minimal: it provides a typed target for paper-specific projection/summation proofs without assuming commutativity, a ring structure, or a normal form for symbolic coefficients.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:520](../../../../library/modules/circuitsemantics/#decl-quantumblockencoding-blockextractionbranchcontributionsum). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.BlockExtractionBranchContributionTarget" (lean := "QuantumBlockEncoding.BlockExtractionBranchContributionTarget")
*Plain-English reading.* This record groups the data and proof fields needed for “block extraction branch contribution target”. A proposition-valued field is a requirement until a constructor supplies it. Typed interface for decomposing one block-extracted matrix entry into finite branch contributions.

*Formal status.* Data contract in the default import surface; proposition-valued fields are obligations, not automatically established facts.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* Typed interface for decomposing one block-extracted matrix entry into finite branch contributions. The interface records the candidate contribution family and the exact block-entry and branch-sum propositions that must be proved. It is not itself a proof that the family is sourced from the backend or that the branch sum equals the block entry; those remain explicit semantic obligations.

*Declaration kind.* structure.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:535](../../../../library/modules/circuitsemantics/#decl-quantumblockencoding-blockextractionbranchcontributiontarget). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.BlockExtractionBranchContributionTarget.selectedBranchStatement" (lean := "QuantumBlockEncoding.BlockExtractionBranchContributionTarget.selectedBranchStatement")
*Plain-English reading.* This definition gives the library's named construction or computation for “selected branch statement”. The selected-branch identity exposed by the target.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The selected-branch identity exposed by the target.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:559](../../../../library/modules/circuitsemantics/#decl-quantumblockencoding-blockextractionbranchcontributiontarget-selectedbranchstatement). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.BlockExtractionBranchContributionTarget.projectionSummationStatement" (lean := "QuantumBlockEncoding.BlockExtractionBranchContributionTarget.projectionSummationStatement")
*Plain-English reading.* This definition gives the library's named construction or computation for “projection summation statement”. The projection/summation theorem still required for the target.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The projection/summation theorem still required for the target.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:569](../../../../library/modules/circuitsemantics/#decl-quantumblockencoding-blockextractionbranchcontributiontarget-projectionsummationstatement). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.BlockExtractionBranchContributionTarget.backendExpansionStatement" (lean := "QuantumBlockEncoding.BlockExtractionBranchContributionTarget.backendExpansionStatement")
*Plain-English reading.* This definition gives the library's named construction or computation for “backend expansion statement”. The backend expansion theorem needed to close 'projectionSummationStatement'.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The backend expansion theorem needed to close 'projectionSummationStatement'. This version is stated directly in terms of the extraction target's block matrix entry and the candidate branch-contribution fold. It is useful as a proof-DAG interface because paper-specific projection backends can target this statement without depending on the record's cached 'blockEntry' and 'branchSum' fields.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:586](../../../../library/modules/circuitsemantics/#decl-quantumblockencoding-blockextractionbranchcontributiontarget-backendexpansionstatement). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.BlockExtractionBranchContributionTarget.selectedBranchStatement_of_eq" (lean := "QuantumBlockEncoding.BlockExtractionBranchContributionTarget.selectedBranchStatement_of_eq")
*Plain-English reading.* Lean checks the proposition indexed as “selected branch statement of eq”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:595](../../../../library/modules/circuitsemantics/#decl-quantumblockencoding-blockextractionbranchcontributiontarget-selectedbranchstatement-of-eq). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.BlockExtractionBranchContributionTarget.projectionSummationStatement_iff_backendExpansionStatement" (lean := "QuantumBlockEncoding.BlockExtractionBranchContributionTarget.projectionSummationStatement_iff_backendExpansionStatement")
*Plain-English reading.* Lean checks the proposition indexed as “projection summation statement iff backend expansion statement”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:603](../../../../library/modules/circuitsemantics/#decl-quantumblockencoding-blockextractionbranchcontributiontarget-projectionsummationstatement-iff-backendexpansionstatement). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.BlockExtractionBranchContributionTarget.projectionSummationStatement_of_backendExpansionStatement" (lean := "QuantumBlockEncoding.BlockExtractionBranchContributionTarget.projectionSummationStatement_of_backendExpansionStatement")
*Plain-English reading.* Lean checks the proposition indexed as “projection summation statement of backend expansion statement”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:629](../../../../library/modules/circuitsemantics/#decl-quantumblockencoding-blockextractionbranchcontributiontarget-projectionsummationstatement-of-backendexpansionstatement). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.BlockExtractionBranchContributionTarget.backendExpansionStatement_of_projectionSummationStatement" (lean := "QuantumBlockEncoding.BlockExtractionBranchContributionTarget.backendExpansionStatement_of_projectionSummationStatement")
*Plain-English reading.* Lean checks the proposition indexed as “backend expansion statement of projection summation statement”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:640](../../../../library/modules/circuitsemantics/#decl-quantumblockencoding-blockextractionbranchcontributiontarget-backendexpansionstatement-of-projectionsummationstatement). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.CircuitBlockEncodingClaim" (lean := "QuantumBlockEncoding.CircuitBlockEncodingClaim")
*Plain-English reading.* This record groups the data and proof fields needed for “circuit block encoding claim”. A proposition-valued field is a requirement until a constructor supplies it. A circuit-level block encoding claim bundling a circuit matrix semantics with a block extraction target and a dimension compatibility proof.

*Formal status.* Data contract in the default import surface; proposition-valued fields are obligations, not automatically established facts.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* A circuit-level block encoding claim bundling a circuit matrix semantics with a block extraction target and a dimension compatibility proof. The 'blockCorrect' obligation tracks the main mathematical claim: (⟨signalIdx| ⊗ I) U (|signalIdx⟩ ⊗ I) = targetMatrix / normalizer. This does not assert the claim is true; it records what needs proving.

*Declaration kind.* structure.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:661](../../../../library/modules/circuitsemantics/#decl-quantumblockencoding-circuitblockencodingclaim). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.FiniteBlockCompositionContract" (lean := "QuantumBlockEncoding.FiniteBlockCompositionContract")
*Plain-English reading.* This record groups the data and proof fields needed for “finite block composition contract”. A proposition-valued field is a requirement until a constructor supplies it. Typed contract for a finite-dimensional LCU/block-composition step.

*Formal status.* Data contract in the default import surface; proposition-valued fields are obligations, not automatically established facts.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* Typed contract for a finite-dimensional LCU/block-composition step. This is intentionally contract-only: it states the exact matrix objects and obligations that a later theorem must connect, without treating a cited LCU result or a paper theorem as a Lean proof.

*Declaration kind.* structure.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:676](../../../../library/modules/circuitsemantics/#decl-quantumblockencoding-finiteblockcompositioncontract). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.signalSystemBlockRowIndex" (lean := "QuantumBlockEncoding.signalSystemBlockRowIndex")
*Plain-English reading.* This definition gives the library's named construction or computation for “signal system block row index”. Compound row index for a signal value and a system-row index.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* Compound row index for a signal value and a system-row index.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:696](../../../../library/modules/circuitsemantics/#decl-quantumblockencoding-signalsystemblockrowindex). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.signalSystemBlockColIndex" (lean := "QuantumBlockEncoding.signalSystemBlockColIndex")
*Plain-English reading.* This definition gives the library's named construction or computation for “signal system block col index”. Compound column index for a signal value and a system-column index.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* Compound column index for a signal value and a system-column index.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:700](../../../../library/modules/circuitsemantics/#decl-quantumblockencoding-signalsystemblockcolindex). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.signalSystemBlockRowIndex_zero" (lean := "QuantumBlockEncoding.signalSystemBlockRowIndex_zero")
*Plain-English reading.* Lean checks the proposition indexed as “signal system block row index zero”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:703](../../../../library/modules/circuitsemantics/#decl-quantumblockencoding-signalsystemblockrowindex-zero). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.signalSystemBlockColIndex_zero" (lean := "QuantumBlockEncoding.signalSystemBlockColIndex_zero")
*Plain-English reading.* Lean checks the proposition indexed as “signal system block col index zero”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:707](../../../../library/modules/circuitsemantics/#decl-quantumblockencoding-signalsystemblockcolindex-zero). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.signalSystemBlockRowIndex_lt" (lean := "QuantumBlockEncoding.signalSystemBlockRowIndex_lt")
*Plain-English reading.* Lean checks the proposition indexed as “signal system block row index lt”; the hypotheses and conclusion in the code panel fix its exact scope. The row compound index stays inside a signal × row matrix.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The row compound index stays inside a signal × row matrix.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:712](../../../../library/modules/circuitsemantics/#decl-quantumblockencoding-signalsystemblockrowindex-lt). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.signalSystemBlockColIndex_lt" (lean := "QuantumBlockEncoding.signalSystemBlockColIndex_lt")
*Plain-English reading.* Lean checks the proposition indexed as “signal system block col index lt”; the hypotheses and conclusion in the code panel fix its exact scope. The column compound index stays inside a signal × column matrix.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The column compound index stays inside a signal × column matrix.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:727](../../../../library/modules/circuitsemantics/#decl-quantumblockencoding-signalsystemblockcolindex-lt). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.signalSystemBlockProjection" (lean := "QuantumBlockEncoding.signalSystemBlockProjection")
*Plain-English reading.* This definition gives the library's named construction or computation for “signal system block projection”. Block projection: extract the '(signalIdx, signalIdx)' block from a signal × system matrix.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* Block projection: extract the '(signalIdx, signalIdx)' block from a signal × system matrix. Given a matrix M of size '(signalDim \* rows) × (signalDim \* cols)', the helpers 'signalSystemBlockRowIndex' and 'signalSystemBlockColIndex' map a pair '(i, j)' of system indices to the compound row and column indices in the full matrix that correspond to signal register value 'idx' and system indices '(i, j)'. The block '(⟨signalIdx| ⊗ I) M (|signalIdx⟩ ⊗ I)' is then: blockMatrix i j = M (signalIdx \* rows + i) (signalIdx \* cols + j)

*Declaration kind.* def.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:753](../../../../library/modules/circuitsemantics/#decl-quantumblockencoding-signalsystemblockprojection). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.signalSystemBlockProjection_apply" (lean := "QuantumBlockEncoding.signalSystemBlockProjection_apply")
*Plain-English reading.* Lean checks the proposition indexed as “signal system block projection apply”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:764](../../../../library/modules/circuitsemantics/#decl-quantumblockencoding-signalsystemblockprojection-apply). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.totalCircuitQubits" (lean := "QuantumBlockEncoding.totalCircuitQubits")
*Plain-English reading.* This definition gives the library's named construction or computation for “total circuit qubits”. Total qubits needed for a circuit operating on 'system' system qubits and 'signal' signal qubits.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* Total qubits needed for a circuit operating on 'system' system qubits and 'signal' signal qubits.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:778](../../../../library/modules/circuitsemantics/#decl-quantumblockencoding-totalcircuitqubits). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.CircuitMatrixSemantics.blockExtractionTarget" (lean := "QuantumBlockEncoding.CircuitMatrixSemantics.blockExtractionTarget")
*Plain-English reading.* This definition gives the library's named construction or computation for “block extraction target”. Build a BlockExtractionTarget from a CircuitMatrixSemantics by computing the block projection.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* Build a BlockExtractionTarget from a CircuitMatrixSemantics by computing the block projection. The circuit matrix is square with dimension 'signalDim \* dim', and we extract the '(signalIdx, signalIdx)' block.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:786](../../../../library/modules/circuitsemantics/#decl-quantumblockencoding-circuitmatrixsemantics-blockextractiontarget). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

# QuantumBlockEncoding/ConcreteSemantics.lean

22 explicit public declarations, in source order.

:::definition "QuantumBlockEncoding.ConcreteSemantics.FiniteMatrix" (lean := "QuantumBlockEncoding.ConcreteSemantics.FiniteMatrix")
*Plain-English reading.* This abbreviation gives a shorter name to the type or expression used for “finite matrix”. A Mathlib finite matrix, definitionally compatible with ABEIS 'Matrix'.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* A Mathlib finite matrix, definitionally compatible with ABEIS 'Matrix'.

*Declaration kind.* abbrev.

Source: [QuantumBlockEncoding/ConcreteSemantics.lean:25](../../../../library/modules/concretesemantics/#decl-quantumblockencoding-concretesemantics-finitematrix). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.ConcreteSemantics.StateVector" (lean := "QuantumBlockEncoding.ConcreteSemantics.StateVector")
*Plain-English reading.* This abbreviation gives a shorter name to the type or expression used for “state vector”. A finite column vector.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* A finite column vector.

*Declaration kind.* abbrev.

Source: [QuantumBlockEncoding/ConcreteSemantics.lean:29](../../../../library/modules/concretesemantics/#decl-quantumblockencoding-concretesemantics-statevector). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.ConcreteSemantics.basisKet" (lean := "QuantumBlockEncoding.ConcreteSemantics.basisKet")
*Plain-English reading.* This definition gives the library's named construction or computation for “basis ket”. A computational-basis ket in the concrete finite backend.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* A computational-basis ket in the concrete finite backend.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/ConcreteSemantics.lean:33](../../../../library/modules/concretesemantics/#decl-quantumblockencoding-concretesemantics-basisket). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.ConcreteSemantics.zeroKet" (lean := "QuantumBlockEncoding.ConcreteSemantics.zeroKet")
*Plain-English reading.* This definition gives the library's named construction or computation for “zero ket”. The all-zero computational-basis ket for an 'n'-qubit register.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The all-zero computational-basis ket for an 'n'-qubit register.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/ConcreteSemantics.lean:38](../../../../library/modules/concretesemantics/#decl-quantumblockencoding-concretesemantics-zeroket). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.ConcreteSemantics.applyVec" (lean := "QuantumBlockEncoding.ConcreteSemantics.applyVec")
*Plain-English reading.* This definition gives the library's named construction or computation for “apply vec”. Matrix-vector action using Mathlib's finite sum semantics.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* Matrix-vector action using Mathlib's finite sum semantics.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/ConcreteSemantics.lean:43](../../../../library/modules/concretesemantics/#decl-quantumblockencoding-concretesemantics-applyvec). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.ConcreteSemantics.ComplexUnitaryGate" (lean := "QuantumBlockEncoding.ConcreteSemantics.ComplexUnitaryGate")
*Plain-English reading.* This record groups the data and proof fields needed for “complex unitary gate”. A proposition-valued field is a requirement until a constructor supplies it. A finite complex gate whose unitarity is the standard Mathlib unitary-group predicate rather than an unconstrained proposition.

*Formal status.* Data contract in the default import surface; proposition-valued fields are obligations, not automatically established facts.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* A finite complex gate whose unitarity is the standard Mathlib unitary-group predicate rather than an unconstrained proposition.

*Declaration kind.* structure.

Source: [QuantumBlockEncoding/ConcreteSemantics.lean:52](../../../../library/modules/concretesemantics/#decl-quantumblockencoding-concretesemantics-complexunitarygate). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.ConcreteSemantics.applyVec_basisKet" (lean := "QuantumBlockEncoding.ConcreteSemantics.applyVec_basisKet")
*Plain-English reading.* Lean checks the proposition indexed as “apply vec basis ket”; the hypotheses and conclusion in the code panel fix its exact scope. Acting on a basis ket selects the corresponding matrix column.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* Acting on a basis ket selects the corresponding matrix column.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/ConcreteSemantics.lean:58](../../../../library/modules/concretesemantics/#decl-quantumblockencoding-concretesemantics-applyvec-basisket). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.ConcreteSemantics.applyVec_zeroKet" (lean := "QuantumBlockEncoding.ConcreteSemantics.applyVec_zeroKet")
*Plain-English reading.* Lean checks the proposition indexed as “apply vec zero ket”; the hypotheses and conclusion in the code panel fix its exact scope. Acting on the all-zero ket selects column zero.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* Acting on the all-zero ket selects column zero.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/ConcreteSemantics.lean:65](../../../../library/modules/concretesemantics/#decl-quantumblockencoding-concretesemantics-applyvec-zeroket). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.ConcreteSemantics.firstColumnMatches_iff_applyVec_zeroKet" (lean := "QuantumBlockEncoding.ConcreteSemantics.firstColumnMatches_iff_applyVec_zeroKet")
*Plain-English reading.* Lean checks the proposition indexed as “first column matches iff apply vec zero ket”; the hypotheses and conclusion in the code panel fix its exact scope. The ABEIS first-column contract is exactly the state-action equation 'U |0^n> = |psi>' in the concrete finite matrix backend.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The ABEIS first-column contract is exactly the state-action equation 'U |0^n> = |psi>' in the concrete finite matrix backend.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/ConcreteSemantics.lean:76](../../../../library/modules/concretesemantics/#decl-quantumblockencoding-concretesemantics-firstcolumnmatches-iff-applyvec-zeroket). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.ConcreteSemantics.ComplexStatePreparationCertificate" (lean := "QuantumBlockEncoding.ConcreteSemantics.ComplexStatePreparationCertificate")
*Plain-English reading.* This record groups the data and proof fields needed for “complex state preparation certificate”. A proposition-valued field is a requirement until a constructor supplies it. Concrete state-preparation evidence.

*Formal status.* Data contract in the default import surface; proposition-valued fields are obligations, not automatically established facts.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* Concrete state-preparation evidence. This is an optional final semantic layer: existing symbolic and rational candidates do not need to use it, but a complex candidate cannot enter this record without standard unitarity and state action.

*Declaration kind.* structure.

Source: [QuantumBlockEncoding/ConcreteSemantics.lean:95](../../../../library/modules/concretesemantics/#decl-quantumblockencoding-concretesemantics-complexstatepreparationcertificate). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.ConcreteSemantics.ComplexStatePreparationCertificate.candidate" (lean := "QuantumBlockEncoding.ConcreteSemantics.ComplexStatePreparationCertificate.candidate")
*Plain-English reading.* This definition gives the library's named construction or computation for “candidate”. Repackage concrete semantics in the existing generic candidate interface.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* Repackage concrete semantics in the existing generic candidate interface.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/ConcreteSemantics.lean:105](../../../../library/modules/concretesemantics/#decl-quantumblockencoding-concretesemantics-complexstatepreparationcertificate-candidate). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.ConcreteSemantics.ComplexStatePreparationCertificate.verified" (lean := "QuantumBlockEncoding.ConcreteSemantics.ComplexStatePreparationCertificate.verified")
*Plain-English reading.* This definition gives the library's named construction or computation for “verified”. Promote a concrete certificate to the existing verified wrapper.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* Promote a concrete certificate to the existing verified wrapper. The generic 'isUnitary' field is instantiated by, rather than substituted for, the Mathlib unitary-group predicate.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/ConcreteSemantics.lean:124](../../../../library/modules/concretesemantics/#decl-quantumblockencoding-concretesemantics-complexstatepreparationcertificate-verified). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.ConcreteSemantics.ComplexStatePreparationCertificate.preparesVector" (lean := "QuantumBlockEncoding.ConcreteSemantics.ComplexStatePreparationCertificate.preparesVector")
*Plain-English reading.* Lean checks the proposition indexed as “prepares vector”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/ConcreteSemantics.lean:137](../../../../library/modules/concretesemantics/#decl-quantumblockencoding-concretesemantics-complexstatepreparationcertificate-preparesvector). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.ConcreteSemantics.ProductRegisterMatrix" (lean := "QuantumBlockEncoding.ConcreteSemantics.ProductRegisterMatrix")
*Plain-English reading.* This abbreviation gives a shorter name to the type or expression used for “product register matrix”. A matrix indexed by an explicit signal-register/system-register product.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* A matrix indexed by an explicit signal-register/system-register product.

*Declaration kind.* abbrev.

Source: [QuantumBlockEncoding/ConcreteSemantics.lean:145](../../../../library/modules/concretesemantics/#decl-quantumblockencoding-concretesemantics-productregistermatrix). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.ConcreteSemantics.flatToProductRegister" (lean := "QuantumBlockEncoding.ConcreteSemantics.flatToProductRegister")
*Plain-English reading.* This definition gives the library's named construction or computation for “flat to product register”. View a flattened signal-system matrix through explicit product-register indices.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* View a flattened signal-system matrix through explicit product-register indices. The signal register is high-order and the system register low-order.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/ConcreteSemantics.lean:152](../../../../library/modules/concretesemantics/#decl-quantumblockencoding-concretesemantics-flattoproductregister). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.ConcreteSemantics.productRegisterBlockProjection" (lean := "QuantumBlockEncoding.ConcreteSemantics.productRegisterBlockProjection")
*Plain-English reading.* This definition gives the library's named construction or computation for “product register block projection”. Project one signal branch from an explicit product-register matrix.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* Project one signal branch from an explicit product-register matrix.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/ConcreteSemantics.lean:163](../../../../library/modules/concretesemantics/#decl-quantumblockencoding-concretesemantics-productregisterblockprojection). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.ConcreteSemantics.productRegisterBlockProjection_flatToProductRegister" (lean := "QuantumBlockEncoding.ConcreteSemantics.productRegisterBlockProjection_flatToProductRegister")
*Plain-English reading.* Lean checks the proposition indexed as “product register block projection flat to product register”; the hypotheses and conclusion in the code panel fix its exact scope. Product-register projection after viewing a flat matrix is definitionally the existing ABEIS flattened block projection.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* Product-register projection after viewing a flat matrix is definitionally the existing ABEIS flattened block projection.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/ConcreteSemantics.lean:172](../../../../library/modules/concretesemantics/#decl-quantumblockencoding-concretesemantics-productregisterblockprojection-flattoproductregister). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.ConcreteSemantics.productIndex_val_eq_signalSystemBlockRowIndex" (lean := "QuantumBlockEncoding.ConcreteSemantics.productIndex_val_eq_signalSystemBlockRowIndex")
*Plain-English reading.* Lean checks the proposition indexed as “product index val eq signal system block row index”; the hypotheses and conclusion in the code panel fix its exact scope. The classic product index and circuit-semantics row index have the same value.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The classic product index and circuit-semantics row index have the same value.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/ConcreteSemantics.lean:182](../../../../library/modules/concretesemantics/#decl-quantumblockencoding-concretesemantics-productindex-val-eq-signalsystemblockrowindex). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.ConcreteSemantics.signalSystemBlockProjection_eq_cleanBlockProduct" (lean := "QuantumBlockEncoding.ConcreteSemantics.signalSystemBlockProjection_eq_cleanBlockProduct")
*Plain-English reading.* Lean checks the proposition indexed as “signal system block projection eq clean block product”; the hypotheses and conclusion in the code panel fix its exact scope. The classic rational clean block and the generic circuit-semantics projection are the same pointwise matrix under the shared register order.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The classic rational clean block and the generic circuit-semantics projection are the same pointwise matrix under the shared register order.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/ConcreteSemantics.lean:194](../../../../library/modules/concretesemantics/#decl-quantumblockencoding-concretesemantics-signalsystemblockprojection-eq-cleanblockproduct). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.ConcreteSemantics.cleanBasisActionAmplitude" (lean := "QuantumBlockEncoding.ConcreteSemantics.cleanBasisActionAmplitude")
*Plain-English reading.* This definition gives the library's named construction or computation for “clean basis action amplitude”. The clean output amplitude obtained by applying 'operator' to a clean signal-system basis input.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The clean output amplitude obtained by applying 'operator' to a clean signal-system basis input. Naming this quantity makes the two common block-encoding proof styles explicit: prove the projected matrix block, or prove the clean branch of the action on every basis input.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/ConcreteSemantics.lean:211](../../../../library/modules/concretesemantics/#decl-quantumblockencoding-concretesemantics-cleanbasisactionamplitude). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.ConcreteSemantics.cleanBasisActionAmplitude_eq_signalSystemBlockProjection" (lean := "QuantumBlockEncoding.ConcreteSemantics.cleanBasisActionAmplitude_eq_signalSystemBlockProjection")
*Plain-English reading.* Lean checks the proposition indexed as “clean basis action amplitude eq signal system block projection”; the hypotheses and conclusion in the code panel fix its exact scope. Acting on a clean basis input and reading a clean output is one projected-block entry.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* Acting on a clean basis input and reading a clean output is one projected-block entry.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/ConcreteSemantics.lean:221](../../../../library/modules/concretesemantics/#decl-quantumblockencoding-concretesemantics-cleanbasisactionamplitude-eq-signalsystemblockprojection). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.ConcreteSemantics.pointwiseProjection_iff_cleanBasisAction" (lean := "QuantumBlockEncoding.ConcreteSemantics.pointwiseProjection_iff_cleanBasisAction")
*Plain-English reading.* Lean checks the proposition indexed as “pointwise projection iff clean basis action”; the hypotheses and conclusion in the code panel fix its exact scope. Finite-dimensional bridge between the projected-block definition and the clean-branch action proof.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* Finite-dimensional bridge between the projected-block definition and the clean-branch action proof. Linearity then extends the basis statement to an arbitrary system state; any normalized orthogonal failure branch is additional unitarity evidence, not a different block-encoding contract.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/ConcreteSemantics.lean:239](../../../../library/modules/concretesemantics/#decl-quantumblockencoding-concretesemantics-pointwiseprojection-iff-cleanbasisaction). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

# QuantumBlockEncoding/ModularAdder3.lean

22 explicit public declarations, in source order.

:::definition "QuantumBlockEncoding.primitiveXProgram" (lean := "QuantumBlockEncoding.primitiveXProgram")
*Plain-English reading.* This definition gives the library's named construction or computation for “primitive x program”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/ModularAdder3.lean:16](../../../../library/modules/modularadder3/#decl-quantumblockencoding-primitivexprogram). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.primitiveXProgram_eval" (lean := "QuantumBlockEncoding.primitiveXProgram_eval")
*Plain-English reading.* Lean checks the proposition indexed as “primitive x program eval”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/ModularAdder3.lean:21](../../../../library/modules/modularadder3/#decl-quantumblockencoding-primitivexprogram-eval). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.compileReversibleGate" (lean := "QuantumBlockEncoding.compileReversibleGate")
*Plain-English reading.* This definition gives the library's named construction or computation for “compile reversible gate”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/ModularAdder3.lean:31](../../../../library/modules/modularadder3/#decl-quantumblockencoding-compilereversiblegate). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.compileReversibleGate_eval" (lean := "QuantumBlockEncoding.compileReversibleGate_eval")
*Plain-English reading.* Lean checks the proposition indexed as “compile reversible gate eval”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/ModularAdder3.lean:40](../../../../library/modules/modularadder3/#decl-quantumblockencoding-compilereversiblegate-eval). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.compileReversibleProgram" (lean := "QuantumBlockEncoding.compileReversibleProgram")
*Plain-English reading.* This definition gives the library's named construction or computation for “compile reversible program”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/ModularAdder3.lean:52](../../../../library/modules/modularadder3/#decl-quantumblockencoding-compilereversibleprogram). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.compileReversibleProgram_eval" (lean := "QuantumBlockEncoding.compileReversibleProgram_eval")
*Plain-English reading.* Lean checks the proposition indexed as “compile reversible program eval”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/ModularAdder3.lean:58](../../../../library/modules/modularadder3/#decl-quantumblockencoding-compilereversibleprogram-eval). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.cleanC3XReversibleProgram" (lean := "QuantumBlockEncoding.cleanC3XReversibleProgram")
*Plain-English reading.* This definition gives the library's named construction or computation for “clean c 3 x reversible program”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/ModularAdder3.lean:75](../../../../library/modules/modularadder3/#decl-quantumblockencoding-cleanc3xreversibleprogram). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.cleanC3XBasisEquiv" (lean := "QuantumBlockEncoding.cleanC3XBasisEquiv")
*Plain-English reading.* This definition gives the library's named construction or computation for “clean c 3 x basis equiv”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/ModularAdder3.lean:88](../../../../library/modules/modularadder3/#decl-quantumblockencoding-cleanc3xbasisequiv). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.c3xBasisAction" (lean := "QuantumBlockEncoding.c3xBasisAction")
*Plain-English reading.* This definition gives the library's named construction or computation for “c 3 x basis action”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/ModularAdder3.lean:102](../../../../library/modules/modularadder3/#decl-quantumblockencoding-c3xbasisaction). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.cleanC3XBasisAction" (lean := "QuantumBlockEncoding.cleanC3XBasisAction")
*Plain-English reading.* Lean checks the proposition indexed as “clean c 3 x basis action”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/ModularAdder3.lean:109](../../../../library/modules/modularadder3/#decl-quantumblockencoding-cleanc3xbasisaction). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.cleanC3XWorkspaceClean" (lean := "QuantumBlockEncoding.cleanC3XWorkspaceClean")
*Plain-English reading.* Lean checks the proposition indexed as “clean c 3 x workspace clean”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/ModularAdder3.lean:143](../../../../library/modules/modularadder3/#decl-quantumblockencoding-cleanc3xworkspaceclean). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.cleanC3XPrimitiveProgram" (lean := "QuantumBlockEncoding.cleanC3XPrimitiveProgram")
*Plain-English reading.* This definition gives the library's named construction or computation for “clean c 3 x primitive program”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/ModularAdder3.lean:165](../../../../library/modules/modularadder3/#decl-quantumblockencoding-cleanc3xprimitiveprogram). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.cleanC3XPrimitiveProgram_eval" (lean := "QuantumBlockEncoding.cleanC3XPrimitiveProgram_eval")
*Plain-English reading.* Lean checks the proposition indexed as “clean c 3 x primitive program eval”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/ModularAdder3.lean:178](../../../../library/modules/modularadder3/#decl-quantumblockencoding-cleanc3xprimitiveprogram-eval). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.littleEndian3Value" (lean := "QuantumBlockEncoding.littleEndian3Value")
*Plain-English reading.* This definition gives the library's named construction or computation for “little endian 3 value”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/ModularAdder3.lean:198](../../../../library/modules/modularadder3/#decl-quantumblockencoding-littleendian3value). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.modularAdd3ReversibleProgram" (lean := "QuantumBlockEncoding.modularAdd3ReversibleProgram")
*Plain-English reading.* This definition gives the library's named construction or computation for “modular add 3 reversible program”. Wire order is 'a0,a1,a2,b0,b1,b2,work'.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* Wire order is 'a0,a1,a2,b0,b1,b2,work'.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/ModularAdder3.lean:203](../../../../library/modules/modularadder3/#decl-quantumblockencoding-modularadd3reversibleprogram). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.modularAdd3BasisEquiv" (lean := "QuantumBlockEncoding.modularAdd3BasisEquiv")
*Plain-English reading.* This definition gives the library's named construction or computation for “modular add 3 basis equiv”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/ModularAdder3.lean:214](../../../../library/modules/modularadder3/#decl-quantumblockencoding-modularadd3basisequiv). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.modularAdd3_cleanAction" (lean := "QuantumBlockEncoding.modularAdd3_cleanAction")
*Plain-English reading.* Lean checks the proposition indexed as “modular add 3 clean action”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/ModularAdder3.lean:217](../../../../library/modules/modularadder3/#decl-quantumblockencoding-modularadd3-cleanaction). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.modularAdd3PrimitiveProgram" (lean := "QuantumBlockEncoding.modularAdd3PrimitiveProgram")
*Plain-English reading.* This definition gives the library's named construction or computation for “modular add 3 primitive program”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/ModularAdder3.lean:227](../../../../library/modules/modularadder3/#decl-quantumblockencoding-modularadd3primitiveprogram). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.modularAdd3Primitive_eval" (lean := "QuantumBlockEncoding.modularAdd3Primitive_eval")
*Plain-English reading.* Lean checks the proposition indexed as “modular add 3 primitive eval”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/ModularAdder3.lean:230](../../../../library/modules/modularadder3/#decl-quantumblockencoding-modularadd3primitive-eval). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.modularAdd3Primitive_workspaceClean" (lean := "QuantumBlockEncoding.modularAdd3Primitive_workspaceClean")
*Plain-English reading.* Lean checks the proposition indexed as “modular add 3 primitive workspace clean”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/ModularAdder3.lean:235](../../../../library/modules/modularadder3/#decl-quantumblockencoding-modularadd3primitive-workspaceclean). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.modularAdd3Primitive_resource_faithful" (lean := "QuantumBlockEncoding.modularAdd3Primitive_resource_faithful")
*Plain-English reading.* Lean checks the proposition indexed as “modular add 3 primitive resource faithful”; the hypotheses and conclusion in the code panel fix its exact scope. The resource is definitionally computed from the emitted primitive list.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The resource is definitionally computed from the emitted primitive list.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/ModularAdder3.lean:241](../../../../library/modules/modularadder3/#decl-quantumblockencoding-modularadd3primitive-resource-faithful). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.modularAdd3Primitive_oracleCalls_eq_zero" (lean := "QuantumBlockEncoding.modularAdd3Primitive_oracleCalls_eq_zero")
*Plain-English reading.* Lean checks the proposition indexed as “modular add 3 primitive oracle calls eq zero”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/ModularAdder3.lean:245](../../../../library/modules/modularadder3/#decl-quantumblockencoding-modularadd3primitive-oraclecalls-eq-zero). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

# QuantumBlockEncoding/PrimitiveBasisLE.lean

8 explicit public declarations, in source order.

:::definition "QuantumBlockEncoding.primitiveBasisLEEquiv" (lean := "QuantumBlockEncoding.primitiveBasisLEEquiv")
*Plain-English reading.* This definition gives the library's named construction or computation for “primitive basis le equiv”. Convert named primitive bits to a flat little-endian matrix index.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* Convert named primitive bits to a flat little-endian matrix index.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/PrimitiveBasisLE.lean:15](../../../../library/modules/primitivebasisle/#decl-quantumblockencoding-primitivebasisleequiv). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.primitiveBasisLEEquiv_zero_apply" (lean := "QuantumBlockEncoding.primitiveBasisLEEquiv_zero_apply")
*Plain-English reading.* Lean checks the proposition indexed as “primitive basis le equiv zero apply”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/PrimitiveBasisLE.lean:28](../../../../library/modules/primitivebasisle/#decl-quantumblockencoding-primitivebasisleequiv-zero-apply). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.primitiveBasisLEEquiv_succ_value" (lean := "QuantumBlockEncoding.primitiveBasisLEEquiv_succ_value")
*Plain-English reading.* Lean checks the proposition indexed as “primitive basis le equiv succ value”; the hypotheses and conclusion in the code panel fix its exact scope. The recursive equation makes the little-endian convention inspectable.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The recursive equation makes the little-endian convention inspectable.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/PrimitiveBasisLE.lean:33](../../../../library/modules/primitivebasisle/#decl-quantumblockencoding-primitivebasisleequiv-succ-value). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.primitiveBasisLEEquiv_six_value" (lean := "QuantumBlockEncoding.primitiveBasisLEEquiv_six_value")
*Plain-English reading.* Lean checks the proposition indexed as “primitive basis le equiv six value”; the hypotheses and conclusion in the code panel fix its exact scope. Six-wire expansion used by the fixed Robin executable benchmark.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* Six-wire expansion used by the fixed Robin executable benchmark.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/PrimitiveBasisLE.lean:41](../../../../library/modules/primitivebasisle/#decl-quantumblockencoding-primitivebasisleequiv-six-value). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.primitiveBits3LE" (lean := "QuantumBlockEncoding.primitiveBits3LE")
*Plain-English reading.* This definition gives the library's named construction or computation for “primitive bits 3 le”. Explicit inverse used by finite three-wire compiler proofs.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* Explicit inverse used by finite three-wire compiler proofs.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/PrimitiveBasisLE.lean:48](../../../../library/modules/primitivebasisle/#decl-quantumblockencoding-primitivebits3le). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.primitiveBasisLEEquiv_three_symm" (lean := "QuantumBlockEncoding.primitiveBasisLEEquiv_three_symm")
*Plain-English reading.* Lean checks the proposition indexed as “primitive basis le equiv three symm”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/PrimitiveBasisLE.lean:53](../../../../library/modules/primitivebasisle/#decl-quantumblockencoding-primitivebasisleequiv-three-symm). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.primitiveBits3LEWithout" (lean := "QuantumBlockEncoding.primitiveBits3LEWithout")
*Plain-English reading.* This definition gives the library's named construction or computation for “primitive bits 3 le without”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/PrimitiveBasisLE.lean:57](../../../../library/modules/primitivebasisle/#decl-quantumblockencoding-primitivebits3lewithout). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.splitPrimitiveWire_primitiveBits3LE_context_eq" (lean := "QuantumBlockEncoding.splitPrimitiveWire_primitiveBits3LE_context_eq")
*Plain-English reading.* Lean checks the proposition indexed as “split primitive wire primitive bits 3 le context eq”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/PrimitiveBasisLE.lean:63](../../../../library/modules/primitivebasisle/#decl-quantumblockencoding-splitprimitivewire-primitivebits3le-context-eq). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

# QuantumBlockEncoding/PrimitiveCircuit.lean

39 explicit public declarations, in source order.

:::definition "QuantumBlockEncoding.ExactAngle" (lean := "QuantumBlockEncoding.ExactAngle")
*Plain-English reading.* This type lists the allowed alternatives for “exact angle”; its constructors are the cases that downstream code must handle.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* inductive.

Source: [QuantumBlockEncoding/PrimitiveCircuit.lean:17](../../../../library/modules/primitivecircuit/#decl-quantumblockencoding-exactangle). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.ExactAngle.eval" (lean := "QuantumBlockEncoding.ExactAngle.eval")
*Plain-English reading.* This definition gives the library's named construction or computation for “eval”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/PrimitiveCircuit.lean:31](../../../../library/modules/primitivecircuit/#decl-quantumblockencoding-exactangle-eval). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.ExactAngle.eval_add" (lean := "QuantumBlockEncoding.ExactAngle.eval_add")
*Plain-English reading.* Lean checks the proposition indexed as “eval add”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/PrimitiveCircuit.lean:41](../../../../library/modules/primitivecircuit/#decl-quantumblockencoding-exactangle-eval-add). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.ExactAngle.eval_neg" (lean := "QuantumBlockEncoding.ExactAngle.eval_neg")
*Plain-English reading.* Lean checks the proposition indexed as “eval neg”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/PrimitiveCircuit.lean:44](../../../../library/modules/primitivecircuit/#decl-quantumblockencoding-exactangle-eval-neg). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.ExactAngle.eval_scale" (lean := "QuantumBlockEncoding.ExactAngle.eval_scale")
*Plain-English reading.* Lean checks the proposition indexed as “eval scale”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/PrimitiveCircuit.lean:47](../../../../library/modules/primitivecircuit/#decl-quantumblockencoding-exactangle-eval-scale). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.ExactAngle.sub" (lean := "QuantumBlockEncoding.ExactAngle.sub")
*Plain-English reading.* This definition gives the library's named construction or computation for “sub”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/PrimitiveCircuit.lean:50](../../../../library/modules/primitivecircuit/#decl-quantumblockencoding-exactangle-sub). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.ExactAngle.halfAdd" (lean := "QuantumBlockEncoding.ExactAngle.halfAdd")
*Plain-English reading.* This definition gives the library's named construction or computation for “half add”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/PrimitiveCircuit.lean:53](../../../../library/modules/primitivecircuit/#decl-quantumblockencoding-exactangle-halfadd). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.ExactAngle.halfSub" (lean := "QuantumBlockEncoding.ExactAngle.halfSub")
*Plain-English reading.* This definition gives the library's named construction or computation for “half sub”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/PrimitiveCircuit.lean:56](../../../../library/modules/primitivecircuit/#decl-quantumblockencoding-exactangle-halfsub). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.ExactAngle.eval_sub" (lean := "QuantumBlockEncoding.ExactAngle.eval_sub")
*Plain-English reading.* Lean checks the proposition indexed as “eval sub”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/PrimitiveCircuit.lean:59](../../../../library/modules/primitivecircuit/#decl-quantumblockencoding-exactangle-eval-sub). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.ExactAngle.eval_half_add" (lean := "QuantumBlockEncoding.ExactAngle.eval_half_add")
*Plain-English reading.* Lean checks the proposition indexed as “eval half add”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/PrimitiveCircuit.lean:63](../../../../library/modules/primitivecircuit/#decl-quantumblockencoding-exactangle-eval-half-add). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.ExactAngle.eval_half_sub" (lean := "QuantumBlockEncoding.ExactAngle.eval_half_sub")
*Plain-English reading.* Lean checks the proposition indexed as “eval half sub”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/PrimitiveCircuit.lean:70](../../../../library/modules/primitivecircuit/#decl-quantumblockencoding-exactangle-eval-half-sub). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.PrimitiveGate" (lean := "QuantumBlockEncoding.PrimitiveGate")
*Plain-English reading.* This type lists the allowed alternatives for “primitive gate”; its constructors are the cases that downstream code must handle.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* inductive.

Source: [QuantumBlockEncoding/PrimitiveCircuit.lean:79](../../../../library/modules/primitivecircuit/#decl-quantumblockencoding-primitivegate). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.PrimitiveCircuit" (lean := "QuantumBlockEncoding.PrimitiveCircuit")
*Plain-English reading.* This abbreviation gives a shorter name to the type or expression used for “primitive circuit”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* abbrev.

Source: [QuantumBlockEncoding/PrimitiveCircuit.lean:85](../../../../library/modules/primitivecircuit/#decl-quantumblockencoding-primitivecircuit). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.PrimitiveProgram" (lean := "QuantumBlockEncoding.PrimitiveProgram")
*Plain-English reading.* This record groups the data and proof fields needed for “primitive program”. A proposition-valued field is a requirement until a constructor supplies it. A primitive circuit together with an exact global phase.

*Formal status.* Data contract in the default import surface; proposition-valued fields are obligations, not automatically established facts.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* A primitive circuit together with an exact global phase.

*Declaration kind.* structure.

Source: [QuantumBlockEncoding/PrimitiveCircuit.lean:88](../../../../library/modules/primitivecircuit/#decl-quantumblockencoding-primitiveprogram). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.PrimitiveGate.dagger" (lean := "QuantumBlockEncoding.PrimitiveGate.dagger")
*Plain-English reading.* This definition gives the library's named construction or computation for “dagger”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/PrimitiveCircuit.lean:94](../../../../library/modules/primitivecircuit/#decl-quantumblockencoding-primitivegate-dagger). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.PrimitiveGate.touched" (lean := "QuantumBlockEncoding.PrimitiveGate.touched")
*Plain-English reading.* This definition gives the library's named construction or computation for “touched”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/PrimitiveCircuit.lean:100](../../../../library/modules/primitivecircuit/#decl-quantumblockencoding-primitivegate-touched). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.PrimitiveGate.oneQubitCount" (lean := "QuantumBlockEncoding.PrimitiveGate.oneQubitCount")
*Plain-English reading.* This definition gives the library's named construction or computation for “one qubit count”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/PrimitiveCircuit.lean:104](../../../../library/modules/primitivecircuit/#decl-quantumblockencoding-primitivegate-onequbitcount). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.PrimitiveGate.twoQubitCount" (lean := "QuantumBlockEncoding.PrimitiveGate.twoQubitCount")
*Plain-English reading.* This definition gives the library's named construction or computation for “two qubit count”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/PrimitiveCircuit.lean:108](../../../../library/modules/primitivecircuit/#decl-quantumblockencoding-primitivegate-twoqubitcount). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.PrimitiveCircuit.gateCount" (lean := "QuantumBlockEncoding.PrimitiveCircuit.gateCount")
*Plain-English reading.* This definition gives the library's named construction or computation for “gate count”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/PrimitiveCircuit.lean:116](../../../../library/modules/primitivecircuit/#decl-quantumblockencoding-primitivecircuit-gatecount). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.PrimitiveCircuit.oneQubitCount" (lean := "QuantumBlockEncoding.PrimitiveCircuit.oneQubitCount")
*Plain-English reading.* This definition gives the library's named construction or computation for “one qubit count”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/PrimitiveCircuit.lean:119](../../../../library/modules/primitivecircuit/#decl-quantumblockencoding-primitivecircuit-onequbitcount). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.PrimitiveCircuit.twoQubitCount" (lean := "QuantumBlockEncoding.PrimitiveCircuit.twoQubitCount")
*Plain-English reading.* This definition gives the library's named construction or computation for “two qubit count”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/PrimitiveCircuit.lean:122](../../../../library/modules/primitivecircuit/#decl-quantumblockencoding-primitivecircuit-twoqubitcount). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.PrimitiveCircuit.ryCount" (lean := "QuantumBlockEncoding.PrimitiveCircuit.ryCount")
*Plain-English reading.* This definition gives the library's named construction or computation for “ry count”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/PrimitiveCircuit.lean:125](../../../../library/modules/primitivecircuit/#decl-quantumblockencoding-primitivecircuit-rycount). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.PrimitiveCircuit.cxCount" (lean := "QuantumBlockEncoding.PrimitiveCircuit.cxCount")
*Plain-English reading.* This definition gives the library's named construction or computation for “cx count”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/PrimitiveCircuit.lean:130](../../../../library/modules/primitivecircuit/#decl-quantumblockencoding-primitivecircuit-cxcount). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.PrimitiveCircuit.ryCount_append" (lean := "QuantumBlockEncoding.PrimitiveCircuit.ryCount_append")
*Plain-English reading.* Lean checks the proposition indexed as “ry count append”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/PrimitiveCircuit.lean:135](../../../../library/modules/primitivecircuit/#decl-quantumblockencoding-primitivecircuit-rycount-append). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.PrimitiveCircuit.cxCount_append" (lean := "QuantumBlockEncoding.PrimitiveCircuit.cxCount_append")
*Plain-English reading.* Lean checks the proposition indexed as “cx count append”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/PrimitiveCircuit.lean:140](../../../../library/modules/primitivecircuit/#decl-quantumblockencoding-primitivecircuit-cxcount-append). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.PrimitiveCircuit.ryCount_singleton_ry" (lean := "QuantumBlockEncoding.PrimitiveCircuit.ryCount_singleton_ry")
*Plain-English reading.* Lean checks the proposition indexed as “ry count singleton ry”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/PrimitiveCircuit.lean:145](../../../../library/modules/primitivecircuit/#decl-quantumblockencoding-primitivecircuit-rycount-singleton-ry). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.PrimitiveCircuit.ryCount_singleton_cx" (lean := "QuantumBlockEncoding.PrimitiveCircuit.ryCount_singleton_cx")
*Plain-English reading.* Lean checks the proposition indexed as “ry count singleton cx”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/PrimitiveCircuit.lean:150](../../../../library/modules/primitivecircuit/#decl-quantumblockencoding-primitivecircuit-rycount-singleton-cx). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.PrimitiveCircuit.cxCount_singleton_ry" (lean := "QuantumBlockEncoding.PrimitiveCircuit.cxCount_singleton_ry")
*Plain-English reading.* Lean checks the proposition indexed as “cx count singleton ry”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/PrimitiveCircuit.lean:155](../../../../library/modules/primitivecircuit/#decl-quantumblockencoding-primitivecircuit-cxcount-singleton-ry). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.PrimitiveCircuit.cxCount_singleton_cx" (lean := "QuantumBlockEncoding.PrimitiveCircuit.cxCount_singleton_cx")
*Plain-English reading.* Lean checks the proposition indexed as “cx count singleton cx”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/PrimitiveCircuit.lean:160](../../../../library/modules/primitivecircuit/#decl-quantumblockencoding-primitivecircuit-cxcount-singleton-cx). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.PrimitiveCircuit.nextWireDepth" (lean := "QuantumBlockEncoding.PrimitiveCircuit.nextWireDepth")
*Plain-English reading.* This definition gives the library's named construction or computation for “next wire depth”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/PrimitiveCircuit.lean:165](../../../../library/modules/primitivecircuit/#decl-quantumblockencoding-primitivecircuit-nextwiredepth). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.PrimitiveCircuit.wireDepths" (lean := "QuantumBlockEncoding.PrimitiveCircuit.wireDepths")
*Plain-English reading.* This definition gives the library's named construction or computation for “wire depths”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/PrimitiveCircuit.lean:170](../../../../library/modules/primitivecircuit/#decl-quantumblockencoding-primitivecircuit-wiredepths). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.PrimitiveCircuit.depth" (lean := "QuantumBlockEncoding.PrimitiveCircuit.depth")
*Plain-English reading.* This definition gives the library's named construction or computation for “depth”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/PrimitiveCircuit.lean:174](../../../../library/modules/primitivecircuit/#decl-quantumblockencoding-primitivecircuit-depth). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.PrimitiveCircuit.resource" (lean := "QuantumBlockEncoding.PrimitiveCircuit.resource")
*Plain-English reading.* This definition gives the library's named construction or computation for “resource”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/PrimitiveCircuit.lean:177](../../../../library/modules/primitivecircuit/#decl-quantumblockencoding-primitivecircuit-resource). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.PrimitiveCircuit.gateCount_eq_length" (lean := "QuantumBlockEncoding.PrimitiveCircuit.gateCount_eq_length")
*Plain-English reading.* Lean checks the proposition indexed as “gate count eq length”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/PrimitiveCircuit.lean:181](../../../../library/modules/primitivecircuit/#decl-quantumblockencoding-primitivecircuit-gatecount-eq-length). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.PrimitiveCircuit.resource_oracleCalls_eq_zero" (lean := "QuantumBlockEncoding.PrimitiveCircuit.resource_oracleCalls_eq_zero")
*Plain-English reading.* Lean checks the proposition indexed as “resource oracle calls eq zero”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/PrimitiveCircuit.lean:185](../../../../library/modules/primitivecircuit/#decl-quantumblockencoding-primitivecircuit-resource-oraclecalls-eq-zero). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.PrimitiveProgram.identity" (lean := "QuantumBlockEncoding.PrimitiveProgram.identity")
*Plain-English reading.* This definition gives the library's named construction or computation for “identity”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/PrimitiveCircuit.lean:193](../../../../library/modules/primitivecircuit/#decl-quantumblockencoding-primitiveprogram-identity). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.PrimitiveProgram.seq" (lean := "QuantumBlockEncoding.PrimitiveProgram.seq")
*Plain-English reading.* This definition gives the library's named construction or computation for “seq”. Execute 'left', then 'right', using chronological list semantics.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* Execute 'left', then 'right', using chronological list semantics.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/PrimitiveCircuit.lean:198](../../../../library/modules/primitivecircuit/#decl-quantumblockencoding-primitiveprogram-seq). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.PrimitiveProgram.dagger" (lean := "QuantumBlockEncoding.PrimitiveProgram.dagger")
*Plain-English reading.* This definition gives the library's named construction or computation for “dagger”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/PrimitiveCircuit.lean:203](../../../../library/modules/primitivecircuit/#decl-quantumblockencoding-primitiveprogram-dagger). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.PrimitiveProgram.resource" (lean := "QuantumBlockEncoding.PrimitiveProgram.resource")
*Plain-English reading.* This definition gives the library's named construction or computation for “resource”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/PrimitiveCircuit.lean:208](../../../../library/modules/primitivecircuit/#decl-quantumblockencoding-primitiveprogram-resource). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

# QuantumBlockEncoding/PrimitiveMacros.lean

43 explicit public declarations, in source order.

:::definition "QuantumBlockEncoding.hadamardMatrix" (lean := "QuantumBlockEncoding.hadamardMatrix")
*Plain-English reading.* This definition gives the library's named construction or computation for “hadamard matrix”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/PrimitiveMacros.lean:15](../../../../library/modules/primitivemacros/#decl-quantumblockencoding-hadamardmatrix). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.phaseMatrix" (lean := "QuantumBlockEncoding.phaseMatrix")
*Plain-English reading.* This definition gives the library's named construction or computation for “phase matrix”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/PrimitiveMacros.lean:19](../../../../library/modules/primitivemacros/#decl-quantumblockencoding-phasematrix). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.hadamardMatrix_apply" (lean := "QuantumBlockEncoding.hadamardMatrix_apply")
*Plain-English reading.* Lean checks the proposition indexed as “hadamard matrix apply”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/PrimitiveMacros.lean:24](../../../../library/modules/primitivemacros/#decl-quantumblockencoding-hadamardmatrix-apply). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.phaseMatrix_apply" (lean := "QuantumBlockEncoding.phaseMatrix_apply")
*Plain-English reading.* Lean checks the proposition indexed as “phase matrix apply”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/PrimitiveMacros.lean:41](../../../../library/modules/primitivemacros/#decl-quantumblockencoding-phasematrix-apply). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.primitiveHProgram" (lean := "QuantumBlockEncoding.primitiveHProgram")
*Plain-English reading.* This definition gives the library's named construction or computation for “primitive h program”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/PrimitiveMacros.lean:76](../../../../library/modules/primitivemacros/#decl-quantumblockencoding-primitivehprogram). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.primitiveTProgram" (lean := "QuantumBlockEncoding.primitiveTProgram")
*Plain-English reading.* This definition gives the library's named construction or computation for “primitive t program”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/PrimitiveMacros.lean:82](../../../../library/modules/primitivemacros/#decl-quantumblockencoding-primitivetprogram). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.primitiveTdgProgram" (lean := "QuantumBlockEncoding.primitiveTdgProgram")
*Plain-English reading.* This definition gives the library's named construction or computation for “primitive tdg program”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/PrimitiveMacros.lean:87](../../../../library/modules/primitivemacros/#decl-quantumblockencoding-primitivetdgprogram). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.evalGlobalPhase_pi_div_two" (lean := "QuantumBlockEncoding.evalGlobalPhase_pi_div_two")
*Plain-English reading.* Lean checks the proposition indexed as “eval global phase pi div two”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/PrimitiveMacros.lean:92](../../../../library/modules/primitivemacros/#decl-quantumblockencoding-evalglobalphase-pi-div-two). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.liftPrimitiveOneQubit_mul" (lean := "QuantumBlockEncoding.liftPrimitiveOneQubit_mul")
*Plain-English reading.* Lean checks the proposition indexed as “lift primitive one qubit mul”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/PrimitiveMacros.lean:98](../../../../library/modules/primitivemacros/#decl-quantumblockencoding-liftprimitiveonequbit-mul). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.smul_liftPrimitiveOneQubit" (lean := "QuantumBlockEncoding.smul_liftPrimitiveOneQubit")
*Plain-English reading.* Lean checks the proposition indexed as “smul lift primitive one qubit”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/PrimitiveMacros.lean:108](../../../../library/modules/primitivemacros/#decl-quantumblockencoding-smul-liftprimitiveonequbit). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.primitiveHProgram_eval" (lean := "QuantumBlockEncoding.primitiveHProgram_eval")
*Plain-English reading.* Lean checks the proposition indexed as “primitive h program eval”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/PrimitiveMacros.lean:117](../../../../library/modules/primitivemacros/#decl-quantumblockencoding-primitivehprogram-eval). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.primitiveTProgram_eval" (lean := "QuantumBlockEncoding.primitiveTProgram_eval")
*Plain-English reading.* Lean checks the proposition indexed as “primitive t program eval”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/PrimitiveMacros.lean:132](../../../../library/modules/primitivemacros/#decl-quantumblockencoding-primitivetprogram-eval). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.primitiveTdgProgram_eval" (lean := "QuantumBlockEncoding.primitiveTdgProgram_eval")
*Plain-English reading.* Lean checks the proposition indexed as “primitive tdg program eval”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/PrimitiveMacros.lean:152](../../../../library/modules/primitivemacros/#decl-quantumblockencoding-primitivetdgprogram-eval). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.phasePermutationMatrix" (lean := "QuantumBlockEncoding.phasePermutationMatrix")
*Plain-English reading.* This definition gives the library's named construction or computation for “phase permutation matrix”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/PrimitiveMacros.lean:174](../../../../library/modules/primitivemacros/#decl-quantumblockencoding-phasepermutationmatrix). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.phasePermutationMatrix_mul" (lean := "QuantumBlockEncoding.phasePermutationMatrix_mul")
*Plain-English reading.* Lean checks the proposition indexed as “phase permutation matrix mul”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/PrimitiveMacros.lean:180](../../../../library/modules/primitivemacros/#decl-quantumblockencoding-phasepermutationmatrix-mul). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.evalPrimitiveCx_eq_phasePermutationMatrix" (lean := "QuantumBlockEncoding.evalPrimitiveCx_eq_phasePermutationMatrix")
*Plain-English reading.* Lean checks the proposition indexed as “eval primitive cx eq phase permutation matrix”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/PrimitiveMacros.lean:198](../../../../library/modules/primitivemacros/#decl-quantumblockencoding-evalprimitivecx-eq-phasepermutationmatrix). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.liftPhaseMatrix_eq_phasePermutationMatrix" (lean := "QuantumBlockEncoding.liftPhaseMatrix_eq_phasePermutationMatrix")
*Plain-English reading.* Lean checks the proposition indexed as “lift phase matrix eq phase permutation matrix”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/PrimitiveMacros.lean:206](../../../../library/modules/primitivemacros/#decl-quantumblockencoding-liftphasematrix-eq-phasepermutationmatrix). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.primitiveCxProgram" (lean := "QuantumBlockEncoding.primitiveCxProgram")
*Plain-English reading.* This definition gives the library's named construction or computation for “primitive cx program”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/PrimitiveMacros.lean:232](../../../../library/modules/primitivemacros/#decl-quantumblockencoding-primitivecxprogram). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.primitiveCxProgram_eval" (lean := "QuantumBlockEncoding.primitiveCxProgram_eval")
*Plain-English reading.* Lean checks the proposition indexed as “primitive cx program eval”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/PrimitiveMacros.lean:237](../../../../library/modules/primitivemacros/#decl-quantumblockencoding-primitivecxprogram-eval). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.primitiveTProgram_eval_monomial" (lean := "QuantumBlockEncoding.primitiveTProgram_eval_monomial")
*Plain-English reading.* Lean checks the proposition indexed as “primitive t program eval monomial”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/PrimitiveMacros.lean:249](../../../../library/modules/primitivemacros/#decl-quantumblockencoding-primitivetprogram-eval-monomial). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.primitiveTdgProgram_eval_monomial" (lean := "QuantumBlockEncoding.primitiveTdgProgram_eval_monomial")
*Plain-English reading.* Lean checks the proposition indexed as “primitive tdg program eval monomial”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/PrimitiveMacros.lean:258](../../../../library/modules/primitivemacros/#decl-quantumblockencoding-primitivetdgprogram-eval-monomial). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.MonomialProgram" (lean := "QuantumBlockEncoding.MonomialProgram")
*Plain-English reading.* This record groups the data and proof fields needed for “monomial program”. A proposition-valued field is a requirement until a constructor supplies it.

*Formal status.* Data contract in the default import surface; proposition-valued fields are obligations, not automatically established facts.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* structure.

Source: [QuantumBlockEncoding/PrimitiveMacros.lean:267](../../../../library/modules/primitivemacros/#decl-quantumblockencoding-monomialprogram). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.MonomialProgram.seq" (lean := "QuantumBlockEncoding.MonomialProgram.seq")
*Plain-English reading.* This definition gives the library's named construction or computation for “seq”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/PrimitiveMacros.lean:276](../../../../library/modules/primitivemacros/#decl-quantumblockencoding-monomialprogram-seq). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.MonomialProgram.cx" (lean := "QuantumBlockEncoding.MonomialProgram.cx")
*Plain-English reading.* This definition gives the library's named construction or computation for “cx”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/PrimitiveMacros.lean:285](../../../../library/modules/primitivemacros/#decl-quantumblockencoding-monomialprogram-cx). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.MonomialProgram.t" (lean := "QuantumBlockEncoding.MonomialProgram.t")
*Plain-English reading.* This definition gives the library's named construction or computation for “t”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/PrimitiveMacros.lean:292](../../../../library/modules/primitivemacros/#decl-quantumblockencoding-monomialprogram-t). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.MonomialProgram.tdg" (lean := "QuantumBlockEncoding.MonomialProgram.tdg")
*Plain-English reading.* This definition gives the library's named construction or computation for “tdg”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/PrimitiveMacros.lean:299](../../../../library/modules/primitivemacros/#decl-quantumblockencoding-monomialprogram-tdg). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.primitiveCCXMiddle" (lean := "QuantumBlockEncoding.primitiveCCXMiddle")
*Plain-English reading.* This definition gives the library's named construction or computation for “primitive ccx middle”. The phase-only middle of the standard exact Toffoli decomposition.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The phase-only middle of the standard exact Toffoli decomposition.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/PrimitiveMacros.lean:309](../../../../library/modules/primitivemacros/#decl-quantumblockencoding-primitiveccxmiddle). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.primitiveCCXProgram" (lean := "QuantumBlockEncoding.primitiveCCXProgram")
*Plain-English reading.* This definition gives the library's named construction or computation for “primitive ccx program”. The exact primitive program uses the requested H/T/Tdg/CX chronology.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The exact primitive program uses the requested H/T/Tdg/CX chronology.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/PrimitiveMacros.lean:330](../../../../library/modules/primitivemacros/#decl-quantumblockencoding-primitiveccxprogram). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.primitiveCCXMiddle_permutation_eq_refl" (lean := "QuantumBlockEncoding.primitiveCCXMiddle_permutation_eq_refl")
*Plain-English reading.* Lean checks the proposition indexed as “primitive ccx middle permutation eq refl”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/PrimitiveMacros.lean:339](../../../../library/modules/primitivemacros/#decl-quantumblockencoding-primitiveccxmiddle-permutation-eq-refl). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.primitiveCCXMiddle_phase_eq_ccz" (lean := "QuantumBlockEncoding.primitiveCCXMiddle_phase_eq_ccz")
*Plain-English reading.* Lean checks the proposition indexed as “primitive ccx middle phase eq ccz”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/PrimitiveMacros.lean:363](../../../../library/modules/primitivemacros/#decl-quantumblockencoding-primitiveccxmiddle-phase-eq-ccz). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.cczMatrix" (lean := "QuantumBlockEncoding.cczMatrix")
*Plain-English reading.* This definition gives the library's named construction or computation for “ccz matrix”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/PrimitiveMacros.lean:384](../../../../library/modules/primitivemacros/#decl-quantumblockencoding-cczmatrix). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.primitiveCCXMiddle_eval" (lean := "QuantumBlockEncoding.primitiveCCXMiddle_eval")
*Plain-English reading.* Lean checks the proposition indexed as “primitive ccx middle eval”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/PrimitiveMacros.lean:392](../../../../library/modules/primitivemacros/#decl-quantumblockencoding-primitiveccxmiddle-eval). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.zMatrix" (lean := "QuantumBlockEncoding.zMatrix")
*Plain-English reading.* This definition gives the library's named construction or computation for “z matrix”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/PrimitiveMacros.lean:407](../../../../library/modules/primitivemacros/#decl-quantumblockencoding-zmatrix). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.hadamard_mul_hadamard" (lean := "QuantumBlockEncoding.hadamard_mul_hadamard")
*Plain-English reading.* Lean checks the proposition indexed as “hadamard mul hadamard”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/PrimitiveMacros.lean:410](../../../../library/modules/primitivemacros/#decl-quantumblockencoding-hadamard-mul-hadamard). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.hadamard_mul_z_mul_hadamard" (lean := "QuantumBlockEncoding.hadamard_mul_z_mul_hadamard")
*Plain-English reading.* Lean checks the proposition indexed as “hadamard mul z mul hadamard”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/PrimitiveMacros.lean:419](../../../../library/modules/primitivemacros/#decl-quantumblockencoding-hadamard-mul-z-mul-hadamard). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.liftPrimitiveOneQubit_eq_blockDiagonal" (lean := "QuantumBlockEncoding.liftPrimitiveOneQubit_eq_blockDiagonal")
*Plain-English reading.* Lean checks the proposition indexed as “lift primitive one qubit eq block diagonal”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/PrimitiveMacros.lean:430](../../../../library/modules/primitivemacros/#decl-quantumblockencoding-liftprimitiveonequbit-eq-blockdiagonal). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.cczTargetBlock" (lean := "QuantumBlockEncoding.cczTargetBlock")
*Plain-English reading.* This definition gives the library's named construction or computation for “ccz target block”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/PrimitiveMacros.lean:440](../../../../library/modules/primitivemacros/#decl-quantumblockencoding-ccztargetblock). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.cczMatrix_eq_blockDiagonal" (lean := "QuantumBlockEncoding.cczMatrix_eq_blockDiagonal")
*Plain-English reading.* Lean checks the proposition indexed as “ccz matrix eq block diagonal”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/PrimitiveMacros.lean:448](../../../../library/modules/primitivemacros/#decl-quantumblockencoding-cczmatrix-eq-blockdiagonal). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.ccxTargetBlock" (lean := "QuantumBlockEncoding.ccxTargetBlock")
*Plain-English reading.* This definition gives the library's named construction or computation for “ccx target block”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/PrimitiveMacros.lean:500](../../../../library/modules/primitivemacros/#decl-quantumblockencoding-ccxtargetblock). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.equivPermutationMatrix_ccx_eq_blockDiagonal" (lean := "QuantumBlockEncoding.equivPermutationMatrix_ccx_eq_blockDiagonal")
*Plain-English reading.* Lean checks the proposition indexed as “equiv permutation matrix ccx eq block diagonal”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/PrimitiveMacros.lean:508](../../../../library/modules/primitivemacros/#decl-quantumblockencoding-equivpermutationmatrix-ccx-eq-blockdiagonal). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.hadamard_conjugates_ccz" (lean := "QuantumBlockEncoding.hadamard_conjugates_ccz")
*Plain-English reading.* Lean checks the proposition indexed as “hadamard conjugates ccz”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/PrimitiveMacros.lean:580](../../../../library/modules/primitivemacros/#decl-quantumblockencoding-hadamard-conjugates-ccz). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.primitiveCCXProgram_eval" (lean := "QuantumBlockEncoding.primitiveCCXProgram_eval")
*Plain-English reading.* Lean checks the proposition indexed as “primitive ccx program eval”; the hypotheses and conclusion in the code panel fix its exact scope. The requested H/T/Tdg/CX decomposition is exactly Toffoli, including its global phase.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The requested H/T/Tdg/CX decomposition is exactly Toffoli, including its global phase.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/PrimitiveMacros.lean:611](../../../../library/modules/primitivemacros/#decl-quantumblockencoding-primitiveccxprogram-eval). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.primitiveCCXProgramRefinement" (lean := "QuantumBlockEncoding.primitiveCCXProgramRefinement")
*Plain-English reading.* This definition gives the library's named construction or computation for “primitive ccx program refinement”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/PrimitiveMacros.lean:624](../../../../library/modules/primitivemacros/#decl-quantumblockencoding-primitiveccxprogramrefinement). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

# QuantumBlockEncoding/PrimitiveRefinement.lean

5 explicit public declarations, in source order.

:::definition "QuantumBlockEncoding.PrimitiveProgramRefinement" (lean := "QuantumBlockEncoding.PrimitiveProgramRefinement")
*Plain-English reading.* This record groups the data and proof fields needed for “primitive program refinement”. A proposition-valued field is a requirement until a constructor supplies it. Exact refinement for a primitive program, including its declared global phase.

*Formal status.* Data contract in the default import surface; proposition-valued fields are obligations, not automatically established facts.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* Exact refinement for a primitive program, including its declared global phase. This is the acceptance record used by phase-sensitive macro compilers.

*Declaration kind.* structure.

Source: [QuantumBlockEncoding/PrimitiveRefinement.lean:15](../../../../library/modules/primitiverefinement/#decl-quantumblockencoding-primitiveprogramrefinement). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.PrimitiveProgramRefinement.resource" (lean := "QuantumBlockEncoding.PrimitiveProgramRefinement.resource")
*Plain-English reading.* This definition gives the library's named construction or computation for “resource”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/PrimitiveRefinement.lean:20](../../../../library/modules/primitiverefinement/#decl-quantumblockencoding-primitiveprogramrefinement-resource). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.PrimitiveProgramRefinement.oracleCalls_eq_zero" (lean := "QuantumBlockEncoding.PrimitiveProgramRefinement.oracleCalls_eq_zero")
*Plain-English reading.* Lean checks the proposition indexed as “oracle calls eq zero”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/PrimitiveRefinement.lean:24](../../../../library/modules/primitiverefinement/#decl-quantumblockencoding-primitiveprogramrefinement-oraclecalls-eq-zero). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.PrimitiveRefinement.resource" (lean := "QuantumBlockEncoding.PrimitiveRefinement.resource")
*Plain-English reading.* This definition gives the library's named construction or computation for “resource”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/PrimitiveRefinement.lean:29](../../../../library/modules/primitiverefinement/#decl-quantumblockencoding-primitiverefinement-resource). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.PrimitiveRefinement.oracleCalls_eq_zero" (lean := "QuantumBlockEncoding.PrimitiveRefinement.oracleCalls_eq_zero")
*Plain-English reading.* Lean checks the proposition indexed as “oracle calls eq zero”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/PrimitiveRefinement.lean:33](../../../../library/modules/primitiverefinement/#decl-quantumblockencoding-primitiverefinement-oraclecalls-eq-zero). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

# QuantumBlockEncoding/PrimitiveSemantics.lean

54 explicit public declarations, in source order.

:::definition "QuantumBlockEncoding.standardRyMatrix" (lean := "QuantumBlockEncoding.standardRyMatrix")
*Plain-English reading.* This definition gives the library's named construction or computation for “standard ry matrix”. Standard 'RY(theta)' in the convention used by Qiskit and OpenQASM 3.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* Standard 'RY(theta)' in the convention used by Qiskit and OpenQASM 3.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/PrimitiveSemantics.lean:18](../../../../library/modules/primitivesemantics/#decl-quantumblockencoding-standardrymatrix). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.standardRyMatrix_zero" (lean := "QuantumBlockEncoding.standardRyMatrix_zero")
*Plain-English reading.* Lean checks the proposition indexed as “standard ry matrix zero”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/PrimitiveSemantics.lean:22](../../../../library/modules/primitivesemantics/#decl-quantumblockencoding-standardrymatrix-zero). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.standardRyMatrix_add" (lean := "QuantumBlockEncoding.standardRyMatrix_add")
*Plain-English reading.* Lean checks the proposition indexed as “standard ry matrix add”; the hypotheses and conclusion in the code panel fix its exact scope. Standard rotations compose by adding their physical angles.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* Standard rotations compose by adding their physical angles.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/PrimitiveSemantics.lean:28](../../../../library/modules/primitivesemantics/#decl-quantumblockencoding-standardrymatrix-add). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.star_complex_cos_ofReal" (lean := "QuantumBlockEncoding.star_complex_cos_ofReal")
*Plain-English reading.* Lean checks the proposition indexed as “star complex cos of real”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/PrimitiveSemantics.lean:39](../../../../library/modules/primitivesemantics/#decl-quantumblockencoding-star-complex-cos-ofreal). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.conj_complex_cos_ofReal" (lean := "QuantumBlockEncoding.conj_complex_cos_ofReal")
*Plain-English reading.* Lean checks the proposition indexed as “conj complex cos of real”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/PrimitiveSemantics.lean:43](../../../../library/modules/primitivesemantics/#decl-quantumblockencoding-conj-complex-cos-ofreal). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.star_complex_sin_ofReal" (lean := "QuantumBlockEncoding.star_complex_sin_ofReal")
*Plain-English reading.* Lean checks the proposition indexed as “star complex sin of real”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/PrimitiveSemantics.lean:48](../../../../library/modules/primitivesemantics/#decl-quantumblockencoding-star-complex-sin-ofreal). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.conj_complex_sin_ofReal" (lean := "QuantumBlockEncoding.conj_complex_sin_ofReal")
*Plain-English reading.* Lean checks the proposition indexed as “conj complex sin of real”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/PrimitiveSemantics.lean:52](../../../../library/modules/primitivesemantics/#decl-quantumblockencoding-conj-complex-sin-ofreal). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.complex_ofReal_div_two" (lean := "QuantumBlockEncoding.complex_ofReal_div_two")
*Plain-English reading.* Lean checks the proposition indexed as “complex of real div two”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/PrimitiveSemantics.lean:57](../../../../library/modules/primitivesemantics/#decl-quantumblockencoding-complex-ofreal-div-two). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.conj_complex_cos_ofReal_div_two" (lean := "QuantumBlockEncoding.conj_complex_cos_ofReal_div_two")
*Plain-English reading.* Lean checks the proposition indexed as “conj complex cos of real div two”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/PrimitiveSemantics.lean:61](../../../../library/modules/primitivesemantics/#decl-quantumblockencoding-conj-complex-cos-ofreal-div-two). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.conj_complex_sin_ofReal_div_two" (lean := "QuantumBlockEncoding.conj_complex_sin_ofReal_div_two")
*Plain-English reading.* Lean checks the proposition indexed as “conj complex sin of real div two”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/PrimitiveSemantics.lean:66](../../../../library/modules/primitivesemantics/#decl-quantumblockencoding-conj-complex-sin-ofreal-div-two). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.standardRyMatrix_neg" (lean := "QuantumBlockEncoding.standardRyMatrix_neg")
*Plain-English reading.* Lean checks the proposition indexed as “standard ry matrix neg”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/PrimitiveSemantics.lean:71](../../../../library/modules/primitivesemantics/#decl-quantumblockencoding-standardrymatrix-neg). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.xMatrix" (lean := "QuantumBlockEncoding.xMatrix")
*Plain-English reading.* This definition gives the library's named construction or computation for “x matrix”. Pauli X in the same two-dimensional basis as 'standardRyMatrix'.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* Pauli X in the same two-dimensional basis as 'standardRyMatrix'.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/PrimitiveSemantics.lean:80](../../../../library/modules/primitivesemantics/#decl-quantumblockencoding-xmatrix). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.xMatrix_conjugates_standardRy" (lean := "QuantumBlockEncoding.xMatrix_conjugates_standardRy")
*Plain-English reading.* Lean checks the proposition indexed as “x matrix conjugates standard ry”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/PrimitiveSemantics.lean:83](../../../../library/modules/primitivesemantics/#decl-quantumblockencoding-xmatrix-conjugates-standardry). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.standardRyMatrix_unitary" (lean := "QuantumBlockEncoding.standardRyMatrix_unitary")
*Plain-English reading.* Lean checks the proposition indexed as “standard ry matrix unitary”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/PrimitiveSemantics.lean:91](../../../../library/modules/primitivesemantics/#decl-quantumblockencoding-standardrymatrix-unitary). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.standardRyMatrix_two_arccos_eq_amplitudeRotation" (lean := "QuantumBlockEncoding.standardRyMatrix_two_arccos_eq_amplitudeRotation")
*Plain-English reading.* Lean checks the proposition indexed as “standard ry matrix two arccos eq amplitude rotation”; the hypotheses and conclusion in the code panel fix its exact scope. The exact half-angle correction from standard 'RY' to the logical loader.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The exact half-angle correction from standard 'RY' to the logical loader.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/PrimitiveSemantics.lean:96](../../../../library/modules/primitivesemantics/#decl-quantumblockencoding-standardrymatrix-two-arccos-eq-amplituderotation). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.standardRyMatrix_pi_div_two_eq_warmRobinUniformBitPrepare" (lean := "QuantumBlockEncoding.standardRyMatrix_pi_div_two_eq_warmRobinUniformBitPrepare")
*Plain-English reading.* Lean checks the proposition indexed as “standard ry matrix pi div two eq warm robin uniform bit prepare”; the hypotheses and conclusion in the code panel fix its exact scope. The symmetry PREPARE is exactly a standard 'RY(pi/2)', not an opaque H.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The symmetry PREPARE is exactly a standard 'RY(pi/2)', not an opaque H.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/PrimitiveSemantics.lean:106](../../../../library/modules/primitivesemantics/#decl-quantumblockencoding-standardrymatrix-pi-div-two-eq-warmrobinuniformbitprepare). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.PrimitiveBasis" (lean := "QuantumBlockEncoding.PrimitiveBasis")
*Plain-English reading.* This abbreviation gives a shorter name to the type or expression used for “primitive basis”. Computational-basis bit strings with one named coordinate per qubit.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* Computational-basis bit strings with one named coordinate per qubit.

*Declaration kind.* abbrev.

Source: [QuantumBlockEncoding/PrimitiveSemantics.lean:116](../../../../library/modules/primitivesemantics/#decl-quantumblockencoding-primitivebasis). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.flipBit" (lean := "QuantumBlockEncoding.flipBit")
*Plain-English reading.* This definition gives the library's named construction or computation for “flip bit”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/PrimitiveSemantics.lean:118](../../../../library/modules/primitivesemantics/#decl-quantumblockencoding-flipbit). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.flipBit_flipBit" (lean := "QuantumBlockEncoding.flipBit_flipBit")
*Plain-English reading.* Lean checks the proposition indexed as “flip bit flip bit”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/PrimitiveSemantics.lean:120](../../../../library/modules/primitivesemantics/#decl-quantumblockencoding-flipbit-flipbit). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.xBasisAction" (lean := "QuantumBlockEncoding.xBasisAction")
*Plain-English reading.* This definition gives the library's named construction or computation for “x basis action”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/PrimitiveSemantics.lean:123](../../../../library/modules/primitivesemantics/#decl-quantumblockencoding-xbasisaction). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.xBasisAction_involutive" (lean := "QuantumBlockEncoding.xBasisAction_involutive")
*Plain-English reading.* Lean checks the proposition indexed as “x basis action involutive”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/PrimitiveSemantics.lean:127](../../../../library/modules/primitivesemantics/#decl-quantumblockencoding-xbasisaction-involutive). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.xBasisEquiv" (lean := "QuantumBlockEncoding.xBasisEquiv")
*Plain-English reading.* This definition gives the library's named construction or computation for “x basis equiv”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/PrimitiveSemantics.lean:136](../../../../library/modules/primitivesemantics/#decl-quantumblockencoding-xbasisequiv). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.cxBasisAction" (lean := "QuantumBlockEncoding.cxBasisAction")
*Plain-English reading.* This definition gives the library's named construction or computation for “cx basis action”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/PrimitiveSemantics.lean:143](../../../../library/modules/primitivesemantics/#decl-quantumblockencoding-cxbasisaction). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.cxBasisAction_involutive" (lean := "QuantumBlockEncoding.cxBasisAction_involutive")
*Plain-English reading.* Lean checks the proposition indexed as “cx basis action involutive”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/PrimitiveSemantics.lean:147](../../../../library/modules/primitivesemantics/#decl-quantumblockencoding-cxbasisaction-involutive). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.cxBasisEquiv" (lean := "QuantumBlockEncoding.cxBasisEquiv")
*Plain-English reading.* This definition gives the library's named construction or computation for “cx basis equiv”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/PrimitiveSemantics.lean:158](../../../../library/modules/primitivesemantics/#decl-quantumblockencoding-cxbasisequiv). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.OtherPrimitiveWires" (lean := "QuantumBlockEncoding.OtherPrimitiveWires")
*Plain-English reading.* This abbreviation gives a shorter name to the type or expression used for “other primitive wires”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* abbrev.

Source: [QuantumBlockEncoding/PrimitiveSemantics.lean:166](../../../../library/modules/primitivesemantics/#decl-quantumblockencoding-otherprimitivewires). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.splitPrimitiveWire" (lean := "QuantumBlockEncoding.splitPrimitiveWire")
*Plain-English reading.* This definition gives the library's named construction or computation for “split primitive wire”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/PrimitiveSemantics.lean:169](../../../../library/modules/primitivesemantics/#decl-quantumblockencoding-splitprimitivewire). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.splitPrimitiveWire_other_apply" (lean := "QuantumBlockEncoding.splitPrimitiveWire_other_apply")
*Plain-English reading.* Lean checks the proposition indexed as “split primitive wire other apply”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/PrimitiveSemantics.lean:188](../../../../library/modules/primitivesemantics/#decl-quantumblockencoding-splitprimitivewire-other-apply). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.liftPrimitiveOneQubit" (lean := "QuantumBlockEncoding.liftPrimitiveOneQubit")
*Plain-English reading.* This definition gives the library's named construction or computation for “lift primitive one qubit”. Lift a one-qubit matrix to a named wire, leaving every other wire fixed.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* Lift a one-qubit matrix to a named wire, leaving every other wire fixed.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/PrimitiveSemantics.lean:194](../../../../library/modules/primitivesemantics/#decl-quantumblockencoding-liftprimitiveonequbit). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.liftPrimitiveOneQubit_apply" (lean := "QuantumBlockEncoding.liftPrimitiveOneQubit_apply")
*Plain-English reading.* Lean checks the proposition indexed as “lift primitive one qubit apply”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/PrimitiveSemantics.lean:202](../../../../library/modules/primitivesemantics/#decl-quantumblockencoding-liftprimitiveonequbit-apply). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.liftPrimitiveOneQubit_unitary" (lean := "QuantumBlockEncoding.liftPrimitiveOneQubit_unitary")
*Plain-English reading.* Lean checks the proposition indexed as “lift primitive one qubit unitary”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/PrimitiveSemantics.lean:220](../../../../library/modules/primitivesemantics/#decl-quantumblockencoding-liftprimitiveonequbit-unitary). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.standardRzMatrix" (lean := "QuantumBlockEncoding.standardRzMatrix")
*Plain-English reading.* This definition gives the library's named construction or computation for “standard rz matrix”. Standard exact 'RZ(theta)' matrix, including its phase convention.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* Standard exact 'RZ(theta)' matrix, including its phase convention.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/PrimitiveSemantics.lean:232](../../../../library/modules/primitivesemantics/#decl-quantumblockencoding-standardrzmatrix). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.standardRzMatrix_unitary" (lean := "QuantumBlockEncoding.standardRzMatrix_unitary")
*Plain-English reading.* Lean checks the proposition indexed as “standard rz matrix unitary”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/PrimitiveSemantics.lean:241](../../../../library/modules/primitivesemantics/#decl-quantumblockencoding-standardrzmatrix-unitary). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.standardRzMatrix_neg" (lean := "QuantumBlockEncoding.standardRzMatrix_neg")
*Plain-English reading.* Lean checks the proposition indexed as “standard rz matrix neg”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/PrimitiveSemantics.lean:263](../../../../library/modules/primitivesemantics/#decl-quantumblockencoding-standardrzmatrix-neg). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.star_equivPermutationMatrix" (lean := "QuantumBlockEncoding.star_equivPermutationMatrix")
*Plain-English reading.* Lean checks the proposition indexed as “star equiv permutation matrix”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/PrimitiveSemantics.lean:286](../../../../library/modules/primitivesemantics/#decl-quantumblockencoding-star-equivpermutationmatrix). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.star_liftPrimitiveOneQubit" (lean := "QuantumBlockEncoding.star_liftPrimitiveOneQubit")
*Plain-English reading.* Lean checks the proposition indexed as “star lift primitive one qubit”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/PrimitiveSemantics.lean:306](../../../../library/modules/primitivesemantics/#decl-quantumblockencoding-star-liftprimitiveonequbit). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.evalPrimitiveGate" (lean := "QuantumBlockEncoding.evalPrimitiveGate")
*Plain-English reading.* This definition gives the library's named construction or computation for “eval primitive gate”. Exact matrix denotation of one primitive instruction.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* Exact matrix denotation of one primitive instruction.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/PrimitiveSemantics.lean:323](../../../../library/modules/primitivesemantics/#decl-quantumblockencoding-evalprimitivegate). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.evalPrimitiveGate_unitary" (lean := "QuantumBlockEncoding.evalPrimitiveGate_unitary")
*Plain-English reading.* Lean checks the proposition indexed as “eval primitive gate unitary”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/PrimitiveSemantics.lean:331](../../../../library/modules/primitivesemantics/#decl-quantumblockencoding-evalprimitivegate-unitary). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.xBasisEquiv_symm" (lean := "QuantumBlockEncoding.xBasisEquiv_symm")
*Plain-English reading.* Lean checks the proposition indexed as “x basis equiv symm”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/PrimitiveSemantics.lean:342](../../../../library/modules/primitivesemantics/#decl-quantumblockencoding-xbasisequiv-symm). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.cxBasisEquiv_symm" (lean := "QuantumBlockEncoding.cxBasisEquiv_symm")
*Plain-English reading.* Lean checks the proposition indexed as “cx basis equiv symm”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/PrimitiveSemantics.lean:346](../../../../library/modules/primitivesemantics/#decl-quantumblockencoding-cxbasisequiv-symm). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.evalPrimitiveGate_dagger" (lean := "QuantumBlockEncoding.evalPrimitiveGate_dagger")
*Plain-English reading.* Lean checks the proposition indexed as “eval primitive gate dagger”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/PrimitiveSemantics.lean:352](../../../../library/modules/primitivesemantics/#decl-quantumblockencoding-evalprimitivegate-dagger). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.evalPrimitiveCircuit" (lean := "QuantumBlockEncoding.evalPrimitiveCircuit")
*Plain-English reading.* This definition gives the library's named construction or computation for “eval primitive circuit”. Chronological circuit evaluation: later instructions multiply on the left.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* Chronological circuit evaluation: later instructions multiply on the left.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/PrimitiveSemantics.lean:374](../../../../library/modules/primitivesemantics/#decl-quantumblockencoding-evalprimitivecircuit). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.evalPrimitiveCircuit_unitary" (lean := "QuantumBlockEncoding.evalPrimitiveCircuit_unitary")
*Plain-English reading.* Lean checks the proposition indexed as “eval primitive circuit unitary”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/PrimitiveSemantics.lean:379](../../../../library/modules/primitivesemantics/#decl-quantumblockencoding-evalprimitivecircuit-unitary). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.evalPrimitiveCircuit_append" (lean := "QuantumBlockEncoding.evalPrimitiveCircuit_append")
*Plain-English reading.* Lean checks the proposition indexed as “eval primitive circuit append”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/PrimitiveSemantics.lean:389](../../../../library/modules/primitivesemantics/#decl-quantumblockencoding-evalprimitivecircuit-append). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.evalPrimitiveCircuit_dagger" (lean := "QuantumBlockEncoding.evalPrimitiveCircuit_dagger")
*Plain-English reading.* Lean checks the proposition indexed as “eval primitive circuit dagger”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/PrimitiveSemantics.lean:400](../../../../library/modules/primitivesemantics/#decl-quantumblockencoding-evalprimitivecircuit-dagger). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.evalGlobalPhase" (lean := "QuantumBlockEncoding.evalGlobalPhase")
*Plain-English reading.* This definition gives the library's named construction or computation for “eval global phase”. Unit-modulus scalar represented by an exact global phase.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* Unit-modulus scalar represented by an exact global phase.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/PrimitiveSemantics.lean:413](../../../../library/modules/primitivesemantics/#decl-quantumblockencoding-evalglobalphase). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.evalGlobalPhase_unitary" (lean := "QuantumBlockEncoding.evalGlobalPhase_unitary")
*Plain-English reading.* Lean checks the proposition indexed as “eval global phase unitary”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/PrimitiveSemantics.lean:416](../../../../library/modules/primitivesemantics/#decl-quantumblockencoding-evalglobalphase-unitary). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.evalGlobalPhase_neg" (lean := "QuantumBlockEncoding.evalGlobalPhase_neg")
*Plain-English reading.* Lean checks the proposition indexed as “eval global phase neg”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/PrimitiveSemantics.lean:430](../../../../library/modules/primitivesemantics/#decl-quantumblockencoding-evalglobalphase-neg). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.evalPrimitiveProgram" (lean := "QuantumBlockEncoding.evalPrimitiveProgram")
*Plain-English reading.* This definition gives the library's named construction or computation for “eval primitive program”. Exact program semantics, with the same 'exp(i phase)' convention used by Qiskit and OpenQASM 3.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* Exact program semantics, with the same 'exp(i phase)' convention used by Qiskit and OpenQASM 3.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/PrimitiveSemantics.lean:439](../../../../library/modules/primitivesemantics/#decl-quantumblockencoding-evalprimitiveprogram). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.evalPrimitiveProgram_identity" (lean := "QuantumBlockEncoding.evalPrimitiveProgram_identity")
*Plain-English reading.* Lean checks the proposition indexed as “eval primitive program identity”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/PrimitiveSemantics.lean:444](../../../../library/modules/primitivesemantics/#decl-quantumblockencoding-evalprimitiveprogram-identity). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.evalPrimitiveProgram_seq" (lean := "QuantumBlockEncoding.evalPrimitiveProgram_seq")
*Plain-English reading.* Lean checks the proposition indexed as “eval primitive program seq”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/PrimitiveSemantics.lean:449](../../../../library/modules/primitivesemantics/#decl-quantumblockencoding-evalprimitiveprogram-seq). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.evalPrimitiveProgram_unitary" (lean := "QuantumBlockEncoding.evalPrimitiveProgram_unitary")
*Plain-English reading.* Lean checks the proposition indexed as “eval primitive program unitary”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/PrimitiveSemantics.lean:463](../../../../library/modules/primitivesemantics/#decl-quantumblockencoding-evalprimitiveprogram-unitary). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.evalPrimitiveProgram_dagger" (lean := "QuantumBlockEncoding.evalPrimitiveProgram_dagger")
*Plain-English reading.* Lean checks the proposition indexed as “eval primitive program dagger”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/PrimitiveSemantics.lean:470](../../../../library/modules/primitivesemantics/#decl-quantumblockencoding-evalprimitiveprogram-dagger). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.PrimitiveRefinement" (lean := "QuantumBlockEncoding.PrimitiveRefinement")
*Plain-English reading.* This record groups the data and proof fields needed for “primitive refinement”. A proposition-valued field is a requirement until a constructor supplies it. A typed primitive refinement records exact equality, not equality up to phase.

*Formal status.* Data contract in the default import surface; proposition-valued fields are obligations, not automatically established facts.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* A typed primitive refinement records exact equality, not equality up to phase.

*Declaration kind.* structure.

Source: [QuantumBlockEncoding/PrimitiveSemantics.lean:482](../../../../library/modules/primitivesemantics/#decl-quantumblockencoding-primitiverefinement). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

# QuantumBlockEncoding/PromiseGateOptimization.lean

17 explicit public declarations, in source order.

:::definition "QuantumBlockEncoding.PromiseGateOptimization.liftTargetEquiv" (lean := "QuantumBlockEncoding.PromiseGateOptimization.liftTargetEquiv")
*Plain-English reading.* This definition gives the library's named construction or computation for “lift target equiv”. Apply a target permutation without changing its control register.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* Apply a target permutation without changing its control register.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/PromiseGateOptimization.lean:23](../../../../library/modules/promisegateoptimization/#decl-quantumblockencoding-promisegateoptimization-lifttargetequiv). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.PromiseGateOptimization.controlledTargetEquiv" (lean := "QuantumBlockEncoding.PromiseGateOptimization.controlledTargetEquiv")
*Plain-English reading.* This definition gives the library's named construction or computation for “controlled target equiv”. Apply the target permutation exactly on the 'true' control branch.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* Apply the target permutation exactly on the 'true' control branch.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/PromiseGateOptimization.lean:28](../../../../library/modules/promisegateoptimization/#decl-quantumblockencoding-promisegateoptimization-controlledtargetequiv). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.PromiseGateOptimization.conjugatedTargetEquiv" (lean := "QuantumBlockEncoding.PromiseGateOptimization.conjugatedTargetEquiv")
*Plain-English reading.* This definition gives the library's named construction or computation for “conjugated target equiv”. Chronological 'V', then 'U', then 'V†'.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* Chronological 'V', then 'U', then 'V†'.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/PromiseGateOptimization.lean:42](../../../../library/modules/promisegateoptimization/#decl-quantumblockencoding-promisegateoptimization-conjugatedtargetequiv). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.PromiseGateOptimization.controlledConjugation_equiv" (lean := "QuantumBlockEncoding.PromiseGateOptimization.controlledConjugation_equiv")
*Plain-English reading.* Lean checks the proposition indexed as “controlled conjugation equiv”; the hypotheses and conclusion in the code panel fix its exact scope. Figure 3(a): controlling 'V† U V' is equivalent to leaving 'V' and 'V†' uncontrolled and controlling only 'U'.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* Figure 3(a): controlling 'V† U V' is equivalent to leaving 'V' and 'V†' uncontrolled and controlling only 'U'.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/PromiseGateOptimization.lean:48](../../../../library/modules/promisegateoptimization/#decl-quantumblockencoding-promisegateoptimization-controlledconjugation-equiv). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.PromiseGateOptimization.controlledConjugation_matrix" (lean := "QuantumBlockEncoding.PromiseGateOptimization.controlledConjugation_matrix")
*Plain-English reading.* Lean checks the proposition indexed as “controlled conjugation matrix”; the hypotheses and conclusion in the code panel fix its exact scope. Matrix form of the controlled-conjugation identity.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* Matrix form of the controlled-conjugation identity.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/PromiseGateOptimization.lean:61](../../../../library/modules/promisegateoptimization/#decl-quantumblockencoding-promisegateoptimization-controlledconjugation-matrix). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.PromiseGateOptimization.WeakPromiseSpec" (lean := "QuantumBlockEncoding.PromiseGateOptimization.WeakPromiseSpec")
*Plain-English reading.* This definition gives the library's named construction or computation for “weak promise spec”. Exact clean-branch contract for a weak promise gate.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* Exact clean-branch contract for a weak promise gate. No behavior is required away from 'cleanPromise'.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/PromiseGateOptimization.lean:75](../../../../library/modules/promisegateoptimization/#decl-quantumblockencoding-promisegateoptimization-weakpromisespec). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.PromiseGateOptimization.StrongPromiseSpec" (lean := "QuantumBlockEncoding.PromiseGateOptimization.StrongPromiseSpec")
*Plain-English reading.* This definition gives the library's named construction or computation for “strong promise spec”. A strong promise gate additionally restores its promise register for every basis input.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* A strong promise gate additionally restores its promise register for every basis input.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/PromiseGateOptimization.lean:83](../../../../library/modules/promisegateoptimization/#decl-quantumblockencoding-promisegateoptimization-strongpromisespec). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.PromiseGateOptimization.StrongPromiseSpec.weak" (lean := "QuantumBlockEncoding.PromiseGateOptimization.StrongPromiseSpec.weak")
*Plain-English reading.* Lean checks the proposition indexed as “weak”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/PromiseGateOptimization.lean:89](../../../../library/modules/promisegateoptimization/#decl-quantumblockencoding-promisegateoptimization-strongpromisespec-weak). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.PromiseGateOptimization.toggleDirtyFlagEquiv" (lean := "QuantumBlockEncoding.PromiseGateOptimization.toggleDirtyFlagEquiv")
*Plain-English reading.* This definition gives the library's named construction or computation for “toggle dirty flag equiv”. Toggle a possibly dirty flag exactly when the control predicate holds.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* Toggle a possibly dirty flag exactly when the control predicate holds.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/PromiseGateOptimization.lean:97](../../../../library/modules/promisegateoptimization/#decl-quantumblockencoding-promisegateoptimization-toggledirtyflagequiv). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.PromiseGateOptimization.dirtyFlagControlledTargetEquiv" (lean := "QuantumBlockEncoding.PromiseGateOptimization.dirtyFlagControlledTargetEquiv")
*Plain-English reading.* This definition gives the library's named construction or computation for “dirty flag controlled target equiv”. Apply the target when the dirty flag is set, preserving key and flag.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* Apply the target when the dirty flag is set, preserving key and flag.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/PromiseGateOptimization.lean:111](../../../../library/modules/promisegateoptimization/#decl-quantumblockencoding-promisegateoptimization-dirtyflagcontrolledtargetequiv). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.PromiseGateOptimization.dirtyControlledInvolutionEquiv" (lean := "QuantumBlockEncoding.PromiseGateOptimization.dirtyControlledInvolutionEquiv")
*Plain-English reading.* This definition gives the library's named construction or computation for “dirty controlled involution equiv”. Compute-use-uncompute-use protocol from Figure 2(a), right-hand side.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* Compute-use-uncompute-use protocol from Figure 2(a), right-hand side.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/PromiseGateOptimization.lean:125](../../../../library/modules/promisegateoptimization/#decl-quantumblockencoding-promisegateoptimization-dirtycontrolledinvolutionequiv). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.PromiseGateOptimization.dirtyControlledInvolution_action" (lean := "QuantumBlockEncoding.PromiseGateOptimization.dirtyControlledInvolution_action")
*Plain-English reading.* Lean checks the proposition indexed as “dirty controlled involution action”; the hypotheses and conclusion in the code panel fix its exact scope. A dirty flag is restored and the requested controlled target is applied, provided the target is involutory.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* A dirty flag is restored and the requested controlled target is applied, provided the target is involutory.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/PromiseGateOptimization.lean:135](../../../../library/modules/promisegateoptimization/#decl-quantumblockencoding-promisegateoptimization-dirtycontrolledinvolution-action). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.PromiseGateOptimization.dirtyControlledInvolution_unitary" (lean := "QuantumBlockEncoding.PromiseGateOptimization.dirtyControlledInvolution_unitary")
*Plain-English reading.* Lean checks the proposition indexed as “dirty controlled involution unitary”; the hypotheses and conclusion in the code panel fix its exact scope. The dirty-flag protocol is unitary because it is a basis permutation.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The dirty-flag protocol is unitary because it is a basis permutation.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/PromiseGateOptimization.lean:146](../../../../library/modules/promisegateoptimization/#decl-quantumblockencoding-promisegateoptimization-dirtycontrolledinvolution-unitary). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.PromiseGateOptimization.ControlledProtocolCost" (lean := "QuantumBlockEncoding.PromiseGateOptimization.ControlledProtocolCost")
*Plain-English reading.* This record groups the data and proof fields needed for “controlled protocol cost”. A proposition-valued field is a requirement until a constructor supplies it. Abstract operation counts exposed to the ASPBE planner.

*Formal status.* Data contract in the default import surface; proposition-valued fields are obligations, not automatically established facts.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* Abstract operation counts exposed to the ASPBE planner.

*Declaration kind.* structure.

Source: [QuantumBlockEncoding/PromiseGateOptimization.lean:156](../../../../library/modules/promisegateoptimization/#decl-quantumblockencoding-promisegateoptimization-controlledprotocolcost). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.PromiseGateOptimization.cleanFlagProtocolCost" (lean := "QuantumBlockEncoding.PromiseGateOptimization.cleanFlagProtocolCost")
*Plain-English reading.* This definition gives the library's named construction or computation for “clean flag protocol cost”. Standard clean-flag construction: compute, use, uncompute.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* Standard clean-flag construction: compute, use, uncompute.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/PromiseGateOptimization.lean:164](../../../../library/modules/promisegateoptimization/#decl-quantumblockencoding-promisegateoptimization-cleanflagprotocolcost). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.PromiseGateOptimization.dirtyFlagProtocolCost" (lean := "QuantumBlockEncoding.PromiseGateOptimization.dirtyFlagProtocolCost")
*Plain-English reading.* This definition gives the library's named construction or computation for “dirty flag protocol cost”. Involutory dirty-flag construction: one extra controlled target use.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* Involutory dirty-flag construction: one extra controlled target use.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/PromiseGateOptimization.lean:171](../../../../library/modules/promisegateoptimization/#decl-quantumblockencoding-promisegateoptimization-dirtyflagprotocolcost). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.PromiseGateOptimization.dirtyFlag_replaces_cleanFlag" (lean := "QuantumBlockEncoding.PromiseGateOptimization.dirtyFlag_replaces_cleanFlag")
*Plain-English reading.* Lean checks the proposition indexed as “dirty flag replaces clean flag”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/PromiseGateOptimization.lean:177](../../../../library/modules/promisegateoptimization/#decl-quantumblockencoding-promisegateoptimization-dirtyflag-replaces-cleanflag). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

# QuantumBlockEncoding/ReversibleClassical.lean

7 explicit public declarations, in source order.

:::definition "QuantumBlockEncoding.ReversibleGate" (lean := "QuantumBlockEncoding.ReversibleGate")
*Plain-English reading.* This type lists the allowed alternatives for “reversible gate”; its constructors are the cases that downstream code must handle.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* inductive.

Source: [QuantumBlockEncoding/ReversibleClassical.lean:14](../../../../library/modules/reversibleclassical/#decl-quantumblockencoding-reversiblegate). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.ReversibleProgram" (lean := "QuantumBlockEncoding.ReversibleProgram")
*Plain-English reading.* This abbreviation gives a shorter name to the type or expression used for “reversible program”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* abbrev.

Source: [QuantumBlockEncoding/ReversibleClassical.lean:22](../../../../library/modules/reversibleclassical/#decl-quantumblockencoding-reversibleprogram). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.ccxBasisAction" (lean := "QuantumBlockEncoding.ccxBasisAction")
*Plain-English reading.* This definition gives the library's named construction or computation for “ccx basis action”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/ReversibleClassical.lean:24](../../../../library/modules/reversibleclassical/#decl-quantumblockencoding-ccxbasisaction). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.ccxBasisAction_involutive" (lean := "QuantumBlockEncoding.ccxBasisAction_involutive")
*Plain-English reading.* Lean checks the proposition indexed as “ccx basis action involutive”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/ReversibleClassical.lean:30](../../../../library/modules/reversibleclassical/#decl-quantumblockencoding-ccxbasisaction-involutive). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.ccxBasisEquiv" (lean := "QuantumBlockEncoding.ccxBasisEquiv")
*Plain-English reading.* This definition gives the library's named construction or computation for “ccx basis equiv”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/ReversibleClassical.lean:52](../../../../library/modules/reversibleclassical/#decl-quantumblockencoding-ccxbasisequiv). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.evalReversibleGate" (lean := "QuantumBlockEncoding.evalReversibleGate")
*Plain-English reading.* This definition gives the library's named construction or computation for “eval reversible gate”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/ReversibleClassical.lean:63](../../../../library/modules/reversibleclassical/#decl-quantumblockencoding-evalreversiblegate). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.evalReversibleProgram" (lean := "QuantumBlockEncoding.evalReversibleProgram")
*Plain-English reading.* This definition gives the library's named construction or computation for “eval reversible program”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/ReversibleClassical.lean:70](../../../../library/modules/reversibleclassical/#decl-quantumblockencoding-evalreversibleprogram). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

# QuantumBlockEncoding/TeachingRouteClosures.lean

35 explicit public declarations, in source order.

:::definition "QuantumBlockEncoding.ExecutableResourceCertificate" (lean := "QuantumBlockEncoding.ExecutableResourceCertificate")
*Plain-English reading.* This record groups the data and proof fields needed for “executable resource certificate”. A proposition-valued field is a requirement until a constructor supplies it. Backend-neutral cost evidence computed from the canonical primitive IR.

*Formal status.* Data contract in the default import surface; proposition-valued fields are obligations, not automatically established facts.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* Backend-neutral cost evidence computed from the canonical primitive IR.

*Declaration kind.* structure.

Source: [QuantumBlockEncoding/TeachingRouteClosures.lean:18](../../../../library/modules/teachingrouteclosures/#decl-quantumblockencoding-executableresourcecertificate). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.ExecutableResourceCertificate.resource" (lean := "QuantumBlockEncoding.ExecutableResourceCertificate.resource")
*Plain-English reading.* This definition gives the library's named construction or computation for “resource”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/TeachingRouteClosures.lean:24](../../../../library/modules/teachingrouteclosures/#decl-quantumblockencoding-executableresourcecertificate-resource). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.ExecutableResourceCertificate.cost" (lean := "QuantumBlockEncoding.ExecutableResourceCertificate.cost")
*Plain-English reading.* This definition gives the library's named construction or computation for “cost”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/TeachingRouteClosures.lean:27](../../../../library/modules/teachingrouteclosures/#decl-quantumblockencoding-executableresourcecertificate-cost). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.ExecutableResourceCertificate.resource_eq_program_resource" (lean := "QuantumBlockEncoding.ExecutableResourceCertificate.resource_eq_program_resource")
*Plain-English reading.* Lean checks the proposition indexed as “resource eq program resource”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/TeachingRouteClosures.lean:33](../../../../library/modules/teachingrouteclosures/#decl-quantumblockencoding-executableresourcecertificate-resource-eq-program-resource). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.ExecutableResourceCertificate.cost_auxiliaryQubits" (lean := "QuantumBlockEncoding.ExecutableResourceCertificate.cost_auxiliaryQubits")
*Plain-English reading.* Lean checks the proposition indexed as “cost auxiliary qubits”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/TeachingRouteClosures.lean:37](../../../../library/modules/teachingrouteclosures/#decl-quantumblockencoding-executableresourcecertificate-cost-auxiliaryqubits). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.ExecutableResourceCertificate.cost_gateCount" (lean := "QuantumBlockEncoding.ExecutableResourceCertificate.cost_gateCount")
*Plain-English reading.* Lean checks the proposition indexed as “cost gate count”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/TeachingRouteClosures.lean:41](../../../../library/modules/teachingrouteclosures/#decl-quantumblockencoding-executableresourcecertificate-cost-gatecount). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.ExecutableResourceCertificate.cost_depth" (lean := "QuantumBlockEncoding.ExecutableResourceCertificate.cost_depth")
*Plain-English reading.* Lean checks the proposition indexed as “cost depth”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/TeachingRouteClosures.lean:45](../../../../library/modules/teachingrouteclosures/#decl-quantumblockencoding-executableresourcecertificate-cost-depth). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.ExecutableResourceCertificate.cost_oracleCalls" (lean := "QuantumBlockEncoding.ExecutableResourceCertificate.cost_oracleCalls")
*Plain-English reading.* Lean checks the proposition indexed as “cost oracle calls”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/TeachingRouteClosures.lean:49](../../../../library/modules/teachingrouteclosures/#decl-quantumblockencoding-executableresourcecertificate-cost-oraclecalls). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.StatePreparationCandidate.certify" (lean := "QuantumBlockEncoding.StatePreparationCandidate.certify")
*Plain-English reading.* This definition gives the library's named construction or computation for “certify”. Promote a candidate only after all three state-preparation obligations are supplied.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* Promote a candidate only after all three state-preparation obligations are supplied.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/TeachingRouteClosures.lean:58](../../../../library/modules/teachingrouteclosures/#decl-quantumblockencoding-statepreparationcandidate-certify). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.StatePreparationCandidate.certify_firstColumn" (lean := "QuantumBlockEncoding.StatePreparationCandidate.certify_firstColumn")
*Plain-English reading.* Lean checks the proposition indexed as “certify first column”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/TeachingRouteClosures.lean:68](../../../../library/modules/teachingrouteclosures/#decl-quantumblockencoding-statepreparationcandidate-certify-firstcolumn). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.StatePreparationCandidate.certify_unitary" (lean := "QuantumBlockEncoding.StatePreparationCandidate.certify_unitary")
*Plain-English reading.* Lean checks the proposition indexed as “certify unitary”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/TeachingRouteClosures.lean:75](../../../../library/modules/teachingrouteclosures/#decl-quantumblockencoding-statepreparationcandidate-certify-unitary). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.StatePreparationCandidate.certify_normalization" (lean := "QuantumBlockEncoding.StatePreparationCandidate.certify_normalization")
*Plain-English reading.* Lean checks the proposition indexed as “certify normalization”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/TeachingRouteClosures.lean:82](../../../../library/modules/teachingrouteclosures/#decl-quantumblockencoding-statepreparationcandidate-certify-normalization). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.ConcreteSemantics.ComplexStatePreparationCertificate.ofFirstColumn" (lean := "QuantumBlockEncoding.ConcreteSemantics.ComplexStatePreparationCertificate.ofFirstColumn")
*Plain-English reading.* This definition gives the library's named construction or computation for “of first column”. Build concrete state-preparation evidence from the equivalent first-column statement.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* Build concrete state-preparation evidence from the equivalent first-column statement.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/TeachingRouteClosures.lean:94](../../../../library/modules/teachingrouteclosures/#decl-quantumblockencoding-concretesemantics-complexstatepreparationcertificate-offirstcolumn). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.ConcreteSemantics.ComplexStatePreparationCertificate.verifiedOfFirstColumn" (lean := "QuantumBlockEncoding.ConcreteSemantics.ComplexStatePreparationCertificate.verifiedOfFirstColumn")
*Plain-English reading.* This definition gives the library's named construction or computation for “verified of first column”. Promote first-column evidence through the concrete finite-matrix backend.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* Promote first-column evidence through the concrete finite-matrix backend.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/TeachingRouteClosures.lean:107](../../../../library/modules/teachingrouteclosures/#decl-quantumblockencoding-concretesemantics-complexstatepreparationcertificate-verifiedoffirstcolumn). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.ConcreteSemantics.ComplexStatePreparationCertificate.verifiedOfFirstColumn_preparesTarget" (lean := "QuantumBlockEncoding.ConcreteSemantics.ComplexStatePreparationCertificate.verifiedOfFirstColumn_preparesTarget")
*Plain-English reading.* Lean checks the proposition indexed as “verified of first column prepares target”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/TeachingRouteClosures.lean:116](../../../../library/modules/teachingrouteclosures/#decl-quantumblockencoding-concretesemantics-complexstatepreparationcertificate-verifiedoffirstcolumn-preparestarget). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.textbookPauliXVerifiedOfFirstColumn" (lean := "QuantumBlockEncoding.textbookPauliXVerifiedOfFirstColumn")
*Plain-English reading.* This definition gives the library's named construction or computation for “textbook pauli x verified of first column”. Finite witness that the generic first-column route reuses the Pauli-X proof.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* Finite witness that the generic first-column route reuses the Pauli-X proof.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/TeachingRouteClosures.lean:131](../../../../library/modules/teachingrouteclosures/#decl-quantumblockencoding-textbookpaulixverifiedoffirstcolumn). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.textbookPauliXVerifiedOfFirstColumn_preparesTarget" (lean := "QuantumBlockEncoding.textbookPauliXVerifiedOfFirstColumn_preparesTarget")
*Plain-English reading.* Lean checks the proposition indexed as “textbook pauli x verified of first column prepares target”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/TeachingRouteClosures.lean:141](../../../../library/modules/teachingrouteclosures/#decl-quantumblockencoding-textbookpaulixverifiedoffirstcolumn-preparestarget). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.ConcreteSemantics.exactCleanBlockOfSignalProjection" (lean := "QuantumBlockEncoding.ConcreteSemantics.exactCleanBlockOfSignalProjection")
*Plain-English reading.* This definition gives the library's named construction or computation for “exact clean block of signal projection”. Convert a signal-register projection proof into an exact clean-block certificate.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* Convert a signal-register projection proof into an exact clean-block certificate.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/TeachingRouteClosures.lean:148](../../../../library/modules/teachingrouteclosures/#decl-quantumblockencoding-concretesemantics-exactcleanblockofsignalprojection). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.ConcreteSemantics.exactCleanBlockOfSignalProjection_correct" (lean := "QuantumBlockEncoding.ConcreteSemantics.exactCleanBlockOfSignalProjection_correct")
*Plain-English reading.* Lean checks the proposition indexed as “exact clean block of signal projection correct”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/TeachingRouteClosures.lean:166](../../../../library/modules/teachingrouteclosures/#decl-quantumblockencoding-concretesemantics-exactcleanblockofsignalprojection-correct). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.CertifiedCircuitBlockExtraction" (lean := "QuantumBlockEncoding.CertifiedCircuitBlockExtraction")
*Plain-English reading.* This record groups the data and proof fields needed for “certified circuit block extraction”. A proposition-valued field is a requirement until a constructor supplies it. A circuit block extraction whose selected block equality is carried as a proof.

*Formal status.* Data contract in the default import surface; proposition-valued fields are obligations, not automatically established facts.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* A circuit block extraction whose selected block equality is carried as a proof.

*Declaration kind.* structure.

Source: [QuantumBlockEncoding/TeachingRouteClosures.lean:183](../../../../library/modules/teachingrouteclosures/#decl-quantumblockencoding-certifiedcircuitblockextraction). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.CertifiedCircuitBlockExtraction.extractionTarget" (lean := "QuantumBlockEncoding.CertifiedCircuitBlockExtraction.extractionTarget")
*Plain-English reading.* This definition gives the library's named construction or computation for “extraction target”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/TeachingRouteClosures.lean:198](../../../../library/modules/teachingrouteclosures/#decl-quantumblockencoding-certifiedcircuitblockextraction-extractiontarget). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.CertifiedCircuitBlockExtraction.normalizedTarget" (lean := "QuantumBlockEncoding.CertifiedCircuitBlockExtraction.normalizedTarget")
*Plain-English reading.* This definition gives the library's named construction or computation for “normalized target”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/TeachingRouteClosures.lean:218](../../../../library/modules/teachingrouteclosures/#decl-quantumblockencoding-certifiedcircuitblockextraction-normalizedtarget). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.CertifiedCircuitBlockExtraction.exactCleanBlock" (lean := "QuantumBlockEncoding.CertifiedCircuitBlockExtraction.exactCleanBlock")
*Plain-English reading.* This definition gives the library's named construction or computation for “exact clean block”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/TeachingRouteClosures.lean:222](../../../../library/modules/teachingrouteclosures/#decl-quantumblockencoding-certifiedcircuitblockextraction-exactcleanblock). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.CertifiedCircuitBlockExtraction.extractionTarget_blockProjection_proved" (lean := "QuantumBlockEncoding.CertifiedCircuitBlockExtraction.extractionTarget_blockProjection_proved")
*Plain-English reading.* Lean checks the proposition indexed as “extraction target block projection proved”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/TeachingRouteClosures.lean:230](../../../../library/modules/teachingrouteclosures/#decl-quantumblockencoding-certifiedcircuitblockextraction-extractiontarget-blockprojection-proved). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.CertifiedCircuitBlockExtraction.extractionTarget_blockCorrect_proved" (lean := "QuantumBlockEncoding.CertifiedCircuitBlockExtraction.extractionTarget_blockCorrect_proved")
*Plain-English reading.* Lean checks the proposition indexed as “extraction target block correct proved”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/TeachingRouteClosures.lean:234](../../../../library/modules/teachingrouteclosures/#decl-quantumblockencoding-certifiedcircuitblockextraction-extractiontarget-blockcorrect-proved). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.CertifiedCircuitBlockExtraction.exactCleanBlock_correct" (lean := "QuantumBlockEncoding.CertifiedCircuitBlockExtraction.exactCleanBlock_correct")
*Plain-English reading.* Lean checks the proposition indexed as “exact clean block correct”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/TeachingRouteClosures.lean:238](../../../../library/modules/teachingrouteclosures/#decl-quantumblockencoding-certifiedcircuitblockextraction-exactcleanblock-correct). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.teachingIdentityCircuitSemantics" (lean := "QuantumBlockEncoding.teachingIdentityCircuitSemantics")
*Plain-English reading.* This definition gives the library's named construction or computation for “teaching identity circuit semantics”. Empty-circuit semantics on the one-dimensional zero-qubit space.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* Empty-circuit semantics on the one-dimensional zero-qubit space.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/TeachingRouteClosures.lean:246](../../../../library/modules/teachingrouteclosures/#decl-quantumblockencoding-teachingidentitycircuitsemantics). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.teachingIdentityBlockExtraction" (lean := "QuantumBlockEncoding.teachingIdentityBlockExtraction")
*Plain-English reading.* This definition gives the library's named construction or computation for “teaching identity block extraction”. Finite witness for certified circuit block extraction.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* Finite witness for certified circuit block extraction.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/TeachingRouteClosures.lean:250](../../../../library/modules/teachingrouteclosures/#decl-quantumblockencoding-teachingidentityblockextraction). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.teachingIdentityBlockExtraction_correct" (lean := "QuantumBlockEncoding.teachingIdentityBlockExtraction_correct")
*Plain-English reading.* Lean checks the proposition indexed as “teaching identity block extraction correct”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/TeachingRouteClosures.lean:263](../../../../library/modules/teachingrouteclosures/#decl-quantumblockencoding-teachingidentityblockextraction-correct). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.OperatorBlockEncodingCandidate.certify" (lean := "QuantumBlockEncoding.OperatorBlockEncodingCandidate.certify")
*Plain-English reading.* This definition gives the library's named construction or computation for “certify”. Promote an operator candidate only after its unitary and block proofs are supplied.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* Promote an operator candidate only after its unitary and block proofs are supplied.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/TeachingRouteClosures.lean:271](../../../../library/modules/teachingrouteclosures/#decl-quantumblockencoding-operatorblockencodingcandidate-certify). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.OperatorBlockEncodingCandidate.cost_eq_fromLayoutAndResource" (lean := "QuantumBlockEncoding.OperatorBlockEncodingCandidate.cost_eq_fromLayoutAndResource")
*Plain-English reading.* Lean checks the proposition indexed as “cost eq from layout and resource”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/TeachingRouteClosures.lean:279](../../../../library/modules/teachingrouteclosures/#decl-quantumblockencoding-operatorblockencodingcandidate-cost-eq-fromlayoutandresource). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.BlockEncodingClassics.QSVTConsumerContract.identity" (lean := "QuantumBlockEncoding.BlockEncodingClassics.QSVTConsumerContract.identity")
*Plain-English reading.* This definition gives the library's named construction or computation for “identity”. Degree-one identity consumer: a proved clean block is returned unchanged.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* Degree-one identity consumer: a proved clean block is returned unchanged.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/TeachingRouteClosures.lean:291](../../../../library/modules/teachingrouteclosures/#decl-quantumblockencoding-blockencodingclassics-qsvtconsumercontract-identity). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.QSVTConsumerContract.identity_sideConditions" (lean := "QuantumBlockEncoding.BlockEncodingClassics.QSVTConsumerContract.identity_sideConditions")
*Plain-English reading.* Lean checks the proposition indexed as “identity side conditions”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/TeachingRouteClosures.lean:300](../../../../library/modules/teachingrouteclosures/#decl-quantumblockencoding-blockencodingclassics-qsvtconsumercontract-identity-sideconditions). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.BlockEncodingClassics.QSVTConsumerContract.identity_output" (lean := "QuantumBlockEncoding.BlockEncodingClassics.QSVTConsumerContract.identity_output")
*Plain-English reading.* Lean checks the proposition indexed as “identity output”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/TeachingRouteClosures.lean:304](../../../../library/modules/teachingrouteclosures/#decl-quantumblockencoding-blockencodingclassics-qsvtconsumercontract-identity-output). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.teachingIdentityQSVTConsumer" (lean := "QuantumBlockEncoding.teachingIdentityQSVTConsumer")
*Plain-English reading.* This definition gives the library's named construction or computation for “teaching identity qsvt consumer”. Finite witness that a certified clean block crosses the typed QSVT boundary.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* Finite witness that a certified clean block crosses the typed QSVT boundary.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/TeachingRouteClosures.lean:311](../../../../library/modules/teachingrouteclosures/#decl-quantumblockencoding-teachingidentityqsvtconsumer). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

# QuantumBlockEncoding/TextbookStatePreparation.lean

29 explicit public declarations, in source order.

:::definition "QuantumBlockEncoding.TextbookStatePreparation.zeroIndex" (lean := "QuantumBlockEncoding.TextbookStatePreparation.zeroIndex")
*Plain-English reading.* This definition gives the library's named construction or computation for “zero index”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/TextbookStatePreparation.lean:20](../../../../library/modules/textbookstatepreparation/#decl-quantumblockencoding-textbookstatepreparation-zeroindex). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.TextbookStatePreparation.oneIndex" (lean := "QuantumBlockEncoding.TextbookStatePreparation.oneIndex")
*Plain-English reading.* This definition gives the library's named construction or computation for “one index”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/TextbookStatePreparation.lean:22](../../../../library/modules/textbookstatepreparation/#decl-quantumblockencoding-textbookstatepreparation-oneindex). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.TextbookStatePreparation.pauliX" (lean := "QuantumBlockEncoding.TextbookStatePreparation.pauliX")
*Plain-English reading.* This definition gives the library's named construction or computation for “pauli x”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/TextbookStatePreparation.lean:24](../../../../library/modules/textbookstatepreparation/#decl-quantumblockencoding-textbookstatepreparation-paulix). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.TextbookStatePreparation.pauliX_unitary" (lean := "QuantumBlockEncoding.TextbookStatePreparation.pauliX_unitary")
*Plain-English reading.* Lean checks the proposition indexed as “pauli x unitary”; the hypotheses and conclusion in the code panel fix its exact scope. The Pauli X matrix is unitary in Mathlib's standard unitary group.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The Pauli X matrix is unitary in Mathlib's standard unitary group.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/TextbookStatePreparation.lean:28](../../../../library/modules/textbookstatepreparation/#decl-quantumblockencoding-textbookstatepreparation-paulix-unitary). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.TextbookStatePreparation.oneState" (lean := "QuantumBlockEncoding.TextbookStatePreparation.oneState")
*Plain-English reading.* This definition gives the library's named construction or computation for “one state”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/TextbookStatePreparation.lean:35](../../../../library/modules/textbookstatepreparation/#decl-quantumblockencoding-textbookstatepreparation-onestate). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.TextbookStatePreparation.oneTarget" (lean := "QuantumBlockEncoding.TextbookStatePreparation.oneTarget")
*Plain-English reading.* This definition gives the library's named construction or computation for “one target”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/TextbookStatePreparation.lean:38](../../../../library/modules/textbookstatepreparation/#decl-quantumblockencoding-textbookstatepreparation-onetarget). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.TextbookStatePreparation.oneTarget_normalized" (lean := "QuantumBlockEncoding.TextbookStatePreparation.oneTarget_normalized")
*Plain-English reading.* Lean checks the proposition indexed as “one target normalized”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/TextbookStatePreparation.lean:43](../../../../library/modules/textbookstatepreparation/#decl-quantumblockencoding-textbookstatepreparation-onetarget-normalized). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.TextbookStatePreparation.pauliX_prepares_one" (lean := "QuantumBlockEncoding.TextbookStatePreparation.pauliX_prepares_one")
*Plain-English reading.* Lean checks the proposition indexed as “pauli x prepares one”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/TextbookStatePreparation.lean:49](../../../../library/modules/textbookstatepreparation/#decl-quantumblockencoding-textbookstatepreparation-paulix-prepares-one). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.TextbookStatePreparation.pauliXGate" (lean := "QuantumBlockEncoding.TextbookStatePreparation.pauliXGate")
*Plain-English reading.* This definition gives the library's named construction or computation for “pauli x gate”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/TextbookStatePreparation.lean:62](../../../../library/modules/textbookstatepreparation/#decl-quantumblockencoding-textbookstatepreparation-paulixgate). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.TextbookStatePreparation.pauliXCertificate" (lean := "QuantumBlockEncoding.TextbookStatePreparation.pauliXCertificate")
*Plain-English reading.* This definition gives the library's named construction or computation for “pauli x certificate”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/TextbookStatePreparation.lean:66](../../../../library/modules/textbookstatepreparation/#decl-quantumblockencoding-textbookstatepreparation-paulixcertificate). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.TextbookStatePreparation.pauliXCircuit" (lean := "QuantumBlockEncoding.TextbookStatePreparation.pauliXCircuit")
*Plain-English reading.* This definition gives the library's named construction or computation for “pauli x circuit”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/TextbookStatePreparation.lean:72](../../../../library/modules/textbookstatepreparation/#decl-quantumblockencoding-textbookstatepreparation-paulixcircuit). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.TextbookStatePreparation.pauliXVerified" (lean := "QuantumBlockEncoding.TextbookStatePreparation.pauliXVerified")
*Plain-English reading.* This definition gives the library's named construction or computation for “pauli x verified”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/TextbookStatePreparation.lean:74](../../../../library/modules/textbookstatepreparation/#decl-quantumblockencoding-textbookstatepreparation-paulixverified). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.TextbookStatePreparation.pauliXVerified_cost" (lean := "QuantumBlockEncoding.TextbookStatePreparation.pauliXVerified_cost")
*Plain-English reading.* Lean checks the proposition indexed as “pauli x verified cost”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/TextbookStatePreparation.lean:78](../../../../library/modules/textbookstatepreparation/#decl-quantumblockencoding-textbookstatepreparation-paulixverified-cost). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.TextbookStatePreparation.invSqrtTwo" (lean := "QuantumBlockEncoding.TextbookStatePreparation.invSqrtTwo")
*Plain-English reading.* This definition gives the library's named construction or computation for “inv sqrt two”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/TextbookStatePreparation.lean:83](../../../../library/modules/textbookstatepreparation/#decl-quantumblockencoding-textbookstatepreparation-invsqrttwo). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.TextbookStatePreparation.invSqrtTwo_mul_self" (lean := "QuantumBlockEncoding.TextbookStatePreparation.invSqrtTwo_mul_self")
*Plain-English reading.* Lean checks the proposition indexed as “inv sqrt two mul self”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/TextbookStatePreparation.lean:86](../../../../library/modules/textbookstatepreparation/#decl-quantumblockencoding-textbookstatepreparation-invsqrttwo-mul-self). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.TextbookStatePreparation.hadamard" (lean := "QuantumBlockEncoding.TextbookStatePreparation.hadamard")
*Plain-English reading.* This definition gives the library's named construction or computation for “hadamard”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/TextbookStatePreparation.lean:94](../../../../library/modules/textbookstatepreparation/#decl-quantumblockencoding-textbookstatepreparation-hadamard). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.TextbookStatePreparation.star_hadamard" (lean := "QuantumBlockEncoding.TextbookStatePreparation.star_hadamard")
*Plain-English reading.* Lean checks the proposition indexed as “star hadamard”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/TextbookStatePreparation.lean:99](../../../../library/modules/textbookstatepreparation/#decl-quantumblockencoding-textbookstatepreparation-star-hadamard). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.TextbookStatePreparation.hadamard_unitary" (lean := "QuantumBlockEncoding.TextbookStatePreparation.hadamard_unitary")
*Plain-English reading.* Lean checks the proposition indexed as “hadamard unitary”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/TextbookStatePreparation.lean:104](../../../../library/modules/textbookstatepreparation/#decl-quantumblockencoding-textbookstatepreparation-hadamard-unitary). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.TextbookStatePreparation.plusState" (lean := "QuantumBlockEncoding.TextbookStatePreparation.plusState")
*Plain-English reading.* This definition gives the library's named construction or computation for “plus state”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/TextbookStatePreparation.lean:113](../../../../library/modules/textbookstatepreparation/#decl-quantumblockencoding-textbookstatepreparation-plusstate). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.TextbookStatePreparation.plusTarget" (lean := "QuantumBlockEncoding.TextbookStatePreparation.plusTarget")
*Plain-English reading.* This definition gives the library's named construction or computation for “plus target”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/TextbookStatePreparation.lean:116](../../../../library/modules/textbookstatepreparation/#decl-quantumblockencoding-textbookstatepreparation-plustarget). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.TextbookStatePreparation.plusTarget_normalized" (lean := "QuantumBlockEncoding.TextbookStatePreparation.plusTarget_normalized")
*Plain-English reading.* Lean checks the proposition indexed as “plus target normalized”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/TextbookStatePreparation.lean:121](../../../../library/modules/textbookstatepreparation/#decl-quantumblockencoding-textbookstatepreparation-plustarget-normalized). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.TextbookStatePreparation.hadamard_prepares_plus" (lean := "QuantumBlockEncoding.TextbookStatePreparation.hadamard_prepares_plus")
*Plain-English reading.* Lean checks the proposition indexed as “hadamard prepares plus”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/TextbookStatePreparation.lean:128](../../../../library/modules/textbookstatepreparation/#decl-quantumblockencoding-textbookstatepreparation-hadamard-prepares-plus). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.TextbookStatePreparation.hadamardGate" (lean := "QuantumBlockEncoding.TextbookStatePreparation.hadamardGate")
*Plain-English reading.* This definition gives the library's named construction or computation for “hadamard gate”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/TextbookStatePreparation.lean:139](../../../../library/modules/textbookstatepreparation/#decl-quantumblockencoding-textbookstatepreparation-hadamardgate). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.TextbookStatePreparation.hadamardCertificate" (lean := "QuantumBlockEncoding.TextbookStatePreparation.hadamardCertificate")
*Plain-English reading.* This definition gives the library's named construction or computation for “hadamard certificate”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/TextbookStatePreparation.lean:143](../../../../library/modules/textbookstatepreparation/#decl-quantumblockencoding-textbookstatepreparation-hadamardcertificate). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.TextbookStatePreparation.hadamardCircuit" (lean := "QuantumBlockEncoding.TextbookStatePreparation.hadamardCircuit")
*Plain-English reading.* This definition gives the library's named construction or computation for “hadamard circuit”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/TextbookStatePreparation.lean:150](../../../../library/modules/textbookstatepreparation/#decl-quantumblockencoding-textbookstatepreparation-hadamardcircuit). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.TextbookStatePreparation.hadamardVerified" (lean := "QuantumBlockEncoding.TextbookStatePreparation.hadamardVerified")
*Plain-English reading.* This definition gives the library's named construction or computation for “hadamard verified”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/TextbookStatePreparation.lean:152](../../../../library/modules/textbookstatepreparation/#decl-quantumblockencoding-textbookstatepreparation-hadamardverified). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.TextbookStatePreparation.hadamardVerified_cost" (lean := "QuantumBlockEncoding.TextbookStatePreparation.hadamardVerified_cost")
*Plain-English reading.* Lean checks the proposition indexed as “hadamard verified cost”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/TextbookStatePreparation.lean:156](../../../../library/modules/textbookstatepreparation/#decl-quantumblockencoding-textbookstatepreparation-hadamardverified-cost). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.TextbookStatePreparation.pauliXCertificate_prepares_one" (lean := "QuantumBlockEncoding.TextbookStatePreparation.pauliXCertificate_prepares_one")
*Plain-English reading.* Lean checks the proposition indexed as “pauli x certificate prepares one”; the hypotheses and conclusion in the code panel fix its exact scope. The certified Pauli X example states the familiar textbook equation.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The certified Pauli X example states the familiar textbook equation.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/TextbookStatePreparation.lean:162](../../../../library/modules/textbookstatepreparation/#decl-quantumblockencoding-textbookstatepreparation-paulixcertificate-prepares-one). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.TextbookStatePreparation.hadamardCertificate_prepares_plus" (lean := "QuantumBlockEncoding.TextbookStatePreparation.hadamardCertificate_prepares_plus")
*Plain-English reading.* Lean checks the proposition indexed as “hadamard certificate prepares plus”; the hypotheses and conclusion in the code panel fix its exact scope. The certified Hadamard example prepares the equal superposition.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The certified Hadamard example prepares the equal superposition.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/TextbookStatePreparation.lean:168](../../../../library/modules/textbookstatepreparation/#decl-quantumblockencoding-textbookstatepreparation-hadamardcertificate-prepares-plus). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

# QuantumBlockEncoding/UniformlyControlledRy.lean

11 explicit public declarations, in source order.

:::definition "QuantumBlockEncoding.primitiveControlAssignment" (lean := "QuantumBlockEncoding.primitiveControlAssignment")
*Plain-English reading.* This definition gives the library's named construction or computation for “primitive control assignment”.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/UniformlyControlledRy.lean:34](../../../../library/modules/uniformlycontrolledry/#decl-quantumblockencoding-primitivecontrolassignment). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.controlledRyBlockMatrix" (lean := "QuantumBlockEncoding.controlledRyBlockMatrix")
*Plain-English reading.* This definition gives the library's named construction or computation for “controlled ry block matrix”. Backend-independent specification: each fixed assignment of the non-target wires owns one exact two-dimensional RY block selected by the control bits.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* Backend-independent specification: each fixed assignment of the non-target wires owns one exact two-dimensional RY block selected by the control bits.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/UniformlyControlledRy.lean:42](../../../../library/modules/uniformlycontrolledry/#decl-quantumblockencoding-controlledryblockmatrix). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.controlledRyBlockMatrix_apply" (lean := "QuantumBlockEncoding.controlledRyBlockMatrix_apply")
*Plain-English reading.* Lean checks the proposition indexed as “controlled ry block matrix apply”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/UniformlyControlledRy.lean:51](../../../../library/modules/uniformlycontrolledry/#decl-quantumblockencoding-controlledryblockmatrix-apply). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.compileUniformlyControlledRy" (lean := "QuantumBlockEncoding.compileUniformlyControlledRy")
*Plain-English reading.* This definition gives the library's named construction or computation for “compile uniformly controlled ry”. Reference recursive compiler.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* Reference recursive compiler. Controls are consumed from low to high in the supplied control tuple; circuit execution remains chronological.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/UniformlyControlledRy.lean:192](../../../../library/modules/uniformlycontrolledry/#decl-quantumblockencoding-compileuniformlycontrolledry). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.uniformlyControlledRyMatrix" (lean := "QuantumBlockEncoding.uniformlyControlledRyMatrix")
*Plain-English reading.* This definition gives the library's named construction or computation for “uniformly controlled ry matrix”. Recursive matrix specification corresponding to the standard multiplexor identity.

*Formal status.* Compiled declaration in the default ASPBE import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* Recursive matrix specification corresponding to the standard multiplexor identity. This definition is backend-independent and mentions only exact primitive matrix semantics.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/UniformlyControlledRy.lean:217](../../../../library/modules/uniformlycontrolledry/#decl-quantumblockencoding-uniformlycontrolledrymatrix). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.compileUniformlyControlledRy_eval" (lean := "QuantumBlockEncoding.compileUniformlyControlledRy_eval")
*Plain-English reading.* Lean checks the proposition indexed as “compile uniformly controlled ry eval”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/UniformlyControlledRy.lean:240](../../../../library/modules/uniformlycontrolledry/#decl-quantumblockencoding-compileuniformlycontrolledry-eval). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.compileUniformlyControlledRy_eval_controlledRyBlockMatrix" (lean := "QuantumBlockEncoding.compileUniformlyControlledRy_eval_controlledRyBlockMatrix")
*Plain-English reading.* Lean checks the proposition indexed as “compile uniformly controlled ry eval controlled ry block matrix”; the hypotheses and conclusion in the code panel fix its exact scope. The recursive compiler satisfies the independent block-diagonal specification selected by the computational-basis controls.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The recursive compiler satisfies the independent block-diagonal specification selected by the computational-basis controls.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/UniformlyControlledRy.lean:259](../../../../library/modules/uniformlycontrolledry/#decl-quantumblockencoding-compileuniformlycontrolledry-eval-controlledryblockmatrix). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.compileUniformlyControlledRy_ryCount" (lean := "QuantumBlockEncoding.compileUniformlyControlledRy_ryCount")
*Plain-English reading.* Lean checks the proposition indexed as “compile uniformly controlled ry ry count”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/UniformlyControlledRy.lean:370](../../../../library/modules/uniformlycontrolledry/#decl-quantumblockencoding-compileuniformlycontrolledry-rycount). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.compileUniformlyControlledRy_cxCount" (lean := "QuantumBlockEncoding.compileUniformlyControlledRy_cxCount")
*Plain-English reading.* Lean checks the proposition indexed as “compile uniformly controlled ry cx count”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/UniformlyControlledRy.lean:386](../../../../library/modules/uniformlycontrolledry/#decl-quantumblockencoding-compileuniformlycontrolledry-cxcount). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.compileUniformlyControlledRy_oracleCalls_eq_zero" (lean := "QuantumBlockEncoding.compileUniformlyControlledRy_oracleCalls_eq_zero")
*Plain-English reading.* Lean checks the proposition indexed as “compile uniformly controlled ry oracle calls eq zero”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/UniformlyControlledRy.lean:403](../../../../library/modules/uniformlycontrolledry/#decl-quantumblockencoding-compileuniformlycontrolledry-oraclecalls-eq-zero). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.compileUniformlyControlledRy_five_control_counts" (lean := "QuantumBlockEncoding.compileUniformlyControlledRy_five_control_counts")
*Plain-English reading.* Lean checks the proposition indexed as “compile uniformly controlled ry five control counts”; the hypotheses and conclusion in the code panel fix its exact scope. Frozen Robin reference count: five controls require 32 RY and 62 CX.

*Formal status.* Compiled theorem in the default ASPBE import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* Frozen Robin reference count: five controls require 32 RY and 62 CX.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/UniformlyControlledRy.lean:411](../../../../library/modules/uniformlycontrolledry/#decl-quantumblockencoding-compileuniformlycontrolledry-five-control-counts). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

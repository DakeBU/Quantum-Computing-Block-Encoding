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

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

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

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* Check that a list of gate matrices labels exactly the same circuit gates.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:41](../../../../library/modules/circuitsemantics/#decl-quantumblockencoding-gatematricesmatchcircuit). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.evalGateMatrices" (lean := "QuantumBlockEncoding.evalGateMatrices")
*Plain-English reading.* This definition gives the library's named construction or computation for “eval gate matrices”. Evaluate a list of full-space gate matrices to a circuit matrix.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* Evaluate a list of full-space gate matrices to a circuit matrix. The fold uses the usual right-action convention for a circuit list '\[g₁, g₂, ...\]': the resulting matrix is 'g\_k \* ... \* g₂ \* g₁'.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:54](../../../../library/modules/circuitsemantics/#decl-quantumblockencoding-evalgatematrices). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.Matrix.evalWith_foldl_add_mul" (lean := "QuantumBlockEncoding.Matrix.evalWith_foldl_add_mul")
*Plain-English reading.* Lean checks the proposition indexed as “eval with foldl add mul”; the hypotheses and conclusion in the code panel fix its exact scope. Evaluate one symbolic matrix-product entry as a concrete finite Rat fold.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* Evaluate one symbolic matrix-product entry as a concrete finite Rat fold. The project-local 'Coeff' matrices are syntactic, so a raw 'Matrix.mul' entry does not simplify away zero summands. This lemma moves the finite product entry through 'Coeff.evalWith', where later path-isolation proofs can use ordinary rational arithmetic without expanding the whole symbolic expression.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:71](../../../../library/modules/circuitsemantics/#decl-quantumblockencoding-matrix-evalwith-foldl-add-mul). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.Matrix.evalWith_mul_apply" (lean := "QuantumBlockEncoding.Matrix.evalWith_mul_apply")
*Plain-English reading.* Lean checks the proposition indexed as “eval with mul apply”; the hypotheses and conclusion in the code panel fix its exact scope. Evaluate one entry of 'Matrix.mul' by evaluating each path contribution.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* Evaluate one entry of 'Matrix.mul' by evaluating each path contribution. This is the local matrix-semantics block needed before a focused Robin seven-gate path proof can avoid syntactic 'Coeff.add' blow-up.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:92](../../../../library/modules/circuitsemantics/#decl-quantumblockencoding-matrix-evalwith-mul-apply). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.Matrix.evalWith_mul_eq_zero_of_all_paths_zero" (lean := "QuantumBlockEncoding.Matrix.evalWith_mul_eq_zero_of_all_paths_zero")
*Plain-English reading.* Lean checks the proposition indexed as “eval with mul eq zero of all paths zero”; the hypotheses and conclusion in the code panel fix its exact scope. Evaluate one matrix-product entry as zero when every evaluated path contribution is zero.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* Evaluate one matrix-product entry as zero when every evaluated path contribution is zero. This is the zero-support companion to 'evalWith\_mul\_unique\_path'. It lets paper-specific product proofs avoid expanding a large symbolic 'Coeff' fold when they have already isolated gate-local support facts.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:131](../../../../library/modules/circuitsemantics/#decl-quantumblockencoding-matrix-evalwith-mul-eq-zero-of-all-paths-zero). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.Matrix.evalWith_mul_unique_path" (lean := "QuantumBlockEncoding.Matrix.evalWith_mul_unique_path")
*Plain-English reading.* Lean checks the proposition indexed as “eval with mul unique path”; the hypotheses and conclusion in the code panel fix its exact scope. Evaluate one matrix-product entry when all evaluated paths except 'k0' vanish.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* Evaluate one matrix-product entry when all evaluated paths except 'k0' vanish. This is the reusable path-isolation block for later Robin gamma3 work: a theorem about the seven-gate product can first prove zero-support facts for all unwanted intermediate states, then reduce the evaluated product to the single surviving contribution.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:304](../../../../library/modules/circuitsemantics/#decl-quantumblockencoding-matrix-evalwith-mul-unique-path). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.Matrix.evalWith_mul_two_path" (lean := "QuantumBlockEncoding.Matrix.evalWith_mul_two_path")
*Plain-English reading.* Lean checks the proposition indexed as “eval with mul two path”; the hypotheses and conclusion in the code panel fix its exact scope. Evaluate one matrix-product entry when all evaluated paths except 'k0' and 'k1' vanish.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* Evaluate one matrix-product entry when all evaluated paths except 'k0' and 'k1' vanish. This is the two-path companion to 'evalWith\_mul\_unique\_path'. A seven-gate product proof can first establish that only two intermediate rows contribute, then reduce the evaluated product to their sum using this theorem.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:328](../../../../library/modules/circuitsemantics/#decl-quantumblockencoding-matrix-evalwith-mul-two-path). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.Matrix.evalWith_mul_identity_right_apply" (lean := "QuantumBlockEncoding.Matrix.evalWith_mul_identity_right_apply")
*Plain-English reading.* Lean checks the proposition indexed as “eval with mul identity right apply”; the hypotheses and conclusion in the code panel fix its exact scope. Evaluating a symbolic matrix after multiplying on the right by the identity recovers the evaluated entry.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* Evaluating a symbolic matrix after multiplying on the right by the identity recovers the evaluated entry. The statement is evaluation-level, not syntactic: 'Coeff' deliberately stores matrix products as explicit fold expressions, so the raw 'Coeff' term still contains zero summands.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:355](../../../../library/modules/circuitsemantics/#decl-quantumblockencoding-matrix-evalwith-mul-identity-right-apply). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.Matrix.cast_square_apply" (lean := "QuantumBlockEncoding.Matrix.cast_square_apply")
*Plain-English reading.* Lean checks the proposition indexed as “cast square apply”; the hypotheses and conclusion in the code panel fix its exact scope. Entry-level bridge for square matrix casts along a dimension equality.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* Entry-level bridge for square matrix casts along a dimension equality. This keeps paper-specific finite-entry proofs from unfolding a large casted matrix when the only content is that the row and column values are unchanged.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:371](../../../../library/modules/circuitsemantics/#decl-quantumblockencoding-matrix-cast-square-apply). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.evalWith_evalGateMatrices_single" (lean := "QuantumBlockEncoding.evalWith_evalGateMatrices_single")
*Plain-English reading.* Lean checks the proposition indexed as “eval with eval gate matrices single”; the hypotheses and conclusion in the code panel fix its exact scope. Evaluation-level single-gate reduction for 'evalGateMatrices'.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

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

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

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

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The prepared-composition equality required by the target.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:454](../../../../library/modules/circuitsemantics/#decl-quantumblockencoding-preparedcircuitentrytarget-entryequalitystatement). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.PreparedCircuitEntryTarget.matrixEntryEqualityStatement" (lean := "QuantumBlockEncoding.PreparedCircuitEntryTarget.matrixEntryEqualityStatement")
*Plain-English reading.* This definition gives the library's named construction or computation for “matrix entry equality statement”. The same equality stated directly on the backing matrices.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The same equality stated directly on the backing matrices.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:459](../../../../library/modules/circuitsemantics/#decl-quantumblockencoding-preparedcircuitentrytarget-matrixentryequalitystatement). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.PreparedCircuitEntryTarget.entryEqualityStatement_iff_matrixEntryEqualityStatement" (lean := "QuantumBlockEncoding.PreparedCircuitEntryTarget.entryEqualityStatement_iff_matrixEntryEqualityStatement")
*Plain-English reading.* Lean checks the proposition indexed as “entry equality statement iff matrix entry equality statement”; the hypotheses and conclusion in the code panel fix its exact scope. The cached entry equality is equivalent to the backing matrix-entry equality.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

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

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

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

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The selected-branch identity exposed by the target.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:559](../../../../library/modules/circuitsemantics/#decl-quantumblockencoding-blockextractionbranchcontributiontarget-selectedbranchstatement). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.BlockExtractionBranchContributionTarget.projectionSummationStatement" (lean := "QuantumBlockEncoding.BlockExtractionBranchContributionTarget.projectionSummationStatement")
*Plain-English reading.* This definition gives the library's named construction or computation for “projection summation statement”. The projection/summation theorem still required for the target.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The projection/summation theorem still required for the target.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:569](../../../../library/modules/circuitsemantics/#decl-quantumblockencoding-blockextractionbranchcontributiontarget-projectionsummationstatement). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.BlockExtractionBranchContributionTarget.backendExpansionStatement" (lean := "QuantumBlockEncoding.BlockExtractionBranchContributionTarget.backendExpansionStatement")
*Plain-English reading.* This definition gives the library's named construction or computation for “backend expansion statement”. The backend expansion theorem needed to close 'projectionSummationStatement'.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The backend expansion theorem needed to close 'projectionSummationStatement'. This version is stated directly in terms of the extraction target's block matrix entry and the candidate branch-contribution fold. It is useful as a proof-DAG interface because paper-specific projection backends can target this statement without depending on the record's cached 'blockEntry' and 'branchSum' fields.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:586](../../../../library/modules/circuitsemantics/#decl-quantumblockencoding-blockextractionbranchcontributiontarget-backendexpansionstatement). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.BlockExtractionBranchContributionTarget.selectedBranchStatement_of_eq" (lean := "QuantumBlockEncoding.BlockExtractionBranchContributionTarget.selectedBranchStatement_of_eq")
*Plain-English reading.* Lean checks the proposition indexed as “selected branch statement of eq”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:595](../../../../library/modules/circuitsemantics/#decl-quantumblockencoding-blockextractionbranchcontributiontarget-selectedbranchstatement-of-eq). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.BlockExtractionBranchContributionTarget.projectionSummationStatement_iff_backendExpansionStatement" (lean := "QuantumBlockEncoding.BlockExtractionBranchContributionTarget.projectionSummationStatement_iff_backendExpansionStatement")
*Plain-English reading.* Lean checks the proposition indexed as “projection summation statement iff backend expansion statement”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:603](../../../../library/modules/circuitsemantics/#decl-quantumblockencoding-blockextractionbranchcontributiontarget-projectionsummationstatement-iff-backendexpansionstatement). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.BlockExtractionBranchContributionTarget.projectionSummationStatement_of_backendExpansionStatement" (lean := "QuantumBlockEncoding.BlockExtractionBranchContributionTarget.projectionSummationStatement_of_backendExpansionStatement")
*Plain-English reading.* Lean checks the proposition indexed as “projection summation statement of backend expansion statement”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:629](../../../../library/modules/circuitsemantics/#decl-quantumblockencoding-blockextractionbranchcontributiontarget-projectionsummationstatement-of-backendexpansionstatement). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.BlockExtractionBranchContributionTarget.backendExpansionStatement_of_projectionSummationStatement" (lean := "QuantumBlockEncoding.BlockExtractionBranchContributionTarget.backendExpansionStatement_of_projectionSummationStatement")
*Plain-English reading.* Lean checks the proposition indexed as “backend expansion statement of projection summation statement”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

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

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* Compound row index for a signal value and a system-row index.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:696](../../../../library/modules/circuitsemantics/#decl-quantumblockencoding-signalsystemblockrowindex). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.signalSystemBlockColIndex" (lean := "QuantumBlockEncoding.signalSystemBlockColIndex")
*Plain-English reading.* This definition gives the library's named construction or computation for “signal system block col index”. Compound column index for a signal value and a system-column index.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* Compound column index for a signal value and a system-column index.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:700](../../../../library/modules/circuitsemantics/#decl-quantumblockencoding-signalsystemblockcolindex). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.signalSystemBlockRowIndex_zero" (lean := "QuantumBlockEncoding.signalSystemBlockRowIndex_zero")
*Plain-English reading.* Lean checks the proposition indexed as “signal system block row index zero”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:703](../../../../library/modules/circuitsemantics/#decl-quantumblockencoding-signalsystemblockrowindex-zero). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.signalSystemBlockColIndex_zero" (lean := "QuantumBlockEncoding.signalSystemBlockColIndex_zero")
*Plain-English reading.* Lean checks the proposition indexed as “signal system block col index zero”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:707](../../../../library/modules/circuitsemantics/#decl-quantumblockencoding-signalsystemblockcolindex-zero). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.signalSystemBlockRowIndex_lt" (lean := "QuantumBlockEncoding.signalSystemBlockRowIndex_lt")
*Plain-English reading.* Lean checks the proposition indexed as “signal system block row index lt”; the hypotheses and conclusion in the code panel fix its exact scope. The row compound index stays inside a signal × row matrix.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The row compound index stays inside a signal × row matrix.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:712](../../../../library/modules/circuitsemantics/#decl-quantumblockencoding-signalsystemblockrowindex-lt). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.signalSystemBlockColIndex_lt" (lean := "QuantumBlockEncoding.signalSystemBlockColIndex_lt")
*Plain-English reading.* Lean checks the proposition indexed as “signal system block col index lt”; the hypotheses and conclusion in the code panel fix its exact scope. The column compound index stays inside a signal × column matrix.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The column compound index stays inside a signal × column matrix.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:727](../../../../library/modules/circuitsemantics/#decl-quantumblockencoding-signalsystemblockcolindex-lt). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.signalSystemBlockProjection" (lean := "QuantumBlockEncoding.signalSystemBlockProjection")
*Plain-English reading.* This definition gives the library's named construction or computation for “signal system block projection”. Block projection: extract the '(signalIdx, signalIdx)' block from a signal × system matrix.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* Block projection: extract the '(signalIdx, signalIdx)' block from a signal × system matrix. Given a matrix M of size '(signalDim \* rows) × (signalDim \* cols)', the helpers 'signalSystemBlockRowIndex' and 'signalSystemBlockColIndex' map a pair '(i, j)' of system indices to the compound row and column indices in the full matrix that correspond to signal register value 'idx' and system indices '(i, j)'. The block '(⟨signalIdx| ⊗ I) M (|signalIdx⟩ ⊗ I)' is then: blockMatrix i j = M (signalIdx \* rows + i) (signalIdx \* cols + j)

*Declaration kind.* def.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:753](../../../../library/modules/circuitsemantics/#decl-quantumblockencoding-signalsystemblockprojection). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.signalSystemBlockProjection_apply" (lean := "QuantumBlockEncoding.signalSystemBlockProjection_apply")
*Plain-English reading.* Lean checks the proposition indexed as “signal system block projection apply”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:764](../../../../library/modules/circuitsemantics/#decl-quantumblockencoding-signalsystemblockprojection-apply). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.totalCircuitQubits" (lean := "QuantumBlockEncoding.totalCircuitQubits")
*Plain-English reading.* This definition gives the library's named construction or computation for “total circuit qubits”. Total qubits needed for a circuit operating on 'system' system qubits and 'signal' signal qubits.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* Total qubits needed for a circuit operating on 'system' system qubits and 'signal' signal qubits.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:778](../../../../library/modules/circuitsemantics/#decl-quantumblockencoding-totalcircuitqubits). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.CircuitMatrixSemantics.blockExtractionTarget" (lean := "QuantumBlockEncoding.CircuitMatrixSemantics.blockExtractionTarget")
*Plain-English reading.* This definition gives the library's named construction or computation for “block extraction target”. Build a BlockExtractionTarget from a CircuitMatrixSemantics by computing the block projection.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* Build a BlockExtractionTarget from a CircuitMatrixSemantics by computing the block projection. The circuit matrix is square with dimension 'signalDim \* dim', and we extract the '(signalIdx, signalIdx)' block.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:786](../../../../library/modules/circuitsemantics/#decl-quantumblockencoding-circuitmatrixsemantics-blockextractiontarget). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

# QuantumBlockEncoding/ConcreteSemantics.lean

19 explicit public declarations, in source order.

:::definition "QuantumBlockEncoding.ConcreteSemantics.FiniteMatrix" (lean := "QuantumBlockEncoding.ConcreteSemantics.FiniteMatrix")
*Plain-English reading.* This abbreviation gives a shorter name to the type or expression used for “finite matrix”. A Mathlib finite matrix, definitionally compatible with ABEIS 'Matrix'.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* A Mathlib finite matrix, definitionally compatible with ABEIS 'Matrix'.

*Declaration kind.* abbrev.

Source: [QuantumBlockEncoding/ConcreteSemantics.lean:25](../../../../library/modules/concretesemantics/#decl-quantumblockencoding-concretesemantics-finitematrix). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.ConcreteSemantics.StateVector" (lean := "QuantumBlockEncoding.ConcreteSemantics.StateVector")
*Plain-English reading.* This abbreviation gives a shorter name to the type or expression used for “state vector”. A finite column vector.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* A finite column vector.

*Declaration kind.* abbrev.

Source: [QuantumBlockEncoding/ConcreteSemantics.lean:29](../../../../library/modules/concretesemantics/#decl-quantumblockencoding-concretesemantics-statevector). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.ConcreteSemantics.basisKet" (lean := "QuantumBlockEncoding.ConcreteSemantics.basisKet")
*Plain-English reading.* This definition gives the library's named construction or computation for “basis ket”. A computational-basis ket in the concrete finite backend.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* A computational-basis ket in the concrete finite backend.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/ConcreteSemantics.lean:33](../../../../library/modules/concretesemantics/#decl-quantumblockencoding-concretesemantics-basisket). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.ConcreteSemantics.zeroKet" (lean := "QuantumBlockEncoding.ConcreteSemantics.zeroKet")
*Plain-English reading.* This definition gives the library's named construction or computation for “zero ket”. The all-zero computational-basis ket for an 'n'-qubit register.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The all-zero computational-basis ket for an 'n'-qubit register.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/ConcreteSemantics.lean:38](../../../../library/modules/concretesemantics/#decl-quantumblockencoding-concretesemantics-zeroket). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.ConcreteSemantics.applyVec" (lean := "QuantumBlockEncoding.ConcreteSemantics.applyVec")
*Plain-English reading.* This definition gives the library's named construction or computation for “apply vec”. Matrix-vector action using Mathlib's finite sum semantics.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

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

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* Acting on a basis ket selects the corresponding matrix column.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/ConcreteSemantics.lean:58](../../../../library/modules/concretesemantics/#decl-quantumblockencoding-concretesemantics-applyvec-basisket). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.ConcreteSemantics.applyVec_zeroKet" (lean := "QuantumBlockEncoding.ConcreteSemantics.applyVec_zeroKet")
*Plain-English reading.* Lean checks the proposition indexed as “apply vec zero ket”; the hypotheses and conclusion in the code panel fix its exact scope. Acting on the all-zero ket selects column zero.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* Acting on the all-zero ket selects column zero.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/ConcreteSemantics.lean:65](../../../../library/modules/concretesemantics/#decl-quantumblockencoding-concretesemantics-applyvec-zeroket). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.ConcreteSemantics.firstColumnMatches_iff_applyVec_zeroKet" (lean := "QuantumBlockEncoding.ConcreteSemantics.firstColumnMatches_iff_applyVec_zeroKet")
*Plain-English reading.* Lean checks the proposition indexed as “first column matches iff apply vec zero ket”; the hypotheses and conclusion in the code panel fix its exact scope. The ABEIS first-column contract is exactly the state-action equation 'U |0^n> = |psi>' in the concrete finite matrix backend.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

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

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* Repackage concrete semantics in the existing generic candidate interface.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/ConcreteSemantics.lean:105](../../../../library/modules/concretesemantics/#decl-quantumblockencoding-concretesemantics-complexstatepreparationcertificate-candidate). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.ConcreteSemantics.ComplexStatePreparationCertificate.verified" (lean := "QuantumBlockEncoding.ConcreteSemantics.ComplexStatePreparationCertificate.verified")
*Plain-English reading.* This definition gives the library's named construction or computation for “verified”. Promote a concrete certificate to the existing verified wrapper.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* Promote a concrete certificate to the existing verified wrapper. The generic 'isUnitary' field is instantiated by, rather than substituted for, the Mathlib unitary-group predicate.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/ConcreteSemantics.lean:124](../../../../library/modules/concretesemantics/#decl-quantumblockencoding-concretesemantics-complexstatepreparationcertificate-verified). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.ConcreteSemantics.ComplexStatePreparationCertificate.preparesVector" (lean := "QuantumBlockEncoding.ConcreteSemantics.ComplexStatePreparationCertificate.preparesVector")
*Plain-English reading.* Lean checks the proposition indexed as “prepares vector”; the hypotheses and conclusion in the code panel fix its exact scope.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The source declaration has no docstring. The reader cue above is generated from its kind and name and does not replace the Lean signature.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/ConcreteSemantics.lean:137](../../../../library/modules/concretesemantics/#decl-quantumblockencoding-concretesemantics-complexstatepreparationcertificate-preparesvector). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.ConcreteSemantics.ProductRegisterMatrix" (lean := "QuantumBlockEncoding.ConcreteSemantics.ProductRegisterMatrix")
*Plain-English reading.* This abbreviation gives a shorter name to the type or expression used for “product register matrix”. A matrix indexed by an explicit signal-register/system-register product.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* A matrix indexed by an explicit signal-register/system-register product.

*Declaration kind.* abbrev.

Source: [QuantumBlockEncoding/ConcreteSemantics.lean:145](../../../../library/modules/concretesemantics/#decl-quantumblockencoding-concretesemantics-productregistermatrix). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.ConcreteSemantics.flatToProductRegister" (lean := "QuantumBlockEncoding.ConcreteSemantics.flatToProductRegister")
*Plain-English reading.* This definition gives the library's named construction or computation for “flat to product register”. View a flattened signal-system matrix through explicit product-register indices.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* View a flattened signal-system matrix through explicit product-register indices. The signal register is high-order and the system register low-order.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/ConcreteSemantics.lean:152](../../../../library/modules/concretesemantics/#decl-quantumblockencoding-concretesemantics-flattoproductregister). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::definition "QuantumBlockEncoding.ConcreteSemantics.productRegisterBlockProjection" (lean := "QuantumBlockEncoding.ConcreteSemantics.productRegisterBlockProjection")
*Plain-English reading.* This definition gives the library's named construction or computation for “product register block projection”. Project one signal branch from an explicit product-register matrix.

*Formal status.* Compiled declaration in the default ABEIS import surface; its kind and displayed Lean type determine how it may be used.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* Project one signal branch from an explicit product-register matrix.

*Declaration kind.* def.

Source: [QuantumBlockEncoding/ConcreteSemantics.lean:163](../../../../library/modules/concretesemantics/#decl-quantumblockencoding-concretesemantics-productregisterblockprojection). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.ConcreteSemantics.productRegisterBlockProjection_flatToProductRegister" (lean := "QuantumBlockEncoding.ConcreteSemantics.productRegisterBlockProjection_flatToProductRegister")
*Plain-English reading.* Lean checks the proposition indexed as “product register block projection flat to product register”; the hypotheses and conclusion in the code panel fix its exact scope. Product-register projection after viewing a flat matrix is definitionally the existing ABEIS flattened block projection.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* Product-register projection after viewing a flat matrix is definitionally the existing ABEIS flattened block projection.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/ConcreteSemantics.lean:172](../../../../library/modules/concretesemantics/#decl-quantumblockencoding-concretesemantics-productregisterblockprojection-flattoproductregister). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.ConcreteSemantics.productIndex_val_eq_signalSystemBlockRowIndex" (lean := "QuantumBlockEncoding.ConcreteSemantics.productIndex_val_eq_signalSystemBlockRowIndex")
*Plain-English reading.* Lean checks the proposition indexed as “product index val eq signal system block row index”; the hypotheses and conclusion in the code panel fix its exact scope. The classic product index and circuit-semantics row index have the same value.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The classic product index and circuit-semantics row index have the same value.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/ConcreteSemantics.lean:182](../../../../library/modules/concretesemantics/#decl-quantumblockencoding-concretesemantics-productindex-val-eq-signalsystemblockrowindex). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

:::theorem "QuantumBlockEncoding.ConcreteSemantics.signalSystemBlockProjection_eq_cleanBlockProduct" (lean := "QuantumBlockEncoding.ConcreteSemantics.signalSystemBlockProjection_eq_cleanBlockProduct")
*Plain-English reading.* Lean checks the proposition indexed as “signal system block projection eq clean block product”; the hypotheses and conclusion in the code panel fix its exact scope. The classic rational clean block and the generic circuit-semantics projection are the same pointwise matrix under the shared register order.

*Formal status.* Compiled theorem in the default ABEIS import surface; the displayed Lean signature is the authoritative claim.

*Why it is in this chapter.* Definitions and lemmas that connect circuit syntax to evaluated matrix semantics, finite state action, and explicit product-register projection.

*Technical source note.* The classic rational clean block and the generic circuit-semantics projection are the same pointwise matrix under the shared register order.

*Declaration kind.* theorem.

Source: [QuantumBlockEncoding/ConcreteSemantics.lean:194](../../../../library/modules/concretesemantics/#decl-quantumblockencoding-concretesemantics-signalsystemblockprojection-eq-cleanblockproduct). A commit-pinned external link is added by the publication build when the source exists at the published ref.
:::

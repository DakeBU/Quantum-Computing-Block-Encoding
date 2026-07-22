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

# QuantumBlockEncoding/CircuitSemantics.lean

41 explicit public declarations, in source order.

:::definition "QuantumBlockEncoding.qubitDim" (lean := "QuantumBlockEncoding.qubitDim")
Source documentation: `A finite-dimensional basis size for an 'n'-qubit register.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:16](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CircuitSemantics.lean#L16).
:::

:::definition "QuantumBlockEncoding.SemanticObligation" (lean := "QuantumBlockEncoding.SemanticObligation")
Source documentation: `Structured semantic obligation for the matrix layer. This mirrors 'GHL2025.ObligationRecord' without importing 'GHL2025', so the semantics backend can stay below paper-specific files in the import graph.`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:25](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CircuitSemantics.lean#L25).
:::

:::definition "QuantumBlockEncoding.GateMatrix" (lean := "QuantumBlockEncoding.GateMatrix")
Source documentation: `One gate together with its matrix on the full 'qubits'-qubit Hilbert space. The matrix is supplied by a lower-level certificate for the gate family.`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:35](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CircuitSemantics.lean#L35).
:::

:::definition "QuantumBlockEncoding.gateMatricesMatchCircuit" (lean := "QuantumBlockEncoding.gateMatricesMatchCircuit")
Source documentation: `Check that a list of gate matrices labels exactly the same circuit gates.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:41](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CircuitSemantics.lean#L41).
:::

:::definition "QuantumBlockEncoding.evalGateMatrices" (lean := "QuantumBlockEncoding.evalGateMatrices")
Source documentation: `Evaluate a list of full-space gate matrices to a circuit matrix. The fold uses the usual right-action convention for a circuit list '[g₁, g₂, ...]': the resulting matrix is 'g_k * ... * g₂ * g₁'.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:54](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CircuitSemantics.lean#L54).
:::

:::theorem "QuantumBlockEncoding.Matrix.evalWith_foldl_add_mul" (lean := "QuantumBlockEncoding.Matrix.evalWith_foldl_add_mul")
Source documentation: `Evaluate one symbolic matrix-product entry as a concrete finite Rat fold. The project-local 'Coeff' matrices are syntactic, so a raw 'Matrix.mul' entry does not simplify away zero summands. This lemma moves the finite product entry through 'Coeff.evalWith', where later path-isolation proofs can use ordinary rational arithmetic without expanding the whole symbolic expression.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:71](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CircuitSemantics.lean#L71).
:::

:::theorem "QuantumBlockEncoding.Matrix.evalWith_mul_apply" (lean := "QuantumBlockEncoding.Matrix.evalWith_mul_apply")
Source documentation: `Evaluate one entry of 'Matrix.mul' by evaluating each path contribution. This is the local matrix-semantics block needed before a focused Robin seven-gate path proof can avoid syntactic 'Coeff.add' blow-up.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:92](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CircuitSemantics.lean#L92).
:::

:::theorem "QuantumBlockEncoding.Matrix.evalWith_mul_eq_zero_of_all_paths_zero" (lean := "QuantumBlockEncoding.Matrix.evalWith_mul_eq_zero_of_all_paths_zero")
Source documentation: `Evaluate one matrix-product entry as zero when every evaluated path contribution is zero. This is the zero-support companion to 'evalWith_mul_unique_path'. It lets paper-specific product proofs avoid expanding a large symbolic 'Coeff' fold when they have already isolated gate-local support facts.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:131](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CircuitSemantics.lean#L131).
:::

:::theorem "QuantumBlockEncoding.Matrix.evalWith_mul_unique_path" (lean := "QuantumBlockEncoding.Matrix.evalWith_mul_unique_path")
Source documentation: `Evaluate one matrix-product entry when all evaluated paths except 'k0' vanish. This is the reusable path-isolation block for later Robin gamma3 work: a theorem about the seven-gate product can first prove zero-support facts for all unwanted intermediate states, then reduce the evaluated product to the single surviving contribution.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:304](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CircuitSemantics.lean#L304).
:::

:::theorem "QuantumBlockEncoding.Matrix.evalWith_mul_two_path" (lean := "QuantumBlockEncoding.Matrix.evalWith_mul_two_path")
Source documentation: `Evaluate one matrix-product entry when all evaluated paths except 'k0' and 'k1' vanish. This is the two-path companion to 'evalWith_mul_unique_path'. A seven-gate product proof can first establish that only two intermediate rows contribute, then reduce the evaluated product to their sum using this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:328](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CircuitSemantics.lean#L328).
:::

:::theorem "QuantumBlockEncoding.Matrix.evalWith_mul_identity_right_apply" (lean := "QuantumBlockEncoding.Matrix.evalWith_mul_identity_right_apply")
Source documentation: `Evaluating a symbolic matrix after multiplying on the right by the identity recovers the evaluated entry. The statement is evaluation-level, not syntactic: 'Coeff' deliberately stores matrix products as explicit fold expressions, so the raw 'Coeff' term still contains zero summands.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:355](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CircuitSemantics.lean#L355).
:::

:::theorem "QuantumBlockEncoding.Matrix.cast_square_apply" (lean := "QuantumBlockEncoding.Matrix.cast_square_apply")
Source documentation: `Entry-level bridge for square matrix casts along a dimension equality. This keeps paper-specific finite-entry proofs from unfolding a large casted matrix when the only content is that the row and column values are unchanged.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:371](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CircuitSemantics.lean#L371).
:::

:::theorem "QuantumBlockEncoding.evalWith_evalGateMatrices_single" (lean := "QuantumBlockEncoding.evalWith_evalGateMatrices_single")
Source documentation: `Evaluation-level single-gate reduction for 'evalGateMatrices'. This is the entry helper for prepared composite gates: the matrix semantics of a singleton gate list evaluates to the supplied gate matrix entry, even though the underlying symbolic 'Coeff' expression is still a folded multiplication by the identity matrix.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:389](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CircuitSemantics.lean#L389).
:::

:::definition "QuantumBlockEncoding.CircuitMatrixSemantics" (lean := "QuantumBlockEncoding.CircuitMatrixSemantics")
Source documentation: `Circuit-level matrix semantics assembled from gate-level matrices. This does not certify that individual oracle matrices are correct; it gives the project a stable Lean target for composing those certificates once they exist.`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:404](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CircuitSemantics.lean#L404).
:::

:::definition "QuantumBlockEncoding.CircuitMatrixSemantics.ofGateMatrices" (lean := "QuantumBlockEncoding.CircuitMatrixSemantics.ofGateMatrices")
Source documentation: `Build circuit semantics directly from aligned gate matrices.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:415](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CircuitSemantics.lean#L415).
:::

:::definition "QuantumBlockEncoding.PreparedCircuitEntryTarget" (lean := "QuantumBlockEncoding.PreparedCircuitEntryTarget")
Source documentation: `Typed target for relating an active circuit-matrix entry to a prepared composition entry. This is intentionally only an interface. It records the two matrix entries and the exact equality a paper-specific composition backend must prove; it does not assert that the active circuit already contains the prepared blocks.`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:436](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CircuitSemantics.lean#L436).
:::

:::definition "QuantumBlockEncoding.PreparedCircuitEntryTarget.entryEqualityStatement" (lean := "QuantumBlockEncoding.PreparedCircuitEntryTarget.entryEqualityStatement")
Source documentation: `The prepared-composition equality required by the target.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:454](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CircuitSemantics.lean#L454).
:::

:::definition "QuantumBlockEncoding.PreparedCircuitEntryTarget.matrixEntryEqualityStatement" (lean := "QuantumBlockEncoding.PreparedCircuitEntryTarget.matrixEntryEqualityStatement")
Source documentation: `The same equality stated directly on the backing matrices.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:459](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CircuitSemantics.lean#L459).
:::

:::theorem "QuantumBlockEncoding.PreparedCircuitEntryTarget.entryEqualityStatement_iff_matrixEntryEqualityStatement" (lean := "QuantumBlockEncoding.PreparedCircuitEntryTarget.entryEqualityStatement_iff_matrixEntryEqualityStatement")
Source documentation: `The cached entry equality is equivalent to the backing matrix-entry equality. Paper-specific targets can prove whichever side their local backend exposes without changing the semantic obligation being tracked.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:470](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CircuitSemantics.lean#L470).
:::

:::definition "QuantumBlockEncoding.BlockExtractionTarget" (lean := "QuantumBlockEncoding.BlockExtractionTarget")
Source documentation: `A paper-level block-extraction target against a concrete circuit matrix. The current project can now state the missing equation in matrix terms. The actual block projection from signal/system registers remains a later proof obligation, tracked explicitly by 'blockProjection' and 'blockCorrect'.`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:502](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CircuitSemantics.lean#L502).
:::

:::definition "QuantumBlockEncoding.blockExtractionBranchContributionSum" (lean := "QuantumBlockEncoding.blockExtractionBranchContributionSum")
Source documentation: `Fold a finite family of branch contributions into one projected block entry. This is deliberately minimal: it provides a typed target for paper-specific projection/summation proofs without assuming commutativity, a ring structure, or a normal form for symbolic coefficients.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:520](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CircuitSemantics.lean#L520).
:::

:::definition "QuantumBlockEncoding.BlockExtractionBranchContributionTarget" (lean := "QuantumBlockEncoding.BlockExtractionBranchContributionTarget")
Source documentation: `Typed interface for decomposing one block-extracted matrix entry into finite branch contributions. The interface records the candidate contribution family and the exact block-entry and branch-sum propositions that must be proved. It is not itself a proof that the family is sourced from the backend or that the branch sum equals the block entry; those remain explicit semantic obligations.`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:535](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CircuitSemantics.lean#L535).
:::

:::definition "QuantumBlockEncoding.BlockExtractionBranchContributionTarget.selectedBranchStatement" (lean := "QuantumBlockEncoding.BlockExtractionBranchContributionTarget.selectedBranchStatement")
Source documentation: `The selected-branch identity exposed by the target.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:559](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CircuitSemantics.lean#L559).
:::

:::definition "QuantumBlockEncoding.BlockExtractionBranchContributionTarget.projectionSummationStatement" (lean := "QuantumBlockEncoding.BlockExtractionBranchContributionTarget.projectionSummationStatement")
Source documentation: `The projection/summation theorem still required for the target.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:569](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CircuitSemantics.lean#L569).
:::

:::definition "QuantumBlockEncoding.BlockExtractionBranchContributionTarget.backendExpansionStatement" (lean := "QuantumBlockEncoding.BlockExtractionBranchContributionTarget.backendExpansionStatement")
Source documentation: `The backend expansion theorem needed to close 'projectionSummationStatement'. This version is stated directly in terms of the extraction target's block matrix entry and the candidate branch-contribution fold. It is useful as a proof-DAG interface because paper-specific projection backends can target this statement without depending on the record's cached 'blockEntry' and 'branchSum' fields.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:586](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CircuitSemantics.lean#L586).
:::

:::theorem "QuantumBlockEncoding.BlockExtractionBranchContributionTarget.selectedBranchStatement_of_eq" (lean := "QuantumBlockEncoding.BlockExtractionBranchContributionTarget.selectedBranchStatement_of_eq")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:595](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CircuitSemantics.lean#L595).
:::

:::theorem "QuantumBlockEncoding.BlockExtractionBranchContributionTarget.projectionSummationStatement_iff_backendExpansionStatement" (lean := "QuantumBlockEncoding.BlockExtractionBranchContributionTarget.projectionSummationStatement_iff_backendExpansionStatement")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:603](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CircuitSemantics.lean#L603).
:::

:::theorem "QuantumBlockEncoding.BlockExtractionBranchContributionTarget.projectionSummationStatement_of_backendExpansionStatement" (lean := "QuantumBlockEncoding.BlockExtractionBranchContributionTarget.projectionSummationStatement_of_backendExpansionStatement")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:629](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CircuitSemantics.lean#L629).
:::

:::theorem "QuantumBlockEncoding.BlockExtractionBranchContributionTarget.backendExpansionStatement_of_projectionSummationStatement" (lean := "QuantumBlockEncoding.BlockExtractionBranchContributionTarget.backendExpansionStatement_of_projectionSummationStatement")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:640](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CircuitSemantics.lean#L640).
:::

:::definition "QuantumBlockEncoding.CircuitBlockEncodingClaim" (lean := "QuantumBlockEncoding.CircuitBlockEncodingClaim")
Source documentation: `A circuit-level block encoding claim bundling a circuit matrix semantics with a block extraction target and a dimension compatibility proof. The 'blockCorrect' obligation tracks the main mathematical claim: (⟨signalIdx| ⊗ I) U (|signalIdx⟩ ⊗ I) = targetMatrix / normalizer. This does not assert the claim is true; it records what needs proving.`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:661](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CircuitSemantics.lean#L661).
:::

:::definition "QuantumBlockEncoding.FiniteBlockCompositionContract" (lean := "QuantumBlockEncoding.FiniteBlockCompositionContract")
Source documentation: `Typed contract for a finite-dimensional LCU/block-composition step. This is intentionally contract-only: it states the exact matrix objects and obligations that a later theorem must connect, without treating a cited LCU result or a paper theorem as a Lean proof.`.

Kind: structure. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:676](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CircuitSemantics.lean#L676).
:::

:::definition "QuantumBlockEncoding.signalSystemBlockRowIndex" (lean := "QuantumBlockEncoding.signalSystemBlockRowIndex")
Source documentation: `Compound row index for a signal value and a system-row index.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:696](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CircuitSemantics.lean#L696).
:::

:::definition "QuantumBlockEncoding.signalSystemBlockColIndex" (lean := "QuantumBlockEncoding.signalSystemBlockColIndex")
Source documentation: `Compound column index for a signal value and a system-column index.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:700](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CircuitSemantics.lean#L700).
:::

:::theorem "QuantumBlockEncoding.signalSystemBlockRowIndex_zero" (lean := "QuantumBlockEncoding.signalSystemBlockRowIndex_zero")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:703](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CircuitSemantics.lean#L703).
:::

:::theorem "QuantumBlockEncoding.signalSystemBlockColIndex_zero" (lean := "QuantumBlockEncoding.signalSystemBlockColIndex_zero")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:707](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CircuitSemantics.lean#L707).
:::

:::theorem "QuantumBlockEncoding.signalSystemBlockRowIndex_lt" (lean := "QuantumBlockEncoding.signalSystemBlockRowIndex_lt")
Source documentation: `The row compound index stays inside a signal × row matrix.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:712](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CircuitSemantics.lean#L712).
:::

:::theorem "QuantumBlockEncoding.signalSystemBlockColIndex_lt" (lean := "QuantumBlockEncoding.signalSystemBlockColIndex_lt")
Source documentation: `The column compound index stays inside a signal × column matrix.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:727](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CircuitSemantics.lean#L727).
:::

:::definition "QuantumBlockEncoding.signalSystemBlockProjection" (lean := "QuantumBlockEncoding.signalSystemBlockProjection")
Source documentation: `Block projection: extract the '(signalIdx, signalIdx)' block from a signal × system matrix. Given a matrix M of size '(signalDim * rows) × (signalDim * cols)', the helpers 'signalSystemBlockRowIndex' and 'signalSystemBlockColIndex' map a pair '(i, j)' of system indices to the compound row and column indices in the full matrix that correspond to signal register value 'idx' and system indices '(i, j)'. The block '(⟨signalIdx| ⊗ I) M (|signalIdx⟩ ⊗ I)' is then: blockMatrix i j = M (signalIdx * rows + i) (signalIdx * cols + j)`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:753](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CircuitSemantics.lean#L753).
:::

:::theorem "QuantumBlockEncoding.signalSystemBlockProjection_apply" (lean := "QuantumBlockEncoding.signalSystemBlockProjection_apply")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:764](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CircuitSemantics.lean#L764).
:::

:::definition "QuantumBlockEncoding.totalCircuitQubits" (lean := "QuantumBlockEncoding.totalCircuitQubits")
Source documentation: `Total qubits needed for a circuit operating on 'system' system qubits and 'signal' signal qubits.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:778](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CircuitSemantics.lean#L778).
:::

:::definition "QuantumBlockEncoding.CircuitMatrixSemantics.blockExtractionTarget" (lean := "QuantumBlockEncoding.CircuitMatrixSemantics.blockExtractionTarget")
Source documentation: `Build a BlockExtractionTarget from a CircuitMatrixSemantics by computing the block projection. The circuit matrix is square with dimension 'signalDim * dim', and we extract the '(signalIdx, signalIdx)' block.`.

Kind: def. This declaration is part of the default ABEIS import surface.

Source: [QuantumBlockEncoding/CircuitSemantics.lean:786](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/CircuitSemantics.lean#L786).
:::

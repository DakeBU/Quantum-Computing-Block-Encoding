import QuantumBlockEncoding
import QuantumBlockEncoding.RobinMatrix
import Verso
import VersoManual
import VersoBlueprint

open Verso.Genre
open Verso.Genre.Manual
open Informal

set_option linter.hashCommand false
set_option linter.style.longLine false
set_option verso.blueprint.externalCode.strictResolve true

#doc (Manual) "Declaration catalog: ExperimentalRobinMatrix" =>
%%%
file := "catalog-experimental-robin-matrix"
%%%

This chapter is generated from the Lean source. Every node denotes one explicit public
declaration, and every Lean link is checked during the Blueprint build. Definitions appear
in source order before later results whenever the source module does so.

*Experimental status.* RobinMatrix.lean is not imported by the default library
surface. It is catalogued for completeness and currently contains two sorry-guarded
diagnostic theorems. Those nodes are visible obligations, not certified facts.

# QuantumBlockEncoding/RobinMatrix.lean

396 explicit public declarations, in source order.

:::definition "QuantumBlockEncoding.stencilRowCoeff" (lean := "QuantumBlockEncoding.stencilRowCoeff")
Source documentation: `Coefficient at column 'colIdx' when the stencil 'entries' is applied at row 'rowIdx'. Only entries whose offset lands on 'colIdx' contribute; the result is the sum of all matching coefficients. Returns bare 'Coeff' (no zero-wrapping) when exactly one entry matches.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:21](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L21).
:::

:::definition "QuantumBlockEncoding.robinRowEntries" (lean := "QuantumBlockEncoding.robinRowEntries")
Source documentation: `Select the stencil entry list for row 'i': - rows 'i < w.lower' use left boundary rows, - rows 'i > w.upper' use right boundary rows, - all others use the bulk stencil. Falls back to the empty list if a boundary row is missing from the supplied data, so the definition is total and does not need index proofs.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:37](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L37).
:::

:::definition "QuantumBlockEncoding.buildRobinMatrix" (lean := "QuantumBlockEncoding.buildRobinMatrix")
Source documentation: `Build the full Robin derivative matrix of size 'gridSize n × gridSize n'. The boundary rows come from 'leftRows' and 'rightRows'; the interior uses 'bulkEntries'. The 'BulkWindow w' records where the interior starts and ends.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:56](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L56).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.robinDerivativeMatrix" (lean := "QuantumBlockEncoding.Examples.RobinHeat.robinDerivativeMatrix")
Source documentation: `The concrete Robin derivative matrix for the fourth-order central second-derivative stencil.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:68](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L68).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinAkMatrix" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinAkMatrix")
Source documentation: `The one-term Robin theorem target $A_k$. Theorem '1 term robin' block-encodes the row-scaled operator 'A_k ~ f(x) d^m/dx^m'; Eq. 'ROBIN clarified' carries entries 'f(x_i) D_{ij}' in the 'gamma3' branch.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:81](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L81).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinAkMatrix_apply" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinAkMatrix_apply")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:84](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L84).
:::

:::definition "QuantumBlockEncoding.matrixRowAbsSum" (lean := "QuantumBlockEncoding.matrixRowAbsSum")
Source documentation: `Absolute-row-sum for row 'i' of a 'Coeff'-valued matrix, given a symbol environment 'env'. This is the building block for the induced 1-norm.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:96](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L96).
:::

:::definition "QuantumBlockEncoding.matrixOneNorm" (lean := "QuantumBlockEncoding.matrixOneNorm")
Source documentation: `Induced matrix 1-norm: the maximum absolute row sum. Uses 'evalWith env' to convert symbolic 'Coeff' entries to concrete 'Rat' values.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:106](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L106).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.robinDerivativeNorm" (lean := "QuantumBlockEncoding.Examples.RobinHeat.robinDerivativeNorm")
Source documentation: `Numeric 1-norm of the Robin derivative matrix under a symbol environment. Returns the maximum absolute row sum as a concrete 'Rat'.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:117](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L117).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinNumericNormalizer" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinNumericNormalizer")
Source documentation: `Numeric normalizer α = N_D · N_f · κ for the one-term Robin construction. 'nD' is the derivative-stencil normalization (1-norm of the Robin derivative matrix), 'nF' is the function-oracle normalization, and 'k' is the Robin-condition bound.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:125](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L125).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.robinNormalizerBound" (lean := "QuantumBlockEncoding.Examples.RobinHeat.robinNormalizerBound")
Source documentation: `Proposition: the numeric normalizer α is at least the induced 1-norm of the Robin derivative matrix, i.e. α ≥ ∥D_Robin∥₁. Stated via a 'Decidable' check so 'native_decide' can close concrete instances.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:133](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L133).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinNumericNormalizer_eq_eval" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinNumericNormalizer_eq_eval")
Source documentation: `Connecting the numeric normalizer to the symbolic GHL2025 normalizer via a concrete environment mapping the three symbols to their numeric values.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:139](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L139).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.robinBlockEncodingSpec" (lean := "QuantumBlockEncoding.Examples.RobinHeat.robinBlockEncodingSpec")
Source documentation: `Concrete BlockEncodingSpec wiring the Robin derivative matrix into the one-term Robin block encoding framework. Uses the fourth-order central stencil with Robin boundary corrections.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:149](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L149).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.robinBlockEncodingSpec_pureAncilla" (lean := "QuantumBlockEncoding.Examples.RobinHeat.robinBlockEncodingSpec_pureAncilla")
Source documentation: `The spec's resource pureAncilla matches 2n.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:158](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L158).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.robinDerivativeOracleResource" (lean := "QuantumBlockEncoding.Examples.RobinHeat.robinDerivativeOracleResource")
Source documentation: `Concrete derivative oracle resource for the fourth-order Robin stencil. Uses half-bandwidth l = leftRadius = 2.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:163](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L163).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.robinDerivativeOracleResource_eq" (lean := "QuantumBlockEncoding.Examples.RobinHeat.robinDerivativeOracleResource_eq")
Source documentation: `The Robin derivative oracle resource equals bandedSparseAccessResource n 2.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:167](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L167).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.robinDerivativeOracleResource_pureAncilla" (lean := "QuantumBlockEncoding.Examples.RobinHeat.robinDerivativeOracleResource_pureAncilla")
Source documentation: `The Robin derivative oracle uses n - 1 pure ancillas (from Lemma 1).`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:171](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L171).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.robinBlockEncodingPredicate" (lean := "QuantumBlockEncoding.Examples.RobinHeat.robinBlockEncodingPredicate")
Source documentation: `PO-6: Block-extraction equation for the Robin derivative block encoding. Records the structural preconditions that are checkable now (normalizer bound, ancilla count, zero error) and reserves the full equation ⟨0^a| ⊗ I) U (|0^a⟩ ⊗ I) = A / α as an abstract component pending unitary semantics.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:181](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L181).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.robinResourceBoundHolds" (lean := "QuantumBlockEncoding.Examples.RobinHeat.robinResourceBoundHolds")
Source documentation: `PO-7: Resource bound holds for the Robin block encoding. Concrete decidable check: pureAncilla = 2n and gate count ≤ paper's formula.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:188](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L188).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinResourceConsistent" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinResourceConsistent")
Source documentation: `PO-9: The concrete resource is consistent with the symbolic expression. Checks the decidable part: pureAncilla = 2n.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:195](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L195).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.RobinOracleComposition" (lean := "QuantumBlockEncoding.Examples.RobinHeat.RobinOracleComposition")
Source documentation: `Bundle of oracle contracts and LCU composition obligation for the one-term Robin construction. Contains: - derivative oracle O_D (sparse-access for the banded stencil matrix), - function oracle O_f (amplitude oracle for the coefficient function), - LCU composition Prop (PO-15: linear combination of unitaries correctness), - matrix coherence (the oracle's matrix equals the Robin derivative matrix).`.

Kind: structure. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:204](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L204).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.robinOracleComposition" (lean := "QuantumBlockEncoding.Examples.RobinHeat.robinOracleComposition")
Source documentation: `PO-13/14/15: Concrete oracle composition for the Robin derivative block encoding. Instantiates the derivative oracle with the fourth-order stencil, the function oracle with one piece, and records the LCU composition Prop as an abstract claim.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:215](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L215).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.robinOracleComposition_bandwidth" (lean := "QuantumBlockEncoding.Examples.RobinHeat.robinOracleComposition_bandwidth")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:231](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L231).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.robinOracleComposition_functionPieces" (lean := "QuantumBlockEncoding.Examples.RobinHeat.robinOracleComposition_functionPieces")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:234](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L234).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.robinOracleComposition_matrix" (lean := "QuantumBlockEncoding.Examples.RobinHeat.robinOracleComposition_matrix")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:237](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L237).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.robinProofObligations" (lean := "QuantumBlockEncoding.Examples.RobinHeat.robinProofObligations")
Source documentation: `Default proof-obligation bundle for the one-term Robin construction. All obligations are unproved. main.tex:1131-1136 -`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:242](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L242).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinCircuitSemantics" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinCircuitSemantics")
Source documentation: `CircuitMatrixSemantics for the one-term Robin circuit using honest gate matrices. The full-space matrix is the product of the 7 honest gate matrices computed by 'evalGateMatrices'. Unproved gate claims remain in their own 'SemanticObligation' records. figure:1_term_ROBIN -`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:252](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L252).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinCircuitDimCompat" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinCircuitDimCompat")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:275](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L275).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockExtractionTarget" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockExtractionTarget")
Source documentation: `Block-extraction target for the one-term Robin block encoding. States that the '(0, 0)' block of the circuit matrix should equal 'A_k / (N_D * N_f * kappa)'. The 'unitaryMatrix' and 'blockMatrix' are derived from the real circuit matrix product computed by 'evalGateMatrices' over all 7 honest gate matrices. Block correctness remains unproved. The 'signalDim' is 'qubitDim effectiveRobinSignalQubits' where 'effectiveRobinSignalQubits' counts all non-system qubits. 'systemDim' is 'gridSize n'. figure:1_term_ROBIN, main.tex:1131-1136 -`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:296](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L296).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinCircuitBlockClaim" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinCircuitBlockClaim")
Source documentation: `Circuit block encoding claim for the one-term Robin construction. Connects the circuit matrix semantics to the block extraction target and records the dimension compatibility as a parameter. The caller must supply 'hDim' proving that the total circuit Hilbert space decomposes as signalDim × systemDim. For concrete 'n' (e.g. n = 3) this is provable by 'native_decide'. figure:1_term_ROBIN, main.tex:1131-1136 -`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:323](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L323).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.defaultOneTermRobinCircuitBlockClaim" (lean := "QuantumBlockEncoding.Examples.RobinHeat.defaultOneTermRobinCircuitBlockClaim")
Source documentation: `Default one-term Robin circuit block claim using the reusable dimension compatibility theorem. The block-correctness obligation remains unproved.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:344](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L344).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinFiniteBlockCompositionContract" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinFiniteBlockCompositionContract")
Source documentation: `Contract-only finite-dimensional LCU/block-composition dependency for the one-term Robin theorem. This records the exact circuit claim, target matrix, normalizer, and open matrix obligations that a future finite-dimensional composition theorem must close. It does not promote the current LCU, projection, or extraction flags.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:359](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L359).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinFiniteBlockCompositionContract_transcript" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinFiniteBlockCompositionContract_transcript")
Source documentation: `The finite block-composition contract is wired to the concrete target.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:404](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L404).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinFiniteCompositionExactTheoremObligation" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinFiniteCompositionExactTheoremObligation")
Source documentation: `Contract-only interface for the exact finite composition theorem still needed to close the GHL2025 one-term Robin block encoding. This names the missing theorem-facing step without asserting it: the seven-gate matrix product, projected in the Definition 'def:block-encoding' signal-zero convention, must realize the Eq. 'ROBIN clarified' target block 'oneTermRobinAkMatrix n / (N_D N_f kappa)'. The proof flag stays false until that exact finite-dimensional theorem is build-tested.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:441](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L441).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinFiniteCompositionExactTheoremObligation_transcript" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinFiniteCompositionExactTheoremObligation_transcript")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:449](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L449).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinBlockEncodingProofRoute" (lean := "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinBlockEncodingProofRoute")
Source documentation: `Phase 1 proof-route contract for the GHL2025 one-term Robin theorem. This record ties the theorem tuple, circuit-matrix semantics, block-projection target, active oracle contracts, and source-route blockers into one Lean object. It is a transcript and obligation map, not a proof that the block encoding is correct.`.

Kind: structure. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:467](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L467).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute")
Source documentation: `Default theorem-level proof route for the one-term Robin block encoding. All unproved semantic obligations are deliberately kept false. The route uses the active seven-gate circuit product, the global-slot 'O_D^BS' cleanup-scope decision, and the external-source transcript for 'O_f'.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:531](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L531).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_normalizer" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_normalizer")
Source documentation: `The proof-route contract links the theorem normalizer to the block target.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:573](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L573).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_blockTarget" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_blockTarget")
Source documentation: `The theorem-level route pins the block target used for the one-term theorem. This is only a structural guard: it records the signal-index-zero convention, the Robin target matrix, and the shared circuit semantics object. It does not prove the extracted block equation.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:586](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L586).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_blockProjectionNormalizerAudit" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_blockProjectionNormalizerAudit")
Source documentation: `The theorem-level route uses the same block-projection target, normalizer, and open flags as the concrete circuit matrix target. This is a route guard for the final block-extraction statement. It records the cast circuit product, the signal-index-zero projection API, the Robin target matrix, and the normalizer 'N_D * N_f * kappa', while keeping the block and LCU obligations false.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:610](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L610).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_circuitProduct" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_circuitProduct")
Source documentation: `The theorem-level route uses the active seven-gate circuit product. This is a structural guard for Phase 1: it records that the route still points to 'oneTermRobinCircuitSemantics', whose matrix is the ordered product computed by 'evalGateMatrices' over 'oneTermRobinGateMatrixPlaceholders'. It does not prove any gate unitarity or block-extraction equation.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:680](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L680).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gateUnitaryFlags" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gateUnitaryFlags")
Source documentation: `The theorem route uses the active seven-gate matrix product with the current gate-level proof flags frozen. Only 'U_indic' and SWAP are locally marked proved. The paper-oracle gates 'O_DT^S', 'Ry_boundary', 'O_D^BS', 'O_f', and '(O_D^BS)^dagger' remain in obligation mode, and the O_D^BS cleanup scope is still restricted to the active global sparse-slot source.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:712](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L712).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gateListAndFlags" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gateListAndFlags")
Source documentation: `The theorem route keeps the Fig. 1-term Robin gate order and the current gate-level proof flags synchronized. This guard packages the gate-list freeze with the seven-gate flag freeze. It does not prove any of the paper-oracle gates unitary and keeps the O_D^BS active global-source cleanup scope in obligation mode.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:740](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L740).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gateProjectionFreeze" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gateProjectionFreeze")
Source documentation: `The theorem route keeps the seven-gate order and projection target frozen together. This is a reviewer-facing proof-DAG wrapper over the gate-list guard and the block-projection normalizer audit. It records the active Fig. 1-term Robin gate order, the current proof-state vector, the signal-index-zero target, and the final false flags. It does not prove a block equation or change any oracle matrix.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:780](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L780).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_layoutProjectionAudit" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_layoutProjectionAudit")
Source documentation: `The theorem-level signal and pure-ancilla counts are wired separately from the circuit-level projection dimension. The paper theorem states the block-encoding tuple with 'oneTermRobinLayout.signalQubits' and '2n' pure ancillas. The matrix backend uses 'effectiveRobinSignalQubits' because the block projection zeros every non-system wire in the concrete register partition. This guard records both counts and keeps resource cleanup plus block extraction in obligation mode.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:823](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L823).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockExtractionTarget_signalZeroBlockIndices" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockExtractionTarget_signalZeroBlockIndices")
Source documentation: `The signal-index-zero Robin target uses the unshifted system row and column indices. This is an index-convention guard for the block-projection route, not a proof of the extracted block equation.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:862](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L862).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_signalZeroBlockIndices" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_signalZeroBlockIndices")
Source documentation: `The theorem-level route inherits the signal-index-zero block index convention from 'oneTermRobinBlockExtractionTarget'.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:876](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L876).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_claimBlockCorrectFalse" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_claimBlockCorrectFalse")
Source documentation: `The theorem-level route keeps the circuit-claim block obligation open. 'CircuitBlockEncodingClaim.blockCorrect' is separate from the target-level 'blockCorrect' field. This guard prevents the route from silently promoting the theorem claim while the paper-level oracle and composition blockers remain open.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:899](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L899).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_flags_false" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_flags_false")
Source documentation: `The theorem-level route keeps all semantic blockers in obligation mode. This theorem is the acceptance guard for the Phase 1 contract: it records the current false flags without using them as proofs.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:917](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L917).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_ofExternalSourceAndFlags" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_ofExternalSourceAndFlags")
Source documentation: `The theorem route exposes the 'O_f' external-source transcript and false flags. This is a Phase 1 bridge from the per-column 'functionOracleAmplitudeProofRoute_externalSourceAndFlags' guard to 'oneTermRobinBlockEncodingProofRoute'. It records that the route still points to the cited GHL2025/GL2024 source contract and keeps the 'N_f', orthogonal completion, gate-unitarity, LCU, projection, and block-correctness obligations false.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:969](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L969).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_ofCleanFunctionOracleEntry" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_ofCleanFunctionOracleEntry")
Source documentation: `The route-level 'O_f' gate exposes the clean-workspace paper branch entry. This is a narrow bridge from gate slot 4 of Fig. 1-term Robin to the per-column 'functionOracleAmplitudeProofRoute'. It proves only the matrix entry selected by the clean 'm_f' branch; the theorem-level function-oracle, LCU, projection, block-correctness, and final extraction flags remain false.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:1076](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L1076).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_derivativeBoundaryContractMap" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_derivativeBoundaryContractMap")
Source documentation: `The theorem route exposes the derivative-amplitude and boundary-rotation contracts that share the paper normalizer 'N_D'. This guard connects GHL2025 Lemma 3, Eq. (20), Eq. 'angles for Ry', and Fig. 1-term Robin to 'oneTermRobinBlockEncodingProofRoute'. It packages the existing source-bound bridge for 'O_DT^S' and 'Ry_boundary', checks that those gates occur in the active seven-gate route, and keeps all analytic, gate-level, LCU, projection, and final extraction flags false.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:1174](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L1174).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_odtsKetZeroEntry" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_odtsKetZeroEntry")
Source documentation: `The route-level 'O_DT^S' gate exposes the Eq. (20) ket-zero entry. This is the local matrix-entry bridge for the derivative-amplitude factor in Eq. 'ROBIN clarified'. Under the paper-register hypotheses selecting an indicator-1, ancilla-0 column and the ancilla-0 row with matching non-ancilla bits, gate slot 1 of the Fig. 1-term Robin route has the symbolic ket-zero entry recorded by 'sparseAmplitudeOracleDTCoefficientNormalizerProofRoute'. It does not prove the division semantics, normalizer bound, two-by-two unitarity, LCU composition, projection, or final block extraction.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:1320](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L1320).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_boundaryKetZeroEntry" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_boundaryKetZeroEntry")
Source documentation: `The route-level 'Ry_boundary' gate exposes the boundary ket-zero entry. This is the local matrix-entry bridge for the boundary rotation factor in Eq. 'angles for Ry' and Eq. 'ROBIN clarified'. Under the paper-register hypotheses selecting an indicator-0, ancilla-0 column and the ancilla-0 row with matching non-ancilla bits, gate slot 2 of the Fig. 1-term Robin route has the symbolic cosine half-angle entry recorded by 'boundaryRotationAngleNormalizerProofRoute'. It does not prove the arccos semantics, half-angle identities, two-by-two unitarity, LCU composition, projection, or final block extraction.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:1439](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L1439).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_odbsActiveGlobalSlotBlockers" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_odbsActiveGlobalSlotBlockers")
Source documentation: `The theorem-level route exposes the active global-slot 'O_D^BS' blockers. This is the replacement for the retired row-dependent unused-branch route. The active route is the global sparse-slot source together with the restricted dagger-column cleanup interface. Full clean-domain cleanup and full-space unitarity remain obligations.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:1612](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L1612).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_activeOdbsGatePairBlocked" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_activeOdbsGatePairBlocked")
Source documentation: `The theorem-level route keeps the active 'O_D^BS' gate pair in obligation mode. This guard is intentionally weaker than a semantic theorem. It records only that the active forward and dagger matrices remain unproved as unitaries while the paper cleanup and unitary-extension flags stay false.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:1672](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L1672).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_odbsActiveScopeKeepsFinalFlagsFalse" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_odbsActiveScopeKeepsFinalFlagsFalse")
Source documentation: `The active-scope blocker propagates to the final theorem flags. The global-slot cleanup interface is currently restricted to 'bandedSparseAccessPaperGlobalSlotSource'. This theorem keeps final composition and block-extraction flags false until a full clean-domain or full-space theorem is accepted.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:1697](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L1697).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_activeOdbsGatePairWiring" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_activeOdbsGatePairWiring")
Source documentation: `The theorem-level route wires the active 'O_D^BS' gate pair at the Fig. 1-term Robin positions. This is only a circuit-product guard. It records the gate labels and matrices used by the route while preserving the false unitarity flags.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:1732](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L1732).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_activeOdbsGatePairPublicSources" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_activeOdbsGatePairPublicSources")
Source documentation: `The active 'O_D^BS' gate pair keeps public source anchors on its obligation records.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:1770](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L1770).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_odbsActiveGlobalSlotGateFreeze" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_odbsActiveGlobalSlotGateFreeze")
Source documentation: `The active global-slot gate freeze combines the active matrices, cleanup-scope blocker, block target, and final false flags.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:1786](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L1786).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_projectionSourceFreeze" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_projectionSourceFreeze")
Source documentation: `The source-gate freeze keeps the projection target and final theorem flags open under the active global-slot cleanup scope.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:1838](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L1838).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_rejectedRowDependentCollisionRegression_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_rejectedRowDependentCollisionRegression_n3")
Source documentation: `The old row-dependent collision remains rejected-model regression memory. The active global-slot image separates the same two boundary columns, so this theorem must not be used as an active paper-level blocker.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:1870](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L1870).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_encodedOutOfRangeSparseSlot_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_encodedOutOfRangeSparseSlot_n3")
Source documentation: `The theorem route records encoded sparse value '7' as the first out-of-range clean slot for the one-term 'kappa = 7' source domain. This guard replaces the retired row-dependent unused-branch blocker in the active route. The source column is clean, but it is not in 'bandedSparseAccessPaperGlobalSlotSource', so any broader cleanup theorem must use a precise full-clean-domain or full-space extension interface.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:1901](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L1901).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_contractDriftColumn8Blocked_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_contractDriftColumn8Blocked_n3")
Source documentation: `The theorem route carries the active column-8 'O_D^BS' contract-drift guard. For 'n = 3', source column '8' maps to the Lemma 1 paper-image row '40' in the route's active 'O_D^BS' gate. The legacy helper still has a row-'4' entry, so this guard keeps the active/legacy separation visible at the theorem route without proving injectivity, dagger cleanup, or block correctness.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:1929](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L1929).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_sparseAccessContractIdentity" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_sparseAccessContractIdentity")
Source documentation: `The theorem-level route uses the default Lemma 1 'O_D^BS' contract object. This guard prevents a later lower packet from swapping in a different sparse-access contract while preserving similar-looking field values. It does not prove the oracle image, dagger cleanup, or unitary extension.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:1959](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L1959).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_odbsPaperContractTranscript" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_odbsPaperContractTranscript")
Source documentation: `The theorem-level route carries the Lemma 1 'O_D^BS' paper contract verbatim. This is a source-transcript guard. It pins the padded input/output ket formula and the register widths while keeping all paper-contract semantic flags false.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:1983](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L1983).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_odbsRestrictedDaggerColumnIndicator" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_odbsRestrictedDaggerColumnIndicator")
Source documentation: `The theorem-level route exposes the active-domain 'O_D^BS' dagger-column indicator. For the fixed one-term Robin parameters, this guard routes the compiled global-slot cleanup evidence through 'oneTermRobinBlockEncodingProofRoute'. It is still restricted to rows satisfying 'bandedSparseAccessPaperGlobalSlotSource', and it keeps every theorem-level cleanup, unitarity, LCU, projection, and block-correctness flag false.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:2032](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L2032).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_odbsCleanupScopeDecision" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_odbsCleanupScopeDecision")
Source documentation: `The theorem route selects the active global-source domain as the next 'O_D^BS' cleanup theorem scope. This is a proof-search scope guard, not a cleanup proof. It connects the route to the compiled restricted dagger-column indicator and records that full clean-domain cleanup, full-space unitary extension, LCU correctness, and final block-correctness obligations remain false.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:2116](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L2116).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_odbsFullCleanDomainImageRuleBlocked" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_odbsFullCleanDomainImageRuleBlocked")
Source documentation: `The theorem route keeps the full clean-domain 'O_D^BS' image-rule slot blocked. This is a source-contract guard for the scope decision. The route may use the active global-source cleanup interface, but the full clean-domain wrapper still has no unused-branch image rule and cannot promote cleanup, unitarity, LCU, or block correctness.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:2173](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L2173).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_odbsActiveGlobalSourceCleanupInterface" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_odbsActiveGlobalSourceCleanupInterface")
Source documentation: `The theorem-level route exposes the selected active global-source cleanup interface for 'O_D^BS'. This is only an interface wrapper around the compiled active-domain dagger column and the cleanup-scope decision. It does not promote 'daggerCleanup', unitarity, LCU correctness, block projection, block correctness, or final block extraction.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:2233](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L2233).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_odbsActiveGlobalSourceCleanupContractMap" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_odbsActiveGlobalSourceCleanupContractMap")
Source documentation: `The theorem-level route exposes the active global-source cleanup contract map. This guard packages the current proof-DAG block for post-SWAP inverse evidence: the named candidate is an active global-source preimage of the post-SWAP target, it is unique among active global-source rows, and the transpose-style dagger entry is '1'. The statement is still restricted to 'bandedSparseAccessPaperGlobalSlotSource'; it does not promote paper-contract cleanup, full clean-domain cleanup, full-space unitarity, LCU correctness, or block extraction.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:2323](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L2323).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_theoremTranscriptDependencies" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_theoremTranscriptDependencies")
Source documentation: `The theorem route exposes the source transcript dependencies for Theorem '1 term robin'. This is a guard-only Phase 1 declaration. It ties the theorem source anchor, normalizer, gate order, active 'O_D^BS' global-source scope, 'O_f' external source, signal-index-zero target, and current false proof flags into one reviewer-facing checkpoint. It does not prove cleanup, unitarity, LCU correctness, block projection, block correctness, or final block extraction.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:2420](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L2420).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_theoremTranscriptActiveCleanupMap" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_theoremTranscriptActiveCleanupMap")
Source documentation: `The theorem transcript consumes the active global-source cleanup map. This is the next guard-only proof-DAG bridge after the cleanup contract map: it exposes the active-source post-SWAP preimage data while also pinning the one-term theorem source, normalizer, circuit order, sparse-access formula, and 'O_f' source transcript. The bridge remains restricted to 'bandedSparseAccessPaperGlobalSlotSource' and does not promote semantic cleanup, unitarity, LCU correctness, block projection, block correctness, or final block extraction.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:2525](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L2525).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_robinClarifiedGammaTranscript" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_robinClarifiedGammaTranscript")
Source documentation: `The theorem transcript exposes the Eq. ROBIN clarified gamma decomposition. This guard ties 'defaultRobinWavefunctionDecomposition' to the one-term theorem route, the active global-source cleanup map, and the external 'O_f' source record. It records the three gamma normalizers and keeps the final semantic flags false; it is not a block-extraction proof.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:2615](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L2615).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_blockProjectionDependencyMap" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_blockProjectionDependencyMap")
Source documentation: `The theorem transcript exposes the dependency map for the final block projection. This is a contract-only Phase 1 map. It packages the Eq. ROBIN gamma transcript, active-source 'O_D^BS' cleanup evidence, the 'CircuitBlockEncodingClaim' projection target, the full clean-domain blocker, and the external 'O_f' source contract. It does not prove the signal block equation or promote LCU, cleanup, unitarity, projection, block-correctness, or final extraction flags.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:2709](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L2709).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_fullGateContractLedger" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_fullGateContractLedger")
Source documentation: `The theorem route exposes one ledger for all Fig. 1-term Robin gate contracts. This is a guard-only aggregation step for Phase 1. It consumes the compiled 'O_DT^S'/'Ry_boundary' bridge, the active-source 'O_D^BS' cleanup map, and the external 'O_f' source transcript. It freezes the seven gate slots and keeps all paper-oracle, LCU, projection, and final block-extraction flags false.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:2827](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L2827).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_theoremTranscriptClosurePacket" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_theoremTranscriptClosurePacket")
Source documentation: `The theorem-transcript closure packet consumes the current Phase 1 guards. This is the middle-agent checkpoint for Theorem '1 term robin': it combines the source transcript dependencies, layout/projection audit, block-projection dependency map, and full Fig. 1-term Robin gate-contract ledger into one reviewer-facing statement. It records the exact false-obligation ledger and does not promote cleanup, unitarity, LCU correctness, projection, block-correctness, resource-bound, ancilla-cleanup, or final extraction flags.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:3041](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L3041).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_finiteBlockCompositionContractMap" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_finiteBlockCompositionContractMap")
Source documentation: `The theorem route now has a typed finite LCU/block-composition contract. This guard consumes the Phase 1 closure packet and exposes the exact remaining finite-dimensional composition obligations. It keeps the route-level LCU, circuit-unitary, block-projection, block-correctness, and final-extraction flags false.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:3195](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L3195).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_finiteCompositionExactTheoremInterface" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_finiteCompositionExactTheoremInterface")
Source documentation: `The theorem route exposes the exact finite composition theorem interface. This consumes the finite block-composition contract map and names the precise matrix objects that a future theorem must relate: the route circuit semantics, the signal-zero block projection, the row-scaled Robin target matrix, and the normalizer 'N_D * N_f * kappa'. It is contract-only; all finite composition, route LCU, resource, cleanup, projection, block-correctness, and extraction flags remain false.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:3281](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L3281).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3SignalBlockEntryObligation" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3SignalBlockEntryObligation")
Source documentation: `Contract-only entry obligation connecting Eq. 'ROBIN clarified' to the signal-zero block matrix. The future theorem must show, entry by entry, that the signal-zero projection of the Fig. 1-term Robin gate product realizes the 'gamma3' clean branch and therefore the row-scaled Robin target normalized by 'N_D * N_f * kappa'. This declaration only names that missing theorem-facing step.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:3420](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L3420).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3SignalBlockEntryObligation_transcript" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3SignalBlockEntryObligation_transcript")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:3428](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L3428).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3SignalBlockEntryObligationMap" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3SignalBlockEntryObligationMap")
Source documentation: `The exact finite-composition interface is refined to the gamma3 entry target. This is still a Phase 1 transcript guard. It consumes the exact finite theorem interface, exposes the 'gamma3' normalizer, the concrete signal-projection entry, the target matrix, and the false final flags. It does not prove that the entry equals the paper coefficient, nor does it promote LCU, projection, block-correctness, resource, cleanup, or extraction obligations.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:3445](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L3445).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3TargetEntryData" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3TargetEntryData")
Source documentation: `The gamma3 entry obligation also exposes the concrete target entry. This is the RHS data for the future entry theorem: the same fixed system indices 'i, j' point to 'f(x_i) D_{ij}', with normalizer 'N_D*N_f*kappa'. The statement intentionally does not prove that the circuit block entry equals this target entry; the normalized block equality and final extraction flags remain false.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:3538](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L3538).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3FactorEntryLedger" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3FactorEntryLedger")
Source documentation: `The gamma3 factor-entry ledger joins the existing single-gate transcript bridges. This is the next theorem-facing interface for the future 'one_term_gamma3_signal_block_entry' proof. It packages the target-entry side, the clean 'O_f' entry, the 'O_DT^S' ket-zero entry, the boundary 'Ry_boundary' ket-zero entry, and the active global-source 'O_D^BS' cleanup map. It is still a ledger: the normalized block equality, LCU composition, cleanup promotion, and final extraction fields remain false.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:3620](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L3620).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3SignalBlockProductEntry" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3SignalBlockProductEntry")
Source documentation: `The gamma3 signal-block entry is the concrete seven-gate product entry. This is a matrix-semantics bridge, not the final coefficient theorem. It consumes the factor-entry ledger and exposes that the signal-zero projected entry is an entry of 'evalGateMatrices' over the Fig. 1-term Robin gate list. The finite product still has to be related to the Eq. 'ROBIN clarified' coefficient, so the normalized-block, LCU, projection, and extraction flags remain false.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:3843](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L3843).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3AkCoefficientEntryContract" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3AkCoefficientEntryContract")
Source documentation: `The gamma3 coefficient-entry contract is now tied to the Ak target. This is still a contract bridge, not the finite coefficient theorem. It reuses the concrete signal-block product entry, the factor-entry ledger, and the Ak target expansion 'oneTermRobinAkMatrix n i j = f(x_i) * D_ij'. The product-to-coefficient equality, LCU composition, oracle analytic correctness, cleanup, unitarity, projection, and final extraction flags remain false.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:3980](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L3980).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3ProductToCoefficientObligation" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3ProductToCoefficientObligation")
Source documentation: `Named product-to-coefficient obligation for the gamma3 entry. The future theorem must multiply the already ledgered factor entries in the signal-zero product into the normalized Ak entry. This declaration only names that remaining finite entry theorem; it does not assert the equality.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:4218](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L4218).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3ProductToCoefficientObligation_transcript" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3ProductToCoefficientObligation_transcript")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:4226](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L4226).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3ProductToCoefficientInterface" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3ProductToCoefficientInterface")
Source documentation: `Interface for the exact finite product-to-coefficient theorem. This guard consumes the compiled gamma3 Ak coefficient-entry contract and exposes the remaining theorem-facing obligation: the signal-zero product entry must equal the Ak coefficient normalized by 'N_D*N_f*kappa'. It keeps the entry obligation, LCU composition, projection, cleanup, unitarity, and final extraction flags false.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:4243](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L4243).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3ProjectionPathAudit_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3ProjectionPathAudit_n3")
Source documentation: `Focused path-state audit for the current 'n = 3' gamma3 product attempt. The signal-zero projection sends system entry '(2, 5)' to the full entry '(2, 5)'. The executable gate images then show that the projected-column forward path and the existing factor-entry ledger columns are not one coherent seven-gate path. This is a register-layout audit only: it does not unfold the full product and does not promote any semantic proof flag.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:4415](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L4415).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3PaperBasisIndex" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3PaperBasisIndex")
Source documentation: `Full-basis index for the clean 'gamma3' ket layout in Eq. 'ROBIN clarified'. This is a Phase 1 layout helper, not a new projection convention. It places the trailing rotation ancilla at bit '0', the system register in bits '[1, 1+n)', the padded 'O_D^BS' zero register next, and the sparse slot above that padded register, with all higher 'm_f' and indicator workspace bits set to zero.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:4490](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L4490).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3PaperBasisLayout_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3PaperBasisLayout_n3")
Source documentation: `Layout contract for the next gamma3 path attempt at 'n = 3'. Eq. 'ROBIN clarified' places the clean 'gamma3' basis states for system entry '(2, 5)' at full indices '(4, 10)' when the sparse slot is '0'. The existing 'signalSystemBlockProjection' convention instead selects full indices '(2, 5)'. This theorem records that mismatch together with the relevant clean-register extractions, so the product-to-coefficient route can choose a coherent block index before applying the reusable unique-path product lemma.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:4505](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L4505).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3PaperBasisPathAudit_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3PaperBasisPathAudit_n3")
Source documentation: `Focused Fig. 1-term Robin path audit for the clean 'gamma3' paper-basis endpoints at 'n = 3'. Starting from the paper clean-column index '10', the ket-zero branch follows the active seven-gate images to final dagger row '198', not to the paper clean-row index '4'. The first decisive drift is the active 'O_D^BS' sparse-slot-zero address: after 'U_indic' and the identity 'Ry_boundary' branch, it writes address '3', so SWAP exposes system row '3' before the dagger cleanup. This is a path-state audit only; it does not apply the unique-path product lemma and does not promote any semantic proof flag.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:4563](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L4563).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3SparseSlotAlignment_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3SparseSlotAlignment_n3")
Source documentation: `Sparse-slot alignment audit for the focused 'n = 3' gamma3 coefficient 'D_{2,5}'. The slot-zero paper-basis path remains useful negative evidence: it maps source column '5' to address '3', so it cannot be the route for target row '2'. The finite global-slot table instead selects slot '5', the '-3' diagonal, for the coefficient from source column '5' to target row '2'. This theorem only chooses the slot and clean endpoint data needed by the next path isolation packet; it does not apply the unique-path multiplication lemma or promote any semantic proof flag.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:4646](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L4646).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3ProjectionSlotConventionObligation" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3ProjectionSlotConventionObligation")
Source documentation: `Source-contract obligation for the gamma3 projection-slot convention. Eq. 'ROBIN clarified' sums the clean 'gamma3' branch over sparse slots. The finite path audit for a matrix entry therefore needs an interface that relates the slot-specific clean basis state with 's' satisfying 'r_{s,j}=i' to the theorem-level signal-zero block projection or sparse-register summation. This declaration names that missing convention without proving it.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:4715](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L4715).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3ProjectionSlotConventionObligation_transcript" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3ProjectionSlotConventionObligation_transcript")
Source documentation: `No source docstring is present yet. The Lean signature below is the authoritative contract for this theorem.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:4723](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L4723).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3ProjectionSlotConventionMap_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3ProjectionSlotConventionMap_n3")
Source documentation: `Focused projection-slot contract map for the compiled 'n = 3' gamma3 audit. The previous slot-alignment audit shows that the coefficient for the system entry '(2, 5)' uses sparse slot '5', not slot '0'. This theorem packages the slot-specific clean endpoints '90' and '84' and records that they are still not the generic signal-zero projection endpoints '(2, 5)'. The remaining projection-slot convention is deliberately kept as an unproved obligation.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:4740](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L4740).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3Slot5PathAudit_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3Slot5PathAudit_n3")
Source documentation: `Focused Fig. 1-term Robin path audit for the slot-'5' clean 'gamma3' endpoints at 'n = 3'. The slot-alignment map gives the clean endpoint chain '90 -> 42 -> 84' if the path starts directly at 'O_D^BS'. The actual seven-gate circuit first applies 'U_indic', which flips the indicator bit for system column '5', so the active path starts from '218'. The ket-zero branch then reaches final dagger row '228', not the slot-specific clean row '84'. This declaration records the adjacent states only; it does not apply a product lemma or promote any semantic proof flag.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:4809](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L4809).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3Slot5ProjectionRegisterAuditCheck_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3Slot5ProjectionRegisterAuditCheck_n3")
Source documentation: `Executable field check for the slot-'5' gamma3 projection/register audit. The checked path is the ket-zero branch '90 -> 218 -> 218 -> 218 -> 170 -> 170 -> 212 -> 228'. The Boolean records the indicator, ancilla, system-row, padded-zero, sparse-index, 'm_f' workspace, and active-source fields for the clean source, adjacent states, final endpoint, and clean Eq. ROBIN endpoint.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:4923](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L4923).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3Slot5ProjectionRegisterAudit_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3Slot5ProjectionRegisterAudit_n3")
Source documentation: `Projection/register audit for the slot-'5' gamma3 path at 'n = 3'. The first field-level mismatch between the final seven-gate endpoint '228' and the clean Eq. ROBIN endpoint '84' is the indicator bit: the full path keeps the bulk indicator set to '1', while the clean endpoint has indicator bit '0'. The sparse-index field also differs ('6' versus '5'). No semantic proof flag is promoted.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:5066](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L5066).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3ProjectionRegisterConventionDecision" (lean := "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3ProjectionRegisterConventionDecision")
Source documentation: `Middle-agent decision record for the blocked gamma3 projection/register convention at 'n = 3'. The source transcript provides Eq. ROBIN clarified, Fig. 1-term ROBIN, and the block-encoding projection definition, but it does not specify the finite basis bridge that would identify the full seven-gate endpoint '228' with the clean slot-'5' endpoint '84'. This record keeps product search blocked until that convention is stated precisely.`.

Kind: structure. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:5098](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L5098).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3ProjectionRegisterConventionDecision_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3ProjectionRegisterConventionDecision_n3")
Source documentation: `The focused gamma3 endpoint mismatch is a source-contract gap, not a finite matrix multiplication target.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:5119](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L5119).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3ProjectionRegisterConventionDecision_n3_transcript" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3ProjectionRegisterConventionDecision_n3_transcript")
Source documentation: `Transcript theorem for the middle decision record. This theorem deliberately preserves the false semantic flags. It only records that the compiled register audit has converted the next step into a projection/register convention decision before any product-to-coefficient proof search may continue.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:5160](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L5160).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3SparseRegisterSummationConvention" (lean := "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3SparseRegisterSummationConvention")
Source documentation: `Chosen theorem-facing convention for the focused 'n = 3' gamma3 entry. Eq. 'ROBIN clarified' writes the gamma3 contribution as a sum over sparse slots, so the next interface selects sparse-register summation. The compiled slot-'5' audit also found an indicator-bit mismatch between the full endpoint '228' and the clean endpoint '84'; that mismatch is kept as a separate false obligation instead of being hidden by the summation choice.`.

Kind: structure. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:5193](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L5193).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3SparseRegisterSummationConvention_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3SparseRegisterSummationConvention_n3")
Source documentation: `Sparse-register summation convention selected for the slot-'5' gamma3 audit. This is a contract map only. It records the source-supported summation over 's = 0, ..., kappa - 1', but it does not prove that the current block projection implements that summation. The indicator mismatch remains open.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:5226](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L5226).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3SparseRegisterSummationConvention_n3_transcript" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3SparseRegisterSummationConvention_n3_transcript")
Source documentation: `Transcript theorem for the selected sparse-register summation convention. The theorem proves only the compiled contract map and endpoint facts. It keeps product-to-coefficient search blocked and preserves all semantic false flags.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:5290](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L5290).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3SparseRegisterSummation_indicatorGap_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3SparseRegisterSummation_indicatorGap_n3")
Source documentation: `Indicator-field gap after selecting sparse-register summation. The sparse-register summation convention is source-backed by Eq. 'ROBIN clarified', but it does not explain why the full seven-gate endpoint keeps the indicator bit set. This theorem packages that remaining field-level source contract gap and keeps product-to-coefficient search blocked.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:5330](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L5330).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3IndicatorProjectionConvention" (lean := "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3IndicatorProjectionConvention")
Source documentation: `Indicator-field projection/register convention for the focused 'n = 3' gamma3 endpoint pair. After sparse-register summation has been selected, the remaining question is whether the theorem-level block projection sums, ignores, resets, or permutes the indicator field that differs between full endpoint '228' and clean endpoint '84'. The GHL2025 transcript has not yet supplied that rule, so the convention is recorded as a false source-contract obligation rather than a product proof.`.

Kind: structure. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:5378](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L5378).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3IndicatorProjectionConvention_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3IndicatorProjectionConvention_n3")
Source documentation: `The active gamma3 indicator convention is still an explicit source-contract gap. This declaration is deliberately theorem-facing but not a semantic proof. It reuses the sparse-register summation gap and keeps all block-encoding flags false until a source-backed projection/register rule is stated.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:5406](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L5406).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3IndicatorProjectionConvention_n3_transcript" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3IndicatorProjectionConvention_n3_transcript")
Source documentation: `Transcript theorem for the active gamma3 indicator convention. The theorem packages the endpoint and false-obligation facts needed by the next proof step. It does not identify endpoints '228' and '84', and it does not promote product-to-coefficient, LCU, projection, block, or final extraction flags.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:5456](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L5456).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BulkIndicatorSourceAudit" (lean := "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BulkIndicatorSourceAudit")
Source documentation: `Focused source audit for the bulk-indicator field in the 'n = 3' gamma3 endpoint pair. For the entry using system column '5', the paper's bulk window 'K1 <= j <= K2' classifies the column as bulk. The source-backed 'U_indic' behavior therefore sets the indicator to '1', which matches the full Fig. 1-term Robin endpoint '228' and not the clean endpoint '84'. This refines the active blocker without closing it: the source still does not state a projection/register rule that identifies the two endpoints, and all product, LCU, projection, block, and extraction flags remain false.`.

Kind: structure. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:5512](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L5512).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BulkIndicatorSourceAudit_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BulkIndicatorSourceAudit_n3")
Source documentation: `Source-backed refinement of the active indicator convention blocker. The focused column '5' is in the bulk window for 'n = 3', so the indicator value '1' at endpoint '228' is not accidental; it is exactly the value produced by the 'U_indic' source paragraph. Endpoint '84' remains the clean displayed slot endpoint, and no reset/projection rule is promoted.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:5542](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L5542).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BulkIndicatorSourceAudit_n3_transcript" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BulkIndicatorSourceAudit_n3_transcript")
Source documentation: `Transcript theorem for the bulk-indicator source audit. This theorem only records the source-backed branch classification and the remaining false obligations. It does not replace the missing projection/register convention and does not resume product multiplication.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:5579](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L5579).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BranchCorrectSourceMap" (lean := "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BranchCorrectSourceMap")
Source documentation: `Branch-correct source map for the focused 'n = 3' gamma3 transcript. The older endpoint audit compared the bulk column 'j = 5' against the displayed boundary summand of Eq. 'ROBIN clarified'. This record keeps that bulk audit as omitted-branch memory and introduces a boundary-focused endpoint with 'j = 0', where 'U_indic' leaves the indicator at '0'. It is a transcript map only; both branch product obligations remain false.`.

Kind: structure. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:5630](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L5630).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BranchCorrectSourceMap_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BranchCorrectSourceMap_n3")
Source documentation: `Compiled branch-correct gamma3 transcript for 'n = 3'. The boundary target uses 'j = 0', satisfying the displayed condition '0 <= j < K1'. The old 'j = 5' target satisfies 'K1 <= j <= K2', so it belongs to the omitted bulk summand hidden by '+ ...'. Lower proof search may now target one branch-specific product interface at a time, but no theorem-level semantic flag is promoted here.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:5668](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L5668).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BranchCorrectSourceMap_n3_transcript" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BranchCorrectSourceMap_n3_transcript")
Source documentation: `Transcript theorem for the branch-correct gamma3 source map. This theorem is the handoff boundary between the old bulk endpoint audit and the next lower packet. It proves only branch classification and endpoint facts; the boundary and bulk product-to-coefficient obligations, LCU composition, projection, block correctness, and final extraction stay false.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:5729](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L5729).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3BoundaryBranchPathAudit_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3BoundaryBranchPathAudit_n3")
Source documentation: `Boundary-focused path audit for the displayed gamma3 branch at 'n = 3'. The branch-correct source map chooses the boundary column 'j = 0', so 'U_indic' leaves the indicator bit at '0'. For the target entry '(0, 0)', the sparse slot that maps the source column back to row '0' is slot '2' (offset '0'), not slot '0' (offset '6'). This theorem records the resulting slot-'2' clean path through the Fig. 1-term Robin gate images. It is only a path-state audit: the product-to-coefficient obligation and all block-encoding semantic flags remain false.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:5790](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L5790).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BulkProductInterface" (lean := "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BulkProductInterface")
Source documentation: `Bulk-specific interface for the omitted gamma3 product branch. The old focused column 'j = 5' is bulk for 'n = 3', 'K1 = 2', and 'K2 = 5'. It therefore belongs to the summand hidden by the '+ ...' in Eq. 'ROBIN clarified', not to the displayed boundary branch. This interface uses the source-backed full endpoint with indicator '1'; it does not compare that endpoint with the displayed boundary endpoint and does not prove the final product-to-coefficient theorem.`.

Kind: structure. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:5906](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L5906).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3BulkProductToCoefficientInterface_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3BulkProductToCoefficientInterface_n3")
Source documentation: `Compiled product interface for the omitted bulk branch at 'n = 3', system entry '(2,5)', and global sparse slot '5'. The factor list follows the Fig. 1-term Robin gate order 'U_indic', 'O_DT^S', 'Ry_boundary', 'O_D^BS', 'O_f', 'SWAP', 'O_D^BS†'. Because the column is bulk, 'U_indic' sets the indicator bit to '1', 'O_DT^S' supplies the derivative-amplitude factor, and 'Ry_boundary' acts as identity.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:5955](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L5955).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3BulkProductToCoefficientInterface_n3_transcript" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3BulkProductToCoefficientInterface_n3_transcript")
Source documentation: `Transcript theorem for the omitted bulk product interface. This theorem proves only branch classification, endpoint data, and the gate-factor ledger for the source-backed bulk path. The unique-path support, indicator projection convention, product-to-coefficient equality, LCU composition, block projection, block correctness, and final extraction remain false obligations.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:6052](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L6052).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryProductInterface" (lean := "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryProductInterface")
Source documentation: `Boundary-specific interface for the next gamma3 product theorem. The displayed boundary branch of Eq. 'ROBIN clarified' at 'n = 3', '(i,j) = (0,0)' uses sparse slot '2'. The compiled path audit isolates the seven Fig. 1-term Robin factors for the ket-zero branch, but this record does not claim that the full matrix product has already been reduced to that path. The unique-path support facts and product-to-coefficient equality remain false obligations.`.

Kind: structure. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:6176](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L6176).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3BoundaryProductToCoefficientInterface_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3BoundaryProductToCoefficientInterface_n3")
Source documentation: `Compiled boundary product interface for the 'n = 3', '(0,0)', sparse-slot-'2' gamma3 packet. The factor list follows the gate order 'U_indic', 'O_DT^S', 'Ry_boundary', 'O_D^BS', 'O_f', 'SWAP', 'O_D^BS†'. The ket-zero branch factors are recorded, but applying 'Matrix.evalWith_mul_unique_path' is left to the next finite support proof.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:6216](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L6216).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3BoundaryProductToCoefficientInterface_n3_transcript" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3BoundaryProductToCoefficientInterface_n3_transcript")
Source documentation: `Transcript theorem for the boundary product interface. This proves the branch-specific data and factor list used by the next unique-path product attempt. It deliberately keeps the unique-path support obligation, product-to-coefficient obligation, projection-slot convention, LCU composition, block projection, block correctness, and final extraction false.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:6302](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L6302).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryUniquePathSupportAudit" (lean := "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryUniquePathSupportAudit")
Source documentation: `Boundary unique-path support audit for the displayed 'n = 3' gamma3 branch. This record is intentionally narrower than the final product theorem. It proves the concrete adjacent-branch zero entries currently available from the gate skeletons, then names the first missing global support interface needed before 'Matrix.evalWith_mul_unique_path' can isolate the full seven-gate product.`.

Kind: structure. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:6408](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L6408).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3BoundaryUniquePathSupportAudit_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3BoundaryUniquePathSupportAudit_n3")
Source documentation: `Compiled audit for the first boundary unique-path support packet. The target path is the ket-zero branch '32 -> 32 -> 32 -> 32 -> 0 -> 0 -> 0 -> 32'. The adjacent boundary-rotation ket-one branch reaches the row-'33' endpoint, and its contribution to target row '32' is killed by concrete zero entries in the current 'O_f' and dagger matrices. The remaining all-other-path support theorem is still an explicit false obligation.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:6447](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L6447).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3BoundaryUniquePathSupport_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3BoundaryUniquePathSupport_n3")
Source documentation: `First boundary unique-path support result. This theorem compiles the concrete zero entries for the adjacent ket-one branch and records the remaining missing prefix-support theorem. It deliberately does not prove the all-path support condition, does not apply 'Matrix.evalWith_mul_unique_path' to the seven-gate product, and does not promote any product, projection, LCU, block-correctness, or extraction flag.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:6519](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L6519).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryPrefixParameters_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryPrefixParameters_n3")
Source documentation: `Parameters for the focused 'n = 3' displayed-boundary gamma3 prefix packet.`.

Kind: abbrev. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:6576](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L6576).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryPrefixDim_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryPrefixDim_n3")
Source documentation: `Full matrix dimension for the focused boundary gamma3 prefix packet.`.

Kind: abbrev. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:6581](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L6581).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryPrefixSource_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryPrefixSource_n3")
Source documentation: `Full source column '32' for the focused boundary gamma3 prefix packet.`.

Kind: abbrev. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:6586](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L6586).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryPrefixRow0_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryPrefixRow0_n3")
Source documentation: `Prefix row '0', the ket-zero image after the forward 'O_D^BS' gate.`.

Kind: abbrev. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:6591](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L6591).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryPrefixRow1_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryPrefixRow1_n3")
Source documentation: `Prefix row '1', the adjacent ket-one image after the forward 'O_D^BS' gate.`.

Kind: abbrev. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:6596](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L6596).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryDUPrefixMatrix_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryDUPrefixMatrix_n3")
Source documentation: `Two-gate prefix 'O_DT^S * U_indic' for the displayed-boundary gamma3 packet.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:6605](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L6605).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryRDUPrefixMatrix_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryRDUPrefixMatrix_n3")
Source documentation: `Three-gate prefix 'Ry_boundary * O_DT^S * U_indic'.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:6613](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L6613).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryPrefixMatrix_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryPrefixMatrix_n3")
Source documentation: `Four-gate prefix 'O_D^BS * Ry_boundary * O_DT^S * U_indic'.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:6621](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L6621).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryDUPrefixSupport_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryDUPrefixSupport_n3")
Source documentation: `The two-gate boundary prefix has no evaluated support away from source column '32'. This is an evaluated-matrix support theorem. It does not simplify the raw symbolic 'Coeff' fold and does not promote the product-to-coefficient obligation.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:6744](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L6744).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryRDUPrefixSupport_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryRDUPrefixSupport_n3")
Source documentation: `The three-gate boundary prefix has evaluated support only in rows '32' and '33'.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:6762](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L6762).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3BoundaryPrefixSupport_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3BoundaryPrefixSupport_n3")
Source documentation: `Boundary prefix support for the displayed gamma3 branch at 'n = 3'. For the branch-correct source column '32', the evaluated four-gate prefix 'O_D^BS * Ry_boundary * O_DT^S * U_indic' can land only in rows '0' and '1'. This is the missing prefix-support block named by the previous audit. It does not prove the seven-gate product equality, projection-slot convention, LCU composition, block projection, block correctness, or final extraction.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:6787](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L6787).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryOfSwapMatrix_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryOfSwapMatrix_n3")
Source documentation: `Two-gate suffix 'SWAP * O_f' for the displayed-boundary gamma3 packet.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:6807](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L6807).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundarySuffixMatrix_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundarySuffixMatrix_n3")
Source documentation: `Three-gate suffix '(O_D^BS)^† * SWAP * O_f'.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:6814](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L6814).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundarySevenGateMatrix_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundarySevenGateMatrix_n3")
Source documentation: `Full seven-gate matrix for the focused displayed-boundary gamma3 packet. This is only the finite matrix product for the branch-correct 'n = 3', row-'32', column-'32' support proof. It does not promote any semantic obligation on the theorem route.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:6828](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L6828).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryOfSwapRow0Col1_zero_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryOfSwapRow0Col1_zero_n3")
Source documentation: `After 'O_f' and 'SWAP', the adjacent ket-one column has no evaluated support at row '0'. This is the suffix-side companion to the prefix support theorem. It uses the compiled clean-workspace zero entry 'O_f[0,1] = 0' and SWAP row-'0' support instead of expanding the full symbolic product.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:6897](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L6897).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundarySuffixRow32Col1_zero_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundarySuffixRow32Col1_zero_n3")
Source documentation: `The suffix '(O_D^BS)^† * SWAP * O_f' kills the adjacent row-'1' branch when the target row is the boundary row '32'.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:6921](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L6921).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3BoundarySevenGateSupport_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3BoundarySevenGateSupport_n3")
Source documentation: `Seven-gate support for the displayed 'n = 3' gamma3 boundary branch. For the full product written as 'suffix * prefix', every evaluated contribution from source column '32' to target row '32' vanishes unless the intermediate row between the prefix and suffix is row '0'. Rows outside '{0,1}' are killed by the compiled prefix-support theorem; row '1' is killed by the suffix-side 'O_f'/SWAP/dagger support above. Product-to-coefficient, projection, LCU, block-correctness, and final-extraction obligations remain false.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:6945](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L6945).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3BoundarySevenGateUniquePath_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3BoundarySevenGateUniquePath_n3")
Source documentation: `One-step unique-path reduction for the focused seven-gate boundary entry. This applies the generic evaluated-product reducer to the already isolated row-'0' intermediate branch. It is not the gamma3 coefficient theorem and it does not change any 'proved' flag.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:6970](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L6970).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryDUPrefixEntryEval_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryDUPrefixEntryEval_n3")
Source documentation: `The two-gate 'O_DT^S * U_indic' prefix contributes unit amplitude on the boundary source column '32'.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:6995](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L6995).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryRDUPrefixEntryEval_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryRDUPrefixEntryEval_n3")
Source documentation: `The three-gate 'Ry_boundary * O_DT^S * U_indic' prefix contributes the boundary half-angle cosine on source column '32'.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:7045](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L7045).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryPrefixEntryEval_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryPrefixEntryEval_n3")
Source documentation: `The four-gate prefix entry from source column '32' to row '0' is the boundary half-angle cosine.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:7087](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L7087).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryOfSwapEntryEval_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryOfSwapEntryEval_n3")
Source documentation: `The 'SWAP * O_f' suffix prefix on row/column '0' contributes the clean function-oracle amplitude 'f_3_0 * N_f_inv'.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:7140](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L7140).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundarySuffixEntryEval_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundarySuffixEntryEval_n3")
Source documentation: `The three-gate suffix entry from row '32' to the row-'0' intermediate state is the clean function-oracle amplitude.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:7191](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L7191).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3BoundaryProductEntryEval_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3BoundaryProductEntryEval_n3")
Source documentation: `Evaluated seven-gate product entry for the displayed boundary 'gamma3' packet. This proves the finite row-'32', column-'32' branch product after the compiled unique-path reduction. It is still only the branch product evaluation: the paper-level product-to-'A_k' coefficient theorem, sparse-register projection convention, LCU composition, block projection, block correctness, and final extraction remain separate false obligations.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:7238](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L7238).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryDUPrefixCol0Support_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryDUPrefixCol0Support_n3")
Source documentation: `Two-gate 'O_DT^S * U_indic' prefix support at column '0'. Both 'U_indic' and 'O_DT^S' act as the identity on state '|0⟩' (indicator bit is zero), so the DU prefix at column '0' has support only at row '0'.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:7322](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L7322).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryRDUPrefixCol0Support_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryRDUPrefixCol0Support_n3")
Source documentation: `Three-gate 'Ry * O_DT^S * U_indic' prefix support at column '0'. Since 'DU' feeds only row '0' into 'Ry', and 'Ry' at column '0' acts on the pair '{0, 1}', the RDU prefix at column '0' has support only at rows '{0, 1}'.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:7422](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L7422).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryPrefixCol0Support_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryPrefixCol0Support_n3")
Source documentation: `Four-gate prefix 'O_D^BS * Ry * O_DT^S * U_indic' support at column '0'. The RDU prefix feeds rows '{0, 1}' into 'O_D^BS'. Since 'image(0) = 96' and 'image(1) = 97', the full prefix at column '0' has support only at rows '{96, 97}'.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:7445](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L7445).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryDUPrefixCol0EntryEval_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryDUPrefixCol0EntryEval_n3")
Source documentation: `The two-gate prefix at column '0' contributes unit amplitude on row '0'. This is the column-'0' analogue of 'oneTermRobinGamma3BoundaryDUPrefixEntryEval_n3'; it feeds the two-path decomposition for the active '[0,0]' entry.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:7471](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L7471).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryRDUPrefixRow0Col0_eval_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryRDUPrefixRow0Col0_eval_n3")
Source documentation: `The three-gate column-'0' prefix row '0' is the slot-'0' boundary cosine entry.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:7518](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L7518).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryRDUPrefixRow1Col0_eval_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryRDUPrefixRow1Col0_eval_n3")
Source documentation: `The three-gate column-'0' prefix row '1' is the slot-'0' boundary sine entry.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:7557](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L7557).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryPrefixRow96Col0_eval_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryPrefixRow96Col0_eval_n3")
Source documentation: `The four-gate prefix row '96', column '0' evaluates to the slot-'0' boundary cosine half-angle entry. This is one of the two prefix factors required by 'oneTermRobinBlockEncodingProofRoute_gamma3BoundarySevenGateTwoPath_n3'.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:7602](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L7602).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryPrefixRow97Col0_eval_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryPrefixRow97Col0_eval_n3")
Source documentation: `The four-gate prefix row '97', column '0' evaluates to the slot-'0' boundary sine half-angle entry.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:7659](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L7659).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryCol0SupportAnalysis" (lean := "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryCol0SupportAnalysis")
Source documentation: `QBE-AUTO-002 column-'0' support analysis record for the '[0,0]' entry. The '[0,0]' entry of the seven-gate product 'suffix * prefix' at column '0' requires a different support analysis from the '[32,32]' entry: 1. 'U_indic' at column '0': identity (indicator condition not triggered for state '0'). Support only at row '0'. Compiled. 2. 'O_DT^S' at column '0': identity (indicator bit '0'). Support only at row '0'. Compiled. 3. 'DU = O_DT^S * U_indic' at column '0': support only at row '0'. Compiled. 4. 'Ry_boundary' at column '0': acts on the '(0, 1)' rotation pair. 'Ry[0, 0] = cosHalf' and 'Ry[1, 0] = sinHalf' are both non-zero. Support at rows '{0, 1}'. Compiled. 5. 'RDU = Ry * DU' at column '0': since 'DU' feeds only row '0' into 'Ry', the RDU prefix has support at rows '{0, 1}' (both Ry targets of row '0'). Compiled. 6. 'prefix = O_D^BS * RDU' at column '0': maps rows '{0, 1}' through 'O_D^BS'. The prefix has support at '{image(0), image(1)} = {96, 97}'. Both images compiled. Prefix support compiled. The next proof obligation is: - Add the suffix-side support for row '0' (dagger concentrates at column '96', SWAP maps to row '12', 'O_f' spreads from there) - Build the two-path reduction for '[0,0]' through intermediate rows '{96, 97}' - Compare the resulting entry with the backend fold under HWKappa This record does not promote any 'proved' flag.`.

Kind: structure. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:7741](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L7741).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryCol0SupportAnalysis_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryCol0SupportAnalysis_n3")
Source documentation: `Compiled column-'0' support analysis for the '[0,0]' seven-gate entry.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:7765](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L7765).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3BoundarySevenGateTwoPath_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3BoundarySevenGateTwoPath_n3")
Source documentation: `Two-path reduction for the '[0,0]' entry of the seven-gate boundary matrix. The prefix at column '0' has support only at intermediate rows '{96, 97}' (compiled in 'oneTermRobinGamma3BoundaryPrefixCol0Support_n3'). All other intermediate rows contribute zero to the matrix product 'suffix * prefix' at position '[0, 0]'. This applies 'Matrix.evalWith_mul_two_path' from CircuitSemantics and does not promote any 'proved' flag.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:7838](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L7838).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryRyCoefficientBridge" (lean := "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryRyCoefficientBridge")
Source documentation: `Focused false bridge for the displayed boundary 'gamma3' branch. The compiled seven-gate product contributes the 'Ry_boundary' half-angle entry 'boundary_cos_half_0_2'. Eq. 'ROBIN clarified' needs the normalized derivative coefficient 'D_0^(2) / N_D'. The paper angle line states 'theta_0^2 = arccos(D_0^(2) / N_D)', so identifying the half-angle matrix entry itself with the normalized coefficient is a separate source-contract gap. This record names that gap without changing any matrix convention or promoting the product-to-coefficient theorem.`.

Kind: structure. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:8564](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L8564).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryRyCoefficientBridge_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryRyCoefficientBridge_n3")
Source documentation: `Compiled focused bridge for the 'n = 3', row-'0', column-'0', global-slot-'2' boundary branch. The bridge records exactly the factor mismatch left after 'oneTermRobinBlockEncodingProofRoute_gamma3BoundaryProductEntryEval_n3'. It keeps the 'R_y' angle convention, product-to-coefficient equality, LCU, projection, block correctness, and final extraction as false obligations.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:8597](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L8597).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryRyCoefficientBridge_n3_transcript" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryRyCoefficientBridge_n3_transcript")
Source documentation: `Transcript theorem for the focused boundary 'R_y' coefficient bridge. This theorem proves only the typed wiring of the source-contract gap. The bridge obligation and every theorem-level semantic flag remain false.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:8651](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L8651).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryRyAngleConventionDecision" (lean := "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryRyAngleConventionDecision")
Source documentation: `Human/source decision packet for the boundary 'R_y' angle convention. The focused bridge proves that the compiled seven-gate product uses the standard 'R_y' half-angle entry 'boundary_cos_half_0_2', while Eq. 'ROBIN clarified' needs the normalized coefficient 'D_0^(2) / N_D'. This packet is the theorem-facing freeze requested by the source audit: product-to-coefficient search stays blocked until a paper-backed convention or human decision supplies the missing rule.`.

Kind: structure. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:8717](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L8717).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryRyAngleConventionDecision_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryRyAngleConventionDecision_n3")
Source documentation: `Compiled decision packet for the focused boundary branch at 'n = 3'. This declaration does not choose a new matrix convention. It records that the source currently supports only the bridge obligation, and that lower product proof search must wait for either a source-backed half-angle convention or an accepted decision to keep the standard 'R_y' entry as an explicit theorem gap.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:8744](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L8744).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryRyAngleConventionDecision_n3_transcript" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryRyAngleConventionDecision_n3_transcript")
Source documentation: `Transcript theorem for the boundary 'R_y' angle-convention decision packet. Only the source-backed decision boundary is checked here. The bridge obligation, product-to-coefficient theorem, LCU composition, block projection, block correctness, and final extraction remain false.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:8790](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L8790).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryRyLowerPacketGuard" (lean := "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryRyLowerPacketGuard")
Source documentation: `Lower-packet guard for the boundary 'R_y' decision freeze. This record is deliberately non-semantic. It packages the current source decision state so future lower packets can test that product-to-coefficient proof search is disabled until a source-backed convention or human decision is recorded. Source-backed convention work and reviewer audit remain allowed.`.

Kind: structure. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:8843](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L8843).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryRyLowerPacketGuard_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryRyLowerPacketGuard_n3")
Source documentation: `Compiled lower-packet guard for the focused 'n = 3' boundary branch. The guard does not choose an angle convention. It only freezes lower product-to-coefficient proof search around the existing decision packet while preserving the option to add a source-backed convention packet.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:8867](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L8867).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryRyLowerPacketGuard_n3_transcript" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryRyLowerPacketGuard_n3_transcript")
Source documentation: `Transcript theorem for the lower-packet guard. The theorem checks only the freeze state and false semantic flags. It is a guard against accidentally resuming the focused product proof before the boundary 'R_y' convention gap is resolved.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:8903](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L8903).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryRyCorrectedAngleSourceDecision" (lean := "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryRyCorrectedAngleSourceDecision")
Source documentation: `Source-backed correction decision for the focused boundary 'R_y' route. The local GHL2025 text states 'theta_j^s = arccos(D_j^(s) / N_D)', but the paper uses the standard one-qubit 'R_y' convention elsewhere and the companion implementation computes boundary correction angles as '2 * arccos(...)'. Therefore the next faithful lower packet should use the corrected input angle '2 * arccos(D_j^(s) / N_D)' with the standard 'R_y' matrix. This decision only unblocks product-to-coefficient work; it does not promote the product, LCU, projection, block-correctness, unitarity, or final-extraction flags.`.

Kind: structure. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:8951](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L8951).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryRyCorrectedAngleSourceDecision_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryRyCorrectedAngleSourceDecision_n3")
Source documentation: `Compiled corrected-angle decision for the 'n = 3', row-'0', slot-'2' boundary branch. This records the source audit result needed before the next lower packet: the boundary rotation should be represented as the standard 'R_y' gate with input angle '2 * arccos(D_0^(2) / N_D)', so its clean ket-zero entry is the normalized coefficient. All theorem-facing semantic claims remain unproved.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:8983](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L8983).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryRyCorrectedAngleSourceDecision_n3_transcript" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryRyCorrectedAngleSourceDecision_n3_transcript")
Source documentation: `Transcript theorem for the corrected-angle source decision. The theorem checks only the decision state. It explicitly leaves the product-to-coefficient theorem and all downstream semantic flags false.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:9029](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L9029).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryCorrectedCoefficientInterface" (lean := "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryCorrectedCoefficientInterface")
Source documentation: `Corrected-angle coefficient interface for the focused boundary branch. The record is deliberately conditional: the source-backed angle correction allows the 'Ry_boundary' clean entry to be treated as the normalized boundary coefficient, but the product-to-coefficient theorem and all block-encoding semantics remain false until separate Lean theorems prove them.`.

Kind: structure. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:9070](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L9070).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryCorrectedCoefficientInterface_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryCorrectedCoefficientInterface_n3")
Source documentation: `Compiled interface for replacing the boundary free factor by the corrected normalized coefficient in the 'n = 3', row-'0', column-'0', slot-'2' branch.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:9090](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L9090).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryCorrectedCoefficientInterface_n3_transcript" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryCorrectedCoefficientInterface_n3_transcript")
Source documentation: `Transcript theorem for the corrected-angle coefficient interface. This checks that the interface uses the global sparse-slot normalized coefficient and that every theorem-facing semantic claim remains unproved.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:9130](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L9130).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3BoundaryProductEntryEval_correctedAngle_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3BoundaryProductEntryEval_correctedAngle_n3")
Source documentation: `Conditional evaluated-product interface for the corrected boundary angle. Once the corrected-angle entry hypothesis is supplied for the environment, the compiled seven-gate boundary product is expressed using 'boundaryRotationNormalizedCoefficient' rather than the unresolved free symbol. This is not the final product-to-coefficient theorem.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:9164](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L9164).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3BoundaryProductEntryEval_correctedCoefficientExpanded_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3BoundaryProductEntryEval_correctedCoefficientExpanded_n3")
Source documentation: `Expanded corrected-angle product entry for the displayed boundary branch. This is the strongest local coefficient statement currently available for the focused 'n = 3', '(0,0)', slot-'2' packet. Under the corrected-entry hypothesis, the seven-gate product is the clean 'O_f' amplitude times the global-slot boundary coefficient normalized by 'N_D'. The theorem deliberately does not insert the theorem-level sparse-summation/'kappa' factor or promote the product-to-coefficient obligation.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:9192](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L9192).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryAkEntry_matches_globalSlot2_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryAkEntry_matches_globalSlot2_n3")
Source documentation: `The focused boundary target entry uses the same global slot-'2' coefficient. This closes the local stencil-side comparison for '(A_k)_{0,0}'. The remaining gap is not the Robin matrix entry; it is the theorem-level quotient/projection convention that must turn the branch-local product into '(A_k)_{0,0}/(N_D N_f kappa)'.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:9225](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L9225).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryProductToCoefficientObstruction" (lean := "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryProductToCoefficientObstruction")
Source documentation: `Precise remaining obstruction for the focused boundary product-to-coefficient route. The corrected-angle product has been reduced to '(f_3_0 * N_f_inv) * (D_0^(2) * N_D_inv)', and the target entry has been identified as 'f_3_0 * D_0^(2)'. What is still missing is an exact Lean convention relating this branch-local product to the theorem's normalized block entry with normalizer 'N_D * N_f * kappa', including the sparse-register summation/projection factor. This record keeps the theorem-facing obligation false instead of changing the scientific contract.`.

Kind: structure. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:9245](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L9245).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryProductToCoefficientObstruction_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryProductToCoefficientObstruction_n3")
Source documentation: `Compiled obstruction packet for 'oneTermRobinGamma3ProductToCoefficientObligation 3 0 0'.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:9266](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L9266).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryProductToCoefficientObstruction_n3_transcript" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryProductToCoefficientObstruction_n3_transcript")
Source documentation: `Transcript theorem for the focused boundary product-to-coefficient obstruction. This theorem records the smallest remaining Lean-local obstruction after the corrected-angle expansion and target-entry comparison. It keeps all semantic flags false.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:9316](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L9316).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryNormalizerProjectionConvention" (lean := "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryNormalizerProjectionConvention")
Source documentation: `Theorem-level normalizer/projection convention packet for the focused boundary 'gamma3' product route. The preceding local theorems have reduced the branch product to '(f_3_0 * N_f_inv) * (D_0^(2) * N_D_inv)' and the target entry to 'f_3_0 * D_0^(2)'. This packet ties those facts to the theorem normalizer 'N_D*N_f*kappa', while keeping the quotient interpretation of 'N_D_inv', 'N_f_inv', and the sparse-register 'kappa' projection as explicit false obligations.`.

Kind: structure. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:9360](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L9360).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryNormalizerProjectionConvention_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryNormalizerProjectionConvention_n3")
Source documentation: `Compiled normalizer/projection convention interface for 'oneTermRobinGamma3ProductToCoefficientObligation 3 0 0'. This is a typed convention packet, not the final product-to-coefficient proof. It records that the finite-composition contract uses the same normalizer 'GHL2025.oneTermRobinNormalizer', and that the remaining work is the symbolic inverse convention plus the sparse-register projection factor contributing the 'kappa' denominator.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:9395](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L9395).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryNormalizerProjectionConvention_n3_transcript" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryNormalizerProjectionConvention_n3_transcript")
Source documentation: `Transcript theorem for the focused normalizer/projection convention packet. The theorem checks the wiring to the compiled obstruction, the target-entry comparison, and the finite-composition normalizer. All theorem-facing semantic claims remain false.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:9446](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L9446).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryNormalizerSplitTarget" (lean := "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryNormalizerSplitTarget")
Source documentation: `Middle-agent split target for the next focused boundary 'gamma3' packet. The existing normalizer/projection convention already identifies the two remaining blockers. This record makes them explicit as separate lower-agent targets while reusing the same theorem route: * symbolic inverse semantics for 'N_D_inv' and 'N_f_inv'; * the sparse-register projection factor that contributes '1/kappa'. It is still a convention packet, not a proof of the product-to-coefficient obligation.`.

Kind: structure. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:9530](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L9530).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryNormalizerSplitTarget_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryNormalizerSplitTarget_n3")
Source documentation: `Lean-facing lower packet target after the boundary normalizer/projection convention compiled. The target keeps the fixed theorem-facing obligation 'oneTermRobinGamma3ProductToCoefficientObligation 3 0 0', but it splits the next proof work into two non-overlapping subgoals: the symbolic inverse interpretation of 'N_D_inv'/'N_f_inv', and the sparse-register 'kappa' projection factor. All semantic flags remain false.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:9562](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L9562).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryNormalizerSplitTarget_n3_transcript" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryNormalizerSplitTarget_n3_transcript")
Source documentation: `Transcript theorem for the split target. It checks that the two named sub-obligations are exactly the fields of the compiled normalizer/projection convention and that no semantic flag has been promoted.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:9597](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L9597).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundarySymbolicInverseEval_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundarySymbolicInverseEval_n3")
Source documentation: `Conditional symbolic-inverse evaluation for the focused boundary branch. This proves the local algebraic part of the split target: if the coefficient environment interprets 'N_D_inv' and 'N_f_inv' as right inverses of 'N_D' and 'N_f', then the corrected branch-local product recovers the target entry after multiplication by the 'N_D*N_f' part of the theorem normalizer. The lemma does not supply those inverse hypotheses and does not account for the separate '1/kappa' sparse-register projection factor.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:9647](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L9647).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundarySymbolicInverseSemantics" (lean := "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundarySymbolicInverseSemantics")
Source documentation: `Transcript packet for the symbolic-inverse half of the boundary split target. The conditional evaluation lemma above is compiled, but the theorem route still needs actual inverse semantics for the environment and still needs the separate 'kappa' projection factor. The product-to-coefficient and block-composition flags therefore remain false.`.

Kind: structure. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:9711](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L9711).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundarySymbolicInverseSemantics_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundarySymbolicInverseSemantics_n3")
Source documentation: `Compiled symbolic-inverse packet for the focused boundary branch. This reuses 'oneTermRobinGamma3BoundaryNormalizerSplitTarget_n3' and reduces only the 'N_D_inv'/'N_f_inv' algebra under explicit environment hypotheses. It does not prove the sparse-register '1/kappa' projection or the final product-to-coefficient obligation.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:9741](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L9741).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundarySymbolicInverseSemantics_n3_transcript" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundarySymbolicInverseSemantics_n3_transcript")
Source documentation: `Transcript theorem for the symbolic-inverse packet. It confirms that the new packet consumes exactly the split target's symbolic inverse obligation and leaves the 'kappa' projection and theorem-level composition obligations unproved.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:9777](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L9777).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryUniformSparseRegisterPreparationObligation_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryUniformSparseRegisterPreparationObligation_n3")
Source documentation: `Uniform sparse-register preparation obligation for the focused boundary 'gamma3' route. GHL2025 Eq. 'arbitrary sparcity' defines 'H_W^(kappa)' as the state preparation that gives each sparse slot amplitude '1/sqrt(kappa)'. For the boundary product-to-coefficient route, the missing projection convention is that the preparation amplitude and the matching sparse-register projection contribute the remaining '1/kappa' factor. This obligation records that source dependency without treating the cited implementation as formalized.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:9825](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L9825).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryKappaProjectionTarget" (lean := "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryKappaProjectionTarget")
Source documentation: `Middle-agent packet target for the sparse-register 'kappa' projection factor. The symbolic 'N_D_inv'/'N_f_inv' algebra now has a compiled conditional lemma. This target isolates the remaining source/projection convention: the sparse register is prepared by 'H_W^(kappa)' with amplitude '1/sqrt(kappa)', and the matching projection onto the focused slot contributes another '1/sqrt(kappa)'. The packet is intentionally contract-only; it does not prove the projection factor or the product-to-coefficient theorem.`.

Kind: structure. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:9843](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L9843).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryKappaProjectionTarget_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryKappaProjectionTarget_n3")
Source documentation: `Compiled sparse-register 'kappa' projection target for the focused boundary entry '(0,0)' and global sparse slot '2'. This is the next lower-agent packet target after 'oneTermRobinGamma3BoundarySymbolicInverseSemantics_n3'. It keeps all theorem-facing obligations false and records that the sparse-register factor depends on the 'H_W^(kappa)' uniform-preparation contract rather than on a new gate-level proof in this batch.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:9886](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L9886).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryKappaProjectionTarget_n3_transcript" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryKappaProjectionTarget_n3_transcript")
Source documentation: `Transcript theorem for the sparse-register 'kappa' projection target. The theorem only checks packet wiring: the focused sparse slot is '2', the source and target clean basis index is '32', the cited uniform-preparation dependency is named, and all product/composition/projection flags remain false.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:9938](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L9938).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryKappaProjectionEval_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryKappaProjectionEval_n3")
Source documentation: `Conditional sparse-register 'kappa' projection evaluation for the focused boundary branch. This combines the already compiled 'N_D_inv'/'N_f_inv' cancellation lemma with a separate symbolic 'kappa_inv' projection factor. Under explicit environment hypotheses, the projected branch-local product multiplied by the theorem normalizer evaluates to the target entry. The theorem does not prove that the circuit actually prepares or projects the sparse register with amplitude '1/sqrt(kappa)'; that source/projection convention remains an obligation.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:10000](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L10000).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryKappaProjectionSemantics" (lean := "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryKappaProjectionSemantics")
Source documentation: `Compiled packet for the conditional 'kappa_inv' projection evaluation. The packet records the Lean algebra that would finish the normalizer part once the sparse-register preparation/projection convention is available. It keeps the uniform-preparation, projection, finite-composition, and theorem-facing product obligations false.`.

Kind: structure. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:10079](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L10079).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryKappaProjectionSemantics_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryKappaProjectionSemantics_n3")
Source documentation: `Boundary 'gamma3' sparse-register projection packet for 'n = 3'. The field 'projectedBranchProduct' is the corrected branch-local product multiplied by a symbolic 'kappa_inv' factor. The compiled evaluation lemma checks only rational cancellation under explicit environment hypotheses; it is not a gate-level proof of 'H_W^(kappa)' or block projection.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:10110](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L10110).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryKappaProjectionSemantics_n3_transcript" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryKappaProjectionSemantics_n3_transcript")
Source documentation: `Transcript theorem for the conditional sparse-register projection packet. It checks that the packet reuses the middle-agent target, names 'oneTermRobinGamma3BoundaryKappaProjectionEval_n3' as the compiled algebra lemma, and preserves all semantic proof flags as false.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:10148](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L10148).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryProjectionSourceContract" (lean := "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryProjectionSourceContract")
Source documentation: `Source-backed projection contract for the inserted 'kappa_inv' factor. The compiled cancellation lemma treats 'Coeff.symbol "kappa_inv"' as an explicit factor in the projected branch product. This contract records the paper-facing source of that factor: 'H_W^(kappa)' prepares the sparse register with amplitude '1/sqrt(kappa)' on the focused slot, and the matching block-projection bra contributes the second '1/sqrt(kappa)'. The actual state-preparation circuit, projection convention, normalized block equality, and focused product-to-coefficient equality remain obligations.`.

Kind: structure. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:10198](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L10198).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionSourceContract_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionSourceContract_n3")
Source documentation: `Compiled source/projection contract for the focused boundary branch. This packet connects the existing conditional 'kappa_inv' algebra to the paper source and the cited uniform-state-preparation result. It deliberately does not prove that the circuit supplies the factor; the relevant fields remain false obligations for a later block-projection packet.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:10238](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L10238).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionSourceContract_n3_transcript" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionSourceContract_n3_transcript")
Source documentation: `Transcript theorem for the boundary projection source contract. It checks that the contract reuses the compiled 'kappa_inv' packet, points to the cited uniform-preparation row, fixes the focused slot data, and leaves all semantic obligations false.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:10289](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L10289).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionFactorIndex_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionFactorIndex_n3")
Source documentation: `Finite index check for the boundary projection-factor packet. This theorem proves only the local bookkeeping part of the sparse-register projection factor: the prepared sparse slot and the projected sparse slot are the same focused slot '2', and both use the clean basis index generated by 'oneTermRobinGamma3PaperBasisIndex'. It does not prove the amplitude of 'H_W^(kappa)', the matching projection amplitude, or the block-composition equality.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:10347](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L10347).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryProjectionFactorSemantics" (lean := "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryProjectionFactorSemantics")
Source documentation: `Finite projection-factor interface for the inserted 'kappa_inv' factor. The source contract says where the factor must come from. This packet adds the finite Lean-side index interface: the preparation and projection are both focused on sparse slot '2' and clean basis index '32', so the only remaining meaning of 'Coeff.symbol "kappa_inv"' is the amplitude theorem for the uniform sparse-register preparation and its matching block projection.`.

Kind: structure. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:10379](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L10379).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionFactorSemantics_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionFactorSemantics_n3")
Source documentation: `Compiled finite projection-factor interface for the focused boundary branch. This declaration reduces the projection-source gap to the exact missing semantic theorem: QBE still has to prove that the cited 'H_W^(kappa)' preparation and the matching block projection contribute the symbolic factor 'kappa_inv'. The finite slot and basis-index alignment is build-tested here.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:10422](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L10422).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionFactorSemantics_n3_transcript" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionFactorSemantics_n3_transcript")
Source documentation: `Transcript theorem for the finite projection-factor interface. The theorem checks the compiled index lemma, the focused sparse slot, the clean basis index, the projected branch product, and every false semantic flag.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:10472](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L10472).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryProjectionFactorObstruction" (lean := "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryProjectionFactorObstruction")
Source documentation: `Smallest current obstruction for proving the focused projection factor. The finite slot and basis-index interface is compiled, and the conditional 'kappa_inv' cancellation lemma is compiled. What remains is not another finite-index calculation: QBE still needs a formal source for the 'H_W^(kappa)' per-slot amplitude and a matching block-projection convention for the same sparse slot. This packet separates those two obligations while keeping the product-to-coefficient route false.`.

Kind: structure. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:10536](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L10536).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionFactorObstruction_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionFactorObstruction_n3")
Source documentation: `Compiled obstruction packet for the projection-factor semantics of the focused boundary branch. This is deliberately not a proof of 'kappa_inv'. It records that the cited uniform-preparation amplitude and the QBE matching projection convention are the two separate missing ingredients before the existing conditional algebra can feed the product-to-coefficient route.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:10573](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L10573).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionFactorObstruction_n3_transcript" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionFactorObstruction_n3_transcript")
Source documentation: `Transcript theorem for the projection-factor obstruction packet. The theorem confirms that the obstruction reuses the compiled finite projection-factor interface and does not promote product equality, LCU, projection, block correctness, normalized equality, or final extraction.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:10618](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L10618).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryMatchingProjectionConvention" (lean := "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryMatchingProjectionConvention")
Source documentation: `Local matching-projection convention for the focused boundary branch. The projection-factor obstruction has already separated the cited 'H_W^(kappa)' preparation amplitude from QBE's matching block-projection convention. This packet records only the local convention side: the projected bra is the same sparse slot '2' and the same clean basis index '32' used by the prepared branch. It does not prove that the bra contributes amplitude '1/sqrt(kappa)' and does not identify the two amplitude factors with 'Coeff.symbol "kappa_inv"'.`.

Kind: structure. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:10677](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L10677).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryMatchingProjectionConvention_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryMatchingProjectionConvention_n3")
Source documentation: `Compiled local matching-projection convention for sparse slot '2'. The convention reuses the compiled projection-factor obstruction and finite index lemma. It narrows the local missing ingredient to the semantic theorem that the block projection onto the matching sparse slot contributes the second '1/sqrt(kappa)' amplitude.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:10717](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L10717).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryMatchingProjectionConvention_n3_transcript" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryMatchingProjectionConvention_n3_transcript")
Source documentation: `Transcript theorem for the matching-projection convention packet. The theorem checks the local slot and basis-index wiring and confirms that the matching projection, projection-factor semantics, finite normalized equality, product-to-coefficient equality, and downstream block-encoding claims remain unproved.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:10765](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L10765).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionFactorProductEval_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionFactorProductEval_n3")
Source documentation: `Symbolic product check for the two sparse-register amplitude factors. This is only coefficient algebra: if an environment interprets the two '1/sqrt(kappa)' factors as 'sqrt_kappa_inv' and their product as 'kappa_inv', then the symbolic product evaluates to 'kappa_inv'. It does not prove the cited uniform-preparation amplitude or the matching projection amplitude.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:10832](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L10832).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryMatchingProjectionAmplitudeObstruction" (lean := "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryMatchingProjectionAmplitudeObstruction")
Source documentation: `Smallest current obstruction for the matching-projection amplitude packet. The local convention already fixes the projected bra to sparse slot '2' and clean basis index '32'. This packet separates the remaining amplitude work: the ket-side '1/sqrt(kappa)' factor is an external contract through 'H_W^(kappa)', the bra-side '1/sqrt(kappa)' factor is a local QBE block-projection obligation, and the product must be identified with the symbolic factor 'kappa_inv' before the conditional normalizer lemma can close the focused product route.`.

Kind: structure. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:10854](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L10854).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryMatchingProjectionAmplitudeObstruction_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryMatchingProjectionAmplitudeObstruction_n3")
Source documentation: `Compiled obstruction packet for the focused matching-projection amplitude. This reuses the matching-projection convention and adds the smallest symbolic factor interface needed by the next proof block. It does not prove either '1/sqrt(kappa)' amplitude and keeps product equality, finite normalized equality, LCU, block projection, block correctness, and final extraction false.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:10898](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L10898).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryMatchingProjectionAmplitudeObstruction_n3_transcript" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryMatchingProjectionAmplitudeObstruction_n3_transcript")
Source documentation: `Transcript theorem for the matching-projection amplitude obstruction. The theorem checks that the obstruction is downstream of the compiled matching-projection convention and that it introduces no semantic promotion.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:10956](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L10956).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryMatchingProjectionAmplitudeContract" (lean := "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryMatchingProjectionAmplitudeContract")
Source documentation: `Focused contract for the bra-side matching projection amplitude. The preceding obstruction already separates the cited ket amplitude from the local projection side. This packet gives the local side a precise interface: the block-projection bra is the clean branch for sparse slot '2', basis index '32', and its expected amplitude factor is the symbol 'sqrt_kappa_inv'. It is still a contract, not a projection theorem, so all semantic flags remain false.`.

Kind: structure. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:11028](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L11028).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryMatchingProjectionAmplitudeContract_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryMatchingProjectionAmplitudeContract_n3")
Source documentation: `Compiled bra-side projection-amplitude contract for the focused boundary route. This is the QBE-local complement to the cited 'H_W^(kappa)' preparation-amplitude contract. It narrows the remaining block-projection obligation to one finite branch and one expected symbolic amplitude factor.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:11069](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L11069).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryMatchingProjectionAmplitudeContract_n3_transcript" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryMatchingProjectionAmplitudeContract_n3_transcript")
Source documentation: `Transcript theorem for the focused bra-side projection-amplitude contract. It checks that the new contract is downstream of the existing obstruction, uses the same slot and basis index, exposes the expected 'sqrt_kappa_inv' factor, and preserves all false theorem-facing obligations.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:11125](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L11125).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryProjectionAmplitudeSemantics" (lean := "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryProjectionAmplitudeSemantics")
Source documentation: `Phase-1 projection-amplitude semantics for the focused boundary branch. The bra-side matching projection amplitude has now been narrowed to the symbol 'sqrt_kappa_inv', and the ket-side amplitude remains the cited 'H_W^(kappa)' contract. This packet accepts both as explicit contracts for the current GHL theorem transcript, while keeping the actual amplitude, factor-semantics, finite-composition, and product-to-coefficient obligations false.`.

Kind: structure. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:11190](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L11190).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionAmplitudeSemantics_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionAmplitudeSemantics_n3")
Source documentation: `Compiled projection-amplitude semantics packet for the focused 'gamma3' boundary branch. This is not a proof of the sparse-register amplitude. It is the precise Phase-1 contract interface needed before the route can use the symbolic product lemma and later discharge 'factorSemanticsObligation'.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:11237](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L11237).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionAmplitudeContractProductEval_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionAmplitudeContractProductEval_n3")
Source documentation: `Conditional product evaluation for the accepted sparse-register amplitude contracts. The theorem only performs symbolic coefficient algebra. It does not prove the cited 'H_W^(kappa)' ket amplitude, the QBE matching bra amplitude, or the factor-semantics obligation.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:11298](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L11298).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionAmplitudeSemantics_n3_transcript" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionAmplitudeSemantics_n3_transcript")
Source documentation: `Transcript theorem for the projection-amplitude semantics packet. It verifies that the packet consumes the existing bra-side amplitude contract, accepts the ket and bra amplitudes only as Phase-1 contracts, and keeps all semantic proof flags false.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:11318](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L11318).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionAmplitudeFactorEval_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionAmplitudeFactorEval_n3")
Source documentation: `Conditional factor-semantics evaluation for the accepted sparse-register amplitude contracts. This combines the local symbolic product lemma for the two 'sqrt_kappa_inv' factors with the existing conditional 'kappa_inv' normalizer lemma. The hypotheses are explicit coefficient-environment semantics; the theorem does not prove the cited 'H_W^(kappa)' amplitude, the matching projection amplitude, or the theorem-facing product obligation.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:11394](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L11394).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryProjectionAmplitudeFactorSemantics" (lean := "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryProjectionAmplitudeFactorSemantics")
Source documentation: `Compiled packet for the conditional factor-semantics bridge. The packet records that the accepted ket and bra amplitude contracts can feed the existing 'kappa_inv' normalizer lemma only under the explicit product hypothesis. It keeps all amplitude, factor-semantics, finite-composition, and product-to-coefficient proof flags false.`.

Kind: structure. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:11457](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L11457).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionAmplitudeFactorSemantics_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionAmplitudeFactorSemantics_n3")
Source documentation: `Factor-semantics bridge for the focused boundary 'gamma3' packet. The projected branch product uses the two accepted 'sqrt_kappa_inv' amplitude contracts directly. The conditional lemma shows that this product has the same normalizer behavior as the earlier inserted 'kappa_inv' factor when the environment supplies the product identity.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:11498](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L11498).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionAmplitudeFactorSemantics_n3_transcript" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionAmplitudeFactorSemantics_n3_transcript")
Source documentation: `Transcript theorem for the conditional factor-semantics bridge. It checks the bridge wiring and confirms that no amplitude, projection, finite-composition, product-to-coefficient, LCU, block-correctness, or final extraction flag has been promoted.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:11554](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L11554).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryFactorSemanticsContractMap" (lean := "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryFactorSemanticsContractMap")
Source documentation: `Source-backed contract map for the factor-semantics obligation. The conditional factor bridge is already compiled. This packet records the four remaining sources that must be supplied before the bridge can discharge the actual factor-semantics obligation: the cited ket amplitude, the local bra projection amplitude, the symbolic square-root product hypothesis, and the finite normalized block-composition equality. It keeps the theorem-facing obligation false.`.

Kind: structure. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:11623](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L11623).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryFactorSemanticsContractMap_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryFactorSemanticsContractMap_n3")
Source documentation: `Compiled contract map for the focused boundary factor-semantics obligation. This is a Phase-1 transcript object. It says precisely what would make 'oneTermRobinGamma3BoundaryProjectionAmplitudeFactorEval_n3' usable as the factor-semantics step, while preserving the false status of the real semantic obligations.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:11664](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L11664).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryFactorSemanticsContractMapEval_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryFactorSemanticsContractMapEval_n3")
Source documentation: `Conditional evaluation through the contract-map fields. The theorem does not prove the source obligations. It only shows that if the environment supplies the four stated coefficient hypotheses, then the contract map's projected branch product normalizes to the expected target entry.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:11719](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L11719).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryFactorSemanticsContractMap_n3_transcript" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryFactorSemanticsContractMap_n3_transcript")
Source documentation: `Transcript theorem for the focused factor-semantics contract map. It checks that the map is downstream of the compiled factor bridge, separates the ket, bra, product-hypothesis, and finite-composition blockers, and keeps all semantic proof flags false.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:11744](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L11744).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryBraProjectionAmplitudeSourceMap" (lean := "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryBraProjectionAmplitudeSourceMap")
Source documentation: `Source map for the remaining bra-side projection-amplitude obstruction. The focused projection-amplitude contract already fixes sparse slot '2', clean basis index '32', and the expected factor 'sqrt_kappa_inv'. What is still missing is not another finite index lemma: QBE has not yet introduced the concrete sparse-register preparation/projection matrix, or an equivalent adjoint-entry contract, that would make the bra amplitude a Lean theorem.`.

Kind: structure. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:11816](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L11816).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBraProjectionAmplitudeSourceMap_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBraProjectionAmplitudeSourceMap_n3")
Source documentation: `Compiled source map for the focused bra-side amplitude packet. This is the smaller obstruction requested by the lower packet. It records the precise semantic object needed to prove the local bra amplitude, instead of pretending that the current block-projection API already supplies it.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:11855](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L11855).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBraProjectionAmplitudeSourceMap_n3_transcript" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBraProjectionAmplitudeSourceMap_n3_transcript")
Source documentation: `Transcript theorem for the bra-side projection-amplitude source map. This theorem checks only the source mapping and false-flag discipline. It does not prove the 'H_W^(kappa)' adjoint entry, the block-projection amplitude, the factor-semantics obligation, finite normalized equality, or the focused product-to-coefficient theorem.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:11914](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L11914).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryHWKappaDaggerProjectionEntryContract" (lean := "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryHWKappaDaggerProjectionEntryContract")
Source documentation: `Typed contract for the focused 'H_W^(kappa)' dagger projection entry. The source map already identified the missing semantic object. This contract turns that object into a Lean-facing interface for the exact entry needed by the boundary gamma3 route: the bra projection from sparse slot '2' to the clean sparse-register branch contributes 'sqrt_kappa_inv' at clean basis index '32'. It is accepted only as a Phase-1 contract; the actual matrix entry theorem and all downstream semantic obligations remain false.`.

Kind: structure. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:11980](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L11980).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaDaggerProjectionEntryContract_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaDaggerProjectionEntryContract_n3")
Source documentation: `Compiled Phase-1 contract for the focused bra projection entry. The contract is downstream of 'oneTermRobinGamma3BoundaryBraProjectionAmplitudeSourceMap_n3' and rewires the same bra-amplitude obligation into 'oneTermRobinGamma3BoundaryFactorSemanticsContractMap_n3'. It does not prove the entry of 'H_W^(kappa)^dagger'; it records the precise contract that a future semantic matrix theorem must instantiate.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:12024](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L12024).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaDaggerProjectionEntryContract_n3_transcript" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaDaggerProjectionEntryContract_n3_transcript")
Source documentation: `Transcript theorem for the focused 'H_W^(kappa)' dagger entry contract. This checks that the new contract is wired to both the bra-source map and the factor-semantics contract map. The entry is still a contract-only interface: the actual dagger entry, bra amplitude, factor semantics, finite normalized equality, product-to-coefficient theorem, and final extraction remain false.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:12087](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L12087).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryHWKappaDaggerEmbeddedEntryInterface" (lean := "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryHWKappaDaggerEmbeddedEntryInterface")
Source documentation: `Embedded-entry interface for the focused 'H_W^(kappa)^dagger' contract. The preceding contract names the required local sparse-register entry '<0|H_W^(kappa)^dagger|2>'. This packet refines that contract to the exact finite layout used by the boundary gamma3 route for 'n = 3': the sparse register has width 'ceil(log2 kappa) = 3', local column '2' is in the 'kappa = 7' source domain and the eight-dimensional register, and the ambient clean branch is basis index '32'. It still does not define the 'H_W^(kappa)' matrix or prove the entry.`.

Kind: structure. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:12159](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L12159).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaDaggerEmbeddedEntryInterface_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaDaggerEmbeddedEntryInterface_n3")
Source documentation: `Compiled embedded-entry interface for the focused boundary branch. This is the strict local interface that a future concrete 'H_W^(kappa)^dagger' matrix theorem should instantiate. It is narrower than the source map because the local sparse-register entry, the 'kappa = 7' domain check, the '2^3 = 8' ambient sparse-register dimension, and the clean gamma3 basis index are all fixed and build-tested.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:12208](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L12208).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaDaggerEmbeddedEntryInterface_n3_transcript" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaDaggerEmbeddedEntryInterface_n3_transcript")
Source documentation: `Transcript theorem for the embedded-entry interface. This theorem proves only finite layout wiring for the focused interface. It does not prove the 'H_W^(kappa)^dagger' matrix entry, the bra amplitude, the factor-semantics obligation, finite normalized equality, or the focused product-to-coefficient theorem.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:12269](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L12269).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaDaggerEntryFromUniformColumn_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaDaggerEntryFromUniformColumn_n3")
Source documentation: `Conditional adjoint-entry lemma for the focused 'H_W^(kappa)' slot. If a sparse-register preparation matrix has clean-column entry 'H_W^(kappa)[2,0] = sqrt_kappa_inv', and the local adjoint-entry convention identifies the dagger entry with that clean-column entry, then the focused row-'0', column-'2' dagger entry has the expected value. This is only the local matrix-entry algebra; it does not provide the cited uniform-column contract or a concrete 'H_W^(kappa)' matrix.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:12345](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L12345).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryHWKappaDaggerUniformColumnContract" (lean := "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryHWKappaDaggerUniformColumnContract")
Source documentation: `Uniform-column and adjoint-entry contract split for the focused dagger entry. The embedded interface fixes the local row and column. This record splits the remaining semantic source into the cited clean-column amplitude 'H_W^(kappa)[2,0] = 1/sqrt(kappa)' and the QBE adjoint-entry convention that turns that column entry into the bra-side dagger entry. Both source inputs remain obligations; the only compiled theorem is the conditional entry lemma above.`.

Kind: structure. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:12367](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L12367).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaDaggerUniformColumnContract_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaDaggerUniformColumnContract_n3")
Source documentation: `Compiled contract split for row '0', column '2' of 'H_W^(kappa)^dagger'. This refines the embedded-entry interface without proving the uniform preparation result or the adjoint-entry convention. The compiled conditional lemma records exactly what a future concrete sparse-register matrix theorem must instantiate.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:12421](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L12421).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaDaggerUniformColumnContract_n3_transcript" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaDaggerUniformColumnContract_n3_transcript")
Source documentation: `Transcript theorem for the uniform-column contract split. The theorem checks that the split is tied to the embedded-entry interface, that the compiled conditional entry lemma has the expected shape, and that all semantic proof flags remain false.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:12502](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L12502).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaDaggerTransposeMatrix_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaDaggerTransposeMatrix_n3")
Source documentation: `Local transpose-style dagger for the focused symbolic 'H_W^(kappa)' matrix. The current 'Coeff' backend is a symbolic real-coefficient matrix layer with no conjugation operation. For this Phase-1 packet the only needed adjoint fact is therefore the focused transpose entry used by the row-'0', column-'2' boundary route.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:12589](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L12589).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaDaggerTransposeEntryConvention_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaDaggerTransposeEntryConvention_n3")
Source documentation: `Focused adjoint-entry convention for the boundary 'H_W^(kappa)' packet. This proves only the matrix-interface convention 'H_W^(kappa)^dagger[0,2] = H_W^(kappa)[2,0]' for the local transpose-style dagger. It does not provide the cited clean-column amplitude.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:12600](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L12600).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaDaggerEntryFromTransposeUniformColumn_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaDaggerEntryFromTransposeUniformColumn_n3")
Source documentation: `Focused dagger-entry theorem under the external uniform-column contract. The adjoint-entry convention is now supplied by the local transpose-style matrix interface; the theorem remains conditional on the clean-column amplitude from the cited 'H_W^(kappa)' state-preparation contract.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:12614](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L12614).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryHWKappaDaggerAdjointEntryConvention" (lean := "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryHWKappaDaggerAdjointEntryConvention")
Source documentation: `Adjoint-entry convention packet for the focused 'H_W^(kappa)' dagger entry. This refines 'oneTermRobinGamma3BoundaryHWKappaDaggerUniformColumnContract_n3' by supplying the QBE local transpose-style adjoint convention for row '0', column '2'. The Shukla--Vedula clean-column amplitude remains contract-only, so the full dagger entry and all downstream product/block obligations remain false.`.

Kind: structure. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:12636](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L12636).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaDaggerAdjointEntryConvention_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaDaggerAdjointEntryConvention_n3")
Source documentation: `Compiled local adjoint-entry convention for the focused boundary branch. Only the local transpose convention is proved here. The uniform clean-column entry remains an external cited contract, so this packet cannot discharge the bra-amplitude or focused product-to-coefficient obligations by itself.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:12688](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L12688).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaDaggerAdjointEntryConvention_n3_transcript" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaDaggerAdjointEntryConvention_n3_transcript")
Source documentation: `Transcript theorem for the local adjoint-entry convention packet. The QBE transpose-style convention is now compiled and marked proved in this local packet. The external uniform-column source, full dagger entry, bra-amplitude route, factor semantics, finite normalized equality, focused product theorem, and all block-correctness flags remain false.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:12762](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L12762).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryHWKappaCleanColumnContract" (lean := "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryHWKappaCleanColumnContract")
Source documentation: `External clean-column contract bridge for the focused 'H_W^(kappa)' entry. This packet accepts the GHL2025 Eq. 'arbitrary sparcity' clean-column entry only as a typed external contract through the existing Shukla--Vedula cited row. It then records that the accepted entry is the exact hypothesis consumed by the compiled transpose-style dagger bridge. No cited theorem is formalized and no product, projection, LCU, block-correctness, or final-extraction flag is promoted.`.

Kind: structure. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:12853](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L12853).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaCleanColumnContract_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaCleanColumnContract_n3")
Source documentation: `Compiled clean-column contract bridge for the focused boundary branch. The bridge records the external contract 'H_W^(kappa)[2,0] = sqrt_kappa_inv' and ties it to the already-compiled transpose convention. The clean-column source remains 'contract-only'; the actual dagger entry and downstream bra-amplitude route remain unproved.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:12906](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L12906).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaCleanColumnContract_feedsTransposeBridge_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaCleanColumnContract_feedsTransposeBridge_n3")
Source documentation: `The clean-column contract is exactly the hypothesis consumed by the transpose dagger bridge. This theorem is conditional on a matrix satisfying the external clean-column entry. It does not prove that any concrete 'H_W^(kappa)' matrix satisfies that entry.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:12976](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L12976).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaCleanColumnContract_n3_transcript" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaCleanColumnContract_n3_transcript")
Source documentation: `Transcript theorem for the clean-column contract bridge. The theorem checks that the bridge uses the Shukla--Vedula cited row as a contract-only source, feeds the accepted entry through the transpose lemma, and keeps the theorem-facing semantic flags false.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:13002](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L13002).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryCleanColumnBraRouteContract" (lean := "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryCleanColumnBraRouteContract")
Source documentation: `Route contract from the accepted clean-column input to the existing bra amplitude and factor-semantics obligations. The clean-column bridge supplies a conditional focused dagger entry under the external Shukla--Vedula uniform-column contract. This packet records that the same entry is exactly the bra-side amplitude source needed by 'oneTermRobinGamma3BoundaryBraProjectionAmplitudeSourceMap_n3' and the same bra-amplitude obligation consumed by 'oneTermRobinGamma3BoundaryFactorSemanticsContractMap_n3'. It is still only a route contract: the external clean-column theorem, the actual bra amplitude, factor semantics, finite normalized equality, and product-to-coefficient obligation remain false.`.

Kind: structure. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:13097](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L13097).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryCleanColumnBraRouteContract_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryCleanColumnBraRouteContract_n3")
Source documentation: `Compiled clean-column to bra-route contract for the focused boundary branch. This declaration connects the contract-only clean-column bridge to the exact bra-amplitude and factor-semantics fields already present in the route. It does not prove the Shukla--Vedula clean-column input or discharge the internal projection-amplitude obligation.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:13154](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L13154).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryCleanColumnBraRouteContract_feedsBraAmplitude_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryCleanColumnBraRouteContract_feedsBraAmplitude_n3")
Source documentation: `The clean-column bridge feeds the expected bra-amplitude factor conditionally. This theorem only rewrites the existing transpose bridge through the new route contract. The uniform-column hypothesis remains external.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:13226](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L13226).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryCleanColumnBraRouteContract_n3_transcript" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryCleanColumnBraRouteContract_n3_transcript")
Source documentation: `Transcript theorem for the clean-column to bra-route contract. This checks that the route points at the same bra-amplitude obligation in the source map and the factor-semantics contract map, while every semantic proof flag remains false.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:13252](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L13252).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryCleanColumnFactorSemanticsRoute" (lean := "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryCleanColumnFactorSemanticsRoute")
Source documentation: `Under-contract route from the clean-column bra factor to factor semantics. The route records that the clean-column-to-bra bridge supplies the bra-side factor expected by the factor-semantics contract map. It also keeps the external uniform amplitude, ket amplitude, square-root product convention, finite normalized equality, and focused product theorem as explicit false obligations.`.

Kind: structure. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:13362](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L13362).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryCleanColumnFactorSemanticsRoute_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryCleanColumnFactorSemanticsRoute_n3")
Source documentation: `Compiled clean-column to factor-semantics route for the focused boundary branch. This declaration is not a proof of the Shukla--Vedula preparation theorem or the final product-to-coefficient obligation. It only connects the clean bra-factor route to the already compiled conditional factor-map evaluation.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:13417](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L13417).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryCleanColumnFactorSemanticsRouteEval_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryCleanColumnFactorSemanticsRouteEval_n3")
Source documentation: `Conditional evaluation for the clean-column to factor-semantics route. The theorem explicitly consumes the external clean-column hypothesis and the coefficient-environment hypotheses. It proves only the local conditional bridge and the already compiled factor-map evaluation under those contracts.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:13488](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L13488).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryCleanColumnFactorSemanticsRoute_n3_transcript" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryCleanColumnFactorSemanticsRoute_n3_transcript")
Source documentation: `Transcript theorem for the clean-column to factor-semantics route. It checks that the route connects the clean-column bra factor to the factor contract map and preserves all theorem-facing semantic flags as false.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:13532](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L13532).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryProductUnderContractsRoute" (lean := "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryProductUnderContractsRoute")
Source documentation: `Product-under-contracts route for the focused boundary branch. The clean-column factor-semantics route already supplies the conditional coefficient calculation. This packet ties that route to the fixed 'oneTermRobinGamma3ProductToCoefficientObligation 3 0 0' and names the exact remaining bridge: the finite block-composition contract must identify the projected branch product with the theorem's normalized block entry. No semantic proof flag is promoted here.`.

Kind: structure. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:13630](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L13630).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryProductUnderContractsRoute_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryProductUnderContractsRoute_n3")
Source documentation: `Compiled product-under-contracts route for 'oneTermRobinGamma3ProductToCoefficientObligation 3 0 0'. The route uses the clean-column factor-semantics calculation as its local coefficient engine, then records the remaining theorem-facing bridge to the finite block-composition contract. The product obligation remains false.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:13682](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L13682).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryProductUnderContractsEval_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryProductUnderContractsEval_n3")
Source documentation: `Conditional product-under-contracts evaluation for the focused boundary route. This is only the Lean-local algebra under explicit contracts. It reuses 'oneTermRobinGamma3BoundaryCleanColumnFactorSemanticsRouteEval_n3' and does not prove the finite block-composition bridge or the product-to-coefficient obligation.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:13749](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L13749).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryProductUnderContractsRoute_n3_transcript" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryProductUnderContractsRoute_n3_transcript")
Source documentation: `Transcript theorem for the product-under-contracts route. The theorem confirms that the new packet starts from the clean-column factor route, points at the fixed boundary product obligation, and leaves the finite-composition bridge and product-to-coefficient theorem unproved.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:13788](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L13788).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryFiniteProjectionBlockEntryIndex_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryFiniteProjectionBlockEntryIndex_n3")
Source documentation: `Finite signal-block index lemma for the focused product/projection bridge. The conditional product route works with the branch basis index '32', where sparse slot '2' and system column '0' are embedded in the full circuit basis. The finite block-composition contract, however, exposes the signal-zero block entry at compound row and column '0' for the '(0,0)' system entry. This lemma records that finite indexing fact without claiming that the branch product has already been summed into the block entry.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:13877](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L13877).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryFiniteProjectionProductBridge" (lean := "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryFiniteProjectionProductBridge")
Source documentation: `Finite projection/product bridge packet for the focused boundary branch. This consumes 'oneTermRobinGamma3BoundaryProductUnderContractsRoute_n3' and connects it to the exact finite block-composition entry interface. The compiled part is the index bridge: the signal-zero block entry is the full unitary entry at compound row and column '0', while the branch-local product has been calculated at the embedded sparse-slot basis index '32'. The missing field is now explicit: QBE still needs a branch-decomposition/projection theorem identifying the route's projected branch product with the finite signal-zero block entry before the product obligation can be promoted.`.

Kind: structure. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:13917](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L13917).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryFiniteProjectionProductBridge_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryFiniteProjectionProductBridge_n3")
Source documentation: `Compiled finite projection/product bridge for 'oneTermRobinGamma3ProductToCoefficientObligation 3 0 0'. The bridge deliberately does not assert that the branch-local product is the finite block entry. It records the exact indexing mismatch and names the missing branch-decomposition theorem as the current Lean-local obstruction.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:13963](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L13963).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryFiniteProjectionProductBridge_n3_transcript" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryFiniteProjectionProductBridge_n3_transcript")
Source documentation: `Transcript theorem for the finite projection/product bridge packet. This checks that the bridge consumes the active product-under-contracts route, that the finite signal block uses row and column '0' while the focused branch uses basis index '32', and that all theorem-facing proof flags remain false.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:14036](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L14036).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryBranchDecompositionSlot2" (lean := "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryBranchDecompositionSlot2")
Source documentation: `Branch-decomposition interface for the focused slot-'2' boundary product. The finite projection bridge proves only the index fact: Definition 'def:block-encoding' reads the signal-zero block entry at full '[0,0]', while the branch-local route is attached to the embedded sparse-slot entry '[32,32]'. This packet names the missing finite theorem that must decompose the signal-zero entry into sparse-branch contributions and identify the slot-'2' contribution with the route's projected branch product. It is an obstruction/interface record, not a proof of the branch sum. All theorem-facing proof flags therefore remain false.`.

Kind: structure. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:14112](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L14112).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBranchDecompositionSlot2_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBranchDecompositionSlot2_n3")
Source documentation: `Compiled branch-decomposition interface for the fixed boundary branch. The record consumes 'oneTermRobinGamma3BoundaryFiniteProjectionProductBridge_n3' and makes the next missing theorem precise: QBE needs a finite branch-sum or projection-summation theorem that sends the slot-'2' projected branch product at '[32,32]' into the signal-zero block entry '[0,0]'. No semantic flag is promoted.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:14164](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L14164).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBranchDecompositionSlot2_n3_transcript" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBranchDecompositionSlot2_n3_transcript")
Source documentation: `Transcript theorem for the slot-'2' branch-decomposition interface. The theorem checks that the packet starts from the finite projection bridge, keeps the signal-zero entry '[0,0]' separate from the branch-local entry '[32,32]', and leaves the projection-summation theorem and all semantic flags false.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:14231](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L14231).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryProjectionSummationTarget" (lean := "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryProjectionSummationTarget")
Source documentation: `Typed projection-summation target for the focused slot-'2' boundary packet. The earlier branch-decomposition record names the missing theorem in prose. This target exposes the actual coefficient objects that the theorem must relate: the signal-zero block entry selected by Definition 'def:block-encoding' and the compiled branch-local seven-gate matrix entry at '[32,32]'. The record does not assert that these entries are equal or that the branch contribution has already been summed into the signal-zero block.`.

Kind: structure. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:14308](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L14308).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionSummationTarget_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionSummationTarget_n3")
Source documentation: `Compiled typed target for the missing branch projection/summation theorem. The signal-zero block entry is taken from the finite block-composition contract, while the branch entry is the local seven-gate boundary matrix entry at the slot-'2' basis index. The missing theorem is now a typed bridge between these two 'Coeff' objects rather than only a string-level obligation.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:14360](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L14360).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionSummationTarget_n3_transcript" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionSummationTarget_n3_transcript")
Source documentation: `Transcript theorem for the typed projection-summation target. The theorem checks that the target keeps the signal block entry '[0,0]' and the branch matrix entry '[32,32]' as typed coefficient objects, names the existing evaluation lemma, and leaves branch selection, projection-summation, normalized equality, and product-to-coefficient flags false.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:14467](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L14467).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryBranchEntrySelection" (lean := "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryBranchEntrySelection")
Source documentation: `Conditional branch-entry selection packet for the focused slot-'2' boundary target. The selected local branch entry is the seven-gate matrix entry at '[32,32]'. The route's 'projectedBranchProduct' already includes the two sparse-register projection amplitudes, so the compiled theorem below multiplies the selected branch entry by the existing projection-amplitude factor. The theorem is still conditional on the corrected boundary-rotation entry; it does not prove the projection/summation theorem from the signal-zero block entry '[0,0]'.`.

Kind: structure. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:14537](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L14537).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBranchEntrySelection_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBranchEntrySelection_n3")
Source documentation: `Compiled branch-entry selection interface for the focused projection target. This packet reuses the typed projection-summation target and records the conditional local theorem that selects the branch entry '[32,32]' and feeds it to the route product after the sparse-register projection-amplitude factor is attached. All source obligations and theorem-facing flags remain false.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:14576](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L14576).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBranchEntrySelectionEval_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBranchEntrySelectionEval_n3")
Source documentation: `Conditional branch-entry selection for the focused projection target. Under the corrected 'Ry_boundary' entry hypothesis, the selected seven-gate entry '[32,32]', multiplied by the existing sparse-register projection amplitude factor, evaluates to the route's typed 'projectedBranchProduct'. This is not the signal-block projection/summation theorem.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:14626](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L14626).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBranchEntrySelection_n3_transcript" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBranchEntrySelection_n3_transcript")
Source documentation: `Transcript theorem for the branch-entry selection packet. The theorem records the new conditional local lemma and checks that the actual branch-entry selection, projection/summation, product bridge, normalized equality, and product-to-coefficient obligations remain unproved.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:14666](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L14666).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryProjectionSummationObstruction" (lean := "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryProjectionSummationObstruction")
Source documentation: `Typed obstruction for the remaining finite projection/summation step. The selected slot-'2' contribution is now a concrete 'Coeff': the branch-local entry '[32,32]' multiplied by the two sparse-register projection amplitudes. What QBE still lacks is a finite matrix-semantics field that presents the signal-zero entry '[0,0]' as a sum over sparse-branch contributions and then selects the slot-'2' summand. This record names that missing field without asserting the sum.`.

Kind: structure. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:14739](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L14739).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionSummationObstruction_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionSummationObstruction_n3")
Source documentation: `Compiled typed obstruction for the focused boundary projection/summation bridge. The object is the next theorem-facing interface for 'oneTermRobinGamma3ProductToCoefficientObligation 3 0 0': it records the slot domain '0, ..., 6', identifies slot '2', and exposes the selected contribution as a typed coefficient. The sparse-branch contribution family itself is absent from the current finite matrix semantics.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:14792](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L14792).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionSummationObstruction_selectedSlotEval_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionSummationObstruction_selectedSlotEval_n3")
Source documentation: `The new obstruction reuses the accepted branch-entry selection lemma. Under the corrected boundary-rotation entry hypothesis, the typed selected slot contribution evaluates to the route's projected branch product. This still does not prove that the signal-zero block entry is the sparse-branch sum.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:14863](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L14863).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionSummationObstruction_n3_transcript" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionSummationObstruction_n3_transcript")
Source documentation: `Transcript theorem for the typed projection/summation obstruction. The theorem checks that the sparse-slot domain and selected contribution are typed, names the exact missing branch-contribution family, and keeps every projection, block-composition, and theorem-facing flag false.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:14892](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L14892).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBranchContributionFocusedSlot" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBranchContributionFocusedSlot")
Source documentation: `Focused sparse slot for the branch-contribution interface. The source boundary branch of Eq. 'ROBIN clarified' uses the global sparse slot '2' for system entry '(0,0)' in the finite 'n = 3', 'κ = 7' witness.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:14978](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L14978).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBranchContributionSum" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBranchContributionSum")
Source documentation: `Typed sparse-branch sum over the seven one-term Robin sparse slots. This is intentionally a project-local 'List.finRange' fold instead of a 'Finset.sum', because 'Coeff' is a syntactic coefficient language rather than an additive commutative monoid. It provides the Lean type that the missing projection/summation theorem must target.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:14989](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L14989).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBranchContributionPlaceholder_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBranchContributionPlaceholder_n3")
Source documentation: `Placeholder branch-contribution family for the focused projection/summation interface. Only slot '2' is identified with the already compiled selected contribution. The other slots remain opaque symbolic placeholders; this definition does not assert that their sum is the signal-zero block entry.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:15001](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L15001).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryBranchContributionFamily" (lean := "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryBranchContributionFamily")
Source documentation: `Typed branch-contribution family required by the finite projection/summation bridge. The record supplies the missing shape 'branchContribution : Fin 7 -> Coeff', proves only the selected slot-'2' identity, and leaves the statement 'signalBlockEntry = branchContributionSum' as a typed unproved proposition.`.

Kind: structure. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:15019](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L15019).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBranchContributionFamily_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBranchContributionFamily_n3")
Source documentation: `Compiled branch-contribution family for the focused 'n = 3' boundary branch. This turns the previous string-level interface into a typed Lean family. It does not prove that the signal-zero block entry is the sparse-branch sum.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:15052](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L15052).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBranchContribution_selectedSlot_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBranchContribution_selectedSlot_n3")
Source documentation: `The typed branch-contribution family selects the accepted slot-'2' contribution. This is only the local selected-slot identity. It is not the sparse-branch summation theorem for the signal-zero block entry.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:15101](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L15101).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryBranchContributionObstruction" (lean := "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryBranchContributionObstruction")
Source documentation: `Typed obstruction after introducing the branch-contribution family. The selected slot theorem is now compiled, but the QBE-local finite matrix semantics still lacks the summation proof connecting the signal-zero block entry to the branch-contribution fold.`.

Kind: structure. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:15114](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L15114).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBranchContributionObstruction_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBranchContributionObstruction_n3")
Source documentation: `Current obstruction for the focused projection/summation bridge after the branch-contribution family has been made a typed Lean interface.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:15139](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L15139).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBranchContributionObstruction_n3_transcript" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBranchContributionObstruction_n3_transcript")
Source documentation: `Transcript theorem for the branch-contribution-family obstruction. The theorem verifies that the focused family is typed, slot '2' is selected, and every theorem-facing semantic flag remains false except the local selected-slot interface theorem.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:15174](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L15174).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContributionPredicate_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContributionPredicate_n3")
Source documentation: `Predicate that a backend-sourced sparse-branch contribution family must satisfy for the focused boundary projection/summation theorem. This is the next-run target, not a new assumption. A candidate family must come from the finite projection semantics, select slot '2' as the accepted branch contribution, and sum to the signal-zero block entry.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:15233](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L15233).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryBackendProjectionSummationFieldTarget" (lean := "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryBackendProjectionSummationFieldTarget")
Source documentation: `Smallest backend field still missing from the focused projection bridge. The previous packet supplied a placeholder 'branchContribution' family so Lean could type the selected-slot and branch-sum statements. This record prevents that placeholder from being mistaken for the finite matrix-semantics field: the actual field must be sourced from the 'BlockExtractionTarget'/projection backend and satisfy 'oneTermRobinGamma3BoundaryBackendBranchContributionPredicate_n3'.`.

Kind: structure. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:15250](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L15250).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendProjectionSummationFieldTarget_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendProjectionSummationFieldTarget_n3")
Source documentation: `Concrete backend-field target for the focused 'n = 3' boundary branch. No theorem-facing flag is promoted. The record says that the placeholder family is useful only for typing the statements; the missing semantic field is a backend-sourced 'Fin 7 -> Coeff' family for the signal-zero entry.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:15284](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L15284).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBlockExtractionBranchContributionTarget_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBlockExtractionBranchContributionTarget_n3")
Source documentation: `Generic block-extraction branch-contribution target for the focused boundary entry. This uses the new QBE-local backend interface to type the seven-slot family at 'contract.expectedTarget.blockMatrix[0,0]'. The family is still the current placeholder from the Robin obstruction, so the backend-source and branch-sum obligations stay false. This target exists only to make the next required backend theorem precise.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:15385](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L15385).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryBlockExtractionBackendGap" (lean := "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryBlockExtractionBackendGap")
Source documentation: `Smallest obstruction after inspecting the current 'BlockExtractionTarget' backend. The backend gives a concrete 'blockMatrix[0,0]' entry and the corresponding full-unitary entry. It does not yet expose a sparse-slot contribution family for that entry. This record is therefore a narrower obstruction than the generic backend-field target: it points at the existing 'BlockExtractionTarget' fields and names the missing projection-summand interface.`.

Kind: structure. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:15467](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L15467).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBlockExtractionBackendGap_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBlockExtractionBackendGap_n3")
Source documentation: `Concrete backend gap for the focused 'n = 3' boundary branch. This does not change 'BlockExtractionTarget' or prove the branch sum. It records that the available backend data reaches only the signal-zero block entry and its full-unitary index bridge.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:15517](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L15517).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBlockExtractionBackendGap_n3_transcript" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBlockExtractionBackendGap_n3_transcript")
Source documentation: `Transcript theorem for the block-extraction backend gap. The theorem checks that the gap is tied to the actual 'BlockExtractionTarget' entry and that all theorem-facing semantic flags remain false.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:15572](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L15572).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchFullIndex_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchFullIndex_n3")
Source documentation: `Full-basis branch index map for the focused 'n = 3' boundary backend packet. For the system column '0', this maps each sparse slot to the clean paper-basis index used by the displayed 'gamma3' register expression. The map is typed as a full circuit basis index; it does not by itself provide the branch summand formula or the branch-sum theorem for the signal-zero block entry.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:15644](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L15644).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchFullIndex_selected_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchFullIndex_selected_n3")
Source documentation: `The backend branch-index map sends the focused slot '2' to the accepted clean branch basis index '32'.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:15668](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L15668).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchFullIndex_slotZero_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchFullIndex_slotZero_n3")
Source documentation: `The backend branch-index map sends sparse slot '0' to the active signal-zero full basis index '0'. This is the active-entry side of the current raw-fold obstruction: the uncast '[0,0]' entry is attached to the slot-'0' diagonal, while the backend fold still contains all seven sparse-slot summands.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:15683](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L15683).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchFullIndex_value_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchFullIndex_value_n3")
Source documentation: `The all-slot backend branch-index map embeds sparse slot 's' at full basis index '16 * s'. This is the reusable index feeder for future slot support or cancellation lemmas in the full-unitary fold; it does not prove any summand vanishes and does not assert the branch-sum theorem.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:15698](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L15698).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchFullIndex_injective_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchFullIndex_injective_n3")
Source documentation: `The seven backend sparse slots occupy distinct full-basis indices. This is a support feeder for the full-unitary fold frontier: later slot-by-slot support or cancellation lemmas can use it to rule out accidental branch-index collisions. It does not prove that any summand vanishes or that the fold equals the signal-zero unitary entry.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:15715](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L15715).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendSlotOneDaggerAfterSwap_zero_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendSlotOneDaggerAfterSwap_zero_n3")
Source documentation: `Slot-'1' clean path support mismatch for the backend diagonal branch. The backend slot maps to full index '16'; the forward sparse-access image is '112', and SWAP sends that image to '14'. The transpose-style dagger row for the original slot-'1' index has zero entry at column '14', so the clean slot-'1' path cannot close the diagonal branch through the dagger. This is a strict support feeder for a future slot-'1' vanish proof; it proves no full fold equality and promotes no semantic flag.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:15734](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L15734).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendSelectedBranchSummandFormula_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendSelectedBranchSummandFormula_n3")
Source documentation: `The selected contribution in the generic branch target is the already compiled slot-'2' seven-gate summand formula. This proves only the selected branch formula. It does not construct the all-slot backend family and does not prove that the signal-zero block entry is the seven-branch fold.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:15830](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L15830).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryBackendBranchIndexMapObstruction" (lean := "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryBackendBranchIndexMapObstruction")
Source documentation: `Narrow obstruction after adding the branch-to-full-index map. The selected branch now has a typed full-basis index and a compiled selected summand formula. The remaining backend gap is smaller: QBE still lacks the all-slot summand formula that would compute every 'branchContribution s' from the projection backend and then prove the folded sum equals 'contract.expectedTarget.blockMatrix[0,0]'.`.

Kind: structure. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:15859](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L15859).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchIndexMapObstruction_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchIndexMapObstruction_n3")
Source documentation: `Focused 'n = 3' backend branch-index map obstruction. This packet is the current smallest Lean-facing interface: the full-basis index map for the seven sparse slots is present, and slot '2' is connected to the selected summand. The all-slot summand formula and branch-sum predicate remain unavailable.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:15905](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L15905).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContribution_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContribution_n3")
Source documentation: `All-slot backend summand formula for the focused 'n = 3' boundary packet. Each sparse slot is mapped through the compiled branch-to-full-index map and then read from the focused seven-gate matrix. The two sparse-register projection amplitudes are attached uniformly. This supplies the all-slot formula requested by the projection backend, but it is not yet the theorem that the signal-zero block entry is the fold of these seven summands.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:16028](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L16028).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContribution_selected_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContribution_selected_n3")
Source documentation: `The all-slot backend summand formula selects the accepted slot-'2' contribution. This proves the selected branch clause of 'oneTermRobinGamma3BoundaryBackendBranchContributionPredicate_n3'. The branch-sum clause remains a separate projection/summation theorem.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:16044](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L16044).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContribution_slotZero_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContribution_slotZero_n3")
Source documentation: `The slot-'0' backend summand is the active '[0,0]' seven-gate diagonal multiplied by the sparse-register projection amplitude factor. This is a smaller compiled term identification for the raw uncast backend-expansion target. It does not prove that the active '[0,0]' entry is the full seven-slot fold; it shows that the fold's slot-'0' term is the active diagonal term with the projection weight attached.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:16064](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L16064).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContribution_slotZeroEval_zero_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContribution_slotZeroEval_zero_n3")
Source documentation: `The slot-'0' backend branch contribution vanishes after coefficient evaluation. This packages the active column-'0' vanish fact with the backend summand formula. It is a local support lemma for the active/prepared entry frontier; the all-slot fold and active/prepared equality remain open.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:16085](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L16085).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContribution_slotOneEval_zero_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContribution_slotOneEval_zero_n3")
Source documentation: `The slot-'1' backend branch contribution vanishes after coefficient evaluation. This is the first full slot-'1' vanish feeder: the all-slot backend summand formula maps slot '1' to the full diagonal entry '[16,16]', and the finite seven-gate matrix entry is zero for the focused backend. It does not prove the active/prepared equality, the full unitary fold, or any oracle/block flag.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:16427](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L16427).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContribution_slotThreeEval_zero_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContribution_slotThreeEval_zero_n3")
Source documentation: `The slot-'3' backend branch contribution vanishes after coefficient evaluation. This is the first full evaluated remaining-slot vanish feeder. It uses the slot-'3' full index '48', the seven-gate diagonal support at '[48,48]', and the existing backend branch summand formula. It does not prove the active/prepared equality, the full unitary fold, or any oracle/block flag.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:16757](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L16757).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContribution_slotFourEval_zero_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContribution_slotFourEval_zero_n3")
Source documentation: `The slot-'4' backend branch contribution vanishes after coefficient evaluation. This is a full evaluated remaining-slot feeder at index '64', following the same local support route as the compiled slot-'3' proof. It does not prove the active/prepared equality, the full unitary fold, or any oracle/block flag.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:17086](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L17086).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContribution_slotFiveEval_zero_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContribution_slotFiveEval_zero_n3")
Source documentation: `The slot-'5' backend branch contribution vanishes after coefficient evaluation. This is the post-slot-'4' full evaluated remaining-slot feeder at index '80'. It only advances the local finite matrix-semantics DAG for the all-slot backend fold; it does not prove the active/prepared equality, the full unitary fold, or any oracle/block flag.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:17416](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L17416).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContribution_slotSixEval_zero_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContribution_slotSixEval_zero_n3")
Source documentation: `The slot-'6' backend branch contribution vanishes after coefficient evaluation. This closes the last remaining evaluated backend-slot vanish feeder at full index '96'. It only advances the local finite matrix-semantics DAG for the all-slot backend fold; it does not prove the active/prepared equality, the full unitary fold, or any oracle/block flag.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:17746](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L17746).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchFoldEval_eq_selectedSlotContribution_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchFoldEval_eq_selectedSlotContribution_n3")
Source documentation: `After the compiled vanish feeders for slots '0', '1', '3', '4', '5', and '6', the evaluated seven-slot backend fold collapses to the selected slot-'2' contribution. This is a backend-side feeder for 'ActiveUncastToPreparedEntry'; it does not prove the active/prepared equality and promotes no theorem-facing oracle, projection, block-correctness, or final-extraction flag.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:17783](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L17783).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchFold_expandedSlotZero_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchFold_expandedSlotZero_n3")
Source documentation: `Concrete seven-summand expansion of the backend branch fold. This is the smaller compiled obstruction for the current backend-expansion target: the first summand is the active row-'0' diagonal branch, weighted by the sparse-register projection amplitude, and the remaining six summands stay as the all-slot backend contribution family. It does not prove that the active signal-zero entry equals this fold.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:17834](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L17834).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchFold_expandedAllSlots_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchFold_expandedAllSlots_n3")
Source documentation: `Concrete seven-slot expansion of the backend branch fold. This support lemma exposes every sparse-slot summand as the corresponding full-basis diagonal entry of 'oneTermRobinGamma3BoundarySevenGateMatrix_n3', weighted by the sparse-register projection amplitude. It does not prove that the active signal-zero entry equals this fold.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:17865](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L17865).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3")
Source documentation: `Backend branch-contribution target using the all-slot summand formula. Unlike 'oneTermRobinGamma3BoundaryBlockExtractionBranchContributionTarget_n3', this target no longer uses the placeholder family. The 'backendSource' and 'branchSummationCorrect' obligations remain false until the finite projection backend proves that this seven-slot family is exactly the signal-zero block expansion.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:18012](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L18012).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryBackendAllSlotSummandFormula" (lean := "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryBackendAllSlotSummandFormula")
Source documentation: `Follow-up packet after the branch-index obstruction. The all-slot summand formula is now a concrete 'Fin 7 -> Coeff' family sourced from the branch full-index map and the focused seven-gate matrix. The packet proves only the selected slot-'2' clause. The remaining theorem is still the finite projection/summation equality that identifies the signal-zero block entry with the fold of this backend family.`.

Kind: structure. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:18090](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L18090).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendAllSlotSummandFormula_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendAllSlotSummandFormula_n3")
Source documentation: `Concrete all-slot backend summand formula packet for the focused boundary branch. This supersedes the previous branch-index obstruction only for the all-slot formula itself: 'backendBranchContribution s' is now defined for every 's : Fin 7'. The full backend predicate remains unproved because its second clause is the missing signal-block branch-sum theorem.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:18136](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L18136).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryBackendBranchSumClosure" (lean := "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryBackendBranchSumClosure")
Source documentation: `Final focused obstruction for the current backend branch-sum packet. The selected sparse slot is proved and the predicate closure is conditional on one equality. The unproved equality is precisely the QBE-local projection summation statement: the signal-zero block entry must be the fold of the backend seven-slot branch family.`.

Kind: structure. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:18301](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L18301).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchSumClosure_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchSumClosure_n3")
Source documentation: `Concrete branch-sum closure target for the focused 'n = 3' boundary packet. This record is the narrow fallback for the current lower task: it does not claim the branch sum, but it proves that the selected clause is no longer a blocker and names the single remaining proposition.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:18341](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L18341).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchSumClosure_n3_transcript" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchSumClosure_n3_transcript")
Source documentation: `Transcript theorem for the backend branch-sum closure target. The theorem verifies that the new packet consumes the all-slot summand formula, proves the selected predicate clause, and keeps the actual projection summation statement and every theorem-facing semantic flag false.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:18398](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L18398).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendProjectionStatement_signalEntry_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendProjectionStatement_signalEntry_n3")
Source documentation: `The signal entry used in the Robin-local obstruction is the block entry of the generic backend branch-contribution target. This is an index/record bridge only. It does not assert that the block entry equals the folded branch contribution family.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:18476](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L18476).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryBackendProjectionStatementObstruction" (lean := "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryBackendProjectionStatementObstruction")
Source documentation: `Smallest obstruction after attempting the generic projection statement. The previous declarations provide the all-slot branch family and the selected slot theorem. This packet records the remaining missing backend theorem: 'BlockExtractionTarget' exposes the signal-zero block entry, but it does not yet expose a proof that this entry expands as the fold over the backend sparse-branch contributions.`.

Kind: structure. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:18566](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L18566).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendProjectionStatementObstruction_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendProjectionStatementObstruction_n3")
Source documentation: `Compiled obstruction for the current lower target. No theorem-facing flag is promoted. The packet only names the exact missing projection-backend field required to turn the current all-slot family into the signal-zero block-entry sum.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:18605](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L18605).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryBackendExpansionBridge" (lean := "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryBackendExpansionBridge")
Source documentation: `Proof-DAG packet for the remaining backend-expansion theorem. The packet records that the generic backend-expansion interface is now available and that it conditionally closes the focused projection statement. The actual sparse-slot fold theorem is still absent, so all theorem-facing semantic flags remain false.`.

Kind: structure. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:18785](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L18785).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendExpansionBridge_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendExpansionBridge_n3")
Source documentation: `Compiled backend-expansion bridge packet for the focused boundary branch. This is an interface refinement, not a proof of the sparse-branch expansion. It keeps the current 'oneTermRobinGamma3ProductToCoefficientObligation 3 0 0' blocked until Lean proves the backend expansion statement.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:18826](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L18826).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendExpansionBridge_n3_transcript" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendExpansionBridge_n3_transcript")
Source documentation: `Transcript theorem for the backend-expansion bridge packet. The theorem verifies that the packet uses the generic proof-DAG interface, records the Robin-local equivalence, and keeps the backend expansion and all theorem-facing semantic flags false.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:18879](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L18879).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryBackendUnitaryEntryFoldTarget" (lean := "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryBackendUnitaryEntryFoldTarget")
Source documentation: `Smallest current projection-backend target after moving from the cached block entry to the full finite product entry. The record points at the exact next theorem: the signal-zero full-unitary entry selected by 'def:block-encoding' must be expanded as the seven-slot backend fold. It keeps the backend expansion, product-to-coefficient theorem, LCU, block projection, block correctness, and final extraction flags false.`.

Kind: structure. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:19020](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L19020).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendUnitaryEntryFoldTarget_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendUnitaryEntryFoldTarget_n3")
Source documentation: `Concrete unitary-entry fold target for the focused 'n = 3' boundary branch. This is the accepted fallback when the preferred backend expansion theorem is not available: it replaces the broad block-matrix fold obligation by the full-product entry fold that a finite projection backend must provide.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:19060](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L19060).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryBackendUnitaryEntryFoldSupportTarget" (lean := "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryBackendUnitaryEntryFoldSupportTarget")
Source documentation: `Support packet for the remaining full-unitary entry fold. The packet records the finite fold domain, proves that the focused slot '2' is inside that domain, and keeps the actual theorem 'signalUnitaryEntry = blockExtractionBranchContributionSum ...' as the remaining projection-backend obligation.`.

Kind: structure. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:19190](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L19190).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendUnitaryEntryFoldSupportTarget_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendUnitaryEntryFoldSupportTarget_n3")
Source documentation: `Concrete fold-support target for the focused 'n = 3' boundary branch. This refines the obstruction from "prove a seven-slot fold" to the exact remaining backend theorem: the fold domain contains slot '2' and the slot is already identified with the accepted summand, but Lean still lacks the finite product/projection proof that the full signal-zero entry equals the complete seven-slot fold.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:19237](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L19237).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryPreparedBranchContribution_formula_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryPreparedBranchContribution_formula_n3")
Source documentation: `Every backend sparse-slot contribution is the corresponding branch-diagonal seven-gate entry, multiplied by the two sparse-register projection amplitudes. This is the all-slot formula that was implicit in 'oneTermRobinGamma3BoundaryBackendBranchContribution_n3'. It is not the full-entry fold theorem: it only identifies the summands of that fold.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:19361](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L19361).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryPreparedBranchExpansionTarget" (lean := "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryPreparedBranchExpansionTarget")
Source documentation: `Typed target for the prepared branch expansion still missing from the focused projection bridge. The current 'CircuitMatrixSemantics' exposes the raw seven-gate product entry selected by the signal-zero block convention. The branch fold, however, also uses the external sparse-register preparation/projection amplitudes. This packet proves the all-slot summand formula and records the missing backend field as a prepared-projection theorem, rather than promoting the fold itself.`.

Kind: structure. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:19383](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L19383).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryPreparedBranchExpansionTarget_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryPreparedBranchExpansionTarget_n3")
Source documentation: `Concrete prepared-branch expansion target for the focused 'n = 3' boundary branch. The packet narrows the missing interface: the summands are now proved to be the prepared branch entries, and the only absent theorem is the backend proof that the raw signal-zero entry expands through those prepared branches.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:19438](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L19438).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundarySparseCleanIndex_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundarySparseCleanIndex_n3")
Source documentation: `Clean sparse-register column index for the focused 'H_W^(kappa)' packet.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:19582](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L19582).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundarySparseSlotIndex_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundarySparseSlotIndex_n3")
Source documentation: `Embed one of the seven paper sparse slots into the eight-dimensional register.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:19586](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L19586).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3")
Source documentation: `Focused uniform-column statement for the sparse-register preparation matrix. This is the exact local shape of the Shukla--Vedula contract needed by the prepared projection bridge: each of the seven paper slots has clean-column amplitude 'sqrt_kappa_inv'.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:19596](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L19596).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryPreparedProjectionSandwichContribution_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryPreparedProjectionSandwichContribution_n3")
Source documentation: `Prepared sandwich contribution for one sparse slot. The expression is the local branch-diagonal seven-gate entry multiplied by the ket-side 'H_W^(kappa)' clean-column amplitude and the matching transpose-style bra amplitude. It is the smallest matrix object missing from the raw 'CircuitMatrixSemantics' block entry.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:19611](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L19611).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryPreparedProjectionSandwichSum_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryPreparedProjectionSandwichSum_n3")
Source documentation: `Fold the prepared sandwich contributions over the seven paper sparse slots.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:19625](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L19625).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryPreparedProjectionSandwichBackendTarget" (lean := "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryPreparedProjectionSandwichBackendTarget")
Source documentation: `Smallest prepared-projection backend field still missing from the current matrix semantics. QBE can now prove that a prepared 'H_W^(kappa)^dagger * U * H_W^(kappa)' sandwich fold specializes to the backend branch sum. What remains absent is a field or theorem connecting the raw signal-zero entry exposed by 'CircuitMatrixSemantics' to that prepared sandwich fold.`.

Kind: structure. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:19712](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L19712).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryPreparedProjectionSandwichBackendTarget_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryPreparedProjectionSandwichBackendTarget_n3")
Source documentation: `Concrete prepared-sandwich backend target for the focused 'n = 3' boundary branch. This is a strict reduction of the previous obstruction: the branch summands and their fold are now connected to an explicit 'H_W^(kappa)' clean-column matrix contract. The missing theorem is only the raw-entry-to-prepared-fold backend field.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:19753](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L19753).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField" (lean := "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField")
Source documentation: `Typed raw-entry field needed by the prepared-sandwich backend. The previous packet proved that a prepared sparse-register sandwich fold specializes to the backend branch fold under the clean-column contract. This record names the smaller remaining finite matrix field: the actual signal-zero entry exposed by 'CircuitMatrixSemantics' must equal that prepared sandwich fold. It does not assert that field.`.

Kind: structure. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:19884](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L19884).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField_n3")
Source documentation: `Concrete raw-entry prepared-sandwich field for the focused boundary packet. The matrix 'H' is the sparse-register preparation matrix named by the source contract. The record keeps the Shukla--Vedula clean-column contract separate from the QBE-local raw circuit-entry theorem.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:19918](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L19918).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryRawUnitaryEntry_contractMatrix_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryRawUnitaryEntry_contractMatrix_n3")
Source documentation: `The raw entry in the focused packet is the active seven-gate circuit product entry selected by the finite block-extraction contract. This is smaller than the prepared-sandwich theorem: it identifies the source of the raw entry without asserting that the active circuit product already contains the sparse-register preparation and its adjoint.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:20119](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L20119).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundarySparsePreparationGates_absent_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundarySparsePreparationGates_absent_n3")
Source documentation: `The active Fig. 1-term Robin gate list does not include the external 'H_W^(kappa)' sparse-register preparation block or its adjoint. The missing prepared-sandwich theorem therefore cannot be obtained by simply unfolding 'oneTermRobinGateMatrixPlaceholders'; QBE still needs either a prepared circuit semantics object or a theorem identifying the active raw entry with that prepared circuit entry.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:20135](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L20135).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryPreparedCircuitSemanticsGap" (lean := "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryPreparedCircuitSemanticsGap")
Source documentation: `Smallest prepared-circuit semantics gap after exposing the raw entry. The current raw entry is the active seven-gate 'CircuitMatrixSemantics' entry at '[0,0]'. The prepared-sandwich equality needs a circuit-matrix field for the source-preparation sandwich 'H_W^(kappa)^dagger * U * H_W^(kappa)', or an equivalent theorem relating the active raw entry to that prepared entry. This record does not add an assumption and does not promote any theorem-facing semantic flag.`.

Kind: structure. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:20154](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L20154).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryPreparedCircuitSemanticsGap_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryPreparedCircuitSemanticsGap_n3")
Source documentation: `Compiled prepared-circuit semantics gap for the focused 'n = 3' boundary packet. This is a strict refinement of the raw-entry field: Lean now knows that the raw entry is sourced from the active seven-gate contract matrix and that no 'H_W^(kappa)' preparation gate is present in that active gate list. The next field must therefore be a prepared circuit semantics matrix, not another restatement of the same raw-entry equality.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:20188](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L20188).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_n3")
Source documentation: `Compressed prepared sparse-register sandwich matrix for the focused boundary branch. Rows and columns are sparse-register indices. The clean-clean entry is the seven-slot fold for the prepared 'H_W^(kappa)^dagger * oneTermRobinGamma3BoundarySevenGateMatrix_n3 * H_W^(kappa)' sandwich. This is a local matrix-interface block; it does not assert that the active raw circuit entry equals this prepared entry.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:20287](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L20287).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryPreparedCompositeGate_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryPreparedCompositeGate_n3")
Source documentation: `Composite prepared sparse-register gate for the focused boundary packet. This is a local semantics object for the source-side prepared product 'H_W^(kappa)^dagger * U * H_W^(kappa)' on the sparse register. Its unitarity claim stays false because the cited state-preparation and diagonal-product certificates are not being proved in this lower packet.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:20369](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L20369).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryPreparedCompositeCircuit_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryPreparedCompositeCircuit_n3")
Source documentation: `Singleton circuit for the prepared sparse-register composite gate.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:20384](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L20384).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryPreparedCompositeGateMatchesCircuit_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryPreparedCompositeGateMatchesCircuit_n3")
Source documentation: `The prepared composite gate matrix matches its singleton circuit label.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:20389](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L20389).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_n3")
Source documentation: `Circuit-matrix semantics for the prepared sparse-register composite. This is not the active seven-gate Fig. 1-term Robin circuit. It is the prepared-side matrix object that the source projection step requires before one can relate the active signal-zero entry to a prepared clean entry.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:20404](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L20404).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryPreparedCircuitMatrixInterface" (lean := "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryPreparedCircuitMatrixInterface")
Source documentation: `Prepared-circuit matrix interface for the current projection backend. This packet supplies the missing prepared sparse-register matrix object and proves its clean entry is the prepared sandwich fold. It leaves the theorem connecting the active raw 'CircuitMatrixSemantics' entry to this prepared matrix entry as the exact remaining obstruction.`.

Kind: structure. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:20486](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L20486).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryPreparedCircuitMatrixInterface_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryPreparedCircuitMatrixInterface_n3")
Source documentation: `Concrete prepared-circuit matrix interface for the focused 'n = 3' boundary branch. The prepared sparse matrix is now a Lean object. The active route remains blocked only on the raw-entry theorem identifying 'signalUnitaryEntry' with that prepared matrix's clean-clean entry.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:20526](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L20526).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryActiveFullDim_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryActiveFullDim_n3")
Source documentation: `Full active matrix dimension for the focused 'n = 3' boundary packet.`.

Kind: abbrev. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:20680](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L20680).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryActiveCleanIndex_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryActiveCleanIndex_n3")
Source documentation: `Clean active full-basis index for the focused signal-zero/system-zero entry.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:20685](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L20685).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3")
Source documentation: `Typed active-entry/prepared-entry target for the focused boundary branch. The active entry is the current signal-zero entry from the seven-gate 'CircuitMatrixSemantics' product. The prepared entry is the clean-clean entry of the local sparse-register sandwich matrix. This target names the exact composition equality that is still missing; it does not prove that equality.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:20912](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L20912).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryActivePreparedCompositionFieldTarget" (lean := "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryActivePreparedCompositionFieldTarget")
Source documentation: `Smallest prepared-composition field target now missing from the matrix backend. The previous packet produced the prepared sparse-register matrix and proved its clean entry. This packet exposes the next field as a generic 'PreparedCircuitEntryTarget': relate the active seven-gate signal-zero entry to the clean entry of the prepared sandwich matrix. All theorem-facing flags stay false.`.

Kind: structure. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:21087](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L21087).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryActivePreparedCompositionFieldTarget_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryActivePreparedCompositionFieldTarget_n3")
Source documentation: `Concrete prepared-composition field target for the focused 'n = 3' boundary branch. This is the accepted fallback for the active-entry proof attempt: it is smaller than the previous interface because it uses the generic prepared-entry target and states the exact missing 'CircuitMatrixSemantics' composition field.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:21124](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L21124).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_n3")
Source documentation: `Evaluation-level active/prepared composite entry statement. The active side is the signal-zero entry selected by Definition 'def:block-encoding'. The prepared side is the clean entry of the local singleton 'CircuitMatrixSemantics' object for 'H_W^(kappa)^dagger * U_gamma3_boundary * H_W^(kappa)'. This is not asserted by the current backend; it is the exact composition field still missing.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:21540](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L21540).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3")
Source documentation: `Uncast active-entry form of the active/prepared singleton statement. This removes the signal-system block wrapper and dimension cast from the fixed active/prepared target. The remaining equality is exactly the evaluated Fig. '1 term ROBIN' active entry '[0,0]' against the prepared singleton clean entry. It does not prove that equality.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:21557](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L21557).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryActivePreparedSparseEvalStatement_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryActivePreparedSparseEvalStatement_n3")
Source documentation: `Evaluation-level active/prepared sparse-matrix entry statement. This is the same active entry compared directly with the prepared sparse matrix's clean-clean entry, bypassing the singleton 'evalGateMatrices' wrapper.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:21652](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L21652).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryUncastPreparedSandwichEvalStatement_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryUncastPreparedSandwichEvalStatement_n3")
Source documentation: `Named evaluated target for the current prepared-sandwich equality. This is the right-hand side of 'oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEval_iff_preparedSandwich_n3': the active Fig. 'fig:1 term ROBIN' uncast '[0,0]' entry must evaluate to the prepared sandwich fold. The definition names the target only; it does not assert the equality.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:21785](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L21785).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryActivePreparedCircuitLabels_distinct_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryActivePreparedCircuitLabels_distinct_n3")
Source documentation: `The active seven-gate circuit and the prepared singleton circuit have distinct gate labels. This is a structural guard for the missing composition theorem: the prepared entry cannot be obtained by unfolding the active gate list.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:21890](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L21890).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryActivePreparedCircuitFieldTarget" (lean := "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryActivePreparedCircuitFieldTarget")
Source documentation: `Circuit-semantics field target for the active/prepared clean-entry bridge. Both sides now have concrete 'CircuitMatrixSemantics' objects: the active seven-gate Fig. 'fig:1 term ROBIN' semantics and the prepared singleton semantics for 'H_W^(kappa)^dagger * U * H_W^(kappa)'. The packet records the exact entry comparison still missing and the evaluation-level bridge to the prepared sparse matrix. It does not add an assumption and leaves every theorem-facing flag false.`.

Kind: structure. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:21910](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L21910).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryActivePreparedCircuitFieldTarget_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryActivePreparedCircuitFieldTarget_n3")
Source documentation: `Concrete active/prepared circuit-semantics field target. This is the smallest current obstruction after the prepared singleton semantics packet: the prepared object is typed and its selected entry evaluates to the prepared sparse matrix, but QBE still lacks the composition theorem that identifies the active signal-zero entry with that prepared singleton entry.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:21956](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L21956).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundarySourcePreparedProjectionTarget" (lean := "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundarySourcePreparedProjectionTarget")
Source documentation: `Theorem-facing prepared projection target for the focused boundary branch. The selected entry is the clean entry of the prepared singleton semantics for 'H_W^(kappa)^dagger * U_gamma3_boundary * H_W^(kappa)'. The active signal-zero entry remains a separate missing field; this target prevents the projection backend from silently treating the raw seven-gate entry as the source-prepared entry.`.

Kind: structure. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:22207](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L22207).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3")
Source documentation: `Concrete theorem-facing prepared projection target for 'n = 3'. It selects the prepared singleton clean entry and records the conditional evaluation bridge to the backend fold under the existing all-slot 'H_W^(kappa)' clean-column contract. The active projection backend still needs a finite composition theorem before this target can close the H-free fold.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:22250](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L22250).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundarySourcePreparedProjection_to_backendFold_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundarySourcePreparedProjection_to_backendFold_n3")
Source documentation: `Named lower2 leaf from the source-prepared projection entry to the backend fold. This is only the source-prepared wrapper requested by the current projection/product packet. It consumes the explicit 'H_W^(kappa)' clean-column contract through the existing target-level bridge and does not revive the H-free active row-'0' feeder or the refuted backend-expansion parent.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:22491](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L22491).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendFold_to_slot2ProjectedProduct_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendFold_to_slot2ProjectedProduct_n3")
Source documentation: `Named lower2 bridge from the backend fold to the focused slot-'2' projected branch product. The proof composes only the compiled backend-fold collapse with the compiled selected-slot evaluator under the explicit boundary-entry convention. It does not use the rejected backend-expansion parent, the H-free evaluated fold, or the old selected-slot feeder.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:22514](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L22514).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundarySourcePreparedProjection_slot2_to_projectedBranchProduct_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundarySourcePreparedProjection_slot2_to_projectedBranchProduct_n3")
Source documentation: `Named composite lower2 leaf from the source-prepared projection entry to the focused slot-'2' projected branch product. This is only DAG wiring through the two compiled bridge leaves. The sparse preparation hypothesis enters through the source-prepared/backend-fold bridge, and the boundary-entry convention enters through the backend-fold/product bridge.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:22549](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L22549).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3")
Source documentation: `Evaluation-level backend-fold statement for the focused boundary branch. This is the H-free form of the remaining projection theorem: after interpreting symbolic 'Coeff' terms in an environment, the active signal-zero entry must equal the seven-slot backend branch fold. It is weaker than the raw 'Coeff' equality and does not assert the missing finite projection theorem.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:22956](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L22956).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundarySelectedSlotContribution_allOne_nonzero_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundarySelectedSlotContribution_allOne_nonzero_n3")
Source documentation: `Concrete obstruction witness for the retired all-environment H-free backend fold. Under an all-one environment for the selected branch symbols, the selected slot-'2' contribution evaluates to '1'. This formalizes the finite counterexample side of the current proof-DAG packet; it does not prove or use the retired row-'0' backend fold.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:23196](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L23196).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryActiveSelectedSlotIndexSplit_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryActiveSelectedSlotIndexSplit_n3")
Source documentation: `Index split for the active strict-feeder frontier. The active 'evalGateMatrices' entry in the strict feeder is the signal-zero full-basis entry '[0,0]', while the selected backend contribution is the source slot-'2' branch at full basis index '32'. This is only a compiled calibration guard: it does not prove the feeder and it leaves the required projection/path-normal-form theorem open.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:23247](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L23247).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendExpansionStatement_not_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendExpansionStatement_not_n3")
Source documentation: `No-go guard for the current backend-expansion statement. The all-one selected-branch environment makes the focused selected-slot contribution evaluate to '1', while any backend-expansion proof would force the same evaluated contribution to vanish through the evaluated backend fold.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:23637](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L23637).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendProjectionSummationStatement_not_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendProjectionSummationStatement_not_n3")
Source documentation: `No-go guard for the generic projection-summation surface. The generic 'BlockExtractionBranchContributionTarget.projectionSummationStatement' is equivalent to the backend-expansion statement for the current target. The unchanged backend-expansion route is already refuted by 'oneTermRobinGamma3BoundaryBackendExpansionStatement_not_n3', so this theorem records that the active lower target must be restated as a corrected source-backed branch statement before it can be proved.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:23681](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L23681).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget" (lean := "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget")
Source documentation: `Smallest current evaluated projection-backend target. The source-prepared target has selected the correct prepared singleton entry. This packet removes the matrix 'H' from the statement that still has to be proved: the active signal-zero entry must evaluate to the evaluated backend fold. The external clean-column contract is recorded only as the bridge needed to compare this H-free statement with the active/prepared singleton field.`.

Kind: structure. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:24126](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L24126).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget_n3")
Source documentation: `Concrete evaluated backend-fold target for 'n = 3'. No semantic flag is promoted. The packet records that the remaining local theorem is an evaluated equality between the active signal-zero entry and the backend branch fold; a raw 'Coeff' proof would be stronger but is still absent.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:24158](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L24158).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundarySourcePreparedProductProjectionObligation" (lean := "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundarySourcePreparedProductProjectionObligation")
Source documentation: `Source-prepared product/projection proof-DAG packet for the focused boundary leaf. The packet starts from the clean projection of the full prepared sandwich '(H_W^kappa)^dagger * U_gamma3_boundary * H_W^kappa', reuses the compiled prepared-backend evaluator, and records the fixed product-to-coefficient obligation. It explicitly forbids the stale backend-expansion parent and does not consume the product route or promote any downstream theorem-facing flag.`.

Kind: structure. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:24931](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L24931).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundarySourcePreparedProductProjectionObligation_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundarySourcePreparedProductProjectionObligation_n3")
Source documentation: `Concrete 'n = 3' source-prepared product/projection packet. This is bookkeeping only: the prepared clean entry evaluator is compiled, but the slot-'2' projection/product bridge and normalizer algebra are still open.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:24955](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L24955).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundarySourcePreparedNormalizedProjectionBridge" (lean := "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundarySourcePreparedNormalizedProjectionBridge")
Source documentation: `Source-prepared finite normalized-projection bridge packet for the focused boundary branch. This is route bookkeeping. It attaches the source-prepared projection packet to the finite projection/product bridge and the finite block-composition contract for 'n = 3'. It does not prove the fixed product-to-coefficient obligation or promote any LCU, normalized-block, block, or extraction flag.`.

Kind: structure. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:25219](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L25219).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundarySourcePreparedNormalizedProjectionBridge_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundarySourcePreparedNormalizedProjectionBridge_n3")
Source documentation: `Concrete 'n = 3' source-prepared finite normalized-projection packet. The packet consumes only already compiled route memory: 'oneTermRobinGamma3BoundarySourcePreparedProductProjectionObligation_n3', 'oneTermRobinGamma3BoundaryFiniteProjectionProductBridge_n3', 'oneTermRobinFiniteBlockCompositionContract 3', and the conditional normalizer bridge by name. The root obligation remains false.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:25269](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L25269).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryTheoremFacingFiniteBlockContractAudit" (lean := "QuantumBlockEncoding.Examples.RobinHeat.OneTermRobinGamma3BoundaryTheoremFacingFiniteBlockContractAudit")
Source documentation: `Theorem-facing finite block-contract audit for the focused boundary branch. This packet records that the finite block-composition contract is still wired to the active seven-gate backend while the source-facing Fig. 4 transcript is a larger circuit. It is an audit object only: no normalized-block equality, LCU claim, block projection, final extraction, oracle correctness, unitarity, resource claim, or product-to-coefficient flag is promoted.`.

Kind: structure. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:25426](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L25426).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockContractAudit_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockContractAudit_n3")
Source documentation: `Concrete 'n = 3' theorem-facing finite block-contract audit packet. The packet consumes only existing transcript guards and compiled route memory. It records the source-translation gap between the theorem-facing Fig. 4 circuit and the active backend currently used by 'oneTermRobinFiniteBlockCompositionContract 3'.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:25484](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L25484).
:::

:::definition "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryTheoremFacingFiniteBlockProjectionInterface_n3")
Source documentation: `Concrete 'n = 3' theorem-facing finite block/projection interface packet. The packet records that the source-prepared projection target is the clean prepared entry, while the finite block-composition contract still consumes 'oneTermRobinCircuitSemantics 3'. It does not substitute the Fig. 4 circuit for the active backend and does not prove the root product-to-coefficient obligation.`.

Kind: def. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:25726](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L25726).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_diagnostic_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_diagnostic_n3")
Source documentation: `Diagnostic/H-free route: the evaluated backend fold follows from the raw Coeff equality 'signalUnitaryEntry = blockExtractionBranchContributionSum' via the bridge theorem. This is not the source-correct route; the source-correct route goes through 'oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_of_activePreparedEval_n3'.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:26934](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L26934).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3")
Source documentation: `QBE-AUTO-002: sorry-guarded obstruction record for the H-free raw Coeff fold (n=3). This is the DIAGNOSTIC H-free route, not the source-correct prepared projection route. The source-correct route is 'oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_of_activePreparedEval_n3', which routes through the prepared singleton clean entry under the 'H_W^(kappa)' clean-column contract. The raw Coeff equality 'signalUnitaryEntry = blockExtractionBranchContributionSum' is the missing finite projection theorem. Approaches tried: - 'rfl': hits maxRecDepth (even at 4096) - 'native_decide': OOM/timeout (19GB RSS, killed after 780s) - Both sides unfold to deeply nested Coeff expressions involving 7 gate matrices. After rewriting via 'oneTermRobinGamma3BoundarySignalUnitaryEntry_evalGateMatrices_n3', the LHS reduces to '(evalGateMatrices gates) [0,0]'. The RHS is the seven-slot backend fold 'Sum_{s:Fin 7} sevenGateMatrix[idx(s),idx(s)] * projFactor'. These are structurally different Coeff expressions whose equality encodes the finite projection/summation theorem for the 1-term Robin boundary branch.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:26964](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L26964).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3_proof_diagnostic" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3_proof_diagnostic")
Source documentation: `QBE-AUTO-002: sorry-dependent diagnostic proof of the evaluated backend fold. This uses the H-free raw Coeff fold and is diagnostic/recovery only. The source-correct route is 'oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_of_activePreparedEval_n3'.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:26977](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L26977).
:::

:::theorem "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3")
Source documentation: `QBE-AUTO-002: matrix equality between 'evalGateMatrices' over the 7 gate placeholders and the seven-gate boundary matrix for the focused 'n = 3' gamma3 packet. Both sides represent the same 7-gate product by matrix associativity: - 'evalGateMatrices [G1,...,G7]' folds to 'G7 * G6 * ... * G1' (left-nested 'Matrix.mul') - 'oneTermRobinGamma3BoundarySevenGateMatrix_n3 = suffixMatrix * prefixMatrix' where suffix = '(O_D^BS)^dagger * (SWAP * O_f)' and prefix = 'O_D^BS * (Ry * (O_DT^S * U_indic))' The equality holds by 'Matrix.mul_assoc'. This theorem is a diagnostic bridge connecting the circuit-semantics fold to the explicit boundary product.`.

Kind: theorem. This declaration belongs to the experimental Robin-matrix development; the chapter header records its proof status.

Source: [QuantumBlockEncoding/RobinMatrix.lean:26995](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/QuantumBlockEncoding/RobinMatrix.lean#L26995).
:::

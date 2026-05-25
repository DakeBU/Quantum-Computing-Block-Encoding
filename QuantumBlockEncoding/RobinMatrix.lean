import QuantumBlockEncoding.Core
import QuantumBlockEncoding.CircuitSemantics
import QuantumBlockEncoding.Examples.RobinHeat

/-!
# Robin derivative matrix construction

Lifts stencil entry lists (bulk + boundary) into a concrete `Matrix N N Coeff`.
-/

namespace QuantumBlockEncoding

open Coeff

/--
Coefficient at column `colIdx` when the stencil `entries` is applied at row
`rowIdx`.  Only entries whose offset lands on `colIdx` contribute; the result
is the sum of all matching coefficients.  Returns bare `Coeff` (no zero-wrapping)
when exactly one entry matches.
-/
def stencilRowCoeff (rowIdx colIdx : Nat) (entries : List StencilEntry) : Coeff :=
  match entries.filterMap (fun e =>
    if (rowIdx : Int) + e.offset = (colIdx : Int) then some e.coeff else none) with
  | [] => Coeff.rat 0
  | [c] => c
  | c :: cs => cs.foldl (fun acc b => acc + b) c

/--
Select the stencil entry list for row `i`:
- rows `i < w.lower` use left boundary rows,
- rows `i > w.upper` use right boundary rows,
- all others use the bulk stencil.

Falls back to the empty list if a boundary row is missing from the supplied
data, so the definition is total and does not need index proofs.
-/
def robinRowEntries (bulkEntries : List StencilEntry)
    (leftRows rightRows : List (List StencilEntry))
    (w : BulkWindow)
    (i : Nat) :
    List StencilEntry :=
  if _h : i < w.lower then
    if hi : i < leftRows.length then leftRows.get ⟨i, hi⟩ else []
  else if _h2 : i > w.upper then
    let idx := i - w.upper - 1
    if hi : idx < rightRows.length then rightRows.get ⟨idx, hi⟩ else []
  else
    bulkEntries

/--
Build the full Robin derivative matrix of size `gridSize n × gridSize n`.

The boundary rows come from `leftRows` and `rightRows`; the interior uses
`bulkEntries`.  The `BulkWindow w` records where the interior starts and ends.
-/
def buildRobinMatrix (n : Nat)
    (bulkEntries : List StencilEntry)
    (leftRows rightRows : List (List StencilEntry))
    (w : BulkWindow) :
    Matrix (gridSize n) (gridSize n) Coeff :=
  fun row col =>
    stencilRowCoeff row.val col.val
      (robinRowEntries bulkEntries leftRows rightRows w row.val)

namespace Examples.RobinHeat

/-- The concrete Robin derivative matrix for the fourth-order central second-derivative stencil. -/
def robinDerivativeMatrix (n : Nat) : Matrix (gridSize n) (gridSize n) Coeff :=
  buildRobinMatrix n centralBulkEntries
    [leftBoundaryRow0, leftBoundaryRow1]
    [rightBoundaryRowNm2, rightBoundaryRowNm1]
    (robinWindow n)

/--
The one-term Robin theorem target $A_k$.

Theorem `1 term robin` block-encodes the row-scaled operator
`A_k ~ f(x) d^m/dx^m`; Eq. `ROBIN clarified` carries entries
`f(x_i) D_{ij}` in the `gamma3` branch.
-/
def oneTermRobinAkMatrix (n : Nat) : Matrix (gridSize n) (gridSize n) Coeff :=
  fun i j => Coeff.mul (GHL2025.robinFunctionValue n i.val) (robinDerivativeMatrix n i j)

@[simp] theorem oneTermRobinAkMatrix_apply
    (n : Nat) (i j : Fin (gridSize n)) :
    oneTermRobinAkMatrix n i j =
      Coeff.mul (GHL2025.robinFunctionValue n i.val)
        (robinDerivativeMatrix n i j) := rfl

end Examples.RobinHeat

/--
Absolute-row-sum for row `i` of a `Coeff`-valued matrix, given a symbol
environment `env`.  This is the building block for the induced 1-norm.
-/
def matrixRowAbsSum {rows cols : Nat} (mat : Matrix rows cols Coeff)
    (env : String → Rat) (i : Fin rows) : Rat :=
  (List.finRange cols).foldl (fun acc j =>
    let v := Coeff.evalWith env (mat i j)
    acc + if v < 0 then -v else v) 0

/--
Induced matrix 1-norm: the maximum absolute row sum.  Uses `evalWith env`
to convert symbolic `Coeff` entries to concrete `Rat` values.
-/
def matrixOneNorm {rows cols : Nat} (mat : Matrix rows cols Coeff)
    (env : String → Rat) : Rat :=
  (List.finRange rows).foldl (fun acc i =>
    max acc (matrixRowAbsSum mat env i)) 0

namespace Examples.RobinHeat

/--
Numeric 1-norm of the Robin derivative matrix under a symbol environment.
Returns the maximum absolute row sum as a concrete `Rat`.
-/
def robinDerivativeNorm (n : Nat) (env : String → Rat) : Rat :=
  matrixOneNorm (robinDerivativeMatrix n) env

/--
Numeric normalizer α = N_D · N_f · κ for the one-term Robin construction.
`nD` is the derivative-stencil normalization (1-norm of the Robin derivative matrix),
`nF` is the function-oracle normalization, and `k` is the Robin-condition bound.
-/
def oneTermRobinNumericNormalizer (nD nF : Rat) (k : Nat) : Rat :=
  nD * nF * k

/--
Proposition: the numeric normalizer α is at least the induced 1-norm of the
Robin derivative matrix, i.e. α ≥ ∥D_Robin∥₁.
Stated via a `Decidable` check so `native_decide` can close concrete instances.
-/
def robinNormalizerBound (n : Nat) (env : String → Rat) (nF : Rat) (k : Nat) : Bool :=
  oneTermRobinNumericNormalizer (robinDerivativeNorm n env) nF k ≥
    robinDerivativeNorm n env

/-- Connecting the numeric normalizer to the symbolic GHL2025 normalizer via a
concrete environment mapping the three symbols to their numeric values. -/
theorem oneTermRobinNumericNormalizer_eq_eval (nD nF : Rat) (k : Nat) :
    oneTermRobinNumericNormalizer nD nF k =
      Coeff.evalWith
        (fun s => if s = "N_D" then nD else if s = "N_f" then nF else (k : Rat))
        GHL2025.oneTermRobinNormalizer := by
  simp [oneTermRobinNumericNormalizer, GHL2025.oneTermRobinNormalizer_eval]

/-- Concrete BlockEncodingSpec wiring the Robin derivative matrix into the
one-term Robin block encoding framework. Uses the fourth-order central stencil
with Robin boundary corrections. -/
def robinBlockEncodingSpec (n : Nat) : BlockEncodingSpec Coeff (gridSize n) (gridSize n) where
  matrix := robinDerivativeMatrix n
  normalizer := GHL2025.oneTermRobinNormalizer
  error := Coeff.rat 0
  layout := GHL2025.oneTermRobinLayout (oneTermParameters n)
  circuit := GHL2025.oneTermRobinCircuit
  resource := GHL2025.oneTermRobinResource (oneTermParameters n)

/-- The spec's resource pureAncilla matches 2n. -/
theorem robinBlockEncodingSpec_pureAncilla (n : Nat) :
    (robinBlockEncodingSpec n).resource.pureAncilla = 2 * n := rfl

/-- Concrete derivative oracle resource for the fourth-order Robin stencil.
Uses half-bandwidth l = leftRadius = 2. -/
def robinDerivativeOracleResource (n : Nat) : Resource :=
  GHL2025.derivativeOracleResource n fourthOrderSecondDerivative

/-- The Robin derivative oracle resource equals bandedSparseAccessResource n 2. -/
@[simp] theorem robinDerivativeOracleResource_eq (n : Nat) :
    robinDerivativeOracleResource n = bandedSparseAccessResource n 2 := rfl

/-- The Robin derivative oracle uses n - 1 pure ancillas (from Lemma 1). -/
@[simp] theorem robinDerivativeOracleResource_pureAncilla (n : Nat) :
    (robinDerivativeOracleResource n).pureAncilla = n - 1 := rfl

/-! ## Cycle 4: Named proof-obligation Props and oracle composition -/

/-- PO-6: Block-extraction equation for the Robin derivative block encoding.
Records the structural preconditions that are checkable now (normalizer bound,
ancilla count, zero error) and reserves the full equation
  ⟨0^a| ⊗ I) U (|0^a⟩ ⊗ I) = A / α
as an abstract component pending unitary semantics. -/
def robinBlockEncodingPredicate (n : Nat) : Prop :=
  robinNormalizerBound n (fun _ => 0) 1 (oneTermParameters n).kappa = true ∧
  (robinBlockEncodingSpec n).resource.pureAncilla = 2 * n ∧
  (robinBlockEncodingSpec n).error = Coeff.rat 0

/-- PO-7: Resource bound holds for the Robin block encoding.
Concrete decidable check: pureAncilla = 2n and gate count ≤ paper's formula. -/
def robinResourceBoundHolds (n : Nat) : Prop :=
  (robinBlockEncodingSpec n).resource.pureAncilla = 2 * n ∧
  (robinBlockEncodingSpec n).resource.gates ≤
    (oneTermParameters n).polynomialDegreeCost * n * clog2 n + (oneTermParameters n).kappa * n

/-- PO-9: The concrete resource is consistent with the symbolic expression.
Checks the decidable part: pureAncilla = 2n. -/
def oneTermRobinResourceConsistent (p : GHL2025.OneTermRobinParameters) : Prop :=
  (GHL2025.oneTermRobinResource p).pureAncilla = 2 * p.n

/-- Bundle of oracle contracts and LCU composition obligation for the one-term Robin
construction. Contains:
- derivative oracle O_D (sparse-access for the banded stencil matrix),
- function oracle O_f (amplitude oracle for the coefficient function),
- LCU composition Prop (PO-15: linear combination of unitaries correctness),
- matrix coherence (the oracle's matrix equals the Robin derivative matrix). -/
structure RobinOracleComposition (n : Nat) where
  derivativeOracle : GHL2025.DerivativeOracleContract n
  functionOracle : GHL2025.FunctionOracleContract n
  /-- Obligation: LCU composition of oracle calls yields the correct linear combination.
  figure:1_term_ROBIN, main.tex:1131-1136 --/
  lcuCorrect : GHL2025.ObligationRecord
  matrixCoherence : derivativeOracle.matrix = robinDerivativeMatrix n

/-- PO-13/14/15: Concrete oracle composition for the Robin derivative block encoding.
Instantiates the derivative oracle with the fourth-order stencil, the function oracle
with one piece, and records the LCU composition Prop as an abstract claim. -/
def robinOracleComposition (n : Nat) : RobinOracleComposition n where
  derivativeOracle := {
    stencil := fourthOrderSecondDerivative
    bandwidth := 5
    matrix := robinDerivativeMatrix n
    sparseCorrect := ⟨"O_D^BS for fourth-order Robin stencil", "main.tex:784-801", false⟩
    bandwidth_eq := rfl
  }
  functionOracle := {
    functionPieces := 1
    normalizerBound := Coeff.symbol "N_f"
    amplitudeCorrect := ⟨"O_f for single-piece function", "main.tex:870-910", false⟩
  }
  lcuCorrect := ⟨"LCU composition for one-term Robin", "main.tex:1131-1136", false⟩
  matrixCoherence := rfl

@[simp] theorem robinOracleComposition_bandwidth (n : Nat) :
    (robinOracleComposition n).derivativeOracle.bandwidth = 5 := rfl

@[simp] theorem robinOracleComposition_functionPieces (n : Nat) :
    (robinOracleComposition n).functionOracle.functionPieces = 1 := rfl

@[simp] theorem robinOracleComposition_matrix (n : Nat) :
    (robinOracleComposition n).derivativeOracle.matrix = robinDerivativeMatrix n := rfl

/-- Default proof-obligation bundle for the one-term Robin construction.
All obligations are unproved. main.tex:1131-1136 --/
def robinProofObligations : GHL2025.RobinProofObligations := {}

/-! ## Circuit matrix semantics bridge --/

/--
CircuitMatrixSemantics for the one-term Robin circuit using honest gate matrices.
The full-space matrix is the product of the 7 honest gate matrices computed by
`evalGateMatrices`. Unproved gate claims remain in their own
`SemanticObligation` records.
figure:1_term_ROBIN --/
def oneTermRobinCircuitSemantics (n : Nat) :
    CircuitMatrixSemantics Coeff
      (GHL2025.oneTermRobinTotalQubits (oneTermParameters n)) where
  circuit := GHL2025.oneTermRobinCircuit
  gateMatrices := GHL2025.oneTermRobinGateMatrixPlaceholders (oneTermParameters n)
  gateListMatches := GHL2025.oneTermRobinPlaceholdersMatch (oneTermParameters n)
  matrix := evalGateMatrices (GHL2025.oneTermRobinGateMatrixPlaceholders (oneTermParameters n))
  matrix_eq_eval := by intro _ _; rfl

/--
Dimension compatibility for the one-term Robin circuit:
the full Hilbert-space dimension factors as signal dimension times system
dimension.  This is the reusable arithmetic bridge from qubit counts to the
block-projection matrix shape.
figure:1_term_ROBIN, main.tex:1098-1109 --/
private theorem effectiveSignal_add_n_eq_total (n : Nat) :
    GHL2025.effectiveRobinSignalQubits (oneTermParameters n) + n =
      GHL2025.oneTermRobinTotalQubits (oneTermParameters n) := by
  simp [GHL2025.effectiveRobinSignalQubits, GHL2025.oneTermRobinTotalQubits,
    GHL2025.defaultRobinRegisterPartition, GHL2025.RobinRegisterPartition.totalQubits,
    oneTermParameters, clog2_gridSize]
  omega

theorem oneTermRobinCircuitDimCompat (n : Nat) :
    qubitDim (GHL2025.oneTermRobinTotalQubits (oneTermParameters n)) =
      qubitDim (GHL2025.effectiveRobinSignalQubits (oneTermParameters n)) *
        gridSize n := by
  have h := effectiveSignal_add_n_eq_total n
  simp only [qubitDim, gridSize]
  rw [← h, Nat.pow_add]

/--
Block-extraction target for the one-term Robin block encoding.
States that the `(0, 0)` block of the circuit matrix should equal
`A_k / (N_D * N_f * kappa)`.

The `unitaryMatrix` and `blockMatrix` are derived from the real circuit
matrix product computed by `evalGateMatrices` over all 7 honest gate matrices.
Block correctness remains unproved.

The `signalDim` is `qubitDim effectiveRobinSignalQubits` where
`effectiveRobinSignalQubits` counts all non-system qubits.
`systemDim` is `gridSize n`.
figure:1_term_ROBIN, main.tex:1131-1136 --/
def oneTermRobinBlockExtractionTarget (n : Nat) :
    BlockExtractionTarget Coeff (gridSize n) (gridSize n)
      (qubitDim (GHL2025.effectiveRobinSignalQubits (oneTermParameters n))) :=
  (oneTermRobinCircuitSemantics n).blockExtractionTarget
    (gridSize n)
    (qubitDim (GHL2025.effectiveRobinSignalQubits (oneTermParameters n)))
    (oneTermRobinCircuitDimCompat n)
    (oneTermRobinAkMatrix n)
    GHL2025.oneTermRobinNormalizer
    ⟨0, by
      show (0 : Nat) < qubitDim (GHL2025.effectiveRobinSignalQubits (oneTermParameters n))
      simp only [qubitDim, gridSize]
      have : ∀ k : Nat, (0 : Nat) < 2 ^ k := by
        intro k; induction k with
        | zero => decide
        | succ k _ => simp [Nat.pow_succ]; omega
      exact this _⟩

/--
Circuit block encoding claim for the one-term Robin construction.
Connects the circuit matrix semantics to the block extraction target
and records the dimension compatibility as a parameter.

The caller must supply `hDim` proving that the total circuit Hilbert space
decomposes as signalDim × systemDim.  For concrete `n` (e.g. n = 3) this
is provable by `native_decide`.
figure:1_term_ROBIN, main.tex:1131-1136 --/
def oneTermRobinCircuitBlockClaim (n : Nat)
    (hDim : qubitDim (GHL2025.oneTermRobinTotalQubits (oneTermParameters n)) =
      qubitDim (GHL2025.effectiveRobinSignalQubits (oneTermParameters n)) *
        gridSize n) :
    CircuitBlockEncodingClaim Coeff
      (GHL2025.oneTermRobinTotalQubits (oneTermParameters n))
      (gridSize n)
      (qubitDim (GHL2025.effectiveRobinSignalQubits (oneTermParameters n))) where
  semantics := oneTermRobinCircuitSemantics n
  target := oneTermRobinBlockExtractionTarget n
  dimCompat := hDim
  blockCorrect := {
    description := "one-term Robin: block extraction = A_k / (N_D * N_f * kappa)"
    source := "main.tex:1131-1136, Theorem:1 term robin"
    proved := false
  }

/--
Default one-term Robin circuit block claim using the reusable dimension
compatibility theorem.  The block-correctness obligation remains unproved.
-/
def defaultOneTermRobinCircuitBlockClaim (n : Nat) :
    CircuitBlockEncodingClaim Coeff
      (GHL2025.oneTermRobinTotalQubits (oneTermParameters n))
      (gridSize n)
      (qubitDim (GHL2025.effectiveRobinSignalQubits (oneTermParameters n))) :=
  oneTermRobinCircuitBlockClaim n (oneTermRobinCircuitDimCompat n)

/--
Contract-only finite-dimensional LCU/block-composition dependency for the
one-term Robin theorem.

This records the exact circuit claim, target matrix, normalizer, and open
matrix obligations that a future finite-dimensional composition theorem must
close.  It does not promote the current LCU, projection, or extraction flags.
-/
def oneTermRobinFiniteBlockCompositionContract (n : Nat) :
    FiniteBlockCompositionContract Coeff
      (GHL2025.oneTermRobinTotalQubits (oneTermParameters n))
      (gridSize n)
      (qubitDim (GHL2025.effectiveRobinSignalQubits (oneTermParameters n))) where
  sourceAnchor :=
    "QBE finite-dimensional LCU/block-composition contract for GHL2025 Theorem one-term block-encoding"
  lcuSourceAnchor :=
    "LCU.StandardBlockEncoding; Childs-Wiebe 2012, arXiv:1202.5822; QBE cited-results row"
  theoremAnchor :=
    "Guseynov-Huang-Liu 2025, Theorem one-term block-encoding and Fig. 1-term Robin, arXiv:2506.20478"
  claim := defaultOneTermRobinCircuitBlockClaim n
  expectedTarget := oneTermRobinBlockExtractionTarget n
  targetMatrix := oneTermRobinAkMatrix n
  normalizer := GHL2025.oneTermRobinNormalizer
  claimTargetMatches := rfl
  targetMatrixMatches := rfl
  targetNormalizerMatches := rfl
  circuitUnitary := {
    description := "all seven full-space gate matrices compose to a unitary circuit matrix"
    source := "GHL2025 Theorem one-term block-encoding and Fig. 1-term Robin; QBE finite LCU contract"
    proved := false
  }
  lcuComposition := {
    description := "finite-dimensional LCU/block-composition yields the normalized Robin target block"
    source := "LCU.StandardBlockEncoding cited-results row and GHL2025 Theorem one-term block-encoding"
    proved := false
  }
  blockProjection := {
    description := "signal-zero projection extracts the theorem block from the composed circuit matrix"
    source := "GHL2025 Eq. ROBIN clarified and Fig. 1-term Robin"
    proved := false
  }
  normalizedBlockEquality := {
    description := "projected block equals oneTermRobinAkMatrix n divided by N_D*N_f*kappa"
    source := "GHL2025 Theorem one-term block-encoding"
    proved := false
  }
  finalExtraction := {
    description := "CircuitBlockEncodingClaim closes the final one-term Robin theorem"
    source := "GHL2025 Theorem one-term block-encoding"
    proved := false
  }

/-- The finite block-composition contract is wired to the concrete target. -/
theorem oneTermRobinFiniteBlockCompositionContract_transcript
    (n : Nat) :
    let contract := oneTermRobinFiniteBlockCompositionContract n
    contract.sourceAnchor =
        "QBE finite-dimensional LCU/block-composition contract for GHL2025 Theorem one-term block-encoding" ∧
      contract.lcuSourceAnchor =
        "LCU.StandardBlockEncoding; Childs-Wiebe 2012, arXiv:1202.5822; QBE cited-results row" ∧
      contract.theoremAnchor =
        "Guseynov-Huang-Liu 2025, Theorem one-term block-encoding and Fig. 1-term Robin, arXiv:2506.20478" ∧
      contract.claim = defaultOneTermRobinCircuitBlockClaim n ∧
      contract.expectedTarget = oneTermRobinBlockExtractionTarget n ∧
      contract.claim.target = contract.expectedTarget ∧
      contract.expectedTarget.targetMatrix = contract.targetMatrix ∧
      contract.expectedTarget.normalizer = contract.normalizer ∧
      contract.targetMatrix = oneTermRobinAkMatrix n ∧
      contract.normalizer = GHL2025.oneTermRobinNormalizer ∧
      contract.circuitUnitary.proved = false ∧
      contract.lcuComposition.proved = false ∧
      contract.blockProjection.proved = false ∧
      contract.normalizedBlockEquality.proved = false ∧
      contract.finalExtraction.proved = false := by
  exact ⟨rfl, rfl, rfl, rfl, rfl,
    (oneTermRobinFiniteBlockCompositionContract n).claimTargetMatches,
    (oneTermRobinFiniteBlockCompositionContract n).targetMatrixMatches,
    (oneTermRobinFiniteBlockCompositionContract n).targetNormalizerMatches,
    rfl, rfl, rfl, rfl, rfl, rfl, rfl⟩

/--
Contract-only interface for the exact finite composition theorem still needed
to close the GHL2025 one-term Robin block encoding.

This names the missing theorem-facing step without asserting it: the seven-gate
matrix product, projected in the Definition `def:block-encoding` signal-zero
convention, must realize the Eq. `ROBIN clarified` target block
`oneTermRobinAkMatrix n / (N_D N_f kappa)`.  The proof flag stays false until
that exact finite-dimensional theorem is build-tested.
-/
def oneTermRobinFiniteCompositionExactTheoremObligation
    (_n : Nat) : SemanticObligation where
  description :=
    "exact finite theorem: the signal-zero block of the Fig. 1-term Robin gate product equals oneTermRobinAkMatrix n normalized by N_D*N_f*kappa"
  source :=
    "GHL2025 Theorem one-term block-encoding, Eq. ROBIN clarified, Fig. 1-term ROBIN, Definition def:block-encoding; cited-results row LCU.StandardBlockEncoding"
  proved := false

theorem oneTermRobinFiniteCompositionExactTheoremObligation_transcript
    (n : Nat) :
    (oneTermRobinFiniteCompositionExactTheoremObligation n).source =
        "GHL2025 Theorem one-term block-encoding, Eq. ROBIN clarified, Fig. 1-term ROBIN, Definition def:block-encoding; cited-results row LCU.StandardBlockEncoding" ∧
      (oneTermRobinFiniteCompositionExactTheoremObligation n).proved =
        false := by
  exact ⟨rfl, rfl⟩

/-! ## Theorem-level proof route contract -/

/--
Phase 1 proof-route contract for the GHL2025 one-term Robin theorem.

This record ties the theorem tuple, circuit-matrix semantics, block-projection
target, active oracle contracts, and source-route blockers into one Lean
object.  It is a transcript and obligation map, not a proof that the block
encoding is correct.
-/
structure OneTermRobinBlockEncodingProofRoute (n : Nat) where
  sourceAnchor : String
  parameters : GHL2025.OneTermRobinParameters
  theoremData : GHL2025.OneTermRobinTheoremData
  circuitSemantics :
    CircuitMatrixSemantics Coeff
      (GHL2025.oneTermRobinTotalQubits (oneTermParameters n))
  blockClaim :
    CircuitBlockEncodingClaim Coeff
      (GHL2025.oneTermRobinTotalQubits (oneTermParameters n))
      (gridSize n)
      (qubitDim (GHL2025.effectiveRobinSignalQubits (oneTermParameters n)))
  oracleComposition : RobinOracleComposition n
  sparseAccessContract : GHL2025.BandedSparseAccessPaperContract
  cleanupScopeDecision : GHL2025.BandedSparseAccessCleanupScopeDecision
  functionOracleSource : GHL2025.FunctionOracleExternalAmplitudeSourceContract
  parameters_eq : parameters = oneTermParameters n
  theoremNormalizerMatchesTarget :
    theoremData.alpha = blockClaim.target.normalizer
  targetMatrixMatchesSpec : blockClaim.target.targetMatrix = oneTermRobinAkMatrix n
  signalIndexZero : blockClaim.target.signalIndex.val = 0
  circuitWired : circuitSemantics.circuit = GHL2025.oneTermRobinCircuit
  claimUsesSemantics : blockClaim.semantics = circuitSemantics
  claimUsesTarget : blockClaim.target = oneTermRobinBlockExtractionTarget n
  blockProjectionOpen : blockClaim.target.blockProjection.proved = false
  blockCorrectOpen : blockClaim.target.blockCorrect.proved = false
  theoremBlockExtractionOpen :
    theoremData.obligations.blockExtraction.proved = false
  theoremCircuitUnitaryOpen : theoremData.obligations.circuitUnitary.proved = false
  sparseAccessForwardOpen : sparseAccessContract.forwardCorrect.proved = false
  sparseAccessCleanupOpen : sparseAccessContract.daggerCleanup.proved = false
  sparseAccessUnitaryOpen : sparseAccessContract.unitaryExtension.proved = false
  cleanupScopeActive :
    cleanupScopeDecision.selectedScope =
      GHL2025.BandedSparseAccessCleanupScope.activeGlobalSource
  cleanupScopePredicate :
    cleanupScopeDecision.selectedPredicate =
      "bandedSparseAccessPaperGlobalSlotSource"
  cleanupScopeEvidence :
    cleanupScopeDecision.selectedEvidence =
      "bandedSparseAccessGlobalSlotInverseOnRangeContract_restrictedDaggerColumnIndicator"
  cleanupScopeFullCleanDomainOpen :
    cleanupScopeDecision.fullCleanDomainSelected = false
  cleanupScopeFullSpaceOpen : cleanupScopeDecision.fullSpaceSelected = false
  cleanupScopeNoSemanticPromotion :
    cleanupScopeDecision.semanticCleanupPromotionAllowed = false
  cleanupScopePaperCleanupOpen :
    cleanupScopeDecision.paperContractCleanup.proved = false
  cleanupScopeFullCleanDomainCleanupOpen :
    cleanupScopeDecision.fullCleanDomainCleanup.proved = false
  cleanupScopeFullSpaceUnitaryOpen :
    cleanupScopeDecision.fullSpaceUnitaryExtension.proved = false
  functionOracleExternalOpen : functionOracleSource.closesFunctionOracleContract = false
  functionOracleOpen :
    oracleComposition.functionOracle.amplitudeCorrect.proved = false
  lcuOpen : oracleComposition.lcuCorrect.proved = false

/--
Default theorem-level proof route for the one-term Robin block encoding.

All unproved semantic obligations are deliberately kept false.  The route uses
the active seven-gate circuit product, the global-slot `O_D^BS` cleanup-scope
decision, and the external-source transcript for `O_f`.
-/
def oneTermRobinBlockEncodingProofRoute
    (n : Nat) : OneTermRobinBlockEncodingProofRoute n where
  sourceAnchor :=
    "Guseynov-Huang-Liu 2025, Theorem one-term block-encoding, Fig. 1-term Robin, arXiv:2506.20478"
  parameters := oneTermParameters n
  theoremData := GHL2025.defaultOneTermRobinTheoremData (oneTermParameters n)
  circuitSemantics := oneTermRobinCircuitSemantics n
  blockClaim := defaultOneTermRobinCircuitBlockClaim n
  oracleComposition := robinOracleComposition n
  sparseAccessContract :=
    GHL2025.defaultBandedSparseAccessPaperContract (oneTermParameters n)
  cleanupScopeDecision :=
    GHL2025.bandedSparseAccessCleanupScopeDecision (oneTermParameters n)
  functionOracleSource := GHL2025.functionOracleExternalAmplitudeSourceContract
  parameters_eq := rfl
  theoremNormalizerMatchesTarget := rfl
  targetMatrixMatchesSpec := rfl
  signalIndexZero := rfl
  circuitWired := rfl
  claimUsesSemantics := rfl
  claimUsesTarget := rfl
  blockProjectionOpen := rfl
  blockCorrectOpen := rfl
  theoremBlockExtractionOpen := rfl
  theoremCircuitUnitaryOpen := rfl
  sparseAccessForwardOpen := rfl
  sparseAccessCleanupOpen := rfl
  sparseAccessUnitaryOpen := rfl
  cleanupScopeActive := rfl
  cleanupScopePredicate := rfl
  cleanupScopeEvidence := rfl
  cleanupScopeFullCleanDomainOpen := rfl
  cleanupScopeFullSpaceOpen := rfl
  cleanupScopeNoSemanticPromotion := rfl
  cleanupScopePaperCleanupOpen := rfl
  cleanupScopeFullCleanDomainCleanupOpen := rfl
  cleanupScopeFullSpaceUnitaryOpen := rfl
  functionOracleExternalOpen := rfl
  functionOracleOpen := rfl
  lcuOpen := rfl

/-- The proof-route contract links the theorem normalizer to the block target. -/
theorem oneTermRobinBlockEncodingProofRoute_normalizer
    (n : Nat) :
    (oneTermRobinBlockEncodingProofRoute n).theoremData.alpha =
      (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.normalizer :=
  (oneTermRobinBlockEncodingProofRoute n).theoremNormalizerMatchesTarget

/--
The theorem-level route pins the block target used for the one-term theorem.

This is only a structural guard: it records the signal-index-zero convention,
the Robin target matrix, and the shared circuit semantics object.  It does not
prove the extracted block equation.
-/
theorem oneTermRobinBlockEncodingProofRoute_blockTarget
    (n : Nat) :
    (oneTermRobinBlockEncodingProofRoute n).blockClaim.target =
        oneTermRobinBlockExtractionTarget n ∧
      (oneTermRobinBlockEncodingProofRoute n).blockClaim.semantics =
        (oneTermRobinBlockEncodingProofRoute n).circuitSemantics ∧
      (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.targetMatrix =
        oneTermRobinAkMatrix n ∧
      (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.signalIndex.val =
        0 :=
  ⟨(oneTermRobinBlockEncodingProofRoute n).claimUsesTarget,
    (oneTermRobinBlockEncodingProofRoute n).claimUsesSemantics,
    (oneTermRobinBlockEncodingProofRoute n).targetMatrixMatchesSpec,
    (oneTermRobinBlockEncodingProofRoute n).signalIndexZero⟩

/--
The theorem-level route uses the same block-projection target, normalizer, and
open flags as the concrete circuit matrix target.

This is a route guard for the final block-extraction statement.  It records
the cast circuit product, the signal-index-zero projection API, the Robin
target matrix, and the normalizer `N_D * N_f * kappa`, while keeping the block
and LCU obligations false.
-/
theorem oneTermRobinBlockEncodingProofRoute_blockProjectionNormalizerAudit
    (n : Nat) :
    (oneTermRobinBlockEncodingProofRoute n).blockClaim.target =
        oneTermRobinBlockExtractionTarget n ∧
      (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.unitaryMatrix =
        cast (by rw [oneTermRobinCircuitDimCompat n])
          (oneTermRobinCircuitSemantics n).matrix ∧
      (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.blockMatrix =
        signalSystemBlockProjection
          (qubitDim (GHL2025.effectiveRobinSignalQubits (oneTermParameters n)))
          (gridSize n)
          (gridSize n)
          (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.unitaryMatrix
          (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.signalIndex ∧
      (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.targetMatrix =
        oneTermRobinAkMatrix n ∧
      (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.normalizer =
        GHL2025.oneTermRobinNormalizer ∧
      (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.signalIndex.val =
        0 ∧
      (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.blockProjection.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.blockCorrect.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).sparseAccessContract.daggerCleanup.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).oracleComposition.lcuCorrect.proved =
        false := by
  have htarget :
      (oneTermRobinBlockEncodingProofRoute n).blockClaim.target =
        oneTermRobinBlockExtractionTarget n :=
    (oneTermRobinBlockEncodingProofRoute n).claimUsesTarget
  have hunit :
      (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.unitaryMatrix =
        cast (by rw [oneTermRobinCircuitDimCompat n])
          (oneTermRobinCircuitSemantics n).matrix := by
    rw [htarget]
    rfl
  have hblock :
      (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.blockMatrix =
        signalSystemBlockProjection
          (qubitDim (GHL2025.effectiveRobinSignalQubits (oneTermParameters n)))
          (gridSize n)
          (gridSize n)
          (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.unitaryMatrix
          (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.signalIndex := by
    rw [htarget]
    rfl
  have hnormalizer :
      (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.normalizer =
        GHL2025.oneTermRobinNormalizer := by
    rw [htarget]
    rfl
  exact ⟨htarget, hunit, hblock,
    (oneTermRobinBlockEncodingProofRoute n).targetMatrixMatchesSpec,
    hnormalizer,
    (oneTermRobinBlockEncodingProofRoute n).signalIndexZero,
    (oneTermRobinBlockEncodingProofRoute n).blockProjectionOpen,
    (oneTermRobinBlockEncodingProofRoute n).blockCorrectOpen,
    (oneTermRobinBlockEncodingProofRoute n).sparseAccessCleanupOpen,
    (oneTermRobinBlockEncodingProofRoute n).lcuOpen⟩

/--
The theorem-level route uses the active seven-gate circuit product.

This is a structural guard for Phase 1: it records that the route still points
to `oneTermRobinCircuitSemantics`, whose matrix is the ordered product computed
by `evalGateMatrices` over `oneTermRobinGateMatrixPlaceholders`.  It does not
prove any gate unitarity or block-extraction equation.
-/
theorem oneTermRobinBlockEncodingProofRoute_circuitProduct
    (n : Nat) :
    (oneTermRobinBlockEncodingProofRoute n).circuitSemantics.circuit =
        GHL2025.oneTermRobinCircuit ∧
      (oneTermRobinBlockEncodingProofRoute n).circuitSemantics.gateMatrices =
        GHL2025.oneTermRobinGateMatrixPlaceholders (oneTermParameters n) ∧
      (oneTermRobinBlockEncodingProofRoute n).circuitSemantics.gateListMatches =
        GHL2025.oneTermRobinPlaceholdersMatch (oneTermParameters n) ∧
      Matrix.PointwiseEq
        (oneTermRobinBlockEncodingProofRoute n).circuitSemantics.matrix
        (evalGateMatrices
          (GHL2025.oneTermRobinGateMatrixPlaceholders (oneTermParameters n))) ∧
      (oneTermRobinBlockEncodingProofRoute n).blockClaim.semantics =
        (oneTermRobinBlockEncodingProofRoute n).circuitSemantics := by
  exact ⟨
    (oneTermRobinBlockEncodingProofRoute n).circuitWired,
    rfl,
    rfl,
    by
      intro i j
      exact (oneTermRobinBlockEncodingProofRoute n).circuitSemantics.matrix_eq_eval i j,
    (oneTermRobinBlockEncodingProofRoute n).claimUsesSemantics⟩

/--
The theorem route uses the active seven-gate matrix product with the current
gate-level proof flags frozen.

Only `U_indic` and SWAP are locally marked proved.  The paper-oracle gates
`O_DT^S`, `Ry_boundary`, `O_D^BS`, `O_f`, and `(O_D^BS)^dagger` remain in
obligation mode, and the O_D^BS cleanup scope is still restricted to the
active global sparse-slot source.
-/
theorem oneTermRobinBlockEncodingProofRoute_gateUnitaryFlags
    (n : Nat) :
    (oneTermRobinBlockEncodingProofRoute n).circuitSemantics.gateMatrices.map
        (fun gateMatrix => gateMatrix.unitary.proved) =
        [true, false, false, false, false, true, false] ∧
      (oneTermRobinBlockEncodingProofRoute n).cleanupScopeDecision.selectedScope =
        GHL2025.BandedSparseAccessCleanupScope.activeGlobalSource ∧
      (oneTermRobinBlockEncodingProofRoute n).cleanupScopeDecision.semanticCleanupPromotionAllowed =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).theoremData.obligations.circuitUnitary.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.blockCorrect.proved =
        false := by
  exact ⟨
    GHL2025.oneTermRobinGateMatrixPlaceholders_unitaryFlags (oneTermParameters n),
    (oneTermRobinBlockEncodingProofRoute n).cleanupScopeActive,
    (oneTermRobinBlockEncodingProofRoute n).cleanupScopeNoSemanticPromotion,
    (oneTermRobinBlockEncodingProofRoute n).theoremCircuitUnitaryOpen,
    (oneTermRobinBlockEncodingProofRoute n).blockCorrectOpen⟩

/--
The theorem route keeps the Fig. 1-term Robin gate order and the current
gate-level proof flags synchronized.

This guard packages the gate-list freeze with the seven-gate flag freeze.  It
does not prove any of the paper-oracle gates unitary and keeps the O_D^BS
active global-source cleanup scope in obligation mode.
-/
theorem oneTermRobinBlockEncodingProofRoute_gateListAndFlags
    (n : Nat) :
    (oneTermRobinBlockEncodingProofRoute n).circuitSemantics.gateMatrices.map
        (fun gateMatrix => gateMatrix.gate) =
        GHL2025.oneTermRobinCircuit ∧
      (oneTermRobinBlockEncodingProofRoute n).circuitSemantics.gateMatrices.map
        (fun gateMatrix => gateMatrix.unitary.proved) =
        [true, false, false, false, false, true, false] ∧
      (oneTermRobinBlockEncodingProofRoute n).cleanupScopeDecision.selectedScope =
        GHL2025.BandedSparseAccessCleanupScope.activeGlobalSource ∧
      (oneTermRobinBlockEncodingProofRoute n).cleanupScopeDecision.semanticCleanupPromotionAllowed =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).theoremData.obligations.circuitUnitary.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.blockCorrect.proved =
        false := by
  rcases oneTermRobinBlockEncodingProofRoute_circuitProduct n with
    ⟨_, hgateMatrices, _, _, _⟩
  rcases oneTermRobinBlockEncodingProofRoute_gateUnitaryFlags n with
    ⟨hflags, hscope, hpromotion, hcircuitUnitary, hblockCorrect⟩
  exact ⟨by
      rw [hgateMatrices]
      exact GHL2025.oneTermRobinGateMatrixPlaceholders_gateList
        (oneTermParameters n),
    hflags,
    hscope,
    hpromotion,
    hcircuitUnitary,
    hblockCorrect⟩

/--
The theorem route keeps the seven-gate order and projection target frozen
together.

This is a reviewer-facing proof-DAG wrapper over the gate-list guard and the
block-projection normalizer audit.  It records the active Fig. 1-term Robin
gate order, the current proof-state vector, the signal-index-zero target, and
the final false flags.  It does not prove a block equation or change any oracle
matrix.
-/
theorem oneTermRobinBlockEncodingProofRoute_gateProjectionFreeze
    (n : Nat) :
    (oneTermRobinBlockEncodingProofRoute n).circuitSemantics.gateMatrices.map
        (fun gateMatrix => gateMatrix.gate) =
        GHL2025.oneTermRobinCircuit ∧
      (oneTermRobinBlockEncodingProofRoute n).circuitSemantics.gateMatrices.map
        (fun gateMatrix => gateMatrix.unitary.proved) =
        [true, false, false, false, false, true, false] ∧
      (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.normalizer =
        GHL2025.oneTermRobinNormalizer ∧
      (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.signalIndex.val =
        0 ∧
      (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.blockProjection.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.blockCorrect.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).theoremData.obligations.circuitUnitary.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).theoremData.obligations.blockExtraction.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).oracleComposition.lcuCorrect.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).cleanupScopeDecision.semanticCleanupPromotionAllowed =
        false := by
  rcases oneTermRobinBlockEncodingProofRoute_gateListAndFlags n with
    ⟨hgateList, hflags, _hscope, hpromotion, hcircuitUnitary, hblockCorrectGate⟩
  rcases oneTermRobinBlockEncodingProofRoute_blockProjectionNormalizerAudit n with
    ⟨_, _, _, _, hnormalizer, hsignalIndex, hblockProjection, _, _, hlcu⟩
  exact ⟨hgateList, hflags, hnormalizer, hsignalIndex, hblockProjection,
    hblockCorrectGate, hcircuitUnitary,
    (oneTermRobinBlockEncodingProofRoute n).theoremBlockExtractionOpen, hlcu,
    hpromotion⟩

/--
The theorem-level signal and pure-ancilla counts are wired separately from the
circuit-level projection dimension.

The paper theorem states the block-encoding tuple with
`oneTermRobinLayout.signalQubits` and `2n` pure ancillas.  The matrix backend
uses `effectiveRobinSignalQubits` because the block projection zeros every
non-system wire in the concrete register partition.  This guard records both
counts and keeps resource cleanup plus block extraction in obligation mode.
-/
theorem oneTermRobinBlockEncodingProofRoute_layoutProjectionAudit
    (n : Nat) :
    (oneTermRobinBlockEncodingProofRoute n).theoremData.signalQubits =
        (GHL2025.oneTermRobinLayout (oneTermParameters n)).signalQubits ∧
      (oneTermRobinBlockEncodingProofRoute n).theoremData.pureAncillas =
        (GHL2025.oneTermRobinLayout (oneTermParameters n)).pureAncillas ∧
      (oneTermRobinBlockEncodingProofRoute n).theoremData.pureAncillas =
        (GHL2025.oneTermRobinResource (oneTermParameters n)).pureAncilla ∧
      GHL2025.effectiveRobinSignalQubits (oneTermParameters n) =
        (GHL2025.oneTermRobinLayout (oneTermParameters n)).signalQubits +
          (GHL2025.defaultRobinRegisterPartition
            (oneTermParameters n)).odPureAncillaQubits + 1 ∧
      (oneTermRobinBlockEncodingProofRoute n).theoremData.obligations.resourceBound.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).theoremData.obligations.ancillaCleanup.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.blockProjection.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.blockCorrect.proved =
        false := by
  exact ⟨
    GHL2025.defaultOneTermRobinTheoremData_signalQubits_eq_layout
      (oneTermParameters n),
    GHL2025.defaultOneTermRobinTheoremData_pureAncillas_eq_layout
      (oneTermParameters n),
    GHL2025.defaultOneTermRobinTheoremData_pureAncillas_eq_resource
      (oneTermParameters n),
    GHL2025.effectiveRobinSignalQubits_eq_layout_signal_plus_visibleWorkspace
      (oneTermParameters n),
    rfl,
    rfl,
    (oneTermRobinBlockEncodingProofRoute n).blockProjectionOpen,
    (oneTermRobinBlockEncodingProofRoute n).blockCorrectOpen⟩

/--
The signal-index-zero Robin target uses the unshifted system row and column
indices.  This is an index-convention guard for the block-projection route, not
a proof of the extracted block equation.
-/
theorem oneTermRobinBlockExtractionTarget_signalZeroBlockIndices
    (n : Nat) (i j : Fin (gridSize n)) :
    signalSystemBlockRowIndex (gridSize n)
        (oneTermRobinBlockExtractionTarget n).signalIndex.val i.val = i.val ∧
      signalSystemBlockColIndex (gridSize n)
        (oneTermRobinBlockExtractionTarget n).signalIndex.val j.val = j.val := by
  have hsignal : (oneTermRobinBlockExtractionTarget n).signalIndex.val = 0 := rfl
  constructor <;>
    simp [signalSystemBlockRowIndex, signalSystemBlockColIndex, hsignal]

/--
The theorem-level route inherits the signal-index-zero block index convention
from `oneTermRobinBlockExtractionTarget`.
-/
theorem oneTermRobinBlockEncodingProofRoute_signalZeroBlockIndices
    (n : Nat) (i j : Fin (gridSize n)) :
    signalSystemBlockRowIndex (gridSize n)
        (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.signalIndex.val
        i.val = i.val ∧
      signalSystemBlockColIndex (gridSize n)
        (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.signalIndex.val
        j.val = j.val := by
  have hsignal :
      (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.signalIndex.val =
        0 :=
    (oneTermRobinBlockEncodingProofRoute n).signalIndexZero
  constructor <;>
    simp [signalSystemBlockRowIndex, signalSystemBlockColIndex, hsignal]

/--
The theorem-level route keeps the circuit-claim block obligation open.

`CircuitBlockEncodingClaim.blockCorrect` is separate from the target-level
`blockCorrect` field.  This guard prevents the route from silently promoting
the theorem claim while the paper-level oracle and composition blockers remain
open.
-/
theorem oneTermRobinBlockEncodingProofRoute_claimBlockCorrectFalse
    (n : Nat) :
    (oneTermRobinBlockEncodingProofRoute n).blockClaim.blockCorrect.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.blockProjection.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.blockCorrect.proved =
        false := by
  exact ⟨rfl,
    (oneTermRobinBlockEncodingProofRoute n).blockProjectionOpen,
    (oneTermRobinBlockEncodingProofRoute n).blockCorrectOpen⟩

/--
The theorem-level route keeps all semantic blockers in obligation mode.

This theorem is the acceptance guard for the Phase 1 contract: it records the
current false flags without using them as proofs.
-/
theorem oneTermRobinBlockEncodingProofRoute_flags_false (n : Nat) :
    (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.blockProjection.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.blockCorrect.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).theoremData.obligations.blockExtraction.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).theoremData.obligations.circuitUnitary.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).sparseAccessContract.daggerCleanup.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).sparseAccessContract.unitaryExtension.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).cleanupScopeDecision.selectedScope =
        GHL2025.BandedSparseAccessCleanupScope.activeGlobalSource ∧
      (oneTermRobinBlockEncodingProofRoute n).cleanupScopeDecision.fullCleanDomainSelected =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).cleanupScopeDecision.fullSpaceSelected =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).cleanupScopeDecision.semanticCleanupPromotionAllowed =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).functionOracleSource.closesFunctionOracleContract =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).oracleComposition.functionOracle.amplitudeCorrect.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).oracleComposition.lcuCorrect.proved =
        false := by
  exact ⟨
    (oneTermRobinBlockEncodingProofRoute n).blockProjectionOpen,
    (oneTermRobinBlockEncodingProofRoute n).blockCorrectOpen,
    (oneTermRobinBlockEncodingProofRoute n).theoremBlockExtractionOpen,
    (oneTermRobinBlockEncodingProofRoute n).theoremCircuitUnitaryOpen,
    (oneTermRobinBlockEncodingProofRoute n).sparseAccessCleanupOpen,
    (oneTermRobinBlockEncodingProofRoute n).sparseAccessUnitaryOpen,
    (oneTermRobinBlockEncodingProofRoute n).cleanupScopeActive,
    (oneTermRobinBlockEncodingProofRoute n).cleanupScopeFullCleanDomainOpen,
    (oneTermRobinBlockEncodingProofRoute n).cleanupScopeFullSpaceOpen,
    (oneTermRobinBlockEncodingProofRoute n).cleanupScopeNoSemanticPromotion,
    (oneTermRobinBlockEncodingProofRoute n).functionOracleExternalOpen,
    (oneTermRobinBlockEncodingProofRoute n).functionOracleOpen,
    (oneTermRobinBlockEncodingProofRoute n).lcuOpen⟩

/--
The theorem route exposes the `O_f` external-source transcript and false flags.

This is a Phase 1 bridge from the per-column
`functionOracleAmplitudeProofRoute_externalSourceAndFlags` guard to
`oneTermRobinBlockEncodingProofRoute`.  It records that the route still points
to the cited GHL2025/GL2024 source contract and keeps the `N_f`, orthogonal
completion, gate-unitarity, LCU, projection, and block-correctness obligations
false.
-/
theorem oneTermRobinBlockEncodingProofRoute_ofExternalSourceAndFlags
    (n j : Nat) :
    (oneTermRobinBlockEncodingProofRoute n).functionOracleSource =
        GHL2025.functionOracleExternalAmplitudeSourceContract ∧
      (GHL2025.functionOracleAmplitudeProofRoute
        (oneTermParameters n) j).sourceAnchor =
        (oneTermRobinBlockEncodingProofRoute n).functionOracleSource.sourceAnchor ∧
      (GHL2025.functionOracleAmplitudeProofRoute
        (oneTermParameters n) j).normalizerNf =
        (oneTermRobinBlockEncodingProofRoute n).functionOracleSource.normalizerNf ∧
      (GHL2025.functionOracleAmplitudeProofRoute
        (oneTermParameters n) j).normalizedAmplitudeFormula =
        (oneTermRobinBlockEncodingProofRoute n).functionOracleSource.cleanBranchFormula ∧
      (GHL2025.functionOracleAmplitudeProofRoute
        (oneTermParameters n) j).nonzeroNormalizer =
        (oneTermRobinBlockEncodingProofRoute n).functionOracleSource.nonzeroNormalizer ∧
      (GHL2025.functionOracleAmplitudeProofRoute
        (oneTermParameters n) j).divisionSemantics =
        (oneTermRobinBlockEncodingProofRoute n).functionOracleSource.divisionSemantics ∧
      (GHL2025.functionOracleAmplitudeProofRoute
        (oneTermParameters n) j).theoremAmplitudeCorrect =
        (oneTermRobinBlockEncodingProofRoute n).functionOracleSource.theoremAmplitudeCorrect ∧
      (oneTermRobinBlockEncodingProofRoute n).functionOracleSource.resourceClaim.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).functionOracleSource.externalTheoremFormalized.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).functionOracleSource.nonzeroNormalizer.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).functionOracleSource.divisionSemantics.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).functionOracleSource.theoremAmplitudeCorrect.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).functionOracleSource.closesNormalizerBound =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).functionOracleSource.closesOrthogonalCompletion =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).functionOracleSource.closesUnitaryCompletion =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).functionOracleSource.closesFunctionOracleContract =
        false ∧
      (GHL2025.functionOracleAmplitudeProofRoute
        (oneTermParameters n) j).normalizedAmplitudeCorrect.proved = false ∧
      (GHL2025.functionOracleAmplitudeProofRoute
        (oneTermParameters n) j).nonzeroNormalizer.proved = false ∧
      (GHL2025.functionOracleAmplitudeProofRoute
        (oneTermParameters n) j).divisionSemantics.proved = false ∧
      (GHL2025.functionOracleAmplitudeProofRoute
        (oneTermParameters n) j).normalizerBound.proved = false ∧
      (GHL2025.functionOracleAmplitudeProofRoute
        (oneTermParameters n) j).orthogonalComponentCorrect.proved = false ∧
      (GHL2025.functionOracleAmplitudeProofRoute
        (oneTermParameters n) j).unitaryCompletion.proved = false ∧
      (GHL2025.functionOracleAmplitudeProofRoute
        (oneTermParameters n) j).theoremAmplitudeCorrect.proved = false ∧
      (((oneTermRobinBlockEncodingProofRoute n).circuitSemantics.gateMatrices.get
        ⟨4, by
          simp [oneTermRobinBlockEncodingProofRoute, oneTermRobinCircuitSemantics,
            GHL2025.oneTermRobinGateMatrixPlaceholders]⟩).gate =
        Gate.oracleCall "O_f") ∧
      (((oneTermRobinBlockEncodingProofRoute n).circuitSemantics.gateMatrices.get
        ⟨4, by
          simp [oneTermRobinBlockEncodingProofRoute, oneTermRobinCircuitSemantics,
            GHL2025.oneTermRobinGateMatrixPlaceholders]⟩).matrix =
        GHL2025.functionOraclePaperMatrix (oneTermParameters n)) ∧
      (GHL2025.oneTermRobinGate_O_f (oneTermParameters n)).unitary.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).oracleComposition.functionOracle.amplitudeCorrect.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).oracleComposition.lcuCorrect.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.blockProjection.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.blockCorrect.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).theoremData.obligations.blockExtraction.proved =
        false := by
  rcases
      GHL2025.functionOracleAmplitudeProofRoute_externalSourceAndFlags
        (oneTermParameters n) j
      with
    ⟨hsource, hsourceFlags, hnormalized, hnonzero, hdivision, hbound,
      horthogonal, hunitary, htheoremAmplitude⟩
  rcases hsource with
    ⟨hsourceAnchor, hnormalizer, hformula, hnonzeroEq, hdivisionEq,
      htheoremEq⟩
  rcases hsourceFlags with
    ⟨hresource, hexternal, hsourceNonzero, hsourceDivision, hsourceTheorem,
      hclosesBound, hclosesOrthogonal, hclosesUnitary, hclosesContract⟩
  rcases oneTermRobinBlockEncodingProofRoute_flags_false n with
    ⟨hblockProjection, hblockCorrect, hblockExtraction, _hcircuitUnitary,
      _hsparseCleanup, _hsparseUnitary, _hscope, _hfullClean, _hfullSpace,
      _hpromotion, hfunctionSource, hfunctionAmp, hlcu⟩
  exact ⟨rfl, hsourceAnchor, hnormalizer, hformula, hnonzeroEq, hdivisionEq,
    htheoremEq, hresource, hexternal, hsourceNonzero, hsourceDivision,
    hsourceTheorem, hclosesBound, hclosesOrthogonal, hclosesUnitary,
    hclosesContract, hnormalized, hnonzero, hdivision, hbound, horthogonal,
    hunitary, htheoremAmplitude, rfl, rfl, rfl, hfunctionAmp, hlcu,
    hblockProjection, hblockCorrect, hblockExtraction⟩

/--
The route-level `O_f` gate exposes the clean-workspace paper branch entry.

This is a narrow bridge from gate slot 4 of Fig. 1-term Robin to the
per-column `functionOracleAmplitudeProofRoute`.  It proves only the matrix
entry selected by the clean `m_f` branch; the theorem-level function-oracle,
LCU, projection, block-correctness, and final extraction flags remain false.
-/
theorem oneTermRobinBlockEncodingProofRoute_ofCleanFunctionOracleEntry
    (n : Nat)
    (i j : Fin
      (qubitDim (GHL2025.oneTermRobinTotalQubits (oneTermParameters n))))
    (hClean :
      (GHL2025.functionOraclePaperImage
        (oneTermParameters n) j.val).cleanWorkspaceBranch = true)
    (hBranch :
      i.val =
        (GHL2025.functionOraclePaperImage
          (oneTermParameters n) j.val).cleanBranchBasisIndex) :
    let p := oneTermParameters n
    (((oneTermRobinBlockEncodingProofRoute n).circuitSemantics.gateMatrices.get
      ⟨4, by
        simp [oneTermRobinBlockEncodingProofRoute, oneTermRobinCircuitSemantics,
          GHL2025.oneTermRobinGateMatrixPlaceholders]⟩).gate =
        Gate.oracleCall "O_f") ∧
      (((oneTermRobinBlockEncodingProofRoute n).circuitSemantics.gateMatrices.get
        ⟨4, by
          simp [oneTermRobinBlockEncodingProofRoute, oneTermRobinCircuitSemantics,
            GHL2025.oneTermRobinGateMatrixPlaceholders]⟩).matrix i j =
        (GHL2025.functionOracleAmplitudeProofRoute p j.val).cleanBranchAmplitude) ∧
      (((oneTermRobinBlockEncodingProofRoute n).circuitSemantics.gateMatrices.get
        ⟨4, by
          simp [oneTermRobinBlockEncodingProofRoute, oneTermRobinCircuitSemantics,
            GHL2025.oneTermRobinGateMatrixPlaceholders]⟩).matrix i j =
        (GHL2025.functionOracleAmplitudeProofRoute p j.val).normalizedAmplitude) ∧
      (GHL2025.functionOracleAmplitudeProofRoute p j.val).cleanBranchBasisIndex =
        i.val ∧
      (GHL2025.functionOracleAmplitudeProofRoute p j.val).cleanWorkspaceBranch =
        true ∧
      (((oneTermRobinBlockEncodingProofRoute n).circuitSemantics.gateMatrices.get
        ⟨4, by
          simp [oneTermRobinBlockEncodingProofRoute, oneTermRobinCircuitSemantics,
            GHL2025.oneTermRobinGateMatrixPlaceholders]⟩).unitary.proved =
        false) ∧
      (oneTermRobinBlockEncodingProofRoute n).functionOracleSource.closesFunctionOracleContract =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).oracleComposition.functionOracle.amplitudeCorrect.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).oracleComposition.lcuCorrect.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.blockProjection.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.blockCorrect.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).theoremData.obligations.blockExtraction.proved =
        false := by
  rcases oneTermRobinBlockEncodingProofRoute_ofExternalSourceAndFlags n j.val with
    ⟨_hsourceIdentity, _hsourceAnchor, _hnormalizer, _hformula, _hnonzeroEq,
      _hdivisionEq, _htheoremEq, _hresource, _hexternal, _hsourceNonzero,
      _hsourceDivision, _hsourceTheorem, _hclosesBound, _hclosesOrthogonal,
      _hclosesUnitary, hclosesContract, _hnormalizedCorrect, _hnonzero,
      _hdivision, _hbound, _horthogonal, _hunitary, _hrouteTheorem,
      hgate, _hmatrix, hgateUnitary, hfunctionAmp, hlcu, hblockProjection,
      hblockCorrect, hblockExtraction⟩
  have hentry :
      ((oneTermRobinBlockEncodingProofRoute n).circuitSemantics.gateMatrices.get
        ⟨4, by
          simp [oneTermRobinBlockEncodingProofRoute, oneTermRobinCircuitSemantics,
            GHL2025.oneTermRobinGateMatrixPlaceholders]⟩).matrix i j =
        (GHL2025.functionOracleAmplitudeProofRoute
          (oneTermParameters n) j.val).cleanBranchAmplitude := by
    simpa [oneTermRobinBlockEncodingProofRoute, oneTermRobinCircuitSemantics,
      GHL2025.oneTermRobinGateMatrixPlaceholders,
      GHL2025.functionOracleAmplitudeProofRoute] using
      GHL2025.functionOraclePaperMatrix_cleanBranch_entry
        (oneTermParameters n) i j hClean hBranch
  have hnormalized :
      ((oneTermRobinBlockEncodingProofRoute n).circuitSemantics.gateMatrices.get
        ⟨4, by
          simp [oneTermRobinBlockEncodingProofRoute, oneTermRobinCircuitSemantics,
            GHL2025.oneTermRobinGateMatrixPlaceholders]⟩).matrix i j =
        (GHL2025.functionOracleAmplitudeProofRoute
          (oneTermParameters n) j.val).normalizedAmplitude := by
    simpa [GHL2025.functionOracleAmplitudeProofRoute] using hentry
  have hbasis :
      (GHL2025.functionOracleAmplitudeProofRoute
        (oneTermParameters n) j.val).cleanBranchBasisIndex = i.val := by
    simpa [GHL2025.functionOracleAmplitudeProofRoute] using hBranch.symm
  have hcleanRoute :
      (GHL2025.functionOracleAmplitudeProofRoute
        (oneTermParameters n) j.val).cleanWorkspaceBranch = true := by
    simpa [GHL2025.functionOracleAmplitudeProofRoute] using hClean
  exact ⟨hgate, hentry, hnormalized, hbasis, hcleanRoute, hgateUnitary,
    hclosesContract, hfunctionAmp, hlcu, hblockProjection, hblockCorrect,
    hblockExtraction⟩

/--
The theorem route exposes the derivative-amplitude and boundary-rotation
contracts that share the paper normalizer `N_D`.

This guard connects GHL2025 Lemma 3, Eq. (20), Eq. `angles for Ry`, and
Fig. 1-term Robin to `oneTermRobinBlockEncodingProofRoute`.  It packages the
existing source-bound bridge for `O_DT^S` and `Ry_boundary`, checks that those
gates occur in the active seven-gate route, and keeps all analytic, gate-level,
LCU, projection, and final extraction flags false.
-/
theorem oneTermRobinBlockEncodingProofRoute_derivativeBoundaryContractMap
    (n row sparse : Nat) :
    ((GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute
        (oneTermParameters n) row sparse).coefficient =
        (GHL2025.derivativeNormalizerNDSourceBound
          (oneTermParameters n) row sparse).sourceCoefficient ∧
      (GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute
        (oneTermParameters n) row sparse).normalizerND =
        (GHL2025.derivativeNormalizerNDSourceBound
          (oneTermParameters n) row sparse).normalizerND ∧
      (GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute
        (oneTermParameters n) row sparse).normalizerBound =
        (GHL2025.derivativeNormalizerNDSourceBound
          (oneTermParameters n) row sparse).coefficientBound) ∧
    ((GHL2025.boundaryRotationAngleNormalizerProofRoute
        (oneTermParameters n) row sparse).coefficient =
        (GHL2025.derivativeNormalizerNDSourceBound
          (oneTermParameters n) row sparse).sourceCoefficient ∧
      (GHL2025.boundaryRotationAngleNormalizerProofRoute
        (oneTermParameters n) row sparse).normalizerND =
        (GHL2025.derivativeNormalizerNDSourceBound
          (oneTermParameters n) row sparse).normalizerND ∧
      (GHL2025.boundaryRotationAngleNormalizerProofRoute
        (oneTermParameters n) row sparse).normalizerBound =
        (GHL2025.derivativeNormalizerNDSourceBound
          (oneTermParameters n) row sparse).coefficientBound) ∧
    ((GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute
        (oneTermParameters n) row sparse).coefficient =
        (GHL2025.boundaryRotationAngleNormalizerProofRoute
          (oneTermParameters n) row sparse).coefficient ∧
      (GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute
        (oneTermParameters n) row sparse).normalizerND =
        (GHL2025.boundaryRotationAngleNormalizerProofRoute
          (oneTermParameters n) row sparse).normalizerND ∧
      (GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute
        (oneTermParameters n) row sparse).normalizerBound =
        (GHL2025.boundaryRotationAngleNormalizerProofRoute
          (oneTermParameters n) row sparse).normalizerBound) ∧
    (GHL2025.derivativeNormalizerNDContract
      (oneTermParameters n) row sparse).nonzeroNormalizer.proved = false ∧
    (GHL2025.derivativeNormalizerNDContract
      (oneTermParameters n) row sparse).divisionSemantics.proved = false ∧
    (GHL2025.derivativeNormalizerNDContract
      (oneTermParameters n) row sparse).coefficientBound.proved = false ∧
    (GHL2025.derivativeNormalizerNDContract
      (oneTermParameters n) row sparse).absSquareSemantics.proved = false ∧
    (GHL2025.derivativeNormalizerNDContract
      (oneTermParameters n) row sparse).sqrtComplementSemantics.proved = false ∧
    (GHL2025.derivativeNormalizerNDContract
      (oneTermParameters n) row sparse).arccosSemantics.proved = false ∧
    (GHL2025.derivativeNormalizerNDContract
      (oneTermParameters n) row sparse).twoByTwoUnitary.proved = false ∧
    (GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute
      (oneTermParameters n) row sparse).coefficientDivision.proved = false ∧
    (GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute
      (oneTermParameters n) row sparse).normalizerBound.proved = false ∧
    (GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute
      (oneTermParameters n) row sparse).absSquareSemantics.proved = false ∧
    (GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute
      (oneTermParameters n) row sparse).sqrtComplementSemantics.proved = false ∧
    (GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute
      (oneTermParameters n) row sparse).twoByTwoUnitary.proved = false ∧
    (GHL2025.boundaryRotationAngleNormalizerProofRoute
      (oneTermParameters n) row sparse).coefficientDivision.proved = false ∧
    (GHL2025.boundaryRotationAngleNormalizerProofRoute
      (oneTermParameters n) row sparse).realArccosSemantics.proved = false ∧
    (GHL2025.boundaryRotationAngleNormalizerProofRoute
      (oneTermParameters n) row sparse).halfAngleSemantics.proved = false ∧
    (GHL2025.boundaryRotationAngleNormalizerProofRoute
      (oneTermParameters n) row sparse).normalizerBound.proved = false ∧
    (GHL2025.boundaryRotationAngleNormalizerProofRoute
      (oneTermParameters n) row sparse).twoByTwoUnitary.proved = false ∧
    (oneTermRobinBlockEncodingProofRoute n).circuitSemantics.gateMatrices.map
      (fun gateMatrix => gateMatrix.gate) = GHL2025.oneTermRobinCircuit ∧
    (oneTermRobinBlockEncodingProofRoute n).circuitSemantics.gateMatrices.map
      (fun gateMatrix => gateMatrix.unitary.proved) =
        [true, false, false, false, false, true, false] ∧
    (((oneTermRobinBlockEncodingProofRoute n).circuitSemantics.gateMatrices.get
      ⟨1, by
        simp [oneTermRobinBlockEncodingProofRoute, oneTermRobinCircuitSemantics,
          GHL2025.oneTermRobinGateMatrixPlaceholders]⟩).gate =
      Gate.oracleCall "O_DT^S") ∧
    (((oneTermRobinBlockEncodingProofRoute n).circuitSemantics.gateMatrices.get
      ⟨1, by
        simp [oneTermRobinBlockEncodingProofRoute, oneTermRobinCircuitSemantics,
          GHL2025.oneTermRobinGateMatrixPlaceholders]⟩).matrix =
      GHL2025.sparseAmplitudeOracleDTRotationMatrix (oneTermParameters n)) ∧
    (((oneTermRobinBlockEncodingProofRoute n).circuitSemantics.gateMatrices.get
      ⟨2, by
        simp [oneTermRobinBlockEncodingProofRoute, oneTermRobinCircuitSemantics,
          GHL2025.oneTermRobinGateMatrixPlaceholders]⟩).gate =
      Gate.oracleCall "Ry_boundary") ∧
    (((oneTermRobinBlockEncodingProofRoute n).circuitSemantics.gateMatrices.get
      ⟨2, by
        simp [oneTermRobinBlockEncodingProofRoute, oneTermRobinCircuitSemantics,
          GHL2025.oneTermRobinGateMatrixPlaceholders]⟩).matrix =
      GHL2025.boundaryRotationMatrix (oneTermParameters n)) ∧
    (GHL2025.oneTermRobinGate_O_DT_S (oneTermParameters n)).unitary.proved =
      false ∧
    (GHL2025.oneTermRobinGate_Ry_boundary (oneTermParameters n)).unitary.proved =
      false ∧
    (oneTermRobinBlockEncodingProofRoute n).theoremData.obligations.circuitUnitary.proved =
      false ∧
    (oneTermRobinBlockEncodingProofRoute n).oracleComposition.functionOracle.amplitudeCorrect.proved =
      false ∧
    (oneTermRobinBlockEncodingProofRoute n).oracleComposition.lcuCorrect.proved =
      false ∧
    (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.blockProjection.proved =
      false ∧
    (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.blockCorrect.proved =
      false ∧
    (oneTermRobinBlockEncodingProofRoute n).theoremData.obligations.blockExtraction.proved =
      false := by
  rcases
      GHL2025.derivativeNormalizerNDSharedRoute_sourceBoundAndFlags
        (oneTermParameters n) row sparse
      with
    ⟨hodts, hry, hshared, hnonzero, hdivision, hbound, habs, hsqrt,
      harccos, htwo, hodtsDivision, hodtsBound, hodtsAbs, hodtsSqrt,
      hodtsTwo, hryDivision, hryArccos, hryHalf, hryBound, hryTwo,
      hodtsUnitary, hryUnitary⟩
  rcases oneTermRobinBlockEncodingProofRoute_gateProjectionFreeze n with
    ⟨hgateList, hgateFlags, _hnormalizer, _hsignalIndex, hblockProjection,
      hblockCorrect, hcircuitUnitary, hblockExtraction, hlcu, _hpromotion⟩
  rcases oneTermRobinBlockEncodingProofRoute_flags_false n with
    ⟨_hblockProjection, _hblockCorrect, _hblockExtraction, _hcircuitUnitary,
      _hsparseCleanup, _hsparseUnitary, _hscope, _hfullClean, _hfullSpace,
      _hpromotion, _hfunctionSource, hfunctionAmp, _hlcu⟩
  exact ⟨hodts, hry, hshared, hnonzero, hdivision, hbound, habs, hsqrt,
    harccos, htwo, hodtsDivision, hodtsBound, hodtsAbs, hodtsSqrt,
    hodtsTwo, hryDivision, hryArccos, hryHalf, hryBound, hryTwo, hgateList,
    hgateFlags, rfl, rfl, rfl, rfl, hodtsUnitary, hryUnitary,
    hcircuitUnitary, hfunctionAmp, hlcu, hblockProjection, hblockCorrect,
    hblockExtraction⟩

/--
The route-level `O_DT^S` gate exposes the Eq. (20) ket-zero entry.

This is the local matrix-entry bridge for the derivative-amplitude factor in
Eq. `ROBIN clarified`.  Under the paper-register hypotheses selecting an
indicator-1, ancilla-0 column and the ancilla-0 row with matching non-ancilla
bits, gate slot 1 of the Fig. 1-term Robin route has the symbolic ket-zero
entry recorded by `sparseAmplitudeOracleDTCoefficientNormalizerProofRoute`.
It does not prove the division semantics, normalizer bound, two-by-two
unitarity, LCU composition, projection, or final block extraction.
-/
theorem oneTermRobinBlockEncodingProofRoute_odtsKetZeroEntry
    (n : Nat)
    (i j : Fin
      (qubitDim (GHL2025.oneTermRobinTotalQubits (oneTermParameters n))))
    (hIndicator :
      (GHL2025.sparseAmplitudeOracleDTPaperRegisters
        (oneTermParameters n) j.val).indicatorBit = 1)
    (hAncilla :
      (GHL2025.sparseAmplitudeOracleDTPaperRegisters
        (oneTermParameters n) j.val).ancillaBit = 0)
    (hRow :
      i.val >>> 1 =
        (GHL2025.sparseAmplitudeOracleDTPaperRegisters
          (oneTermParameters n) j.val).nonAncillaValue)
    (hAncillaRow : i.val &&& 1 = 0) :
    let p := oneTermParameters n
    let regs := GHL2025.sparseAmplitudeOracleDTPaperRegisters p j.val
    (((oneTermRobinBlockEncodingProofRoute n).circuitSemantics.gateMatrices.get
      ⟨1, by
        simp [oneTermRobinBlockEncodingProofRoute, oneTermRobinCircuitSemantics,
          GHL2025.oneTermRobinGateMatrixPlaceholders]⟩).gate =
        Gate.oracleCall "O_DT^S") ∧
      (((oneTermRobinBlockEncodingProofRoute n).circuitSemantics.gateMatrices.get
        ⟨1, by
          simp [oneTermRobinBlockEncodingProofRoute, oneTermRobinCircuitSemantics,
            GHL2025.oneTermRobinGateMatrixPlaceholders]⟩).matrix i j =
        (GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute
          p regs.rowValue regs.sparseIndexValue).ketZeroEntry) ∧
      (GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute
        p regs.rowValue regs.sparseIndexValue).ketZeroEntry =
        (GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerContract
          p regs.rowValue regs.sparseIndexValue).ketZeroEntry ∧
      (GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute
        p regs.rowValue regs.sparseIndexValue).normalizedCoefficient =
        GHL2025.sparseAmplitudeOracleDTNormalizedCoefficient
          p regs.rowValue regs.sparseIndexValue ∧
      (GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute
        p regs.rowValue regs.sparseIndexValue).coefficientDivision.proved =
        false ∧
      (GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute
        p regs.rowValue regs.sparseIndexValue).normalizerBound.proved =
        false ∧
      (GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute
        p regs.rowValue regs.sparseIndexValue).absSquareSemantics.proved =
        false ∧
      (GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute
        p regs.rowValue regs.sparseIndexValue).sqrtComplementSemantics.proved =
        false ∧
      (GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute
        p regs.rowValue regs.sparseIndexValue).twoByTwoUnitary.proved =
        false ∧
      (GHL2025.oneTermRobinGate_O_DT_S p).unitary.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).oracleComposition.lcuCorrect.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.blockProjection.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.blockCorrect.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).theoremData.obligations.blockExtraction.proved =
        false := by
  let p := oneTermParameters n
  let regs := GHL2025.sparseAmplitudeOracleDTPaperRegisters p j.val
  have hIndicator' : regs.indicatorBit = 1 := by
    simpa [p, regs] using hIndicator
  have hAncilla' : regs.ancillaBit = 0 := by
    simpa [p, regs] using hAncilla
  have hRow' : i.val >>> 1 = regs.nonAncillaValue := by
    simpa [p, regs] using hRow
  rcases
      oneTermRobinBlockEncodingProofRoute_derivativeBoundaryContractMap
        n regs.rowValue regs.sparseIndexValue
      with
    ⟨_hodts, _hry, _hshared, _hnonzero, _hdivision, _hbound, _habs, _hsqrt,
      _harccos, _htwo, hodtsDivision, hodtsBound, hodtsAbs,
      hodtsSqrt, hodtsTwo, _hryDivision, _hryArccos, _hryHalf,
      _hryBound, _hryTwo, _hgateList, _hgateFlags, hODTSGate,
      hODTSMatrix, _hRyGate, _hRyMatrix, hODTSUnitary, _hRyUnitary,
      _hcircuitUnitary, _hfunctionAmp, hlcu, hblockProjection,
      hblockCorrect, hblockExtraction⟩
  have hrouteMatrix :
      ((oneTermRobinBlockEncodingProofRoute n).circuitSemantics.gateMatrices.get
        ⟨1, by
          simp [oneTermRobinBlockEncodingProofRoute, oneTermRobinCircuitSemantics,
            GHL2025.oneTermRobinGateMatrixPlaceholders]⟩).matrix =
        GHL2025.sparseAmplitudeOracleDTRotationMatrix p := by
    simpa [p] using hODTSMatrix
  have hentry :
      ((oneTermRobinBlockEncodingProofRoute n).circuitSemantics.gateMatrices.get
        ⟨1, by
          simp [oneTermRobinBlockEncodingProofRoute, oneTermRobinCircuitSemantics,
            GHL2025.oneTermRobinGateMatrixPlaceholders]⟩).matrix i j =
        (GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute
          p regs.rowValue regs.sparseIndexValue).ketZeroEntry := by
    rw [hrouteMatrix]
    simp [GHL2025.sparseAmplitudeOracleDTRotationMatrix,
      GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute,
      GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerContract,
      regs, hIndicator', hAncilla', hRow', hAncillaRow]
  exact ⟨hODTSGate, hentry,
    GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute_ketZeroEntry
      p regs.rowValue regs.sparseIndexValue,
    GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute_normalizedCoefficient
      p regs.rowValue regs.sparseIndexValue,
    hodtsDivision, hodtsBound, hodtsAbs, hodtsSqrt, hodtsTwo,
    hODTSUnitary, hlcu, hblockProjection, hblockCorrect, hblockExtraction⟩

/--
The route-level `Ry_boundary` gate exposes the boundary ket-zero entry.

This is the local matrix-entry bridge for the boundary rotation factor in
Eq. `angles for Ry` and Eq. `ROBIN clarified`.  Under the paper-register
hypotheses selecting an indicator-0, ancilla-0 column and the ancilla-0 row
with matching non-ancilla bits, gate slot 2 of the Fig. 1-term Robin route has
the symbolic cosine half-angle entry recorded by
`boundaryRotationAngleNormalizerProofRoute`.  It does not prove the arccos
semantics, half-angle identities, two-by-two unitarity, LCU composition,
projection, or final block extraction.
-/
theorem oneTermRobinBlockEncodingProofRoute_boundaryKetZeroEntry
    (n : Nat)
    (i j : Fin
      (qubitDim (GHL2025.oneTermRobinTotalQubits (oneTermParameters n))))
    (hIndicator :
      (GHL2025.boundaryRotationPaperRegisters
        (oneTermParameters n) j.val).indicatorBit = 0)
    (hAncilla :
      (GHL2025.boundaryRotationPaperRegisters
        (oneTermParameters n) j.val).ancillaBit = 0)
    (hRow :
      i.val >>> 1 =
        (GHL2025.boundaryRotationPaperRegisters
          (oneTermParameters n) j.val).nonAncillaValue)
    (hAncillaRow : i.val &&& 1 = 0) :
    let p := oneTermParameters n
    let regs := GHL2025.boundaryRotationPaperRegisters p j.val
    (((oneTermRobinBlockEncodingProofRoute n).circuitSemantics.gateMatrices.get
      ⟨2, by
        simp [oneTermRobinBlockEncodingProofRoute, oneTermRobinCircuitSemantics,
          GHL2025.oneTermRobinGateMatrixPlaceholders]⟩).gate =
        Gate.oracleCall "Ry_boundary") ∧
      (((oneTermRobinBlockEncodingProofRoute n).circuitSemantics.gateMatrices.get
        ⟨2, by
          simp [oneTermRobinBlockEncodingProofRoute, oneTermRobinCircuitSemantics,
            GHL2025.oneTermRobinGateMatrixPlaceholders]⟩).matrix i j =
        (GHL2025.boundaryRotationAngleNormalizerProofRoute
          p regs.rowValue regs.sparseIndexValue).cosHalfEntry) ∧
      (GHL2025.boundaryRotationAngleNormalizerProofRoute
        p regs.rowValue regs.sparseIndexValue).cosHalfEntry =
        (GHL2025.boundaryRotationAngleNormalizerContract
          p regs.rowValue regs.sparseIndexValue).cosHalfEntry ∧
      (GHL2025.boundaryRotationAngleNormalizerProofRoute
        p regs.rowValue regs.sparseIndexValue).arccosArgument =
        GHL2025.boundaryRotationNormalizedCoefficient
          p regs.rowValue regs.sparseIndexValue ∧
      ((GHL2025.boundaryRotationAngleNormalizerProofRoute
        p regs.rowValue regs.sparseIndexValue).coefficient =
          (GHL2025.derivativeNormalizerNDSourceBound
            p regs.rowValue regs.sparseIndexValue).sourceCoefficient ∧
        (GHL2025.boundaryRotationAngleNormalizerProofRoute
          p regs.rowValue regs.sparseIndexValue).normalizerND =
          (GHL2025.derivativeNormalizerNDSourceBound
            p regs.rowValue regs.sparseIndexValue).normalizerND ∧
        (GHL2025.boundaryRotationAngleNormalizerProofRoute
          p regs.rowValue regs.sparseIndexValue).normalizerBound =
          (GHL2025.derivativeNormalizerNDSourceBound
            p regs.rowValue regs.sparseIndexValue).coefficientBound) ∧
      (GHL2025.derivativeNormalizerNDContract
        p regs.rowValue regs.sparseIndexValue).nonzeroNormalizer.proved =
        false ∧
      (GHL2025.derivativeNormalizerNDContract
        p regs.rowValue regs.sparseIndexValue).divisionSemantics.proved =
        false ∧
      (GHL2025.derivativeNormalizerNDContract
        p regs.rowValue regs.sparseIndexValue).coefficientBound.proved =
        false ∧
      (GHL2025.derivativeNormalizerNDContract
        p regs.rowValue regs.sparseIndexValue).absSquareSemantics.proved =
        false ∧
      (GHL2025.derivativeNormalizerNDContract
        p regs.rowValue regs.sparseIndexValue).sqrtComplementSemantics.proved =
        false ∧
      (GHL2025.derivativeNormalizerNDContract
        p regs.rowValue regs.sparseIndexValue).arccosSemantics.proved =
        false ∧
      (GHL2025.derivativeNormalizerNDContract
        p regs.rowValue regs.sparseIndexValue).twoByTwoUnitary.proved =
        false ∧
      (GHL2025.boundaryRotationAngleNormalizerProofRoute
        p regs.rowValue regs.sparseIndexValue).coefficientDivision.proved =
        false ∧
      (GHL2025.boundaryRotationAngleNormalizerProofRoute
        p regs.rowValue regs.sparseIndexValue).realArccosSemantics.proved =
        false ∧
      (GHL2025.boundaryRotationAngleNormalizerProofRoute
        p regs.rowValue regs.sparseIndexValue).halfAngleSemantics.proved =
        false ∧
      (GHL2025.boundaryRotationAngleNormalizerProofRoute
        p regs.rowValue regs.sparseIndexValue).normalizerBound.proved =
        false ∧
      (GHL2025.boundaryRotationAngleNormalizerProofRoute
        p regs.rowValue regs.sparseIndexValue).twoByTwoUnitary.proved =
        false ∧
      (GHL2025.oneTermRobinGate_O_DT_S p).unitary.proved =
        false ∧
      (GHL2025.oneTermRobinGate_Ry_boundary p).unitary.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).sparseAccessContract.daggerCleanup.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).sparseAccessContract.unitaryExtension.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).functionOracleSource.closesFunctionOracleContract =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).oracleComposition.functionOracle.amplitudeCorrect.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).oracleComposition.lcuCorrect.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).theoremData.obligations.circuitUnitary.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.blockProjection.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.blockCorrect.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).theoremData.obligations.blockExtraction.proved =
        false := by
  let p := oneTermParameters n
  let regs := GHL2025.boundaryRotationPaperRegisters p j.val
  have hRow' : i.val >>> 1 = regs.nonAncillaValue := by
    simpa [p, regs] using hRow
  have hIndicatorBit :
      (j.val >>> GHL2025.robinIndicatorBitPosition p) &&& 1 = 0 := by
    simpa [p, GHL2025.boundaryRotationPaperRegisters] using hIndicator
  have hAncillaBit : j.val &&& 1 = 0 := by
    simpa [p, GHL2025.boundaryRotationPaperRegisters] using hAncilla
  have hIndicatorMod :
      (j.val >>> GHL2025.robinIndicatorBitPosition p) % 2 = 0 := by
    simpa using hIndicatorBit
  have hAncillaMod : j.val % 2 = 0 := by
    simpa using hAncillaBit
  rcases
      oneTermRobinBlockEncodingProofRoute_derivativeBoundaryContractMap
        n regs.rowValue regs.sparseIndexValue
      with
    ⟨_hodts, hry, _hshared, hnonzero, hdivision, hbound, habs, hsqrt,
      harccos, htwo, _hodtsDivision, _hodtsBound, _hodtsAbs,
      _hodtsSqrt, _hodtsTwo, hryDivision, hryArccos, hryHalf,
      hryBound, hryTwo, _hgateList, _hgateFlags, _hODTSGate,
      _hODTSMatrix, hRyGate, hRyMatrix, hODTSUnitary, hRyUnitary,
      hcircuitUnitary, hfunctionAmp, hlcu, hblockProjection,
      hblockCorrect, hblockExtraction⟩
  rcases oneTermRobinBlockEncodingProofRoute_flags_false n with
    ⟨_hblockProjectionRoute, _hblockCorrectRoute, _hblockExtractionRoute,
      _hcircuitUnitaryRoute, hsparseCleanup, hsparseUnitary, _hscope,
      _hfullClean, _hfullSpace, _hpromotion, hfunctionSource,
      _hfunctionAmpRoute, _hlcuRoute⟩
  have hrouteMatrix :
      ((oneTermRobinBlockEncodingProofRoute n).circuitSemantics.gateMatrices.get
        ⟨2, by
          simp [oneTermRobinBlockEncodingProofRoute, oneTermRobinCircuitSemantics,
            GHL2025.oneTermRobinGateMatrixPlaceholders]⟩).matrix =
        GHL2025.boundaryRotationMatrix p := by
    simpa [p] using hRyMatrix
  have hentry :
      ((oneTermRobinBlockEncodingProofRoute n).circuitSemantics.gateMatrices.get
        ⟨2, by
          simp [oneTermRobinBlockEncodingProofRoute, oneTermRobinCircuitSemantics,
            GHL2025.oneTermRobinGateMatrixPlaceholders]⟩).matrix i j =
        (GHL2025.boundaryRotationAngleNormalizerProofRoute
          p regs.rowValue regs.sparseIndexValue).cosHalfEntry := by
    rw [hrouteMatrix]
    simp [GHL2025.boundaryRotationMatrix,
      GHL2025.boundaryRotationPaperRegisters,
      GHL2025.boundaryRotationAngleNormalizerProofRoute,
      GHL2025.boundaryRotationAngleNormalizerContract,
      regs, hIndicatorMod, hAncillaMod, hRow', hAncillaRow]
  exact ⟨hRyGate, hentry, rfl,
    GHL2025.boundaryRotationAngleNormalizerProofRoute_arccosArgument
      p regs.rowValue regs.sparseIndexValue,
    hry, hnonzero, hdivision, hbound, habs, hsqrt, harccos, htwo,
    hryDivision, hryArccos, hryHalf, hryBound, hryTwo, hODTSUnitary,
    hRyUnitary, hsparseCleanup, hsparseUnitary, hfunctionSource,
    hfunctionAmp, hlcu, hcircuitUnitary, hblockProjection, hblockCorrect,
    hblockExtraction⟩

/--
The theorem-level route exposes the active global-slot `O_D^BS` blockers.

This is the replacement for the retired row-dependent unused-branch route.  The
active route is the global sparse-slot source together with the restricted
dagger-column cleanup interface.  Full clean-domain cleanup and full-space
unitarity remain obligations.
-/
theorem oneTermRobinBlockEncodingProofRoute_odbsActiveGlobalSlotBlockers
    (n j : Nat) :
    (oneTermRobinBlockEncodingProofRoute n).cleanupScopeDecision.selectedScope =
        GHL2025.BandedSparseAccessCleanupScope.activeGlobalSource ∧
      (oneTermRobinBlockEncodingProofRoute n).cleanupScopeDecision.selectedPredicate =
        "bandedSparseAccessPaperGlobalSlotSource" ∧
      (oneTermRobinBlockEncodingProofRoute n).cleanupScopeDecision.selectedEvidence =
        "bandedSparseAccessGlobalSlotInverseOnRangeContract_restrictedDaggerColumnIndicator" ∧
      (oneTermRobinBlockEncodingProofRoute n).cleanupScopeDecision.fullCleanDomainSelected =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).cleanupScopeDecision.fullSpaceSelected =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).cleanupScopeDecision.semanticCleanupPromotionAllowed =
        false ∧
      ((GHL2025.bandedSparseAccessFullCleanDomainExtensionContract
        (oneTermParameters n)).unusedBranchImageRuleContract
        j).proposedImageIndex = none ∧
      ((GHL2025.bandedSparseAccessFullCleanDomainExtensionContract
        (oneTermParameters n)).unusedBranchImageRuleContract
        j).imageSpecified.proved = false ∧
      (GHL2025.bandedSparseAccessFullCleanDomainExtensionContract
        (oneTermParameters n)).daggerCleanup.proved = false ∧
      (GHL2025.bandedSparseAccessFullCleanDomainExtensionContract
        (oneTermParameters n)).unitaryExtension.proved = false ∧
      (oneTermRobinBlockEncodingProofRoute n).sparseAccessContract.daggerCleanup.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).sparseAccessContract.unitaryExtension.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.blockCorrect.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).oracleComposition.lcuCorrect.proved =
        false := by
  rcases
      GHL2025.bandedSparseAccessCleanupScopeDecision_fullCleanDomainImageRuleBlocked
        (oneTermParameters n) j
      with
    ⟨_hscopeDefault, _hfullCleanDefault, _hpromotionDefault,
      _hfullCleanCleanupDefault, _hsourceDecision, _hdirectSlot,
      hwrappedSlot, hwrappedImage, _hunusedImage, _hfullCleanInjective,
      hwrapperCleanup, hwrapperUnitary⟩
  exact ⟨
    (oneTermRobinBlockEncodingProofRoute n).cleanupScopeActive,
    (oneTermRobinBlockEncodingProofRoute n).cleanupScopePredicate,
    (oneTermRobinBlockEncodingProofRoute n).cleanupScopeEvidence,
    (oneTermRobinBlockEncodingProofRoute n).cleanupScopeFullCleanDomainOpen,
    (oneTermRobinBlockEncodingProofRoute n).cleanupScopeFullSpaceOpen,
    (oneTermRobinBlockEncodingProofRoute n).cleanupScopeNoSemanticPromotion,
    hwrappedSlot, hwrappedImage, hwrapperCleanup, hwrapperUnitary,
    (oneTermRobinBlockEncodingProofRoute n).sparseAccessCleanupOpen,
    (oneTermRobinBlockEncodingProofRoute n).sparseAccessUnitaryOpen,
    (oneTermRobinBlockEncodingProofRoute n).blockCorrectOpen,
    (oneTermRobinBlockEncodingProofRoute n).lcuOpen⟩

/--
The theorem-level route keeps the active `O_D^BS` gate pair in obligation mode.

This guard is intentionally weaker than a semantic theorem.  It records only
that the active forward and dagger matrices remain unproved as unitaries while
the paper cleanup and unitary-extension flags stay false.
-/
theorem oneTermRobinBlockEncodingProofRoute_activeOdbsGatePairBlocked
    (n : Nat) :
    (GHL2025.oneTermRobinGate_O_D_BS (oneTermParameters n)).unitary.proved =
        false ∧
      (GHL2025.oneTermRobinGate_O_D_BS_dagger (oneTermParameters n)).unitary.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).sparseAccessContract.daggerCleanup.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).sparseAccessContract.unitaryExtension.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).cleanupScopeDecision.semanticCleanupPromotionAllowed =
        false := by
  exact ⟨rfl, rfl,
    (oneTermRobinBlockEncodingProofRoute n).sparseAccessCleanupOpen,
    (oneTermRobinBlockEncodingProofRoute n).sparseAccessUnitaryOpen,
    (oneTermRobinBlockEncodingProofRoute n).cleanupScopeNoSemanticPromotion⟩

/--
The active-scope blocker propagates to the final theorem flags.

The global-slot cleanup interface is currently restricted to
`bandedSparseAccessPaperGlobalSlotSource`.  This theorem keeps final
composition and block-extraction flags false until a full clean-domain or
full-space theorem is accepted.
-/
theorem oneTermRobinBlockEncodingProofRoute_odbsActiveScopeKeepsFinalFlagsFalse
    (n : Nat) :
    (oneTermRobinBlockEncodingProofRoute n).cleanupScopeDecision.semanticCleanupPromotionAllowed =
        false ∧
      (GHL2025.oneTermRobinGate_O_D_BS (oneTermParameters n)).unitary.proved =
        false ∧
      (GHL2025.oneTermRobinGate_O_D_BS_dagger (oneTermParameters n)).unitary.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).sparseAccessContract.daggerCleanup.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).theoremData.obligations.circuitUnitary.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).theoremData.obligations.blockExtraction.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.blockCorrect.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).oracleComposition.lcuCorrect.proved =
        false := by
  exact ⟨
    (oneTermRobinBlockEncodingProofRoute n).cleanupScopeNoSemanticPromotion,
    rfl,
    rfl,
    (oneTermRobinBlockEncodingProofRoute n).sparseAccessCleanupOpen,
    (oneTermRobinBlockEncodingProofRoute n).theoremCircuitUnitaryOpen,
    (oneTermRobinBlockEncodingProofRoute n).theoremBlockExtractionOpen,
    (oneTermRobinBlockEncodingProofRoute n).blockCorrectOpen,
    (oneTermRobinBlockEncodingProofRoute n).lcuOpen⟩

/--
The theorem-level route wires the active `O_D^BS` gate pair at the Fig. 1-term
Robin positions.

This is only a circuit-product guard.  It records the gate labels and matrices
used by the route while preserving the false unitarity flags.
-/
theorem oneTermRobinBlockEncodingProofRoute_activeOdbsGatePairWiring
    (n : Nat) :
    (((oneTermRobinBlockEncodingProofRoute n).circuitSemantics.gateMatrices.get
        ⟨3, by
          simp [oneTermRobinBlockEncodingProofRoute, oneTermRobinCircuitSemantics,
            GHL2025.oneTermRobinGateMatrixPlaceholders]⟩).gate =
        Gate.oracleCall "O_D^BS") ∧
      (((oneTermRobinBlockEncodingProofRoute n).circuitSemantics.gateMatrices.get
        ⟨3, by
          simp [oneTermRobinBlockEncodingProofRoute, oneTermRobinCircuitSemantics,
            GHL2025.oneTermRobinGateMatrixPlaceholders]⟩).matrix =
        GHL2025.bandedSparseAccessPaperMatrix (oneTermParameters n)) ∧
      (((oneTermRobinBlockEncodingProofRoute n).circuitSemantics.gateMatrices.get
        ⟨3, by
          simp [oneTermRobinBlockEncodingProofRoute, oneTermRobinCircuitSemantics,
            GHL2025.oneTermRobinGateMatrixPlaceholders]⟩).unitary.proved =
        false) ∧
      (((oneTermRobinBlockEncodingProofRoute n).circuitSemantics.gateMatrices.get
        ⟨6, by
          simp [oneTermRobinBlockEncodingProofRoute, oneTermRobinCircuitSemantics,
            GHL2025.oneTermRobinGateMatrixPlaceholders]⟩).gate =
        Gate.oracleCall "(O_D^BS)^†") ∧
      (((oneTermRobinBlockEncodingProofRoute n).circuitSemantics.gateMatrices.get
        ⟨6, by
          simp [oneTermRobinBlockEncodingProofRoute, oneTermRobinCircuitSemantics,
            GHL2025.oneTermRobinGateMatrixPlaceholders]⟩).matrix =
        GHL2025.bandedSparseAccessPaperDaggerMatrix (oneTermParameters n)) ∧
      (((oneTermRobinBlockEncodingProofRoute n).circuitSemantics.gateMatrices.get
        ⟨6, by
          simp [oneTermRobinBlockEncodingProofRoute, oneTermRobinCircuitSemantics,
            GHL2025.oneTermRobinGateMatrixPlaceholders]⟩).unitary.proved =
        false) := by
  exact ⟨rfl, rfl, rfl, rfl, rfl, rfl⟩

/--
The active `O_D^BS` gate pair keeps public source anchors on its obligation
records.
-/
theorem oneTermRobinBlockEncodingProofRoute_activeOdbsGatePairPublicSources
    (n : Nat) :
    (GHL2025.oneTermRobinGate_O_D_BS (oneTermParameters n)).unitary.source =
        "Guseynov-Huang-Liu 2025, Lemma 1, arXiv:2506.20478" ∧
      (GHL2025.oneTermRobinGate_O_D_BS_dagger (oneTermParameters n)).unitary.source =
        "Guseynov-Huang-Liu 2025, Fig. 1-term Robin and Lemma 1, arXiv:2506.20478" ∧
      (GHL2025.oneTermRobinGate_O_D_BS (oneTermParameters n)).unitary.proved =
        false ∧
      (GHL2025.oneTermRobinGate_O_D_BS_dagger (oneTermParameters n)).unitary.proved =
        false := by
  exact ⟨rfl, rfl, rfl, rfl⟩

/--
The active global-slot gate freeze combines the active matrices, cleanup-scope
blocker, block target, and final false flags.
-/
theorem oneTermRobinBlockEncodingProofRoute_odbsActiveGlobalSlotGateFreeze
    (n j : Nat) :
    (oneTermRobinBlockEncodingProofRoute n).cleanupScopeDecision.selectedScope =
        GHL2025.BandedSparseAccessCleanupScope.activeGlobalSource ∧
      ((GHL2025.bandedSparseAccessFullCleanDomainExtensionContract
        (oneTermParameters n)).unusedBranchImageRuleContract
        j).proposedImageIndex = none ∧
      (GHL2025.oneTermRobinGate_O_D_BS
        (oneTermParameters n)).unitary.source =
        "Guseynov-Huang-Liu 2025, Lemma 1, arXiv:2506.20478" ∧
      (GHL2025.oneTermRobinGate_O_D_BS_dagger
        (oneTermParameters n)).unitary.source =
        "Guseynov-Huang-Liu 2025, Fig. 1-term Robin and Lemma 1, arXiv:2506.20478" ∧
      (((oneTermRobinBlockEncodingProofRoute n).circuitSemantics.gateMatrices.get
        ⟨3, by
          simp [oneTermRobinBlockEncodingProofRoute, oneTermRobinCircuitSemantics,
            GHL2025.oneTermRobinGateMatrixPlaceholders]⟩).matrix =
        GHL2025.bandedSparseAccessPaperMatrix (oneTermParameters n)) ∧
      (((oneTermRobinBlockEncodingProofRoute n).circuitSemantics.gateMatrices.get
        ⟨6, by
          simp [oneTermRobinBlockEncodingProofRoute, oneTermRobinCircuitSemantics,
            GHL2025.oneTermRobinGateMatrixPlaceholders]⟩).matrix =
        GHL2025.bandedSparseAccessPaperDaggerMatrix (oneTermParameters n)) ∧
      (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.normalizer =
        GHL2025.oneTermRobinNormalizer ∧
      (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.signalIndex.val =
        0 ∧
      (oneTermRobinBlockEncodingProofRoute n).theoremData.obligations.circuitUnitary.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.blockCorrect.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).oracleComposition.lcuCorrect.proved =
        false := by
  rcases oneTermRobinBlockEncodingProofRoute_odbsActiveGlobalSlotBlockers n j with
    ⟨hscope, _, _, _, _, _, hwrappedSlot, _, _, _, _, _, hblockCorrect,
      hlcu⟩
  rcases oneTermRobinBlockEncodingProofRoute_activeOdbsGatePairPublicSources n with
    ⟨hforwardSource, hdaggerSource, _, _⟩
  rcases oneTermRobinBlockEncodingProofRoute_activeOdbsGatePairWiring n with
    ⟨_, hforwardMatrix, _, _, hdaggerMatrix, _⟩
  rcases oneTermRobinBlockEncodingProofRoute_blockProjectionNormalizerAudit n with
    ⟨_, _, _, _, hnormalizer, hsignalIndex, _, _, _, _⟩
  rcases oneTermRobinBlockEncodingProofRoute_odbsActiveScopeKeepsFinalFlagsFalse n with
    ⟨_, _, _, _, hcircuitUnitary, _, _, _⟩
  exact ⟨hscope, hwrappedSlot, hforwardSource, hdaggerSource, hforwardMatrix,
    hdaggerMatrix, hnormalizer, hsignalIndex, hcircuitUnitary, hblockCorrect,
    hlcu⟩

/--
The source-gate freeze keeps the projection target and final theorem flags
open under the active global-slot cleanup scope.
-/
theorem oneTermRobinBlockEncodingProofRoute_projectionSourceFreeze
    (n : Nat) :
    (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.normalizer =
        GHL2025.oneTermRobinNormalizer ∧
      (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.signalIndex.val =
        0 ∧
      (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.blockProjection.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.blockCorrect.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).theoremData.obligations.circuitUnitary.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).theoremData.obligations.blockExtraction.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).oracleComposition.lcuCorrect.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).cleanupScopeDecision.semanticCleanupPromotionAllowed =
        false := by
  rcases oneTermRobinBlockEncodingProofRoute_blockProjectionNormalizerAudit n with
    ⟨_, _, _, _, hnormalizer, hsignalIndex, hblockProjection, hblockCorrect, _,
      hlcu⟩
  rcases oneTermRobinBlockEncodingProofRoute_odbsActiveScopeKeepsFinalFlagsFalse n with
    ⟨hpromotion, _, _, _, hcircuitUnitary, hblockExtraction, _, _⟩
  exact ⟨hnormalizer, hsignalIndex, hblockProjection, hblockCorrect,
    hcircuitUnitary, hblockExtraction, hlcu, hpromotion⟩

/--
The old row-dependent collision remains rejected-model regression memory.

The active global-slot image separates the same two boundary columns, so this
theorem must not be used as an active paper-level blocker.
-/
theorem oneTermRobinBlockEncodingProofRoute_rejectedRowDependentCollisionRegression_n3 :
    let p := oneTermParameters 3
    GHL2025.bandedSparseAccessRowDependentPaperImage p 0 =
        GHL2025.bandedSparseAccessRowDependentPaperImage p 48 ∧
      GHL2025.bandedSparseAccessPaperImage p 0 ≠
        GHL2025.bandedSparseAccessPaperImage p 48 ∧
      (GHL2025.oneTermRobinGate_O_D_BS p).matrix
          ⟨96, by native_decide⟩ ⟨0, by native_decide⟩ = Coeff.rat 1 ∧
      (GHL2025.oneTermRobinGate_O_D_BS p).matrix
          ⟨16, by native_decide⟩ ⟨48, by native_decide⟩ = Coeff.rat 1 ∧
      (oneTermRobinBlockEncodingProofRoute 3).cleanupScopeDecision.selectedScope =
        GHL2025.BandedSparseAccessCleanupScope.activeGlobalSource ∧
      (oneTermRobinBlockEncodingProofRoute 3).cleanupScopeDecision.semanticCleanupPromotionAllowed =
        false ∧
      (oneTermRobinBlockEncodingProofRoute 3).sparseAccessContract.daggerCleanup.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute 3).sparseAccessContract.unitaryExtension.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute 3).oracleComposition.lcuCorrect.proved =
        false := by
  native_decide

/--
The theorem route records encoded sparse value `7` as the first out-of-range
clean slot for the one-term `kappa = 7` source domain.

This guard replaces the retired row-dependent unused-branch blocker in the
active route.  The source column is clean, but it is not in
`bandedSparseAccessPaperGlobalSlotSource`, so any broader cleanup theorem must
use a precise full-clean-domain or full-space extension interface.
-/
theorem oneTermRobinBlockEncodingProofRoute_encodedOutOfRangeSparseSlot_n3 :
    let p := oneTermParameters 3
    GHL2025.bandedSparseAccessPaperCleanInput p 112 = true ∧
      (GHL2025.bandedSparseAccessPaperRegisters p 112).sparseIndexValue = 7 ∧
      GHL2025.bandedSparseAccessPaperSparseIndexInKappa p 112 = false ∧
      GHL2025.bandedSparseAccessPaperGlobalSlotSource p 112 = false ∧
      (oneTermRobinBlockEncodingProofRoute 3).cleanupScopeDecision.selectedScope =
        GHL2025.BandedSparseAccessCleanupScope.activeGlobalSource ∧
      (oneTermRobinBlockEncodingProofRoute 3).cleanupScopeDecision.semanticCleanupPromotionAllowed =
        false ∧
      (oneTermRobinBlockEncodingProofRoute 3).sparseAccessContract.daggerCleanup.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute 3).sparseAccessContract.unitaryExtension.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute 3).blockClaim.target.blockCorrect.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute 3).oracleComposition.lcuCorrect.proved =
        false := by
  native_decide

/--
The theorem route carries the active column-8 `O_D^BS` contract-drift guard.

For `n = 3`, source column `8` maps to the Lemma 1 paper-image row `40` in the
route's active `O_D^BS` gate.  The legacy helper still has a row-`4` entry, so
this guard keeps the active/legacy separation visible at the theorem route
without proving injectivity, dagger cleanup, or block correctness.
-/
theorem oneTermRobinBlockEncodingProofRoute_contractDriftColumn8Blocked_n3 :
    let p := oneTermParameters 3
    GHL2025.bandedSparseAccessPaperImage p 8 = 40 ∧
      (((oneTermRobinBlockEncodingProofRoute 3).circuitSemantics.gateMatrices.get
        ⟨3, by
          simp [oneTermRobinBlockEncodingProofRoute, oneTermRobinCircuitSemantics,
            GHL2025.oneTermRobinGateMatrixPlaceholders]⟩).matrix
          ⟨40, by native_decide⟩ ⟨8, by native_decide⟩ = Coeff.rat 1) ∧
      (((oneTermRobinBlockEncodingProofRoute 3).circuitSemantics.gateMatrices.get
        ⟨3, by
          simp [oneTermRobinBlockEncodingProofRoute, oneTermRobinCircuitSemantics,
            GHL2025.oneTermRobinGateMatrixPlaceholders]⟩).matrix
          ⟨4, by native_decide⟩ ⟨8, by native_decide⟩ = Coeff.rat 0) ∧
      (GHL2025.bandedSparseAccessMatrix p)
          ⟨4, by native_decide⟩ ⟨8, by native_decide⟩ = Coeff.rat 1 ∧
      (oneTermRobinBlockEncodingProofRoute 3).cleanupScopeDecision.semanticCleanupPromotionAllowed =
        false ∧
      (oneTermRobinBlockEncodingProofRoute 3).sparseAccessContract.daggerCleanup.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute 3).blockClaim.target.blockCorrect.proved =
        false := by
  native_decide

/--
The theorem-level route uses the default Lemma 1 `O_D^BS` contract object.

This guard prevents a later lower packet from swapping in a different
sparse-access contract while preserving similar-looking field values.  It does
not prove the oracle image, dagger cleanup, or unitary extension.
-/
theorem oneTermRobinBlockEncodingProofRoute_sparseAccessContractIdentity
    (n : Nat) :
    (oneTermRobinBlockEncodingProofRoute n).sparseAccessContract =
        GHL2025.defaultBandedSparseAccessPaperContract (oneTermParameters n) ∧
      (oneTermRobinBlockEncodingProofRoute n).sparseAccessContract.forwardCorrect.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).sparseAccessContract.daggerCleanup.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).sparseAccessContract.unitaryExtension.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).cleanupScopeDecision.semanticCleanupPromotionAllowed =
        false := by
  exact ⟨rfl,
    (oneTermRobinBlockEncodingProofRoute n).sparseAccessForwardOpen,
    (oneTermRobinBlockEncodingProofRoute n).sparseAccessCleanupOpen,
    (oneTermRobinBlockEncodingProofRoute n).sparseAccessUnitaryOpen,
    (oneTermRobinBlockEncodingProofRoute n).cleanupScopeNoSemanticPromotion⟩

/--
The theorem-level route carries the Lemma 1 `O_D^BS` paper contract verbatim.

This is a source-transcript guard.  It pins the padded input/output ket formula
and the register widths while keeping all paper-contract semantic flags false.
-/
theorem oneTermRobinBlockEncodingProofRoute_odbsPaperContractTranscript
    (n : Nat) :
    (oneTermRobinBlockEncodingProofRoute n).sparseAccessContract.sourceAnchor =
        "Guseynov-Huang-Liu 2025, Lemma 1, arXiv:2506.20478" ∧
      (oneTermRobinBlockEncodingProofRoute n).sparseAccessContract.rowRegisterQubits =
        (oneTermParameters n).n ∧
      (oneTermRobinBlockEncodingProofRoute n).sparseAccessContract.paddedZeroQubits =
        (oneTermParameters n).n - clog2 (oneTermParameters n).kappa ∧
      (oneTermRobinBlockEncodingProofRoute n).sparseAccessContract.sparseIndexQubits =
        clog2 (oneTermParameters n).kappa ∧
      (oneTermRobinBlockEncodingProofRoute n).sparseAccessContract.outputAddressQubits =
        (oneTermParameters n).n ∧
      (oneTermRobinBlockEncodingProofRoute n).sparseAccessContract.inputKet =
        "|0>^(n-l)|s>^l|i>^n" ∧
      (oneTermRobinBlockEncodingProofRoute n).sparseAccessContract.outputKet =
        "|r_si>^n|i>^n" ∧
      (oneTermRobinBlockEncodingProofRoute n).sparseAccessContract.imageFormula =
        "r_si = r_s0 + i mod 2^n" ∧
      (oneTermRobinBlockEncodingProofRoute n).sparseAccessContract.cleanInputDomain.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).sparseAccessContract.widthCompatible.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).sparseAccessContract.addressRange.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).sparseAccessContract.noSpill.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).sparseAccessContract.forwardCorrect.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).sparseAccessContract.daggerCleanup.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).sparseAccessContract.unitaryExtension.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).cleanupScopeDecision.selectedPredicate =
        "bandedSparseAccessPaperGlobalSlotSource" := by
  simp [oneTermRobinBlockEncodingProofRoute,
    GHL2025.defaultBandedSparseAccessPaperContract,
    GHL2025.bandedSparseAccessCleanupScopeDecision]


/--
The theorem-level route exposes the active-domain `O_D^BS` dagger-column
indicator.

For the fixed one-term Robin parameters, this guard routes the compiled
global-slot cleanup evidence through `oneTermRobinBlockEncodingProofRoute`.
It is still restricted to rows satisfying
`bandedSparseAccessPaperGlobalSlotSource`, and it keeps every theorem-level
cleanup, unitarity, LCU, projection, and block-correctness flag false.
-/
theorem oneTermRobinBlockEncodingProofRoute_odbsRestrictedDaggerColumnIndicator
    (n : Nat)
    (source : Fin
      (qubitDim (GHL2025.oneTermRobinTotalQubits (oneTermParameters n))))
    (hn : 3 <= n)
    (hsource : GHL2025.bandedSparseAccessPaperGlobalSlotSource
      (oneTermParameters n) source.val = true) :
    ∃ (post pre : Fin
        (qubitDim (GHL2025.oneTermRobinTotalQubits (oneTermParameters n)))),
      GHL2025.BandedSparseAccessPostSwapCleanup
        (oneTermParameters n) source post pre ∧
        post.val =
          (GHL2025.bandedSparseAccessGlobalSlotInverseOnRangeContract
            (oneTermParameters n) source.val).postSwapImageIndex ∧
        pre.val =
          (GHL2025.bandedSparseAccessGlobalSlotInverseOnRangeContract
            (oneTermParameters n) source.val).candidatePreimageIndex ∧
        GHL2025.bandedSparseAccessPaperGlobalSlotSource
          (oneTermParameters n) pre.val = true ∧
        (∀ (other : Fin
          (qubitDim (GHL2025.oneTermRobinTotalQubits (oneTermParameters n)))),
          GHL2025.bandedSparseAccessPaperGlobalSlotSource
            (oneTermParameters n) other.val = true →
          (GHL2025.oneTermRobinGate_O_D_BS_dagger
              (oneTermParameters n)).matrix other post =
            if other.val = pre.val then Coeff.rat 1 else Coeff.rat 0) ∧
        (oneTermRobinBlockEncodingProofRoute n).sparseAccessContract =
          GHL2025.defaultBandedSparseAccessPaperContract
            (oneTermParameters n) ∧
        (oneTermRobinBlockEncodingProofRoute n).sparseAccessContract.daggerCleanup.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).sparseAccessContract.unitaryExtension.proved =
          false ∧
        (GHL2025.oneTermRobinGate_O_D_BS
          (oneTermParameters n)).unitary.proved = false ∧
        (GHL2025.oneTermRobinGate_O_D_BS_dagger
          (oneTermParameters n)).unitary.proved = false ∧
        (oneTermRobinBlockEncodingProofRoute n).theoremData.obligations.circuitUnitary.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).theoremData.obligations.blockExtraction.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.blockProjection.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.blockCorrect.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).oracleComposition.lcuCorrect.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).cleanupScopeDecision.semanticCleanupPromotionAllowed =
          false := by
  rcases
      GHL2025.bandedSparseAccessGlobalSlotInverseOnRangeContract_restrictedDaggerColumnIndicator
        (oneTermParameters n) source hn rfl
        (by
          change clog2 7 = 3
          native_decide)
        hsource
      with
    ⟨post, pre, hcleanup, hpost, hpre, hpreSource, hindicator,
      _hinverseFlag, _huniqueFlag, _himageFlag, _hcontractCleanupFlag,
      _hcontractUnitaryFlag, _hpaperCleanupFlag, _hpaperUnitaryFlag,
      hforwardUnitaryFlag, hdaggerUnitaryFlag, _htheoremCircuitFlag,
      _htheoremBlockFlag⟩
  rcases oneTermRobinBlockEncodingProofRoute_sparseAccessContractIdentity n with
    ⟨hcontractIdentity, _hforwardOpen, hcleanupOpen, hunitaryOpen,
      hpromotion⟩
  rcases oneTermRobinBlockEncodingProofRoute_flags_false n with
    ⟨hblockProjection, hblockCorrect, hblockExtraction, hcircuitUnitary,
      _hrouteSparseCleanup, _hrouteSparseUnitary, _hscope, _hfullClean,
      _hfullSpace, _hroutePromotion, _hfunctionSource, _hfunctionAmp,
      hlcu⟩
  exact ⟨post, pre, hcleanup, hpost, hpre, hpreSource, hindicator,
    hcontractIdentity, hcleanupOpen, hunitaryOpen, hforwardUnitaryFlag,
    hdaggerUnitaryFlag, hcircuitUnitary, hblockExtraction, hblockProjection,
    hblockCorrect, hlcu, hpromotion⟩

/--
The theorem route selects the active global-source domain as the next
`O_D^BS` cleanup theorem scope.

This is a proof-search scope guard, not a cleanup proof.  It connects the route
to the compiled restricted dagger-column indicator and records that full
clean-domain cleanup, full-space unitary extension, LCU correctness, and final
block-correctness obligations remain false.
-/
theorem oneTermRobinBlockEncodingProofRoute_odbsCleanupScopeDecision
    (n : Nat) :
    (GHL2025.bandedSparseAccessCleanupScopeDecision
        (oneTermParameters n)).selectedScope =
        GHL2025.BandedSparseAccessCleanupScope.activeGlobalSource ∧
      (GHL2025.bandedSparseAccessCleanupScopeDecision
        (oneTermParameters n)).selectedPredicate =
        "bandedSparseAccessPaperGlobalSlotSource" ∧
      (GHL2025.bandedSparseAccessCleanupScopeDecision
        (oneTermParameters n)).selectedEvidence =
        "bandedSparseAccessGlobalSlotInverseOnRangeContract_restrictedDaggerColumnIndicator" ∧
      (GHL2025.bandedSparseAccessCleanupScopeDecision
        (oneTermParameters n)).fullCleanDomainSelected = false ∧
      (GHL2025.bandedSparseAccessCleanupScopeDecision
        (oneTermParameters n)).fullSpaceSelected = false ∧
      (GHL2025.bandedSparseAccessCleanupScopeDecision
        (oneTermParameters n)).semanticCleanupPromotionAllowed = false ∧
      (GHL2025.bandedSparseAccessCleanupScopeDecision
        (oneTermParameters n)).paperContractCleanup.proved = false ∧
      (GHL2025.bandedSparseAccessCleanupScopeDecision
        (oneTermParameters n)).fullCleanDomainCleanup.proved = false ∧
      (GHL2025.bandedSparseAccessCleanupScopeDecision
        (oneTermParameters n)).fullSpaceUnitaryExtension.proved = false ∧
      (oneTermRobinBlockEncodingProofRoute n).sparseAccessContract =
        GHL2025.defaultBandedSparseAccessPaperContract
          (oneTermParameters n) ∧
      (oneTermRobinBlockEncodingProofRoute n).sparseAccessContract.daggerCleanup.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).sparseAccessContract.unitaryExtension.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.blockCorrect.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).oracleComposition.lcuCorrect.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).cleanupScopeDecision.semanticCleanupPromotionAllowed =
        false := by
  rcases GHL2025.bandedSparseAccessCleanupScopeDecision_activeGlobalSource
      (oneTermParameters n) with
    ⟨hscope, hpredicate, hevidence, hfullClean, hfullSpace, hpromotion,
      hpaperCleanup, hfullCleanCleanup, hfullSpaceUnitary⟩
  rcases oneTermRobinBlockEncodingProofRoute_sparseAccessContractIdentity n with
    ⟨hcontractIdentity, _hforwardOpen, hcleanupOpen, hunitaryOpen,
      hroutePromotion⟩
  exact ⟨hscope, hpredicate, hevidence, hfullClean, hfullSpace, hpromotion,
    hpaperCleanup, hfullCleanCleanup, hfullSpaceUnitary, hcontractIdentity,
    hcleanupOpen, hunitaryOpen,
    (oneTermRobinBlockEncodingProofRoute n).blockCorrectOpen,
    (oneTermRobinBlockEncodingProofRoute n).lcuOpen, hroutePromotion⟩

/--
The theorem route keeps the full clean-domain `O_D^BS` image-rule slot blocked.

This is a source-contract guard for the scope decision.  The route may use the
active global-source cleanup interface, but the full clean-domain wrapper still
has no unused-branch image rule and cannot promote cleanup, unitarity, LCU, or
block correctness.
-/
theorem oneTermRobinBlockEncodingProofRoute_odbsFullCleanDomainImageRuleBlocked
    (n j : Nat) :
    (GHL2025.bandedSparseAccessCleanupScopeDecision
        (oneTermParameters n)).selectedScope =
        GHL2025.BandedSparseAccessCleanupScope.activeGlobalSource ∧
      (GHL2025.bandedSparseAccessCleanupScopeDecision
        (oneTermParameters n)).fullCleanDomainSelected = false ∧
      (GHL2025.bandedSparseAccessCleanupScopeDecision
        (oneTermParameters n)).semanticCleanupPromotionAllowed = false ∧
      (GHL2025.bandedSparseAccessCleanupScopeDecision
        (oneTermParameters n)).fullCleanDomainCleanup.proved = false ∧
      ((GHL2025.bandedSparseAccessFullCleanDomainExtensionContract
        (oneTermParameters n)).unusedBranchImageRuleContract
        j).proposedImageIndex = none ∧
      ((GHL2025.bandedSparseAccessFullCleanDomainExtensionContract
        (oneTermParameters n)).unusedBranchImageRuleContract
        j).imageSpecified.proved = false ∧
      (GHL2025.bandedSparseAccessFullCleanDomainExtensionContract
        (oneTermParameters n)).unusedBranchImageSpecified.proved = false ∧
      (GHL2025.bandedSparseAccessFullCleanDomainExtensionContract
        (oneTermParameters n)).fullCleanDomainInjective.proved = false ∧
      (GHL2025.bandedSparseAccessFullCleanDomainExtensionContract
        (oneTermParameters n)).daggerCleanup.proved = false ∧
      (GHL2025.bandedSparseAccessFullCleanDomainExtensionContract
        (oneTermParameters n)).unitaryExtension.proved = false ∧
      (oneTermRobinBlockEncodingProofRoute n).cleanupScopeDecision.semanticCleanupPromotionAllowed =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).sparseAccessContract.daggerCleanup.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).sparseAccessContract.unitaryExtension.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.blockCorrect.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).oracleComposition.lcuCorrect.proved =
        false := by
  rcases
      GHL2025.bandedSparseAccessCleanupScopeDecision_fullCleanDomainImageRuleBlocked
        (oneTermParameters n) j
      with
    ⟨hscope, hfullClean, hpromotion, hfullCleanCleanup, _hsourceDecision,
      _hdirectSlot, hwrappedSlot, hwrappedImage, hunusedImage,
      hfullCleanInjective, hwrapperCleanup, hwrapperUnitary⟩
  exact ⟨hscope, hfullClean, hpromotion, hfullCleanCleanup, hwrappedSlot,
    hwrappedImage, hunusedImage, hfullCleanInjective, hwrapperCleanup,
    hwrapperUnitary,
    (oneTermRobinBlockEncodingProofRoute n).cleanupScopeNoSemanticPromotion,
    (oneTermRobinBlockEncodingProofRoute n).sparseAccessCleanupOpen,
    (oneTermRobinBlockEncodingProofRoute n).sparseAccessUnitaryOpen,
    (oneTermRobinBlockEncodingProofRoute n).blockCorrectOpen,
    (oneTermRobinBlockEncodingProofRoute n).lcuOpen⟩

/--
The theorem-level route exposes the selected active global-source cleanup
interface for `O_D^BS`.

This is only an interface wrapper around the compiled active-domain dagger
column and the cleanup-scope decision.  It does not promote `daggerCleanup`,
unitarity, LCU correctness, block projection, block correctness, or final
block extraction.
-/
theorem oneTermRobinBlockEncodingProofRoute_odbsActiveGlobalSourceCleanupInterface
    (n : Nat)
    (source : Fin
      (qubitDim (GHL2025.oneTermRobinTotalQubits (oneTermParameters n))))
    (hn : 3 <= n)
    (hsource : GHL2025.bandedSparseAccessPaperGlobalSlotSource
      (oneTermParameters n) source.val = true) :
    ∃ (post pre : Fin
        (qubitDim (GHL2025.oneTermRobinTotalQubits (oneTermParameters n)))),
      GHL2025.BandedSparseAccessPostSwapCleanup
        (oneTermParameters n) source post pre ∧
        post.val =
          (GHL2025.bandedSparseAccessGlobalSlotInverseOnRangeContract
            (oneTermParameters n) source.val).postSwapImageIndex ∧
        pre.val =
          (GHL2025.bandedSparseAccessGlobalSlotInverseOnRangeContract
            (oneTermParameters n) source.val).candidatePreimageIndex ∧
        GHL2025.bandedSparseAccessPaperGlobalSlotSource
          (oneTermParameters n) pre.val = true ∧
        (∀ (other : Fin
          (qubitDim (GHL2025.oneTermRobinTotalQubits (oneTermParameters n)))),
          GHL2025.bandedSparseAccessPaperGlobalSlotSource
            (oneTermParameters n) other.val = true →
          (GHL2025.oneTermRobinGate_O_D_BS_dagger
              (oneTermParameters n)).matrix other post =
            if other.val = pre.val then Coeff.rat 1 else Coeff.rat 0) ∧
        (GHL2025.bandedSparseAccessCleanupScopeDecision
          (oneTermParameters n)).selectedScope =
          GHL2025.BandedSparseAccessCleanupScope.activeGlobalSource ∧
        (GHL2025.bandedSparseAccessCleanupScopeDecision
          (oneTermParameters n)).selectedPredicate =
          "bandedSparseAccessPaperGlobalSlotSource" ∧
        (GHL2025.bandedSparseAccessCleanupScopeDecision
          (oneTermParameters n)).selectedEvidence =
          "bandedSparseAccessGlobalSlotInverseOnRangeContract_restrictedDaggerColumnIndicator" ∧
        (GHL2025.bandedSparseAccessCleanupScopeDecision
          (oneTermParameters n)).semanticCleanupPromotionAllowed = false ∧
        (GHL2025.bandedSparseAccessCleanupScopeDecision
          (oneTermParameters n)).fullCleanDomainSelected = false ∧
        (GHL2025.bandedSparseAccessCleanupScopeDecision
          (oneTermParameters n)).fullSpaceSelected = false ∧
        (oneTermRobinBlockEncodingProofRoute n).sparseAccessContract.daggerCleanup.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).sparseAccessContract.unitaryExtension.proved =
          false ∧
        (GHL2025.oneTermRobinGate_O_D_BS
          (oneTermParameters n)).unitary.proved = false ∧
        (GHL2025.oneTermRobinGate_O_D_BS_dagger
          (oneTermParameters n)).unitary.proved = false ∧
        (oneTermRobinBlockEncodingProofRoute n).theoremData.obligations.circuitUnitary.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).theoremData.obligations.blockExtraction.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.blockProjection.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.blockCorrect.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).oracleComposition.lcuCorrect.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).cleanupScopeDecision.semanticCleanupPromotionAllowed =
          false := by
  rcases
      oneTermRobinBlockEncodingProofRoute_odbsRestrictedDaggerColumnIndicator
        n source hn hsource
      with
    ⟨post, pre, hcleanup, hpost, hpre, hpreSource, hindicator,
      _hcontractIdentity, hcleanupOpen, hunitaryOpen, hforwardUnitaryFlag,
      hdaggerUnitaryFlag, hcircuitUnitary, hblockExtraction,
      hblockProjection, hblockCorrect, hlcu, hroutePromotion⟩
  rcases oneTermRobinBlockEncodingProofRoute_odbsCleanupScopeDecision n with
    ⟨hscope, hpredicate, hevidence, hfullClean, hfullSpace, hpromotion,
      _hpaperCleanup, _hfullCleanCleanup, _hfullSpaceUnitary,
      _hcontractIdentity, _hcleanupOpen, _hunitaryOpen, _hblockCorrect,
      _hlcu, _hroutePromotion⟩
  exact ⟨post, pre, hcleanup, hpost, hpre, hpreSource, hindicator, hscope,
    hpredicate, hevidence, hpromotion, hfullClean, hfullSpace, hcleanupOpen,
    hunitaryOpen, hforwardUnitaryFlag, hdaggerUnitaryFlag, hcircuitUnitary,
    hblockExtraction, hblockProjection, hblockCorrect, hlcu, hroutePromotion⟩

/--
The theorem-level route exposes the active global-source cleanup contract map.

This guard packages the current proof-DAG block for post-SWAP inverse evidence:
the named candidate is an active global-source preimage of the post-SWAP target,
it is unique among active global-source rows, and the transpose-style dagger
entry is `1`.  The statement is still restricted to
`bandedSparseAccessPaperGlobalSlotSource`; it does not promote paper-contract
cleanup, full clean-domain cleanup, full-space unitarity, LCU correctness, or
block extraction.
-/
theorem oneTermRobinBlockEncodingProofRoute_odbsActiveGlobalSourceCleanupContractMap
    (n : Nat)
    (source : Fin
      (qubitDim (GHL2025.oneTermRobinTotalQubits (oneTermParameters n))))
    (hn : 3 <= n)
    (hsource : GHL2025.bandedSparseAccessPaperGlobalSlotSource
      (oneTermParameters n) source.val = true) :
    ∃ (post pre : Fin
        (qubitDim (GHL2025.oneTermRobinTotalQubits (oneTermParameters n)))),
      GHL2025.BandedSparseAccessPostSwapCleanup
        (oneTermParameters n) source post pre ∧
        post.val =
          (GHL2025.bandedSparseAccessGlobalSlotInverseOnRangeContract
            (oneTermParameters n) source.val).postSwapImageIndex ∧
        pre.val =
          (GHL2025.bandedSparseAccessGlobalSlotInverseOnRangeContract
            (oneTermParameters n) source.val).candidatePreimageIndex ∧
        GHL2025.bandedSparseAccessPaperGlobalSlotSource
          (oneTermParameters n) pre.val = true ∧
        (∀ (pre' : Fin
          (qubitDim (GHL2025.oneTermRobinTotalQubits (oneTermParameters n)))),
          GHL2025.bandedSparseAccessPaperGlobalSlotSource
            (oneTermParameters n) pre'.val = true →
          GHL2025.bandedSparseAccessPaperImage
              (oneTermParameters n) pre'.val = post.val →
          pre'.val = pre.val) ∧
        (GHL2025.oneTermRobinGate_O_D_BS_dagger
          (oneTermParameters n)).matrix pre post = Coeff.rat 1 ∧
        (GHL2025.bandedSparseAccessGlobalSlotInverseOnRangeContract
            (oneTermParameters n) source.val).inverseOnRange.proved =
          false ∧
        (GHL2025.bandedSparseAccessGlobalSlotInverseOnRangeContract
            (oneTermParameters n) source.val).uniquePreimage.proved =
          false ∧
        (GHL2025.bandedSparseAccessGlobalSlotInverseOnRangeContract
            (oneTermParameters n) source.val).imageInjectiveOnGlobalSource.proved =
          false ∧
        (GHL2025.bandedSparseAccessGlobalSlotInverseOnRangeContract
            (oneTermParameters n) source.val).daggerCleanup.proved =
          false ∧
        (GHL2025.bandedSparseAccessGlobalSlotInverseOnRangeContract
            (oneTermParameters n) source.val).unitaryExtension.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).cleanupScopeDecision.selectedScope =
          GHL2025.BandedSparseAccessCleanupScope.activeGlobalSource ∧
        (oneTermRobinBlockEncodingProofRoute n).cleanupScopeDecision.semanticCleanupPromotionAllowed =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).sparseAccessContract.daggerCleanup.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).sparseAccessContract.unitaryExtension.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).oracleComposition.lcuCorrect.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.blockProjection.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.blockCorrect.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).theoremData.obligations.circuitUnitary.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).theoremData.obligations.blockExtraction.proved =
          false := by
  rcases
      GHL2025.bandedSparseAccessGlobalSlotInverseOnRangeContract_cleanupContractMap
        (oneTermParameters n) source hn rfl
        (by
          change clog2 7 = 3
          native_decide)
        hsource
      with
    ⟨post, pre, hcleanup, hpost, hpre, hpreSource, hunique, hentry,
      _hchecks, hinverseFlag, huniqueFlag, himageFlag, hdaggerFlag,
      hunitaryFlag⟩
  rcases oneTermRobinBlockEncodingProofRoute_odbsCleanupScopeDecision n with
    ⟨hscope, _hpredicate, _hevidence, _hfullClean, _hfullSpace, hpromotion,
      _hpaperCleanup, _hfullCleanCleanup, _hfullSpaceUnitary,
      _hcontractIdentity, hcleanupOpen, hunitaryOpen, hblockCorrect, hlcu,
      _hroutePromotion⟩
  rcases oneTermRobinBlockEncodingProofRoute_flags_false n with
    ⟨hblockProjection, _hblockCorrectRoute, hblockExtraction, hcircuitUnitary,
      _hrouteSparseCleanup, _hrouteSparseUnitary, _hscope, _hfullCleanRoute,
      _hfullSpaceRoute, _hpromotionRoute, _hfunctionSource, _hfunctionAmp,
      _hlcuRoute⟩
  exact ⟨post, pre, hcleanup, hpost, hpre, hpreSource, hunique, hentry,
    hinverseFlag, huniqueFlag, himageFlag, hdaggerFlag, hunitaryFlag, hscope,
    hpromotion, hcleanupOpen, hunitaryOpen, hlcu, hblockProjection,
    hblockCorrect, hcircuitUnitary, hblockExtraction⟩

/--
The theorem route exposes the source transcript dependencies for Theorem
`1 term robin`.

This is a guard-only Phase 1 declaration.  It ties the theorem source anchor,
normalizer, gate order, active `O_D^BS` global-source scope, `O_f` external
source, signal-index-zero target, and current false proof flags into one
reviewer-facing checkpoint.  It does not prove cleanup, unitarity, LCU
correctness, block projection, block correctness, or final block extraction.
-/
theorem oneTermRobinBlockEncodingProofRoute_theoremTranscriptDependencies
    (n : Nat) :
    (oneTermRobinBlockEncodingProofRoute n).sourceAnchor =
        "Guseynov-Huang-Liu 2025, Theorem one-term block-encoding, Fig. 1-term Robin, arXiv:2506.20478" ∧
      (oneTermRobinBlockEncodingProofRoute n).theoremData.alpha =
        (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.normalizer ∧
      (oneTermRobinBlockEncodingProofRoute n).theoremData.alpha =
        GHL2025.oneTermRobinNormalizer ∧
      (oneTermRobinBlockEncodingProofRoute n).circuitSemantics.gateMatrices.map
        (fun gateMatrix => gateMatrix.gate) =
        GHL2025.oneTermRobinCircuit ∧
      (oneTermRobinBlockEncodingProofRoute n).circuitSemantics.gateMatrices.map
        (fun gateMatrix => gateMatrix.unitary.proved) =
        [true, false, false, false, false, true, false] ∧
      (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.signalIndex.val =
        0 ∧
      (oneTermRobinBlockEncodingProofRoute n).sparseAccessContract.sourceAnchor =
        "Guseynov-Huang-Liu 2025, Lemma 1, arXiv:2506.20478" ∧
      (oneTermRobinBlockEncodingProofRoute n).sparseAccessContract.imageFormula =
        "r_si = r_s0 + i mod 2^n" ∧
      (oneTermRobinBlockEncodingProofRoute n).cleanupScopeDecision.selectedScope =
        GHL2025.BandedSparseAccessCleanupScope.activeGlobalSource ∧
      (oneTermRobinBlockEncodingProofRoute n).cleanupScopeDecision.selectedPredicate =
        "bandedSparseAccessPaperGlobalSlotSource" ∧
      (oneTermRobinBlockEncodingProofRoute n).cleanupScopeDecision.semanticCleanupPromotionAllowed =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).cleanupScopeDecision.fullCleanDomainSelected =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).cleanupScopeDecision.fullSpaceSelected =
        false ∧
      ((GHL2025.bandedSparseAccessFullCleanDomainExtensionContract
        (oneTermParameters n)).unusedBranchImageRuleContract
        0).proposedImageIndex = none ∧
      (GHL2025.bandedSparseAccessFullCleanDomainExtensionContract
        (oneTermParameters n)).daggerCleanup.proved = false ∧
      (GHL2025.bandedSparseAccessFullCleanDomainExtensionContract
        (oneTermParameters n)).unitaryExtension.proved = false ∧
      (oneTermRobinBlockEncodingProofRoute n).functionOracleSource =
        GHL2025.functionOracleExternalAmplitudeSourceContract ∧
      (oneTermRobinBlockEncodingProofRoute n).functionOracleSource.closesFunctionOracleContract =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).sparseAccessContract.daggerCleanup.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).sparseAccessContract.unitaryExtension.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).oracleComposition.functionOracle.amplitudeCorrect.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).oracleComposition.lcuCorrect.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).theoremData.obligations.circuitUnitary.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.blockProjection.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.blockCorrect.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).theoremData.obligations.blockExtraction.proved =
        false := by
  rcases oneTermRobinBlockEncodingProofRoute_gateProjectionFreeze n with
    ⟨hgateList, hflags, htargetNormalizer, hsignalIndex, hblockProjection,
      hblockCorrect, hcircuitUnitary, hblockExtraction, hlcu,
      _hprojectionPromotion⟩
  rcases oneTermRobinBlockEncodingProofRoute_flags_false n with
    ⟨_hblockProjectionRoute, _hblockCorrectRoute, _hblockExtractionRoute,
      _hcircuitUnitaryRoute, _hcleanupRoute, _hunitaryRoute, _hscopeRoute,
      _hfullCleanRoute, _hfullSpaceRoute, _hpromotionRoute,
      hfunctionSourceOpen, hfunctionAmp, _hlcuRoute⟩
  rcases oneTermRobinBlockEncodingProofRoute_odbsActiveGlobalSlotBlockers
      n 0 with
    ⟨hscope, hpredicate, _hevidence, hfullClean, hfullSpace, hpromotion,
      hwrappedSlot, _hwrappedImage, hfullCleanCleanup, hfullCleanUnitary,
      hcleanup, hunitary, _hblockCorrectOdbs, _hlcuOdbs⟩
  rcases oneTermRobinBlockEncodingProofRoute_odbsPaperContractTranscript n with
    ⟨hodbsSource, _hrowQubits, _hpaddedZero, _hsparseQubits, _houtputQubits,
      _hinputKet, _houtputKet, himageFormula, _hcleanInput, _hwidth,
      _haddressRange, _hnoSpill, _hforward, _hcleanupContract,
      _hunitaryContract, _hpredicateTranscript⟩
  rcases oneTermRobinBlockEncodingProofRoute_ofExternalSourceAndFlags n 0 with
    ⟨hfunctionSource, _⟩
  have htheoremNormalizer :
      (oneTermRobinBlockEncodingProofRoute n).theoremData.alpha =
        GHL2025.oneTermRobinNormalizer := by
    calc
      (oneTermRobinBlockEncodingProofRoute n).theoremData.alpha =
          (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.normalizer :=
        (oneTermRobinBlockEncodingProofRoute n).theoremNormalizerMatchesTarget
      _ = GHL2025.oneTermRobinNormalizer := htargetNormalizer
  exact ⟨rfl,
    (oneTermRobinBlockEncodingProofRoute n).theoremNormalizerMatchesTarget,
    htheoremNormalizer, hgateList, hflags, hsignalIndex, hodbsSource,
    himageFormula, hscope, hpredicate, hpromotion, hfullClean, hfullSpace,
    hwrappedSlot, hfullCleanCleanup, hfullCleanUnitary, hfunctionSource,
    hfunctionSourceOpen, hcleanup, hunitary, hfunctionAmp, hlcu,
    hcircuitUnitary, hblockProjection, hblockCorrect, hblockExtraction⟩

/--
The theorem transcript consumes the active global-source cleanup map.

This is the next guard-only proof-DAG bridge after the cleanup contract map:
it exposes the active-source post-SWAP preimage data while also pinning the
one-term theorem source, normalizer, circuit order, sparse-access formula, and
`O_f` source transcript.  The bridge remains restricted to
`bandedSparseAccessPaperGlobalSlotSource` and does not promote semantic
cleanup, unitarity, LCU correctness, block projection, block correctness, or
final block extraction.
-/
theorem oneTermRobinBlockEncodingProofRoute_theoremTranscriptActiveCleanupMap
    (n : Nat)
    (source : Fin
      (qubitDim (GHL2025.oneTermRobinTotalQubits (oneTermParameters n))))
    (hn : 3 <= n)
    (hsource : GHL2025.bandedSparseAccessPaperGlobalSlotSource
      (oneTermParameters n) source.val = true) :
    ∃ (post pre : Fin
        (qubitDim (GHL2025.oneTermRobinTotalQubits (oneTermParameters n)))),
      GHL2025.BandedSparseAccessPostSwapCleanup
        (oneTermParameters n) source post pre ∧
        post.val =
          (GHL2025.bandedSparseAccessGlobalSlotInverseOnRangeContract
            (oneTermParameters n) source.val).postSwapImageIndex ∧
        pre.val =
          (GHL2025.bandedSparseAccessGlobalSlotInverseOnRangeContract
            (oneTermParameters n) source.val).candidatePreimageIndex ∧
        GHL2025.bandedSparseAccessPaperGlobalSlotSource
          (oneTermParameters n) pre.val = true ∧
        (∀ (pre' : Fin
          (qubitDim (GHL2025.oneTermRobinTotalQubits (oneTermParameters n)))),
          GHL2025.bandedSparseAccessPaperGlobalSlotSource
            (oneTermParameters n) pre'.val = true →
          GHL2025.bandedSparseAccessPaperImage
              (oneTermParameters n) pre'.val = post.val →
          pre'.val = pre.val) ∧
        (GHL2025.oneTermRobinGate_O_D_BS_dagger
          (oneTermParameters n)).matrix pre post = Coeff.rat 1 ∧
        (oneTermRobinBlockEncodingProofRoute n).sourceAnchor =
          "Guseynov-Huang-Liu 2025, Theorem one-term block-encoding, Fig. 1-term Robin, arXiv:2506.20478" ∧
        (oneTermRobinBlockEncodingProofRoute n).theoremData.alpha =
          GHL2025.oneTermRobinNormalizer ∧
        (oneTermRobinBlockEncodingProofRoute n).circuitSemantics.gateMatrices.map
          (fun gateMatrix => gateMatrix.gate) =
          GHL2025.oneTermRobinCircuit ∧
        (oneTermRobinBlockEncodingProofRoute n).sparseAccessContract.imageFormula =
          "r_si = r_s0 + i mod 2^n" ∧
        (oneTermRobinBlockEncodingProofRoute n).cleanupScopeDecision.selectedScope =
          GHL2025.BandedSparseAccessCleanupScope.activeGlobalSource ∧
        (oneTermRobinBlockEncodingProofRoute n).cleanupScopeDecision.selectedPredicate =
          "bandedSparseAccessPaperGlobalSlotSource" ∧
        (oneTermRobinBlockEncodingProofRoute n).functionOracleSource =
          GHL2025.functionOracleExternalAmplitudeSourceContract ∧
        (oneTermRobinBlockEncodingProofRoute n).sparseAccessContract.daggerCleanup.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).sparseAccessContract.unitaryExtension.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).oracleComposition.functionOracle.amplitudeCorrect.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).oracleComposition.lcuCorrect.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).theoremData.obligations.circuitUnitary.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.blockProjection.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.blockCorrect.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).theoremData.obligations.blockExtraction.proved =
          false := by
  rcases
      oneTermRobinBlockEncodingProofRoute_odbsActiveGlobalSourceCleanupContractMap
        n source hn hsource
      with
    ⟨post, pre, hcleanup, hpost, hpre, hpreSource, hunique, hentry,
      _hinverseFlag, _huniqueFlag, _himageFlag, _hdaggerFlag, _hunitaryFlag,
      _hscopeCleanup, _hpromotionCleanup, hcleanupOpen, hunitaryOpen,
      hlcu, hblockProjection, hblockCorrect, hcircuitUnitary,
      hblockExtraction⟩
  rcases oneTermRobinBlockEncodingProofRoute_theoremTranscriptDependencies n with
    ⟨hsourceAnchor, _hnormalizerMatches, hnormalizer, hgateList, _hflags,
      _hsignalIndex, _hodbsSource, himageFormula, hscope, hpredicate,
      _hpromotion, _hfullClean, _hfullSpace, _hwrappedSlot,
      _hfullCleanCleanup, _hfullCleanUnitary, hfunctionSource,
      _hfunctionOpen, _hcleanupTranscript, _hunitaryTranscript,
      hfunctionAmp, _hlcuTranscript, _hcircuitUnitaryTranscript,
      _hblockProjectionTranscript, _hblockCorrectTranscript,
      _hblockExtractionTranscript⟩
  exact ⟨post, pre, hcleanup, hpost, hpre, hpreSource, hunique, hentry,
    hsourceAnchor, hnormalizer, hgateList, himageFormula, hscope, hpredicate,
    hfunctionSource, hcleanupOpen, hunitaryOpen, hfunctionAmp, hlcu,
    hcircuitUnitary, hblockProjection, hblockCorrect, hblockExtraction⟩

/--
The theorem transcript exposes the Eq. ROBIN clarified gamma decomposition.

This guard ties `defaultRobinWavefunctionDecomposition` to the one-term theorem
route, the active global-source cleanup map, and the external `O_f` source
record.  It records the three gamma normalizers and keeps the final semantic
flags false; it is not a block-extraction proof.
-/
theorem oneTermRobinBlockEncodingProofRoute_robinClarifiedGammaTranscript
    (n : Nat)
    (source : Fin
      (qubitDim (GHL2025.oneTermRobinTotalQubits (oneTermParameters n))))
    (hn : 3 <= n)
    (hsource : GHL2025.bandedSparseAccessPaperGlobalSlotSource
      (oneTermParameters n) source.val = true) :
    let gamma := GHL2025.defaultRobinWavefunctionDecomposition
      (oneTermParameters n)
    ∃ (post pre : Fin
        (qubitDim (GHL2025.oneTermRobinTotalQubits (oneTermParameters n)))),
      GHL2025.BandedSparseAccessPostSwapCleanup
        (oneTermParameters n) source post pre ∧
        gamma.kappa = (oneTermParameters n).kappa ∧
        gamma.K1 = 2 ∧
        gamma.K2 = gridSize n - 3 ∧
        gamma.gridSize = gridSize n ∧
        gamma.gamma1.kappa = gamma.kappa ∧
        gamma.gamma1.K1 = gamma.K1 ∧
        gamma.gamma1.K2 = gamma.K2 ∧
        gamma.gamma1.gridSize = gamma.gridSize ∧
        gamma.gamma1.boundaryNormalizer =
          Coeff.mul (Coeff.symbol "N_D") (Coeff.symbol "sqrt(kappa)") ∧
        gamma.gamma1.bulkNormalizer = Coeff.symbol "sqrt(kappa)" ∧
        gamma.gamma2.kappa = gamma.kappa ∧
        gamma.gamma2.normalizer =
          Coeff.mul (Coeff.symbol "N_D") (Coeff.symbol "sqrt(kappa)") ∧
        gamma.gamma2.hasOrthogonalRemainder = true ∧
        gamma.gamma3.kappa = gamma.kappa ∧
        gamma.gamma3.normalizer = GHL2025.oneTermRobinNormalizer ∧
        gamma.gamma3.hasOrthogonalRemainder = true ∧
        gamma.gamma3.pureAncillaQubits =
          n - clog2 (oneTermParameters n).kappa + 1 ∧
        (oneTermRobinBlockEncodingProofRoute n).theoremData.alpha =
          gamma.gamma3.normalizer ∧
        (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.normalizer =
          gamma.gamma3.normalizer ∧
        (oneTermRobinBlockEncodingProofRoute n).functionOracleSource =
          GHL2025.functionOracleExternalAmplitudeSourceContract ∧
        (oneTermRobinBlockEncodingProofRoute n).cleanupScopeDecision.selectedScope =
          GHL2025.BandedSparseAccessCleanupScope.activeGlobalSource ∧
        (oneTermRobinBlockEncodingProofRoute n).sparseAccessContract.daggerCleanup.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).sparseAccessContract.unitaryExtension.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).oracleComposition.functionOracle.amplitudeCorrect.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).oracleComposition.lcuCorrect.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).theoremData.obligations.circuitUnitary.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.blockProjection.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.blockCorrect.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).theoremData.obligations.blockExtraction.proved =
          false := by
  rcases
      oneTermRobinBlockEncodingProofRoute_theoremTranscriptActiveCleanupMap
        n source hn hsource
      with
    ⟨post, pre, hcleanup, _hpost, _hpre, _hpreSource, _hunique, _hentry,
      _hsourceAnchor, htheoremNormalizer, _hgateList, _himageFormula, hscope,
      _hpredicate, hfunctionSource, hcleanupOpen, hunitaryOpen, hfunctionAmp,
      hlcu, hcircuitUnitary, hblockProjection, hblockCorrect,
      hblockExtraction⟩
  have htargetNormalizer :
      (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.normalizer =
        (GHL2025.defaultRobinWavefunctionDecomposition
          (oneTermParameters n)).gamma3.normalizer := by
    calc
      (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.normalizer =
          GHL2025.oneTermRobinNormalizer := by
            rw [(oneTermRobinBlockEncodingProofRoute n).claimUsesTarget]
            rfl
      _ =
          (GHL2025.defaultRobinWavefunctionDecomposition
            (oneTermParameters n)).gamma3.normalizer := rfl
  exact ⟨post, pre, hcleanup, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl,
    rfl, rfl, rfl, rfl, rfl, rfl, htheoremNormalizer, rfl, rfl,
    htheoremNormalizer, htargetNormalizer, hfunctionSource, hscope,
    hcleanupOpen, hunitaryOpen, hfunctionAmp, hlcu, hcircuitUnitary,
    hblockProjection, hblockCorrect, hblockExtraction⟩

/--
The theorem transcript exposes the dependency map for the final block
projection.

This is a contract-only Phase 1 map.  It packages the Eq. ROBIN gamma
transcript, active-source `O_D^BS` cleanup evidence, the `CircuitBlockEncodingClaim`
projection target, the full clean-domain blocker, and the external `O_f`
source contract.  It does not prove the signal block equation or promote LCU,
cleanup, unitarity, projection, block-correctness, or final extraction flags.
-/
theorem oneTermRobinBlockEncodingProofRoute_blockProjectionDependencyMap
    (n : Nat)
    (source : Fin
      (qubitDim (GHL2025.oneTermRobinTotalQubits (oneTermParameters n))))
    (hn : 3 <= n)
    (hsource : GHL2025.bandedSparseAccessPaperGlobalSlotSource
      (oneTermParameters n) source.val = true)
    (i j : Fin (gridSize n)) :
    let gamma := GHL2025.defaultRobinWavefunctionDecomposition
      (oneTermParameters n)
    ∃ (post pre : Fin
        (qubitDim (GHL2025.oneTermRobinTotalQubits (oneTermParameters n)))),
      GHL2025.BandedSparseAccessPostSwapCleanup
        (oneTermParameters n) source post pre ∧
        (oneTermRobinBlockEncodingProofRoute n).blockClaim =
          defaultOneTermRobinCircuitBlockClaim n ∧
        (oneTermRobinBlockEncodingProofRoute n).blockClaim.semantics =
          (oneTermRobinBlockEncodingProofRoute n).circuitSemantics ∧
        (oneTermRobinBlockEncodingProofRoute n).blockClaim.target =
          oneTermRobinBlockExtractionTarget n ∧
        (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.blockMatrix =
          signalSystemBlockProjection
            (qubitDim (GHL2025.effectiveRobinSignalQubits
              (oneTermParameters n)))
            (gridSize n)
            (gridSize n)
            (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.unitaryMatrix
            (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.signalIndex ∧
        signalSystemBlockRowIndex (gridSize n)
          (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.signalIndex.val
          i.val = i.val ∧
        signalSystemBlockColIndex (gridSize n)
          (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.signalIndex.val
          j.val = j.val ∧
        (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.normalizer =
          gamma.gamma3.normalizer ∧
        (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.targetMatrix =
          oneTermRobinAkMatrix n ∧
        (oneTermRobinBlockEncodingProofRoute n).functionOracleSource =
          GHL2025.functionOracleExternalAmplitudeSourceContract ∧
        GHL2025.functionOracleExternalAmplitudeSourceContract.closesFunctionOracleContract =
          false ∧
        ((GHL2025.bandedSparseAccessFullCleanDomainExtensionContract
          (oneTermParameters n)).unusedBranchImageRuleContract
          source.val).proposedImageIndex = none ∧
        (GHL2025.bandedSparseAccessFullCleanDomainExtensionContract
          (oneTermParameters n)).daggerCleanup.proved = false ∧
        (GHL2025.bandedSparseAccessFullCleanDomainExtensionContract
          (oneTermParameters n)).unitaryExtension.proved = false ∧
        (oneTermRobinBlockEncodingProofRoute n).cleanupScopeDecision.selectedScope =
          GHL2025.BandedSparseAccessCleanupScope.activeGlobalSource ∧
        (oneTermRobinBlockEncodingProofRoute n).sparseAccessContract.daggerCleanup.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).sparseAccessContract.unitaryExtension.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).oracleComposition.functionOracle.amplitudeCorrect.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).oracleComposition.lcuCorrect.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).theoremData.obligations.circuitUnitary.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).blockClaim.blockCorrect.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.blockProjection.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.blockCorrect.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).theoremData.obligations.blockExtraction.proved =
          false := by
  rcases
      oneTermRobinBlockEncodingProofRoute_robinClarifiedGammaTranscript
        n source hn hsource
      with
    ⟨post, pre, hcleanup, _hkappa, _hK1, _hK2, _hgrid, _hg1Kappa,
      _hg1K1, _hg1K2, _hg1Grid, _hg1Boundary, _hg1Bulk, _hg2Kappa,
      _hg2Normalizer, _hg2Orthogonal, _hg3Kappa, _hg3Normalizer,
      _hg3Orthogonal, _hg3Ancilla, _hrouteAlpha, htargetNormalizer,
      hfunctionSource, hscope, hcleanupOpen, hunitaryOpen, hfunctionAmp,
      hlcu, hcircuitUnitary, hblockProjection, hblockCorrect,
      hblockExtraction⟩
  rcases oneTermRobinBlockEncodingProofRoute_blockProjectionNormalizerAudit n with
    ⟨htarget, _hunitaryMatrix, hblockMatrix, htargetMatrix, _hnormalizer,
      _hsignalIndex, _hblockProjectionAudit, _hblockCorrectAudit,
      _hcleanupAudit, _hlcuAudit⟩
  rcases oneTermRobinBlockEncodingProofRoute_claimBlockCorrectFalse n with
    ⟨hclaimBlockCorrect, _hclaimProjection, _hclaimTargetCorrect⟩
  rcases oneTermRobinBlockEncodingProofRoute_signalZeroBlockIndices n i j with
    ⟨hrow, hcol⟩
  rcases
      GHL2025.bandedSparseAccessFullCleanDomainExtensionContract_flags_false
        (oneTermParameters n) source.val
      with
    ⟨_hcleanSplit, _hvalidAgreement, _hunusedSpecified, _hunusedFinite,
      _hunusedInjective, _hfullInjective, hfullCleanup, hfullUnitary,
      hwrappedSlot, _hwrappedImage, _hwrappedFinite⟩
  rcases GHL2025.functionOracleExternalAmplitudeSourceContract_flags_false with
    ⟨_hresource, _hexternalTheorem, _hnonzero, _hdivision,
      _htheoremAmplitude, _hbound, _horthogonal, _hunitaryCompletion,
      hfunctionCloses⟩
  have hclaim :
      (oneTermRobinBlockEncodingProofRoute n).blockClaim =
        defaultOneTermRobinCircuitBlockClaim n := rfl
  exact ⟨post, pre, hcleanup, hclaim,
    (oneTermRobinBlockEncodingProofRoute n).claimUsesSemantics, htarget,
    hblockMatrix, hrow, hcol, htargetNormalizer, htargetMatrix,
    hfunctionSource, hfunctionCloses, hwrappedSlot, hfullCleanup,
    hfullUnitary, hscope, hcleanupOpen, hunitaryOpen, hfunctionAmp, hlcu,
    hcircuitUnitary, hclaimBlockCorrect, hblockProjection, hblockCorrect,
    hblockExtraction⟩

/--
The theorem route exposes one ledger for all Fig. 1-term Robin gate contracts.

This is a guard-only aggregation step for Phase 1.  It consumes the compiled
`O_DT^S`/`Ry_boundary` bridge, the active-source `O_D^BS` cleanup map, and the
external `O_f` source transcript.  It freezes the seven gate slots and keeps
all paper-oracle, LCU, projection, and final block-extraction flags false.
-/
theorem oneTermRobinBlockEncodingProofRoute_fullGateContractLedger
    (n row sparse ofColumn : Nat)
    (source : Fin
      (qubitDim (GHL2025.oneTermRobinTotalQubits (oneTermParameters n))))
    (hn : 3 <= n)
    (hsource : GHL2025.bandedSparseAccessPaperGlobalSlotSource
      (oneTermParameters n) source.val = true) :
    ∃ (post pre : Fin
        (qubitDim (GHL2025.oneTermRobinTotalQubits (oneTermParameters n)))),
      GHL2025.BandedSparseAccessPostSwapCleanup
        (oneTermParameters n) source post pre ∧
        (oneTermRobinBlockEncodingProofRoute n).sourceAnchor =
          "Guseynov-Huang-Liu 2025, Theorem one-term block-encoding, Fig. 1-term Robin, arXiv:2506.20478" ∧
        (oneTermRobinBlockEncodingProofRoute n).theoremData.alpha =
          GHL2025.oneTermRobinNormalizer ∧
        (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.normalizer =
          GHL2025.oneTermRobinNormalizer ∧
        (oneTermRobinBlockEncodingProofRoute n).circuitSemantics.gateMatrices.map
          (fun gateMatrix => gateMatrix.gate) =
          GHL2025.oneTermRobinCircuit ∧
        (oneTermRobinBlockEncodingProofRoute n).circuitSemantics.gateMatrices.map
          (fun gateMatrix => gateMatrix.unitary.proved) =
          [true, false, false, false, false, true, false] ∧
        (((oneTermRobinBlockEncodingProofRoute n).circuitSemantics.gateMatrices.get
          ⟨0, by
            simp [oneTermRobinBlockEncodingProofRoute, oneTermRobinCircuitSemantics,
              GHL2025.oneTermRobinGateMatrixPlaceholders]⟩).gate =
          Gate.oracleCall "U_indic") ∧
        (((oneTermRobinBlockEncodingProofRoute n).circuitSemantics.gateMatrices.get
          ⟨0, by
            simp [oneTermRobinBlockEncodingProofRoute, oneTermRobinCircuitSemantics,
              GHL2025.oneTermRobinGateMatrixPlaceholders]⟩).matrix =
          GHL2025.indicatorOracleMatrix (oneTermParameters n)) ∧
        (((oneTermRobinBlockEncodingProofRoute n).circuitSemantics.gateMatrices.get
          ⟨0, by
            simp [oneTermRobinBlockEncodingProofRoute, oneTermRobinCircuitSemantics,
              GHL2025.oneTermRobinGateMatrixPlaceholders]⟩).unitary.proved =
          true) ∧
        (GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute
          (oneTermParameters n) row sparse).coefficient =
          (GHL2025.boundaryRotationAngleNormalizerProofRoute
            (oneTermParameters n) row sparse).coefficient ∧
        (((oneTermRobinBlockEncodingProofRoute n).circuitSemantics.gateMatrices.get
          ⟨1, by
            simp [oneTermRobinBlockEncodingProofRoute, oneTermRobinCircuitSemantics,
              GHL2025.oneTermRobinGateMatrixPlaceholders]⟩).gate =
          Gate.oracleCall "O_DT^S") ∧
        (((oneTermRobinBlockEncodingProofRoute n).circuitSemantics.gateMatrices.get
          ⟨1, by
            simp [oneTermRobinBlockEncodingProofRoute, oneTermRobinCircuitSemantics,
              GHL2025.oneTermRobinGateMatrixPlaceholders]⟩).matrix =
          GHL2025.sparseAmplitudeOracleDTRotationMatrix (oneTermParameters n)) ∧
        (GHL2025.oneTermRobinGate_O_DT_S (oneTermParameters n)).unitary.proved =
          false ∧
        (((oneTermRobinBlockEncodingProofRoute n).circuitSemantics.gateMatrices.get
          ⟨2, by
            simp [oneTermRobinBlockEncodingProofRoute, oneTermRobinCircuitSemantics,
              GHL2025.oneTermRobinGateMatrixPlaceholders]⟩).gate =
          Gate.oracleCall "Ry_boundary") ∧
        (((oneTermRobinBlockEncodingProofRoute n).circuitSemantics.gateMatrices.get
          ⟨2, by
            simp [oneTermRobinBlockEncodingProofRoute, oneTermRobinCircuitSemantics,
              GHL2025.oneTermRobinGateMatrixPlaceholders]⟩).matrix =
          GHL2025.boundaryRotationMatrix (oneTermParameters n)) ∧
        (GHL2025.oneTermRobinGate_Ry_boundary (oneTermParameters n)).unitary.proved =
          false ∧
        (((oneTermRobinBlockEncodingProofRoute n).circuitSemantics.gateMatrices.get
          ⟨3, by
            simp [oneTermRobinBlockEncodingProofRoute, oneTermRobinCircuitSemantics,
              GHL2025.oneTermRobinGateMatrixPlaceholders]⟩).gate =
          Gate.oracleCall "O_D^BS") ∧
        (((oneTermRobinBlockEncodingProofRoute n).circuitSemantics.gateMatrices.get
          ⟨3, by
            simp [oneTermRobinBlockEncodingProofRoute, oneTermRobinCircuitSemantics,
              GHL2025.oneTermRobinGateMatrixPlaceholders]⟩).matrix =
          GHL2025.bandedSparseAccessPaperMatrix (oneTermParameters n)) ∧
        (GHL2025.oneTermRobinGate_O_D_BS (oneTermParameters n)).unitary.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).sparseAccessContract.imageFormula =
          "r_si = r_s0 + i mod 2^n" ∧
        (oneTermRobinBlockEncodingProofRoute n).cleanupScopeDecision.selectedScope =
          GHL2025.BandedSparseAccessCleanupScope.activeGlobalSource ∧
        (GHL2025.bandedSparseAccessFullCleanDomainExtensionContract
          (oneTermParameters n)).daggerCleanup.proved = false ∧
        (GHL2025.bandedSparseAccessFullCleanDomainExtensionContract
          (oneTermParameters n)).unitaryExtension.proved = false ∧
        (oneTermRobinBlockEncodingProofRoute n).sparseAccessContract.daggerCleanup.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).sparseAccessContract.unitaryExtension.proved =
          false ∧
        (((oneTermRobinBlockEncodingProofRoute n).circuitSemantics.gateMatrices.get
          ⟨4, by
            simp [oneTermRobinBlockEncodingProofRoute, oneTermRobinCircuitSemantics,
              GHL2025.oneTermRobinGateMatrixPlaceholders]⟩).gate =
          Gate.oracleCall "O_f") ∧
        (((oneTermRobinBlockEncodingProofRoute n).circuitSemantics.gateMatrices.get
          ⟨4, by
            simp [oneTermRobinBlockEncodingProofRoute, oneTermRobinCircuitSemantics,
              GHL2025.oneTermRobinGateMatrixPlaceholders]⟩).matrix =
          GHL2025.functionOraclePaperMatrix (oneTermParameters n)) ∧
        (GHL2025.oneTermRobinGate_O_f (oneTermParameters n)).unitary.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).functionOracleSource =
          GHL2025.functionOracleExternalAmplitudeSourceContract ∧
        (oneTermRobinBlockEncodingProofRoute n).functionOracleSource.closesFunctionOracleContract =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).oracleComposition.functionOracle.amplitudeCorrect.proved =
          false ∧
        (((oneTermRobinBlockEncodingProofRoute n).circuitSemantics.gateMatrices.get
          ⟨5, by
            simp [oneTermRobinBlockEncodingProofRoute, oneTermRobinCircuitSemantics,
              GHL2025.oneTermRobinGateMatrixPlaceholders]⟩).gate =
          Gate.swap 0 0) ∧
        (((oneTermRobinBlockEncodingProofRoute n).circuitSemantics.gateMatrices.get
          ⟨5, by
            simp [oneTermRobinBlockEncodingProofRoute, oneTermRobinCircuitSemantics,
              GHL2025.oneTermRobinGateMatrixPlaceholders]⟩).matrix =
          GHL2025.swapOracleMatrix (oneTermParameters n)) ∧
        (((oneTermRobinBlockEncodingProofRoute n).circuitSemantics.gateMatrices.get
          ⟨5, by
            simp [oneTermRobinBlockEncodingProofRoute, oneTermRobinCircuitSemantics,
              GHL2025.oneTermRobinGateMatrixPlaceholders]⟩).unitary.proved =
          true) ∧
        (((oneTermRobinBlockEncodingProofRoute n).circuitSemantics.gateMatrices.get
          ⟨6, by
            simp [oneTermRobinBlockEncodingProofRoute, oneTermRobinCircuitSemantics,
              GHL2025.oneTermRobinGateMatrixPlaceholders]⟩).gate =
          Gate.oracleCall "(O_D^BS)^†") ∧
        (((oneTermRobinBlockEncodingProofRoute n).circuitSemantics.gateMatrices.get
          ⟨6, by
            simp [oneTermRobinBlockEncodingProofRoute, oneTermRobinCircuitSemantics,
              GHL2025.oneTermRobinGateMatrixPlaceholders]⟩).matrix =
          GHL2025.bandedSparseAccessPaperDaggerMatrix (oneTermParameters n)) ∧
        (GHL2025.oneTermRobinGate_O_D_BS_dagger
          (oneTermParameters n)).unitary.proved = false ∧
        (oneTermRobinBlockEncodingProofRoute n).oracleComposition.lcuCorrect.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).theoremData.obligations.circuitUnitary.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.blockProjection.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.blockCorrect.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).theoremData.obligations.blockExtraction.proved =
          false := by
  rcases
      oneTermRobinBlockEncodingProofRoute_theoremTranscriptActiveCleanupMap
        n source hn hsource
      with
    ⟨post, pre, hcleanup, _hpost, _hpre, _hpreSource, _hunique, _hentry,
      hsourceAnchor, htheoremNormalizer, hgateList, himageFormula, hscope,
      _hpredicate, hfunctionSourceCleanup, hcleanupOpen, hunitaryOpen,
      _hfunctionAmpCleanup, _hlcuCleanup, _hcircuitUnitaryCleanup,
      _hblockProjectionCleanup, _hblockCorrectCleanup,
      _hblockExtractionCleanup⟩
  rcases
      oneTermRobinBlockEncodingProofRoute_derivativeBoundaryContractMap
        n row sparse
      with
    ⟨_hodts, _hry, hshared, _hnonzero, _hdivision, _hbound, _habs, _hsqrt,
      _harccos, _htwo, _hodtsDivision, _hodtsBound, _hodtsAbs,
      _hodtsSqrt, _hodtsTwo, _hryDivision, _hryArccos, _hryHalf,
      _hryBound, _hryTwo, _hgateListDerivative, hgateFlags, hODTSGate,
      hODTSMatrix, hRyGate, hRyMatrix, hODTSUnitary, hRyUnitary,
      hcircuitUnitary, _hfunctionAmpDerivative, hlcu, hblockProjection,
      hblockCorrect, hblockExtraction⟩
  rcases hshared with ⟨hsharedCoeff, _hsharedNormalizer, _hsharedBound⟩
  rcases oneTermRobinBlockEncodingProofRoute_activeOdbsGatePairWiring n with
    ⟨hOdbsGate, hOdbsMatrix, hOdbsUnitary, hOdbsDaggerGate,
      hOdbsDaggerMatrix, hOdbsDaggerUnitary⟩
  rcases
      oneTermRobinBlockEncodingProofRoute_ofExternalSourceAndFlags
        n ofColumn
      with
    ⟨hfunctionSource, _hsourceAnchorOf, _hnormalizerOf, _hformulaOf,
      _hnonzeroEqOf, _hdivisionEqOf, _htheoremEqOf, _hresourceOf,
      _hexternalOf, _hsourceNonzeroOf, _hsourceDivisionOf,
      _hsourceTheoremOf, _hclosesBoundOf, _hclosesOrthogonalOf,
      _hclosesUnitaryOf, hclosesContractOf, _hnormalizedOf,
      _hnonzeroOf, _hdivisionOf, _hboundOf, _horthogonalOf, _hunitaryOf,
      _hrouteTheoremOf, hOfGate, hOfMatrix, hOfUnitary, hfunctionAmp,
      _hlcuOf, _hblockProjectionOf, _hblockCorrectOf,
      _hblockExtractionOf⟩
  rcases oneTermRobinBlockEncodingProofRoute_blockProjectionNormalizerAudit n with
    ⟨_htarget, _hunitaryMatrix, _hblockMatrix, _htargetMatrix,
      htargetNormalizer, _hsignalIndex, _hblockProjectionAudit,
      _hblockCorrectAudit, _hcleanupAudit, _hlcuAudit⟩
  rcases
      GHL2025.bandedSparseAccessFullCleanDomainExtensionContract_flags_false
        (oneTermParameters n) source.val
      with
    ⟨_hcleanSplit, _hvalidAgreement, _hunusedSpecified, _hunusedFinite,
      _hunusedInjective, _hfullInjective, hfullCleanup, hfullUnitary,
      _hwrappedSlot, _hwrappedImage, _hwrappedFinite⟩
  exact ⟨post, pre, hcleanup, hsourceAnchor, htheoremNormalizer,
    htargetNormalizer, hgateList, hgateFlags, rfl, rfl, rfl, hsharedCoeff,
    hODTSGate, hODTSMatrix, hODTSUnitary, hRyGate, hRyMatrix, hRyUnitary,
    hOdbsGate, hOdbsMatrix, hOdbsUnitary, himageFormula, hscope,
    hfullCleanup, hfullUnitary, hcleanupOpen, hunitaryOpen, hOfGate,
    hOfMatrix, hOfUnitary, hfunctionSource, hclosesContractOf, hfunctionAmp,
    rfl, rfl, rfl, hOdbsDaggerGate, hOdbsDaggerMatrix,
    hOdbsDaggerUnitary, hlcu, hcircuitUnitary, hblockProjection,
    hblockCorrect, hblockExtraction⟩

/--
The theorem-transcript closure packet consumes the current Phase 1 guards.

This is the middle-agent checkpoint for Theorem `1 term robin`: it combines
the source transcript dependencies, layout/projection audit, block-projection
dependency map, and full Fig. 1-term Robin gate-contract ledger into one
reviewer-facing statement.  It records the exact false-obligation ledger and
does not promote cleanup, unitarity, LCU correctness, projection,
block-correctness, resource-bound, ancilla-cleanup, or final extraction flags.
-/
theorem oneTermRobinBlockEncodingProofRoute_theoremTranscriptClosurePacket
    (n row sparse ofColumn : Nat)
    (source : Fin
      (qubitDim (GHL2025.oneTermRobinTotalQubits (oneTermParameters n))))
    (hn : 3 <= n)
    (hsource : GHL2025.bandedSparseAccessPaperGlobalSlotSource
      (oneTermParameters n) source.val = true)
    (i j : Fin (gridSize n)) :
    let gamma := GHL2025.defaultRobinWavefunctionDecomposition
      (oneTermParameters n)
    ∃ (post pre : Fin
        (qubitDim (GHL2025.oneTermRobinTotalQubits (oneTermParameters n)))),
      GHL2025.BandedSparseAccessPostSwapCleanup
        (oneTermParameters n) source post pre ∧
        (oneTermRobinBlockEncodingProofRoute n).sourceAnchor =
          "Guseynov-Huang-Liu 2025, Theorem one-term block-encoding, Fig. 1-term Robin, arXiv:2506.20478" ∧
        (oneTermRobinBlockEncodingProofRoute n).sparseAccessContract.sourceAnchor =
          "Guseynov-Huang-Liu 2025, Lemma 1, arXiv:2506.20478" ∧
        (oneTermRobinBlockEncodingProofRoute n).sparseAccessContract.imageFormula =
          "r_si = r_s0 + i mod 2^n" ∧
        (oneTermRobinBlockEncodingProofRoute n).functionOracleSource =
          GHL2025.functionOracleExternalAmplitudeSourceContract ∧
        (oneTermRobinBlockEncodingProofRoute n).functionOracleSource.citedSourceAnchor =
          "Guseynov-Liu 2024, arXiv:2411.01131, Theorem 5" ∧
        (oneTermRobinBlockEncodingProofRoute n).functionOracleSource.closesFunctionOracleContract =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).theoremData.alpha =
          GHL2025.oneTermRobinNormalizer ∧
        (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.normalizer =
          gamma.gamma3.normalizer ∧
        (oneTermRobinBlockEncodingProofRoute n).theoremData.signalQubits =
          (GHL2025.oneTermRobinLayout (oneTermParameters n)).signalQubits ∧
        (oneTermRobinBlockEncodingProofRoute n).theoremData.pureAncillas =
          (GHL2025.oneTermRobinLayout (oneTermParameters n)).pureAncillas ∧
        (oneTermRobinBlockEncodingProofRoute n).theoremData.pureAncillas =
          (GHL2025.oneTermRobinResource (oneTermParameters n)).pureAncilla ∧
        GHL2025.effectiveRobinSignalQubits (oneTermParameters n) =
          (GHL2025.oneTermRobinLayout (oneTermParameters n)).signalQubits +
            (GHL2025.defaultRobinRegisterPartition
              (oneTermParameters n)).odPureAncillaQubits + 1 ∧
        (oneTermRobinBlockEncodingProofRoute n).circuitSemantics.gateMatrices.map
          (fun gateMatrix => gateMatrix.gate) =
          GHL2025.oneTermRobinCircuit ∧
        (oneTermRobinBlockEncodingProofRoute n).circuitSemantics.gateMatrices.map
          (fun gateMatrix => gateMatrix.unitary.proved) =
          [true, false, false, false, false, true, false] ∧
        (oneTermRobinBlockEncodingProofRoute n).blockClaim =
          defaultOneTermRobinCircuitBlockClaim n ∧
        (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.targetMatrix =
          oneTermRobinAkMatrix n ∧
        signalSystemBlockRowIndex (gridSize n)
          (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.signalIndex.val
          i.val = i.val ∧
        signalSystemBlockColIndex (gridSize n)
          (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.signalIndex.val
          j.val = j.val ∧
        (GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute
          (oneTermParameters n) row sparse).coefficient =
          (GHL2025.boundaryRotationAngleNormalizerProofRoute
            (oneTermParameters n) row sparse).coefficient ∧
        (oneTermRobinBlockEncodingProofRoute n).cleanupScopeDecision.selectedScope =
          GHL2025.BandedSparseAccessCleanupScope.activeGlobalSource ∧
        (oneTermRobinBlockEncodingProofRoute n).cleanupScopeDecision.selectedPredicate =
          "bandedSparseAccessPaperGlobalSlotSource" ∧
        (oneTermRobinBlockEncodingProofRoute n).cleanupScopeDecision.semanticCleanupPromotionAllowed =
          false ∧
        (GHL2025.bandedSparseAccessFullCleanDomainExtensionContract
          (oneTermParameters n)).daggerCleanup.proved = false ∧
        (GHL2025.bandedSparseAccessFullCleanDomainExtensionContract
          (oneTermParameters n)).unitaryExtension.proved = false ∧
        (oneTermRobinBlockEncodingProofRoute n).theoremData.obligations.resourceBound.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).theoremData.obligations.ancillaCleanup.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).sparseAccessContract.daggerCleanup.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).sparseAccessContract.unitaryExtension.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).oracleComposition.functionOracle.amplitudeCorrect.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).oracleComposition.lcuCorrect.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).theoremData.obligations.circuitUnitary.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).blockClaim.blockCorrect.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.blockProjection.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.blockCorrect.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).theoremData.obligations.blockExtraction.proved =
          false := by
  rcases
      oneTermRobinBlockEncodingProofRoute_fullGateContractLedger
        n row sparse ofColumn source hn hsource
      with
    ⟨post, pre, hcleanup, _hsourceAnchorFull, _htheoremNormalizerFull,
      _htargetNormalizerFull, hgateListFull, hgateFlagsFull, _hUIndicGate,
      _hUIndicMatrix, _hUIndicUnitary, hsharedCoeff, _hODTSGate,
      _hODTSMatrix, _hODTSUnitary, _hRyGate, _hRyMatrix, _hRyUnitary,
      _hOdbsGate, _hOdbsMatrix, _hOdbsUnitary, _himageFormulaFull,
      _hscopeFull, hfullCleanup, hfullUnitary, hcleanupOpen, hunitaryOpen,
      _hOfGate, _hOfMatrix, _hOfUnitary, _hfunctionSourceFull,
      _hclosesContractFull, hfunctionAmp, _hSwapGate, _hSwapMatrix,
      _hSwapUnitary, _hOdbsDaggerGate, _hOdbsDaggerMatrix,
      _hOdbsDaggerUnitary, hlcu, hcircuitUnitary, hblockProjection,
      hblockCorrect, hblockExtraction⟩
  rcases
      oneTermRobinBlockEncodingProofRoute_blockProjectionDependencyMap
        n source hn hsource i j
      with
    ⟨_postProjection, _preProjection, _hcleanupProjection, hclaim,
      _hsemantics, _htarget, _hblockMatrix, hrow, hcol, htargetGamma,
      htargetMatrix, _hfunctionSourceProjection, _hfunctionClosesProjection,
      _hwrappedSlot, _hfullCleanupProjection, _hfullUnitaryProjection,
      _hscopeProjection, _hcleanupOpenProjection, _hunitaryOpenProjection,
      _hfunctionAmpProjection, _hlcuProjection, _hcircuitUnitaryProjection,
      hclaimBlockCorrect, _hblockProjectionProjection, _hblockCorrectProjection,
      _hblockExtractionProjection⟩
  rcases oneTermRobinBlockEncodingProofRoute_layoutProjectionAudit n with
    ⟨hsignalQubits, hpureLayout, hpureResource, heffectiveSignal,
      hresourceBound, hancillaCleanup, _hblockProjectionLayout,
      _hblockCorrectLayout⟩
  rcases oneTermRobinBlockEncodingProofRoute_theoremTranscriptDependencies n with
    ⟨hsourceAnchor, _hnormalizerMatches, htheoremNormalizer, _hgateList,
      _hgateFlags, _hsignalIndex, hodbsSource, himageFormula, hscope,
      hpredicate, hpromotion, _hfullClean, _hfullSpace, _hwrappedSlot,
      _hfullCleanCleanup, _hfullCleanUnitary, hfunctionSource,
      hfunctionOpen, _hcleanupTranscript, _hunitaryTranscript,
      _hfunctionAmpTranscript, _hlcuTranscript, _hcircuitUnitaryTranscript,
      _hblockProjectionTranscript, _hblockCorrectTranscript,
      _hblockExtractionTranscript⟩
  have hfunctionCited :
      (oneTermRobinBlockEncodingProofRoute n).functionOracleSource.citedSourceAnchor =
        "Guseynov-Liu 2024, arXiv:2411.01131, Theorem 5" := by
    rw [hfunctionSource]
    rfl
  exact ⟨post, pre, hcleanup, hsourceAnchor, hodbsSource, himageFormula,
    hfunctionSource, hfunctionCited, hfunctionOpen, htheoremNormalizer,
    htargetGamma, hsignalQubits, hpureLayout, hpureResource,
    heffectiveSignal, hgateListFull, hgateFlagsFull, hclaim, htargetMatrix,
    hrow, hcol, hsharedCoeff, hscope, hpredicate, hpromotion, hfullCleanup,
    hfullUnitary, hresourceBound, hancillaCleanup, hcleanupOpen,
    hunitaryOpen, hfunctionAmp, hlcu, hcircuitUnitary, hclaimBlockCorrect,
    hblockProjection, hblockCorrect, hblockExtraction⟩

/--
The theorem route now has a typed finite LCU/block-composition contract.

This guard consumes the Phase 1 closure packet and exposes the exact remaining
finite-dimensional composition obligations.  It keeps the route-level LCU,
circuit-unitary, block-projection, block-correctness, and final-extraction
flags false.
-/
theorem oneTermRobinBlockEncodingProofRoute_finiteBlockCompositionContractMap
    (n row sparse ofColumn : Nat)
    (source : Fin
      (qubitDim (GHL2025.oneTermRobinTotalQubits (oneTermParameters n))))
    (hn : 3 <= n)
    (hsource : GHL2025.bandedSparseAccessPaperGlobalSlotSource
      (oneTermParameters n) source.val = true)
    (i j : Fin (gridSize n)) :
    let contract := oneTermRobinFiniteBlockCompositionContract n
    ∃ (post pre : Fin
        (qubitDim (GHL2025.oneTermRobinTotalQubits (oneTermParameters n)))),
      GHL2025.BandedSparseAccessPostSwapCleanup
        (oneTermParameters n) source post pre ∧
        contract.sourceAnchor =
          "QBE finite-dimensional LCU/block-composition contract for GHL2025 Theorem one-term block-encoding" ∧
        contract.lcuSourceAnchor =
          "LCU.StandardBlockEncoding; Childs-Wiebe 2012, arXiv:1202.5822; QBE cited-results row" ∧
        contract.theoremAnchor =
          "Guseynov-Huang-Liu 2025, Theorem one-term block-encoding and Fig. 1-term Robin, arXiv:2506.20478" ∧
        contract.claim = (oneTermRobinBlockEncodingProofRoute n).blockClaim ∧
        contract.claim.target = contract.expectedTarget ∧
        contract.expectedTarget = oneTermRobinBlockExtractionTarget n ∧
        contract.targetMatrix = oneTermRobinAkMatrix n ∧
        contract.normalizer = GHL2025.oneTermRobinNormalizer ∧
        contract.expectedTarget.targetMatrix = contract.targetMatrix ∧
        contract.expectedTarget.normalizer = contract.normalizer ∧
        contract.circuitUnitary.proved = false ∧
        contract.lcuComposition.proved = false ∧
        contract.blockProjection.proved = false ∧
        contract.normalizedBlockEquality.proved = false ∧
        contract.finalExtraction.proved = false ∧
        (oneTermRobinBlockEncodingProofRoute n).oracleComposition.lcuCorrect.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).theoremData.obligations.circuitUnitary.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).blockClaim.blockCorrect.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.blockProjection.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.blockCorrect.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).theoremData.obligations.blockExtraction.proved =
          false := by
  rcases
      oneTermRobinFiniteBlockCompositionContract_transcript n
      with
    ⟨hcontractSource, hcontractLCU, hcontractTheorem, hcontractClaim,
      hcontractTarget, hclaimTarget, htargetMatrixContract,
      htargetNormalizerContract, htargetMatrix, hnormalizer,
      hcircuitContract, hlcuContract, hprojectionContract,
      hblockEqContract, hfinalContract⟩
  rcases
      oneTermRobinBlockEncodingProofRoute_theoremTranscriptClosurePacket
        n row sparse ofColumn source hn hsource i j
      with
    ⟨post, pre, hcleanup, _hsourceAnchor, _hodbsSource, _himageFormula,
      _hfunctionSource, _hfunctionCited, _hfunctionOpen, _htheoremNormalizer,
      _htargetGamma, _hsignalQubits, _hpureLayout, _hpureResource,
      _heffectiveSignal, _hgateList, _hgateFlags, hrouteClaim,
      _htargetMatrixRoute, _hrow, _hcol, _hsharedCoeff, _hscope,
      _hpredicate, _hpromotion, _hfullCleanup, _hfullUnitary,
      _hresourceBound, _hancillaCleanup, _hcleanupOpen, _hunitaryOpen,
      _hfunctionAmp, hlcu, hcircuitUnitary, hclaimBlockCorrect,
      hblockProjection, hblockCorrect, hblockExtraction⟩
  have hclaimRoute :
      (oneTermRobinFiniteBlockCompositionContract n).claim =
        (oneTermRobinBlockEncodingProofRoute n).blockClaim := by
    rw [hcontractClaim, hrouteClaim]
  exact ⟨post, pre, hcleanup, hcontractSource, hcontractLCU,
    hcontractTheorem, hclaimRoute, hclaimTarget, hcontractTarget,
    htargetMatrix, hnormalizer, htargetMatrixContract,
    htargetNormalizerContract, hcircuitContract, hlcuContract,
    hprojectionContract, hblockEqContract, hfinalContract, hlcu,
    hcircuitUnitary, hclaimBlockCorrect, hblockProjection, hblockCorrect,
    hblockExtraction⟩

/--
The theorem route exposes the exact finite composition theorem interface.

This consumes the finite block-composition contract map and names the precise
matrix objects that a future theorem must relate: the route circuit semantics,
the signal-zero block projection, the row-scaled Robin target matrix, and the
normalizer `N_D * N_f * kappa`.  It is contract-only; all finite composition,
route LCU, resource, cleanup, projection, block-correctness, and extraction
flags remain false.
-/
theorem oneTermRobinBlockEncodingProofRoute_finiteCompositionExactTheoremInterface
    (n row sparse ofColumn : Nat)
    (source : Fin
      (qubitDim (GHL2025.oneTermRobinTotalQubits (oneTermParameters n))))
    (hn : 3 <= n)
    (hsource : GHL2025.bandedSparseAccessPaperGlobalSlotSource
      (oneTermParameters n) source.val = true)
    (i j : Fin (gridSize n)) :
    let contract := oneTermRobinFiniteBlockCompositionContract n
    let exactTheorem := oneTermRobinFiniteCompositionExactTheoremObligation n
    ∃ (post pre : Fin
        (qubitDim (GHL2025.oneTermRobinTotalQubits (oneTermParameters n)))),
      GHL2025.BandedSparseAccessPostSwapCleanup
        (oneTermParameters n) source post pre ∧
        exactTheorem.source =
          "GHL2025 Theorem one-term block-encoding, Eq. ROBIN clarified, Fig. 1-term ROBIN, Definition def:block-encoding; cited-results row LCU.StandardBlockEncoding" ∧
        exactTheorem.proved = false ∧
        contract.claim = (oneTermRobinBlockEncodingProofRoute n).blockClaim ∧
        contract.claim.semantics =
          (oneTermRobinBlockEncodingProofRoute n).circuitSemantics ∧
        contract.claim.target = contract.expectedTarget ∧
        contract.expectedTarget = oneTermRobinBlockExtractionTarget n ∧
        contract.expectedTarget.blockMatrix =
          signalSystemBlockProjection
            (qubitDim (GHL2025.effectiveRobinSignalQubits
              (oneTermParameters n)))
            (gridSize n)
            (gridSize n)
            contract.expectedTarget.unitaryMatrix
            contract.expectedTarget.signalIndex ∧
        contract.expectedTarget.blockMatrix i j =
          contract.expectedTarget.unitaryMatrix
            ⟨signalSystemBlockRowIndex (gridSize n)
                contract.expectedTarget.signalIndex.val i.val,
              signalSystemBlockRowIndex_lt
                contract.expectedTarget.signalIndex i⟩
            ⟨signalSystemBlockColIndex (gridSize n)
                contract.expectedTarget.signalIndex.val j.val,
              signalSystemBlockColIndex_lt
                contract.expectedTarget.signalIndex j⟩ ∧
        contract.expectedTarget.signalIndex.val = 0 ∧
        contract.targetMatrix = oneTermRobinAkMatrix n ∧
        contract.normalizer = GHL2025.oneTermRobinNormalizer ∧
        contract.blockProjection.source =
          "GHL2025 Eq. ROBIN clarified and Fig. 1-term Robin" ∧
        contract.normalizedBlockEquality.description =
          "projected block equals oneTermRobinAkMatrix n divided by N_D*N_f*kappa" ∧
        contract.finalExtraction.source =
          "GHL2025 Theorem one-term block-encoding" ∧
        contract.circuitUnitary.proved = false ∧
        contract.lcuComposition.proved = false ∧
        contract.blockProjection.proved = false ∧
        contract.normalizedBlockEquality.proved = false ∧
        contract.finalExtraction.proved = false ∧
        (oneTermRobinBlockEncodingProofRoute n).oracleComposition.lcuCorrect.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).theoremData.obligations.resourceBound.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).theoremData.obligations.ancillaCleanup.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).theoremData.obligations.circuitUnitary.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).blockClaim.blockCorrect.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.blockProjection.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.blockCorrect.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).theoremData.obligations.blockExtraction.proved =
          false := by
  rcases
      oneTermRobinBlockEncodingProofRoute_finiteBlockCompositionContractMap
        n row sparse ofColumn source hn hsource i j
      with
    ⟨post, pre, hcleanup, _hcontractSource, _hcontractLCU,
      _hcontractTheorem, hclaim, hclaimTarget, hcontractTarget,
      htargetMatrix, hnormalizer, _htargetMatrixContract,
      _htargetNormalizerContract, hcircuitContract, hlcuContract,
      hprojectionContract, hblockEqContract, hfinalContract, hlcu,
      hcircuitUnitary, hclaimBlockCorrect, hblockProjection, hblockCorrect,
      hblockExtraction⟩
  rcases oneTermRobinBlockEncodingProofRoute_layoutProjectionAudit n with
    ⟨_hsignalQubits, _hpureLayout, _hpureResource, _heffectiveSignal,
      hresourceBound, hancillaCleanup, _hblockProjectionLayout,
      _hblockCorrectLayout⟩
  rcases oneTermRobinFiniteCompositionExactTheoremObligation_transcript n with
    ⟨hexactSource, hexactFalse⟩
  have hsemantics :
      (oneTermRobinFiniteBlockCompositionContract n).claim.semantics =
        (oneTermRobinBlockEncodingProofRoute n).circuitSemantics := by
    rw [hclaim]
    exact (oneTermRobinBlockEncodingProofRoute n).claimUsesSemantics
  have hblockMatrixObject :
      (oneTermRobinFiniteBlockCompositionContract n).expectedTarget.blockMatrix =
        signalSystemBlockProjection
          (qubitDim (GHL2025.effectiveRobinSignalQubits
            (oneTermParameters n)))
          (gridSize n)
          (gridSize n)
          (oneTermRobinFiniteBlockCompositionContract n).expectedTarget.unitaryMatrix
          (oneTermRobinFiniteBlockCompositionContract n).expectedTarget.signalIndex := by
    rw [hcontractTarget]
    rfl
  have hblockEntry :
      (oneTermRobinFiniteBlockCompositionContract n).expectedTarget.blockMatrix i j =
        (oneTermRobinFiniteBlockCompositionContract n).expectedTarget.unitaryMatrix
          ⟨signalSystemBlockRowIndex (gridSize n)
              (oneTermRobinFiniteBlockCompositionContract n).expectedTarget.signalIndex.val i.val,
            signalSystemBlockRowIndex_lt
              (oneTermRobinFiniteBlockCompositionContract n).expectedTarget.signalIndex i⟩
          ⟨signalSystemBlockColIndex (gridSize n)
              (oneTermRobinFiniteBlockCompositionContract n).expectedTarget.signalIndex.val j.val,
            signalSystemBlockColIndex_lt
              (oneTermRobinFiniteBlockCompositionContract n).expectedTarget.signalIndex j⟩ := by
    rw [hblockMatrixObject]
    exact signalSystemBlockProjection_apply
      (oneTermRobinFiniteBlockCompositionContract n).expectedTarget.unitaryMatrix
      (oneTermRobinFiniteBlockCompositionContract n).expectedTarget.signalIndex i j
  have hsignalZero :
      (oneTermRobinFiniteBlockCompositionContract n).expectedTarget.signalIndex.val =
        0 := by
    rw [hcontractTarget]
    rfl
  exact ⟨post, pre, hcleanup, hexactSource, hexactFalse, hclaim, hsemantics,
    hclaimTarget, hcontractTarget, hblockMatrixObject, hblockEntry,
    hsignalZero, htargetMatrix, hnormalizer, rfl, rfl, rfl,
    hcircuitContract, hlcuContract, hprojectionContract, hblockEqContract,
    hfinalContract, hlcu, hresourceBound, hancillaCleanup, hcircuitUnitary,
    hclaimBlockCorrect, hblockProjection, hblockCorrect, hblockExtraction⟩

/--
Contract-only entry obligation connecting Eq. `ROBIN clarified` to the
signal-zero block matrix.

The future theorem must show, entry by entry, that the signal-zero projection
of the Fig. 1-term Robin gate product realizes the `gamma3` clean branch and
therefore the row-scaled Robin target normalized by `N_D * N_f * kappa`.
This declaration only names that missing theorem-facing step.
-/
def oneTermRobinGamma3SignalBlockEntryObligation
    (_n : Nat) : SemanticObligation where
  description :=
    "gamma3-to-signal-zero-block entry theorem: each system entry of the signal-zero projection of the Fig. 1-term Robin circuit product equals the Eq. ROBIN clarified gamma3 clean-branch coefficient, hence oneTermRobinAkMatrix n normalized by N_D*N_f*kappa"
  source :=
    "GHL2025 Eq. ROBIN clarified gamma3 line, Theorem one-term block-encoding, Fig. 1-term ROBIN, Definition def:block-encoding"
  proved := false

theorem oneTermRobinGamma3SignalBlockEntryObligation_transcript
    (n : Nat) :
    (oneTermRobinGamma3SignalBlockEntryObligation n).source =
        "GHL2025 Eq. ROBIN clarified gamma3 line, Theorem one-term block-encoding, Fig. 1-term ROBIN, Definition def:block-encoding" ∧
      (oneTermRobinGamma3SignalBlockEntryObligation n).proved =
        false := by
  exact ⟨rfl, rfl⟩

/--
The exact finite-composition interface is refined to the gamma3 entry target.

This is still a Phase 1 transcript guard.  It consumes the exact finite theorem
interface, exposes the `gamma3` normalizer, the concrete signal-projection
entry, the target matrix, and the false final flags.  It does not prove that
the entry equals the paper coefficient, nor does it promote LCU, projection,
block-correctness, resource, cleanup, or extraction obligations.
-/
theorem oneTermRobinBlockEncodingProofRoute_gamma3SignalBlockEntryObligationMap
    (n row sparse ofColumn : Nat)
    (source : Fin
      (qubitDim (GHL2025.oneTermRobinTotalQubits (oneTermParameters n))))
    (hn : 3 <= n)
    (hsource : GHL2025.bandedSparseAccessPaperGlobalSlotSource
      (oneTermParameters n) source.val = true)
    (i j : Fin (gridSize n)) :
    let gamma := GHL2025.defaultRobinWavefunctionDecomposition
      (oneTermParameters n)
    let contract := oneTermRobinFiniteBlockCompositionContract n
    let exactTheorem := oneTermRobinFiniteCompositionExactTheoremObligation n
    let entryObligation :=
      oneTermRobinGamma3SignalBlockEntryObligation n
    ∃ (post pre : Fin
        (qubitDim (GHL2025.oneTermRobinTotalQubits (oneTermParameters n)))),
      GHL2025.BandedSparseAccessPostSwapCleanup
        (oneTermParameters n) source post pre ∧
        entryObligation.source =
          "GHL2025 Eq. ROBIN clarified gamma3 line, Theorem one-term block-encoding, Fig. 1-term ROBIN, Definition def:block-encoding" ∧
        entryObligation.proved = false ∧
        exactTheorem.source =
          "GHL2025 Theorem one-term block-encoding, Eq. ROBIN clarified, Fig. 1-term ROBIN, Definition def:block-encoding; cited-results row LCU.StandardBlockEncoding" ∧
        exactTheorem.proved = false ∧
        gamma.gamma3.normalizer = GHL2025.oneTermRobinNormalizer ∧
        contract.normalizer = gamma.gamma3.normalizer ∧
        contract.expectedTarget.blockMatrix i j =
          contract.expectedTarget.unitaryMatrix
            ⟨signalSystemBlockRowIndex (gridSize n)
                contract.expectedTarget.signalIndex.val i.val,
              signalSystemBlockRowIndex_lt
                contract.expectedTarget.signalIndex i⟩
            ⟨signalSystemBlockColIndex (gridSize n)
                contract.expectedTarget.signalIndex.val j.val,
              signalSystemBlockColIndex_lt
                contract.expectedTarget.signalIndex j⟩ ∧
        contract.targetMatrix = oneTermRobinAkMatrix n ∧
        contract.normalizedBlockEquality.proved = false ∧
        contract.finalExtraction.proved = false ∧
        (oneTermRobinBlockEncodingProofRoute n).oracleComposition.lcuCorrect.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).theoremData.obligations.resourceBound.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).theoremData.obligations.ancillaCleanup.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).theoremData.obligations.circuitUnitary.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).blockClaim.blockCorrect.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.blockProjection.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.blockCorrect.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).theoremData.obligations.blockExtraction.proved =
          false := by
  rcases
      oneTermRobinBlockEncodingProofRoute_finiteCompositionExactTheoremInterface
        n row sparse ofColumn source hn hsource i j
      with
    ⟨post, pre, hcleanup, hexactSource, hexactFalse, _hclaim,
      _hsemantics, _hclaimTarget, _hcontractTarget, _hblockMatrixObject,
      hblockEntry, _hsignalZero, htargetMatrix, hnormalizer,
      _hblockProjectionSource, _hblockEqDescription, _hfinalSource,
      _hcircuitContract, _hlcuContract, _hprojectionContract,
      hblockEqContract, hfinalContract, hlcu, hresourceBound,
      hancillaCleanup, hcircuitUnitary, hclaimBlockCorrect, hblockProjection,
      hblockCorrect, hblockExtraction⟩
  rcases oneTermRobinGamma3SignalBlockEntryObligation_transcript n with
    ⟨hentrySource, hentryFalse⟩
  have hgammaNormalizer :
      (GHL2025.defaultRobinWavefunctionDecomposition
        (oneTermParameters n)).gamma3.normalizer =
          GHL2025.oneTermRobinNormalizer := rfl
  have hcontractGamma :
      (oneTermRobinFiniteBlockCompositionContract n).normalizer =
        (GHL2025.defaultRobinWavefunctionDecomposition
          (oneTermParameters n)).gamma3.normalizer := by
    rw [hnormalizer, hgammaNormalizer]
  exact ⟨post, pre, hcleanup, hentrySource, hentryFalse, hexactSource,
    hexactFalse, hgammaNormalizer, hcontractGamma, hblockEntry,
    htargetMatrix, hblockEqContract, hfinalContract, hlcu, hresourceBound,
    hancillaCleanup, hcircuitUnitary, hclaimBlockCorrect, hblockProjection,
    hblockCorrect, hblockExtraction⟩

/--
The gamma3 entry obligation also exposes the concrete target entry.

This is the RHS data for the future entry theorem: the same fixed system
indices `i, j` point to `f(x_i) D_{ij}`, with normalizer `N_D*N_f*kappa`.
The statement intentionally does not prove that the circuit block entry equals
this target entry; the normalized block equality and final extraction flags
remain false.
-/
theorem oneTermRobinBlockEncodingProofRoute_gamma3TargetEntryData
    (n row sparse ofColumn : Nat)
    (source : Fin
      (qubitDim (GHL2025.oneTermRobinTotalQubits (oneTermParameters n))))
    (hn : 3 <= n)
    (hsource : GHL2025.bandedSparseAccessPaperGlobalSlotSource
      (oneTermParameters n) source.val = true)
    (i j : Fin (gridSize n)) :
    let gamma := GHL2025.defaultRobinWavefunctionDecomposition
      (oneTermParameters n)
    let contract := oneTermRobinFiniteBlockCompositionContract n
    let entryObligation :=
      oneTermRobinGamma3SignalBlockEntryObligation n
    ∃ (post pre : Fin
        (qubitDim (GHL2025.oneTermRobinTotalQubits (oneTermParameters n)))),
      GHL2025.BandedSparseAccessPostSwapCleanup
        (oneTermParameters n) source post pre ∧
        entryObligation.proved = false ∧
        contract.expectedTarget.targetMatrix i j =
          oneTermRobinAkMatrix n i j ∧
        contract.expectedTarget.normalizer =
          gamma.gamma3.normalizer ∧
        contract.targetMatrix i j =
          oneTermRobinAkMatrix n i j ∧
        contract.normalizer =
          gamma.gamma3.normalizer ∧
        contract.expectedTarget.blockMatrix i j =
          contract.expectedTarget.unitaryMatrix
            ⟨signalSystemBlockRowIndex (gridSize n)
                contract.expectedTarget.signalIndex.val i.val,
              signalSystemBlockRowIndex_lt
                contract.expectedTarget.signalIndex i⟩
            ⟨signalSystemBlockColIndex (gridSize n)
                contract.expectedTarget.signalIndex.val j.val,
              signalSystemBlockColIndex_lt
                contract.expectedTarget.signalIndex j⟩ ∧
        contract.normalizedBlockEquality.proved = false ∧
        contract.finalExtraction.proved = false ∧
        (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.blockProjection.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.blockCorrect.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).theoremData.obligations.blockExtraction.proved =
          false := by
  rcases
      oneTermRobinBlockEncodingProofRoute_gamma3SignalBlockEntryObligationMap
        n row sparse ofColumn source hn hsource i j
      with
    ⟨post, pre, hcleanup, _hentrySource, hentryFalse, _hexactSource,
      _hexactFalse, _hgammaNormalizer, hcontractGamma, hblockEntry,
      htargetMatrix, hblockEqContract, hfinalContract, _hlcu,
      _hresourceBound, _hancillaCleanup, _hcircuitUnitary,
      _hclaimBlockCorrect, hblockProjection, hblockCorrect,
      hblockExtraction⟩
  have htargetEntry :
      (oneTermRobinFiniteBlockCompositionContract n).expectedTarget.targetMatrix
          i j =
        oneTermRobinAkMatrix n i j := rfl
  have htargetNormalizer :
      (oneTermRobinFiniteBlockCompositionContract n).expectedTarget.normalizer =
        (GHL2025.defaultRobinWavefunctionDecomposition
          (oneTermParameters n)).gamma3.normalizer := rfl
  have hcontractTargetEntry :
      (oneTermRobinFiniteBlockCompositionContract n).targetMatrix i j =
        oneTermRobinAkMatrix n i j := by
    rw [htargetMatrix]
  exact ⟨post, pre, hcleanup, hentryFalse, htargetEntry,
    htargetNormalizer, hcontractTargetEntry, hcontractGamma, hblockEntry,
    hblockEqContract, hfinalContract, hblockProjection, hblockCorrect,
    hblockExtraction⟩

/--
The gamma3 factor-entry ledger joins the existing single-gate transcript
bridges.

This is the next theorem-facing interface for the future
`one_term_gamma3_signal_block_entry` proof.  It packages the target-entry
side, the clean `O_f` entry, the `O_DT^S` ket-zero entry, the boundary
`Ry_boundary` ket-zero entry, and the active global-source `O_D^BS` cleanup
map.  It is still a ledger: the normalized block equality, LCU composition,
cleanup promotion, and final extraction fields remain false.
-/
theorem oneTermRobinBlockEncodingProofRoute_gamma3FactorEntryLedger
    (n row sparse ofColumn : Nat)
    (source : Fin
      (qubitDim (GHL2025.oneTermRobinTotalQubits (oneTermParameters n))))
    (hn : 3 <= n)
    (hsource : GHL2025.bandedSparseAccessPaperGlobalSlotSource
      (oneTermParameters n) source.val = true)
    (i j : Fin (gridSize n))
    (ofRow ofCol odtsRow odtsCol ryRow ryCol : Fin
      (qubitDim (GHL2025.oneTermRobinTotalQubits (oneTermParameters n))))
    (hOfClean :
      (GHL2025.functionOraclePaperImage
        (oneTermParameters n) ofCol.val).cleanWorkspaceBranch = true)
    (hOfBranch :
      ofRow.val =
        (GHL2025.functionOraclePaperImage
          (oneTermParameters n) ofCol.val).cleanBranchBasisIndex)
    (hOdtsIndicator :
      (GHL2025.sparseAmplitudeOracleDTPaperRegisters
        (oneTermParameters n) odtsCol.val).indicatorBit = 1)
    (hOdtsAncilla :
      (GHL2025.sparseAmplitudeOracleDTPaperRegisters
        (oneTermParameters n) odtsCol.val).ancillaBit = 0)
    (hOdtsRow :
      odtsRow.val >>> 1 =
        (GHL2025.sparseAmplitudeOracleDTPaperRegisters
          (oneTermParameters n) odtsCol.val).nonAncillaValue)
    (hOdtsAncillaRow : odtsRow.val &&& 1 = 0)
    (hRyIndicator :
      (GHL2025.boundaryRotationPaperRegisters
        (oneTermParameters n) ryCol.val).indicatorBit = 0)
    (hRyAncilla :
      (GHL2025.boundaryRotationPaperRegisters
        (oneTermParameters n) ryCol.val).ancillaBit = 0)
    (hRyRow :
      ryRow.val >>> 1 =
        (GHL2025.boundaryRotationPaperRegisters
          (oneTermParameters n) ryCol.val).nonAncillaValue)
    (hRyAncillaRow : ryRow.val &&& 1 = 0) :
    let p := oneTermParameters n
    let gamma := GHL2025.defaultRobinWavefunctionDecomposition p
    let contract := oneTermRobinFiniteBlockCompositionContract n
    let entryObligation := oneTermRobinGamma3SignalBlockEntryObligation n
    let odtsRegs := GHL2025.sparseAmplitudeOracleDTPaperRegisters p odtsCol.val
    let ryRegs := GHL2025.boundaryRotationPaperRegisters p ryCol.val
    ∃ (post pre : Fin
        (qubitDim (GHL2025.oneTermRobinTotalQubits p))),
      GHL2025.BandedSparseAccessPostSwapCleanup p source post pre ∧
        entryObligation.proved = false ∧
        contract.expectedTarget.targetMatrix i j =
          oneTermRobinAkMatrix n i j ∧
        contract.targetMatrix i j =
          oneTermRobinAkMatrix n i j ∧
        contract.expectedTarget.normalizer = gamma.gamma3.normalizer ∧
        contract.normalizer = gamma.gamma3.normalizer ∧
        contract.expectedTarget.blockMatrix i j =
          contract.expectedTarget.unitaryMatrix
            ⟨signalSystemBlockRowIndex (gridSize n)
                contract.expectedTarget.signalIndex.val i.val,
              signalSystemBlockRowIndex_lt
                contract.expectedTarget.signalIndex i⟩
            ⟨signalSystemBlockColIndex (gridSize n)
                contract.expectedTarget.signalIndex.val j.val,
              signalSystemBlockColIndex_lt
                contract.expectedTarget.signalIndex j⟩ ∧
        (((oneTermRobinBlockEncodingProofRoute n).circuitSemantics.gateMatrices.get
          ⟨4, by
            simp [oneTermRobinBlockEncodingProofRoute, oneTermRobinCircuitSemantics,
              GHL2025.oneTermRobinGateMatrixPlaceholders]⟩).gate =
          Gate.oracleCall "O_f") ∧
        (((oneTermRobinBlockEncodingProofRoute n).circuitSemantics.gateMatrices.get
          ⟨4, by
            simp [oneTermRobinBlockEncodingProofRoute, oneTermRobinCircuitSemantics,
              GHL2025.oneTermRobinGateMatrixPlaceholders]⟩).matrix ofRow ofCol =
          (GHL2025.functionOracleAmplitudeProofRoute
            p ofCol.val).normalizedAmplitude) ∧
        (GHL2025.functionOracleAmplitudeProofRoute
          p ofCol.val).cleanWorkspaceBranch = true ∧
        (GHL2025.functionOracleAmplitudeProofRoute
          p ofCol.val).unitaryCompletion.proved = false ∧
        (((oneTermRobinBlockEncodingProofRoute n).circuitSemantics.gateMatrices.get
          ⟨1, by
            simp [oneTermRobinBlockEncodingProofRoute, oneTermRobinCircuitSemantics,
              GHL2025.oneTermRobinGateMatrixPlaceholders]⟩).gate =
          Gate.oracleCall "O_DT^S") ∧
        (((oneTermRobinBlockEncodingProofRoute n).circuitSemantics.gateMatrices.get
          ⟨1, by
            simp [oneTermRobinBlockEncodingProofRoute, oneTermRobinCircuitSemantics,
              GHL2025.oneTermRobinGateMatrixPlaceholders]⟩).matrix odtsRow odtsCol =
          (GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute
            p odtsRegs.rowValue odtsRegs.sparseIndexValue).ketZeroEntry) ∧
        (GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute
          p odtsRegs.rowValue odtsRegs.sparseIndexValue).normalizedCoefficient =
          GHL2025.sparseAmplitudeOracleDTNormalizedCoefficient
            p odtsRegs.rowValue odtsRegs.sparseIndexValue ∧
        (GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute
          p odtsRegs.rowValue odtsRegs.sparseIndexValue).twoByTwoUnitary.proved =
          false ∧
        (((oneTermRobinBlockEncodingProofRoute n).circuitSemantics.gateMatrices.get
          ⟨2, by
            simp [oneTermRobinBlockEncodingProofRoute, oneTermRobinCircuitSemantics,
              GHL2025.oneTermRobinGateMatrixPlaceholders]⟩).gate =
          Gate.oracleCall "Ry_boundary") ∧
        (((oneTermRobinBlockEncodingProofRoute n).circuitSemantics.gateMatrices.get
          ⟨2, by
            simp [oneTermRobinBlockEncodingProofRoute, oneTermRobinCircuitSemantics,
              GHL2025.oneTermRobinGateMatrixPlaceholders]⟩).matrix ryRow ryCol =
          (GHL2025.boundaryRotationAngleNormalizerProofRoute
            p ryRegs.rowValue ryRegs.sparseIndexValue).cosHalfEntry) ∧
        (GHL2025.boundaryRotationAngleNormalizerProofRoute
          p ryRegs.rowValue ryRegs.sparseIndexValue).arccosArgument =
          GHL2025.boundaryRotationNormalizedCoefficient
            p ryRegs.rowValue ryRegs.sparseIndexValue ∧
        (GHL2025.boundaryRotationAngleNormalizerProofRoute
          p ryRegs.rowValue ryRegs.sparseIndexValue).twoByTwoUnitary.proved =
          false ∧
        (((oneTermRobinBlockEncodingProofRoute n).circuitSemantics.gateMatrices.get
          ⟨3, by
            simp [oneTermRobinBlockEncodingProofRoute, oneTermRobinCircuitSemantics,
              GHL2025.oneTermRobinGateMatrixPlaceholders]⟩).matrix =
          GHL2025.bandedSparseAccessPaperMatrix p) ∧
        (((oneTermRobinBlockEncodingProofRoute n).circuitSemantics.gateMatrices.get
          ⟨6, by
            simp [oneTermRobinBlockEncodingProofRoute, oneTermRobinCircuitSemantics,
              GHL2025.oneTermRobinGateMatrixPlaceholders]⟩).matrix =
          GHL2025.bandedSparseAccessPaperDaggerMatrix p) ∧
        GHL2025.bandedSparseAccessPaperGlobalSlotSource p pre.val = true ∧
        (GHL2025.oneTermRobinGate_O_D_BS_dagger p).matrix pre post =
          Coeff.rat 1 ∧
        (oneTermRobinBlockEncodingProofRoute n).cleanupScopeDecision.selectedScope =
          GHL2025.BandedSparseAccessCleanupScope.activeGlobalSource ∧
        (oneTermRobinBlockEncodingProofRoute n).cleanupScopeDecision.semanticCleanupPromotionAllowed =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).sparseAccessContract.daggerCleanup.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).sparseAccessContract.unitaryExtension.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).functionOracleSource.closesFunctionOracleContract =
          false ∧
        contract.normalizedBlockEquality.proved = false ∧
        contract.finalExtraction.proved = false ∧
        (oneTermRobinBlockEncodingProofRoute n).oracleComposition.functionOracle.amplitudeCorrect.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).oracleComposition.lcuCorrect.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).theoremData.obligations.circuitUnitary.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.blockProjection.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.blockCorrect.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).theoremData.obligations.blockExtraction.proved =
          false := by
  let p := oneTermParameters n
  let odtsRegs := GHL2025.sparseAmplitudeOracleDTPaperRegisters p odtsCol.val
  let ryRegs := GHL2025.boundaryRotationPaperRegisters p ryCol.val
  rcases
      oneTermRobinBlockEncodingProofRoute_gamma3TargetEntryData
        n row sparse ofColumn source hn hsource i j
      with
    ⟨_gammaPost, _gammaPre, _hgammaCleanup, hentryFalse, htargetEntry,
      htargetNormalizer, hcontractTargetEntry, hcontractGamma, hblockEntry,
      hblockEqContract, hfinalContract, hblockProjection, hblockCorrect,
      hblockExtraction⟩
  rcases
      oneTermRobinBlockEncodingProofRoute_ofCleanFunctionOracleEntry
        n ofRow ofCol hOfClean hOfBranch
      with
    ⟨hOfGate, _hOfCleanBranchEntry, hOfNormalizedEntry, _hOfBasis,
      hOfCleanRoute, _hOfGateUnitary, hFunctionSource, hFunctionAmp,
      hOfLcu, _hOfBlockProjection, _hOfBlockCorrect, _hOfBlockExtraction⟩
  rcases
      oneTermRobinBlockEncodingProofRoute_odtsKetZeroEntry
        n odtsRow odtsCol hOdtsIndicator hOdtsAncilla hOdtsRow
        hOdtsAncillaRow
      with
    ⟨hOdtsGate, hOdtsEntry, _hOdtsKetZero, hOdtsNormalized,
      _hOdtsDivision, _hOdtsBound, _hOdtsAbs, _hOdtsSqrt, hOdtsTwo,
      _hOdtsUnitary, _hOdtsLcu, _hOdtsBlockProjection,
      _hOdtsBlockCorrect, _hOdtsBlockExtraction⟩
  rcases
      oneTermRobinBlockEncodingProofRoute_boundaryKetZeroEntry
        n ryRow ryCol hRyIndicator hRyAncilla hRyRow hRyAncillaRow
      with
    ⟨hRyGate, hRyEntry, _hRyCosContract, hRyArccosArgument, _hRySource,
      _hNDNonzero, _hNDDivision, _hNDBound, _hNDAbs, _hNDSqrt,
      _hNDArccos, _hNDTwo, _hRyDivision, _hRyArccos, _hRyHalf,
      _hRyBound, hRyTwo, _hODTSUnitary, _hRyUnitary, hSparseCleanup,
      hSparseUnitary, _hFunctionSourceFromRy, _hFunctionAmpFromRy, hRyLcu,
      hcircuitUnitary, _hRyBlockProjection, _hRyBlockCorrect,
      _hRyBlockExtraction⟩
  rcases
      oneTermRobinBlockEncodingProofRoute_odbsActiveGlobalSourceCleanupContractMap
        n source hn hsource
      with
    ⟨post, pre, hcleanup, _hpost, _hpre, hpreSource, _hunique,
      hdaggerEntry, _hinverseFlag, _huniqueFlag, _himageFlag,
      _hdaggerFlag, _hunitaryFlag, hscope, hpromotion,
      _hcleanupOpen, _hunitaryOpen, _hOdbsLcu, _hOdbsBlockProjection,
      _hOdbsBlockCorrect, _hOdbsCircuitUnitary, _hOdbsBlockExtraction⟩
  rcases oneTermRobinBlockEncodingProofRoute_activeOdbsGatePairWiring n with
    ⟨_hOdbsGate, hOdbsMatrix, _hOdbsUnitary, _hDaggerGate,
      hDaggerMatrix, _hDaggerUnitary⟩
  exact ⟨post, pre, hcleanup, hentryFalse, htargetEntry,
    hcontractTargetEntry, htargetNormalizer, hcontractGamma, hblockEntry,
    hOfGate, hOfNormalizedEntry, hOfCleanRoute, hFunctionSource, hOdtsGate,
    hOdtsEntry, hOdtsNormalized, hOdtsTwo, hRyGate, hRyEntry,
    hRyArccosArgument, hRyTwo, hOdbsMatrix, hDaggerMatrix, hpreSource,
    hdaggerEntry, hscope, hpromotion, hSparseCleanup, hSparseUnitary,
    hFunctionSource, hblockEqContract, hfinalContract, hFunctionAmp,
    hRyLcu, hcircuitUnitary, hblockProjection, hblockCorrect,
    hblockExtraction⟩

/--
The gamma3 signal-block entry is the concrete seven-gate product entry.

This is a matrix-semantics bridge, not the final coefficient theorem.  It
consumes the factor-entry ledger and exposes that the signal-zero projected
entry is an entry of `evalGateMatrices` over the Fig. 1-term Robin gate list.
The finite product still has to be related to the Eq. `ROBIN clarified`
coefficient, so the normalized-block, LCU, projection, and extraction flags
remain false.
-/
theorem oneTermRobinBlockEncodingProofRoute_gamma3SignalBlockProductEntry
    (n row sparse ofColumn : Nat)
    (source : Fin
      (qubitDim (GHL2025.oneTermRobinTotalQubits (oneTermParameters n))))
    (hn : 3 <= n)
    (hsource : GHL2025.bandedSparseAccessPaperGlobalSlotSource
      (oneTermParameters n) source.val = true)
    (i j : Fin (gridSize n))
    (ofRow ofCol odtsRow odtsCol ryRow ryCol : Fin
      (qubitDim (GHL2025.oneTermRobinTotalQubits (oneTermParameters n))))
    (hOfClean :
      (GHL2025.functionOraclePaperImage
        (oneTermParameters n) ofCol.val).cleanWorkspaceBranch = true)
    (hOfBranch :
      ofRow.val =
        (GHL2025.functionOraclePaperImage
          (oneTermParameters n) ofCol.val).cleanBranchBasisIndex)
    (hOdtsIndicator :
      (GHL2025.sparseAmplitudeOracleDTPaperRegisters
        (oneTermParameters n) odtsCol.val).indicatorBit = 1)
    (hOdtsAncilla :
      (GHL2025.sparseAmplitudeOracleDTPaperRegisters
        (oneTermParameters n) odtsCol.val).ancillaBit = 0)
    (hOdtsRow :
      odtsRow.val >>> 1 =
        (GHL2025.sparseAmplitudeOracleDTPaperRegisters
          (oneTermParameters n) odtsCol.val).nonAncillaValue)
    (hOdtsAncillaRow : odtsRow.val &&& 1 = 0)
    (hRyIndicator :
      (GHL2025.boundaryRotationPaperRegisters
        (oneTermParameters n) ryCol.val).indicatorBit = 0)
    (hRyAncilla :
      (GHL2025.boundaryRotationPaperRegisters
        (oneTermParameters n) ryCol.val).ancillaBit = 0)
    (hRyRow :
      ryRow.val >>> 1 =
        (GHL2025.boundaryRotationPaperRegisters
          (oneTermParameters n) ryCol.val).nonAncillaValue)
    (hRyAncillaRow : ryRow.val &&& 1 = 0) :
    let p := oneTermParameters n
    let contract := oneTermRobinFiniteBlockCompositionContract n
    let entryObligation := oneTermRobinGamma3SignalBlockEntryObligation n
    let productMatrix :=
      evalGateMatrices (GHL2025.oneTermRobinGateMatrixPlaceholders p)
    ∃ (post pre : Fin
        (qubitDim (GHL2025.oneTermRobinTotalQubits p))),
      GHL2025.BandedSparseAccessPostSwapCleanup p source post pre ∧
        entryObligation.proved = false ∧
        contract.expectedTarget.blockMatrix i j =
          ((cast (by rw [oneTermRobinCircuitDimCompat n]) productMatrix :
            Matrix
              (qubitDim (GHL2025.effectiveRobinSignalQubits p) * gridSize n)
              (qubitDim (GHL2025.effectiveRobinSignalQubits p) * gridSize n)
              Coeff))
            ⟨signalSystemBlockRowIndex (gridSize n)
                contract.expectedTarget.signalIndex.val i.val,
              signalSystemBlockRowIndex_lt
                contract.expectedTarget.signalIndex i⟩
            ⟨signalSystemBlockColIndex (gridSize n)
                contract.expectedTarget.signalIndex.val j.val,
              signalSystemBlockColIndex_lt
                contract.expectedTarget.signalIndex j⟩ ∧
        (oneTermRobinBlockEncodingProofRoute n).circuitSemantics.matrix =
          productMatrix ∧
        (GHL2025.oneTermRobinGateMatrixPlaceholders p).map
          (fun gateMatrix => gateMatrix.gate) =
          GHL2025.oneTermRobinCircuit ∧
        (GHL2025.oneTermRobinGateMatrixPlaceholders p).map
          (fun gateMatrix => gateMatrix.unitary.proved) =
          [true, false, false, false, false, true, false] ∧
        contract.normalizedBlockEquality.proved = false ∧
        contract.finalExtraction.proved = false ∧
        (oneTermRobinBlockEncodingProofRoute n).oracleComposition.lcuCorrect.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).theoremData.obligations.circuitUnitary.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.blockProjection.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.blockCorrect.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).theoremData.obligations.blockExtraction.proved =
          false := by
  let p := oneTermParameters n
  rcases
      oneTermRobinBlockEncodingProofRoute_gamma3FactorEntryLedger
        n row sparse ofColumn source hn hsource i j
        ofRow ofCol odtsRow odtsCol ryRow ryCol
        hOfClean hOfBranch hOdtsIndicator hOdtsAncilla hOdtsRow
        hOdtsAncillaRow hRyIndicator hRyAncilla hRyRow hRyAncillaRow
      with
    ⟨post, pre, hcleanup, hentryFalse, _htargetEntry,
      _hcontractTargetEntry, _htargetNormalizer, _hcontractGamma,
      hblockEntry, _hOfGate, _hOfEntry, _hOfCleanRoute, _hFunctionSource,
      _hOdtsGate, _hOdtsEntry, _hOdtsNormalized, _hOdtsTwo, _hRyGate,
      _hRyEntry, _hRyArccosArgument, _hRyTwo, _hOdbsMatrix,
      _hDaggerMatrix, _hpreSource, _hdaggerEntry, _hscope, _hpromotion,
      _hSparseCleanup, _hSparseUnitary, _hFunctionSourceAgain,
      hblockEqContract, hfinalContract, _hFunctionAmp, hlcu,
      hcircuitUnitary, hblockProjection, hblockCorrect, hblockExtraction⟩
  have hblockProduct :
      (oneTermRobinFiniteBlockCompositionContract n).expectedTarget.blockMatrix i j =
        ((cast (by rw [oneTermRobinCircuitDimCompat n])
          (evalGateMatrices
            (GHL2025.oneTermRobinGateMatrixPlaceholders p)) :
          Matrix
            (qubitDim (GHL2025.effectiveRobinSignalQubits p) * gridSize n)
            (qubitDim (GHL2025.effectiveRobinSignalQubits p) * gridSize n)
            Coeff))
          ⟨signalSystemBlockRowIndex (gridSize n)
              (oneTermRobinFiniteBlockCompositionContract n).expectedTarget.signalIndex.val i.val,
            signalSystemBlockRowIndex_lt
              (oneTermRobinFiniteBlockCompositionContract n).expectedTarget.signalIndex i⟩
          ⟨signalSystemBlockColIndex (gridSize n)
              (oneTermRobinFiniteBlockCompositionContract n).expectedTarget.signalIndex.val j.val,
            signalSystemBlockColIndex_lt
              (oneTermRobinFiniteBlockCompositionContract n).expectedTarget.signalIndex j⟩ := by
    rw [hblockEntry]
    rfl
  have hrouteProduct :
      (oneTermRobinBlockEncodingProofRoute n).circuitSemantics.matrix =
        evalGateMatrices (GHL2025.oneTermRobinGateMatrixPlaceholders p) := rfl
  exact ⟨post, pre, hcleanup, hentryFalse, hblockProduct, hrouteProduct,
    GHL2025.oneTermRobinGateMatrixPlaceholders_gateList p,
    GHL2025.oneTermRobinGateMatrixPlaceholders_unitaryFlags p,
    hblockEqContract, hfinalContract, hlcu, hcircuitUnitary,
    hblockProjection, hblockCorrect, hblockExtraction⟩

/--
The gamma3 coefficient-entry contract is now tied to the Ak target.

This is still a contract bridge, not the finite coefficient theorem.  It
reuses the concrete signal-block product entry, the factor-entry ledger, and
the Ak target expansion
`oneTermRobinAkMatrix n i j = f(x_i) * D_ij`.  The product-to-coefficient
equality, LCU composition, oracle analytic correctness, cleanup, unitarity,
projection, and final extraction flags remain false.
-/
theorem oneTermRobinBlockEncodingProofRoute_gamma3AkCoefficientEntryContract
    (n row sparse ofColumn : Nat)
    (source : Fin
      (qubitDim (GHL2025.oneTermRobinTotalQubits (oneTermParameters n))))
    (hn : 3 <= n)
    (hsource : GHL2025.bandedSparseAccessPaperGlobalSlotSource
      (oneTermParameters n) source.val = true)
    (i j : Fin (gridSize n))
    (ofRow ofCol odtsRow odtsCol ryRow ryCol : Fin
      (qubitDim (GHL2025.oneTermRobinTotalQubits (oneTermParameters n))))
    (hOfClean :
      (GHL2025.functionOraclePaperImage
        (oneTermParameters n) ofCol.val).cleanWorkspaceBranch = true)
    (hOfBranch :
      ofRow.val =
        (GHL2025.functionOraclePaperImage
          (oneTermParameters n) ofCol.val).cleanBranchBasisIndex)
    (hOdtsIndicator :
      (GHL2025.sparseAmplitudeOracleDTPaperRegisters
        (oneTermParameters n) odtsCol.val).indicatorBit = 1)
    (hOdtsAncilla :
      (GHL2025.sparseAmplitudeOracleDTPaperRegisters
        (oneTermParameters n) odtsCol.val).ancillaBit = 0)
    (hOdtsRow :
      odtsRow.val >>> 1 =
        (GHL2025.sparseAmplitudeOracleDTPaperRegisters
          (oneTermParameters n) odtsCol.val).nonAncillaValue)
    (hOdtsAncillaRow : odtsRow.val &&& 1 = 0)
    (hRyIndicator :
      (GHL2025.boundaryRotationPaperRegisters
        (oneTermParameters n) ryCol.val).indicatorBit = 0)
    (hRyAncilla :
      (GHL2025.boundaryRotationPaperRegisters
        (oneTermParameters n) ryCol.val).ancillaBit = 0)
    (hRyRow :
      ryRow.val >>> 1 =
        (GHL2025.boundaryRotationPaperRegisters
          (oneTermParameters n) ryCol.val).nonAncillaValue)
    (hRyAncillaRow : ryRow.val &&& 1 = 0) :
    let p := oneTermParameters n
    let contract := oneTermRobinFiniteBlockCompositionContract n
    let entryObligation := oneTermRobinGamma3SignalBlockEntryObligation n
    let productMatrix :=
      evalGateMatrices (GHL2025.oneTermRobinGateMatrixPlaceholders p)
    let odtsRegs := GHL2025.sparseAmplitudeOracleDTPaperRegisters p odtsCol.val
    let ryRegs := GHL2025.boundaryRotationPaperRegisters p ryCol.val
    ∃ (post pre : Fin
        (qubitDim (GHL2025.oneTermRobinTotalQubits p))),
      GHL2025.BandedSparseAccessPostSwapCleanup p source post pre ∧
        entryObligation.proved = false ∧
        contract.expectedTarget.blockMatrix i j =
          ((cast (by rw [oneTermRobinCircuitDimCompat n]) productMatrix :
            Matrix
              (qubitDim (GHL2025.effectiveRobinSignalQubits p) * gridSize n)
              (qubitDim (GHL2025.effectiveRobinSignalQubits p) * gridSize n)
              Coeff))
            ⟨signalSystemBlockRowIndex (gridSize n)
                contract.expectedTarget.signalIndex.val i.val,
              signalSystemBlockRowIndex_lt
                contract.expectedTarget.signalIndex i⟩
            ⟨signalSystemBlockColIndex (gridSize n)
                contract.expectedTarget.signalIndex.val j.val,
              signalSystemBlockColIndex_lt
                contract.expectedTarget.signalIndex j⟩ ∧
        (oneTermRobinBlockEncodingProofRoute n).circuitSemantics.matrix =
          productMatrix ∧
        (GHL2025.oneTermRobinGateMatrixPlaceholders p).map
          (fun gateMatrix => gateMatrix.gate) =
          GHL2025.oneTermRobinCircuit ∧
        (GHL2025.oneTermRobinGateMatrixPlaceholders p).map
          (fun gateMatrix => gateMatrix.unitary.proved) =
          [true, false, false, false, false, true, false] ∧
        contract.expectedTarget.targetMatrix i j =
          oneTermRobinAkMatrix n i j ∧
        contract.targetMatrix i j =
          oneTermRobinAkMatrix n i j ∧
        oneTermRobinAkMatrix n i j =
          Coeff.mul (GHL2025.robinFunctionValue n i.val)
            (robinDerivativeMatrix n i j) ∧
        (((oneTermRobinBlockEncodingProofRoute n).circuitSemantics.gateMatrices.get
          ⟨4, by
            simp [oneTermRobinBlockEncodingProofRoute, oneTermRobinCircuitSemantics,
              GHL2025.oneTermRobinGateMatrixPlaceholders]⟩).gate =
          Gate.oracleCall "O_f") ∧
        (((oneTermRobinBlockEncodingProofRoute n).circuitSemantics.gateMatrices.get
          ⟨4, by
            simp [oneTermRobinBlockEncodingProofRoute, oneTermRobinCircuitSemantics,
              GHL2025.oneTermRobinGateMatrixPlaceholders]⟩).matrix ofRow ofCol =
          (GHL2025.functionOracleAmplitudeProofRoute
            p ofCol.val).normalizedAmplitude) ∧
        (GHL2025.functionOracleAmplitudeProofRoute
          p ofCol.val).cleanWorkspaceBranch = true ∧
        (GHL2025.functionOracleAmplitudeProofRoute
          p ofCol.val).unitaryCompletion.proved = false ∧
        (((oneTermRobinBlockEncodingProofRoute n).circuitSemantics.gateMatrices.get
          ⟨1, by
            simp [oneTermRobinBlockEncodingProofRoute, oneTermRobinCircuitSemantics,
              GHL2025.oneTermRobinGateMatrixPlaceholders]⟩).gate =
          Gate.oracleCall "O_DT^S") ∧
        (((oneTermRobinBlockEncodingProofRoute n).circuitSemantics.gateMatrices.get
          ⟨1, by
            simp [oneTermRobinBlockEncodingProofRoute, oneTermRobinCircuitSemantics,
              GHL2025.oneTermRobinGateMatrixPlaceholders]⟩).matrix odtsRow odtsCol =
          (GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute
            p odtsRegs.rowValue odtsRegs.sparseIndexValue).ketZeroEntry) ∧
        (GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute
          p odtsRegs.rowValue odtsRegs.sparseIndexValue).normalizedCoefficient =
          GHL2025.sparseAmplitudeOracleDTNormalizedCoefficient
            p odtsRegs.rowValue odtsRegs.sparseIndexValue ∧
        (GHL2025.oneTermRobinGate_O_DT_S p).unitary.proved = false ∧
        (((oneTermRobinBlockEncodingProofRoute n).circuitSemantics.gateMatrices.get
          ⟨2, by
            simp [oneTermRobinBlockEncodingProofRoute, oneTermRobinCircuitSemantics,
              GHL2025.oneTermRobinGateMatrixPlaceholders]⟩).gate =
          Gate.oracleCall "Ry_boundary") ∧
        (((oneTermRobinBlockEncodingProofRoute n).circuitSemantics.gateMatrices.get
          ⟨2, by
            simp [oneTermRobinBlockEncodingProofRoute, oneTermRobinCircuitSemantics,
              GHL2025.oneTermRobinGateMatrixPlaceholders]⟩).matrix ryRow ryCol =
          (GHL2025.boundaryRotationAngleNormalizerProofRoute
            p ryRegs.rowValue ryRegs.sparseIndexValue).cosHalfEntry) ∧
        (GHL2025.boundaryRotationAngleNormalizerProofRoute
          p ryRegs.rowValue ryRegs.sparseIndexValue).arccosArgument =
          GHL2025.boundaryRotationNormalizedCoefficient
            p ryRegs.rowValue ryRegs.sparseIndexValue ∧
        (GHL2025.oneTermRobinGate_Ry_boundary p).unitary.proved = false ∧
        (((oneTermRobinBlockEncodingProofRoute n).circuitSemantics.gateMatrices.get
          ⟨3, by
            simp [oneTermRobinBlockEncodingProofRoute, oneTermRobinCircuitSemantics,
              GHL2025.oneTermRobinGateMatrixPlaceholders]⟩).matrix =
          GHL2025.bandedSparseAccessPaperMatrix p) ∧
        (((oneTermRobinBlockEncodingProofRoute n).circuitSemantics.gateMatrices.get
          ⟨6, by
            simp [oneTermRobinBlockEncodingProofRoute, oneTermRobinCircuitSemantics,
              GHL2025.oneTermRobinGateMatrixPlaceholders]⟩).matrix =
          GHL2025.bandedSparseAccessPaperDaggerMatrix p) ∧
        GHL2025.bandedSparseAccessPaperGlobalSlotSource p pre.val = true ∧
        (GHL2025.oneTermRobinGate_O_D_BS_dagger p).matrix pre post =
          Coeff.rat 1 ∧
        (GHL2025.oneTermRobinGate_O_D_BS p).unitary.proved = false ∧
        (GHL2025.oneTermRobinGate_O_D_BS_dagger p).unitary.proved = false ∧
        (oneTermRobinBlockEncodingProofRoute n).cleanupScopeDecision.selectedScope =
          GHL2025.BandedSparseAccessCleanupScope.activeGlobalSource ∧
        (oneTermRobinBlockEncodingProofRoute n).cleanupScopeDecision.semanticCleanupPromotionAllowed =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).sparseAccessContract.daggerCleanup.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).sparseAccessContract.unitaryExtension.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).functionOracleSource.closesFunctionOracleContract =
          false ∧
        contract.lcuComposition.proved = false ∧
        contract.blockProjection.proved = false ∧
        contract.normalizedBlockEquality.proved = false ∧
        contract.finalExtraction.proved = false ∧
        (oneTermRobinBlockEncodingProofRoute n).oracleComposition.functionOracle.amplitudeCorrect.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).oracleComposition.lcuCorrect.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).theoremData.obligations.circuitUnitary.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.blockProjection.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.blockCorrect.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).theoremData.obligations.blockExtraction.proved =
          false := by
  let p := oneTermParameters n
  let odtsRegs := GHL2025.sparseAmplitudeOracleDTPaperRegisters p odtsCol.val
  let ryRegs := GHL2025.boundaryRotationPaperRegisters p ryCol.val
  rcases
      oneTermRobinBlockEncodingProofRoute_gamma3SignalBlockProductEntry
        n row sparse ofColumn source hn hsource i j
        ofRow ofCol odtsRow odtsCol ryRow ryCol
        hOfClean hOfBranch hOdtsIndicator hOdtsAncilla hOdtsRow
        hOdtsAncillaRow hRyIndicator hRyAncilla hRyRow hRyAncillaRow
      with
    ⟨_productPost, _productPre, _hproductCleanup, _hproductEntryFalse,
      _hproductBlock, hrouteProduct, hgateList, hgateFlags,
      _hproductBlockEq, _hproductFinal, _hproductLcu,
      _hproductCircuitUnitary, _hproductProjection, _hproductCorrect,
      _hproductExtraction⟩
  rcases
      oneTermRobinBlockEncodingProofRoute_gamma3FactorEntryLedger
        n row sparse ofColumn source hn hsource i j
        ofRow ofCol odtsRow odtsCol ryRow ryCol
        hOfClean hOfBranch hOdtsIndicator hOdtsAncilla hOdtsRow
        hOdtsAncillaRow hRyIndicator hRyAncilla hRyRow hRyAncillaRow
      with
    ⟨post, pre, hcleanup, hentryFalse, htargetEntry,
      hcontractTargetEntry, _htargetNormalizer, _hcontractGamma,
      hblockEntry, hOfGate, hOfEntry, hOfCleanRoute, hOfUnitary,
      hOdtsGate, hOdtsEntry, hOdtsNormalized, _hOdtsTwo, hRyGate,
      hRyEntry, hRyArccosArgument, _hRyTwo, hOdbsMatrix, hDaggerMatrix,
      hpreSource, hdaggerEntry, hscope, hpromotion, hSparseCleanup,
      hSparseUnitary, hFunctionSource, hblockEqContract, hfinalContract,
      hFunctionAmp, hlcu, hcircuitUnitary, hblockProjection, hblockCorrect,
      hblockExtraction⟩
  have hblockProduct :
      (oneTermRobinFiniteBlockCompositionContract n).expectedTarget.blockMatrix i j =
        ((cast (by rw [oneTermRobinCircuitDimCompat n])
          (evalGateMatrices
            (GHL2025.oneTermRobinGateMatrixPlaceholders p)) :
          Matrix
            (qubitDim (GHL2025.effectiveRobinSignalQubits p) * gridSize n)
            (qubitDim (GHL2025.effectiveRobinSignalQubits p) * gridSize n)
            Coeff))
          ⟨signalSystemBlockRowIndex (gridSize n)
              (oneTermRobinFiniteBlockCompositionContract n).expectedTarget.signalIndex.val i.val,
            signalSystemBlockRowIndex_lt
              (oneTermRobinFiniteBlockCompositionContract n).expectedTarget.signalIndex i⟩
          ⟨signalSystemBlockColIndex (gridSize n)
              (oneTermRobinFiniteBlockCompositionContract n).expectedTarget.signalIndex.val j.val,
            signalSystemBlockColIndex_lt
              (oneTermRobinFiniteBlockCompositionContract n).expectedTarget.signalIndex j⟩ := by
    rw [hblockEntry]
    rfl
  have hAkEntry :
      oneTermRobinAkMatrix n i j =
        Coeff.mul (GHL2025.robinFunctionValue n i.val)
          (robinDerivativeMatrix n i j) :=
    oneTermRobinAkMatrix_apply n i j
  exact ⟨post, pre, hcleanup, hentryFalse, hblockProduct, hrouteProduct,
    hgateList, hgateFlags, htargetEntry, hcontractTargetEntry, hAkEntry,
    hOfGate, hOfEntry, hOfCleanRoute, hOfUnitary, hOdtsGate, hOdtsEntry,
    hOdtsNormalized, rfl, hRyGate, hRyEntry, hRyArccosArgument, rfl,
    hOdbsMatrix, hDaggerMatrix, hpreSource, hdaggerEntry, rfl, rfl, hscope,
    hpromotion, hSparseCleanup, hSparseUnitary, hFunctionSource, rfl, rfl,
    hblockEqContract, hfinalContract, hFunctionAmp, hlcu, hcircuitUnitary,
    hblockProjection, hblockCorrect, hblockExtraction⟩

/--
Named product-to-coefficient obligation for the gamma3 entry.

The future theorem must multiply the already ledgered factor entries in the
signal-zero product into the normalized Ak entry.  This declaration only names
that remaining finite entry theorem; it does not assert the equality.
-/
def oneTermRobinGamma3ProductToCoefficientObligation
    (n : Nat) (_i _j : Fin (gridSize n)) : SemanticObligation where
  description :=
    "gamma3 product-to-coefficient theorem: the projected seven-gate product entry equals the Ak target entry normalized by N_D*N_f*kappa"
  source :=
    "GHL2025 Eq. ROBIN clarified gamma3 line, Theorem one-term block-encoding, Fig. 1-term ROBIN, Definition def:block-encoding; cited-results row LCU.StandardBlockEncoding"
  proved := false

theorem oneTermRobinGamma3ProductToCoefficientObligation_transcript
    (n : Nat) (i j : Fin (gridSize n)) :
    (oneTermRobinGamma3ProductToCoefficientObligation n i j).source =
        "GHL2025 Eq. ROBIN clarified gamma3 line, Theorem one-term block-encoding, Fig. 1-term ROBIN, Definition def:block-encoding; cited-results row LCU.StandardBlockEncoding" ∧
      (oneTermRobinGamma3ProductToCoefficientObligation n i j).proved =
        false := by
  exact ⟨rfl, rfl⟩

/--
Interface for the exact finite product-to-coefficient theorem.

This guard consumes the compiled gamma3 Ak coefficient-entry contract and
exposes the remaining theorem-facing obligation: the signal-zero product entry
must equal the Ak coefficient normalized by `N_D*N_f*kappa`.  It keeps the
entry obligation, LCU composition, projection, cleanup, unitarity, and final
extraction flags false.
-/
theorem oneTermRobinBlockEncodingProofRoute_gamma3ProductToCoefficientInterface
    (n row sparse ofColumn : Nat)
    (source : Fin
      (qubitDim (GHL2025.oneTermRobinTotalQubits (oneTermParameters n))))
    (hn : 3 <= n)
    (hsource : GHL2025.bandedSparseAccessPaperGlobalSlotSource
      (oneTermParameters n) source.val = true)
    (i j : Fin (gridSize n))
    (ofRow ofCol odtsRow odtsCol ryRow ryCol : Fin
      (qubitDim (GHL2025.oneTermRobinTotalQubits (oneTermParameters n))))
    (hOfClean :
      (GHL2025.functionOraclePaperImage
        (oneTermParameters n) ofCol.val).cleanWorkspaceBranch = true)
    (hOfBranch :
      ofRow.val =
        (GHL2025.functionOraclePaperImage
          (oneTermParameters n) ofCol.val).cleanBranchBasisIndex)
    (hOdtsIndicator :
      (GHL2025.sparseAmplitudeOracleDTPaperRegisters
        (oneTermParameters n) odtsCol.val).indicatorBit = 1)
    (hOdtsAncilla :
      (GHL2025.sparseAmplitudeOracleDTPaperRegisters
        (oneTermParameters n) odtsCol.val).ancillaBit = 0)
    (hOdtsRow :
      odtsRow.val >>> 1 =
        (GHL2025.sparseAmplitudeOracleDTPaperRegisters
          (oneTermParameters n) odtsCol.val).nonAncillaValue)
    (hOdtsAncillaRow : odtsRow.val &&& 1 = 0)
    (hRyIndicator :
      (GHL2025.boundaryRotationPaperRegisters
        (oneTermParameters n) ryCol.val).indicatorBit = 0)
    (hRyAncilla :
      (GHL2025.boundaryRotationPaperRegisters
        (oneTermParameters n) ryCol.val).ancillaBit = 0)
    (hRyRow :
      ryRow.val >>> 1 =
        (GHL2025.boundaryRotationPaperRegisters
          (oneTermParameters n) ryCol.val).nonAncillaValue)
    (hRyAncillaRow : ryRow.val &&& 1 = 0) :
    let p := oneTermParameters n
    let contract := oneTermRobinFiniteBlockCompositionContract n
    let entryObligation := oneTermRobinGamma3SignalBlockEntryObligation n
    let productToCoefficient :=
      oneTermRobinGamma3ProductToCoefficientObligation n i j
    let productMatrix :=
      evalGateMatrices (GHL2025.oneTermRobinGateMatrixPlaceholders p)
    let odtsRegs := GHL2025.sparseAmplitudeOracleDTPaperRegisters p odtsCol.val
    let ryRegs := GHL2025.boundaryRotationPaperRegisters p ryCol.val
    ∃ (post pre : Fin
        (qubitDim (GHL2025.oneTermRobinTotalQubits p))),
      GHL2025.BandedSparseAccessPostSwapCleanup p source post pre ∧
        productToCoefficient.source =
          "GHL2025 Eq. ROBIN clarified gamma3 line, Theorem one-term block-encoding, Fig. 1-term ROBIN, Definition def:block-encoding; cited-results row LCU.StandardBlockEncoding" ∧
        productToCoefficient.proved = false ∧
        entryObligation.proved = false ∧
        contract.expectedTarget.blockMatrix i j =
          ((cast (by rw [oneTermRobinCircuitDimCompat n]) productMatrix :
            Matrix
              (qubitDim (GHL2025.effectiveRobinSignalQubits p) * gridSize n)
              (qubitDim (GHL2025.effectiveRobinSignalQubits p) * gridSize n)
              Coeff))
            ⟨signalSystemBlockRowIndex (gridSize n)
                contract.expectedTarget.signalIndex.val i.val,
              signalSystemBlockRowIndex_lt
                contract.expectedTarget.signalIndex i⟩
            ⟨signalSystemBlockColIndex (gridSize n)
                contract.expectedTarget.signalIndex.val j.val,
              signalSystemBlockColIndex_lt
                contract.expectedTarget.signalIndex j⟩ ∧
        (oneTermRobinBlockEncodingProofRoute n).circuitSemantics.matrix =
          productMatrix ∧
        (GHL2025.oneTermRobinGateMatrixPlaceholders p).map
          (fun gateMatrix => gateMatrix.gate) =
          GHL2025.oneTermRobinCircuit ∧
        (GHL2025.oneTermRobinGateMatrixPlaceholders p).map
          (fun gateMatrix => gateMatrix.unitary.proved) =
          [true, false, false, false, false, true, false] ∧
        contract.expectedTarget.targetMatrix i j =
          oneTermRobinAkMatrix n i j ∧
        contract.targetMatrix i j =
          oneTermRobinAkMatrix n i j ∧
        oneTermRobinAkMatrix n i j =
          Coeff.mul (GHL2025.robinFunctionValue n i.val)
            (robinDerivativeMatrix n i j) ∧
        (((oneTermRobinBlockEncodingProofRoute n).circuitSemantics.gateMatrices.get
          ⟨4, by
            simp [oneTermRobinBlockEncodingProofRoute, oneTermRobinCircuitSemantics,
              GHL2025.oneTermRobinGateMatrixPlaceholders]⟩).matrix ofRow ofCol =
          (GHL2025.functionOracleAmplitudeProofRoute
            p ofCol.val).normalizedAmplitude) ∧
        (GHL2025.functionOracleAmplitudeProofRoute
          p ofCol.val).unitaryCompletion.proved = false ∧
        (((oneTermRobinBlockEncodingProofRoute n).circuitSemantics.gateMatrices.get
          ⟨1, by
            simp [oneTermRobinBlockEncodingProofRoute, oneTermRobinCircuitSemantics,
              GHL2025.oneTermRobinGateMatrixPlaceholders]⟩).matrix odtsRow odtsCol =
          (GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute
            p odtsRegs.rowValue odtsRegs.sparseIndexValue).ketZeroEntry) ∧
        (GHL2025.oneTermRobinGate_O_DT_S p).unitary.proved = false ∧
        (((oneTermRobinBlockEncodingProofRoute n).circuitSemantics.gateMatrices.get
          ⟨2, by
            simp [oneTermRobinBlockEncodingProofRoute, oneTermRobinCircuitSemantics,
              GHL2025.oneTermRobinGateMatrixPlaceholders]⟩).matrix ryRow ryCol =
          (GHL2025.boundaryRotationAngleNormalizerProofRoute
            p ryRegs.rowValue ryRegs.sparseIndexValue).cosHalfEntry) ∧
        (GHL2025.oneTermRobinGate_Ry_boundary p).unitary.proved = false ∧
        (GHL2025.oneTermRobinGate_O_D_BS_dagger p).matrix pre post =
          Coeff.rat 1 ∧
        (GHL2025.oneTermRobinGate_O_D_BS p).unitary.proved = false ∧
        (GHL2025.oneTermRobinGate_O_D_BS_dagger p).unitary.proved = false ∧
        (oneTermRobinBlockEncodingProofRoute n).sparseAccessContract.daggerCleanup.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).sparseAccessContract.unitaryExtension.proved =
          false ∧
        contract.lcuComposition.proved = false ∧
        contract.blockProjection.proved = false ∧
        contract.normalizedBlockEquality.proved = false ∧
        contract.finalExtraction.proved = false ∧
        (oneTermRobinBlockEncodingProofRoute n).oracleComposition.functionOracle.amplitudeCorrect.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).oracleComposition.lcuCorrect.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).theoremData.obligations.circuitUnitary.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.blockProjection.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.blockCorrect.proved =
          false ∧
        (oneTermRobinBlockEncodingProofRoute n).theoremData.obligations.blockExtraction.proved =
          false := by
  let p := oneTermParameters n
  let odtsRegs := GHL2025.sparseAmplitudeOracleDTPaperRegisters p odtsCol.val
  let ryRegs := GHL2025.boundaryRotationPaperRegisters p ryCol.val
  rcases
      oneTermRobinBlockEncodingProofRoute_gamma3AkCoefficientEntryContract
        n row sparse ofColumn source hn hsource i j
        ofRow ofCol odtsRow odtsCol ryRow ryCol
        hOfClean hOfBranch hOdtsIndicator hOdtsAncilla hOdtsRow
        hOdtsAncillaRow hRyIndicator hRyAncilla hRyRow hRyAncillaRow
      with
    ⟨post, pre, hcleanup, hentryFalse, hblockProduct, hrouteProduct,
      hgateList, hgateFlags, htargetEntry, hcontractTargetEntry, hAkEntry,
      _hOfGate, hOfEntry, _hOfCleanRoute, hOfUnitary, _hOdtsGate,
      hOdtsEntry, _hOdtsNormalized, hOdtsUnitary, _hRyGate, hRyEntry,
      _hRyArccosArgument, hRyUnitary, _hOdbsMatrix, _hDaggerMatrix,
      _hpreSource, hdaggerEntry, hOdbsUnitary, hOdbsDaggerUnitary,
      _hscope, _hpromotion, hSparseCleanup, hSparseUnitary,
      _hFunctionSource, hlcuContract, hprojectionContract, hblockEqContract,
      hfinalContract, hFunctionAmp, hlcu, hcircuitUnitary, hblockProjection,
      hblockCorrect, hblockExtraction⟩
  rcases
      oneTermRobinGamma3ProductToCoefficientObligation_transcript n i j
      with
    ⟨hproductSource, hproductFalse⟩
  exact ⟨post, pre, hcleanup, hproductSource, hproductFalse, hentryFalse,
    hblockProduct, hrouteProduct, hgateList, hgateFlags, htargetEntry,
    hcontractTargetEntry, hAkEntry, hOfEntry, hOfUnitary, hOdtsEntry,
    hOdtsUnitary, hRyEntry, hRyUnitary, hdaggerEntry, hOdbsUnitary,
    hOdbsDaggerUnitary, hSparseCleanup, hSparseUnitary, hlcuContract,
    hprojectionContract, hblockEqContract, hfinalContract, hFunctionAmp,
    hlcu, hcircuitUnitary, hblockProjection, hblockCorrect,
    hblockExtraction⟩

/--
Focused path-state audit for the current `n = 3` gamma3 product attempt.

The signal-zero projection sends system entry `(2, 5)` to the full entry
`(2, 5)`.  The executable gate images then show that the projected-column
forward path and the existing factor-entry ledger columns are not one coherent
seven-gate path.  This is a register-layout audit only: it does not unfold the
full product and does not promote any semantic proof flag.
-/
theorem oneTermRobinBlockEncodingProofRoute_gamma3ProjectionPathAudit_n3 :
    let p := oneTermParameters 3
    let fullDim := qubitDim (GHL2025.oneTermRobinTotalQubits p)
    let sysRow : Fin (gridSize 3) := ⟨2, by native_decide⟩
    let sysCol : Fin (gridSize 3) := ⟨5, by native_decide⟩
    let row2 : Fin fullDim := ⟨2, by native_decide⟩
    let row18 : Fin fullDim := ⟨18, by native_decide⟩
    let row192 : Fin fullDim := ⟨192, by native_decide⟩
    let col2 : Fin fullDim := ⟨2, by native_decide⟩
    let col160 : Fin fullDim := ⟨160, by native_decide⟩
    let col132 : Fin fullDim := ⟨132, by native_decide⟩
    let col133 : Fin fullDim := ⟨133, by native_decide⟩
    signalSystemBlockRowIndex (gridSize 3)
        (oneTermRobinFiniteBlockCompositionContract 3).expectedTarget.signalIndex.val
        sysRow.val = 2 ∧
      signalSystemBlockColIndex (gridSize 3)
        (oneTermRobinFiniteBlockCompositionContract 3).expectedTarget.signalIndex.val
        sysCol.val = 5 ∧
      GHL2025.indicatorOracleImage p 5 = 133 ∧
      (GHL2025.sparseAmplitudeOracleDTPaperRegisters p 133).indicatorBit = 1 ∧
      (GHL2025.sparseAmplitudeOracleDTPaperRegisters p 133).ancillaBit = 1 ∧
      (GHL2025.sparseAmplitudeOracleDTPaperRegisters p 133).rowValue = 2 ∧
      (GHL2025.sparseAmplitudeOracleDTPaperRegisters p 133).sparseIndexValue = 0 ∧
      GHL2025.sparseAmplitudeOracleDTRotationMatrix p col132 col133 =
        Coeff.neg (Coeff.symbol "odts_sin_half_2_0") ∧
      GHL2025.boundaryRotationMatrix p col132 col132 = Coeff.rat 1 ∧
      GHL2025.bandedSparseAccessPaperImage p 132 = 132 ∧
      (GHL2025.functionOraclePaperImage p 132).cleanBranchBasisIndex = 132 ∧
      (GHL2025.functionOraclePaperImage p 132).cleanBranchSystemValue = 2 ∧
      GHL2025.swapOracleImage p 132 = 160 ∧
      GHL2025.bandedSparseAccessPaperDaggerMatrix p row192 col160 =
        Coeff.rat 1 ∧
      GHL2025.bandedSparseAccessPaperDaggerMatrix p row2 col160 =
        Coeff.rat 0 ∧
      GHL2025.bandedSparseAccessPaperImage p 48 = 16 ∧
      (GHL2025.functionOraclePaperImage p 16).cleanBranchSystemValue = 0 ∧
      GHL2025.swapOracleImage p 16 = 2 ∧
      GHL2025.bandedSparseAccessPaperPostSwapPreimageCandidate p 48 = 18 ∧
      GHL2025.bandedSparseAccessPaperDaggerMatrix p row18 col2 =
        Coeff.rat 1 ∧
      18 ≠ 2 ∧
      16 ≠ 36 ∧
      (GHL2025.functionOraclePaperImage p 36).cleanBranchBasisIndex = 36 ∧
      (GHL2025.functionOraclePaperImage p 36).cleanBranchAmplitude =
        Coeff.mul (Coeff.symbol "f_3_2") (Coeff.symbol "N_f_inv") ∧
      GHL2025.sparseAmplitudeOracleDTRotationMatrix p col132 col132 =
        Coeff.symbol "odts_cos_half_2_0" ∧
      GHL2025.boundaryRotationMatrix p
          ⟨0, by native_decide⟩ ⟨0, by native_decide⟩ =
        Coeff.symbol "boundary_cos_half_0_0" ∧
      GHL2025.bandedSparseAccessPaperImage p 2 = 114 ∧
      GHL2025.swapOracleImage p 30 = 114 ∧
      GHL2025.bandedSparseAccessPaperImage p 78 = 30 ∧
      (GHL2025.functionOraclePaperImage p 30).cleanBranchSystemValue = 7 ∧
      (oneTermRobinGamma3ProductToCoefficientObligation 3 sysRow sysCol).proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute 3).oracleComposition.lcuCorrect.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute 3).blockClaim.target.blockProjection.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute 3).blockClaim.target.blockCorrect.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute 3).theoremData.obligations.blockExtraction.proved =
        false := by
  native_decide

/--
Full-basis index for the clean `gamma3` ket layout in Eq. `ROBIN clarified`.

This is a Phase 1 layout helper, not a new projection convention.  It places
the trailing rotation ancilla at bit `0`, the system register in bits
`[1, 1+n)`, the padded `O_D^BS` zero register next, and the sparse slot above
that padded register, with all higher `m_f` and indicator workspace bits set to
zero.
-/
def oneTermRobinGamma3PaperBasisIndex
    (p : GHL2025.OneTermRobinParameters) (s j : Nat) : Nat :=
  let odPure := p.n - clog2 p.kappa
  (s <<< (1 + p.n + odPure)) + (j <<< 1)

/--
Layout contract for the next gamma3 path attempt at `n = 3`.

Eq. `ROBIN clarified` places the clean `gamma3` basis states for system entry
`(2, 5)` at full indices `(4, 10)` when the sparse slot is `0`.  The existing
`signalSystemBlockProjection` convention instead selects full indices `(2, 5)`.
This theorem records that mismatch together with the relevant clean-register
extractions, so the product-to-coefficient route can choose a coherent block
index before applying the reusable unique-path product lemma.
-/
theorem oneTermRobinBlockEncodingProofRoute_gamma3PaperBasisLayout_n3 :
    let p := oneTermParameters 3
    let sysRow : Fin (gridSize 3) := ⟨2, by native_decide⟩
    let sysCol : Fin (gridSize 3) := ⟨5, by native_decide⟩
    let projectedRow :=
      signalSystemBlockRowIndex (gridSize 3)
        (oneTermRobinFiniteBlockCompositionContract 3).expectedTarget.signalIndex.val
        sysRow.val
    let projectedCol :=
      signalSystemBlockColIndex (gridSize 3)
        (oneTermRobinFiniteBlockCompositionContract 3).expectedTarget.signalIndex.val
        sysCol.val
    let paperRow := oneTermRobinGamma3PaperBasisIndex p 0 sysRow.val
    let paperCol := oneTermRobinGamma3PaperBasisIndex p 0 sysCol.val
    paperRow = 4 ∧
      paperCol = 10 ∧
      projectedRow = 2 ∧
      projectedCol = 5 ∧
      paperRow ≠ projectedRow ∧
      paperCol ≠ projectedCol ∧
      (GHL2025.bandedSparseAccessPaperRegisters p paperRow).rowValue = 2 ∧
      (GHL2025.bandedSparseAccessPaperRegisters p paperRow).paddedZeroValue = 0 ∧
      (GHL2025.bandedSparseAccessPaperRegisters p paperRow).sparseIndexValue = 0 ∧
      GHL2025.bandedSparseAccessPaperGlobalSlotSource p paperRow = true ∧
      (GHL2025.functionOraclePaperRegisters p paperRow).cleanWorkspace = true ∧
      (GHL2025.functionOraclePaperImage p paperRow).cleanBranchBasisIndex =
        paperRow ∧
      (GHL2025.functionOraclePaperImage p paperRow).cleanBranchSystemValue =
        2 ∧
      (GHL2025.bandedSparseAccessPaperRegisters p paperCol).rowValue = 5 ∧
      (GHL2025.bandedSparseAccessPaperRegisters p paperCol).paddedZeroValue = 0 ∧
      (GHL2025.bandedSparseAccessPaperRegisters p paperCol).sparseIndexValue = 0 ∧
      GHL2025.bandedSparseAccessPaperGlobalSlotSource p paperCol = true ∧
      (GHL2025.functionOraclePaperRegisters p paperCol).cleanWorkspace = true ∧
      (GHL2025.functionOraclePaperImage p paperCol).cleanBranchBasisIndex =
        paperCol ∧
      (GHL2025.functionOraclePaperImage p paperCol).cleanBranchSystemValue =
        5 ∧
      GHL2025.indicatorOracleImage p paperCol = 138 ∧
      (GHL2025.sparseAmplitudeOracleDTPaperRegisters p 138).indicatorBit = 1 ∧
      (GHL2025.sparseAmplitudeOracleDTPaperRegisters p 138).ancillaBit = 0 ∧
      (GHL2025.sparseAmplitudeOracleDTPaperRegisters p 138).rowValue = 5 ∧
      (GHL2025.sparseAmplitudeOracleDTPaperRegisters p 138).sparseIndexValue =
        0 := by
  native_decide

/--
Focused Fig. 1-term Robin path audit for the clean `gamma3` paper-basis
endpoints at `n = 3`.

Starting from the paper clean-column index `10`, the ket-zero branch follows the
active seven-gate images to final dagger row `198`, not to the paper clean-row
index `4`.  The first decisive drift is the active `O_D^BS` sparse-slot-zero
address: after `U_indic` and the identity `Ry_boundary` branch, it writes
address `3`, so SWAP exposes system row `3` before the dagger cleanup.  This is
a path-state audit only; it does not apply the unique-path product lemma and
does not promote any semantic proof flag.
-/
theorem oneTermRobinBlockEncodingProofRoute_gamma3PaperBasisPathAudit_n3 :
    let p := oneTermParameters 3
    let fullDim := qubitDim (GHL2025.oneTermRobinTotalQubits p)
    let row4 : Fin fullDim := ⟨4, by native_decide⟩
    let row198 : Fin fullDim := ⟨198, by native_decide⟩
    let col10 : Fin fullDim := ⟨10, by native_decide⟩
    let col138 : Fin fullDim := ⟨138, by native_decide⟩
    let col139 : Fin fullDim := ⟨139, by native_decide⟩
    let col186 : Fin fullDim := ⟨186, by native_decide⟩
    let col187 : Fin fullDim := ⟨187, by native_decide⟩
    let col214 : Fin fullDim := ⟨214, by native_decide⟩
    let col215 : Fin fullDim := ⟨215, by native_decide⟩
    oneTermRobinGamma3PaperBasisIndex p 0 2 = 4 ∧
      oneTermRobinGamma3PaperBasisIndex p 0 5 = 10 ∧
      (oneTermRobinBlockEncodingProofRoute 3).circuitSemantics.gateMatrices.map
          (fun gateMatrix => gateMatrix.gate) =
        GHL2025.oneTermRobinCircuit ∧
      (oneTermRobinBlockEncodingProofRoute 3).circuitSemantics.gateMatrices.map
          (fun gateMatrix => gateMatrix.unitary.proved) =
        [true, false, false, false, false, true, false] ∧
      GHL2025.indicatorOracleImage p 10 = 138 ∧
      GHL2025.indicatorOracleMatrix p col138 col10 = Coeff.rat 1 ∧
      (GHL2025.sparseAmplitudeOracleDTPaperRegisters p 138).indicatorBit = 1 ∧
      (GHL2025.sparseAmplitudeOracleDTPaperRegisters p 138).ancillaBit = 0 ∧
      (GHL2025.sparseAmplitudeOracleDTPaperRegisters p 138).rowValue = 5 ∧
      (GHL2025.sparseAmplitudeOracleDTPaperRegisters p 138).sparseIndexValue =
        0 ∧
      GHL2025.sparseAmplitudeOracleDTRotationMatrix p col138 col138 =
        Coeff.symbol "odts_cos_half_5_0" ∧
      GHL2025.sparseAmplitudeOracleDTRotationMatrix p col139 col138 =
        Coeff.symbol "odts_sin_half_5_0" ∧
      GHL2025.boundaryRotationMatrix p col138 col138 = Coeff.rat 1 ∧
      GHL2025.boundaryRotationMatrix p col139 col139 = Coeff.rat 1 ∧
      GHL2025.bandedSparseAccessPaperImage p 138 = 186 ∧
      GHL2025.bandedSparseAccessPaperImage p 139 = 187 ∧
      GHL2025.bandedSparseAccessPaperMatrix p col186 col138 = Coeff.rat 1 ∧
      GHL2025.bandedSparseAccessPaperMatrix p col187 col139 = Coeff.rat 1 ∧
      (GHL2025.bandedSparseAccessPaperRegisters p 186).odRegisterValue = 3 ∧
      (GHL2025.bandedSparseAccessPaperRegisters p 186).rowValue = 5 ∧
      (GHL2025.functionOraclePaperImage p 186).cleanBranchBasisIndex = 186 ∧
      (GHL2025.functionOraclePaperImage p 186).cleanBranchSystemValue = 5 ∧
      (GHL2025.functionOraclePaperImage p 186).cleanBranchAmplitude =
        Coeff.mul (Coeff.symbol "f_3_5") (Coeff.symbol "N_f_inv") ∧
      GHL2025.functionOraclePaperMatrix p col186 col186 =
        Coeff.mul (Coeff.symbol "f_3_5") (Coeff.symbol "N_f_inv") ∧
      GHL2025.swapOracleImage p 186 = 214 ∧
      GHL2025.swapOracleImage p 187 = 215 ∧
      GHL2025.swapOracleMatrix p col214 col186 = Coeff.rat 1 ∧
      GHL2025.swapOracleMatrix p col215 col187 = Coeff.rat 1 ∧
      GHL2025.bandedSparseAccessPaperPostSwapPreimageCandidate p 138 = 198 ∧
      GHL2025.bandedSparseAccessPaperImage p 198 = 214 ∧
      GHL2025.bandedSparseAccessPaperDaggerMatrix p row198 col214 =
        Coeff.rat 1 ∧
      GHL2025.bandedSparseAccessPaperDaggerMatrix p row4 col214 =
        Coeff.rat 0 ∧
      (GHL2025.bandedSparseAccessPaperRegisters p 214).rowValue = 3 ∧
      (GHL2025.bandedSparseAccessPaperRegisters p 198).rowValue = 3 ∧
      198 ≠ 4 ∧
      (oneTermRobinGamma3ProductToCoefficientObligation
          3 ⟨2, by native_decide⟩ ⟨5, by native_decide⟩).proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute 3).oracleComposition.lcuCorrect.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute 3).blockClaim.target.blockProjection.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute 3).blockClaim.target.blockCorrect.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute 3).theoremData.obligations.blockExtraction.proved =
        false := by
  native_decide

/--
Sparse-slot alignment audit for the focused `n = 3` gamma3 coefficient
`D_{2,5}`.

The slot-zero paper-basis path remains useful negative evidence: it maps source
column `5` to address `3`, so it cannot be the route for target row `2`.
The finite global-slot table instead selects slot `5`, the `-3` diagonal, for
the coefficient from source column `5` to target row `2`.  This theorem only
chooses the slot and clean endpoint data needed by the next path isolation
packet; it does not apply the unique-path multiplication lemma or promote any
semantic proof flag.
-/
theorem oneTermRobinBlockEncodingProofRoute_gamma3SparseSlotAlignment_n3 :
    let p := oneTermParameters 3
    let fullDim := qubitDim (GHL2025.oneTermRobinTotalQubits p)
    let slot0Col := oneTermRobinGamma3PaperBasisIndex p 0 5
    let slot5Row := oneTermRobinGamma3PaperBasisIndex p 5 2
    let slot5Col := oneTermRobinGamma3PaperBasisIndex p 5 5
    let slot5Image := GHL2025.bandedSparseAccessPaperImage p slot5Col
    let row4 : Fin fullDim := ⟨4, by native_decide⟩
    let col214 : Fin fullDim := ⟨214, by native_decide⟩
    GHL2025.oneTermRobinGlobalSparseOffset 3 0 = 6 ∧
      GHL2025.oneTermRobinGlobalSparseAddress 3 0 5 = 3 ∧
      GHL2025.oneTermRobinGlobalSparseOffset 3 5 = 5 ∧
      GHL2025.oneTermRobinGlobalSparseAddress 3 5 5 = 2 ∧
      GHL2025.oneTermRobinGlobalSparseAddress 3 5 5 ≠
        GHL2025.oneTermRobinGlobalSparseAddress 3 0 5 ∧
      oneTermRobinGamma3PaperBasisIndex p 0 5 = 10 ∧
      oneTermRobinGamma3PaperBasisIndex p 5 2 = 84 ∧
      oneTermRobinGamma3PaperBasisIndex p 5 5 = 90 ∧
      slot5Row = 84 ∧
      slot5Col = 90 ∧
      (GHL2025.bandedSparseAccessPaperRegisters p slot5Col).rowValue = 5 ∧
      (GHL2025.bandedSparseAccessPaperRegisters p slot5Col).paddedZeroValue = 0 ∧
      (GHL2025.bandedSparseAccessPaperRegisters p slot5Col).sparseIndexValue =
        5 ∧
      GHL2025.bandedSparseAccessPaperGlobalSlotSource p slot5Col = true ∧
      GHL2025.bandedSparseAccessPaperAddress p slot5Col = 2 ∧
      slot5Image = 42 ∧
      (GHL2025.bandedSparseAccessPaperRegisters p slot5Image).rowValue = 5 ∧
      (GHL2025.bandedSparseAccessPaperRegisters p slot5Image).odRegisterValue =
        2 ∧
      GHL2025.swapOracleImage p slot5Image = slot5Row ∧
      (GHL2025.bandedSparseAccessPaperRegisters p slot5Row).rowValue = 2 ∧
      (GHL2025.bandedSparseAccessPaperRegisters p slot5Row).paddedZeroValue = 0 ∧
      (GHL2025.bandedSparseAccessPaperRegisters p slot5Row).sparseIndexValue =
        5 ∧
      GHL2025.bandedSparseAccessPaperGlobalSlotSource p slot5Row = true ∧
      GHL2025.indicatorOracleImage p slot5Col = 218 ∧
      (GHL2025.sparseAmplitudeOracleDTPaperRegisters p 218).rowValue = 5 ∧
      (GHL2025.sparseAmplitudeOracleDTPaperRegisters p 218).sparseIndexValue =
        5 ∧
      GHL2025.bandedSparseAccessPaperAddress p slot0Col = 3 ∧
      GHL2025.bandedSparseAccessPaperImage p 138 = 186 ∧
      (GHL2025.bandedSparseAccessPaperRegisters p 186).odRegisterValue = 3 ∧
      GHL2025.bandedSparseAccessPaperPostSwapPreimageCandidate p 138 = 198 ∧
      GHL2025.bandedSparseAccessPaperImage p 198 = 214 ∧
      GHL2025.bandedSparseAccessPaperDaggerMatrix p row4 col214 =
        Coeff.rat 0 ∧
      (oneTermRobinGamma3ProductToCoefficientObligation
          3 ⟨2, by native_decide⟩ ⟨5, by native_decide⟩).proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute 3).oracleComposition.lcuCorrect.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute 3).blockClaim.target.blockProjection.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute 3).blockClaim.target.blockCorrect.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute 3).theoremData.obligations.blockExtraction.proved =
        false := by
  native_decide

/--
Source-contract obligation for the gamma3 projection-slot convention.

Eq. `ROBIN clarified` sums the clean `gamma3` branch over sparse slots.  The
finite path audit for a matrix entry therefore needs an interface that relates
the slot-specific clean basis state with `s` satisfying `r_{s,j}=i` to the
theorem-level signal-zero block projection or sparse-register summation.  This
declaration names that missing convention without proving it.
-/
def oneTermRobinGamma3ProjectionSlotConventionObligation
    (n : Nat) (_i _j : Fin (gridSize n)) : SemanticObligation where
  description :=
    "gamma3 projection-slot convention: relate the slot-specific clean branch with r_{s,j}=i to the theorem-level signal-zero block projection or sparse-register summation before applying the seven-gate product equality"
  source :=
    "GHL2025 Eq. ROBIN clarified gamma3 line, Theorem one-term block-encoding, Fig. 1-term ROBIN, Definition def:block-encoding, Lemma Banded-sparse-access-oracle"
  proved := false

theorem oneTermRobinGamma3ProjectionSlotConventionObligation_transcript
    (n : Nat) (i j : Fin (gridSize n)) :
    (oneTermRobinGamma3ProjectionSlotConventionObligation n i j).source =
        "GHL2025 Eq. ROBIN clarified gamma3 line, Theorem one-term block-encoding, Fig. 1-term ROBIN, Definition def:block-encoding, Lemma Banded-sparse-access-oracle" ∧
      (oneTermRobinGamma3ProjectionSlotConventionObligation n i j).proved =
        false := by
  exact ⟨rfl, rfl⟩

/--
Focused projection-slot contract map for the compiled `n = 3` gamma3 audit.

The previous slot-alignment audit shows that the coefficient for the system
entry `(2, 5)` uses sparse slot `5`, not slot `0`.  This theorem packages the
slot-specific clean endpoints `90` and `84` and records that they are still not
the generic signal-zero projection endpoints `(2, 5)`.  The remaining
projection-slot convention is deliberately kept as an unproved obligation.
-/
theorem oneTermRobinBlockEncodingProofRoute_gamma3ProjectionSlotConventionMap_n3 :
    let p := oneTermParameters 3
    let sysRow : Fin (gridSize 3) := ⟨2, by native_decide⟩
    let sysCol : Fin (gridSize 3) := ⟨5, by native_decide⟩
    let projectionObligation :=
      oneTermRobinGamma3ProjectionSlotConventionObligation 3 sysRow sysCol
    let productObligation :=
      oneTermRobinGamma3ProductToCoefficientObligation 3 sysRow sysCol
    let projectedRow :=
      signalSystemBlockRowIndex (gridSize 3)
        (oneTermRobinFiniteBlockCompositionContract 3).expectedTarget.signalIndex.val
        sysRow.val
    let projectedCol :=
      signalSystemBlockColIndex (gridSize 3)
        (oneTermRobinFiniteBlockCompositionContract 3).expectedTarget.signalIndex.val
        sysCol.val
    let slot5Row := oneTermRobinGamma3PaperBasisIndex p 5 sysRow.val
    let slot5Col := oneTermRobinGamma3PaperBasisIndex p 5 sysCol.val
    projectionObligation.source =
        "GHL2025 Eq. ROBIN clarified gamma3 line, Theorem one-term block-encoding, Fig. 1-term ROBIN, Definition def:block-encoding, Lemma Banded-sparse-access-oracle" ∧
      projectionObligation.proved = false ∧
      GHL2025.oneTermRobinGlobalSparseAddress 3 5 5 = 2 ∧
      projectedRow = 2 ∧
      projectedCol = 5 ∧
      slot5Row = 84 ∧
      slot5Col = 90 ∧
      slot5Row ≠ projectedRow ∧
      slot5Col ≠ projectedCol ∧
      (GHL2025.bandedSparseAccessPaperRegisters p slot5Col).rowValue = 5 ∧
      (GHL2025.bandedSparseAccessPaperRegisters p slot5Col).sparseIndexValue =
        5 ∧
      (GHL2025.bandedSparseAccessPaperRegisters p slot5Col).paddedZeroValue =
        0 ∧
      GHL2025.bandedSparseAccessPaperGlobalSlotSource p slot5Col = true ∧
      GHL2025.bandedSparseAccessPaperAddress p slot5Col = 2 ∧
      GHL2025.bandedSparseAccessPaperImage p slot5Col = 42 ∧
      GHL2025.swapOracleImage p (GHL2025.bandedSparseAccessPaperImage p slot5Col) =
        slot5Row ∧
      (GHL2025.bandedSparseAccessPaperRegisters p slot5Row).rowValue = 2 ∧
      (GHL2025.bandedSparseAccessPaperRegisters p slot5Row).sparseIndexValue =
        5 ∧
      GHL2025.bandedSparseAccessPaperGlobalSlotSource p slot5Row = true ∧
      GHL2025.indicatorOracleImage p slot5Col = 218 ∧
      (GHL2025.sparseAmplitudeOracleDTPaperRegisters p 218).rowValue = 5 ∧
      (GHL2025.sparseAmplitudeOracleDTPaperRegisters p 218).sparseIndexValue =
        5 ∧
      productObligation.proved = false ∧
      (oneTermRobinBlockEncodingProofRoute 3).oracleComposition.lcuCorrect.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute 3).blockClaim.target.blockProjection.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute 3).blockClaim.target.blockCorrect.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute 3).theoremData.obligations.blockExtraction.proved =
        false := by
  native_decide

/--
Focused Fig. 1-term Robin path audit for the slot-`5` clean `gamma3`
endpoints at `n = 3`.

The slot-alignment map gives the clean endpoint chain `90 -> 42 -> 84` if the
path starts directly at `O_D^BS`.  The actual seven-gate circuit first applies
`U_indic`, which flips the indicator bit for system column `5`, so the active
path starts from `218`.  The ket-zero branch then reaches final dagger row
`228`, not the slot-specific clean row `84`.  This declaration records the
adjacent states only; it does not apply a product lemma or promote any semantic
proof flag.
-/
theorem oneTermRobinBlockEncodingProofRoute_gamma3Slot5PathAudit_n3 :
    let p := oneTermParameters 3
    let fullDim := qubitDim (GHL2025.oneTermRobinTotalQubits p)
    let sysRow : Fin (gridSize 3) := ⟨2, by native_decide⟩
    let sysCol : Fin (gridSize 3) := ⟨5, by native_decide⟩
    let slot5Row := oneTermRobinGamma3PaperBasisIndex p 5 sysRow.val
    let slot5Col := oneTermRobinGamma3PaperBasisIndex p 5 sysCol.val
    let afterIndic := GHL2025.indicatorOracleImage p slot5Col
    let odtsKetOne := afterIndic + 1
    let afterOdbsKetZero := GHL2025.bandedSparseAccessPaperImage p afterIndic
    let afterOdbsKetOne := GHL2025.bandedSparseAccessPaperImage p odtsKetOne
    let afterSwapKetZero := GHL2025.swapOracleImage p afterOdbsKetZero
    let afterSwapKetOne := GHL2025.swapOracleImage p afterOdbsKetOne
    let daggerPreKetZero :=
      GHL2025.bandedSparseAccessPaperPostSwapPreimageCandidate p afterIndic
    let daggerPreKetOne :=
      GHL2025.bandedSparseAccessPaperPostSwapPreimageCandidate p odtsKetOne
    let row84 : Fin fullDim := ⟨84, by native_decide⟩
    let row85 : Fin fullDim := ⟨85, by native_decide⟩
    let row228 : Fin fullDim := ⟨228, by native_decide⟩
    let row229 : Fin fullDim := ⟨229, by native_decide⟩
    let col90 : Fin fullDim := ⟨90, by native_decide⟩
    let col218 : Fin fullDim := ⟨218, by native_decide⟩
    let col219 : Fin fullDim := ⟨219, by native_decide⟩
    let col170 : Fin fullDim := ⟨170, by native_decide⟩
    let col171 : Fin fullDim := ⟨171, by native_decide⟩
    let col212 : Fin fullDim := ⟨212, by native_decide⟩
    let col213 : Fin fullDim := ⟨213, by native_decide⟩
    slot5Col = 90 ∧
      slot5Row = 84 ∧
      GHL2025.oneTermRobinGlobalSparseAddress 3 5 5 = 2 ∧
      GHL2025.bandedSparseAccessPaperImage p slot5Col = 42 ∧
      GHL2025.swapOracleImage p (GHL2025.bandedSparseAccessPaperImage p slot5Col) =
        slot5Row ∧
      (GHL2025.sparseAmplitudeOracleDTPaperRegisters p slot5Col).indicatorBit =
        0 ∧
      afterIndic = 218 ∧
      GHL2025.indicatorOracleMatrix p col218 col90 = Coeff.rat 1 ∧
      (GHL2025.sparseAmplitudeOracleDTPaperRegisters p afterIndic).indicatorBit =
        1 ∧
      (GHL2025.sparseAmplitudeOracleDTPaperRegisters p afterIndic).ancillaBit =
        0 ∧
      (GHL2025.sparseAmplitudeOracleDTPaperRegisters p afterIndic).rowValue =
        5 ∧
      (GHL2025.sparseAmplitudeOracleDTPaperRegisters p afterIndic).sparseIndexValue =
        5 ∧
      GHL2025.sparseAmplitudeOracleDTRotationMatrix p col218 col218 =
        Coeff.symbol "odts_cos_half_5_5" ∧
      GHL2025.sparseAmplitudeOracleDTRotationMatrix p col219 col218 =
        Coeff.symbol "odts_sin_half_5_5" ∧
      GHL2025.boundaryRotationMatrix p col218 col218 = Coeff.rat 1 ∧
      GHL2025.boundaryRotationMatrix p col219 col219 = Coeff.rat 1 ∧
      afterOdbsKetZero = 170 ∧
      afterOdbsKetOne = 171 ∧
      GHL2025.bandedSparseAccessPaperMatrix p col170 col218 = Coeff.rat 1 ∧
      GHL2025.bandedSparseAccessPaperMatrix p col171 col219 = Coeff.rat 1 ∧
      (GHL2025.functionOraclePaperImage p afterOdbsKetZero).cleanBranchBasisIndex =
        afterOdbsKetZero ∧
      (GHL2025.functionOraclePaperImage p afterOdbsKetZero).cleanBranchSystemValue =
        5 ∧
      (GHL2025.functionOraclePaperImage p afterOdbsKetZero).cleanBranchAmplitude =
        Coeff.mul (Coeff.symbol "f_3_5") (Coeff.symbol "N_f_inv") ∧
      GHL2025.functionOraclePaperMatrix p col170 col170 =
        Coeff.mul (Coeff.symbol "f_3_5") (Coeff.symbol "N_f_inv") ∧
      GHL2025.functionOraclePaperMatrix p col171 col171 =
        Coeff.mul (Coeff.symbol "f_3_5") (Coeff.symbol "N_f_inv") ∧
      afterSwapKetZero = 212 ∧
      afterSwapKetOne = 213 ∧
      GHL2025.swapOracleMatrix p col212 col170 = Coeff.rat 1 ∧
      GHL2025.swapOracleMatrix p col213 col171 = Coeff.rat 1 ∧
      daggerPreKetZero = 228 ∧
      daggerPreKetOne = 229 ∧
      GHL2025.bandedSparseAccessPaperImage p daggerPreKetZero = afterSwapKetZero ∧
      GHL2025.bandedSparseAccessPaperImage p daggerPreKetOne = afterSwapKetOne ∧
      GHL2025.bandedSparseAccessPaperImage p slot5Row = 116 ∧
      GHL2025.bandedSparseAccessPaperDaggerMatrix p row228 col212 =
        Coeff.rat 1 ∧
      GHL2025.bandedSparseAccessPaperDaggerMatrix p row84 col212 =
        Coeff.rat 0 ∧
      GHL2025.bandedSparseAccessPaperDaggerMatrix p row229 col213 =
        Coeff.rat 1 ∧
      GHL2025.bandedSparseAccessPaperDaggerMatrix p row85 col213 =
        Coeff.rat 0 ∧
      daggerPreKetZero ≠ slot5Row ∧
      daggerPreKetOne ≠ slot5Row + 1 ∧
      (GHL2025.bandedSparseAccessPaperRegisters p daggerPreKetZero).rowValue =
        2 ∧
      (GHL2025.bandedSparseAccessPaperRegisters p daggerPreKetZero).sparseIndexValue =
        6 ∧
      (GHL2025.bandedSparseAccessPaperRegisters p slot5Row).sparseIndexValue =
        5 ∧
      (oneTermRobinGamma3ProjectionSlotConventionObligation 3 sysRow sysCol).proved =
        false ∧
      (oneTermRobinGamma3ProductToCoefficientObligation 3 sysRow sysCol).proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute 3).oracleComposition.lcuCorrect.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute 3).blockClaim.target.blockProjection.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute 3).blockClaim.target.blockCorrect.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute 3).theoremData.obligations.blockExtraction.proved =
        false := by
  native_decide

/--
Executable field check for the slot-`5` gamma3 projection/register audit.

The checked path is the ket-zero branch
`90 -> 218 -> 218 -> 218 -> 170 -> 170 -> 212 -> 228`.  The Boolean records
the indicator, ancilla, system-row, padded-zero, sparse-index, `m_f` workspace,
and active-source fields for the clean source, adjacent states, final endpoint,
and clean Eq. ROBIN endpoint.
-/
def oneTermRobinGamma3Slot5ProjectionRegisterAuditCheck_n3 : Bool :=
  let p := oneTermParameters 3
  let fullDim := qubitDim (GHL2025.oneTermRobinTotalQubits p)
  let slot5Row := oneTermRobinGamma3PaperBasisIndex p 5 2
  let slot5Col := oneTermRobinGamma3PaperBasisIndex p 5 5
  let afterIndic := GHL2025.indicatorOracleImage p slot5Col
  let afterOdbs := GHL2025.bandedSparseAccessPaperImage p afterIndic
  let afterSwap := GHL2025.swapOracleImage p afterOdbs
  let daggerEndpoint :=
    GHL2025.bandedSparseAccessPaperPostSwapPreimageCandidate p afterIndic
  let row84 : Fin fullDim := ⟨84, by native_decide⟩
  let row228 : Fin fullDim := ⟨228, by native_decide⟩
  let col212 : Fin fullDim := ⟨212, by native_decide⟩
  let finalIndicator :=
    (GHL2025.sparseAmplitudeOracleDTPaperRegisters p daggerEndpoint).indicatorBit
  let cleanIndicator :=
    (GHL2025.sparseAmplitudeOracleDTPaperRegisters p slot5Row).indicatorBit
  let finalSparse :=
    (GHL2025.bandedSparseAccessPaperRegisters p daggerEndpoint).sparseIndexValue
  let cleanSparse :=
    (GHL2025.bandedSparseAccessPaperRegisters p slot5Row).sparseIndexValue
  decide (slot5Col = 90) &&
  decide (slot5Row = 84) &&
  decide (afterIndic = 218) &&
  decide (afterOdbs = 170) &&
  decide (afterSwap = 212) &&
  decide (daggerEndpoint = 228) &&
  decide (GHL2025.bandedSparseAccessPaperDaggerMatrix p row228 col212 =
    Coeff.rat 1) &&
  decide (GHL2025.bandedSparseAccessPaperDaggerMatrix p row84 col212 =
    Coeff.rat 0) &&
  decide ((GHL2025.sparseAmplitudeOracleDTPaperRegisters p slot5Col).indicatorBit =
    0) &&
  decide ((GHL2025.sparseAmplitudeOracleDTPaperRegisters p slot5Col).ancillaBit =
    0) &&
  decide ((GHL2025.bandedSparseAccessPaperRegisters p slot5Col).rowValue =
    5) &&
  decide ((GHL2025.bandedSparseAccessPaperRegisters p slot5Col).paddedZeroValue =
    0) &&
  decide ((GHL2025.bandedSparseAccessPaperRegisters p slot5Col).sparseIndexValue =
    5) &&
  decide ((GHL2025.functionOraclePaperRegisters p slot5Col).mfWorkspaceValue =
    0) &&
  decide ((GHL2025.functionOraclePaperRegisters p slot5Col).cleanWorkspace =
    true) &&
  decide (GHL2025.bandedSparseAccessPaperGlobalSlotSource p slot5Col =
    true) &&
  decide ((GHL2025.sparseAmplitudeOracleDTPaperRegisters p afterIndic).indicatorBit =
    1) &&
  decide ((GHL2025.sparseAmplitudeOracleDTPaperRegisters p afterIndic).ancillaBit =
    0) &&
  decide ((GHL2025.bandedSparseAccessPaperRegisters p afterIndic).rowValue =
    5) &&
  decide ((GHL2025.bandedSparseAccessPaperRegisters p afterIndic).paddedZeroValue =
    0) &&
  decide ((GHL2025.bandedSparseAccessPaperRegisters p afterIndic).sparseIndexValue =
    5) &&
  decide ((GHL2025.functionOraclePaperRegisters p afterIndic).mfWorkspaceValue =
    0) &&
  decide ((GHL2025.functionOraclePaperRegisters p afterIndic).cleanWorkspace =
    true) &&
  decide (GHL2025.bandedSparseAccessPaperGlobalSlotSource p afterIndic =
    true) &&
  decide ((GHL2025.sparseAmplitudeOracleDTPaperRegisters p afterOdbs).indicatorBit =
    1) &&
  decide ((GHL2025.sparseAmplitudeOracleDTPaperRegisters p afterOdbs).ancillaBit =
    0) &&
  decide ((GHL2025.bandedSparseAccessPaperRegisters p afterOdbs).rowValue =
    5) &&
  decide ((GHL2025.bandedSparseAccessPaperRegisters p afterOdbs).paddedZeroValue =
    0) &&
  decide ((GHL2025.bandedSparseAccessPaperRegisters p afterOdbs).sparseIndexValue =
    2) &&
  decide ((GHL2025.functionOraclePaperRegisters p afterOdbs).mfWorkspaceValue =
    0) &&
  decide ((GHL2025.functionOraclePaperRegisters p afterOdbs).cleanWorkspace =
    true) &&
  decide (GHL2025.bandedSparseAccessPaperGlobalSlotSource p afterOdbs =
    true) &&
  decide ((GHL2025.sparseAmplitudeOracleDTPaperRegisters p afterSwap).indicatorBit =
    1) &&
  decide ((GHL2025.sparseAmplitudeOracleDTPaperRegisters p afterSwap).ancillaBit =
    0) &&
  decide ((GHL2025.bandedSparseAccessPaperRegisters p afterSwap).rowValue =
    2) &&
  decide ((GHL2025.bandedSparseAccessPaperRegisters p afterSwap).paddedZeroValue =
    0) &&
  decide ((GHL2025.bandedSparseAccessPaperRegisters p afterSwap).sparseIndexValue =
    5) &&
  decide ((GHL2025.functionOraclePaperRegisters p afterSwap).mfWorkspaceValue =
    0) &&
  decide ((GHL2025.functionOraclePaperRegisters p afterSwap).cleanWorkspace =
    true) &&
  decide (GHL2025.bandedSparseAccessPaperGlobalSlotSource p afterSwap =
    true) &&
  decide (finalIndicator = 1) &&
  decide ((GHL2025.sparseAmplitudeOracleDTPaperRegisters p daggerEndpoint).ancillaBit =
    0) &&
  decide ((GHL2025.bandedSparseAccessPaperRegisters p daggerEndpoint).rowValue =
    2) &&
  decide ((GHL2025.bandedSparseAccessPaperRegisters p daggerEndpoint).paddedZeroValue =
    0) &&
  decide (finalSparse = 6) &&
  decide ((GHL2025.functionOraclePaperRegisters p daggerEndpoint).mfWorkspaceValue =
    0) &&
  decide ((GHL2025.functionOraclePaperRegisters p daggerEndpoint).cleanWorkspace =
    true) &&
  decide (GHL2025.bandedSparseAccessPaperGlobalSlotSource p daggerEndpoint =
    true) &&
  decide (cleanIndicator = 0) &&
  decide ((GHL2025.sparseAmplitudeOracleDTPaperRegisters p slot5Row).ancillaBit =
    0) &&
  decide ((GHL2025.bandedSparseAccessPaperRegisters p slot5Row).rowValue =
    2) &&
  decide ((GHL2025.bandedSparseAccessPaperRegisters p slot5Row).paddedZeroValue =
    0) &&
  decide (cleanSparse = 5) &&
  decide ((GHL2025.functionOraclePaperRegisters p slot5Row).mfWorkspaceValue =
    0) &&
  decide ((GHL2025.functionOraclePaperRegisters p slot5Row).cleanWorkspace =
    true) &&
  decide (GHL2025.bandedSparseAccessPaperGlobalSlotSource p slot5Row =
    true) &&
  decide (finalIndicator ≠ cleanIndicator) &&
  decide ((GHL2025.sparseAmplitudeOracleDTPaperRegisters p daggerEndpoint).ancillaBit =
    (GHL2025.sparseAmplitudeOracleDTPaperRegisters p slot5Row).ancillaBit) &&
  decide ((GHL2025.bandedSparseAccessPaperRegisters p daggerEndpoint).rowValue =
    (GHL2025.bandedSparseAccessPaperRegisters p slot5Row).rowValue) &&
  decide ((GHL2025.bandedSparseAccessPaperRegisters p daggerEndpoint).paddedZeroValue =
    (GHL2025.bandedSparseAccessPaperRegisters p slot5Row).paddedZeroValue) &&
  decide (finalSparse ≠ cleanSparse) &&
  decide ((GHL2025.functionOraclePaperRegisters p daggerEndpoint).cleanWorkspace =
    (GHL2025.functionOraclePaperRegisters p slot5Row).cleanWorkspace)

/--
Projection/register audit for the slot-`5` gamma3 path at `n = 3`.

The first field-level mismatch between the final seven-gate endpoint `228` and
the clean Eq. ROBIN endpoint `84` is the indicator bit: the full path keeps the
bulk indicator set to `1`, while the clean endpoint has indicator bit `0`.
The sparse-index field also differs (`6` versus `5`).  No semantic proof flag
is promoted.
-/
theorem oneTermRobinBlockEncodingProofRoute_gamma3Slot5ProjectionRegisterAudit_n3 :
    oneTermRobinGamma3Slot5ProjectionRegisterAuditCheck_n3 = true ∧
      (oneTermRobinGamma3ProjectionSlotConventionObligation
          3 ⟨2, by native_decide⟩ ⟨5, by native_decide⟩).proved =
        false ∧
      (oneTermRobinGamma3ProductToCoefficientObligation
          3 ⟨2, by native_decide⟩ ⟨5, by native_decide⟩).proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute 3).oracleComposition.lcuCorrect.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute 3).blockClaim.target.blockProjection.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute 3).blockClaim.target.blockCorrect.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute 3).theoremData.obligations.blockExtraction.proved =
        false := by
  have _pathAudit :=
    oneTermRobinBlockEncodingProofRoute_gamma3Slot5PathAudit_n3
  have _slotConventionMap :=
    oneTermRobinBlockEncodingProofRoute_gamma3ProjectionSlotConventionMap_n3
  exact ⟨by native_decide, rfl, rfl, rfl, rfl, rfl, rfl⟩

/--
Middle-agent decision record for the blocked gamma3 projection/register
convention at `n = 3`.

The source transcript provides Eq. ROBIN clarified, Fig. 1-term ROBIN, and the
block-encoding projection definition, but it does not specify the finite
basis bridge that would identify the full seven-gate endpoint `228` with the
clean slot-`5` endpoint `84`.  This record keeps product search blocked until
that convention is stated precisely.
-/
structure OneTermRobinGamma3ProjectionRegisterConventionDecision where
  sourceAnchor : String
  cleanEndpoint : Nat
  fullEndpoint : Nat
  firstMismatch : String
  secondaryMismatch : String
  classification : String
  requiredDecision : SemanticObligation
  auditCheck : Bool
  productSearchBlocked : Bool
  projectionSlotConventionProved : Bool
  productToCoefficientProved : Bool
  lcuCorrectProved : Bool
  blockProjectionProved : Bool
  blockCorrectProved : Bool
  finalExtractionProved : Bool

/--
The focused gamma3 endpoint mismatch is a source-contract gap, not a finite
matrix multiplication target.
-/
def oneTermRobinGamma3ProjectionRegisterConventionDecision_n3 :
    OneTermRobinGamma3ProjectionRegisterConventionDecision where
  sourceAnchor :=
    "GHL2025 Theorem one-term block-encoding, Eq. ROBIN clarified, Fig. 1-term ROBIN, Definition def:block-encoding, arXiv:2506.20478"
  cleanEndpoint := 84
  fullEndpoint := 228
  firstMismatch := "indicator bit: full endpoint has 1, clean endpoint has 0"
  secondaryMismatch := "sparse-index value: full endpoint has 6, clean endpoint has 5"
  classification := "source-contract-gap plus internal-paper-step"
  requiredDecision := {
    description :=
      "state the projection/register convention relating the full endpoint 228 to the clean gamma3 endpoint 84, or specify the sparse-register summation/basis permutation used by the theorem"
    source :=
      "GHL2025 Eq. ROBIN clarified, Fig. 1-term ROBIN, Definition def:block-encoding; QBE gamma3 slot-5 projection/register audit"
    proved := false
  }
  auditCheck := oneTermRobinGamma3Slot5ProjectionRegisterAuditCheck_n3
  productSearchBlocked := true
  projectionSlotConventionProved :=
    (oneTermRobinGamma3ProjectionSlotConventionObligation
      3 ⟨2, by native_decide⟩ ⟨5, by native_decide⟩).proved
  productToCoefficientProved :=
    (oneTermRobinGamma3ProductToCoefficientObligation
      3 ⟨2, by native_decide⟩ ⟨5, by native_decide⟩).proved
  lcuCorrectProved :=
    (oneTermRobinBlockEncodingProofRoute 3).oracleComposition.lcuCorrect.proved
  blockProjectionProved :=
    (oneTermRobinBlockEncodingProofRoute 3).blockClaim.target.blockProjection.proved
  blockCorrectProved :=
    (oneTermRobinBlockEncodingProofRoute 3).blockClaim.target.blockCorrect.proved
  finalExtractionProved :=
    (oneTermRobinBlockEncodingProofRoute 3).theoremData.obligations.blockExtraction.proved

/--
Transcript theorem for the middle decision record.

This theorem deliberately preserves the false semantic flags.  It only records
that the compiled register audit has converted the next step into a
projection/register convention decision before any product-to-coefficient
proof search may continue.
-/
theorem oneTermRobinGamma3ProjectionRegisterConventionDecision_n3_transcript :
    let decision := oneTermRobinGamma3ProjectionRegisterConventionDecision_n3
    decision.auditCheck = true ∧
      decision.cleanEndpoint = 84 ∧
      decision.fullEndpoint = 228 ∧
      decision.firstMismatch =
        "indicator bit: full endpoint has 1, clean endpoint has 0" ∧
      decision.secondaryMismatch =
        "sparse-index value: full endpoint has 6, clean endpoint has 5" ∧
      decision.classification =
        "source-contract-gap plus internal-paper-step" ∧
      decision.requiredDecision.proved = false ∧
      decision.productSearchBlocked = true ∧
      decision.projectionSlotConventionProved = false ∧
      decision.productToCoefficientProved = false ∧
      decision.lcuCorrectProved = false ∧
      decision.blockProjectionProved = false ∧
      decision.blockCorrectProved = false ∧
      decision.finalExtractionProved = false := by
  have _audit :=
    oneTermRobinBlockEncodingProofRoute_gamma3Slot5ProjectionRegisterAudit_n3
  exact ⟨by native_decide, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl,
    rfl, rfl, rfl⟩

/--
Chosen theorem-facing convention for the focused `n = 3` gamma3 entry.

Eq. `ROBIN clarified` writes the gamma3 contribution as a sum over sparse
slots, so the next interface selects sparse-register summation.  The compiled
slot-`5` audit also found an indicator-bit mismatch between the full endpoint
`228` and the clean endpoint `84`; that mismatch is kept as a separate false
obligation instead of being hidden by the summation choice.
-/
structure OneTermRobinGamma3SparseRegisterSummationConvention where
  sourceAnchor : String
  chosenConvention : String
  summedSlotRange : String
  cleanEndpoint : Nat
  fullEndpoint : Nat
  cleanSystemRow : Nat
  fullSystemRow : Nat
  cleanIndicator : Nat
  fullIndicator : Nat
  cleanSparseIndex : Nat
  fullSparseIndex : Nat
  systemRowAgrees : Bool
  sparseRegisterSummationSelected : Bool
  indicatorMismatchHandledBySummation : Bool
  indicatorMismatchObligation : SemanticObligation
  decision : OneTermRobinGamma3ProjectionRegisterConventionDecision
  auditCheck : Bool
  projectionSlotConventionProved : Bool
  productToCoefficientProved : Bool
  productSearchBlocked : Bool
  lcuCorrectProved : Bool
  blockProjectionProved : Bool
  blockCorrectProved : Bool
  finalExtractionProved : Bool

/--
Sparse-register summation convention selected for the slot-`5` gamma3 audit.

This is a contract map only.  It records the source-supported summation over
`s = 0, ..., kappa - 1`, but it does not prove that the current block
projection implements that summation.  The indicator mismatch remains open.
-/
def oneTermRobinGamma3SparseRegisterSummationConvention_n3 :
    OneTermRobinGamma3SparseRegisterSummationConvention :=
  let p := oneTermParameters 3
  let sysRow : Fin (gridSize 3) := ⟨2, by native_decide⟩
  let sysCol : Fin (gridSize 3) := ⟨5, by native_decide⟩
  let cleanEndpoint := oneTermRobinGamma3PaperBasisIndex p 5 sysRow.val
  let cleanColumn := oneTermRobinGamma3PaperBasisIndex p 5 sysCol.val
  let fullEndpoint :=
    GHL2025.bandedSparseAccessPaperPostSwapPreimageCandidate p
      (GHL2025.indicatorOracleImage p cleanColumn)
  {
    sourceAnchor :=
      "GHL2025 Eq. ROBIN clarified gamma3 line and Theorem one-term block-encoding, arXiv:2506.20478"
    chosenConvention := "sparse-register summation"
    summedSlotRange := "s = 0..kappa-1"
    cleanEndpoint := cleanEndpoint
    fullEndpoint := fullEndpoint
    cleanSystemRow := (GHL2025.bandedSparseAccessPaperRegisters p cleanEndpoint).rowValue
    fullSystemRow := (GHL2025.bandedSparseAccessPaperRegisters p fullEndpoint).rowValue
    cleanIndicator :=
      (GHL2025.sparseAmplitudeOracleDTPaperRegisters p cleanEndpoint).indicatorBit
    fullIndicator :=
      (GHL2025.sparseAmplitudeOracleDTPaperRegisters p fullEndpoint).indicatorBit
    cleanSparseIndex :=
      (GHL2025.bandedSparseAccessPaperRegisters p cleanEndpoint).sparseIndexValue
    fullSparseIndex :=
      (GHL2025.bandedSparseAccessPaperRegisters p fullEndpoint).sparseIndexValue
    systemRowAgrees :=
      decide ((GHL2025.bandedSparseAccessPaperRegisters p cleanEndpoint).rowValue =
        (GHL2025.bandedSparseAccessPaperRegisters p fullEndpoint).rowValue)
    sparseRegisterSummationSelected := true
    indicatorMismatchHandledBySummation := false
    indicatorMismatchObligation := {
      description :=
        "indicator-bit mismatch between full endpoint 228 and clean endpoint 84 must be handled by a separate projection/register convention; sparse-register summation alone does not close it"
      source :=
        "GHL2025 Eq. ROBIN clarified, Fig. 1-term ROBIN; QBE slot-5 projection/register audit"
      proved := false
    }
    decision := oneTermRobinGamma3ProjectionRegisterConventionDecision_n3
    auditCheck := oneTermRobinGamma3Slot5ProjectionRegisterAuditCheck_n3
    projectionSlotConventionProved :=
      (oneTermRobinGamma3ProjectionSlotConventionObligation
        3 sysRow sysCol).proved
    productToCoefficientProved :=
      (oneTermRobinGamma3ProductToCoefficientObligation
        3 sysRow sysCol).proved
    productSearchBlocked := true
    lcuCorrectProved :=
      (oneTermRobinBlockEncodingProofRoute 3).oracleComposition.lcuCorrect.proved
    blockProjectionProved :=
      (oneTermRobinBlockEncodingProofRoute 3).blockClaim.target.blockProjection.proved
    blockCorrectProved :=
      (oneTermRobinBlockEncodingProofRoute 3).blockClaim.target.blockCorrect.proved
    finalExtractionProved :=
      (oneTermRobinBlockEncodingProofRoute 3).theoremData.obligations.blockExtraction.proved
  }

/--
Transcript theorem for the selected sparse-register summation convention.

The theorem proves only the compiled contract map and endpoint facts.  It keeps
product-to-coefficient search blocked and preserves all semantic false flags.
-/
theorem oneTermRobinGamma3SparseRegisterSummationConvention_n3_transcript :
    let convention :=
      oneTermRobinGamma3SparseRegisterSummationConvention_n3
    convention.chosenConvention = "sparse-register summation" ∧
      convention.summedSlotRange = "s = 0..kappa-1" ∧
      convention.sparseRegisterSummationSelected = true ∧
      convention.auditCheck = true ∧
      convention.cleanEndpoint = 84 ∧
      convention.fullEndpoint = 228 ∧
      convention.cleanSystemRow = 2 ∧
      convention.fullSystemRow = 2 ∧
      convention.systemRowAgrees = true ∧
      convention.cleanIndicator = 0 ∧
      convention.fullIndicator = 1 ∧
      convention.indicatorMismatchHandledBySummation = false ∧
      convention.indicatorMismatchObligation.proved = false ∧
      convention.cleanSparseIndex = 5 ∧
      convention.fullSparseIndex = 6 ∧
      convention.decision.productSearchBlocked = true ∧
      convention.projectionSlotConventionProved = false ∧
      convention.productToCoefficientProved = false ∧
      convention.productSearchBlocked = true ∧
      convention.lcuCorrectProved = false ∧
      convention.blockProjectionProved = false ∧
      convention.blockCorrectProved = false ∧
      convention.finalExtractionProved = false := by
  have _decision :=
    oneTermRobinGamma3ProjectionRegisterConventionDecision_n3_transcript
  have _audit :=
    oneTermRobinBlockEncodingProofRoute_gamma3Slot5ProjectionRegisterAudit_n3
  native_decide

/--
Indicator-field gap after selecting sparse-register summation.

The sparse-register summation convention is source-backed by Eq. `ROBIN
clarified`, but it does not explain why the full seven-gate endpoint keeps the
indicator bit set.  This theorem packages that remaining field-level source
contract gap and keeps product-to-coefficient search blocked.
-/
theorem oneTermRobinGamma3SparseRegisterSummation_indicatorGap_n3 :
    let convention :=
      oneTermRobinGamma3SparseRegisterSummationConvention_n3
    convention.chosenConvention = "sparse-register summation" ∧
      convention.indicatorMismatchHandledBySummation = false ∧
      convention.indicatorMismatchObligation.description =
        "indicator-bit mismatch between full endpoint 228 and clean endpoint 84 must be handled by a separate projection/register convention; sparse-register summation alone does not close it" ∧
      convention.indicatorMismatchObligation.source =
        "GHL2025 Eq. ROBIN clarified, Fig. 1-term ROBIN; QBE slot-5 projection/register audit" ∧
      convention.indicatorMismatchObligation.proved = false ∧
      convention.cleanEndpoint = 84 ∧
      convention.fullEndpoint = 228 ∧
      convention.cleanSystemRow = convention.fullSystemRow ∧
      convention.systemRowAgrees = true ∧
      convention.cleanIndicator = 0 ∧
      convention.fullIndicator = 1 ∧
      convention.cleanIndicator ≠ convention.fullIndicator ∧
      convention.cleanSparseIndex = 5 ∧
      convention.fullSparseIndex = 6 ∧
      convention.productSearchBlocked = true ∧
      convention.projectionSlotConventionProved = false ∧
      convention.productToCoefficientProved = false ∧
      convention.lcuCorrectProved = false ∧
      convention.blockProjectionProved = false ∧
      convention.blockCorrectProved = false ∧
      convention.finalExtractionProved = false ∧
      (oneTermRobinBlockEncodingProofRoute 3).oracleComposition.lcuCorrect.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute 3).blockClaim.target.blockProjection.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute 3).blockClaim.target.blockCorrect.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute 3).theoremData.obligations.blockExtraction.proved =
        false := by
  have _convention :=
    oneTermRobinGamma3SparseRegisterSummationConvention_n3_transcript
  native_decide

/--
Indicator-field projection/register convention for the focused `n = 3`
gamma3 endpoint pair.

After sparse-register summation has been selected, the remaining question is
whether the theorem-level block projection sums, ignores, resets, or permutes
the indicator field that differs between full endpoint `228` and clean endpoint
`84`.  The GHL2025 transcript has not yet supplied that rule, so the convention
is recorded as a false source-contract obligation rather than a product proof.
-/
structure OneTermRobinGamma3IndicatorProjectionConvention where
  sourceAnchor : String
  cleanEndpoint : Nat
  fullEndpoint : Nat
  cleanIndicator : Nat
  fullIndicator : Nat
  indicatorRelationSpecifiedBySource : Bool
  humanInputRequired : Bool
  requiredConvention : String
  conventionObligation : SemanticObligation
  sparseSummationConvention : OneTermRobinGamma3SparseRegisterSummationConvention
  projectionDecision : OneTermRobinGamma3ProjectionRegisterConventionDecision
  productSearchBlocked : Bool
  indicatorMismatchObligationProved : Bool
  projectionSlotConventionProved : Bool
  productToCoefficientProved : Bool
  lcuCorrectProved : Bool
  blockProjectionProved : Bool
  blockCorrectProved : Bool
  finalExtractionProved : Bool

/--
The active gamma3 indicator convention is still an explicit source-contract gap.

This declaration is deliberately theorem-facing but not a semantic proof.  It
reuses the sparse-register summation gap and keeps all block-encoding flags
false until a source-backed projection/register rule is stated.
-/
def oneTermRobinGamma3IndicatorProjectionConvention_n3 :
    OneTermRobinGamma3IndicatorProjectionConvention :=
  let sparseConvention :=
    oneTermRobinGamma3SparseRegisterSummationConvention_n3
  {
    sourceAnchor :=
      "GHL2025 Eq. ROBIN clarified, Fig. 1-term ROBIN, Definition def:block-encoding, arXiv:2506.20478"
    cleanEndpoint := sparseConvention.cleanEndpoint
    fullEndpoint := sparseConvention.fullEndpoint
    cleanIndicator := sparseConvention.cleanIndicator
    fullIndicator := sparseConvention.fullIndicator
    indicatorRelationSpecifiedBySource := false
    humanInputRequired := true
    requiredConvention :=
      "state whether the theorem projection sums, ignores, resets, or permutes the indicator field relating endpoint 228 to endpoint 84"
    conventionObligation := {
      description :=
        "indicator projection/register rule after sparse-register summation for the gamma3 endpoint pair 228 and 84"
      source :=
        "GHL2025 Eq. ROBIN clarified, Fig. 1-term ROBIN, Definition def:block-encoding; QBE gamma3 sparse-register summation indicator gap"
      proved := false
    }
    sparseSummationConvention := sparseConvention
    projectionDecision :=
      oneTermRobinGamma3ProjectionRegisterConventionDecision_n3
    productSearchBlocked := true
    indicatorMismatchObligationProved :=
      sparseConvention.indicatorMismatchObligation.proved
    projectionSlotConventionProved :=
      sparseConvention.projectionSlotConventionProved
    productToCoefficientProved :=
      sparseConvention.productToCoefficientProved
    lcuCorrectProved :=
      (oneTermRobinBlockEncodingProofRoute 3).oracleComposition.lcuCorrect.proved
    blockProjectionProved :=
      (oneTermRobinBlockEncodingProofRoute 3).blockClaim.target.blockProjection.proved
    blockCorrectProved :=
      (oneTermRobinBlockEncodingProofRoute 3).blockClaim.target.blockCorrect.proved
    finalExtractionProved :=
      (oneTermRobinBlockEncodingProofRoute 3).theoremData.obligations.blockExtraction.proved
  }

/--
Transcript theorem for the active gamma3 indicator convention.

The theorem packages the endpoint and false-obligation facts needed by the next
proof step.  It does not identify endpoints `228` and `84`, and it does not
promote product-to-coefficient, LCU, projection, block, or final extraction
flags.
-/
theorem oneTermRobinGamma3IndicatorProjectionConvention_n3_transcript :
    let convention :=
      oneTermRobinGamma3IndicatorProjectionConvention_n3
    convention.cleanEndpoint = 84 ∧
      convention.fullEndpoint = 228 ∧
      convention.cleanIndicator = 0 ∧
      convention.fullIndicator = 1 ∧
      convention.cleanIndicator ≠ convention.fullIndicator ∧
      convention.indicatorRelationSpecifiedBySource = false ∧
      convention.humanInputRequired = true ∧
      convention.requiredConvention =
        "state whether the theorem projection sums, ignores, resets, or permutes the indicator field relating endpoint 228 to endpoint 84" ∧
      convention.conventionObligation.source =
        "GHL2025 Eq. ROBIN clarified, Fig. 1-term ROBIN, Definition def:block-encoding; QBE gamma3 sparse-register summation indicator gap" ∧
      convention.conventionObligation.proved = false ∧
      convention.sparseSummationConvention.indicatorMismatchHandledBySummation =
        false ∧
      convention.sparseSummationConvention.indicatorMismatchObligation.proved =
        false ∧
      convention.projectionDecision.productSearchBlocked = true ∧
      convention.productSearchBlocked = true ∧
      convention.indicatorMismatchObligationProved = false ∧
      convention.projectionSlotConventionProved = false ∧
      convention.productToCoefficientProved = false ∧
      convention.lcuCorrectProved = false ∧
      convention.blockProjectionProved = false ∧
      convention.blockCorrectProved = false ∧
      convention.finalExtractionProved = false ∧
      (oneTermRobinBlockEncodingProofRoute 3).oracleComposition.lcuCorrect.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute 3).blockClaim.target.blockProjection.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute 3).blockClaim.target.blockCorrect.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute 3).theoremData.obligations.blockExtraction.proved =
        false := by
  have _gap :=
    oneTermRobinGamma3SparseRegisterSummation_indicatorGap_n3
  have _convention :=
    oneTermRobinGamma3SparseRegisterSummationConvention_n3_transcript
  have _decision :=
    oneTermRobinGamma3ProjectionRegisterConventionDecision_n3_transcript
  native_decide

/--
Focused source audit for the bulk-indicator field in the `n = 3` gamma3
endpoint pair.

For the entry using system column `5`, the paper's bulk window
`K1 <= j <= K2` classifies the column as bulk.  The source-backed
`U_indic` behavior therefore sets the indicator to `1`, which matches the
full Fig. 1-term Robin endpoint `228` and not the clean endpoint `84`.
This refines the active blocker without closing it: the source still does not
state a projection/register rule that identifies the two endpoints, and all
product, LCU, projection, block, and extraction flags remain false.
-/
structure OneTermRobinGamma3BulkIndicatorSourceAudit where
  sourceAnchor : String
  focusedSystemColumn : Nat
  K1 : Nat
  K2 : Nat
  isBulkColumn : Bool
  cleanEndpoint : Nat
  fullEndpoint : Nat
  cleanIndicator : Nat
  fullIndicator : Nat
  sourceBulkIndicator : Nat
  fullEndpointMatchesSourceBulkIndicator : Bool
  cleanEndpointMatchesSourceBulkIndicator : Bool
  sourceStatesResetRule : Bool
  indicatorConvention : OneTermRobinGamma3IndicatorProjectionConvention
  productSearchBlocked : Bool
  conventionObligationProved : Bool
  productToCoefficientProved : Bool
  blockProjectionProved : Bool
  blockCorrectProved : Bool
  finalExtractionProved : Bool

/--
Source-backed refinement of the active indicator convention blocker.

The focused column `5` is in the bulk window for `n = 3`, so the indicator
value `1` at endpoint `228` is not accidental; it is exactly the value produced
by the `U_indic` source paragraph.  Endpoint `84` remains the clean displayed
slot endpoint, and no reset/projection rule is promoted.
-/
def oneTermRobinGamma3BulkIndicatorSourceAudit_n3 :
    OneTermRobinGamma3BulkIndicatorSourceAudit :=
  let p := oneTermParameters 3
  let convention := oneTermRobinGamma3IndicatorProjectionConvention_n3
  {
    sourceAnchor :=
      "GHL2025 U_indic paragraph, Eq. ROBIN clarified, Fig. 1-term ROBIN, Definition def:block-encoding, arXiv:2506.20478"
    focusedSystemColumn := 5
    K1 := 2
    K2 := gridSize p.n - 3
    isBulkColumn := GHL2025.isBulkRow 2 (gridSize p.n - 3) 5
    cleanEndpoint := convention.cleanEndpoint
    fullEndpoint := convention.fullEndpoint
    cleanIndicator := convention.cleanIndicator
    fullIndicator := convention.fullIndicator
    sourceBulkIndicator := 1
    fullEndpointMatchesSourceBulkIndicator :=
      decide (convention.fullIndicator = 1)
    cleanEndpointMatchesSourceBulkIndicator :=
      decide (convention.cleanIndicator = 1)
    sourceStatesResetRule := false
    indicatorConvention := convention
    productSearchBlocked := true
    conventionObligationProved := convention.conventionObligation.proved
    productToCoefficientProved := convention.productToCoefficientProved
    blockProjectionProved := convention.blockProjectionProved
    blockCorrectProved := convention.blockCorrectProved
    finalExtractionProved := convention.finalExtractionProved
  }

/--
Transcript theorem for the bulk-indicator source audit.

This theorem only records the source-backed branch classification and the
remaining false obligations.  It does not replace the missing
projection/register convention and does not resume product multiplication.
-/
theorem oneTermRobinGamma3BulkIndicatorSourceAudit_n3_transcript :
    let p := oneTermParameters 3
    let audit := oneTermRobinGamma3BulkIndicatorSourceAudit_n3
    audit.focusedSystemColumn = 5 ∧
      audit.K1 = 2 ∧
      audit.K2 = 5 ∧
      audit.isBulkColumn = true ∧
      GHL2025.isBulkRow audit.K1 audit.K2 audit.focusedSystemColumn = true ∧
      GHL2025.indicatorOracleImage p
          (oneTermRobinGamma3PaperBasisIndex p 5 audit.focusedSystemColumn) =
        218 ∧
      (GHL2025.sparseAmplitudeOracleDTPaperRegisters p 218).indicatorBit =
        audit.sourceBulkIndicator ∧
      audit.sourceBulkIndicator = 1 ∧
      audit.fullEndpoint = 228 ∧
      audit.fullIndicator = 1 ∧
      audit.fullEndpointMatchesSourceBulkIndicator = true ∧
      audit.cleanEndpoint = 84 ∧
      audit.cleanIndicator = 0 ∧
      audit.cleanEndpointMatchesSourceBulkIndicator = false ∧
      audit.sourceStatesResetRule = false ∧
      audit.indicatorConvention.indicatorRelationSpecifiedBySource = false ∧
      audit.indicatorConvention.humanInputRequired = true ∧
      audit.indicatorConvention.conventionObligation.proved = false ∧
      audit.productSearchBlocked = true ∧
      audit.conventionObligationProved = false ∧
      audit.productToCoefficientProved = false ∧
      audit.blockProjectionProved = false ∧
      audit.blockCorrectProved = false ∧
      audit.finalExtractionProved = false ∧
      (oneTermRobinBlockEncodingProofRoute 3).oracleComposition.lcuCorrect.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute 3).blockClaim.target.blockProjection.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute 3).blockClaim.target.blockCorrect.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute 3).theoremData.obligations.blockExtraction.proved =
        false := by
  have _indicatorConvention :=
    oneTermRobinGamma3IndicatorProjectionConvention_n3_transcript
  native_decide

end Examples.RobinHeat

end QuantumBlockEncoding

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
Block-extraction target for the Robin derivative block encoding.
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
    (robinDerivativeMatrix n)
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

/-! ## Theorem-level proof route contract -/

/--
Phase 1 proof-route contract for the GHL2025 one-term Robin theorem.

This record ties the theorem tuple, circuit-matrix semantics, block-projection
target, active oracle contracts, and cited-result blockers into one Lean
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
  unusedZeroBranchDecision :
    GHL2025.BandedSparseAccessUnusedZeroBranchSourceDecision
  priorSparseAccessSource : GHL2025.BandedSparseAccessPriorPDESourceContract
  robinZeroInclusionSource :
    GHL2025.BandedSparseAccessRobinZeroInclusionSourceContract
  functionOracleSource : GHL2025.FunctionOracleExternalAmplitudeSourceContract
  parameters_eq : parameters = oneTermParameters n
  theoremNormalizerMatchesTarget :
    theoremData.alpha = blockClaim.target.normalizer
  targetMatrixMatchesSpec : blockClaim.target.targetMatrix = robinDerivativeMatrix n
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
  unusedZeroBranchBlocked : unusedZeroBranchDecision.lowerProofSearchAllowed = false
  priorSourceDoesNotCloseOdbs :
    priorSparseAccessSource.closesUnusedZeroBranchExtension = false
  robinZeroInclusionDoesNotCloseOdbs :
    robinZeroInclusionSource.closesUnusedZeroBranchExtension = false
  robinZeroInclusionBlocksLowerSearch :
    robinZeroInclusionSource.lowerProofSearchAllowed = false
  functionOracleExternalOpen : functionOracleSource.closesFunctionOracleContract = false
  functionOracleOpen :
    oracleComposition.functionOracle.amplitudeCorrect.proved = false
  lcuOpen : oracleComposition.lcuCorrect.proved = false

/--
Default theorem-level proof route for the one-term Robin block encoding.

All unproved semantic obligations are deliberately kept false.  The route uses
the active seven-gate circuit product and the existing cited-result blockers
for `O_D^BS` and `O_f`.
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
  unusedZeroBranchDecision :=
    GHL2025.bandedSparseAccessUnusedZeroBranchSourceDecision
  priorSparseAccessSource := GHL2025.bandedSparseAccessPriorPDESourceContract
  robinZeroInclusionSource :=
    GHL2025.bandedSparseAccessRobinZeroInclusionSourceContract
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
  unusedZeroBranchBlocked := rfl
  priorSourceDoesNotCloseOdbs := rfl
  robinZeroInclusionDoesNotCloseOdbs := rfl
  robinZeroInclusionBlocksLowerSearch := rfl
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
        robinDerivativeMatrix n ∧
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
        robinDerivativeMatrix n ∧
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
obligation mode, and the O_D^BS source-decision blocker still disables lower
proof search.
-/
theorem oneTermRobinBlockEncodingProofRoute_gateUnitaryFlags
    (n : Nat) :
    (oneTermRobinBlockEncodingProofRoute n).circuitSemantics.gateMatrices.map
        (fun gateMatrix => gateMatrix.unitary.proved) =
        [true, false, false, false, false, true, false] ∧
      (oneTermRobinBlockEncodingProofRoute n).unusedZeroBranchDecision.lowerProofSearchAllowed =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).theoremData.obligations.circuitUnitary.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.blockCorrect.proved =
        false := by
  exact ⟨
    GHL2025.oneTermRobinGateMatrixPlaceholders_unitaryFlags (oneTermParameters n),
    (oneTermRobinBlockEncodingProofRoute n).unusedZeroBranchBlocked,
    (oneTermRobinBlockEncodingProofRoute n).theoremCircuitUnitaryOpen,
    (oneTermRobinBlockEncodingProofRoute n).blockCorrectOpen⟩

/--
The theorem route keeps the Fig. 1-term Robin gate order and the current
gate-level proof flags synchronized.

This guard packages the gate-list freeze with the seven-gate flag freeze.  It
does not prove any of the paper-oracle gates unitary and keeps the O_D^BS
source blocker active.
-/
theorem oneTermRobinBlockEncodingProofRoute_gateListAndFlags
    (n : Nat) :
    (oneTermRobinBlockEncodingProofRoute n).circuitSemantics.gateMatrices.map
        (fun gateMatrix => gateMatrix.gate) =
        GHL2025.oneTermRobinCircuit ∧
      (oneTermRobinBlockEncodingProofRoute n).circuitSemantics.gateMatrices.map
        (fun gateMatrix => gateMatrix.unitary.proved) =
        [true, false, false, false, false, true, false] ∧
      (oneTermRobinBlockEncodingProofRoute n).unusedZeroBranchDecision.lowerProofSearchAllowed =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).theoremData.obligations.circuitUnitary.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.blockCorrect.proved =
        false := by
  rcases oneTermRobinBlockEncodingProofRoute_circuitProduct n with
    ⟨_, hgateMatrices, _, _, _⟩
  rcases oneTermRobinBlockEncodingProofRoute_gateUnitaryFlags n with
    ⟨hflags, hlowerBlocked, hcircuitUnitary, hblockCorrect⟩
  exact ⟨by
      rw [hgateMatrices]
      exact GHL2025.oneTermRobinGateMatrixPlaceholders_gateList
        (oneTermParameters n),
    hflags,
    hlowerBlocked,
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
      (oneTermRobinBlockEncodingProofRoute n).unusedZeroBranchDecision.lowerProofSearchAllowed =
        false := by
  rcases oneTermRobinBlockEncodingProofRoute_gateListAndFlags n with
    ⟨hgateList, hflags, hlowerBlocked, hcircuitUnitary, hblockCorrectGate⟩
  rcases oneTermRobinBlockEncodingProofRoute_blockProjectionNormalizerAudit n with
    ⟨_, _, _, _, hnormalizer, hsignalIndex, hblockProjection, _, _, hlcu⟩
  exact ⟨hgateList, hflags, hnormalizer, hsignalIndex, hblockProjection,
    hblockCorrectGate, hcircuitUnitary,
    (oneTermRobinBlockEncodingProofRoute n).theoremBlockExtractionOpen, hlcu,
    hlowerBlocked⟩

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
      (oneTermRobinBlockEncodingProofRoute n).unusedZeroBranchDecision.lowerProofSearchAllowed =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).priorSparseAccessSource.closesUnusedZeroBranchExtension =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).robinZeroInclusionSource.closesUnusedZeroBranchExtension =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).robinZeroInclusionSource.lowerProofSearchAllowed =
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
    (oneTermRobinBlockEncodingProofRoute n).unusedZeroBranchBlocked,
    (oneTermRobinBlockEncodingProofRoute n).priorSourceDoesNotCloseOdbs,
    (oneTermRobinBlockEncodingProofRoute n).robinZeroInclusionDoesNotCloseOdbs,
    (oneTermRobinBlockEncodingProofRoute n).robinZeroInclusionBlocksLowerSearch,
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
      _hsparseCleanup, _hsparseUnitary, _hunusedBlocked, _hpriorOpen,
      _hrobinOpen, _hrobinLower, hfunctionSource, hfunctionAmp, hlcu⟩
  exact ⟨rfl, hsourceAnchor, hnormalizer, hformula, hnonzeroEq, hdivisionEq,
    htheoremEq, hresource, hexternal, hsourceNonzero, hsourceDivision,
    hsourceTheorem, hclosesBound, hclosesOrthogonal, hclosesUnitary,
    hclosesContract, hnormalized, hnonzero, hdivision, hbound, horthogonal,
    hunitary, htheoremAmplitude, rfl, rfl, rfl, hfunctionAmp, hlcu,
    hblockProjection, hblockCorrect, hblockExtraction⟩

/--
The theorem-level route exposes the O_D^BS source blockers as a named guard.

This is a source-audit bridge, not a semantic proof: the unused-zero-branch
source decision disables lower proof search, the prior PDE transcript supplies
no Robin-specific unused-branch image rule, and the paper-level O_D^BS
correctness flags remain false.
-/
theorem oneTermRobinBlockEncodingProofRoute_odbsSourceBlockers (n : Nat) :
    (oneTermRobinBlockEncodingProofRoute n).unusedZeroBranchDecision.citedResultKey =
        "QBE.ODBS.UnusedZeroBranchExtension" ∧
      (oneTermRobinBlockEncodingProofRoute n).unusedZeroBranchDecision.lowerProofSearchAllowed =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).priorSparseAccessSource.robinUnusedBranchImageRule =
        none ∧
      (oneTermRobinBlockEncodingProofRoute n).robinZeroInclusionSource.unusedBranchImageRule =
        none ∧
      (oneTermRobinBlockEncodingProofRoute n).robinZeroInclusionSource.lowerProofSearchAllowed =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).priorSparseAccessSource.closesUnusedZeroBranchExtension =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).sparseAccessContract.forwardCorrect.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).sparseAccessContract.daggerCleanup.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).sparseAccessContract.unitaryExtension.proved =
        false := by
  exact ⟨rfl, rfl, rfl, rfl,
    (oneTermRobinBlockEncodingProofRoute n).robinZeroInclusionBlocksLowerSearch,
    rfl, rfl, rfl, rfl⟩

/--
The theorem-level route records the Robin zero-inclusion source transcript.

The source transcript says zero-amplitude sparse branches are included in the
one-term sparse-index range, but it supplies no reversible unused-branch image
rule.  This guard keeps that transcript tied to the existing lower-proof-search
blocker.
-/
theorem oneTermRobinBlockEncodingProofRoute_robinZeroInclusionTranscript
    (n : Nat) :
    (oneTermRobinBlockEncodingProofRoute n).robinZeroInclusionSource.zerosIncludedInSparseEnumeration =
        true ∧
      (oneTermRobinBlockEncodingProofRoute n).robinZeroInclusionSource.unusedBranchImageRule =
        none ∧
      (oneTermRobinBlockEncodingProofRoute n).robinZeroInclusionSource.unusedBranchImageIndex =
        none ∧
      (oneTermRobinBlockEncodingProofRoute n).robinZeroInclusionSource.reversibleExtensionTheorem =
        none ∧
      (oneTermRobinBlockEncodingProofRoute n).robinZeroInclusionSource.closesUnusedZeroBranchExtension =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).robinZeroInclusionSource.lowerProofSearchAllowed =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).unusedZeroBranchDecision.lowerProofSearchAllowed =
        false := by
  exact ⟨rfl, rfl, rfl, rfl,
    (oneTermRobinBlockEncodingProofRoute n).robinZeroInclusionDoesNotCloseOdbs,
    (oneTermRobinBlockEncodingProofRoute n).robinZeroInclusionBlocksLowerSearch,
    (oneTermRobinBlockEncodingProofRoute n).unusedZeroBranchBlocked⟩

/--
The Robin zero-inclusion transcript cannot be used to promote `O_D^BS`.

The paper keeps zero-amplitude sparse branches inside the kappa-wide sparse
range, but the route still has no unused-branch image rule.  This guard ties
that transcript to the blocked paper-contract fields and the active gate-pair
unitarity flags.
-/
theorem oneTermRobinBlockEncodingProofRoute_robinZeroInclusionKeepsOdbsBlocked
    (n : Nat) :
    (oneTermRobinBlockEncodingProofRoute n).robinZeroInclusionSource.zerosIncludedInSparseEnumeration =
        true ∧
      (oneTermRobinBlockEncodingProofRoute n).robinZeroInclusionSource.unusedBranchImageRule =
        none ∧
      (oneTermRobinBlockEncodingProofRoute n).robinZeroInclusionSource.lowerProofSearchAllowed =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).unusedZeroBranchDecision.lowerProofSearchAllowed =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).sparseAccessContract.forwardCorrect.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).sparseAccessContract.daggerCleanup.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).sparseAccessContract.unitaryExtension.proved =
        false ∧
      (GHL2025.oneTermRobinGate_O_D_BS (oneTermParameters n)).unitary.proved =
        false ∧
      (GHL2025.oneTermRobinGate_O_D_BS_dagger (oneTermParameters n)).unitary.proved =
        false := by
  exact ⟨rfl, rfl,
    (oneTermRobinBlockEncodingProofRoute n).robinZeroInclusionBlocksLowerSearch,
    (oneTermRobinBlockEncodingProofRoute n).unusedZeroBranchBlocked,
    (oneTermRobinBlockEncodingProofRoute n).sparseAccessForwardOpen,
    (oneTermRobinBlockEncodingProofRoute n).sparseAccessCleanupOpen,
    (oneTermRobinBlockEncodingProofRoute n).sparseAccessUnitaryOpen,
    rfl,
    rfl⟩

/--
The theorem-level route uses the prior PDE sparse-access source only as a
transcript.

The prior source records the same padded-register equation as GHL2025 Lemma 1,
but its resource claim is still an external obligation and it does not enable
lower proof search for the Robin unused-zero-branch extension.
-/
theorem oneTermRobinBlockEncodingProofRoute_priorPDESourceTranscript
    (n : Nat) :
    (oneTermRobinBlockEncodingProofRoute n).priorSparseAccessSource.oracleEquation =
        "O_A^BS |0>^(n-l)|s>^l|i>^n = |r_si>^n|i>^n" ∧
      (oneTermRobinBlockEncodingProofRoute n).priorSparseAccessSource.resourceClaim.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).priorSparseAccessSource.robinUnusedBranchImageRule =
        none ∧
      (oneTermRobinBlockEncodingProofRoute n).priorSparseAccessSource.lowerProofSearchAllowed =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).unusedZeroBranchDecision.lowerProofSearchAllowed =
        false := by
  exact ⟨rfl, rfl, rfl, rfl,
    (oneTermRobinBlockEncodingProofRoute n).unusedZeroBranchBlocked⟩

/--
The theorem-level route preserves the public anchors for the prior PDE
sparse-access transcript.

This is a source-audit guard only.  It records Definition 6, Lemma 1, the
appendix decomposition, and the fact that the prior source remains an external
resource obligation.  It does not supply the missing Robin unused-branch image
rule or enable lower proof search for `O_D^BS`.
-/
theorem oneTermRobinBlockEncodingProofRoute_priorPDESourceAnchorsTranscript
    (n : Nat) :
    (oneTermRobinBlockEncodingProofRoute n).priorSparseAccessSource.sourceAnchor =
        "Guseynov-Huang-Liu 2024, arXiv:2405.12855v3, Definition 6, Lemma 1, Appendix Banded-sparse-access" ∧
      (oneTermRobinBlockEncodingProofRoute n).priorSparseAccessSource.definitionAnchor =
        "Definition 6: Banded-sparse-access" ∧
      (oneTermRobinBlockEncodingProofRoute n).priorSparseAccessSource.lemmaAnchor =
        "Lemma 1: Banded-sparse-access resource bound" ∧
      (oneTermRobinBlockEncodingProofRoute n).priorSparseAccessSource.appendixAnchor =
        "Appendix: Explicit quantum circuit construction for O_A^BS" ∧
      (oneTermRobinBlockEncodingProofRoute n).priorSparseAccessSource.circuitDecomposition =
        "O_A^BS = U^SUM (U_A^(l) tensor I^n)" ∧
      (oneTermRobinBlockEncodingProofRoute n).priorSparseAccessSource.resourceClaim.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).priorSparseAccessSource.robinUnusedBranchImageRule =
        none ∧
      (oneTermRobinBlockEncodingProofRoute n).priorSparseAccessSource.lowerProofSearchAllowed =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).unusedZeroBranchDecision.lowerProofSearchAllowed =
        false := by
  exact ⟨rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl,
    (oneTermRobinBlockEncodingProofRoute n).unusedZeroBranchBlocked⟩

/--
The theorem-level route carries exactly the audited O_D^BS source transcripts.

This prevents the route from swapping in an alternate source decision while
the unused zero-branch blocker is active.  It is a structural guard only: it
does not add an unused-branch image rule or promote any cleanup/unitarity flag.
-/
theorem oneTermRobinBlockEncodingProofRoute_sourceTranscriptIdentity
    (n : Nat) :
    (oneTermRobinBlockEncodingProofRoute n).unusedZeroBranchDecision =
        GHL2025.bandedSparseAccessUnusedZeroBranchSourceDecision ∧
      (oneTermRobinBlockEncodingProofRoute n).priorSparseAccessSource =
        GHL2025.bandedSparseAccessPriorPDESourceContract ∧
      (oneTermRobinBlockEncodingProofRoute n).robinZeroInclusionSource =
        GHL2025.bandedSparseAccessRobinZeroInclusionSourceContract ∧
      (oneTermRobinBlockEncodingProofRoute n).unusedZeroBranchDecision.lowerProofSearchAllowed =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).robinZeroInclusionSource.lowerProofSearchAllowed =
        false := by
  exact ⟨rfl, rfl, rfl,
    (oneTermRobinBlockEncodingProofRoute n).unusedZeroBranchBlocked,
    (oneTermRobinBlockEncodingProofRoute n).robinZeroInclusionBlocksLowerSearch⟩

/--
The theorem-level route keeps the source-dependency obligations themselves
unproved.

This guard exposes the blocking obligations carried by the audited source
records without unfolding the route.  It does not add an image rule, change an
active `O_D^BS` matrix, or promote block projection/correctness.
-/
theorem oneTermRobinBlockEncodingProofRoute_sourceObligationsFalse
    (n : Nat) :
    (oneTermRobinBlockEncodingProofRoute n).unusedZeroBranchDecision.dependency.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).robinZeroInclusionSource.imageRuleObligation.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).robinZeroInclusionSource.reversibleExtensionObligation.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).priorSparseAccessSource.resourceClaim.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).unusedZeroBranchDecision.lowerProofSearchAllowed =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.blockProjection.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.blockCorrect.proved =
        false := by
  exact ⟨rfl, rfl, rfl, rfl,
    (oneTermRobinBlockEncodingProofRoute n).unusedZeroBranchBlocked,
    (oneTermRobinBlockEncodingProofRoute n).blockProjectionOpen,
    (oneTermRobinBlockEncodingProofRoute n).blockCorrectOpen⟩

/--
The theorem-level route keeps O_D^BS unused-branch proof search disabled.

This guard ties the route blocker to both unused-branch image-rule interfaces:
the direct per-column contract and the full clean-domain wrapper still leave
the image as `none`, while block correctness and O_D^BS semantic flags remain
false.
-/
theorem oneTermRobinBlockEncodingProofRoute_odbsNoLowerProofSearch
    (n j : Nat) :
    (oneTermRobinBlockEncodingProofRoute n).unusedZeroBranchDecision.lowerProofSearchAllowed =
        false ∧
      (GHL2025.bandedSparseAccessUnusedBranchImageRuleContract
        (oneTermParameters n) j).proposedImageIndex = none ∧
      ((GHL2025.bandedSparseAccessFullCleanDomainExtensionContract
        (oneTermParameters n)).unusedBranchImageRuleContract
        j).proposedImageIndex = none ∧
      ((GHL2025.bandedSparseAccessFullCleanDomainExtensionContract
        (oneTermParameters n)).unusedBranchImageRuleContract
        j).imageSpecified.proved = false ∧
      (oneTermRobinBlockEncodingProofRoute n).blockClaim.target.blockCorrect.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).sparseAccessContract.forwardCorrect.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).sparseAccessContract.daggerCleanup.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).sparseAccessContract.unitaryExtension.proved =
        false := by
  exact ⟨rfl, rfl, rfl, rfl,
    (oneTermRobinBlockEncodingProofRoute n).blockCorrectOpen,
    (oneTermRobinBlockEncodingProofRoute n).sparseAccessForwardOpen,
    (oneTermRobinBlockEncodingProofRoute n).sparseAccessCleanupOpen,
    (oneTermRobinBlockEncodingProofRoute n).sparseAccessUnitaryOpen⟩

/--
The disabled source decision keeps every unused-branch image slot empty.

This guard is narrower than a semantic oracle theorem: it only connects the
audited `QBE.ODBS.UnusedZeroBranchExtension` blocker to the per-column
image-rule interfaces used by the theorem route.  It does not choose an image
for unused sparse branches or change any `O_D^BS` proof flag.
-/
theorem oneTermRobinBlockEncodingProofRoute_sourceDecisionImageSlotsBlocked
    (n j : Nat) :
    (oneTermRobinBlockEncodingProofRoute n).unusedZeroBranchDecision.citedResultKey =
        "QBE.ODBS.UnusedZeroBranchExtension" ∧
      (oneTermRobinBlockEncodingProofRoute n).unusedZeroBranchDecision.paperImageRuleSpecified =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).unusedZeroBranchDecision.externalExtensionTheoremAccepted =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).unusedZeroBranchDecision.lowerProofSearchAllowed =
        false ∧
      (GHL2025.bandedSparseAccessUnusedBranchImageRuleContract
        (oneTermParameters n) j).proposedImageIndex = none ∧
      ((GHL2025.bandedSparseAccessFullCleanDomainExtensionContract
        (oneTermParameters n)).unusedBranchImageRuleContract
        j).proposedImageIndex = none ∧
      ((GHL2025.bandedSparseAccessFullCleanDomainExtensionContract
        (oneTermParameters n)).unusedBranchImageRuleContract
        j).imageSpecified.proved = false ∧
      (oneTermRobinBlockEncodingProofRoute n).sparseAccessContract.forwardCorrect.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).sparseAccessContract.daggerCleanup.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).sparseAccessContract.unitaryExtension.proved =
        false := by
  exact ⟨rfl, rfl, rfl,
    (oneTermRobinBlockEncodingProofRoute n).unusedZeroBranchBlocked,
    rfl, rfl, rfl,
    (oneTermRobinBlockEncodingProofRoute n).sparseAccessForwardOpen,
    (oneTermRobinBlockEncodingProofRoute n).sparseAccessCleanupOpen,
    (oneTermRobinBlockEncodingProofRoute n).sparseAccessUnitaryOpen⟩

/--
The theorem-level route also keeps the active `O_D^BS` gate pair in obligation
mode.

This guard is intentionally weaker than a semantic theorem: it only ties the
source-decision blocker to the two gate records used by the circuit product and
to the paper-contract cleanup/unitarity fields.  It does not assert injectivity,
cleanup, or unitarity for either active matrix.
-/
theorem oneTermRobinBlockEncodingProofRoute_activeOdbsGatePairBlocked
    (n : Nat) :
    (oneTermRobinBlockEncodingProofRoute n).unusedZeroBranchDecision.lowerProofSearchAllowed =
        false ∧
      (GHL2025.oneTermRobinGate_O_D_BS (oneTermParameters n)).unitary.proved =
        false ∧
      (GHL2025.oneTermRobinGate_O_D_BS_dagger (oneTermParameters n)).unitary.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).sparseAccessContract.daggerCleanup.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).sparseAccessContract.unitaryExtension.proved =
        false := by
  exact ⟨
    (oneTermRobinBlockEncodingProofRoute n).unusedZeroBranchBlocked,
    rfl,
    rfl,
    (oneTermRobinBlockEncodingProofRoute n).sparseAccessCleanupOpen,
    (oneTermRobinBlockEncodingProofRoute n).sparseAccessUnitaryOpen⟩

/--
The audited `O_D^BS` source blocker propagates to the final theorem flags.

This is a guard theorem for Phase 1: the source obligations remain unproved,
lower proof search remains disabled, the active `O_D^BS` gate pair remains
non-unitary at the record level, and the theorem-level circuit/unitary,
block-extraction, and LCU flags remain false.
-/
theorem oneTermRobinBlockEncodingProofRoute_sourceBlockerKeepsFinalFlagsFalse
    (n : Nat) :
    (oneTermRobinBlockEncodingProofRoute n).unusedZeroBranchDecision.dependency.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).robinZeroInclusionSource.imageRuleObligation.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).unusedZeroBranchDecision.lowerProofSearchAllowed =
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
  exact ⟨rfl, rfl,
    (oneTermRobinBlockEncodingProofRoute n).unusedZeroBranchBlocked,
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
used by the route while preserving the false unitarity flags and the disabled
unused-zero-branch proof-search decision.
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
        false) ∧
      (oneTermRobinBlockEncodingProofRoute n).unusedZeroBranchDecision.lowerProofSearchAllowed =
        false := by
  exact ⟨rfl, rfl, rfl, rfl, rfl, rfl,
    (oneTermRobinBlockEncodingProofRoute n).unusedZeroBranchBlocked⟩

/--
The active `O_D^BS` gate pair keeps public source anchors on its obligation
records.

This is a source-anchor guard only.  It records that the forward and dagger
gate records still cite GHL2025 paper anchors and still keep their unitarity
flags false while the unused-zero-branch source decision disables lower proof
search.
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
        false ∧
      (oneTermRobinBlockEncodingProofRoute n).unusedZeroBranchDecision.lowerProofSearchAllowed =
        false := by
  exact ⟨rfl, rfl, rfl, rfl,
    (oneTermRobinBlockEncodingProofRoute n).unusedZeroBranchBlocked⟩

/--
Guard-only freeze for the blocked `O_D^BS` source gate.

This packages the existing source-decision, image-slot, active-gate wiring,
public-source, and final-flag guards for reviewer use.  It does not select an
image for unused sparse branches or promote any semantic proof flag.
-/
theorem oneTermRobinBlockEncodingProofRoute_sourceGateFreeze
    (n j : Nat) :
    (oneTermRobinBlockEncodingProofRoute n).unusedZeroBranchDecision.lowerProofSearchAllowed =
        false ∧
      (GHL2025.bandedSparseAccessUnusedBranchImageRuleContract
        (oneTermParameters n) j).proposedImageIndex = none ∧
      ((GHL2025.bandedSparseAccessFullCleanDomainExtensionContract
        (oneTermParameters n)).unusedBranchImageRuleContract
        j).proposedImageIndex = none ∧
      (GHL2025.oneTermRobinGate_O_D_BS (oneTermParameters n)).unitary.source =
        "Guseynov-Huang-Liu 2025, Lemma 1, arXiv:2506.20478" ∧
      (GHL2025.oneTermRobinGate_O_D_BS_dagger (oneTermParameters n)).unitary.source =
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
  rcases oneTermRobinBlockEncodingProofRoute_sourceDecisionImageSlotsBlocked n j with
    ⟨_, _, _, hlowerBlocked, himageSlot, hwrappedSlot, _, _, _, _⟩
  rcases oneTermRobinBlockEncodingProofRoute_activeOdbsGatePairPublicSources n with
    ⟨hforwardSource, hdaggerSource, _, _, _⟩
  rcases oneTermRobinBlockEncodingProofRoute_activeOdbsGatePairWiring n with
    ⟨_, hforwardMatrix, _, _, hdaggerMatrix, _, _⟩
  rcases oneTermRobinBlockEncodingProofRoute_blockProjectionNormalizerAudit n with
    ⟨_, _, _, _, hnormalizer, hsignalIndex, _, hblockCorrect, _, _⟩
  rcases oneTermRobinBlockEncodingProofRoute_sourceBlockerKeepsFinalFlagsFalse n with
    ⟨_, _, _, _, _, _, hcircuitUnitary, _, _, hlcu⟩
  exact ⟨hlowerBlocked, himageSlot, hwrappedSlot, hforwardSource, hdaggerSource,
    hforwardMatrix, hdaggerMatrix, hnormalizer, hsignalIndex, hcircuitUnitary,
    hblockCorrect, hlcu⟩

/--
The source-gate freeze keeps the projection target and final theorem flags
open.

This packages the repeated guard that combines the block-projection audit with
the source-blocker audit.  It is a proof-DAG block for reviewer checks only:
it does not change the signal index, select an unused-branch image rule, or
promote any semantic proof flag.
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
      (oneTermRobinBlockEncodingProofRoute n).unusedZeroBranchDecision.lowerProofSearchAllowed =
        false := by
  rcases oneTermRobinBlockEncodingProofRoute_blockProjectionNormalizerAudit n with
    ⟨_, _, _, _, hnormalizer, hsignalIndex, hblockProjection, hblockCorrect, _,
      hlcu⟩
  rcases oneTermRobinBlockEncodingProofRoute_sourceBlockerKeepsFinalFlagsFalse n with
    ⟨_, _, hlowerBlocked, _, _, _, hcircuitUnitary, hblockExtraction, _, _⟩
  exact ⟨hnormalizer, hsignalIndex, hblockProjection, hblockCorrect,
    hcircuitUnitary, hblockExtraction, hlcu, hlowerBlocked⟩

/--
The theorem route keeps the concrete `n = 3` rejected row-dependent collision
as regression memory while checking that the active global-slot image separates
the same two columns.

This packages the old boundary-collision witness together with the route false
flags.  It is not an injectivity theorem and does not select an unused-branch
image rule.
-/
theorem oneTermRobinBlockEncodingProofRoute_activeCollisionBlocked_n3 :
    let p := oneTermParameters 3
    GHL2025.bandedSparseAccessRowDependentPaperImage p 0 =
        GHL2025.bandedSparseAccessRowDependentPaperImage p 48 ∧
      GHL2025.bandedSparseAccessPaperImage p 0 ≠
        GHL2025.bandedSparseAccessPaperImage p 48 ∧
      (GHL2025.oneTermRobinGate_O_D_BS p).matrix
          ⟨96, by native_decide⟩ ⟨0, by native_decide⟩ = Coeff.rat 1 ∧
      (GHL2025.oneTermRobinGate_O_D_BS p).matrix
          ⟨16, by native_decide⟩ ⟨48, by native_decide⟩ = Coeff.rat 1 ∧
      (GHL2025.bandedSparseAccessUnusedBranchImageRuleContract p 48).proposedImageIndex =
        none ∧
      (oneTermRobinBlockEncodingProofRoute 3).unusedZeroBranchDecision.lowerProofSearchAllowed =
        false ∧
      (oneTermRobinBlockEncodingProofRoute 3).sparseAccessContract.daggerCleanup.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute 3).sparseAccessContract.unitaryExtension.proved =
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
      (oneTermRobinBlockEncodingProofRoute 3).unusedZeroBranchDecision.lowerProofSearchAllowed =
        false ∧
      (oneTermRobinBlockEncodingProofRoute 3).sparseAccessContract.daggerCleanup.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute 3).blockClaim.target.blockCorrect.proved =
        false := by
  native_decide

/--
The theorem-level route uses the default Lemma 1 `O_D^BS` contract object.

This guard prevents a later lower packet from swapping in a different
sparse-access contract while preserving similar-looking field values.  It
does not prove the oracle image, dagger cleanup, or unitary extension.
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
      (oneTermRobinBlockEncodingProofRoute n).unusedZeroBranchDecision.lowerProofSearchAllowed =
        false := by
  exact ⟨rfl,
    (oneTermRobinBlockEncodingProofRoute n).sparseAccessForwardOpen,
    (oneTermRobinBlockEncodingProofRoute n).sparseAccessCleanupOpen,
    (oneTermRobinBlockEncodingProofRoute n).sparseAccessUnitaryOpen,
    (oneTermRobinBlockEncodingProofRoute n).unusedZeroBranchBlocked⟩

/--
The theorem-level route carries the Lemma 1 `O_D^BS` paper contract verbatim.

This is a source-transcript guard.  It pins the padded input/output ket
formula and the register widths while keeping all paper-contract semantic
flags false and lower O_D^BS proof search disabled.
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
      (oneTermRobinBlockEncodingProofRoute n).unusedZeroBranchDecision.lowerProofSearchAllowed =
        false := by
  simp [oneTermRobinBlockEncodingProofRoute,
    GHL2025.defaultBandedSparseAccessPaperContract,
    GHL2025.bandedSparseAccessUnusedZeroBranchSourceDecision]

/--
Concrete source-decision freeze for the blocked `n = 3` O_D^BS witness.

This guard packages the accepted source-transcript, collision, contract-drift,
projection, and source-obligation guards into one reviewer-facing checkpoint.
It is not an image rule and does not promote injectivity, cleanup, unitarity,
LCU correctness, or block extraction.
-/
theorem oneTermRobinBlockEncodingProofRoute_sourceDecisionOnlyFreeze_n3 :
    (oneTermRobinBlockEncodingProofRoute 3).unusedZeroBranchDecision =
        GHL2025.bandedSparseAccessUnusedZeroBranchSourceDecision ∧
      (oneTermRobinBlockEncodingProofRoute 3).priorSparseAccessSource =
        GHL2025.bandedSparseAccessPriorPDESourceContract ∧
      (oneTermRobinBlockEncodingProofRoute 3).robinZeroInclusionSource =
        GHL2025.bandedSparseAccessRobinZeroInclusionSourceContract ∧
      (oneTermRobinBlockEncodingProofRoute 3).unusedZeroBranchDecision.lowerProofSearchAllowed =
        false ∧
      (GHL2025.bandedSparseAccessUnusedBranchImageRuleContract
        (oneTermParameters 3) 48).proposedImageIndex = none ∧
      GHL2025.bandedSparseAccessPaperImage (oneTermParameters 3) 0 ≠
        GHL2025.bandedSparseAccessPaperImage (oneTermParameters 3) 48 ∧
      GHL2025.bandedSparseAccessPaperImage (oneTermParameters 3) 8 = 40 ∧
      (oneTermRobinBlockEncodingProofRoute 3).blockClaim.target.normalizer =
        GHL2025.oneTermRobinNormalizer ∧
      (oneTermRobinBlockEncodingProofRoute 3).blockClaim.target.signalIndex.val =
        0 ∧
      (oneTermRobinBlockEncodingProofRoute 3).unusedZeroBranchDecision.dependency.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute 3).robinZeroInclusionSource.imageRuleObligation.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute 3).robinZeroInclusionSource.reversibleExtensionObligation.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute 3).priorSparseAccessSource.resourceClaim.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute 3).sparseAccessContract.daggerCleanup.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute 3).sparseAccessContract.unitaryExtension.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute 3).theoremData.obligations.circuitUnitary.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute 3).theoremData.obligations.blockExtraction.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute 3).blockClaim.target.blockCorrect.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute 3).oracleComposition.lcuCorrect.proved =
        false := by
  rcases oneTermRobinBlockEncodingProofRoute_sourceTranscriptIdentity 3 with
    ⟨hdecision, hpriorTranscript, hrobinTranscript, hlowerTranscript, _⟩
  rcases oneTermRobinBlockEncodingProofRoute_sourceGateFreeze 3 48 with
    ⟨_, himageSlot, _, _, _, _, _, hnormalizer, hsignalIndex,
      hcircuitUnitary, hblockCorrect, hlcu⟩
  rcases oneTermRobinBlockEncodingProofRoute_projectionSourceFreeze 3 with
    ⟨_, _, _, _, _, hblockExtraction, _, _⟩
  rcases oneTermRobinBlockEncodingProofRoute_sourceObligationsFalse 3 with
    ⟨hdependency, himageObligation, hreverseObligation, hpriorResource,
      _, _, _⟩
  rcases oneTermRobinBlockEncodingProofRoute_activeCollisionBlocked_n3 with
    ⟨_, hactiveNoCollision, _, _, _, _, hdaggerCleanup,
      hunitaryExtension, _⟩
  rcases oneTermRobinBlockEncodingProofRoute_contractDriftColumn8Blocked_n3 with
    ⟨hcolumn8, _, _, _, _, _, _⟩
  exact ⟨hdecision, hpriorTranscript, hrobinTranscript, hlowerTranscript,
    himageSlot, hactiveNoCollision, hcolumn8, hnormalizer, hsignalIndex,
    hdependency, himageObligation, hreverseObligation, hpriorResource,
    hdaggerCleanup, hunitaryExtension, hcircuitUnitary, hblockExtraction,
    hblockCorrect, hlcu⟩

/--
The concrete source-decision freeze keeps both unused-branch image-rule slots
empty for the recorded `n = 3` boundary column.

This is a focused guard for the direct per-column slot and the full clean-domain
wrapper slot.  It does not choose an unused-branch image and does not promote
LCU or block correctness.
-/
theorem oneTermRobinBlockEncodingProofRoute_sourceDecisionWrapperSlotsBlocked_n3 :
    (oneTermRobinBlockEncodingProofRoute 3).unusedZeroBranchDecision.paperImageRuleSpecified =
        false ∧
      (oneTermRobinBlockEncodingProofRoute 3).unusedZeroBranchDecision.externalExtensionTheoremAccepted =
        false ∧
      (oneTermRobinBlockEncodingProofRoute 3).unusedZeroBranchDecision.lowerProofSearchAllowed =
        false ∧
      (GHL2025.bandedSparseAccessUnusedBranchImageRuleContract
        (oneTermParameters 3) 48).proposedImageIndex = none ∧
      (GHL2025.bandedSparseAccessUnusedBranchImageRuleContract
        (oneTermParameters 3) 48).imageSpecified.proved = false ∧
      ((GHL2025.bandedSparseAccessFullCleanDomainExtensionContract
        (oneTermParameters 3)).unusedBranchImageRuleContract
        48).proposedImageIndex = none ∧
      ((GHL2025.bandedSparseAccessFullCleanDomainExtensionContract
        (oneTermParameters 3)).unusedBranchImageRuleContract
        48).imageSpecified.proved = false ∧
      (oneTermRobinBlockEncodingProofRoute 3).blockClaim.target.blockCorrect.proved =
        false ∧
      (oneTermRobinBlockEncodingProofRoute 3).oracleComposition.lcuCorrect.proved =
        false := by
  rcases oneTermRobinBlockEncodingProofRoute_sourceDecisionImageSlotsBlocked 3 48 with
    ⟨_, hpaper, hext, hlower, hdirectSlot, hwrappedSlot, hwrappedImage, _, _, _⟩
  rcases GHL2025.bandedSparseAccessUnusedBranchImageRuleContract_flags_false
      (oneTermParameters 3) 48 with
    ⟨_, hdirectImage, _, _, _⟩
  exact ⟨hpaper, hext, hlower, hdirectSlot, hdirectImage, hwrappedSlot,
    hwrappedImage, (oneTermRobinBlockEncodingProofRoute 3).blockCorrectOpen,
    (oneTermRobinBlockEncodingProofRoute 3).lcuOpen⟩

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
        (oneTermRobinBlockEncodingProofRoute n).unusedZeroBranchDecision.lowerProofSearchAllowed =
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
      hlowerBlocked⟩
  rcases oneTermRobinBlockEncodingProofRoute_flags_false n with
    ⟨hblockProjection, hblockCorrect, hblockExtraction, hcircuitUnitary,
      _hrouteSparseCleanup, _hrouteSparseUnitary, _hunusedBlocked,
      _hpriorOpen, _hrobinOpen, _hrobinLower, _hfunctionSource,
      _hfunctionAmp, hlcu⟩
  exact ⟨post, pre, hcleanup, hpost, hpre, hpreSource, hindicator,
    hcontractIdentity, hcleanupOpen, hunitaryOpen, hforwardUnitaryFlag,
    hdaggerUnitaryFlag, hcircuitUnitary, hblockExtraction, hblockProjection,
    hblockCorrect, hlcu, hlowerBlocked⟩

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
      (oneTermRobinBlockEncodingProofRoute n).unusedZeroBranchDecision.lowerProofSearchAllowed =
        false := by
  rcases GHL2025.bandedSparseAccessCleanupScopeDecision_activeGlobalSource
      (oneTermParameters n) with
    ⟨hscope, hpredicate, hevidence, hfullClean, hfullSpace, hpromotion,
      hpaperCleanup, hfullCleanCleanup, hfullSpaceUnitary⟩
  rcases oneTermRobinBlockEncodingProofRoute_sparseAccessContractIdentity n with
    ⟨hcontractIdentity, _hforwardOpen, hcleanupOpen, hunitaryOpen,
      hlowerBlocked⟩
  exact ⟨hscope, hpredicate, hevidence, hfullClean, hfullSpace, hpromotion,
    hpaperCleanup, hfullCleanCleanup, hfullSpaceUnitary, hcontractIdentity,
    hcleanupOpen, hunitaryOpen,
    (oneTermRobinBlockEncodingProofRoute n).blockCorrectOpen,
    (oneTermRobinBlockEncodingProofRoute n).lcuOpen, hlowerBlocked⟩

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
      (oneTermRobinBlockEncodingProofRoute n).unusedZeroBranchDecision.lowerProofSearchAllowed =
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
    (oneTermRobinBlockEncodingProofRoute n).unusedZeroBranchBlocked,
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
        (oneTermRobinBlockEncodingProofRoute n).unusedZeroBranchDecision.lowerProofSearchAllowed =
          false := by
  rcases
      oneTermRobinBlockEncodingProofRoute_odbsRestrictedDaggerColumnIndicator
        n source hn hsource
      with
    ⟨post, pre, hcleanup, hpost, hpre, hpreSource, hindicator,
      _hcontractIdentity, hcleanupOpen, hunitaryOpen, hforwardUnitaryFlag,
      hdaggerUnitaryFlag, hcircuitUnitary, hblockExtraction,
      hblockProjection, hblockCorrect, hlcu, hlowerBlocked⟩
  rcases oneTermRobinBlockEncodingProofRoute_odbsCleanupScopeDecision n with
    ⟨hscope, hpredicate, hevidence, hfullClean, hfullSpace, hpromotion,
      _hpaperCleanup, _hfullCleanCleanup, _hfullSpaceUnitary,
      _hcontractIdentity, _hcleanupOpen, _hunitaryOpen, _hblockCorrect,
      _hlcu, _hlowerBlocked⟩
  exact ⟨post, pre, hcleanup, hpost, hpre, hpreSource, hindicator, hscope,
    hpredicate, hevidence, hpromotion, hfullClean, hfullSpace, hcleanupOpen,
    hunitaryOpen, hforwardUnitaryFlag, hdaggerUnitaryFlag, hcircuitUnitary,
    hblockExtraction, hblockProjection, hblockCorrect, hlcu, hlowerBlocked⟩

end Examples.RobinHeat

end QuantumBlockEncoding

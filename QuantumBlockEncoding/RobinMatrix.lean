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
CircuitMatrixSemantics for the one-term Robin circuit using placeholder gate matrices.
The full-space matrix is the product of the 7 placeholder gate matrices
(which is currently the zero matrix since all placeholders return 0).
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
Block-extraction target for the Robin derivative block encoding.
States that the `(0, 0)` block of the circuit matrix should equal
`A_k / (N_D * N_f * kappa)`.

The `signalDim` is `qubitDim signalQubits` where `signalQubits` comes from the
register layout.  `systemDim` is `gridSize n`.
figure:1_term_ROBIN, main.tex:1131-1136 --/
def oneTermRobinBlockExtractionTarget (n : Nat) :
    BlockExtractionTarget Coeff (gridSize n) (gridSize n)
      (qubitDim (GHL2025.oneTermRobinLayout (oneTermParameters n)).signalQubits) where
  unitaryMatrix := fun _ _ => Coeff.rat 0
  targetMatrix := robinDerivativeMatrix n
  normalizer := GHL2025.oneTermRobinNormalizer
  signalIndex := ⟨0, by
    show (0 : Nat) < qubitDim (GHL2025.oneTermRobinLayout (oneTermParameters n)).signalQubits
    simp only [qubitDim, gridSize, oneTermParameters,
      GHL2025.oneTermRobinLayout, clog2_one]
    have : ∀ k : Nat, (0 : Nat) < 2 ^ k := by
      intro k; induction k with
      | zero => decide
      | succ k _ => simp [Nat.pow_succ]; omega
    exact this _⟩
  blockMatrix := fun _ _ => Coeff.rat 0
  blockProjection := {
    description := "block projection for one-term Robin: signal register at index 0"
    source := "main.tex:1131-1136, figure:1_term_ROBIN"
    proved := false
  }
  blockCorrect := {
    description := "extracted block = robinDerivativeMatrix n / (N_D * N_f * kappa)"
    source := "main.tex:1131-1136, Theorem:1 term robin"
    proved := false
  }

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
      qubitDim ((GHL2025.oneTermRobinLayout (oneTermParameters n)).signalQubits) *
        gridSize n) :
    CircuitBlockEncodingClaim Coeff
      (GHL2025.oneTermRobinTotalQubits (oneTermParameters n))
      (gridSize n)
      (qubitDim ((GHL2025.oneTermRobinLayout (oneTermParameters n)).signalQubits)) where
  semantics := oneTermRobinCircuitSemantics n
  target := oneTermRobinBlockExtractionTarget n
  dimCompat := hDim
  blockCorrect := {
    description := "one-term Robin: block extraction = A_k / (N_D * N_f * kappa)"
    source := "main.tex:1131-1136, Theorem:1 term robin"
    proved := false
  }

/--
Dimension compatibility for the one-term Robin circuit:
the full Hilbert-space dimension factors as signal dimension times system
dimension.  This is the reusable arithmetic bridge from qubit counts to the
block-projection matrix shape.
figure:1_term_ROBIN, main.tex:1098-1109 --/
theorem oneTermRobinCircuitDimCompat (n : Nat) :
    qubitDim (GHL2025.oneTermRobinTotalQubits (oneTermParameters n)) =
      qubitDim ((GHL2025.oneTermRobinLayout (oneTermParameters n)).signalQubits) *
        gridSize n := by
  simp only [qubitDim, GHL2025.oneTermRobinTotalQubits, GHL2025.oneTermRobinLayout,
    oneTermParameters, clog2_gridSize, clog2_one]
  simp [gridSize, Nat.pow_add, Nat.mul_comm]

/--
Default one-term Robin circuit block claim using the reusable dimension
compatibility theorem.  The block-correctness obligation remains unproved.
-/
def defaultOneTermRobinCircuitBlockClaim (n : Nat) :
    CircuitBlockEncodingClaim Coeff
      (GHL2025.oneTermRobinTotalQubits (oneTermParameters n))
      (gridSize n)
      (qubitDim ((GHL2025.oneTermRobinLayout (oneTermParameters n)).signalQubits)) :=
  oneTermRobinCircuitBlockClaim n (oneTermRobinCircuitDimCompat n)

end Examples.RobinHeat

end QuantumBlockEncoding

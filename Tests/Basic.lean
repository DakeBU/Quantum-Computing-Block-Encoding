import QuantumBlockEncoding

open QuantumBlockEncoding

example : gridSize 3 = 8 := rfl

example : (bandedSparseAccessResource 4 2).pureAncilla = 3 := rfl

example :
    (GHL2025.oneTermRobinResource { n := 5, kappa := 7, functionPieces := 1, polynomialDegreeCost := 3 }).pureAncilla = 10 := rfl

example : Examples.RobinHeat.fourthOrderSecondDerivative.width = 5 := rfl

example : problemCount = 7 := rfl

example : literatureCount = 16 := rfl

example : automationTaskCount = 3 := rfl

example : threeLayerAgentContracts.length = 4 := rfl

-- CircuitSemantics tests: first matrix-semantics backend layer

example : qubitDim 3 = 8 := rfl

example :
    (Matrix.identity 2 Rat) ⟨0, by native_decide⟩ ⟨0, by native_decide⟩ = 1 := by
  native_decide

example :
    (Matrix.identity 2 Rat) ⟨0, by native_decide⟩ ⟨1, by native_decide⟩ = 0 := by
  native_decide

def testIdentityGateMatrix : GateMatrix Rat 1 where
  gate := Gate.oneQubit "I" 0
  matrix := Matrix.identity (qubitDim 1) Rat
  unitary := {
    description := "identity gate matrix is unitary"
    source := "Tests/Basic.lean"
    proved := true
  }

example :
    gateMatricesMatchCircuit [Gate.oneQubit "I" 0] [testIdentityGateMatrix] = true := rfl

example :
    gateMatricesMatchCircuit [Gate.oneQubit "X" 0] [testIdentityGateMatrix] = false := rfl

example :
    (evalGateMatrices [testIdentityGateMatrix])
      ⟨0, by native_decide⟩ ⟨0, by native_decide⟩ = 1 := by
  native_decide

example :
    (CircuitMatrixSemantics.ofGateMatrices
      [Gate.oneQubit "I" 0] [testIdentityGateMatrix] rfl).gateListMatches = rfl := rfl

-- RobinMatrix tests (buildRobinMatrix from stencil data)
open QuantumBlockEncoding.Coeff

-- Bulk diagonal entry: row 2, col 2 should be bare -5/2 (single-match, no zero-wrapping)
example :
    (Examples.RobinHeat.robinDerivativeMatrix 3)
      ⟨2, by native_decide⟩ ⟨2, by native_decide⟩ =
    Coeff.rat ((-5 : Rat) / 2) := by native_decide

-- Bulk off-diagonal: row 2, col 0 should be bare -1/12 (single-match)
example :
    (Examples.RobinHeat.robinDerivativeMatrix 3)
      ⟨2, by native_decide⟩ ⟨0, by native_decide⟩ =
    Coeff.rat ((-1 : Rat) / 12) := by native_decide

-- Left boundary row 0, col 0: the Robin-corrected diagonal entry (single-match, bare add)
example :
    (Examples.RobinHeat.robinDerivativeMatrix 3)
      ⟨0, by native_decide⟩ ⟨0, by native_decide⟩ =
    Coeff.add (Coeff.rat ((-5 : Rat) / 2))
      (Coeff.mul (Coeff.rat ((7 : Rat) / 3)) (Coeff.symbol "A1*dx")) := by native_decide

-- Zero entry: row 0, col 3 has no stencil contribution
example :
    (Examples.RobinHeat.robinDerivativeMatrix 3)
      ⟨0, by native_decide⟩ ⟨3, by native_decide⟩ =
    Coeff.rat 0 := by native_decide

-- Cycle 4 upper: paper-anchor boundary matrix entry tests (Eq. 24, main.tex:1014-1025)

-- Row 0, col 1: left boundary off-diagonal = 8/3
example :
    (Examples.RobinHeat.robinDerivativeMatrix 3)
      ⟨0, by native_decide⟩ ⟨1, by native_decide⟩ =
    Coeff.rat ((8 : Rat) / 3) := by native_decide

-- Row 0, col 2: left boundary far off-diagonal = -1/6
example :
    (Examples.RobinHeat.robinDerivativeMatrix 3)
      ⟨0, by native_decide⟩ ⟨2, by native_decide⟩ =
    Coeff.rat ((-1 : Rat) / 6) := by native_decide

-- Row 1, col 0: left boundary row, off-diagonal with A1*dx term
-- Paper: 4/3 - A1*dx/6
example :
    (Examples.RobinHeat.robinDerivativeMatrix 3)
      ⟨1, by native_decide⟩ ⟨0, by native_decide⟩ =
    Coeff.add (Coeff.rat ((4 : Rat) / 3))
      (Coeff.neg (Coeff.mul (Coeff.rat ((1 : Rat) / 6)) (Coeff.symbol "A1*dx"))) := by native_decide

-- Row 1, col 1: left boundary row, diagonal = -31/12
example :
    (Examples.RobinHeat.robinDerivativeMatrix 3)
      ⟨1, by native_decide⟩ ⟨1, by native_decide⟩ =
    Coeff.rat ((-31 : Rat) / 12) := by native_decide

-- Row 1, col 2: left boundary row, off-diagonal = 4/3
example :
    (Examples.RobinHeat.robinDerivativeMatrix 3)
      ⟨1, by native_decide⟩ ⟨2, by native_decide⟩ =
    Coeff.rat ((4 : Rat) / 3) := by native_decide

-- Row 1, col 3: left boundary row, far off-diagonal = -1/12
example :
    (Examples.RobinHeat.robinDerivativeMatrix 3)
      ⟨1, by native_decide⟩ ⟨3, by native_decide⟩ =
    Coeff.rat ((-1 : Rat) / 12) := by native_decide

-- Row 6, col 4: right boundary row, first nonzero = -1/12
example :
    (Examples.RobinHeat.robinDerivativeMatrix 3)
      ⟨6, by native_decide⟩ ⟨4, by native_decide⟩ =
    Coeff.rat ((-1 : Rat) / 12) := by native_decide

-- Row 6, col 5: right boundary row, off-diagonal = 4/3
example :
    (Examples.RobinHeat.robinDerivativeMatrix 3)
      ⟨6, by native_decide⟩ ⟨5, by native_decide⟩ =
    Coeff.rat ((4 : Rat) / 3) := by native_decide

-- Row 6, col 6: right boundary row, diagonal = -31/12
example :
    (Examples.RobinHeat.robinDerivativeMatrix 3)
      ⟨6, by native_decide⟩ ⟨6, by native_decide⟩ =
    Coeff.rat ((-31 : Rat) / 12) := by native_decide

-- Row 6, col 7: right boundary row, off-diagonal with B1*dx term
-- Paper: 4/3 + B1*dx/6
example :
    (Examples.RobinHeat.robinDerivativeMatrix 3)
      ⟨6, by native_decide⟩ ⟨7, by native_decide⟩ =
    Coeff.add (Coeff.rat ((4 : Rat) / 3))
      (Coeff.mul (Coeff.rat ((1 : Rat) / 6)) (Coeff.symbol "B1*dx")) := by native_decide

-- Row 7, col 5: last row, first nonzero = -1/6
example :
    (Examples.RobinHeat.robinDerivativeMatrix 3)
      ⟨7, by native_decide⟩ ⟨5, by native_decide⟩ =
    Coeff.rat ((-1 : Rat) / 6) := by native_decide

-- Row 7, col 6: last row, off-diagonal = 8/3
example :
    (Examples.RobinHeat.robinDerivativeMatrix 3)
      ⟨7, by native_decide⟩ ⟨6, by native_decide⟩ =
    Coeff.rat ((8 : Rat) / 3) := by native_decide

-- Row 7, col 7: last row, diagonal with B1*dx term
-- Paper: -5/2 - 7*B1*dx/3
example :
    (Examples.RobinHeat.robinDerivativeMatrix 3)
      ⟨7, by native_decide⟩ ⟨7, by native_decide⟩ =
    Coeff.add (Coeff.rat ((-5 : Rat) / 2))
      (Coeff.neg (Coeff.mul (Coeff.rat ((7 : Rat) / 3)) (Coeff.symbol "B1*dx"))) := by native_decide

-- GHL2025 BlockEncodingSpec tests

-- Spec ancilla count matches the resource formula
example (p : GHL2025.OneTermRobinParameters)
    (mat : Matrix (gridSize p.n) (gridSize p.n) Coeff) :
    (GHL2025.oneTermRobinSpec p mat).resource.pureAncilla = 2 * p.n :=
  GHL2025.oneTermRobinSpec_ancilla p mat

-- Spec circuit local cost: 3 CNOTs from SWAP placeholder, oracle calls are free
example : Circuit.resource GHL2025.oneTermRobinCircuit = Resource.ofCounts 0 3 0 :=
  GHL2025.oneTermRobinSpec_circuitCost

-- Spec circuit gate count: 7 gates (U_indic, O_DT^S, Ry_boundary, O_D^BS, O_f, SWAP, (O_D^BS)^†)
-- figure:1_term_ROBIN
example : GHL2025.oneTermRobinCircuit.length = 7 := rfl

-- Spec matrix entry at bulk diagonal matches direct robinDerivativeMatrix call (bare Coeff)
example :
    (GHL2025.oneTermRobinSpec
      { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
      (Examples.RobinHeat.robinDerivativeMatrix 3)).matrix
      ⟨2, by native_decide⟩ ⟨2, by native_decide⟩ =
    Coeff.rat ((-5 : Rat) / 2) := by native_decide

-- Spec layout pure ancillas match 2n
example :
    (GHL2025.oneTermRobinLayout { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }).pureAncillas = 6 := rfl

-- Coeff.evalWith tests

-- evalWith on a bare rational returns that rational
example : Coeff.evalWith (fun _ => 0) (Coeff.rat 5) = (5 : Rat) := rfl

-- evalWith on a symbol looks up the environment
example : Coeff.evalWith (fun s => if s = "A1*dx" then 3 else 0) (Coeff.symbol "A1*dx") = (3 : Rat) := rfl

-- evalWith on add adds the evaluated components
example : Coeff.evalWith (fun _ => 1) (Coeff.add (Coeff.rat 2) (Coeff.symbol "x")) = (3 : Rat) := by native_decide

-- evalWith on mul multiplies the evaluated components
example : Coeff.evalWith (fun _ => 2) (Coeff.mul (Coeff.rat 3) (Coeff.symbol "x")) = (6 : Rat) := by native_decide

-- evalWith on neg negates
example : Coeff.evalWith (fun _ => 0) (Coeff.neg (Coeff.rat 4)) = (-4 : Rat) := by native_decide

-- Numeric normalizer tests (all symbols set to 0 → bulk-only evaluation)

-- oneTermRobinNumericNormalizer: α = N_D * N_F * κ
example : Examples.RobinHeat.oneTermRobinNumericNormalizer 3 2 5 = (30 : Rat) := by native_decide

-- robinNormalizerBound: Bool check that α ≥ ∥D_Robin∥₁, provable by native_decide for concrete args
-- With all boundary symbols = 0, the Robin matrix is purely the bulk stencil.
-- We check the bound holds for a concrete instance: n=3, env maps all symbols to 0, nF=1, kappa=7
example :
    Examples.RobinHeat.robinNormalizerBound 3 (fun _ => 0) 1 7 = true := by
  native_decide

-- GHL2025 normalizer-eval lemma tests

-- Symbolic normalizer evaluates to product of symbol lookups
example (env : String → Rat) :
    Coeff.evalWith env GHL2025.oneTermRobinNormalizer = env "N_D" * env "N_f" * env "kappa" :=
  GHL2025.oneTermRobinNormalizer_eval env

-- Concrete normalizer eval: env maps N_D=3, N_f=2, kappa=5 → 30
example :
    Coeff.evalWith (fun s => if s = "N_D" then 3 else if s = "N_f" then 2 else 5)
      GHL2025.oneTermRobinNormalizer = (30 : Rat) := by
  native_decide

-- Numeric normalizer equals symbolic normalizer under the right env
example :
    Examples.RobinHeat.oneTermRobinNumericNormalizer 3 2 5 =
      Coeff.evalWith
        (fun s => if s = "N_D" then (3 : Rat) else if s = "N_f" then 2 else 5)
        GHL2025.oneTermRobinNormalizer :=
  Examples.RobinHeat.oneTermRobinNumericNormalizer_eq_eval 3 2 5

-- clog2 (gridSize n) = n for concrete n values (justifies systemQubits = n)
example : clog2 (gridSize 1) = 1 := by native_decide
example : clog2 (gridSize 2) = 2 := by native_decide
example : clog2 (gridSize 3) = 3 := by native_decide
example : clog2 (gridSize 5) = 5 := by native_decide

-- General reusable dimension lemma for n-qubit grids
example (n : Nat) : clog2 (gridSize n) = n := clog2_gridSize n

-- Total qubits for a concrete layout (n=3, kappa=7, functionPieces=1, polynomialDegreeCost=1)
-- clog2 3 = 2, clog2 1 = 0, clog2 7 = 3 → signalQubits = 2 + 0 + 3 + 4 = 9
example :
    let layout := GHL2025.oneTermRobinLayout
      { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    layout.systemQubits + layout.signalQubits + layout.pureAncillas = 3 + (2 + 0 + 3 + 4) + 6 := rfl

-- Cycle 3: robinBlockEncodingSpec tests

-- AC-1: spec matrix matches robinDerivativeMatrix at a bulk diagonal entry (n=3)
example :
    (Examples.RobinHeat.robinBlockEncodingSpec 3).matrix
      ⟨2, by native_decide⟩ ⟨2, by native_decide⟩ =
    Coeff.rat ((-5 : Rat) / 2) := by native_decide

-- AC-2: spec resource pureAncilla = 2n (rfl)
example (n : Nat) :
    (Examples.RobinHeat.robinBlockEncodingSpec n).resource.pureAncilla = 2 * n :=
  Examples.RobinHeat.robinBlockEncodingSpec_pureAncilla n

-- AC-3: clog2 (gridSize 10) = 10
example : clog2 (gridSize 10) = 10 := by native_decide

-- AC-4: DerivativeOracleContract compiles with RobinHeat stencil
example : GHL2025.DerivativeOracleContract 3 := {
  stencil := Examples.RobinHeat.fourthOrderSecondDerivative
  bandwidth := 5
  matrix := Examples.RobinHeat.robinDerivativeMatrix 3
  sparseCorrect := ⟨"O_D^BS test", "main.tex:784-801", false⟩
  bandwidth_eq := rfl
}

-- AC-4: FunctionOracleContract compiles
example : GHL2025.FunctionOracleContract 3 := {
  functionPieces := 1
  normalizerBound := Coeff.symbol "N_f"
  amplitudeCorrect := ⟨"O_f test", "main.tex:870-910", false⟩
}

-- Cycle 3 lower: derivative oracle resource wiring tests

-- derivativeOracleResource pure ancilla = n - 1 for general stencil
example (n : Nat) (s : Stencil) :
    (GHL2025.derivativeOracleResource n s).pureAncilla = n - 1 :=
  GHL2025.derivativeOracleResource_pureAncilla n s

-- Robin derivative oracle resource equals bandedSparseAccessResource n 2
example (n : Nat) :
    Examples.RobinHeat.robinDerivativeOracleResource n =
      bandedSparseAccessResource n 2 :=
  Examples.RobinHeat.robinDerivativeOracleResource_eq n

-- Concrete: n=4, l=2 → pure ancilla = 3
example : (Examples.RobinHeat.robinDerivativeOracleResource 4).pureAncilla = 3 := rfl

-- Concrete: n=4, l=2 → oneQubit = (2^2+1)*(32*4-48) = 5*80 = 400
example : (Examples.RobinHeat.robinDerivativeOracleResource 4).oneQubit = 400 := rfl

-- Concrete: n=4, l=2 → cnot = 25*4*4 - 36*4 + 32*4 - 48 = 400 - 144 + 128 - 48 = 336
example : (Examples.RobinHeat.robinDerivativeOracleResource 4).cnot = 336 := rfl

-- Cycle 4 lower: named proof-obligation and oracle composition tests

-- PO-6: robinBlockEncodingPredicate structural preconditions hold for n=3
-- (normalizer bound = true, pureAncilla = 2n, error = 0)
example : Examples.RobinHeat.robinBlockEncodingPredicate 3 := by
  unfold Examples.RobinHeat.robinBlockEncodingPredicate
  exact ⟨by native_decide, rfl, rfl⟩

-- PO-7: robinResourceBoundHolds — pureAncilla = 2n and gate count ≤ paper formula for n=3
example : Examples.RobinHeat.robinResourceBoundHolds 3 := by
  unfold Examples.RobinHeat.robinResourceBoundHolds
  exact ⟨rfl, by native_decide⟩

-- Oracle composition: bandwidth = 5 for the fourth-order stencil (rfl via simp lemma)
example : (Examples.RobinHeat.robinOracleComposition 3).derivativeOracle.bandwidth = 5 := rfl

-- Oracle composition: function pieces = 1
example : (Examples.RobinHeat.robinOracleComposition 3).functionOracle.functionPieces = 1 := rfl

-- Oracle composition: matrix coherence — oracle matrix equals robinDerivativeMatrix
example (n : Nat) :
    (Examples.RobinHeat.robinOracleComposition n).derivativeOracle.matrix =
      Examples.RobinHeat.robinDerivativeMatrix n :=
  Examples.RobinHeat.robinOracleComposition_matrix n

-- PO-9: oneTermRobinResourceConsistent -- pureAncilla = 2n for the symbolic resource
example : Examples.RobinHeat.oneTermRobinResourceConsistent (Examples.RobinHeat.oneTermParameters 3) := rfl

-- Cycle 3: layout signal qubit fix (main.tex:1102) and OneTermRobinTheoremData tests

-- Signal qubits = clog2 n + clog2 G_f + clog2 kappa + 4 for n=3, G_f=1, kappa=7
-- clog2 3 = 2, clog2 1 = 0, clog2 7 = 3 → 2 + 0 + 3 + 4 = 9
example :
    (GHL2025.oneTermRobinLayout { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }).signalQubits = 9 := rfl

-- OneTermRobinTheoremData signal qubits match the layout
example (p : GHL2025.OneTermRobinParameters) :
    (GHL2025.defaultOneTermRobinTheoremData p).signalQubits =
      (GHL2025.oneTermRobinLayout p).signalQubits := rfl

-- OneTermRobinTheoremData pure ancillas = 2n
example (p : GHL2025.OneTermRobinParameters) :
    (GHL2025.defaultOneTermRobinTheoremData p).pureAncillas = 2 * p.n := rfl

-- OneTermRobinTheoremData error = 0
example (p : GHL2025.OneTermRobinParameters) :
    (GHL2025.defaultOneTermRobinTheoremData p).error = Coeff.rat 0 := rfl

-- OneTermRobinTheoremData obligations are all unproved (none proved := true)
example (p : GHL2025.OneTermRobinParameters) :
    (GHL2025.defaultOneTermRobinTheoremData p).obligations.circuitUnitary.proved = false := rfl

-- Cycle 2 middle: precise resource formula and deviatingIndices tests

-- deviatingIndices: K1 + gridSize - K2 for the fourth-order stencil (K1=2, K2=gridSize(n)-3)
-- n=3: gridSize 3 = 8, K2 = 5, deviating = 2 + 8 - 5 = 5
example : GHL2025.deviatingIndices 2 5 8 = 5 := rfl

-- deviatingIndices with K1=2, K2=gridSize(4)-3=13, gridSize(4)=16 → 2+16-13 = 5
example : GHL2025.deviatingIndices 2 13 16 = 5 := rfl

-- oneTermRobinPreciseResourceExpr has the boundary deviation term in the gate count
example : GHL2025.oneTermRobinPreciseResourceExpr.pureAncilla =
    GHL2025.oneTermRobinResourceExpr.pureAncilla := rfl

-- indicatorResource from Resources.lean (U_indic): n=4, O(n) gates, n-1 pure ancillas
example : (indicatorResource 4).oneQubit = 16 * 4 + 34 := rfl

-- indicatorResource pure ancilla = n - 1
example : (indicatorResource 4).pureAncilla = 3 := rfl

-- Cycle 2 lower: indicator oracle classical spec and register partition tests

-- isBulkRow: boundary rows (i < K1) return false
example : GHL2025.isBulkRow 2 5 0 = false := rfl

-- isBulkRow: boundary rows (i > K2) return false
example : GHL2025.isBulkRow 2 5 6 = false := rfl

-- isBulkRow: bulk rows (K1 ≤ i ≤ K2) return true
example : GHL2025.isBulkRow 2 5 2 = true := rfl
example : GHL2025.isBulkRow 2 5 5 = true := rfl

-- isBulkRow: exactly at K1-1 is boundary, at K1 is bulk
example : GHL2025.isBulkRow 2 5 1 = false := rfl

-- RobinRegisterPartition fields for n=3, kappa=7, functionPieces=1
-- mfQubits = clog2(3) + clog2(1) + 3 = 2 + 0 + 3 = 5
example :
    (GHL2025.defaultRobinRegisterPartition
      { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }).mfQubits = 5 := rfl

-- sparseIndexQubits = clog2(7) = 3
example :
    (GHL2025.defaultRobinRegisterPartition
      { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }).sparseIndexQubits = 3 := rfl

-- odPureAncillaQubits = n - clog2(kappa) = 3 - 3 = 0
example :
    (GHL2025.defaultRobinRegisterPartition
      { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }).odPureAncillaQubits = 0 := rfl

-- totalPureAncillas = odPureAncillaQubits + 1 = 0 + 1 = 1 for n=3, kappa=7
example :
    (GHL2025.RobinRegisterPartition.totalPureAncillas
      (GHL2025.defaultRobinRegisterPartition
        { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 })) = 1 := rfl

-- For n=4, kappa=3: odPureAncillaQubits = 4 - clog2(3) = 4 - 2 = 2
example :
    (GHL2025.defaultRobinRegisterPartition
      { n := 4, kappa := 3, functionPieces := 1, polynomialDegreeCost := 1 }).odPureAncillaQubits = 2 := rfl

-- totalPureAncillas = 2 + 1 = 3 for n=4, kappa=3
example :
    (GHL2025.RobinRegisterPartition.totalPureAncillas
      (GHL2025.defaultRobinRegisterPartition
        { n := 4, kappa := 3, functionPieces := 1, polynomialDegreeCost := 1 })) = 3 := rfl

-- Cycle 3 lower: isBoundaryRow and RobinWavefunctionDecomposition tests

-- isBoundaryRow: j < K1 returns true (main.tex:1113)
example : GHL2025.isBoundaryRow 2 5 8 0 = true := rfl

-- isBoundaryRow: K2 < j returns true (main.tex:1113)
example : GHL2025.isBoundaryRow 2 5 8 6 = true := rfl

-- isBoundaryRow: bulk row returns false (main.tex:1113)
example : GHL2025.isBoundaryRow 2 5 8 3 = false := rfl

-- isBoundaryRow complements isBulkRow: concrete boundary case (main.tex:1113, 1035-1038)
example : GHL2025.isBoundaryRow 2 5 8 0 = !GHL2025.isBulkRow 2 5 0 := rfl

-- isBoundaryRow complements isBulkRow: concrete bulk case (main.tex:1113, 1035-1038)
example : GHL2025.isBoundaryRow 2 5 8 4 = !GHL2025.isBulkRow 2 5 4 := rfl

-- Gamma1 kappa field access (main.tex:1113)
example :
    (GHL2025.defaultRobinWavefunctionDecomposition
      { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }).gamma1.kappa = 7 := rfl

-- Gamma1 boundary normalizer = N_D * sqrt(kappa), evaluates to 3*7 = 21 (main.tex:1113)
example :
    Coeff.evalWith (fun s => if s = "N_D" then 3 else (7 : Rat))
      (GHL2025.defaultRobinWavefunctionDecomposition
        { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }).gamma1.boundaryNormalizer
      = (21 : Rat) := by native_decide

-- Gamma1 bulk normalizer = sqrt(kappa) only — no N_D factor (main.tex:1113)
-- The bulk term in gamma_1 omits N_D because the sparse-amplitude oracle has not yet acted.
example :
    Coeff.evalWith (fun _ => (7 : Rat))
      (GHL2025.defaultRobinWavefunctionDecomposition
        { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }).gamma1.bulkNormalizer
      = (7 : Rat) := by native_decide

-- Gamma1 boundary and bulk normalizers differ: boundary has N_D factor, bulk does not (main.tex:1113)
example :
    Coeff.evalWith (fun s => if s = "N_D" then 3 else (7 : Rat))
      (GHL2025.defaultRobinWavefunctionDecomposition
        { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }).gamma1.boundaryNormalizer
      = 3 * Coeff.evalWith (fun _ => (7 : Rat))
          (GHL2025.defaultRobinWavefunctionDecomposition
            { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }).gamma1.bulkNormalizer := by
  native_decide

-- Gamma3 normalizer = N_D * N_f * kappa, evaluates to 3*2*7 = 42 (main.tex:1117)
example :
    Coeff.evalWith (fun s => if s = "N_D" then 3 else if s = "N_f" then 2 else (7 : Rat))
      (GHL2025.defaultRobinWavefunctionDecomposition
        { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }).gamma3.normalizer
      = (42 : Rat) := by native_decide

-- Gamma3 pureAncillaQubits = n - clog2(kappa) + 1 = 3 - 3 + 1 = 1 for n=3, kappa=7 (main.tex:1117, 1149)
example :
    (GHL2025.defaultRobinWavefunctionDecomposition
      { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }).gamma3.pureAncillaQubits = 1 := rfl

-- Gamma2 hasOrthogonalRemainder = true (main.tex:1115)
example :
    (GHL2025.defaultRobinWavefunctionDecomposition
      { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }).gamma2.hasOrthogonalRemainder = true := rfl

-- Shared params match gamma fields (figure:1_term_ROBIN)
example (p : GHL2025.OneTermRobinParameters) :
    (GHL2025.defaultRobinWavefunctionDecomposition p).kappa = p.kappa := rfl

-- Cycle 4 lower: RobinBoundaryRotationAngle and RobinBoundaryRotationSet tests
-- (Eq. angles for Ry, main.tex:1081-1083)

-- A boundary rotation angle compiles with symbolic Coeff entries
example : GHL2025.RobinBoundaryRotationAngle := {
  row := 0
  sparseIndex := 0
  matrixEntry := Coeff.rat ((-5 : Rat) / 2)
  arccosArgument := Coeff.symbol "arccos_arg_0_0"
}

-- expectedCount for K1=2, K2=5, gridSize=8, kappa=5: 5 * (2 + 8 - 5) = 5 * 5 = 25
example :
    (GHL2025.RobinBoundaryRotationSet.expectedCount
      { K1 := 2, K2 := 5, gridSize := 8, kappa := 5,
        normalizerND := Coeff.symbol "N_D",
        angles := [] }) = 25 := rfl

-- expectedCount for the default fourth-order stencil: kappa=5, K1=2, K2=gridSize(n)-3
-- n=3: gridSize=8, K2=5, deviating=5, expected=5*5=25
example :
    (GHL2025.RobinBoundaryRotationSet.expectedCount
      { K1 := 2, K2 := gridSize 3 - 3, gridSize := gridSize 3, kappa := 5,
        normalizerND := Coeff.symbol "N_D",
        angles := [] }) = 25 := rfl

-- Cycle QBE-AUTO-002: Circuit matrix semantics backend tests

-- GHL2025.oneTermRobinTotalQubits: total qubits = register partition total
-- n=3, kappa=7: mfQubits(5) + indicator(1) + sparse(3) + odPure(0) + system(3) + ancilla(1) = 13
example :
    GHL2025.oneTermRobinTotalQubits { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 } = 13 := rfl

-- GHL2025.oneTermRobinTotalQubits for n=1: mfQubits(3) + indicator(1) + sparse(0) + odPure(1) + system(1) + ancilla(1) = 7
example :
    GHL2025.oneTermRobinTotalQubits { n := 1, kappa := 1, functionPieces := 1, polynomialDegreeCost := 1 } = 7 := rfl

-- robinIndicatorBitPosition: = 1 + n + (n - clog2 κ) + clog2 κ = 1 + 2n
-- For n=3, κ=7: 1 + 2*3 = 7
example :
    GHL2025.robinIndicatorBitPosition { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 } = 7 := rfl

-- For n=1, κ=1: 1 + 2*1 = 3
example :
    GHL2025.robinIndicatorBitPosition { n := 1, kappa := 1, functionPieces := 1, polynomialDegreeCost := 1 } = 3 := rfl

-- effectiveRobinSignalQubits = totalQubits - clog2(gridSize n) = 13 - 3 = 10 for n=3
example :
    GHL2025.effectiveRobinSignalQubits { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 } = 10 := rfl

-- effectiveRobinSignalQubits for n=1: 7 - 1 = 6
example :
    GHL2025.effectiveRobinSignalQubits { n := 1, kappa := 1, functionPieces := 1, polynomialDegreeCost := 1 } = 6 := rfl

-- U_indic matrix: boundary row (systemVal=0, < K1=2) → identity
-- Compound index j=0: systemVal = (0 >>> 1) &&& 7 = 0, isBulk = false, expectedImage = 0
-- M(0, 0) = 1 (identity on boundary)
example :
    let p : GHL2025.OneTermRobinParameters := { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.indicatorOracleMatrix p)
      ⟨0, by native_decide⟩ ⟨0, by native_decide⟩ = Coeff.rat 1 := by
  native_decide

-- U_indic matrix: bulk row (systemVal=2, K1=2 ≤ 2 ≤ K2=5) → flips indicator
-- Compound index j=4: systemVal = (4 >>> 1) &&& 7 = 2, isBulk = true
-- expectedImage = 4 XOR (1 <<< 7) = 4 XOR 128 = 132
-- M(132, 4) = 1
example :
    let p : GHL2025.OneTermRobinParameters := { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.indicatorOracleMatrix p)
      ⟨132, by native_decide⟩ ⟨4, by native_decide⟩ = Coeff.rat 1 := by
  native_decide

-- U_indic matrix: M(0, 4) = 0 (row 0 is not the image of j=4)
example :
    let p : GHL2025.OneTermRobinParameters := { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.indicatorOracleMatrix p)
      ⟨0, by native_decide⟩ ⟨4, by native_decide⟩ = Coeff.rat 0 := by
  native_decide

-- U_indic matrix: M(4, 132) = 0 (j=132 has systemVal=66&&&7=2 bulk, maps to 132 XOR 128 = 4, not 4 → 132)
-- Actually j=132: systemVal = (132 >>> 1) &&& 7 = 66 &&& 7 = 2, isBulk=true, expectedImage = 132 XOR 128 = 4
-- M(4, 132) = 1 (inverse mapping)
example :
    let p : GHL2025.OneTermRobinParameters := { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.indicatorOracleMatrix p)
      ⟨4, by native_decide⟩ ⟨132, by native_decide⟩ = Coeff.rat 1 := by
  native_decide

-- Dim compat: qubitDim total = qubitDim effectiveSignal * gridSize n for n=3
-- 2^13 = 2^10 * 8 = 8192
example : qubitDim (GHL2025.oneTermRobinTotalQubits (Examples.RobinHeat.oneTermParameters 3)) =
    qubitDim (GHL2025.effectiveRobinSignalQubits (Examples.RobinHeat.oneTermParameters 3)) *
      gridSize 3 := by native_decide

-- Dim compat for n=1: 2^7 = 2^6 * 2 = 128
example : qubitDim (GHL2025.oneTermRobinTotalQubits (Examples.RobinHeat.oneTermParameters 1)) =
    qubitDim (GHL2025.effectiveRobinSignalQubits (Examples.RobinHeat.oneTermParameters 1)) *
      gridSize 1 := by native_decide

-- Gate matrix placeholders: length = 7 (one per circuit gate)
example (p : GHL2025.OneTermRobinParameters) :
    (GHL2025.oneTermRobinGateMatrixPlaceholders p).length = 7 := rfl

-- Gate matrix placeholders: each gate matches the circuit label
example (p : GHL2025.OneTermRobinParameters) :
    gateMatricesMatchCircuit GHL2025.oneTermRobinCircuit (GHL2025.oneTermRobinGateMatrixPlaceholders p) = true :=
  GHL2025.oneTermRobinPlaceholdersMatch p

-- U_indic unitarity has been promoted by the cycle-12 permutation proof.
example (p : GHL2025.OneTermRobinParameters) :
    (GHL2025.oneTermRobinGate_U_indic p).unitary.proved = true := rfl

-- Gate matrix placeholders: O_D^BS has proved = false
example (p : GHL2025.OneTermRobinParameters) :
    (GHL2025.oneTermRobinGate_O_D_BS p).unitary.proved = false := rfl

-- SWAP unitarity remains a proof-DAG obligation.
example (p : GHL2025.OneTermRobinParameters) :
    (GHL2025.oneTermRobinGate_SWAP p).unitary.proved = false := rfl

-- oneTermRobinCircuitSemantics: gate list matches the circuit
example (n : Nat) :
    (Examples.RobinHeat.oneTermRobinCircuitSemantics n).gateListMatches =
      GHL2025.oneTermRobinPlaceholdersMatch (Examples.RobinHeat.oneTermParameters n) := rfl

-- oneTermRobinCircuitSemantics: circuit is oneTermRobinCircuit
example (n : Nat) :
    (Examples.RobinHeat.oneTermRobinCircuitSemantics n).circuit = GHL2025.oneTermRobinCircuit := rfl

-- oneTermRobinBlockExtractionTarget: target matrix is robinDerivativeMatrix
example (n : Nat) :
    (Examples.RobinHeat.oneTermRobinBlockExtractionTarget n).targetMatrix =
      Examples.RobinHeat.robinDerivativeMatrix n := rfl

-- oneTermRobinBlockExtractionTarget: normalizer is the symbolic N_D * N_f * kappa
example (n : Nat) :
    (Examples.RobinHeat.oneTermRobinBlockExtractionTarget n).normalizer =
      GHL2025.oneTermRobinNormalizer := rfl

-- oneTermRobinBlockExtractionTarget: blockCorrect obligation is unproved
example (n : Nat) :
    (Examples.RobinHeat.oneTermRobinBlockExtractionTarget n).blockCorrect.proved = false := rfl

-- oneTermRobinBlockExtractionTarget: blockProjection obligation is unproved
example (n : Nat) :
    (Examples.RobinHeat.oneTermRobinBlockExtractionTarget n).blockProjection.proved = false := rfl

-- oneTermRobinBlockExtractionTarget: signalIndex = 0
example (n : Nat) :
    (Examples.RobinHeat.oneTermRobinBlockExtractionTarget n).signalIndex.val = 0 := rfl

-- signalSystemBlockProjection: on a 4x4 identity block with signalDim=2, rows=2, cols=2, index=0
-- The identity matrix of size 4: M(i,j) = if i = j then 1 else 0
-- Block at index 0: M(0,0), M(0,1), M(1,0), M(1,1) → diagonal block is identity 2x2
example :
    signalSystemBlockProjection 2 2 2
      (fun i j : Fin 4 => if (i : Nat) = (j : Nat) then Coeff.rat 1 else Coeff.rat 0)
      ⟨0, by decide⟩
      ⟨0, by decide⟩ ⟨0, by decide⟩ =
    Coeff.rat 1 := by native_decide

-- signalSystemBlockProjection: diagonal block (0,0) → off-diagonal entry is 0
example :
    signalSystemBlockProjection 2 2 2
      (fun i j : Fin 4 => if (i : Nat) = (j : Nat) then Coeff.rat 1 else Coeff.rat 0)
      ⟨0, by decide⟩
      ⟨0, by decide⟩ ⟨1, by decide⟩ =
    Coeff.rat 0 := by native_decide

-- signalSystemBlockProjection: block at index=1, diagonal entry (0,0) → M(2,2) = 1
example :
    signalSystemBlockProjection 2 2 2
      (fun i j : Fin 4 => if (i : Nat) = (j : Nat) then Coeff.rat 1 else Coeff.rat 0)
      ⟨1, by decide⟩
      ⟨0, by decide⟩ ⟨0, by decide⟩ =
    Coeff.rat 1 := by native_decide

-- totalCircuitQubits: system=3, signal=9 → 12
example : totalCircuitQubits 3 9 = 12 := rfl

-- CircuitBlockEncodingClaim tests

-- Dimension compatibility for n=3: 2^13 = 2^10 * 2^3 (register partition total = 13)
example : qubitDim (GHL2025.oneTermRobinTotalQubits (Examples.RobinHeat.oneTermParameters 3)) =
    qubitDim (GHL2025.effectiveRobinSignalQubits (Examples.RobinHeat.oneTermParameters 3)) *
      gridSize 3 := by native_decide

-- Dimension compatibility for n=4: total=14, effectiveSignal=10, gridSize=16
-- 2^14 = 2^10 * 2^4 = 16384
example : qubitDim (GHL2025.oneTermRobinTotalQubits (Examples.RobinHeat.oneTermParameters 4)) =
    qubitDim (GHL2025.effectiveRobinSignalQubits (Examples.RobinHeat.oneTermParameters 4)) *
      gridSize 4 := by native_decide

-- CircuitBlockEncodingClaim: circuit matches oneTermRobinCircuit for n=3
example :
    (Examples.RobinHeat.oneTermRobinCircuitBlockClaim 3 (by native_decide)).semantics.circuit =
      GHL2025.oneTermRobinCircuit := rfl

-- Default CircuitBlockEncodingClaim no longer needs a per-instance native_decide dimension proof
example :
    (Examples.RobinHeat.defaultOneTermRobinCircuitBlockClaim 3).semantics.circuit =
      GHL2025.oneTermRobinCircuit := rfl

-- CircuitBlockEncodingClaim: target matrix matches robinDerivativeMatrix for n=3
example :
    (Examples.RobinHeat.oneTermRobinCircuitBlockClaim 3 (by native_decide)).target.targetMatrix =
      Examples.RobinHeat.robinDerivativeMatrix 3 := rfl

-- CircuitBlockEncodingClaim: blockCorrect is unproved
example :
    (Examples.RobinHeat.oneTermRobinCircuitBlockClaim 3 (by native_decide)).blockCorrect.proved = false := rfl

example (n : Nat) :
    (Examples.RobinHeat.defaultOneTermRobinCircuitBlockClaim n).blockCorrect.proved = false := rfl

-- CircuitBlockEncodingClaim: normalizer matches oneTermRobinNormalizer for n=3
example :
    (Examples.RobinHeat.oneTermRobinCircuitBlockClaim 3 (by native_decide)).target.normalizer =
      GHL2025.oneTermRobinNormalizer := rfl

-- Cycle 1 edge tests: dimension compatibility, block projection, field roundtrips

-- Edge test 1: n=1 dimension compatibility (total=7, effectiveSignal=6, gridSize 1 = 2)
example : qubitDim (GHL2025.oneTermRobinTotalQubits (Examples.RobinHeat.oneTermParameters 1)) =
    qubitDim (GHL2025.effectiveRobinSignalQubits (Examples.RobinHeat.oneTermParameters 1)) *
      gridSize 1 := by native_decide

-- Edge test 2: oneTermRobinCircuitDimCompat for n=1 feeds into CircuitBlockEncodingClaim
example : Examples.RobinHeat.oneTermRobinCircuitDimCompat 1 ▸
    (Examples.RobinHeat.oneTermRobinCircuitBlockClaim 1 (Examples.RobinHeat.oneTermRobinCircuitDimCompat 1)).dimCompat = Examples.RobinHeat.oneTermRobinCircuitDimCompat 1 := rfl

-- Edge test 3: signalSystemBlockProjection on a 1x1 system (trivial block = the single entry)
example :
    signalSystemBlockProjection 2 1 1
      (fun _ _ => Coeff.rat 42)
      ⟨0, by decide⟩
      ⟨0, by decide⟩ ⟨0, by decide⟩ =
    Coeff.rat 42 := by native_decide

-- Edge test 4: CircuitBlockEncodingClaim field-access roundtrip for n=2
-- target matrix at bulk diagonal (2,2) for n=2 matches robinDerivativeMatrix
example :
    (Examples.RobinHeat.oneTermRobinCircuitBlockClaim 2 (by native_decide)).target.targetMatrix
      ⟨2, by native_decide⟩ ⟨2, by native_decide⟩ =
    (Examples.RobinHeat.robinDerivativeMatrix 2)
      ⟨2, by native_decide⟩ ⟨2, by native_decide⟩ := rfl

-- Edge test 5: defaultOneTermRobinCircuitBlockClaim for n=2 preserves circuit identity
example :
    (Examples.RobinHeat.defaultOneTermRobinCircuitBlockClaim 2).semantics.circuit =
      GHL2025.oneTermRobinCircuit := rfl

-- Cycle 3: SWAP honest permutation matrix tests

-- SWAP test 1: block swap for n=3
-- Compound index j=86: systemVal = (86>>>1)&&&7 = 3, O_D^BS val = (86>>>4)&&&7 = 5
-- Swapped: system=5, O_D^BS=3, swapped index = 58
-- M(58, 86) = 1
example :
    let p : GHL2025.OneTermRobinParameters := { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.swapOracleMatrix p)
      ⟨58, by native_decide⟩ ⟨86, by native_decide⟩ = Coeff.rat 1 := by
  native_decide

-- SWAP test 1b: M(86, 58) = 1 (reverse direction)
example :
    let p : GHL2025.OneTermRobinParameters := { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.swapOracleMatrix p)
      ⟨86, by native_decide⟩ ⟨58, by native_decide⟩ = Coeff.rat 1 := by
  native_decide

-- SWAP test 2: second swap pair confirms self-inverse (together with tests 1 and 1b)
-- j=2: block1 = (2>>>1)&&&7 = 1, block2 = (2>>>4)&&&7 = 0, diff=1
-- swapped = 2 XOR 2 XOR 16 = 16. M(16, 2) = 1
example :
    let p : GHL2025.OneTermRobinParameters := { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.swapOracleMatrix p)
      ⟨16, by native_decide⟩ ⟨2, by native_decide⟩ = Coeff.rat 1 := by
  native_decide

-- j=16: block1 = 0, block2 = 1, swapped = 2. M(2, 16) = 1 (round-trip confirmed)
example :
    let p : GHL2025.OneTermRobinParameters := { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.swapOracleMatrix p)
      ⟨2, by native_decide⟩ ⟨16, by native_decide⟩ = Coeff.rat 1 := by
  native_decide

-- SWAP test 3: equal blocks → identity (no swap)
-- j=54: systemVal = (54>>>1)&&&7 = 3, O_D^BS = (54>>>4)&&&7 = 3, diff=0
-- swapped = 54
example :
    let p : GHL2025.OneTermRobinParameters := { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.swapOracleMatrix p)
      ⟨54, by native_decide⟩ ⟨54, by native_decide⟩ = Coeff.rat 1 := by
  native_decide

-- SWAP test 4: preserves bits outside the two blocks
-- j=214 = 86 | (1<<<7): sets indicator bit (bit 7)
-- block1 = (214>>>1)&&&7 = 3, block2 = (214>>>4)&&&7 = 5
-- swapped = 214 XOR 12 XOR 96 = 186
-- M(186, 214) = 1 and indicator bit (bit 7) is preserved in 186
example :
    let p : GHL2025.OneTermRobinParameters := { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.swapOracleMatrix p)
      ⟨186, by native_decide⟩ ⟨214, by native_decide⟩ = Coeff.rat 1 := by
  native_decide

-- Verify indicator bit is preserved: bit 7 of 186 = 1
example : (186 >>> 7) &&& 1 = 1 := by native_decide

-- Verify ancilla bit (bit 0) is preserved: ancilla=0 for j=214
example : 214 &&& 1 = 0 := by native_decide
example : 186 &&& 1 = 0 := by native_decide

-- SWAP gate matrix uses an honest matrix; unitarity remains pending.
example :
    let p : GHL2025.OneTermRobinParameters := { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.oneTermRobinGate_SWAP p).unitary.proved = false := rfl

-- SWAP placeholder match still holds with honest matrix
example (p : GHL2025.OneTermRobinParameters) :
    gateMatricesMatchCircuit GHL2025.oneTermRobinCircuit (GHL2025.oneTermRobinGateMatrixPlaceholders p) = true :=
  GHL2025.oneTermRobinPlaceholdersMatch p

-- Cycle 4: O_D^BS sparse-access matrix tests (banded sparse access oracle)

-- O_D^BS test 1: bulk row i=4, s=0 → col=2
-- j=8: sysVal=(8>>>1)&&&7=4, sparseVal=(8>>>4)&&&7=0, col=4-2+0=2
-- expectedImage = 8 - 8 + 4 = 4. M(4, 8) = 1
example :
    let p : GHL2025.OneTermRobinParameters := { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.bandedSparseAccessMatrix p)
      ⟨4, by native_decide⟩ ⟨8, by native_decide⟩ = Coeff.rat 1 := by
  native_decide

-- O_D^BS test 2: bulk row i=4, s=4 → col=6
-- j=72: sysVal=4, sparseVal=4, col=4-2+4=6
-- expectedImage = 72 - 8 + 12 = 76. M(76, 72) = 1
example :
    let p : GHL2025.OneTermRobinParameters := { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.bandedSparseAccessMatrix p)
      ⟨76, by native_decide⟩ ⟨72, by native_decide⟩ = Coeff.rat 1 := by
  native_decide

-- O_D^BS test 3: bulk row i=3, s=2 → col=3 (diagonal, identity)
-- j=38: sysVal=3, sparseVal=2, col=3-2+2=3
-- expectedImage = 38 - 6 + 6 = 38. M(38, 38) = 1
example :
    let p : GHL2025.OneTermRobinParameters := { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.bandedSparseAccessMatrix p)
      ⟨38, by native_decide⟩ ⟨38, by native_decide⟩ = Coeff.rat 1 := by
  native_decide

-- O_D^BS test 4: boundary row 0, s=0 → col=0 (identity)
-- j=0: M(0, 0) = 1
example :
    let p : GHL2025.OneTermRobinParameters := { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.bandedSparseAccessMatrix p)
      ⟨0, by native_decide⟩ ⟨0, by native_decide⟩ = Coeff.rat 1 := by
  native_decide

-- O_D^BS test 5: boundary row 0, s=5 → unused (3 entries), col=0 (identity)
-- j=80: sysVal=0, sparseVal=5, col=0 (identity). expectedImage=80. M(80, 80) = 1
example :
    let p : GHL2025.OneTermRobinParameters := { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.bandedSparseAccessMatrix p)
      ⟨80, by native_decide⟩ ⟨80, by native_decide⟩ = Coeff.rat 1 := by
  native_decide

-- O_D^BS test 6: right boundary i=7, s=0 → col=5
-- j=14: sysVal=7, sparseVal=0, col=8-3+0=5
-- expectedImage = 14 - 14 + 10 = 10. M(10, 14) = 1
example :
    let p : GHL2025.OneTermRobinParameters := { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.bandedSparseAccessMatrix p)
      ⟨10, by native_decide⟩ ⟨14, by native_decide⟩ = Coeff.rat 1 := by
  native_decide

-- O_D^BS dagger test 7: transpose of test 1
-- Forward: M(4, 8) = 1. Dagger: M_dag(8, 4) = 1
example :
    let p : GHL2025.OneTermRobinParameters := { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.bandedSparseAccessDaggerMatrix p)
      ⟨8, by native_decide⟩ ⟨4, by native_decide⟩ = Coeff.rat 1 := by
  native_decide

-- O_D^BS gate: unitary.proved = false
example (p : GHL2025.OneTermRobinParameters) :
    (GHL2025.oneTermRobinGate_O_D_BS p).unitary.proved = false := rfl

-- O_D^BS dagger gate: unitary.proved = false
example (p : GHL2025.OneTermRobinParameters) :
    (GHL2025.oneTermRobinGate_O_D_BS_dagger p).unitary.proved = false := rfl

-- O_D^BS placeholder match still holds with honest matrices
example (p : GHL2025.OneTermRobinParameters) :
    gateMatricesMatchCircuit GHL2025.oneTermRobinCircuit (GHL2025.oneTermRobinGateMatrixPlaceholders p) = true :=
  GHL2025.oneTermRobinPlaceholdersMatch p

-- Cycle 5: robinSparseAmplitudeValue tests (sparse amplitude data layer)
-- main.tex:822-849, 1081-1083, 1113-1117

-- Bulk row i=2, s=2 (diagonal): amplitude = -5/2
example : GHL2025.robinSparseAmplitudeValue 3 2 2 = Coeff.rat ((-5 : Rat) / 2) := by native_decide

-- Bulk row i=2, s=0 (off-diagonal at offset -2): amplitude = -1/12
example : GHL2025.robinSparseAmplitudeValue 3 0 2 = Coeff.rat ((-1 : Rat) / 12) := by native_decide

-- Bulk row i=3, s=1 (off-diagonal at offset -1): amplitude = 4/3
example : GHL2025.robinSparseAmplitudeValue 3 1 3 = Coeff.rat ((4 : Rat) / 3) := by native_decide

-- Left boundary row 0, s=0: amplitude = -5/2 + 7/3 * A1*dx
example : GHL2025.robinSparseAmplitudeValue 3 0 0 =
    Coeff.add (Coeff.rat ((-5 : Rat) / 2))
      (Coeff.mul (Coeff.rat ((7 : Rat) / 3)) (Coeff.symbol "A1*dx")) := by native_decide

-- Left boundary row 0, s=1: amplitude = 8/3
example : GHL2025.robinSparseAmplitudeValue 3 1 0 = Coeff.rat ((8 : Rat) / 3) := by native_decide

-- Left boundary row 1, s=0: amplitude = 4/3 - 1/6 * A1*dx
example : GHL2025.robinSparseAmplitudeValue 3 0 1 =
    Coeff.add (Coeff.rat ((4 : Rat) / 3))
      (Coeff.neg (Coeff.mul (Coeff.rat ((1 : Rat) / 6)) (Coeff.symbol "A1*dx"))) := by native_decide

-- Left boundary row 1, s=1: amplitude = -31/12
example : GHL2025.robinSparseAmplitudeValue 3 1 1 = Coeff.rat ((-31 : Rat) / 12) := by native_decide

-- Right boundary row 6 (N-2), s=3: amplitude = 4/3 + 1/6 * B1*dx
example : GHL2025.robinSparseAmplitudeValue 3 3 6 =
    Coeff.add (Coeff.rat ((4 : Rat) / 3))
      (Coeff.mul (Coeff.rat ((1 : Rat) / 6)) (Coeff.symbol "B1*dx")) := by native_decide

-- Right boundary row 7 (N-1), s=2: amplitude = -5/2 - 7/3 * B1*dx
example : GHL2025.robinSparseAmplitudeValue 3 2 7 =
    Coeff.add (Coeff.rat ((-5 : Rat) / 2))
      (Coeff.neg (Coeff.mul (Coeff.rat ((7 : Rat) / 3)) (Coeff.symbol "B1*dx"))) := by native_decide

-- Unused sparse index: bulk row i=2, s=5 (only 5 entries) → Coeff.rat 0
example : GHL2025.robinSparseAmplitudeValue 3 5 2 = Coeff.rat 0 := by native_decide

-- Unused sparse index: boundary row 0, s=3 (only 3 entries) → Coeff.rat 0
example : GHL2025.robinSparseAmplitudeValue 3 3 0 = Coeff.rat 0 := by native_decide

-- Coherence: amplitude at (j, s) equals matrix entry at (j, robinSparseColumnMap n s j)
-- Bulk row i=2, s=2, col=robinSparseColumnMap 3 2 2 = 2
example :
    GHL2025.robinSparseAmplitudeValue 3 2 2 =
    (Examples.RobinHeat.robinDerivativeMatrix 3)
      ⟨2, by native_decide⟩
      ⟨GHL2025.robinSparseColumnMap 3 2 2, by native_decide⟩ := by native_decide

-- Coherence: left boundary row 0, s=0, col=robinSparseColumnMap 3 0 0 = 0
example :
    GHL2025.robinSparseAmplitudeValue 3 0 0 =
    (Examples.RobinHeat.robinDerivativeMatrix 3)
      ⟨0, by native_decide⟩
      ⟨GHL2025.robinSparseColumnMap 3 0 0, by native_decide⟩ := by native_decide

-- Coherence: right boundary row 7, s=2, col=robinSparseColumnMap 3 2 7 = 7
example :
    GHL2025.robinSparseAmplitudeValue 3 2 7 =
    (Examples.RobinHeat.robinDerivativeMatrix 3)
      ⟨7, by native_decide⟩
      ⟨GHL2025.robinSparseColumnMap 3 2 7, by native_decide⟩ := by native_decide

-- Coherence: left boundary row 1, s=0, col=robinSparseColumnMap 3 0 1 = 0
example :
    GHL2025.robinSparseAmplitudeValue 3 0 1 =
    (Examples.RobinHeat.robinDerivativeMatrix 3)
      ⟨1, by native_decide⟩
      ⟨GHL2025.robinSparseColumnMap 3 0 1, by native_decide⟩ := by native_decide

-- Coherence: right boundary row 6, s=3, col=robinSparseColumnMap 3 3 6 = 7
example :
    GHL2025.robinSparseAmplitudeValue 3 3 6 =
    (Examples.RobinHeat.robinDerivativeMatrix 3)
      ⟨6, by native_decide⟩
      ⟨GHL2025.robinSparseColumnMap 3 3 6, by native_decide⟩ := by native_decide

-- Cycle 6->9: O_f function oracle diagonal matrix tests (main.tex:870-910)
-- O_f now uses robinFunctionValue (symbolic f(x_j)) instead of derivative amplitude data.

-- O_f diagonal entry: sysVal=2, compound j=36
-- j=36: sysVal=(36>>>1)&7=2. Diagonal entry = robinFunctionValue 3 2 = Coeff.symbol "f_3_2"
example :
    let p : GHL2025.OneTermRobinParameters := { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.functionOracleMatrix p)
      ⟨36, by native_decide⟩ ⟨36, by native_decide⟩ =
    Coeff.symbol "f_3_2" := by
  native_decide

-- O_f diagonal entry: sysVal=0, compound j=0
-- j=0: sysVal=0. Diagonal entry = robinFunctionValue 3 0 = Coeff.symbol "f_3_0"
example :
    let p : GHL2025.OneTermRobinParameters := { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.functionOracleMatrix p)
      ⟨0, by native_decide⟩ ⟨0, by native_decide⟩ =
    Coeff.symbol "f_3_0" := by
  native_decide

-- O_f diagonal entry: sysVal=2, compound j=4
-- j=4: sysVal=(4>>>1)&7=2. Same sysVal as j=36, same function value symbol
example :
    let p : GHL2025.OneTermRobinParameters := { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.functionOracleMatrix p)
      ⟨4, by native_decide⟩ ⟨4, by native_decide⟩ =
    Coeff.symbol "f_3_2" := by
  native_decide

-- O_f off-diagonal entry: M(0, 1) = 0
example :
    let p : GHL2025.OneTermRobinParameters := { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.functionOracleMatrix p)
      ⟨0, by native_decide⟩ ⟨1, by native_decide⟩ =
    Coeff.rat 0 := by
  native_decide

-- O_f off-diagonal entry: M(36, 0) = 0
example :
    let p : GHL2025.OneTermRobinParameters := { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.functionOracleMatrix p)
      ⟨36, by native_decide⟩ ⟨0, by native_decide⟩ =
    Coeff.rat 0 := by
  native_decide

-- O_f diagonal entry: sysVal=6, compound j=60
-- j=60: sysVal=(60>>>1)&7=6. Diagonal entry = Coeff.symbol "f_3_6"
example :
    let p : GHL2025.OneTermRobinParameters := { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.functionOracleMatrix p)
      ⟨60, by native_decide⟩ ⟨60, by native_decide⟩ =
    Coeff.symbol "f_3_6" := by
  native_decide

-- O_f diagonal entry: sysVal=7, compound j=14
-- j=14: sysVal=(14>>>1)&7=7. Diagonal entry = Coeff.symbol "f_3_7"
example :
    let p : GHL2025.OneTermRobinParameters := { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.functionOracleMatrix p)
      ⟨14, by native_decide⟩ ⟨14, by native_decide⟩ =
    Coeff.symbol "f_3_7" := by
  native_decide

-- robinFunctionValue: different grid points produce different symbols
example : GHL2025.robinFunctionValue 3 0 = Coeff.symbol "f_3_0" := by native_decide
example : GHL2025.robinFunctionValue 3 2 = Coeff.symbol "f_3_2" := by native_decide
example : GHL2025.robinFunctionValue 3 7 = Coeff.symbol "f_3_7" := by native_decide

-- O_f gate: unitary.proved = false
example (p : GHL2025.OneTermRobinParameters) :
    (GHL2025.oneTermRobinGate_O_f p).unitary.proved = false := rfl

-- O_f placeholder match still holds with function value matrix
example (p : GHL2025.OneTermRobinParameters) :
    gateMatricesMatchCircuit GHL2025.oneTermRobinCircuit (GHL2025.oneTermRobinGateMatrixPlaceholders p) = true :=
  GHL2025.oneTermRobinPlaceholdersMatch p

-- ## Cycle 7: O_DT^S Diagonal Matrix Tests

-- O_DT^S boundary row (indicator=0): diagonal entry = Coeff.rat 1 (identity)
-- j=4: binary 0000000000100, bit 0=0 (anc), bits [1,4)=010 (sysVal=2),
-- bits [4,7)=000 (sparseVal=0), bit 7=0 (indicator=0 → boundary)
example :
    let p : GHL2025.OneTermRobinParameters := { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.sparseAmplitudeOracleDTMatrix p)
      ⟨4, by native_decide⟩ ⟨4, by native_decide⟩ =
    Coeff.rat 1 := by
  native_decide

-- O_DT^S bulk row (indicator=1), s=0, i=2: diagonal entry = -1/12
-- j=132: binary 0000010000100, sysVal=2, sparseVal=0, indicator=1
example :
    let p : GHL2025.OneTermRobinParameters := { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.sparseAmplitudeOracleDTMatrix p)
      ⟨132, by native_decide⟩ ⟨132, by native_decide⟩ =
    Coeff.rat ((-1 : Rat) / 12) := by
  native_decide

-- O_DT^S bulk row (indicator=1), s=2, i=2 (diagonal): diagonal entry = -5/2
-- j=164: bit 7=1 (ind), bits [4,7)=010 (sparse=2), bits [1,4)=010 (sys=2), bit 0=0
example :
    let p : GHL2025.OneTermRobinParameters := { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.sparseAmplitudeOracleDTMatrix p)
      ⟨164, by native_decide⟩ ⟨164, by native_decide⟩ =
    Coeff.rat ((-5 : Rat) / 2) := by
  native_decide

-- O_DT^S off-diagonal entry: M(132, 133) = 0
example :
    let p : GHL2025.OneTermRobinParameters := { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.sparseAmplitudeOracleDTMatrix p)
      ⟨132, by native_decide⟩ ⟨133, by native_decide⟩ =
    Coeff.rat 0 := by
  native_decide

-- O_DT^S bulk row with boundary amplitude data (indicator=1 but sysVal=0)
-- j=128: bit 7=1 (ind), sysVal=0, sparseVal=0 → robinSparseAmplitudeValue 3 0 0
-- = -5/2 + 7/3*A1*dx (left boundary row 0 coefficient, despite indicator=1)
example :
    let p : GHL2025.OneTermRobinParameters := { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.sparseAmplitudeOracleDTMatrix p)
      ⟨128, by native_decide⟩ ⟨128, by native_decide⟩ =
    Coeff.add (Coeff.rat ((-5 : Rat) / 2))
      (Coeff.mul (Coeff.rat ((7 : Rat) / 3)) (Coeff.symbol "A1*dx")) := by
  native_decide

-- O_DT^S gate: unitary.proved = false
example (p : GHL2025.OneTermRobinParameters) :
    (GHL2025.oneTermRobinGate_O_DT_S p).unitary.proved = false := rfl

-- O_DT^S placeholder match still holds with honest diagonal matrix
example (p : GHL2025.OneTermRobinParameters) :
    gateMatricesMatchCircuit GHL2025.oneTermRobinCircuit (GHL2025.oneTermRobinGateMatrixPlaceholders p) = true :=
  GHL2025.oneTermRobinPlaceholdersMatch p

-- ## Cycle 8: Ry_boundary Controlled Rotation Matrix Tests
-- main.tex:1115-1120, Eq. angles for Ry

-- Ry_boundary bulk row (indicator=1): identity
-- j=132: bit 7=1 (indicator=1), bulk row → identity
example :
    let p : GHL2025.OneTermRobinParameters := { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.boundaryRotationMatrix p)
      ⟨132, by native_decide⟩ ⟨132, by native_decide⟩ =
    Coeff.rat 1 := by
  native_decide

-- Ry_boundary bulk row: off-diagonal is zero
example :
    let p : GHL2025.OneTermRobinParameters := { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.boundaryRotationMatrix p)
      ⟨133, by native_decide⟩ ⟨132, by native_decide⟩ =
    Coeff.rat 0 := by
  native_decide

-- Ry_boundary boundary row (indicator=0), anc_j=0, anc_i=0: cos(θ/2)
-- j=0: sysVal=0, sparseVal=0, anc=0, indicator=0
example :
    let p : GHL2025.OneTermRobinParameters := { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.boundaryRotationMatrix p)
      ⟨0, by native_decide⟩ ⟨0, by native_decide⟩ =
    Coeff.symbol "boundary_cos_half_0_0" := by
  native_decide

-- Ry_boundary boundary row, anc_j=0, anc_i=1: sin(θ/2)
-- j=0, i=1: anc changes from 0→1, rest matches (i>>>1 = j>>>1 = 0)
example :
    let p : GHL2025.OneTermRobinParameters := { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.boundaryRotationMatrix p)
      ⟨1, by native_decide⟩ ⟨0, by native_decide⟩ =
    Coeff.symbol "boundary_sin_half_0_0" := by
  native_decide

-- Ry_boundary boundary row, anc_j=1, anc_i=0: -sin(θ/2)
-- j=1, i=0: anc changes from 1→0, rest matches
example :
    let p : GHL2025.OneTermRobinParameters := { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.boundaryRotationMatrix p)
      ⟨0, by native_decide⟩ ⟨1, by native_decide⟩ =
    Coeff.neg (Coeff.symbol "boundary_sin_half_0_0") := by
  native_decide

-- Ry_boundary boundary row, anc_j=1, anc_i=1: cos(θ/2)
example :
    let p : GHL2025.OneTermRobinParameters := { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.boundaryRotationMatrix p)
      ⟨1, by native_decide⟩ ⟨1, by native_decide⟩ =
    Coeff.symbol "boundary_cos_half_0_0" := by
  native_decide

-- Ry_boundary: different boundary row sysVal produces different symbol
-- j=2: indicator=(2>>>7)&1=0, sysVal=(2>>>1)&7=1, sparseVal=(2>>>4)&7=0
example :
    let p : GHL2025.OneTermRobinParameters := { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.boundaryRotationMatrix p)
      ⟨2, by native_decide⟩ ⟨2, by native_decide⟩ =
    Coeff.symbol "boundary_cos_half_1_0" := by
  native_decide

-- Ry_boundary: different sparseVal produces different symbol
-- j=16: indicator=0, sysVal=(16>>>1)&7=0, sparseVal=(16>>>4)&7=1
example :
    let p : GHL2025.OneTermRobinParameters := { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.boundaryRotationMatrix p)
      ⟨16, by native_decide⟩ ⟨16, by native_decide⟩ =
    Coeff.symbol "boundary_cos_half_0_1" := by
  native_decide

-- Ry_boundary: off-diagonal between different boundary rows (different rest) = 0
-- j=2, i=0: i>>>1=0 ≠ j>>>1=1 → 0
example :
    let p : GHL2025.OneTermRobinParameters := { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.boundaryRotationMatrix p)
      ⟨0, by native_decide⟩ ⟨2, by native_decide⟩ =
    Coeff.rat 0 := by
  native_decide

-- Ry_boundary gate: unitary.proved = false
example (p : GHL2025.OneTermRobinParameters) :
    (GHL2025.oneTermRobinGate_Ry_boundary p).unitary.proved = false := rfl

-- Ry_boundary placeholder match still holds with honest matrix
example (p : GHL2025.OneTermRobinParameters) :
    gateMatricesMatchCircuit GHL2025.oneTermRobinCircuit (GHL2025.oneTermRobinGateMatrixPlaceholders p) = true :=
  GHL2025.oneTermRobinPlaceholdersMatch p

-- ## Cycle 3 (QBE-AUTO-002): Pipeline upgrade — real matrix products

-- unitaryMatrix is now derived from evalGateMatrices, not hardcoded zeros.
-- Keep this as a structural test: concrete entry-level evaluation of the n=3
-- 13-qubit product is too large for routine `lake build Tests`.
example (n : Nat) :
    (Examples.RobinHeat.oneTermRobinCircuitSemantics n).matrix =
      evalGateMatrices
        (GHL2025.oneTermRobinGateMatrixPlaceholders
          (Examples.RobinHeat.oneTermParameters n)) := rfl

-- The block extraction target uses the circuit product as its full-space matrix.
example (n : Nat) :
    (Examples.RobinHeat.oneTermRobinBlockExtractionTarget n).unitaryMatrix =
      cast (by rw [Examples.RobinHeat.oneTermRobinCircuitDimCompat n])
        (Examples.RobinHeat.oneTermRobinCircuitSemantics n).matrix := rfl

-- blockMatrix is the signal-0 block projection of that circuit product.
example (n : Nat) :
    (Examples.RobinHeat.oneTermRobinBlockExtractionTarget n).blockMatrix =
      signalSystemBlockProjection
        (qubitDim (GHL2025.effectiveRobinSignalQubits (Examples.RobinHeat.oneTermParameters n)))
        (gridSize n)
        (gridSize n)
        (Examples.RobinHeat.oneTermRobinBlockExtractionTarget n).unitaryMatrix
        (Examples.RobinHeat.oneTermRobinBlockExtractionTarget n).signalIndex := rfl

-- Structural tests still pass: targetMatrix = robinDerivativeMatrix
example (n : Nat) :
    (Examples.RobinHeat.oneTermRobinBlockExtractionTarget n).targetMatrix =
      Examples.RobinHeat.robinDerivativeMatrix n := rfl

-- Structural tests: normalizer = oneTermRobinNormalizer
example (n : Nat) :
    (Examples.RobinHeat.oneTermRobinBlockExtractionTarget n).normalizer =
      GHL2025.oneTermRobinNormalizer := rfl

-- Structural tests: blockCorrect.proved = false
example (n : Nat) :
    (Examples.RobinHeat.oneTermRobinBlockExtractionTarget n).blockCorrect.proved = false := rfl

-- Structural tests: blockProjection.proved = false
example (n : Nat) :
    (Examples.RobinHeat.oneTermRobinBlockExtractionTarget n).blockProjection.proved = false := rfl

-- Structural tests: signalIndex = 0
example (n : Nat) :
    (Examples.RobinHeat.oneTermRobinBlockExtractionTarget n).signalIndex.val = 0 := rfl

-- Entry-level nonzero checks for the full product are tracked as future proof
-- obligations rather than compiled tests, because they force large symbolic
-- matrix multiplication at n=3.

-- Cycle 12: U_indic proof-DAG tests

example (p : GHL2025.OneTermRobinParameters) (j : Nat) :
    GHL2025.indicatorOracleImage p (GHL2025.indicatorOracleImage p j) = j :=
  GHL2025.indicatorOracleImage_self_inverse p j

example (p : GHL2025.OneTermRobinParameters) :
    (∀ (a b : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p))),
        (⟨GHL2025.indicatorOracleImage p a.val, GHL2025.indicatorOracleImage_lt p a.2⟩ :
          Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p))) =
        ⟨GHL2025.indicatorOracleImage p b.val, GHL2025.indicatorOracleImage_lt p b.2⟩ →
        a = b) ∧
      ∀ (y : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p))),
        ∃ (x : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p))),
          (⟨GHL2025.indicatorOracleImage p x.val, GHL2025.indicatorOracleImage_lt p x.2⟩ :
            Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p))) = y :=
  GHL2025.indicatorOracleImage_bijective p

example (p : GHL2025.OneTermRobinParameters) :
    (GHL2025.oneTermRobinGate_U_indic p).unitary.proved = true := rfl

-- Run 02 cycle 02 recovery: SWAP image tests remain concrete until the
-- proof-DAG bit-slice lemmas are factored into reusable general theorems.
example (p : GHL2025.OneTermRobinParameters) :
    (GHL2025.oneTermRobinGate_SWAP p).unitary.proved = false := rfl

-- O_D^BS noninjectivity witness: the current boundary sparse-column map
-- sends multiple boundary rows to the same column for the same sparse index.
-- This blocks the permutation-matrix proof route for O_D^BS and its dagger.
example : GHL2025.robinSparseColumnMap 3 0 0 = 0 := by native_decide
example : GHL2025.robinSparseColumnMap 3 0 1 = 0 := by native_decide
example : GHL2025.robinSparseColumnMap 3 0 2 = 0 := by native_decide

example :
    GHL2025.robinSparseColumnMap 3 0 0 =
      GHL2025.robinSparseColumnMap 3 0 1 := by native_decide

example :
    GHL2025.robinSparseColumnMap 3 0 1 =
      GHL2025.robinSparseColumnMap 3 0 2 := by native_decide

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

-- GHL2025.oneTermRobinTotalQubits: total qubits for concrete parameters
-- n=3: clog2 8 + (clog2 3 + clog2 1 + clog2 7 + 4) = 3 + (2+0+3+4) = 12
example :
    GHL2025.oneTermRobinTotalQubits { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 } = 12 := rfl

-- Gate matrix placeholders: length = 7 (one per circuit gate)
example (p : GHL2025.OneTermRobinParameters) :
    (GHL2025.oneTermRobinGateMatrixPlaceholders p).length = 7 := rfl

-- Gate matrix placeholders: each gate matches the circuit label
example (p : GHL2025.OneTermRobinParameters) :
    gateMatricesMatchCircuit GHL2025.oneTermRobinCircuit (GHL2025.oneTermRobinGateMatrixPlaceholders p) = true :=
  GHL2025.oneTermRobinPlaceholdersMatch p

-- Gate matrix placeholders: U_indic has proved = false
example (p : GHL2025.OneTermRobinParameters) :
    (GHL2025.oneTermRobinGate_U_indic p).unitary.proved = false := rfl

-- Gate matrix placeholders: O_D^BS has proved = false
example (p : GHL2025.OneTermRobinParameters) :
    (GHL2025.oneTermRobinGate_O_D_BS p).unitary.proved = false := rfl

-- Gate matrix placeholders: SWAP has proved = false
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

-- Dimension compatibility for n=3: 2^12 = 2^9 * 2^3
example : qubitDim (GHL2025.oneTermRobinTotalQubits (Examples.RobinHeat.oneTermParameters 3)) =
    qubitDim ((GHL2025.oneTermRobinLayout (Examples.RobinHeat.oneTermParameters 3)).signalQubits) *
      gridSize 3 := by native_decide

-- Dimension compatibility for n=4: 2^13 = 2^9 * 2^4 (clog2 4 = 2, signal = 2+0+3+4 = 9, total = 4+9 = 13)
example : qubitDim (GHL2025.oneTermRobinTotalQubits (Examples.RobinHeat.oneTermParameters 4)) =
    qubitDim ((GHL2025.oneTermRobinLayout (Examples.RobinHeat.oneTermParameters 4)).signalQubits) *
      gridSize 4 := by native_decide

-- CircuitBlockEncodingClaim: circuit matches oneTermRobinCircuit for n=3
example :
    (Examples.RobinHeat.oneTermRobinCircuitBlockClaim 3 (by native_decide)).semantics.circuit =
      GHL2025.oneTermRobinCircuit := rfl

-- CircuitBlockEncodingClaim: target matrix matches robinDerivativeMatrix for n=3
example :
    (Examples.RobinHeat.oneTermRobinCircuitBlockClaim 3 (by native_decide)).target.targetMatrix =
      Examples.RobinHeat.robinDerivativeMatrix 3 := rfl

-- CircuitBlockEncodingClaim: blockCorrect is unproved
example :
    (Examples.RobinHeat.oneTermRobinCircuitBlockClaim 3 (by native_decide)).blockCorrect.proved = false := rfl

-- CircuitBlockEncodingClaim: normalizer matches oneTermRobinNormalizer for n=3
example :
    (Examples.RobinHeat.oneTermRobinCircuitBlockClaim 3 (by native_decide)).target.normalizer =
      GHL2025.oneTermRobinNormalizer := rfl

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

example :
    (Resource.parallel (Resource.ofCounts 1 0 0) (Resource.ofCounts 0 1 0)).depth = 1 := by
  native_decide

example :
    (Resource.ofCounts 1 1 0).depth = 2 := rfl

example :
    BlockEncodingCost.betterThan
      { auxiliaryQubits := 1, gateCount := 10, depth := 4, oracleCalls := 0 }
      { auxiliaryQubits := 1, gateCount := 10, depth := 5, oracleCalls := 0 } := by
  simp [BlockEncodingCost.betterThan]

example :
    gridSize (3 + 1) = 2 * gridSize 3 := by
  native_decide

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

def testDiagonalGateMatrix : GateMatrix Rat 1 where
  gate := Gate.oneQubit "D" 0
  matrix := fun i j =>
    if i = j then
      if i.val = 0 then (2 : Rat) else (3 : Rat)
    else 0
  unitary := {
    description := "non-unitary diagonal test matrix for product order only"
    source := "Tests/Basic.lean"
    proved := false
  }

def testFlipGateMatrix : GateMatrix Rat 1 where
  gate := Gate.oneQubit "X" 0
  matrix := fun i j => if i.val + j.val = 1 then (1 : Rat) else 0
  unitary := {
    description := "flip test matrix for product order only"
    source := "Tests/Basic.lean"
    proved := false
  }

-- evalGateMatrices uses circuit order `[D, X]` as the product `X * D`.
example :
    (evalGateMatrices [testDiagonalGateMatrix, testFlipGateMatrix])
      ⟨0, by native_decide⟩ ⟨1, by native_decide⟩ = (3 : Rat) := by
  native_decide

example :
    (evalGateMatrices [testDiagonalGateMatrix, testFlipGateMatrix])
      ⟨1, by native_decide⟩ ⟨0, by native_decide⟩ = (2 : Rat) := by
  native_decide

def testBranchContribution : Fin 3 → Rat :=
  fun s =>
    if s.val = 0 then
      1
    else if s.val = 1 then
      2
    else
      3

example :
    blockExtractionBranchContributionSum testBranchContribution = (6 : Rat) := by
  native_decide

def testCoeffDiagonalMatrix : Matrix 2 2 Coeff :=
  fun i j =>
    if i = j then
      if i.val = 0 then Coeff.rat 2 else Coeff.rat 3
    else Coeff.rat 0

def testCoeffFlipMatrix : Matrix 2 2 Coeff :=
  fun i j => if i.val + j.val = 1 then Coeff.rat 1 else Coeff.rat 0

def testCoeffDiagonalGateMatrix : GateMatrix Coeff 1 where
  gate := Gate.oneQubit "D" 0
  matrix := testCoeffDiagonalMatrix
  unitary := {
    description := "non-unitary symbolic diagonal test matrix"
    source := "Tests/Basic.lean"
    proved := false
  }

example :
    Coeff.evalWith (fun _ => 0)
        ((evalGateMatrices [testCoeffDiagonalGateMatrix])
          ⟨0, by native_decide⟩ ⟨0, by native_decide⟩) =
      Coeff.evalWith (fun _ => 0)
        (testCoeffDiagonalGateMatrix.matrix
          ⟨0, by native_decide⟩ ⟨0, by native_decide⟩) :=
  evalWith_evalGateMatrices_single (fun _ => 0)
    testCoeffDiagonalGateMatrix
    ⟨0, by native_decide⟩ ⟨0, by native_decide⟩

example :
    Coeff.evalWith (fun _ => 0)
        (Matrix.mul testCoeffFlipMatrix testCoeffDiagonalMatrix
          ⟨0, by native_decide⟩ ⟨1, by native_decide⟩) =
      (List.finRange 2).foldl
        (fun acc k =>
          acc + Coeff.evalWith (fun _ => 0)
              (testCoeffFlipMatrix ⟨0, by native_decide⟩ k) *
            Coeff.evalWith (fun _ => 0)
              (testCoeffDiagonalMatrix k ⟨1, by native_decide⟩))
        0 :=
  Matrix.evalWith_mul_apply (fun _ => 0)
    testCoeffFlipMatrix testCoeffDiagonalMatrix
    ⟨0, by native_decide⟩ ⟨1, by native_decide⟩

example :
    Coeff.evalWith (fun _ => 0)
        (Matrix.mul testCoeffFlipMatrix testCoeffDiagonalMatrix
          ⟨0, by native_decide⟩ ⟨1, by native_decide⟩) =
      Coeff.evalWith (fun _ => 0)
          (testCoeffFlipMatrix ⟨0, by native_decide⟩ ⟨1, by native_decide⟩) *
        Coeff.evalWith (fun _ => 0)
          (testCoeffDiagonalMatrix ⟨1, by native_decide⟩ ⟨1, by native_decide⟩) := by
  apply Matrix.evalWith_mul_unique_path
  intro k hk
  have hkval : k.val = 0 := by
    have hne : k.val ≠ 1 := by
      intro hval
      apply hk
      apply Fin.eq_of_val_eq
      simpa using hval
    omega
  have hkzero : k = ⟨0, by native_decide⟩ := Fin.eq_of_val_eq hkval
  subst k
  native_decide

example :
    Coeff.evalWith (fun _ => 0)
        (Matrix.mul testCoeffFlipMatrix testCoeffDiagonalMatrix
          ⟨0, by native_decide⟩ ⟨1, by native_decide⟩) = 3 := by
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

-- Spec circuit local cost: 3 CNOTs from SWAP placeholder, 6 unresolved oracle calls
example :
    Circuit.resource GHL2025.oneTermRobinCircuit =
      Resource.ofCountsWithDepth 0 3 6 0 9 :=
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

-- SWAP unitarity is backed by the finite permutation-matrix bridge.
example (p : GHL2025.OneTermRobinParameters) :
    (GHL2025.oneTermRobinGate_SWAP p).unitary.proved = true := rfl

-- SWAP image arithmetic is self-inverse and feeds the finite permutation proof.
example (p : GHL2025.OneTermRobinParameters) (j : Nat) :
    GHL2025.swapOracleImage p (GHL2025.swapOracleImage p j) = j :=
  GHL2025.swapOracleImage_self_inverse p j

-- The reusable SWAP difference block is preserved after one image application.
example (p : GHL2025.OneTermRobinParameters) (j : Nat) :
    GHL2025.swapOracleDiff p (GHL2025.swapOracleImage p j) =
      GHL2025.swapOracleDiff p j :=
  GHL2025.swapOracleDiff_preserved p j

-- SWAP image is a finite-basis bijection.
example (p : GHL2025.OneTermRobinParameters) :
    (∀ (a b : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p))),
        (⟨GHL2025.swapOracleImage p a.val, GHL2025.swapOracleImage_lt_qubitDim p a.2⟩ :
          Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p))) =
        ⟨GHL2025.swapOracleImage p b.val, GHL2025.swapOracleImage_lt_qubitDim p b.2⟩ →
        a = b) ∧
      ∀ (y : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p))),
        ∃ (x : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p))),
          (⟨GHL2025.swapOracleImage p x.val, GHL2025.swapOracleImage_lt_qubitDim p x.2⟩ :
            Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p))) = y :=
  GHL2025.swapOracleImage_bijective p

-- SWAP matrix has exactly one 1-entry in each row and column.
example (p : GHL2025.OneTermRobinParameters) :
    (∀ (i : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p))),
      ∃ (j : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p))),
        GHL2025.swapOracleMatrix p i j = Coeff.rat 1 ∧
        ∀ (j' : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p))),
          GHL2025.swapOracleMatrix p i j' = Coeff.rat 1 → j' = j) ∧
    (∀ (j : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p))),
      ∃ (i : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p))),
        GHL2025.swapOracleMatrix p i j = Coeff.rat 1 ∧
        ∀ (i' : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p))),
          GHL2025.swapOracleMatrix p i' j = Coeff.rat 1 → i' = i) :=
  GHL2025.swapOracleMatrix_is_permutation p

-- oneTermRobinCircuitSemantics: gate list matches the circuit
example (n : Nat) :
    (Examples.RobinHeat.oneTermRobinCircuitSemantics n).gateListMatches =
      GHL2025.oneTermRobinPlaceholdersMatch (Examples.RobinHeat.oneTermParameters n) := rfl

-- oneTermRobinCircuitSemantics: circuit is oneTermRobinCircuit
example (n : Nat) :
    (Examples.RobinHeat.oneTermRobinCircuitSemantics n).circuit = GHL2025.oneTermRobinCircuit := rfl

-- oneTermRobinBlockExtractionTarget: target matrix is the row-scaled A_k matrix
example (n : Nat) :
    (Examples.RobinHeat.oneTermRobinBlockExtractionTarget n).targetMatrix =
      Examples.RobinHeat.oneTermRobinAkMatrix n := rfl

example :
    Examples.RobinHeat.oneTermRobinAkMatrix 3
        ⟨2, by native_decide⟩ ⟨5, by native_decide⟩ =
      Coeff.mul (GHL2025.robinFunctionValue 3 2)
        (Examples.RobinHeat.robinDerivativeMatrix 3
          ⟨2, by native_decide⟩ ⟨5, by native_decide⟩) := rfl

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

-- signal-system index convention: signal block 1 with a 2-row system starts at row 2.
example : signalSystemBlockRowIndex 2 1 1 = 3 := rfl

-- signal-system index convention: rectangular column stride uses the column count.
example : signalSystemBlockColIndex 3 1 2 = 5 := rfl

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

-- signalSystemBlockProjection: index 1 shifts both row and column by one 2x2 block.
example :
    signalSystemBlockProjection 3 2 2
      (fun i j : Fin 6 => i.val * 10 + j.val)
      ⟨1, by decide⟩
      ⟨1, by decide⟩ ⟨0, by decide⟩ =
    32 := by native_decide

-- signalSystemBlockProjection: rectangular rows/cols use separate row and column strides.
example :
    signalSystemBlockProjection 2 2 3
      (fun i : Fin 4 => fun j : Fin 6 => i.val * 10 + j.val)
      ⟨1, by decide⟩
      ⟨0, by decide⟩ ⟨2, by decide⟩ =
    25 := by native_decide

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

-- CircuitBlockEncodingClaim: target matrix matches the row-scaled A_k matrix for n=3
example :
    (Examples.RobinHeat.oneTermRobinCircuitBlockClaim 3 (by native_decide)).target.targetMatrix =
      Examples.RobinHeat.oneTermRobinAkMatrix 3 := rfl

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
-- target matrix at bulk diagonal (2,2) for n=2 matches oneTermRobinAkMatrix
example :
    (Examples.RobinHeat.oneTermRobinCircuitBlockClaim 2 (by native_decide)).target.targetMatrix
      ⟨2, by native_decide⟩ ⟨2, by native_decide⟩ =
    (Examples.RobinHeat.oneTermRobinAkMatrix 2)
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

-- SWAP gate matrix uses an honest matrix with a finite permutation certificate.
example :
    let p : GHL2025.OneTermRobinParameters := { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.oneTermRobinGate_SWAP p).unitary.proved = true := rfl

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

-- Source-contract audit: the paper Lemma 1 contract is recorded separately
-- from the interim column-map helper used by bandedSparseAccessMatrix.
example :
    (GHL2025.defaultBandedSparseAccessPaperContract
      { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }).inputKet =
      "|0>^(n-l)|s>^l|i>^n" := rfl

example :
    (GHL2025.defaultBandedSparseAccessPaperContract
      { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }).outputKet =
      "|r_si>^n|i>^n" := rfl

example :
    (GHL2025.defaultBandedSparseAccessPaperContract
      { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }).paddedZeroQubits = 0 := rfl

example :
    (GHL2025.defaultBandedSparseAccessPaperContract
      { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }).sparseIndexQubits = 3 := rfl

example :
    (GHL2025.defaultBandedSparseAccessPaperContract
      { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }).cleanInputDomain.proved = false := rfl

example :
    (GHL2025.defaultBandedSparseAccessPaperContract
      { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }).addressRange.proved = false := rfl

example (p : GHL2025.OneTermRobinParameters) :
    (GHL2025.defaultBandedSparseAccessPaperContract p).addressRange.proved = false := rfl

example :
    (GHL2025.defaultBandedSparseAccessPaperContract
      { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }).noSpill.proved = false := rfl

example (p : GHL2025.OneTermRobinParameters) :
    (GHL2025.defaultBandedSparseAccessPaperContract p).noSpill.proved = false := rfl

example :
    (GHL2025.defaultBandedSparseAccessPaperContract
      { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }).forwardCorrect.proved = false := rfl

example :
    (GHL2025.defaultBandedSparseAccessPaperContract
      { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }).daggerCleanup.proved = false := rfl

example :
    (GHL2025.defaultBandedSparseAccessPaperContract
      { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }).unitaryExtension.proved = false := rfl

-- O_D^BS paper-image skeleton: Lemma 1 extracts the padded address register
-- separately from the row register.  For n=3, kappa=7 the padded-zero width is
-- 0 and the whole O_D block is the sparse/address register.
example :
    let p : GHL2025.OneTermRobinParameters :=
      { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.bandedSparseAccessPaperRegisters p 8).rowValue = 4 := by
  native_decide

example :
    let p : GHL2025.OneTermRobinParameters :=
      { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.bandedSparseAccessPaperRegisters p 8).sparseIndexValue = 0 := by
  native_decide

example :
    let p : GHL2025.OneTermRobinParameters :=
      { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    GHL2025.bandedSparseAccessPaperAddress p 8 = 2 := by
  native_decide

example :
    let p : GHL2025.OneTermRobinParameters :=
      { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    GHL2025.bandedSparseAccessPaperAddressInRange p 8 = true := by
  native_decide

example (p : GHL2025.OneTermRobinParameters) (j : Nat) :
    (GHL2025.bandedSparseAccessPaperRegisters p j).rowValue < gridSize p.n :=
  GHL2025.bandedSparseAccessPaperRegisters_row_lt_gridSize p j

example (p : GHL2025.OneTermRobinParameters) (j : Nat) :
    GHL2025.bandedSparseAccessPaperAddressInRange p j = true ↔
      GHL2025.bandedSparseAccessPaperAddress p j < (1 <<< p.n) :=
  GHL2025.bandedSparseAccessPaperAddressInRange_iff p j

example (p : GHL2025.OneTermRobinParameters) (j : Nat) (hn : 2 ≤ p.n) :
    GHL2025.bandedSparseAccessPaperAddressInRange p j = true :=
  GHL2025.bandedSparseAccessPaperAddressInRange_eq_true_of_two_le p j hn

-- Bulk row i=4, s=0: paper image preserves row 4 and replaces the O_D
-- address block by r_si = 2.  Compound index 8 becomes 40.
example :
    let p : GHL2025.OneTermRobinParameters :=
      { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    GHL2025.bandedSparseAccessPaperImage p 8 = 40 := by
  native_decide

-- Contract-drift guard: the active O_D^BS gate uses the Lemma 1 paper-image
-- matrix, not the legacy helper that overwrites the system register by
-- robinSparseColumnMap.  For column 8 the paper image is row 40, while the
-- helper has its historical row-4 entry.
example :
    let p : GHL2025.OneTermRobinParameters :=
      { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    GHL2025.bandedSparseAccessPaperImage p 8 = 40 ∧
      (GHL2025.oneTermRobinGate_O_D_BS p).matrix
        ⟨40, by native_decide⟩ ⟨8, by native_decide⟩ = Coeff.rat 1 ∧
      (GHL2025.oneTermRobinGate_O_D_BS p).matrix
        ⟨4, by native_decide⟩ ⟨8, by native_decide⟩ = Coeff.rat 0 ∧
      (GHL2025.bandedSparseAccessMatrix p)
        ⟨4, by native_decide⟩ ⟨8, by native_decide⟩ = Coeff.rat 1 ∧
      (GHL2025.oneTermRobinGate_O_D_BS p).unitary.proved = false :=
  GHL2025.oneTermRobinGate_O_D_BS_contractDrift_column8_n3

example :
    let p : GHL2025.OneTermRobinParameters :=
      { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    GHL2025.bandedSparseAccessPaperCleanInput p 8 = true := by
  native_decide

example (p : GHL2025.OneTermRobinParameters) (j : Nat) :
    GHL2025.bandedSparseAccessPaperCleanInput p j = true ↔
      (GHL2025.bandedSparseAccessPaperRegisters p j).paddedZeroValue = 0 :=
  GHL2025.bandedSparseAccessPaperCleanInput_iff p j

example :
    let p : GHL2025.OneTermRobinParameters :=
      { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    GHL2025.bandedSparseAccessPaperImageNoSpill p 8 = true := by
  native_decide

example (p : GHL2025.OneTermRobinParameters) (j : Nat) :
    GHL2025.bandedSparseAccessPaperImageNoSpill p j = true ↔
      GHL2025.bandedSparseAccessPaperHighTail p
          (GHL2025.bandedSparseAccessPaperImage p j) =
        GHL2025.bandedSparseAccessPaperHighTail p j :=
  GHL2025.bandedSparseAccessPaperImageNoSpill_iff p j

example (p : GHL2025.OneTermRobinParameters) (j : Nat)
    (haddr : GHL2025.bandedSparseAccessPaperAddress p j < (1 <<< p.n)) :
    GHL2025.bandedSparseAccessPaperHighTail p
        (GHL2025.bandedSparseAccessPaperImage p j) =
      GHL2025.bandedSparseAccessPaperHighTail p j :=
  GHL2025.bandedSparseAccessPaperImage_highTail_eq_of_address_lt p j haddr

example (p : GHL2025.OneTermRobinParameters) (j : Nat) (hn : 2 ≤ p.n) :
    GHL2025.bandedSparseAccessPaperImageNoSpill p j = true :=
  GHL2025.bandedSparseAccessPaperImageNoSpill_eq_true_of_two_le p j hn

example (p : GHL2025.OneTermRobinParameters) (j : Nat) (hn : 2 ≤ p.n) :
    (GHL2025.bandedSparseAccessPaperColumnContract p j).imageNoSpill = true := by
  rw [GHL2025.bandedSparseAccessPaperColumnContract_imageNoSpill_eq]
  exact GHL2025.bandedSparseAccessPaperImageNoSpill_eq_true_of_two_le p j hn

example (p : GHL2025.OneTermRobinParameters)
    (j : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)))
    (haddr : GHL2025.bandedSparseAccessPaperAddress p j.val < (1 <<< p.n)) :
    GHL2025.bandedSparseAccessPaperImage p j.val <
      qubitDim (GHL2025.oneTermRobinTotalQubits p) :=
  GHL2025.bandedSparseAccessPaperImage_lt_qubitDim_of_address_lt
    p j.val j.2 haddr

example (p : GHL2025.OneTermRobinParameters)
    (j : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)))
    (haddr : GHL2025.bandedSparseAccessPaperAddress p j.val < (1 <<< p.n)) :
    (GHL2025.bandedSparseAccessPaperImageFin p j haddr).val =
      GHL2025.bandedSparseAccessPaperImage p j.val :=
  GHL2025.bandedSparseAccessPaperImageFin_val p j haddr

example (p : GHL2025.OneTermRobinParameters)
    (j : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)))
    (haddr : GHL2025.bandedSparseAccessPaperAddress p j.val < (1 <<< p.n)) :
    GHL2025.bandedSparseAccessPaperMatrix p
        (GHL2025.bandedSparseAccessPaperImageFin p j haddr) j =
      Coeff.rat 1 :=
  GHL2025.bandedSparseAccessPaperMatrix_imageFin_eq_one p j haddr

example (p : GHL2025.OneTermRobinParameters)
    (j : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)))
    (haddr : GHL2025.bandedSparseAccessPaperAddress p j.val < (1 <<< p.n)) :
    GHL2025.bandedSparseAccessPaperDaggerMatrix p j
        (GHL2025.bandedSparseAccessPaperImageFin p j haddr) =
      Coeff.rat 1 :=
  GHL2025.bandedSparseAccessPaperDaggerMatrix_imageFin_eq_one p j haddr

example (p : GHL2025.OneTermRobinParameters)
    (j : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)))
    (haddr : GHL2025.bandedSparseAccessPaperAddress p j.val < (1 <<< p.n)) :
    (GHL2025.oneTermRobinGate_O_D_BS p).matrix
        (GHL2025.bandedSparseAccessPaperImageFin p j haddr) j =
      Coeff.rat 1 :=
  GHL2025.oneTermRobinGate_O_D_BS_imageFin_eq_one p j haddr

example (p : GHL2025.OneTermRobinParameters)
    (j : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)))
    (haddr : GHL2025.bandedSparseAccessPaperAddress p j.val < (1 <<< p.n)) :
    (GHL2025.oneTermRobinGate_O_D_BS_dagger p).matrix j
        (GHL2025.bandedSparseAccessPaperImageFin p j haddr) =
      Coeff.rat 1 :=
  GHL2025.oneTermRobinGate_O_D_BS_dagger_imageFin_eq_one p j haddr

example (p : GHL2025.OneTermRobinParameters) (j : Nat) :
    (GHL2025.bandedSparseAccessPaperRegisters p
      (GHL2025.bandedSparseAccessPaperImage p j)).rowValue =
      (GHL2025.bandedSparseAccessPaperRegisters p j).rowValue :=
  GHL2025.bandedSparseAccessPaperImage_rowValue_eq p j

example (p : GHL2025.OneTermRobinParameters) (j : Nat)
    (haddr : GHL2025.bandedSparseAccessPaperAddress p j < (1 <<< p.n)) :
    (GHL2025.bandedSparseAccessPaperRegisters p
      (GHL2025.bandedSparseAccessPaperImage p j)).odRegisterValue =
      GHL2025.bandedSparseAccessPaperAddress p j :=
  GHL2025.bandedSparseAccessPaperImage_odRegisterValue_eq p j haddr

-- The high-tail no-spill check is not only a zero-tail test: with the
-- indicator tail bit set, the executable image keeps the same high tail.
example :
    let p : GHL2025.OneTermRobinParameters :=
      { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    GHL2025.bandedSparseAccessPaperHighTail p 136 = 1 := by
  native_decide

example :
    let p : GHL2025.OneTermRobinParameters :=
      { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    GHL2025.bandedSparseAccessPaperHighTail p
        (GHL2025.bandedSparseAccessPaperImage p 136) = 1 := by
  native_decide

example :
    let p : GHL2025.OneTermRobinParameters :=
      { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    GHL2025.bandedSparseAccessPaperImageNoSpill p 136 = true := by
  native_decide

example :
    let p : GHL2025.OneTermRobinParameters :=
      { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.bandedSparseAccessPaperColumnContract p 8).imageIndex = 40 := by
  native_decide

example :
    let p : GHL2025.OneTermRobinParameters :=
      { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.bandedSparseAccessPaperColumnContract p 8).rowPreserved = true := by
  native_decide

example :
    let p : GHL2025.OneTermRobinParameters :=
      { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.bandedSparseAccessPaperColumnContract p 8).addressWritten = true := by
  native_decide

example :
    let p : GHL2025.OneTermRobinParameters :=
      { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.bandedSparseAccessPaperColumnContract p 8).addressInRange = true := by
  native_decide

example :
    let p : GHL2025.OneTermRobinParameters :=
      { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.bandedSparseAccessPaperColumnContract p 8).imageNoSpill = true := by
  native_decide

example :
    let p : GHL2025.OneTermRobinParameters :=
      { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.bandedSparseAccessPaperRegisters p
      (GHL2025.bandedSparseAccessPaperImage p 8)).rowValue = 4 := by
  native_decide

example :
    let p : GHL2025.OneTermRobinParameters :=
      { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.bandedSparseAccessPaperRegisters p
      (GHL2025.bandedSparseAccessPaperImage p 8)).odRegisterValue = 2 := by
  native_decide

-- Right boundary row i=7, s=0: paper image preserves row 7 and replaces the
-- O_D address block by r_si = 5.  Compound index 14 becomes 94.
example :
    let p : GHL2025.OneTermRobinParameters :=
      { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    GHL2025.bandedSparseAccessPaperImage p 14 = 94 := by
  native_decide

example :
    let p : GHL2025.OneTermRobinParameters :=
      { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.bandedSparseAccessPaperRegisters p
      (GHL2025.bandedSparseAccessPaperImage p 14)).rowValue = 7 := by
  native_decide

example :
    let p : GHL2025.OneTermRobinParameters :=
      { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.bandedSparseAccessPaperRegisters p
      (GHL2025.bandedSparseAccessPaperImage p 14)).odRegisterValue = 5 := by
  native_decide

-- With n=4, kappa=7, the padded-zero field has width 1.  Column 32 has the
-- padded bit set, so Lemma 1's clean-input equation does not apply directly;
-- the full-space unitary extension remains an explicit obligation.
example :
    let p : GHL2025.OneTermRobinParameters :=
      { n := 4, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.bandedSparseAccessPaperRegisters p 32).paddedZeroValue = 1 := by
  native_decide

example :
    let p : GHL2025.OneTermRobinParameters :=
      { n := 4, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    GHL2025.bandedSparseAccessPaperCleanInput p 32 = false := by
  native_decide

example :
    let p : GHL2025.OneTermRobinParameters :=
      { n := 4, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.bandedSparseAccessPaperColumnContract p 32).cleanInput = false := by
  native_decide

example :
    let p : GHL2025.OneTermRobinParameters :=
      { n := 4, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.bandedSparseAccessPaperColumnContract p 32).unitaryExtension.proved = false := rfl

example (p : GHL2025.OneTermRobinParameters) (j : Nat) :
    (GHL2025.bandedSparseAccessPaperColumnContract p j).inputRegisters =
      GHL2025.bandedSparseAccessPaperRegisters p j :=
  GHL2025.bandedSparseAccessPaperColumnContract_inputRegisters_eq p j

example (p : GHL2025.OneTermRobinParameters) (j : Nat) :
    (GHL2025.bandedSparseAccessPaperColumnContract p j).cleanInput =
      GHL2025.bandedSparseAccessPaperCleanInput p j :=
  GHL2025.bandedSparseAccessPaperColumnContract_cleanInput_eq p j

example (p : GHL2025.OneTermRobinParameters) (j : Nat) :
    (GHL2025.bandedSparseAccessPaperColumnContract p j).cleanInput = true ↔
      (GHL2025.bandedSparseAccessPaperRegisters p j).paddedZeroValue = 0 :=
  GHL2025.bandedSparseAccessPaperColumnContract_cleanInput_iff p j

example (p : GHL2025.OneTermRobinParameters) (j : Nat) :
    (GHL2025.bandedSparseAccessPaperColumnContract p j).unitaryExtension.proved = false :=
  GHL2025.bandedSparseAccessPaperColumnContract_unitaryExtension_proved_eq_false p j

example (p : GHL2025.OneTermRobinParameters) (j : Nat) :
    (GHL2025.bandedSparseAccessPaperColumnContract p j).imageIndex =
      GHL2025.bandedSparseAccessPaperImage p j :=
  GHL2025.bandedSparseAccessPaperColumnContract_imageIndex_eq p j

example (p : GHL2025.OneTermRobinParameters) (j : Nat) :
    (GHL2025.bandedSparseAccessPaperColumnContract p j).addressInRange =
      GHL2025.bandedSparseAccessPaperAddressInRange p j :=
  GHL2025.bandedSparseAccessPaperColumnContract_addressInRange_eq p j

example (p : GHL2025.OneTermRobinParameters) (j : Nat) :
    (GHL2025.bandedSparseAccessPaperColumnContract p j).imageNoSpill =
      GHL2025.bandedSparseAccessPaperImageNoSpill p j :=
  GHL2025.bandedSparseAccessPaperColumnContract_imageNoSpill_eq p j

example (p : GHL2025.OneTermRobinParameters) (j : Nat) :
    (GHL2025.bandedSparseAccessPaperColumnContract p j).rowPreserved = true :=
  GHL2025.bandedSparseAccessPaperColumnContract_rowPreserved_eq_true p j

example (p : GHL2025.OneTermRobinParameters) (j : Nat)
    (haddr : GHL2025.bandedSparseAccessPaperAddress p j < (1 <<< p.n)) :
    (GHL2025.bandedSparseAccessPaperColumnContract p j).addressWritten = true :=
  GHL2025.bandedSparseAccessPaperColumnContract_addressWritten_eq_true_of_address_lt p j haddr

example (p : GHL2025.OneTermRobinParameters) (j : Nat)
    (haddr : GHL2025.bandedSparseAccessPaperAddress p j < (1 <<< p.n)) :
    (GHL2025.bandedSparseAccessPaperColumnContract p j).rowPreserved = true ∧
      (GHL2025.bandedSparseAccessPaperColumnContract p j).addressWritten = true ∧
      (GHL2025.bandedSparseAccessPaperColumnContract p j).addressInRange = true ∧
      (GHL2025.bandedSparseAccessPaperColumnContract p j).imageNoSpill = true :=
  GHL2025.bandedSparseAccessPaperColumnContract_registerSafety_of_address_lt p j haddr

-- O_D^BS paper matrix skeleton: the matrix uses the paper-image column
-- convention without promoting proof flags.
example :
    let p : GHL2025.OneTermRobinParameters :=
      { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.bandedSparseAccessPaperMatrix p)
      ⟨40, by native_decide⟩ ⟨8, by native_decide⟩ = Coeff.rat 1 := by
  native_decide

example :
    let p : GHL2025.OneTermRobinParameters :=
      { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.bandedSparseAccessPaperMatrix p)
      ⟨4, by native_decide⟩ ⟨8, by native_decide⟩ = Coeff.rat 0 := by
  native_decide

example :
    let p : GHL2025.OneTermRobinParameters :=
      { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.bandedSparseAccessPaperMatrix p)
      ⟨94, by native_decide⟩ ⟨14, by native_decide⟩ = Coeff.rat 1 := by
  native_decide

-- Active O_D^BS gate now uses the paper-image matrix, not the interim helper.
example (p : GHL2025.OneTermRobinParameters) :
    (GHL2025.oneTermRobinGate_O_D_BS p).matrix =
      GHL2025.bandedSparseAccessPaperMatrix p := rfl

example (p : GHL2025.OneTermRobinParameters)
    (i j : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p))) :
    (GHL2025.oneTermRobinGate_O_D_BS p).matrix i j =
      if i.val = GHL2025.bandedSparseAccessPaperImage p j.val then
        Coeff.rat 1
      else
        Coeff.rat 0 := rfl

example :
    let p : GHL2025.OneTermRobinParameters :=
      { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.oneTermRobinGate_O_D_BS p).matrix
      ⟨40, by native_decide⟩ ⟨8, by native_decide⟩ = Coeff.rat 1 := by
  native_decide

example :
    let p : GHL2025.OneTermRobinParameters :=
      { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.oneTermRobinGate_O_D_BS p).matrix
      ⟨4, by native_decide⟩ ⟨8, by native_decide⟩ = Coeff.rat 0 := by
  native_decide

-- The active dagger gate is the transpose-style matrix for the paper image.
example (p : GHL2025.OneTermRobinParameters) :
    (GHL2025.oneTermRobinGate_O_D_BS_dagger p).matrix =
      GHL2025.bandedSparseAccessPaperDaggerMatrix p := rfl

example (p : GHL2025.OneTermRobinParameters)
    (i j : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p))) :
    (GHL2025.oneTermRobinGate_O_D_BS_dagger p).matrix i j =
      if j.val = GHL2025.bandedSparseAccessPaperImage p i.val then
        Coeff.rat 1
      else
        Coeff.rat 0 := rfl

example :
    let p : GHL2025.OneTermRobinParameters :=
      { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.bandedSparseAccessPaperDaggerMatrix p)
      ⟨8, by native_decide⟩ ⟨40, by native_decide⟩ = Coeff.rat 1 := by
  native_decide

example :
    let p : GHL2025.OneTermRobinParameters :=
      { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.oneTermRobinGate_O_D_BS_dagger p).matrix
      ⟨8, by native_decide⟩ ⟨40, by native_decide⟩ = Coeff.rat 1 := by
  native_decide

example (p : GHL2025.OneTermRobinParameters)
    (j : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)))
    (haddr : GHL2025.bandedSparseAccessPaperAddress p j.val < (1 <<< p.n)) :
    (GHL2025.oneTermRobinGate_O_D_BS p).matrix
        (GHL2025.bandedSparseAccessPaperImageFin p j haddr) j = Coeff.rat 1 ∧
      (GHL2025.oneTermRobinGate_O_D_BS_dagger p).matrix j
        (GHL2025.bandedSparseAccessPaperImageFin p j haddr) = Coeff.rat 1 ∧
      GHL2025.bandedSparseAccessPaperImageNoSpill p j.val = true := by
  have h := GHL2025.oneTermRobinGate_O_D_BS_imageFin_entrySafety p j haddr
  exact ⟨h.1, h.2.1, h.2.2.2.2⟩

example :
    let p : GHL2025.OneTermRobinParameters :=
      { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    GHL2025.bandedSparseAccessPaperCleanInput p 48 = true ∧
      (GHL2025.bandedSparseAccessPaperRegisters p 48).sparseIndexValue < p.kappa ∧
      ∃ image : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)),
        image.val = GHL2025.bandedSparseAccessPaperImage p 48 ∧
          (GHL2025.oneTermRobinGate_O_D_BS p).matrix image ⟨48, by native_decide⟩ =
            Coeff.rat 1 ∧
          (GHL2025.oneTermRobinGate_O_D_BS_dagger p).matrix
            ⟨48, by native_decide⟩ image = Coeff.rat 1 ∧
          GHL2025.bandedSparseAccessPaperImageNoSpill p 48 = true ∧
          (GHL2025.oneTermRobinGate_O_D_BS p).unitary.proved = false ∧
          (GHL2025.oneTermRobinGate_O_D_BS_dagger p).unitary.proved = false := by
  let p : GHL2025.OneTermRobinParameters :=
    { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
  have hsource : GHL2025.bandedSparseAccessPaperGlobalSlotSource p 48 = true := by
    native_decide
  have h :=
    GHL2025.oneTermRobinGate_O_D_BS_globalSlotSource_entrySafety
      p ⟨48, by native_decide⟩ (by decide) hsource
  rcases h with ⟨hclean, hsparse, image, hval, hforward, hdagger, _hrow,
    _hod, hnospill, hforwardFlag, hdaggerFlag⟩
  exact ⟨hclean, hsparse, image, hval, hforward, hdagger, hnospill,
    hforwardFlag, hdaggerFlag⟩

example :
    let p : GHL2025.OneTermRobinParameters :=
      { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    GHL2025.bandedSparseAccessPaperCleanInput p 0 = true ∧
      GHL2025.bandedSparseAccessPaperCleanInput p 48 = true ∧
      GHL2025.bandedSparseAccessPaperAddress p 0 = 6 ∧
      GHL2025.bandedSparseAccessPaperAddress p 48 = 1 ∧
      GHL2025.bandedSparseAccessPaperImage p 0 = 96 ∧
      GHL2025.bandedSparseAccessPaperImage p 48 = 16 ∧
      GHL2025.bandedSparseAccessPaperImage p 0 ≠
        GHL2025.bandedSparseAccessPaperImage p 48 ∧
      (GHL2025.oneTermRobinGate_O_D_BS p).matrix
          ⟨96, by native_decide⟩ ⟨0, by native_decide⟩ = Coeff.rat 1 ∧
      (GHL2025.oneTermRobinGate_O_D_BS p).matrix
          ⟨16, by native_decide⟩ ⟨48, by native_decide⟩ = Coeff.rat 1 ∧
      (GHL2025.oneTermRobinGate_O_D_BS p).unitary.proved = false :=
  GHL2025.oneTermRobinGate_O_D_BS_globalSparseBoundaryNoCollision_n3

example :
    GHL2025.robinSparseColumnBranchValid 3 0 0 = true ∧
      GHL2025.robinSparseColumnBranchValid 3 3 0 = false ∧
      GHL2025.robinSparseColumnMap 3 0 0 =
        GHL2025.robinSparseColumnMap 3 3 0 :=
  GHL2025.robinSparseColumnBranchValid_boundaryUnused_n3

example :
    let p : GHL2025.OneTermRobinParameters :=
      { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    GHL2025.bandedSparseAccessPaperCleanInput p 0 = true ∧
      GHL2025.bandedSparseAccessPaperCleanInput p 48 = true ∧
      GHL2025.bandedSparseAccessPaperValidSparseBranch p 0 = true ∧
    GHL2025.bandedSparseAccessPaperValidSparseBranch p 48 = false ∧
      GHL2025.bandedSparseAccessPaperValidCleanSource p 0 = true ∧
      GHL2025.bandedSparseAccessPaperValidCleanSource p 48 = false ∧
      GHL2025.bandedSparseAccessRowDependentPaperImage p 0 =
        GHL2025.bandedSparseAccessRowDependentPaperImage p 48 ∧
      GHL2025.bandedSparseAccessPaperImage p 0 ≠
        GHL2025.bandedSparseAccessPaperImage p 48 :=
  GHL2025.bandedSparseAccessPaperValidCleanSource_separates_boundaryCollision_n3

example :
    let p : GHL2025.OneTermRobinParameters :=
      { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    GHL2025.bandedSparseAccessPaperGlobalSlotSource p 0 = true ∧
      GHL2025.bandedSparseAccessPaperGlobalSlotSource p 48 = true ∧
      GHL2025.bandedSparseAccessPaperValidCleanSource p 48 = false ∧
      GHL2025.bandedSparseAccessPaperImage p 0 ≠
        GHL2025.bandedSparseAccessPaperImage p 48 ∧
      (GHL2025.oneTermRobinGate_O_D_BS p).unitary.proved = false :=
  GHL2025.bandedSparseAccessPaperGlobalSlotSource_boundaryColumns_n3

example :
    let p : GHL2025.OneTermRobinParameters :=
      { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    GHL2025.bandedSparseAccessPaperCleanInput p 112 = true ∧
      (GHL2025.bandedSparseAccessPaperRegisters p 112).sparseIndexValue = 7 ∧
      GHL2025.bandedSparseAccessPaperSparseIndexInKappa p 112 = false ∧
      GHL2025.bandedSparseAccessPaperGlobalSlotSource p 112 = false ∧
      (GHL2025.oneTermRobinGate_O_D_BS p).unitary.proved = false :=
  GHL2025.bandedSparseAccessPaperGlobalSlotSource_encodedOutOfRange_n3

example (p : GHL2025.OneTermRobinParameters) (j : Nat)
    (h : GHL2025.bandedSparseAccessPaperValidCleanSource p j = true) :
    GHL2025.bandedSparseAccessPaperCleanInput p j = true :=
  GHL2025.bandedSparseAccessPaperValidCleanSource_cleanInput_eq_true p j h

example (p : GHL2025.OneTermRobinParameters) (j : Nat)
    (h : GHL2025.bandedSparseAccessPaperValidCleanSource p j = true) :
    GHL2025.bandedSparseAccessPaperValidSparseBranch p j = true :=
  GHL2025.bandedSparseAccessPaperValidCleanSource_validSparseBranch_eq_true p j h

example :
    let p : GHL2025.OneTermRobinParameters :=
      { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    GHL2025.bandedSparseAccessPaperUnusedSparseBranch p 48 = true ∧
      GHL2025.bandedSparseAccessPaperValidCleanSource p 48 = false := by
  native_decide

example (p : GHL2025.OneTermRobinParameters) (j : Nat)
    (h : GHL2025.bandedSparseAccessPaperUnusedSparseBranch p j = true) :
    GHL2025.bandedSparseAccessPaperCleanInput p j = true :=
  GHL2025.bandedSparseAccessPaperUnusedSparseBranch_cleanInput_eq_true p j h

example (p : GHL2025.OneTermRobinParameters) (j : Nat)
    (h : GHL2025.bandedSparseAccessPaperUnusedSparseBranch p j = true) :
    GHL2025.bandedSparseAccessPaperValidSparseBranch p j = false :=
  GHL2025.bandedSparseAccessPaperUnusedSparseBranch_validSparseBranch_eq_false p j h

example (p : GHL2025.OneTermRobinParameters) (j : Nat) :
    (GHL2025.bandedSparseAccessUnusedBranchExtensionContract p j).unusedBranchImageRule.proved = false ∧
      (GHL2025.bandedSparseAccessUnusedBranchExtensionContract p j).unusedBranchInjective.proved = false ∧
      (GHL2025.bandedSparseAccessUnusedBranchExtensionContract p j).unitaryExtension.proved = false := by
  have h :=
    GHL2025.bandedSparseAccessUnusedBranchExtensionContract_flags_false p j
  exact ⟨h.2.1, h.2.2.1, h.2.2.2.2.2⟩

example (p : GHL2025.OneTermRobinParameters) (j : Nat) :
    (GHL2025.bandedSparseAccessUnusedBranchImageRuleContract p j).proposedImageIndex = none ∧
      (GHL2025.bandedSparseAccessUnusedBranchImageRuleContract p j).imageSpecified.proved = false ∧
      (GHL2025.bandedSparseAccessUnusedBranchImageRuleContract p j).imageFinite.proved = false ∧
      (GHL2025.bandedSparseAccessUnusedBranchImageRuleContract p j).separatesActiveCollision.proved = false ∧
      (GHL2025.bandedSparseAccessUnusedBranchImageRuleContract p j).validBranchAgreement.proved = false :=
  GHL2025.bandedSparseAccessUnusedBranchImageRuleContract_flags_false p j

example (p : GHL2025.OneTermRobinParameters) (j : Nat) :
    (GHL2025.bandedSparseAccessUnusedBranchExtensionContract p j).unusedBranchImageRuleContract.proposedImageIndex = none ∧
      (GHL2025.bandedSparseAccessUnusedBranchExtensionContract p j).unusedBranchImageRuleContract.imageSpecified.proved = false ∧
      (GHL2025.bandedSparseAccessUnusedBranchExtensionContract p j).unusedBranchImageRuleContract.validBranchAgreement.proved = false ∧
      (GHL2025.bandedSparseAccessUnusedBranchExtensionContract p j).unusedBranchImageRule.proved = false := by
  simp [GHL2025.bandedSparseAccessUnusedBranchExtensionContract,
    GHL2025.bandedSparseAccessUnusedBranchImageRuleContract]

example (p : GHL2025.OneTermRobinParameters) (j : Nat)
    (h : GHL2025.bandedSparseAccessPaperUnusedSparseBranch p j = true) :
    (GHL2025.bandedSparseAccessUnusedBranchExtensionContract p j).cleanInput = true ∧
      (GHL2025.bandedSparseAccessUnusedBranchExtensionContract p j).validSparseBranch = false ∧
      (GHL2025.bandedSparseAccessUnusedBranchExtensionContract p j).unusedSparseBranch = true ∧
      (GHL2025.bandedSparseAccessUnusedBranchExtensionContract p j).unusedBranchImageRule.proved = false ∧
      (GHL2025.bandedSparseAccessUnusedBranchExtensionContract p j).unitaryExtension.proved = false := by
  have hcontract :=
    GHL2025.bandedSparseAccessUnusedBranchExtensionContract_of_unusedBranch
      p j h
  exact ⟨hcontract.1, hcontract.2.1, hcontract.2.2.1,
    hcontract.2.2.2.1, hcontract.2.2.2.2.2.2.2⟩

example (p : GHL2025.OneTermRobinParameters) (j : Nat)
    (h : GHL2025.bandedSparseAccessPaperUnusedSparseBranch p j = true) :
    (GHL2025.bandedSparseAccessUnusedBranchImageRuleContract p j).cleanInput = true ∧
      (GHL2025.bandedSparseAccessUnusedBranchImageRuleContract p j).validSparseBranch = false ∧
      (GHL2025.bandedSparseAccessUnusedBranchImageRuleContract p j).unusedSparseBranch = true ∧
      (GHL2025.bandedSparseAccessUnusedBranchImageRuleContract p j).proposedImageIndex = none ∧
      (GHL2025.bandedSparseAccessUnusedBranchImageRuleContract p j).imageSpecified.proved = false ∧
      (GHL2025.bandedSparseAccessUnusedBranchImageRuleContract p j).validBranchAgreement.proved = false :=
  GHL2025.bandedSparseAccessUnusedBranchImageRuleContract_of_unusedBranch p j h

example :
    let p : GHL2025.OneTermRobinParameters :=
      { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    GHL2025.bandedSparseAccessPaperValidCleanSource p 0 = true ∧
      GHL2025.bandedSparseAccessPaperUnusedSparseBranch p 48 = true ∧
      GHL2025.bandedSparseAccessRowDependentPaperImage p 0 =
        GHL2025.bandedSparseAccessRowDependentPaperImage p 48 ∧
      GHL2025.bandedSparseAccessPaperImage p 0 ≠
        GHL2025.bandedSparseAccessPaperImage p 48 ∧
      (GHL2025.bandedSparseAccessUnusedBranchExtensionContract p 48).unitaryExtension.proved = false ∧
      (GHL2025.oneTermRobinGate_O_D_BS p).unitary.proved = false ∧
      (GHL2025.oneTermRobinGate_O_D_BS_dagger p).unitary.proved = false := by
  have h := GHL2025.bandedSparseAccessUnusedBranchExtensionContract_boundaryCollision_n3
  exact ⟨h.1, h.2.1, h.2.2.1, h.2.2.2.1,
    h.2.2.2.2.2, rfl, rfl⟩

example (p : GHL2025.OneTermRobinParameters)
    (source post pre : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)))
    (hpost : post.val =
      GHL2025.swapOracleImage p
        (GHL2025.bandedSparseAccessPaperImage p source.val))
    (hpre : post.val = GHL2025.bandedSparseAccessPaperImage p pre.val) :
    (GHL2025.oneTermRobinGate_O_D_BS_dagger p).matrix pre post = Coeff.rat 1 :=
  GHL2025.oneTermRobinGate_O_D_BS_dagger_postSwap_entry_of_preimage
    p source post pre hpost hpre

example (p : GHL2025.OneTermRobinParameters)
    (source post pre : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)))
    (hpost : post.val =
      GHL2025.swapOracleImage p
        (GHL2025.bandedSparseAccessPaperImage p source.val))
    (hpre : post.val = GHL2025.bandedSparseAccessPaperImage p pre.val)
    (hclean : GHL2025.bandedSparseAccessPaperCleanInput p pre.val = true)
    (haddr : GHL2025.bandedSparseAccessPaperAddress p pre.val < (1 <<< p.n)) :
    (GHL2025.oneTermRobinGate_O_D_BS_dagger p).matrix pre post = Coeff.rat 1 ∧
      GHL2025.bandedSparseAccessPaperCleanInput p pre.val = true ∧
      (GHL2025.bandedSparseAccessPaperColumnContract p pre.val).imageNoSpill = true ∧
      (GHL2025.bandedSparseAccessPaperRegisters p post.val).odRegisterValue =
        GHL2025.bandedSparseAccessPaperAddress p pre.val := by
  let witness :=
    GHL2025.bandedSparseAccessPostSwapCleanup_of_preimage
      p source post pre hpost hpre hclean haddr
  exact ⟨witness.daggerEntry, witness.preCleanInput,
    witness.preImageNoSpill, witness.postOd_eq_preAddress⟩

example :
    let p : GHL2025.OneTermRobinParameters :=
      { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    GHL2025.swapOracleImage p (GHL2025.bandedSparseAccessPaperImage p 8) = 68 ∧
      GHL2025.bandedSparseAccessPaperImage p 68 = 68 ∧
      GHL2025.bandedSparseAccessPaperCleanInput p 68 = true ∧
      (GHL2025.bandedSparseAccessPaperColumnContract p 68).imageNoSpill = true := by
  native_decide

example :
    GHL2025.robinSparseReverseColumnIndex 3 4
        (GHL2025.robinSparseColumnMap 3 0 4) = 4 := by
  native_decide

example :
    GHL2025.robinSparseReverseColumnRoundtripCheck 3 8 = true := by
  native_decide

example :
    GHL2025.robinSparseReverseColumnRoundtripCheck 4 8 = true := by
  native_decide

example {n s i : Nat} (hn : 3 ≤ n) (hs : s < 8) (hi : i < gridSize n) :
    GHL2025.robinSparseColumnMap n
      (GHL2025.robinSparseReverseColumnIndex n i
        (GHL2025.robinSparseColumnMap n s i))
      (GHL2025.robinSparseColumnMap n s i) = i :=
  GHL2025.robinSparseReverseColumnRoundtrip_of_lt_eight hn hs hi

example {n s i : Nat} (hn : 3 ≤ n) (hs : s < 8) (hi : i < gridSize n) :
    GHL2025.robinSparseReverseColumnIndex n i
        (GHL2025.robinSparseColumnMap n s i) < 8 :=
  GHL2025.robinSparseReverseColumnIndex_lt_eight_of_columnMap hn hs hi

example :
    let p : GHL2025.OneTermRobinParameters :=
      { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    GHL2025.bandedSparseAccessPaperPostSwapPreimageCandidate p 8 = 68 ∧
      GHL2025.bandedSparseAccessPaperPostSwapPreimageCandidateChecks p 8 = true := by
  native_decide

example :
    let p : GHL2025.OneTermRobinParameters :=
      { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (List.range (qubitDim (GHL2025.oneTermRobinTotalQubits p))).all
      (fun source =>
        GHL2025.bandedSparseAccessPaperPostSwapPreimageCandidateChecks p source) =
      true := by
  native_decide

example (p : GHL2025.OneTermRobinParameters) (source : Nat)
    (hn : 3 ≤ p.n) (hkappa : p.kappa = 7) (hκbits : clog2 p.kappa = 3)
    (hsource : source < qubitDim (GHL2025.oneTermRobinTotalQubits p))
    (hclean : GHL2025.bandedSparseAccessPaperCleanInput p source = true) :
    GHL2025.bandedSparseAccessPaperPostSwapPreimageCandidateChecks p source = true :=
  GHL2025.bandedSparseAccessPaperPostSwapPreimageCandidateChecks_of_cleanSource
    p source hn hkappa hκbits hsource hclean

example (p : GHL2025.OneTermRobinParameters)
    (source : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)))
    (hn : 3 ≤ p.n) (hkappa : p.kappa = 7) (hκbits : clog2 p.kappa = 3)
    (hclean : GHL2025.bandedSparseAccessPaperCleanInput p source.val = true)
    (hpostRange :
      GHL2025.swapOracleImage p (GHL2025.bandedSparseAccessPaperImage p source.val) <
        qubitDim (GHL2025.oneTermRobinTotalQubits p))
    (hpreRange :
      GHL2025.bandedSparseAccessPaperPostSwapPreimageCandidate p source.val <
        qubitDim (GHL2025.oneTermRobinTotalQubits p)) :
    GHL2025.BandedSparseAccessPostSwapCleanup p source
      ⟨GHL2025.swapOracleImage p
          (GHL2025.bandedSparseAccessPaperImage p source.val), hpostRange⟩
      ⟨GHL2025.bandedSparseAccessPaperPostSwapPreimageCandidate p source.val,
        hpreRange⟩ :=
  GHL2025.bandedSparseAccessPostSwapCleanup_of_cleanSourceCandidate
    p source hn hkappa hκbits hclean hpostRange hpreRange

example (p : GHL2025.OneTermRobinParameters) {j : Nat}
    (hj : j < qubitDim (GHL2025.oneTermRobinTotalQubits p)) :
    GHL2025.swapOracleImage p j <
      qubitDim (GHL2025.oneTermRobinTotalQubits p) :=
  GHL2025.swapOracleImage_lt_qubitDim p hj

example (p : GHL2025.OneTermRobinParameters)
    (source : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)))
    (haddr : GHL2025.bandedSparseAccessPaperAddress p source.val < (1 <<< p.n)) :
    GHL2025.swapOracleImage p
        (GHL2025.bandedSparseAccessPaperImage p source.val) <
      qubitDim (GHL2025.oneTermRobinTotalQubits p) :=
  GHL2025.bandedSparseAccessPaperPostSwapImage_lt_qubitDim_of_address_lt
    p source haddr

example (p : GHL2025.OneTermRobinParameters)
    (source : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)))
    (hn : 3 ≤ p.n) (hkappa : p.kappa = 7) (hκbits : clog2 p.kappa = 3)
    (hclean : GHL2025.bandedSparseAccessPaperCleanInput p source.val = true) :
    GHL2025.bandedSparseAccessPaperPostSwapPreimageCandidate p source.val <
      qubitDim (GHL2025.oneTermRobinTotalQubits p) :=
  GHL2025.bandedSparseAccessPaperPostSwapPreimageCandidate_lt_qubitDim_of_cleanSource
    p source hn hkappa hκbits hclean

example (p : GHL2025.OneTermRobinParameters)
    (source : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)))
    (hn : 3 ≤ p.n) (hkappa : p.kappa = 7) (hκbits : clog2 p.kappa = 3)
    (hclean : GHL2025.bandedSparseAccessPaperCleanInput p source.val = true) :
    GHL2025.bandedSparseAccessPaperCleanInput p
        (GHL2025.bandedSparseAccessPaperPostSwapPreimageCandidate p source.val) =
      true := by
  let witness :=
    GHL2025.bandedSparseAccessPostSwapCleanup_of_cleanSourceCandidate_noRange
      p source hn hkappa hκbits hclean
  exact witness.preCleanInput

example (p : GHL2025.OneTermRobinParameters)
    (source : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)))
    (hn : 3 ≤ p.n) (hkappa : p.kappa = 7) (hκbits : clog2 p.kappa = 3)
    (hvalid : GHL2025.bandedSparseAccessPaperValidCleanSource p source.val = true) :
    GHL2025.bandedSparseAccessPaperCleanInput p
        (GHL2025.bandedSparseAccessPaperPostSwapPreimageCandidate p source.val) =
      true := by
  let witness :=
    GHL2025.bandedSparseAccessPostSwapCleanup_of_validCleanSourceCandidate_noRange
      p source hn hkappa hκbits hvalid
  exact witness.preCleanInput

example (p : GHL2025.OneTermRobinParameters)
    (source : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)))
    (hn : 3 ≤ p.n) (hkappa : p.kappa = 7) (hκbits : clog2 p.kappa = 3)
    (hsource : GHL2025.bandedSparseAccessPaperGlobalSlotSource p source.val = true) :
    GHL2025.bandedSparseAccessPaperCleanInput p
        (GHL2025.bandedSparseAccessPaperPostSwapPreimageCandidate p source.val) =
      true := by
  let witness :=
    GHL2025.bandedSparseAccessPostSwapCleanup_of_globalSlotSourceCandidate_noRange
      p source hn hkappa hκbits hsource
  exact witness.preCleanInput

example :
    let p : GHL2025.OneTermRobinParameters :=
      { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    let source : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
      ⟨48, by native_decide⟩
    GHL2025.bandedSparseAccessPaperGlobalSlotSource p source.val = true ∧
      GHL2025.bandedSparseAccessPaperValidCleanSource p source.val = false ∧
      (GHL2025.oneTermRobinGate_O_D_BS_dagger p).matrix
        ⟨GHL2025.bandedSparseAccessPaperPostSwapPreimageCandidate p source.val,
          by native_decide⟩
        ⟨GHL2025.swapOracleImage p
            (GHL2025.bandedSparseAccessPaperImage p source.val),
          by native_decide⟩ = Coeff.rat 1 ∧
      (GHL2025.oneTermRobinGate_O_D_BS p).unitary.proved = false ∧
      (GHL2025.oneTermRobinGate_O_D_BS_dagger p).unitary.proved = false := by
  let p : GHL2025.OneTermRobinParameters :=
    { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
  let source : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
    ⟨48, by native_decide⟩
  have witness :=
    GHL2025.bandedSparseAccessPostSwapCleanup_of_globalSlotSourceCandidate_noRange
      p source (by native_decide) rfl (by native_decide) (by native_decide)
  exact ⟨by native_decide, by native_decide, witness.daggerEntry, rfl, rfl⟩

example (p : GHL2025.OneTermRobinParameters)
    (source : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)))
    (hn : 3 ≤ p.n) (hkappa : p.kappa = 7) (hκbits : clog2 p.kappa = 3)
    (hsource : GHL2025.bandedSparseAccessPaperGlobalSlotSource p source.val = true) :
    GHL2025.bandedSparseAccessPaperPostSwapPreimageCandidateChecks p source.val =
      true :=
  GHL2025.bandedSparseAccessPaperPostSwapPreimageCandidateChecks_of_globalSlotSource
    p source.val hn hkappa hκbits source.2 hsource

example (p : GHL2025.OneTermRobinParameters)
    (source : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)))
    (hn : 3 ≤ p.n) (hkappa : p.kappa = 7) (hκbits : clog2 p.kappa = 3)
    (hsource : GHL2025.bandedSparseAccessPaperGlobalSlotSource p source.val = true) :
    GHL2025.bandedSparseAccessPaperPostSwapPreimageCandidate p source.val <
      qubitDim (GHL2025.oneTermRobinTotalQubits p) :=
  GHL2025.bandedSparseAccessPaperPostSwapPreimageCandidate_lt_qubitDim_of_globalSlotSource
    p source hn hkappa hκbits hsource

example (p : GHL2025.OneTermRobinParameters)
    (source : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)))
    (hn : 3 ≤ p.n) (hkappa : p.kappa = 7) (hκbits : clog2 p.kappa = 3)
    (hsource : GHL2025.bandedSparseAccessPaperGlobalSlotSource p source.val = true) :
    (GHL2025.bandedSparseAccessGlobalSlotInverseOnRangeContract p source.val).sourceInGlobalDomain =
        true ∧
      (GHL2025.bandedSparseAccessGlobalSlotInverseOnRangeContract p source.val).candidateChecks =
        true ∧
      (GHL2025.bandedSparseAccessGlobalSlotInverseOnRangeContract p source.val).inverseOnRange.proved =
        false ∧
      (GHL2025.bandedSparseAccessGlobalSlotInverseOnRangeContract p source.val).uniquePreimage.proved =
        false ∧
      (GHL2025.bandedSparseAccessGlobalSlotInverseOnRangeContract p source.val).imageInjectiveOnGlobalSource.proved =
        false ∧
      (GHL2025.bandedSparseAccessGlobalSlotInverseOnRangeContract p source.val).daggerCleanup.proved =
        false ∧
      (GHL2025.bandedSparseAccessGlobalSlotInverseOnRangeContract p source.val).unitaryExtension.proved =
        false :=
  GHL2025.bandedSparseAccessGlobalSlotInverseOnRangeContract_of_globalSlotSource
    p source.val hn hkappa hκbits source.2 hsource

example (p : GHL2025.OneTermRobinParameters)
    (source pre : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)))
    (hn : 3 ≤ p.n) (hkappa : p.kappa = 7) (hκbits : clog2 p.kappa = 3)
    (hsource : GHL2025.bandedSparseAccessPaperGlobalSlotSource p source.val = true)
    (hpreSource : GHL2025.bandedSparseAccessPaperGlobalSlotSource p pre.val = true)
    (hpreImage :
      GHL2025.bandedSparseAccessPaperImage p pre.val =
        (GHL2025.bandedSparseAccessGlobalSlotInverseOnRangeContract p
          source.val).postSwapImageIndex) :
    pre.val =
        (GHL2025.bandedSparseAccessGlobalSlotInverseOnRangeContract p
          source.val).candidatePreimageIndex ∧
      (GHL2025.bandedSparseAccessGlobalSlotInverseOnRangeContract p
          source.val).sourceInGlobalDomain = true ∧
      (GHL2025.bandedSparseAccessGlobalSlotInverseOnRangeContract p
          source.val).candidateChecks = true ∧
      (GHL2025.bandedSparseAccessGlobalSlotInverseOnRangeContract p
          source.val).inverseOnRange.proved = false ∧
      (GHL2025.bandedSparseAccessGlobalSlotInverseOnRangeContract p
          source.val).uniquePreimage.proved = false ∧
      (GHL2025.bandedSparseAccessGlobalSlotInverseOnRangeContract p
          source.val).imageInjectiveOnGlobalSource.proved = false ∧
      (GHL2025.bandedSparseAccessGlobalSlotInverseOnRangeContract p
          source.val).daggerCleanup.proved = false ∧
      (GHL2025.bandedSparseAccessGlobalSlotInverseOnRangeContract p
          source.val).unitaryExtension.proved = false :=
  GHL2025.bandedSparseAccessGlobalSlotInverseOnRangeContract_uniquePreimageBridge
    p source pre hn hkappa hκbits hsource hpreSource hpreImage

example {s : Nat} (hs : s < 7) :
    GHL2025.oneTermRobinGlobalSparseInverseSlot s < 7 :=
  GHL2025.oneTermRobinGlobalSparseInverseSlot_lt_seven hs

example {s : Nat} (hs : s < 7) :
    GHL2025.oneTermRobinGlobalSparseInverseSlot
        (GHL2025.oneTermRobinGlobalSparseInverseSlot s) = s :=
  GHL2025.oneTermRobinGlobalSparseInverseSlot_involutive_of_lt_seven hs

example {s t : Nat} (hs : s < 7) (ht : t < 7)
    (h : GHL2025.oneTermRobinGlobalSparseInverseSlot s =
      GHL2025.oneTermRobinGlobalSparseInverseSlot t) :
    s = t :=
  GHL2025.oneTermRobinGlobalSparseInverseSlot_injective_of_lt_seven hs ht h

example {n s t i : Nat} (hn : 3 ≤ n) (hs : s < 7) (ht : t < 7)
    (hi : i < gridSize n)
    (h :
      GHL2025.oneTermRobinGlobalSparseAddress n t
          (GHL2025.oneTermRobinGlobalSparseAddress n s i) = i) :
    t = GHL2025.oneTermRobinGlobalSparseInverseSlot s :=
  GHL2025.oneTermRobinGlobalSparseAddress_inverseSlot_unique_of_lt_seven
    hn hs ht hi h

example {n s t i : Nat} (hn : 3 ≤ n) (hs : s < 7) (ht : t < 7)
    (hi : i < gridSize n)
    (h :
      GHL2025.oneTermRobinGlobalSparseAddress n s i =
        GHL2025.oneTermRobinGlobalSparseAddress n t i) :
    s = t :=
  GHL2025.oneTermRobinGlobalSparseAddress_same_row_injective_of_lt_seven
    hn hs ht hi h

example :
    (4 : Nat) = GHL2025.oneTermRobinGlobalSparseInverseSlot 0 :=
  GHL2025.oneTermRobinGlobalSparseAddress_inverseSlot_unique_of_lt_seven
    (n := 3) (s := 0) (t := 4) (i := 0)
    (by decide) (by decide) (by decide) (by native_decide) (by native_decide)

example (p : GHL2025.OneTermRobinParameters) {j₁ j₂ : Nat}
    (hkappa : p.kappa = 7)
    (hsource₁ : GHL2025.bandedSparseAccessPaperGlobalSlotSource p j₁ = true)
    (hsource₂ : GHL2025.bandedSparseAccessPaperGlobalSlotSource p j₂ = true)
    (h :
      GHL2025.oneTermRobinGlobalSparseInverseSlot
          (GHL2025.bandedSparseAccessPaperRegisters p j₁).sparseIndexValue =
        GHL2025.oneTermRobinGlobalSparseInverseSlot
          (GHL2025.bandedSparseAccessPaperRegisters p j₂).sparseIndexValue) :
    (GHL2025.bandedSparseAccessPaperRegisters p j₁).sparseIndexValue =
      (GHL2025.bandedSparseAccessPaperRegisters p j₂).sparseIndexValue :=
  GHL2025.bandedSparseAccessPaperGlobalSlotSource_inverseSlot_injective
    p hkappa hsource₁ hsource₂ h

example (p : GHL2025.OneTermRobinParameters) {j₁ j₂ : Nat}
    (hn : 3 ≤ p.n) (hkappa : p.kappa = 7)
    (hsource₁ : GHL2025.bandedSparseAccessPaperGlobalSlotSource p j₁ = true)
    (hsource₂ : GHL2025.bandedSparseAccessPaperGlobalSlotSource p j₂ = true)
    (hrow :
      (GHL2025.bandedSparseAccessPaperRegisters p j₁).rowValue =
        (GHL2025.bandedSparseAccessPaperRegisters p j₂).rowValue)
    (haddr :
      GHL2025.bandedSparseAccessPaperAddress p j₁ =
        GHL2025.bandedSparseAccessPaperAddress p j₂) :
    (GHL2025.bandedSparseAccessPaperRegisters p j₁).sparseIndexValue =
      (GHL2025.bandedSparseAccessPaperRegisters p j₂).sparseIndexValue :=
  GHL2025.bandedSparseAccessPaperAddress_same_row_injective_of_globalSlotSource
    p hn hkappa hsource₁ hsource₂ hrow haddr

example (p : GHL2025.OneTermRobinParameters)
    (j₁ j₂ : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)))
    (hn : 3 ≤ p.n) (hkappa : p.kappa = 7) (hκbits : clog2 p.kappa = 3)
    (hsource₁ : GHL2025.bandedSparseAccessPaperGlobalSlotSource p j₁.val = true)
    (hsource₂ : GHL2025.bandedSparseAccessPaperGlobalSlotSource p j₂.val = true)
    (himage :
      GHL2025.bandedSparseAccessPaperImage p j₁.val =
        GHL2025.bandedSparseAccessPaperImage p j₂.val) :
    j₁ = j₂ :=
  GHL2025.bandedSparseAccessPaperImage_injective_on_globalSlotSource
    p j₁ j₂ hn hkappa hκbits hsource₁ hsource₂ himage

example (p : GHL2025.OneTermRobinParameters)
    (source pre : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)))
    (hn : 3 ≤ p.n) (hkappa : p.kappa = 7) (hκbits : clog2 p.kappa = 3)
    (hsource : GHL2025.bandedSparseAccessPaperGlobalSlotSource p source.val = true)
    (hpreSource : GHL2025.bandedSparseAccessPaperGlobalSlotSource p pre.val = true)
    (hpreImage :
      GHL2025.bandedSparseAccessPaperImage p pre.val =
        GHL2025.swapOracleImage p
          (GHL2025.bandedSparseAccessPaperImage p source.val)) :
    pre.val =
      GHL2025.bandedSparseAccessPaperPostSwapPreimageCandidate p source.val :=
  GHL2025.bandedSparseAccessPaperPostSwapPreimageCandidate_unique_on_globalSlotSource
    p source pre hn hkappa hκbits hsource hpreSource hpreImage

example :
    let p : GHL2025.OneTermRobinParameters :=
      { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    let source : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
      ⟨48, by native_decide⟩
    let pre : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
      ⟨GHL2025.bandedSparseAccessPaperPostSwapPreimageCandidate p source.val,
        by native_decide⟩
    GHL2025.bandedSparseAccessPaperGlobalSlotSource p source.val = true ∧
      pre.val =
        GHL2025.bandedSparseAccessPaperPostSwapPreimageCandidate p source.val := by
  let p : GHL2025.OneTermRobinParameters :=
    { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
  let source : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
    ⟨48, by native_decide⟩
  let pre : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
    ⟨GHL2025.bandedSparseAccessPaperPostSwapPreimageCandidate p source.val,
      by native_decide⟩
  constructor
  · native_decide
  · exact
      GHL2025.bandedSparseAccessPaperPostSwapPreimageCandidate_unique_on_globalSlotSource
        p source pre (by native_decide) rfl (by native_decide)
        (by native_decide) (by native_decide) (by native_decide)

example :
    let p : GHL2025.OneTermRobinParameters :=
      { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    let c := GHL2025.bandedSparseAccessGlobalSlotInverseOnRangeContract p 48
    c.sourceInGlobalDomain = true ∧
      c.candidateChecks = true ∧
      c.inverseOnRange.proved = false ∧
      c.uniquePreimage.proved = false ∧
      c.imageInjectiveOnGlobalSource.proved = false ∧
      c.daggerCleanup.proved = false ∧
      c.unitaryExtension.proved = false := by
  native_decide

example :
    let p : GHL2025.OneTermRobinParameters :=
      { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    let source : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
      ⟨48, by native_decide⟩
    let pre : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
      ⟨GHL2025.bandedSparseAccessPaperPostSwapPreimageCandidate p source.val,
        by native_decide⟩
    let c := GHL2025.bandedSparseAccessGlobalSlotInverseOnRangeContract p
      source.val
    pre.val = c.candidatePreimageIndex ∧
      c.sourceInGlobalDomain = true ∧
      c.candidateChecks = true ∧
      c.inverseOnRange.proved = false ∧
      c.uniquePreimage.proved = false ∧
      c.imageInjectiveOnGlobalSource.proved = false ∧
      c.daggerCleanup.proved = false ∧
      c.unitaryExtension.proved = false := by
  let p : GHL2025.OneTermRobinParameters :=
    { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
  let source : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
    ⟨48, by native_decide⟩
  let pre : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
    ⟨GHL2025.bandedSparseAccessPaperPostSwapPreimageCandidate p source.val,
      by native_decide⟩
  exact
    GHL2025.bandedSparseAccessGlobalSlotInverseOnRangeContract_uniquePreimageBridge
      p source pre (by native_decide) rfl (by native_decide)
      (by native_decide) (by native_decide) (by native_decide)

example (p : GHL2025.OneTermRobinParameters)
    (source : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)))
    (hn : 3 ≤ p.n) (hkappa : p.kappa = 7) (hκbits : clog2 p.kappa = 3)
    (hsource : GHL2025.bandedSparseAccessPaperGlobalSlotSource p source.val = true) :
    ∃ (post pre : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p))),
      GHL2025.BandedSparseAccessPostSwapCleanup p source post pre ∧
        (GHL2025.oneTermRobinGate_O_D_BS_dagger p).matrix pre post =
          Coeff.rat 1 ∧
        (GHL2025.bandedSparseAccessGlobalSlotInverseOnRangeContract p
            source.val).candidateChecks = true ∧
        (GHL2025.bandedSparseAccessGlobalSlotInverseOnRangeContract p
            source.val).daggerCleanup.proved = false ∧
        (GHL2025.bandedSparseAccessGlobalSlotInverseOnRangeContract p
            source.val).unitaryExtension.proved = false := by
  have h :=
    GHL2025.bandedSparseAccessGlobalSlotInverseOnRangeContract_daggerCleanupBridge
      p source hn hkappa hκbits hsource
  rcases h with
    ⟨post, pre, hcleanup, _hpost, _hpre, hentry, hchecks, hdaggerFlag,
      hunitaryFlag⟩
  exact ⟨post, pre, hcleanup, hentry, hchecks, hdaggerFlag, hunitaryFlag⟩

example :
    let p : GHL2025.OneTermRobinParameters :=
      { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    let source : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
      ⟨48, by native_decide⟩
    ∃ (post pre : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p))),
      GHL2025.BandedSparseAccessPostSwapCleanup p source post pre ∧
        post.val =
          (GHL2025.bandedSparseAccessGlobalSlotInverseOnRangeContract p
            source.val).postSwapImageIndex ∧
        pre.val =
          (GHL2025.bandedSparseAccessGlobalSlotInverseOnRangeContract p
            source.val).candidatePreimageIndex ∧
        (GHL2025.oneTermRobinGate_O_D_BS_dagger p).matrix pre post =
          Coeff.rat 1 ∧
        (GHL2025.bandedSparseAccessGlobalSlotInverseOnRangeContract p
            source.val).daggerCleanup.proved = false ∧
        (GHL2025.bandedSparseAccessGlobalSlotInverseOnRangeContract p
            source.val).unitaryExtension.proved = false := by
  let p : GHL2025.OneTermRobinParameters :=
    { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
  let source : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
    ⟨48, by native_decide⟩
  have h :=
    GHL2025.bandedSparseAccessGlobalSlotInverseOnRangeContract_daggerCleanupBridge
      p source (by native_decide) rfl (by native_decide) (by native_decide)
  rcases h with
    ⟨post, pre, hcleanup, hpost, hpre, hentry, _hchecks, hdaggerFlag,
      hunitaryFlag⟩
  exact ⟨post, pre, hcleanup, hpost, hpre, hentry, hdaggerFlag, hunitaryFlag⟩

example (p : GHL2025.OneTermRobinParameters)
    (source : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)))
    (hn : 3 ≤ p.n) (hkappa : p.kappa = 7) (hκbits : clog2 p.kappa = 3)
    (hsource : GHL2025.bandedSparseAccessPaperGlobalSlotSource p source.val = true) :
    ∃ (post pre : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p))),
      GHL2025.BandedSparseAccessPostSwapCleanup p source post pre ∧
        post.val =
          (GHL2025.bandedSparseAccessGlobalSlotInverseOnRangeContract p
            source.val).postSwapImageIndex ∧
        pre.val =
          (GHL2025.bandedSparseAccessGlobalSlotInverseOnRangeContract p
            source.val).candidatePreimageIndex ∧
        GHL2025.bandedSparseAccessPaperGlobalSlotSource p pre.val = true ∧
        (∀ (pre' : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p))),
          GHL2025.bandedSparseAccessPaperGlobalSlotSource p pre'.val = true →
          GHL2025.bandedSparseAccessPaperImage p pre'.val = post.val →
          pre'.val = pre.val) ∧
        (GHL2025.oneTermRobinGate_O_D_BS_dagger p).matrix pre post =
          Coeff.rat 1 ∧
        (GHL2025.bandedSparseAccessGlobalSlotInverseOnRangeContract p
            source.val).candidateChecks = true ∧
        (GHL2025.bandedSparseAccessGlobalSlotInverseOnRangeContract p
            source.val).inverseOnRange.proved = false ∧
        (GHL2025.bandedSparseAccessGlobalSlotInverseOnRangeContract p
            source.val).uniquePreimage.proved = false ∧
        (GHL2025.bandedSparseAccessGlobalSlotInverseOnRangeContract p
            source.val).imageInjectiveOnGlobalSource.proved = false ∧
        (GHL2025.bandedSparseAccessGlobalSlotInverseOnRangeContract p
            source.val).daggerCleanup.proved = false ∧
        (GHL2025.bandedSparseAccessGlobalSlotInverseOnRangeContract p
            source.val).unitaryExtension.proved = false :=
  GHL2025.bandedSparseAccessGlobalSlotInverseOnRangeContract_cleanupContractMap
    p source hn hkappa hκbits hsource

example :
    let p : GHL2025.OneTermRobinParameters :=
      { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    let source : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
      ⟨48, by native_decide⟩
    ∃ (post pre : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p))),
      GHL2025.BandedSparseAccessPostSwapCleanup p source post pre ∧
        GHL2025.bandedSparseAccessPaperGlobalSlotSource p pre.val = true ∧
        (∀ (pre' : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p))),
          GHL2025.bandedSparseAccessPaperGlobalSlotSource p pre'.val = true →
          GHL2025.bandedSparseAccessPaperImage p pre'.val = post.val →
          pre'.val = pre.val) ∧
        (GHL2025.oneTermRobinGate_O_D_BS_dagger p).matrix pre post =
          Coeff.rat 1 ∧
        (GHL2025.bandedSparseAccessGlobalSlotInverseOnRangeContract p
            source.val).daggerCleanup.proved = false ∧
        (GHL2025.bandedSparseAccessGlobalSlotInverseOnRangeContract p
            source.val).unitaryExtension.proved = false := by
  let p : GHL2025.OneTermRobinParameters :=
    { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
  let source : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
    ⟨48, by native_decide⟩
  rcases
      GHL2025.bandedSparseAccessGlobalSlotInverseOnRangeContract_cleanupContractMap
        p source (by native_decide) rfl (by native_decide) (by native_decide)
      with
    ⟨post, pre, hcleanup, _hpost, _hpre, hpreSource, hunique, hentry,
      _hchecks, _hinverseFlag, _huniqueFlag, _himageFlag, hdaggerFlag,
      hunitaryFlag⟩
  exact ⟨post, pre, hcleanup, hpreSource, hunique, hentry, hdaggerFlag,
    hunitaryFlag⟩

example (p : GHL2025.OneTermRobinParameters)
    (source : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)))
    (hn : 3 ≤ p.n) (hkappa : p.kappa = 7) (hκbits : clog2 p.kappa = 3)
    (hsource : GHL2025.bandedSparseAccessPaperGlobalSlotSource p source.val = true) :
    ∃ (post pre : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p))),
      GHL2025.BandedSparseAccessPostSwapCleanup p source post pre ∧
        GHL2025.bandedSparseAccessPaperGlobalSlotSource p pre.val = true ∧
        (∀ (pre' : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p))),
          GHL2025.bandedSparseAccessPaperGlobalSlotSource p pre'.val = true →
          GHL2025.bandedSparseAccessPaperImage p pre'.val = post.val →
          pre'.val = pre.val) ∧
        (GHL2025.oneTermRobinGate_O_D_BS_dagger p).matrix pre post =
          Coeff.rat 1 ∧
        (GHL2025.defaultBandedSparseAccessPaperContract p).daggerCleanup.proved =
          false ∧
        (GHL2025.defaultBandedSparseAccessPaperContract p).unitaryExtension.proved =
          false ∧
        (GHL2025.oneTermRobinGate_O_D_BS p).unitary.proved = false ∧
        (GHL2025.oneTermRobinGate_O_D_BS_dagger p).unitary.proved = false := by
  rcases
      GHL2025.defaultBandedSparseAccessPaperContract_cleanupRouteBridge
        p source hn hkappa hκbits hsource
      with
    ⟨post, pre, hcleanup, _hpost, _hpre, hpreSource, hunique, hentry,
      hpaperCleanupFlag, hpaperUnitaryFlag, hforwardUnitaryFlag,
      hdaggerUnitaryFlag⟩
  exact ⟨post, pre, hcleanup, hpreSource, hunique, hentry,
    hpaperCleanupFlag, hpaperUnitaryFlag, hforwardUnitaryFlag,
    hdaggerUnitaryFlag⟩

example :
    let p : GHL2025.OneTermRobinParameters :=
      { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    let source : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
      ⟨48, by native_decide⟩
    ∃ (post pre : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p))),
      GHL2025.BandedSparseAccessPostSwapCleanup p source post pre ∧
        GHL2025.bandedSparseAccessPaperGlobalSlotSource p pre.val = true ∧
        (GHL2025.oneTermRobinGate_O_D_BS_dagger p).matrix pre post =
          Coeff.rat 1 ∧
        (GHL2025.defaultBandedSparseAccessPaperContract p).daggerCleanup.proved =
          false ∧
        (GHL2025.defaultBandedSparseAccessPaperContract p).unitaryExtension.proved =
          false ∧
        (GHL2025.oneTermRobinGate_O_D_BS p).unitary.proved = false ∧
        (GHL2025.oneTermRobinGate_O_D_BS_dagger p).unitary.proved = false := by
  let p : GHL2025.OneTermRobinParameters :=
    { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
  let source : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
    ⟨48, by native_decide⟩
  rcases
      GHL2025.defaultBandedSparseAccessPaperContract_cleanupRouteBridge
        p source (by native_decide) rfl (by native_decide) (by native_decide)
      with
    ⟨post, pre, hcleanup, _hpost, _hpre, hpreSource, _hunique, hentry,
      hpaperCleanupFlag, hpaperUnitaryFlag, hforwardUnitaryFlag,
      hdaggerUnitaryFlag⟩
  exact ⟨post, pre, hcleanup, hpreSource, hentry, hpaperCleanupFlag,
    hpaperUnitaryFlag, hforwardUnitaryFlag, hdaggerUnitaryFlag⟩

example :
    let p : GHL2025.OneTermRobinParameters :=
      { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    let source : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
      ⟨48, by native_decide⟩
    ∃ (post pre : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p))),
      GHL2025.BandedSparseAccessPostSwapCleanup p source post pre ∧
        GHL2025.bandedSparseAccessPaperGlobalSlotSource p source.val = true ∧
        GHL2025.bandedSparseAccessPaperValidCleanSource p source.val = false ∧
        GHL2025.bandedSparseAccessPaperGlobalSlotSource p pre.val = true ∧
        (GHL2025.oneTermRobinGate_O_D_BS_dagger p).matrix pre post =
          Coeff.rat 1 ∧
        (GHL2025.defaultBandedSparseAccessPaperContract p).daggerCleanup.proved =
          false ∧
        (GHL2025.defaultBandedSparseAccessPaperContract p).unitaryExtension.proved =
          false ∧
        (GHL2025.oneTermRobinGate_O_D_BS p).unitary.proved = false ∧
        (GHL2025.oneTermRobinGate_O_D_BS_dagger p).unitary.proved = false := by
  let p : GHL2025.OneTermRobinParameters :=
    { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
  let source : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
    ⟨48, by native_decide⟩
  rcases
      GHL2025.defaultBandedSparseAccessPaperContract_cleanupRouteBridge_boundaryColumn_n3
      with
    ⟨post, pre, hcleanup, _hpost, _hpre, hsource, hvalidRejected,
      hpreSource, _hunique, hentry, hpaperCleanupFlag, hpaperUnitaryFlag,
      hforwardUnitaryFlag, hdaggerUnitaryFlag⟩
  exact ⟨post, pre, hcleanup, hsource, hvalidRejected, hpreSource, hentry,
    hpaperCleanupFlag, hpaperUnitaryFlag, hforwardUnitaryFlag,
    hdaggerUnitaryFlag⟩

example (p : GHL2025.OneTermRobinParameters)
    (source other post : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)))
    (hn : 3 ≤ p.n) (hkappa : p.kappa = 7) (hκbits : clog2 p.kappa = 3)
    (hsource : GHL2025.bandedSparseAccessPaperGlobalSlotSource p source.val = true)
    (hotherSource : GHL2025.bandedSparseAccessPaperGlobalSlotSource p other.val = true)
    (hpost :
      post.val =
        (GHL2025.bandedSparseAccessGlobalSlotInverseOnRangeContract p
          source.val).postSwapImageIndex)
    (hne :
      other.val ≠
        (GHL2025.bandedSparseAccessGlobalSlotInverseOnRangeContract p
          source.val).candidatePreimageIndex) :
    (GHL2025.oneTermRobinGate_O_D_BS_dagger p).matrix other post =
        Coeff.rat 0 ∧
      (GHL2025.bandedSparseAccessGlobalSlotInverseOnRangeContract p
          source.val).daggerCleanup.proved = false ∧
      (GHL2025.bandedSparseAccessGlobalSlotInverseOnRangeContract p
          source.val).unitaryExtension.proved = false :=
  GHL2025.bandedSparseAccessGlobalSlotInverseOnRangeContract_daggerOffCandidate_zero
    p source other post hn hkappa hκbits hsource hotherSource hpost hne

example :
    let p : GHL2025.OneTermRobinParameters :=
      { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    let source : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
      ⟨48, by native_decide⟩
    let post : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
      ⟨(GHL2025.bandedSparseAccessGlobalSlotInverseOnRangeContract p
          source.val).postSwapImageIndex, by native_decide⟩
    (GHL2025.oneTermRobinGate_O_D_BS_dagger p).matrix source post =
        Coeff.rat 0 ∧
      (GHL2025.bandedSparseAccessGlobalSlotInverseOnRangeContract p
          source.val).daggerCleanup.proved = false ∧
      (GHL2025.bandedSparseAccessGlobalSlotInverseOnRangeContract p
          source.val).unitaryExtension.proved = false := by
  let p : GHL2025.OneTermRobinParameters :=
    { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
  let source : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
    ⟨48, by native_decide⟩
  let post : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
    ⟨(GHL2025.bandedSparseAccessGlobalSlotInverseOnRangeContract p
        source.val).postSwapImageIndex, by native_decide⟩
  exact
    GHL2025.bandedSparseAccessGlobalSlotInverseOnRangeContract_daggerOffCandidate_zero
      p source source post (by native_decide) rfl (by native_decide)
      (by native_decide) (by native_decide) rfl (by native_decide)

example (p : GHL2025.OneTermRobinParameters)
    (source : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)))
    (hn : 3 ≤ p.n) (hkappa : p.kappa = 7) (hκbits : clog2 p.kappa = 3)
    (hsource : GHL2025.bandedSparseAccessPaperGlobalSlotSource p source.val = true) :
    ∃ (post pre : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p))),
      GHL2025.BandedSparseAccessPostSwapCleanup p source post pre ∧
        (GHL2025.oneTermRobinGate_O_D_BS_dagger p).matrix pre post =
          Coeff.rat 1 ∧
        (∀ (other : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p))),
          GHL2025.bandedSparseAccessPaperGlobalSlotSource p other.val = true →
          other.val ≠ pre.val →
          (GHL2025.oneTermRobinGate_O_D_BS_dagger p).matrix other post =
            Coeff.rat 0) ∧
        (GHL2025.bandedSparseAccessGlobalSlotInverseOnRangeContract p
            source.val).daggerCleanup.proved = false ∧
        (GHL2025.bandedSparseAccessGlobalSlotInverseOnRangeContract p
            source.val).unitaryExtension.proved = false ∧
        (GHL2025.defaultBandedSparseAccessPaperContract p).daggerCleanup.proved =
          false ∧
        (GHL2025.defaultBandedSparseAccessPaperContract p).unitaryExtension.proved =
          false ∧
        (GHL2025.oneTermRobinGate_O_D_BS p).unitary.proved = false ∧
        (GHL2025.oneTermRobinGate_O_D_BS_dagger p).unitary.proved = false := by
  rcases
      GHL2025.bandedSparseAccessGlobalSlotInverseOnRangeContract_restrictedDaggerColumnCleanup
        p source hn hkappa hκbits hsource
      with
    ⟨post, pre, hcleanup, _hpost, _hpre, _hpreSource, hentry, hzero,
      hcontractCleanupFlag, hcontractUnitaryFlag, hpaperCleanupFlag,
      hpaperUnitaryFlag, hforwardUnitaryFlag, hdaggerUnitaryFlag,
      _htheoremCircuitFlag, _htheoremBlockFlag⟩
  exact ⟨post, pre, hcleanup, hentry, hzero, hcontractCleanupFlag,
    hcontractUnitaryFlag, hpaperCleanupFlag, hpaperUnitaryFlag,
    hforwardUnitaryFlag, hdaggerUnitaryFlag⟩

example :
    let p : GHL2025.OneTermRobinParameters :=
      { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    let source : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
      ⟨48, by native_decide⟩
    ∃ (post pre : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p))),
      GHL2025.BandedSparseAccessPostSwapCleanup p source post pre ∧
        (GHL2025.oneTermRobinGate_O_D_BS_dagger p).matrix pre post =
          Coeff.rat 1 ∧
        (∀ (other : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p))),
          GHL2025.bandedSparseAccessPaperGlobalSlotSource p other.val = true →
          other.val ≠ pre.val →
          (GHL2025.oneTermRobinGate_O_D_BS_dagger p).matrix other post =
            Coeff.rat 0) ∧
        (GHL2025.oneTermRobinGate_O_D_BS p).unitary.proved = false ∧
        (GHL2025.oneTermRobinGate_O_D_BS_dagger p).unitary.proved = false ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).blockClaim.target.blockProjection.proved =
          false ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).blockClaim.target.blockCorrect.proved =
          false ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).theoremData.obligations.circuitUnitary.proved =
          false ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).theoremData.obligations.blockExtraction.proved =
          false ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).oracleComposition.lcuCorrect.proved =
          false := by
  let p : GHL2025.OneTermRobinParameters :=
    { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
  let source : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
    ⟨48, by native_decide⟩
  rcases
      GHL2025.bandedSparseAccessGlobalSlotInverseOnRangeContract_restrictedDaggerColumnCleanup
        p source (by native_decide) rfl (by native_decide) (by native_decide)
      with
    ⟨post, pre, hcleanup, _hpost, _hpre, _hpreSource, hentry, hzero,
      _hcontractCleanupFlag, _hcontractUnitaryFlag, _hpaperCleanupFlag,
      _hpaperUnitaryFlag, hforwardUnitaryFlag, hdaggerUnitaryFlag,
      htheoremCircuitFlag, htheoremBlockFlag⟩
  rcases Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_flags_false 3 with
    ⟨hblockProjection, hblockCorrect, _hrouteBlockExtraction,
      _hrouteCircuitUnitary, _hrouteSparseCleanup, _hrouteSparseUnitary,
      _hscope, _hfullClean, _hfullSpace, _hpromotion, _hfunctionSource,
      _hfunctionAmp, hlcu⟩
  exact ⟨post, pre, hcleanup, hentry, hzero, hforwardUnitaryFlag,
    hdaggerUnitaryFlag, hblockProjection, hblockCorrect, htheoremCircuitFlag,
    htheoremBlockFlag, hlcu⟩

example (p : GHL2025.OneTermRobinParameters)
    (source : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)))
    (hn : 3 ≤ p.n) (hkappa : p.kappa = 7) (hκbits : clog2 p.kappa = 3)
    (hsource : GHL2025.bandedSparseAccessPaperGlobalSlotSource p source.val = true) :
    ∃ (post pre : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p))),
      GHL2025.BandedSparseAccessPostSwapCleanup p source post pre ∧
        (∀ (other : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p))),
          GHL2025.bandedSparseAccessPaperGlobalSlotSource p other.val = true →
          (GHL2025.oneTermRobinGate_O_D_BS_dagger p).matrix other post =
            if other.val = pre.val then Coeff.rat 1 else Coeff.rat 0) ∧
        (GHL2025.bandedSparseAccessGlobalSlotInverseOnRangeContract p
            source.val).inverseOnRange.proved = false ∧
        (GHL2025.bandedSparseAccessGlobalSlotInverseOnRangeContract p
            source.val).uniquePreimage.proved = false ∧
        (GHL2025.bandedSparseAccessGlobalSlotInverseOnRangeContract p
            source.val).imageInjectiveOnGlobalSource.proved = false ∧
        (GHL2025.bandedSparseAccessGlobalSlotInverseOnRangeContract p
            source.val).daggerCleanup.proved = false ∧
        (GHL2025.bandedSparseAccessGlobalSlotInverseOnRangeContract p
            source.val).unitaryExtension.proved = false ∧
        (GHL2025.oneTermRobinGate_O_D_BS p).unitary.proved = false ∧
        (GHL2025.oneTermRobinGate_O_D_BS_dagger p).unitary.proved = false := by
  rcases
      GHL2025.bandedSparseAccessGlobalSlotInverseOnRangeContract_restrictedDaggerColumnIndicator
        p source hn hkappa hκbits hsource
      with
    ⟨post, pre, hcleanup, _hpost, _hpre, _hpreSource, hindicator,
      hinverseFlag, huniqueFlag, himageFlag, hcontractCleanupFlag,
      hcontractUnitaryFlag, _hpaperCleanupFlag, _hpaperUnitaryFlag,
      hforwardUnitaryFlag, hdaggerUnitaryFlag, _htheoremCircuitFlag,
      _htheoremBlockFlag⟩
  exact ⟨post, pre, hcleanup, hindicator, hinverseFlag, huniqueFlag,
    himageFlag, hcontractCleanupFlag, hcontractUnitaryFlag,
    hforwardUnitaryFlag, hdaggerUnitaryFlag⟩

example :
    let p : GHL2025.OneTermRobinParameters :=
      { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    let source : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
      ⟨48, by native_decide⟩
    ∃ (post pre : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p))),
      GHL2025.BandedSparseAccessPostSwapCleanup p source post pre ∧
        (∀ (other : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p))),
          GHL2025.bandedSparseAccessPaperGlobalSlotSource p other.val = true →
          (GHL2025.oneTermRobinGate_O_D_BS_dagger p).matrix other post =
            if other.val = pre.val then Coeff.rat 1 else Coeff.rat 0) ∧
        (GHL2025.oneTermRobinGate_O_D_BS p).unitary.proved = false ∧
        (GHL2025.oneTermRobinGate_O_D_BS_dagger p).unitary.proved = false ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).blockClaim.target.blockProjection.proved =
          false ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).blockClaim.target.blockCorrect.proved =
          false ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).theoremData.obligations.circuitUnitary.proved =
          false ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).theoremData.obligations.blockExtraction.proved =
          false ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).oracleComposition.lcuCorrect.proved =
          false := by
  let p : GHL2025.OneTermRobinParameters :=
    { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
  let source : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
    ⟨48, by native_decide⟩
  rcases
      GHL2025.bandedSparseAccessGlobalSlotInverseOnRangeContract_restrictedDaggerColumnIndicator
        p source (by native_decide) rfl (by native_decide) (by native_decide)
      with
    ⟨post, pre, hcleanup, _hpost, _hpre, _hpreSource, hindicator,
      _hinverseFlag, _huniqueFlag, _himageFlag, _hcontractCleanupFlag,
      _hcontractUnitaryFlag, _hpaperCleanupFlag, _hpaperUnitaryFlag,
      hforwardUnitaryFlag, hdaggerUnitaryFlag, htheoremCircuitFlag,
      htheoremBlockFlag⟩
  rcases Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_flags_false 3 with
    ⟨hblockProjection, hblockCorrect, _hrouteBlockExtraction,
      _hrouteCircuitUnitary, _hrouteSparseCleanup, _hrouteSparseUnitary,
      _hscope, _hfullClean, _hfullSpace, _hpromotion, _hfunctionSource,
      _hfunctionAmp, hlcu⟩
  exact ⟨post, pre, hcleanup, hindicator, hforwardUnitaryFlag,
    hdaggerUnitaryFlag, hblockProjection, hblockCorrect, htheoremCircuitFlag,
    htheoremBlockFlag, hlcu⟩

example (n : Nat)
    (source : Fin
      (qubitDim
        (GHL2025.oneTermRobinTotalQubits
          (Examples.RobinHeat.oneTermParameters n))))
    (hn : 3 <= n)
    (hsource : GHL2025.bandedSparseAccessPaperGlobalSlotSource
      (Examples.RobinHeat.oneTermParameters n) source.val = true) :
    ∃ (post pre : Fin
        (qubitDim
          (GHL2025.oneTermRobinTotalQubits
            (Examples.RobinHeat.oneTermParameters n)))),
      GHL2025.BandedSparseAccessPostSwapCleanup
        (Examples.RobinHeat.oneTermParameters n) source post pre ∧
        (∀ (other : Fin
          (qubitDim
            (GHL2025.oneTermRobinTotalQubits
              (Examples.RobinHeat.oneTermParameters n)))),
          GHL2025.bandedSparseAccessPaperGlobalSlotSource
            (Examples.RobinHeat.oneTermParameters n) other.val = true →
          (GHL2025.oneTermRobinGate_O_D_BS_dagger
              (Examples.RobinHeat.oneTermParameters n)).matrix other post =
            if other.val = pre.val then Coeff.rat 1 else Coeff.rat 0) ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).sparseAccessContract.daggerCleanup.proved =
          false ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).sparseAccessContract.unitaryExtension.proved =
          false ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).blockClaim.target.blockCorrect.proved =
          false ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).oracleComposition.lcuCorrect.proved =
          false := by
  rcases
      Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_odbsRestrictedDaggerColumnIndicator
        n source hn hsource
      with
    ⟨post, pre, hcleanup, _hpost, _hpre, _hpreSource, hindicator,
      _hcontractIdentity, hcleanupOpen, hunitaryOpen, _hforwardUnitaryFlag,
      _hdaggerUnitaryFlag, _hcircuitUnitary, _hblockExtraction,
      _hblockProjection, hblockCorrect, hlcu, _hlowerBlocked⟩
  exact ⟨post, pre, hcleanup, hindicator, hcleanupOpen, hunitaryOpen,
    hblockCorrect, hlcu⟩

example :
    let p := Examples.RobinHeat.oneTermParameters 3
    let source : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
      ⟨48, by native_decide⟩
    ∃ (post pre : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p))),
      GHL2025.BandedSparseAccessPostSwapCleanup p source post pre ∧
        (∀ (other : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p))),
          GHL2025.bandedSparseAccessPaperGlobalSlotSource p other.val = true →
          (GHL2025.oneTermRobinGate_O_D_BS_dagger p).matrix other post =
            if other.val = pre.val then Coeff.rat 1 else Coeff.rat 0) ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).theoremData.obligations.circuitUnitary.proved =
          false ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).theoremData.obligations.blockExtraction.proved =
          false ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).blockClaim.target.blockProjection.proved =
          false ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).blockClaim.target.blockCorrect.proved =
          false ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).oracleComposition.lcuCorrect.proved =
          false ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).cleanupScopeDecision.semanticCleanupPromotionAllowed =
          false := by
  let p := Examples.RobinHeat.oneTermParameters 3
  let source : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
    ⟨48, by native_decide⟩
  rcases
      Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_odbsRestrictedDaggerColumnIndicator
        3 source (by native_decide) (by native_decide)
      with
    ⟨post, pre, hcleanup, _hpost, _hpre, _hpreSource, hindicator,
      _hcontractIdentity, _hcleanupOpen, _hunitaryOpen, _hforwardUnitaryFlag,
      _hdaggerUnitaryFlag, hcircuitUnitary, hblockExtraction,
      hblockProjection, hblockCorrect, hlcu, hpromotion⟩
  exact ⟨post, pre, hcleanup, hindicator, hcircuitUnitary, hblockExtraction,
    hblockProjection, hblockCorrect, hlcu, hpromotion⟩

example (p : GHL2025.OneTermRobinParameters) :
    (GHL2025.bandedSparseAccessCleanupScopeDecision p).selectedScope =
        GHL2025.BandedSparseAccessCleanupScope.activeGlobalSource ∧
      (GHL2025.bandedSparseAccessCleanupScopeDecision p).selectedPredicate =
        "bandedSparseAccessPaperGlobalSlotSource" ∧
      (GHL2025.bandedSparseAccessCleanupScopeDecision p).selectedEvidence =
        "bandedSparseAccessGlobalSlotInverseOnRangeContract_restrictedDaggerColumnIndicator" ∧
      (GHL2025.bandedSparseAccessCleanupScopeDecision p).fullCleanDomainSelected =
        false ∧
      (GHL2025.bandedSparseAccessCleanupScopeDecision p).fullSpaceSelected =
        false ∧
      (GHL2025.bandedSparseAccessCleanupScopeDecision p).semanticCleanupPromotionAllowed =
        false ∧
      (GHL2025.bandedSparseAccessCleanupScopeDecision p).paperContractCleanup.proved =
        false ∧
      (GHL2025.bandedSparseAccessCleanupScopeDecision p).fullCleanDomainCleanup.proved =
        false ∧
      (GHL2025.bandedSparseAccessCleanupScopeDecision p).fullSpaceUnitaryExtension.proved =
        false :=
  GHL2025.bandedSparseAccessCleanupScopeDecision_activeGlobalSource p

example (p : GHL2025.OneTermRobinParameters) :
    (GHL2025.bandedSparseAccessCleanupScopeDecision p).selectedScope =
        GHL2025.BandedSparseAccessCleanupScope.activeGlobalSource ∧
      (GHL2025.bandedSparseAccessCleanupScopeDecision p).fullSpaceSelected =
        false ∧
      (GHL2025.bandedSparseAccessCleanupScopeDecision p).fullSpaceUnitaryExtension.proved =
        false ∧
      GHL2025.bandedSparseAccessPriorPDESourceContract.oracleEquation =
        "O_A^BS |0>^(n-l)|s>^l|i>^n = |r_si>^n|i>^n" ∧
      GHL2025.bandedSparseAccessPriorPDESourceContract.resourceClaim.proved =
        false ∧
      GHL2025.bandedSparseAccessPriorPDESourceContract.robinUnusedBranchImageRule =
        none ∧
      GHL2025.bandedSparseAccessPriorPDESourceContract.closesUnusedZeroBranchExtension =
        false ∧
      GHL2025.bandedSparseAccessPriorPDESourceContract.lowerProofSearchAllowed =
        false ∧
      (GHL2025.defaultBandedSparseAccessPaperContract p).unitaryExtension.proved =
        false :=
  GHL2025.bandedSparseAccessCleanupScopeDecision_priorPDESourceTranscriptGuard p

example (p : GHL2025.OneTermRobinParameters) (j : Nat) :
    (GHL2025.bandedSparseAccessCleanupScopeDecision p).selectedScope =
        GHL2025.BandedSparseAccessCleanupScope.activeGlobalSource ∧
      (GHL2025.bandedSparseAccessCleanupScopeDecision p).fullCleanDomainSelected =
        false ∧
      (GHL2025.bandedSparseAccessCleanupScopeDecision p).semanticCleanupPromotionAllowed =
        false ∧
      (GHL2025.bandedSparseAccessCleanupScopeDecision p).fullCleanDomainCleanup.proved =
        false ∧
      GHL2025.bandedSparseAccessUnusedZeroBranchSourceDecision.lowerProofSearchAllowed =
        false ∧
      (GHL2025.bandedSparseAccessUnusedBranchImageRuleContract p j).proposedImageIndex =
        none ∧
      ((GHL2025.bandedSparseAccessFullCleanDomainExtensionContract p).unusedBranchImageRuleContract
        j).proposedImageIndex = none ∧
      ((GHL2025.bandedSparseAccessFullCleanDomainExtensionContract p).unusedBranchImageRuleContract
        j).imageSpecified.proved = false ∧
      (GHL2025.bandedSparseAccessFullCleanDomainExtensionContract p).unusedBranchImageSpecified.proved =
        false ∧
      (GHL2025.bandedSparseAccessFullCleanDomainExtensionContract p).fullCleanDomainInjective.proved =
        false ∧
      (GHL2025.bandedSparseAccessFullCleanDomainExtensionContract p).daggerCleanup.proved =
        false ∧
      (GHL2025.bandedSparseAccessFullCleanDomainExtensionContract p).unitaryExtension.proved =
        false :=
  GHL2025.bandedSparseAccessCleanupScopeDecision_fullCleanDomainImageRuleBlocked p j

example (n : Nat) :
    (GHL2025.bandedSparseAccessCleanupScopeDecision
        (Examples.RobinHeat.oneTermParameters n)).selectedScope =
        GHL2025.BandedSparseAccessCleanupScope.activeGlobalSource ∧
      (GHL2025.bandedSparseAccessCleanupScopeDecision
        (Examples.RobinHeat.oneTermParameters n)).fullCleanDomainSelected =
        false ∧
      (GHL2025.bandedSparseAccessCleanupScopeDecision
        (Examples.RobinHeat.oneTermParameters n)).fullSpaceSelected =
        false ∧
      (GHL2025.bandedSparseAccessCleanupScopeDecision
        (Examples.RobinHeat.oneTermParameters n)).semanticCleanupPromotionAllowed =
        false ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).sparseAccessContract.daggerCleanup.proved =
        false ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).sparseAccessContract.unitaryExtension.proved =
        false ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).blockClaim.target.blockCorrect.proved =
        false ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).oracleComposition.lcuCorrect.proved =
        false ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).cleanupScopeDecision.semanticCleanupPromotionAllowed =
        false := by
  rcases
      Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_odbsCleanupScopeDecision n
      with
    ⟨hscope, _hpredicate, _hevidence, hfullClean, hfullSpace, hpromotion,
      _hpaperCleanup, _hfullCleanCleanup, _hfullSpaceUnitary,
      _hcontractIdentity, hcleanupOpen, hunitaryOpen, hblockCorrect, hlcu,
      hpromotionRoute⟩
  exact ⟨hscope, hfullClean, hfullSpace, hpromotion, hcleanupOpen,
    hunitaryOpen, hblockCorrect, hlcu, hpromotionRoute⟩

example (n j : Nat) :
    (GHL2025.bandedSparseAccessCleanupScopeDecision
        (Examples.RobinHeat.oneTermParameters n)).selectedScope =
        GHL2025.BandedSparseAccessCleanupScope.activeGlobalSource ∧
      (GHL2025.bandedSparseAccessCleanupScopeDecision
        (Examples.RobinHeat.oneTermParameters n)).fullCleanDomainSelected =
        false ∧
      (GHL2025.bandedSparseAccessCleanupScopeDecision
        (Examples.RobinHeat.oneTermParameters n)).semanticCleanupPromotionAllowed =
        false ∧
      ((GHL2025.bandedSparseAccessFullCleanDomainExtensionContract
        (Examples.RobinHeat.oneTermParameters n)).unusedBranchImageRuleContract
        j).proposedImageIndex = none ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).cleanupScopeDecision.semanticCleanupPromotionAllowed =
        false ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).sparseAccessContract.daggerCleanup.proved =
        false ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).sparseAccessContract.unitaryExtension.proved =
        false ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).blockClaim.target.blockCorrect.proved =
        false ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).oracleComposition.lcuCorrect.proved =
        false := by
  rcases
      Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_odbsFullCleanDomainImageRuleBlocked
        n j
      with
    ⟨hscope, hfullClean, hpromotion, _hfullCleanCleanup, hwrappedSlot,
      _hwrappedImage, _hunusedImage, _hfullCleanInjective, _hwrapperCleanup,
      _hwrapperUnitary, hpromotionRoute, hcleanupOpen, hunitaryOpen,
      hblockCorrect, hlcu⟩
  exact ⟨hscope, hfullClean, hpromotion, hwrappedSlot, hpromotionRoute,
    hcleanupOpen, hunitaryOpen, hblockCorrect, hlcu⟩

example :
    let p := Examples.RobinHeat.oneTermParameters 3
    let source : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
      ⟨48, by native_decide⟩
    ∃ (post pre : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p))),
      GHL2025.BandedSparseAccessPostSwapCleanup p source post pre ∧
        (∀ (other : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p))),
          GHL2025.bandedSparseAccessPaperGlobalSlotSource p other.val = true →
          (GHL2025.oneTermRobinGate_O_D_BS_dagger p).matrix other post =
            if other.val = pre.val then Coeff.rat 1 else Coeff.rat 0) ∧
        (GHL2025.bandedSparseAccessCleanupScopeDecision p).selectedScope =
          GHL2025.BandedSparseAccessCleanupScope.activeGlobalSource ∧
        (GHL2025.bandedSparseAccessCleanupScopeDecision p).selectedPredicate =
          "bandedSparseAccessPaperGlobalSlotSource" ∧
        (GHL2025.bandedSparseAccessCleanupScopeDecision p).selectedEvidence =
          "bandedSparseAccessGlobalSlotInverseOnRangeContract_restrictedDaggerColumnIndicator" ∧
        (GHL2025.bandedSparseAccessCleanupScopeDecision p).semanticCleanupPromotionAllowed =
          false ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).sparseAccessContract.daggerCleanup.proved =
          false ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).sparseAccessContract.unitaryExtension.proved =
          false ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).theoremData.obligations.circuitUnitary.proved =
          false ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).theoremData.obligations.blockExtraction.proved =
          false ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).blockClaim.target.blockProjection.proved =
          false ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).blockClaim.target.blockCorrect.proved =
          false ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).oracleComposition.lcuCorrect.proved =
          false ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).cleanupScopeDecision.semanticCleanupPromotionAllowed =
          false := by
  let p := Examples.RobinHeat.oneTermParameters 3
  let source : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
    ⟨48, by native_decide⟩
  rcases
      Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_odbsActiveGlobalSourceCleanupInterface
        3 source (by native_decide) (by native_decide)
      with
    ⟨post, pre, hcleanup, _hpost, _hpre, _hpreSource, hindicator,
      hscope, hpredicate, hevidence, hpromotion, _hfullClean, _hfullSpace,
      hcleanupOpen, hunitaryOpen, _hforwardUnitary, _hdaggerUnitary,
      hcircuitUnitary, hblockExtraction, hblockProjection, hblockCorrect,
      hlcu, hpromotionRoute⟩
  exact ⟨post, pre, hcleanup, hindicator, hscope, hpredicate, hevidence,
    hpromotion, hcleanupOpen, hunitaryOpen, hcircuitUnitary, hblockExtraction,
    hblockProjection, hblockCorrect, hlcu, hpromotionRoute⟩

example :
    let p : GHL2025.OneTermRobinParameters :=
      { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    let source : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
      ⟨8, by native_decide⟩
    GHL2025.bandedSparseAccessPaperValidCleanSource p source.val = true ∧
      (GHL2025.oneTermRobinGate_O_D_BS_dagger p).matrix
        ⟨GHL2025.bandedSparseAccessPaperPostSwapPreimageCandidate p source.val,
          by native_decide⟩
        ⟨GHL2025.swapOracleImage p
            (GHL2025.bandedSparseAccessPaperImage p source.val),
          by native_decide⟩ = Coeff.rat 1 := by
  let p : GHL2025.OneTermRobinParameters :=
    { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
  let source : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
    ⟨8, by native_decide⟩
  constructor
  · native_decide
  · let witness :=
      GHL2025.bandedSparseAccessPostSwapCleanup_of_validCleanSourceCandidate_noRange
        p source (by native_decide) rfl (by native_decide) (by native_decide)
    exact witness.daggerEntry

example :
    let p : GHL2025.OneTermRobinParameters :=
      { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    let source : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
      ⟨8, by native_decide⟩
    GHL2025.swapOracleImage p
        (GHL2025.bandedSparseAccessPaperImage p source.val) <
        qubitDim (GHL2025.oneTermRobinTotalQubits p) ∧
      GHL2025.bandedSparseAccessPaperPostSwapPreimageCandidate p source.val <
        qubitDim (GHL2025.oneTermRobinTotalQubits p) := by
  let p : GHL2025.OneTermRobinParameters :=
    { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
  let source : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
    ⟨8, by native_decide⟩
  constructor
  · have haddr : GHL2025.bandedSparseAccessPaperAddress p source.val < (1 <<< p.n) := by
      native_decide
    exact GHL2025.bandedSparseAccessPaperPostSwapImage_lt_qubitDim_of_address_lt
      p source haddr
  · exact
      GHL2025.bandedSparseAccessPaperPostSwapPreimageCandidate_lt_qubitDim_of_cleanSource
        p source (by native_decide) rfl (by native_decide) (by native_decide)

example :
    let p : GHL2025.OneTermRobinParameters :=
      { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    let source : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
      ⟨8, by native_decide⟩
    (GHL2025.oneTermRobinGate_O_D_BS_dagger p).matrix
        ⟨GHL2025.bandedSparseAccessPaperPostSwapPreimageCandidate p source.val,
          by native_decide⟩
        ⟨GHL2025.swapOracleImage p
            (GHL2025.bandedSparseAccessPaperImage p source.val),
          by native_decide⟩ = Coeff.rat 1 ∧
      GHL2025.bandedSparseAccessPaperCleanInput p
        (GHL2025.bandedSparseAccessPaperPostSwapPreimageCandidate p source.val) =
          true := by
  let p : GHL2025.OneTermRobinParameters :=
    { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
  let source : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
    ⟨8, by native_decide⟩
  let witness :=
    GHL2025.bandedSparseAccessPostSwapCleanup_of_cleanSourceCandidate
      p source (by native_decide) rfl (by native_decide) (by native_decide)
      (by native_decide) (by native_decide)
  exact ⟨witness.daggerEntry, witness.preCleanInput⟩

example (p : GHL2025.OneTermRobinParameters) (j : Nat) :
    let n := p.n
    let blockMask := (1 <<< n) - 1
    ((GHL2025.swapOracleImage p j) >>> (1 + n)) &&& blockMask =
      (j >>> 1) &&& blockMask :=
  GHL2025.swapOracleImage_block2_eq_block1 p j

example (p : GHL2025.OneTermRobinParameters) (j : Nat)
    (haddr : GHL2025.bandedSparseAccessPaperAddress p j < (1 <<< p.n)) :
    (GHL2025.bandedSparseAccessPaperRegisters p
      (GHL2025.swapOracleImage p (GHL2025.bandedSparseAccessPaperImage p j))).rowValue =
      GHL2025.bandedSparseAccessPaperAddress p j :=
  GHL2025.bandedSparseAccessPaperPostSwap_rowValue_eq_address p j haddr

example (p : GHL2025.OneTermRobinParameters) (j : Nat) :
    (GHL2025.bandedSparseAccessPaperRegisters p
      (GHL2025.swapOracleImage p (GHL2025.bandedSparseAccessPaperImage p j))).odRegisterValue =
      (GHL2025.bandedSparseAccessPaperRegisters p j).rowValue :=
  GHL2025.bandedSparseAccessPaperPostSwap_odRegisterValue_eq_rowValue p j

example :
    let p : GHL2025.OneTermRobinParameters :=
      { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.bandedSparseAccessPaperRegisters p
      (GHL2025.swapOracleImage p (GHL2025.bandedSparseAccessPaperImage p 8))).rowValue = 2 ∧
      (GHL2025.bandedSparseAccessPaperRegisters p
        (GHL2025.swapOracleImage p (GHL2025.bandedSparseAccessPaperImage p 8))).odRegisterValue = 4 := by
  native_decide

-- O_D^BS paper-contract obligations remain unproved.
example (p : GHL2025.OneTermRobinParameters) :
    (GHL2025.defaultBandedSparseAccessPaperContract p).widthCompatible.proved = false := rfl

example (p : GHL2025.OneTermRobinParameters) :
    (GHL2025.defaultBandedSparseAccessPaperContract p).cleanInputDomain.proved = false := rfl

example (p : GHL2025.OneTermRobinParameters) :
    (GHL2025.defaultBandedSparseAccessPaperContract p).forwardCorrect.proved = false := rfl

example (p : GHL2025.OneTermRobinParameters) :
    (GHL2025.defaultBandedSparseAccessPaperContract p).daggerCleanup.proved = false := rfl

example (p : GHL2025.OneTermRobinParameters) :
    (GHL2025.defaultBandedSparseAccessPaperContract p).unitaryExtension.proved = false := rfl

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

-- Global sparse-slot source: slot 2 is the active diagonal slot for boundary row 0.
example :
    GHL2025.robinGlobalSparseAmplitudeValue 3 2 0 =
      Coeff.add (Coeff.rat ((-5 : Rat) / 2))
        (Coeff.mul (Coeff.rat ((7 : Rat) / 3)) (Coeff.symbol "A1*dx")) :=
  GHL2025.robinGlobalSparseAmplitudeValue_boundarySlot2_row0_n3

-- The same global slot differs from the old row-local slot numbering.
example :
    GHL2025.robinGlobalSparseAmplitudeValue 3 2 0 ≠
      GHL2025.robinSparseAmplitudeValue 3 2 0 :=
  GHL2025.robinGlobalSparseAmplitudeValue_boundarySlot2_differs_rowLocal_n3

-- Matrix coherence for the focused boundary packet: global slot 2 maps to column 0.
example :
    GHL2025.robinGlobalSparseAmplitudeValue 3 2 0 =
    (Examples.RobinHeat.robinDerivativeMatrix 3)
      ⟨0, by native_decide⟩
      ⟨GHL2025.oneTermRobinGlobalSparseAddress 3 2 0, by native_decide⟩ := by
  native_decide

example :
    let p : GHL2025.OneTermRobinParameters :=
      { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.derivativeNormalizerNDSourceBound p 0 2).sourceCoefficient =
      GHL2025.robinGlobalSparseAmplitudeValue 3 2 0 ∧
    (GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute p 0 2).coefficient =
      GHL2025.robinGlobalSparseAmplitudeValue 3 2 0 ∧
    (GHL2025.boundaryRotationAngleNormalizerProofRoute p 0 2).coefficient =
      GHL2025.robinGlobalSparseAmplitudeValue 3 2 0 ∧
    (GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute p 0 2).coefficient =
      (GHL2025.boundaryRotationAngleNormalizerProofRoute p 0 2).coefficient := by
  exact GHL2025.robinGlobalSparseAmplitudeValue_sharedNormalizerRoutes
    { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 } 0 2

example :
    let p : GHL2025.OneTermRobinParameters :=
      { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.derivativeNormalizerNDContract p 0 2).coefficientBound.proved = false ∧
      (GHL2025.boundaryRotationAngleNormalizerProofRoute p 0 2).normalizerBound.proved =
        false :=
  by native_decide

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

-- O_f active gate matrix is the paper-image matrix skeleton.
example (p : GHL2025.OneTermRobinParameters) :
    (GHL2025.oneTermRobinGate_O_f p).matrix =
      GHL2025.functionOraclePaperMatrix p := rfl

-- O_f paper-register source contract: clean workspace, system value 2.
example :
    let p : GHL2025.OneTermRobinParameters := { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.functionOraclePaperRegisters p 36).systemValue = 2 := by
  native_decide

example :
    let p : GHL2025.OneTermRobinParameters := { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.functionOraclePaperRegisters p 36).mfWorkspaceValue = 0 := by
  native_decide

example :
    let p : GHL2025.OneTermRobinParameters := { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.functionOraclePaperRegisters p 36).nonMFValue = 36 := by
  native_decide

example :
    let p : GHL2025.OneTermRobinParameters := { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.functionOraclePaperRegisters p 36).cleanWorkspace = true := by
  native_decide

-- The mf workspace starts immediately above the indicator bit.
example :
    let p : GHL2025.OneTermRobinParameters := { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.functionOraclePaperRegisters p ((3 <<< (GHL2025.robinIndicatorBitPosition p + 1)) + 4)).mfWorkspaceValue = 3 := by
  native_decide

-- O_f normalized clean-branch amplitude records f(x_i) times the reciprocal symbol for N_f.
example :
    let p : GHL2025.OneTermRobinParameters := { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    GHL2025.functionOracleNormalizedValue p 2 =
      Coeff.mul (Coeff.symbol "f_3_2") (Coeff.symbol "N_f_inv") := by
  native_decide

example :
    let p : GHL2025.OneTermRobinParameters := { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.functionOraclePaperImage p 36).cleanBranchSystemValue = 2 := by
  native_decide

example :
    let p : GHL2025.OneTermRobinParameters := { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.functionOraclePaperImage p 36).cleanBranchBasisIndex = 36 := by
  native_decide

example :
    let p : GHL2025.OneTermRobinParameters := { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.functionOraclePaperImage p 36).cleanBranchWorkspaceValue = 0 := by
  native_decide

example :
    let p : GHL2025.OneTermRobinParameters := { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.functionOraclePaperImage p 36).cleanBranchAmplitude =
      Coeff.mul (Coeff.symbol "f_3_2") (Coeff.symbol "N_f_inv") := by
  native_decide

example :
    let p : GHL2025.OneTermRobinParameters := { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.functionOraclePaperImage p 36).systemPreserved = true := by
  native_decide

example :
    let p : GHL2025.OneTermRobinParameters := { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.functionOraclePaperImage p 36).cleanWorkspaceBranch = true := by
  native_decide

-- O_f paper-image bridge lemmas expose the definitional link to the extractor.
example (p : GHL2025.OneTermRobinParameters) (j : Nat) :
    (GHL2025.functionOraclePaperImage p j).inputRegisters =
      GHL2025.functionOraclePaperRegisters p j :=
  GHL2025.functionOraclePaperImage_inputRegisters_eq p j

example (p : GHL2025.OneTermRobinParameters) (j : Nat) :
    (GHL2025.functionOraclePaperImage p j).cleanBranchBasisIndex =
      (GHL2025.functionOraclePaperRegisters p j).nonMFValue :=
  GHL2025.functionOraclePaperImage_cleanBranchBasisIndex_eq p j

example (p : GHL2025.OneTermRobinParameters) (j : Nat) :
    (GHL2025.functionOraclePaperImage p j).cleanBranchSystemValue =
      (GHL2025.functionOraclePaperRegisters p j).systemValue :=
  GHL2025.functionOraclePaperImage_cleanBranchSystemValue_eq p j

example (p : GHL2025.OneTermRobinParameters) (j : Nat) :
    (GHL2025.functionOraclePaperImage p j).cleanBranchWorkspaceValue = 0 :=
  GHL2025.functionOraclePaperImage_cleanBranchWorkspaceValue_eq p j

example (p : GHL2025.OneTermRobinParameters) (j : Nat) :
    (GHL2025.functionOraclePaperImage p j).cleanBranchAmplitude =
      GHL2025.functionOracleNormalizedValue p
        (GHL2025.functionOraclePaperRegisters p j).systemValue :=
  GHL2025.functionOraclePaperImage_cleanBranchAmplitude_eq p j

example (p : GHL2025.OneTermRobinParameters) (j : Nat) :
    (GHL2025.functionOraclePaperImage p j).cleanWorkspaceBranch =
      (GHL2025.functionOraclePaperRegisters p j).cleanWorkspace :=
  GHL2025.functionOraclePaperImage_cleanWorkspaceBranch_eq p j

-- O_f paper-image obligations remain unproved.
example (p : GHL2025.OneTermRobinParameters) (j : Nat) :
    (GHL2025.functionOraclePaperImage p j).normalizedAmplitudeCorrect.proved = false := rfl

example (p : GHL2025.OneTermRobinParameters) (j : Nat) :
    (GHL2025.functionOraclePaperImage p j).orthogonalComponentCorrect.proved = false := rfl

example (p : GHL2025.OneTermRobinParameters) (j : Nat) :
    (GHL2025.functionOraclePaperImage p j).normalizerBound.proved = false := rfl

example (p : GHL2025.OneTermRobinParameters) (j : Nat) :
    (GHL2025.functionOraclePaperImage p j).unitaryCompletion.proved = false := rfl

example (p : GHL2025.OneTermRobinParameters) (j : Nat) :
    (GHL2025.functionOraclePaperImage p j).diagonalHelperIsolation.proved = false := rfl

-- O_f paper matrix: the clean branch exposes f(x_i) / N_f.
example :
    let p : GHL2025.OneTermRobinParameters := { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.functionOraclePaperMatrix p)
      ⟨36, by native_decide⟩ ⟨36, by native_decide⟩ =
    Coeff.mul (Coeff.symbol "f_3_2") (Coeff.symbol "N_f_inv") := by
  native_decide

-- O_f active gate exposes the same clean-branch amplitude.
example :
    let p : GHL2025.OneTermRobinParameters := { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.oneTermRobinGate_O_f p).matrix
      ⟨36, by native_decide⟩ ⟨36, by native_decide⟩ =
    Coeff.mul (Coeff.symbol "f_3_2") (Coeff.symbol "N_f_inv") := by
  native_decide

-- O_f paper matrix: clean-workspace rows outside the branch have zero
-- orthogonal-completion entry.
example :
    let p : GHL2025.OneTermRobinParameters := { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.functionOraclePaperMatrix p)
      ⟨4, by native_decide⟩ ⟨36, by native_decide⟩ =
    Coeff.rat 0 := by
  native_decide

-- O_f paper matrix: non-clean rows carry symbolic orthogonal-completion data.
example :
    let p : GHL2025.OneTermRobinParameters := { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.functionOraclePaperMatrix p)
      ⟨772, by native_decide⟩ ⟨36, by native_decide⟩ =
    Coeff.symbol "orth_f_entry_3_2_772_36" := by
  native_decide

-- O_f paper matrix: non-clean input columns stay symbolic even at the clean
-- branch basis row for the same non-mf index.
example :
    let p : GHL2025.OneTermRobinParameters := { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.functionOraclePaperMatrix p)
      ⟨4, by native_decide⟩ ⟨772, by native_decide⟩ =
    Coeff.symbol "orth_f_entry_3_2_4_772" := by
  native_decide

-- O_f paper matrix bridge lemmas pin the clean branch, clean-workspace zero
-- rule, and non-clean input symbolic branch.
example (p : GHL2025.OneTermRobinParameters)
    (i j : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)))
    (hClean : (GHL2025.functionOraclePaperImage p j.val).cleanWorkspaceBranch = true)
    (h : i.val = (GHL2025.functionOraclePaperImage p j.val).cleanBranchBasisIndex) :
    GHL2025.functionOraclePaperMatrix p i j =
      (GHL2025.functionOraclePaperImage p j.val).cleanBranchAmplitude :=
  GHL2025.functionOraclePaperMatrix_cleanBranch_entry p i j hClean h

example (p : GHL2025.OneTermRobinParameters)
    (i j : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)))
    (hInputClean : (GHL2025.functionOraclePaperImage p j.val).cleanWorkspaceBranch = true)
    (hBranch : i.val ≠ (GHL2025.functionOraclePaperImage p j.val).cleanBranchBasisIndex)
    (hClean : (GHL2025.functionOraclePaperRegisters p i.val).mfWorkspaceValue = 0) :
    GHL2025.functionOraclePaperMatrix p i j = Coeff.rat 0 :=
  GHL2025.functionOraclePaperMatrix_cleanWorkspace_offBranch_zero p i j hInputClean hBranch hClean

example (p : GHL2025.OneTermRobinParameters)
    (i j : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)))
    (hInputNonClean : (GHL2025.functionOraclePaperImage p j.val).cleanWorkspaceBranch = false) :
    GHL2025.functionOraclePaperMatrix p i j =
      GHL2025.functionOracleOrthogonalEntry p
        (GHL2025.functionOraclePaperImage p j.val).cleanBranchSystemValue i.val j.val :=
  GHL2025.functionOraclePaperMatrix_nonCleanInput_entry p i j hInputNonClean

-- O_f legacy data helper: every diagonal entry is the function value at the
-- extracted system grid index, not sparse-amplitude data.
example (p : GHL2025.OneTermRobinParameters)
    (j : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p))) :
    (GHL2025.functionOracleMatrix p) j j =
      GHL2025.robinFunctionValue p.n
        ((j.val >>> 1) &&& ((1 <<< p.n) - 1)) := by
  simp [GHL2025.functionOracleMatrix]

-- O_f remains diagonal for all parameters.
example (p : GHL2025.OneTermRobinParameters)
    (i j : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)))
    (h : i.val ≠ j.val) :
    (GHL2025.functionOracleMatrix p) i j = Coeff.rat 0 := by
  simp [GHL2025.functionOracleMatrix, h]

-- O_f paper contract: normalizer is N_f and amplitude correctness is unproved.
example (n : Nat) :
    (Examples.RobinHeat.robinOracleComposition n).functionOracle.normalizerBound =
      Coeff.symbol "N_f" := rfl

example (n : Nat) :
    (Examples.RobinHeat.robinOracleComposition n).functionOracle.amplitudeCorrect.proved =
      false := rfl

-- O_f external amplitude source contract: GL2024 Theorem 5 is recorded as a
-- source transcript only, not as a proof of the analytic O_f obligations.
example :
    GHL2025.functionOracleExternalAmplitudeSourceContract.sourceAnchor =
      "GHL2025 Theorem 'Amplitude-oracle for piece-wise polynomial function' and Eq. 'coordinate oracle', arXiv:2506.20478; cited source arXiv:2411.01131" :=
  GHL2025.functionOracleExternalAmplitudeSourceContract_sourceAnchor

example :
    GHL2025.functionOracleExternalAmplitudeSourceContract.normalizerNf =
      Coeff.symbol "N_f" := rfl

example :
    GHL2025.functionOracleExternalAmplitudeSourceContract.resourceClaim.proved = false ∧
      GHL2025.functionOracleExternalAmplitudeSourceContract.externalTheoremFormalized.proved = false ∧
      GHL2025.functionOracleExternalAmplitudeSourceContract.nonzeroNormalizer.proved = false ∧
      GHL2025.functionOracleExternalAmplitudeSourceContract.divisionSemantics.proved = false ∧
      GHL2025.functionOracleExternalAmplitudeSourceContract.theoremAmplitudeCorrect.proved = false ∧
      GHL2025.functionOracleExternalAmplitudeSourceContract.closesNormalizerBound = false ∧
      GHL2025.functionOracleExternalAmplitudeSourceContract.closesOrthogonalCompletion = false ∧
      GHL2025.functionOracleExternalAmplitudeSourceContract.closesUnitaryCompletion = false ∧
      GHL2025.functionOracleExternalAmplitudeSourceContract.closesFunctionOracleContract = false :=
  GHL2025.functionOracleExternalAmplitudeSourceContract_flags_false

-- O_f amplitude route: the clean-branch amplitude and N_f contract are only
-- packaged, not proved.
example (p : GHL2025.OneTermRobinParameters) (j : Nat) :
    (GHL2025.functionOracleAmplitudeProofRoute p j).sourceAnchor =
      "GHL2025 Theorem 'Amplitude-oracle for piece-wise polynomial function' and Eq. 'coordinate oracle', arXiv:2506.20478; cited source arXiv:2411.01131" :=
  GHL2025.functionOracleAmplitudeProofRoute_sourceAnchor p j

example (p : GHL2025.OneTermRobinParameters) (j : Nat) :
    (GHL2025.functionOracleAmplitudeProofRoute p j).sourceFunctionValue =
      GHL2025.robinFunctionValue p.n
        (GHL2025.functionOraclePaperRegisters p j).systemValue :=
  GHL2025.functionOracleAmplitudeProofRoute_sourceFunctionValue p j

example (p : GHL2025.OneTermRobinParameters) (j : Nat) :
    (GHL2025.functionOracleAmplitudeProofRoute p j).normalizedAmplitude =
      GHL2025.functionOracleNormalizedValue p
        (GHL2025.functionOraclePaperRegisters p j).systemValue :=
  GHL2025.functionOracleAmplitudeProofRoute_normalizedAmplitude p j

example (p : GHL2025.OneTermRobinParameters) (j : Nat) :
    (GHL2025.functionOracleAmplitudeProofRoute p j).normalizerNf =
      Coeff.symbol "N_f" :=
  GHL2025.functionOracleAmplitudeProofRoute_normalizerNf p j

example (p : GHL2025.OneTermRobinParameters) (j : Nat) :
    (GHL2025.functionOracleAmplitudeProofRoute p j).cleanBranchAmplitude =
      (GHL2025.functionOraclePaperImage p j).cleanBranchAmplitude ∧
    (GHL2025.functionOracleAmplitudeProofRoute p j).cleanBranchBasisIndex =
      (GHL2025.functionOraclePaperImage p j).cleanBranchBasisIndex ∧
    (GHL2025.functionOracleAmplitudeProofRoute p j).cleanWorkspaceBranch =
      (GHL2025.functionOraclePaperImage p j).cleanWorkspaceBranch :=
  GHL2025.functionOracleAmplitudeProofRoute_paperImage p j

example (p : GHL2025.OneTermRobinParameters) (j : Nat) :
    (GHL2025.functionOracleAmplitudeProofRoute p j).normalizedAmplitudeCorrect =
      (GHL2025.functionOraclePaperImage p j).normalizedAmplitudeCorrect ∧
    (GHL2025.functionOracleAmplitudeProofRoute p j).normalizerBound =
      (GHL2025.functionOraclePaperImage p j).normalizerBound ∧
    (GHL2025.functionOracleAmplitudeProofRoute p j).orthogonalComponentCorrect =
      (GHL2025.functionOraclePaperImage p j).orthogonalComponentCorrect ∧
    (GHL2025.functionOracleAmplitudeProofRoute p j).unitaryCompletion =
      (GHL2025.functionOraclePaperImage p j).unitaryCompletion :=
  GHL2025.functionOracleAmplitudeProofRoute_obligations_reuse_paperImage p j

example (p : GHL2025.OneTermRobinParameters) (j : Nat) :
    (GHL2025.functionOracleAmplitudeProofRoute p j).sourceAnchor =
      GHL2025.functionOracleExternalAmplitudeSourceContract.sourceAnchor ∧
    (GHL2025.functionOracleAmplitudeProofRoute p j).normalizerNf =
      GHL2025.functionOracleExternalAmplitudeSourceContract.normalizerNf ∧
    (GHL2025.functionOracleAmplitudeProofRoute p j).normalizedAmplitudeFormula =
      GHL2025.functionOracleExternalAmplitudeSourceContract.cleanBranchFormula ∧
    (GHL2025.functionOracleAmplitudeProofRoute p j).nonzeroNormalizer =
      GHL2025.functionOracleExternalAmplitudeSourceContract.nonzeroNormalizer ∧
    (GHL2025.functionOracleAmplitudeProofRoute p j).divisionSemantics =
      GHL2025.functionOracleExternalAmplitudeSourceContract.divisionSemantics ∧
    (GHL2025.functionOracleAmplitudeProofRoute p j).theoremAmplitudeCorrect =
      GHL2025.functionOracleExternalAmplitudeSourceContract.theoremAmplitudeCorrect :=
  GHL2025.functionOracleAmplitudeProofRoute_externalSourceContract p j

example (p : GHL2025.OneTermRobinParameters) (j : Nat) :
    (GHL2025.functionOracleAmplitudeProofRoute p j).normalizedAmplitudeCorrect.proved = false ∧
    (GHL2025.functionOracleAmplitudeProofRoute p j).nonzeroNormalizer.proved = false ∧
    (GHL2025.functionOracleAmplitudeProofRoute p j).divisionSemantics.proved = false ∧
    (GHL2025.functionOracleAmplitudeProofRoute p j).normalizerBound.proved = false ∧
    (GHL2025.functionOracleAmplitudeProofRoute p j).orthogonalComponentCorrect.proved = false ∧
    (GHL2025.functionOracleAmplitudeProofRoute p j).unitaryCompletion.proved = false ∧
    (GHL2025.functionOracleAmplitudeProofRoute p j).theoremAmplitudeCorrect.proved = false :=
  GHL2025.functionOracleAmplitudeProofRoute_flags_false p j

-- Combined O_f source transcript guard: the cited theorem transcript and the
-- per-column amplitude route stay obligation-only.
example (p : GHL2025.OneTermRobinParameters) (j : Nat) :
    GHL2025.functionOracleExternalAmplitudeSourceContract.externalTheoremFormalized.proved =
      false :=
  (GHL2025.functionOracleAmplitudeProofRoute_externalSourceAndFlags p j).2.1.2.1

example (p : GHL2025.OneTermRobinParameters) (j : Nat) :
    (GHL2025.functionOracleAmplitudeProofRoute p j).theoremAmplitudeCorrect.proved =
      false := by
  rcases GHL2025.functionOracleAmplitudeProofRoute_externalSourceAndFlags p j with
    ⟨_, _, _, _, _, _, _, _, hTheoremAmplitude⟩
  exact hTheoremAmplitude

example (n : Nat) :
    (GHL2025.functionOracleAmplitudeProofRoute
        (Examples.RobinHeat.oneTermParameters n) 0).theoremNormalizer =
      (Examples.RobinHeat.robinOracleComposition n).functionOracle.normalizerBound := rfl

example :
    let p : GHL2025.OneTermRobinParameters := { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.functionOracleAmplitudeProofRoute p 36).sourceFunctionValue =
      Coeff.symbol "f_3_2" := by
  native_decide

example :
    let p : GHL2025.OneTermRobinParameters := { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.functionOracleAmplitudeProofRoute p 36).cleanBranchAmplitude =
      Coeff.mul (Coeff.symbol "f_3_2") (Coeff.symbol "N_f_inv") := by
  native_decide

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

-- O_DT^S coefficient-normalizer relation is an explicit paper obligation.
example :
    GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerObligation.proved = false := rfl

-- O_DT^S Eq. (20) coefficient-normalizer contract pins the symbolic rotation
-- entries to the sparse derivative coefficient and the N_D normalizer, without
-- proving the analytic identities.
example :
    let p : GHL2025.OneTermRobinParameters := { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerContract p 2 0).coefficient =
      Coeff.rat ((-1 : Rat) / 12) := by
  native_decide

example :
    let p : GHL2025.OneTermRobinParameters := { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerContract p 2 0).normalizerND =
      Coeff.symbol "N_D" := rfl

example :
    let p : GHL2025.OneTermRobinParameters := { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerContract p 2 0).ketZeroEntry =
      Coeff.symbol "odts_cos_half_2_0" := by
  native_decide

example :
    let p : GHL2025.OneTermRobinParameters := { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerContract p 2 0).ketOneEntry =
      Coeff.symbol "odts_sin_half_2_0" := by
  native_decide

example (p : GHL2025.OneTermRobinParameters) (row sparse : Nat) :
    (GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerContract p row sparse).coefficientRelation.proved =
      false := rfl

example (p : GHL2025.OneTermRobinParameters) (row sparse : Nat) :
    (GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerContract p row sparse).complementRelation.proved =
      false := rfl

example (p : GHL2025.OneTermRobinParameters) (row sparse : Nat) :
    (GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerContract p row sparse).twoByTwoUnitary.proved =
      false := rfl

-- O_DT^S Eq. (20) proof-route record separates the normalized coefficient
-- stand-in from the ND-bound, absolute-square, square-root complement, and
-- two-by-two-unitary obligations.  All proof flags remain false.
example :
    let p : GHL2025.OneTermRobinParameters := { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    GHL2025.sparseAmplitudeOracleDTNormalizedCoefficient p 2 0 =
      Coeff.mul (Coeff.rat ((-1 : Rat) / 12)) (Coeff.symbol "N_D_inv") := by
  native_decide

-- Shared N_D normalizer contract used by O_DT^S and Ry_boundary proof routes.
example :
    let p : GHL2025.OneTermRobinParameters := { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.derivativeNormalizerNDContract p 2 0).coefficient =
      Coeff.rat ((-1 : Rat) / 12) := by
  native_decide

example :
    let p : GHL2025.OneTermRobinParameters := { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.derivativeNormalizerNDContract p 2 0).normalizerND =
      Coeff.symbol "N_D" := rfl

example :
    let p : GHL2025.OneTermRobinParameters := { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.derivativeNormalizerNDContract p 2 0).normalizedCoefficient =
      Coeff.mul (Coeff.rat ((-1 : Rat) / 12)) (Coeff.symbol "N_D_inv") := by
  native_decide

example (p : GHL2025.OneTermRobinParameters) (row sparse : Nat) :
    (GHL2025.derivativeNormalizerNDContract p row sparse).nonzeroNormalizer.proved =
      false := rfl

example (p : GHL2025.OneTermRobinParameters) (row sparse : Nat) :
    (GHL2025.derivativeNormalizerNDContract p row sparse).divisionSemantics.proved =
      false := rfl

example (p : GHL2025.OneTermRobinParameters) (row sparse : Nat) :
    (GHL2025.derivativeNormalizerNDContract p row sparse).coefficientBound.proved =
      false := rfl

example (p : GHL2025.OneTermRobinParameters) (row sparse : Nat) :
    (GHL2025.derivativeNormalizerNDContract p row sparse).absSquareSemantics.proved =
      false := rfl

example (p : GHL2025.OneTermRobinParameters) (row sparse : Nat) :
    (GHL2025.derivativeNormalizerNDContract p row sparse).sqrtComplementSemantics.proved =
      false := rfl

example (p : GHL2025.OneTermRobinParameters) (row sparse : Nat) :
    (GHL2025.derivativeNormalizerNDContract p row sparse).arccosSemantics.proved =
      false := rfl

example (p : GHL2025.OneTermRobinParameters) (row sparse : Nat) :
    (GHL2025.derivativeNormalizerNDContract p row sparse).twoByTwoUnitary.proved =
      false := rfl

example :
    let p : GHL2025.OneTermRobinParameters := { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.derivativeNormalizerNDSourceBound p 2 0).sourceCoefficient =
      Coeff.rat ((-1 : Rat) / 12) := by
  native_decide

example :
    let p : GHL2025.OneTermRobinParameters := { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.derivativeNormalizerNDSourceBound p 2 0).normalizerND =
      Coeff.symbol "N_D" := rfl

example (p : GHL2025.OneTermRobinParameters) (row sparse : Nat) :
    (GHL2025.derivativeNormalizerNDSourceBound p row sparse).boundFormula =
      "|D_j^(s)| <= N_D" :=
  GHL2025.derivativeNormalizerNDSourceBound_boundFormula p row sparse

example (p : GHL2025.OneTermRobinParameters) (row sparse : Nat) :
    (GHL2025.derivativeNormalizerNDSourceBound p row sparse).coefficientBound =
      (GHL2025.derivativeNormalizerNDContract p row sparse).coefficientBound :=
  GHL2025.derivativeNormalizerNDSourceBound_coefficientBound p row sparse

example (p : GHL2025.OneTermRobinParameters) (row sparse : Nat) :
    (GHL2025.derivativeNormalizerNDSourceBound p row sparse).coefficientBound.proved =
      false :=
  GHL2025.derivativeNormalizerNDSourceBound_coefficientBound_false p row sparse

example (p : GHL2025.OneTermRobinParameters) (row sparse : Nat) :
    (GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute p row sparse).coefficient =
      (GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerContract p row sparse).coefficient :=
  GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute_coefficient
    p row sparse

example (p : GHL2025.OneTermRobinParameters) (row sparse : Nat) :
    (GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute p row sparse).normalizerND =
      (GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerContract p row sparse).normalizerND :=
  GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute_normalizerND
    p row sparse

example (p : GHL2025.OneTermRobinParameters) (row sparse : Nat) :
    (GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute p row sparse).normalizedCoefficient =
      GHL2025.sparseAmplitudeOracleDTNormalizedCoefficient p row sparse :=
  GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute_normalizedCoefficient
    p row sparse

example (p : GHL2025.OneTermRobinParameters) (row sparse : Nat) :
    (GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute p row sparse).ketZeroEntry =
      (GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerContract p row sparse).ketZeroEntry :=
  GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute_ketZeroEntry
    p row sparse

example (p : GHL2025.OneTermRobinParameters) (row sparse : Nat) :
    (GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute p row sparse).ketOneEntry =
      (GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerContract p row sparse).ketOneEntry :=
  GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute_ketOneEntry
    p row sparse

example (p : GHL2025.OneTermRobinParameters) (row sparse : Nat) :
    (GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute p row sparse).normalizerBound =
      (GHL2025.derivativeNormalizerNDContract p row sparse).coefficientBound ∧
    (GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute p row sparse).coefficientDivision =
      (GHL2025.derivativeNormalizerNDContract p row sparse).divisionSemantics ∧
    (GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute p row sparse).absSquareSemantics =
      (GHL2025.derivativeNormalizerNDContract p row sparse).absSquareSemantics ∧
    (GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute p row sparse).sqrtComplementSemantics =
      (GHL2025.derivativeNormalizerNDContract p row sparse).sqrtComplementSemantics :=
  GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute_sharedND p row sparse

example (p : GHL2025.OneTermRobinParameters) (row sparse : Nat) :
    (GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute p row sparse).coefficient =
      (GHL2025.derivativeNormalizerNDSourceBound p row sparse).sourceCoefficient ∧
    (GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute p row sparse).normalizerND =
      (GHL2025.derivativeNormalizerNDSourceBound p row sparse).normalizerND ∧
    (GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute p row sparse).normalizerBound =
      (GHL2025.derivativeNormalizerNDSourceBound p row sparse).coefficientBound :=
  GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute_sourceBound
    p row sparse

example (p : GHL2025.OneTermRobinParameters) (row sparse : Nat) :
    (GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute p row sparse).coefficientDivision.proved =
      false := rfl

example (p : GHL2025.OneTermRobinParameters) (row sparse : Nat) :
    (GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute p row sparse).normalizerBound.proved =
      false := rfl

example (p : GHL2025.OneTermRobinParameters) (row sparse : Nat) :
    (GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute p row sparse).absSquareSemantics.proved =
      false := rfl

example (p : GHL2025.OneTermRobinParameters) (row sparse : Nat) :
    (GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute p row sparse).sqrtComplementSemantics.proved =
      false := rfl

example (p : GHL2025.OneTermRobinParameters) (row sparse : Nat) :
    (GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute p row sparse).twoByTwoUnitary.proved =
      false := rfl

-- O_DT^S active gate is rewired from the legacy diagonal helper to the
-- faithful Lemma 3 controlled-rotation skeleton on ancilla bit 0.
example (p : GHL2025.OneTermRobinParameters) :
    (GHL2025.oneTermRobinGate_O_DT_S p).matrix =
      GHL2025.sparseAmplitudeOracleDTRotationMatrix p := rfl

-- O_DT^S paper register extraction for the bulk column used by the lower packet.
-- j=132 has indicator=1, system row=2, sparse index=0, ancilla=0.
example :
    let p : GHL2025.OneTermRobinParameters := { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.sparseAmplitudeOracleDTPaperRegisters p 132).indicatorBit = 1 := by
  native_decide

example :
    let p : GHL2025.OneTermRobinParameters := { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.sparseAmplitudeOracleDTPaperRegisters p 132).rowValue = 2 := by
  native_decide

example :
    let p : GHL2025.OneTermRobinParameters := { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.sparseAmplitudeOracleDTPaperRegisters p 132).sparseIndexValue = 0 := by
  native_decide

-- O_DT^S controlled rotation: bulk column j=132 has cos entry at row 132.
example :
    let p : GHL2025.OneTermRobinParameters := { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.sparseAmplitudeOracleDTRotationMatrix p)
      ⟨132, by native_decide⟩ ⟨132, by native_decide⟩ =
    Coeff.symbol "odts_cos_half_2_0" := by
  native_decide

-- O_DT^S controlled rotation: the same bulk column flips ancilla to row 133
-- with the sine half-angle symbol.
example :
    let p : GHL2025.OneTermRobinParameters := { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.sparseAmplitudeOracleDTRotationMatrix p)
      ⟨133, by native_decide⟩ ⟨132, by native_decide⟩ =
    Coeff.symbol "odts_sin_half_2_0" := by
  native_decide

-- O_DT^S controlled rotation: indicator=0 columns remain identity.
example :
    let p : GHL2025.OneTermRobinParameters := { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.sparseAmplitudeOracleDTRotationMatrix p)
      ⟨4, by native_decide⟩ ⟨4, by native_decide⟩ =
    Coeff.rat 1 := by
  native_decide

-- O_DT^S controlled rotation: indicator=0 columns do not flip ancilla.
example :
    let p : GHL2025.OneTermRobinParameters := { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.sparseAmplitudeOracleDTRotationMatrix p)
      ⟨5, by native_decide⟩ ⟨4, by native_decide⟩ =
    Coeff.rat 0 := by
  native_decide

-- O_DT^S active gate exposes the same controlled-rotation entries.
example :
    let p : GHL2025.OneTermRobinParameters := { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.oneTermRobinGate_O_DT_S p).matrix
      ⟨132, by native_decide⟩ ⟨132, by native_decide⟩ =
    Coeff.symbol "odts_cos_half_2_0" := by
  native_decide

-- O_DT^S placeholder match still holds with the controlled-rotation matrix.
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

-- Ry_boundary source contract: register extraction pins the same fields used
-- by the active rotation matrix.
example :
    let p : GHL2025.OneTermRobinParameters := { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.boundaryRotationPaperRegisters p 16).indicatorBit = 0 := by
  native_decide

example :
    let p : GHL2025.OneTermRobinParameters := { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.boundaryRotationPaperRegisters p 16).rowValue = 0 := by
  native_decide

example :
    let p : GHL2025.OneTermRobinParameters := { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.boundaryRotationPaperRegisters p 16).sparseIndexValue = 1 := by
  native_decide

example :
    let p : GHL2025.OneTermRobinParameters := { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.boundaryRotationPaperRegisters p 132).indicatorBit = 1 := by
  native_decide

-- Ry_boundary angle-normalizer relation is explicit and unproved.
example :
    GHL2025.boundaryRotationAngleNormalizerObligation.proved = false := rfl

example :
    let p : GHL2025.OneTermRobinParameters := { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.boundaryRotationAngleNormalizerContract p 0 2).coefficient =
      Coeff.add (Coeff.rat ((-5 : Rat) / 2))
        (Coeff.mul (Coeff.rat ((7 : Rat) / 3)) (Coeff.symbol "A1*dx")) := by
  native_decide

example :
    let p : GHL2025.OneTermRobinParameters := { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.boundaryRotationAngleNormalizerContract p 0 0).normalizerND =
      Coeff.symbol "N_D" := rfl

example :
    let p : GHL2025.OneTermRobinParameters := { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.boundaryRotationAngleNormalizerContract p 0 0).cosHalfEntry =
      Coeff.symbol "boundary_cos_half_0_0" := by
  native_decide

example :
    let p : GHL2025.OneTermRobinParameters := { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    (GHL2025.boundaryRotationAngleNormalizerContract p 0 0).sinHalfEntry =
      Coeff.symbol "boundary_sin_half_0_0" := by
  native_decide

example (p : GHL2025.OneTermRobinParameters) (row sparse : Nat) :
    (GHL2025.boundaryRotationAngleNormalizerContract p row sparse).boundaryControl.proved =
      false := rfl

example (p : GHL2025.OneTermRobinParameters) (row sparse : Nat) :
    (GHL2025.boundaryRotationAngleNormalizerContract p row sparse).arccosArgumentRelation.proved =
      false := rfl

example (p : GHL2025.OneTermRobinParameters) (row sparse : Nat) :
    (GHL2025.boundaryRotationAngleNormalizerContract p row sparse).cosHalfRelation.proved =
      false := rfl

example (p : GHL2025.OneTermRobinParameters) (row sparse : Nat) :
    (GHL2025.boundaryRotationAngleNormalizerContract p row sparse).sinHalfRelation.proved =
      false := rfl

example (p : GHL2025.OneTermRobinParameters) (row sparse : Nat) :
    (GHL2025.boundaryRotationAngleNormalizerContract p row sparse).twoByTwoUnitary.proved =
      false := rfl

example (p : GHL2025.OneTermRobinParameters) (row sparse : Nat) :
    (GHL2025.boundaryRotationAngleNormalizerContract p row sparse).coefficient =
      GHL2025.robinGlobalSparseAmplitudeValue p.n sparse row :=
  GHL2025.boundaryRotationAngleNormalizerContract_coefficient p row sparse

example :
    let p : GHL2025.OneTermRobinParameters := { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    GHL2025.boundaryRotationNormalizedCoefficient p 0 2 =
      Coeff.mul
        (Coeff.add (Coeff.rat ((-5 : Rat) / 2))
          (Coeff.mul (Coeff.rat ((7 : Rat) / 3)) (Coeff.symbol "A1*dx")))
        (Coeff.symbol "N_D_inv") := by
  native_decide

example (p : GHL2025.OneTermRobinParameters) (row sparse : Nat) :
    (GHL2025.boundaryRotationAngleNormalizerProofRoute p row sparse).coefficient =
      (GHL2025.boundaryRotationAngleNormalizerContract p row sparse).coefficient :=
  GHL2025.boundaryRotationAngleNormalizerProofRoute_coefficient p row sparse

example (p : GHL2025.OneTermRobinParameters) (row sparse : Nat) :
    (GHL2025.boundaryRotationAngleNormalizerProofRoute p row sparse).arccosArgument =
      GHL2025.boundaryRotationNormalizedCoefficient p row sparse :=
  GHL2025.boundaryRotationAngleNormalizerProofRoute_arccosArgument p row sparse

example (p : GHL2025.OneTermRobinParameters) (row sparse : Nat) :
    (GHL2025.boundaryRotationAngleNormalizerProofRoute p row sparse).arccosArgumentFormula =
      "D_j^(s) / N_D" := rfl

example (p : GHL2025.OneTermRobinParameters) (row sparse : Nat) :
    (GHL2025.boundaryRotationAngleNormalizerProofRoute p row sparse).normalizerBound =
      (GHL2025.derivativeNormalizerNDContract p row sparse).coefficientBound ∧
    (GHL2025.boundaryRotationAngleNormalizerProofRoute p row sparse).coefficientDivision =
      (GHL2025.derivativeNormalizerNDContract p row sparse).divisionSemantics ∧
    (GHL2025.boundaryRotationAngleNormalizerProofRoute p row sparse).realArccosSemantics =
      (GHL2025.derivativeNormalizerNDContract p row sparse).arccosSemantics :=
  GHL2025.boundaryRotationAngleNormalizerProofRoute_sharedND p row sparse

example (p : GHL2025.OneTermRobinParameters) (row sparse : Nat) :
    (GHL2025.boundaryRotationAngleNormalizerProofRoute p row sparse).coefficient =
      (GHL2025.derivativeNormalizerNDSourceBound p row sparse).sourceCoefficient ∧
    (GHL2025.boundaryRotationAngleNormalizerProofRoute p row sparse).normalizerND =
      (GHL2025.derivativeNormalizerNDSourceBound p row sparse).normalizerND ∧
    (GHL2025.boundaryRotationAngleNormalizerProofRoute p row sparse).normalizerBound =
      (GHL2025.derivativeNormalizerNDSourceBound p row sparse).coefficientBound :=
  GHL2025.boundaryRotationAngleNormalizerProofRoute_sourceBound p row sparse

example (p : GHL2025.OneTermRobinParameters) (row sparse : Nat) :
    (GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute p row sparse).coefficient =
      (GHL2025.boundaryRotationAngleNormalizerProofRoute p row sparse).coefficient ∧
    (GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute p row sparse).normalizerND =
      (GHL2025.boundaryRotationAngleNormalizerProofRoute p row sparse).normalizerND ∧
    (GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute p row sparse).normalizerBound =
      (GHL2025.boundaryRotationAngleNormalizerProofRoute p row sparse).normalizerBound :=
  GHL2025.derivativeNormalizerNDSourceBound_sharedRoutes p row sparse

example (p : GHL2025.OneTermRobinParameters) (row sparse : Nat) :
    (GHL2025.derivativeNormalizerNDContract p row sparse).nonzeroNormalizer.proved = false ∧
    (GHL2025.derivativeNormalizerNDContract p row sparse).divisionSemantics.proved = false ∧
    (GHL2025.derivativeNormalizerNDContract p row sparse).coefficientBound.proved = false ∧
    (GHL2025.derivativeNormalizerNDContract p row sparse).absSquareSemantics.proved = false ∧
    (GHL2025.derivativeNormalizerNDContract p row sparse).sqrtComplementSemantics.proved = false ∧
    (GHL2025.derivativeNormalizerNDContract p row sparse).arccosSemantics.proved = false ∧
    (GHL2025.derivativeNormalizerNDContract p row sparse).twoByTwoUnitary.proved = false ∧
    (GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute p row sparse).coefficientDivision.proved = false ∧
    (GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute p row sparse).normalizerBound.proved = false ∧
    (GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute p row sparse).absSquareSemantics.proved = false ∧
    (GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute p row sparse).sqrtComplementSemantics.proved = false ∧
    (GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute p row sparse).twoByTwoUnitary.proved = false ∧
    (GHL2025.boundaryRotationAngleNormalizerProofRoute p row sparse).coefficientDivision.proved = false ∧
    (GHL2025.boundaryRotationAngleNormalizerProofRoute p row sparse).realArccosSemantics.proved = false ∧
    (GHL2025.boundaryRotationAngleNormalizerProofRoute p row sparse).halfAngleSemantics.proved = false ∧
    (GHL2025.boundaryRotationAngleNormalizerProofRoute p row sparse).normalizerBound.proved = false ∧
    (GHL2025.boundaryRotationAngleNormalizerProofRoute p row sparse).twoByTwoUnitary.proved = false ∧
    (GHL2025.oneTermRobinGate_O_DT_S p).unitary.proved = false ∧
    (GHL2025.oneTermRobinGate_Ry_boundary p).unitary.proved = false :=
  GHL2025.derivativeNormalizerNDSharedRoute_flags_false p row sparse

example (p : GHL2025.OneTermRobinParameters) (row sparse : Nat) :
    ((GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute p row sparse).coefficient =
        (GHL2025.derivativeNormalizerNDSourceBound p row sparse).sourceCoefficient ∧
      (GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute p row sparse).normalizerND =
        (GHL2025.derivativeNormalizerNDSourceBound p row sparse).normalizerND ∧
      (GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute p row sparse).normalizerBound =
        (GHL2025.derivativeNormalizerNDSourceBound p row sparse).coefficientBound) ∧
    ((GHL2025.boundaryRotationAngleNormalizerProofRoute p row sparse).coefficient =
        (GHL2025.derivativeNormalizerNDSourceBound p row sparse).sourceCoefficient ∧
      (GHL2025.boundaryRotationAngleNormalizerProofRoute p row sparse).normalizerND =
        (GHL2025.derivativeNormalizerNDSourceBound p row sparse).normalizerND ∧
      (GHL2025.boundaryRotationAngleNormalizerProofRoute p row sparse).normalizerBound =
        (GHL2025.derivativeNormalizerNDSourceBound p row sparse).coefficientBound) ∧
    ((GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute p row sparse).coefficient =
        (GHL2025.boundaryRotationAngleNormalizerProofRoute p row sparse).coefficient ∧
      (GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute p row sparse).normalizerND =
        (GHL2025.boundaryRotationAngleNormalizerProofRoute p row sparse).normalizerND ∧
      (GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute p row sparse).normalizerBound =
        (GHL2025.boundaryRotationAngleNormalizerProofRoute p row sparse).normalizerBound) ∧
    (GHL2025.derivativeNormalizerNDContract p row sparse).nonzeroNormalizer.proved = false ∧
    (GHL2025.derivativeNormalizerNDContract p row sparse).divisionSemantics.proved = false ∧
    (GHL2025.derivativeNormalizerNDContract p row sparse).coefficientBound.proved = false ∧
    (GHL2025.derivativeNormalizerNDContract p row sparse).absSquareSemantics.proved = false ∧
    (GHL2025.derivativeNormalizerNDContract p row sparse).sqrtComplementSemantics.proved = false ∧
    (GHL2025.derivativeNormalizerNDContract p row sparse).arccosSemantics.proved = false ∧
    (GHL2025.derivativeNormalizerNDContract p row sparse).twoByTwoUnitary.proved = false ∧
    (GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute p row sparse).coefficientDivision.proved = false ∧
    (GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute p row sparse).normalizerBound.proved = false ∧
    (GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute p row sparse).absSquareSemantics.proved = false ∧
    (GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute p row sparse).sqrtComplementSemantics.proved = false ∧
    (GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute p row sparse).twoByTwoUnitary.proved = false ∧
    (GHL2025.boundaryRotationAngleNormalizerProofRoute p row sparse).coefficientDivision.proved = false ∧
    (GHL2025.boundaryRotationAngleNormalizerProofRoute p row sparse).realArccosSemantics.proved = false ∧
    (GHL2025.boundaryRotationAngleNormalizerProofRoute p row sparse).halfAngleSemantics.proved = false ∧
    (GHL2025.boundaryRotationAngleNormalizerProofRoute p row sparse).normalizerBound.proved = false ∧
    (GHL2025.boundaryRotationAngleNormalizerProofRoute p row sparse).twoByTwoUnitary.proved = false ∧
    (GHL2025.oneTermRobinGate_O_DT_S p).unitary.proved = false ∧
    (GHL2025.oneTermRobinGate_Ry_boundary p).unitary.proved = false :=
  GHL2025.derivativeNormalizerNDSharedRoute_sourceBoundAndFlags p row sparse

example (p : GHL2025.OneTermRobinParameters) (row sparse : Nat) :
    (GHL2025.boundaryRotationAngleNormalizerProofRoute p row sparse).coefficientDivision.proved =
      false := rfl

example (p : GHL2025.OneTermRobinParameters) (row sparse : Nat) :
    (GHL2025.boundaryRotationAngleNormalizerProofRoute p row sparse).realArccosSemantics.proved =
      false := rfl

example (p : GHL2025.OneTermRobinParameters) (row sparse : Nat) :
    (GHL2025.boundaryRotationAngleNormalizerProofRoute p row sparse).halfAngleSemantics.proved =
      false := rfl

example (p : GHL2025.OneTermRobinParameters) (row sparse : Nat) :
    (GHL2025.boundaryRotationAngleNormalizerProofRoute p row sparse).normalizerBound.proved =
      false := rfl

example (p : GHL2025.OneTermRobinParameters) (row sparse : Nat) :
    (GHL2025.boundaryRotationAngleNormalizerProofRoute p row sparse).twoByTwoUnitary.proved =
      false := rfl

example (p : GHL2025.OneTermRobinParameters) :
    (GHL2025.oneTermRobinGate_Ry_boundary p).matrix =
      GHL2025.boundaryRotationMatrix p := rfl

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

-- Structural tests still pass: targetMatrix = oneTermRobinAkMatrix
example (n : Nat) :
    (Examples.RobinHeat.oneTermRobinBlockExtractionTarget n).targetMatrix =
      Examples.RobinHeat.oneTermRobinAkMatrix n := rfl

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

-- Block-projection normalizer audit: the default block claim reuses the same
-- target object, so downstream proofs cannot silently swap the projection
-- convention or normalizer.
example (n : Nat) :
    (Examples.RobinHeat.defaultOneTermRobinCircuitBlockClaim n).target =
      Examples.RobinHeat.oneTermRobinBlockExtractionTarget n := rfl

example (n : Nat) :
    (Examples.RobinHeat.defaultOneTermRobinCircuitBlockClaim n).target.normalizer =
      GHL2025.oneTermRobinNormalizer := rfl

example (n : Nat) :
    (Examples.RobinHeat.defaultOneTermRobinCircuitBlockClaim n).target.signalIndex.val = 0 := rfl

-- The block claim and the extracted target both keep correctness unproved.
example (n : Nat) :
    (Examples.RobinHeat.defaultOneTermRobinCircuitBlockClaim n).blockCorrect.proved = false := rfl

example (n : Nat) :
    (Examples.RobinHeat.defaultOneTermRobinCircuitBlockClaim n).target.blockProjection.proved = false := rfl

example (n : Nat) :
    (Examples.RobinHeat.defaultOneTermRobinCircuitBlockClaim n).target.blockCorrect.proved = false := rfl

-- Upstream O_D^BS dagger cleanup is still an explicit paper-contract gap.
example (n : Nat) :
    (GHL2025.defaultBandedSparseAccessPaperContract
      (Examples.RobinHeat.oneTermParameters n)).daggerCleanup.proved = false := rfl

-- O_D^BS full clean-domain extension remains an obligation-only wrapper.
example (p : GHL2025.OneTermRobinParameters) :
    (GHL2025.bandedSparseAccessFullCleanDomainExtensionContract p).fullCleanDomainInjective.proved =
      false := rfl

example (p : GHL2025.OneTermRobinParameters) :
    (GHL2025.bandedSparseAccessFullCleanDomainExtensionContract p).daggerCleanup.proved =
      false := rfl

example (p : GHL2025.OneTermRobinParameters) :
    (GHL2025.bandedSparseAccessFullCleanDomainExtensionContract p).unitaryExtension.proved =
      false := rfl

example (p : GHL2025.OneTermRobinParameters) (j : Nat) :
    ((GHL2025.bandedSparseAccessFullCleanDomainExtensionContract p).unusedBranchImageRuleContract
      j).proposedImageIndex = none := rfl

example (p : GHL2025.OneTermRobinParameters) (j : Nat) :
    ((GHL2025.bandedSparseAccessFullCleanDomainExtensionContract p).unusedBranchImageRuleContract
      j).imageSpecified.proved = false := rfl

example (p : GHL2025.OneTermRobinParameters) (j : Nat) :
    (GHL2025.bandedSparseAccessFullCleanDomainExtensionContract p).cleanDomainSplit.proved = false ∧
      (GHL2025.bandedSparseAccessFullCleanDomainExtensionContract p).validBranchAgreement.proved = false ∧
      (GHL2025.bandedSparseAccessFullCleanDomainExtensionContract p).unusedBranchImageSpecified.proved = false ∧
      (GHL2025.bandedSparseAccessFullCleanDomainExtensionContract p).unusedBranchImageFinite.proved = false ∧
      (GHL2025.bandedSparseAccessFullCleanDomainExtensionContract p).unusedBranchInjective.proved = false ∧
      (GHL2025.bandedSparseAccessFullCleanDomainExtensionContract p).fullCleanDomainInjective.proved = false ∧
      (GHL2025.bandedSparseAccessFullCleanDomainExtensionContract p).daggerCleanup.proved = false ∧
      (GHL2025.bandedSparseAccessFullCleanDomainExtensionContract p).unitaryExtension.proved = false ∧
      ((GHL2025.bandedSparseAccessFullCleanDomainExtensionContract p).unusedBranchImageRuleContract
        j).proposedImageIndex = none ∧
      ((GHL2025.bandedSparseAccessFullCleanDomainExtensionContract p).unusedBranchImageRuleContract
        j).imageSpecified.proved = false ∧
      ((GHL2025.bandedSparseAccessFullCleanDomainExtensionContract p).unusedBranchImageRuleContract
        j).imageFinite.proved = false :=
  GHL2025.bandedSparseAccessFullCleanDomainExtensionContract_flags_false p j

example (p : GHL2025.OneTermRobinParameters) (j : Nat)
    (h : GHL2025.bandedSparseAccessPaperUnusedSparseBranch p j = true) :
    ((GHL2025.bandedSparseAccessFullCleanDomainExtensionContract p).unusedBranchImageRuleContract
      j).cleanInput = true ∧
      ((GHL2025.bandedSparseAccessFullCleanDomainExtensionContract p).unusedBranchImageRuleContract
        j).validSparseBranch = false ∧
      ((GHL2025.bandedSparseAccessFullCleanDomainExtensionContract p).unusedBranchImageRuleContract
        j).unusedSparseBranch = true ∧
      ((GHL2025.bandedSparseAccessFullCleanDomainExtensionContract p).unusedBranchImageRuleContract
        j).proposedImageIndex = none ∧
      (GHL2025.bandedSparseAccessFullCleanDomainExtensionContract p).unusedBranchImageSpecified.proved = false ∧
      (GHL2025.bandedSparseAccessFullCleanDomainExtensionContract p).fullCleanDomainInjective.proved = false ∧
      (GHL2025.bandedSparseAccessFullCleanDomainExtensionContract p).unitaryExtension.proved = false :=
  GHL2025.bandedSparseAccessFullCleanDomainExtensionContract_of_unusedBranch p j h

example (p : GHL2025.OneTermRobinParameters) (j : Nat) :
    GHL2025.bandedSparseAccessPaperCleanInput p j = true ↔
      GHL2025.bandedSparseAccessPaperValidCleanSource p j = true ∨
        GHL2025.bandedSparseAccessPaperUnusedSparseBranch p j = true :=
  GHL2025.bandedSparseAccessPaperCleanDomainSplit_iff p j

example (p : GHL2025.OneTermRobinParameters) (j : Nat) :
    ¬ (GHL2025.bandedSparseAccessPaperValidCleanSource p j = true ∧
        GHL2025.bandedSparseAccessPaperUnusedSparseBranch p j = true) :=
  GHL2025.bandedSparseAccessPaperCleanDomainSplit_disjoint p j

example (p : GHL2025.OneTermRobinParameters) (j : Nat) :
    (GHL2025.bandedSparseAccessPaperCleanInput p j = true ↔
      GHL2025.bandedSparseAccessPaperValidCleanSource p j = true ∨
        GHL2025.bandedSparseAccessPaperUnusedSparseBranch p j = true) ∧
      (GHL2025.bandedSparseAccessFullCleanDomainExtensionContract p).cleanDomainSplit.proved =
        false :=
  GHL2025.bandedSparseAccessFullCleanDomainExtensionContract_localCleanDomainSplit p j

example :
    GHL2025.bandedSparseAccessUnusedZeroBranchSourceDecision.citedResultKey =
      "QBE.ODBS.UnusedZeroBranchExtension" := rfl

example :
    GHL2025.bandedSparseAccessUnusedZeroBranchSourceDecision.paperImageRuleSpecified = false ∧
      GHL2025.bandedSparseAccessUnusedZeroBranchSourceDecision.externalExtensionTheoremAccepted =
        false ∧
      GHL2025.bandedSparseAccessUnusedZeroBranchSourceDecision.lowerProofSearchAllowed =
        false ∧
      GHL2025.bandedSparseAccessUnusedZeroBranchSourceDecision.dependency.proved = false :=
  GHL2025.bandedSparseAccessUnusedZeroBranchSourceDecision_flags_false

example (p : GHL2025.OneTermRobinParameters) :
    GHL2025.bandedSparseAccessUnusedZeroBranchSourceDecision.lowerProofSearchAllowed =
        false ∧
      (GHL2025.bandedSparseAccessFullCleanDomainExtensionContract p).unusedBranchImageSpecified.proved =
        false ∧
      (GHL2025.bandedSparseAccessFullCleanDomainExtensionContract p).fullCleanDomainInjective.proved =
        false ∧
      (GHL2025.bandedSparseAccessFullCleanDomainExtensionContract p).daggerCleanup.proved =
        false ∧
      (GHL2025.bandedSparseAccessFullCleanDomainExtensionContract p).unitaryExtension.proved =
        false :=
  GHL2025.bandedSparseAccessUnusedZeroBranchSourceDecision_keepsFullDomainFlagsFalse p

example (p : GHL2025.OneTermRobinParameters) (j : Nat) :
    GHL2025.bandedSparseAccessUnusedZeroBranchSourceDecision.lowerProofSearchAllowed =
        false ∧
      (GHL2025.bandedSparseAccessUnusedBranchImageRuleContract p j).proposedImageIndex =
        none ∧
      (GHL2025.bandedSparseAccessUnusedBranchImageRuleContract p j).imageSpecified.proved =
        false ∧
      ((GHL2025.bandedSparseAccessFullCleanDomainExtensionContract p).unusedBranchImageRuleContract
        j).proposedImageIndex = none ∧
      ((GHL2025.bandedSparseAccessFullCleanDomainExtensionContract p).unusedBranchImageRuleContract
        j).imageSpecified.proved = false ∧
      ((GHL2025.bandedSparseAccessFullCleanDomainExtensionContract p).unusedBranchImageRuleContract
        j).separatesActiveCollision.proved = false :=
  GHL2025.bandedSparseAccessUnusedZeroBranchSourceDecision_keepsImageRuleUnspecified p j

example (p : GHL2025.OneTermRobinParameters) :
    GHL2025.bandedSparseAccessUnusedZeroBranchSourceDecision.lowerProofSearchAllowed =
        false ∧
      (GHL2025.defaultBandedSparseAccessPaperContract p).forwardCorrect.proved =
        false ∧
      (GHL2025.defaultBandedSparseAccessPaperContract p).daggerCleanup.proved =
        false ∧
      (GHL2025.defaultBandedSparseAccessPaperContract p).unitaryExtension.proved =
        false :=
  GHL2025.bandedSparseAccessUnusedZeroBranchSourceDecision_keepsPaperContractFlagsFalse p

example :
    GHL2025.bandedSparseAccessRobinZeroInclusionSourceContract.zerosIncludedInSparseEnumeration =
        true ∧
      GHL2025.bandedSparseAccessRobinZeroInclusionSourceContract.unusedBranchImageRule =
        none ∧
      GHL2025.bandedSparseAccessRobinZeroInclusionSourceContract.unusedBranchImageIndex =
        none ∧
      GHL2025.bandedSparseAccessRobinZeroInclusionSourceContract.reversibleExtensionTheorem =
        none ∧
      GHL2025.bandedSparseAccessRobinZeroInclusionSourceContract.closesUnusedZeroBranchExtension =
        false ∧
      GHL2025.bandedSparseAccessRobinZeroInclusionSourceContract.lowerProofSearchAllowed =
        false ∧
      GHL2025.bandedSparseAccessRobinZeroInclusionSourceContract.imageRuleObligation.proved =
        false ∧
      GHL2025.bandedSparseAccessRobinZeroInclusionSourceContract.reversibleExtensionObligation.proved =
        false ∧
      GHL2025.bandedSparseAccessUnusedZeroBranchSourceDecision.lowerProofSearchAllowed =
        false :=
  GHL2025.bandedSparseAccessRobinZeroInclusionSourceContract_blocks_unusedZeroBranch

example (p : GHL2025.OneTermRobinParameters) (j : Nat) :
    GHL2025.bandedSparseAccessRobinZeroInclusionSourceContract.zerosIncludedInSparseEnumeration =
        true ∧
      GHL2025.bandedSparseAccessRobinZeroInclusionSourceContract.unusedBranchImageIndex =
        none ∧
      GHL2025.bandedSparseAccessRobinZeroInclusionSourceContract.reversibleExtensionTheorem =
        none ∧
      GHL2025.bandedSparseAccessRobinZeroInclusionSourceContract.lowerProofSearchAllowed =
        false ∧
      (GHL2025.bandedSparseAccessUnusedBranchImageRuleContract p j).proposedImageIndex =
        none ∧
      (GHL2025.bandedSparseAccessUnusedBranchImageRuleContract p j).imageSpecified.proved =
        false :=
  GHL2025.bandedSparseAccessRobinZeroInclusionSourceContract_keepsImageRuleUnspecified p j

example :
    GHL2025.bandedSparseAccessPriorPDESourceContract.oracleEquation =
      "O_A^BS |0>^(n-l)|s>^l|i>^n = |r_si>^n|i>^n" :=
  GHL2025.bandedSparseAccessPriorPDESourceContract_oracleEquation

example :
    GHL2025.bandedSparseAccessPriorPDESourceContract.robinUnusedBranchImageRule =
        none ∧
      GHL2025.bandedSparseAccessPriorPDESourceContract.closesUnusedZeroBranchExtension =
        false ∧
      GHL2025.bandedSparseAccessPriorPDESourceContract.lowerProofSearchAllowed =
        false ∧
      GHL2025.bandedSparseAccessUnusedZeroBranchSourceDecision.lowerProofSearchAllowed =
        false :=
  GHL2025.bandedSparseAccessPriorPDESourceContract_blocks_unusedZeroBranch

example :
    GHL2025.bandedSparseAccessPriorPDESourceContract.resourceClaim.proved =
      false :=
  GHL2025.bandedSparseAccessPriorPDESourceContract_resource_unproved

-- Theorem-level one-term proof-route contract.

example (n : Nat) :
    (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).theoremData.alpha =
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).blockClaim.target.normalizer :=
  Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_normalizer n

example (n : Nat) :
    (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).blockClaim.target.targetMatrix =
      Examples.RobinHeat.oneTermRobinAkMatrix n :=
  (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).targetMatrixMatchesSpec

example (n : Nat) :
    (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).blockClaim.target.signalIndex.val =
      0 :=
  (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).signalIndexZero

example (n : Nat) (i j : Fin (gridSize n)) :
    signalSystemBlockRowIndex (gridSize n)
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).blockClaim.target.signalIndex.val
        i.val = i.val ∧
      signalSystemBlockColIndex (gridSize n)
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).blockClaim.target.signalIndex.val
        j.val = j.val :=
  Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_signalZeroBlockIndices n i j

example (n : Nat) :
    (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).blockClaim.target =
        Examples.RobinHeat.oneTermRobinBlockExtractionTarget n ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).blockClaim.semantics =
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).circuitSemantics ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).blockClaim.target.targetMatrix =
        Examples.RobinHeat.oneTermRobinAkMatrix n ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).blockClaim.target.signalIndex.val =
        0 :=
  Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_blockTarget n

example (n : Nat) :
    (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).blockClaim.target =
        Examples.RobinHeat.oneTermRobinBlockExtractionTarget n ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).blockClaim.target.unitaryMatrix =
        cast (by rw [Examples.RobinHeat.oneTermRobinCircuitDimCompat n])
          (Examples.RobinHeat.oneTermRobinCircuitSemantics n).matrix ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).blockClaim.target.blockMatrix =
        signalSystemBlockProjection
          (qubitDim (GHL2025.effectiveRobinSignalQubits
            (Examples.RobinHeat.oneTermParameters n)))
          (gridSize n)
          (gridSize n)
          (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).blockClaim.target.unitaryMatrix
          (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).blockClaim.target.signalIndex ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).blockClaim.target.targetMatrix =
        Examples.RobinHeat.oneTermRobinAkMatrix n ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).blockClaim.target.normalizer =
        GHL2025.oneTermRobinNormalizer ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).blockClaim.target.signalIndex.val =
        0 ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).blockClaim.target.blockProjection.proved =
        false ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).blockClaim.target.blockCorrect.proved =
        false ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).sparseAccessContract.daggerCleanup.proved =
        false ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).oracleComposition.lcuCorrect.proved =
        false :=
  Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_blockProjectionNormalizerAudit n

example (n : Nat) :
    (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).circuitSemantics.circuit =
        GHL2025.oneTermRobinCircuit ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).circuitSemantics.gateMatrices =
        GHL2025.oneTermRobinGateMatrixPlaceholders (Examples.RobinHeat.oneTermParameters n) ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).circuitSemantics.gateListMatches =
        GHL2025.oneTermRobinPlaceholdersMatch (Examples.RobinHeat.oneTermParameters n) ∧
      Matrix.PointwiseEq
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).circuitSemantics.matrix
        (evalGateMatrices
          (GHL2025.oneTermRobinGateMatrixPlaceholders
            (Examples.RobinHeat.oneTermParameters n))) ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).blockClaim.semantics =
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).circuitSemantics :=
  Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_circuitProduct n

example (n : Nat) :
    (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).blockClaim.blockCorrect.proved =
        false ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).blockClaim.target.blockProjection.proved =
        false ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).blockClaim.target.blockCorrect.proved =
        false :=
  Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_claimBlockCorrectFalse n

example (p : GHL2025.OneTermRobinParameters) :
    (GHL2025.defaultOneTermRobinTheoremData p).signalQubits =
      (GHL2025.oneTermRobinLayout p).signalQubits :=
  GHL2025.defaultOneTermRobinTheoremData_signalQubits_eq_layout p

example (p : GHL2025.OneTermRobinParameters) :
    (GHL2025.defaultOneTermRobinTheoremData p).pureAncillas =
      (GHL2025.oneTermRobinLayout p).pureAncillas :=
  GHL2025.defaultOneTermRobinTheoremData_pureAncillas_eq_layout p

example (p : GHL2025.OneTermRobinParameters) :
    (GHL2025.defaultOneTermRobinTheoremData p).pureAncillas =
      (GHL2025.oneTermRobinResource p).pureAncilla :=
  GHL2025.defaultOneTermRobinTheoremData_pureAncillas_eq_resource p

example (p : GHL2025.OneTermRobinParameters) :
    GHL2025.effectiveRobinSignalQubits p =
      (GHL2025.oneTermRobinLayout p).signalQubits +
        (GHL2025.defaultRobinRegisterPartition p).odPureAncillaQubits + 1 :=
  GHL2025.effectiveRobinSignalQubits_eq_layout_signal_plus_visibleWorkspace p

example (p : GHL2025.OneTermRobinParameters) :
    GHL2025.effectiveRobinSignalQubits p =
      (GHL2025.defaultOneTermRobinTheoremData p).signalQubits +
        (GHL2025.defaultRobinRegisterPartition p).odPureAncillaQubits + 1 :=
  GHL2025.effectiveRobinSignalQubits_eq_theoremData_signal_plus_visibleWorkspace p

example (n : Nat) :
    (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).theoremData.signalQubits =
        (GHL2025.oneTermRobinLayout (Examples.RobinHeat.oneTermParameters n)).signalQubits ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).theoremData.pureAncillas =
        (GHL2025.oneTermRobinLayout (Examples.RobinHeat.oneTermParameters n)).pureAncillas ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).theoremData.pureAncillas =
        (GHL2025.oneTermRobinResource (Examples.RobinHeat.oneTermParameters n)).pureAncilla ∧
      GHL2025.effectiveRobinSignalQubits (Examples.RobinHeat.oneTermParameters n) =
        (GHL2025.oneTermRobinLayout (Examples.RobinHeat.oneTermParameters n)).signalQubits +
          (GHL2025.defaultRobinRegisterPartition
            (Examples.RobinHeat.oneTermParameters n)).odPureAncillaQubits + 1 ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).theoremData.obligations.resourceBound.proved =
        false ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).theoremData.obligations.ancillaCleanup.proved =
        false ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).blockClaim.target.blockProjection.proved =
        false ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).blockClaim.target.blockCorrect.proved =
        false :=
  Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_layoutProjectionAudit n

example (n : Nat) :
    (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).circuitSemantics.circuit =
      GHL2025.oneTermRobinCircuit :=
  (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).circuitWired

example (n : Nat) :
    (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).blockClaim.target.blockProjection.proved =
        false ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).blockClaim.target.blockCorrect.proved =
        false ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).theoremData.obligations.blockExtraction.proved =
        false ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).theoremData.obligations.circuitUnitary.proved =
        false ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).sparseAccessContract.daggerCleanup.proved =
        false ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).sparseAccessContract.unitaryExtension.proved =
        false ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).cleanupScopeDecision.selectedScope =
        GHL2025.BandedSparseAccessCleanupScope.activeGlobalSource ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).cleanupScopeDecision.fullCleanDomainSelected =
        false ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).cleanupScopeDecision.fullSpaceSelected =
        false ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).cleanupScopeDecision.semanticCleanupPromotionAllowed =
        false ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).functionOracleSource.closesFunctionOracleContract =
        false ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).oracleComposition.functionOracle.amplitudeCorrect.proved =
        false ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).oracleComposition.lcuCorrect.proved =
        false :=
  Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_flags_false n

example (n j : Nat) :
    (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).functionOracleSource =
        GHL2025.functionOracleExternalAmplitudeSourceContract ∧
      (GHL2025.functionOracleAmplitudeProofRoute
        (Examples.RobinHeat.oneTermParameters n) j).normalizerNf =
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).functionOracleSource.normalizerNf ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).functionOracleSource.externalTheoremFormalized.proved =
        false ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).functionOracleSource.closesFunctionOracleContract =
        false ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).oracleComposition.functionOracle.amplitudeCorrect.proved =
        false ∧
      (GHL2025.oneTermRobinGate_O_f
        (Examples.RobinHeat.oneTermParameters n)).unitary.proved = false ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).oracleComposition.lcuCorrect.proved =
        false ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).blockClaim.target.blockCorrect.proved =
        false := by
  rcases
      Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_ofExternalSourceAndFlags
        n j
      with
    ⟨hsourceIdentity, _hsourceAnchor, hnormalizer, _hformula, _hnonzeroEq,
      _hdivisionEq, _htheoremEq, _hresource, hexternal, _hsourceNonzero,
      _hsourceDivision, _hsourceTheorem, _hclosesBound, _hclosesOrthogonal,
      _hclosesUnitary, hclosesContract, _hnormalized, _hnonzero, _hdivision,
      _hbound, _horthogonal, _hunitary, _hrouteTheorem, _hgate, _hmatrix,
      hgateUnitary, hfunctionAmp, hlcu, _hblockProjection, hblockCorrect,
      _hblockExtraction⟩
  exact ⟨hsourceIdentity, hnormalizer, hexternal, hclosesContract,
    hfunctionAmp, hgateUnitary, hlcu, hblockCorrect⟩

example :
    let p := Examples.RobinHeat.oneTermParameters 3
    (((Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).circuitSemantics.gateMatrices.get
      ⟨4, by
        simp [Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute,
          Examples.RobinHeat.oneTermRobinCircuitSemantics,
          GHL2025.oneTermRobinGateMatrixPlaceholders]⟩).gate =
        Gate.oracleCall "O_f") ∧
      (((Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).circuitSemantics.gateMatrices.get
      ⟨4, by
        simp [Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute,
          Examples.RobinHeat.oneTermRobinCircuitSemantics,
          GHL2025.oneTermRobinGateMatrixPlaceholders]⟩).matrix =
        GHL2025.functionOraclePaperMatrix p) ∧
      (GHL2025.functionOracleAmplitudeProofRoute p 36).theoremAmplitudeCorrect.proved =
        false ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).theoremData.obligations.blockExtraction.proved =
        false := by
  rcases
      Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_ofExternalSourceAndFlags
        3 36
      with
    ⟨_hsourceIdentity, _hsourceAnchor, _hnormalizer, _hformula, _hnonzeroEq,
      _hdivisionEq, _htheoremEq, _hresource, _hexternal, _hsourceNonzero,
      _hsourceDivision, _hsourceTheorem, _hclosesBound, _hclosesOrthogonal,
      _hclosesUnitary, _hclosesContract, _hnormalized, _hnonzero, _hdivision,
      _hbound, _horthogonal, _hunitary, hrouteTheorem, hgate, hmatrix,
      _hgateUnitary, _hfunctionAmp, _hlcu, _hblockProjection, _hblockCorrect,
      hblockExtraction⟩
  exact ⟨hgate, hmatrix, hrouteTheorem, hblockExtraction⟩

example :
    let p := Examples.RobinHeat.oneTermParameters 3
    let i : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
      ⟨36, by native_decide⟩
    let j : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
      ⟨36, by native_decide⟩
    (((Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).circuitSemantics.gateMatrices.get
      ⟨4, by
        simp [Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute,
          Examples.RobinHeat.oneTermRobinCircuitSemantics,
          GHL2025.oneTermRobinGateMatrixPlaceholders]⟩).matrix i j =
        Coeff.mul (Coeff.symbol "f_3_2") (Coeff.symbol "N_f_inv")) ∧
      (GHL2025.functionOracleAmplitudeProofRoute p j.val).cleanBranchBasisIndex =
        i.val ∧
      (GHL2025.functionOracleAmplitudeProofRoute p j.val).cleanWorkspaceBranch =
        true ∧
      (((Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).circuitSemantics.gateMatrices.get
        ⟨4, by
          simp [Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute,
            Examples.RobinHeat.oneTermRobinCircuitSemantics,
            GHL2025.oneTermRobinGateMatrixPlaceholders]⟩).unitary.proved =
        false) ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).oracleComposition.functionOracle.amplitudeCorrect.proved =
        false ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).oracleComposition.lcuCorrect.proved =
        false ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).blockClaim.target.blockProjection.proved =
        false ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).theoremData.obligations.blockExtraction.proved =
        false := by
  let p := Examples.RobinHeat.oneTermParameters 3
  let i : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
    ⟨36, by native_decide⟩
  let j : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
    ⟨36, by native_decide⟩
  rcases
      Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_ofCleanFunctionOracleEntry
        3 i j (by native_decide) (by native_decide)
      with
    ⟨_hgate, _hentryBranch, hentryNormalized, hbasis, hclean, hunitary,
      _hclosesContract, hfunctionAmp, hlcu, hblockProjection, _hblockCorrect,
      hblockExtraction⟩
  have hnormalized :
      (GHL2025.functionOracleAmplitudeProofRoute p j.val).normalizedAmplitude =
        Coeff.mul (Coeff.symbol "f_3_2") (Coeff.symbol "N_f_inv") := by
    native_decide
  exact ⟨by rw [hentryNormalized, hnormalized], hbasis, hclean, hunitary,
    hfunctionAmp, hlcu, hblockProjection, hblockExtraction⟩


-- Active O_D^BS route guards now point to the global sparse-slot cleanup scope,
-- not the retired row-dependent unused-branch decision.
example (n j : Nat) :
    (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).cleanupScopeDecision.selectedScope =
        GHL2025.BandedSparseAccessCleanupScope.activeGlobalSource ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).cleanupScopeDecision.selectedPredicate =
        "bandedSparseAccessPaperGlobalSlotSource" ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).cleanupScopeDecision.selectedEvidence =
        "bandedSparseAccessGlobalSlotInverseOnRangeContract_restrictedDaggerColumnIndicator" ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).cleanupScopeDecision.fullCleanDomainSelected =
        false ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).cleanupScopeDecision.fullSpaceSelected =
        false ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).cleanupScopeDecision.semanticCleanupPromotionAllowed =
        false ∧
      ((GHL2025.bandedSparseAccessFullCleanDomainExtensionContract
        (Examples.RobinHeat.oneTermParameters n)).unusedBranchImageRuleContract
        j).proposedImageIndex = none ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).sparseAccessContract.daggerCleanup.proved =
        false ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).sparseAccessContract.unitaryExtension.proved =
        false ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).blockClaim.target.blockCorrect.proved =
        false ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).oracleComposition.lcuCorrect.proved =
        false := by
  rcases
      Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_odbsActiveGlobalSlotBlockers
        n j
      with
    ⟨hscope, hpredicate, hevidence, hfullClean, hfullSpace, hpromotion,
      hwrappedSlot, _hwrappedImage, _hwrapperCleanup, _hwrapperUnitary,
      hcleanupOpen, hunitaryOpen, hblockCorrect, hlcu⟩
  exact ⟨hscope, hpredicate, hevidence, hfullClean, hfullSpace, hpromotion,
    hwrappedSlot, hcleanupOpen, hunitaryOpen, hblockCorrect, hlcu⟩

example (n : Nat) :
    (GHL2025.oneTermRobinGate_O_D_BS
        (Examples.RobinHeat.oneTermParameters n)).unitary.proved =
        false ∧
      (GHL2025.oneTermRobinGate_O_D_BS_dagger
        (Examples.RobinHeat.oneTermParameters n)).unitary.proved =
        false ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).sparseAccessContract.daggerCleanup.proved =
        false ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).sparseAccessContract.unitaryExtension.proved =
        false ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).cleanupScopeDecision.semanticCleanupPromotionAllowed =
        false :=
  Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_activeOdbsGatePairBlocked n

example :
    let p := Examples.RobinHeat.oneTermParameters 3
    GHL2025.bandedSparseAccessRowDependentPaperImage p 0 =
        GHL2025.bandedSparseAccessRowDependentPaperImage p 48 ∧
      GHL2025.bandedSparseAccessPaperImage p 0 ≠
        GHL2025.bandedSparseAccessPaperImage p 48 ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).cleanupScopeDecision.selectedScope =
        GHL2025.BandedSparseAccessCleanupScope.activeGlobalSource ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).cleanupScopeDecision.semanticCleanupPromotionAllowed =
        false ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).sparseAccessContract.daggerCleanup.proved =
        false ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).oracleComposition.lcuCorrect.proved =
        false := by
  rcases
      Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_rejectedRowDependentCollisionRegression_n3
      with
    ⟨hlegacy, hactive, _hentry0, _hentry48, hscope, hpromotion,
      hcleanup, _hunitary, hlcu⟩
  exact ⟨hlegacy, hactive, hscope, hpromotion, hcleanup, hlcu⟩

example :
    let p := Examples.RobinHeat.oneTermParameters 3
    GHL2025.bandedSparseAccessPaperCleanInput p 112 = true ∧
      (GHL2025.bandedSparseAccessPaperRegisters p 112).sparseIndexValue = 7 ∧
      GHL2025.bandedSparseAccessPaperSparseIndexInKappa p 112 = false ∧
      GHL2025.bandedSparseAccessPaperGlobalSlotSource p 112 = false ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).cleanupScopeDecision.selectedScope =
        GHL2025.BandedSparseAccessCleanupScope.activeGlobalSource ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).cleanupScopeDecision.semanticCleanupPromotionAllowed =
        false ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).sparseAccessContract.daggerCleanup.proved =
        false ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).sparseAccessContract.unitaryExtension.proved =
        false ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).blockClaim.target.blockCorrect.proved =
        false ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).oracleComposition.lcuCorrect.proved =
        false :=
  Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_encodedOutOfRangeSparseSlot_n3

example (n : Nat) :
    (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).sparseAccessContract =
        GHL2025.defaultBandedSparseAccessPaperContract
          (Examples.RobinHeat.oneTermParameters n) ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).sparseAccessContract.forwardCorrect.proved =
        false ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).sparseAccessContract.daggerCleanup.proved =
        false ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).sparseAccessContract.unitaryExtension.proved =
        false ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).cleanupScopeDecision.semanticCleanupPromotionAllowed =
        false :=
  Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_sparseAccessContractIdentity n

example (n : Nat) :
    (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).sourceAnchor =
        "Guseynov-Huang-Liu 2025, Theorem one-term block-encoding, Fig. 1-term Robin, arXiv:2506.20478" ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).theoremData.alpha =
        GHL2025.oneTermRobinNormalizer ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).circuitSemantics.gateMatrices.map
        (fun gateMatrix => gateMatrix.gate) =
        GHL2025.oneTermRobinCircuit ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).cleanupScopeDecision.selectedScope =
        GHL2025.BandedSparseAccessCleanupScope.activeGlobalSource ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).cleanupScopeDecision.selectedPredicate =
        "bandedSparseAccessPaperGlobalSlotSource" ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).functionOracleSource =
        GHL2025.functionOracleExternalAmplitudeSourceContract ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).oracleComposition.functionOracle.amplitudeCorrect.proved =
        false ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).oracleComposition.lcuCorrect.proved =
        false ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).theoremData.obligations.blockExtraction.proved =
        false := by
  rcases
      Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_theoremTranscriptDependencies
        n
      with
    ⟨hsource, _hnormalizerMatches, hnormalizer, hgateList, _hflags, _hsignal,
      _hodbsSource, _himageFormula, hscope, hpredicate, _hpromotion,
      _hfullClean, _hfullSpace, _hwrappedSlot, _hfullCleanCleanup,
      _hfullCleanUnitary, hfunctionSource, _hfunctionOpen, _hcleanup,
      _hunitary, hfunctionAmp, hlcu, _hcircuitUnitary, _hblockProjection,
      _hblockCorrect, hblockExtraction⟩
  exact ⟨hsource, hnormalizer, hgateList, hscope, hpredicate, hfunctionSource,
    hfunctionAmp, hlcu, hblockExtraction⟩

example (n : Nat) :
    (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).sparseAccessContract.daggerCleanup.proved =
        false ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).sparseAccessContract.unitaryExtension.proved =
        false ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).oracleComposition.functionOracle.amplitudeCorrect.proved =
        false ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).oracleComposition.lcuCorrect.proved =
        false ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).theoremData.obligations.circuitUnitary.proved =
        false ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).blockClaim.target.blockProjection.proved =
        false ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).blockClaim.target.blockCorrect.proved =
        false ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute n).theoremData.obligations.blockExtraction.proved =
        false := by
  rcases
      Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_theoremTranscriptDependencies
        n
      with
    ⟨_hsource, _hnormalizerMatches, _hnormalizer, _hgateList, _hflags,
      _hsignal, _hodbsSource, _himageFormula, _hscope, _hpredicate,
      _hpromotion, _hfullClean, _hfullSpace, _hwrappedSlot,
      _hfullCleanCleanup, _hfullCleanUnitary, _hfunctionSource,
      _hfunctionOpen, hcleanup, hunitary, hfunctionAmp, hlcu,
      hcircuitUnitary, hblockProjection, hblockCorrect,
      hblockExtraction⟩
  exact ⟨hcleanup, hunitary, hfunctionAmp, hlcu, hcircuitUnitary,
    hblockProjection, hblockCorrect, hblockExtraction⟩

example :
    let p : GHL2025.OneTermRobinParameters :=
      Examples.RobinHeat.oneTermParameters 3
    let source : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
      ⟨48, by native_decide⟩
    ∃ (post pre : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p))),
      GHL2025.BandedSparseAccessPostSwapCleanup p source post pre ∧
        GHL2025.bandedSparseAccessPaperGlobalSlotSource p pre.val = true ∧
        (∀ (pre' : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p))),
          GHL2025.bandedSparseAccessPaperGlobalSlotSource p pre'.val = true →
          GHL2025.bandedSparseAccessPaperImage p pre'.val = post.val →
          pre'.val = pre.val) ∧
        (GHL2025.oneTermRobinGate_O_D_BS_dagger p).matrix pre post =
          Coeff.rat 1 ∧
        (GHL2025.bandedSparseAccessGlobalSlotInverseOnRangeContract
            p source.val).inverseOnRange.proved = false ∧
        (GHL2025.bandedSparseAccessGlobalSlotInverseOnRangeContract
            p source.val).daggerCleanup.proved = false ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).cleanupScopeDecision.selectedScope =
          GHL2025.BandedSparseAccessCleanupScope.activeGlobalSource ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).cleanupScopeDecision.semanticCleanupPromotionAllowed =
          false ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).blockClaim.target.blockCorrect.proved =
          false ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).oracleComposition.lcuCorrect.proved =
          false := by
  let p : GHL2025.OneTermRobinParameters :=
    Examples.RobinHeat.oneTermParameters 3
  let source : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
    ⟨48, by native_decide⟩
  rcases
      Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_odbsActiveGlobalSourceCleanupContractMap
        3 source (by native_decide) (by native_decide)
      with
    ⟨post, pre, hcleanup, _hpost, _hpre, hpreSource, hunique, hentry,
      hinverseFlag, _huniqueFlag, _himageFlag, hdaggerFlag, _hunitaryFlag,
      hscope, hpromotion, _hcleanupOpen, _hunitaryOpen, hlcu,
      _hblockProjection, hblockCorrect, _hcircuitUnitary,
      _hblockExtraction⟩
  exact ⟨post, pre, hcleanup, hpreSource, hunique, hentry, hinverseFlag,
    hdaggerFlag, hscope, hpromotion, hblockCorrect, hlcu⟩

example :
    let p : GHL2025.OneTermRobinParameters :=
      Examples.RobinHeat.oneTermParameters 3
    let source : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
      ⟨48, by native_decide⟩
    ∃ (post pre : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p))),
      GHL2025.BandedSparseAccessPostSwapCleanup p source post pre ∧
        GHL2025.bandedSparseAccessPaperGlobalSlotSource p pre.val = true ∧
        (∀ (pre' : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p))),
          GHL2025.bandedSparseAccessPaperGlobalSlotSource p pre'.val = true →
          GHL2025.bandedSparseAccessPaperImage p pre'.val = post.val →
          pre'.val = pre.val) ∧
        (GHL2025.oneTermRobinGate_O_D_BS_dagger p).matrix pre post =
          Coeff.rat 1 ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).sourceAnchor =
          "Guseynov-Huang-Liu 2025, Theorem one-term block-encoding, Fig. 1-term Robin, arXiv:2506.20478" ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).theoremData.alpha =
          GHL2025.oneTermRobinNormalizer ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).circuitSemantics.gateMatrices.map
          (fun gateMatrix => gateMatrix.gate) =
          GHL2025.oneTermRobinCircuit ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).sparseAccessContract.imageFormula =
          "r_si = r_s0 + i mod 2^n" ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).functionOracleSource =
          GHL2025.functionOracleExternalAmplitudeSourceContract ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).oracleComposition.functionOracle.amplitudeCorrect.proved =
          false ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).oracleComposition.lcuCorrect.proved =
          false ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).theoremData.obligations.blockExtraction.proved =
          false := by
  let p : GHL2025.OneTermRobinParameters :=
    Examples.RobinHeat.oneTermParameters 3
  let source : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
    ⟨48, by native_decide⟩
  rcases
      Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_theoremTranscriptActiveCleanupMap
        3 source (by native_decide) (by native_decide)
      with
    ⟨post, pre, hcleanup, _hpost, _hpre, hpreSource, hunique, hentry,
      hsourceAnchor, hnormalizer, hgateList, himageFormula, _hscope,
      _hpredicate, hfunctionSource, _hcleanupOpen, _hunitaryOpen,
      hfunctionAmp, hlcu, _hcircuitUnitary, _hblockProjection,
      _hblockCorrect, hblockExtraction⟩
  exact ⟨post, pre, hcleanup, hpreSource, hunique, hentry, hsourceAnchor,
    hnormalizer, hgateList, himageFormula, hfunctionSource, hfunctionAmp,
    hlcu, hblockExtraction⟩

example :
    let p : GHL2025.OneTermRobinParameters :=
      Examples.RobinHeat.oneTermParameters 3
    let source : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
      ⟨48, by native_decide⟩
    let gamma := GHL2025.defaultRobinWavefunctionDecomposition p
    ∃ (post pre : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p))),
      GHL2025.BandedSparseAccessPostSwapCleanup p source post pre ∧
        gamma.gamma1.boundaryNormalizer =
          Coeff.mul (Coeff.symbol "N_D") (Coeff.symbol "sqrt(kappa)") ∧
        gamma.gamma2.hasOrthogonalRemainder = true ∧
        gamma.gamma3.normalizer = GHL2025.oneTermRobinNormalizer ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).theoremData.alpha =
          gamma.gamma3.normalizer ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).blockClaim.target.normalizer =
          gamma.gamma3.normalizer ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).functionOracleSource =
          GHL2025.functionOracleExternalAmplitudeSourceContract ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).cleanupScopeDecision.selectedScope =
          GHL2025.BandedSparseAccessCleanupScope.activeGlobalSource ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).sparseAccessContract.daggerCleanup.proved =
          false ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).oracleComposition.functionOracle.amplitudeCorrect.proved =
          false ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).blockClaim.target.blockProjection.proved =
          false ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).theoremData.obligations.blockExtraction.proved =
          false := by
  let p : GHL2025.OneTermRobinParameters :=
    Examples.RobinHeat.oneTermParameters 3
  let source : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
    ⟨48, by native_decide⟩
  rcases
      Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_robinClarifiedGammaTranscript
        3 source (by native_decide) (by native_decide)
      with
    ⟨post, pre, hcleanup, _hkappa, _hK1, _hK2, _hgrid, _hg1Kappa,
      _hg1K1, _hg1K2, _hg1Grid, hg1Boundary, _hg1Bulk, _hg2Kappa,
      _hg2Normalizer, hg2Orthogonal, _hg3Kappa, hg3Normalizer,
      hg3Orthogonal, _hg3Ancilla, hrouteAlpha, htargetNormalizer,
      hfunctionSource, hscope, hcleanupOpen, _hunitaryOpen, hfunctionAmp,
      _hlcu, _hcircuitUnitary, hblockProjection, _hblockCorrect,
      hblockExtraction⟩
  exact ⟨post, pre, hcleanup, hg1Boundary, hg2Orthogonal, hg3Normalizer,
    hrouteAlpha, htargetNormalizer, hfunctionSource, hscope, hcleanupOpen,
    hfunctionAmp, hblockProjection, hblockExtraction⟩

example :
    let p : GHL2025.OneTermRobinParameters :=
      Examples.RobinHeat.oneTermParameters 3
    let source : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
      ⟨48, by native_decide⟩
    ∃ (post pre : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p))),
      GHL2025.BandedSparseAccessPostSwapCleanup p source post pre ∧
        GHL2025.bandedSparseAccessPaperCleanInput p 112 = true ∧
        (GHL2025.bandedSparseAccessPaperRegisters p 112).sparseIndexValue = 7 ∧
        GHL2025.bandedSparseAccessPaperSparseIndexInKappa p 112 = false ∧
        GHL2025.bandedSparseAccessPaperGlobalSlotSource p 112 = false ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).blockClaim =
          Examples.RobinHeat.defaultOneTermRobinCircuitBlockClaim 3 ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).functionOracleSource =
          GHL2025.functionOracleExternalAmplitudeSourceContract ∧
        GHL2025.functionOracleExternalAmplitudeSourceContract.closesFunctionOracleContract =
          false ∧
        ((GHL2025.bandedSparseAccessFullCleanDomainExtensionContract
          p).unusedBranchImageRuleContract source.val).proposedImageIndex =
          none ∧
        (GHL2025.bandedSparseAccessFullCleanDomainExtensionContract
          p).daggerCleanup.proved = false ∧
        (GHL2025.bandedSparseAccessFullCleanDomainExtensionContract
          p).unitaryExtension.proved = false ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).sparseAccessContract.daggerCleanup.proved =
          false ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).oracleComposition.functionOracle.amplitudeCorrect.proved =
          false ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).oracleComposition.lcuCorrect.proved =
          false ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).blockClaim.blockCorrect.proved =
          false ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).blockClaim.target.blockProjection.proved =
          false ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).theoremData.obligations.blockExtraction.proved =
          false := by
  let p : GHL2025.OneTermRobinParameters :=
    Examples.RobinHeat.oneTermParameters 3
  let source : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
    ⟨48, by native_decide⟩
  let i : Fin (gridSize 3) := ⟨2, by native_decide⟩
  let j : Fin (gridSize 3) := ⟨5, by native_decide⟩
  rcases
      Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_blockProjectionDependencyMap
        3 source (by native_decide) (by native_decide) i j
      with
    ⟨post, pre, hcleanup, hclaim, _hsemantics, _htarget, _hblockMatrix,
      _hrow, _hcol, _hnormalizer, _htargetMatrix, hfunctionSource,
      hfunctionCloses, hwrappedSlot, hfullCleanup, hfullUnitary, _hscope,
      hcleanupOpen, _hunitaryOpen, hfunctionAmp, hlcu, _hcircuitUnitary,
      hclaimBlockCorrect, hblockProjection, _hblockCorrect,
      hblockExtraction⟩
  rcases
      Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_encodedOutOfRangeSparseSlot_n3
      with
    ⟨hclean112, hslot112, hnotKappa112, hnotSource112, _hscope112,
      _hpromotion112, _hcleanup112, _hunitary112, _hblockCorrect112,
      _hlcu112⟩
  exact ⟨post, pre, hcleanup, hclean112, hslot112, hnotKappa112,
    hnotSource112, hclaim, hfunctionSource, hfunctionCloses, hwrappedSlot,
    hfullCleanup, hfullUnitary, hcleanupOpen, hfunctionAmp, hlcu,
    hclaimBlockCorrect, hblockProjection, hblockExtraction⟩

example :
    (GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute
      (Examples.RobinHeat.oneTermParameters 3) 2 1).coefficient =
        (GHL2025.boundaryRotationAngleNormalizerProofRoute
          (Examples.RobinHeat.oneTermParameters 3) 2 1).coefficient ∧
      (GHL2025.oneTermRobinGate_O_DT_S
        (Examples.RobinHeat.oneTermParameters 3)).unitary.proved = false ∧
      (GHL2025.oneTermRobinGate_Ry_boundary
        (Examples.RobinHeat.oneTermParameters 3)).unitary.proved = false ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute
        3).theoremData.obligations.circuitUnitary.proved = false ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute
        3).oracleComposition.functionOracle.amplitudeCorrect.proved = false ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute
        3).oracleComposition.lcuCorrect.proved = false ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute
        3).blockClaim.target.blockProjection.proved = false ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute
        3).blockClaim.target.blockCorrect.proved = false ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute
        3).theoremData.obligations.blockExtraction.proved = false := by
  rcases
      Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_derivativeBoundaryContractMap
        3 2 1
      with
    ⟨_hodts, _hry, hshared, _hnonzero, _hdivision, _hbound, _habs, _hsqrt,
      _harccos, _htwo, _hodtsDivision, _hodtsBound, _hodtsAbs,
      _hodtsSqrt, _hodtsTwo, _hryDivision, _hryArccos, _hryHalf,
      _hryBound, _hryTwo, _hgateList, _hgateFlags, _hODTSGate,
      _hODTSMatrix, _hRyGate, _hRyMatrix, hODTSUnitary, hRyUnitary,
      hcircuitUnitary, hfunctionAmp, hlcu, hblockProjection, hblockCorrect,
      hblockExtraction⟩
  rcases hshared with ⟨hcoefficient, _hnormalizer, _hboundShared⟩
  exact ⟨hcoefficient, hODTSUnitary, hRyUnitary, hcircuitUnitary,
    hfunctionAmp, hlcu, hblockProjection, hblockCorrect, hblockExtraction⟩

example :
    let p : GHL2025.OneTermRobinParameters :=
      Examples.RobinHeat.oneTermParameters 3
    let i : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
      ⟨132, by native_decide⟩
    let j : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
      ⟨132, by native_decide⟩
    let regs := GHL2025.sparseAmplitudeOracleDTPaperRegisters p j.val
    regs.rowValue = 2 ∧
      regs.sparseIndexValue = 0 ∧
      (((Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).circuitSemantics.gateMatrices.get
        ⟨1, by
          simp [Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute,
            Examples.RobinHeat.oneTermRobinCircuitSemantics,
            GHL2025.oneTermRobinGateMatrixPlaceholders]⟩).matrix i j =
        Coeff.symbol "odts_cos_half_2_0") ∧
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
        p regs.rowValue regs.sparseIndexValue).twoByTwoUnitary.proved =
        false ∧
      (GHL2025.oneTermRobinGate_O_DT_S p).unitary.proved =
        false ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).oracleComposition.lcuCorrect.proved =
        false ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).blockClaim.target.blockProjection.proved =
        false ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).theoremData.obligations.blockExtraction.proved =
        false := by
  let p : GHL2025.OneTermRobinParameters :=
    Examples.RobinHeat.oneTermParameters 3
  let i : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
    ⟨132, by native_decide⟩
  let j : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
    ⟨132, by native_decide⟩
  let regs := GHL2025.sparseAmplitudeOracleDTPaperRegisters p j.val
  rcases
      Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_odtsKetZeroEntry
        3 i j (by native_decide) (by native_decide) (by native_decide)
        (by native_decide)
      with
    ⟨_hgate, hentry, _hketZero, hnormalized, hdivision, hbound, _habs,
      _hsqrt, htwo, hunitary, hlcu, hblockProjection, _hblockCorrect,
      hblockExtraction⟩
  have hentrySymbol :
      (((Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).circuitSemantics.gateMatrices.get
        ⟨1, by
          simp [Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute,
            Examples.RobinHeat.oneTermRobinCircuitSemantics,
            GHL2025.oneTermRobinGateMatrixPlaceholders]⟩).matrix i j =
        Coeff.symbol "odts_cos_half_2_0") := by
    rw [hentry]
    native_decide
  exact ⟨by native_decide, by native_decide, hentrySymbol, hnormalized,
    hdivision, hbound, htwo, hunitary, hlcu, hblockProjection,
    hblockExtraction⟩

example :
    let p : GHL2025.OneTermRobinParameters :=
      Examples.RobinHeat.oneTermParameters 3
    let i : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
      ⟨0, by native_decide⟩
    let j : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
      ⟨0, by native_decide⟩
    let regs := GHL2025.boundaryRotationPaperRegisters p j.val
    regs.rowValue = 0 ∧
      regs.sparseIndexValue = 0 ∧
      (((Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).circuitSemantics.gateMatrices.get
        ⟨2, by
          simp [Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute,
            Examples.RobinHeat.oneTermRobinCircuitSemantics,
            GHL2025.oneTermRobinGateMatrixPlaceholders]⟩).matrix i j =
        Coeff.symbol "boundary_cos_half_0_0") ∧
      (GHL2025.boundaryRotationAngleNormalizerProofRoute
        p regs.rowValue regs.sparseIndexValue).arccosArgument =
        GHL2025.boundaryRotationNormalizedCoefficient
          p regs.rowValue regs.sparseIndexValue ∧
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
        p regs.rowValue regs.sparseIndexValue).twoByTwoUnitary.proved =
        false ∧
      (GHL2025.oneTermRobinGate_O_DT_S p).unitary.proved =
        false ∧
      (GHL2025.oneTermRobinGate_Ry_boundary p).unitary.proved =
        false ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).sparseAccessContract.daggerCleanup.proved =
        false ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).sparseAccessContract.unitaryExtension.proved =
        false ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).functionOracleSource.closesFunctionOracleContract =
        false ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).oracleComposition.functionOracle.amplitudeCorrect.proved =
        false ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).oracleComposition.lcuCorrect.proved =
        false ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).theoremData.obligations.circuitUnitary.proved =
        false ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).blockClaim.target.blockProjection.proved =
        false ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).blockClaim.target.blockCorrect.proved =
        false ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).theoremData.obligations.blockExtraction.proved =
        false := by
  let p : GHL2025.OneTermRobinParameters :=
    Examples.RobinHeat.oneTermParameters 3
  let i : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
    ⟨0, by native_decide⟩
  let j : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
    ⟨0, by native_decide⟩
  let regs := GHL2025.boundaryRotationPaperRegisters p j.val
  rcases
      Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_boundaryKetZeroEntry
        3 i j (by native_decide) (by native_decide) (by native_decide)
        (by native_decide)
      with
    ⟨_hgate, hentry, _hcosContract, harccos, _hsource, _hnonzero,
      _hdivision, _hbound, _habs, _hsqrt, _hcontractArccos,
      _hcontractTwo, hryDivision, hryArccos, hryHalf, _hryBound, hryTwo,
      hODTSUnitary, hRyUnitary, hsparseCleanup, hsparseUnitary,
      hfunctionSource, hfunctionAmp, hlcu, hcircuitUnitary,
      hblockProjection, hblockCorrect, hblockExtraction⟩
  have hentrySymbol :
      (((Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).circuitSemantics.gateMatrices.get
        ⟨2, by
          simp [Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute,
            Examples.RobinHeat.oneTermRobinCircuitSemantics,
            GHL2025.oneTermRobinGateMatrixPlaceholders]⟩).matrix i j =
        Coeff.symbol "boundary_cos_half_0_0") := by
    rw [hentry]
    native_decide
  exact ⟨by native_decide, by native_decide, hentrySymbol, harccos,
    hryDivision, hryArccos, hryHalf, hryTwo, hODTSUnitary, hRyUnitary,
    hsparseCleanup, hsparseUnitary, hfunctionSource, hfunctionAmp, hlcu,
    hcircuitUnitary, hblockProjection, hblockCorrect, hblockExtraction⟩

example :
    let p : GHL2025.OneTermRobinParameters :=
      Examples.RobinHeat.oneTermParameters 3
    let source : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
      ⟨48, by native_decide⟩
    ∃ (post pre : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p))),
      GHL2025.BandedSparseAccessPostSwapCleanup p source post pre ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).circuitSemantics.gateMatrices.map
          (fun gateMatrix => gateMatrix.unitary.proved) =
          [true, false, false, false, false, true, false] ∧
        (((Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).circuitSemantics.gateMatrices.get
          ⟨0, by
            simp [Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute,
              Examples.RobinHeat.oneTermRobinCircuitSemantics,
              GHL2025.oneTermRobinGateMatrixPlaceholders]⟩).unitary.proved =
          true) ∧
        (GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute
          p 2 1).coefficient =
          (GHL2025.boundaryRotationAngleNormalizerProofRoute p 2 1).coefficient ∧
        (((Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).circuitSemantics.gateMatrices.get
          ⟨1, by
            simp [Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute,
              Examples.RobinHeat.oneTermRobinCircuitSemantics,
              GHL2025.oneTermRobinGateMatrixPlaceholders]⟩).gate =
          Gate.oracleCall "O_DT^S") ∧
        (((Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).circuitSemantics.gateMatrices.get
          ⟨2, by
            simp [Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute,
              Examples.RobinHeat.oneTermRobinCircuitSemantics,
              GHL2025.oneTermRobinGateMatrixPlaceholders]⟩).gate =
          Gate.oracleCall "Ry_boundary") ∧
        (((Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).circuitSemantics.gateMatrices.get
          ⟨3, by
            simp [Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute,
              Examples.RobinHeat.oneTermRobinCircuitSemantics,
              GHL2025.oneTermRobinGateMatrixPlaceholders]⟩).gate =
          Gate.oracleCall "O_D^BS") ∧
        (((Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).circuitSemantics.gateMatrices.get
          ⟨4, by
            simp [Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute,
              Examples.RobinHeat.oneTermRobinCircuitSemantics,
              GHL2025.oneTermRobinGateMatrixPlaceholders]⟩).gate =
          Gate.oracleCall "O_f") ∧
        (((Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).circuitSemantics.gateMatrices.get
          ⟨5, by
            simp [Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute,
              Examples.RobinHeat.oneTermRobinCircuitSemantics,
              GHL2025.oneTermRobinGateMatrixPlaceholders]⟩).unitary.proved =
          true) ∧
        (((Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).circuitSemantics.gateMatrices.get
          ⟨6, by
            simp [Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute,
              Examples.RobinHeat.oneTermRobinCircuitSemantics,
              GHL2025.oneTermRobinGateMatrixPlaceholders]⟩).gate =
          Gate.oracleCall "(O_D^BS)^†") ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).functionOracleSource =
          GHL2025.functionOracleExternalAmplitudeSourceContract ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).functionOracleSource.closesFunctionOracleContract =
          false ∧
        (GHL2025.bandedSparseAccessFullCleanDomainExtensionContract
          p).daggerCleanup.proved = false ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).oracleComposition.lcuCorrect.proved =
          false ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).blockClaim.target.blockProjection.proved =
          false ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).theoremData.obligations.blockExtraction.proved =
          false := by
  let p : GHL2025.OneTermRobinParameters :=
    Examples.RobinHeat.oneTermParameters 3
  let source : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
    ⟨48, by native_decide⟩
  rcases
      Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_fullGateContractLedger
        3 2 1 36 source (by native_decide) (by native_decide)
      with
    ⟨post, pre, hcleanup, _hsourceAnchor, _htheoremNormalizer,
      _htargetNormalizer, _hgateList, hgateFlags, _hUIndicGate,
      _hUIndicMatrix, hUIndicUnitary, hsharedCoeff, hODTSGate,
      _hODTSMatrix, _hODTSUnitary, hRyGate, _hRyMatrix, _hRyUnitary,
      hOdbsGate, _hOdbsMatrix, _hOdbsUnitary, _himageFormula, _hscope,
      hfullCleanup, _hfullUnitary, _hcleanupOpen, _hunitaryOpen, hOfGate,
      _hOfMatrix, _hOfUnitary, hfunctionSource, hclosesContract,
      _hfunctionAmp, _hSwapGate, _hSwapMatrix, hSwapUnitary,
      hOdbsDaggerGate, _hOdbsDaggerMatrix, _hOdbsDaggerUnitary, hlcu,
      _hcircuitUnitary, hblockProjection, _hblockCorrect,
      hblockExtraction⟩
  exact ⟨post, pre, hcleanup, hgateFlags, hUIndicUnitary, hsharedCoeff,
    hODTSGate, hRyGate, hOdbsGate, hOfGate, hSwapUnitary,
    hOdbsDaggerGate, hfunctionSource, hclosesContract, hfullCleanup, hlcu,
    hblockProjection, hblockExtraction⟩

example :
    let p : GHL2025.OneTermRobinParameters :=
      Examples.RobinHeat.oneTermParameters 3
    let source : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
      ⟨48, by native_decide⟩
    ∃ (post pre : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p))),
      GHL2025.BandedSparseAccessPostSwapCleanup p source post pre ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).sourceAnchor =
          "Guseynov-Huang-Liu 2025, Theorem one-term block-encoding, Fig. 1-term Robin, arXiv:2506.20478" ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).functionOracleSource.citedSourceAnchor =
          "Guseynov-Liu 2024, arXiv:2411.01131, Theorem 5" ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).theoremData.signalQubits =
          (GHL2025.oneTermRobinLayout p).signalQubits ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).circuitSemantics.gateMatrices.map
          (fun gateMatrix => gateMatrix.unitary.proved) =
          [true, false, false, false, false, true, false] ∧
        (GHL2025.sparseAmplitudeOracleDTCoefficientNormalizerProofRoute
          p 2 1).coefficient =
          (GHL2025.boundaryRotationAngleNormalizerProofRoute p 2 1).coefficient ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).theoremData.obligations.resourceBound.proved =
          false ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).theoremData.obligations.ancillaCleanup.proved =
          false ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).oracleComposition.lcuCorrect.proved =
          false ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).blockClaim.target.blockProjection.proved =
          false ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).theoremData.obligations.blockExtraction.proved =
          false := by
  let p : GHL2025.OneTermRobinParameters :=
    Examples.RobinHeat.oneTermParameters 3
  let source : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
    ⟨48, by native_decide⟩
  let i : Fin (gridSize 3) := ⟨2, by native_decide⟩
  let j : Fin (gridSize 3) := ⟨5, by native_decide⟩
  rcases
      Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_theoremTranscriptClosurePacket
        3 2 1 36 source (by native_decide) (by native_decide) i j
      with
    ⟨post, pre, hcleanup, hsourceAnchor, _hodbsSource, _himageFormula,
      _hfunctionSource, hfunctionCited, _hfunctionOpen, _htheoremNormalizer,
      _htargetGamma, hsignalQubits, _hpureLayout, _hpureResource,
      _heffectiveSignal, _hgateList, hgateFlags, _hclaim, _htargetMatrix,
      _hrow, _hcol, hsharedCoeff, _hscope, _hpredicate, _hpromotion,
      _hfullCleanup, _hfullUnitary, hresourceBound, hancillaCleanup,
      _hcleanupOpen, _hunitaryOpen, _hfunctionAmp, hlcu, _hcircuitUnitary,
      _hclaimBlockCorrect, hblockProjection, _hblockCorrect,
      hblockExtraction⟩
  exact ⟨post, pre, hcleanup, hsourceAnchor, hfunctionCited, hsignalQubits,
    hgateFlags, hsharedCoeff, hresourceBound, hancillaCleanup, hlcu,
    hblockProjection, hblockExtraction⟩

example :
    let p : GHL2025.OneTermRobinParameters :=
      Examples.RobinHeat.oneTermParameters 3
    let source : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
      ⟨48, by native_decide⟩
    let contract := Examples.RobinHeat.oneTermRobinFiniteBlockCompositionContract 3
    ∃ (post pre : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p))),
      GHL2025.BandedSparseAccessPostSwapCleanup p source post pre ∧
        contract.lcuSourceAnchor =
          "LCU.StandardBlockEncoding; Childs-Wiebe 2012, arXiv:1202.5822; QBE cited-results row" ∧
        contract.claim =
          (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).blockClaim ∧
        contract.lcuComposition.proved = false ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).oracleComposition.lcuCorrect.proved =
          false ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).blockClaim.blockCorrect.proved =
          false ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).blockClaim.target.blockCorrect.proved =
          false ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).theoremData.obligations.blockExtraction.proved =
          false := by
  let p : GHL2025.OneTermRobinParameters :=
    Examples.RobinHeat.oneTermParameters 3
  let source : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
    ⟨48, by native_decide⟩
  let i : Fin (gridSize 3) := ⟨2, by native_decide⟩
  let j : Fin (gridSize 3) := ⟨5, by native_decide⟩
  rcases
      Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_finiteBlockCompositionContractMap
        3 2 1 36 source (by native_decide) (by native_decide) i j
      with
    ⟨post, pre, hcleanup, _hcontractSource, hcontractLCU,
      _hcontractTheorem, hclaim, _hclaimTarget, _hcontractTarget,
      _htargetMatrix, _hnormalizer, _htargetMatrixContract,
      _htargetNormalizerContract, _hcircuitContract, hlcuContract,
      _hprojectionContract, _hblockEqContract, _hfinalContract, hlcuRoute,
      _hcircuitRoute, hclaimBlockCorrect, _hblockProjection,
      hblockCorrect, hblockExtraction⟩
  exact ⟨post, pre, hcleanup, hcontractLCU, hclaim, hlcuContract, hlcuRoute,
    hclaimBlockCorrect, hblockCorrect, hblockExtraction⟩

example :
    let p : GHL2025.OneTermRobinParameters :=
      Examples.RobinHeat.oneTermParameters 3
    let source : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
      ⟨48, by native_decide⟩
    let contract := Examples.RobinHeat.oneTermRobinFiniteBlockCompositionContract 3
    let exactTheorem :=
      Examples.RobinHeat.oneTermRobinFiniteCompositionExactTheoremObligation 3
    let i : Fin (gridSize 3) := ⟨2, by native_decide⟩
    let j : Fin (gridSize 3) := ⟨5, by native_decide⟩
    ∃ (post pre : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p))),
      GHL2025.BandedSparseAccessPostSwapCleanup p source post pre ∧
        exactTheorem.source =
          "GHL2025 Theorem one-term block-encoding, Eq. ROBIN clarified, Fig. 1-term ROBIN, Definition def:block-encoding; cited-results row LCU.StandardBlockEncoding" ∧
        exactTheorem.proved = false ∧
        contract.expectedTarget.blockMatrix i j =
          contract.expectedTarget.unitaryMatrix
            ⟨signalSystemBlockRowIndex (gridSize 3)
                contract.expectedTarget.signalIndex.val i.val,
              signalSystemBlockRowIndex_lt
                contract.expectedTarget.signalIndex i⟩
            ⟨signalSystemBlockColIndex (gridSize 3)
                contract.expectedTarget.signalIndex.val j.val,
              signalSystemBlockColIndex_lt
                contract.expectedTarget.signalIndex j⟩ ∧
        contract.expectedTarget.signalIndex.val = 0 ∧
        contract.normalizedBlockEquality.proved = false ∧
        contract.finalExtraction.proved = false ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).theoremData.obligations.resourceBound.proved =
          false ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).theoremData.obligations.ancillaCleanup.proved =
          false ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).theoremData.obligations.blockExtraction.proved =
          false := by
  let p : GHL2025.OneTermRobinParameters :=
    Examples.RobinHeat.oneTermParameters 3
  let source : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
    ⟨48, by native_decide⟩
  let i : Fin (gridSize 3) := ⟨2, by native_decide⟩
  let j : Fin (gridSize 3) := ⟨5, by native_decide⟩
  rcases
      Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_finiteCompositionExactTheoremInterface
        3 2 1 36 source (by native_decide) (by native_decide) i j
      with
    ⟨post, pre, hcleanup, hexactSource, hexactFalse, _hclaim,
      _hsemantics, _hclaimTarget, _hcontractTarget, _hblockMatrixObject,
      hblockEntry, hsignalZero, _htargetMatrix, _hnormalizer,
      _hblockProjectionSource, _hblockEqDescription, _hfinalSource,
      _hcircuitContract, _hlcuContract, _hprojectionContract,
      hblockEqContract, hfinalContract, _hlcu, hresourceBound,
      hancillaCleanup, _hcircuitUnitary, _hclaimBlockCorrect,
      _hblockProjection, _hblockCorrect, hblockExtraction⟩
  exact ⟨post, pre, hcleanup, hexactSource, hexactFalse, hblockEntry,
    hsignalZero, hblockEqContract, hfinalContract, hresourceBound,
    hancillaCleanup, hblockExtraction⟩

example :
    let p : GHL2025.OneTermRobinParameters :=
      Examples.RobinHeat.oneTermParameters 3
    let source : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
      ⟨48, by native_decide⟩
    let gamma := GHL2025.defaultRobinWavefunctionDecomposition p
    let contract := Examples.RobinHeat.oneTermRobinFiniteBlockCompositionContract 3
    let entryObligation :=
      Examples.RobinHeat.oneTermRobinGamma3SignalBlockEntryObligation 3
    let i : Fin (gridSize 3) := ⟨2, by native_decide⟩
    let j : Fin (gridSize 3) := ⟨5, by native_decide⟩
    ∃ (post pre : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p))),
      GHL2025.BandedSparseAccessPostSwapCleanup p source post pre ∧
        entryObligation.source =
          "GHL2025 Eq. ROBIN clarified gamma3 line, Theorem one-term block-encoding, Fig. 1-term ROBIN, Definition def:block-encoding" ∧
        entryObligation.proved = false ∧
        gamma.gamma3.normalizer = GHL2025.oneTermRobinNormalizer ∧
        contract.normalizer = gamma.gamma3.normalizer ∧
        contract.expectedTarget.blockMatrix i j =
          contract.expectedTarget.unitaryMatrix
            ⟨signalSystemBlockRowIndex (gridSize 3)
                contract.expectedTarget.signalIndex.val i.val,
              signalSystemBlockRowIndex_lt
                contract.expectedTarget.signalIndex i⟩
            ⟨signalSystemBlockColIndex (gridSize 3)
                contract.expectedTarget.signalIndex.val j.val,
              signalSystemBlockColIndex_lt
                contract.expectedTarget.signalIndex j⟩ ∧
        contract.normalizedBlockEquality.proved = false ∧
        contract.finalExtraction.proved = false ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).blockClaim.target.blockProjection.proved =
          false ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).blockClaim.target.blockCorrect.proved =
          false ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).theoremData.obligations.blockExtraction.proved =
          false := by
  let p : GHL2025.OneTermRobinParameters :=
    Examples.RobinHeat.oneTermParameters 3
  let source : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
    ⟨48, by native_decide⟩
  let i : Fin (gridSize 3) := ⟨2, by native_decide⟩
  let j : Fin (gridSize 3) := ⟨5, by native_decide⟩
  rcases
      Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3SignalBlockEntryObligationMap
        3 2 1 36 source (by native_decide) (by native_decide) i j
      with
    ⟨post, pre, hcleanup, hentrySource, hentryFalse, _hexactSource,
      _hexactFalse, hgammaNormalizer, hcontractGamma, hblockEntry,
      _htargetMatrix, hblockEqContract, hfinalContract, _hlcu,
      _hresourceBound, _hancillaCleanup, _hcircuitUnitary,
      _hclaimBlockCorrect, hblockProjection, hblockCorrect,
      hblockExtraction⟩
  exact ⟨post, pre, hcleanup, hentrySource, hentryFalse, hgammaNormalizer,
    hcontractGamma, hblockEntry, hblockEqContract, hfinalContract,
    hblockProjection, hblockCorrect, hblockExtraction⟩

example :
    let p : GHL2025.OneTermRobinParameters :=
      Examples.RobinHeat.oneTermParameters 3
    let source : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
      ⟨48, by native_decide⟩
    let gamma := GHL2025.defaultRobinWavefunctionDecomposition p
    let contract := Examples.RobinHeat.oneTermRobinFiniteBlockCompositionContract 3
    let entryObligation :=
      Examples.RobinHeat.oneTermRobinGamma3SignalBlockEntryObligation 3
    let i : Fin (gridSize 3) := ⟨2, by native_decide⟩
    let j : Fin (gridSize 3) := ⟨5, by native_decide⟩
    ∃ (post pre : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p))),
      GHL2025.BandedSparseAccessPostSwapCleanup p source post pre ∧
        entryObligation.proved = false ∧
        contract.expectedTarget.targetMatrix i j =
          Examples.RobinHeat.oneTermRobinAkMatrix 3 i j ∧
        contract.expectedTarget.normalizer = gamma.gamma3.normalizer ∧
        contract.targetMatrix i j =
          Examples.RobinHeat.oneTermRobinAkMatrix 3 i j ∧
        contract.normalizer = gamma.gamma3.normalizer ∧
        contract.expectedTarget.blockMatrix i j =
          contract.expectedTarget.unitaryMatrix
            ⟨signalSystemBlockRowIndex (gridSize 3)
                contract.expectedTarget.signalIndex.val i.val,
              signalSystemBlockRowIndex_lt
                contract.expectedTarget.signalIndex i⟩
            ⟨signalSystemBlockColIndex (gridSize 3)
                contract.expectedTarget.signalIndex.val j.val,
              signalSystemBlockColIndex_lt
                contract.expectedTarget.signalIndex j⟩ ∧
        contract.normalizedBlockEquality.proved = false ∧
        contract.finalExtraction.proved = false ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).theoremData.obligations.blockExtraction.proved =
          false := by
  let p : GHL2025.OneTermRobinParameters :=
    Examples.RobinHeat.oneTermParameters 3
  let source : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
    ⟨48, by native_decide⟩
  let i : Fin (gridSize 3) := ⟨2, by native_decide⟩
  let j : Fin (gridSize 3) := ⟨5, by native_decide⟩
  rcases
      Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3TargetEntryData
        3 2 1 36 source (by native_decide) (by native_decide) i j
      with
    ⟨post, pre, hcleanup, hentryFalse, htargetEntry,
      htargetNormalizer, hcontractTargetEntry, hcontractGamma, hblockEntry,
      hblockEqContract, hfinalContract, _hblockProjection, _hblockCorrect,
      hblockExtraction⟩
  exact ⟨post, pre, hcleanup, hentryFalse, htargetEntry,
    htargetNormalizer, hcontractTargetEntry, hcontractGamma, hblockEntry,
    hblockEqContract, hfinalContract, hblockExtraction⟩

example :
    let p : GHL2025.OneTermRobinParameters :=
      Examples.RobinHeat.oneTermParameters 3
    let source : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
      ⟨48, by native_decide⟩
    let ofRow : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
      ⟨36, by native_decide⟩
    let ofCol : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
      ⟨36, by native_decide⟩
    let odtsRow : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
      ⟨132, by native_decide⟩
    let odtsCol : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
      ⟨132, by native_decide⟩
    let ryRow : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
      ⟨0, by native_decide⟩
    let ryCol : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
      ⟨0, by native_decide⟩
    let i : Fin (gridSize 3) := ⟨2, by native_decide⟩
    let j : Fin (gridSize 3) := ⟨5, by native_decide⟩
    let contract := Examples.RobinHeat.oneTermRobinFiniteBlockCompositionContract 3
    ∃ (post pre : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p))),
      GHL2025.BandedSparseAccessPostSwapCleanup p source post pre ∧
        contract.expectedTarget.targetMatrix i j =
          Examples.RobinHeat.oneTermRobinAkMatrix 3 i j ∧
        (((Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).circuitSemantics.gateMatrices.get
          ⟨4, by
            simp [Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute,
              Examples.RobinHeat.oneTermRobinCircuitSemantics,
              GHL2025.oneTermRobinGateMatrixPlaceholders]⟩).matrix ofRow ofCol =
          Coeff.mul (Coeff.symbol "f_3_2") (Coeff.symbol "N_f_inv")) ∧
        (((Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).circuitSemantics.gateMatrices.get
          ⟨1, by
            simp [Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute,
              Examples.RobinHeat.oneTermRobinCircuitSemantics,
              GHL2025.oneTermRobinGateMatrixPlaceholders]⟩).matrix odtsRow odtsCol =
          Coeff.symbol "odts_cos_half_2_0") ∧
        (((Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).circuitSemantics.gateMatrices.get
          ⟨2, by
            simp [Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute,
              Examples.RobinHeat.oneTermRobinCircuitSemantics,
              GHL2025.oneTermRobinGateMatrixPlaceholders]⟩).matrix ryRow ryCol =
          Coeff.symbol "boundary_cos_half_0_0") ∧
        (GHL2025.oneTermRobinGate_O_D_BS_dagger p).matrix pre post =
          Coeff.rat 1 ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).cleanupScopeDecision.semanticCleanupPromotionAllowed =
          false ∧
        contract.normalizedBlockEquality.proved = false ∧
        contract.finalExtraction.proved = false ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).oracleComposition.functionOracle.amplitudeCorrect.proved =
          false ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).oracleComposition.lcuCorrect.proved =
          false ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).theoremData.obligations.blockExtraction.proved =
          false := by
  let p : GHL2025.OneTermRobinParameters :=
    Examples.RobinHeat.oneTermParameters 3
  let source : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
    ⟨48, by native_decide⟩
  let ofRow : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
    ⟨36, by native_decide⟩
  let ofCol : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
    ⟨36, by native_decide⟩
  let odtsRow : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
    ⟨132, by native_decide⟩
  let odtsCol : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
    ⟨132, by native_decide⟩
  let ryRow : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
    ⟨0, by native_decide⟩
  let ryCol : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
    ⟨0, by native_decide⟩
  let i : Fin (gridSize 3) := ⟨2, by native_decide⟩
  let j : Fin (gridSize 3) := ⟨5, by native_decide⟩
  rcases
      Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3FactorEntryLedger
        3 2 1 36 source (by native_decide) (by native_decide) i j
        ofRow ofCol odtsRow odtsCol ryRow ryCol
        (by native_decide) (by native_decide)
        (by native_decide) (by native_decide) (by native_decide)
        (by native_decide)
        (by native_decide) (by native_decide) (by native_decide)
        (by native_decide)
      with
    ⟨post, pre, hcleanup, _hentryFalse, htargetEntry,
      _hcontractTargetEntry, _htargetNormalizer, _hcontractGamma,
      _hblockEntry, _hOfGate, hOfEntry, _hOfClean, _hFunctionSource,
      _hOdtsGate, hOdtsEntry, _hOdtsNormalized, _hOdtsTwo, _hRyGate,
      hRyEntry, _hRyArccos, _hRyTwo, _hOdbsMatrix, _hDaggerMatrix,
      _hpreSource, hdaggerEntry, _hscope, hpromotion, _hSparseCleanup,
      _hSparseUnitary, _hFunctionSourceAgain, hblockEq, hfinal,
      hfunctionAmp, hlcu, _hcircuitUnitary, _hblockProjection,
      _hblockCorrect, hblockExtraction⟩
  have hOfSymbol :
      (((Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).circuitSemantics.gateMatrices.get
        ⟨4, by
          simp [Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute,
            Examples.RobinHeat.oneTermRobinCircuitSemantics,
            GHL2025.oneTermRobinGateMatrixPlaceholders]⟩).matrix ofRow ofCol =
        Coeff.mul (Coeff.symbol "f_3_2") (Coeff.symbol "N_f_inv")) := by
    rw [hOfEntry]
    native_decide
  have hOdtsSymbol :
      (((Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).circuitSemantics.gateMatrices.get
        ⟨1, by
          simp [Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute,
            Examples.RobinHeat.oneTermRobinCircuitSemantics,
            GHL2025.oneTermRobinGateMatrixPlaceholders]⟩).matrix odtsRow odtsCol =
        Coeff.symbol "odts_cos_half_2_0") := by
    rw [hOdtsEntry]
    native_decide
  have hRySymbol :
      (((Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).circuitSemantics.gateMatrices.get
        ⟨2, by
          simp [Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute,
            Examples.RobinHeat.oneTermRobinCircuitSemantics,
            GHL2025.oneTermRobinGateMatrixPlaceholders]⟩).matrix ryRow ryCol =
        Coeff.symbol "boundary_cos_half_0_0") := by
    rw [hRyEntry]
    native_decide
  exact ⟨post, pre, hcleanup, htargetEntry, hOfSymbol, hOdtsSymbol,
    hRySymbol, hdaggerEntry, hpromotion, hblockEq, hfinal, hfunctionAmp,
    hlcu, hblockExtraction⟩

example :
    let p : GHL2025.OneTermRobinParameters :=
      Examples.RobinHeat.oneTermParameters 3
    let source : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
      ⟨48, by native_decide⟩
    let i : Fin (gridSize 3) := ⟨2, by native_decide⟩
    let j : Fin (gridSize 3) := ⟨5, by native_decide⟩
    let contract := Examples.RobinHeat.oneTermRobinFiniteBlockCompositionContract 3
    let productMatrix :=
      evalGateMatrices (GHL2025.oneTermRobinGateMatrixPlaceholders p)
    ∃ (post pre : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p))),
      GHL2025.BandedSparseAccessPostSwapCleanup p source post pre ∧
        contract.expectedTarget.blockMatrix i j =
          ((cast (by rw [Examples.RobinHeat.oneTermRobinCircuitDimCompat 3])
            productMatrix :
            Matrix
              (qubitDim (GHL2025.effectiveRobinSignalQubits p) * gridSize 3)
              (qubitDim (GHL2025.effectiveRobinSignalQubits p) * gridSize 3)
              Coeff))
            ⟨signalSystemBlockRowIndex (gridSize 3)
                contract.expectedTarget.signalIndex.val i.val,
              signalSystemBlockRowIndex_lt
                contract.expectedTarget.signalIndex i⟩
            ⟨signalSystemBlockColIndex (gridSize 3)
                contract.expectedTarget.signalIndex.val j.val,
              signalSystemBlockColIndex_lt
                contract.expectedTarget.signalIndex j⟩ ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).circuitSemantics.matrix =
          productMatrix ∧
        (GHL2025.oneTermRobinGateMatrixPlaceholders p).map
          (fun gateMatrix => gateMatrix.gate) =
          GHL2025.oneTermRobinCircuit ∧
        (GHL2025.oneTermRobinGateMatrixPlaceholders p).map
          (fun gateMatrix => gateMatrix.unitary.proved) =
          [true, false, false, false, false, true, false] ∧
        contract.normalizedBlockEquality.proved = false ∧
        contract.finalExtraction.proved = false ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).oracleComposition.lcuCorrect.proved =
          false ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).theoremData.obligations.blockExtraction.proved =
          false := by
  let p : GHL2025.OneTermRobinParameters :=
    Examples.RobinHeat.oneTermParameters 3
  let source : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
    ⟨48, by native_decide⟩
  let ofRow : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
    ⟨36, by native_decide⟩
  let ofCol : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
    ⟨36, by native_decide⟩
  let odtsRow : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
    ⟨132, by native_decide⟩
  let odtsCol : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
    ⟨132, by native_decide⟩
  let ryRow : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
    ⟨0, by native_decide⟩
  let ryCol : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
    ⟨0, by native_decide⟩
  let i : Fin (gridSize 3) := ⟨2, by native_decide⟩
  let j : Fin (gridSize 3) := ⟨5, by native_decide⟩
  rcases
      Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3SignalBlockProductEntry
        3 2 1 36 source (by native_decide) (by native_decide) i j
        ofRow ofCol odtsRow odtsCol ryRow ryCol
        (by native_decide) (by native_decide)
        (by native_decide) (by native_decide) (by native_decide)
        (by native_decide)
        (by native_decide) (by native_decide) (by native_decide)
        (by native_decide)
      with
    ⟨post, pre, hcleanup, _hentryFalse, hblockProduct, hrouteProduct,
      hgateList, hgateFlags, hblockEq, hfinal, hlcu, _hcircuitUnitary,
      _hblockProjection, _hblockCorrect, hblockExtraction⟩
  exact ⟨post, pre, hcleanup, hblockProduct, hrouteProduct, hgateList,
    hgateFlags, hblockEq, hfinal, hlcu, hblockExtraction⟩

example :
    let p : GHL2025.OneTermRobinParameters :=
      Examples.RobinHeat.oneTermParameters 3
    let source : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
      ⟨48, by native_decide⟩
    let ofRow : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
      ⟨36, by native_decide⟩
    let ofCol : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
      ⟨36, by native_decide⟩
    let odtsRow : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
      ⟨132, by native_decide⟩
    let odtsCol : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
      ⟨132, by native_decide⟩
    let ryRow : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
      ⟨0, by native_decide⟩
    let ryCol : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
      ⟨0, by native_decide⟩
    let i : Fin (gridSize 3) := ⟨2, by native_decide⟩
    let j : Fin (gridSize 3) := ⟨5, by native_decide⟩
    let contract := Examples.RobinHeat.oneTermRobinFiniteBlockCompositionContract 3
    let productMatrix :=
      evalGateMatrices (GHL2025.oneTermRobinGateMatrixPlaceholders p)
    ∃ (post pre : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p))),
      GHL2025.BandedSparseAccessPostSwapCleanup p source post pre ∧
        contract.expectedTarget.blockMatrix i j =
          ((cast (by rw [Examples.RobinHeat.oneTermRobinCircuitDimCompat 3])
            productMatrix :
            Matrix
              (qubitDim (GHL2025.effectiveRobinSignalQubits p) * gridSize 3)
              (qubitDim (GHL2025.effectiveRobinSignalQubits p) * gridSize 3)
              Coeff))
            ⟨signalSystemBlockRowIndex (gridSize 3)
                contract.expectedTarget.signalIndex.val i.val,
              signalSystemBlockRowIndex_lt
                contract.expectedTarget.signalIndex i⟩
            ⟨signalSystemBlockColIndex (gridSize 3)
                contract.expectedTarget.signalIndex.val j.val,
              signalSystemBlockColIndex_lt
                contract.expectedTarget.signalIndex j⟩ ∧
        contract.expectedTarget.targetMatrix i j =
          Examples.RobinHeat.oneTermRobinAkMatrix 3 i j ∧
        Examples.RobinHeat.oneTermRobinAkMatrix 3 i j =
          Coeff.mul (GHL2025.robinFunctionValue 3 2)
            (Examples.RobinHeat.robinDerivativeMatrix 3 i j) ∧
        (((Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).circuitSemantics.gateMatrices.get
          ⟨4, by
            simp [Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute,
              Examples.RobinHeat.oneTermRobinCircuitSemantics,
              GHL2025.oneTermRobinGateMatrixPlaceholders]⟩).matrix ofRow ofCol =
          Coeff.mul (Coeff.symbol "f_3_2") (Coeff.symbol "N_f_inv")) ∧
        (((Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).circuitSemantics.gateMatrices.get
          ⟨1, by
            simp [Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute,
              Examples.RobinHeat.oneTermRobinCircuitSemantics,
              GHL2025.oneTermRobinGateMatrixPlaceholders]⟩).matrix odtsRow odtsCol =
          Coeff.symbol "odts_cos_half_2_0") ∧
        (((Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).circuitSemantics.gateMatrices.get
          ⟨2, by
            simp [Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute,
              Examples.RobinHeat.oneTermRobinCircuitSemantics,
              GHL2025.oneTermRobinGateMatrixPlaceholders]⟩).matrix ryRow ryCol =
          Coeff.symbol "boundary_cos_half_0_0") ∧
        contract.lcuComposition.proved = false ∧
        contract.normalizedBlockEquality.proved = false ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).oracleComposition.functionOracle.amplitudeCorrect.proved =
          false ∧
        (GHL2025.oneTermRobinGate_O_DT_S p).unitary.proved = false ∧
        (GHL2025.oneTermRobinGate_Ry_boundary p).unitary.proved = false ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).sparseAccessContract.daggerCleanup.proved =
          false ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).sparseAccessContract.unitaryExtension.proved =
          false ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).oracleComposition.lcuCorrect.proved =
          false ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).theoremData.obligations.circuitUnitary.proved =
          false ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).blockClaim.target.blockProjection.proved =
          false ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).blockClaim.target.blockCorrect.proved =
          false ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).theoremData.obligations.blockExtraction.proved =
          false := by
  let p : GHL2025.OneTermRobinParameters :=
    Examples.RobinHeat.oneTermParameters 3
  let source : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
    ⟨48, by native_decide⟩
  let ofRow : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
    ⟨36, by native_decide⟩
  let ofCol : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
    ⟨36, by native_decide⟩
  let odtsRow : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
    ⟨132, by native_decide⟩
  let odtsCol : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
    ⟨132, by native_decide⟩
  let ryRow : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
    ⟨0, by native_decide⟩
  let ryCol : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
    ⟨0, by native_decide⟩
  let i : Fin (gridSize 3) := ⟨2, by native_decide⟩
  let j : Fin (gridSize 3) := ⟨5, by native_decide⟩
  rcases
      Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3AkCoefficientEntryContract
        3 2 1 36 source (by native_decide) (by native_decide) i j
        ofRow ofCol odtsRow odtsCol ryRow ryCol
        (by native_decide) (by native_decide)
        (by native_decide) (by native_decide) (by native_decide)
        (by native_decide)
        (by native_decide) (by native_decide) (by native_decide)
        (by native_decide)
      with
    ⟨post, pre, hcleanup, _hentryFalse, hblockProduct, _hrouteProduct,
      _hgateList, _hgateFlags, htargetEntry, _hcontractTargetEntry,
      hAkEntry, _hOfGate, hOfEntry, _hOfClean, _hOfUnitary, _hOdtsGate,
      hOdtsEntry, _hOdtsNormalized, hOdtsUnitary, _hRyGate, hRyEntry,
      _hRyArccos, hRyUnitary, _hOdbsMatrix, _hDaggerMatrix, _hpreSource,
      _hdaggerEntry, _hOdbsUnitary, _hOdbsDaggerUnitary, _hscope,
      _hpromotion, hSparseCleanup, hSparseUnitary, _hFunctionSource,
      hlcuContract, _hcontractProjection, hblockEq, _hfinal, hFunctionAmp,
      hlcu, hcircuitUnitary, hblockProjection, hblockCorrect,
      hblockExtraction⟩
  have hAkConcrete :
      Examples.RobinHeat.oneTermRobinAkMatrix 3 i j =
        Coeff.mul (GHL2025.robinFunctionValue 3 2)
          (Examples.RobinHeat.robinDerivativeMatrix 3 i j) := by
    simp [i] at hAkEntry ⊢
  have hOfSymbol :
      (((Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).circuitSemantics.gateMatrices.get
        ⟨4, by
          simp [Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute,
            Examples.RobinHeat.oneTermRobinCircuitSemantics,
            GHL2025.oneTermRobinGateMatrixPlaceholders]⟩).matrix ofRow ofCol =
        Coeff.mul (Coeff.symbol "f_3_2") (Coeff.symbol "N_f_inv")) := by
    rw [hOfEntry]
    native_decide
  have hOdtsSymbol :
      (((Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).circuitSemantics.gateMatrices.get
        ⟨1, by
          simp [Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute,
            Examples.RobinHeat.oneTermRobinCircuitSemantics,
            GHL2025.oneTermRobinGateMatrixPlaceholders]⟩).matrix odtsRow odtsCol =
        Coeff.symbol "odts_cos_half_2_0") := by
    rw [hOdtsEntry]
    native_decide
  have hRySymbol :
      (((Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).circuitSemantics.gateMatrices.get
        ⟨2, by
          simp [Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute,
            Examples.RobinHeat.oneTermRobinCircuitSemantics,
            GHL2025.oneTermRobinGateMatrixPlaceholders]⟩).matrix ryRow ryCol =
        Coeff.symbol "boundary_cos_half_0_0") := by
    rw [hRyEntry]
    native_decide
  exact ⟨post, pre, hcleanup, hblockProduct, htargetEntry, hAkConcrete,
    hOfSymbol, hOdtsSymbol, hRySymbol, hlcuContract, hblockEq,
    hFunctionAmp, hOdtsUnitary, hRyUnitary, hSparseCleanup, hSparseUnitary,
    hlcu, hcircuitUnitary, hblockProjection, hblockCorrect,
    hblockExtraction⟩

example :
    let p : GHL2025.OneTermRobinParameters :=
      Examples.RobinHeat.oneTermParameters 3
    let source : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
      ⟨48, by native_decide⟩
    let ofRow : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
      ⟨36, by native_decide⟩
    let ofCol : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
      ⟨36, by native_decide⟩
    let odtsRow : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
      ⟨132, by native_decide⟩
    let odtsCol : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
      ⟨132, by native_decide⟩
    let ryRow : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
      ⟨0, by native_decide⟩
    let ryCol : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
      ⟨0, by native_decide⟩
    let i : Fin (gridSize 3) := ⟨2, by native_decide⟩
    let j : Fin (gridSize 3) := ⟨5, by native_decide⟩
    let contract := Examples.RobinHeat.oneTermRobinFiniteBlockCompositionContract 3
    let entryObligation :=
      Examples.RobinHeat.oneTermRobinGamma3SignalBlockEntryObligation 3
    let productToCoefficient :=
      Examples.RobinHeat.oneTermRobinGamma3ProductToCoefficientObligation 3 i j
    let productMatrix :=
      evalGateMatrices (GHL2025.oneTermRobinGateMatrixPlaceholders p)
    ∃ (post pre : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p))),
      GHL2025.BandedSparseAccessPostSwapCleanup p source post pre ∧
        productToCoefficient.proved = false ∧
        entryObligation.proved = false ∧
        contract.expectedTarget.blockMatrix i j =
          ((cast (by rw [Examples.RobinHeat.oneTermRobinCircuitDimCompat 3])
            productMatrix :
            Matrix
              (qubitDim (GHL2025.effectiveRobinSignalQubits p) * gridSize 3)
              (qubitDim (GHL2025.effectiveRobinSignalQubits p) * gridSize 3)
              Coeff))
            ⟨signalSystemBlockRowIndex (gridSize 3)
                contract.expectedTarget.signalIndex.val i.val,
              signalSystemBlockRowIndex_lt
                contract.expectedTarget.signalIndex i⟩
            ⟨signalSystemBlockColIndex (gridSize 3)
                contract.expectedTarget.signalIndex.val j.val,
              signalSystemBlockColIndex_lt
                contract.expectedTarget.signalIndex j⟩ ∧
        contract.expectedTarget.targetMatrix i j =
          Examples.RobinHeat.oneTermRobinAkMatrix 3 i j ∧
        Examples.RobinHeat.oneTermRobinAkMatrix 3 i j =
          Coeff.mul (GHL2025.robinFunctionValue 3 2)
            (Examples.RobinHeat.robinDerivativeMatrix 3 i j) ∧
        (((Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).circuitSemantics.gateMatrices.get
          ⟨4, by
            simp [Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute,
              Examples.RobinHeat.oneTermRobinCircuitSemantics,
              GHL2025.oneTermRobinGateMatrixPlaceholders]⟩).matrix ofRow ofCol =
          Coeff.mul (Coeff.symbol "f_3_2") (Coeff.symbol "N_f_inv")) ∧
        (((Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).circuitSemantics.gateMatrices.get
          ⟨1, by
            simp [Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute,
              Examples.RobinHeat.oneTermRobinCircuitSemantics,
              GHL2025.oneTermRobinGateMatrixPlaceholders]⟩).matrix odtsRow odtsCol =
          Coeff.symbol "odts_cos_half_2_0") ∧
        (((Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).circuitSemantics.gateMatrices.get
          ⟨2, by
            simp [Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute,
              Examples.RobinHeat.oneTermRobinCircuitSemantics,
              GHL2025.oneTermRobinGateMatrixPlaceholders]⟩).matrix ryRow ryCol =
          Coeff.symbol "boundary_cos_half_0_0") ∧
        contract.lcuComposition.proved = false ∧
        contract.blockProjection.proved = false ∧
        contract.normalizedBlockEquality.proved = false ∧
        contract.finalExtraction.proved = false ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).oracleComposition.functionOracle.amplitudeCorrect.proved =
          false ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).oracleComposition.lcuCorrect.proved =
          false ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).theoremData.obligations.circuitUnitary.proved =
          false ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).blockClaim.target.blockProjection.proved =
          false ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).blockClaim.target.blockCorrect.proved =
          false ∧
        (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).theoremData.obligations.blockExtraction.proved =
          false := by
  let p : GHL2025.OneTermRobinParameters :=
    Examples.RobinHeat.oneTermParameters 3
  let source : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
    ⟨48, by native_decide⟩
  let ofRow : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
    ⟨36, by native_decide⟩
  let ofCol : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
    ⟨36, by native_decide⟩
  let odtsRow : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
    ⟨132, by native_decide⟩
  let odtsCol : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
    ⟨132, by native_decide⟩
  let ryRow : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
    ⟨0, by native_decide⟩
  let ryCol : Fin (qubitDim (GHL2025.oneTermRobinTotalQubits p)) :=
    ⟨0, by native_decide⟩
  let i : Fin (gridSize 3) := ⟨2, by native_decide⟩
  let j : Fin (gridSize 3) := ⟨5, by native_decide⟩
  rcases
      Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3ProductToCoefficientInterface
        3 2 1 36 source (by native_decide) (by native_decide) i j
        ofRow ofCol odtsRow odtsCol ryRow ryCol
        (by native_decide) (by native_decide)
        (by native_decide) (by native_decide) (by native_decide)
        (by native_decide)
        (by native_decide) (by native_decide) (by native_decide)
        (by native_decide)
      with
    ⟨post, pre, hcleanup, _hproductSource, hproductFalse, hentryFalse,
      hblockProduct, _hrouteProduct, _hgateList, _hgateFlags, htargetEntry,
      _hcontractTargetEntry, hAkEntry, hOfEntry, _hOfUnitary, hOdtsEntry,
      _hOdtsUnitary, hRyEntry, _hRyUnitary, _hdaggerEntry, _hOdbsUnitary,
      _hOdbsDaggerUnitary, _hSparseCleanup, _hSparseUnitary, hlcuContract,
      hprojectionContract, hblockEq, hfinal, hFunctionAmp, hlcu,
      hcircuitUnitary, hblockProjection, hblockCorrect, hblockExtraction⟩
  have hAkConcrete :
      Examples.RobinHeat.oneTermRobinAkMatrix 3 i j =
        Coeff.mul (GHL2025.robinFunctionValue 3 2)
          (Examples.RobinHeat.robinDerivativeMatrix 3 i j) := by
    simp [i] at hAkEntry ⊢
  have hOfSymbol :
      (((Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).circuitSemantics.gateMatrices.get
        ⟨4, by
          simp [Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute,
            Examples.RobinHeat.oneTermRobinCircuitSemantics,
            GHL2025.oneTermRobinGateMatrixPlaceholders]⟩).matrix ofRow ofCol =
        Coeff.mul (Coeff.symbol "f_3_2") (Coeff.symbol "N_f_inv")) := by
    rw [hOfEntry]
    native_decide
  have hOdtsSymbol :
      (((Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).circuitSemantics.gateMatrices.get
        ⟨1, by
          simp [Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute,
            Examples.RobinHeat.oneTermRobinCircuitSemantics,
            GHL2025.oneTermRobinGateMatrixPlaceholders]⟩).matrix odtsRow odtsCol =
        Coeff.symbol "odts_cos_half_2_0") := by
    rw [hOdtsEntry]
    native_decide
  have hRySymbol :
      (((Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).circuitSemantics.gateMatrices.get
        ⟨2, by
          simp [Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute,
            Examples.RobinHeat.oneTermRobinCircuitSemantics,
            GHL2025.oneTermRobinGateMatrixPlaceholders]⟩).matrix ryRow ryCol =
        Coeff.symbol "boundary_cos_half_0_0") := by
    rw [hRyEntry]
    native_decide
  exact ⟨post, pre, hcleanup, hproductFalse, hentryFalse, hblockProduct,
    htargetEntry, hAkConcrete, hOfSymbol, hOdtsSymbol, hRySymbol,
    hlcuContract, hprojectionContract, hblockEq, hfinal, hFunctionAmp,
    hlcu, hcircuitUnitary, hblockProjection, hblockCorrect,
    hblockExtraction⟩

example :
    let p := Examples.RobinHeat.oneTermParameters 3
    let fullDim := qubitDim (GHL2025.oneTermRobinTotalQubits p)
    GHL2025.indicatorOracleImage p 5 = 133 ∧
      GHL2025.sparseAmplitudeOracleDTRotationMatrix p
          (⟨132, by native_decide⟩ : Fin fullDim)
          (⟨133, by native_decide⟩ : Fin fullDim) =
        Coeff.neg (Coeff.symbol "odts_sin_half_2_0") ∧
      GHL2025.bandedSparseAccessPaperDaggerMatrix p
          (⟨2, by native_decide⟩ : Fin fullDim)
          (⟨160, by native_decide⟩ : Fin fullDim) =
        Coeff.rat 0 ∧
      GHL2025.bandedSparseAccessPaperPostSwapPreimageCandidate p 48 = 18 ∧
      GHL2025.bandedSparseAccessPaperImage p 78 = 30 ∧
      (Examples.RobinHeat.oneTermRobinGamma3ProductToCoefficientObligation
        3 ⟨2, by native_decide⟩ ⟨5, by native_decide⟩).proved = false ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).blockClaim.target.blockCorrect.proved =
        false := by
  native_decide

example :
    let p := Examples.RobinHeat.oneTermParameters 3
    Examples.RobinHeat.oneTermRobinGamma3PaperBasisIndex p 0 2 = 4 ∧
      Examples.RobinHeat.oneTermRobinGamma3PaperBasisIndex p 0 5 = 10 ∧
      signalSystemBlockRowIndex (gridSize 3)
          (Examples.RobinHeat.oneTermRobinFiniteBlockCompositionContract 3).expectedTarget.signalIndex.val
          2 = 2 ∧
      signalSystemBlockColIndex (gridSize 3)
          (Examples.RobinHeat.oneTermRobinFiniteBlockCompositionContract 3).expectedTarget.signalIndex.val
          5 = 5 ∧
      Examples.RobinHeat.oneTermRobinGamma3PaperBasisIndex p 0 2 ≠
        signalSystemBlockRowIndex (gridSize 3)
          (Examples.RobinHeat.oneTermRobinFiniteBlockCompositionContract 3).expectedTarget.signalIndex.val
          2 ∧
      Examples.RobinHeat.oneTermRobinGamma3PaperBasisIndex p 0 5 ≠
        signalSystemBlockColIndex (gridSize 3)
          (Examples.RobinHeat.oneTermRobinFiniteBlockCompositionContract 3).expectedTarget.signalIndex.val
          5 := by
  native_decide

example :
    let p := Examples.RobinHeat.oneTermParameters 3
    (GHL2025.bandedSparseAccessPaperRegisters p
        (Examples.RobinHeat.oneTermRobinGamma3PaperBasisIndex p 0 5)).rowValue = 5 ∧
      GHL2025.bandedSparseAccessPaperGlobalSlotSource p
          (Examples.RobinHeat.oneTermRobinGamma3PaperBasisIndex p 0 5) = true ∧
      GHL2025.indicatorOracleImage p
          (Examples.RobinHeat.oneTermRobinGamma3PaperBasisIndex p 0 5) = 138 ∧
      (GHL2025.sparseAmplitudeOracleDTPaperRegisters p 138).indicatorBit = 1 ∧
      (GHL2025.sparseAmplitudeOracleDTPaperRegisters p 138).ancillaBit = 0 := by
  native_decide

example :
    let p := Examples.RobinHeat.oneTermParameters 3
    let slot5Col := Examples.RobinHeat.oneTermRobinGamma3PaperBasisIndex p 5 5
    let slot5Row := Examples.RobinHeat.oneTermRobinGamma3PaperBasisIndex p 5 2
    GHL2025.oneTermRobinGlobalSparseAddress 3 0 5 = 3 ∧
      GHL2025.oneTermRobinGlobalSparseAddress 3 5 5 = 2 ∧
      slot5Col = 90 ∧
      slot5Row = 84 ∧
      GHL2025.bandedSparseAccessPaperAddress p slot5Col = 2 ∧
      GHL2025.swapOracleImage p
          (GHL2025.bandedSparseAccessPaperImage p slot5Col) =
        slot5Row ∧
      (Examples.RobinHeat.oneTermRobinGamma3ProductToCoefficientObligation
          3 ⟨2, by native_decide⟩ ⟨5, by native_decide⟩).proved =
        false ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).blockClaim.target.blockCorrect.proved =
        false := by
  native_decide

example :
    let p := Examples.RobinHeat.oneTermParameters 3
    let sysRow : Fin (gridSize 3) := ⟨2, by native_decide⟩
    let sysCol : Fin (gridSize 3) := ⟨5, by native_decide⟩
    let slot5Col := Examples.RobinHeat.oneTermRobinGamma3PaperBasisIndex p 5 5
    let slot5Row := Examples.RobinHeat.oneTermRobinGamma3PaperBasisIndex p 5 2
    let projectedRow :=
      signalSystemBlockRowIndex (gridSize 3)
        (Examples.RobinHeat.oneTermRobinFiniteBlockCompositionContract 3).expectedTarget.signalIndex.val
        sysRow.val
    let projectedCol :=
      signalSystemBlockColIndex (gridSize 3)
        (Examples.RobinHeat.oneTermRobinFiniteBlockCompositionContract 3).expectedTarget.signalIndex.val
        sysCol.val
    (Examples.RobinHeat.oneTermRobinGamma3ProjectionSlotConventionObligation
        3 sysRow sysCol).proved = false ∧
      slot5Row = 84 ∧
      slot5Col = 90 ∧
      projectedRow = 2 ∧
      projectedCol = 5 ∧
      slot5Row ≠ projectedRow ∧
      slot5Col ≠ projectedCol ∧
      GHL2025.bandedSparseAccessPaperGlobalSlotSource p slot5Col = true ∧
      GHL2025.swapOracleImage p
          (GHL2025.bandedSparseAccessPaperImage p slot5Col) =
        slot5Row ∧
      (Examples.RobinHeat.oneTermRobinGamma3ProductToCoefficientObligation
          3 sysRow sysCol).proved = false ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).blockClaim.target.blockCorrect.proved =
        false := by
  native_decide

example :
    let p := Examples.RobinHeat.oneTermParameters 3
    let fullDim := qubitDim (GHL2025.oneTermRobinTotalQubits p)
    let slot5Col := Examples.RobinHeat.oneTermRobinGamma3PaperBasisIndex p 5 5
    let slot5Row := Examples.RobinHeat.oneTermRobinGamma3PaperBasisIndex p 5 2
    let afterIndic := GHL2025.indicatorOracleImage p slot5Col
    let afterOdbs := GHL2025.bandedSparseAccessPaperImage p afterIndic
    let afterSwap := GHL2025.swapOracleImage p afterOdbs
    let daggerPre :=
      GHL2025.bandedSparseAccessPaperPostSwapPreimageCandidate p afterIndic
    let row84 : Fin fullDim := ⟨84, by native_decide⟩
    let row228 : Fin fullDim := ⟨228, by native_decide⟩
    let col212 : Fin fullDim := ⟨212, by native_decide⟩
    slot5Col = 90 ∧
      slot5Row = 84 ∧
      afterIndic = 218 ∧
      afterOdbs = 170 ∧
      afterSwap = 212 ∧
      daggerPre = 228 ∧
      GHL2025.bandedSparseAccessPaperDaggerMatrix p row228 col212 =
        Coeff.rat 1 ∧
      GHL2025.bandedSparseAccessPaperDaggerMatrix p row84 col212 =
        Coeff.rat 0 ∧
      (GHL2025.bandedSparseAccessPaperRegisters p daggerPre).sparseIndexValue =
        6 ∧
      (GHL2025.bandedSparseAccessPaperRegisters p slot5Row).sparseIndexValue =
        5 ∧
      (Examples.RobinHeat.oneTermRobinGamma3ProjectionSlotConventionObligation
          3 ⟨2, by native_decide⟩ ⟨5, by native_decide⟩).proved =
        false ∧
      (Examples.RobinHeat.oneTermRobinGamma3ProductToCoefficientObligation
          3 ⟨2, by native_decide⟩ ⟨5, by native_decide⟩).proved =
        false ∧
      (Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute 3).blockClaim.target.blockCorrect.proved =
        false := by
  native_decide

example :
    let p := Examples.RobinHeat.oneTermParameters 3
    let slot5Row := Examples.RobinHeat.oneTermRobinGamma3PaperBasisIndex p 5 2
    let slot5Col := Examples.RobinHeat.oneTermRobinGamma3PaperBasisIndex p 5 5
    let afterIndic := GHL2025.indicatorOracleImage p slot5Col
    let finalEndpoint :=
      GHL2025.bandedSparseAccessPaperPostSwapPreimageCandidate p afterIndic
    let firstBlockingField := "indicatorBit"
    firstBlockingField = "indicatorBit" ∧
      finalEndpoint = 228 ∧
      slot5Row = 84 ∧
      (GHL2025.sparseAmplitudeOracleDTPaperRegisters p finalEndpoint).indicatorBit =
        1 ∧
      (GHL2025.sparseAmplitudeOracleDTPaperRegisters p slot5Row).indicatorBit =
        0 ∧
      (GHL2025.bandedSparseAccessPaperRegisters p finalEndpoint).sparseIndexValue =
        6 ∧
      (GHL2025.bandedSparseAccessPaperRegisters p slot5Row).sparseIndexValue =
        5 ∧
      (Examples.RobinHeat.oneTermRobinGamma3ProjectionSlotConventionObligation
          3 ⟨2, by native_decide⟩ ⟨5, by native_decide⟩).proved =
        false := by
  have _audit :=
    Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3Slot5ProjectionRegisterAudit_n3
  native_decide

example :
    let decision :=
      Examples.RobinHeat.oneTermRobinGamma3ProjectionRegisterConventionDecision_n3
    decision.auditCheck = true ∧
      decision.productSearchBlocked = true ∧
      decision.classification =
        "source-contract-gap plus internal-paper-step" ∧
      decision.requiredDecision.proved = false ∧
      decision.projectionSlotConventionProved = false ∧
      decision.productToCoefficientProved = false ∧
      decision.blockCorrectProved = false := by
  have _decision :=
    Examples.RobinHeat.oneTermRobinGamma3ProjectionRegisterConventionDecision_n3_transcript
  native_decide

example :
    let convention :=
      Examples.RobinHeat.oneTermRobinGamma3SparseRegisterSummationConvention_n3
    convention.chosenConvention = "sparse-register summation" ∧
      convention.summedSlotRange = "s = 0..kappa-1" ∧
      convention.cleanEndpoint = 84 ∧
      convention.fullEndpoint = 228 ∧
      convention.cleanSystemRow = 2 ∧
      convention.fullSystemRow = 2 ∧
      convention.cleanIndicator = 0 ∧
      convention.fullIndicator = 1 ∧
      convention.indicatorMismatchHandledBySummation = false ∧
      convention.indicatorMismatchObligation.proved = false ∧
      convention.cleanSparseIndex = 5 ∧
      convention.fullSparseIndex = 6 ∧
      convention.productSearchBlocked = true ∧
      convention.productToCoefficientProved = false ∧
      convention.blockCorrectProved = false := by
  have _convention :=
    Examples.RobinHeat.oneTermRobinGamma3SparseRegisterSummationConvention_n3_transcript
  native_decide

example :
    let convention :=
      Examples.RobinHeat.oneTermRobinGamma3SparseRegisterSummationConvention_n3
    convention.indicatorMismatchHandledBySummation = false ∧
      convention.indicatorMismatchObligation.proved = false ∧
      convention.cleanIndicator = 0 ∧
      convention.fullIndicator = 1 ∧
      convention.cleanIndicator ≠ convention.fullIndicator ∧
      convention.productSearchBlocked = true ∧
      convention.productToCoefficientProved = false ∧
      convention.blockProjectionProved = false ∧
      convention.blockCorrectProved = false ∧
      convention.finalExtractionProved = false := by
  have _gap :=
    Examples.RobinHeat.oneTermRobinGamma3SparseRegisterSummation_indicatorGap_n3
  native_decide

example :
    let convention :=
      Examples.RobinHeat.oneTermRobinGamma3IndicatorProjectionConvention_n3
    convention.cleanEndpoint = 84 ∧
      convention.fullEndpoint = 228 ∧
      convention.cleanIndicator = 0 ∧
      convention.fullIndicator = 1 ∧
      convention.cleanIndicator ≠ convention.fullIndicator ∧
      convention.indicatorRelationSpecifiedBySource = false ∧
      convention.humanInputRequired = true ∧
      convention.conventionObligation.proved = false ∧
      convention.sparseSummationConvention.indicatorMismatchObligation.proved =
        false ∧
      convention.productSearchBlocked = true ∧
      convention.productToCoefficientProved = false ∧
      convention.blockProjectionProved = false ∧
      convention.blockCorrectProved = false ∧
      convention.finalExtractionProved = false := by
  have _convention :=
    Examples.RobinHeat.oneTermRobinGamma3IndicatorProjectionConvention_n3_transcript
  native_decide

example :
    let convention :=
      Examples.RobinHeat.oneTermRobinGamma3IndicatorProjectionConvention_n3
    convention.sourceAnchor =
        "GHL2025 Eq. ROBIN clarified, Fig. 1-term ROBIN, Definition def:block-encoding, arXiv:2506.20478" ∧
      convention.requiredConvention =
        "state whether the theorem projection sums, ignores, resets, or permutes the indicator field relating endpoint 228 to endpoint 84" ∧
      convention.conventionObligation.description =
        "indicator projection/register rule after sparse-register summation for the gamma3 endpoint pair 228 and 84" ∧
      convention.conventionObligation.source =
        "GHL2025 Eq. ROBIN clarified, Fig. 1-term ROBIN, Definition def:block-encoding; QBE gamma3 sparse-register summation indicator gap" ∧
      convention.conventionObligation.proved = false ∧
      convention.indicatorRelationSpecifiedBySource = false ∧
      convention.humanInputRequired = true ∧
      convention.productSearchBlocked = true ∧
      convention.productToCoefficientProved = false ∧
      convention.blockCorrectProved = false ∧
      convention.finalExtractionProved = false := by
  have _convention :=
    Examples.RobinHeat.oneTermRobinGamma3IndicatorProjectionConvention_n3_transcript
  native_decide

example :
    let audit :=
      Examples.RobinHeat.oneTermRobinGamma3BulkIndicatorSourceAudit_n3
    audit.focusedSystemColumn = 5 ∧
      audit.isBulkColumn = true ∧
      audit.sourceBulkIndicator = 1 ∧
      audit.fullEndpoint = 228 ∧
      audit.fullIndicator = 1 ∧
      audit.fullEndpointMatchesSourceBulkIndicator = true ∧
      audit.cleanEndpoint = 84 ∧
      audit.cleanIndicator = 0 ∧
      audit.cleanEndpointMatchesSourceBulkIndicator = false ∧
      audit.sourceStatesResetRule = false ∧
      audit.indicatorConvention.humanInputRequired = true ∧
      audit.conventionObligationProved = false ∧
      audit.productSearchBlocked = true ∧
      audit.productToCoefficientProved = false ∧
      audit.blockProjectionProved = false ∧
      audit.blockCorrectProved = false ∧
      audit.finalExtractionProved = false := by
  have _audit :=
    Examples.RobinHeat.oneTermRobinGamma3BulkIndicatorSourceAudit_n3_transcript
  native_decide

-- Omitted bulk gamma3 packet: for displayed-omitted column j=5, slot 5
-- follows the source-backed bulk path with indicator 1 and endpoint 228.
example :
    let interface :=
      Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3BulkProductToCoefficientInterface_n3
    interface.systemRow = 2 ∧
      interface.systemColumn = 5 ∧
      interface.sparseSlot = 5 ∧
      interface.bulkColumnIsBulk = true ∧
      interface.bulkBranchIsOmittedByDisplay = true ∧
      interface.fullEndpointUsed = true ∧
      interface.cleanBoundaryEndpointComparisonUsed = false ∧
      interface.cleanSource = 90 ∧
      interface.afterIndic = 218 ∧
      interface.sourceBulkIndicator = 1 ∧
      interface.afterOdbsKetZero = 170 ∧
      interface.afterSwapKetZero = 212 ∧
      interface.daggerKetZeroEndpoint = 228 ∧
      interface.ketZeroFactors = [
        Coeff.rat 1,
        Coeff.symbol "odts_cos_half_5_5",
        Coeff.rat 1,
        Coeff.rat 1,
        Coeff.mul (Coeff.symbol "f_3_5") (Coeff.symbol "N_f_inv"),
        Coeff.rat 1,
        Coeff.rat 1
      ] ∧
      interface.productObligation.proved = false ∧
      interface.indicatorProjectionConvention.proved = false ∧
      interface.uniquePathSupportObligation.proved = false ∧
      interface.derivativeAmplitudeNormalizerProved = false ∧
      interface.productToCoefficientProved = false ∧
      interface.lcuCorrectProved = false ∧
      interface.blockProjectionProved = false ∧
      interface.blockCorrectProved = false ∧
      interface.finalExtractionProved = false := by
  have _bulk :=
    Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3BulkProductToCoefficientInterface_n3_transcript
  native_decide

-- Branch-correct boundary gamma3 packet: for displayed column j=0, slot 2 is
-- the sparse slot that routes column 0 back to row 0; product flags stay false.
example :
    let p := Examples.RobinHeat.oneTermParameters 3
    let branch := Examples.RobinHeat.oneTermRobinGamma3BranchCorrectSourceMap_n3
    let sysRow : Fin (gridSize 3) := ⟨0, by native_decide⟩
    let sysCol : Fin (gridSize 3) := ⟨0, by native_decide⟩
    let slot0Col := Examples.RobinHeat.oneTermRobinGamma3PaperBasisIndex
      p 0 sysCol.val
    let slot2Col := Examples.RobinHeat.oneTermRobinGamma3PaperBasisIndex
      p 2 sysCol.val
    let slot2Row := Examples.RobinHeat.oneTermRobinGamma3PaperBasisIndex
      p 2 sysRow.val
    branch.boundaryColumn = 0 ∧
      branch.boundaryColumnIsBoundary = true ∧
      branch.boundaryColumnIsBulk = false ∧
      slot0Col = 0 ∧
      GHL2025.oneTermRobinGlobalSparseAddress 3 0 sysCol.val = 6 ∧
      GHL2025.oneTermRobinGlobalSparseAddress 3 2 sysCol.val =
        sysRow.val ∧
      slot2Col = 32 ∧
      slot2Row = 32 ∧
      GHL2025.indicatorOracleImage p slot2Col = slot2Col ∧
      GHL2025.bandedSparseAccessPaperImage p slot2Col = 0 ∧
      GHL2025.swapOracleImage p
          (GHL2025.bandedSparseAccessPaperImage p slot2Col) = 0 ∧
      GHL2025.bandedSparseAccessPaperPostSwapPreimageCandidate p slot2Col =
        slot2Row ∧
      branch.boundaryProductObligation.proved = false ∧
      (Examples.RobinHeat.oneTermRobinGamma3ProductToCoefficientObligation
          3 sysRow sysCol).proved = false ∧
      branch.lcuCorrectProved = false ∧
      branch.blockProjectionProved = false ∧
      branch.blockCorrectProved = false ∧
      branch.finalExtractionProved = false := by
  have _audit :=
    Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3BoundaryBranchPathAudit_n3
  native_decide

-- Boundary gamma3 product interface: the branch factor list is now compiled,
-- but unique-path support and product-to-coefficient remain false obligations.
example :
    let interface :=
      Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3BoundaryProductToCoefficientInterface_n3
    interface.systemRow = 0 ∧
      interface.systemColumn = 0 ∧
      interface.sparseSlot = 2 ∧
      interface.cleanSource = 32 ∧
      interface.afterIndic = 32 ∧
      interface.afterOdbsKetZero = 0 ∧
      interface.afterOdbsKetOne = 1 ∧
      interface.daggerKetZeroEndpoint = 32 ∧
      interface.daggerKetOneEndpoint = 33 ∧
      interface.ketZeroFactors = [
        Coeff.rat 1,
        Coeff.rat 1,
        Coeff.symbol "boundary_cos_half_0_2",
        Coeff.rat 1,
        Coeff.mul (Coeff.symbol "f_3_0") (Coeff.symbol "N_f_inv"),
        Coeff.rat 1,
        Coeff.rat 1
      ] ∧
      interface.uniquePathSupportObligation.proved = false ∧
      interface.exactProductEqualityProved = false ∧
      interface.productToCoefficientProved = false ∧
      interface.lcuCorrectProved = false ∧
      interface.blockProjectionProved = false ∧
      interface.blockCorrectProved = false ∧
      interface.finalExtractionProved = false := by
  have _interface :=
    Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3BoundaryProductToCoefficientInterface_n3_transcript
  native_decide

-- Boundary unique-path support audit: the adjacent ket-one target contribution
-- has concrete zero entries, while the all-other-path support theorem remains
-- the next obligation.
example :
    let p := Examples.RobinHeat.oneTermParameters 3
    let fullDim := qubitDim (GHL2025.oneTermRobinTotalQubits p)
    let audit :=
      Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3BoundaryUniquePathSupportAudit_n3
    let row0 : Fin fullDim := ⟨0, by native_decide⟩
    let row1 : Fin fullDim := ⟨1, by native_decide⟩
    let row32 : Fin fullDim := ⟨32, by native_decide⟩
    let row33 : Fin fullDim := ⟨33, by native_decide⟩
    audit.survivingKetZeroPath = [32, 32, 32, 32, 0, 0, 0, 32] ∧
      audit.adjacentKetOnePath = [32, 32, 32, 33, 1, 1, 1, 33] ∧
      GHL2025.sparseAmplitudeOracleDTRotationMatrix p row33 row32 =
        Coeff.rat 0 ∧
      GHL2025.functionOraclePaperMatrix p row0 row1 = Coeff.rat 0 ∧
      GHL2025.bandedSparseAccessPaperDaggerMatrix p row32 row1 =
        Coeff.rat 0 ∧
      audit.adjacentBranchKilledAtOf = true ∧
      audit.adjacentBranchKilledAtDagger = true ∧
      audit.firstMissingGateIndex = 3 ∧
      audit.firstMissingSupportColumn = 32 ∧
      audit.supportComplete = false ∧
      audit.uniquePathSupportObligation.proved = false ∧
      audit.productToCoefficientProved = false ∧
      audit.blockCorrectProved = false ∧
      audit.finalExtractionProved = false := by
  have _support :=
    Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3BoundaryUniquePathSupport_n3
  native_decide

-- Boundary gamma3 prefix support: after `O_D^BS * Ry_boundary * O_DT^S *
-- U_indic`, source column 32 has evaluated support only in rows 0 and 1.
example :
    let env : String → Rat := fun _ => 0
    let row2 : Fin Examples.RobinHeat.oneTermRobinGamma3BoundaryPrefixDim_n3 :=
      ⟨2, by native_decide⟩
    Coeff.evalWith env
      (Examples.RobinHeat.oneTermRobinGamma3BoundaryPrefixMatrix_n3
        row2 Examples.RobinHeat.oneTermRobinGamma3BoundaryPrefixSource_n3) = 0 := by
  exact
    Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3BoundaryPrefixSupport_n3
      (fun _ => 0) ⟨2, by native_decide⟩ (by native_decide) (by native_decide)

-- Boundary gamma3 seven-gate support: the adjacent row-1 branch is killed by
-- the suffix after the compiled prefix-support step.
example :
    let env : String → Rat := fun _ => 0
    Coeff.evalWith env
        (Examples.RobinHeat.oneTermRobinGamma3BoundarySuffixMatrix_n3
          Examples.RobinHeat.oneTermRobinGamma3BoundaryPrefixSource_n3
          Examples.RobinHeat.oneTermRobinGamma3BoundaryPrefixRow1_n3) *
      Coeff.evalWith env
        (Examples.RobinHeat.oneTermRobinGamma3BoundaryPrefixMatrix_n3
          Examples.RobinHeat.oneTermRobinGamma3BoundaryPrefixRow1_n3
          Examples.RobinHeat.oneTermRobinGamma3BoundaryPrefixSource_n3) = 0 := by
  exact
    Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3BoundarySevenGateSupport_n3
      (fun _ => 0) Examples.RobinHeat.oneTermRobinGamma3BoundaryPrefixRow1_n3
      (by native_decide)

-- The focused seven-gate row-32/column-32 entry reduces to the row-0
-- intermediate branch; this is not yet the product-to-coefficient theorem.
example :
    let env : String → Rat := fun _ => 0
    Coeff.evalWith env
      (Examples.RobinHeat.oneTermRobinGamma3BoundarySevenGateMatrix_n3
        Examples.RobinHeat.oneTermRobinGamma3BoundaryPrefixSource_n3
        Examples.RobinHeat.oneTermRobinGamma3BoundaryPrefixSource_n3) =
      Coeff.evalWith env
        (Examples.RobinHeat.oneTermRobinGamma3BoundarySuffixMatrix_n3
          Examples.RobinHeat.oneTermRobinGamma3BoundaryPrefixSource_n3
          Examples.RobinHeat.oneTermRobinGamma3BoundaryPrefixRow0_n3) *
      Coeff.evalWith env
        (Examples.RobinHeat.oneTermRobinGamma3BoundaryPrefixMatrix_n3
          Examples.RobinHeat.oneTermRobinGamma3BoundaryPrefixRow0_n3
          Examples.RobinHeat.oneTermRobinGamma3BoundaryPrefixSource_n3) := by
  exact
    Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3BoundarySevenGateUniquePath_n3
      (fun _ => 0)

-- The focused seven-gate row-32/column-32 entry now evaluates to the
-- branch-local boundary cosine times the clean O_f amplitude.  The final
-- product-to-Ak coefficient theorem remains a separate obligation.
example :
    let env : String → Rat := fun s =>
      if s = "f_3_0" then 2
      else if s = "N_f_inv" then 3
      else if s = "boundary_cos_half_0_2" then 5
      else 0
    Coeff.evalWith env
      (Examples.RobinHeat.oneTermRobinGamma3BoundarySevenGateMatrix_n3
        Examples.RobinHeat.oneTermRobinGamma3BoundaryPrefixSource_n3
        Examples.RobinHeat.oneTermRobinGamma3BoundaryPrefixSource_n3) =
      (env "f_3_0" * env "N_f_inv") * env "boundary_cos_half_0_2" := by
  exact
    Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3BoundaryProductEntryEval_n3
      (fun s =>
        if s = "f_3_0" then 2
        else if s = "N_f_inv" then 3
        else if s = "boundary_cos_half_0_2" then 5
        else 0)

-- The focused boundary Ry coefficient bridge is only a source-contract gap.
example :
    let bridge := Examples.RobinHeat.oneTermRobinGamma3BoundaryRyCoefficientBridge_n3
    bridge.cosHalfEntry = Coeff.symbol "boundary_cos_half_0_2" ∧
      bridge.normalizedCoefficient =
        GHL2025.boundaryRotationNormalizedCoefficient
          (Examples.RobinHeat.oneTermParameters 3) 0 2 ∧
      bridge.normalizedCoefficient =
        Coeff.mul (GHL2025.robinGlobalSparseAmplitudeValue 3 2 0)
          (Coeff.symbol "N_D_inv") ∧
      bridge.angleConventionObligation.proved = false ∧
      bridge.productObligation.proved = false ∧
      bridge.boundaryHalfAngleSemanticsProved = false ∧
      bridge.productToCoefficientProved = false ∧
      bridge.lcuCorrectProved = false ∧
      bridge.blockProjectionProved = false ∧
      bridge.blockCorrectProved = false ∧
      bridge.finalExtractionProved = false := by
  native_decide

-- The boundary Ry angle-convention decision blocks product proof search.
example :
    let decision :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryRyAngleConventionDecision_n3
    decision.sourceSpecifiesDirectHalfAngleCoefficientRule = false ∧
      decision.humanInputRequired = true ∧
      decision.productSearchBlocked = true ∧
      decision.decisionObligation.proved = false ∧
      decision.angleConventionObligationProved = false ∧
      decision.boundaryHalfAngleSemanticsProved = false ∧
      decision.productToCoefficientProved = false ∧
      decision.lcuCorrectProved = false ∧
      decision.blockProjectionProved = false ∧
      decision.blockCorrectProved = false ∧
      decision.finalExtractionProved = false := by
  have _decision :=
    Examples.RobinHeat.oneTermRobinGamma3BoundaryRyAngleConventionDecision_n3_transcript
  native_decide

-- Lower packets must not resume product proof search while the boundary Ry
-- angle convention decision is still open.
example :
    let guard :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryRyLowerPacketGuard_n3
    guard.decision.humanInputRequired = true ∧
      guard.decision.productSearchBlocked = true ∧
      guard.lowerProductProofPacketAllowed = false ∧
      guard.sourceBackedConventionPacketAllowed = true ∧
      guard.bridgeObligationProved = false ∧
      guard.decisionObligationProved = false ∧
      guard.productToCoefficientProved = false ∧
      guard.lcuCorrectProved = false ∧
      guard.blockProjectionProved = false ∧
      guard.blockCorrectProved = false ∧
      guard.finalExtractionProved = false := by
  have _guard :=
    Examples.RobinHeat.oneTermRobinGamma3BoundaryRyLowerPacketGuard_n3_transcript
  native_decide

-- Source-evidence boundary for the frozen boundary Ry route: future work must
-- supply a paper-backed convention or keep the coefficient bridge open.
example :
    let guard :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryRyLowerPacketGuard_n3
    guard.guardReason =
        "product-to-coefficient search is blocked until the boundary Ry angle convention has source-backed or human input" ∧
      guard.decision.acceptedSourceBackedOptions =
        "either keep standard Ry and leave the coefficient bridge as a theorem gap, or supply an author/paper-backed boundary amplitude-preparation convention" ∧
      guard.decision.sourceSpecifiesDirectHalfAngleCoefficientRule = false ∧
      guard.decision.bridge.thetaFormula =
        "theta_j^s = arccos(D_j^(s) / N_D)" ∧
      guard.decision.bridge.cosHalfFormula =
        "sqrt((1 + D_j^(s) / N_D) / 2)" ∧
      guard.decision.bridge.angleConventionObligation.source =
        "GHL2025 Eq. angles for Ry and Eq. ROBIN clarified, arXiv:2506.20478; source-contract gap recorded in cited-results row GHL2025.RyBoundary.AngleConventionBoundarySlot2" ∧
      guard.decision.decisionObligation.source =
        "GHL2025 Eq. angles for Ry and Eq. ROBIN clarified; QBE bridge oneTermRobinGamma3BoundaryRyCoefficientBridge_n3" ∧
      guard.lowerProductProofPacketAllowed = false ∧
      guard.sourceBackedConventionPacketAllowed = true ∧
      guard.productToCoefficientProved = false := by
  have _guard :=
    Examples.RobinHeat.oneTermRobinGamma3BoundaryRyLowerPacketGuard_n3_transcript
  native_decide

-- Source-backed correction: standard Ry uses half-angle entries, so the
-- faithful continuation is the corrected input angle `2 * arccos(D/N_D)`.
example :
    let decision :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryRyCorrectedAngleSourceDecision_n3
    decision.correctedThetaFormula =
        "theta_j^s = 2 arccos(D_j^(s) / N_D)" ∧
      decision.correctedAngleSourceBacked = true ∧
      decision.useStandardRyMatrixConvention = true ∧
      decision.directCoefficientEntryAllowed = true ∧
      decision.productSearchBlocked = false ∧
      decision.lowerProductProofPacketAllowed = true ∧
      decision.semanticFlagsRemainFalseUntilLeanProof = true ∧
      decision.productToCoefficientProved = false ∧
      decision.lcuCorrectProved = false ∧
      decision.blockProjectionProved = false ∧
      decision.blockCorrectProved = false ∧
      decision.finalExtractionProved = false := by
  have _decision :=
    Examples.RobinHeat.oneTermRobinGamma3BoundaryRyCorrectedAngleSourceDecision_n3_transcript
  native_decide

-- The corrected-angle route now has a conditional coefficient interface.
example :
    let interface :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryCorrectedCoefficientInterface_n3
    interface.productEntryFactor = Coeff.symbol "boundary_cos_half_0_2" ∧
      interface.normalizedCoefficient =
        GHL2025.boundaryRotationNormalizedCoefficient
          (Examples.RobinHeat.oneTermParameters 3) 0 2 ∧
      interface.correctedEntryHypothesis.proved = false ∧
      interface.productObligation.proved = false ∧
      interface.correctedAngleSourceBacked = true ∧
      interface.coefficientInterfaceCompiled = true ∧
      interface.productToCoefficientProved = false ∧
      interface.lcuCorrectProved = false ∧
      interface.blockProjectionProved = false ∧
      interface.blockCorrectProved = false ∧
      interface.finalExtractionProved = false := by
  have _interface :=
    Examples.RobinHeat.oneTermRobinGamma3BoundaryCorrectedCoefficientInterface_n3_transcript
  native_decide

-- Under the corrected-entry environment hypothesis, the boundary product uses
-- the normalized coefficient instead of the unresolved free symbol.
example :
    let env : String → Rat := fun s =>
      if s = "f_3_0" then 3
      else if s = "N_f_inv" then 4
      else if s = "N_D_inv" then 2
      else if s = "A1*dx" then 0
      else if s = "boundary_cos_half_0_2" then -5
      else 0
    Coeff.evalWith env
      (Examples.RobinHeat.oneTermRobinGamma3BoundarySevenGateMatrix_n3
        Examples.RobinHeat.oneTermRobinGamma3BoundaryPrefixSource_n3
        Examples.RobinHeat.oneTermRobinGamma3BoundaryPrefixSource_n3) =
      (env "f_3_0" * env "N_f_inv") *
        Coeff.evalWith env
          (GHL2025.boundaryRotationNormalizedCoefficient
            (Examples.RobinHeat.oneTermParameters 3) 0 2) := by
  exact
    Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3BoundaryProductEntryEval_correctedAngle_n3
      (fun s =>
        if s = "f_3_0" then 3
        else if s = "N_f_inv" then 4
        else if s = "N_D_inv" then 2
        else if s = "A1*dx" then 0
        else if s = "boundary_cos_half_0_2" then -5
        else 0)
      (by native_decide)

-- The corrected-entry route expands to the branch-local normalized derivative
-- coefficient.  The theorem-level quotient/projection convention is still an
-- explicit obstruction.
example :
    let env : String → Rat := fun s =>
      if s = "f_3_0" then 3
      else if s = "N_f_inv" then 4
      else if s = "N_D_inv" then 2
      else if s = "A1*dx" then 0
      else if s = "boundary_cos_half_0_2" then -5
      else 0
    Coeff.evalWith env
      (Examples.RobinHeat.oneTermRobinGamma3BoundarySevenGateMatrix_n3
        Examples.RobinHeat.oneTermRobinGamma3BoundaryPrefixSource_n3
        Examples.RobinHeat.oneTermRobinGamma3BoundaryPrefixSource_n3) =
      Coeff.evalWith env
        (Coeff.mul
          (Coeff.mul (GHL2025.robinFunctionValue 3 0)
            (Coeff.symbol "N_f_inv"))
          (GHL2025.boundaryRotationNormalizedCoefficient
            (Examples.RobinHeat.oneTermParameters 3) 0 2)) := by
  exact
    Examples.RobinHeat.oneTermRobinBlockEncodingProofRoute_gamma3BoundaryProductEntryEval_correctedCoefficientExpanded_n3
      (fun s =>
        if s = "f_3_0" then 3
        else if s = "N_f_inv" then 4
        else if s = "N_D_inv" then 2
        else if s = "A1*dx" then 0
        else if s = "boundary_cos_half_0_2" then -5
        else 0)
      (by native_decide)

example :
    let obstruction :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryProductToCoefficientObstruction_n3
    obstruction.productEntryExpanded = true ∧
      obstruction.akEntryMatched = true ∧
      obstruction.normalizedQuotientConvention.proved = false ∧
      obstruction.sparseRegisterProjectionConvention.proved = false ∧
      obstruction.productObligation.proved = false ∧
      obstruction.productToCoefficientProved = false ∧
      obstruction.lcuCorrectProved = false ∧
      obstruction.blockProjectionProved = false ∧
      obstruction.blockCorrectProved = false ∧
      obstruction.finalExtractionProved = false := by
  have _obstruction :=
    Examples.RobinHeat.oneTermRobinGamma3BoundaryProductToCoefficientObstruction_n3_transcript
  native_decide

-- The focused boundary normalizer/projection packet names the remaining
-- `N_D*N_f*kappa` convention without proving the product theorem.
example :
    let convention :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryNormalizerProjectionConvention_n3
    convention.obstruction =
        Examples.RobinHeat.oneTermRobinGamma3BoundaryProductToCoefficientObstruction_n3 ∧
      convention.targetEntry = convention.targetEntryLocalFormula ∧
      convention.theoremNormalizer = GHL2025.oneTermRobinNormalizer ∧
      convention.finiteCompositionNormalizer = GHL2025.oneTermRobinNormalizer ∧
      convention.theoremNormalizer = convention.finiteCompositionNormalizer ∧
      convention.normalizerFormula = "N_D*N_f*kappa" ∧
      convention.quotientConvention.proved = false ∧
      convention.sparseProjectionConvention.proved = false ∧
      convention.productObligation.proved = false ∧
      convention.finiteCompositionNormalizedEquality.proved = false ∧
      convention.productToCoefficientProved = false ∧
      convention.finiteCompositionNormalizedEqualityProved = false ∧
      convention.lcuCorrectProved = false ∧
      convention.blockProjectionProved = false ∧
      convention.blockCorrectProved = false ∧
      convention.finalExtractionProved = false := by
  have _convention :=
    Examples.RobinHeat.oneTermRobinGamma3BoundaryNormalizerProjectionConvention_n3_transcript
  native_decide

example (env : String → Rat) :
    let convention :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryNormalizerProjectionConvention_n3
    Coeff.evalWith env convention.theoremNormalizer =
      env "N_D" * env "N_f" * env "kappa" := by
  simp [Examples.RobinHeat.oneTermRobinGamma3BoundaryNormalizerProjectionConvention_n3]

-- Middle split target: the next lower packet must treat symbolic inverse
-- semantics and the sparse-register kappa factor as separate obligations.
example :
    let target :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryNormalizerSplitTarget_n3
    let convention :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryNormalizerProjectionConvention_n3
    target.convention = convention ∧
      target.symbolicInverseObligation = convention.quotientConvention ∧
      target.kappaProjectionObligation = convention.sparseProjectionConvention ∧
      target.finiteCompositionNormalizedEquality =
        convention.finiteCompositionNormalizedEquality ∧
      target.productObligation = convention.productObligation ∧
      target.branchLocalProduct = convention.branchLocalProduct ∧
      target.targetEntry = convention.targetEntry ∧
      target.theoremNormalizer = convention.theoremNormalizer ∧
      target.symbolicInverseProved = false ∧
      target.kappaProjectionProved = false ∧
      target.normalizedBlockEqualityProved = false ∧
      target.productToCoefficientProved = false ∧
      target.lcuCorrectProved = false ∧
      target.blockProjectionProved = false ∧
      target.blockCorrectProved = false ∧
      target.finalExtractionProved = false := by
  have _target :=
    Examples.RobinHeat.oneTermRobinGamma3BoundaryNormalizerSplitTarget_n3_transcript
  native_decide

example (env : String → Rat)
    (hND : env "N_D_inv" * env "N_D" = 1)
    (hNF : env "N_f_inv" * env "N_f" = 1) :
    Coeff.evalWith env
        Examples.RobinHeat.oneTermRobinGamma3BoundaryNormalizerSplitTarget_n3.branchLocalProduct *
      (env "N_D" * env "N_f") =
    Coeff.evalWith env
        Examples.RobinHeat.oneTermRobinGamma3BoundaryNormalizerSplitTarget_n3.targetEntry :=
  Examples.RobinHeat.oneTermRobinGamma3BoundarySymbolicInverseEval_n3
    env hND hNF

-- The symbolic-inverse packet compiles the local algebra but keeps the
-- theorem-facing inverse, kappa projection, and composition obligations false.
example :
    let semantics :=
      Examples.RobinHeat.oneTermRobinGamma3BoundarySymbolicInverseSemantics_n3
    let target :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryNormalizerSplitTarget_n3
    semantics.splitTarget = target ∧
      semantics.conditionalEvalCompiled = true ∧
      semantics.symbolicInverseObligation = target.symbolicInverseObligation ∧
      semantics.kappaProjectionObligation = target.kappaProjectionObligation ∧
      semantics.finiteCompositionNormalizedEquality =
        target.finiteCompositionNormalizedEquality ∧
      semantics.productObligation = target.productObligation ∧
      semantics.symbolicInverseObligation.proved = false ∧
      semantics.kappaProjectionObligation.proved = false ∧
      semantics.finiteCompositionNormalizedEquality.proved = false ∧
      semantics.productObligation.proved = false ∧
      semantics.symbolicInverseProved = false ∧
      semantics.kappaProjectionProved = false ∧
      semantics.normalizedBlockEqualityProved = false ∧
      semantics.productToCoefficientProved = false ∧
      semantics.lcuCorrectProved = false ∧
      semantics.blockProjectionProved = false ∧
      semantics.blockCorrectProved = false ∧
      semantics.finalExtractionProved = false := by
  have _semantics :=
    Examples.RobinHeat.oneTermRobinGamma3BoundarySymbolicInverseSemantics_n3_transcript
  native_decide

-- The kappa-projection target isolates the remaining sparse-register
-- preparation/projection factor without promoting the product theorem.
example :
    let target :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryKappaProjectionTarget_n3
    target.splitTarget =
        Examples.RobinHeat.oneTermRobinGamma3BoundaryNormalizerSplitTarget_n3 ∧
      target.symbolicInverseSemantics =
        Examples.RobinHeat.oneTermRobinGamma3BoundarySymbolicInverseSemantics_n3 ∧
      target.citedResultId =
        "ShuklaVedula2024.HWkappaUniformSuperposition" ∧
      target.focusedKappa = 7 ∧
      target.focusedSparseSlot = 2 ∧
      target.sourceBasisIndex = 32 ∧
      target.targetBasisIndex = 32 ∧
      target.productProjectionFormula = "1/kappa" ∧
      target.symbolicInverseConditionalLemmaCompiled = true ∧
      target.dependsOnUniformPreparationCitation = true ∧
      target.uniformPreparationObligation.proved = false ∧
      target.kappaProjectionObligation.proved = false ∧
      target.finiteCompositionNormalizedEquality.proved = false ∧
      target.productObligation.proved = false ∧
      target.productToCoefficientProved = false ∧
      target.lcuCorrectProved = false ∧
      target.blockProjectionProved = false ∧
      target.blockCorrectProved = false ∧
      target.finalExtractionProved = false := by
  have _target :=
    Examples.RobinHeat.oneTermRobinGamma3BoundaryKappaProjectionTarget_n3_transcript
  native_decide

example (env : String → Rat)
    (hND : env "N_D_inv" * env "N_D" = 1)
    (hNF : env "N_f_inv" * env "N_f" = 1)
    (hkappa : env "kappa_inv" * env "kappa" = 1) :
    Coeff.evalWith env
        (Coeff.mul
          Examples.RobinHeat.oneTermRobinGamma3BoundaryKappaProjectionTarget_n3.splitTarget.branchLocalProduct
          (Coeff.symbol "kappa_inv")) *
      Coeff.evalWith env
        Examples.RobinHeat.oneTermRobinGamma3BoundaryKappaProjectionTarget_n3.theoremNormalizer =
    Coeff.evalWith env
        Examples.RobinHeat.oneTermRobinGamma3BoundaryKappaProjectionTarget_n3.splitTarget.targetEntry :=
  Examples.RobinHeat.oneTermRobinGamma3BoundaryKappaProjectionEval_n3
    env hND hNF hkappa

-- The kappa-projection semantics packet compiles only the conditional algebra;
-- sparse-register preparation/projection and block-composition flags stay false.
example :
    let semantics :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryKappaProjectionSemantics_n3
    let target :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryKappaProjectionTarget_n3
    semantics.projectionTarget = target ∧
      semantics.projectedBranchProduct =
        Coeff.mul target.splitTarget.branchLocalProduct
          (Coeff.symbol "kappa_inv") ∧
      semantics.projectionFactor = Coeff.symbol "kappa_inv" ∧
      semantics.conditionalEvalLemma =
        "oneTermRobinGamma3BoundaryKappaProjectionEval_n3" ∧
      semantics.symbolicInverseConditionalLemmaCompiled = true ∧
      semantics.kappaProjectionConditionalLemmaCompiled = true ∧
      semantics.uniformPreparationObligation.proved = false ∧
      semantics.kappaProjectionObligation.proved = false ∧
      semantics.finiteCompositionNormalizedEquality.proved = false ∧
      semantics.productObligation.proved = false ∧
      semantics.uniformPreparationProved = false ∧
      semantics.kappaProjectionProved = false ∧
      semantics.normalizedBlockEqualityProved = false ∧
      semantics.productToCoefficientProved = false ∧
      semantics.lcuCorrectProved = false ∧
      semantics.blockProjectionProved = false ∧
      semantics.blockCorrectProved = false ∧
      semantics.finalExtractionProved = false := by
  have _semantics :=
    Examples.RobinHeat.oneTermRobinGamma3BoundaryKappaProjectionSemantics_n3_transcript
  native_decide

-- The projection source contract explains the inserted kappa_inv factor without
-- proving the cited uniform preparation or block-projection convention.
example :
    let contract :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionSourceContract_n3
    let semantics :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryKappaProjectionSemantics_n3
    contract.kappaSemantics = semantics ∧
      contract.citedResultId =
        "ShuklaVedula2024.HWkappaUniformSuperposition" ∧
      contract.preparationAmplitudeFormula = "1/sqrt(kappa)" ∧
      contract.projectionAmplitudeFormula = "1/sqrt(kappa)" ∧
      contract.combinedProjectionFormula = "1/kappa" ∧
      contract.focusedKappa = 7 ∧
      contract.focusedSparseSlot = 2 ∧
      contract.projectionFactor = Coeff.symbol "kappa_inv" ∧
      contract.projectedBranchProduct = semantics.projectedBranchProduct ∧
      contract.uniformPreparationObligation =
        semantics.uniformPreparationObligation ∧
      contract.matchingProjectionObligation =
        semantics.kappaProjectionObligation ∧
      contract.conditionalEvalLemma =
        "oneTermRobinGamma3BoundaryKappaProjectionEval_n3" ∧
      contract.sourceContractCompiled = true ∧
      contract.uniformPreparationObligation.proved = false ∧
      contract.matchingProjectionObligation.proved = false ∧
      contract.projectionFactorSemantics.proved = false ∧
      contract.finiteCompositionNormalizedEquality.proved = false ∧
      contract.productObligation.proved = false ∧
      contract.uniformPreparationProved = false ∧
      contract.matchingProjectionProved = false ∧
      contract.projectionFactorSemanticsProved = false ∧
      contract.normalizedBlockEqualityProved = false ∧
      contract.productToCoefficientProved = false ∧
      contract.lcuCorrectProved = false ∧
      contract.blockProjectionProved = false ∧
      contract.blockCorrectProved = false ∧
      contract.finalExtractionProved = false := by
  have _contract :=
    Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionSourceContract_n3_transcript
  native_decide

-- The projection-factor semantics packet proves only finite slot/index wiring;
-- the amplitude and block-projection meanings of kappa_inv remain obligations.
example :
    let factor :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionFactorSemantics_n3
    let contract :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionSourceContract_n3
    factor.sourceContract = contract ∧
      factor.finiteIndexLemma =
        "oneTermRobinGamma3BoundaryProjectionFactorIndex_n3" ∧
      factor.preparedSparseSlot = 2 ∧
      factor.projectedSparseSlot = 2 ∧
      factor.preparedBasisIndex = 32 ∧
      factor.projectedBasisIndex = 32 ∧
      factor.preparedAndProjectedSlotAgree = true ∧
      factor.preparedAndProjectedBasisAgree = true ∧
      factor.projectionFactor = Coeff.symbol "kappa_inv" ∧
      factor.projectedBranchProduct = contract.projectedBranchProduct ∧
      factor.factorSemanticsObligation =
        contract.projectionFactorSemantics ∧
      factor.sourceContractCompiled = true ∧
      factor.finiteIndexLemmaCompiled = true ∧
      factor.factorSemanticsObligation.proved = false ∧
      factor.uniformPreparationObligation.proved = false ∧
      factor.matchingProjectionObligation.proved = false ∧
      factor.finiteCompositionNormalizedEquality.proved = false ∧
      factor.productObligation.proved = false ∧
      factor.projectionFactorSemanticsProved = false ∧
      factor.normalizedBlockEqualityProved = false ∧
      factor.productToCoefficientProved = false ∧
      factor.lcuCorrectProved = false ∧
      factor.blockProjectionProved = false ∧
      factor.blockCorrectProved = false ∧
      factor.finalExtractionProved = false := by
  have _factor :=
    Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionFactorSemantics_n3_transcript
  native_decide

-- The projection-factor obstruction separates the cited uniform-preparation
-- contract from QBE's matching block-projection convention.
example :
    let obstruction :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionFactorObstruction_n3
    let factor :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionFactorSemantics_n3
    obstruction.factorSemantics = factor ∧
      obstruction.citedUniformPreparationId =
        "ShuklaVedula2024.HWkappaUniformSuperposition" ∧
      obstruction.uniformPreparationObligation =
        factor.uniformPreparationObligation ∧
      obstruction.matchingProjectionObligation =
        factor.matchingProjectionObligation ∧
      obstruction.factorSemanticsObligation =
        factor.factorSemanticsObligation ∧
      obstruction.finiteIndexLemmaCompiled = true ∧
      obstruction.conditionalEvalCompiled = true ∧
      obstruction.uniformPreparationObligation.proved = false ∧
      obstruction.matchingProjectionObligation.proved = false ∧
      obstruction.factorSemanticsObligation.proved = false ∧
      obstruction.citedUniformPreparationProved = false ∧
      obstruction.matchingProjectionProved = false ∧
      obstruction.factorSemanticsProved = false ∧
      obstruction.productToCoefficientProved = false ∧
      obstruction.lcuCorrectProved = false ∧
      obstruction.blockProjectionProved = false ∧
      obstruction.blockCorrectProved = false ∧
      obstruction.finalExtractionProved = false := by
  have _obstruction :=
    Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionFactorObstruction_n3_transcript
  native_decide

-- The matching-projection convention pins the local bra to sparse slot 2 and
-- clean basis index 32 without proving the projection amplitude.
example :
    let convention :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryMatchingProjectionConvention_n3
    let obstruction :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionFactorObstruction_n3
    convention.obstruction = obstruction ∧
      convention.sourceContract =
        Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionSourceContract_n3 ∧
      convention.factorSemantics =
        Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionFactorSemantics_n3 ∧
      convention.focusedSparseSlot = 2 ∧
      convention.preparedBasisIndex = 32 ∧
      convention.projectedBasisIndex = 32 ∧
      convention.preparedBasisIndex = convention.projectedBasisIndex ∧
      convention.matchingProjectionObligation =
        obstruction.matchingProjectionObligation ∧
      convention.uniformPreparationObligation =
        obstruction.uniformPreparationObligation ∧
      convention.factorSemanticsObligation =
        obstruction.factorSemanticsObligation ∧
      convention.finiteIndexLemmaCompiled = true ∧
      convention.obstructionPacketCompiled = true ∧
      convention.matchingProjectionConventionCompiled = true ∧
      convention.matchingProjectionObligation.proved = false ∧
      convention.factorSemanticsObligation.proved = false ∧
      convention.productObligation.proved = false ∧
      convention.uniformPreparationProved = false ∧
      convention.matchingProjectionProved = false ∧
      convention.factorSemanticsProved = false ∧
      convention.productToCoefficientProved = false ∧
      convention.lcuCorrectProved = false ∧
      convention.blockProjectionProved = false ∧
      convention.blockCorrectProved = false ∧
      convention.finalExtractionProved = false := by
  have _convention :=
    Examples.RobinHeat.oneTermRobinGamma3BoundaryMatchingProjectionConvention_n3_transcript
  native_decide

-- The matching-projection amplitude obstruction separates the bra-side
-- projection amplitude from the external uniform-preparation contract.
example :
    let obstruction :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryMatchingProjectionAmplitudeObstruction_n3
    let convention :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryMatchingProjectionConvention_n3
    obstruction.matchingConvention = convention ∧
      obstruction.preparationAmplitudeFactor =
        Coeff.symbol "sqrt_kappa_inv" ∧
      obstruction.matchingProjectionAmplitudeFactor =
        Coeff.symbol "sqrt_kappa_inv" ∧
      obstruction.combinedAmplitudeFactor =
        Coeff.mul (Coeff.symbol "sqrt_kappa_inv")
          (Coeff.symbol "sqrt_kappa_inv") ∧
      obstruction.expectedProjectionFactor =
        Coeff.symbol "kappa_inv" ∧
      obstruction.uniformPreparationObligation =
        convention.uniformPreparationObligation ∧
      obstruction.matchingProjectionObligation =
        convention.matchingProjectionObligation ∧
      obstruction.factorSemanticsObligation =
        convention.factorSemanticsObligation ∧
      obstruction.symbolicProductEvalCompiled = true ∧
      obstruction.matchingProjectionObligation.proved = false ∧
      obstruction.factorSemanticsObligation.proved = false ∧
      obstruction.productObligation.proved = false ∧
      obstruction.matchingProjectionAmplitudeProved = false ∧
      obstruction.factorSemanticsProved = false ∧
      obstruction.productToCoefficientProved = false ∧
      obstruction.lcuCorrectProved = false ∧
      obstruction.blockProjectionProved = false ∧
      obstruction.blockCorrectProved = false ∧
      obstruction.finalExtractionProved = false := by
  have _obstruction :=
    Examples.RobinHeat.oneTermRobinGamma3BoundaryMatchingProjectionAmplitudeObstruction_n3_transcript
  native_decide

-- The bra-side projection-amplitude contract exposes the exact local
-- sqrt_kappa_inv obligation without proving projection or product semantics.
example :
    let contract :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryMatchingProjectionAmplitudeContract_n3
    let obstruction :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryMatchingProjectionAmplitudeObstruction_n3
    contract.amplitudeObstruction = obstruction ∧
      contract.focusedSparseSlot = 2 ∧
      contract.preparedBasisIndex = 32 ∧
      contract.projectedBasisIndex = 32 ∧
      contract.matchingProjectionAmplitudeFactor =
        Coeff.symbol "sqrt_kappa_inv" ∧
      contract.routeMatchingProjectionObligation =
        obstruction.matchingProjectionObligation ∧
      contract.amplitudeContractObligation.proved = false ∧
      contract.factorSemanticsObligation =
        obstruction.factorSemanticsObligation ∧
      contract.productObligation = obstruction.productObligation ∧
      contract.amplitudeContractCompiled = true ∧
      contract.finiteIndexLemmaCompiled = true ∧
      contract.symbolicProductEvalCompiled = true ∧
      contract.routeMatchingProjectionObligation.proved = false ∧
      contract.factorSemanticsObligation.proved = false ∧
      contract.productObligation.proved = false ∧
      contract.matchingProjectionAmplitudeProved = false ∧
      contract.factorSemanticsProved = false ∧
      contract.productToCoefficientProved = false ∧
      contract.lcuCorrectProved = false ∧
      contract.blockProjectionProved = false ∧
      contract.blockCorrectProved = false ∧
      contract.finalExtractionProved = false := by
  have _contract :=
    Examples.RobinHeat.oneTermRobinGamma3BoundaryMatchingProjectionAmplitudeContract_n3_transcript
  native_decide

-- The projection-amplitude semantics packet accepts the two sqrt_kappa_inv
-- factors only as Phase-1 contracts and leaves the product route false.
example :
    let semantics :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionAmplitudeSemantics_n3
    let contract :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryMatchingProjectionAmplitudeContract_n3
    semantics.amplitudeContract = contract ∧
      semantics.citedUniformPreparationId =
        "ShuklaVedula2024.HWkappaUniformSuperposition" ∧
      semantics.focusedSparseSlot = 2 ∧
      semantics.cleanBasisIndex = 32 ∧
      semantics.ketAmplitudeFactor = Coeff.symbol "sqrt_kappa_inv" ∧
      semantics.braAmplitudeFactor = Coeff.symbol "sqrt_kappa_inv" ∧
      semantics.expectedProjectionFactor = Coeff.symbol "kappa_inv" ∧
      semantics.ketAmplitudeAcceptedAsContract = true ∧
      semantics.braAmplitudeAcceptedAsContract = true ∧
      semantics.conditionalProductEvalCompiled = true ∧
      semantics.uniformPreparationObligation.proved = false ∧
      semantics.braAmplitudeObligation.proved = false ∧
      semantics.routeMatchingProjectionObligation.proved = false ∧
      semantics.factorSemanticsObligation.proved = false ∧
      semantics.productObligation.proved = false ∧
      semantics.braAmplitudeProved = false ∧
      semantics.factorSemanticsProved = false ∧
      semantics.productToCoefficientProved = false ∧
      semantics.lcuCorrectProved = false ∧
      semantics.blockProjectionProved = false ∧
      semantics.blockCorrectProved = false ∧
      semantics.finalExtractionProved = false := by
  have _semantics :=
    Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionAmplitudeSemantics_n3_transcript
  native_decide

example (env : String → Rat)
    (hkappaSqrt :
      env "sqrt_kappa_inv" * env "sqrt_kappa_inv" =
        env "kappa_inv") :
    let semantics :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionAmplitudeSemantics_n3
    Coeff.evalWith env semantics.combinedAmplitudeFactor =
      Coeff.evalWith env semantics.expectedProjectionFactor :=
  Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionAmplitudeContractProductEval_n3
    env hkappaSqrt

example (env : String → Rat)
    (hND : env "N_D_inv" * env "N_D" = 1)
    (hNF : env "N_f_inv" * env "N_f" = 1)
    (hkappa : env "kappa_inv" * env "kappa" = 1)
    (hkappaSqrt :
      env "sqrt_kappa_inv" * env "sqrt_kappa_inv" =
        env "kappa_inv") :
    let semantics :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionAmplitudeSemantics_n3
    Coeff.evalWith env
        (Coeff.mul
          Examples.RobinHeat.oneTermRobinGamma3BoundaryKappaProjectionTarget_n3.splitTarget.branchLocalProduct
          semantics.combinedAmplitudeFactor) *
      Coeff.evalWith env
        Examples.RobinHeat.oneTermRobinGamma3BoundaryKappaProjectionTarget_n3.theoremNormalizer =
    Coeff.evalWith env
        Examples.RobinHeat.oneTermRobinGamma3BoundaryKappaProjectionTarget_n3.splitTarget.targetEntry :=
  Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionAmplitudeFactorEval_n3
    env hND hNF hkappa hkappaSqrt

-- The factor-semantics bridge compiles only a conditional coefficient lemma;
-- all semantic proof flags remain false.
example :
    let factor :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionAmplitudeFactorSemantics_n3
    let semantics :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionAmplitudeSemantics_n3
    factor.projectionAmplitudeSemantics = semantics ∧
      factor.projectedBranchProduct =
        Coeff.mul
          Examples.RobinHeat.oneTermRobinGamma3BoundaryKappaProjectionTarget_n3.splitTarget.branchLocalProduct
          semantics.combinedAmplitudeFactor ∧
      factor.conditionalFactorEvalCompiled = true ∧
      factor.uniformPreparationObligation.proved = false ∧
      factor.braAmplitudeObligation.proved = false ∧
      factor.routeMatchingProjectionObligation.proved = false ∧
      factor.factorSemanticsObligation.proved = false ∧
      factor.finiteCompositionNormalizedEquality.proved = false ∧
      factor.productObligation.proved = false ∧
      factor.uniformPreparationProved = false ∧
      factor.braAmplitudeProved = false ∧
      factor.factorSemanticsProved = false ∧
      factor.productToCoefficientProved = false ∧
      factor.lcuCorrectProved = false ∧
      factor.blockProjectionProved = false ∧
      factor.blockCorrectProved = false ∧
      factor.finalExtractionProved = false := by
  have _factor :=
    Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionAmplitudeFactorSemantics_n3_transcript
  native_decide

example (env : String → Rat)
    (hND : env "N_D_inv" * env "N_D" = 1)
    (hNF : env "N_f_inv" * env "N_f" = 1)
    (hkappa : env "kappa_inv" * env "kappa" = 1)
    (hkappaSqrt :
      env "sqrt_kappa_inv" * env "sqrt_kappa_inv" =
        env "kappa_inv") :
    let contract :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryFactorSemanticsContractMap_n3
    Coeff.evalWith env contract.projectedBranchProduct *
      Coeff.evalWith env contract.theoremNormalizer =
    Coeff.evalWith env contract.expectedTargetEntry :=
  Examples.RobinHeat.oneTermRobinGamma3BoundaryFactorSemanticsContractMapEval_n3
    env hND hNF hkappa hkappaSqrt

example :
    let contract :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryFactorSemanticsContractMap_n3
    let factor :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionAmplitudeFactorSemantics_n3
    contract.factorBridge = factor ∧
      contract.factorSemanticsContractMapped = true ∧
      contract.conditionalFactorEvalCompiled = true ∧
      contract.ketAmplitudeObligation.proved = false ∧
      contract.braAmplitudeObligation.proved = false ∧
      contract.routeMatchingProjectionObligation.proved = false ∧
      contract.productHypothesisObligation.proved = false ∧
      contract.factorSemanticsObligation.proved = false ∧
      contract.finiteCompositionNormalizedEquality.proved = false ∧
      contract.productObligation.proved = false ∧
      contract.ketAmplitudeProved = false ∧
      contract.braAmplitudeProved = false ∧
      contract.routeMatchingProjectionProved = false ∧
      contract.productHypothesisProved = false ∧
      contract.factorSemanticsProved = false ∧
      contract.normalizedBlockEqualityProved = false ∧
      contract.productToCoefficientProved = false ∧
      contract.lcuCorrectProved = false ∧
      contract.blockProjectionProved = false ∧
      contract.blockCorrectProved = false ∧
      contract.finalExtractionProved = false := by
  have _contract :=
    Examples.RobinHeat.oneTermRobinGamma3BoundaryFactorSemanticsContractMap_n3_transcript
  native_decide

-- The bra-side projection-amplitude source map names the missing H_W dagger
-- or block-projection entry contract without proving the semantic amplitude.
example :
    let sourceMap :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryBraProjectionAmplitudeSourceMap_n3
    let amplitudeContract :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryMatchingProjectionAmplitudeContract_n3
    let factorContract :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryFactorSemanticsContractMap_n3
    sourceMap.amplitudeContract = amplitudeContract ∧
      sourceMap.factorContractMap = factorContract ∧
      sourceMap.focusedSparseSlot = 2 ∧
      sourceMap.cleanBasisIndex = 32 ∧
      sourceMap.expectedBraAmplitudeFactor =
        Coeff.symbol "sqrt_kappa_inv" ∧
      sourceMap.braAmplitudeSourceMapped = true ∧
      sourceMap.directBraAmplitudeProofAvailable = false ∧
      sourceMap.amplitudeContractObligation.proved = false ∧
      sourceMap.factorSemanticsObligation.proved = false ∧
      sourceMap.finiteCompositionNormalizedEquality.proved = false ∧
      sourceMap.productObligation.proved = false ∧
      sourceMap.productToCoefficientProved = false ∧
      sourceMap.lcuCorrectProved = false ∧
      sourceMap.blockProjectionProved = false ∧
      sourceMap.blockCorrectProved = false ∧
      sourceMap.finalExtractionProved = false := by
  have _sourceMap :=
    Examples.RobinHeat.oneTermRobinGamma3BoundaryBraProjectionAmplitudeSourceMap_n3_transcript
  native_decide

-- The focused H_W dagger entry is now a typed contract wired to the source
-- map and factor-semantics map; it is not a proved amplitude theorem.
example :
    let entry :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaDaggerProjectionEntryContract_n3
    let sourceMap :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryBraProjectionAmplitudeSourceMap_n3
    let factorMap :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryFactorSemanticsContractMap_n3
    entry.braSourceMap = sourceMap ∧
      entry.factorContractMap = factorMap ∧
      entry.focusedSparseSlot = 2 ∧
      entry.cleanBasisIndex = 32 ∧
      entry.expectedEntry = Coeff.symbol "sqrt_kappa_inv" ∧
      entry.sourceMapBraAmplitudeObligation =
        sourceMap.amplitudeContractObligation ∧
      entry.factorMapBraAmplitudeObligation =
        factorMap.braAmplitudeObligation ∧
      entry.factorMapBraAmplitudeObligation =
        entry.sourceMapBraAmplitudeObligation ∧
      entry.contractAcceptedAsTypedInterface = true ∧
      entry.sourceMapWired = true ∧
      entry.factorMapWired = true ∧
      entry.daggerEntryProved = false ∧
      entry.braAmplitudeProved = false ∧
      entry.factorSemanticsProved = false ∧
      entry.productToCoefficientProved = false ∧
      entry.lcuCorrectProved = false ∧
      entry.blockProjectionProved = false ∧
      entry.blockCorrectProved = false ∧
      entry.finalExtractionProved = false := by
  have _entry :=
    Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaDaggerProjectionEntryContract_n3_transcript
  native_decide

-- The embedded-entry interface pins the local H_W dagger row/column and the
-- ambient clean gamma3 basis index, while keeping the entry theorem false.
example :
    let interface :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaDaggerEmbeddedEntryInterface_n3
    let entry :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaDaggerProjectionEntryContract_n3
    interface.entryContract = entry ∧
      interface.focusedSparseSlot = 2 ∧
      interface.focusedKappa = 7 ∧
      interface.sparseRegisterQubits = 3 ∧
      interface.sparseRegisterDimension = 8 ∧
      interface.localBraIndex = 0 ∧
      interface.localKetIndex = 2 ∧
      interface.ambientCleanBasisIndex = 32 ∧
      interface.expectedLocalEntry = Coeff.symbol "sqrt_kappa_inv" ∧
      interface.expectedEmbeddedEntry = Coeff.symbol "sqrt_kappa_inv" ∧
      interface.localKetWithinKappa = true ∧
      interface.localKetWithinSparseDimension = true ∧
      interface.refinesProjectionEntryContract = true ∧
      interface.concreteHWKappaMatrixAvailable = false ∧
      interface.localEntryProved = false ∧
      interface.embeddedEntryProved = false ∧
      interface.braAmplitudeProved = false ∧
      interface.factorSemanticsProved = false ∧
      interface.productToCoefficientProved = false ∧
      interface.lcuCorrectProved = false ∧
      interface.blockProjectionProved = false ∧
      interface.blockCorrectProved = false ∧
      interface.finalExtractionProved = false := by
  have _interface :=
    Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaDaggerEmbeddedEntryInterface_n3_transcript
  native_decide

-- The focused H_W dagger entry now has a compiled conditional bridge from
-- the uniform clean-column contract plus the local adjoint-entry convention.
example :
    ((fun _ _ => Coeff.symbol "sqrt_kappa_inv") : Matrix 8 8 Coeff)
      ⟨0, by native_decide⟩ ⟨2, by native_decide⟩ =
        Coeff.symbol "sqrt_kappa_inv" :=
  Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaDaggerEntryFromUniformColumn_n3
    ((fun _ _ => Coeff.symbol "sqrt_kappa_inv") : Matrix 8 8 Coeff)
    ((fun _ _ => Coeff.symbol "sqrt_kappa_inv") : Matrix 8 8 Coeff)
    rfl
    rfl

-- The uniform-column contract split is wired to the embedded-entry interface,
-- but the uniform-column and adjoint-entry source obligations remain false.
example :
    let contract :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaDaggerUniformColumnContract_n3
    let interface :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaDaggerEmbeddedEntryInterface_n3
    contract.embeddedInterface = interface ∧
      contract.focusedSparseSlot = 2 ∧
      contract.focusedKappa = 7 ∧
      contract.sparseRegisterDimension = 8 ∧
      contract.uniformColumnRowIndex = 2 ∧
      contract.uniformColumnColIndex = 0 ∧
      contract.daggerRowIndex = 0 ∧
      contract.daggerColIndex = 2 ∧
      contract.ambientCleanBasisIndex = 32 ∧
      contract.expectedUniformColumnEntry = Coeff.symbol "sqrt_kappa_inv" ∧
      contract.expectedDaggerEntry = Coeff.symbol "sqrt_kappa_inv" ∧
      contract.uniformColumnContractMapped = true ∧
      contract.adjointEntryConventionMapped = true ∧
      contract.conditionalEntryLemmaCompiled = true ∧
      contract.concreteHWKappaMatrixAvailable = false ∧
      contract.uniformColumnObligation.proved = false ∧
      contract.adjointEntryConventionObligation.proved = false ∧
      contract.sourceContractObligation.proved = false ∧
      contract.uniformColumnProved = false ∧
      contract.adjointEntryConventionProved = false ∧
      contract.daggerEntryProved = false ∧
      contract.embeddedEntryProved = false ∧
      contract.braAmplitudeProved = false ∧
      contract.factorSemanticsProved = false ∧
      contract.productToCoefficientProved = false ∧
      contract.lcuCorrectProved = false ∧
      contract.blockProjectionProved = false ∧
      contract.blockCorrectProved = false ∧
      contract.finalExtractionProved = false := by
  have _contract :=
    Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaDaggerUniformColumnContract_n3_transcript
  native_decide

-- The local transpose-style dagger convention supplies the adjoint-entry side
-- of the focused H_W packet without proving the external uniform-column source.
example :
    Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaDaggerTransposeMatrix_n3
        ((fun row col => if row.val = 2 ∧ col.val = 0 then
            Coeff.symbol "sqrt_kappa_inv" else Coeff.rat 0) :
          Matrix 8 8 Coeff)
        ⟨0, by native_decide⟩ ⟨2, by native_decide⟩ =
      Coeff.symbol "sqrt_kappa_inv" := by
  native_decide

example :
    Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaDaggerTransposeMatrix_n3
        ((fun row col => if row.val = 2 ∧ col.val = 0 then
            Coeff.symbol "sqrt_kappa_inv" else Coeff.rat 0) :
          Matrix 8 8 Coeff)
        ⟨0, by native_decide⟩ ⟨2, by native_decide⟩ =
      ((fun row col => if row.val = 2 ∧ col.val = 0 then
          Coeff.symbol "sqrt_kappa_inv" else Coeff.rat 0) :
        Matrix 8 8 Coeff)
        ⟨2, by native_decide⟩ ⟨0, by native_decide⟩ :=
  Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaDaggerTransposeEntryConvention_n3
    ((fun row col => if row.val = 2 ∧ col.val = 0 then
        Coeff.symbol "sqrt_kappa_inv" else Coeff.rat 0) :
      Matrix 8 8 Coeff)

example :
    Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaDaggerTransposeMatrix_n3
        ((fun row col => if row.val = 2 ∧ col.val = 0 then
            Coeff.symbol "sqrt_kappa_inv" else Coeff.rat 0) :
          Matrix 8 8 Coeff)
        ⟨0, by native_decide⟩ ⟨2, by native_decide⟩ =
      Coeff.symbol "sqrt_kappa_inv" :=
  Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaDaggerEntryFromTransposeUniformColumn_n3
    ((fun row col => if row.val = 2 ∧ col.val = 0 then
        Coeff.symbol "sqrt_kappa_inv" else Coeff.rat 0) :
      Matrix 8 8 Coeff)
    (by native_decide)

-- The refined convention packet marks only the local adjoint convention as
-- proved; uniform-column and downstream semantic obligations remain false.
example :
    let convention :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaDaggerAdjointEntryConvention_n3
    let contract :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaDaggerUniformColumnContract_n3
    convention.uniformColumnContract = contract ∧
      convention.focusedSparseSlot = 2 ∧
      convention.focusedKappa = 7 ∧
      convention.sparseRegisterDimension = 8 ∧
      convention.uniformColumnRowIndex = 2 ∧
      convention.uniformColumnColIndex = 0 ∧
      convention.daggerRowIndex = 0 ∧
      convention.daggerColIndex = 2 ∧
      convention.expectedUniformColumnEntry =
        Coeff.symbol "sqrt_kappa_inv" ∧
      convention.expectedDaggerEntry =
        Coeff.symbol "sqrt_kappa_inv" ∧
      convention.uniformColumnObligation.proved = false ∧
      convention.adjointEntryConventionObligation.proved = true ∧
      convention.transposeMatrixAvailable = true ∧
      convention.transposeEntryConventionCompiled = true ∧
      convention.conditionalDaggerEntryFromTransposeCompiled = true ∧
      convention.adjointEntryConventionProved = true ∧
      convention.uniformColumnProved = false ∧
      convention.daggerEntryProved = false ∧
      convention.braAmplitudeProved = false ∧
      convention.factorSemanticsProved = false ∧
      convention.productToCoefficientProved = false ∧
      convention.lcuCorrectProved = false ∧
      convention.blockProjectionProved = false ∧
      convention.blockCorrectProved = false ∧
      convention.finalExtractionProved = false := by
  have _convention :=
    Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaDaggerAdjointEntryConvention_n3_transcript
  native_decide

-- The external clean-column contract is accepted only as a Phase-1 contract
-- and is wired into the compiled transpose bridge.
example :
    let bridge :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaCleanColumnContract_n3
    let convention :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaDaggerAdjointEntryConvention_n3
    bridge.adjointConvention = convention ∧
      bridge.citedResultId =
        "ShuklaVedula2024.HWkappaUniformSuperposition" ∧
      bridge.focusedSparseSlot = 2 ∧
      bridge.focusedKappa = 7 ∧
      bridge.sparseRegisterDimension = 8 ∧
      bridge.uniformColumnRowIndex = 2 ∧
      bridge.uniformColumnColIndex = 0 ∧
      bridge.daggerRowIndex = 0 ∧
      bridge.daggerColIndex = 2 ∧
      bridge.expectedUniformColumnEntry =
        Coeff.symbol "sqrt_kappa_inv" ∧
      bridge.expectedDaggerEntry =
        Coeff.symbol "sqrt_kappa_inv" ∧
      bridge.externalCleanColumnAcceptedAsContract = true ∧
      bridge.cleanColumnFeedsTransposeBridge = true ∧
      bridge.conditionalDaggerEntryBridgeCompiled = true ∧
      bridge.uniformColumnObligation.proved = false ∧
      bridge.adjointEntryConventionObligation.proved = true ∧
      bridge.uniformColumnProved = false ∧
      bridge.adjointEntryConventionProved = true ∧
      bridge.daggerEntryProved = false ∧
      bridge.embeddedEntryProved = false ∧
      bridge.braAmplitudeProved = false ∧
      bridge.factorSemanticsProved = false ∧
      bridge.productToCoefficientProved = false ∧
      bridge.lcuCorrectProved = false ∧
      bridge.blockProjectionProved = false ∧
      bridge.blockCorrectProved = false ∧
      bridge.finalExtractionProved = false := by
  have _bridge :=
    Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaCleanColumnContract_n3_transcript
  native_decide

example :
    Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaDaggerTransposeMatrix_n3
        ((fun row col => if row.val = 2 ∧ col.val = 0 then
            Coeff.symbol "sqrt_kappa_inv" else Coeff.rat 0) :
          Matrix 8 8 Coeff)
        ⟨0, by native_decide⟩ ⟨2, by native_decide⟩ =
      Coeff.symbol "sqrt_kappa_inv" :=
  Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaCleanColumnContract_feedsTransposeBridge_n3
    ((fun row col => if row.val = 2 ∧ col.val = 0 then
        Coeff.symbol "sqrt_kappa_inv" else Coeff.rat 0) :
      Matrix 8 8 Coeff)
    (by native_decide)

-- The clean-column bridge is wired to the existing bra-amplitude source map
-- and factor-semantics contract map without promoting semantic flags.
example :
    let route :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryCleanColumnBraRouteContract_n3
    let cleanColumn :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaCleanColumnContract_n3
    let sourceMap :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryBraProjectionAmplitudeSourceMap_n3
    let factorMap :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryFactorSemanticsContractMap_n3
    route.cleanColumnContract = cleanColumn ∧
      route.braSourceMap = sourceMap ∧
      route.factorContractMap = factorMap ∧
      route.focusedSparseSlot = 2 ∧
      route.cleanBasisIndex = 32 ∧
      route.expectedBraAmplitudeFactor =
        Coeff.symbol "sqrt_kappa_inv" ∧
      route.sourceMapBraAmplitudeObligation =
        sourceMap.amplitudeContractObligation ∧
      route.factorMapBraAmplitudeObligation =
        factorMap.braAmplitudeObligation ∧
      route.sourceMapBraAmplitudeObligation =
        route.factorMapBraAmplitudeObligation ∧
      route.externalCleanColumnAcceptedAsContract = true ∧
      route.cleanColumnFeedsDaggerEntry = true ∧
      route.braRouteContractMapped = true ∧
      route.uniformColumnProved = false ∧
      route.daggerEntryProved = false ∧
      route.braAmplitudeProved = false ∧
      route.factorSemanticsProved = false ∧
      route.productToCoefficientProved = false ∧
      route.lcuCorrectProved = false ∧
      route.blockProjectionProved = false ∧
      route.blockCorrectProved = false ∧
      route.finalExtractionProved = false := by
  have _route :=
    Examples.RobinHeat.oneTermRobinGamma3BoundaryCleanColumnBraRouteContract_n3_transcript
  native_decide

example :
    Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaDaggerTransposeMatrix_n3
        ((fun row col => if row.val = 2 ∧ col.val = 0 then
            Coeff.symbol "sqrt_kappa_inv" else Coeff.rat 0) :
          Matrix 8 8 Coeff)
        ⟨0, by native_decide⟩ ⟨2, by native_decide⟩ =
      (Examples.RobinHeat.oneTermRobinGamma3BoundaryCleanColumnBraRouteContract_n3).expectedBraAmplitudeFactor :=
  Examples.RobinHeat.oneTermRobinGamma3BoundaryCleanColumnBraRouteContract_feedsBraAmplitude_n3
    ((fun row col => if row.val = 2 ∧ col.val = 0 then
        Coeff.symbol "sqrt_kappa_inv" else Coeff.rat 0) :
      Matrix 8 8 Coeff)
    (by native_decide)

-- The clean-column route now feeds the factor-semantics contract map under
-- explicit external and coefficient hypotheses.
example :
    let route :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryCleanColumnFactorSemanticsRoute_n3
    let cleanRoute :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryCleanColumnBraRouteContract_n3
    let factorMap :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryFactorSemanticsContractMap_n3
    route.cleanColumnRoute = cleanRoute ∧
      route.factorContractMap = factorMap ∧
      route.focusedSparseSlot = 2 ∧
      route.cleanBasisIndex = 32 ∧
      route.expectedBraAmplitudeFactor =
        Coeff.symbol "sqrt_kappa_inv" ∧
      route.cleanColumnFeedLemma =
        "oneTermRobinGamma3BoundaryCleanColumnBraRouteContract_feedsBraAmplitude_n3" ∧
      route.factorEvalLemma =
        "oneTermRobinGamma3BoundaryFactorSemanticsContractMapEval_n3" ∧
      route.braAmplitudeObligation =
        factorMap.braAmplitudeObligation ∧
      route.braAmplitudeObligation =
        cleanRoute.factorMapBraAmplitudeObligation ∧
      route.externalCleanColumnAcceptedAsContract = true ∧
      route.braFactorRouteWired = true ∧
      route.conditionalBraFactorCompiled = true ∧
      route.conditionalFactorEvalCompiled = true ∧
      route.cleanColumnToFactorRouteMapped = true ∧
      route.uniformColumnProved = false ∧
      route.ketAmplitudeProved = false ∧
      route.braAmplitudeProved = false ∧
      route.productHypothesisProved = false ∧
      route.factorSemanticsProved = false ∧
      route.normalizedBlockEqualityProved = false ∧
      route.productToCoefficientProved = false ∧
      route.lcuCorrectProved = false ∧
      route.blockProjectionProved = false ∧
      route.blockCorrectProved = false ∧
      route.finalExtractionProved = false := by
  have _route :=
    Examples.RobinHeat.oneTermRobinGamma3BoundaryCleanColumnFactorSemanticsRoute_n3_transcript
  native_decide

example :
    let env : String → Rat := fun _ => 1
    let H : Matrix 8 8 Coeff :=
      ((fun row col =>
        if row.val = 2 ∧ col.val = 0 then
          Coeff.symbol "sqrt_kappa_inv"
        else
          Coeff.rat 0) : Matrix 8 8 Coeff)
    let route :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryCleanColumnFactorSemanticsRoute_n3
    Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaDaggerTransposeMatrix_n3 H
        ⟨route.daggerRowIndex, by native_decide⟩
        ⟨route.daggerColIndex, by native_decide⟩ =
      route.expectedBraAmplitudeFactor ∧
    Coeff.evalWith env route.projectedBranchProduct *
      Coeff.evalWith env route.theoremNormalizer =
    Coeff.evalWith env route.expectedTargetEntry :=
  Examples.RobinHeat.oneTermRobinGamma3BoundaryCleanColumnFactorSemanticsRouteEval_n3
    (fun _ => 1)
    ((fun row col =>
      if row.val = 2 ∧ col.val = 0 then
        Coeff.symbol "sqrt_kappa_inv"
      else
        Coeff.rat 0) : Matrix 8 8 Coeff)
    (by native_decide)
    (by simp) (by simp) (by simp) (by simp)

-- The product-under-contracts route starts from the clean-column factor route
-- and names the remaining finite block-composition/product bridge.
example :
    let productRoute :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryProductUnderContractsRoute_n3
    let factorRoute :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryCleanColumnFactorSemanticsRoute_n3
    productRoute.cleanColumnFactorRoute = factorRoute ∧
      productRoute.focusedSparseSlot = 2 ∧
      productRoute.cleanBasisIndex = 32 ∧
      productRoute.fixedProductObligationName =
        "oneTermRobinGamma3ProductToCoefficientObligation 3 0 0" ∧
      productRoute.conditionalEvalCompiled = true ∧
      productRoute.productUnderContractsMapped = true ∧
      productRoute.productBridgeObligation.proved = false ∧
      productRoute.finiteCompositionNormalizedEquality.proved = false ∧
      productRoute.productObligation.proved = false ∧
      productRoute.productToCoefficientProved = false ∧
      productRoute.lcuCorrectProved = false ∧
      productRoute.blockProjectionProved = false ∧
      productRoute.blockCorrectProved = false ∧
      productRoute.finalExtractionProved = false := by
  have _route :=
    Examples.RobinHeat.oneTermRobinGamma3BoundaryProductUnderContractsRoute_n3_transcript
  native_decide

example :
    let env : String → Rat := fun _ => 1
    let H : Matrix 8 8 Coeff :=
      ((fun row col =>
        if row.val = 2 ∧ col.val = 0 then
          Coeff.symbol "sqrt_kappa_inv"
        else
          Coeff.rat 0) : Matrix 8 8 Coeff)
    let productRoute :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryProductUnderContractsRoute_n3
    Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaDaggerTransposeMatrix_n3 H
        ⟨productRoute.cleanColumnFactorRoute.daggerRowIndex, by native_decide⟩
        ⟨productRoute.cleanColumnFactorRoute.daggerColIndex, by native_decide⟩ =
      productRoute.expectedBraAmplitudeFactor ∧
    Coeff.evalWith env productRoute.projectedBranchProduct *
      Coeff.evalWith env productRoute.theoremNormalizer =
    Coeff.evalWith env productRoute.expectedTargetEntry :=
  Examples.RobinHeat.oneTermRobinGamma3BoundaryProductUnderContractsEval_n3
    (fun _ => 1)
    ((fun row col =>
      if row.val = 2 ∧ col.val = 0 then
        Coeff.symbol "sqrt_kappa_inv"
      else
        Coeff.rat 0) : Matrix 8 8 Coeff)
    (by native_decide)
    (by simp) (by simp) (by simp) (by simp)

-- The finite projection/product bridge exposes the current indexing split:
-- the signal-zero block entry is `[0,0]`, while the focused slot-2 branch was
-- evaluated at full basis entry `[32,32]`.
example :
    let bridge :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryFiniteProjectionProductBridge_n3
    let productRoute :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryProductUnderContractsRoute_n3
    bridge.productRoute = productRoute ∧
      bridge.focusedSparseSlot = 2 ∧
      bridge.signalBlockRowIndex = 0 ∧
      bridge.signalBlockColumnIndex = 0 ∧
      bridge.branchBasisIndex = 32 ∧
      bridge.branchBasisMatchesSignalBlockIndex = false ∧
      bridge.finiteBlockIndexCompiled = true ∧
      bridge.productRouteConsumed = true ∧
      bridge.productBridgeObligation.proved = false ∧
      bridge.branchDecompositionObligation.proved = false ∧
      bridge.finiteCompositionNormalizedEquality.proved = false ∧
      bridge.signalBlockEntryObligation.proved = false ∧
      bridge.productObligation.proved = false ∧
      bridge.productToCoefficientProved = false ∧
      bridge.lcuCorrectProved = false ∧
      bridge.blockProjectionProved = false ∧
      bridge.blockCorrectProved = false ∧
      bridge.finalExtractionProved = false := by
  have _bridge :=
    Examples.RobinHeat.oneTermRobinGamma3BoundaryFiniteProjectionProductBridge_n3_transcript
  native_decide

example :
    let p := Examples.RobinHeat.oneTermParameters 3
    let contract :=
      Examples.RobinHeat.oneTermRobinFiniteBlockCompositionContract 3
    let sysRow : Fin (gridSize 3) := ⟨0, by native_decide⟩
    let sysCol : Fin (gridSize 3) := ⟨0, by native_decide⟩
    let blockRow : Fin
        (qubitDim (GHL2025.effectiveRobinSignalQubits p) * gridSize 3) :=
      ⟨signalSystemBlockRowIndex (gridSize 3)
          contract.expectedTarget.signalIndex.val sysRow.val,
        signalSystemBlockRowIndex_lt
          contract.expectedTarget.signalIndex sysRow⟩
    let blockCol : Fin
        (qubitDim (GHL2025.effectiveRobinSignalQubits p) * gridSize 3) :=
      ⟨signalSystemBlockColIndex (gridSize 3)
          contract.expectedTarget.signalIndex.val sysCol.val,
        signalSystemBlockColIndex_lt
          contract.expectedTarget.signalIndex sysCol⟩
    contract.expectedTarget.blockMatrix sysRow sysCol =
        contract.expectedTarget.unitaryMatrix blockRow blockCol ∧
      blockRow.val = 0 ∧
      blockCol.val = 0 ∧
      Examples.RobinHeat.oneTermRobinGamma3PaperBasisIndex p 2 0 = 32 := by
  rcases
      Examples.RobinHeat.oneTermRobinGamma3BoundaryFiniteProjectionBlockEntryIndex_n3
    with ⟨hentry, hrow, hcol, hbasis, _hsource, _hrowNe, _hcolNe⟩
  exact ⟨hentry, hrow, hcol, hbasis⟩

-- The next branch-decomposition packet names the exact missing
-- projection/summation theorem from the slot-2 branch entry `[32,32]` into
-- the signal-zero block entry `[0,0]`.
example :
    let packet :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryBranchDecompositionSlot2_n3
    let bridge :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryFiniteProjectionProductBridge_n3
    packet.finiteBridge = bridge ∧
      packet.focusedSparseSlot = 2 ∧
      packet.signalBlockRowIndex = 0 ∧
      packet.signalBlockColumnIndex = 0 ∧
      packet.branchRowIndex = 32 ∧
      packet.branchColumnIndex = 32 ∧
      packet.signalBlockEntryMatchesBranchEntry = false ∧
      packet.branchDecompositionInterfaceCompiled = true ∧
      packet.finiteIndexCompiled = true ∧
      packet.conditionalProductEvalCompiled = true ∧
      packet.projectionSummationObligation.proved = false ∧
      packet.productBridgeObligation.proved = false ∧
      packet.branchDecompositionObligation.proved = false ∧
      packet.finiteCompositionNormalizedEquality.proved = false ∧
      packet.signalBlockEntryObligation.proved = false ∧
      packet.productObligation.proved = false ∧
      packet.productToCoefficientProved = false ∧
      packet.lcuCorrectProved = false ∧
      packet.blockProjectionProved = false ∧
      packet.blockCorrectProved = false ∧
      packet.finalExtractionProved = false := by
  have _packet :=
    Examples.RobinHeat.oneTermRobinGamma3BoundaryBranchDecompositionSlot2_n3_transcript
  native_decide

-- The typed projection/summation target exposes the actual coefficient
-- objects for the signal block entry and branch-local entry, while keeping the
-- missing projection theorem false.
example :
    Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalBlockEntry =
      Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry :=
  Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionSummationTarget_blockEntry_eq_unitary_n3

example :
    let target :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionSummationTarget_n3
    let packet :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryBranchDecompositionSlot2_n3
    target.branchPacket = packet ∧
      target.signalBlockEntryEqualityLemma =
        "oneTermRobinGamma3BoundaryProjectionSummationTarget_blockEntry_eq_unitary_n3" ∧
      target.branchEntryEvalLemma =
        "oneTermRobinBlockEncodingProofRoute_gamma3BoundaryProductEntryEval_n3" ∧
      target.requiredBranchEntrySelectionTheorem =
        "branch-matrix entry [32,32] evaluates to the projectedBranchProduct used by the product route under the explicit coefficient contracts" ∧
      target.projectionSummationObligation =
        packet.projectionSummationObligation ∧
      target.branchEntrySelectionObligation.proved = false ∧
      target.typedProjectionSummationTargetCompiled = true ∧
      target.signalBlockEntryTyped = true ∧
      target.branchMatrixEntryTyped = true ∧
      target.branchEntrySelectionProved = false ∧
      target.projectionSummationProved = false ∧
      target.productBridgeProved = false ∧
      target.productToCoefficientProved = false := by
  have _target :=
    Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionSummationTarget_n3_transcript
  exact ⟨rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl,
    rfl, rfl, rfl⟩

-- The branch-entry selection packet proves the conditional local step from
-- the selected `[32,32]` seven-gate entry to the route's projected branch
-- product, but it does not prove the source amplitudes or signal-block sum.
example :
    let selection :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryBranchEntrySelection_n3
    let target :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionSummationTarget_n3
    selection.projectionTarget = target ∧
      selection.focusedSparseSlot = 2 ∧
      selection.branchRowIndex = 32 ∧
      selection.branchColumnIndex = 32 ∧
      selection.projectionAmplitudeFactor =
        Coeff.mul (Coeff.symbol "sqrt_kappa_inv")
          (Coeff.symbol "sqrt_kappa_inv") ∧
      selection.conditionalBranchEntrySelectionLemma =
        "oneTermRobinGamma3BoundaryBranchEntrySelectionEval_n3" ∧
      selection.conditionalBranchEntrySelectionCompiled = true ∧
      selection.correctedEntryHypothesis.proved = false ∧
      selection.ketAmplitudeObligation.proved = false ∧
      selection.braAmplitudeObligation.proved = false ∧
      selection.branchEntrySelectionObligation.proved = false ∧
      selection.projectionSummationObligation.proved = false ∧
      selection.productBridgeObligation.proved = false ∧
      selection.productToCoefficientProved = false := by
  have _selection :=
    Examples.RobinHeat.oneTermRobinGamma3BoundaryBranchEntrySelection_n3_transcript
  exact ⟨rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl,
    rfl, rfl, rfl, rfl⟩

example :
    let env : String → Rat := fun _ => 0
    let selection :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryBranchEntrySelection_n3
    Coeff.evalWith env
        (Coeff.mul
          (Examples.RobinHeat.oneTermRobinGamma3BoundarySevenGateMatrix_n3
            Examples.RobinHeat.oneTermRobinGamma3BoundaryPrefixSource_n3
            Examples.RobinHeat.oneTermRobinGamma3BoundaryPrefixSource_n3)
          selection.projectionAmplitudeFactor) =
      Coeff.evalWith env selection.projectionTarget.projectedBranchProduct :=
  Examples.RobinHeat.oneTermRobinGamma3BoundaryBranchEntrySelectionEval_n3
    (fun _ => 0) (by native_decide)

-- The projection/summation obstruction now has a typed selected slot-2
-- contribution, but no branch-contribution family or sparse-branch sum theorem.
example :
    let obstruction :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionSummationObstruction_n3
    obstruction.slotDomain = [0, 1, 2, 3, 4, 5, 6] ∧
      obstruction.slotDomainCardinality = 7 ∧
      obstruction.focusedSparseSlot = 2 ∧
      obstruction.focusedSlotInDomain = true :=
  by exact ⟨rfl, rfl, rfl, rfl⟩

example :
    let obstruction :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionSummationObstruction_n3
    obstruction.selectedSlotContribution =
      Coeff.mul
        (Examples.RobinHeat.oneTermRobinGamma3BoundarySevenGateMatrix_n3
          Examples.RobinHeat.oneTermRobinGamma3BoundaryPrefixSource_n3
          Examples.RobinHeat.oneTermRobinGamma3BoundaryPrefixSource_n3)
        Examples.RobinHeat.oneTermRobinGamma3BoundaryBranchEntrySelection_n3.projectionAmplitudeFactor :=
  rfl

example :
    let obstruction :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionSummationObstruction_n3
    obstruction.branchContributionFamilyInterface =
        "branchContribution : Fin 7 -> Coeff" ∧
      obstruction.requiredSelectedSlotTheorem =
        "branchContribution[2] = selectedSlotContribution" ∧
      obstruction.requiredProjectionSummationTheorem =
        "signalBlockEntry = Finset.univ.sum branchContribution" ∧
      obstruction.typedInterfaceCompiled = true ∧
      obstruction.selectedSlotContributionTyped = true ∧
      obstruction.selectedSlotEvalCompiled = true ∧
      obstruction.branchContributionFamilyAvailable = false ∧
      obstruction.sparseBranchSumExpansionAvailable = false ∧
      obstruction.projectionSummationProved = false ∧
      obstruction.productBridgeProved = false ∧
      obstruction.normalizedBlockEqualityProved = false ∧
      obstruction.productToCoefficientProved = false := by
  exact ⟨rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl,
    rfl, rfl⟩

example :
    let env : String → Rat := fun _ => 0
    let obstruction :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionSummationObstruction_n3
    Coeff.evalWith env obstruction.selectedSlotContribution =
      Coeff.evalWith env obstruction.projectionTarget.projectedBranchProduct :=
  Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionSummationObstruction_selectedSlotEval_n3
    (fun _ => 0) (by native_decide)

-- The branch-contribution interface now exposes a typed `Fin 7 -> Coeff`
-- family and proves only the slot-2 selection.  The sparse-branch sum theorem
-- remains an explicit obstruction.
example :
    let family :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryBranchContributionFamily_n3
    family.focusedSparseSlot.val = 2 ∧
      family.branchContributionFamilyAvailable = true ∧
      family.selectedSlotStatementTyped = true ∧
      family.selectedSlotProved = true ∧
      family.projectionSummationStatementTyped = true ∧
      family.projectionSummationProved = false ∧
      family.productToCoefficientProved = false := by
  have _transcript :=
    Examples.RobinHeat.oneTermRobinGamma3BoundaryBranchContributionObstruction_n3_transcript
  exact ⟨rfl, rfl, rfl, rfl, rfl, rfl, rfl⟩

example :
    let family :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryBranchContributionFamily_n3
    family.branchContribution family.focusedSparseSlot =
      family.selectedSlotContribution := by
  change (Examples.RobinHeat.oneTermRobinGamma3BoundaryBranchContributionFamily_n3).selectedSlotStatement
  exact
    Examples.RobinHeat.oneTermRobinGamma3BoundaryBranchContribution_selectedSlot_n3

example :
    let obstruction :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryBranchContributionObstruction_n3
    obstruction.branchContributionFamilyAvailable = true ∧
      obstruction.selectedSlotTheoremCompiled = true ∧
      obstruction.projectionSummationStatementTyped = true ∧
      obstruction.projectionSummationTheoremAvailable = false ∧
      obstruction.projectionSummationProved = false ∧
      obstruction.productBridgeProved = false ∧
      obstruction.normalizedBlockEqualityProved = false ∧
      obstruction.productToCoefficientProved = false ∧
      obstruction.lcuCorrectProved = false ∧
      obstruction.blockProjectionProved = false ∧
      obstruction.blockCorrectProved = false ∧
      obstruction.finalExtractionProved = false := by
  have _transcript :=
    Examples.RobinHeat.oneTermRobinGamma3BoundaryBranchContributionObstruction_n3_transcript
  exact ⟨rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl,
    rfl, rfl⟩

-- The backend-field target separates the typed placeholder family from the
-- still-missing projection/summation field that must come from the finite
-- block-extraction backend.
example :
    let target :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendProjectionSummationFieldTarget_n3
    let family :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryBranchContributionFamily_n3
    target.family = family ∧
      target.backendBranchContributionPredicate =
        Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContributionPredicate_n3 ∧
      target.backendBranchContributionPredicate family.branchContribution =
        Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContributionPredicate_n3
          family.branchContribution ∧
      target.backendPredicateTyped = true ∧
      target.placeholderFamilyIsBackendSourced = false ∧
      target.placeholderMayCloseProjectionSummation = false ∧
      target.backendFieldAvailable = false ∧
      target.backendSelectedSlotTheoremAvailable = false ∧
      target.backendProjectionSummationTheoremAvailable = false ∧
      target.projectionSummationProved = false ∧
      target.productToCoefficientProved = false :=
  by
    have _target :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendProjectionSummationFieldTarget_n3_transcript
    exact ⟨rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl⟩

example :
    let target :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendProjectionSummationFieldTarget_n3
    target.backendFieldExpectedOwner =
        "BlockExtractionTarget / finite projection-summation backend" ∧
      target.backendFieldLeanType =
        "branchContribution : Fin 7 -> Coeff, sourced from contract.expectedTarget.blockMatrix[0,0]" ∧
      target.requiredSelectedSlotTheorem =
        "backendBranchContribution[2] = selectedSlotContribution" ∧
      target.requiredProjectionSummationTheorem =
        "signalBlockEntry = oneTermRobinGamma3BoundaryBranchContributionSum backendBranchContribution" ∧
      target.exactRemainingObstruction =
        "BlockExtractionTarget exposes the signal-zero block entry but not a backend-sourced sparse-branch contribution family for that entry" :=
  by
    have _target :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendProjectionSummationFieldTarget_n3_transcript
    exact ⟨rfl, rfl, rfl, rfl, rfl⟩

-- The generic block-extraction branch target is typed for the focused slot-2
-- branch, but the backend-source and branch-summation obligations remain open.
example :
    let target :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryBlockExtractionBranchContributionTarget_n3
    target.selectedBranch.val = 2 ∧
      target.backendSource.proved = false ∧
      target.selectedBranchCorrect.proved = false ∧
      target.branchSummationCorrect.proved = false ∧
      target.selectedBranchStatement := by
  exact ⟨rfl, rfl, rfl, rfl,
    Examples.RobinHeat.oneTermRobinGamma3BoundaryBlockExtractionBranchContributionTarget_selected_n3⟩

example :
    Examples.RobinHeat.oneTermRobinGamma3BoundaryBlockExtractionBranchContributionTarget_n3.selectedContribution =
      Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionSummationObstruction_n3.selectedSlotContribution :=
  Examples.RobinHeat.oneTermRobinGamma3BoundaryBlockExtractionBranchContributionTarget_selectedContribution_eq_n3

-- The smaller backend gap ties the obstruction to the actual
-- BlockExtractionTarget fields: the block entry exists and a generic
-- branch-target interface is now typed, but no backend-sourced seven-slot
-- family has been proved for that entry.
example :
    Examples.RobinHeat.oneTermRobinGamma3BoundaryBlockExtractionBackendGap_n3.signalBlockEntry =
      Examples.RobinHeat.oneTermRobinGamma3BoundaryBlockExtractionBackendGap_n3.unitaryEntry := by
  simpa [Examples.RobinHeat.oneTermRobinGamma3BoundaryBlockExtractionBackendGap_n3]
    using
      Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionSummationTarget_blockEntry_eq_unitary_n3

example :
    let gap :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryBlockExtractionBackendGap_n3
    gap.exposesBlockMatrix = true ∧
      gap.exposesBranchContributionField = false ∧
      gap.genericBranchContributionInterfaceAvailable = true ∧
      gap.genericBranchContributionBackendSourced = false ∧
      gap.genericSelectedBranchStatementCompiled = true ∧
      gap.genericProjectionSummationStatementTyped = true ∧
      gap.blockEntryOnlyBridgeCompiled = true ∧
      gap.backendFieldAvailable = false ∧
      gap.placeholderFamilyRejected = true ∧
      gap.blockProjectionObligation.proved = false ∧
      gap.blockCorrectObligation.proved = false ∧
      gap.projectionSummationProved = false ∧
      gap.productToCoefficientProved = false ∧
      gap.exactRemainingObstruction =
        "BlockExtractionTarget can be paired with a typed seven-slot branch target, but the backend-source proof and signal-block branch-sum theorem are still absent" :=
  by
    have _gap :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryBlockExtractionBackendGap_n3_transcript
    exact ⟨rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl,
      rfl, rfl, rfl, rfl⟩

-- The branch-to-full-index map is now typed for the seven sparse slots.  Slot
-- 2 maps to the branch-local full basis index 32, but the all-slot backend
-- summand formula remains open.
example :
    let idx :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchFullIndex_n3
        Examples.RobinHeat.oneTermRobinGamma3BoundaryBranchContributionFocusedSlot
    idx.val = 32 ∧
      idx = Examples.RobinHeat.oneTermRobinGamma3BoundaryPrefixSource_n3 :=
  Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchFullIndex_selected_n3

example :
    let target :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryBlockExtractionBranchContributionTarget_n3
    target.selectedContribution =
      Coeff.mul
        (Examples.RobinHeat.oneTermRobinGamma3BoundarySevenGateMatrix_n3
          Examples.RobinHeat.oneTermRobinGamma3BoundaryPrefixSource_n3
          Examples.RobinHeat.oneTermRobinGamma3BoundaryPrefixSource_n3)
        Examples.RobinHeat.oneTermRobinGamma3BoundaryBranchEntrySelection_n3.projectionAmplitudeFactor :=
  Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendSelectedBranchSummandFormula_n3

example :
    let obstruction :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchIndexMapObstruction_n3
    obstruction.backendBranchIndexMapAvailable = true ∧
      obstruction.selectedBranchIndexMapCompiled = true ∧
      obstruction.selectedBranchSummandFormulaCompiled = true ∧
      obstruction.backendBranchSummandFormulaAvailable = false ∧
      obstruction.backendPredicateTyped = true ∧
      obstruction.backendPredicateProved = false ∧
      obstruction.projectionSummationProved = false ∧
      obstruction.productToCoefficientProved = false ∧
      obstruction.exactRemainingObstruction =
        "the branch-to-full-index map is typed and the selected slot-2 summand formula compiles, but QBE still lacks the all-slot backend summand formula and branch-sum theorem for contract.expectedTarget.blockMatrix[0,0]" :=
  by
    have _obstruction :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchIndexMapObstruction_n3_transcript
    exact ⟨rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl⟩

-- The all-slot backend summand formula now supplies a concrete `Fin 7 -> Coeff`
-- family from the branch full-index map.  Only the selected slot-2 clause is
-- proved; the signal-block branch-sum theorem remains open.
example :
    Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContribution_n3
        Examples.RobinHeat.oneTermRobinGamma3BoundaryBranchContributionFocusedSlot =
      Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionSummationObstruction_n3.selectedSlotContribution :=
  Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContribution_selected_n3

example :
    let target :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3
    target.selectedBranchStatement ∧
      target.selectedBranch.val = 2 ∧
      target.selectedContribution =
        Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionSummationObstruction_n3.selectedSlotContribution ∧
      target.backendSource.proved = false ∧
      target.selectedBranchCorrect.proved = false ∧
      target.branchSummationCorrect.proved = false := by
  exact ⟨
    Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContributionTarget_selected_n3,
    rfl,
    Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContributionTarget_selectedContribution_eq_n3,
    rfl, rfl, rfl⟩

example :
    let packet :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendAllSlotSummandFormula_n3
    packet.allSlotBackendSummandFormulaAvailable = true ∧
      packet.backendBranchContributionFamilyAvailable = true ∧
      packet.selectedBranchContributionCompiled = true ∧
      packet.backendPredicateSelectedClauseProved = true ∧
      packet.backendPredicateProved = false ∧
      packet.projectionSummationProved = false ∧
      packet.productBridgeProved = false ∧
      packet.normalizedBlockEqualityProved = false ∧
      packet.productToCoefficientProved = false ∧
      packet.exactRemainingObstruction =
        "all-slot backend summand formula is typed and slot 2 is selected, but QBE still lacks the signal-block branch-sum theorem for contract.expectedTarget.blockMatrix[0,0]" := by
  have _packet :=
    Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendAllSlotSummandFormula_n3_transcript
  exact ⟨rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl⟩

-- The branch-sum closure packet proves the selected predicate clause and
-- isolates the remaining missing input to the signal-zero branch-sum equality.
example :
    Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContribution_n3
        Examples.RobinHeat.oneTermRobinGamma3BoundaryBranchContributionFocusedSlot =
      Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionSummationObstruction_n3.selectedSlotContribution :=
  Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContributionPredicate_selectedClause_n3

example
    (hbranchSum :
      Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionSummationObstruction_n3.signalBlockEntry =
        Examples.RobinHeat.oneTermRobinGamma3BoundaryBranchContributionSum
          Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContribution_n3) :
    Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContributionPredicate_n3
      Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContribution_n3 :=
  Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContributionPredicate_of_branchSum_n3
    hbranchSum

example :
    let closure :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchSumClosure_n3
    closure.selectedClauseStatement ∧
      closure.selectedClauseProved = true ∧
      closure.conditionalPredicateClosureCompiled = true ∧
      closure.projectionSummationStatementTyped = true ∧
      closure.backendPredicateTyped = true ∧
      closure.backendPredicateProved = false ∧
      closure.projectionSummationProved = false ∧
      closure.productBridgeProved = false ∧
      closure.normalizedBlockEqualityProved = false ∧
      closure.productToCoefficientProved = false ∧
      closure.requiredSecondConjunct =
        "oneTermRobinGamma3BoundaryProjectionSummationObstruction_n3.signalBlockEntry = oneTermRobinGamma3BoundaryBranchContributionSum oneTermRobinGamma3BoundaryBackendBranchContribution_n3" ∧
      closure.exactRemainingObstruction =
        "the selected branch predicate clause is proved and predicate closure is conditional, but QBE still lacks the signal-zero branch-sum equality for the backend seven-slot family" := by
  have _closure :=
    Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchSumClosure_n3_transcript
  exact ⟨
    Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContributionPredicate_selectedClause_n3,
    rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl⟩

-- The generic backend projection statement is now bridged to the Robin-local
-- branch-sum predicate target, but the branch sum itself remains unproved.
example :
    Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.projectionSummationStatement ↔
      Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.blockEntry =
        blockExtractionBranchContributionSum
          Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.branchContribution :=
  Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendProjectionStatement_unfold_n3

example :
    Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionSummationObstruction_n3.signalBlockEntry =
      Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.blockEntry :=
  Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendProjectionStatement_signalEntry_n3

example
    (hprojection :
      Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.projectionSummationStatement) :
    Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContributionPredicate_n3
      Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContribution_n3 :=
  Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContributionPredicate_of_targetProjection_n3
    hprojection

example :
    Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.projectionSummationStatement ↔
      Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionSummationObstruction_n3.signalBlockEntry =
        Examples.RobinHeat.oneTermRobinGamma3BoundaryBranchContributionSum
          Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContribution_n3 :=
  Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendProjectionStatement_equivBranchSum_n3

example :
    let obstruction :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendProjectionStatementObstruction_n3
    obstruction.equivalenceCompiled = true ∧
      obstruction.selectedClauseProved = true ∧
      obstruction.backendFieldAvailable = false ∧
      obstruction.projectionSummationProved = false ∧
      obstruction.backendPredicateProved = false ∧
      obstruction.productBridgeProved = false ∧
      obstruction.normalizedBlockEqualityProved = false ∧
      obstruction.productToCoefficientProved = false ∧
      obstruction.requiredBackendTheorem =
        "contract.expectedTarget.blockMatrix[0,0] = blockExtractionBranchContributionSum backendBranchContribution" ∧
      obstruction.exactRemainingObstruction =
        "the generic projection statement is equivalent to the focused branch-sum equality, but the finite backend still lacks the theorem expanding blockMatrix[0,0] as the seven-slot branch fold" := by
  have _obstruction :=
    Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendProjectionStatementObstruction_n3_transcript
  exact ⟨rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl⟩

-- The backend-expansion proof-DAG block states the exact theorem that would
-- close the generic projection statement, without asserting the theorem.
example :
    Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.projectionSummationStatement ↔
      Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement :=
  BlockExtractionBranchContributionTarget.projectionSummationStatement_iff_backendExpansionStatement
    Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3

example
    (hexpansion :
      Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement) :
    Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.projectionSummationStatement :=
  Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendProjectionStatement_of_backendExpansion_n3
    hexpansion

example :
    Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement ↔
      Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionSummationObstruction_n3.signalBlockEntry =
        Examples.RobinHeat.oneTermRobinGamma3BoundaryBranchContributionSum
          Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContribution_n3 :=
  Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendExpansionStatement_equivBranchSum_n3

example :
    let bridge :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendExpansionBridge_n3
    bridge.backendExpansionStatementTyped = true ∧
      bridge.genericEquivalenceCompiled = true ∧
      bridge.robinEquivalenceCompiled = true ∧
      bridge.conditionalProjectionCompiled = true ∧
      bridge.backendExpansionProved = false ∧
      bridge.projectionSummationProved = false ∧
      bridge.backendPredicateProved = false ∧
      bridge.requiredBackendTheorem =
        "oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement" ∧
      bridge.exactRemainingObstruction =
        "the backend-expansion statement is typed and equivalent to the focused branch-sum equality, but the finite backend still has not proved the seven-slot fold for blockMatrix[0,0]" := by
  have _bridge :=
    Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendExpansionBridge_n3_transcript
  exact ⟨rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl⟩

-- The backend-expansion target is now narrowed one step further: it is
-- equivalent to a fold theorem for the actual full-unitary entry selected by
-- the signal-zero block projection.
example :
    Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement ↔
      Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry =
        blockExtractionBranchContributionSum
          Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContribution_n3 :=
  Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendExpansionStatement_equivUnitaryEntryFold_n3

example :
    Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement ↔
      (evalGateMatrices
        (GHL2025.oneTermRobinGateMatrixPlaceholders
          (Examples.RobinHeat.oneTermParameters 3)))
        Examples.RobinHeat.oneTermRobinGamma3BoundaryPrefixRow0_n3
        Examples.RobinHeat.oneTermRobinGamma3BoundaryPrefixRow0_n3 =
      blockExtractionBranchContributionSum
        Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContribution_n3 :=
  Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendExpansionStatement_iff_uncastActiveEntryFold_n3

example :
    let idx :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchFullIndex_n3
        ⟨0, by native_decide⟩
    idx.val = 0 ∧
      idx = Examples.RobinHeat.oneTermRobinGamma3BoundaryPrefixRow0_n3 :=
  Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchFullIndex_slotZero_n3

example :
    Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContribution_n3
        ⟨0, by native_decide⟩ =
      Coeff.mul
        (Examples.RobinHeat.oneTermRobinGamma3BoundarySevenGateMatrix_n3
          Examples.RobinHeat.oneTermRobinGamma3BoundaryPrefixRow0_n3
          Examples.RobinHeat.oneTermRobinGamma3BoundaryPrefixRow0_n3)
        Examples.RobinHeat.oneTermRobinGamma3BoundaryBranchEntrySelection_n3.projectionAmplitudeFactor :=
  Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContribution_slotZero_n3

example :
    blockExtractionBranchContributionSum
        Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContribution_n3 =
      (((((((0 +
        Coeff.mul
          (Examples.RobinHeat.oneTermRobinGamma3BoundarySevenGateMatrix_n3
            Examples.RobinHeat.oneTermRobinGamma3BoundaryPrefixRow0_n3
            Examples.RobinHeat.oneTermRobinGamma3BoundaryPrefixRow0_n3)
          Examples.RobinHeat.oneTermRobinGamma3BoundaryBranchEntrySelection_n3.projectionAmplitudeFactor) +
        Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContribution_n3
          ⟨1, by native_decide⟩) +
        Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContribution_n3
          ⟨2, by native_decide⟩) +
        Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContribution_n3
          ⟨3, by native_decide⟩) +
        Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContribution_n3
          ⟨4, by native_decide⟩) +
        Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContribution_n3
          ⟨5, by native_decide⟩) +
        Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContribution_n3
          ⟨6, by native_decide⟩) :=
  Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchFold_expandedSlotZero_n3

example :
    Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement ↔
      (evalGateMatrices
        (GHL2025.oneTermRobinGateMatrixPlaceholders
          (Examples.RobinHeat.oneTermParameters 3)))
        Examples.RobinHeat.oneTermRobinGamma3BoundaryPrefixRow0_n3
        Examples.RobinHeat.oneTermRobinGamma3BoundaryPrefixRow0_n3 =
      (((((((0 +
        Coeff.mul
          (Examples.RobinHeat.oneTermRobinGamma3BoundarySevenGateMatrix_n3
            Examples.RobinHeat.oneTermRobinGamma3BoundaryPrefixRow0_n3
            Examples.RobinHeat.oneTermRobinGamma3BoundaryPrefixRow0_n3)
          Examples.RobinHeat.oneTermRobinGamma3BoundaryBranchEntrySelection_n3.projectionAmplitudeFactor) +
        Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContribution_n3
          ⟨1, by native_decide⟩) +
        Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContribution_n3
          ⟨2, by native_decide⟩) +
        Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContribution_n3
          ⟨3, by native_decide⟩) +
        Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContribution_n3
          ⟨4, by native_decide⟩) +
        Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContribution_n3
          ⟨5, by native_decide⟩) +
        Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContribution_n3
          ⟨6, by native_decide⟩) :=
  Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendExpansionStatement_iff_uncastActiveEntryExpandedFold_n3

example
    (H : Matrix 8 8 Coeff)
    (hUniform :
      Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3
        H) :
    (Examples.RobinHeat.oneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField_n3
        H).rawEntryPreparedSandwichStatement ↔
      (evalGateMatrices
        (GHL2025.oneTermRobinGateMatrixPlaceholders
          (Examples.RobinHeat.oneTermParameters 3)))
        Examples.RobinHeat.oneTermRobinGamma3BoundaryPrefixRow0_n3
        Examples.RobinHeat.oneTermRobinGamma3BoundaryPrefixRow0_n3 =
      (((((((0 +
        Coeff.mul
          (Examples.RobinHeat.oneTermRobinGamma3BoundarySevenGateMatrix_n3
            Examples.RobinHeat.oneTermRobinGamma3BoundaryPrefixRow0_n3
            Examples.RobinHeat.oneTermRobinGamma3BoundaryPrefixRow0_n3)
          Examples.RobinHeat.oneTermRobinGamma3BoundaryBranchEntrySelection_n3.projectionAmplitudeFactor) +
        Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContribution_n3
          ⟨1, by native_decide⟩) +
        Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContribution_n3
          ⟨2, by native_decide⟩) +
        Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContribution_n3
          ⟨3, by native_decide⟩) +
        Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContribution_n3
          ⟨4, by native_decide⟩) +
        Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContribution_n3
          ⟨5, by native_decide⟩) +
        Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContribution_n3
          ⟨6, by native_decide⟩) :=
  Examples.RobinHeat.oneTermRobinGamma3BoundaryRawEntryPreparedSandwichField_iff_uncastActiveEntryExpandedFold_n3
    H hUniform

example :
    let target :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendUnitaryEntryFoldTarget_n3
    target.blockEntryUnitaryBridgeCompiled = true ∧
      target.unitaryEntryFoldStatementTyped = true ∧
      target.backendExpansionEquivalentToUnitaryFold = true ∧
      target.backendExpansionProved = false ∧
      target.projectionSummationProved = false ∧
      target.backendPredicateProved = false ∧
      target.requiredFullProductFoldTheorem =
        "contract.expectedTarget.unitaryMatrix[0,0] = blockExtractionBranchContributionSum backendBranchContribution" ∧
      target.exactRemainingObstruction =
        "the backend expansion is equivalent to a full-unitary entry fold, but QBE still lacks the finite product/projection theorem expanding entry [0,0] as the seven backend branch summands" := by
  have _target :=
    Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendUnitaryEntryFoldTarget_n3_transcript
  exact ⟨rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl⟩

-- The fold-support packet proves only that slot 2 is inside the seven-slot
-- backend fold and already equals the selected [32,32] branch summand.
example :
    Examples.RobinHeat.oneTermRobinGamma3BoundaryBranchContributionFocusedSlot ∈
      (List.finRange 7) :=
  Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendSelectedBranch_mem_fold_n3

example :
    let support :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendUnitaryEntryFoldSupportTarget_n3
    support.selectedBranchInFoldStatement ∧
      support.selectedContributionStatement ∧
      support.foldDomainTyped = true ∧
      support.selectedBranchInFoldProved = true ∧
      support.selectedContributionProved = true ∧
      support.unitaryEntryFoldStatementTyped = true ∧
      support.fullProductFoldProved = false ∧
      support.projectionSummationProved = false ∧
      support.backendPredicateProved = false ∧
      support.productBridgeProved = false ∧
      support.normalizedBlockEqualityProved = false ∧
      support.productToCoefficientProved = false ∧
      support.requiredFullProductFoldTheorem =
        "oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry = blockExtractionBranchContributionSum oneTermRobinGamma3BoundaryBackendBranchContribution_n3" ∧
      support.exactRemainingObstruction =
        "the fold domain contains slot 2 and the selected summand is proved, but QBE still lacks the finite product/projection theorem equating the full signal-zero entry with the complete seven-slot fold" := by
  have hsupport :=
    Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendUnitaryEntryFoldSupportTarget_n3_transcript
  exact ⟨hsupport.2.2.2.2.2.2.2.1, hsupport.2.2.2.2.2.2.2.2.1,
    rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl⟩

-- The prepared-branch packet proves the all-slot summand formula and narrows
-- the remaining obstruction to the prepared projection backend theorem.
example (s : Fin 7) :
    Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContribution_n3 s =
      Coeff.mul
        (Examples.RobinHeat.oneTermRobinGamma3BoundarySevenGateMatrix_n3
          (Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchFullIndex_n3 s)
          (Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchFullIndex_n3 s))
        (Coeff.mul (Coeff.symbol "sqrt_kappa_inv")
          (Coeff.symbol "sqrt_kappa_inv")) :=
  Examples.RobinHeat.oneTermRobinGamma3BoundaryPreparedBranchContribution_formula_n3
    s

example :
    let target :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryPreparedBranchExpansionTarget_n3
    target.branchContributionFormulaStatement ∧
      target.branchContributionFormulaProved = true ∧
      target.preparedProjectionBackendStatementTyped = true ∧
      target.rawCircuitMatrixExposed = true ∧
      target.preparedProjectionBackendAvailable = false ∧
      target.fullProductFoldProved = false ∧
      target.projectionSummationProved = false ∧
      target.productToCoefficientProved = false ∧
      target.requiredPreparedProjectionTheorem =
        "oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry = blockExtractionBranchContributionSum oneTermRobinGamma3BoundaryBackendBranchContribution_n3" ∧
      target.exactRemainingObstruction =
        "all seven prepared branch summands are typed and proved by formula, but the backend still lacks the prepared projection theorem equating the raw signal-zero entry with their fold" := by
  have hformula :=
    Examples.RobinHeat.oneTermRobinGamma3BoundaryPreparedBranchExpansionTarget_formula_n3
  exact ⟨hformula, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl⟩

-- The prepared-sandwich backend block proves that an explicit H_W/H_W^dagger
-- clean-column matrix specializes the prepared fold to the backend branch sum.
example
    (H : Matrix 8 8 Coeff)
    (hUniform :
      Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3
        H)
    (s : Fin 7) :
    Examples.RobinHeat.oneTermRobinGamma3BoundaryPreparedProjectionSandwichContribution_n3
        H s =
      Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContribution_n3
        s :=
  Examples.RobinHeat.oneTermRobinGamma3BoundaryPreparedProjectionSandwichContribution_eq_backend_n3
    H hUniform s

example
    (H : Matrix 8 8 Coeff)
    (hUniform :
      Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3
        H) :
    Examples.RobinHeat.oneTermRobinGamma3BoundaryPreparedProjectionSandwichSum_n3
        H =
      blockExtractionBranchContributionSum
        Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContribution_n3 :=
  Examples.RobinHeat.oneTermRobinGamma3BoundaryPreparedProjectionSandwichSum_eq_backend_n3
    H hUniform

example
    (H : Matrix 8 8 Coeff)
    (hUniform :
      Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3
        H)
    (hPreparedBackend :
      Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry =
        Examples.RobinHeat.oneTermRobinGamma3BoundaryPreparedProjectionSandwichSum_n3
          H) :
    Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry =
      blockExtractionBranchContributionSum
        Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContribution_n3 :=
  Examples.RobinHeat.oneTermRobinGamma3BoundaryUnitaryEntryFold_of_preparedSandwichBackend_n3
    H hUniform hPreparedBackend

example :
    let backend :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryPreparedProjectionSandwichBackendTarget_n3
    backend.preparedSandwichContributionSpecialized = true ∧
      backend.preparedSandwichSumSpecialized = true ∧
      backend.conditionalUnitaryFoldCompiled = true ∧
      backend.preparedProjectionBackendAvailable = false ∧
      backend.fullProductFoldProved = false ∧
      backend.projectionSummationProved = false ∧
      backend.productToCoefficientProved = false ∧
      backend.requiredPreparedProjectionBackendField =
        "oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry = oneTermRobinGamma3BoundaryPreparedProjectionSandwichSum_n3 H" ∧
      backend.exactRemainingObstruction =
        "prepared sandwich summands specialize to the backend branch fold under the H_W^(kappa) clean-column contract; the remaining missing field is the raw signal-zero entry equals prepared sandwich fold theorem" := by
  have _backend :=
    Examples.RobinHeat.oneTermRobinGamma3BoundaryPreparedProjectionSandwichBackendTarget_n3_transcript
  exact ⟨rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl⟩

-- The raw-entry prepared-sandwich packet types the exact CircuitMatrixSemantics
-- field still needed to close the preferred unitary-entry fold.
example (H : Matrix 8 8 Coeff) :
    (Examples.RobinHeat.oneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField_n3
        H).rawEntryPreparedSandwichStatement ↔
      Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry =
        Examples.RobinHeat.oneTermRobinGamma3BoundaryPreparedProjectionSandwichSum_n3
          H :=
  Examples.RobinHeat.oneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField_statement_n3
    H

example
    (H : Matrix 8 8 Coeff)
    (hUniform :
      (Examples.RobinHeat.oneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField_n3
        H).uniformColumnStatement)
    (hRaw :
      (Examples.RobinHeat.oneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField_n3
        H).rawEntryPreparedSandwichStatement) :
    (Examples.RobinHeat.oneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField_n3
      H).preferredUnitaryEntryFoldStatement :=
  Examples.RobinHeat.oneTermRobinGamma3BoundaryUnitaryEntryFold_of_rawEntryPreparedSandwichField_n3
    H hUniform hRaw

example (H : Matrix 8 8 Coeff) :
    let field :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField_n3
        H
    field.preparedSandwichBackendTarget =
        Examples.RobinHeat.oneTermRobinGamma3BoundaryPreparedProjectionSandwichBackendTarget_n3 ∧
      field.rawEntryPreparedSandwichStatementTyped = true ∧
      field.conditionalFoldBridgeCompiled = true ∧
      field.preparedProjectionBackendAvailable = false ∧
      field.fullProductFoldProved = false ∧
      field.projectionSummationProved = false ∧
      field.productToCoefficientProved = false ∧
      field.requiredCircuitMatrixField =
        "oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry = oneTermRobinGamma3BoundaryPreparedProjectionSandwichSum_n3 H" ∧
      field.exactRemainingObstruction =
        "the remaining field is the CircuitMatrixSemantics raw entry [0,0] equals the prepared H_W^(kappa)^dagger * U * H_W^(kappa) sandwich fold" := by
  have _field :=
    Examples.RobinHeat.oneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField_n3_transcript
      H
  exact ⟨rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl⟩

-- The prepared-circuit gap packet shows that the active raw entry is the
-- seven-gate contract matrix entry, while H_W^(kappa) is not an active gate.
example :
    Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry =
      (Examples.RobinHeat.oneTermRobinFiniteBlockCompositionContract 3).expectedTarget.unitaryMatrix
        ⟨0, by native_decide⟩ ⟨0, by native_decide⟩ :=
  Examples.RobinHeat.oneTermRobinGamma3BoundaryRawUnitaryEntry_contractMatrix_n3

example :
    Gate.oracleCall "H_W^(kappa)" ∉
        (GHL2025.oneTermRobinGateMatrixPlaceholders
          (Examples.RobinHeat.oneTermParameters 3)).map
            (fun gateMatrix => gateMatrix.gate) ∧
      Gate.oracleCall "(H_W^(kappa))^dagger" ∉
        (GHL2025.oneTermRobinGateMatrixPlaceholders
          (Examples.RobinHeat.oneTermParameters 3)).map
            (fun gateMatrix => gateMatrix.gate) :=
  Examples.RobinHeat.oneTermRobinGamma3BoundarySparsePreparationGates_absent_n3

example (H : Matrix 8 8 Coeff) :
    let gap :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryPreparedCircuitSemanticsGap_n3
        H
    gap.rawEntryContractProved = true ∧
      gap.sparsePreparationAbsenceProved = true ∧
      gap.rawEntryPreparedSandwichStatementTyped = true ∧
      gap.preparedCircuitSemanticsAvailable = false ∧
      gap.preparedCircuitEntryEqualityProved = false ∧
      gap.fullProductFoldProved = false ∧
      gap.projectionSummationProved = false ∧
      gap.productToCoefficientProved = false ∧
      gap.requiredPreparedCircuitSemantics =
        "CircuitMatrixSemantics entry for H_W^(kappa)^dagger * oneTermRobinGamma3BoundarySevenGateMatrix_n3 * H_W^(kappa), projected at clean sparse-register index 0" :=
    by
  have _gap :=
    Examples.RobinHeat.oneTermRobinGamma3BoundaryPreparedCircuitSemanticsGap_n3_transcript
      H
  exact ⟨rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl⟩

-- The prepared sparse-register matrix now has a clean-clean entry that is
-- definitionally the prepared sandwich fold.
example (H : Matrix 8 8 Coeff) :
    Examples.RobinHeat.oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_n3 H
        Examples.RobinHeat.oneTermRobinGamma3BoundarySparseCleanIndex_n3
        Examples.RobinHeat.oneTermRobinGamma3BoundarySparseCleanIndex_n3 =
      Examples.RobinHeat.oneTermRobinGamma3BoundaryPreparedProjectionSandwichSum_n3
        H :=
  Examples.RobinHeat.oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_cleanEntry_n3
    H

example (H : Matrix 8 8 Coeff) :
    gateMatricesMatchCircuit
        Examples.RobinHeat.oneTermRobinGamma3BoundaryPreparedCompositeCircuit_n3
        [Examples.RobinHeat.oneTermRobinGamma3BoundaryPreparedCompositeGate_n3 H] =
      true :=
  Examples.RobinHeat.oneTermRobinGamma3BoundaryPreparedCompositeGateMatchesCircuit_n3
    H

example (H : Matrix 8 8 Coeff) (env : String → Rat) :
    Coeff.evalWith env
        ((Examples.RobinHeat.oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_n3
          H).matrix
          Examples.RobinHeat.oneTermRobinGamma3BoundarySparseCleanIndex_n3
          Examples.RobinHeat.oneTermRobinGamma3BoundarySparseCleanIndex_n3) =
      Coeff.evalWith env
        (Examples.RobinHeat.oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_n3 H
          Examples.RobinHeat.oneTermRobinGamma3BoundarySparseCleanIndex_n3
          Examples.RobinHeat.oneTermRobinGamma3BoundarySparseCleanIndex_n3) :=
  Examples.RobinHeat.oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_cleanEntryEval_n3
    H env

example
    (H : Matrix 8 8 Coeff)
    (hUniform :
      Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3
        H)
    (hPreparedEntry :
      Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry =
        Examples.RobinHeat.oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_n3 H
          Examples.RobinHeat.oneTermRobinGamma3BoundarySparseCleanIndex_n3
          Examples.RobinHeat.oneTermRobinGamma3BoundarySparseCleanIndex_n3) :
    Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry =
      blockExtractionBranchContributionSum
        Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContribution_n3 :=
  Examples.RobinHeat.oneTermRobinGamma3BoundaryUnitaryEntryFold_of_preparedCircuitSparseMatrix_n3
    H hUniform hPreparedEntry

example (H : Matrix 8 8 Coeff) :
    let interface :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryPreparedCircuitMatrixInterface_n3
        H
    interface.preparedSparseMatrixAvailable = true ∧
      interface.preparedCompositeSemanticsAvailable = true ∧
      interface.cleanEntryStatement ∧
      interface.preparedCompositeCleanEntryEvalStatement ∧
      interface.cleanEntryStatementProved = true ∧
      interface.preparedCompositeCleanEntryEvalCompiled = true ∧
      interface.activePreparedEntryEqualityProved = false ∧
      interface.fullProductFoldProved = false ∧
      interface.projectionSummationProved = false ∧
      interface.productToCoefficientProved = false ∧
      interface.requiredActivePreparedEntryTheorem =
        "oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry = oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_n3 H 0 0" :=
  by
    have hclean :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_cleanEntry_n3
        H
    have hsemantics :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_cleanEntryEval_n3
        H
    dsimp [Examples.RobinHeat.oneTermRobinGamma3BoundaryPreparedCircuitMatrixInterface_n3]
    exact ⟨rfl, rfl, hclean, hsemantics, rfl, rfl, rfl, rfl,
      rfl, rfl, rfl⟩

example (H : Matrix 8 8 Coeff) :
    (Examples.RobinHeat.oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3
        H).entryEqualityStatement ↔
      (Examples.RobinHeat.oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3
        H).matrixEntryEqualityStatement :=
  Examples.RobinHeat.oneTermRobinGamma3BoundaryActivePreparedEntryTarget_matrixStatement_n3
    H

example (H : Matrix 8 8 Coeff) :
    (Examples.RobinHeat.oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3
        H).entryEqualityStatement ↔
      (Examples.RobinHeat.oneTermRobinGamma3BoundaryPreparedCircuitMatrixInterface_n3
        H).activeEntryToPreparedEntryStatement :=
  Examples.RobinHeat.oneTermRobinGamma3BoundaryActivePreparedEntryTarget_interfaceStatement_n3
    H

example (H : Matrix 8 8 Coeff) :
    let field :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryActivePreparedCompositionFieldTarget_n3
        H
    field.entryTargetTyped = true ∧
      field.matrixEntryEquivalenceCompiled = true ∧
      field.preparedCompositionFieldAvailable = false ∧
      field.activePreparedEntryEqualityProved = false ∧
      field.fullProductFoldProved = false ∧
      field.projectionSummationProved = false ∧
      field.productToCoefficientProved = false ∧
      field.requiredCompositionTheorem =
        "oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3 H.entryEqualityStatement" ∧
      field.exactRemainingObstruction =
        "the active and prepared entries are packaged in a generic prepared-entry target, but QBE still lacks the CircuitMatrixSemantics composition theorem equating them" :=
  by
    have _field :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryActivePreparedCompositionFieldTarget_n3_transcript
        H
    exact ⟨rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl⟩

example (H : Matrix 8 8 Coeff) :
    let field :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryActivePreparedCompositionFieldTarget_n3
        H
    field.activeEntryStatement ↔ field.interfaceStatement :=
  Examples.RobinHeat.oneTermRobinGamma3BoundaryActivePreparedCompositionFieldTarget_interfaceStatement_n3
    H

example
    (H : Matrix 8 8 Coeff)
    (hUniform :
      Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3
        H)
    (hEntry :
      (Examples.RobinHeat.oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3
        H).matrixEntryEqualityStatement) :
    Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry =
      blockExtractionBranchContributionSum
        Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContribution_n3 :=
  Examples.RobinHeat.oneTermRobinGamma3BoundaryUnitaryEntryFold_of_activePreparedEntryTarget_matrix_n3
    H hUniform hEntry

example
    (H : Matrix 8 8 Coeff)
    (hUniform :
      Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3
        H)
    (hEntry :
      (Examples.RobinHeat.oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3
        H).entryEqualityStatement) :
    Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry =
      blockExtractionBranchContributionSum
        Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContribution_n3 :=
  Examples.RobinHeat.oneTermRobinGamma3BoundaryUnitaryEntryFold_of_activePreparedEntryTarget_n3
    H hUniform hEntry

example
    (H : Matrix 8 8 Coeff)
    (hUniform :
      Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3
        H)
    (hFold :
      Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry =
        blockExtractionBranchContributionSum
          Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContribution_n3) :
    (Examples.RobinHeat.oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3
      H).entryEqualityStatement :=
  Examples.RobinHeat.oneTermRobinGamma3BoundaryActivePreparedEntryTarget_of_unitaryEntryFold_n3
    H hUniform hFold

example
    (H : Matrix 8 8 Coeff)
    (hUniform :
      Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3
        H) :
    (Examples.RobinHeat.oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3
        H).entryEqualityStatement ↔
      Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry =
        blockExtractionBranchContributionSum
          Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContribution_n3 :=
  Examples.RobinHeat.oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_unitaryEntryFold_n3
    H hUniform

example
    (H : Matrix 8 8 Coeff)
    (hUniform :
      Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3
        H) :
    let field :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryActivePreparedCompositionFieldTarget_n3
        H
    field.activeEntryStatement ↔
      Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry =
        blockExtractionBranchContributionSum
          Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContribution_n3 :=
  Examples.RobinHeat.oneTermRobinGamma3BoundaryActivePreparedCompositionFieldTarget_iff_unitaryEntryFold_n3
    H hUniform

example
    (H : Matrix 8 8 Coeff)
    (hUniform :
      Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3
        H) :
    (Examples.RobinHeat.oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3
        H).entryEqualityStatement ↔
      Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement :=
  Examples.RobinHeat.oneTermRobinGamma3BoundaryActivePreparedEntryTarget_iff_backendExpansion_n3
    H hUniform

example
    (H : Matrix 8 8 Coeff)
    (hUniform :
      Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3
        H) :
    let field :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryActivePreparedCompositionFieldTarget_n3
        H
    field.activeEntryStatement ↔
      Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement :=
  Examples.RobinHeat.oneTermRobinGamma3BoundaryActivePreparedCompositionFieldTarget_iff_backendExpansion_n3
    H hUniform

example
    (H : Matrix 8 8 Coeff)
    (hUniform :
      Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3
        H) :
    (Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry =
      blockExtractionBranchContributionSum
        Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContribution_n3) ↔
      Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry =
        Examples.RobinHeat.oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_n3 H
          Examples.RobinHeat.oneTermRobinGamma3BoundarySparseCleanIndex_n3
          Examples.RobinHeat.oneTermRobinGamma3BoundarySparseCleanIndex_n3 :=
  Examples.RobinHeat.oneTermRobinGamma3BoundaryUnitaryEntryFold_iff_preparedCleanEntry_n3
    H hUniform

example (H : Matrix 8 8 Coeff) (env : String → Rat) :
    Examples.RobinHeat.oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_n3
        H env ↔
      Examples.RobinHeat.oneTermRobinGamma3BoundaryActivePreparedSparseEvalStatement_n3
        H env :=
  Examples.RobinHeat.oneTermRobinGamma3BoundaryActivePreparedCompositeEval_iff_sparseEval_n3
    H env

example (H : Matrix 8 8 Coeff) (env : String → Rat) :
    Examples.RobinHeat.oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3
        H env ↔
      Examples.RobinHeat.oneTermRobinGamma3BoundaryUncastPreparedSandwichEvalStatement_n3
        H env :=
  Examples.RobinHeat.oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEval_iff_preparedSandwichStatement_n3
    H env

example
    (H : Matrix 8 8 Coeff) (env : String → Rat)
    (hUniform :
      Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3
        H) :
    Examples.RobinHeat.oneTermRobinGamma3BoundaryUncastPreparedSandwichEvalStatement_n3
        H env ↔
      Examples.RobinHeat.oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3
        env :=
  Examples.RobinHeat.oneTermRobinGamma3BoundaryUncastPreparedSandwichEvalStatement_iff_evaluatedBackendFold_n3
    H env hUniform

example
    (H : Matrix 8 8 Coeff) (env : String → Rat)
    (hUniform :
      Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3
        H)
    (hexpansion :
      Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement) :
    Examples.RobinHeat.oneTermRobinGamma3BoundaryUncastPreparedSandwichEvalStatement_n3
      H env :=
  Examples.RobinHeat.oneTermRobinGamma3BoundaryUncastPreparedSandwichEval_of_backendExpansion_n3
    H env hUniform hexpansion

example
    (H : Matrix 8 8 Coeff) (env : String → Rat)
    (hUniform :
      Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3
        H)
    (hexpansion :
      Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement) :
    Examples.RobinHeat.oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3
      H env :=
  Examples.RobinHeat.oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEval_of_backendExpansion_n3
    H env hUniform hexpansion

example
    (H : Matrix 8 8 Coeff) (env : String → Rat)
    (hUniform :
      Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3
        H)
    (hexpansion :
      Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement) :
    (Examples.RobinHeat.oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3
        H env).activeToPreparedSingletonEvalStatement :=
  Examples.RobinHeat.oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_of_backendExpansion_n3
    H env hUniform hexpansion

example
    (H : Matrix 8 8 Coeff) (env : String → Rat)
    (hUniform :
      Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3
        H)
    (hexpansion :
      Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement) :
    Examples.RobinHeat.oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_n3
      H env :=
  Examples.RobinHeat.oneTermRobinGamma3BoundaryActivePreparedCompositeEval_of_backendExpansion_n3
    H env hUniform hexpansion

example (H : Matrix 8 8 Coeff) :
    (Examples.RobinHeat.oneTermRobinCircuitSemantics 3).circuit ≠
      (Examples.RobinHeat.oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_n3
        H).circuit :=
  Examples.RobinHeat.oneTermRobinGamma3BoundaryActivePreparedCircuitLabels_distinct_n3
    H

example
    (H : Matrix 8 8 Coeff) (env : String → Rat)
    (hPrepared :
      Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry =
        Examples.RobinHeat.oneTermRobinGamma3BoundaryPreparedCircuitSparseMatrix_n3 H
          Examples.RobinHeat.oneTermRobinGamma3BoundarySparseCleanIndex_n3
          Examples.RobinHeat.oneTermRobinGamma3BoundarySparseCleanIndex_n3) :
    Examples.RobinHeat.oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_n3
      H env :=
  Examples.RobinHeat.oneTermRobinGamma3BoundaryActivePreparedCompositeEval_of_preparedCleanEntry_n3
    H env hPrepared

example (H : Matrix 8 8 Coeff) (env : String → Rat) :
    let field :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryActivePreparedCircuitFieldTarget_n3
        H env
    field.activeGateCount = 7 ∧
      field.preparedGateCount = 1 ∧
      field.activeCircuit ≠ field.preparedCircuit ∧
      (field.activePreparedCompositeEvalStatement ↔
        field.activePreparedSparseEvalStatement) ∧
      field.preparedSingletonSemanticsCompiled = true ∧
      field.preparedCompositeCleanEvalCompiled = true ∧
      field.activePreparedEvalBridgeCompiled = true ∧
      field.activePreparedEntryEqualityProved = false ∧
      field.fullProductFoldProved = false ∧
      field.projectionSummationProved = false ∧
      field.productToCoefficientProved = false ∧
      field.requiredCircuitCompositionTheorem =
        "active signal-zero CircuitMatrixSemantics entry equals prepared singleton clean entry" ∧
      field.exactRemainingObstruction =
        "the active seven-gate semantics and prepared singleton semantics are both typed, but QBE still lacks the CircuitMatrixSemantics composition theorem equating their selected entries" :=
  by
    have hdistinct :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryActivePreparedCircuitLabels_distinct_n3
        H
    have hequiv :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryActivePreparedCompositeEval_iff_sparseEval_n3
        H env
    dsimp [
      Examples.RobinHeat.oneTermRobinGamma3BoundaryActivePreparedCircuitFieldTarget_n3,
      Examples.RobinHeat.oneTermRobinCircuitSemantics,
      Examples.RobinHeat.oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_n3,
      CircuitMatrixSemantics.ofGateMatrices,
      Examples.RobinHeat.oneTermRobinGamma3BoundaryPreparedCompositeCircuit_n3,
      GHL2025.oneTermRobinGateMatrixPlaceholders]
    exact ⟨rfl, rfl, hdistinct, hequiv, rfl, rfl, rfl, rfl, rfl,
      rfl, rfl, rfl, rfl⟩

example
    (H : Matrix 8 8 Coeff) (env : String → Rat)
    (hUniform :
      Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3
        H) :
    Coeff.evalWith env
        ((Examples.RobinHeat.oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_n3
          H).matrix
          Examples.RobinHeat.oneTermRobinGamma3BoundarySparseCleanIndex_n3
          Examples.RobinHeat.oneTermRobinGamma3BoundarySparseCleanIndex_n3) =
      Coeff.evalWith env
        (blockExtractionBranchContributionSum
          Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContribution_n3) :=
  Examples.RobinHeat.oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3
    H env hUniform

example (H : Matrix 8 8 Coeff) (env : String → Rat) :
    let target :=
      Examples.RobinHeat.oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3
        H env
    let prepared :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_n3
        H
    let clean :=
      Examples.RobinHeat.oneTermRobinGamma3BoundarySparseCleanIndex_n3
    target.preparedProjectionEntry = prepared.matrix clean clean ∧
      target.preparedSingletonToSparseEvalStatement ∧
      target.preparedSingletonToBackendEvalStatement := by
  have hsparse :=
    Examples.RobinHeat.oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_cleanEntryEval_n3
      H env
  have hbackend :
      Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3 H →
        Coeff.evalWith env
          ((Examples.RobinHeat.oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_n3
            H).matrix
            Examples.RobinHeat.oneTermRobinGamma3BoundarySparseCleanIndex_n3
            Examples.RobinHeat.oneTermRobinGamma3BoundarySparseCleanIndex_n3) =
          Coeff.evalWith env
            (blockExtractionBranchContributionSum
              Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContribution_n3) := by
    intro hUniform
    exact
      Examples.RobinHeat.oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3
        H env hUniform
  dsimp [
    Examples.RobinHeat.oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3]
  exact ⟨rfl, hsparse, hbackend⟩

example (H : Matrix 8 8 Coeff) (env : String → Rat) :
    let target :=
      Examples.RobinHeat.oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3
        H env
    target.theoremFacingPreparedEntry =
        "(oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_n3 H).matrix clean clean" ∧
      target.conditionalBackendEvalBridgeLemma =
        "oneTermRobinGamma3BoundaryPreparedCompositeCleanEntryEval_eq_backend_n3" ∧
      target.preparedProjectionTargetCompiled = true ∧
      target.preparedSingletonEntrySelected = true ∧
      target.singletonToSparseEvalCompiled = true ∧
      target.conditionalBackendEvalBridgeCompiled = true ∧
      target.activeProjectionBackendUsesPreparedEntry = false ∧
      target.activePreparedEntryEqualityProved = false ∧
      target.productToCoefficientProved = false ∧
      target.lcuCorrectProved = false ∧
      target.blockProjectionProved = false ∧
      target.finalExtractionProved = false := by
  dsimp [
    Examples.RobinHeat.oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3]
  exact ⟨rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl,
    rfl, rfl⟩

example
    (H : Matrix 8 8 Coeff) (env : String → Rat)
    (hUniform :
      Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3
        H) :
    (Examples.RobinHeat.oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3
        H env).activeToPreparedSingletonEvalStatement ↔
      Coeff.evalWith env
        Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry =
        Coeff.evalWith env
          (blockExtractionBranchContributionSum
            Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContribution_n3) :=
  Examples.RobinHeat.oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_iff_backendEval_n3
    H env hUniform

example (H : Matrix 8 8 Coeff) (env : String → Rat) :
    (Examples.RobinHeat.oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3
        H env).preparedSingletonToBackendEvalStatement :=
  Examples.RobinHeat.oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_preparedBackendEval_n3
    H env

example
    (H : Matrix 8 8 Coeff) (env : String → Rat)
    (hUniform :
      Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3
        H) :
    let target :=
      Examples.RobinHeat.oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3
        H env
    Coeff.evalWith env target.preparedProjectionEntry =
      Coeff.evalWith env target.backendBranchFold :=
  Examples.RobinHeat.oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_preparedProjectionEntryEval_eq_backend_n3
    H env hUniform

example (H : Matrix 8 8 Coeff) (env : String → Rat) :
    (Examples.RobinHeat.oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3
        H env).activeToPreparedSingletonEvalStatement ↔
      Examples.RobinHeat.oneTermRobinGamma3BoundaryUncastPreparedSandwichEvalStatement_n3
        H env :=
  Examples.RobinHeat.oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_iff_uncastPreparedSandwich_n3
    H env

example (H : Matrix 8 8 Coeff) (env : String → Rat) :
    (Examples.RobinHeat.oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3
        H env).activeToPreparedSingletonEvalStatement ↔
      (Examples.RobinHeat.oneTermRobinGamma3BoundaryActivePreparedCircuitFieldTarget_n3
        H env).activePreparedCompositeEvalStatement :=
  Examples.RobinHeat.oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_iff_activePreparedCircuitField_n3
    H env

example
    (H : Matrix 8 8 Coeff) (env : String → Rat)
    (hEntry :
      (Examples.RobinHeat.oneTermRobinGamma3BoundaryActivePreparedEntryTarget_n3
        H).entryEqualityStatement) :
    (Examples.RobinHeat.oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3
        H env).activeToPreparedSingletonEvalStatement :=
  Examples.RobinHeat.oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_of_entryTarget_n3
    H env hEntry

example (H : Matrix 8 8 Coeff) (env : String → Rat) :
    (Examples.RobinHeat.oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3
        H env).activeToPreparedSingletonEvalStatement ↔
      Examples.RobinHeat.oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3
        H env :=
  Examples.RobinHeat.oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_iff_uncastActivePreparedCompositeEval_n3
    H env

example
    (H : Matrix 8 8 Coeff) (env : String → Rat)
    (hUncast :
      Examples.RobinHeat.oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3
        H env) :
    (Examples.RobinHeat.oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3
        H env).activeToPreparedSingletonEvalStatement :=
  Examples.RobinHeat.oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_of_uncastActivePreparedCompositeEval_n3
    H env hUncast

example (H : Matrix 8 8 Coeff) (env : String → Rat) :
    let target :=
      Examples.RobinHeat.oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3
        H env
    let productRoute :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryProductUnderContractsRoute_n3
    target.preparedSingletonToBackendEvalStatement ∧
      target.conditionalBackendEvalBridgeCompiled = true ∧
      target.activeProjectionBackendUsesPreparedEntry = false ∧
      target.activePreparedEntryEqualityProved = false ∧
      target.productToCoefficientProved = false ∧
      target.lcuCorrectProved = false ∧
      target.blockProjectionProved = false ∧
      target.blockCorrectProved = false ∧
      target.finalExtractionProved = false ∧
      productRoute.productBridgeProved = false ∧
      productRoute.productToCoefficientProved = false ∧
      productRoute.normalizedBlockEqualityProved = false ∧
      productRoute.blockProjectionProved = false ∧
      productRoute.blockCorrectProved = false ∧
      productRoute.finalExtractionProved = false :=
  Examples.RobinHeat.oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_feedsProductRoute_n3
    H env

example (env : String → Rat) :
    Examples.RobinHeat.oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3
        env =
      (Coeff.evalWith env
          Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry =
        Coeff.evalWith env
          (blockExtractionBranchContributionSum
            Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContribution_n3)) :=
  rfl

example :
    Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry =
      (((cast (by rw [Examples.RobinHeat.oneTermRobinCircuitDimCompat 3])
        (Examples.RobinHeat.oneTermRobinCircuitSemantics 3).matrix) :
          Matrix Examples.RobinHeat.oneTermRobinGamma3BoundaryActiveFullDim_n3
            Examples.RobinHeat.oneTermRobinGamma3BoundaryActiveFullDim_n3 Coeff)
        Examples.RobinHeat.oneTermRobinGamma3BoundaryActiveCleanIndex_n3
        Examples.RobinHeat.oneTermRobinGamma3BoundaryActiveCleanIndex_n3) :=
  Examples.RobinHeat.oneTermRobinGamma3BoundarySignalUnitaryEntry_activeCircuitMatrix_n3

example (env : String → Rat) :
    Examples.RobinHeat.oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3
        env ↔
      Coeff.evalWith env
        (((cast (by rw [Examples.RobinHeat.oneTermRobinCircuitDimCompat 3])
          (Examples.RobinHeat.oneTermRobinCircuitSemantics 3).matrix) :
            Matrix Examples.RobinHeat.oneTermRobinGamma3BoundaryActiveFullDim_n3
              Examples.RobinHeat.oneTermRobinGamma3BoundaryActiveFullDim_n3 Coeff)
          Examples.RobinHeat.oneTermRobinGamma3BoundaryActiveCleanIndex_n3
          Examples.RobinHeat.oneTermRobinGamma3BoundaryActiveCleanIndex_n3) =
        Coeff.evalWith env
          (blockExtractionBranchContributionSum
            Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContribution_n3) :=
  Examples.RobinHeat.oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_iff_activeCircuitEntryEval_n3
    env

example
    (H : Matrix 8 8 Coeff) (env : String → Rat)
    (hUniform :
      Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3
        H) :
    Examples.RobinHeat.oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3
        env ↔
      (Examples.RobinHeat.oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3
        H env).activeToPreparedSingletonEvalStatement :=
  Examples.RobinHeat.oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_iff_activePreparedEval_n3
    H env hUniform

example
    (H : Matrix 8 8 Coeff) (env : String → Rat)
    (hUniform :
      Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3
        H) :
    Examples.RobinHeat.oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3
        env ↔
      (Examples.RobinHeat.oneTermRobinGamma3BoundaryActivePreparedCircuitFieldTarget_n3
        H env).activePreparedCompositeEvalStatement :=
  Examples.RobinHeat.oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_iff_activePreparedCircuitField_n3
    H env hUniform

example
    (H : Matrix 8 8 Coeff) (env : String → Rat)
    (hUniform :
      Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3
        H)
    (hFold :
      Examples.RobinHeat.oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3
        env) :
    Examples.RobinHeat.oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3
      H env :=
  Examples.RobinHeat.oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEval_of_evaluatedBackendFold_n3
    H env hUniform hFold

example
    (H : Matrix 8 8 Coeff) (env : String → Rat)
    (hUniform :
      Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3
        H)
    (hFold :
      Examples.RobinHeat.oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3
        env) :
    (Examples.RobinHeat.oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3
        H env).activeToPreparedSingletonEvalStatement :=
  Examples.RobinHeat.oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_of_evaluatedBackendFold_n3
    H env hUniform hFold

example
    (H : Matrix 8 8 Coeff) (env : String → Rat)
    (hUniform :
      Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3
        H)
    (hFold :
      Examples.RobinHeat.oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3
        env) :
    (Examples.RobinHeat.oneTermRobinGamma3BoundaryActivePreparedCircuitFieldTarget_n3
        H env).activePreparedCompositeEvalStatement :=
  Examples.RobinHeat.oneTermRobinGamma3BoundaryActivePreparedCircuitFieldTarget_activeEval_of_evaluatedBackendFold_n3
    H env hUniform hFold

example
    (H : Matrix 8 8 Coeff) (env : String → Rat)
    (hUniform :
      Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3
        H) :
    let target :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget_n3
        H env
    target.activePreparedEvalStatement ↔
      target.evaluatedBackendFoldStatement :=
  Examples.RobinHeat.oneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget_activeEval_iff_statement_n3
    H env hUniform

example
    (H : Matrix 8 8 Coeff) (env : String → Rat)
    (hUniform :
      Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3
        H) :
    let target :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget_n3
        H env
    let field :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryActivePreparedCircuitFieldTarget_n3
        H env
    target.evaluatedBackendFoldStatement ↔
      field.activePreparedCompositeEvalStatement :=
  Examples.RobinHeat.oneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget_activePreparedCircuitField_iff_statement_n3
    H env hUniform

example (H : Matrix 8 8 Coeff) (env : String → Rat) :
    Examples.RobinHeat.oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_n3
        H env ↔
      Examples.RobinHeat.oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3
        H env :=
  Examples.RobinHeat.oneTermRobinGamma3BoundaryActivePreparedCompositeEvalStatement_iff_uncast_n3
    H env

example (H : Matrix 8 8 Coeff) (env : String → Rat) :
    let field :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryActivePreparedCircuitFieldTarget_n3
        H env
    field.activePreparedCompositeEvalStatement ↔
      Examples.RobinHeat.oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3
        H env :=
  Examples.RobinHeat.oneTermRobinGamma3BoundaryActivePreparedCircuitFieldTarget_iff_uncast_n3
    H env

example (H : Matrix 8 8 Coeff) (env : String → Rat) :
    Examples.RobinHeat.oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3
        H env ↔
      Coeff.evalWith env
        ((evalGateMatrices
          (GHL2025.oneTermRobinGateMatrixPlaceholders
            (Examples.RobinHeat.oneTermParameters 3)))
          Examples.RobinHeat.oneTermRobinGamma3BoundaryPrefixRow0_n3
          Examples.RobinHeat.oneTermRobinGamma3BoundaryPrefixRow0_n3) =
        Coeff.evalWith env
          (Examples.RobinHeat.oneTermRobinGamma3BoundaryPreparedProjectionSandwichSum_n3
            H) :=
  Examples.RobinHeat.oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEval_iff_preparedSandwich_n3
    H env

example
    (H : Matrix 8 8 Coeff) (env : String → Rat)
    (hUniform :
      Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3
        H) :
    Examples.RobinHeat.oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3
        H env ↔
      Examples.RobinHeat.oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3
        env :=
  Examples.RobinHeat.oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEval_iff_evaluatedBackendFold_n3
    H env hUniform

example
    (env : String → Rat)
    (hFold :
      Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry =
        blockExtractionBranchContributionSum
          Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContribution_n3) :
    Examples.RobinHeat.oneTermRobinGamma3BoundaryEvaluatedBackendFoldStatement_n3
        env :=
  Examples.RobinHeat.oneTermRobinGamma3BoundaryEvaluatedBackendFold_of_unitaryEntryFold_n3
    env hFold

example
    (H : Matrix 8 8 Coeff) (env : String → Rat)
    (hUniform :
      Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3
        H)
    (hFold :
      Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry =
        blockExtractionBranchContributionSum
          Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContribution_n3) :
    Examples.RobinHeat.oneTermRobinGamma3BoundaryUncastPreparedSandwichEvalStatement_n3
      H env :=
  Examples.RobinHeat.oneTermRobinGamma3BoundaryUncastPreparedSandwichEval_of_unitaryEntryFold_n3
    H env hUniform hFold

example
    (H : Matrix 8 8 Coeff) (env : String → Rat)
    (hUniform :
      Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3
        H)
    (hFold :
      Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry =
        blockExtractionBranchContributionSum
          Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContribution_n3) :
    Examples.RobinHeat.oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3
      H env :=
  Examples.RobinHeat.oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEval_of_unitaryEntryFold_n3
    H env hUniform hFold

example
    (H : Matrix 8 8 Coeff) (env : String → Rat)
    (hUniform :
      Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3
        H)
    (hFold :
      Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry =
        blockExtractionBranchContributionSum
          Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContribution_n3) :
    (Examples.RobinHeat.oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3
        H env).activeToPreparedSingletonEvalStatement :=
  Examples.RobinHeat.oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_of_unitaryEntryFold_n3
    H env hUniform hFold

example
    (H : Matrix 8 8 Coeff) (env : String → Rat)
    (hRaw :
      (Examples.RobinHeat.oneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField_n3
        H).rawEntryPreparedSandwichStatement) :
    Examples.RobinHeat.oneTermRobinGamma3BoundaryUncastPreparedSandwichEvalStatement_n3
      H env :=
  Examples.RobinHeat.oneTermRobinGamma3BoundaryUncastPreparedSandwichEval_of_rawEntryPreparedSandwichField_n3
    H env hRaw

example
    (H : Matrix 8 8 Coeff) (env : String → Rat)
    (hRaw :
      (Examples.RobinHeat.oneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField_n3
        H).rawEntryPreparedSandwichStatement) :
    Examples.RobinHeat.oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3
      H env :=
  Examples.RobinHeat.oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEval_of_rawEntryPreparedSandwichField_n3
    H env hRaw

example
    (H : Matrix 8 8 Coeff) (env : String → Rat)
    (hRaw :
      (Examples.RobinHeat.oneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField_n3
        H).rawEntryPreparedSandwichStatement) :
    (Examples.RobinHeat.oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3
        H env).activeToPreparedSingletonEvalStatement :=
  Examples.RobinHeat.oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_of_rawEntryPreparedSandwichField_n3
    H env hRaw

example
    (H : Matrix 8 8 Coeff)
    (hUniform :
      Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3
        H) :
    (Examples.RobinHeat.oneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField_n3
        H).rawEntryPreparedSandwichStatement ↔
      Examples.RobinHeat.oneTermRobinGamma3BoundaryProjectionSummationTarget_n3.signalUnitaryEntry =
        blockExtractionBranchContributionSum
          Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContribution_n3 :=
  Examples.RobinHeat.oneTermRobinGamma3BoundaryRawEntryPreparedSandwichField_iff_unitaryEntryFold_n3
    H hUniform

example
    (H : Matrix 8 8 Coeff)
    (hUniform :
      Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3
        H) :
    (Examples.RobinHeat.oneTermRobinGamma3BoundaryRawEntryPreparedSandwichCircuitField_n3
        H).rawEntryPreparedSandwichStatement ↔
      Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContributionTarget_n3.backendExpansionStatement :=
  Examples.RobinHeat.oneTermRobinGamma3BoundaryRawEntryPreparedSandwichField_iff_backendExpansion_n3
    H hUniform

example
    (H : Matrix 8 8 Coeff) (env : String → Rat)
    (hUniform :
      Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3
        H)
    (hExpanded :
      (evalGateMatrices
        (GHL2025.oneTermRobinGateMatrixPlaceholders
          (Examples.RobinHeat.oneTermParameters 3)))
        Examples.RobinHeat.oneTermRobinGamma3BoundaryPrefixRow0_n3
        Examples.RobinHeat.oneTermRobinGamma3BoundaryPrefixRow0_n3 =
      (((((((0 +
        Coeff.mul
          (Examples.RobinHeat.oneTermRobinGamma3BoundarySevenGateMatrix_n3
            Examples.RobinHeat.oneTermRobinGamma3BoundaryPrefixRow0_n3
            Examples.RobinHeat.oneTermRobinGamma3BoundaryPrefixRow0_n3)
          Examples.RobinHeat.oneTermRobinGamma3BoundaryBranchEntrySelection_n3.projectionAmplitudeFactor) +
        Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContribution_n3
          ⟨1, by native_decide⟩) +
        Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContribution_n3
          ⟨2, by native_decide⟩) +
        Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContribution_n3
          ⟨3, by native_decide⟩) +
        Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContribution_n3
          ⟨4, by native_decide⟩) +
        Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContribution_n3
          ⟨5, by native_decide⟩) +
        Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContribution_n3
          ⟨6, by native_decide⟩)) :
    Examples.RobinHeat.oneTermRobinGamma3BoundaryUncastPreparedSandwichEvalStatement_n3
      H env :=
  Examples.RobinHeat.oneTermRobinGamma3BoundaryUncastPreparedSandwichEval_of_uncastActiveEntryExpandedFold_n3
    H env hUniform hExpanded

example
    (H : Matrix 8 8 Coeff) (env : String → Rat)
    (hUniform :
      Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3
        H)
    (hExpanded :
      (evalGateMatrices
        (GHL2025.oneTermRobinGateMatrixPlaceholders
          (Examples.RobinHeat.oneTermParameters 3)))
        Examples.RobinHeat.oneTermRobinGamma3BoundaryPrefixRow0_n3
        Examples.RobinHeat.oneTermRobinGamma3BoundaryPrefixRow0_n3 =
      (((((((0 +
        Coeff.mul
          (Examples.RobinHeat.oneTermRobinGamma3BoundarySevenGateMatrix_n3
            Examples.RobinHeat.oneTermRobinGamma3BoundaryPrefixRow0_n3
            Examples.RobinHeat.oneTermRobinGamma3BoundaryPrefixRow0_n3)
          Examples.RobinHeat.oneTermRobinGamma3BoundaryBranchEntrySelection_n3.projectionAmplitudeFactor) +
        Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContribution_n3
          ⟨1, by native_decide⟩) +
        Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContribution_n3
          ⟨2, by native_decide⟩) +
        Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContribution_n3
          ⟨3, by native_decide⟩) +
        Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContribution_n3
          ⟨4, by native_decide⟩) +
        Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContribution_n3
          ⟨5, by native_decide⟩) +
        Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContribution_n3
          ⟨6, by native_decide⟩)) :
    Examples.RobinHeat.oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEvalStatement_n3
      H env :=
  Examples.RobinHeat.oneTermRobinGamma3BoundaryUncastActivePreparedCompositeEval_of_uncastActiveEntryExpandedFold_n3
    H env hUniform hExpanded

example
    (H : Matrix 8 8 Coeff) (env : String → Rat)
    (hUniform :
      Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3
        H)
    (hExpanded :
      (evalGateMatrices
        (GHL2025.oneTermRobinGateMatrixPlaceholders
          (Examples.RobinHeat.oneTermParameters 3)))
        Examples.RobinHeat.oneTermRobinGamma3BoundaryPrefixRow0_n3
        Examples.RobinHeat.oneTermRobinGamma3BoundaryPrefixRow0_n3 =
      (((((((0 +
        Coeff.mul
          (Examples.RobinHeat.oneTermRobinGamma3BoundarySevenGateMatrix_n3
            Examples.RobinHeat.oneTermRobinGamma3BoundaryPrefixRow0_n3
            Examples.RobinHeat.oneTermRobinGamma3BoundaryPrefixRow0_n3)
          Examples.RobinHeat.oneTermRobinGamma3BoundaryBranchEntrySelection_n3.projectionAmplitudeFactor) +
        Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContribution_n3
          ⟨1, by native_decide⟩) +
        Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContribution_n3
          ⟨2, by native_decide⟩) +
        Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContribution_n3
          ⟨3, by native_decide⟩) +
        Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContribution_n3
          ⟨4, by native_decide⟩) +
        Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContribution_n3
          ⟨5, by native_decide⟩) +
        Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContribution_n3
          ⟨6, by native_decide⟩)) :
    (Examples.RobinHeat.oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3
        H env).activeToPreparedSingletonEvalStatement :=
  Examples.RobinHeat.oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_activeEval_of_uncastActiveEntryExpandedFold_n3
    H env hUniform hExpanded

example (H : Matrix 8 8 Coeff) (env : String → Rat) :
    let field :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryActivePreparedCircuitFieldTarget_n3
        H env
    field.activeSevenGateSemanticsCompiled = true ∧
      field.preparedSingletonSemanticsCompiled = true ∧
      field.activePreparedEntryEqualityProved = false ∧
      field.fullProductFoldProved = false ∧
      field.projectionSummationProved = false ∧
      field.productToCoefficientProved = false ∧
      field.exactRemainingObstruction =
        "the active seven-gate semantics and prepared singleton semantics are both typed, but QBE still lacks the CircuitMatrixSemantics composition theorem equating their selected entries" := by
  have _field :=
    Examples.RobinHeat.oneTermRobinGamma3BoundaryActivePreparedCircuitFieldTarget_n3_transcript
      H env
  exact ⟨rfl, rfl, rfl, rfl, rfl, rfl, rfl⟩

example (H : Matrix 8 8 Coeff) (env : String → Rat) :
    let target :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget_n3
        H env
    target.sourcePreparedTargetCompiled = true ∧
      target.evaluatedBackendFoldStatementTyped = true ∧
      target.activeEvalEquivalenceCompiled = true ∧
      target.evaluatedBackendFoldProved = false ∧
      target.rawCoeffFoldProved = false ∧
      target.projectionSummationProved = false ∧
      target.productToCoefficientProved = false ∧
      target.requiredEvaluationTheorem =
        "Coeff.evalWith env signalUnitaryEntry = Coeff.evalWith env (blockExtractionBranchContributionSum backendBranchContribution)" ∧
      target.exactRemainingObstruction =
        "the source-prepared active/evaluated-backend equivalence is compiled, but QBE still lacks the finite projection theorem evaluating the active signal-zero entry as the backend branch fold" := by
  have _target :=
    Examples.RobinHeat.oneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget_n3_transcript
      H env
  exact ⟨rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl⟩

example
    (H : Matrix 8 8 Coeff) (env : String → Rat)
    (hUniform :
      Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3
        H) :
    let target :=
      Examples.RobinHeat.oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3
        H env
    let productRoute :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryProductUnderContractsRoute_n3
    Coeff.evalWith env target.preparedProjectionEntry =
        Coeff.evalWith env target.backendBranchFold ∧
      target.productToCoefficientProved = false ∧
      target.lcuCorrectProved = false ∧
      target.blockProjectionProved = false ∧
      target.blockCorrectProved = false ∧
      target.finalExtractionProved = false ∧
      productRoute.productBridgeProved = false ∧
      productRoute.normalizedBlockEqualityProved = false ∧
      productRoute.productToCoefficientProved = false ∧
      productRoute.lcuCorrectProved = false ∧
      productRoute.blockProjectionProved = false ∧
      productRoute.blockCorrectProved = false ∧
      productRoute.finalExtractionProved = false :=
  by
    have hroute :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryProductUnderContractsRoute_preparedProjectionBackendEval_n3
        H env hUniform
    rcases hroute with
      ⟨hEval, _hPreparedEntry, _hBackendFold, _hConditional,
        _hActivePrepared, hTargetProduct, hTargetLCU, hTargetBlockProjection,
        hTargetBlockCorrect, hTargetFinal, _hFixed, hProductBridge,
        hNormalized, hProduct, hLCU, hBlockProjection, hBlockCorrect,
        hFinal⟩
    exact ⟨hEval, hTargetProduct, hTargetLCU, hTargetBlockProjection,
      hTargetBlockCorrect, hTargetFinal, hProductBridge, hNormalized, hProduct,
      hLCU, hBlockProjection, hBlockCorrect, hFinal⟩

example
    (H : Matrix 8 8 Coeff) (env : String → Rat)
    (hUniform :
      Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3
        H) :
    let target :=
      Examples.RobinHeat.oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3
        H env
    let bridge :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryFiniteProjectionProductBridge_n3
    Coeff.evalWith env target.preparedProjectionEntry =
        Coeff.evalWith env target.backendBranchFold ∧
      bridge.productRouteConsumed = true ∧
      bridge.productBridgeProved = false ∧
      bridge.branchDecompositionProved = false ∧
      bridge.normalizedBlockEqualityProved = false ∧
      bridge.productToCoefficientProved = false ∧
      bridge.lcuCorrectProved = false ∧
      bridge.blockProjectionProved = false ∧
      bridge.blockCorrectProved = false ∧
      bridge.finalExtractionProved = false :=
  by
    have hbridge :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryFiniteProjectionProductBridge_preparedProjectionBackendEval_n3
        H env hUniform
    rcases hbridge with
      ⟨hEval, _hProductRoute, hConsumed, hProductBridge,
        hBranchDecomposition, hNormalized, hProduct, hLCU, hBlockProjection,
        hBlockCorrect, hFinal⟩
    exact ⟨hEval, hConsumed, hProductBridge, hBranchDecomposition,
      hNormalized, hProduct, hLCU, hBlockProjection, hBlockCorrect, hFinal⟩

example
    (H : Matrix 8 8 Coeff) (env : String → Rat)
    (hUniform :
      Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3
        H) :
    let target :=
      Examples.RobinHeat.oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3
        H env
    let bridge :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryFiniteProjectionProductBridge_n3
    Coeff.evalWith env target.preparedProjectionEntry =
        Coeff.evalWith env target.backendBranchFold ∧
      bridge.productObligation =
        Examples.RobinHeat.oneTermRobinGamma3ProductToCoefficientObligation 3
          ⟨0, by native_decide⟩ ⟨0, by native_decide⟩ ∧
      bridge.productObligation.proved = false ∧
      bridge.productRouteConsumed = true ∧
      bridge.productBridgeProved = false ∧
      bridge.branchDecompositionProved = false ∧
      bridge.normalizedBlockEqualityProved = false ∧
      bridge.productToCoefficientProved = false ∧
      bridge.lcuCorrectProved = false ∧
      bridge.blockProjectionProved = false ∧
      bridge.blockCorrectProved = false ∧
      bridge.finalExtractionProved = false :=
  Examples.RobinHeat.oneTermRobinGamma3BoundaryFocusedProductObligation_preparedProjectionBackendEval_n3
    H env hUniform

example
    (H : Matrix 8 8 Coeff) (env : String → Rat)
    (hUniform :
      Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3
        H) :
    let bridge :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryFiniteProjectionProductBridge_n3
    Coeff.evalWith env
        ((Examples.RobinHeat.oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_n3
          H).matrix
          Examples.RobinHeat.oneTermRobinGamma3BoundarySparseCleanIndex_n3
          Examples.RobinHeat.oneTermRobinGamma3BoundarySparseCleanIndex_n3) =
      Coeff.evalWith env
        (blockExtractionBranchContributionSum
          Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContribution_n3) ∧
      bridge.productObligation =
        Examples.RobinHeat.oneTermRobinGamma3ProductToCoefficientObligation 3
          ⟨0, by native_decide⟩ ⟨0, by native_decide⟩ ∧
      bridge.productObligation.proved = false ∧
      bridge.productRouteConsumed = true ∧
      bridge.productBridgeProved = false ∧
      bridge.branchDecompositionProved = false ∧
      bridge.normalizedBlockEqualityProved = false ∧
      bridge.productToCoefficientProved = false ∧
      bridge.lcuCorrectProved = false ∧
      bridge.blockProjectionProved = false ∧
      bridge.blockCorrectProved = false ∧
      bridge.finalExtractionProved = false :=
  Examples.RobinHeat.oneTermRobinGamma3BoundaryFocusedProductObligation_preparedCompositeCleanEntryBackendEval_n3
    H env hUniform

example
    (H : Matrix 8 8 Coeff) (env : String → Rat)
    (hUniform :
      Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3
        H) :
    let target :=
      Examples.RobinHeat.oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3
        H env
    let bridge :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryFiniteProjectionProductBridge_n3
    let obligation :=
      Examples.RobinHeat.oneTermRobinGamma3ProductToCoefficientObligation 3
        ⟨0, by native_decide⟩ ⟨0, by native_decide⟩
    Coeff.evalWith env target.preparedProjectionEntry =
        Coeff.evalWith env target.backendBranchFold ∧
      bridge.productObligation = obligation ∧
      obligation.proved = false ∧
      bridge.productRouteConsumed = true ∧
      bridge.productBridgeProved = false ∧
      bridge.branchDecompositionProved = false ∧
      bridge.normalizedBlockEqualityProved = false ∧
      bridge.productToCoefficientProved = false ∧
      bridge.lcuCorrectProved = false ∧
      bridge.blockProjectionProved = false ∧
      bridge.blockCorrectProved = false ∧
      bridge.finalExtractionProved = false ∧
      target.productToCoefficientProved = false ∧
      target.lcuCorrectProved = false ∧
      target.blockProjectionProved = false ∧
      target.blockCorrectProved = false ∧
      target.finalExtractionProved = false :=
  Examples.RobinHeat.oneTermRobinGamma3BoundaryProductToCoefficientObligation_preparedProjectionBackendEval_n3
    H env hUniform

example
    (H : Matrix 8 8 Coeff) (env : String → Rat)
    (hUniform :
      Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3
        H) :
    let bridge :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryFiniteProjectionProductBridge_n3
    let obligation :=
      Examples.RobinHeat.oneTermRobinGamma3ProductToCoefficientObligation 3
        ⟨0, by native_decide⟩ ⟨0, by native_decide⟩
    Coeff.evalWith env
        ((Examples.RobinHeat.oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_n3
          H).matrix
          Examples.RobinHeat.oneTermRobinGamma3BoundarySparseCleanIndex_n3
          Examples.RobinHeat.oneTermRobinGamma3BoundarySparseCleanIndex_n3) =
      Coeff.evalWith env
        (blockExtractionBranchContributionSum
          Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContribution_n3) ∧
      bridge.productObligation = obligation ∧
      obligation.proved = false ∧
      bridge.productRouteConsumed = true ∧
      bridge.productBridgeProved = false ∧
      bridge.branchDecompositionProved = false ∧
      bridge.normalizedBlockEqualityProved = false ∧
      bridge.productToCoefficientProved = false ∧
      bridge.lcuCorrectProved = false ∧
      bridge.blockProjectionProved = false ∧
      bridge.blockCorrectProved = false ∧
      bridge.finalExtractionProved = false :=
  Examples.RobinHeat.oneTermRobinGamma3BoundaryProductToCoefficientObligation_preparedCompositeCleanEntryBackendEval_n3
    H env hUniform

example
    (H : Matrix 8 8 Coeff) (env : String → Rat)
    (hUniform :
      Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3
        H) :
    let bridge :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryFiniteProjectionProductBridge_n3
    let obligation :=
      Examples.RobinHeat.oneTermRobinGamma3ProductToCoefficientObligation 3
        ⟨0, by native_decide⟩ ⟨0, by native_decide⟩
    Coeff.evalWith env
        ((Examples.RobinHeat.oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_n3
          H).matrix
          Examples.RobinHeat.oneTermRobinGamma3BoundarySparseCleanIndex_n3
          Examples.RobinHeat.oneTermRobinGamma3BoundarySparseCleanIndex_n3) =
      Coeff.evalWith env
        (blockExtractionBranchContributionSum
          Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContribution_n3) ∧
      bridge.productObligation = obligation ∧
      obligation.proved = false ∧
      bridge.normalizedBlockEqualityProved = false ∧
      bridge.productToCoefficientProved = false ∧
      bridge.lcuCorrectProved = false ∧
      bridge.blockProjectionProved = false ∧
      bridge.blockCorrectProved = false ∧
      bridge.finalExtractionProved = false :=
  Examples.RobinHeat.oneTermRobinGamma3BoundaryPreparedCleanEntryBackendEval_feedsFixedProductMap_n3
    H env hUniform

example
    (H : Matrix 8 8 Coeff) (env : String → Rat)
    (hUniform :
      Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3
        H) :
    let target :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget_n3
        H env
    let bridge :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryFiniteProjectionProductBridge_n3
    let obligation :=
      Examples.RobinHeat.oneTermRobinGamma3ProductToCoefficientObligation 3
        ⟨0, by native_decide⟩ ⟨0, by native_decide⟩
    Coeff.evalWith env
        target.sourcePreparedProjectionTarget.preparedProjectionEntry =
      Coeff.evalWith env target.backendBranchFold ∧
      target.sourcePreparedProjectionTarget.preparedProjectionEntry =
        ((Examples.RobinHeat.oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_n3
          H).matrix
          Examples.RobinHeat.oneTermRobinGamma3BoundarySparseCleanIndex_n3
          Examples.RobinHeat.oneTermRobinGamma3BoundarySparseCleanIndex_n3) ∧
      target.backendBranchFold =
        blockExtractionBranchContributionSum
          Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContribution_n3 ∧
      bridge.productObligation = obligation ∧
      obligation.proved = false ∧
      target.evaluatedBackendFoldProved = false ∧
      target.rawCoeffFoldProved = false ∧
      target.productToCoefficientProved = false ∧
      target.lcuCorrectProved = false ∧
      target.blockProjectionProved = false ∧
      target.blockCorrectProved = false ∧
      target.finalExtractionProved = false ∧
      bridge.normalizedBlockEqualityProved = false ∧
      bridge.productToCoefficientProved = false ∧
      bridge.lcuCorrectProved = false ∧
      bridge.blockProjectionProved = false ∧
      bridge.blockCorrectProved = false ∧
      bridge.finalExtractionProved = false :=
  Examples.RobinHeat.oneTermRobinGamma3BoundaryEvaluatedBackendFoldTarget_preparedCleanEntryFeedsProductMap_n3
    H env hUniform

example
    (H : Matrix 8 8 Coeff) (env : String → Rat)
    (hUniform :
      Examples.RobinHeat.oneTermRobinGamma3BoundaryHWKappaUniformColumnAllSlotsStatement_n3
        H) :
    let target :=
      Examples.RobinHeat.oneTermRobinGamma3BoundarySourcePreparedProjectionTarget_n3
        H env
    let bridge :=
      Examples.RobinHeat.oneTermRobinGamma3BoundaryFiniteProjectionProductBridge_n3
    let obligation :=
      Examples.RobinHeat.oneTermRobinGamma3ProductToCoefficientObligation 3
        ⟨0, by native_decide⟩ ⟨0, by native_decide⟩
    target.preparedSingletonToBackendEvalStatement ∧
      Coeff.evalWith env target.preparedProjectionEntry =
        Coeff.evalWith env target.backendBranchFold ∧
      target.preparedProjectionEntry =
        ((Examples.RobinHeat.oneTermRobinGamma3BoundaryPreparedCompositeCircuitSemantics_n3
          H).matrix
          Examples.RobinHeat.oneTermRobinGamma3BoundarySparseCleanIndex_n3
          Examples.RobinHeat.oneTermRobinGamma3BoundarySparseCleanIndex_n3) ∧
      target.backendBranchFold =
        blockExtractionBranchContributionSum
          Examples.RobinHeat.oneTermRobinGamma3BoundaryBackendBranchContribution_n3 ∧
      bridge.productObligation = obligation ∧
      obligation.proved = false ∧
      target.activePreparedEntryEqualityProved = false ∧
      target.productToCoefficientProved = false ∧
      target.lcuCorrectProved = false ∧
      target.blockProjectionProved = false ∧
      target.blockCorrectProved = false ∧
      target.finalExtractionProved = false ∧
      bridge.normalizedBlockEqualityProved = false ∧
      bridge.productToCoefficientProved = false ∧
      bridge.lcuCorrectProved = false ∧
      bridge.blockProjectionProved = false ∧
      bridge.blockCorrectProved = false ∧
      bridge.finalExtractionProved = false :=
  Examples.RobinHeat.oneTermRobinGamma3BoundaryProductToCoefficientObligation_sourcePreparedTargetBackendEval_n3
    H env hUniform

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

-- SWAP finite permutation bridge is compiled.
example (p : GHL2025.OneTermRobinParameters) :
    (GHL2025.oneTermRobinGate_SWAP p).unitary.proved = true := rfl

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

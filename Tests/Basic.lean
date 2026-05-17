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

-- GHL2025 BlockEncodingSpec tests

-- Spec ancilla count matches the resource formula
example (p : GHL2025.OneTermRobinParameters)
    (mat : Matrix (gridSize p.n) (gridSize p.n) Coeff) :
    (GHL2025.oneTermRobinSpec p mat).resource.pureAncilla = 2 * p.n :=
  GHL2025.oneTermRobinSpec_ancilla p mat

-- Spec circuit has zero local cost (oracle calls only)
example : Circuit.resource GHL2025.oneTermRobinCircuit = 0 :=
  GHL2025.oneTermRobinSpec_circuitCost

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
example :
    let layout := GHL2025.oneTermRobinLayout
      { n := 3, kappa := 7, functionPieces := 1, polynomialDegreeCost := 1 }
    layout.systemQubits + layout.signalQubits + layout.pureAncillas = 3 + (0 + 3 + 4) + 6 := rfl

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
  sparseCorrect := True
  bandwidth_eq := rfl
}

-- AC-4: FunctionOracleContract compiles
example : GHL2025.FunctionOracleContract 3 := {
  functionPieces := 1
  normalizerBound := Coeff.symbol "N_f"
  amplitudeCorrect := True
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

-- PO-9: oneTermRobinResourceConsistent — pureAncilla = 2n for the symbolic resource
example : Examples.RobinHeat.oneTermRobinResourceConsistent (Examples.RobinHeat.oneTermParameters 3) := rfl

-- PO-3: ghostPointEliminationCorrect is abstract True (placeholder)
example : Examples.RobinHeat.ghostPointEliminationCorrect 3 := trivial

-- PO-5: robinCircuitIsUnitary is abstract True (placeholder)
example : Examples.RobinHeat.robinCircuitIsUnitary 3 := trivial

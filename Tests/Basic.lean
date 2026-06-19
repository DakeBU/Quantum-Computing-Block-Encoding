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
    BlockEncodingCost.betterThan
      { auxiliaryQubits := 5, gateCount := 9, depth := 20, oracleCalls := 0 }
      { auxiliaryQubits := 1, gateCount := 10, depth := 1, oracleCalls := 0 } := by
  simp [BlockEncodingCost.betterThan]

example :
    BlockEncodingCost.betterThan
      { auxiliaryQubits := 2, gateCount := 9, depth := 4, oracleCalls := 0 }
      { auxiliaryQubits := 1, gateCount := 10, depth := 4, oracleCalls := 0 } := by
  simp [BlockEncodingCost.betterThan]

example :
    BlockEncodingCost.betterThan
      { auxiliaryQubits := 1, gateCount := 10, depth := 4, oracleCalls := 0 }
      { auxiliaryQubits := 2, gateCount := 10, depth := 4, oracleCalls := 0 } := by
  simp [BlockEncodingCost.betterThan]

example :
    gridSize (3 + 1) = 2 * gridSize 3 := by
  native_decide

example :
    OptimalControl.exampleUnitary
      (OptimalControl.cleanIndex OptimalControl.targetState0)
      (OptimalControl.cleanIndex OptimalControl.sourceState0) = 1 := by
  native_decide

example :
    OptimalControl.exampleUnitary
      (OptimalControl.cleanIndex OptimalControl.targetState1)
      (OptimalControl.cleanIndex OptimalControl.sourceState1) = 1 := by
  native_decide

example :
    OptimalControl.exampleUnitary
      (OptimalControl.cleanIndex OptimalControl.sourceState0)
      (OptimalControl.cleanIndex OptimalControl.targetState0) = 0 := by
  native_decide

example : OptimalControl.IsPermutation OptimalControl.exampleImage :=
  OptimalControl.exampleImage_isPermutation

example :
    OptimalControl.exampleCandidate.cost =
      { auxiliaryQubits := 1, gateCount := 1, depth := 1, oracleCalls := 1 } :=
  OptimalControl.exampleCandidate_cost

example :
    ¬ OptimalControl.IsRationalOrthogonal OptimalControl.exampleOperator :=
  OptimalControl.exampleOperator_not_rationalOrthogonal

example :
    ∀ x : Fin 8,
      OptimalControl.reducedDepth5Image x = OptimalControl.reducedTargetImage x :=
  OptimalControl.reducedDepth5Image_eq_target

example :
    ∀ x : Fin 16,
      OptimalControl.liftReducedImage OptimalControl.reducedDepth5Image x =
        OptimalControl.exampleImage x :=
  OptimalControl.reducedDepth5_lifts_exampleImage

example :
    OptimalControl.IsPermutation
      (OptimalControl.liftReducedImage OptimalControl.reducedDepth5Image) :=
  OptimalControl.reducedDepth5Full_isPermutation

example :
    OptimalControl.CleanBlockE1 OptimalControl.reducedDepth5Image :=
  OptimalControl.reducedDepth5_cleanBlock

example :
    OptimalControl.IsRationalOrthogonal OptimalControl.reducedDepth5Unitary :=
  OptimalControl.reducedDepth5Unitary_isRationalOrthogonal

example :
    ∀ row col : Fin 8,
      OptimalControl.reducedDepth5Unitary
          (OptimalControl.cleanIndex row) (OptimalControl.cleanIndex col) =
        OptimalControl.exampleOperator row col :=
  OptimalControl.reducedDepth5Unitary_cleanBlock

example :
    gateMatricesMatchCircuit
      OptimalControl.reducedDepth5Circuit
      OptimalControl.reducedDepth5GateMatrices = true :=
  OptimalControl.reducedDepth5GateMatrices_matchCircuit

example :
    ∀ x : Fin 8,
      OptimalControl.evalReducedGateImages
          OptimalControl.reducedDepth5GateImages x =
        OptimalControl.reducedDepth5Image x :=
  OptimalControl.reducedDepth5GateImages_eval

example :
    OptimalControl.reducedDepth5Candidate.cost =
      { auxiliaryQubits := 1, gateCount := 6, depth := 5, oracleCalls := 0 } :=
  OptimalControl.reducedDepth5Candidate_cost

example :
    OptimalControl.reducedDepth5Verified.candidate =
      OptimalControl.reducedDepth5Candidate := rfl

example :
    OptimalControl.reducedDepth5Cost.gateCount = 6 :=
  OptimalControl.reducedDepth5Cost_gateCount

example :
    OptimalControl.reducedDepth5Cost.depth = 5 := rfl

example :
    OptimalControl.reducedDepth5Cost.oracleCalls = 0 :=
  OptimalControl.reducedDepth5Cost_oracleFree

example :
    OptimalControl.CleanBlockE1 OptimalControl.proEqTransferImage :=
  OptimalControl.proEqTransfer_cleanBlock

example :
    OptimalControl.IsRationalOrthogonal OptimalControl.proEqTransferUnitary :=
  OptimalControl.proEqTransferUnitary_isRationalOrthogonal

example :
    ∀ row col : Fin 8,
      OptimalControl.proEqTransferUnitary
          (OptimalControl.cleanIndex row) (OptimalControl.cleanIndex col) =
        OptimalControl.exampleOperator row col :=
  OptimalControl.proEqTransferUnitary_cleanBlock

example :
    gateMatricesMatchCircuit
      OptimalControl.proEqTransferCircuit
      OptimalControl.proEqTransferGateMatrices = true :=
  OptimalControl.proEqTransferGateMatrices_matchCircuit

example :
    ∀ x : Fin 8,
      OptimalControl.evalReducedGateImages
          OptimalControl.proEqTransferGateImages x =
        OptimalControl.proEqTransferImage x :=
  OptimalControl.proEqTransferGateImages_eval

example :
    OptimalControl.proEqTransferCandidate.cost =
      { auxiliaryQubits := 1, gateCount := 4, depth := 4, oracleCalls := 0 } :=
  OptimalControl.proEqTransferCandidate_cost

example :
    OptimalControl.proEqTransferVerified.candidate =
      OptimalControl.proEqTransferCandidate := rfl

example :
    OptimalControl.IsPermutation OptimalControl.proEqTransferImage :=
  OptimalControl.proEqTransferImage_isPermutation

example :
    OptimalControl.IsPermutation
      (OptimalControl.liftReducedImage OptimalControl.proEqTransferImage) :=
  OptimalControl.proEqTransferFull_isPermutation

example :
    OptimalControl.proEqTransferCost.gateCount = 4 :=
  OptimalControl.proEqTransferCost_gateCount

example :
    OptimalControl.proEqTransferCost.depth = 4 := rfl

example :
    OptimalControl.proEqTransferCost.betterThan
      OptimalControl.reducedDepth5Cost :=
  OptimalControl.proEqTransferCost_betterThan_depth5

example :
    OptimalControl.CleanBlockE1 OptimalControl.evolvedEqFlipImage :=
  OptimalControl.evolvedEqFlip_cleanBlock

example :
    OptimalControl.IsRationalOrthogonal OptimalControl.evolvedEqFlipUnitary :=
  OptimalControl.evolvedEqFlipUnitary_isRationalOrthogonal

example :
    ∀ row col : Fin 8,
      OptimalControl.evolvedEqFlipUnitary
          (OptimalControl.cleanIndex row) (OptimalControl.cleanIndex col) =
        OptimalControl.exampleOperator row col :=
  OptimalControl.evolvedEqFlipUnitary_cleanBlock

example :
    OptimalControl.IsPermutation OptimalControl.evolvedEqFlipImage :=
  OptimalControl.evolvedEqFlipImage_isPermutation

example :
    OptimalControl.IsPermutation
      (OptimalControl.liftReducedImage OptimalControl.evolvedEqFlipImage) :=
  OptimalControl.evolvedEqFlipFull_isPermutation

example :
    OptimalControl.evolvedEqFlipCost.gateCount = 4 :=
  OptimalControl.evolvedEqFlipCost_gateCount

example :
    OptimalControl.evolvedEqFlipCost.depth = 2 := rfl

example :
    OptimalControl.evolvedEqFlipCost.betterThan
      OptimalControl.proEqTransferCost :=
  OptimalControl.evolvedEqFlipCost_betterThan_pro

example :
    OptimalControl.evolvedEqFlipCost.betterThan
      OptimalControl.reducedDepth5Cost :=
  OptimalControl.evolvedEqFlipCost_betterThan_depth5

example :
    gateMatricesMatchCircuit
      OptimalControl.evolvedEqFlipCircuit
      OptimalControl.evolvedEqFlipGateMatrices = true :=
  OptimalControl.evolvedEqFlipGateMatrices_matchCircuit

example :
    ∀ x : Fin 8,
      OptimalControl.evalReducedGateImages
          OptimalControl.evolvedEqFlipGateImages x =
        OptimalControl.evolvedEqFlipImage x :=
  OptimalControl.evolvedEqFlipGateImages_eval

example :
    OptimalControl.evolvedEqFlipCandidate.cost =
      { auxiliaryQubits := 1, gateCount := 4, depth := 2, oracleCalls := 0 } :=
  OptimalControl.evolvedEqFlipCandidate_cost

example :
    OptimalControl.evolvedEqFlipVerified.candidate =
      OptimalControl.evolvedEqFlipCandidate := rfl

example :
    OptimalControl.evolvedEqFlipZeroErrorApprox.approxCandidate.epsilon = 0 := rfl

example :
    OptimalControl.evolvedEqFlipZeroErrorApprox.approxCandidate.candidate =
      OptimalControl.evolvedEqFlipCandidate := rfl

example :
    OptimalControl.directRouteAblationTarget
        ⟨0, by native_decide⟩ ⟨6, by native_decide⟩ = 1 := by
  native_decide

example :
    OptimalControl.directRouteAblationTarget
        ⟨1, by native_decide⟩ ⟨7, by native_decide⟩ = 1 := by
  native_decide

example :
    OptimalControl.directRouteAblationTarget
        ⟨6, by native_decide⟩ ⟨0, by native_decide⟩ = 0 := by
  native_decide

example :
    ∀ row col : Fin 8,
      OptimalControl.directRouteAblationUnitary
          (OptimalControl.cleanIndex row) (OptimalControl.cleanIndex col) =
        OptimalControl.directRouteAblationTarget row col :=
  OptimalControl.directRouteAblation_cleanBlock

example :
    OptimalControl.IsPermutation OptimalControl.directRouteAblationImage :=
  OptimalControl.directRouteAblationImage_isPermutation

example :
    gateMatricesMatchCircuit
      OptimalControl.directRouteAblationCircuit
      OptimalControl.directRouteAblationGateMatrices = true :=
  OptimalControl.directRouteAblationGateMatrices_matchCircuit

example :
    OptimalControl.directRouteAblationResourceTuple = (4, 2, 1, 0) :=
  OptimalControl.directRouteAblationResourceTuple_eq

example : BlockEncodingSearchPhase.exactSearch ≠
    BlockEncodingSearchPhase.relaxedApproxSearch := by
  decide

example :
    (AdaptiveBlockEncodingPolicy.mk
      20
      5
      { auxiliaryQubits := 1, gateCount := 4, depth := 2, oracleCalls := 0 }
      (0 : Rat)
      true
      3
      4
      6).requiredCost.gateCount = 4 := rfl

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


/-!
Optional Robin/GHL paper-benchmark tests are intentionally not part of the
default `lake build Tests` gate.  The historical `QuantumBlockEncoding.RobinMatrix`
module remains in the repository as a research module with active proof
obligations, but public default checks should report only the current stable
operator-first ABEIS surface.
-/

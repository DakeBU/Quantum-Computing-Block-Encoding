import QuantumBlockEncoding.ConcreteSemantics
import QuantumBlockEncoding.TextbookStatePreparation
import Mathlib.Tactic

/-!
# Representative state-preparation benchmarks

This file expands the textbook state-preparation surface beyond one-qubit toy
examples.  The four fixed benchmarks are chosen to expose different algorithmic
phenomena:

* Bell-state preparation: entanglement;
* a dense two-qubit real-amplitude state: the fixed finite benchmark used to
  explain uniformly controlled-rotation / Möttönen-style synthesis;
* a structured product distribution: a Grover--Rudolph-style example where
  exploiting factorization strictly improves the same frozen resource score;
* a three-sparse three-qubit state: a fixed sparse-state benchmark where
  pruning zero branches strictly beats the corresponding dense tree transcript.

For these finite cases the mathematical state and unitary completion are exact.
The lightweight `Circuit` attached to a certificate is a resource transcript,
just as in the original textbook examples; the paper-wide scalable synthesis
claims remain separate reproduction targets.
-/

open scoped ComplexConjugate

namespace QuantumBlockEncoding.StatePreparationBenchmarks

open ConcreteSemantics

private theorem rationalMatrixUnitary4
    (matrix : FiniteMatrix 4 4 ℂ)
    (h : matrix * star matrix = 1) :
    matrix ∈ _root_.Matrix.unitaryGroup (Fin 4) ℂ := by
  rw [_root_.Matrix.mem_unitaryGroup_iff']
  exact h

private theorem rationalMatrixUnitary8
    (matrix : FiniteMatrix 8 8 ℂ)
    (h : matrix * star matrix = 1) :
    matrix ∈ _root_.Matrix.unitaryGroup (Fin 8) ℂ := by
  rw [_root_.Matrix.mem_unitaryGroup_iff']
  exact h

/-! ## Bell state -/

noncomputable abbrev bellAmplitude : ℂ :=
  TextbookStatePreparation.invSqrtTwo

noncomputable def bellState : StateVector (gridSize 2) ℂ := fun index =>
  if index.val = 0 ∨ index.val = 3 then bellAmplitude else 0

noncomputable def bellTarget : StatePreparationTarget ℂ 2 where
  amplitudes := bellState
  normalization := ∑ index, Complex.normSq (bellState index) = 1
  source := "Bell-state textbook benchmark"

theorem bellTarget_normalized : bellTarget.normalization := by
  change ∑ index : Fin 4, Complex.normSq (bellState index) = 1
  rw [Finset.sum_fin_eq_sum_range]
  have hs : Complex.normSq bellAmplitude = (1 : ℝ) / 2 := by
    simp [bellAmplitude, TextbookStatePreparation.invSqrtTwo,
      Complex.normSq_apply]
  norm_num [bellState, Finset.sum_range_succ, hs]

noncomputable def bellMatrix : FiniteMatrix (gridSize 2) (gridSize 2) ℂ :=
  fun row column =>
    match row.val, column.val with
    | 0, 0 => bellAmplitude
    | 0, 3 => bellAmplitude
    | 1, 1 => bellAmplitude
    | 1, 2 => bellAmplitude
    | 2, 1 => bellAmplitude
    | 2, 2 => -bellAmplitude
    | 3, 0 => bellAmplitude
    | 3, 3 => -bellAmplitude
    | _, _ => 0

theorem bellMatrix_unitary :
    bellMatrix ∈ _root_.Matrix.unitaryGroup (Fin (gridSize 2)) ℂ := by
  apply rationalMatrixUnitary4
  ext row column
  fin_cases row <;> fin_cases column <;>
    rw [_root_.Matrix.mul_apply, Finset.sum_fin_eq_sum_range] <;>
    simp [bellMatrix, bellAmplitude, TextbookStatePreparation.invSqrtTwo,
      Finset.sum_range_succ, _root_.Matrix.star_apply] <;>
    nlinarith [Real.sq_sqrt (by norm_num : (0 : ℝ) ≤ 2)]

noncomputable def bellGate : ComplexUnitaryGate 2 where
  matrix := bellMatrix
  unitary := bellMatrix_unitary

theorem bellMatrix_prepares_target :
    applyVec bellMatrix (zeroKet 2) = bellTarget.amplitudes := by
  rw [applyVec_zeroKet]
  change bellMatrix.col (0 : Fin 4) = bellState
  funext row
  fin_cases row <;> simp [bellMatrix, bellState, bellAmplitude]

noncomputable def bellCertificate : ComplexStatePreparationCertificate 2 where
  target := bellTarget
  gate := bellGate
  normalizationProof := bellTarget_normalized
  preparationProof := bellMatrix_prepares_target

def bellCircuit : Circuit :=
  [Gate.oneQubit "H" 0, Gate.cnot 0 1]

def bellSchedule : LayeredCircuit :=
  [[Gate.oneQubit "H" 0], [Gate.cnot 0 1]]

noncomputable def bellVerified : VerifiedStatePreparation ℂ 2 :=
  bellCertificate.verified bellCircuit bellSchedule bellCircuit.resource

theorem bellVerified_cost :
    bellVerified.candidate.cost =
      { auxiliaryQubits := 0, gateCount := 2, depth := 2, oracleCalls := 0 } := by
  rfl

/-! ## Dense Möttönen-style two-qubit benchmark -/

noncomputable def mottonenDenseState : StateVector (gridSize 2) ℂ := fun index =>
  match index.val with
  | 0 => (1 : ℂ) / 11
  | 1 => (2 : ℂ) / 11
  | 2 => (4 : ℂ) / 11
  | _ => (10 : ℂ) / 11

noncomputable def mottonenDenseTarget : StatePreparationTarget ℂ 2 where
  amplitudes := mottonenDenseState
  normalization := ∑ index, Complex.normSq (mottonenDenseState index) = 1
  source := "Möttönen-style dense two-qubit real-amplitude benchmark"

theorem mottonenDenseTarget_normalized : mottonenDenseTarget.normalization := by
  change ∑ index : Fin 4, Complex.normSq (mottonenDenseState index) = 1
  rw [Finset.sum_fin_eq_sum_range]
  norm_num [mottonenDenseState, Complex.normSq_apply, Finset.sum_range_succ]

/-- Rational quaternion completion whose first column is `(1,2,4,10)/11`. -/
noncomputable def mottonenDenseMatrix :
    FiniteMatrix (gridSize 2) (gridSize 2) ℂ := fun row column =>
  match row.val, column.val with
  | 0, 0 => (1 : ℂ) / 11
  | 0, 1 => -(2 : ℂ) / 11
  | 0, 2 => -(4 : ℂ) / 11
  | 0, 3 => -(10 : ℂ) / 11
  | 1, 0 => (2 : ℂ) / 11
  | 1, 1 => (1 : ℂ) / 11
  | 1, 2 => -(10 : ℂ) / 11
  | 1, 3 => (4 : ℂ) / 11
  | 2, 0 => (4 : ℂ) / 11
  | 2, 1 => (10 : ℂ) / 11
  | 2, 2 => (1 : ℂ) / 11
  | 2, 3 => -(2 : ℂ) / 11
  | 3, 0 => (10 : ℂ) / 11
  | 3, 1 => -(4 : ℂ) / 11
  | 3, 2 => (2 : ℂ) / 11
  | _, _ => (1 : ℂ) / 11

theorem mottonenDenseMatrix_unitary :
    mottonenDenseMatrix ∈
      _root_.Matrix.unitaryGroup (Fin (gridSize 2)) ℂ := by
  apply rationalMatrixUnitary4
  ext row column
  fin_cases row <;> fin_cases column <;>
    rw [_root_.Matrix.mul_apply, Finset.sum_fin_eq_sum_range] <;>
    norm_num [mottonenDenseMatrix, Finset.sum_range_succ,
      _root_.Matrix.star_apply]

noncomputable def mottonenDenseGate : ComplexUnitaryGate 2 where
  matrix := mottonenDenseMatrix
  unitary := mottonenDenseMatrix_unitary

theorem mottonenDenseMatrix_prepares_target :
    applyVec mottonenDenseMatrix (zeroKet 2) =
      mottonenDenseTarget.amplitudes := by
  rw [applyVec_zeroKet]
  change mottonenDenseMatrix.col (0 : Fin 4) = mottonenDenseState
  funext row
  fin_cases row <;> norm_num [mottonenDenseMatrix, mottonenDenseState]

noncomputable def mottonenDenseCertificate :
    ComplexStatePreparationCertificate 2 where
  target := mottonenDenseTarget
  gate := mottonenDenseGate
  normalizationProof := mottonenDenseTarget_normalized
  preparationProof := mottonenDenseMatrix_prepares_target

/-- Root RY followed by a one-control uniformly-controlled RY transcript. -/
def mottonenDenseCircuit : Circuit :=
  [ Gate.rotationY 1 "theta-root"
  , Gate.rotationY 0 "theta-plus"
  , Gate.cnot 1 0
  , Gate.rotationY 0 "theta-minus"
  , Gate.cnot 1 0
  ]

def mottonenDenseSchedule : LayeredCircuit :=
  mottonenDenseCircuit.map fun gate => [gate]

noncomputable def mottonenDenseVerified : VerifiedStatePreparation ℂ 2 :=
  mottonenDenseCertificate.verified
    mottonenDenseCircuit mottonenDenseSchedule mottonenDenseCircuit.resource

theorem mottonenDenseVerified_cost :
    mottonenDenseVerified.candidate.cost =
      { auxiliaryQubits := 0, gateCount := 5, depth := 5, oracleCalls := 0 } := by
  rfl

/-! ## Structured Grover--Rudolph-style product distribution -/

noncomputable def groverRudolphProductState : StateVector (gridSize 2) ℂ :=
  fun index =>
    match index.val with
    | 0 => (9 : ℂ) / 25
    | 1 => (12 : ℂ) / 25
    | 2 => (12 : ℂ) / 25
    | _ => (16 : ℂ) / 25

noncomputable def groverRudolphProductTarget : StatePreparationTarget ℂ 2 where
  amplitudes := groverRudolphProductState
  normalization := ∑ index, Complex.normSq (groverRudolphProductState index) = 1
  source := "Grover--Rudolph structured product-distribution benchmark"

theorem groverRudolphProductTarget_normalized :
    groverRudolphProductTarget.normalization := by
  change ∑ index : Fin 4, Complex.normSq (groverRudolphProductState index) = 1
  rw [Finset.sum_fin_eq_sum_range]
  norm_num [groverRudolphProductState, Complex.normSq_apply,
    Finset.sum_range_succ]

/-- `(3,4,4,3)/5` single-qubit factors expanded as a two-qubit product unitary. -/
noncomputable def groverRudolphProductMatrix :
    FiniteMatrix (gridSize 2) (gridSize 2) ℂ := fun row column =>
  match row.val, column.val with
  | 0, 0 => (9 : ℂ) / 25
  | 0, 1 => -(12 : ℂ) / 25
  | 0, 2 => -(12 : ℂ) / 25
  | 0, 3 => (16 : ℂ) / 25
  | 1, 0 => (12 : ℂ) / 25
  | 1, 1 => (9 : ℂ) / 25
  | 1, 2 => -(16 : ℂ) / 25
  | 1, 3 => -(12 : ℂ) / 25
  | 2, 0 => (12 : ℂ) / 25
  | 2, 1 => -(16 : ℂ) / 25
  | 2, 2 => (9 : ℂ) / 25
  | 2, 3 => -(12 : ℂ) / 25
  | 3, 0 => (16 : ℂ) / 25
  | 3, 1 => (12 : ℂ) / 25
  | 3, 2 => (12 : ℂ) / 25
  | _, _ => (9 : ℂ) / 25

theorem groverRudolphProductMatrix_unitary :
    groverRudolphProductMatrix ∈
      _root_.Matrix.unitaryGroup (Fin (gridSize 2)) ℂ := by
  apply rationalMatrixUnitary4
  ext row column
  fin_cases row <;> fin_cases column <;>
    rw [_root_.Matrix.mul_apply, Finset.sum_fin_eq_sum_range] <;>
    norm_num [groverRudolphProductMatrix, Finset.sum_range_succ,
      _root_.Matrix.star_apply]

noncomputable def groverRudolphProductGate : ComplexUnitaryGate 2 where
  matrix := groverRudolphProductMatrix
  unitary := groverRudolphProductMatrix_unitary

theorem groverRudolphProductMatrix_prepares_target :
    applyVec groverRudolphProductMatrix (zeroKet 2) =
      groverRudolphProductTarget.amplitudes := by
  rw [applyVec_zeroKet]
  change groverRudolphProductMatrix.col (0 : Fin 4) = groverRudolphProductState
  funext row
  fin_cases row <;>
    norm_num [groverRudolphProductMatrix, groverRudolphProductState]

noncomputable def groverRudolphProductCertificate :
    ComplexStatePreparationCertificate 2 where
  target := groverRudolphProductTarget
  gate := groverRudolphProductGate
  normalizationProof := groverRudolphProductTarget_normalized
  preparationProof := groverRudolphProductMatrix_prepares_target

/-- Generic binary-tree transcript that ignores the visible tensor-product structure. -/
def groverRudolphTreeCircuit : Circuit :=
  [ Gate.rotationY 1 "theta-root"
  , Gate.rotationY 0 "theta-plus"
  , Gate.cnot 1 0
  , Gate.rotationY 0 "theta-minus"
  , Gate.cnot 1 0
  ]

def groverRudolphTreeSchedule : LayeredCircuit :=
  groverRudolphTreeCircuit.map fun gate => [gate]

noncomputable def groverRudolphTreeVerified : VerifiedStatePreparation ℂ 2 :=
  groverRudolphProductCertificate.verified
    groverRudolphTreeCircuit groverRudolphTreeSchedule
    groverRudolphTreeCircuit.resource

/-- The product structure permits two independent one-qubit rotations in one layer. -/
def groverRudolphFactorizedCircuit : Circuit :=
  [ Gate.rotationY 0 "2 arccos(3/5)"
  , Gate.rotationY 1 "2 arccos(3/5)"
  ]

def groverRudolphFactorizedSchedule : LayeredCircuit :=
  [[ Gate.rotationY 0 "2 arccos(3/5)"
   , Gate.rotationY 1 "2 arccos(3/5)" ]]

noncomputable def groverRudolphFactorizedVerified :
    VerifiedStatePreparation ℂ 2 :=
  groverRudolphProductCertificate.verified
    groverRudolphFactorizedCircuit groverRudolphFactorizedSchedule
    groverRudolphFactorizedSchedule.resource

theorem groverRudolphTreeVerified_cost :
    groverRudolphTreeVerified.candidate.cost =
      { auxiliaryQubits := 0, gateCount := 5, depth := 5, oracleCalls := 0 } := by
  rfl

theorem groverRudolphFactorizedVerified_cost :
    groverRudolphFactorizedVerified.candidate.cost =
      { auxiliaryQubits := 0, gateCount := 2, depth := 1, oracleCalls := 0 } := by
  rfl

theorem groverRudolphFactorized_betterThan_tree :
    groverRudolphFactorizedVerified.candidate.cost.betterThan
      groverRudolphTreeVerified.candidate.cost := by
  unfold BlockEncodingCost.betterThan
  left
  change 2 < 5
  decide

/-! ## Fixed three-sparse benchmark -/

noncomputable def sparseThreeState : StateVector (gridSize 3) ℂ := fun index =>
  if index.val = 0 then (1 : ℂ) / 3
  else if index.val = 2 ∨ index.val = 4 then (2 : ℂ) / 3
  else 0

noncomputable def sparseThreeTarget : StatePreparationTarget ℂ 3 where
  amplitudes := sparseThreeState
  normalization := ∑ index, Complex.normSq (sparseThreeState index) = 1
  source := "Fixed d=3 sparse-state benchmark"

theorem sparseThreeTarget_normalized : sparseThreeTarget.normalization := by
  change ∑ index : Fin 8, Complex.normSq (sparseThreeState index) = 1
  rw [Finset.sum_fin_eq_sum_range]
  norm_num [sparseThreeState, Complex.normSq_apply, Finset.sum_range_succ]

/-- Orthogonal completion supported on rows `0,2,4`, identity elsewhere. -/
noncomputable def sparseThreeMatrix :
    FiniteMatrix (gridSize 3) (gridSize 3) ℂ := fun row column =>
  match row.val, column.val with
  | 0, 0 => (1 : ℂ) / 3
  | 0, 1 => (2 : ℂ) / 3
  | 0, 2 => (2 : ℂ) / 3
  | 2, 0 => (2 : ℂ) / 3
  | 2, 1 => -(2 : ℂ) / 3
  | 2, 2 => (1 : ℂ) / 3
  | 4, 0 => (2 : ℂ) / 3
  | 4, 1 => (1 : ℂ) / 3
  | 4, 2 => -(2 : ℂ) / 3
  | 1, 3 => 1
  | 3, 4 => 1
  | 5, 5 => 1
  | 6, 6 => 1
  | 7, 7 => 1
  | _, _ => 0

theorem sparseThreeMatrix_unitary :
    sparseThreeMatrix ∈
      _root_.Matrix.unitaryGroup (Fin (gridSize 3)) ℂ := by
  apply rationalMatrixUnitary8
  ext row column
  fin_cases row <;> fin_cases column <;>
    rw [_root_.Matrix.mul_apply, Finset.sum_fin_eq_sum_range] <;>
    norm_num [sparseThreeMatrix, Finset.sum_range_succ,
      _root_.Matrix.star_apply]

noncomputable def sparseThreeGate : ComplexUnitaryGate 3 where
  matrix := sparseThreeMatrix
  unitary := sparseThreeMatrix_unitary

theorem sparseThreeMatrix_prepares_target :
    applyVec sparseThreeMatrix (zeroKet 3) = sparseThreeTarget.amplitudes := by
  rw [applyVec_zeroKet]
  change sparseThreeMatrix.col (0 : Fin 8) = sparseThreeState
  funext row
  fin_cases row <;> norm_num [sparseThreeMatrix, sparseThreeState]

noncomputable def sparseThreeCertificate : ComplexStatePreparationCertificate 3 where
  target := sparseThreeTarget
  gate := sparseThreeGate
  normalizationProof := sparseThreeTarget_normalized
  preparationProof := sparseThreeMatrix_prepares_target

/-- Dense three-qubit binary-tree transcript: 1 + 4 + 10 primitive slots. -/
def sparseDenseTreeCircuit : Circuit :=
  [ Gate.rotationY 2 "root"
  , Gate.rotationY 1 "l0"
  , Gate.cnot 2 1
  , Gate.rotationY 1 "l1"
  , Gate.cnot 2 1
  , Gate.rotationY 0 "a0"
  , Gate.cnot 1 0
  , Gate.rotationY 0 "a1"
  , Gate.cnot 2 0
  , Gate.rotationY 0 "a2"
  , Gate.cnot 1 0
  , Gate.rotationY 0 "a3"
  , Gate.cnot 2 0
  , Gate.rotationY 0 "a4"
  , Gate.cnot 1 0
  ]

/-- Pruning the identically-zero q0 branch leaves root + one-control UCRY. -/
def sparsePrunedCircuit : Circuit :=
  [ Gate.rotationY 2 "2 arccos(sqrt(5)/3)"
  , Gate.rotationY 1 "theta-plus"
  , Gate.cnot 2 1
  , Gate.rotationY 1 "theta-minus"
  , Gate.cnot 2 1
  ]

def sparseDenseTreeSchedule : LayeredCircuit :=
  sparseDenseTreeCircuit.map fun gate => [gate]

def sparsePrunedSchedule : LayeredCircuit :=
  sparsePrunedCircuit.map fun gate => [gate]

noncomputable def sparseDenseTreeVerified : VerifiedStatePreparation ℂ 3 :=
  sparseThreeCertificate.verified
    sparseDenseTreeCircuit sparseDenseTreeSchedule sparseDenseTreeCircuit.resource

noncomputable def sparsePrunedVerified : VerifiedStatePreparation ℂ 3 :=
  sparseThreeCertificate.verified
    sparsePrunedCircuit sparsePrunedSchedule sparsePrunedCircuit.resource

theorem sparseDenseTreeVerified_cost :
    sparseDenseTreeVerified.candidate.cost =
      { auxiliaryQubits := 0, gateCount := 15, depth := 15, oracleCalls := 0 } := by
  rfl

theorem sparsePrunedVerified_cost :
    sparsePrunedVerified.candidate.cost =
      { auxiliaryQubits := 0, gateCount := 5, depth := 5, oracleCalls := 0 } := by
  rfl

theorem sparsePruned_betterThan_denseTree :
    sparsePrunedVerified.candidate.cost.betterThan
      sparseDenseTreeVerified.candidate.cost := by
  unfold BlockEncodingCost.betterThan
  left
  change 5 < 15
  decide

/-! ## Low--Kliuchnikov--Schaeffer SelectSwap resource arithmetic -/

/-- Clean-qubit SelectSwap T-count row `4 ceil(N/lambda) + 8 b lambda`.
This is a resource-formula transcription, not a proof of the full approximate
state-preparation theorem. -/
def selectSwapCleanTCount (N b lambda : Nat) : Nat :=
  4 * ((N + lambda - 1) / lambda) + 8 * b * lambda

theorem selectSwapCleanTCount_16_1_1 :
    selectSwapCleanTCount 16 1 1 = 72 := by decide

theorem selectSwapCleanTCount_16_1_4 :
    selectSwapCleanTCount 16 1 4 = 48 := by decide

theorem selectSwapCleanTCount_lambda4_better_lambda1 :
    selectSwapCleanTCount 16 1 4 < selectSwapCleanTCount 16 1 1 := by decide

end QuantumBlockEncoding.StatePreparationBenchmarks

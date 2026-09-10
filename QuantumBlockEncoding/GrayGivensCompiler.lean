import QuantumBlockEncoding.GrayBasis
import QuantumBlockEncoding.AdjacentGivens

/-! Exact Gray-ordered Givens compilation through the proved recursive
selected-RY compiler. This is not the Python Walsh/Gray multiplexor backend.
Both boundary basis reindexing and target-bit orientation are explicit. -/

namespace QuantumBlockEncoding.GrayGivensCompiler

open AdjacentGivens

theorem bit_eq_or_flip (a b : Fin 2) : a = b ∨ a = flipBit b := by
  fin_cases a <;> fin_cases b <;> simp [flipBit]

theorem x_context {n : ℕ} (target : Fin n) (bits : PrimitiveBasis n) :
    (splitPrimitiveWire target (xBasisAction target bits)).2 =
      (splitPrimitiveWire target bits).2 := by
  funext wire
  simp [splitPrimitiveWire, xBasisAction, wire.property]

theorem same_context_iff {n : ℕ} (target : Fin n) (a b : PrimitiveBasis n) :
    (splitPrimitiveWire target a).2 = (splitPrimitiveWire target b).2 ↔
      a = b ∨ a = xBasisAction target b := by
  constructor
  · intro context
    rcases bit_eq_or_flip (a target) (b target) with same | flipped
    · left
      apply (splitPrimitiveWire target).injective
      exact Prod.ext same context
    · right
      apply (splitPrimitiveWire target).injective
      apply Prod.ext
      · simpa [splitPrimitiveWire, xBasisAction] using flipped
      · exact context.trans (x_context target b).symm
  · rintro (rfl | rfl)
    · rfl
    · exact x_context target b

noncomputable def controlsEquiv {q : ℕ} (target : Fin (q + 1)) :
    Fin q ≃ OtherPrimitiveWires target :=
  Fintype.equivOfCardEq (by
    simp [OtherPrimitiveWires, Fintype.card_subtype_compl])

noncomputable def realTransport {N n : ℕ} (basis : Fin N ≃ PrimitiveBasis n) :
    _root_.Matrix (Fin N) (Fin N) ℝ ≃ₐ[ℝ]
      _root_.Matrix (PrimitiveBasis n) (PrimitiveBasis n) ℝ :=
  _root_.Matrix.reindexAlgEquiv ℝ ℝ basis

noncomputable def transport {N n : ℕ} (basis : Fin N ≃ PrimitiveBasis n) :
    _root_.Matrix (Fin N) (Fin N) ℝ →+*
      _root_.Matrix (PrimitiveBasis n) (PrimitiveBasis n) ℂ :=
  Complex.ofRealHom.mapMatrix.comp (realTransport basis).toRingHom

set_option maxHeartbeats 600000 in
theorem edge_plane_transport {N n : ℕ} (basis : Fin N ≃ PrimitiveBasis n)
    (first second : Fin N) (distinct : first ≠ second) (target : Fin n)
    (action : basis second = xBasisAction target (basis first)) (theta : ℝ) :
    realTransport basis (planeMatrix first second theta) =
      selectedRyPlaneMatrix target (splitPrimitiveWire target (basis first)).2
        (if basis first target = 0 then theta else -theta) := by
  have context (i : Fin N) :
      (splitPrimitiveWire target (basis i)).2 = (splitPrimitiveWire target (basis first)).2 ↔
        i = first ∨ i = second := by
    rw [same_context_iff, ← action]
    simp only [basis.injective.eq_iff]
  have secondBit : basis second target = flipBit (basis first target) := by
    rw [action]
    simp [xBasisAction]
  clear action
  ext a b
  obtain ⟨row, rfl⟩ := basis.surjective a
  obtain ⟨col, rfl⟩ := basis.surjective b
  simp only [realTransport, _root_.Matrix.reindexAlgEquiv_apply,
    _root_.Matrix.reindex_apply, _root_.Matrix.submatrix_apply, basis.symm_apply_apply,
    selectedRyPlaneMatrix, context, basis.injective.eq_iff]
  have bitCases : basis first target = 0 ∨ basis first target = 1 :=
    (show ∀ b : Fin 2, b = 0 ∨ b = 1 from by decide) _
  rcases bitCases with bit | bit <;>
    by_cases ri : row = first <;> by_cases rj : row = second <;>
    by_cases ci : col = first <;> by_cases cj : col = second
  all_goals try (exfalso; exact distinct (ri.symm.trans rj))
  all_goals try (exfalso; exact distinct (ci.symm.trans cj))
  all_goals simp [ri, rj, ci, cj, bit, secondBit, distinct, distinct.symm,
    planeMatrix, rotateRows, _root_.Matrix.one_apply, realRyPlaneBlock,
    flipBit, neg_div, Real.cos_neg, Real.sin_neg, eq_comm]
  all_goals simp [Ne.symm ci, Ne.symm cj]

noncomputable def stepTarget {q : ℕ} (step : AdjacentGivens.Step (2 ^ (q + 1))) : Fin (q + 1) :=
  Classical.choose (GrayBasis.adjacent step.first step.second step.adjacent)

theorem stepTarget_action {q : ℕ} (step : AdjacentGivens.Step (2 ^ (q + 1))) :
    GrayBasis.equiv (q + 1) step.second =
      xBasisAction (stepTarget step) (GrayBasis.equiv (q + 1) step.first) :=
  Classical.choose_spec (GrayBasis.adjacent step.first step.second step.adjacent)

/-- One actual selected-rotation instruction. Reversed target-bit order negates
the RY angle, while every non-target wire is an explicit control. -/
noncomputable def selectedStep {q : ℕ} (step : AdjacentGivens.Step (2 ^ (q + 1))) :
    SelectedRyStep (q + 1) q where
  target := stepTarget step
  wires := fun i => (controlsEquiv (stepTarget step) i).val
  distinct := fun i => (controlsEquiv (stepTarget step) i).property
  chosen := fun i => GrayBasis.equiv (q + 1) step.first (controlsEquiv (stepTarget step) i).val
  angle := .real (if GrayBasis.equiv (q + 1) step.first (stepTarget step) = 0
    then step.angle else -step.angle)

theorem selectedStep_matrix {q : ℕ} (step : AdjacentGivens.Step (2 ^ (q + 1))) :
    (selectedStep step).matrix = transport (GrayBasis.equiv (q + 1)) step.matrix := by
  have actual := compileSelectedRy_eval_plane (stepTarget step) (controlsEquiv (stepTarget step))
    (splitPrimitiveWire (stepTarget step) (GrayBasis.equiv (q + 1) step.first)).2
    (.real (if GrayBasis.equiv (q + 1) step.first (stepTarget step) = 0
      then step.angle else -step.angle))
  rw [compileSelectedRy_eval_block] at actual
  change (selectedStep step).matrix =
    (selectedRyPlaneMatrix (stepTarget step)
      (splitPrimitiveWire (stepTarget step) (GrayBasis.equiv (q + 1) step.first)).2
      (if GrayBasis.equiv (q + 1) step.first (stepTarget step) = 0
        then step.angle else -step.angle)).map Complex.ofReal at actual
  rw [← edge_plane_transport (GrayBasis.equiv (q + 1)) step.first step.second
    step.distinct (stepTarget step) (stepTarget_action step) step.angle] at actual
  exact actual

noncomputable def compileSteps {q : ℕ} (steps : List (AdjacentGivens.Step (2 ^ (q + 1)))) :
    PrimitiveCircuit (q + 1) := compileSelectedRySteps (steps.map selectedStep)

theorem compileSteps_eval {q : ℕ} (steps : List (AdjacentGivens.Step (2 ^ (q + 1)))) :
    evalPrimitiveCircuit (compileSteps steps) =
      transport (GrayBasis.equiv (q + 1)) (AdjacentGivens.stepsMatrix steps) := by
  rw [compileSteps, compileSelectedRySteps_eval]
  induction steps with
  | nil => simp [selectedRyStepsMatrix, AdjacentGivens.stepsMatrix]
  | cons step rest ih =>
      simp only [List.map_cons, selectedRyStepsMatrix, AdjacentGivens.stepsMatrix,
        selectedStep_matrix, ih, map_mul]

theorem compileSteps_gateCount {q : ℕ} (steps : List (AdjacentGivens.Step (2 ^ (q + 1)))) :
    (compileSteps steps).gateCount = steps.length * (2 ^ q + 2 * (2 ^ q - 1)) := by
  simp only [compileSteps, compileSelectedRySteps_gateCount, List.length_map]

/-- Input coordinates here are Gray-ordered natural indices. -/
noncomputable def compileSOGray {q : ℕ}
    (A : _root_.Matrix (Fin (2 ^ (q + 1))) (Fin (2 ^ (q + 1))) ℝ) : PrimitiveCircuit (q + 1) :=
  compileSteps (decomposeSO A)

theorem compileSOGray_eval {q : ℕ}
    (A : _root_.Matrix (Fin (2 ^ (q + 1))) (Fin (2 ^ (q + 1))) ℝ)
    (orthogonal : A.transpose * A = 1) (determinant : A.det = 1) :
    evalPrimitiveCircuit (compileSOGray A) = transport (GrayBasis.equiv (q + 1)) A := by
  rw [compileSOGray, compileSteps_eval, decomposeSO_matrix A orthogonal determinant]

theorem compileSOGray_cubic_bound {q : ℕ}
    (A : _root_.Matrix (Fin (2 ^ (q + 1))) (Fin (2 ^ (q + 1))) ℝ) :
    (compileSOGray A).gateCount ≤ 6 * (2 ^ q) ^ 3 ∧
    (compileSOGray A).resource.oracleCalls = 0 := by
  have bound := compileSelectedRySteps_cubic_bound ((decomposeSO A).map selectedStep) 1 (by
    simp [List.length_map, decomposeSO_length, pow_succ, Nat.mul_comm])
  simpa only [Nat.mul_one, compileSOGray, compileSteps] using bound

noncomputable def grayCoordinates {q : ℕ}
    (A : _root_.Matrix (PrimitiveBasis (q + 1)) (PrimitiveBasis (q + 1)) ℝ) :
    _root_.Matrix (Fin (2 ^ (q + 1))) (Fin (2 ^ (q + 1))) ℝ :=
  _root_.Matrix.reindexAlgEquiv ℝ ℝ (GrayBasis.equiv (q + 1)).symm A

/-- A circuit on the original named wires; Gray order is internal only. -/
noncomputable def compileSO {q : ℕ}
    (A : _root_.Matrix (PrimitiveBasis (q + 1)) (PrimitiveBasis (q + 1)) ℝ) :
    PrimitiveCircuit (q + 1) := compileSOGray (grayCoordinates A)

theorem grayCoordinates_orthogonal {q : ℕ}
    (A : _root_.Matrix (PrimitiveBasis (q + 1)) (PrimitiveBasis (q + 1)) ℝ)
    (orthogonal : A.transpose * A = 1) :
    (grayCoordinates A).transpose * grayCoordinates A = 1 := by
  let reindex := _root_.Matrix.reindexAlgEquiv ℝ ℝ (GrayBasis.equiv (q + 1)).symm
  change reindex A.transpose * reindex A = 1
  rw [← map_mul, orthogonal, map_one]

theorem grayCoordinates_det {q : ℕ}
    (A : _root_.Matrix (PrimitiveBasis (q + 1)) (PrimitiveBasis (q + 1)) ℝ) :
    (grayCoordinates A).det = A.det := by
  simp [grayCoordinates, _root_.Matrix.reindexAlgEquiv_apply]

/-- No assumed plane realization or Gray adjacency: the actual finite primitive
list realizes the original real SO matrix embedded in complex amplitudes. -/
theorem compileSO_eval {q : ℕ}
    (A : _root_.Matrix (PrimitiveBasis (q + 1)) (PrimitiveBasis (q + 1)) ℝ)
    (orthogonal : A.transpose * A = 1) (determinant : A.det = 1) :
    evalPrimitiveCircuit (compileSO A) = A.map Complex.ofReal := by
  rw [compileSO, compileSOGray_eval _ (grayCoordinates_orthogonal A orthogonal)
    ((grayCoordinates_det A).trans determinant)]
  ext row col
  simp [transport, realTransport, grayCoordinates, _root_.Matrix.reindexAlgEquiv_apply,
    _root_.Matrix.reindex_apply]

/-- With `S=2^q`, the exact recursive selected-RY backend needs at most `6*S^3`
primitive gates and no oracle calls, on the existing `q+1` wires. -/
theorem compileSO_cubic_bound {q : ℕ}
    (A : _root_.Matrix (PrimitiveBasis (q + 1)) (PrimitiveBasis (q + 1)) ℝ) :
    (compileSO A).gateCount ≤ 6 * (2 ^ q) ^ 3 ∧ (compileSO A).resource.oracleCalls = 0 :=
  compileSOGray_cubic_bound (grayCoordinates A)

theorem compileSO_gateCount {q : ℕ}
    (A : _root_.Matrix (PrimitiveBasis (q + 1)) (PrimitiveBasis (q + 1)) ℝ) :
    (compileSO A).gateCount =
      (2 ^ (q + 1) * (2 ^ (q + 1) - 1) / 2) * (2 ^ q + 2 * (2 ^ q - 1)) := by
  rw [compileSO, compileSOGray, compileSteps_gateCount, decomposeSO_length]

theorem compileSO_ryCount {q : ℕ}
    (A : _root_.Matrix (PrimitiveBasis (q + 1)) (PrimitiveBasis (q + 1)) ℝ) :
    (compileSO A).ryCount = (2 ^ (q + 1) * (2 ^ (q + 1) - 1) / 2) * 2 ^ q := by
  simp only [compileSO, compileSOGray, compileSteps, compileSelectedRySteps_ryCount,
    List.length_map, decomposeSO_length]

theorem compileSO_cxCount {q : ℕ}
    (A : _root_.Matrix (PrimitiveBasis (q + 1)) (PrimitiveBasis (q + 1)) ℝ) :
    (compileSO A).cxCount =
      (2 ^ (q + 1) * (2 ^ (q + 1) - 1) / 2) * (2 * (2 ^ q - 1)) := by
  simp only [compileSO, compileSOGray, compileSteps, compileSelectedRySteps_cxCount,
    List.length_map, decomposeSO_length]

end QuantumBlockEncoding.GrayGivensCompiler

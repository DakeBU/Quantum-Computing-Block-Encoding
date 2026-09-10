import QuantumBlockEncoding.UniformlyControlledRy

/-!
# Selected RY planes and finite-list resource accounting

This adapter uses the proved recursive RY/CX compiler, not the Walsh/Gray
export backend. Its exact count is `2^m` RY and `2 * (2^m - 1)` CX per
selected rotation. When the controls enumerate all non-target wires, the
operator rotates exactly one computational-basis pair and fixes its complement.

This file does not assert a general SO decomposition: constructing a bounded
list of these planes realizing a prescribed stage remains a separate obligation.
-/

namespace QuantumBlockEncoding

open Robin.ComplexLCU

/-- One nonzero entry in a multiplexed angle table; all other branches are identity. -/
def selectedRyAngles {controls : Nat} (chosen : PrimitiveBasis controls)
    (angle : ExactAngle) : PrimitiveBasis controls → ExactAngle :=
  fun bits => if bits = chosen then angle else .rational 0

def compileSelectedRy {qubits controls : Nat}
    (wires : Fin controls → Fin qubits) (target : Fin qubits)
    (distinct : ∀ control, wires control ≠ target)
    (chosen : PrimitiveBasis controls) (angle : ExactAngle) :
    PrimitiveCircuit qubits :=
  compileUniformlyControlledRy controls wires target distinct
    (selectedRyAngles chosen angle)

/-- General block version, allowing unused passive wires. -/
theorem compileSelectedRy_eval_block {qubits controls : Nat}
    (wires : Fin controls → Fin qubits) (target : Fin qubits)
    (distinct : ∀ control, wires control ≠ target)
    (chosen : PrimitiveBasis controls) (angle : ExactAngle) :
    evalPrimitiveCircuit (compileSelectedRy wires target distinct chosen angle) =
      controlledRyBlockMatrix wires target distinct (selectedRyAngles chosen angle) :=
  compileUniformlyControlledRy_eval_controlledRyBlockMatrix _ _ _ _

/-- The real matrix underlying the standard half-angle RY convention. -/
noncomputable def realRyPlaneBlock (theta : ℝ) :
    _root_.Matrix (Fin 2) (Fin 2) ℝ :=
  !![Real.cos (theta / 2), -Real.sin (theta / 2);
     Real.sin (theta / 2), Real.cos (theta / 2)]

theorem standardRyMatrix_eq_realRyPlaneBlock (theta : ℝ) (row column : Fin 2) :
    standardRyMatrix theta row column = (realRyPlaneBlock theta row column : ℂ) := by
  fin_cases row <;> fin_cases column <;>
    simp [standardRyMatrix, realRotation, realOrthogonalRotation, realRyPlaneBlock]

@[simp] theorem realRyPlaneBlock_zero : realRyPlaneBlock 0 = 1 := by
  ext row column
  fin_cases row <;> fin_cases column <;> simp [realRyPlaneBlock]

/-- A real two-level plane: the chosen pair is ordered by target bit 0, then 1.
Every other computational-basis vector is fixed, including its sign. -/
noncomputable def selectedRyPlaneMatrix {qubits : Nat} (target : Fin qubits)
    (chosen : OtherPrimitiveWires target → Fin 2) (theta : ℝ) :
    _root_.Matrix (PrimitiveBasis qubits) (PrimitiveBasis qubits) ℝ :=
  fun row column =>
    if (splitPrimitiveWire target row).2 = chosen ∧
        (splitPrimitiveWire target column).2 = chosen then
      realRyPlaneBlock theta (row target) (column target)
    else if row = column then 1 else 0

theorem primitiveControlAssignment_eq_iff {qubits controls : Nat}
    (target : Fin qubits) (wires : Fin controls ≃ OtherPrimitiveWires target)
    (rowContext chosen : OtherPrimitiveWires target → Fin 2) :
    primitiveControlAssignment (fun index => (wires index).1) target
        (fun index => (wires index).2) rowContext =
      (fun index => chosen (wires index)) ↔ rowContext = chosen := by
  constructor
  · intro equal
    funext wire
    simpa [primitiveControlAssignment] using congrFun equal (wires.symm wire)
  · rintro rfl
    rfl

/-- Full-control specialization: an actual finite RY/CX circuit equals the
complex embedding of the explicitly real two-level plane. -/
theorem compileSelectedRy_eval_plane {qubits controls : Nat}
    (target : Fin qubits) (wires : Fin controls ≃ OtherPrimitiveWires target)
    (chosen : OtherPrimitiveWires target → Fin 2) (angle : ExactAngle) :
    evalPrimitiveCircuit
        (compileSelectedRy (fun index => (wires index).1) target
          (fun index => (wires index).2) (fun index => chosen (wires index)) angle) =
      (selectedRyPlaneMatrix target chosen angle.eval).map Complex.ofReal := by
  rw [compileSelectedRy_eval_block]
  ext row column
  rw [controlledRyBlockMatrix_apply]
  simp only [_root_.Matrix.map_apply, selectedRyPlaneMatrix, selectedRyAngles]
  simp only [primitiveControlAssignment_eq_iff]
  by_cases same : (splitPrimitiveWire target row).2 =
      (splitPrimitiveWire target column).2
  · by_cases hit : (splitPrimitiveWire target row).2 = chosen
    · have hitColumn : (splitPrimitiveWire target column).2 = chosen := same.symm.trans hit
      simp [same, hitColumn, standardRyMatrix_eq_realRyPlaneBlock]
    · have rowEq : row = column ↔ row target = column target := by
        constructor
        · intro equal
          exact congrFun equal target
        · intro equal
          apply (splitPrimitiveWire target).injective
          exact Prod.ext equal same
      have missColumn : (splitPrimitiveWire target column).2 ≠ chosen := by
        intro hitColumn
        exact hit (same.trans hitColumn)
      simp [same, missColumn, ExactAngle.eval, _root_.Matrix.one_apply, rowEq]
      split_ifs <;> norm_num
  · have rowNe : row ≠ column := by
      intro equal
      exact same (congrArg (fun state => (splitPrimitiveWire target state).2) equal)
    have notBoth : ¬ ((splitPrimitiveWire target row).2 = chosen ∧
        (splitPrimitiveWire target column).2 = chosen) := by
      rintro ⟨left, right⟩
      exact same (left.trans right.symm)
    simp [same, rowNe, notBoth]

/-- Entry-level complement statement: no amplitude or phase is changed outside
the selected pair. -/
theorem selectedRyPlaneMatrix_fixed_column {qubits : Nat} (target : Fin qubits)
    (chosen : OtherPrimitiveWires target → Fin 2) (theta : ℝ)
    (column : PrimitiveBasis qubits)
    (outside : (splitPrimitiveWire target column).2 ≠ chosen)
    (row : PrimitiveBasis qubits) :
    selectedRyPlaneMatrix target chosen theta row column =
      (1 : _root_.Matrix (PrimitiveBasis qubits) (PrimitiveBasis qubits) ℝ) row column := by
  simp [selectedRyPlaneMatrix, outside, _root_.Matrix.one_apply]

theorem selectedRyPlaneMatrix_selected_entry {qubits : Nat} (target : Fin qubits)
    (chosen : OtherPrimitiveWires target → Fin 2) (theta : ℝ)
    (rowBit columnBit : Fin 2) :
    selectedRyPlaneMatrix target chosen theta
        ((splitPrimitiveWire target).symm (rowBit, chosen))
        ((splitPrimitiveWire target).symm (columnBit, chosen)) =
      realRyPlaneBlock theta rowBit columnBit := by
  have targetBit (bit : Fin 2) :
      ((splitPrimitiveWire target).symm (bit, chosen)) target = bit :=
    congrArg Prod.fst ((splitPrimitiveWire target).apply_symm_apply (bit, chosen))
  simp [selectedRyPlaneMatrix, targetBit]

theorem compileSelectedRy_ryCount {qubits controls : Nat}
    (wires : Fin controls → Fin qubits) (target : Fin qubits)
    (distinct : ∀ control, wires control ≠ target)
    (chosen : PrimitiveBasis controls) (angle : ExactAngle) :
    (compileSelectedRy wires target distinct chosen angle).ryCount = 2 ^ controls :=
  compileUniformlyControlledRy_ryCount _ _ _ _

theorem compileSelectedRy_cxCount {qubits controls : Nat}
    (wires : Fin controls → Fin qubits) (target : Fin qubits)
    (distinct : ∀ control, wires control ≠ target)
    (chosen : PrimitiveBasis controls) (angle : ExactAngle) :
    (compileSelectedRy wires target distinct chosen angle).cxCount =
      2 * (2 ^ controls - 1) :=
  compileUniformlyControlledRy_cxCount _ _ _ _

/-- A concrete selected-rotation instruction, not an assumed target operator. -/
structure SelectedRyStep (qubits controls : Nat) where
  wires : Fin controls → Fin qubits
  target : Fin qubits
  distinct : ∀ control, wires control ≠ target
  chosen : PrimitiveBasis controls
  angle : ExactAngle

def SelectedRyStep.compile {qubits controls : Nat}
    (step : SelectedRyStep qubits controls) : PrimitiveCircuit qubits :=
  compileSelectedRy step.wires step.target step.distinct step.chosen step.angle

noncomputable def SelectedRyStep.matrix {qubits controls : Nat}
    (step : SelectedRyStep qubits controls) :
    _root_.Matrix (PrimitiveBasis qubits) (PrimitiveBasis qubits) ℂ :=
  controlledRyBlockMatrix step.wires step.target step.distinct
    (selectedRyAngles step.chosen step.angle)

def compileSelectedRySteps {qubits controls : Nat}
    (steps : List (SelectedRyStep qubits controls)) : PrimitiveCircuit qubits :=
  steps.flatMap SelectedRyStep.compile

/-- Chronological product: the last listed stage multiplies on the left. -/
noncomputable def selectedRyStepsMatrix {qubits controls : Nat} :
    List (SelectedRyStep qubits controls) →
    _root_.Matrix (PrimitiveBasis qubits) (PrimitiveBasis qubits) ℂ
  | [] => 1
  | step :: rest => selectedRyStepsMatrix rest * step.matrix

theorem compileSelectedRySteps_eval {qubits controls : Nat}
    (steps : List (SelectedRyStep qubits controls)) :
    evalPrimitiveCircuit (compileSelectedRySteps steps) = selectedRyStepsMatrix steps := by
  induction steps with
  | nil => rfl
  | cons step rest ih =>
      simp only [compileSelectedRySteps, List.flatMap_cons, evalPrimitiveCircuit_append]
      change evalPrimitiveCircuit (compileSelectedRySteps rest) *
        evalPrimitiveCircuit step.compile = _
      rw [show evalPrimitiveCircuit (compileSelectedRySteps rest) = _ from ih]
      rw [show evalPrimitiveCircuit step.compile = step.matrix from
        compileSelectedRy_eval_block _ _ _ _ _]
      rfl

theorem compileSelectedRySteps_ryCount {qubits controls : Nat}
    (steps : List (SelectedRyStep qubits controls)) :
    (compileSelectedRySteps steps).ryCount = steps.length * 2 ^ controls := by
  induction steps with
  | nil => simp [compileSelectedRySteps, PrimitiveCircuit.ryCount]
  | cons step rest ih =>
      change (step.compile ++ compileSelectedRySteps rest).ryCount = _
      rw [PrimitiveCircuit.ryCount_append, ih]
      change (compileSelectedRy _ _ _ _ _).ryCount + _ = _
      rw [compileSelectedRy_ryCount]
      simp [Nat.add_mul, Nat.add_comm]

theorem compileSelectedRySteps_cxCount {qubits controls : Nat}
    (steps : List (SelectedRyStep qubits controls)) :
    (compileSelectedRySteps steps).cxCount = steps.length * (2 * (2 ^ controls - 1)) := by
  induction steps with
  | nil => simp [compileSelectedRySteps, PrimitiveCircuit.cxCount]
  | cons step rest ih =>
      change (step.compile ++ compileSelectedRySteps rest).cxCount = _
      rw [PrimitiveCircuit.cxCount_append, ih]
      change (compileSelectedRy _ _ _ _ _).cxCount + _ = _
      rw [compileSelectedRy_cxCount]
      simp [Nat.add_mul, Nat.add_comm]

theorem compileSelectedRySteps_noOracle {qubits controls : Nat}
    (steps : List (SelectedRyStep qubits controls)) :
    (compileSelectedRySteps steps).resource.oracleCalls = 0 := rfl

theorem compileUniformlyControlledRy_gateCount {qubits controls : Nat}
    (wires : Fin controls → Fin qubits) (target : Fin qubits)
    (distinct : ∀ control, wires control ≠ target)
    (angles : PrimitiveBasis controls → ExactAngle) :
    (compileUniformlyControlledRy controls wires target distinct angles).gateCount =
      2 ^ controls + 2 * (2 ^ controls - 1) := by
  change (compileUniformlyControlledRy controls wires target distinct angles).length = _
  induction controls with
  | zero => simp [compileUniformlyControlledRy]
  | succ controls ih =>
      simp only [compileUniformlyControlledRy, List.length_append, List.length_singleton]
      rw [ih, ih, pow_succ]
      have positive : 0 < 2 ^ controls := pow_pos (by decide) _
      omega

theorem compileSelectedRySteps_gateCount {qubits controls : Nat}
    (steps : List (SelectedRyStep qubits controls)) :
    (compileSelectedRySteps steps).gateCount =
      steps.length * (2 ^ controls + 2 * (2 ^ controls - 1)) := by
  induction steps with
  | nil => simp [compileSelectedRySteps]
  | cons step rest ih =>
      change (step.compile ++ compileSelectedRySteps rest).length = _
      rw [List.length_append]
      change step.compile.gateCount + (compileSelectedRySteps rest).gateCount = _
      rw [ih]
      change (compileUniformlyControlledRy _ _ _ _ _).gateCount + _ = _
      rw [compileUniformlyControlledRy_gateCount]
      simp [Nat.add_mul, Nat.add_comm]

/-- Concrete cubic bound for a supplied finite list. The length hypothesis is
the decomposition obligation, not a claim that arbitrary stages already have
such decompositions. With `S = 2^controls`, at most `n (2S)(2S-1)/2` selected
planes compile to at most `6 n S^3` primitive gates, with no oracle calls. -/
theorem compileSelectedRySteps_cubic_bound {qubits controls : Nat}
    (steps : List (SelectedRyStep qubits controls)) (stages : Nat)
    (lengthBound : steps.length ≤
      stages * ((2 * 2 ^ controls) * (2 * 2 ^ controls - 1) / 2)) :
    (compileSelectedRySteps steps).gateCount ≤ 6 * stages * (2 ^ controls) ^ 3 ∧
    (compileSelectedRySteps steps).resource.oracleCalls = 0 := by
  constructor
  · rw [compileSelectedRySteps_gateCount]
    let S := 2 ^ controls
    have subtractBound : 2 * S - 1 ≤ 2 * S := Nat.sub_le _ _
    have multiplyBound : (2 * S) * (2 * S - 1) ≤ (2 * S) * (2 * S) :=
      Nat.mul_le_mul_left _ subtractBound
    have divideBound := Nat.div_mul_le_self ((2 * S) * (2 * S - 1)) 2
    have planesBound : (2 * S) * (2 * S - 1) / 2 ≤ 2 * S ^ 2 := by
      nlinarith
    have listBound : steps.length ≤ stages * (2 * S ^ 2) :=
      lengthBound.trans (Nat.mul_le_mul_left _ planesBound)
    have perPlane : S + 2 * (S - 1) ≤ 3 * S := by omega
    have total := Nat.mul_le_mul listBound perPlane
    calc
      steps.length * (S + 2 * (S - 1)) ≤ stages * (2 * S ^ 2) * (3 * S) := total
      _ = 6 * stages * S ^ 3 := by ring
  · rfl

end QuantumBlockEncoding

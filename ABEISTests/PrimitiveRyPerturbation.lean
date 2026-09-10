import QuantumBlockEncoding.PrimitiveRyPerturbation

namespace QuantumBlockEncoding.PrimitiveRyPerturbationTests
open PrimitiveRyPerturbation Robin.ComplexLCU
open scoped Matrix.Norms.L2Operator

example (q : ℕ) (target : Fin q) (a b : ℝ) :
    ‖evalPrimitiveGate (.ry target (.real a)) - evalPrimitiveGate (.ry target (.real b))‖ ≤
      |a - b| / 2 := eval_ry_distance_le target (.real a) (.real b)

/-- Adding arbitrarily many spectator wires does not change this exact norm. -/
example (q : ℕ) (target : Fin q) :
    ‖evalPrimitiveGate (.ry target (.real 0)) -
      evalPrimitiveGate (.ry target (.real (2 * Real.pi)))‖ = 2 := by
  rw [eval_ry_distance]
  have h : (0 - 2 * Real.pi) / 4 = -(Real.pi / 2) := by ring
  simp only [ExactAngle.eval]
  rw [h]
  norm_num

example (a : ExactAngle) :
    ‖evalPrimitiveGate (.ry (0 : Fin 1) a) - evalPrimitiveGate (.ry (0 : Fin 1) a)‖ = 0 := by simp

example (a b : ExactAngle) :
    ‖_root_.Matrix.toEuclideanCLM (𝕜 := ℂ) (n := PrimitiveBasis 128)
      (evalPrimitiveGate (.ry (127 : Fin 128) a) - evalPrimitiveGate (.ry (127 : Fin 128) b))‖ ≤
        |a.eval - b.eval| / 2 := eval_ry_clm_distance_le (127 : Fin 128) a b

/-- Zero physical width has no RY target; empty-circuit equality still holds. -/
example (target : Fin 0) : False := Fin.elim0 target

example : ‖evalPrimitiveCircuit ([] : PrimitiveCircuit 0) -
    evalPrimitiveCircuit ([] : PrimitiveCircuit 0)‖ = 0 := by simp

def zeroState : PrimitiveBasis 2 := fun _ => 0
def firstOne : PrimitiveBasis 2 := fun wire => if wire = 0 then 1 else 0

/-- Equal angles on different physical wires do not imply equal operators. -/
theorem mismatched_targets :
    evalPrimitiveGate (.ry (0 : Fin 2) (.real Real.pi)) ≠
      evalPrimitiveGate (.ry (1 : Fin 2) (.real Real.pi)) := by
  have same0 : (splitPrimitiveWire (0 : Fin 2) zeroState).2 =
      (splitPrimitiveWire (0 : Fin 2) firstOne).2 := by
    funext wire
    simp [splitPrimitiveWire, zeroState, firstOne, wire.property]
  have different1 : (splitPrimitiveWire (1 : Fin 2) zeroState).2 ≠
      (splitPrimitiveWire (1 : Fin 2) firstOne).2 := by
    intro h
    have hh := congrFun h (⟨0, by decide⟩ : OtherPrimitiveWires (1 : Fin 2))
    norm_num [splitPrimitiveWire, zeroState, firstOne] at hh
  intro h
  have entry := congrFun (congrFun h zeroState) firstOne
  simp only [evalPrimitiveGate, liftPrimitiveOneQubit_apply] at entry
  rw [if_pos same0, if_neg different1] at entry
  norm_num [zeroState, firstOne, ExactAngle.eval, standardRyMatrix,
    realRotation, realOrthogonalRotation] at entry

example : 0 < ‖evalPrimitiveGate (.ry (0 : Fin 2) (.real Real.pi)) -
    evalPrimitiveGate (.ry (1 : Fin 2) (.real Real.pi))‖ :=
  norm_pos_iff.mpr (sub_ne_zero.mpr mismatched_targets)

#print axioms standardRy_difference_factor
#print axioms eval_ry_distance
#print axioms eval_ry_distance_le
#print axioms eval_ry_clm_distance_le
#print axioms mismatched_targets

end QuantumBlockEncoding.PrimitiveRyPerturbationTests

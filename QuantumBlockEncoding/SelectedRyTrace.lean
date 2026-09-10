import QuantumBlockEncoding.SelectedRyPlane

/-!
# Portable rational traces of the recursive selected-RY compiler

A trace contains only physical wires and rational coefficients of one supplied
angle. It is computable without evaluating that real angle. Instantiating the
trace has the semantics of the existing verified recursive backend. This does
not certify a numerical approximation of the supplied angle.
-/

namespace QuantumBlockEncoding.SelectedRyTrace

inductive Gate (qubits : Nat) where
  | ry (target : Fin qubits) (coefficient : Rat)
  | cx (control target : Fin qubits) (distinct : control ≠ target)
  deriving Repr

def Gate.instantiate {qubits : Nat} (angle : ExactAngle) : Gate qubits → PrimitiveGate qubits
  | .ry target coefficient => .ry target (.scale coefficient angle)
  | .cx control target distinct => .cx control target distinct

def instantiate {qubits : Nat} (angle : ExactAngle) (trace : List (Gate qubits)) :
    PrimitiveCircuit qubits := trace.map (Gate.instantiate angle)

/-- The supplied tuple order is the recursive control order. No dense data-state
amplitude table is needed: these coefficients concern only the local controls. -/
def compile {qubits : Nat} : (controls : Nat) →
    (wires : Fin controls → Fin qubits) → (target : Fin qubits) →
    (∀ control, wires control ≠ target) → (PrimitiveBasis controls → Rat) → List (Gate qubits)
  | 0, _, target, _, coefficients => [.ry target (coefficients fun i => Fin.elim0 i)]
  | controls + 1, wires, target, distinct, coefficients =>
      let tailWires := fun i : Fin controls => wires i.succ
      let tailDistinct := fun i : Fin controls => distinct i.succ
      let controlled := Gate.cx (wires 0) target (distinct 0)
      compile controls tailWires target tailDistinct
          (fun bits => (coefficients (Fin.cons 0 bits) + coefficients (Fin.cons 1 bits)) / 2) ++
        [controlled] ++
        compile controls tailWires target tailDistinct
          (fun bits => (coefficients (Fin.cons 0 bits) - coefficients (Fin.cons 1 bits)) / 2) ++
        [controlled]

theorem eval_congr {qubits controls : Nat} (wires : Fin controls → Fin qubits)
    (target : Fin qubits) (distinct : ∀ c, wires c ≠ target)
    (a b : PrimitiveBasis controls → ExactAngle) (h : ∀ bits, (a bits).eval = (b bits).eval) :
    evalPrimitiveCircuit (compileUniformlyControlledRy controls wires target distinct a) =
      evalPrimitiveCircuit (compileUniformlyControlledRy controls wires target distinct b) := by
  rw [compileUniformlyControlledRy_eval_controlledRyBlockMatrix,
    compileUniformlyControlledRy_eval_controlledRyBlockMatrix]
  ext row col
  simp only [controlledRyBlockMatrix_apply, h]

theorem compile_refines {qubits controls : Nat} (wires : Fin controls → Fin qubits)
    (target : Fin qubits) (distinct : ∀ c, wires c ≠ target)
    (coefficients : PrimitiveBasis controls → Rat) (angle : ExactAngle) :
    evalPrimitiveCircuit (instantiate angle (compile controls wires target distinct coefficients)) =
      evalPrimitiveCircuit (compileUniformlyControlledRy controls wires target distinct
        (fun bits => .scale (coefficients bits) angle)) := by
  induction controls with
  | zero => rfl
  | succ controls ih =>
    let tailWires := fun i : Fin controls => wires i.succ
    let tailDistinct := fun i : Fin controls => distinct i.succ
    have ha := eval_congr tailWires target tailDistinct
      (fun bits => ExactAngle.scale
        ((coefficients (Fin.cons 0 bits) + coefficients (Fin.cons 1 bits)) / 2) angle)
      (fun bits => ExactAngle.halfAdd (.scale (coefficients (Fin.cons 0 bits)) angle)
        (.scale (coefficients (Fin.cons 1 bits)) angle)) (by
          intro bits
          simp only [ExactAngle.eval_scale, ExactAngle.eval_half_add]
          push_cast
          ring)
    have hs := eval_congr tailWires target tailDistinct
      (fun bits => ExactAngle.scale
        ((coefficients (Fin.cons 0 bits) - coefficients (Fin.cons 1 bits)) / 2) angle)
      (fun bits => ExactAngle.halfSub (.scale (coefficients (Fin.cons 0 bits)) angle)
        (.scale (coefficients (Fin.cons 1 bits)) angle)) (by
          intro bits
          simp only [ExactAngle.eval_scale, ExactAngle.eval_half_sub]
          push_cast
          ring)
    simp only [compile, instantiate, List.map_append, List.map_cons, List.map_nil,
      Gate.instantiate, compileUniformlyControlledRy, evalPrimitiveCircuit_append]
    simp only [instantiate] at ih
    rw [ih, ih]
    rw [ha, hs]
    rfl

/-- A selected plane has one coefficient equal to one; all other controls select zero. -/
def selected {qubits controls : Nat} (wires : Fin controls → Fin qubits)
    (target : Fin qubits) (distinct : ∀ c, wires c ≠ target)
    (chosen : PrimitiveBasis controls) : List (Gate qubits) :=
  compile controls wires target distinct (fun bits => if bits = chosen then 1 else 0)

theorem selected_refines {qubits controls : Nat} (wires : Fin controls → Fin qubits)
    (target : Fin qubits) (distinct : ∀ c, wires c ≠ target)
    (chosen : PrimitiveBasis controls) (angle : ExactAngle) :
    evalPrimitiveCircuit (instantiate angle (selected wires target distinct chosen)) =
      evalPrimitiveCircuit (compileSelectedRy wires target distinct chosen angle) := by
  rw [selected, compile_refines, compileSelectedRy]
  apply eval_congr
  intro bits
  by_cases h : bits = chosen <;> simp [selectedRyAngles, h, ExactAngle.eval]

theorem compile_length {qubits controls : Nat} (wires : Fin controls → Fin qubits)
    (target : Fin qubits) (distinct : ∀ c, wires c ≠ target)
    (coefficients : PrimitiveBasis controls → Rat) :
    (compile controls wires target distinct coefficients).length =
      2 ^ controls + 2 * (2 ^ controls - 1) := by
  induction controls with
  | zero => rfl
  | succ controls ih =>
    simp only [compile, List.length_append, List.length_singleton, ih, pow_succ]
    have hp : 0 < 2 ^ controls := pow_pos (by decide) _
    omega

theorem selected_gateCount {qubits controls : Nat} (wires : Fin controls → Fin qubits)
    (target : Fin qubits) (distinct : ∀ c, wires c ≠ target)
    (chosen : PrimitiveBasis controls) (angle : ExactAngle) :
    (instantiate angle (selected wires target distinct chosen)).gateCount =
      2 ^ controls + 2 * (2 ^ controls - 1) := by
  simp only [PrimitiveCircuit.gateCount, instantiate, List.length_map, selected, compile_length]

end QuantumBlockEncoding.SelectedRyTrace

import QuantumBlockEncoding.SelectedRyTrace

open QuantumBlockEncoding

example (angle : ExactAngle) :
    evalPrimitiveCircuit (SelectedRyTrace.instantiate angle
      (SelectedRyTrace.selected (fun _ : Fin 1 => (0 : Fin 2)) 1 (by decide) (fun _ => 1))) =
    evalPrimitiveCircuit (compileSelectedRy (fun _ : Fin 1 => (0 : Fin 2))
      1 (by decide) (fun _ => 1) angle) :=
  SelectedRyTrace.selected_refines _ _ _ _ _

example : (SelectedRyTrace.selected (fun _ : Fin 1 => (0 : Fin 2))
    1 (by decide) (fun _ => 1)).length = 4 := by decide

example (angle : ExactAngle) : (SelectedRyTrace.instantiate angle
    (SelectedRyTrace.selected (fun _ : Fin 1 => (0 : Fin 2)) 1 (by decide) (fun _ => 1))).gateCount = 4 :=
  SelectedRyTrace.selected_gateCount _ _ _ _ _

example {qubits controls : Nat} (wires : Fin controls → Fin qubits)
    (target : Fin qubits) (distinct : ∀ c, wires c ≠ target)
    (coefficients : PrimitiveBasis controls → Rat) (angle : ExactAngle) :
    evalPrimitiveCircuit (SelectedRyTrace.instantiate angle
      (SelectedRyTrace.compile controls wires target distinct coefficients)) =
      evalPrimitiveCircuit (compileUniformlyControlledRy controls wires target distinct
        (fun bits => .scale (coefficients bits) angle)) :=
  SelectedRyTrace.compile_refines _ _ _ _ _

#print axioms SelectedRyTrace.compile_refines
#print axioms SelectedRyTrace.selected_refines
#print axioms SelectedRyTrace.selected_gateCount

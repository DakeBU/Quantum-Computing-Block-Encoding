import QuantumBlockEncoding.SelectedRyPlane

open QuantumBlockEncoding

private def controls2 : Fin 1 ≃ OtherPrimitiveWires (1 : Fin 2) where
  toFun _ := ⟨0, by decide⟩
  invFun _ := 0
  left_inv _ := Subsingleton.elim _ _
  right_inv wire := by
    rcases wire with ⟨wire, different⟩
    fin_cases wire
    · rfl
    · exact (different rfl).elim

private def chosen2 : OtherPrimitiveWires (1 : Fin 2) → Fin 2 := fun _ => 1

private def circuit2 (angle : ExactAngle) : PrimitiveCircuit 2 :=
  compileSelectedRy (fun index => (controls2 index).1) 1
    (fun index => (controls2 index).2) (fun index => chosen2 (controls2 index)) angle

example (theta : ℝ) :
    evalPrimitiveCircuit (circuit2 (.real theta)) =
      (selectedRyPlaneMatrix 1 chosen2 theta).map Complex.ofReal :=
  compileSelectedRy_eval_plane 1 controls2 chosen2 (.real theta)

-- The 0 <- 1 entry is negative sine, not positive sine or a full-angle sine.
example (theta : ℝ) :
    evalPrimitiveCircuit (circuit2 (.real theta))
        ((splitPrimitiveWire (1 : Fin 2)).symm (0, chosen2))
        ((splitPrimitiveWire (1 : Fin 2)).symm (1, chosen2)) =
      -(Real.sin (theta / 2) : ℂ) := by
  rw [show evalPrimitiveCircuit (circuit2 (.real theta)) =
      (selectedRyPlaneMatrix 1 chosen2 theta).map Complex.ofReal from
    compileSelectedRy_eval_plane 1 controls2 chosen2 (.real theta)]
  simp [selectedRyPlaneMatrix_selected_entry, realRyPlaneBlock]

-- The off-plane zero-control input is fixed with exact sign +1.
example (theta : ℝ) (row : PrimitiveBasis 2) :
    selectedRyPlaneMatrix (1 : Fin 2) chosen2 theta row (fun _ => 0) =
      (1 : _root_.Matrix (PrimitiveBasis 2) (PrimitiveBasis 2) ℝ) row (fun _ => 0) := by
  apply selectedRyPlaneMatrix_fixed_column
  intro equal
  have contradiction := congrFun equal ⟨0, by decide⟩
  norm_num [splitPrimitiveWire, chosen2] at contradiction

example (angle : ExactAngle) :
    (circuit2 angle).ryCount = 2 ∧ (circuit2 angle).cxCount = 2 := by
  constructor
  · exact compileSelectedRy_ryCount _ _ _ _ _
  · exact compileSelectedRy_cxCount _ _ _ _ _

example (step : SelectedRyStep 4 3) :
    (compileSelectedRySteps (List.replicate 120 step)).gateCount ≤ 3072 ∧
    (compileSelectedRySteps (List.replicate 120 step)).resource.oracleCalls = 0 := by
  simpa using compileSelectedRySteps_cubic_bound (List.replicate 120 step) 1 (by simp)

#print axioms QuantumBlockEncoding.compileSelectedRy_eval_plane
#print axioms QuantumBlockEncoding.selectedRyPlaneMatrix_fixed_column
#print axioms QuantumBlockEncoding.compileSelectedRySteps_eval
#print axioms QuantumBlockEncoding.compileSelectedRySteps_gateCount
#print axioms QuantumBlockEncoding.compileSelectedRySteps_cubic_bound

#check QuantumBlockEncoding.compileSelectedRy_eval_plane
#check QuantumBlockEncoding.compileSelectedRySteps_cubic_bound

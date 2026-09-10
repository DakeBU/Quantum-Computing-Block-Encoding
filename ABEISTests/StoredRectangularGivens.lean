import QuantumBlockEncoding.StoredRectangularGivens

namespace StoredRectangularGivensTests

open QuantumBlockEncoding StoredGivens StoredRectangularGivens

/-- Explicit copying, including a shared nonempty suffix. -/
example : (append [1, 2, 3] [4, 5]).value = [1, 2, 3, 4, 5] ∧
    (append [1, 2, 3] [4, 5]).cost .read = 3 ∧
    (append [1, 2, 3] [4, 5]).cost .write = 3 := by
  simp [append, tick]

example (N : ℕ) : denote (identity N).value = 1 := identity_value N

example (N : ℕ) : (identity N).cost .compare = N * N := by
  simp [identity_cost, identityBudget, tick]

example (A : StoredMatrix 0 3) : (compile A).value.steps = [] := by
  rw [compile_steps]
  simp [RectangularGivens.decompose, RectangularGivens.sweepSteps]

/-- Empty width still requires initializing the stored transform. -/
example (A : StoredMatrix 4 0) :
    (compile A).cost .field = 0 ∧ (compile A).cost .angle = 0 ∧
    (compile A).cost .emit = 0 := by
  have hf := compile_polynomial_cost_le A .field
  have ha := compile_polynomial_cost_le A .angle
  have he := compile_polynomial_cost_le A .emit
  simp [polynomialBudget] at *
  exact ⟨hf, ha, he⟩

/-- Width larger than height follows the no-pivot-row branch exactly. -/
example (A : StoredMatrix 2 5) :
    (sweep A 2 3 (by omega)).value.steps = [] := by
  rw [sweep_steps]
  simp [RectangularGivens.sweepSteps]

noncomputable def repeated : StoredMatrix 3 2 :=
  Vector.replicate 3 (Vector.replicate 2 4)

example : denote (compile repeated).value.reduced 2 0 = 0 := by
  apply compile_zero_below
  decide

example : denote (compile repeated).value.reduced 2 1 = 0 := by
  apply compile_zero_below
  decide

example : (denote (compile repeated).value.transform).transpose *
    denote (compile repeated).value.reduced = denote repeated := compile_exact_recovery _

example : (denote (compile repeated).value.transform).det = 1 := compile_transform_det _

example (A : StoredMatrix 2 3) : (compile A).cost .field ≤ 234 := by
  simpa [polynomialBudget] using compile_polynomial_cost_le A .field

example (A : StoredMatrix 2 3) : total (compile A).cost ≤ 962 := by
  simpa using compile_total_cost_le A

example (A : StoredMatrix 3 2) : total (compile A).cost ≤ 1038 := by
  simpa using compile_total_cost_le A

/-- The replay primitive has a charged empty-list read and no hidden action. -/
example (A : StoredMatrix 2 3) : (replay [] A).value = A ∧
    (replay [] A).cost .read = 1 := by simp [replay, charge, tick]

example (steps : List (AdjacentGivens.Step 3)) (A : StoredMatrix 3 2) :
    (replay steps A).cost .field = steps.length * 13 := by
  simp [replay_cost, replayStepBudget, tick]

#print axioms QuantumBlockEncoding.StoredRectangularGivens.sweep_matrix
#print axioms QuantumBlockEncoding.StoredRectangularGivens.sweep_steps
#print axioms QuantumBlockEncoding.StoredRectangularGivens.compile_transform
#print axioms QuantumBlockEncoding.StoredRectangularGivens.compile_polynomial_cost_le
#print axioms QuantumBlockEncoding.StoredRectangularGivens.compile_total_cost_le
#print axioms QuantumBlockEncoding.StoredRectangularGivens.compile_exact_recovery

end StoredRectangularGivensTests

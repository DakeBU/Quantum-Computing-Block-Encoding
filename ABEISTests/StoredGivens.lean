import QuantumBlockEncoding.StoredGivens

namespace StoredGivensTests

open QuantumBlockEncoding
open StoredGivens

noncomputable def zero23 : StoredMatrix 2 3 := Vector.replicate 2 (Vector.replicate 3 0)
noncomputable def repeated23 : StoredMatrix 2 3 := Vector.replicate 2 (Vector.replicate 3 3)

example : (angle 0 0).value = 0 := by
  rw [angle_value, AdjacentGivens.eliminationAngle_zero]

/-- The zero branch really skips arccos and the sign comparison. -/
example : (angle 0 0).cost .angle = 0 ∧ (angle 0 0).cost .compare = 1 := by
  simp [angle, StoredGivens.mul, StoredGivens.add, StoredGivens.sqrt,
    zeroTest, bind, pure, Run.bind, Run.pure, charge, tick]

example : denote (eliminate zero23 0 1 0).value.matrix = denote zero23 := by
  rw [eliminate_matrix]
  apply AdjacentGivens.eliminateEntry_zero_pair <;> simp [zero23, denote]

example : (StoredGivens.columnSweep zero23 0 0 1 (by omega)).cost .emit = 1 :=
  columnSweep_emit _ _ _ _ _

/-- Duplicate nonzero rows, not a full-rank-only example. Every lower output
entry vanishes since both rows have the same constant value. -/
example (col : Fin 3) : denote (eliminate repeated23 0 1 0).value.matrix 1 col = 0 := by
  rw [eliminate_matrix]
  have hp := (AdjacentGivens.eliminate_pair (3 : ℝ) 3).2
  simpa [AdjacentGivens.eliminateEntry, AdjacentGivens.rotateRows,
    denote, repeated23] using hp

/-- Repeated row indices retain the exact priority convention of rotateRows. -/
example (A : StoredMatrix 2 3) (theta : ℝ) :
    denote (rotate A 0 0 (Real.cos (theta / 2)) (Real.sin (theta / 2))).value =
      AdjacentGivens.rotateRows (denote A) 0 0 theta := rotate_value _ _ _ _

example (c s : ℝ) (op : Op) :
    (rowPair (#v[] : Vector ℝ 0) #v[] c s).cost op = 0 := by
  rw [rowPair_cost]
  simp

/-- Empty width has no entry arithmetic, but copying row references is paid. -/
example (A : StoredMatrix 3 0) (c s : ℝ) :
    (rotate A 0 2 c s).cost .field = 0 ∧
    (rotate A 0 2 c s).cost .read = 8 ∧
    (rotate A 0 2 c s).cost .write = 6 := by
  simp [rotate_cost, tick]

example (op : Op) :
    (materialize (N := 0) (M := 0) (fun i => Fin.elim0 i)).cost op = 0 := by
  simp [materialize_cost]

example (A : StoredMatrix 2 3) (op : Op) :
    (StoredGivens.columnSweep A 0 1 0 (by omega)).cost op = 0 := rfl

example (A : StoredMatrix 2 3) :
    (StoredGivens.columnSweep A 0 0 1 (by omega)).cost .field ≤ 26 := by
  have h := columnSweep_cost_le A 0 0 1 (by omega) .field
  simpa [stepBudget, eliminationBudget, coefficientBudget, angleBudget, tick] using h

example (A : StoredMatrix 5 3) :
    (StoredGivens.columnSweep A 2 1 3 (by omega)).value.steps.length = 3 :=
  columnSweep_steps_length _ _ _ _ _

example (A : StoredMatrix 5 3) :
    AdjacentGivens.applySteps
      (StoredGivens.columnSweep A 2 1 3 (by omega)).value.steps (denote A) =
      denote (StoredGivens.columnSweep A 2 1 3 (by omega)).value.matrix :=
  columnSweep_action _ _ _ _ _

#print axioms QuantumBlockEncoding.StoredGivens.angle_value
#print axioms QuantumBlockEncoding.StoredGivens.rotate_value
#print axioms QuantumBlockEncoding.StoredGivens.columnSweep_matrix
#print axioms QuantumBlockEncoding.StoredGivens.columnSweep_steps
#print axioms QuantumBlockEncoding.StoredGivens.columnSweep_cost_le
#print axioms QuantumBlockEncoding.StoredGivens.columnSweep_emit
#print axioms QuantumBlockEncoding.StoredGivens.materialize_cost

end StoredGivensTests

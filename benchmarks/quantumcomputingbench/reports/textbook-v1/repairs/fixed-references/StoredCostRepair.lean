import QuantumBlockEncoding.StoredGivens

namespace QuantumBlockEncoding.StoredGivens.QcbCostRepairReference

theorem zero_branch (op : Op) :
    (angle 0 0).cost op =
      3 * tick .field op + tick .sqrt op + tick .compare op := by
  cases op <;> norm_num [angle, mul, add, sqrt, zeroTest, div, arccos,
    signTest, sub, charge, Bind.bind, Pure.pure, Run.bind, Run.pure, tick] <;> decide

theorem nonnegative_nonzero_branch (op : Op) :
    (angle 1 0).cost op =
      6 * tick .field op + tick .sqrt op + tick .angle op + 2 * tick .compare op := by
  cases op <;> norm_num [angle, mul, add, sqrt, zeroTest, div, arccos,
    signTest, sub, charge, Bind.bind, Pure.pure, Run.bind, Run.pure, tick] <;> decide

theorem negative_nonzero_branch (op : Op) :
    (angle 0 (-1)).cost op =
      7 * tick .field op + tick .sqrt op + tick .angle op + 2 * tick .compare op := by
  cases op <;> norm_num [angle, mul, add, sqrt, zeroTest, div, arccos,
    signTest, sub, charge, Bind.bind, Pure.pure, Run.bind, Run.pure, tick] <;> decide

noncomputable def addZeros : Nat → Run ℝ
  | 0 => Run.pure 0
  | k + 1 => Run.bind (addZeros k) (fun x => add x 0)

theorem addZeros_value (k : Nat) : (addZeros k).value = 0 := by
  induction k with
  | zero => rfl
  | succ k ih => simp [addZeros, Run.bind, add, charge, ih]

theorem addZeros_cost (k : Nat) (op : Op) :
    (addZeros k).cost op = k * tick .field op := by
  induction k with
  | zero => simp [addZeros, Run.pure]
  | succ k ih => simp [addZeros, Run.bind, add, charge, ih, Nat.succ_mul]

theorem one_by_one_field_cost (k : Nat) :
    (materialize (fun (_ : Fin 1) (_ : Fin 1) => addZeros k)).cost .field = k := by
  rw [materialize_cost]
  simp [addZeros_cost, tick]

theorem one_by_one_zero_matrix (k : Nat) :
    denote (materialize (fun (_ : Fin 1) (_ : Fin 1) => addZeros k)).value = 0 := by
  ext i j
  simp [denote, materialize, collect, addZeros_value]

#print axioms zero_branch
#print axioms nonnegative_nonzero_branch
#print axioms negative_nonzero_branch
#print axioms addZeros_value
#print axioms addZeros_cost
#print axioms one_by_one_field_cost
#print axioms one_by_one_zero_matrix
end QuantumBlockEncoding.StoredGivens.QcbCostRepairReference

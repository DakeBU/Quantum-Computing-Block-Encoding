import QuantumBlockEncoding.StoredBernstein

namespace StoredBernsteinTests

open QuantumBlockEncoding StoredGivens StoredBernstein HermiteBernstein

example (x u v : ℝ) : (restrict (#v[x] : Vector ℝ 1) u v).value[0] = x := by
  simp [restrict, left, right, rows, collect, StoredGivens.read, sub, div,
    charge, bind, pure, Run.bind, Run.pure]

example : (left (#v[(1 : ℝ), 3] : Vector ℝ 2) (1 / 4)).value[1] = 3 / 2 := by
  norm_num [left, rows, step, cell, collect, StoredGivens.read, StoredGivens.mul,
    sub, add, charge, bind, pure, Run.bind, Run.pure]

example : (right (#v[(1 : ℝ), 3] : Vector ℝ 2) (3 / 4)).value[0] = 5 / 2 := by
  norm_num [right, rows, step, cell, collect, StoredGivens.read, StoredGivens.mul,
    sub, add, charge, bind, pure, Run.bind, Run.pure]

/-- No excluded-value premise is needed for coefficient refinement. The separate
affine evaluation theorem, rather than this program identity, requires u != 1. -/
example {d : ℕ} (xs : Vector ℝ (d + 1)) (c : ℕ → ℝ)
    (hx : ∀ i : Fin (d + 1), xs[i.val] = c i.val) (v : ℝ) (i : Fin (d + 1)) :
    (restrict xs 1 v).value[i.val] = restrictCoefficients d 1 v c i.val :=
  restrict_value xs c hx 1 v i

example (xs : Vector ℝ 2) (u v : ℝ) :
    StoredRectangularGivens.total (restrict xs u v).cost ≤ 107 := by
  simpa using restrict_total_cost_le xs u v

example (xs : Vector ℝ 1) (u v : ℝ) :
    StoredRectangularGivens.total (restrict xs u v).cost ≤ 13 := by
  simpa using restrict_total_cost_le xs u v

example (xs : Vector ℝ 10) (u v : ℝ) :
    (restrict xs u v).cost .sqrt = 0 ∧ (restrict xs u v).cost .angle = 0 := by
  constructor
  · have h := restrict_cost_le xs u v .sqrt
    simpa [edgeBudget, rowBudget, tick] using h
  · have h := restrict_cost_le xs u v .angle
    simpa [edgeBudget, rowBudget, tick] using h

#print axioms QuantumBlockEncoding.StoredBernstein.rows_value
#print axioms QuantumBlockEncoding.StoredBernstein.restrict_value
#print axioms QuantumBlockEncoding.StoredBernstein.restrict_total_cost_le

end StoredBernsteinTests

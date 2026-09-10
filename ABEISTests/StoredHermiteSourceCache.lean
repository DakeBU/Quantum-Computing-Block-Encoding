import QuantumBlockEncoding.StoredHermiteSourceCache

namespace QuantumBlockEncoding.StoredHermiteSourceCache.Tests

open StoredGivens HermiteBoundaryInjection HermiteBernstein
open scoped BigOperators

/-- Literal source endpoints for the smallest polynomial degree. -/
example (n : ℕ) (L : ℝ) : (compile 0 n L).run.value.source[0] = Real.exp (-1) := by
  have h := compile_source 0 n L ⟨0, by decide⟩
  norm_num [sourceBernsteinCoefficient, leftCoefficient_eq, sourceCoefficient_eq,
    Finset.sum_range_succ, Nat.choose] at h
  exact h

example (n : ℕ) (L : ℝ) : (compile 0 n L).run.value.source[1] = 1 := by
  have h := compile_source 0 n L ⟨1, by decide⟩
  norm_num [sourceBernsteinCoefficient, leftCoefficient_eq, sourceCoefficient_eq,
    Finset.sum_range_succ, Nat.choose] at h
  exact h

example (k n : ℕ) (L : ℝ) (i : Fin (2*k+1+1)) :
    0 < (compile k n L).run.value.source[i.val] :=
  StoredHermiteCoefficients.compile_pos k i

/-- Shared table orientations remain distinct after cache composition. -/
example (n : ℕ) (L : ℝ) : denote (compile 0 n L).run.value.shared.falseTable 0 1 = 1/2 := by
  rw [compile_shared_false, sharedCore_false]
  norm_num

example (n : ℕ) (L : ℝ) : denote (compile 0 n L).run.value.shared.trueTable 0 1 = 0 := by
  rw [compile_shared_true, sharedCore_true]
  norm_num

example (n : ℕ) (L : ℝ) : denote (compile 0 n L).run.value.shared.trueTable 1 0 = 1/2 := by
  rw [compile_shared_true, sharedCore_true]
  norm_num

/-- The strict -1 cutoff remains zero when -1 is the first grid point. -/
example (k n : ℕ) : (compile k n (1/Real.pi)).run.value.tails.cutoff = 0 := by
  rw [(compile_tails k n _ (by positivity)).1]
  simp [cutIndex, neg_mul]

example (k : ℕ) : (compile k 0 (1/Real.pi)).run.value.origin = -1 := by
  rw [compile_origin k 0 _ (by positivity)]
  simp [neg_mul]

private theorem four_width : Real.pi * (4/Real.pi) = 4 := by field_simp

private theorem four_origin : -Real.pi * (4/Real.pi) = -4 := by rw [neg_mul, four_width]

private theorem four_step : gridStep 2 (4/Real.pi) = 1 := by
  rw [gridStep, mul_assoc, four_width]
  norm_num [gridSize]

private theorem four_cutoff : cutIndex 2 (4/Real.pi) = 3 := by
  norm_num [cutIndex, four_origin, four_step, four_width]

/-- Actual cache for origin=-4, step=1: index 3 is exactly -1. -/
example (k : ℕ) : (compile k 2 (4/Real.pi)).run.value.tails.cutoff = 3 := by
  rw [(compile_tails k 2 _ (by positivity)).1, four_cutoff]

example (k : ℕ) : ((compile k 2 (4/Real.pi)).run.value.parents[0]).lower = -4 := by
  have h := compile_parents_lower k 2 (4/Real.pi) (by positivity) ⟨0, by decide⟩
  simpa [four_origin, four_step, four_cutoff, affinePoint, boundarySchedule, four_width] using h

example (k : ℕ) : ((compile k 2 (4/Real.pi)).run.value.parents[1]).lower = -4 := by
  have h := compile_parents_lower k 2 (4/Real.pi) (by positivity) ⟨1, by decide⟩
  simpa [four_origin, four_step, four_cutoff, affinePoint, boundarySchedule, four_width] using h

example (k : ℕ) : ((compile k 2 (4/Real.pi)).run.value.parents[2]).lower = -2 := by
  have h := compile_parents_lower k 2 (4/Real.pi) (by positivity) ⟨2, by decide⟩
  norm_num [four_origin, four_step, four_cutoff, affinePoint, boundarySchedule, four_width] at h
  exact h

example (k : ℕ) : ((compile k 2 (4/Real.pi)).run.value.parents[2]).first = 2 := by
  have h := compile_parents_first k 2 (4/Real.pi) (by positivity) ⟨2, by decide⟩
  norm_num [four_cutoff, boundarySchedule] at h
  exact h

example (k : ℕ) : ((compile k 2 (4/Real.pi)).run.value.tails.levels[2]).width = 4 := by
  have h := ((compile_tails k 2 (4/Real.pi) (by positivity)).2.2 ⟨2, by decide⟩).1
  norm_num [four_step] at h
  exact h

example (k : ℕ) : ((compile k 2 (4/Real.pi)).run.value.tails.levels[1]).factor = Real.exp (-2) := by
  have h := ((compile_tails k 2 (4/Real.pi) (by positivity)).2.2 ⟨1, by decide⟩).2
  norm_num [four_step] at h
  exact h

/-- Only n+1 integer spans are stored, ascending in residual level r. -/
example (k : ℕ) (L : ℝ) : (compile k 0 L).run.value.spans[0] = 1 := by
  exact compile_spans k 0 L 0

example (k : ℕ) (L : ℝ) : (compile k 2 L).run.value.spans[2] = 4 := by
  exact compile_spans k 2 L 2

example (k : ℕ) (L : ℝ) :
    (StoredDyadicSpans.atStage (compile k 2 L).run.value.spans 2).value = 1 := by
  exact StoredDyadicSpans.atStage_value 2 2

example (k : ℕ) (L : ℝ) : (compile k 0 L).exponentialCalls = 2 :=
  compile_exponentialCalls k 0 L

example (k : ℕ) (L : ℝ) : (compile k 127 L).exponentialCalls = 129 :=
  compile_exponentialCalls k 127 L

example (k : ℕ) (L : ℝ) : (compile k 2 L).quotientCalls = 12 ∧
    (compile k 2 L).remainderCalls = 9 ∧ (compile k 2 L).integerDoublings = 2 := by
  simp [compile_quotientCalls, compile_remainderCalls, compile_integerDoublings]

example (L : ℝ) (op : Op) : (compile 0 0 L).run.cost op ≤ 432 := by
  simpa using compile_cost_le 0 0 L op

example (L : ℝ) : (∑ op : Op, (compile 0 0 L).run.cost op) ≤ 3456 := by
  simpa using compile_total_cost_le 0 0 L

/-- The inherited SourceRun is the same computed result, not a second run. -/
example (k n : ℕ) (L : ℝ) (hL : 0 < L) :
    (compile k n L).toSourceRun.run.value.origin = -Real.pi * L :=
  compile_origin k n L hL

#print axioms compile_source
#print axioms compile_shared_false
#print axioms compile_tails
#print axioms compile_origin
#print axioms compile_parents_lower
#print axioms compile_spans
#print axioms compile_exponentialCalls
#print axioms compile_cost_le
#print axioms compile_total_cost_le

end QuantumBlockEncoding.StoredHermiteSourceCache.Tests

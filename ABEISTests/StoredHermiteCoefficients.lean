import QuantumBlockEncoding.StoredHermiteCoefficients

namespace ABEISTests.StoredHermiteCoefficients

open scoped BigOperators
open QuantumBlockEncoding StoredGivens HermiteBernstein
open QuantumBlockEncoding.StoredHermiteCoefficients

-- Factorial and binomial arithmetic is derived from the stored table.
example : (factorials 4).value.values[4] = 24 := by
  have h := factorials_value 4 ⟨4, by decide⟩
  norm_num at h
  exact h
example : (chooseFrom (factorials 5).value.values 5 2 (by decide) (by decide)).value = 10 := by
  rw [chooseFrom_value _ (factorials_value 5)]
  norm_num [Nat.choose]
example (op : Op) :
    (chooseFrom (factorials 5).value.values 5 2 (by decide) (by decide)).cost op =
      3 * tick .read op + 2 * tick .field op := chooseFrom_cost _ _ _ _ _ _

-- A nontrivial coefficient of exp(t) * (1-t)^(-3) is 19/2.
example : (sourceEntry 2 (factorials 5).value.values ⟨2, by decide⟩).value = 19 / 2 := by
  rw [sourceEntry_value _ _ (factorials_value 5), sourceCoefficient_eq]
  norm_num [Finset.sum_range_succ, Nat.choose]

-- Degree one handles both endpoints without exceptions or missing entries.
example (e : ℝ) : (fromConstant 0 e).value[0] = e := by
  have h := fromConstant_value 0 e ⟨0, by decide⟩
  norm_num [leftCoefficient_eq, sourceCoefficient_eq, Finset.sum_range_succ, Nat.choose] at h
  exact h
example (e : ℝ) : (fromConstant 0 e).value[1] = 1 := by
  have h := fromConstant_value 0 e ⟨1, by decide⟩
  norm_num [leftCoefficient_eq, sourceCoefficient_eq, Finset.sum_range_succ, Nat.choose] at h
  exact h

-- The degree-three vector is [e, 4e/3, 4/3, 1].
example (e : ℝ) : (fromConstant 1 e).value[1] = 4 * e / 3 := by
  have h := fromConstant_value 1 e ⟨1, by decide⟩
  norm_num [leftCoefficient_eq, sourceCoefficient_eq, Finset.sum_range_succ, Nat.choose] at h
  rw [h]
  ring
example (e : ℝ) : (fromConstant 1 e).value[2] = 4 / 3 := by
  have h := fromConstant_value 1 e ⟨2, by decide⟩
  norm_num [leftCoefficient_eq, sourceCoefficient_eq, Finset.sum_range_succ, Nat.choose] at h
  exact h

-- Two interior entries distinguish the degree-five source from a linear one.
example (e : ℝ) : (fromConstant 2 e).value[2] = 29 * e / 20 := by
  have h := fromConstant_value 2 e ⟨2, by decide⟩
  norm_num [leftCoefficient_eq, sourceCoefficient_eq, Finset.sum_range_succ, Nat.choose] at h
  rw [h]
  ring
example (e : ℝ) : (fromConstant 2 e).value[3] = 29 / 20 := by
  have h := fromConstant_value 2 e ⟨3, by decide⟩
  norm_num [leftCoefficient_eq, sourceCoefficient_eq, Finset.sum_range_succ, Nat.choose] at h
  exact h

-- Literal-source refinement and positivity hold for every degree and entry.
example (k : ℕ) (i : Fin (2 * k + 2)) :
    (compile k).run.value[i.val] = sourceBernsteinCoefficient k i.val := compile_value k i
example (k : ℕ) (i : Fin (2 * k + 2)) : 0 < (compile k).run.value[i.val] := compile_pos k i
example (k : ℕ) : (compile k).exponentialCalls = 1 := compile_exponentialCalls k
example (k : ℕ) (op : Op) : (compile k).run.cost op ≤ 108 * (k + 1) ^ 2 := compile_cost_le k op
example (k : ℕ) : StoredRectangularGivens.total (compile k).run.cost ≤ 864 * (k + 1) ^ 2 :=
  compile_total_cost_le k
example : StoredRectangularGivens.total (compile 0).run.cost ≤ 864 := by
  simpa using compile_total_cost_le 0

#print axioms QuantumBlockEncoding.StoredHermiteCoefficients.factorials_value
#print axioms QuantumBlockEncoding.StoredHermiteCoefficients.compile_value
#print axioms QuantumBlockEncoding.StoredHermiteCoefficients.compile_pos
#print axioms QuantumBlockEncoding.StoredHermiteCoefficients.compile_total_cost_le
#print axioms QuantumBlockEncoding.StoredHermiteCoefficients.compile_exponentialCalls

end ABEISTests.StoredHermiteCoefficients

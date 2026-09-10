import QuantumBlockEncoding.HermiteBinaryCutoff

namespace HermiteBinaryCutoffTests

open QuantumBlockEncoding StoredGivens HermiteBoundaryInjection HermiteBinaryCutoff

/-- The public source uses `n+1` data qubits, including the smallest case. -/
example (n : ℕ) (L : ℝ) (hL : 0 < L) :
    (compute n L).value = cutIndex n L := compute_value n L hL

/-- The exact boundary point is excluded by the strict source inequality. -/
example (start : ℕ) (span : ℝ) : (search 0 start (-1) span).value = start := by
  norm_num [search, below, charge, bind, pure, Run.bind, Run.pure]

example (start : ℕ) (span : ℝ) : (search 0 start (-2) span).value = start + 1 := by
  norm_num [search, below, charge, bind, pure, Run.bind, Run.pure]

/-- This legal real input puts the cutoff exactly at the first sample. -/
example (n : ℕ) : (compute n (1 / Real.pi)).value = 0 := by
  rw [compute_value n _ (by positivity)]
  simp [cutIndex, neg_mul]

example (L : ℝ) : (compute 0 L).cost .compare = 1 := by
  simpa using compute_comparisons 0 L

example (L : ℝ) : (compute 127 L).cost .compare = 128 := by
  simpa using compute_comparisons 127 L

example (L : ℝ) : (compute 127 L).cost .field = 256 := by
  simpa using compute_field_operations 127 L

/-- There is no trigonometric or norm operation hidden in cutoff search. -/
example (n : ℕ) (L : ℝ) :
    (compute n L).cost .sqrt = 0 ∧ (compute n L).cost .trig = 0 ∧
      (compute n L).cost .angle = 0 := by
  simp [compute_cost, tick]

#print axioms QuantumBlockEncoding.HermiteBinaryCutoff.search_value
#print axioms QuantumBlockEncoding.HermiteBinaryCutoff.compute_value
#print axioms QuantumBlockEncoding.HermiteBinaryCutoff.compute_cost

end HermiteBinaryCutoffTests

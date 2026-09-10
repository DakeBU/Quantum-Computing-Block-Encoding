import QuantumBlockEncoding.StoredHermiteSharedTables

namespace QuantumBlockEncoding.StoredHermiteSharedTablesTests

open StoredGivens StoredHermiteSharedTables HermiteBoundaryInjection

-- Generic same-producer refinement, including both triangular orientations.
example (d : ℕ) : denote (compile d).value.falseTable = sharedCore d false :=
  compile_false d

example (d : ℕ) : denote (compile d).value.trueTable = sharedCore d true :=
  compile_true d

-- Constant-degree edge case, not a source-target replacement.
example : denote (compile 0).value.falseTable 0 0 = 1 := by
  rw [compile_false, sharedCore_false]
  norm_num

example : denote (compile 0).value.trueTable 0 0 = 1 := by
  rw [compile_true, sharedCore_true]
  norm_num

-- k=0 has d=1: these off-diagonal entries discriminate transpose conventions.
example : denote (compile 1).value.falseTable 1 0 = 0 := by
  rw [compile_false, sharedCore_false]
  norm_num

example : denote (compile 1).value.falseTable 0 1 = 1 / 2 := by
  rw [compile_false, sharedCore_false]
  norm_num

example : denote (compile 1).value.trueTable 0 1 = 0 := by
  rw [compile_true, sharedCore_true]
  norm_num

example : denote (compile 1).value.trueTable 1 0 = 1 / 2 := by
  rw [compile_true, sharedCore_true]
  norm_num

-- A previously compiled source vector is consumed directly, once supplied.
example (k : ℕ) (origin step : ℝ) (lower upper : ℕ) (schedule : ℕ → ℕ)
    (r : ℕ) (bit : Bool) (a b : ℝ) (enabled : Bool)
    (ha : a = affinePoint origin step (selectedChild schedule r bit))
    (hb : b = affinePoint origin step (selectedChild schedule r bit + 2 ^ r))
    (he : enabled = true ↔ Full lower upper (selectedChild schedule r bit) (2 ^ r))
    (j : Fin (2 * k + 1 + 1)) :
    (injectionRow (StoredHermiteCoefficients.compile k).run.value a b enabled).value[j.val] =
      injectionCore k origin step lower upper schedule r bit none (some j) :=
  injectionRow_eq_injectionCore k _ (StoredHermiteCoefficients.compile_value k)
    origin step lower upper schedule r bit a b enabled ha hb he j

-- The first included sample is exactly -1; the excluded endpoint is 0.
example (j : Fin 2) :
    (injectionRow (StoredHermiteCoefficients.compile 0).run.value (-1) 0 true).value[j.val] =
      injectionCore 0 (-1) 1 0 1 (fun _ => 0) 0 false none (some j) := by
  apply injectionRow_eq_injectionCore 0 _ (StoredHermiteCoefficients.compile_value 0)
  · simp [affinePoint, selectedChild]
  · simp [affinePoint, selectedChild]
  · simp [Full, selectedChild]

-- Empty target interval: disable restriction, but still produce a stored zero row.
example (k : ℕ) (j : Fin (2 * k + 1 + 1)) :
    (injectionRow (StoredHermiteCoefficients.compile k).run.value (-1) 0 false).value[j.val] =
      injectionCore k (-1) 1 0 0 (fun _ => 0) 0 false none (some j) := by
  apply injectionRow_eq_injectionCore k _ (StoredHermiteCoefficients.compile_value k)
  · simp [affinePoint, selectedChild]
  · simp [affinePoint, selectedChild]
  · simp [Full, selectedChild]

example (k : ℕ) : StoredRectangularGivens.total (compile (2 * k + 1)).cost ≤
    1600 * (k + 1) ^ 2 := by
  have h := compile_total_cost_le (2 * k + 1)
  nlinarith

example (k : ℕ) (xs : Vector ℝ (2 * k + 1 + 1)) (a b : ℝ) (enabled : Bool) :
    StoredRectangularGivens.total (injectionRow xs a b enabled).cost ≤
      20 * (2 * k + 1) ^ 3 + 42 * (2 * k + 1) ^ 2 + 32 * (2 * k + 1) + 16 :=
  injectionRow_total_cost_le xs a b enabled

#print axioms QuantumBlockEncoding.StoredHermiteSharedTables.compile_false
#print axioms QuantumBlockEncoding.StoredHermiteSharedTables.compile_true
#print axioms QuantumBlockEncoding.StoredHermiteSharedTables.compile_total_cost_le
#print axioms QuantumBlockEncoding.StoredHermiteSharedTables.injectionRow_eq_injectionCore
#print axioms QuantumBlockEncoding.StoredHermiteSharedTables.injectionRow_total_cost_le

end QuantumBlockEncoding.StoredHermiteSharedTablesTests

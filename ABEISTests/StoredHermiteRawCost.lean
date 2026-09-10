import QuantumBlockEncoding.StoredHermiteRawCost

namespace QuantumBlockEncoding.StoredHermiteRawCost.Tests

open StoredGivens StoredTensorTrain StoredHermiteRawSource
open scoped BigOperators

/-- The alternate total really enumerates all eight counters once. -/
example : ordinary (fun _ : Op => 1) = 8 := by
  rw [ordinary_eq_total]
  norm_num [StoredRectangularGivens.total]

example (op : Op) : ordinary (tick op) = 1 := ordinary_tick op

/-- Synthetic, already returned ledgers test collector bookkeeping only;
they are not asserted to be Hermite source computations. -/
def marker {m : ℕ} (i : Fin m) : StageRun ℕ :=
  { run := ⟨i.val, tick .write⟩, exponentialCalls := 2, integerAdditions := 4 }

example : (collectStages (marker : Fin 3 → StageRun ℕ)).run.value[2] = 2 := by
  have h := collectStages_value (marker : Fin 3 → StageRun ℕ) ⟨2, by decide⟩
  exact h

example : ordinary (collectStages (marker : Fin 3 → StageRun ℕ)).run.cost = 21 := by
  rw [collectStages_total_cost]
  simp [marker, ordinary_tick]

example : (collectStages (marker : Fin 3 → StageRun ℕ)).exponentialCalls = 6 := by
  simp [collectStages_exponentialCalls, marker]

example : (collectStages (marker : Fin 3 → StageRun ℕ)).integerAdditions = 12 := by
  simp [collectStages_integerAdditions, marker]

example : ordinary (collectStages (marker : Fin 0 → StageRun ℕ)).run.cost = 0 := by
  rw [collectStages_total_cost]
  simp

example : (collectStages (marker : Fin 0 → StageRun ℕ)).exponentialCalls = 0 ∧
    (collectStages (marker : Fin 0 → StageRun ℕ)).integerAdditions = 0 := by
  simp [collectStages_exponentialCalls, collectStages_integerAdditions]

example (cache : StoredHermiteSourceCache.Cache 0 0) :
    ordinary (boundaries cache).cost = 198 := by
  simpa using boundaries_total_cost cache

example (k n : ℕ) (cache : StoredHermiteSourceCache.Cache k n) (t : Fin (n+1)) :
    (stage cache t).integerAdditions = 4 := stage_integerAdditions cache t

/-- Smallest raw source: first-core and last-core contractions are both in
the same stored-chain producer and its work certificate. -/
example (L : ℝ) (hL : 0 < L) :
    denoteChain (raw 0 0 L).run.value = HermiteExplicitBond.rawSourceChain 0 0 L :=
  (raw_certified 0 0 L hL).1

example : rawBudget 0 0 = 25709 := by norm_num [rawBudget]

example : rawBudget 0 1 = 47613 := by norm_num [rawBudget]

example : rawBudget 1 0 = 53961 := by norm_num [rawBudget]

example : rawBudget 0 127 = 6984039 := by norm_num [rawBudget]

example (L : ℝ) : ordinary (raw 0 0 L).run.cost ≤ 25709 := by
  simpa [rawBudget] using raw_total_cost_le 0 0 L

example (L : ℝ) (op : Op) : (raw 1 0 L).run.cost op ≤ 53961 := by
  simpa [rawBudget] using raw_cost_le 1 0 L op

example (k : ℕ) (L : ℝ) : (raw k 0 L).exponentialCalls ≤ 4 := by
  simpa using raw_exponentialCalls_le k 0 L

example (k : ℕ) (L : ℝ) : (raw k 127 L).exponentialCalls ≤ 385 := by
  simpa using raw_exponentialCalls_le k 127 L

example (k : ℕ) (L : ℝ) : (raw k 0 L).quotientCalls = 2 ∧
    (raw k 0 L).remainderCalls = 1 ∧ (raw k 0 L).integerDoublings = 0 ∧
    (raw k 0 L).integerAdditions = 4 := by
  simp [raw_quotientCalls, raw_remainderCalls, raw_integerDoublings, raw_integerAdditions]

example (k : ℕ) (L : ℝ) : (raw k 127 L).quotientCalls = 16512 ∧
    (raw k 127 L).remainderCalls = 16384 ∧ (raw k 127 L).integerDoublings = 127 ∧
    (raw k 127 L).integerAdditions = 512 := by
  simp [raw_quotientCalls, raw_remainderCalls, raw_integerDoublings, raw_integerAdditions]

example (k : ℕ) (L : ℝ) : (raw k 2 L).quotientCalls + (raw k 2 L).remainderCalls +
    (raw k 2 L).integerDoublings + (raw k 2 L).integerAdditions = 35 := by
  simpa using raw_selected_integer_total k 2 L

#print axioms ordinary_eq_total
#print axioms collectStages_total_cost
#print axioms raw_total_cost_le
#print axioms raw_exponentialCalls
#print axioms raw_exponentialCalls_le
#print axioms raw_selected_integer_total
#print axioms raw_certified

end QuantumBlockEncoding.StoredHermiteRawCost.Tests

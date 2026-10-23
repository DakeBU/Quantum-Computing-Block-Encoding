import QuantumBlockEncoding.StoredThinLQ

/-! Trusted fixed support for the LA206 question-contract correction.
This is not an admitted native Lean view or a proof of every NL sentence. -/
namespace QuantumBlockEncoding.QcbWideLQCostContract

open StoredGivens

theorem actual_stage_cost {m n : ℕ} (h : m ≤ n) (A : StoredMatrix m n) (op : Op) :
    (StoredThinLQ.wide h A).cost op =
      StoredThinLQ.extractionBudget n m op +
      (StoredRectangularGivens.compile (StoredThinLQ.transpose A).value).cost op +
      StoredThinLQ.extractionBudget m m op + StoredThinLQ.extractionBudget m n op := by
  simp only [StoredThinLQ.wide, bind, pure, Run.bind, Run.pure,
    StoredThinLQ.transpose_cost, StoredThinLQ.extractR_cost, StoredThinLQ.extractQ_cost,
    Pi.add_apply, add_zero]
  omega

theorem one_by_one_emit (A : StoredMatrix 1 1) :
    (StoredThinLQ.wide (by omega) A).cost .emit = 0 := by
  rw [actual_stage_cost]
  simp [StoredThinLQ.extractionBudget, tick, StoredRectangularGivens.compile,
    StoredRectangularGivens.sweep, StoredGivens.columnSweep,
    StoredRectangularGivens.append, StoredRectangularGivens.identity_cost,
    StoredRectangularGivens.identityBudget, StoredRectangularGivens.replay,
    bind, pure, Run.bind, Run.pure, charge]

theorem one_by_one_budget_emit : StoredThinLQ.wideBudget 1 1 .emit = 1 := by
  simp [StoredThinLQ.wideBudget, StoredThinLQ.extractionBudget,
    StoredRectangularGivens.polynomialBudget, tick]

#print axioms actual_stage_cost
#print axioms one_by_one_emit
#print axioms one_by_one_budget_emit

end QuantumBlockEncoding.QcbWideLQCostContract

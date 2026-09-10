import QuantumBlockEncoding.StoredDyadicSpans

namespace QuantumBlockEncoding.StoredDyadicSpansTests
open StoredGivens StoredDyadicSpans
open scoped BigOperators

example : (spans 0).run.value[0] = 1 ∧ (spans 0).integerDoublings = 0 := by
  constructor
  · simpa using spans_value 0 (0 : Fin 1)
  · exact spans_integerDoublings 0

example : (∑ op : Op, (spans 0).run.cost op) = 4 := by
  simpa using spans_total_cost 0

example : (spans 1).run.value[0] = 1 ∧ (spans 1).run.value[1] = 2 ∧
    (spans 1).integerDoublings = 1 := by
  refine ⟨?_, ?_, spans_integerDoublings 1⟩
  · simpa using spans_value 1 (0 : Fin 2)
  · simpa using spans_value 1 (1 : Fin 2)

example : (∑ op : Op, (spans 1).run.cost op) = 16 := by
  simpa using spans_total_cost 1

example : (atStage (spans 1).run.value 0).value = 2 ∧
    (atStage (spans 1).run.value 1).value = 1 := by
  simp [atStage_value]

example : (spans 127).run.value[127] = 2^127 := by
  exact spans_value 127 (Fin.last 127)

example : (spans 127).integerDoublings = 127 := spans_integerDoublings 127

example : (∑ op : Op, (spans 127).run.cost op) = 49534 := by
  simpa using spans_total_cost 127

example : (atStage (spans 127).run.value 0).value = 2^127 ∧
    (atStage (spans 127).run.value (Fin.last 127)).value = 1 := by
  simp [atStage_value]

example (r : Fin 128) : (spans 127).run.value[r.val] ≤ 2^127 ∧
    (spans 127).run.value[r.val] < 2^128 := spans_word_bound 127 r

example (n : ℕ) (t : Fin (n + 1)) :
    (spans n).run.cost .field = 0 ∧
    (atStage (spans n).run.value t).cost .read = 1 := by
  simp [spans_field_cost, atStage_cost, tick]

#print axioms spans_value
#print axioms spans_total_cost
#print axioms spans_integerDoublings
#print axioms spans_word_bound
#print axioms spans_certified

-- Executable diagnostics supplement, rather than replace, the proofs above.
#eval (spans 0).run.value
#eval (spans 1).run.value
#eval (spans 127).run.value[127]

end QuantumBlockEncoding.StoredDyadicSpansTests

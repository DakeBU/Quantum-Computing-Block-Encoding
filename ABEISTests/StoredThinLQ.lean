import QuantumBlockEncoding.StoredThinLQ

namespace StoredThinLQTests

open QuantumBlockEncoding StoredGivens

def zeros (m n : ℕ) : StoredMatrix m n := Vector.replicate m (Vector.replicate n 0)
def repeated : StoredMatrix 2 3 := Vector.ofFn (fun _ => Vector.ofFn (fun j => (j.val : ℝ) + 1))

example : denote repeated 0 = denote repeated 1 := rfl
example : denote repeated 0 0 = 1 := by norm_num [repeated, denote]

example (A : StoredMatrix 2 3) :
    denote (StoredThinLQ.compile A).value.R = (ConstructiveThinLQ.factor (denote A)).R :=
  StoredThinLQ.compile_R A
example (A : StoredMatrix 3 2) :
    denote (StoredThinLQ.compile A).value.Q = (ConstructiveThinLQ.factor (denote A)).Q :=
  StoredThinLQ.compile_Q A

-- Empty dimensions still use the same actual stored producer and exact factors.
example : denote (zeros 0 3) = denote (StoredThinLQ.compile (zeros 0 3)).value.R *
    denote (StoredThinLQ.compile (zeros 0 3)).value.Q := (StoredThinLQ.compile_correct _).1
example : denote (zeros 3 0) = denote (StoredThinLQ.compile (zeros 3 0)).value.R *
    denote (StoredThinLQ.compile (zeros 3 0)).value.Q := (StoredThinLQ.compile_correct _).1
example : denote (zeros 0 0) = denote (StoredThinLQ.compile (zeros 0 0)).value.R *
    denote (StoredThinLQ.compile (zeros 0 0)).value.Q := (StoredThinLQ.compile_correct _).1

example : denote repeated = denote (StoredThinLQ.compile repeated).value.R *
    denote (StoredThinLQ.compile repeated).value.Q := (StoredThinLQ.compile_correct _).1
example : denote (zeros 2 4) = denote (StoredThinLQ.compile (zeros 2 4)).value.R *
    denote (StoredThinLQ.compile (zeros 2 4)).value.Q := (StoredThinLQ.compile_correct _).1

-- Symbolic category bounds quantify over actual stored input, not matrix shape
-- callbacks or supplied target factorization witnesses.
example {m n : ℕ} (A : StoredMatrix m n) (op : Op) :
    (StoredThinLQ.compile A).cost op ≤ StoredThinLQ.compileBudget m n op :=
  StoredThinLQ.compile_cost_le A op
example (A : StoredMatrix 0 0) :
    StoredRectangularGivens.total (StoredThinLQ.compile A).cost ≤ 2 := by
  simpa using StoredThinLQ.compile_total_cost_le A
example (A : StoredMatrix 2 3) :
    StoredRectangularGivens.total (StoredThinLQ.compile A).cost ≤ 1163 := by
  simpa using StoredThinLQ.compile_total_cost_le A

#print axioms QuantumBlockEncoding.StoredThinLQ.compile_R
#print axioms QuantumBlockEncoding.StoredThinLQ.compile_Q
#print axioms QuantumBlockEncoding.StoredThinLQ.compile_correct
#print axioms QuantumBlockEncoding.StoredThinLQ.compile_cost_le
#print axioms QuantumBlockEncoding.StoredThinLQ.compile_total_cost_le

end StoredThinLQTests

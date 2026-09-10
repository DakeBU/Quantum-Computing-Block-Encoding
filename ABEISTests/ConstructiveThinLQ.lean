import QuantumBlockEncoding.ConstructiveThinLQ

namespace ConstructiveThinLQTests

open QuantumBlockEncoding
open AdjacentGivens RectangularGivens ConstructiveThinLQ

-- The empty column recursion returns no rotations, for arbitrary row dimension.
example {N : ℕ} (A : _root_.Matrix (Fin N) (Fin 0) ℝ) : decompose A = [] := rfl

-- An empty row dimension safely skips every impossible pivot.
example (A : _root_.Matrix (Fin 0) (Fin 3) ℝ) : decompose A = [] := by
  simp [decompose, sweepSteps]

private theorem column_zero {N M : ℕ} (col : Fin M) (lo count : ℕ)
    (bound : lo + count < N) :
    columnSweep (0 : _root_.Matrix (Fin N) (Fin M) ℝ) col lo count bound = 0 := by
  induction count with
  | zero => rfl
  | succ count ih =>
      rw [columnSweep, eliminateEntry_zero_pair _ _ _ _ rfl rfl]
      exact ih (by omega)

private theorem sweep_zero {N M : ℕ} (k remaining : ℕ) (bound : k + remaining ≤ M) :
    sweep (0 : _root_.Matrix (Fin N) (Fin M) ℝ) k remaining bound = 0 := by
  induction remaining generalizing k with
  | zero => rfl
  | succ remaining ih =>
      by_cases h : k < N
      · rw [sweep, dif_pos h, column_zero]
        exact ih _ _
      · rw [sweep, dif_neg h]
        exact ih _ _

-- All-zero inputs return an actually zero coefficient factor, not just an
-- arbitrary existential orthonormal factorization.
example {m n : ℕ} (h : m ≤ n) :
    (factorOfLE h (0 : _root_.Matrix (Fin m) (Fin n) ℝ)).R = 0 := by
  ext i j
  change reduced (0 : _root_.Matrix (Fin n) (Fin m) ℝ) (Fin.castLE h j) i = 0
  rw [reduced, sweep_zero]
  rfl

-- Repeated nonzero rows exercise deficient rank with exactly two Q rows.
def repeated : _root_.Matrix (Fin 2) (Fin 3) ℝ := fun _ j => (j.val : ℝ) + 1

example : repeated 0 = repeated 1 := rfl
example : repeated 0 0 = 1 := by norm_num [repeated]
example : repeated = (factor repeated).R * (factor repeated).Q :=
  (factor repeated).factorization
example : (factor repeated).Q * (factor repeated).Q.transpose = 1 :=
  (factor repeated).orthogonal

-- Arbitrary tall and both empty shapes retain the exact all-shape contract.
example (A : _root_.Matrix (Fin 4) (Fin 2) ℝ) :
    A = (factor A).R * (factor A).Q ∧ (factor A).Q * (factor A).Q.transpose =
      (1 : _root_.Matrix (Fin (min 4 2)) (Fin (min 4 2)) ℝ) :=
  factor_correct A
example (A : _root_.Matrix (Fin 0) (Fin 3) ℝ) :
    A = (factor A).R * (factor A).Q ∧ (factor A).Q * (factor A).Q.transpose =
      (1 : _root_.Matrix (Fin (min 0 3)) (Fin (min 0 3)) ℝ) :=
  factor_correct A
example (A : _root_.Matrix (Fin 3) (Fin 0) ℝ) :
    A = (factor A).R * (factor A).Q ∧ (factor A).Q * (factor A).Q.transpose =
      (1 : _root_.Matrix (Fin (min 3 0)) (Fin (min 3 0)) ℝ) :=
  factor_correct A
example (A : _root_.Matrix (Fin 0) (Fin 0) ℝ) :
    A = (factor A).R * (factor A).Q ∧ (factor A).Q * (factor A).Q.transpose =
      (1 : _root_.Matrix (Fin (min 0 0)) (Fin (min 0 0)) ℝ) :=
  factor_correct A

-- A genuinely rectangular, wide elimination does not access nonexistent rows.
example (A : _root_.Matrix (Fin 2) (Fin 5) ℝ) : reduced A 1 0 = 0 :=
  reduced_zero_below A 1 0 (by decide)
example (A : _root_.Matrix (Fin 5) (Fin 2) ℝ) : (decompose A).length ≤ 10 := by
  simpa using decompose_length_le A
example (A : _root_.Matrix (Fin 5) (Fin 2) ℝ) :
    (transform A).transpose * reduced A = A := exact_recovery A

#print axioms QuantumBlockEncoding.RectangularGivens.reduced_zero_below
#print axioms QuantumBlockEncoding.RectangularGivens.exact_recovery
#print axioms QuantumBlockEncoding.RectangularGivens.transform_det
#print axioms QuantumBlockEncoding.ConstructiveThinLQ.factor
#print axioms QuantumBlockEncoding.ConstructiveThinLQ.factor_correct

end ConstructiveThinLQTests

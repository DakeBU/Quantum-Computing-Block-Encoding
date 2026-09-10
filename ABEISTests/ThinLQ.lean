import QuantumBlockEncoding.ThinLQ

open QuantumBlockEncoding.ThinLQ

-- Rank zero, with a nonempty factor that still has orthonormal rows.
example : ∃ (R : Matrix (Fin 3) (Fin 3) ℝ) (Q : Matrix (Fin 3) (Fin 5) ℝ),
    (0 : Matrix (Fin 3) (Fin 5) ℝ) = R * Q ∧ Q * Q.transpose = 1 := by
  exact exists_factor_of_le (by decide) 0

-- Repeated nonzero rows, so full row rank is explicitly unnecessary.
example : ∃ (R : Matrix (Fin 2) (Fin 2) ℝ) (Q : Matrix (Fin 2) (Fin 4) ℝ),
    (fun _ _ => (1 : ℝ)) = R * Q ∧ Q * Q.transpose = 1 := by
  exact exists_factor_of_le (by decide) (fun _ _ => 1)

-- Tall arbitrary matrix, on the identity-factor branch.
example (A : Matrix (Fin 7) (Fin 3) ℝ) :
    ∃ (R : Matrix (Fin 7) (Fin 3) ℝ) (Q : Matrix (Fin 3) (Fin 3) ℝ),
      A = R * Q ∧ Q * Q.transpose = 1 := by
  exact exists_thin_lq A

-- Both empty-dimension orientations.
example (A : Matrix (Fin 0) (Fin 5) ℝ) :
    ∃ (R : Matrix (Fin 0) (Fin 0) ℝ) (Q : Matrix (Fin 0) (Fin 5) ℝ),
      A = R * Q ∧ Q * Q.transpose = 1 := by
  exact exists_thin_lq A

example (A : Matrix (Fin 5) (Fin 0) ℝ) :
    ∃ (R : Matrix (Fin 5) (Fin 0) ℝ) (Q : Matrix (Fin 0) (Fin 0) ℝ),
      A = R * Q ∧ Q * Q.transpose = 1 := by
  exact exists_thin_lq A

example (A : Matrix (Fin 0) (Fin 0) ℝ) :
    ∃ (R : Matrix (Fin 0) (Fin 0) ℝ) (Q : Matrix (Fin 0) (Fin 0) ℝ),
      A = R * Q ∧ Q * Q.transpose = 1 := by
  exact exists_thin_lq A

#check exists_thin_lq
#print axioms sum_prefix_of_zero
#print axioms exists_factor_of_le
#print axioms exists_thin_lq

import QuantumBlockEncoding.QuantumQueryWord

open QuantumBlockEncoding QuantumQueryWord
open scoped Matrix.Norms.L2Operator MatrixOrder

variable {ι : Type*} [Fintype ι] [DecidableEq ι]

-- Known gates may be interleaved without being charged as oracle calls.
example (A B : Matrix.unitaryGroup ι ℂ) :
    queryCount [.known A, .forward, .known B, .inverse] = 2 := rfl

example (A B : Matrix.unitaryGroup ι ℂ) (U : Matrix ι ι ℂ) :
    eval [.known A, .forward, .known B, .inverse] U =
      star U * (B : Matrix ι ι ℂ) * U * (A : Matrix ι ι ℂ) := by
  simp [eval, Instruction.eval, mul_assoc]

-- Consumes only the sealed mathematical inputs, never an assumed eval certificate.
example (A B : Matrix.unitaryGroup ι ℂ) (U V P : Matrix ι ι ℂ)
    (ψ : EuclideanSpace ℂ ι) (hψ : ‖ψ‖ = 1)
    (hU : U ∈ Matrix.unitaryGroup ι ℂ) (hV : V ∈ Matrix.unitaryGroup ι ℂ)
    (hP : 0 ≤ P) (hPI : P ≤ 1) {η : ℝ} (hUV : ‖U - V‖ ≤ η) :
    |BornStability.probability (eval [.known A, .forward, .known B, .inverse] U) P ψ -
      BornStability.probability (eval [.known A, .forward, .known B, .inverse] V) P ψ|
      ≤ 4 * η := by
  have h := QuantumQueryWord.probability_difference_le
    [.known A, .forward, .known B, .inverse] U V P ψ hψ hU hV hP hPI hUV
  norm_num [queryCount, Instruction.queryCost] at h
  exact h

#print axioms QuantumQueryWord.eval_unitary
#print axioms QuantumQueryWord.eval_distance_le
#print axioms QuantumQueryWord.probability_difference_le
#print axioms QuantumQueryWord.bounded_probability_difference_le

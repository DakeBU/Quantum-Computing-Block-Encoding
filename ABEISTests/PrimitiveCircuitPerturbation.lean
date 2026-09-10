import QuantumBlockEncoding.PrimitiveCircuitPerturbation

namespace QuantumBlockEncoding.PrimitiveCircuitPerturbationTests
open PrimitiveCircuitPerturbation
open scoped Matrix.Norms.L2Operator

example : ‖evalPrimitiveCircuit ([] : PrimitiveCircuit 0) -
    evalPrimitiveCircuit ([] : PrimitiveCircuit 0)‖ ≤ 0 := by
  simpa only [mul_zero, zero_div] using aligned_eval_distance_le (δ := 0) (le_refl 0)
    (Aligned.refl 0 ([] : PrimitiveCircuit 0))

def cx01 : PrimitiveGate 2 := .cx 0 1 (by decide)

example : ‖evalPrimitiveCircuit [cx01, cx01] - evalPrimitiveCircuit [cx01, cx01]‖ ≤ 0 := by
  simpa only [mul_zero, zero_div] using aligned_eval_distance_le (δ := 0) (le_refl 0)
    (Aligned.refl 0 [cx01, cx01])

theorem shifted_ry (target : Fin 2) (a e : ℝ) :
    GateAligned |e| (.ry target (.real a)) (.ry target (.real (a + e))) := by
  apply GateAligned.ry
  change |a - (a + e)| ≤ |e|
  rw [show a - (a + e) = -e by ring, abs_neg]

/-- A genuinely ordered RY-CX-RY test, with distinct target wires. -/
theorem noncommuting_sequence (a b e : ℝ) :
    Aligned |e|
      [.ry 0 (.real a), cx01, .ry 1 (.real b)]
      [.ry 0 (.real (a + e)), cx01, .ry 1 (.real (b + e))] :=
  .cons (shifted_ry 0 a e) (.cons (.unchanged cx01) (.cons (shifted_ry 1 b e) .nil))

example (a b e : ℝ) :
    ‖evalPrimitiveCircuit [.ry 0 (.real (a + e)), cx01, .ry 1 (.real (b + e))] -
      evalPrimitiveCircuit [.ry 0 (.real a), cx01, .ry 1 (.real b)]‖ ≤ 3 * |e| / 2 := by
  simpa using aligned_eval_distance_le (abs_nonneg e) (noncommuting_sequence a b e)

/-- Physical target mismatch is rejected even if the numerical error budget is huge. -/
example (δ : ℝ) (a b : ExactAngle) :
    ¬ GateAligned δ (.ry (0 : Fin 2) a) (.ry (1 : Fin 2) b) := by
  intro h
  have ht := h.touched_eq
  norm_num [PrimitiveGate.touched] at ht

/-- Changing chronological gate types/order is not an aligned approximation. -/
example (δ : ℝ) (a : ExactAngle) :
    ¬ Aligned δ [.ry (0 : Fin 2) a, cx01] [cx01, .ry (0 : Fin 2) a] := by
  intro h
  cases h with
  | cons head tail => cases head

/-- Repeated angle occurrences cannot be deduplicated away. -/
example (δ : ℝ) (a : ExactAngle) :
    ¬ Aligned δ [.ry (0 : Fin 2) a, .ry (0 : Fin 2) a] [.ry (0 : Fin 2) a] := by
  intro h
  have hl := h.length_eq
  simp at hl

example (ε : ℝ) : hermiteAngleBudget 0 0 ε = ε / 5184 := by
  norm_num [hermiteAngleBudget]

/-- The smallest actual Hermite circuit is a consumer of the conditional budget. -/
example (L : ℝ) {ε : ℝ} (hε : 0 ≤ ε)
    (approximate : PrimitiveCircuit (1 + HermiteFiniteChain.bondQubits 0))
    (h : Aligned (ε / 5184) (ConstructiveHermitePreparation.prepare 0 0 L) approximate) :
    ‖evalPrimitiveCircuit approximate -
      evalPrimitiveCircuit (ConstructiveHermitePreparation.prepare 0 0 L)‖ ≤ ε := by
  apply prepare_conditional_distance_le 0 0 L hε approximate
  rw [show hermiteAngleBudget 0 0 ε = ε / 5184 by norm_num [hermiteAngleBudget]]
  exact h

example (k n : ℕ) (L : ℝ) :
    ‖_root_.Matrix.toEuclideanCLM (𝕜 := ℂ)
      (n := PrimitiveBasis ((n + 1) + HermiteFiniteChain.bondQubits k))
      (evalPrimitiveCircuit (ConstructiveHermitePreparation.prepare k n L) -
        evalPrimitiveCircuit (ConstructiveHermitePreparation.prepare k n L))‖ ≤ 0 := by
  apply prepare_conditional_clm_distance_le k n L (by norm_num)
  exact Aligned.refl _ _

#print axioms aligned_eval_distance_le
#print axioms aligned_eval_clm_distance_le
#print axioms prepare_conditional_distance_le
#print axioms prepare_conditional_clm_distance_le

end QuantumBlockEncoding.PrimitiveCircuitPerturbationTests

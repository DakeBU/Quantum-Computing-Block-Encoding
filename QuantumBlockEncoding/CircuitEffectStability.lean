import QuantumBlockEncoding.BornStability
import QuantumBlockEncoding.PrimitiveCircuitPerturbation

namespace QuantumBlockEncoding.CircuitEffectStability

open scoped Matrix.Norms.L2Operator MatrixOrder
open PrimitiveCircuitPerturbation

/-- An alignment certificate is required; this does not synthesize rounding. -/
theorem aligned_probability_difference_le {n : ℕ} {δ : ℝ} (hδ : 0 ≤ δ)
    (exact approximate : PrimitiveCircuit n) (ha : Aligned δ exact approximate)
    (P : _root_.Matrix (PrimitiveBasis n) (PrimitiveBasis n) ℂ)
    (ψ : EuclideanSpace ℂ (PrimitiveBasis n)) (hψ : ‖ψ‖ = 1)
    (hP : 0 ≤ P) (hPI : P ≤ 1) :
    |BornStability.probability (evalPrimitiveCircuit approximate) P ψ -
      BornStability.probability (evalPrimitiveCircuit exact) P ψ| ≤
        (exact.length : ℝ) * δ := by
  have h := BornStability.probability_difference_le
    (evalPrimitiveCircuit approximate) (evalPrimitiveCircuit exact) P ψ hψ
    (evalPrimitiveCircuit_unitary approximate) (evalPrimitiveCircuit_unitary exact)
    hP hPI (aligned_eval_distance_le hδ ha)
  convert h using 1; ring

end QuantumBlockEncoding.CircuitEffectStability

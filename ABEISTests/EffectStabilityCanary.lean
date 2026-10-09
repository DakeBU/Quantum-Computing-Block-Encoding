import QuantumBlockEncoding.CircuitEffectStability
import ABEISTests.PrimitiveCircuitPerturbation

namespace QuantumBlockEncoding.EffectStabilityCanary
open scoped Matrix.Norms.L2Operator MatrixOrder
open PrimitiveCircuitPerturbationTests

/-- The two rotations are separated by an actual entangling instruction. -/
example (a b e : ℝ)
    (P : _root_.Matrix (PrimitiveBasis 2) (PrimitiveBasis 2) ℂ)
    (ψ : EuclideanSpace ℂ (PrimitiveBasis 2)) (hψ : ‖ψ‖ = 1)
    (hP : 0 ≤ P) (hPI : P ≤ 1) :
    |BornStability.probability
       (evalPrimitiveCircuit [.ry 0 (.real (a + e)), cx01, .ry 1 (.real (b + e))]) P ψ -
      BornStability.probability
       (evalPrimitiveCircuit [.ry 0 (.real a), cx01, .ry 1 (.real b)]) P ψ| ≤ 3 * |e| := by
  simpa using CircuitEffectStability.aligned_probability_difference_le (abs_nonneg e) _ _
    (noncommuting_sequence a b e) P ψ hψ hP hPI

#print axioms BornStability.effect_norm_le_one
#print axioms BornStability.unitary_norm_map
#print axioms BornStability.quadratic_difference_le
#print axioms BornStability.probability_difference_le
#print axioms BornStability.probability_mem_Icc
#print axioms CircuitEffectStability.aligned_probability_difference_le
end QuantumBlockEncoding.EffectStabilityCanary

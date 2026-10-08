import QuantumBlockEncoding.CircuitRewardBias
import ABEISTests.PrimitiveCircuitPerturbation
import QuantumBlockEncoding.RealAmplitudePreparation

namespace QuantumBlockEncoding.QuantumBanditBornCanary
open scoped Matrix.Norms.L2Operator MatrixOrder
open PrimitiveCircuitPerturbationTests

/-- Two perturbed rotations separated by a real entangling instruction.
No commutation, wire swap, or synthesis certificate is being inferred. -/
example (a b e : ℝ)
    (P : _root_.Matrix (PrimitiveBasis 2) (PrimitiveBasis 2) ℂ)
    (ψ : EuclideanSpace ℂ (PrimitiveBasis 2)) (hψ : ‖ψ‖ = 1)
    (hP : 0 ≤ P) (hPI : P ≤ 1) :
    |BornStability.probability
       (evalPrimitiveCircuit [.ry 0 (.real (a + e)), cx01, .ry 1 (.real (b + e))]) P ψ -
      BornStability.probability
       (evalPrimitiveCircuit [.ry 0 (.real a), cx01, .ry 1 (.real b)]) P ψ| ≤ 3 * |e| := by
  simpa using CircuitRewardBias.aligned_reward_bias_le (abs_nonneg e) _ _
    (noncommuting_sequence a b e) P ψ hψ hP hPI

/-- The existing known-table preparation is checked separately from an
unknown reward oracle; its exact-real angles do not supply unknown means. -/
example (f : PrimitiveBasis 2 → ℝ) :
    (RealAmplitudePreparation.prepareCircuit 2 f).ryCount = 3 := by
  simpa using RealAmplitudePreparation.prepareCircuit_ryCount (n := 2) f

example (f : PrimitiveBasis 2 → ℝ) :
    evalPrimitiveCircuit
      ((RealAmplitudePreparation.prepareCircuit 2 f).reverse.map PrimitiveGate.dagger) =
        star (evalPrimitiveCircuit (RealAmplitudePreparation.prepareCircuit 2 f)) :=
  evalPrimitiveCircuit_dagger _

#print axioms BornStability.probability_difference_le
#print axioms CircuitRewardBias.aligned_reward_bias_le

end QuantumBlockEncoding.QuantumBanditBornCanary


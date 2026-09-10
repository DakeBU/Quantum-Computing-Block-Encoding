import QuantumBlockEncoding.HermitePolynomialPreparation
import QuantumBlockEncoding.PrimitiveDepthBound

/-! Exact-real Hermite resources, including the actual wire-scheduled depth.
The allocated clean bond is explicit in the circuit type and output split;
generic primitive metadata does not infer a wire's ancilla role. -/

namespace QuantumBlockEncoding.HermitePolynomialPreparation
open HermiteFiniteChain

theorem exists_polynomial_resources (k n : Nat) (L : ℝ) (hL : 0 < L) :
    ∃ circuit : PrimitiveCircuit ((n + 1) + bondQubits k),
      circuit.gateCount ≤ 48 * (n + 1) * (2 * k + 6) ^ 3 ∧
      circuit.resource.depth ≤ 48 * (n + 1) * (2 * k + 6) ^ 3 ∧
      circuit.resource.oracleCalls = 0 ∧
      evalPrimitiveCircuit circuit ∈
        _root_.Matrix.unitaryGroup (PrimitiveBasis ((n + 1) + bondQubits k)) ℂ ∧
      ∀ (x : PrimitiveBasis (n + 1)) (b : PrimitiveBasis (bondQubits k)),
        evalPrimitiveCircuit circuit (Fin.append x b) (fun _ => 0) =
          if b = (fun _ => 0) then
            HermiteStatePreparation.normalizedAmplitude k (n + 1) L
              (primitiveBasisLEEquiv (n + 1) x) else 0 := by
  obtain ⟨circuit, hg, ho, hu, ha⟩ := exists_polynomial_preparation k n L hL
  exact ⟨circuit, hg, circuit.resource_depth_le_gateCount.trans hg, ho, hu, ha⟩

end QuantumBlockEncoding.HermitePolynomialPreparation

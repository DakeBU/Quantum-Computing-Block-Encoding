import QuantumBlockEncoding.HermiteFiniteChain
import QuantumBlockEncoding.TensorTrainPrimitivePreparation

/-!
# Polynomial-gate exact-real Hermite state preparation

This root starts from the literal Hermite source, not a supplied target-action
certificate. It returns an actual finite primitive circuit, full unitary action,
zero output in every non-clean bond sector, and a bound on all instructions.
The quantum resource tier permits exact real angles. Classical computation of
those angles, finite-bit input comparison and rounded QASM error are separate
obligations; this theorem is not a certificate for a floating-point exporter.
-/

namespace QuantumBlockEncoding.HermitePolynomialPreparation
open HermiteFiniteChain TensorTrainWord

/-- For `n+1` data qubits, the additional register has
`ceil(log2(2*k+6))` wires. It is returned completely to zero, without
measurement or postselection. Every primitive instruction is counted.
For fixed smoothing order the proved gate bound is linear in data width. -/
theorem exists_polynomial_preparation (k n : Nat) (L : ℝ) (hL : 0 < L) :
    ∃ circuit : PrimitiveCircuit ((n + 1) + bondQubits k),
      circuit.gateCount ≤ 48 * (n + 1) * (2 * k + 6) ^ 3 ∧
      circuit.resource.oracleCalls = 0 ∧
      evalPrimitiveCircuit circuit ∈
        _root_.Matrix.unitaryGroup (PrimitiveBasis ((n + 1) + bondQubits k)) ℂ ∧
      ∀ (x : PrimitiveBasis (n + 1)) (b : PrimitiveBasis (bondQubits k)),
        evalPrimitiveCircuit circuit (Fin.append x b) (fun _ => 0) =
          if b = (fun _ => 0) then
            HermiteStatePreparation.normalizedAmplitude k (n + 1) L
              (primitiveBasisLEEquiv (n + 1) x) else 0 := by
  obtain ⟨circuit, hg, ho, hu, ha⟩ :=
    TensorTrainPrimitivePreparation.exists_primitive_preparation
      (sourceChain k n L) ((sourceChain_maxBond k n L).trans (bond_fits k))
      (sourceChain_normalized k n L hL)
  refine ⟨circuit, hg.trans ?_, ho, hu, ?_⟩
  · simpa only [Nat.mul_assoc, Nat.mul_comm, Nat.mul_left_comm] using cubic_stage_budget k n
  · intro x b
    rw [ha, sourceChain_contract k n L hL, sampleEquiv_public]
    rfl

end QuantumBlockEncoding.HermitePolynomialPreparation

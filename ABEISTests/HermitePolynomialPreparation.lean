import QuantumBlockEncoding.HermitePolynomialPreparation

open QuantumBlockEncoding HermiteFiniteChain HermitePolynomialPreparation

-- The complete family, not a pre-supplied circuit action hypothesis.
example (k n : Nat) (L : ℝ) (hL : 0 < L) :
    ∃ circuit : PrimitiveCircuit ((n + 1) + bondQubits k),
      circuit.gateCount ≤ 48 * (n + 1) * (2 * k + 6) ^ 3 ∧
      circuit.resource.oracleCalls = 0 ∧
      evalPrimitiveCircuit circuit ∈
        _root_.Matrix.unitaryGroup (PrimitiveBasis ((n + 1) + bondQubits k)) ℂ ∧
      ∀ (x : PrimitiveBasis (n + 1)) (b : PrimitiveBasis (bondQubits k)),
        evalPrimitiveCircuit circuit (Fin.append x b) (fun _ => 0) =
          if b = (fun _ => 0) then
            HermiteStatePreparation.normalizedAmplitude k (n + 1) L
              (primitiveBasisLEEquiv (n + 1) x) else 0 :=
  exists_polynomial_preparation k n L hL

-- Smallest data width and lowest smoothing order are not excluded.
example (L : ℝ) (hL : 0 < L) :
    ∃ circuit : PrimitiveCircuit (1 + bondQubits 0),
      circuit.gateCount ≤ 10368 ∧ circuit.resource.oracleCalls = 0 := by
  obtain ⟨c, hg, ho, _⟩ := exists_polynomial_preparation 0 0 L hL
  exact ⟨c, by simpa using hg, ho⟩

-- This checks the all-ancilla-sector statement, not just its clean projection.
example (k n : Nat) (L : ℝ) (hL : 0 < L) :
    ∃ circuit : PrimitiveCircuit ((n + 1) + bondQubits k),
      ∀ (x : PrimitiveBasis (n + 1)) (b : PrimitiveBasis (bondQubits k)),
        b ≠ (fun _ => 0) → evalPrimitiveCircuit circuit (Fin.append x b) (fun _ => 0) = 0 := by
  obtain ⟨c, _, _, _, ha⟩ := exists_polynomial_preparation k n L hL
  refine ⟨c, ?_⟩
  intro x b hb
  rw [ha, if_neg hb]

#print axioms exists_polynomial_preparation
#print axioms QuantumBlockEncoding.TensorTrainPrimitivePreparation.exists_primitive_preparation

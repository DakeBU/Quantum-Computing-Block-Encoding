import QuantumBlockEncoding.HermitePolynomialResources

open QuantumBlockEncoding HermitePolynomialPreparation HermiteFiniteChain

example (k n : Nat) (L : ℝ) (hL : 0 < L) :
    ∃ circuit : PrimitiveCircuit ((n + 1) + bondQubits k),
      circuit.resource.depth ≤ 48 * (n + 1) * (2 * k + 6) ^ 3 ∧
      ∀ (x : PrimitiveBasis (n + 1)) (b : PrimitiveBasis (bondQubits k)),
        evalPrimitiveCircuit circuit (Fin.append x b) (fun _ => 0) =
          if b = (fun _ => 0) then
            HermiteStatePreparation.normalizedAmplitude k (n + 1) L
              (primitiveBasisLEEquiv (n + 1) x) else 0 := by
  obtain ⟨circuit, _, hd, _, _, ha⟩ := exists_polynomial_resources k n L hL
  exact ⟨circuit, hd, ha⟩

example (L : ℝ) (hL : 0 < L) :
    ∃ circuit : PrimitiveCircuit (1 + bondQubits 0),
      circuit.gateCount ≤ 10368 ∧ circuit.resource.depth ≤ 10368 := by
  obtain ⟨circuit, hg, hd, _, _, _⟩ := exists_polynomial_resources 0 0 L hL
  exact ⟨circuit, hg, hd⟩

#print axioms exists_polynomial_resources
#print axioms PrimitiveCircuit.depth_le_gateCount

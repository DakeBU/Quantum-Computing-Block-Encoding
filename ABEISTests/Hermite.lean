import QuantumBlockEncoding.HermiteStatePreparation

/-! Regression tests keep the root attached to its actual primitive circuit. -/
namespace ABEISTests.Hermite
open QuantumBlockEncoding QuantumBlockEncoding.HermiteStatePreparation

example (k n : ℕ) (L : ℝ) :
    ConcreteSemantics.applyVec (hermiteUnitary k n L) (ConcreteSemantics.zeroKet n) =
      normalizedAmplitude k n L := hermite_stateAction k n L

example (k n : ℕ) (L : ℝ) :
    hermiteUnitary k n L =
      Matrix.reindexAlgEquiv ℂ ℂ (primitiveBasisLEEquiv n)
        (evalPrimitiveCircuit (hermiteCircuit k n L)) := hermiteUnitary_eq_circuit k n L

example (k : ℕ) (L : ℝ) : (hermiteCircuit k 3 L).ryCount = 7 := by
  rw [hermite_ryCount]
  norm_num

example (k : ℕ) (L : ℝ) : (hermiteCircuit k 3 L).cxCount = 8 := by
  rw [hermite_cxCount]
  norm_num

#check hermiteStatePreparation_complete
#check hermiteCertificate
#print axioms hermiteStatePreparation_complete
end ABEISTests.Hermite

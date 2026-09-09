import QuantumBlockEncoding.HermiteStatePreparation

#print axioms QuantumBlockEncoding.RealAmplitudePreparation.prepareCircuit_firstColumn
#print axioms QuantumBlockEncoding.HermiteStatePreparation.hermiteStatePreparation_complete

namespace QuantumBlockEncoding.Tests.RealAmplitudePreparation

open QuantumBlockEncoding.RealAmplitudePreparation

/-- Arbitrary-width sparse inputs exercise every possible zero-subtree position. -/
example (n : ℕ) (wanted row : PrimitiveBasis n) :
    evalPrimitiveCircuit (prepareCircuit n (fun b => if b = wanted then 1 else 0))
      row (fun _ => 0) = if row = wanted then 1 else 0 := by
  have hn : ∀ b : PrimitiveBasis n, (0 : ℝ) ≤ if b = wanted then 1 else 0 := by
    intro b; split_ifs <;> norm_num
  have hp : 0 < normSq (fun b : PrimitiveBasis n => if b = wanted then (1 : ℝ) else 0) := by
    simp [normSq]
  have result := prepareCircuit_firstColumn _ hn hp row
  by_cases hrow : row = wanted <;> simpa [normSq, hrow] using result

/-- The signed local polar rule must preserve a negative output amplitude. -/
example : standardRyMatrix (splitAngle (-3) (-4)).eval 1 0 * 5 = (-4 : ℂ) := by
  have h := splitAngle_firstColumn (-3) (-4) 1
  norm_num [pairNorm] at h ⊢
  exact h

/-- An empty subtree emits the explicit zero angle. -/
example : splitAngle 0 0 = .rational 0 := by simp [splitAngle, pairNorm]

/-- Wire zero remains the least-significant bit in the flattening bridge. -/
example : (primitiveBasisLEEquiv 2 (fun w => if w = 0 then 1 else 0)).val = 1 := by
  decide

/-- The degenerate zero-wire grid is a genuine normalized one-dimensional state. -/
example (k : ℕ) (L : ℝ) :
    HermiteStatePreparation.hermiteUnitary k 0 L (zeroBasisIndex 0) (zeroBasisIndex 0) =
      HermiteStatePreparation.normalizedAmplitude k 0 L (zeroBasisIndex 0) :=
  HermiteStatePreparation.hermite_firstColumn k 0 L _

end QuantumBlockEncoding.Tests.RealAmplitudePreparation

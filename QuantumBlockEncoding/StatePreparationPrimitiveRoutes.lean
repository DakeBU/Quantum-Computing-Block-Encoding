import QuantumBlockEncoding.StatePreparationBenchmarksCoreFixed
import QuantumBlockEncoding.PrimitiveBasisLE
import QuantumBlockEncoding.UniformlyControlledRy
import Mathlib.Tactic

/-!
# Proof-bearing primitive routes for state preparation

`VerifiedStatePreparation` certifies a target matrix and its first column.  For
resource comparisons we need one stronger layer: the scored circuit itself must
have exact matrix semantics and must prepare that target.  This module therefore
scores typed `PrimitiveCircuit`s only after their evaluated matrix has an exact
state-action proof.
-/

namespace QuantumBlockEncoding.StatePreparationBenchmarks

open ConcreteSemantics
open Robin.ComplexLCU

noncomputable def evalPrimitiveCircuitLE {qubits : Nat}
    (circuit : PrimitiveCircuit qubits) :
    FiniteMatrix (gridSize qubits) (gridSize qubits) ℂ :=
  _root_.Matrix.reindexAlgEquiv ℂ ℂ (primitiveBasisLEEquiv qubits)
    (evalPrimitiveCircuit circuit)

theorem evalPrimitiveCircuitLE_unitary {qubits : Nat}
    (circuit : PrimitiveCircuit qubits) :
    evalPrimitiveCircuitLE circuit ∈
      _root_.Matrix.unitaryGroup (Fin (gridSize qubits)) ℂ := by
  exact reindex_unitary (primitiveBasisLEEquiv qubits)
    (evalPrimitiveCircuit circuit) (evalPrimitiveCircuit_unitary circuit)

structure ExactPrimitiveStatePreparationRoute (qubits : Nat) where
  target : StatePreparationTarget ℂ qubits
  circuit : PrimitiveCircuit qubits
  normalizationProof : target.normalization
  preparationProof :
    applyVec (evalPrimitiveCircuitLE circuit) (zeroKet qubits) =
      target.amplitudes

namespace ExactPrimitiveStatePreparationRoute

def cost (route : ExactPrimitiveStatePreparationRoute qubits) :
    BlockEncodingCost where
  auxiliaryQubits := 0
  gateCount := route.circuit.resource.gates
  depth := route.circuit.resource.depth
  oracleCalls := route.circuit.resource.oracleCalls

theorem unitary (route : ExactPrimitiveStatePreparationRoute qubits) :
    evalPrimitiveCircuitLE route.circuit ∈
      _root_.Matrix.unitaryGroup (Fin (gridSize qubits)) ℂ :=
  evalPrimitiveCircuitLE_unitary route.circuit

end ExactPrimitiveStatePreparationRoute

/-! ## Exact Pythagorean rotations

The fixed benchmarks are chosen so the required RY cosines and sines are
rational Pythagorean pairs.  This lets Lean reduce the typed angle semantics to
small exact real-orthogonal matrices before any finite circuit proof.
-/

private theorem amplitudeRotation_eq_pythagorean
    (cosine sine : Real)
    (lower : -1 ≤ cosine) (upper : cosine ≤ 1)
    (sine_nonneg : 0 ≤ sine)
    (normalization : cosine * cosine + sine * sine = 1) :
    amplitudeRotation cosine = realOrthogonalRotation cosine sine := by
  unfold amplitudeRotation realRotation
  have cosine_eval : Real.cos (Real.arccos cosine) = cosine :=
    Real.cos_arccos lower upper
  have sine_nonneg' : 0 ≤ Real.sin (Real.arccos cosine) := by
    exact Real.sin_nonneg_of_nonneg_of_le_pi
      (Real.arccos_nonneg cosine) (Real.arccos_le_pi cosine)
  have circle := Real.sin_sq_add_cos_sq (Real.arccos cosine)
  have sine_eval : Real.sin (Real.arccos cosine) = sine := by
    rw [cosine_eval] at circle
    nlinarith
  rw [cosine_eval, sine_eval]

private def cosine35 : Rat := 3 / 5
private def sine35 : Rat := 4 / 5
private def cosine513 : Rat := 5 / 13
private def sine513 : Rat := 12 / 13

noncomputable def ryAngle35 : ExactAngle :=
  .twiceArccosRational cosine35 (by
    norm_num [cosine35, abs_of_nonneg])

noncomputable def ryAngle513 : ExactAngle :=
  .twiceArccosRational cosine513 (by
    norm_num [cosine513, abs_of_nonneg])

def ryAngleZero : ExactAngle := .rational 0

theorem standardRyMatrix_ryAngle35 :
    standardRyMatrix ryAngle35.eval =
      realOrthogonalRotation (cosine35 : Real) (sine35 : Real) := by
  calc
    standardRyMatrix ryAngle35.eval =
        amplitudeRotation (cosine35 : Real) := by
      simpa [ryAngle35, ExactAngle.eval] using
        standardRyMatrix_two_arccos_eq_amplitudeRotation
          (cosine35 : Real) (by norm_num [cosine35]) (by norm_num [cosine35])
    _ = realOrthogonalRotation (cosine35 : Real) (sine35 : Real) := by
      apply amplitudeRotation_eq_pythagorean
      · norm_num [cosine35]
      · norm_num [cosine35]
      · norm_num [sine35]
      · norm_num [cosine35, sine35]

theorem standardRyMatrix_ryAngle513 :
    standardRyMatrix ryAngle513.eval =
      realOrthogonalRotation (cosine513 : Real) (sine513 : Real) := by
  calc
    standardRyMatrix ryAngle513.eval =
        amplitudeRotation (cosine513 : Real) := by
      simpa [ryAngle513, ExactAngle.eval] using
        standardRyMatrix_two_arccos_eq_amplitudeRotation
          (cosine513 : Real) (by norm_num [cosine513]) (by norm_num [cosine513])
    _ = realOrthogonalRotation (cosine513 : Real) (sine513 : Real) := by
      apply amplitudeRotation_eq_pythagorean
      · norm_num [cosine513]
      · norm_num [cosine513]
      · norm_num [sine513]
      · norm_num [cosine513, sine513]

@[simp] theorem standardRyMatrix_ryAngleZero :
    standardRyMatrix ryAngleZero.eval = 1 := by
  simp [ryAngleZero, ExactAngle.eval]

end QuantumBlockEncoding.StatePreparationBenchmarks

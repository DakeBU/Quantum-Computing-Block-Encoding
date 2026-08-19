import QuantumBlockEncoding.StatePreparationPrimitiveRoutes
import Mathlib.Tactic

/-!
# Proof-bearing Bell state-preparation route

The public Bell benchmark uses the same primitive semantics as the paper-derived
state-preparation routes.  A standard `RY(pi/2)` creates the equal positive
superposition on the little-endian q0 wire; `CX(q0,q1)` moves the `|01>` branch
to `|11>`.  The resource tuple is computed from this exact typed circuit.
-/

namespace QuantumBlockEncoding.StatePreparationBenchmarks

open ConcreteSemantics
open Robin.ComplexLCU
attribute [local simp] Pi.single_apply

noncomputable def bellRyAngle : ExactAngle :=
  .piRational (1 / 2)

theorem bellRyAngle_eval : bellRyAngle.eval = Real.pi / 2 := by
  change Real.pi * (((1 / 2 : Rat) : Real)) = Real.pi / 2
  norm_num

theorem standardRyMatrix_bellRyAngle :
    standardRyMatrix bellRyAngle.eval = Robin.warmRobinUniformBitPrepare := by
  rw [bellRyAngle_eval]
  exact standardRyMatrix_pi_div_two_eq_warmRobinUniformBitPrepare

def bellControl : Fin 2 := 0

def bellTargetWire : Fin 2 := 1

theorem bellControl_ne_target : bellControl ≠ bellTargetWire := by
  decide

noncomputable def bellRyCircuit : PrimitiveCircuit 2 :=
  [PrimitiveGate.ry (0 : Fin 2) bellRyAngle]

noncomputable def bellCxCircuit : PrimitiveCircuit 2 :=
  [PrimitiveGate.cx bellControl bellTargetWire bellControl_ne_target]

noncomputable def bellPrimitiveCircuit : PrimitiveCircuit 2 :=
  bellRyCircuit ++ bellCxCircuit

noncomputable def bellAfterRy : StateVector (gridSize 2) ℂ :=
  bellAmplitude • basisKet (gridSize 2) (0 : Fin 4) +
    bellAmplitude • basisKet (gridSize 2) (1 : Fin 4)

@[simp] theorem evalPrimitiveCircuitLE_singleton_cx_apply
    {qubits : Nat} (control target : Fin qubits) (distinct : control ≠ target)
    (row column : Fin (gridSize qubits)) :
    evalPrimitiveCircuitLE ([PrimitiveGate.cx control target distinct]) row column =
      if primitiveLEBits qubits row =
          cxBasisEquiv control target distinct (primitiveLEBits qubits column)
      then 1 else 0 := by
  simp [evalPrimitiveCircuitLE, evalPrimitiveCircuit, evalPrimitiveGate,
    _root_.Matrix.reindexAlgEquiv_apply, _root_.Matrix.reindex_apply,
    _root_.Matrix.submatrix_apply, equivPermutationMatrix, primitiveLEBits]

theorem bellRy_col_zero :
    (evalPrimitiveCircuitLE bellRyCircuit).col (0 : Fin 4) = bellAfterRy := by
  funext row
  fin_cases row <;>
    simp [bellRyCircuit, bellAfterRy, basisKet,
      evalPrimitiveCircuitLE_singleton_ry_apply, primitiveLEBits,
      standardRyMatrix_bellRyAngle, Robin.warmRobinUniformBitPrepare,
      realOrthogonalRotation, bellAmplitude,
      TextbookStatePreparation.invSqrtTwo] <;>
    norm_num

theorem bellRy_prepares :
    applyVec (evalPrimitiveCircuitLE bellRyCircuit) (zeroKet 2) = bellAfterRy := by
  rw [applyVec_zeroKet]
  exact bellRy_col_zero

theorem bellCx_col_zero :
    (evalPrimitiveCircuitLE bellCxCircuit).col (0 : Fin 4) =
      basisKet (gridSize 2) (0 : Fin 4) := by
  funext row
  fin_cases row <;>
    simp [bellCxCircuit, bellControl, bellTargetWire, basisKet,
      primitiveLEBits, cxBasisEquiv, cxBasisAction, xBasisAction,
      primitiveBits2LE]

theorem bellCx_col_one :
    (evalPrimitiveCircuitLE bellCxCircuit).col (1 : Fin 4) =
      basisKet (gridSize 2) (3 : Fin 4) := by
  funext row
  fin_cases row <;>
    simp [bellCxCircuit, bellControl, bellTargetWire, basisKet,
      primitiveLEBits, cxBasisEquiv, cxBasisAction, xBasisAction,
      primitiveBits2LE]

theorem bellCx_on_afterRy :
    applyVec (evalPrimitiveCircuitLE bellCxCircuit) bellAfterRy = bellState := by
  unfold applyVec bellAfterRy basisKet
  rw [_root_.Matrix.mulVec_add, _root_.Matrix.mulVec_smul,
    _root_.Matrix.mulVec_smul, _root_.Matrix.mulVec_single_one,
    _root_.Matrix.mulVec_single_one]
  change
    bellAmplitude • (evalPrimitiveCircuitLE bellCxCircuit).col (0 : Fin 4) +
      bellAmplitude • (evalPrimitiveCircuitLE bellCxCircuit).col (1 : Fin 4) =
      bellState
  rw [bellCx_col_zero, bellCx_col_one]
  funext row
  fin_cases row <;> simp [basisKet, bellState]

theorem bellPrimitive_prepares_target :
    applyVec (evalPrimitiveCircuitLE bellPrimitiveCircuit) (zeroKet 2) =
      bellTarget.amplitudes := by
  unfold bellPrimitiveCircuit
  rw [evalPrimitiveCircuitLE_append]
  unfold applyVec
  rw [← _root_.Matrix.mulVec_mulVec]
  change
    applyVec (evalPrimitiveCircuitLE bellCxCircuit)
        (applyVec (evalPrimitiveCircuitLE bellRyCircuit) (zeroKet 2)) = bellState
  rw [bellRy_prepares]
  exact bellCx_on_afterRy

noncomputable def bellPrimitiveRoute : ExactPrimitiveStatePreparationRoute 2 where
  target := bellTarget
  circuit := bellPrimitiveCircuit
  normalizationProof := bellTarget_normalized
  preparationProof := bellPrimitive_prepares_target

theorem bellVerified_cost :
    bellPrimitiveRoute.cost =
      { auxiliaryQubits := 0, gateCount := 2, depth := 2, oracleCalls := 0 } := by
  decide

end QuantumBlockEncoding.StatePreparationBenchmarks

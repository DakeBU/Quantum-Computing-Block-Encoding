import QuantumBlockEncoding.StatePreparationPrimitiveRoutes
import Mathlib.Tactic

/-!
# Paper-grounded state-preparation primitive routes

This is the canonical proof-bearing paper route layer.  The scored object is
always the same typed `PrimitiveCircuit` whose clean-input state action is
proved exactly.  Fixed finite witnesses are decomposed into small matrix-entry
and output-coordinate leaves so verification work stays local and reusable.
-/

namespace QuantumBlockEncoding.StatePreparationBenchmarks

open ConcreteSemantics
open Robin.ComplexLCU

attribute [local simp] Pi.single_apply
attribute [local simp] primitiveBits2LE primitiveBits3LE
attribute [local simp] primitiveBits2LEWithout primitiveBits3LEWithout
attribute [local simp] splitPrimitiveWire_other_apply

/-! ## Exact Pythagorean RY blocks -/

theorem standardRyMatrix_ryAngle35_explicit :
    standardRyMatrix ryAngle35.eval =
      realOrthogonalRotation ((3 : Real) / 5) ((4 : Real) / 5) := by
  rw [standardRyMatrix_ryAngle35]
  change
    realOrthogonalRotation ((3 / 5 : Rat) : Real) ((4 / 5 : Rat) : Real) =
      realOrthogonalRotation ((3 : Real) / 5) ((4 : Real) / 5)
  ext row column
  fin_cases row <;> fin_cases column <;> norm_num [realOrthogonalRotation]

theorem standardRyMatrix_ryAngle513_explicit :
    standardRyMatrix ryAngle513.eval =
      realOrthogonalRotation ((5 : Real) / 13) ((12 : Real) / 13) := by
  rw [standardRyMatrix_ryAngle513]
  change
    realOrthogonalRotation ((5 / 13 : Rat) : Real) ((12 / 13 : Rat) : Real) =
      realOrthogonalRotation ((5 : Real) / 13) ((12 : Real) / 13)
  ext row column
  fin_cases row <;> fin_cases column <;> norm_num [realOrthogonalRotation]

/-! ## Möttönen Eq. (6)--(8) / Fig. 3 finite UCRY route -/

noncomputable def mottonenConditionalAngles (bits : PrimitiveBasis 1) : ExactAngle :=
  if bits 0 = 0 then ryAngle35 else ryAngle513

noncomputable def mottonenDenseUcryCircuit : PrimitiveCircuit 2 :=
  compileUniformlyControlledRy 1 groverRudolphControlWire (0 : Fin 2)
    groverRudolphControlWire_ne_target mottonenConditionalAngles

noncomputable def mottonenDensePrimitiveCircuit : PrimitiveCircuit 2 :=
  [PrimitiveGate.ry (1 : Fin 2) ryAngle513] ++ mottonenDenseUcryCircuit

noncomputable def mottonenRootState : StateVector (gridSize 2) ℂ :=
  (5 / 13 : ℂ) • basisKet (gridSize 2) (0 : Fin 4) +
    (12 / 13 : ℂ) • basisKet (gridSize 2) (2 : Fin 4)

private theorem mottonenRootState_0 :
    mottonenRootState (0 : Fin 4) = (5 : ℂ) / 13 := by
  simp [mottonenRootState, basisKet,
    show (0 : Fin 4) ≠ (2 : Fin 4) by decide]

private theorem mottonenRootState_1 :
    mottonenRootState (1 : Fin 4) = 0 := by
  simp [mottonenRootState, basisKet,
    show (1 : Fin 4) ≠ (0 : Fin 4) by decide,
    show (1 : Fin 4) ≠ (2 : Fin 4) by decide]

private theorem mottonenRootState_2 :
    mottonenRootState (2 : Fin 4) = (12 : ℂ) / 13 := by
  simp [mottonenRootState, basisKet,
    show (2 : Fin 4) ≠ (0 : Fin 4) by decide]

private theorem mottonenRootState_3 :
    mottonenRootState (3 : Fin 4) = 0 := by
  simp [mottonenRootState, basisKet,
    show (3 : Fin 4) ≠ (0 : Fin 4) by decide,
    show (3 : Fin 4) ≠ (2 : Fin 4) by decide]

theorem mottonenRootRy_col_zero :
    (evalPrimitiveCircuitLE [PrimitiveGate.ry (1 : Fin 2) ryAngle513]).col
        (0 : Fin 4) = mottonenRootState := by
  funext row
  fin_cases row
  · change
      evalPrimitiveCircuitLE [PrimitiveGate.ry (1 : Fin 2) ryAngle513]
          (0 : Fin 4) (0 : Fin 4) = mottonenRootState (0 : Fin 4)
    rw [mottonenRootState_0]
    norm_num [evalPrimitiveCircuitLE_singleton_ry_apply, primitiveLEBits,
      standardRyMatrix_ryAngle513_explicit, realOrthogonalRotation]
  · change
      evalPrimitiveCircuitLE [PrimitiveGate.ry (1 : Fin 2) ryAngle513]
          (1 : Fin 4) (0 : Fin 4) = mottonenRootState (1 : Fin 4)
    rw [mottonenRootState_1]
    norm_num [evalPrimitiveCircuitLE_singleton_ry_apply, primitiveLEBits,
      standardRyMatrix_ryAngle513_explicit, realOrthogonalRotation]
  · change
      evalPrimitiveCircuitLE [PrimitiveGate.ry (1 : Fin 2) ryAngle513]
          (2 : Fin 4) (0 : Fin 4) = mottonenRootState (2 : Fin 4)
    rw [mottonenRootState_2]
    norm_num [evalPrimitiveCircuitLE_singleton_ry_apply, primitiveLEBits,
      standardRyMatrix_ryAngle513_explicit, realOrthogonalRotation]
  · change
      evalPrimitiveCircuitLE [PrimitiveGate.ry (1 : Fin 2) ryAngle513]
          (3 : Fin 4) (0 : Fin 4) = mottonenRootState (3 : Fin 4)
    rw [mottonenRootState_3]
    norm_num [evalPrimitiveCircuitLE_singleton_ry_apply, primitiveLEBits,
      standardRyMatrix_ryAngle513_explicit, realOrthogonalRotation]

theorem mottonenRootRy_prepares :
    applyVec
        (evalPrimitiveCircuitLE [PrimitiveGate.ry (1 : Fin 2) ryAngle513])
        (zeroKet 2) = mottonenRootState := by
  rw [applyVec_zeroKet]
  exact mottonenRootRy_col_zero

private theorem mottonenDenseUcry_entry_zero_of_context_ne
    (row column : Fin (gridSize 2))
    (contextNe :
      (splitPrimitiveWire (0 : Fin 2) (primitiveLEBits 2 row)).2 ≠
        (splitPrimitiveWire (0 : Fin 2) (primitiveLEBits 2 column)).2) :
    evalPrimitiveCircuitLE mottonenDenseUcryCircuit row column = 0 := by
  unfold mottonenDenseUcryCircuit
  rw [evalPrimitiveCircuitLE_compileUniformlyControlledRy_apply]
  rw [if_neg contextNe]

private theorem mottonenDenseUcry_entry_00 :
    evalPrimitiveCircuitLE mottonenDenseUcryCircuit (0 : Fin 4) (0 : Fin 4) =
      (3 : ℂ) / 5 := by
  unfold mottonenDenseUcryCircuit
  rw [evalPrimitiveCircuitLE_compileUniformlyControlledRy_apply]
  rw [if_pos (by native_decide)]
  simp [mottonenConditionalAngles, groverRudolphControlWire,
    primitiveControlAssignment, primitiveLEBits,
    standardRyMatrix_ryAngle35_explicit, realOrthogonalRotation]

private theorem mottonenDenseUcry_entry_10 :
    evalPrimitiveCircuitLE mottonenDenseUcryCircuit (1 : Fin 4) (0 : Fin 4) =
      (4 : ℂ) / 5 := by
  unfold mottonenDenseUcryCircuit
  rw [evalPrimitiveCircuitLE_compileUniformlyControlledRy_apply]
  rw [if_pos (by native_decide)]
  simp [mottonenConditionalAngles, groverRudolphControlWire,
    primitiveControlAssignment, primitiveLEBits,
    standardRyMatrix_ryAngle35_explicit, realOrthogonalRotation]

private theorem mottonenDenseUcry_entry_22 :
    evalPrimitiveCircuitLE mottonenDenseUcryCircuit (2 : Fin 4) (2 : Fin 4) =
      (5 : ℂ) / 13 := by
  unfold mottonenDenseUcryCircuit
  rw [evalPrimitiveCircuitLE_compileUniformlyControlledRy_apply]
  rw [if_pos (by native_decide)]
  simp [mottonenConditionalAngles, groverRudolphControlWire,
    primitiveControlAssignment, primitiveLEBits,
    standardRyMatrix_ryAngle513_explicit, realOrthogonalRotation]

private theorem mottonenDenseUcry_entry_32 :
    evalPrimitiveCircuitLE mottonenDenseUcryCircuit (3 : Fin 4) (2 : Fin 4) =
      (12 : ℂ) / 13 := by
  unfold mottonenDenseUcryCircuit
  rw [evalPrimitiveCircuitLE_compileUniformlyControlledRy_apply]
  rw [if_pos (by native_decide)]
  simp [mottonenConditionalAngles, groverRudolphControlWire,
    primitiveControlAssignment, primitiveLEBits,
    standardRyMatrix_ryAngle513_explicit, realOrthogonalRotation]

private theorem mottonenDenseUcry_entry_02 :
    evalPrimitiveCircuitLE mottonenDenseUcryCircuit (0 : Fin 4) (2 : Fin 4) = 0 :=
  mottonenDenseUcry_entry_zero_of_context_ne
    (0 : Fin 4) (2 : Fin 4) (by native_decide)

private theorem mottonenDenseUcry_entry_12 :
    evalPrimitiveCircuitLE mottonenDenseUcryCircuit (1 : Fin 4) (2 : Fin 4) = 0 :=
  mottonenDenseUcry_entry_zero_of_context_ne
    (1 : Fin 4) (2 : Fin 4) (by native_decide)

private theorem mottonenDenseUcry_entry_20 :
    evalPrimitiveCircuitLE mottonenDenseUcryCircuit (2 : Fin 4) (0 : Fin 4) = 0 :=
  mottonenDenseUcry_entry_zero_of_context_ne
    (2 : Fin 4) (0 : Fin 4) (by native_decide)

private theorem mottonenDenseUcry_entry_30 :
    evalPrimitiveCircuitLE mottonenDenseUcryCircuit (3 : Fin 4) (0 : Fin 4) = 0 :=
  mottonenDenseUcry_entry_zero_of_context_ne
    (3 : Fin 4) (0 : Fin 4) (by native_decide)

set_option maxHeartbeats 1000000 in
private theorem mottonenDenseUcry_output_0 :
    ((5 / 13 : ℂ) • (evalPrimitiveCircuitLE mottonenDenseUcryCircuit).col (0 : Fin 4) +
      (12 / 13 : ℂ) • (evalPrimitiveCircuitLE mottonenDenseUcryCircuit).col (2 : Fin 4))
        (0 : Fin 4) = mottonenDenseState (0 : Fin 4) := by
  change
    (5 / 13 : ℂ) * evalPrimitiveCircuitLE mottonenDenseUcryCircuit (0 : Fin 4) (0 : Fin 4) +
      (12 / 13 : ℂ) * evalPrimitiveCircuitLE mottonenDenseUcryCircuit (0 : Fin 4) (2 : Fin 4) =
      (39 : ℂ) / 169
  rw [mottonenDenseUcry_entry_00, mottonenDenseUcry_entry_02]
  norm_num

set_option maxHeartbeats 1000000 in
private theorem mottonenDenseUcry_output_1 :
    ((5 / 13 : ℂ) • (evalPrimitiveCircuitLE mottonenDenseUcryCircuit).col (0 : Fin 4) +
      (12 / 13 : ℂ) • (evalPrimitiveCircuitLE mottonenDenseUcryCircuit).col (2 : Fin 4))
        (1 : Fin 4) = mottonenDenseState (1 : Fin 4) := by
  change
    (5 / 13 : ℂ) * evalPrimitiveCircuitLE mottonenDenseUcryCircuit (1 : Fin 4) (0 : Fin 4) +
      (12 / 13 : ℂ) * evalPrimitiveCircuitLE mottonenDenseUcryCircuit (1 : Fin 4) (2 : Fin 4) =
      (52 : ℂ) / 169
  rw [mottonenDenseUcry_entry_10, mottonenDenseUcry_entry_12]
  norm_num

set_option maxHeartbeats 1000000 in
private theorem mottonenDenseUcry_output_2 :
    ((5 / 13 : ℂ) • (evalPrimitiveCircuitLE mottonenDenseUcryCircuit).col (0 : Fin 4) +
      (12 / 13 : ℂ) • (evalPrimitiveCircuitLE mottonenDenseUcryCircuit).col (2 : Fin 4))
        (2 : Fin 4) = mottonenDenseState (2 : Fin 4) := by
  change
    (5 / 13 : ℂ) * evalPrimitiveCircuitLE mottonenDenseUcryCircuit (2 : Fin 4) (0 : Fin 4) +
      (12 / 13 : ℂ) * evalPrimitiveCircuitLE mottonenDenseUcryCircuit (2 : Fin 4) (2 : Fin 4) =
      (60 : ℂ) / 169
  rw [mottonenDenseUcry_entry_20, mottonenDenseUcry_entry_22]
  norm_num

set_option maxHeartbeats 1000000 in
private theorem mottonenDenseUcry_output_3 :
    ((5 / 13 : ℂ) • (evalPrimitiveCircuitLE mottonenDenseUcryCircuit).col (0 : Fin 4) +
      (12 / 13 : ℂ) • (evalPrimitiveCircuitLE mottonenDenseUcryCircuit).col (2 : Fin 4))
        (3 : Fin 4) = mottonenDenseState (3 : Fin 4) := by
  change
    (5 / 13 : ℂ) * evalPrimitiveCircuitLE mottonenDenseUcryCircuit (3 : Fin 4) (0 : Fin 4) +
      (12 / 13 : ℂ) * evalPrimitiveCircuitLE mottonenDenseUcryCircuit (3 : Fin 4) (2 : Fin 4) =
      (144 : ℂ) / 169
  rw [mottonenDenseUcry_entry_30, mottonenDenseUcry_entry_32]
  norm_num

theorem mottonenDenseUcry_on_root :
    applyVec (evalPrimitiveCircuitLE mottonenDenseUcryCircuit) mottonenRootState =
      mottonenDenseState := by
  unfold mottonenRootState
  rw [applyVec_twoBasisSuperposition]
  funext row
  fin_cases row
  · exact mottonenDenseUcry_output_0
  · exact mottonenDenseUcry_output_1
  · exact mottonenDenseUcry_output_2
  · exact mottonenDenseUcry_output_3

theorem mottonenDensePrimitive_prepares_target :
    applyVec (evalPrimitiveCircuitLE mottonenDensePrimitiveCircuit) (zeroKet 2) =
      mottonenDenseTarget.amplitudes := by
  unfold mottonenDensePrimitiveCircuit
  rw [evalPrimitiveCircuitLE_append]
  unfold applyVec
  rw [← _root_.Matrix.mulVec_mulVec]
  change
    applyVec (evalPrimitiveCircuitLE mottonenDenseUcryCircuit)
        (applyVec
          (evalPrimitiveCircuitLE [PrimitiveGate.ry (1 : Fin 2) ryAngle513])
          (zeroKet 2)) = mottonenDenseState
  rw [mottonenRootRy_prepares]
  exact mottonenDenseUcry_on_root

noncomputable def mottonenDensePrimitiveRoute :
    ExactPrimitiveStatePreparationRoute 2 where
  target := mottonenDenseTarget
  circuit := mottonenDensePrimitiveCircuit
  normalizationProof := mottonenDenseTarget_normalized
  preparationProof := mottonenDensePrimitive_prepares_target

theorem mottonenDenseVerified_cost :
    mottonenDensePrimitiveRoute.cost =
      { auxiliaryQubits := 0, gateCount := 5, depth := 4, oracleCalls := 0 } := by
  decide

/-! ## Generic exact identity fact for a zero-angle UCRY compiler -/

theorem zeroAngleCompiledUcry_eval_eq_one
    {qubits controls : Nat}
    (wires : Fin controls → Fin qubits) (target : Fin qubits)
    (distinct : ∀ control, wires control ≠ target) :
    evalPrimitiveCircuit
        (compileUniformlyControlledRy controls wires target distinct
          (fun _ => ryAngleZero)) = 1 := by
  rw [compileUniformlyControlledRy_eval_controlledRyBlockMatrix]
  ext row column
  rw [controlledRyBlockMatrix_apply]
  by_cases contextsEqual :
      (splitPrimitiveWire target row).2 = (splitPrimitiveWire target column).2
  · have rowEq_iff : row = column ↔ row target = column target := by
      constructor
      · intro equality
        exact congrFun equality target
      · intro targetEqual
        apply (splitPrimitiveWire target).injective
        apply Prod.ext
        · simpa [splitPrimitiveWire] using targetEqual
        · exact contextsEqual
    rw [if_pos contextsEqual, standardRyMatrix_ryAngleZero]
    simpa only [_root_.Matrix.one_apply, rowEq_iff]
  · have rowNe : row ≠ column := by
      intro equality
      subst column
      exact contextsEqual rfl
    rw [if_neg contextsEqual]
    simp [rowNe]

/-! ## Li--Luo Eq. (1)--(2) finite sparse route -/

def sparseControlWire : Fin 1 → Fin 3 := fun _ => 2

theorem sparseControlWire_ne_target :
    ∀ control, sparseControlWire control ≠ (1 : Fin 3) := by
  intro control
  fin_cases control
  decide

noncomputable def sparseConditionalAngles (bits : PrimitiveBasis 1) : ExactAngle :=
  if bits 0 = 0 then ryAngle35 else ryAngleZero

noncomputable def sparsePrunedUcryCircuit : PrimitiveCircuit 3 :=
  compileUniformlyControlledRy 1 sparseControlWire (1 : Fin 3)
    sparseControlWire_ne_target sparseConditionalAngles

noncomputable def sparsePrunedCircuit : PrimitiveCircuit 3 :=
  [PrimitiveGate.ry (2 : Fin 3) ryAngle513] ++ sparsePrunedUcryCircuit

noncomputable def sparseRootState : StateVector (gridSize 3) ℂ :=
  (5 / 13 : ℂ) • basisKet (gridSize 3) (0 : Fin 8) +
    (12 / 13 : ℂ) • basisKet (gridSize 3) (4 : Fin 8)

private theorem sparseRootState_0 :
    sparseRootState (0 : Fin 8) = (5 : ℂ) / 13 := by
  simp [sparseRootState, basisKet,
    show (0 : Fin 8) ≠ (4 : Fin 8) by decide]

private theorem sparseRootState_1 :
    sparseRootState (1 : Fin 8) = 0 := by
  simp [sparseRootState, basisKet,
    show (1 : Fin 8) ≠ (0 : Fin 8) by decide,
    show (1 : Fin 8) ≠ (4 : Fin 8) by decide]

private theorem sparseRootState_2 :
    sparseRootState (2 : Fin 8) = 0 := by
  simp [sparseRootState, basisKet,
    show (2 : Fin 8) ≠ (0 : Fin 8) by decide,
    show (2 : Fin 8) ≠ (4 : Fin 8) by decide]

private theorem sparseRootState_3 :
    sparseRootState (3 : Fin 8) = 0 := by
  simp [sparseRootState, basisKet,
    show (3 : Fin 8) ≠ (0 : Fin 8) by decide,
    show (3 : Fin 8) ≠ (4 : Fin 8) by decide]

private theorem sparseRootState_4 :
    sparseRootState (4 : Fin 8) = (12 : ℂ) / 13 := by
  simp [sparseRootState, basisKet,
    show (4 : Fin 8) ≠ (0 : Fin 8) by decide]

private theorem sparseRootState_5 :
    sparseRootState (5 : Fin 8) = 0 := by
  simp [sparseRootState, basisKet,
    show (5 : Fin 8) ≠ (0 : Fin 8) by decide,
    show (5 : Fin 8) ≠ (4 : Fin 8) by decide]

private theorem sparseRootState_6 :
    sparseRootState (6 : Fin 8) = 0 := by
  simp [sparseRootState, basisKet,
    show (6 : Fin 8) ≠ (0 : Fin 8) by decide,
    show (6 : Fin 8) ≠ (4 : Fin 8) by decide]

private theorem sparseRootState_7 :
    sparseRootState (7 : Fin 8) = 0 := by
  simp [sparseRootState, basisKet,
    show (7 : Fin 8) ≠ (0 : Fin 8) by decide,
    show (7 : Fin 8) ≠ (4 : Fin 8) by decide]

theorem sparseRootRy_col_zero :
    (evalPrimitiveCircuitLE [PrimitiveGate.ry (2 : Fin 3) ryAngle513]).col
        (0 : Fin 8) = sparseRootState := by
  funext row
  fin_cases row
  · change
      evalPrimitiveCircuitLE [PrimitiveGate.ry (2 : Fin 3) ryAngle513]
          (0 : Fin 8) (0 : Fin 8) = sparseRootState (0 : Fin 8)
    rw [sparseRootState_0]
    norm_num [evalPrimitiveCircuitLE_singleton_ry_apply, primitiveLEBits,
      standardRyMatrix_ryAngle513_explicit, realOrthogonalRotation]
  · change
      evalPrimitiveCircuitLE [PrimitiveGate.ry (2 : Fin 3) ryAngle513]
          (1 : Fin 8) (0 : Fin 8) = sparseRootState (1 : Fin 8)
    rw [sparseRootState_1]
    norm_num [evalPrimitiveCircuitLE_singleton_ry_apply, primitiveLEBits,
      standardRyMatrix_ryAngle513_explicit, realOrthogonalRotation]
  · change
      evalPrimitiveCircuitLE [PrimitiveGate.ry (2 : Fin 3) ryAngle513]
          (2 : Fin 8) (0 : Fin 8) = sparseRootState (2 : Fin 8)
    rw [sparseRootState_2]
    norm_num [evalPrimitiveCircuitLE_singleton_ry_apply, primitiveLEBits,
      standardRyMatrix_ryAngle513_explicit, realOrthogonalRotation]
  · change
      evalPrimitiveCircuitLE [PrimitiveGate.ry (2 : Fin 3) ryAngle513]
          (3 : Fin 8) (0 : Fin 8) = sparseRootState (3 : Fin 8)
    rw [sparseRootState_3]
    norm_num [evalPrimitiveCircuitLE_singleton_ry_apply, primitiveLEBits,
      standardRyMatrix_ryAngle513_explicit, realOrthogonalRotation]
  · change
      evalPrimitiveCircuitLE [PrimitiveGate.ry (2 : Fin 3) ryAngle513]
          (4 : Fin 8) (0 : Fin 8) = sparseRootState (4 : Fin 8)
    rw [sparseRootState_4]
    norm_num [evalPrimitiveCircuitLE_singleton_ry_apply, primitiveLEBits,
      standardRyMatrix_ryAngle513_explicit, realOrthogonalRotation]
  · change
      evalPrimitiveCircuitLE [PrimitiveGate.ry (2 : Fin 3) ryAngle513]
          (5 : Fin 8) (0 : Fin 8) = sparseRootState (5 : Fin 8)
    rw [sparseRootState_5]
    norm_num [evalPrimitiveCircuitLE_singleton_ry_apply, primitiveLEBits,
      standardRyMatrix_ryAngle513_explicit, realOrthogonalRotation]
  · change
      evalPrimitiveCircuitLE [PrimitiveGate.ry (2 : Fin 3) ryAngle513]
          (6 : Fin 8) (0 : Fin 8) = sparseRootState (6 : Fin 8)
    rw [sparseRootState_6]
    norm_num [evalPrimitiveCircuitLE_singleton_ry_apply, primitiveLEBits,
      standardRyMatrix_ryAngle513_explicit, realOrthogonalRotation]
  · change
      evalPrimitiveCircuitLE [PrimitiveGate.ry (2 : Fin 3) ryAngle513]
          (7 : Fin 8) (0 : Fin 8) = sparseRootState (7 : Fin 8)
    rw [sparseRootState_7]
    norm_num [evalPrimitiveCircuitLE_singleton_ry_apply, primitiveLEBits,
      standardRyMatrix_ryAngle513_explicit, realOrthogonalRotation]

theorem sparseRootRy_prepares :
    applyVec
        (evalPrimitiveCircuitLE [PrimitiveGate.ry (2 : Fin 3) ryAngle513])
        (zeroKet 3) = sparseRootState := by
  rw [applyVec_zeroKet]
  exact sparseRootRy_col_zero

private theorem sparsePrunedUcry_entry_zero_of_context_ne
    (row column : Fin (gridSize 3))
    (contextNe :
      (splitPrimitiveWire (1 : Fin 3) (primitiveLEBits 3 row)).2 ≠
        (splitPrimitiveWire (1 : Fin 3) (primitiveLEBits 3 column)).2) :
    evalPrimitiveCircuitLE sparsePrunedUcryCircuit row column = 0 := by
  unfold sparsePrunedUcryCircuit
  rw [evalPrimitiveCircuitLE_compileUniformlyControlledRy_apply]
  rw [if_neg contextNe]

private theorem sparsePrunedUcry_entry_00 :
    evalPrimitiveCircuitLE sparsePrunedUcryCircuit (0 : Fin 8) (0 : Fin 8) =
      (3 : ℂ) / 5 := by
  unfold sparsePrunedUcryCircuit
  rw [evalPrimitiveCircuitLE_compileUniformlyControlledRy_apply]
  rw [if_pos (by native_decide)]
  simp [sparseConditionalAngles, sparseControlWire, primitiveControlAssignment,
    primitiveLEBits, standardRyMatrix_ryAngle35_explicit,
    realOrthogonalRotation]

private theorem sparsePrunedUcry_entry_20 :
    evalPrimitiveCircuitLE sparsePrunedUcryCircuit (2 : Fin 8) (0 : Fin 8) =
      (4 : ℂ) / 5 := by
  unfold sparsePrunedUcryCircuit
  rw [evalPrimitiveCircuitLE_compileUniformlyControlledRy_apply]
  rw [if_pos (by native_decide)]
  simp [sparseConditionalAngles, sparseControlWire, primitiveControlAssignment,
    primitiveLEBits, standardRyMatrix_ryAngle35_explicit,
    realOrthogonalRotation]

private theorem sparsePrunedUcry_entry_44 :
    evalPrimitiveCircuitLE sparsePrunedUcryCircuit (4 : Fin 8) (4 : Fin 8) = 1 := by
  unfold sparsePrunedUcryCircuit
  rw [evalPrimitiveCircuitLE_compileUniformlyControlledRy_apply]
  rw [if_pos (by native_decide)]
  simp [sparseConditionalAngles, sparseControlWire, primitiveControlAssignment,
    primitiveLEBits, standardRyMatrix_ryAngleZero]

private theorem sparsePrunedUcry_entry_64 :
    evalPrimitiveCircuitLE sparsePrunedUcryCircuit (6 : Fin 8) (4 : Fin 8) = 0 := by
  unfold sparsePrunedUcryCircuit
  rw [evalPrimitiveCircuitLE_compileUniformlyControlledRy_apply]
  rw [if_pos (by native_decide)]
  simp [sparseConditionalAngles, sparseControlWire, primitiveControlAssignment,
    primitiveLEBits, standardRyMatrix_ryAngleZero]

private theorem sparsePrunedUcry_entry_10 :
    evalPrimitiveCircuitLE sparsePrunedUcryCircuit (1 : Fin 8) (0 : Fin 8) = 0 :=
  sparsePrunedUcry_entry_zero_of_context_ne
    (1 : Fin 8) (0 : Fin 8) (by native_decide)

private theorem sparsePrunedUcry_entry_30 :
    evalPrimitiveCircuitLE sparsePrunedUcryCircuit (3 : Fin 8) (0 : Fin 8) = 0 :=
  sparsePrunedUcry_entry_zero_of_context_ne
    (3 : Fin 8) (0 : Fin 8) (by native_decide)

private theorem sparsePrunedUcry_entry_40 :
    evalPrimitiveCircuitLE sparsePrunedUcryCircuit (4 : Fin 8) (0 : Fin 8) = 0 :=
  sparsePrunedUcry_entry_zero_of_context_ne
    (4 : Fin 8) (0 : Fin 8) (by native_decide)

private theorem sparsePrunedUcry_entry_50 :
    evalPrimitiveCircuitLE sparsePrunedUcryCircuit (5 : Fin 8) (0 : Fin 8) = 0 :=
  sparsePrunedUcry_entry_zero_of_context_ne
    (5 : Fin 8) (0 : Fin 8) (by native_decide)

private theorem sparsePrunedUcry_entry_60 :
    evalPrimitiveCircuitLE sparsePrunedUcryCircuit (6 : Fin 8) (0 : Fin 8) = 0 :=
  sparsePrunedUcry_entry_zero_of_context_ne
    (6 : Fin 8) (0 : Fin 8) (by native_decide)

private theorem sparsePrunedUcry_entry_70 :
    evalPrimitiveCircuitLE sparsePrunedUcryCircuit (7 : Fin 8) (0 : Fin 8) = 0 :=
  sparsePrunedUcry_entry_zero_of_context_ne
    (7 : Fin 8) (0 : Fin 8) (by native_decide)

private theorem sparsePrunedUcry_entry_04 :
    evalPrimitiveCircuitLE sparsePrunedUcryCircuit (0 : Fin 8) (4 : Fin 8) = 0 :=
  sparsePrunedUcry_entry_zero_of_context_ne
    (0 : Fin 8) (4 : Fin 8) (by native_decide)

private theorem sparsePrunedUcry_entry_14 :
    evalPrimitiveCircuitLE sparsePrunedUcryCircuit (1 : Fin 8) (4 : Fin 8) = 0 :=
  sparsePrunedUcry_entry_zero_of_context_ne
    (1 : Fin 8) (4 : Fin 8) (by native_decide)

private theorem sparsePrunedUcry_entry_24 :
    evalPrimitiveCircuitLE sparsePrunedUcryCircuit (2 : Fin 8) (4 : Fin 8) = 0 :=
  sparsePrunedUcry_entry_zero_of_context_ne
    (2 : Fin 8) (4 : Fin 8) (by native_decide)

private theorem sparsePrunedUcry_entry_34 :
    evalPrimitiveCircuitLE sparsePrunedUcryCircuit (3 : Fin 8) (4 : Fin 8) = 0 :=
  sparsePrunedUcry_entry_zero_of_context_ne
    (3 : Fin 8) (4 : Fin 8) (by native_decide)

private theorem sparsePrunedUcry_entry_54 :
    evalPrimitiveCircuitLE sparsePrunedUcryCircuit (5 : Fin 8) (4 : Fin 8) = 0 :=
  sparsePrunedUcry_entry_zero_of_context_ne
    (5 : Fin 8) (4 : Fin 8) (by native_decide)

private theorem sparsePrunedUcry_entry_74 :
    evalPrimitiveCircuitLE sparsePrunedUcryCircuit (7 : Fin 8) (4 : Fin 8) = 0 :=
  sparsePrunedUcry_entry_zero_of_context_ne
    (7 : Fin 8) (4 : Fin 8) (by native_decide)

set_option maxHeartbeats 1000000 in
private theorem sparsePrunedUcry_output_0 :
    ((5 / 13 : ℂ) • (evalPrimitiveCircuitLE sparsePrunedUcryCircuit).col (0 : Fin 8) +
      (12 / 13 : ℂ) • (evalPrimitiveCircuitLE sparsePrunedUcryCircuit).col (4 : Fin 8))
        (0 : Fin 8) = sparseThreeState (0 : Fin 8) := by
  change
    (5 / 13 : ℂ) * evalPrimitiveCircuitLE sparsePrunedUcryCircuit (0 : Fin 8) (0 : Fin 8) +
      (12 / 13 : ℂ) * evalPrimitiveCircuitLE sparsePrunedUcryCircuit (0 : Fin 8) (4 : Fin 8) =
      (3 : ℂ) / 13
  rw [sparsePrunedUcry_entry_00, sparsePrunedUcry_entry_04]
  norm_num

set_option maxHeartbeats 1000000 in
private theorem sparsePrunedUcry_output_1 :
    ((5 / 13 : ℂ) • (evalPrimitiveCircuitLE sparsePrunedUcryCircuit).col (0 : Fin 8) +
      (12 / 13 : ℂ) • (evalPrimitiveCircuitLE sparsePrunedUcryCircuit).col (4 : Fin 8))
        (1 : Fin 8) = sparseThreeState (1 : Fin 8) := by
  change
    (5 / 13 : ℂ) * evalPrimitiveCircuitLE sparsePrunedUcryCircuit (1 : Fin 8) (0 : Fin 8) +
      (12 / 13 : ℂ) * evalPrimitiveCircuitLE sparsePrunedUcryCircuit (1 : Fin 8) (4 : Fin 8) = 0
  rw [sparsePrunedUcry_entry_10, sparsePrunedUcry_entry_14]
  norm_num

set_option maxHeartbeats 1000000 in
private theorem sparsePrunedUcry_output_2 :
    ((5 / 13 : ℂ) • (evalPrimitiveCircuitLE sparsePrunedUcryCircuit).col (0 : Fin 8) +
      (12 / 13 : ℂ) • (evalPrimitiveCircuitLE sparsePrunedUcryCircuit).col (4 : Fin 8))
        (2 : Fin 8) = sparseThreeState (2 : Fin 8) := by
  change
    (5 / 13 : ℂ) * evalPrimitiveCircuitLE sparsePrunedUcryCircuit (2 : Fin 8) (0 : Fin 8) +
      (12 / 13 : ℂ) * evalPrimitiveCircuitLE sparsePrunedUcryCircuit (2 : Fin 8) (4 : Fin 8) =
      (4 : ℂ) / 13
  rw [sparsePrunedUcry_entry_20, sparsePrunedUcry_entry_24]
  norm_num

set_option maxHeartbeats 1000000 in
private theorem sparsePrunedUcry_output_3 :
    ((5 / 13 : ℂ) • (evalPrimitiveCircuitLE sparsePrunedUcryCircuit).col (0 : Fin 8) +
      (12 / 13 : ℂ) • (evalPrimitiveCircuitLE sparsePrunedUcryCircuit).col (4 : Fin 8))
        (3 : Fin 8) = sparseThreeState (3 : Fin 8) := by
  change
    (5 / 13 : ℂ) * evalPrimitiveCircuitLE sparsePrunedUcryCircuit (3 : Fin 8) (0 : Fin 8) +
      (12 / 13 : ℂ) * evalPrimitiveCircuitLE sparsePrunedUcryCircuit (3 : Fin 8) (4 : Fin 8) = 0
  rw [sparsePrunedUcry_entry_30, sparsePrunedUcry_entry_34]
  norm_num

set_option maxHeartbeats 1000000 in
private theorem sparsePrunedUcry_output_4 :
    ((5 / 13 : ℂ) • (evalPrimitiveCircuitLE sparsePrunedUcryCircuit).col (0 : Fin 8) +
      (12 / 13 : ℂ) • (evalPrimitiveCircuitLE sparsePrunedUcryCircuit).col (4 : Fin 8))
        (4 : Fin 8) = sparseThreeState (4 : Fin 8) := by
  change
    (5 / 13 : ℂ) * evalPrimitiveCircuitLE sparsePrunedUcryCircuit (4 : Fin 8) (0 : Fin 8) +
      (12 / 13 : ℂ) * evalPrimitiveCircuitLE sparsePrunedUcryCircuit (4 : Fin 8) (4 : Fin 8) =
      (12 : ℂ) / 13
  rw [sparsePrunedUcry_entry_40, sparsePrunedUcry_entry_44]
  norm_num

set_option maxHeartbeats 1000000 in
private theorem sparsePrunedUcry_output_5 :
    ((5 / 13 : ℂ) • (evalPrimitiveCircuitLE sparsePrunedUcryCircuit).col (0 : Fin 8) +
      (12 / 13 : ℂ) • (evalPrimitiveCircuitLE sparsePrunedUcryCircuit).col (4 : Fin 8))
        (5 : Fin 8) = sparseThreeState (5 : Fin 8) := by
  change
    (5 / 13 : ℂ) * evalPrimitiveCircuitLE sparsePrunedUcryCircuit (5 : Fin 8) (0 : Fin 8) +
      (12 / 13 : ℂ) * evalPrimitiveCircuitLE sparsePrunedUcryCircuit (5 : Fin 8) (4 : Fin 8) = 0
  rw [sparsePrunedUcry_entry_50, sparsePrunedUcry_entry_54]
  norm_num

set_option maxHeartbeats 1000000 in
private theorem sparsePrunedUcry_output_6 :
    ((5 / 13 : ℂ) • (evalPrimitiveCircuitLE sparsePrunedUcryCircuit).col (0 : Fin 8) +
      (12 / 13 : ℂ) • (evalPrimitiveCircuitLE sparsePrunedUcryCircuit).col (4 : Fin 8))
        (6 : Fin 8) = sparseThreeState (6 : Fin 8) := by
  change
    (5 / 13 : ℂ) * evalPrimitiveCircuitLE sparsePrunedUcryCircuit (6 : Fin 8) (0 : Fin 8) +
      (12 / 13 : ℂ) * evalPrimitiveCircuitLE sparsePrunedUcryCircuit (6 : Fin 8) (4 : Fin 8) = 0
  rw [sparsePrunedUcry_entry_60, sparsePrunedUcry_entry_64]
  norm_num

set_option maxHeartbeats 1000000 in
private theorem sparsePrunedUcry_output_7 :
    ((5 / 13 : ℂ) • (evalPrimitiveCircuitLE sparsePrunedUcryCircuit).col (0 : Fin 8) +
      (12 / 13 : ℂ) • (evalPrimitiveCircuitLE sparsePrunedUcryCircuit).col (4 : Fin 8))
        (7 : Fin 8) = sparseThreeState (7 : Fin 8) := by
  change
    (5 / 13 : ℂ) * evalPrimitiveCircuitLE sparsePrunedUcryCircuit (7 : Fin 8) (0 : Fin 8) +
      (12 / 13 : ℂ) * evalPrimitiveCircuitLE sparsePrunedUcryCircuit (7 : Fin 8) (4 : Fin 8) = 0
  rw [sparsePrunedUcry_entry_70, sparsePrunedUcry_entry_74]
  norm_num

theorem sparsePrunedUcry_on_root :
    applyVec (evalPrimitiveCircuitLE sparsePrunedUcryCircuit) sparseRootState =
      sparseThreeState := by
  unfold sparseRootState
  rw [applyVec_twoBasisSuperposition]
  funext row
  fin_cases row
  · exact sparsePrunedUcry_output_0
  · exact sparsePrunedUcry_output_1
  · exact sparsePrunedUcry_output_2
  · exact sparsePrunedUcry_output_3
  · exact sparsePrunedUcry_output_4
  · exact sparsePrunedUcry_output_5
  · exact sparsePrunedUcry_output_6
  · exact sparsePrunedUcry_output_7

theorem sparsePruned_prepares_target :
    applyVec (evalPrimitiveCircuitLE sparsePrunedCircuit) (zeroKet 3) =
      sparseThreeTarget.amplitudes := by
  unfold sparsePrunedCircuit
  rw [evalPrimitiveCircuitLE_append]
  unfold applyVec
  rw [← _root_.Matrix.mulVec_mulVec]
  change
    applyVec (evalPrimitiveCircuitLE sparsePrunedUcryCircuit)
        (applyVec
          (evalPrimitiveCircuitLE [PrimitiveGate.ry (2 : Fin 3) ryAngle513])
          (zeroKet 3)) = sparseThreeState
  rw [sparseRootRy_prepares]
  exact sparsePrunedUcry_on_root

noncomputable def sparsePrunedRoute : ExactPrimitiveStatePreparationRoute 3 where
  target := sparseThreeTarget
  circuit := sparsePrunedCircuit
  normalizationProof := sparseThreeTarget_normalized
  preparationProof := sparsePruned_prepares_target

def sparseDenseControlWires : Fin 2 → Fin 3
  | ⟨0, _⟩ => 1
  | _ => 2

theorem sparseDenseControlWires_ne_target :
    ∀ control, sparseDenseControlWires control ≠ (0 : Fin 3) := by
  intro control
  fin_cases control <;> decide

noncomputable def sparseZeroFillCircuit : PrimitiveCircuit 3 :=
  compileUniformlyControlledRy 2 sparseDenseControlWires (0 : Fin 3)
    sparseDenseControlWires_ne_target (fun _ => ryAngleZero)

noncomputable def sparseDenseTreeCircuit : PrimitiveCircuit 3 :=
  sparsePrunedCircuit ++ sparseZeroFillCircuit

theorem sparseZeroFill_eval_eq_one :
    evalPrimitiveCircuit sparseZeroFillCircuit = 1 := by
  unfold sparseZeroFillCircuit
  exact zeroAngleCompiledUcry_eval_eq_one
    sparseDenseControlWires (0 : Fin 3) sparseDenseControlWires_ne_target

theorem sparseZeroFill_evalLE_eq_one :
    evalPrimitiveCircuitLE sparseZeroFillCircuit = 1 := by
  unfold evalPrimitiveCircuitLE
  rw [sparseZeroFill_eval_eq_one]
  simp

theorem sparseDenseTree_evalLE_eq_pruned :
    evalPrimitiveCircuitLE sparseDenseTreeCircuit =
      evalPrimitiveCircuitLE sparsePrunedCircuit := by
  unfold sparseDenseTreeCircuit
  rw [evalPrimitiveCircuitLE_append, sparseZeroFill_evalLE_eq_one]
  simp

theorem sparseDenseTree_prepares_target :
    applyVec (evalPrimitiveCircuitLE sparseDenseTreeCircuit) (zeroKet 3) =
      sparseThreeTarget.amplitudes := by
  rw [sparseDenseTree_evalLE_eq_pruned]
  exact sparsePruned_prepares_target

noncomputable def sparseDenseTreeRoute : ExactPrimitiveStatePreparationRoute 3 where
  target := sparseThreeTarget
  circuit := sparseDenseTreeCircuit
  normalizationProof := sparseThreeTarget_normalized
  preparationProof := sparseDenseTree_prepares_target

theorem sparsePrunedVerified_cost :
    sparsePrunedRoute.cost =
      { auxiliaryQubits := 0, gateCount := 5, depth := 4, oracleCalls := 0 } := by
  decide

theorem sparseDenseTreeVerified_cost :
    sparseDenseTreeRoute.cost =
      { auxiliaryQubits := 0, gateCount := 15, depth := 13, oracleCalls := 0 } := by
  decide

theorem sparsePruned_betterThan_denseTree :
    sparsePrunedRoute.cost.betterThan sparseDenseTreeRoute.cost := by
  rw [sparsePrunedVerified_cost, sparseDenseTreeVerified_cost]
  exact Or.inl (by decide)

end QuantumBlockEncoding.StatePreparationBenchmarks

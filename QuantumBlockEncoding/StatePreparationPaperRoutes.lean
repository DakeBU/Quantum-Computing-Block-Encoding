import QuantumBlockEncoding.StatePreparationPrimitiveRoutes
import Mathlib.Tactic

/-!
# Paper-grounded state-preparation primitive routes

This module instantiates the reusable exact UCRY compiler on two paper-grounded
finite benchmarks.  Every resource comparison is attached to the same typed
primitive circuit whose zero-input state action is proved exactly.
-/

namespace QuantumBlockEncoding.StatePreparationBenchmarks

open ConcreteSemantics
open Robin.ComplexLCU

/-! ## Public exact forms of the two Pythagorean RY blocks -/

theorem standardRyMatrix_ryAngle35_explicit :
    standardRyMatrix ryAngle35.eval =
      realOrthogonalRotation ((3 : Real) / 5) ((4 : Real) / 5) := by
  rw [standardRyMatrix_ryAngle35]
  ext row column
  fin_cases row <;> fin_cases column <;>
    dsimp [realOrthogonalRotation] <;> norm_num

theorem standardRyMatrix_ryAngle513_explicit :
    standardRyMatrix ryAngle513.eval =
      realOrthogonalRotation ((5 : Real) / 13) ((12 : Real) / 13) := by
  rw [standardRyMatrix_ryAngle513]
  ext row column
  fin_cases row <;> fin_cases column <;>
    dsimp [realOrthogonalRotation] <;> norm_num

/-! ## Möttönen Eq. (6)--(8) / Fig. 3 finite UCRY route -/

noncomputable def mottonenConditionalAngles (bits : PrimitiveBasis 1) : ExactAngle :=
  if bits 0 = 0 then ryAngle35 else ryAngle513

/-- Root probability split on q1, then one-control UCRY on q0. -/
noncomputable def mottonenDensePrimitiveCircuit : PrimitiveCircuit 2 :=
  [PrimitiveGate.ry (1 : Fin 2) ryAngle513] ++
    compileUniformlyControlledRy 1 groverRudolphControlWire (0 : Fin 2)
      groverRudolphControlWire_ne_target mottonenConditionalAngles

theorem mottonenDensePrimitive_prepares_target :
    applyVec (evalPrimitiveCircuitLE mottonenDensePrimitiveCircuit) (zeroKet 2) =
      mottonenDenseTarget.amplitudes := by
  rw [applyVec_zeroKet]
  funext row
  change evalPrimitiveCircuitLE mottonenDensePrimitiveCircuit row (0 : Fin 4) =
    mottonenDenseState row
  unfold mottonenDensePrimitiveCircuit
  rw [evalPrimitiveCircuitLE_append]
  change
    (evalPrimitiveCircuitLE
        (compileUniformlyControlledRy 1 groverRudolphControlWire (0 : Fin 2)
          groverRudolphControlWire_ne_target mottonenConditionalAngles) *
      evalPrimitiveCircuitLE [PrimitiveGate.ry (1 : Fin 2) ryAngle513])
      row (0 : Fin 4) = mottonenDenseState row
  rw [_root_.Matrix.mul_apply, Finset.sum_fin_eq_sum_range]
  fin_cases row <;>
    norm_num [gridSize, Finset.sum_range_succ,
      evalPrimitiveCircuitLE_singleton_ry_apply,
      evalPrimitiveCircuitLE_compileUniformlyControlledRy_apply,
      mottonenConditionalAngles, groverRudolphControlWire,
      groverRudolphControlWire_ne_target, primitiveControlAssignment,
      primitiveLEBits, primitiveBasisLEEquiv_two_symm, primitiveBits2LE,
      primitiveBits2LEWithout, splitPrimitiveWire_primitiveBits2LE_context_eq,
      standardRyMatrix_ryAngle35_explicit,
      standardRyMatrix_ryAngle513_explicit, realOrthogonalRotation,
      mottonenDenseState]

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
    simp [_root_.Matrix.one_apply, rowNe]

/-! ## Li--Luo Eq. (1)--(2) finite sparse route -/

def sparseControlWire : Fin 1 → Fin 3 := fun _ => 2

theorem sparseControlWire_ne_target :
    ∀ control, sparseControlWire control ≠ (1 : Fin 3) := by
  intro control
  fin_cases control
  decide

noncomputable def sparseConditionalAngles (bits : PrimitiveBasis 1) : ExactAngle :=
  if bits 0 = 0 then ryAngle35 else ryAngleZero

/-- q2 root split followed by q2-controlled preparation of q1; q0 stays zero. -/
noncomputable def sparsePrunedCircuit : PrimitiveCircuit 3 :=
  [PrimitiveGate.ry (2 : Fin 3) ryAngle513] ++
    compileUniformlyControlledRy 1 sparseControlWire (1 : Fin 3)
      sparseControlWire_ne_target sparseConditionalAngles

theorem sparsePruned_prepares_target :
    applyVec (evalPrimitiveCircuitLE sparsePrunedCircuit) (zeroKet 3) =
      sparseThreeTarget.amplitudes := by
  rw [applyVec_zeroKet]
  funext row
  change evalPrimitiveCircuitLE sparsePrunedCircuit row (0 : Fin 8) =
    sparseThreeState row
  unfold sparsePrunedCircuit
  rw [evalPrimitiveCircuitLE_append]
  change
    (evalPrimitiveCircuitLE
        (compileUniformlyControlledRy 1 sparseControlWire (1 : Fin 3)
          sparseControlWire_ne_target sparseConditionalAngles) *
      evalPrimitiveCircuitLE [PrimitiveGate.ry (2 : Fin 3) ryAngle513])
      row (0 : Fin 8) = sparseThreeState row
  rw [_root_.Matrix.mul_apply, Finset.sum_fin_eq_sum_range]
  fin_cases row <;>
    norm_num [gridSize, Finset.sum_range_succ,
      evalPrimitiveCircuitLE_singleton_ry_apply,
      evalPrimitiveCircuitLE_compileUniformlyControlledRy_apply,
      sparseConditionalAngles, sparseControlWire, sparseControlWire_ne_target,
      primitiveControlAssignment, primitiveLEBits,
      primitiveBasisLEEquiv_three_symm, primitiveBits3LE,
      primitiveBits3LEWithout, splitPrimitiveWire_primitiveBits3LE_context_eq,
      standardRyMatrix_ryAngle35_explicit,
      standardRyMatrix_ryAngle513_explicit, standardRyMatrix_ryAngleZero,
      realOrthogonalRotation, sparseThreeState]

noncomputable def sparsePrunedRoute : ExactPrimitiveStatePreparationRoute 3 where
  target := sparseThreeTarget
  circuit := sparsePrunedCircuit
  normalizationProof := sparseThreeTarget_normalized
  preparationProof := sparsePruned_prepares_target

/-! ### Structure-blind dense-tree baseline

The extra two-control UCRY targets q0 with four zero angles. Its exact matrix
is identity, but the reference compiler still emits four RY and six CX gates.
Thus the baseline has the same semantics and deliberately pays for a zero
amplitude subtree.
-/

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
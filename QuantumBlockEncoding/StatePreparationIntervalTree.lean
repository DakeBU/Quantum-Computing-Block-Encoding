import QuantumBlockEncoding.ComparatorIncrementer
import QuantumBlockEncoding.PrimitiveBasisLE
import QuantumBlockEncoding.StatePreparationPrimitiveRoutes
import Mathlib.Tactic

/-!
# First interval-tree State Preparation routing case

This module plugs the exact `< 3` reversible selector into a concrete State
Preparation route.  The address amplitudes are the already-certified
Grover--Rudolph product benchmark `(9,12,12,16)/25`.  Two additional wires are
initially clean: a work flag and a target bit.  The selector maps

* address 0,1,2 to target bit 1;
* address 3 to target bit 0;
* the work flag back to 0.

The resulting four-qubit target has amplitudes `9/25,12/25,12/25,16/25` at
flat little-endian indices `8,9,10,3`, respectively.

The routing stage, its unitarity, its explicit amplitudes, and its primitive
cost are exact.  A later leaf will package the already-certified two-qubit
address preparer as an explicit four-wire clean-ancilla extension, closing the
single `|0^4> -> target` certificate without changing this routing theorem.
-/

namespace QuantumBlockEncoding
namespace StatePreparationIntervalTree

open ConcreteSemantics
open Robin.ComplexLCU

noncomputable def intervalAddressInputState : StateVector (gridSize 4) ℂ :=
  fun index =>
    match index.val with
    | 0 => (9 : ℂ) / 25
    | 1 => (12 : ℂ) / 25
    | 2 => (12 : ℂ) / 25
    | 3 => (16 : ℂ) / 25
    | _ => 0

noncomputable def intervalTreeTargetState : StateVector (gridSize 4) ℂ :=
  fun index =>
    match index.val with
    | 3 => (16 : ℂ) / 25
    | 8 => (9 : ℂ) / 25
    | 9 => (12 : ℂ) / 25
    | 10 => (12 : ℂ) / 25
    | _ => 0

noncomputable def intervalTreeTarget : StatePreparationTarget ℂ 4 where
  amplitudes := intervalTreeTargetState
  normalization :=
    ∑ index, Complex.normSq (intervalTreeTargetState index) = 1
  source :=
    "ASPBE interval-tree routing benchmark: Grover--Rudolph product address plus x<3 selector"

theorem intervalAddressInput_normalized :
    ∑ index, Complex.normSq (intervalAddressInputState index) = 1 := by
  change ∑ index : Fin 16, Complex.normSq (intervalAddressInputState index) = 1
  rw [Finset.sum_fin_eq_sum_range]
  norm_num [intervalAddressInputState, Complex.normSq_apply,
    Finset.sum_range_succ]

theorem intervalTreeTarget_normalized : intervalTreeTarget.normalization := by
  change ∑ index : Fin 16, Complex.normSq (intervalTreeTargetState index) = 1
  rw [Finset.sum_fin_eq_sum_range]
  norm_num [intervalTreeTargetState, Complex.normSq_apply,
    Finset.sum_range_succ]

/-- Embed a two-bit little-endian address index into the low two wires of the
four-wire interval route. -/
def liftAddressIndex (index : Fin (gridSize 2)) : Fin (gridSize 4) :=
  ⟨index.val, by
    have bound := index.isLt
    norm_num [gridSize] at bound ⊢
    omega⟩

/-- The input amplitudes are exactly the existing two-qubit
Grover--Rudolph product target, with two clean high wires appended. -/
theorem intervalAddressInput_agrees_groverRudolph
    (index : Fin (gridSize 2)) :
    intervalAddressInputState (liftAddressIndex index) =
      StatePreparationBenchmarks.groverRudolphProductTarget.amplitudes index := by
  fin_cases index <;>
    norm_num [liftAddressIndex, intervalAddressInputState,
      StatePreparationBenchmarks.groverRudolphProductTarget,
      StatePreparationBenchmarks.groverRudolphProductState, gridSize]

/-! ## Transport the proved reversible selector to the flat little-endian backend -/

def flatTransportEquiv {qubits : Nat}
    (equiv : PrimitiveBasis qubits ≃ PrimitiveBasis qubits) :
    Fin (gridSize qubits) ≃ Fin (gridSize qubits) :=
  (primitiveBasisLEEquiv qubits).symm.trans
    (equiv.trans (primitiveBasisLEEquiv qubits))

theorem reindex_equivPermutationMatrix {qubits : Nat}
    (equiv : PrimitiveBasis qubits ≃ PrimitiveBasis qubits) :
    _root_.Matrix.reindexAlgEquiv ℂ ℂ (primitiveBasisLEEquiv qubits)
        (equivPermutationMatrix equiv) =
      equivPermutationMatrix (flatTransportEquiv equiv) := by
  ext row column
  simp only [_root_.Matrix.reindexAlgEquiv_apply,
    _root_.Matrix.reindex_apply, _root_.Matrix.submatrix_apply]
  change
    (if (primitiveBasisLEEquiv qubits).symm row =
          equiv ((primitiveBasisLEEquiv qubits).symm column)
      then 1 else 0) =
    (if row = primitiveBasisLEEquiv qubits
          (equiv ((primitiveBasisLEEquiv qubits).symm column))
      then 1 else 0)
  by_cases hit :
      (primitiveBasisLEEquiv qubits).symm row =
        equiv ((primitiveBasisLEEquiv qubits).symm column)
  · have flatHit :
        row = primitiveBasisLEEquiv qubits
          (equiv ((primitiveBasisLEEquiv qubits).symm column)) := by
      calc
        row = primitiveBasisLEEquiv qubits
            ((primitiveBasisLEEquiv qubits).symm row) :=
          ((primitiveBasisLEEquiv qubits).apply_symm_apply row).symm
        _ = primitiveBasisLEEquiv qubits
            (equiv ((primitiveBasisLEEquiv qubits).symm column)) :=
          congrArg (primitiveBasisLEEquiv qubits) hit
    simp [hit, flatHit]
  · have flatMiss :
        row ≠ primitiveBasisLEEquiv qubits
          (equiv ((primitiveBasisLEEquiv qubits).symm column)) := by
      intro flatHit
      apply hit
      apply (primitiveBasisLEEquiv qubits).injective
      simpa using flatHit
    simp [hit, flatMiss]

noncomputable def intervalSelectorMatrix :
    FiniteMatrix (gridSize 4) (gridSize 4) ℂ :=
  _root_.Matrix.reindexAlgEquiv ℂ ℂ (primitiveBasisLEEquiv 4)
    (evalPrimitiveProgram
      ComparatorIncrementer.intervalLtThreeSelectPrimitive)

def intervalSelectorFlatEquiv :
    Fin (gridSize 4) ≃ Fin (gridSize 4) :=
  flatTransportEquiv
    (evalReversibleProgram
      ComparatorIncrementer.intervalLtThreeSelectProgram)

theorem intervalSelectorMatrix_eq_permutation :
    intervalSelectorMatrix =
      equivPermutationMatrix intervalSelectorFlatEquiv := by
  unfold intervalSelectorMatrix intervalSelectorFlatEquiv
  rw [ComparatorIncrementer.intervalLtThreeSelectPrimitive_exact]
  exact reindex_equivPermutationMatrix _

theorem intervalSelectorMatrix_unitary :
    intervalSelectorMatrix ∈
      _root_.Matrix.unitaryGroup (Fin (gridSize 4)) ℂ := by
  unfold intervalSelectorMatrix
  exact reindex_unitary (primitiveBasisLEEquiv 4) _
    (evalPrimitiveProgram_unitary
      ComparatorIncrementer.intervalLtThreeSelectPrimitive)

/-! The four occupied input basis states are routed to the claimed interval
support.  These are finite permutation facts and are kernel-reducible. -/

@[simp] theorem intervalSelectorFlatEquiv_0 :
    intervalSelectorFlatEquiv (0 : Fin (gridSize 4)) = 8 := by native_decide
@[simp] theorem intervalSelectorFlatEquiv_1 :
    intervalSelectorFlatEquiv (1 : Fin (gridSize 4)) = 9 := by native_decide
@[simp] theorem intervalSelectorFlatEquiv_2 :
    intervalSelectorFlatEquiv (2 : Fin (gridSize 4)) = 10 := by native_decide
@[simp] theorem intervalSelectorFlatEquiv_3 :
    intervalSelectorFlatEquiv (3 : Fin (gridSize 4)) = 3 := by native_decide

noncomputable def intervalAddressInputSparse : StateVector (gridSize 4) ℂ :=
  ((9 : ℂ) / 25) • basisKet (gridSize 4) 0 +
  ((12 : ℂ) / 25) • basisKet (gridSize 4) 1 +
  ((12 : ℂ) / 25) • basisKet (gridSize 4) 2 +
  ((16 : ℂ) / 25) • basisKet (gridSize 4) 3

noncomputable def intervalTreeTargetSparse : StateVector (gridSize 4) ℂ :=
  ((9 : ℂ) / 25) • basisKet (gridSize 4) 8 +
  ((12 : ℂ) / 25) • basisKet (gridSize 4) 9 +
  ((12 : ℂ) / 25) • basisKet (gridSize 4) 10 +
  ((16 : ℂ) / 25) • basisKet (gridSize 4) 3

theorem intervalAddressInputState_eq_sparse :
    intervalAddressInputState = intervalAddressInputSparse := by
  funext row
  fin_cases row <;>
    norm_num [intervalAddressInputState, intervalAddressInputSparse,
      basisKet_apply, gridSize]

theorem intervalTreeTargetState_eq_sparse :
    intervalTreeTargetState = intervalTreeTargetSparse := by
  funext row
  fin_cases row <;>
    norm_num [intervalTreeTargetState, intervalTreeTargetSparse,
      basisKet_apply, gridSize]

theorem applyVec_add
    (operator : FiniteMatrix (gridSize 4) (gridSize 4) ℂ)
    (left right : StateVector (gridSize 4) ℂ) :
    applyVec operator (left + right) =
      applyVec operator left + applyVec operator right := by
  unfold applyVec
  exact _root_.Matrix.mulVec_add operator left right

theorem applyVec_smul
    (operator : FiniteMatrix (gridSize 4) (gridSize 4) ℂ)
    (scalar : ℂ) (state : StateVector (gridSize 4) ℂ) :
    applyVec operator (scalar • state) =
      scalar • applyVec operator state := by
  unfold applyVec
  exact _root_.Matrix.mulVec_smul operator scalar state

theorem equivPermutationMatrix_col_eq_basisKet
    (equiv : Fin (gridSize 4) ≃ Fin (gridSize 4))
    (column : Fin (gridSize 4)) :
    (equivPermutationMatrix equiv).col column =
      basisKet (gridSize 4) (equiv column) := by
  funext row
  simp [equivPermutationMatrix, basisKet_apply, eq_comm]

/-- Exact state-routing theorem for the first interval-tree case. -/
theorem intervalSelector_routes_input :
    applyVec intervalSelectorMatrix intervalAddressInputState =
      intervalTreeTargetState := by
  rw [intervalAddressInputState_eq_sparse,
    intervalTreeTargetState_eq_sparse,
    intervalSelectorMatrix_eq_permutation]
  simp only [intervalAddressInputSparse, intervalTreeTargetSparse,
    applyVec_add, applyVec_smul, applyVec_basisKet,
    equivPermutationMatrix_col_eq_basisKet,
    intervalSelectorFlatEquiv_0, intervalSelectorFlatEquiv_1,
    intervalSelectorFlatEquiv_2, intervalSelectorFlatEquiv_3]

/-- The selector portion of the route has an exact primitive cost certificate.
The already-certified two-qubit address preparation is accounted separately
until its four-wire clean extension is packaged. -/
theorem intervalSelector_compilationCost :
    ComparatorIncrementer.compilationCost
        ComparatorIncrementer.intervalLtThreeSelectProgram 1 =
      {
        logicalX := 2,
        logicalCnot := 1,
        logicalToffoli := 2,
        tCount := 14,
        primitiveOneQubit := 24,
        primitiveCnot := 13,
        primitiveDepth := 27,
        cleanAncillas := 1
      } :=
  ComparatorIncrementer.intervalLtThreeSelect_compilationCost

end StatePreparationIntervalTree
end QuantumBlockEncoding

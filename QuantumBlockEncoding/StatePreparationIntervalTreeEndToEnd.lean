import QuantumBlockEncoding.StatePreparationIntervalTree
import QuantumBlockEncoding.PrimitiveBasisLE4
import Mathlib.Tactic

/-!
# End-to-end interval-tree State Preparation certificate

This file closes the missing clean-extension leaf for the first arithmetic
State Preparation consumer.  The already-certified Grover--Rudolph product
address is prepared directly on low wires 0 and 1 of a four-wire register, then
the exact `< 3` selector routes the target bit while restoring its clean work
flag.

The final matrix is the exact denotation of the same primitive program whose
resource fields are counted below.
-/

namespace QuantumBlockEncoding
namespace StatePreparationIntervalTreeEndToEnd

open ConcreteSemantics
open Robin.ComplexLCU
open StatePreparationIntervalTree

noncomputable def intervalRy1Matrix :
    FiniteMatrix (gridSize 4) (gridSize 4) ℂ :=
  StatePreparationBenchmarks.evalPrimitiveCircuitLE
    [PrimitiveGate.ry (1 : Fin 4) StatePreparationBenchmarks.ryAngle35]

noncomputable def intervalRy0Matrix :
    FiniteMatrix (gridSize 4) (gridSize 4) ℂ :=
  StatePreparationBenchmarks.evalPrimitiveCircuitLE
    [PrimitiveGate.ry (0 : Fin 4) StatePreparationBenchmarks.ryAngle35]

/-- Public finite entry form of the 3-4-5 rotation used by the existing
Grover--Rudolph product route. -/
theorem intervalRy35_apply (row column : Fin 2) :
    standardRyMatrix StatePreparationBenchmarks.ryAngle35.eval row column =
      match row.val, column.val with
      | 0, 0 | 1, 1 => (3 : ℂ) / 5
      | 0, _ => -(4 : ℂ) / 5
      | _, 0 => (4 : ℂ) / 5
      | _, _ => 0 := by
  rw [StatePreparationBenchmarks.standardRyMatrix_ryAngle35]
  fin_cases row <;> fin_cases column <;>
    norm_num [realOrthogonalRotation]

noncomputable def intervalAddressFirstSplit : StateVector (gridSize 4) ℂ :=
  ((3 : ℂ) / 5) • basisKet (gridSize 4) 0 +
  ((4 : ℂ) / 5) • basisKet (gridSize 4) 2

/-- The high two wires stay clean while the first address rotation acts. -/
theorem intervalRy1_zero_action :
    applyVec intervalRy1Matrix (zeroKet 4) = intervalAddressFirstSplit := by
  rw [applyVec_zeroKet]
  funext row
  fin_cases row <;>
    norm_num [intervalRy1Matrix, intervalAddressFirstSplit,
      StatePreparationBenchmarks.evalPrimitiveCircuitLE_singleton_ry_apply,
      StatePreparationBenchmarks.primitiveLEBits,
      primitiveBits4LEGridWithout, intervalRy35_apply,
      basisKet_apply, zeroBasisIndex, gridSize]

/-- The second independent address rotation completes the four-wire clean
extension of the existing two-qubit Grover--Rudolph product preparation. -/
theorem intervalRy0_firstSplit_action :
    applyVec intervalRy0Matrix intervalAddressFirstSplit =
      intervalAddressInputState := by
  unfold intervalAddressFirstSplit
  rw [applyVec_twoBasisSuperposition]
  funext row
  fin_cases row <;>
    norm_num [intervalRy0Matrix, intervalAddressInputState,
      StatePreparationBenchmarks.evalPrimitiveCircuitLE_singleton_ry_apply,
      StatePreparationBenchmarks.primitiveLEBits,
      primitiveBits4LEGridWithout, intervalRy35_apply,
      basisKet_apply, gridSize]

/-- Same two independent rotations as the certified two-qubit factorized
Grover--Rudolph route, embedded on the low address wires of the four-wire case. -/
noncomputable def intervalAddressPrepCircuit : PrimitiveCircuit 4 :=
  [PrimitiveGate.ry (1 : Fin 4) StatePreparationBenchmarks.ryAngle35] ++
    [PrimitiveGate.ry (0 : Fin 4) StatePreparationBenchmarks.ryAngle35]

theorem intervalAddressPrep_prepares_input :
    applyVec
        (StatePreparationBenchmarks.evalPrimitiveCircuitLE
          intervalAddressPrepCircuit)
        (zeroKet 4) =
      intervalAddressInputState := by
  unfold intervalAddressPrepCircuit
  rw [StatePreparationBenchmarks.evalPrimitiveCircuitLE_append]
  unfold applyVec
  rw [← _root_.Matrix.mulVec_mulVec]
  rw [show intervalRy1Matrix.mulVec (zeroKet 4) = intervalAddressFirstSplit by
    simpa [applyVec] using intervalRy1_zero_action]
  simpa [intervalRy0Matrix, applyVec] using intervalRy0_firstSplit_action

noncomputable def intervalAddressPrepProgram : PrimitiveProgram 4 where
  circuit := intervalAddressPrepCircuit
  globalPhase := .rational 0

noncomputable def evalPrimitiveProgramLE {qubits : Nat}
    (program : PrimitiveProgram qubits) :
    FiniteMatrix (gridSize qubits) (gridSize qubits) ℂ :=
  _root_.Matrix.reindexAlgEquiv ℂ ℂ (primitiveBasisLEEquiv qubits)
    (evalPrimitiveProgram program)

theorem evalPrimitiveProgramLE_seq {qubits : Nat}
    (left right : PrimitiveProgram qubits) :
    evalPrimitiveProgramLE (left.seq right) =
      evalPrimitiveProgramLE right * evalPrimitiveProgramLE left := by
  unfold evalPrimitiveProgramLE
  rw [evalPrimitiveProgram_seq, _root_.Matrix.reindexAlgEquiv_mul]

theorem intervalAddressPrepProgram_evalLE :
    evalPrimitiveProgramLE intervalAddressPrepProgram =
      StatePreparationBenchmarks.evalPrimitiveCircuitLE
        intervalAddressPrepCircuit := by
  unfold evalPrimitiveProgramLE intervalAddressPrepProgram
  simp [evalPrimitiveProgram, evalGlobalPhase, ExactAngle.eval,
    StatePreparationBenchmarks.evalPrimitiveCircuitLE]

noncomputable def intervalTreePrimitiveProgram : PrimitiveProgram 4 :=
  intervalAddressPrepProgram.seq
    ComparatorIncrementer.intervalLtThreeSelectPrimitive

noncomputable def intervalTreePrimitiveMatrix :
    FiniteMatrix (gridSize 4) (gridSize 4) ℂ :=
  evalPrimitiveProgramLE intervalTreePrimitiveProgram

theorem intervalTreePrimitiveMatrix_eq_composed :
    intervalTreePrimitiveMatrix =
      intervalSelectorMatrix *
        StatePreparationBenchmarks.evalPrimitiveCircuitLE
          intervalAddressPrepCircuit := by
  unfold intervalTreePrimitiveMatrix intervalTreePrimitiveProgram
  rw [evalPrimitiveProgramLE_seq, intervalAddressPrepProgram_evalLE]
  rfl

theorem intervalTreePrimitiveMatrix_unitary :
    intervalTreePrimitiveMatrix ∈
      _root_.Matrix.unitaryGroup (Fin (gridSize 4)) ℂ := by
  unfold intervalTreePrimitiveMatrix evalPrimitiveProgramLE
  exact reindex_unitary (primitiveBasisLEEquiv 4) _
    (evalPrimitiveProgram_unitary intervalTreePrimitiveProgram)

/-- End-to-end exact preparation from `|0^4>` through address PREPARE and the
clean comparator selector. -/
theorem intervalTreePrimitive_prepares_target :
    applyVec intervalTreePrimitiveMatrix (zeroKet 4) =
      intervalTreeTarget.amplitudes := by
  rw [intervalTreePrimitiveMatrix_eq_composed]
  unfold applyVec
  rw [← _root_.Matrix.mulVec_mulVec]
  rw [show
      (StatePreparationBenchmarks.evalPrimitiveCircuitLE
        intervalAddressPrepCircuit).mulVec (zeroKet 4) =
        intervalAddressInputState by
      simpa [applyVec] using intervalAddressPrep_prepares_input]
  simpa [applyVec, intervalTreeTarget] using intervalSelector_routes_input

noncomputable def intervalTreeCertificate :
    ComplexStatePreparationCertificate 4 where
  target := intervalTreeTarget
  gate := {
    matrix := intervalTreePrimitiveMatrix
    unitary := intervalTreePrimitiveMatrix_unitary
  }
  normalizationProof := intervalTreeTarget_normalized
  preparationProof := intervalTreePrimitive_prepares_target

structure IntervalTreePrimitiveCost where
  tCount : Nat
  primitiveOneQubit : Nat
  primitiveCnot : Nat
  primitiveDepth : Nat
  cleanAncillas : Nat
deriving Repr, DecidableEq

noncomputable def intervalTreePrimitiveCost : IntervalTreePrimitiveCost :=
  {
    tCount := ComparatorIncrementer.PrimitiveCircuit.tCount
      intervalTreePrimitiveProgram.circuit
    primitiveOneQubit := intervalTreePrimitiveProgram.resource.oneQubit
    primitiveCnot := intervalTreePrimitiveProgram.resource.cnot
    primitiveDepth := intervalTreePrimitiveProgram.resource.depth
    cleanAncillas := 1
  }

/-- Unified cost of address PREPARE plus comparator routing.  The two address
rotations overlap the selector's initial work-wire X in the dependency-based
depth schedule, so the total primitive depth remains 27 rather than 28. -/
theorem intervalTreePrimitiveCost_exact :
    intervalTreePrimitiveCost =
      {
        tCount := 14,
        primitiveOneQubit := 26,
        primitiveCnot := 13,
        primitiveDepth := 27,
        cleanAncillas := 1
      } := by
  decide

end StatePreparationIntervalTreeEndToEnd
end QuantumBlockEncoding

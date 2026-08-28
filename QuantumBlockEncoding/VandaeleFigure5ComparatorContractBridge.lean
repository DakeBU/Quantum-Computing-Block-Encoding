import QuantumBlockEncoding.VandaeleComparatorBitArithmetic
import QuantumBlockEncoding.VandaeleFigure5ComparatorFullSemantics
import Mathlib.Tactic

/-!
# Figure 5 source-to-contract bridge

The gate/source audit of Vandaele Figure 5 is now complete: the displayed
34-gate circuit has the reversed predicate `b < a`, while the minimal endpoint
repair (move the two five-X layers from `b` to `a`) restores both data
registers and toggles the flag exactly on `a < b`.

This module closes the remaining representation gap to the canonical
Equation-(17) contract.  It defines an explicit equivalence between the
interleaved eleven source wires

`a0,b0,a1,b1,a2,b2,a3,b3,a4,b4,z`

and `VandaeleComparatorContract.ComparatorState 5`, proves that the two
little-endian register values agree with the source `aValue`/`bValue`, and
transports the already-certified repaired Figure-5 semantics through that
layout equivalence.

No comparison arithmetic or gate semantics is reproved here.  The root theorem
`repairedFigure5_comparatorSpec` says directly that the concrete repaired
34-gate source realizes Equation (17).
-/

namespace QuantumBlockEncoding
namespace VandaeleFigure5ComparatorContractBridge

open VandaeleComparatorContract
open VandaeleComparatorBitArithmetic
open VandaeleFigure4TakahashiSourceProgram
open VandaeleFigure4TakahashiCarryAlgebra
open VandaeleFigure5ComparatorDirection
open VandaeleFigure5ComparatorRepair
open VandaeleFigure5ComparatorFullSemantics

/-- The five even-position source wires, in little-endian order. -/
def sourceLeft (state : SourceBasis) : BitRegister 5 :=
  fun index =>
    match index.val with
    | 0 => state 0
    | 1 => state 2
    | 2 => state 4
    | 3 => state 6
    | _ => state 8

/-- The five odd-position source wires, in little-endian order. -/
def sourceRight (state : SourceBasis) : BitRegister 5 :=
  fun index =>
    match index.val with
    | 0 => state 1
    | 1 => state 3
    | 2 => state 5
    | 3 => state 7
    | _ => state 9

/-- Read the interleaved Figure-5 source layout as the canonical Equation-(17)
comparator state. -/
def sourceToComparatorState (state : SourceBasis) : ComparatorState 5 where
  left := sourceLeft state
  right := sourceRight state
  flag := state 10

/-- Write a canonical five-bit comparator state back into the exact source wire
order used by Figures 4 and 5. -/
def comparatorStateToSource (state : ComparatorState 5) : SourceBasis :=
  sourceState
    (state.left 0) (state.right 0)
    (state.left 1) (state.right 1)
    (state.left 2) (state.right 2)
    (state.left 3) (state.right 3)
    (state.left 4) (state.right 4)
    state.flag

/-- Local extensionality helper for the pure three-field comparator contract. -/
theorem comparatorState_ext {n : Nat} {leftState rightState : ComparatorState n}
    (leftEq : leftState.left = rightState.left)
    (rightEq : leftState.right = rightState.right)
    (flagEq : leftState.flag = rightState.flag) :
    leftState = rightState := by
  rcases leftState with ⟨left₁, right₁, flag₁⟩
  rcases rightState with ⟨left₂, right₂, flag₂⟩
  cases leftEq
  cases rightEq
  cases flagEq
  rfl

/-- Reading after writing the interleaved source layout is exact. -/
theorem sourceToComparator_comparatorStateToSource
    (state : ComparatorState 5) :
    sourceToComparatorState (comparatorStateToSource state) = state := by
  apply comparatorState_ext
  · funext index
    fin_cases index <;> rfl
  · funext index
    fin_cases index <;> rfl
  · rfl

/-- Writing after reading the interleaved source layout is exact. -/
theorem comparatorStateToSource_sourceToComparator
    (state : SourceBasis) :
    comparatorStateToSource (sourceToComparatorState state) = state := by
  simpa [comparatorStateToSource, sourceToComparatorState, sourceLeft,
    sourceRight] using sourceState_eta state

/-- The interleaved Figure-5 wire order and the canonical five-bit comparator
state are equivalent representations of the same computational basis. -/
def sourceComparatorEquiv : SourceBasis ≃ ComparatorState 5 where
  toFun := sourceToComparatorState
  invFun := comparatorStateToSource
  left_inv := comparatorStateToSource_sourceToComparator
  right_inv := sourceToComparator_comparatorStateToSource

/-- The canonical left-register value is exactly the source `aValue`. -/
theorem sourceLeft_littleEndianValue (state : SourceBasis) :
    littleEndianValue (sourceLeft state) = aValue state := by
  rw [littleEndianValue_succ]
  rw [littleEndianValue_succ]
  rw [littleEndianValue_succ]
  rw [littleEndianValue_succ]
  rw [littleEndianValue_succ]
  simp [littleEndianValue, tailBits, sourceLeft, aValue]
  ring

/-- The canonical right-register value is exactly the source `bValue`. -/
theorem sourceRight_littleEndianValue (state : SourceBasis) :
    littleEndianValue (sourceRight state) = bValue state := by
  rw [littleEndianValue_succ]
  rw [littleEndianValue_succ]
  rw [littleEndianValue_succ]
  rw [littleEndianValue_succ]
  rw [littleEndianValue_succ]
  simp [littleEndianValue, tailBits, sourceRight, bValue]
  ring

@[simp] theorem sourceLeft_comparatorStateToSource
    (state : ComparatorState 5) :
    sourceLeft (comparatorStateToSource state) = state.left := by
  funext index
  fin_cases index <;> rfl

@[simp] theorem sourceRight_comparatorStateToSource
    (state : ComparatorState 5) :
    sourceRight (comparatorStateToSource state) = state.right := by
  funext index
  fin_cases index <;> rfl

/-- Source and contract agree on the numeric left operand. -/
theorem aValue_comparatorStateToSource (state : ComparatorState 5) :
    aValue (comparatorStateToSource state) = littleEndianValue state.left := by
  rw [← sourceLeft_littleEndianValue]
  simp

/-- Source and contract agree on the numeric right operand. -/
theorem bValue_comparatorStateToSource (state : ComparatorState 5) :
    bValue (comparatorStateToSource state) = littleEndianValue state.right := by
  rw [← sourceRight_littleEndianValue]
  simp

/-- XOR with the certified strict-comparison bit is exactly the flag action used
by Equation (17). -/
theorem xorBit_strictLtBit_eq_contractFlag
    (flag : Fin 2) (left right : Nat) :
    xorBit flag (strictLtBit left right) =
      if left < right then flipFlag flag else flag := by
  by_cases less : left < right
  · have comparisonBit : strictLtBit left right = 1 := by
      simp [strictLtBit, less]
    rw [comparisonBit, if_pos less]
    fin_cases flag <;> native_decide
  · simp [strictLtBit, less]

/-- Transport the concrete repaired Figure-5 source action into the canonical
five-bit comparator representation. -/
theorem repairedFigure5_transport
    (state : ComparatorState 5) :
    sourceToComparatorState
        (evalReversibleProgram repairedFigure5Program
          (comparatorStateToSource state)) =
      equationSeventeenAction state := by
  rw [repairedFigure5_full_semantics]
  apply comparatorState_ext
  · funext index
    fin_cases index <;> rfl
  · funext index
    fin_cases index <;> rfl
  · change
      xorBit state.flag
          (strictLtBit
            (aValue (comparatorStateToSource state))
            (bValue (comparatorStateToSource state))) =
        if littleEndianValue state.left < littleEndianValue state.right then
          flipFlag state.flag
        else state.flag
    rw [aValue_comparatorStateToSource, bValue_comparatorStateToSource]
    exact xorBit_strictLtBit_eq_contractFlag state.flag
      (littleEndianValue state.left) (littleEndianValue state.right)

/-- The exact repaired Figure-5 source action, expressed directly in the
canonical Equation-(17) representation.  The source evaluator and the layout
map are separately certified equivalences; this function form matches the
minimal `ComparatorSpec` interface without forcing Lean to elaborate a deeply
nested `Equiv.trans`. -/
def repairedFigure5ComparatorAction
    (state : ComparatorState 5) : ComparatorState 5 :=
  sourceToComparatorState
    (evalReversibleProgram repairedFigure5Program
      (comparatorStateToSource state))

/-- Root source-to-contract theorem: the concrete repaired 34-gate Figure-5
program realizes Vandaele Equation (17) on every five-bit computational-basis
comparator state. -/
theorem repairedFigure5_comparatorSpec :
    ComparatorSpec repairedFigure5ComparatorAction := by
  intro state
  exact repairedFigure5_transport state

/-- Reader-facing certificate pairing exact source resources with the canonical
Equation-(17) functional specification. -/
theorem repairedFigure5_source_certificate :
    ComparatorSpec repairedFigure5ComparatorAction ∧
      repairedFigure5Program.length = 34 :=
  ⟨repairedFigure5_comparatorSpec, repairedFigure5_gateCount⟩

end VandaeleFigure5ComparatorContractBridge
end QuantumBlockEncoding

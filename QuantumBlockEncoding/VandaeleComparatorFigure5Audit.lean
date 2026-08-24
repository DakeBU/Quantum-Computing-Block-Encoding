import QuantumBlockEncoding.VandaeleComparatorContract
import QuantumBlockEncoding.VandaeleVOperator
import Mathlib.Tactic

/-!
# Source audit for Vandaele Figure 5

This file deliberately starts with the smallest source-faithful specialization
of the quantum--quantum comparator shown in Figure 5 of Vandaele (2026).

For one-bit inputs, the two outer CX ladders and the parallel CX layers are
empty.  The displayed circuit therefore consists only of the X conjugation on
`b`, the middle `V₂^(1)` block, and the inverse X conjugation on `b`.

We do **not** change the Figure-5 wiring to make it agree with Equation (17).
Instead we encode the displayed one-bit circuit literally and compare it with
the already-formalized Equation-(17) contract.  Any mismatch is therefore a
source-audit result, not a replacement theorem.
-/

namespace QuantumBlockEncoding
namespace VandaeleComparatorFigure5Audit

open VandaeleLadderContract
open VandaeleVOperator

/-- Figure-5 slice 1 at `n=1`: the only surviving outer operation is X on `b`.
The physical V2 register is `[a₀, X b₀, z]`, represented as the initial pivot
plus one `(fresh-control,target)` ladder block. -/
def oneBitFigureFivePreprocess
    (state : VandaeleComparatorContract.ComparatorState 1) :
    LadderState 1 1 :=
  (state.left 0,
    fun _ =>
      (fun _ => VandaeleComparatorContract.flipFlag (state.right 0),
        state.flag))

/-- Figure-5 slice 2 at `n=1`, using the existing proof-bearing `V₂` operator
rather than introducing a second semantic oracle. -/
def oneBitFigureFiveMiddle
    (state : VandaeleComparatorContract.ComparatorState 1) :
    LadderState 1 1 :=
  sourceV2SuccEquiv 0 (oneBitFigureFivePreprocess state)

/-- Decode the one-bit Figure-5 output after the final X on `b`. -/
def oneBitFigureFiveAction
    (state : VandaeleComparatorContract.ComparatorState 1) :
    VandaeleComparatorContract.ComparatorState 1 :=
  let output := oneBitFigureFiveMiddle state
  { left := fun _ => output.1
    right := fun _ =>
      VandaeleComparatorContract.flipFlag ((output.2 0).1 0)
    flag := (output.2 0).2 }

/-- Canonical one-bit comparator input used to exhaust the source truth table. -/
def oneBitState (a b z : Fin 2) :
    VandaeleComparatorContract.ComparatorState 1 :=
  { left := fun _ => a
    right := fun _ => b
    flag := z }

/-- The literal Figure-5 one-bit specialization restores the left input bit. -/
theorem oneBitFigureFive_preserves_left
    (a b z : Fin 2) :
    (oneBitFigureFiveAction (oneBitState a b z)).left =
      (oneBitState a b z).left := by
  funext index
  fin_cases index
  fin_cases a <;> fin_cases b <;> fin_cases z <;> native_decide

/-- The literal Figure-5 one-bit specialization restores the right input bit. -/
theorem oneBitFigureFive_preserves_right
    (a b z : Fin 2) :
    (oneBitFigureFiveAction (oneBitState a b z)).right =
      (oneBitState a b z).right := by
  funext index
  fin_cases index
  fin_cases a <;> fin_cases b <;> fin_cases z <;> native_decide

/-- Complete one-bit source orientation certificate.  Under the literal Figure-5
wiring, the flag is toggled iff `b < a`, i.e. iff `a > b`. -/
theorem oneBitFigureFive_flag_truthTable
    (a b z : Fin 2) :
    (oneBitFigureFiveAction (oneBitState a b z)).flag =
      if b.val < a.val then
        VandaeleComparatorContract.flipFlag z
      else z := by
  fin_cases a <;> fin_cases b <;> fin_cases z <;> native_decide

/-- In contrast, the already-formalized Equation (17) contract toggles iff
`a < b`.  This theorem puts both orientations in the same one-bit notation. -/
theorem equationSeventeen_oneBit_flag_truthTable
    (a b z : Fin 2) :
    (VandaeleComparatorContract.equationSeventeenAction
      (oneBitState a b z)).flag =
      if a.val < b.val then
        VandaeleComparatorContract.flipFlag z
      else z := by
  fin_cases a <;> fin_cases b <;> fin_cases z <;> native_decide

/-- Concrete source-audit input `a=1, b=0, z=0`. -/
def oneBitAOneBZero : VandaeleComparatorContract.ComparatorState 1 :=
  oneBitState 1 0 0

/-- Concrete input in the opposite ordering. -/
def oneBitAZeroBOne : VandaeleComparatorContract.ComparatorState 1 :=
  oneBitState 0 1 0

/-- The literal one-bit Figure-5 circuit toggles the flag on `a=1,b=0,z=0`. -/
theorem oneBitFigureFive_aOne_bZero_flag :
    (oneBitFigureFiveAction oneBitAOneBZero).flag = 1 := by
  native_decide

/-- Equation (17), whose contract is `a<b`, leaves the flag unchanged on the
same input. -/
theorem equationSeventeen_aOne_bZero_flag :
    (VandaeleComparatorContract.equationSeventeenAction
      oneBitAOneBZero).flag = 0 := by
  native_decide

/-- The opposite ordering makes the orientation mismatch visible in the other
direction as well: literal Figure 5 does not toggle on `a=0,b=1`. -/
theorem oneBitFigureFive_aZero_bOne_flag :
    (oneBitFigureFiveAction oneBitAZeroBOne).flag = 0 := by
  native_decide

/-- Equation (17) does toggle on that opposite ordering. -/
theorem equationSeventeen_aZero_bOne_flag :
    (VandaeleComparatorContract.equationSeventeenAction
      oneBitAZeroBOne).flag = 1 := by
  native_decide

/-- Therefore the displayed one-bit Figure-5 specialization does not inhabit
the current source Equation-(17) comparator contract under this explicit
little-endian register interpretation. -/
theorem oneBitFigureFive_not_equationSeventeen :
    oneBitFigureFiveAction oneBitAOneBZero ≠
      VandaeleComparatorContract.equationSeventeenAction oneBitAOneBZero := by
  intro equal
  have flagEqual :=
    congrArg VandaeleComparatorContract.ComparatorState.flag equal
  rw [oneBitFigureFive_aOne_bZero_flag,
    equationSeventeen_aOne_bZero_flag] at flagEqual
  have oneNeZero : (1 : Fin 2) ≠ 0 := by decide
  exact oneNeZero flagEqual

/-- Contract-level form of the same source audit. -/
theorem oneBitFigureFive_not_ComparatorSpec :
    ¬ VandaeleComparatorContract.ComparatorSpec oneBitFigureFiveAction := by
  intro spec
  exact oneBitFigureFive_not_equationSeventeen (spec oneBitAOneBZero)

end VandaeleComparatorFigure5Audit
end QuantumBlockEncoding

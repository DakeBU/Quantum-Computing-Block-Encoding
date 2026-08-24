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

/-- Concrete source-audit input `a=1, b=0, z=0`. -/
def oneBitAOneBZero : VandaeleComparatorContract.ComparatorState 1 :=
  { left := fun _ => 1
    right := fun _ => 0
    flag := 0 }

/-- Concrete input in the opposite ordering, retained for the next generic
orientation audit. -/
def oneBitAZeroBOne : VandaeleComparatorContract.ComparatorState 1 :=
  { left := fun _ => 0
    right := fun _ => 1
    flag := 0 }

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

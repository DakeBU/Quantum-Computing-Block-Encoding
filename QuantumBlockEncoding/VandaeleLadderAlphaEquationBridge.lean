import QuantumBlockEncoding.VandaeleLadderAlphaActivationBridge
import Mathlib.Tactic

/-!
# Action bridge: regular Vandaele Equation (5) = general-alpha Equation (7)

The representation and activation layers are now fixed.  This file closes the
semantic square itself:

`equationSevenAction regularAlphaPlan (flattenLadderState state)`

is exactly

`flattenLadderState (equationFiveAction state)`.

The proof classifies every physical wire as the initial pivot, one fresh
control, or one block target.  Equation (7) preserves the first two classes and
on the target class its interval predicate is the already-verified
Equation-(5) ladder predicate.
-/

namespace QuantumBlockEncoding
namespace VandaeleLadderAlphaEquationBridge

open VandaeleLadderAlphaRepresentation
open VandaeleLadderAlphaActivationBridge
open VandaeleLadderContract
open RemaudVandaeleLadderAlphaContract

/-- Decoding and then re-encoding a block-major tail coordinate is exact. -/
@[simp] theorem blockTailIndex_decodeTail
    {localControls steps : Nat}
    (tail : Fin (steps * blockWidth localControls)) :
    blockTailIndex (decodeTail tail).1 (decodeTail tail).2 = tail := by
  simpa [blockTailIndex, decodeTail] using
    (Equiv.apply_symm_apply finProdFinEquiv tail)

/-- No regular alpha target is the leading pivot wire. -/
theorem regularTarget_ne_pivotWire
    {localControls steps : Nat} (block : Fin steps) :
    regularTarget (localControls := localControls) block ≠
      pivotWire localControls steps := by
  intro equal
  have values := congrArg Fin.val equal
  simp [regularTarget, blockWire, pivotWire] at values

/-- A fresh-control slot can never coincide with any regular alpha target. -/
theorem regularTarget_ne_regularFreshWire
    {localControls steps : Nat}
    (query block : Fin steps) (control : Fin localControls) :
    regularTarget (localControls := localControls) query ≠
      regularFreshWire block control := by
  intro equal
  change
    (blockTailIndex query (targetOffset localControls)).succ =
      (blockTailIndex block (freshOffset control)).succ at equal
  have tailEqual :
      blockTailIndex query (targetOffset localControls) =
        blockTailIndex block (freshOffset control) :=
    Fin.succ_injective _ equal
  have coordinateEqual :
      (query, targetOffset localControls) =
        (block, freshOffset control) := by
    have decoded := congrArg decodeTail tailEqual
    simpa using decoded
  have offsetEqual := congrArg Prod.snd coordinateEqual
  have valueEqual := congrArg Fin.val offsetEqual
  simp [targetOffset, freshOffset] at valueEqual
  omega

/-- Every physical wire in the flattened regular ladder is exactly one of:
initial pivot, a fresh control, or a block target. -/
theorem regularPhysicalWire_cases
    {localControls steps : Nat}
    (wire : Fin (physicalQ localControls steps)) :
    wire = pivotWire localControls steps ∨
      ∃ block : Fin steps,
        (∃ control : Fin localControls,
          wire = regularFreshWire block control) ∨
        wire = regularTarget (localControls := localControls) block := by
  unfold physicalQ at wire ⊢
  refine Fin.cases ?_ (fun tail => ?_) wire
  · left
    apply Fin.ext
    rfl
  · let coordinates := decodeTail tail
    let block := coordinates.1
    let offset := coordinates.2
    have recovered : blockTailIndex block offset = tail := by
      dsimp [block, offset, coordinates]
      exact blockTailIndex_decodeTail tail
    right
    refine ⟨block, ?_⟩
    by_cases fresh : offset.val < localControls
    · left
      let control : Fin localControls := ⟨offset.val, fresh⟩
      have offsetEqual : freshOffset control = offset := by
        apply Fin.ext
        rfl
      refine ⟨control, ?_⟩
      apply Fin.ext
      simp [regularFreshWire, blockWire, recovered, offsetEqual]
    · right
      have offsetValue : offset.val = localControls := by
        have offsetLt := offset.isLt
        simp [blockWidth] at offsetLt
        omega
      have offsetEqual : offset = targetOffset localControls := by
        apply Fin.ext
        simpa [targetOffset] using offsetValue
      change tail.succ =
        (blockTailIndex block (targetOffset localControls)).succ
      rw [← recovered, offsetEqual]

/-- Equation (7) preserves the initial pivot, matching Equation (5). -/
theorem equationSeven_regular_pivot
    {localControls steps : Nat}
    (state : LadderState localControls steps) :
    equationSevenAction (regularAlphaPlan localControls steps)
        (flattenLadderState state) (pivotWire localControls steps) =
      flattenLadderState
        (equationFiveAction localControls steps state)
        (pivotWire localControls steps) := by
  have miss :
      ¬ ∃ block : Fin steps,
        (regularAlphaPlan localControls steps).target block =
          pivotWire localControls steps := by
    rintro ⟨block, target⟩
    exact regularTarget_ne_pivotWire block target
  calc
    equationSevenAction (regularAlphaPlan localControls steps)
        (flattenLadderState state) (pivotWire localControls steps) =
        flattenLadderState state (pivotWire localControls steps) :=
      equationSeven_nonTarget _ _ _ miss
    _ = flattenLadderState
        (equationFiveAction localControls steps state)
        (pivotWire localControls steps) := by simp

/-- Equation (7) preserves every fresh control, matching Equation (5). -/
theorem equationSeven_regular_fresh
    {localControls steps : Nat}
    (state : LadderState localControls steps)
    (block : Fin steps) (control : Fin localControls) :
    equationSevenAction (regularAlphaPlan localControls steps)
        (flattenLadderState state) (regularFreshWire block control) =
      flattenLadderState
        (equationFiveAction localControls steps state)
        (regularFreshWire block control) := by
  have miss :
      ¬ ∃ query : Fin steps,
        (regularAlphaPlan localControls steps).target query =
          regularFreshWire block control := by
    rintro ⟨query, target⟩
    exact regularTarget_ne_regularFreshWire query block control target
  calc
    equationSevenAction (regularAlphaPlan localControls steps)
        (flattenLadderState state) (regularFreshWire block control) =
        flattenLadderState state (regularFreshWire block control) :=
      equationSeven_nonTarget _ _ _ miss
    _ = flattenLadderState
        (equationFiveAction localControls steps state)
        (regularFreshWire block control) := by simp

/-- On each block target, Equation (7) and Equation (5) use the same original
input bit and the same verified activation predicate. -/
theorem equationSeven_regular_target
    {localControls steps : Nat}
    (state : LadderState localControls steps) (block : Fin steps) :
    equationSevenAction (regularAlphaPlan localControls steps)
        (flattenLadderState state)
        (regularTarget (localControls := localControls) block) =
      flattenLadderState
        (equationFiveAction localControls steps state)
        (regularTarget (localControls := localControls) block) := by
  have targetFormula := equationSeven_target
    (regularAlphaPlan localControls steps)
    (flattenLadderState state) block
  rw [regular_intervalActive_iff_ladderActive state block] at targetFormula
  simpa using targetFormula

/-- Commuting semantic square for the regular ladder specialization:
flattening Equation (5) is exactly general-alpha Equation (7). -/
theorem equationSeven_regular_eq_flatten_equationFive
    (localControls steps : Nat)
    (state : LadderState localControls steps) :
    equationSevenAction (regularAlphaPlan localControls steps)
        (flattenLadderState state) =
      flattenLadderState (equationFiveAction localControls steps state) := by
  funext wire
  rcases regularPhysicalWire_cases wire with
    pivot | ⟨block, fresh | target⟩
  · rw [pivot]
    exact equationSeven_regular_pivot state
  · rcases fresh with ⟨control, equal⟩
    rw [equal]
    exact equationSeven_regular_fresh state block control
  · rw [target]
    exact equationSeven_regular_target state block

/-- Reader-facing statement: regular Vandaele Equation (5) is the structured
special case of general-alpha Equation (7) under the canonical flattening. -/
theorem equationFive_is_regular_equationSeven
    (localControls steps : Nat)
    (state : LadderState localControls steps) :
    flattenLadderState (equationFiveAction localControls steps state) =
      equationSevenAction (regularAlphaPlan localControls steps)
        (flattenLadderState state) :=
  (equationSeven_regular_eq_flatten_equationFive
    localControls steps state).symm

end VandaeleLadderAlphaEquationBridge
end QuantumBlockEncoding

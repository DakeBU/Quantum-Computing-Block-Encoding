import QuantumBlockEncoding.RemaudVandaeleLadderAlphaContract
import Mathlib.Logic.Equiv.Fin.Basic
import Mathlib.Tactic

/-!
# Regular Vandaele ladders as general alpha ladders

For a regular ladder with `localControls` fresh controls per block, set

`k = localControls + 1`.

The physical register has `steps * k + 1` wires.  Wire zero is the initial
pivot.  The remaining wires are block-major: each block contributes its
`localControls` fresh controls followed by its target.  Therefore block `i`
has target at physical wire `(i+1)k`, exactly the regular alpha vector needed
to compare Vandaele Equation (5) with the general Definition-6 / Equation-(7)
contract.
-/

namespace QuantumBlockEncoding
namespace VandaeleLadderAlphaRepresentation

open VandaeleLadderContract
open RemaudVandaeleLadderAlphaContract

/-- Width of one regular ladder block: fresh controls plus its target. -/
def blockWidth (localControls : Nat) : Nat := localControls + 1

/-- Total number of physical wires in a regular ladder. -/
def physicalQ (localControls steps : Nat) : Nat :=
  steps * blockWidth localControls + 1

/-- The named initial pivot wire.  Naming it avoids asking typeclass inference
to manufacture a numeral in `Fin (physicalQ ...)` before positivity is known. -/
def pivotWire (localControls steps : Nat) :
    Fin (physicalQ localControls steps) :=
  ⟨0, by simp [physicalQ]⟩

@[simp] theorem pivotWire_val (localControls steps : Nat) :
    (pivotWire localControls steps).val = 0 := rfl

/-- The final position inside a block is its target slot. -/
def targetOffset (localControls : Nat) : Fin (blockWidth localControls) :=
  ⟨localControls, by simp [blockWidth]⟩

/-- Promote one fresh-control offset into the full block coordinate. -/
def freshOffset {localControls : Nat} (control : Fin localControls) :
    Fin (blockWidth localControls) :=
  ⟨control.val, by
    have controlLt := control.isLt
    simp [blockWidth]⟩

/-- Block-major index inside the tail register after the initial pivot. -/
def blockTailIndex
    {localControls steps : Nat}
    (block : Fin steps) (offset : Fin (blockWidth localControls)) :
    Fin (steps * blockWidth localControls) :=
  finProdFinEquiv (block, offset)

/-- Decode one tail-register index back to its block and within-block offset. -/
def decodeTail
    {localControls steps : Nat}
    (tail : Fin (steps * blockWidth localControls)) :
    Fin steps × Fin (blockWidth localControls) :=
  finProdFinEquiv.symm tail

@[simp] theorem decodeTail_blockTailIndex
    {localControls steps : Nat}
    (block : Fin steps) (offset : Fin (blockWidth localControls)) :
    decodeTail (blockTailIndex block offset) = (block, offset) := by
  simp [decodeTail, blockTailIndex]

/-- Physical wire obtained by putting the initial pivot in front of the
block-major tail register. -/
def blockWire
    {localControls steps : Nat}
    (block : Fin steps) (offset : Fin (blockWidth localControls)) :
    Fin (physicalQ localControls steps) := by
  unfold physicalQ
  exact (blockTailIndex block offset).succ

/-- Physical target wire of a regular source block. -/
def regularTarget
    {localControls steps : Nat} (block : Fin steps) :
    Fin (physicalQ localControls steps) :=
  blockWire block (targetOffset localControls)

/-- Physical wire of one fresh control inside a regular source block. -/
def regularFreshWire
    {localControls steps : Nat}
    (block : Fin steps) (control : Fin localControls) :
    Fin (physicalQ localControls steps) :=
  blockWire block (freshOffset control)

@[simp] theorem blockTailIndex_val
    {localControls steps : Nat}
    (block : Fin steps) (offset : Fin (blockWidth localControls)) :
    (blockTailIndex block offset).val =
      offset.val + blockWidth localControls * block.val := by
  simp [blockTailIndex]

@[simp] theorem blockWire_val
    {localControls steps : Nat}
    (block : Fin steps) (offset : Fin (blockWidth localControls)) :
    (blockWire block offset).val =
      offset.val + blockWidth localControls * block.val + 1 := by
  simp [blockWire]

@[simp] theorem regularTarget_val
    {localControls steps : Nat} (block : Fin steps) :
    (regularTarget (localControls := localControls) block).val =
      blockWidth localControls * (block.val + 1) := by
  simp [regularTarget, targetOffset, blockWidth]
  ring

@[simp] theorem regularFreshWire_val
    {localControls steps : Nat}
    (block : Fin steps) (control : Fin localControls) :
    (regularFreshWire block control).val =
      blockWidth localControls * block.val + control.val + 1 := by
  simp [regularFreshWire, freshOffset, blockWidth]
  ring

/-- The regular alpha vector `(k,2k,...,steps*k)`. -/
def regularAlphaPlan (localControls steps : Nat) :
    AlphaPlan (physicalQ localControls steps) steps where
  target := regularTarget
  strict := by
    intro i j hij
    simp only [regularTarget_val]
    have widthPositive : 0 < blockWidth localControls := by
      simp [blockWidth]
    apply (Nat.mul_lt_mul_left widthPositive).2
    omega

/-- Flatten the structured Equation-(5) ladder state into the physical
computational-basis register used by the alpha-ladder semantics. -/
def flattenLadderState
    {localControls steps : Nat}
    (state : LadderState localControls steps) :
    PrimitiveBasis (physicalQ localControls steps) := by
  unfold physicalQ
  intro wire
  refine Fin.cases state.1 ?_ wire
  intro tail
  let coordinates := decodeTail tail
  by_cases fresh : coordinates.2.val < localControls
  · exact (state.2 coordinates.1).1 ⟨coordinates.2.val, fresh⟩
  · exact (state.2 coordinates.1).2

@[simp] theorem flattenLadderState_pivot
    {localControls steps : Nat}
    (state : LadderState localControls steps) :
    flattenLadderState state (pivotWire localControls steps) = state.1 := by
  simp [flattenLadderState, pivotWire, physicalQ]

@[simp] theorem flattenLadderState_fresh
    {localControls steps : Nat}
    (state : LadderState localControls steps)
    (block : Fin steps) (control : Fin localControls) :
    flattenLadderState state (regularFreshWire block control) =
      (state.2 block).1 control := by
  simp [flattenLadderState, regularFreshWire, blockWire, blockTailIndex,
    decodeTail, freshOffset, physicalQ]

@[simp] theorem flattenLadderState_target
    {localControls steps : Nat}
    (state : LadderState localControls steps)
    (block : Fin steps) :
    flattenLadderState state (regularTarget (localControls := localControls) block) =
      (state.2 block).2 := by
  simp [flattenLadderState, regularTarget, blockWire, blockTailIndex,
    decodeTail, targetOffset, physicalQ, blockWidth]

end VandaeleLadderAlphaRepresentation
end QuantumBlockEncoding

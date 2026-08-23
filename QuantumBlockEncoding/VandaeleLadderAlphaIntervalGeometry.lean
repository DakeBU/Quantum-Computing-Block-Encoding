import QuantumBlockEncoding.VandaeleLadderAlphaRepresentation
import Mathlib.Tactic

/-!
# Regular ladder control intervals inside the alpha representation

For the regular alpha vector `alpha_i = k(i+1)`, the i-th Definition-6 control
interval is exactly

`[k i, k(i+1))`.

Its first wire is the source `previousPivot`: the initial pivot when `i = 0`,
and otherwise the previous block target.  Every remaining wire in the interval
is one of the current block's fresh controls.  This is the exact geometry needed
to identify general-alpha `intervalActive` with Vandaele Equation-(5)
`ladderActive`.
-/

namespace QuantumBlockEncoding
namespace VandaeleLadderAlphaIntervalGeometry

open VandaeleLadderAlphaRepresentation
open VandaeleLadderContract
open RemaudVandaeleLadderAlphaContract

/-- The physical wire supplying the overlapping predecessor control for one
regular ladder block. -/
def regularPreviousWire
    {localControls steps : Nat} (block : Fin steps) :
    Fin (physicalQ localControls steps) :=
  if first : block.val = 0 then
    pivotWire localControls steps
  else
    regularTarget (localControls := localControls)
      (⟨block.val - 1, by
        have blockLt := block.isLt
        omega⟩ : Fin steps)

@[simp] theorem regularPreviousWire_val
    {localControls steps : Nat} (block : Fin steps) :
    (regularPreviousWire (localControls := localControls) block).val =
      blockWidth localControls * block.val := by
  by_cases first : block.val = 0
  · simp [regularPreviousWire, first]
  · have oneLe : 1 ≤ block.val := by omega
    simp [regularPreviousWire, first, Nat.sub_add_cancel oneLe]

/-- Structured Equation-(5) predecessor control reads back exactly from the
left endpoint of the corresponding regular alpha interval. -/
@[simp] theorem flattenLadderState_regularPreviousWire
    {localControls steps : Nat}
    (state : LadderState localControls steps) (block : Fin steps) :
    flattenLadderState state
        (regularPreviousWire (localControls := localControls) block) =
      previousPivot state block := by
  by_cases first : block.val = 0
  · simp [regularPreviousWire, previousPivot, first]
  · simp [regularPreviousWire, previousPivot, first]

/-- The lower endpoint of the i-th regular alpha interval is `k i`. -/
@[simp] theorem regularAlpha_lowerEndpoint
    {localControls steps : Nat} (block : Fin steps) :
    lowerEndpoint (regularAlphaPlan localControls steps) block =
      blockWidth localControls * block.val := by
  by_cases first : block.val = 0
  · simp [lowerEndpoint, regularAlphaPlan, first]
  · have oneLe : 1 ≤ block.val := by omega
    simp [lowerEndpoint, regularAlphaPlan, first, Nat.sub_add_cancel oneLe]

/-- The upper endpoint / target of the i-th regular alpha interval is
`k(i+1)`. -/
@[simp] theorem regularAlpha_upperEndpoint
    {localControls steps : Nat} (block : Fin steps) :
    upperEndpoint (regularAlphaPlan localControls steps) block =
      blockWidth localControls * (block.val + 1) := by
  simp [upperEndpoint, regularAlphaPlan]

/-- Arithmetic form of membership in one regular alpha control interval. -/
theorem regular_inControlInterval_iff
    {localControls steps : Nat}
    (block : Fin steps) (wire : Fin (physicalQ localControls steps)) :
    inControlInterval (regularAlphaPlan localControls steps) block wire ↔
      blockWidth localControls * block.val ≤ wire.val ∧
      wire.val < blockWidth localControls * (block.val + 1) := by
  simp [inControlInterval]

/-- The predecessor wire is the leftmost control of its regular alpha block. -/
theorem regularPreviousWire_inControlInterval
    {localControls steps : Nat} (block : Fin steps) :
    inControlInterval (regularAlphaPlan localControls steps) block
      (regularPreviousWire (localControls := localControls) block) := by
  rw [regular_inControlInterval_iff]
  constructor
  · simp
  · rw [regularPreviousWire_val]
    have widthPositive : 0 < blockWidth localControls := by
      simp [blockWidth]
    exact (Nat.mul_lt_mul_left widthPositive).2 (by omega)

/-- Every fresh control of the current block lies in the same regular alpha
control interval, immediately to the right of the predecessor wire. -/
theorem regularFreshWire_inControlInterval
    {localControls steps : Nat}
    (block : Fin steps) (control : Fin localControls) :
    inControlInterval (regularAlphaPlan localControls steps) block
      (regularFreshWire block control) := by
  rw [regular_inControlInterval_iff]
  rw [regularFreshWire_val]
  constructor
  · omega
  · rw [Nat.mul_add]
    simp only [Nat.mul_one]
    have controlLt := control.isLt
    simp [blockWidth]
    omega

/-- Complete control-interval decomposition: a wire in the i-th regular alpha
interval is either its predecessor pivot/target or exactly one fresh control of
block i. -/
theorem regular_controlInterval_wire_cases
    {localControls steps : Nat}
    (block : Fin steps) (wire : Fin (physicalQ localControls steps))
    (member : inControlInterval (regularAlphaPlan localControls steps) block wire) :
    wire = regularPreviousWire (localControls := localControls) block ∨
      ∃ control : Fin localControls, wire = regularFreshWire block control := by
  have bounds := (regular_inControlInterval_iff block wire).1 member
  have lower := bounds.1
  have upper := bounds.2
  have upper' :
      wire.val < blockWidth localControls * block.val + blockWidth localControls := by
    simpa [Nat.mul_add] using upper
  by_cases atLower : wire.val = blockWidth localControls * block.val
  · left
    apply Fin.ext
    simpa using atLower
  · have strictLower : blockWidth localControls * block.val < wire.val := by
      omega
    let controlValue := wire.val - blockWidth localControls * block.val - 1
    have controlLt : controlValue < localControls := by
      dsimp [controlValue]
      simp [blockWidth] at strictLower upper' ⊢
      omega
    let control : Fin localControls := ⟨controlValue, controlLt⟩
    right
    refine ⟨control, ?_⟩
    apply Fin.ext
    rw [regularFreshWire_val]
    dsimp [control, controlValue]
    omega

end VandaeleLadderAlphaIntervalGeometry
end QuantumBlockEncoding

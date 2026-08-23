import QuantumBlockEncoding.VandaeleLadderAlphaIntervalGeometry
import Mathlib.Tactic

/-!
# Activation bridge: Vandaele Equation (5) = regular alpha Equation (7)

The interval decomposition is now purely semantic.  General-alpha
`intervalActive` requires every physical wire in `[k i, k(i+1))` to be one.
For a regular ladder this interval consists exactly of:

1. the Equation-(5) `previousPivot`; and
2. every fresh control of block i.

Hence the two source activation predicates are identical after flattening the
structured Vandaele state into the physical alpha register.
-/

namespace QuantumBlockEncoding
namespace VandaeleLadderAlphaActivationBridge

open MultiControlledXSchedule
open VandaeleLadderAlphaIntervalGeometry
open VandaeleLadderAlphaRepresentation
open VandaeleLadderContract
open RemaudVandaeleLadderAlphaContract

/-- The general Definition-6 interval predicate is exactly the source
Equation-(5) ladder predicate on every regular block. -/
theorem regular_intervalActive_iff_ladderActive
    {localControls steps : Nat}
    (state : LadderState localControls steps) (block : Fin steps) :
    intervalActive (regularAlphaPlan localControls steps)
        (flattenLadderState state) block ↔
      ladderActive state block := by
  constructor
  · intro interval
    unfold ladderActive
    constructor
    · have one := interval
        (regularPreviousWire (localControls := localControls) block)
        (regularPreviousWire_inControlInterval block)
      simpa using one
    · unfold allLocalControlsOne
      intro control
      have one := interval
        (regularFreshWire block control)
        (regularFreshWire_inControlInterval block control)
      simpa using one
  · intro source
    unfold ladderActive at source
    rcases source with ⟨previousOne, freshOne⟩
    intro wire member
    rcases regular_controlInterval_wire_cases block wire member with
      previous | ⟨control, fresh⟩
    · rw [previous]
      simpa using previousOne
    · rw [fresh]
      simpa using (freshOne control)

/-- The actual generic MCX source gate for the regular alpha plan fires exactly
under the Vandaele Equation-(5) source predicate. -/
theorem regular_sourceGate_active_iff_ladderActive
    {localControls steps : Nat}
    (state : LadderState localControls steps) (block : Fin steps) :
    active (sourceGate (regularAlphaPlan localControls steps) block)
        (flattenLadderState state) ↔
      ladderActive state block := by
  exact (sourceGate_active_iff
    (regularAlphaPlan localControls steps)
    (flattenLadderState state) block).trans
      (regular_intervalActive_iff_ladderActive state block)

end VandaeleLadderAlphaActivationBridge
end QuantumBlockEncoding

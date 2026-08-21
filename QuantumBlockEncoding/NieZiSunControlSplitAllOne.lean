import QuantumBlockEncoding.NieZiSunControlSplit
import Mathlib.Tactic

/-!
# Activation bridge for the Nie--Zi--Sun control split

The recursive Figure-3 proof reasons in head/left/right coordinates, while the
public n-Toffoli target is activated by all n physical controls.  This module
proves those predicates are exactly the same under the no-padding split from
`NieZiSunControlSplit`.
-/

namespace QuantumBlockEncoding
namespace NieZiSunControlSplitAllOne

open NieZiSunControlSplit
open NieZiSunFigure3Protocol

/-- All-one physical controls iff head and both tails are all one. -/
theorem allOne_split_iff
    {n : Nat} (large : 4 ≤ n)
    (controls : PrimitiveBasis n) :
    allOne controls ↔
      let parts := splitControls n large controls
      headAllOne parts.1 ∧ allOne parts.2.1 ∧ allOne parts.2.2 := by
  constructor
  · intro active
    dsimp
    constructor
    · intro i
      exact active (headWire n large i)
    · constructor
      · intro i
        exact active (leftWire n large i)
      · intro i
        exact active (rightWire n large i)
  · intro splitActive wire
    rcases splitActive with ⟨headActive,leftActive,rightActive⟩
    rcases wire_region n large wire with head | left | right
    · let i : Fin 4 := ⟨wire.val, head⟩
      have wireEq : headWire n large i = wire := by
        apply Fin.ext
        rfl
      rw [← wireEq]
      exact headActive i
    · let i : Fin (leftTailWidth n) := ⟨wire.val - 4, by omega⟩
      have wireEq : leftWire n large i = wire := by
        apply Fin.ext
        simp [leftWire, i]
        omega
      rw [← wireEq]
      exact leftActive i
    · let i : Fin (rightTailWidth n) :=
        ⟨wire.val - 4 - leftTailWidth n, by
          have wireLt := wire.isLt
          unfold rightTailWidth
          omega⟩
      have wireEq : rightWire n large i = wire := by
        apply Fin.ext
        simp [rightWire, i]
        omega
      rw [← wireEq]
      exact rightActive i

/-- Reader-facing implication in the direction used by Figure-3 Step 3. -/
theorem fullActive_of_allOne
    {n : Nat} (large : 4 ≤ n)
    (controls : PrimitiveBasis n)
    (active : allOne controls) :
    let parts := splitControls n large controls
    fullActive parts.1 parts.2.1 parts.2.2 := by
  simpa [fullActive] using (allOne_split_iff large controls).1 active

/-- Conversely a Figure-3 full-active midpoint originates from all-one physical
controls. -/
theorem allOne_of_fullActive
    {n : Nat} (large : 4 ≤ n)
    (controls : PrimitiveBasis n)
    (active :
      let parts := splitControls n large controls
      fullActive parts.1 parts.2.1 parts.2.2) :
    allOne controls := by
  apply (allOne_split_iff large controls).2
  simpa [fullActive] using active

end NieZiSunControlSplitAllOne
end QuantumBlockEncoding

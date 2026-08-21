import QuantumBlockEncoding.GidneyZeroedSourceProgram
import QuantumBlockEncoding.ReversibleProgramCounts
import Mathlib.Tactic

/-!
# Exact logical gate profile of the Gidney source family

The source syntax already proves total length `3c+2` for `c=n-2` workspace
bits.  This module refines that number by gate class, using the repository's
existing X/CX/CCX counters on the *same* `ReversibleProgram`.

Each nested carry level contains two CCX gates and one CX gate.  The final low
bit tail contributes one CX and one X.  Hence

`X = 1`, `CX = c+1`, `CCX = 2c`.

For an n-bit target (`n=c+2`) this is

`X = 1`, `CX = n-1`, `CCX = 2n-4`, total `3n-4`.
-/

namespace QuantumBlockEncoding
namespace GidneyZeroedSourceLogicalResources

open ComparatorIncrementer
open GidneyZeroedSourceProgram
open ReversibleProgramCounts

/-- Every carry-compute gate is one CCX and no X/CX. -/
theorem computeCarryGate_counts
    (carryCount : Nat) (j : Fin carryCount) :
    j.1 = j.val ∧
    j.isLt = j.isLt ∧
    ComparatorIncrementer.ReversibleGate.xCount
      (computeCarryGate carryCount j) = 0 ∧
    ComparatorIncrementer.ReversibleGate.cxCount
      (computeCarryGate carryCount j) = 0 ∧
    ComparatorIncrementer.ReversibleGate.toffoliCount
      (computeCarryGate carryCount j) = 1 := by
  by_cases first : j.val = 0 <;>
    simp [computeCarryGate, first,
      ComparatorIncrementer.ReversibleGate.xCount,
      ComparatorIncrementer.ReversibleGate.cxCount,
      ComparatorIncrementer.ReversibleGate.toffoliCount]

/-- Every carry-consumption gate is one CX and no X/CCX. -/
theorem consumeCarryGate_counts
    (carryCount : Nat) (j : Fin carryCount) :
    ComparatorIncrementer.ReversibleGate.xCount
      (consumeCarryGate carryCount j) = 0 ∧
    ComparatorIncrementer.ReversibleGate.cxCount
      (consumeCarryGate carryCount j) = 1 ∧
    ComparatorIncrementer.ReversibleGate.toffoliCount
      (consumeCarryGate carryCount j) = 0 := by
  rfl

/-- One nested carry level contributes exactly `(X,CX,CCX)=(0,1,2)`. -/
theorem carryCoreProgramFrom_counts
    (carryCount start count : Nat)
    (bound : start + count ≤ carryCount) :
    ComparatorIncrementer.ReversibleProgram.xCount
        (carryCoreProgramFrom carryCount start count bound) = 0 ∧
    ComparatorIncrementer.ReversibleProgram.cxCount
        (carryCoreProgramFrom carryCount start count bound) = count ∧
    ComparatorIncrementer.ReversibleProgram.toffoliCount
        (carryCoreProgramFrom carryCount start count bound) = 2 * count := by
  induction count generalizing start with
  | zero =>
      simp [carryCoreProgramFrom]
  | succ count induction =>
      let j : Fin carryCount := ⟨start, by omega⟩
      have gateCounts := computeCarryGate_counts carryCount j
      have consumeCounts := consumeCarryGate_counts carryCount j
      have recursive := induction (start := start + 1) (bound := by omega)
      simp [carryCoreProgramFrom, consumeAndUncomputePair,
        recursive, gateCounts.2.2.1, gateCounts.2.2.2.1,
        gateCounts.2.2.2.2,
        consumeCounts.1, consumeCounts.2.1, consumeCounts.2.2]
      omega

/-- Complete carry core profile. -/
theorem carryCoreProgram_counts (carryCount : Nat) :
    ComparatorIncrementer.ReversibleProgram.xCount
        (carryCoreProgram carryCount) = 0 ∧
    ComparatorIncrementer.ReversibleProgram.cxCount
        (carryCoreProgram carryCount) = carryCount ∧
    ComparatorIncrementer.ReversibleProgram.toffoliCount
        (carryCoreProgram carryCount) = 2 * carryCount := by
  unfold carryCoreProgram
  exact carryCoreProgramFrom_counts carryCount 0 carryCount (by omega)

/-- Low-bit tail profile. -/
theorem lowBitProgram_counts (carryCount : Nat) :
    ComparatorIncrementer.ReversibleProgram.xCount
        (lowBitProgram carryCount) = 1 ∧
    ComparatorIncrementer.ReversibleProgram.cxCount
        (lowBitProgram carryCount) = 1 ∧
    ComparatorIncrementer.ReversibleProgram.toffoliCount
        (lowBitProgram carryCount) = 0 := by
  simp [lowBitProgram,
    ComparatorIncrementer.ReversibleGate.xCount,
    ComparatorIncrementer.ReversibleGate.cxCount,
    ComparatorIncrementer.ReversibleGate.toffoliCount]

/-- Exact arbitrary-width source profile from the actual gate list. -/
theorem sourceProgram_counts (carryCount : Nat) :
    ComparatorIncrementer.ReversibleProgram.xCount
        (sourceProgram carryCount) = 1 ∧
    ComparatorIncrementer.ReversibleProgram.cxCount
        (sourceProgram carryCount) = carryCount + 1 ∧
    ComparatorIncrementer.ReversibleProgram.toffoliCount
        (sourceProgram carryCount) = 2 * carryCount := by
  have core := carryCoreProgram_counts carryCount
  have low := lowBitProgram_counts carryCount
  unfold sourceProgram
  simp [core.1, core.2.1, core.2.2,
    low.1, low.2.1, low.2.2]

/-- The three classified counts sum to the already-certified total length. -/
theorem sourceProgram_classified_total (carryCount : Nat) :
    ComparatorIncrementer.ReversibleProgram.xCount (sourceProgram carryCount) +
      ComparatorIncrementer.ReversibleProgram.cxCount (sourceProgram carryCount) +
      ComparatorIncrementer.ReversibleProgram.toffoliCount (sourceProgram carryCount) =
        (sourceProgram carryCount).length := by
  rw [sourceProgram_length]
  rcases sourceProgram_counts carryCount with ⟨x, cx, ccx⟩
  rw [x, cx, ccx]
  omega

end GidneyZeroedSourceLogicalResources
end QuantumBlockEncoding
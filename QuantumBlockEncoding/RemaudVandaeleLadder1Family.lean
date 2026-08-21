import QuantumBlockEncoding.RemaudVandaeleLadder1AlgorithmSemantics
import QuantumBlockEncoding.RemaudVandaeleLadder1ResourceClosure
import QuantumBlockEncoding.ReversibleWireEmbedding
import QuantumBlockEncoding.VandaeleLemma3ProgramFamily
import Mathlib.Tactic

/-!
# Complete proof-bearing Remaud--Vandaele Algorithm-1 family

This module closes the upstream citation used by Vandaele 2026 Lemma 3.
The same scheduled circuit family now carries all required evidence:

* exact Equation-(5) `L_1` semantics;
* every logical instruction is a CNOT;
* linear gate count;
* logarithmic certified depth;
* no ancillary register.

No resource field is copied from the paper into an unrelated record: all counts
and depths are read from the exact `ScheduledReversibleProgram` whose semantics
were proved in `RemaudVandaeleLadder1AlgorithmSemantics`.
-/

namespace QuantumBlockEncoding
namespace RemaudVandaeleLadder1Family

open ReversibleWireEmbedding
open RemaudVandaeleLadder1AlgorithmPlan
open RemaudVandaeleLadder1AlgorithmSchedule
open RemaudVandaeleLadder1AlgorithmSemantics
open RemaudVandaeleLadder1ResourceClosure
open VandaeleLemma3ProgramFamily

/-- `OnlyCX` is stable under chronological concatenation. -/
theorem onlyCX_append
    {q : Nat} (left right : ReversibleProgram q)
    (leftOnly : OnlyCX left) (rightOnly : OnlyCX right) :
    OnlyCX (left ++ right) := by
  intro gate member
  rw [List.mem_append] at member
  rcases member with member | member
  · exact leftOnly gate member
  · exact rightOnly gate member

/-- Injective wire renaming does not change a CX into another gate type. -/
theorem onlyCX_mapProgram
    {small large : Nat}
    (embed : Fin small → Fin large)
    (injective : Function.Injective embed)
    (program : ReversibleProgram small)
    (only : OnlyCX program) :
    OnlyCX (mapProgramWires embed injective program) := by
  intro gate member
  simp [mapProgramWires] at member
  rcases member with ⟨source, sourceMember, rfl⟩
  have sourceCX := only source sourceMember
  cases source with
  | x target => contradiction
  | cx control target distinct => rfl
  | ccx c0 c1 target c01 c0t c1t => contradiction

/-- Every gate in the paper's left wall is CX. -/
theorem leftLayer_onlyCX (n : Nat) : OnlyCX (leftLayer n) := by
  intro gate member
  simp [leftLayer] at member
  rcases member with ⟨index, rfl⟩
  rfl

/-- Every gate in the paper's right wall is CX. -/
theorem rightLayer_onlyCX (n : Nat) : OnlyCX (rightLayer n) := by
  intro gate member
  simp [rightLayer] at member
  rcases member with ⟨index, rfl⟩
  rfl

/-- The base two-wire source circuit is one CX. -/
theorem baseTwo_onlyCX : OnlyCX baseTwoScheduled.program := by
  intro gate member
  simp [baseTwoScheduled, oneLayerScheduled] at member
  rcases member with rfl
  rfl

/-- Every logical gate in the complete recursive Algorithm-1 circuit is CX. -/
theorem algorithm_onlyCX : ∀ n, OnlyCX (algorithm n).program := by
  intro n
  induction n using Nat.strong_induction_on with
  | h n induction =>
      rcases n with (_ | _ | _ | m)
      · intro gate member
        simp [algorithm, emptyScheduled] at member
      · intro gate member
        simp [algorithm, emptyScheduled] at member
      · simpa [algorithm] using baseTwo_onlyCX
      · let n := m + 3
        have smaller : recursiveWidth n < n := recursiveWidth_lt (by omega)
        have recursiveOnly := induction (recursiveWidth n) smaller
        rw [algorithm_step (n := n) (by omega)]
        rw [ScheduledReversibleProgram.seq_program]
        rw [ScheduledReversibleProgram.seq_program]
        apply onlyCX_append
        · apply onlyCX_append
          · simpa [oneLayerScheduled] using leftLayer_onlyCX n
          · rw [ScheduledWireEmbedding.mapScheduledWires_program]
            exact onlyCX_mapProgram
              (recursiveWire n)
              (recursiveWire_injective (n := n))
              (algorithm (recursiveWidth n)).program
              recursiveOnly
        · simpa [oneLayerScheduled] using rightLayer_onlyCX n

/-- The exact Remaud--Vandaele Algorithm-1 circuit family, expressed in the
`steps` convention of Vandaele Definition 2.3. -/
def family : LemmaThreeScheduledFamily where
  scheduled := fun steps => algorithm (steps + 1)
  correctness := fun steps => algorithm_vandaele_flatSpec steps
  onlyCX := fun steps => algorithm_onlyCX (steps + 1)
  resources := by
    simpa [gateCountBySteps, depthBySteps] using
      algorithm_resources_for_vandaele

/-- Reader-facing theorem: the upstream citation now provides an actual
proof-bearing family rather than only a resource interface. -/
theorem closes_vandaele_lemmaThree :
    LemmaThreeUniformResourceTarget
      (fun steps => (family.scheduled steps).gateCount)
      (fun steps => (family.scheduled steps).depth) :=
  family.resources

end RemaudVandaeleLadder1Family
end QuantumBlockEncoding

import QuantumBlockEncoding.VandaeleLemma1NieRecursiveStep
import QuantumBlockEncoding.VandaeleLemma1NieSizes
import QuantumBlockEncoding.VandaeleLemma1CleanPromise
import Mathlib.Tactic

/-!
# Well-founded raw circuit family for Nie / Vandaele Lemma 1

The recursive constructor is already proof-bearing at the schedule/resource
level.  This module solves only the *generation* recursion: every control count
gets one concrete split built from the fixed base cases and the Figure-3
constructor.

Correctness remains deliberately separate.  A later induction will upgrade
`rawSplit k` to a `CleanSplitCertificate k`; keeping generation independent lets
resource recurrences and termination be audited without circularly assuming the
semantic theorem we are trying to prove.
-/

namespace QuantumBlockEncoding
namespace VandaeleLemma1NieRawFamily

open VandaeleLemma1ProgramFamily
open VandaeleLemma1NieLayout
open VandaeleLemma1NieSizes
open VandaeleLemma1NieRecursiveStep
open VandaeleLemma1CleanPromise

/-- Concrete recursive split for every number of controls. -/
def rawSplit : (k : Nat) →
    ReversibleComputeActionUncompute (lemmaOneFlatWidth k)
  | 0 => k0Certificate.split
  | 1 => k1Certificate.split
  | 2 => k2Certificate.split
  | 3 => k3Certificate.split
  | 4 => k4Certificate.split
  | k + 5 =>
      recursiveSplit (k := k + 5) (by omega)
        (rawSplit (leftSize (k + 5)))
        (rawSplit (rightSize (k + 5)))
termination_by k => k
decreasing_by
  · exact leftSize_lt_parent (k := k + 5) (by omega)
  · exact rightSize_lt_parent (k := k + 5) (by omega)

/-- The complete clean-recursion circuit represented by the split. -/
def rawScheduled (k : Nat) :
    ScheduledReversibleProgram (lemmaOneFlatWidth k) :=
  (rawSplit k).full

@[simp] theorem rawSplit_zero : rawSplit 0 = k0Certificate.split := by
  rfl

@[simp] theorem rawSplit_one : rawSplit 1 = k1Certificate.split := by
  rfl

@[simp] theorem rawSplit_two : rawSplit 2 = k2Certificate.split := by
  rfl

@[simp] theorem rawSplit_three : rawSplit 3 = k3Certificate.split := by
  rfl

@[simp] theorem rawSplit_four : rawSplit 4 = k4Certificate.split := by
  rfl

/-- Definitional unfolding at every recursive node. -/
theorem rawSplit_succ5 (k : Nat) :
    rawSplit (k + 5) =
      recursiveSplit (k := k + 5) (by omega)
        (rawSplit (leftSize (k + 5)))
        (rawSplit (rightSize (k + 5))) := by
  rw [rawSplit]

/-- The scheduled circuit is exactly the complete circuit of its generated
split, so all downstream resource values are read from the same object. -/
@[simp] theorem rawScheduled_eq_full (k : Nat) :
    rawScheduled k = (rawSplit k).full := by
  rfl

end VandaeleLemma1NieRawFamily
end QuantumBlockEncoding

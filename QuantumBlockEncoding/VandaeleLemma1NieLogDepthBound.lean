import QuantumBlockEncoding.VandaeleLemma1NieResourceBounds
import Mathlib.Data.Nat.Log
import Mathlib.Tactic

/-!
# Explicit logarithmic depth bound for the generated Nie family

The proof-bearing Figure-3 constructor gives

```
D(k) = 32 + max (D(L)+C(L)) (D(R)+C(R)),
```

and the central commit satisfies `C(·) ≤ 10`.  Both children have at most half
the parent scale after the four reserved controls are removed.  Using Mathlib's
exact base-two logarithm recurrence, this yields

```
D(k) ≤ 42 * logScale k,
```

where `logScale k = Nat.log2 (k+1) + 1` is the source-facing resource scale from
`VandaeleLemma1Contract`.

The constant 42 is not fitted or detached metadata: one unit of logarithmic
scale supplies exactly enough slack for the fixed `32 + 10` cost at each
recursive level.
-/

namespace QuantumBlockEncoding
namespace VandaeleLemma1NieLogDepthBound

open VandaeleLemma1Contract
open VandaeleLemma1ProgramFamily
open VandaeleLemma1NieLayout
open VandaeleLemma1NieSizes
open VandaeleLemma1NieRawFamily
open VandaeleLemma1NieRecursiveStep
open VandaeleLemma1NieResourceBounds
open VandaeleLemma1CleanPromise

private theorem left_plus_one_le_half_parent
    (k : Nat) (five_le : 5 ≤ k) :
    leftSize k + 1 ≤ (k + 1) / 2 := by
  simp [leftSize]
  omega

private theorem right_plus_one_le_half_parent
    (k : Nat) (five_le : 5 ≤ k) :
    rightSize k + 1 ≤ (k + 1) / 2 := by
  simp [rightSize, leftSize]
  omega

/-- Any child whose `size+1` fits in half of `k+1` loses at least one unit of
the source logarithmic scale. -/
private theorem child_logScale_succ_le
    (k child : Nat) (five_le : 5 ≤ k)
    (half : child + 1 ≤ (k + 1) / 2) :
    logScale child + 1 ≤ logScale k := by
  have logMono :
      Nat.log 2 (child + 1) ≤ Nat.log 2 ((k + 1) / 2) :=
    Nat.log_mono_right half
  have parentRec :
      Nat.log 2 (k + 1) = Nat.log 2 ((k + 1) / 2) + 1 := by
    exact Nat.log_of_one_lt_of_le (by omega) (by omega)
  simp only [logScale, Nat.log2_eq_log_two]
  omega

private theorem base_depth_bound (k : Nat) (small : k < 5) :
    (rawScheduled k).depth ≤ 42 * logScale k := by
  interval_cases k <;>
    simp [rawScheduled, rawSplit_zero, rawSplit_one, rawSplit_two,
      rawSplit_three, rawSplit_four,
      k0Certificate, k1Certificate, k2Certificate, k3Certificate, k4Certificate,
      atomicCertificate, atomicSplit, logScale]

/-- Every generated clean-recursion circuit has depth at most
`42 * (Nat.log2 (k+1)+1)`. -/
theorem rawScheduled_depth_le_logScale (k : Nat) :
    (rawScheduled k).depth ≤ 42 * logScale k := by
  induction k using Nat.strong_induction_on with
  | h k induction =>
      by_cases small : k < 5
      · exact base_depth_bound k small
      · have five_le : 5 ≤ k := by omega
        obtain ⟨n, rfl⟩ := Nat.exists_eq_add_of_le five_le
        rw [show 5 + n = n + 5 by omega]
        change (rawSplit (n + 5)).full.depth ≤ 42 * logScale (n + 5)
        rw [rawSplit_succ5, recursiveSplit_full_depth]
        have left_lt : leftSize (n + 5) < 5 + n := by
          have h := leftSize_lt_parent (k := n + 5) (by omega)
          omega
        have right_lt : rightSize (n + 5) < 5 + n := by
          have h := rightSize_lt_parent (k := n + 5) (by omega)
          omega
        have leftBound := induction (leftSize (n + 5)) left_lt
        have rightBound := induction (rightSize (n + 5)) right_lt
        change (rawSplit (leftSize (n + 5))).full.depth ≤
          42 * logScale (leftSize (n + 5)) at leftBound
        change (rawSplit (rightSize (n + 5))).full.depth ≤
          42 * logScale (rightSize (n + 5)) at rightBound
        have leftCommit :=
          rawSplit_commit_depth_le_ten (leftSize (n + 5))
        have rightCommit :=
          rawSplit_commit_depth_le_ten (rightSize (n + 5))
        have leftLog :
            logScale (leftSize (n + 5)) + 1 ≤ logScale (n + 5) :=
          child_logScale_succ_le (n + 5) (leftSize (n + 5))
            (by omega) (left_plus_one_le_half_parent (n + 5) (by omega))
        have rightLog :
            logScale (rightSize (n + 5)) + 1 ≤ logScale (n + 5) :=
          child_logScale_succ_le (n + 5) (rightSize (n + 5))
            (by omega) (right_plus_one_le_half_parent (n + 5) (by omega))
        omega

/-- Big-O style witness, derived from the explicit logarithmic certificate. -/
theorem exists_log_depth_constant :
    ∃ c : Nat, ∀ k : Nat,
      (rawScheduled k).depth ≤ c * logScale k := by
  exact ⟨42, rawScheduled_depth_le_logScale⟩

end VandaeleLemma1NieLogDepthBound
end QuantumBlockEncoding
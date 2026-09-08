import QuantumBlockEncoding.VandaeleLemma1NieResourceBounds
import Mathlib.Tactic

/-!
# Explicit linear gate bound for the generated Nie family

The proof-bearing recursive constructor already gives the exact recurrence

```
G(k) = 32 + (G(L) + C(L)) + (G(R) + C(R)),
```

with `L + R = k - 4`.  `VandaeleLemma1NieResourceBounds` proves the uniform
central-commit cap `C(·) ≤ 10`.  Strong induction therefore closes with the
concrete bound

```
G(k) ≤ 18 * (k + 1).
```

This is deliberately an explicit theorem rather than an `O(k)` annotation.
The numerical constant is conservative and can be improved later without
changing the semantic construction.
-/

namespace QuantumBlockEncoding
namespace VandaeleLemma1NieLinearGateBound

open VandaeleLemma1NieLayout
open VandaeleLemma1NieSizes
open VandaeleLemma1NieRawFamily
open VandaeleLemma1NieRecursiveStep
open VandaeleLemma1NieResourceBounds
open VandaeleLemma1CleanPromise

private theorem base_gate_bound (k : Nat) (small : k < 5) :
    (rawScheduled k).gateCount ≤ 18 * (k + 1) := by
  interval_cases k <;>
    simp [rawScheduled, rawSplit_zero, rawSplit_one, rawSplit_two,
      rawSplit_three, rawSplit_four,
      k0Certificate, k1Certificate, k2Certificate, k3Certificate, k4Certificate,
      atomicCertificate, atomicSplit]

/-- Every generated clean-recursion circuit has at most `18(k+1)` NCT gates. -/
theorem rawScheduled_gateCount_le_linear (k : Nat) :
    (rawScheduled k).gateCount ≤ 18 * (k + 1) := by
  induction k using Nat.strong_induction_on with
  | h k induction =>
      by_cases small : k < 5
      · exact base_gate_bound k small
      · have five_le : 5 ≤ k := by omega
        obtain ⟨n, rfl⟩ := Nat.exists_eq_add_of_le five_le
        rw [show 5 + n = n + 5 by omega]
        change (rawSplit (n + 5)).full.gateCount ≤ 18 * (n + 5 + 1)
        rw [rawSplit_succ5, recursiveSplit_full_gateCount]
        have left_lt : leftSize (n + 5) < n + 5 :=
          leftSize_lt_parent (k := n + 5) (by omega)
        have right_lt : rightSize (n + 5) < n + 5 :=
          rightSize_lt_parent (k := n + 5) (by omega)
        have leftBound := induction (leftSize (n + 5)) left_lt
        have rightBound := induction (rightSize (n + 5)) right_lt
        have leftCommit :=
          rawSplit_commit_gateCount_le_ten (leftSize (n + 5))
        have rightCommit :=
          rawSplit_commit_gateCount_le_ten (rightSize (n + 5))
        have partition := split_size (n + 5) (by omega)
        change (rawSplit (leftSize (n + 5))).full.gateCount ≤
          18 * (leftSize (n + 5) + 1) at leftBound
        change (rawSplit (rightSize (n + 5))).full.gateCount ≤
          18 * (rightSize (n + 5) + 1) at rightBound
        omega

/-- Big-O style witness, retained as a corollary of the explicit certificate. -/
theorem exists_linear_gate_constant :
    ∃ c : Nat, ∀ k : Nat, (rawScheduled k).gateCount ≤ c * (k + 1) := by
  exact ⟨18, rawScheduled_gateCount_le_linear⟩

end VandaeleLemma1NieLinearGateBound
end QuantumBlockEncoding
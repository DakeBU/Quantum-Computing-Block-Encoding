import QuantumBlockEncoding.ComparatorIncrementerLemma7Contract
import QuantumBlockEncoding.VandaeleLemma5SplitBudget
import Mathlib.Tactic

/-!
# Promise-register budget in Vandaele Lemma 7 / Equation (38)

The proof of Lemma 7 reduces the promise-register requirement by splitting the
n-bit target into floor/ceiling halves.  The two singly controlled promise
incrementers can be realized using

`2 * ceil(n/2) - 4`

promise qubits as clean substitutes.  For `n >= 3` the source observes

`2 * ceil(n/2) - 4 < n - 2`.

Since the final Lemma-7 promise register has size `n-1`, this leaves at least one
additional promise qubit available as the dirty workspace used by Equation (36).
This file formalizes exactly that register-count argument; no gate-count or
depth claim is inferred from it.
-/

namespace QuantumBlockEncoding
namespace ComparatorIncrementerLemma7PromiseBudget

open ComparatorIncrementerLemma7Contract
open VandaeleLemma5SplitBudget

/-- Source count for the clean-substitute promise bits used by the two half-size
singly controlled promise incrementers. -/
def halfIncrementCleanNeed (n : Nat) : Nat :=
  2 * upperHalf n - 4

/-- Reserve one promise qubit for the dirty-ancilla conversion in Equation (36). -/
def reservedDirtyPromiseBits (_n : Nat) : Nat := 1

/-- With one promise qubit reserved as dirty workspace, the remaining clean
substitute capacity is exactly `n-2` in the source regime. -/
def cleanSubstituteCapacity (n : Nat) : Nat :=
  lemmaSevenPromiseWidth n - reservedDirtyPromiseBits n

@[simp] theorem cleanSubstituteCapacity_eq
    {n : Nat} (positive : 1 ≤ n) :
    cleanSubstituteCapacity n = n - 2 := by
  unfold cleanSubstituteCapacity reservedDirtyPromiseBits
  unfold lemmaSevenPromiseWidth
  omega

/-- Exact source inequality following Equation (38). -/
theorem halfIncrementCleanNeed_lt_n_sub_two
    {n : Nat} (large : 3 ≤ n) :
    halfIncrementCleanNeed n < n - 2 := by
  unfold halfIncrementCleanNeed upperHalf lowerHalf
  omega

/-- Hence the two half-size subcircuits fit strictly inside the clean-substitute
portion of the `n-1` promise register. -/
theorem halfIncrementCleanNeed_le_cleanCapacity
    {n : Nat} (large : 3 ≤ n) :
    halfIncrementCleanNeed n ≤ cleanSubstituteCapacity n := by
  rw [cleanSubstituteCapacity_eq (by omega)]
  exact Nat.le_of_lt (halfIncrementCleanNeed_lt_n_sub_two large)

/-- Including the one reserved dirty bit still fits in the declared Lemma-7
promise register of size `n-1`. -/
theorem halfClean_plus_dirty_le_promiseWidth
    {n : Nat} (large : 3 ≤ n) :
    halfIncrementCleanNeed n + reservedDirtyPromiseBits n ≤
      lemmaSevenPromiseWidth n := by
  unfold reservedDirtyPromiseBits lemmaSevenPromiseWidth
  have cleanStrict := halfIncrementCleanNeed_lt_n_sub_two large
  omega

/-- A source-facing package of the exact workspace arithmetic. -/
structure PromiseBudgetCertificate (n : Nat) where
  cleanSubstituteBits : Nat
  dirtyBits : Nat
  declaredPromiseWidth : Nat
  cleanMatchesSource : cleanSubstituteBits = halfIncrementCleanNeed n
  dirtyMatchesSource : dirtyBits = 1
  widthMatchesSource : declaredPromiseWidth = lemmaSevenPromiseWidth n
  fits : cleanSubstituteBits + dirtyBits ≤ declaredPromiseWidth

/-- Canonical Lemma-7 workspace certificate for every width in the recursive
source regime. -/
def canonicalPromiseBudget
    (n : Nat) (large : 3 ≤ n) : PromiseBudgetCertificate n where
  cleanSubstituteBits := halfIncrementCleanNeed n
  dirtyBits := 1
  declaredPromiseWidth := lemmaSevenPromiseWidth n
  cleanMatchesSource := rfl
  dirtyMatchesSource := rfl
  widthMatchesSource := rfl
  fits := halfClean_plus_dirty_le_promiseWidth large

end ComparatorIncrementerLemma7PromiseBudget
end QuantumBlockEncoding

import QuantumBlockEncoding.ComparatorIncrementerLemma7Contract
import Mathlib.Tactic

/-!
# Vandaele Lemma 7 / Equation (38): promise-register ancilla budget

The proof of Lemma 7 reduces the controlled n-bit incrementer to two singly
controlled promise incrementers on half-size target registers.  The paper states
that these two subcircuits use

`2 * ceil(n/2) - 4 < n - 2`

ancilla qubits from the promise register.  It then replaces the one clean
ancilla appearing in Equation (38) by one dirty ancilla via Equation (36), also
borrowed from the same promise register.  Hence a promise register of size
`n - 1` is sufficient.

This file isolates exactly that natural-number bookkeeping.  It does not claim
the gate/depth part of Lemma 7; those remain tied to the concrete circuit
realization and the upstream Lemma-1/Lemma-5 resource families.
-/

namespace QuantumBlockEncoding
namespace ComparatorIncrementerLemma7AncillaBudget

open ComparatorIncrementerLemma7Contract

/-- Natural-number version of `ceil(n/2)`. -/
def ceilHalf (n : Nat) : Nat := (n + 1) / 2

/-- One half-size Gidney-style incrementer uses `ceil(n/2)-2` promise qubits. -/
def oneHalfPromiseAncillas (n : Nat) : Nat := ceilHalf n - 2

/-- The two singly controlled half-size promise incrementers in Equation (38). -/
def eq38InternalPromiseAncillas (n : Nat) : Nat :=
  2 * oneHalfPromiseAncillas n

/-- In the nontrivial source regime, the structural two-half count is exactly
`2*ceil(n/2)-4`. -/
theorem eq38InternalPromiseAncillas_eq_source_formula
    {n : Nat} (large : 3 ≤ n) :
    eq38InternalPromiseAncillas n = 2 * ceilHalf n - 4 := by
  unfold eq38InternalPromiseAncillas oneHalfPromiseAncillas ceilHalf
  omega

/-- Exact strict inequality quoted immediately after Equation (38):
`2 ceil(n/2) - 4 < n - 2`. -/
theorem eq38_source_ancilla_strict_bound
    {n : Nat} (large : 3 ≤ n) :
    eq38InternalPromiseAncillas n < n - 2 := by
  rw [eq38InternalPromiseAncillas_eq_source_formula large]
  unfold ceilHalf
  omega

/-- Therefore, after allocating all Equation-(38) internal promise ancillas,
there is still room for one additional borrowed dirty ancilla inside the final
`n-1` promise-register budget. -/
theorem eq38_plus_dirty_fits_promise_register
    {n : Nat} (large : 3 ≤ n) :
    eq38InternalPromiseAncillas n + 1 ≤ lemmaSevenPromiseWidth n := by
  have strict := eq38_source_ancilla_strict_bound large
  unfold lemmaSevenPromiseWidth
  omega

/-- A slightly stronger slack statement: the Equation-(38) internal ancillas
alone leave at least two positions below the `n-1` promise-register capacity.
One of these can be used as the dirty ancilla required by Equation (36). -/
theorem eq38_internal_plus_two_fits
    {n : Nat} (large : 3 ≤ n) :
    eq38InternalPromiseAncillas n + 2 ≤ lemmaSevenPromiseWidth n := by
  have strict := eq38_source_ancilla_strict_bound large
  unfold lemmaSevenPromiseWidth
  omega

/-- Reader/planner-facing accounting record for the Lemma-7 promise register. -/
structure LemmaSevenAncillaBudget (n : Nat) where
  internalPromiseAncillas : Nat
  dirtyAncillasBorrowed : Nat
  promiseRegisterCapacity : Nat
  internalMatchesEq38 : internalPromiseAncillas = eq38InternalPromiseAncillas n
  dirtyCount : dirtyAncillasBorrowed = 1
  capacityMatchesSource : promiseRegisterCapacity = lemmaSevenPromiseWidth n
  fits : internalPromiseAncillas + dirtyAncillasBorrowed ≤ promiseRegisterCapacity

/-- Canonical budget obtained from the source inequality for every `n >= 3`. -/
def canonicalLemmaSevenAncillaBudget
    (n : Nat) (large : 3 ≤ n) : LemmaSevenAncillaBudget n where
  internalPromiseAncillas := eq38InternalPromiseAncillas n
  dirtyAncillasBorrowed := 1
  promiseRegisterCapacity := lemmaSevenPromiseWidth n
  internalMatchesEq38 := rfl
  dirtyCount := rfl
  capacityMatchesSource := rfl
  fits := eq38_plus_dirty_fits_promise_register large

end ComparatorIncrementerLemma7AncillaBudget
end QuantumBlockEncoding

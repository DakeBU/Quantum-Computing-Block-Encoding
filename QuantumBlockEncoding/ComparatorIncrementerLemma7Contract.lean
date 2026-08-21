import QuantumBlockEncoding.ComparatorIncrementerLemma8Contract
import QuantumBlockEncoding.PredicateControlledStrongPromise

/-!
# Semantic contract for Vandaele Lemma 7

Lemma 7 supplies the controlled strong promise incrementers used locally inside
Lemma 8.  For k external controls and an n-bit target, the source uses a promise
register of size `n-1` and proves an implementation with O(k+n) gates and
O(log(kn)) depth.

As elsewhere in the Vandaele formalization, ASPBE separates semantic
inhabitation from low-resource realization.  This file fixes the exact
computational-basis control predicate and promise contract, and exposes the
resource theorem as a proposition to be discharged by a concrete circuit
family.
-/

namespace QuantumBlockEncoding
namespace ComparatorIncrementerLemma7Contract

open ComparatorIncrementerLemma8Contract
open ComparatorIncrementerModularConjugation
open PredicateControlledStrongPromise

/-- All-k-controls-on predicate. -/
def allControlsActive {k : Nat} (controls : PrimitiveBasis k) : Bool :=
  if (∀ wire, controls wire = 1) then true else false

@[simp] theorem allControlsActive_iff {k : Nat}
    (controls : PrimitiveBasis k) :
    allControlsActive controls = true ↔ ∀ wire, controls wire = 1 := by
  unfold allControlsActive
  by_cases active : ∀ wire, controls wire = 1 <;> simp [active]

/-- Promise-register width in the source Lemma 7. -/
def lemmaSevenPromiseWidth (n : Nat) : Nat := n - 1

/-- Exact k-controlled strong-promise increment contract. -/
def LemmaSevenSpec (k n : Nat)
    (implementation : Equiv.Perm
      (PrimitiveBasis k ×
        PrimitiveBasis (lemmaSevenPromiseWidth n) ×
        ZMod (gridSize n))) : Prop :=
  PredicateControlledStrongPromiseSpec
    allControlsActive
    (zeroPromiseBasis (lemmaSevenPromiseWidth n))
    implementation
    (modularIncrementEquiv (gridSize n))

/-- Semantic promise implementation used only to show the contract is
consistent; it carries no claim about Lemma 7's resource complexity. -/
def semanticLemmaSevenPromise (n : Nat) :
    Equiv.Perm
      (PrimitiveBasis (lemmaSevenPromiseWidth n) × ZMod (gridSize n)) :=
  preservePromiseLift (modularIncrementEquiv (gridSize n))

/-- The semantic promise implementation is strong for the designated zero
promise branch. -/
theorem semanticLemmaSevenPromise_strong (n : Nat) :
    PromiseGateOptimization.StrongPromiseSpec
      (zeroPromiseBasis (lemmaSevenPromiseWidth n))
      (semanticLemmaSevenPromise n)
      (modularIncrementEquiv (gridSize n)) := by
  exact preservePromiseLift_strong
    (zeroPromiseBasis (lemmaSevenPromiseWidth n))
    (modularIncrementEquiv (gridSize n))

/-- Add the k-control all-ones predicate. -/
def semanticLemmaSeven (k n : Nat) :
    Equiv.Perm
      (PrimitiveBasis k ×
        PrimitiveBasis (lemmaSevenPromiseWidth n) ×
        ZMod (gridSize n)) :=
  predicateControlledPromiseEquiv
    allControlsActive (semanticLemmaSevenPromise n)

/-- Exact semantic Lemma 7 contract for every k,n. -/
theorem semanticLemmaSeven_correct (k n : Nat) :
    LemmaSevenSpec k n (semanticLemmaSeven k n) := by
  exact predicateControlledPromise_of_strong
    allControlsActive
    (zeroPromiseBasis (lemmaSevenPromiseWidth n))
    (semanticLemmaSevenPromise n)
    (modularIncrementEquiv (gridSize n))
    (semanticLemmaSevenPromise_strong n)

/-- Quantitative source target for the eventual concrete Lemma 7 family.
The `+1` factors make the bound total on zero-width edge cases without changing
the asymptotic statement on the source regime. -/
def LemmaSevenResourceTarget
    (gateCount depth : Nat → Nat → Nat) : Prop :=
  (∃ constant : Nat, ∀ k n,
    gateCount k n ≤ constant * (k + n + 1)) ∧
  (∃ constant : Nat, ∀ k n,
    depth k n ≤ constant *
      (Nat.log2 ((k + 1) * (n + 1)) + 1))

/-- A complete Lemma 7 reproduction must provide one implementation family and
one resource family satisfying both semantic and quantitative contracts. -/
structure LemmaSevenFamilyCertificate where
  implementation : (k n : Nat) → Equiv.Perm
    (PrimitiveBasis k ×
      PrimitiveBasis (lemmaSevenPromiseWidth n) ×
      ZMod (gridSize n))
  gateCount : Nat → Nat → Nat
  depth : Nat → Nat → Nat
  correctness : ∀ k n, LemmaSevenSpec k n (implementation k n)
  resources : LemmaSevenResourceTarget gateCount depth

end ComparatorIncrementerLemma7Contract
end QuantumBlockEncoding

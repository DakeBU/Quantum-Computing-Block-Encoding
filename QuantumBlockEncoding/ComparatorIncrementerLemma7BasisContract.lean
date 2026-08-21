import QuantumBlockEncoding.ComparatorIncrementerLemma7Contract
import QuantumBlockEncoding.ZModPrimitiveBasisBridge

/-!
# Basis-level Vandaele Lemma 7 contract

The algebraic Lemma-7 contract uses `ZMod (2^n)` for the target register.  Real
reversible circuits, however, act on `PrimitiveBasis n`.  This file keeps both
views and connects them through `ZModPrimitiveBasisBridge` rather than replacing
one representation by the other.

The resulting target is now gate-friendly: a future Figure-9 refinement can be
stated entirely with computational-basis registers while inheriting the exact
modular successor semantics from the algebra layer.
-/

namespace QuantumBlockEncoding
namespace ComparatorIncrementerLemma7BasisContract

open ComparatorIncrementerLemma7Contract
open ComparatorIncrementerLemma8Contract
open PredicateControlledStrongPromise
open PromiseGateOptimization
open ZModPrimitiveBasisBridge

/-- Basis-register version of the Lemma-7 strong-promise contract. -/
def LemmaSevenBasisSpec (k n : Nat)
    (implementation : Equiv.Perm
      (PrimitiveBasis k ×
        PrimitiveBasis (lemmaSevenPromiseWidth n) ×
        PrimitiveBasis n)) : Prop :=
  PredicateControlledStrongPromiseSpec
    allControlsActive
    (zeroPromiseBasis (lemmaSevenPromiseWidth n))
    implementation
    (basisModularIncrementEquiv n)

/-- Promise-preserving basis witness.  As before, this is semantic evidence only
and carries no low-resource circuit claim. -/
def semanticLemmaSevenBasisPromise (n : Nat) :
    Equiv.Perm
      (PrimitiveBasis (lemmaSevenPromiseWidth n) × PrimitiveBasis n) :=
  preservePromiseLift (basisModularIncrementEquiv n)

/-- The basis witness is a strong promise gate. -/
theorem semanticLemmaSevenBasisPromise_strong (n : Nat) :
    StrongPromiseSpec
      (zeroPromiseBasis (lemmaSevenPromiseWidth n))
      (semanticLemmaSevenBasisPromise n)
      (basisModularIncrementEquiv n) := by
  exact preservePromiseLift_strong
    (zeroPromiseBasis (lemmaSevenPromiseWidth n))
    (basisModularIncrementEquiv n)

/-- Add the k-control all-ones predicate on the computational-basis key. -/
def semanticLemmaSevenBasis (k n : Nat) :
    Equiv.Perm
      (PrimitiveBasis k ×
        PrimitiveBasis (lemmaSevenPromiseWidth n) ×
        PrimitiveBasis n) :=
  predicateControlledPromiseEquiv
    allControlsActive (semanticLemmaSevenBasisPromise n)

/-- The gate-friendly semantic family inhabits the exact Lemma-7 basis
contract for every k,n. -/
theorem semanticLemmaSevenBasis_correct (k n : Nat) :
    LemmaSevenBasisSpec k n (semanticLemmaSevenBasis k n) := by
  exact predicateControlledPromise_of_strong
    allControlsActive
    (zeroPromiseBasis (lemmaSevenPromiseWidth n))
    (semanticLemmaSevenBasisPromise n)
    (basisModularIncrementEquiv n)
    (semanticLemmaSevenBasisPromise_strong n)

/-- The target square between the basis and ZMod formulations commutes exactly. -/
theorem lemmaSeven_target_bridge
    (n : Nat) (state : PrimitiveBasis n) :
    basisZModEquiv n (basisModularIncrementEquiv n state) =
      modularIncrementEquiv (gridSize n) (basisZModEquiv n state) := by
  exact transportZModPerm_commutes
    n (modularIncrementEquiv (gridSize n)) state

/-- Consequently the basis target satisfies the repository's standard n-bit
incrementer specification. -/
theorem lemmaSeven_basis_target_incrementerSpec (n : Nat) :
    ComparatorIncrementerGeneral.IncrementerSpec n
      (basisModularIncrementEquiv n) :=
  basisModularIncrement_satisfies_spec n

/-- Key and promise registers are restored unconditionally by the canonical
basis witness. -/
theorem semanticLemmaSevenBasis_restores
    (k n : Nat)
    (controls : PrimitiveBasis k)
    (promise : PrimitiveBasis (lemmaSevenPromiseWidth n))
    (value : PrimitiveBasis n) :
    (semanticLemmaSevenBasis k n (controls, promise, value)).1 = controls ∧
    (semanticLemmaSevenBasis k n (controls, promise, value)).2.1 = promise := by
  exact (semanticLemmaSevenBasis_correct k n).2.2
    controls promise value

end ComparatorIncrementerLemma7BasisContract
end QuantumBlockEncoding

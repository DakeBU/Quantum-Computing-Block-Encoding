import QuantumBlockEncoding.ComparatorIncrementerLemma7BasisContract
import QuantumBlockEncoding.PrimitiveBasisRegisterSplit
import QuantumBlockEncoding.ReversibleClassical

/-!
# Flat reversible-program contract for Vandaele Lemma 7

The previous layers now agree on the arithmetic target and the product-register
promise semantics.  This file fixes the final interface that a real Figure-9
circuit must inhabit.

Wire order is explicit and little-endian within each logical register:

`[ k control wires | n-1 promise wires | n target wires ]`.

No implementation is postulated.  A `LemmaSevenFlatProgramCertificate` can be
constructed only after an actual `ReversibleProgram` has been proved to satisfy
the product-register strong-promise contract through the exact split equivalence.
-/

namespace QuantumBlockEncoding
namespace ComparatorIncrementerLemma7FlatContract

open ComparatorIncrementerLemma7BasisContract
open ComparatorIncrementerLemma7Contract
open PrimitiveBasisRegisterSplit

/-- Total flat wire count of the Lemma-7 register layout. -/
def lemmaSevenFlatWidth (k n : Nat) : Nat :=
  k + (lemmaSevenPromiseWidth n + n)

/-- One external control wire in the low prefix. -/
def controlWire (k n : Nat) (wire : Fin k) :
    Fin (lemmaSevenFlatWidth k n) :=
  ⟨wire.val, by unfold lemmaSevenFlatWidth; omega⟩

/-- One promise wire immediately after the controls. -/
def promiseWire (k n : Nat)
    (wire : Fin (lemmaSevenPromiseWidth n)) :
    Fin (lemmaSevenFlatWidth k n) :=
  ⟨k + wire.val, by unfold lemmaSevenFlatWidth; omega⟩

/-- One target wire in the final n-wire suffix. -/
def targetWire (k n : Nat) (wire : Fin n) :
    Fin (lemmaSevenFlatWidth k n) :=
  ⟨k + lemmaSevenPromiseWidth n + wire.val, by
    unfold lemmaSevenFlatWidth
    omega⟩

/-- The three flat regions are pairwise ordered. -/
theorem control_before_promise
    (k n : Nat) (control : Fin k)
    (promise : Fin (lemmaSevenPromiseWidth n)) :
    (controlWire k n control).val < (promiseWire k n promise).val := by
  simp [controlWire, promiseWire]
  omega

theorem promise_before_target
    (k n : Nat) (promise : Fin (lemmaSevenPromiseWidth n))
    (target : Fin n) :
    (promiseWire k n promise).val < (targetWire k n target).val := by
  simp [promiseWire, targetWire]
  omega

/-- Canonical flat-to-logical register view. -/
def lemmaSevenRegisterEquiv (k n : Nat) :
    PrimitiveBasis (lemmaSevenFlatWidth k n) ≃
      PrimitiveBasis k ×
        PrimitiveBasis (lemmaSevenPromiseWidth n) ×
        PrimitiveBasis n := by
  unfold lemmaSevenFlatWidth
  exact basisTripleSplitEquiv k (lemmaSevenPromiseWidth n) n

/-- Read a flat basis permutation as a logical controls/promise/target
permutation. -/
def productViewOfFlat (k n : Nat)
    (implementation : Equiv.Perm (PrimitiveBasis (lemmaSevenFlatWidth k n))) :
    Equiv.Perm
      (PrimitiveBasis k ×
        PrimitiveBasis (lemmaSevenPromiseWidth n) ×
        PrimitiveBasis n) :=
  (lemmaSevenRegisterEquiv k n).symm.trans
    (implementation.trans (lemmaSevenRegisterEquiv k n))

/-- Flatten a logical product-register permutation into the circuit register. -/
def flattenProductPermutation (k n : Nat)
    (implementation : Equiv.Perm
      (PrimitiveBasis k ×
        PrimitiveBasis (lemmaSevenPromiseWidth n) ×
        PrimitiveBasis n)) :
    Equiv.Perm (PrimitiveBasis (lemmaSevenFlatWidth k n)) :=
  (lemmaSevenRegisterEquiv k n).trans
    (implementation.trans (lemmaSevenRegisterEquiv k n).symm)

/-- Flattening and then reopening the logical register view is lossless. -/
theorem productView_flattenProduct
    (k n : Nat)
    (implementation : Equiv.Perm
      (PrimitiveBasis k ×
        PrimitiveBasis (lemmaSevenPromiseWidth n) ×
        PrimitiveBasis n)) :
    productViewOfFlat k n
      (flattenProductPermutation k n implementation) = implementation := by
  apply Equiv.ext
  intro state
  simp [productViewOfFlat, flattenProductPermutation]

/-- Exact flat correctness proposition for a Lemma-7 circuit. -/
def LemmaSevenFlatSpec (k n : Nat)
    (implementation : Equiv.Perm
      (PrimitiveBasis (lemmaSevenFlatWidth k n))) : Prop :=
  LemmaSevenBasisSpec k n (productViewOfFlat k n implementation)

/-- Canonical semantic flat permutation, useful only as a consistency witness. -/
def semanticLemmaSevenFlat (k n : Nat) :
    Equiv.Perm (PrimitiveBasis (lemmaSevenFlatWidth k n)) :=
  flattenProductPermutation k n (semanticLemmaSevenBasis k n)

/-- The flat contract is semantically inhabited.  This does not imply a
low-resource gate decomposition. -/
theorem semanticLemmaSevenFlat_correct (k n : Nat) :
    LemmaSevenFlatSpec k n (semanticLemmaSevenFlat k n) := by
  unfold LemmaSevenFlatSpec semanticLemmaSevenFlat
  rw [productView_flattenProduct]
  exact semanticLemmaSevenBasis_correct k n

/-- Final proof-bearing target for an actual gate-level Figure-9 construction. -/
structure LemmaSevenFlatProgramCertificate (k n : Nat) where
  program : ReversibleProgram (lemmaSevenFlatWidth k n)
  correctness :
    LemmaSevenFlatSpec k n (evalReversibleProgram program)

/-- Family-level gate target.  A future source reproduction must construct this
for every k,n and separately discharge `LemmaSevenResourceTarget`; the presence
of this structure alone contains no asymptotic assumption. -/
structure LemmaSevenFlatProgramFamily where
  program : (k n : Nat) → ReversibleProgram (lemmaSevenFlatWidth k n)
  correctness : ∀ k n,
    LemmaSevenFlatSpec k n (evalReversibleProgram (program k n))

end ComparatorIncrementerLemma7FlatContract
end QuantumBlockEncoding

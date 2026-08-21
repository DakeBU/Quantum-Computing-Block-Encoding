import QuantumBlockEncoding.ComparatorIncrementerLemma7BasisContract
import QuantumBlockEncoding.ComparatorIncrementerLemma7PromiseEmbedding
import Mathlib.Tactic

/-!
# Equation (38) inhabits the Lemma-7 basis strong-promise contract

The previous layers proved the dirty Equation-(38) protocol on explicit low and
high registers and embedded its dirty bit into a complete promise register.  The
last representation step is to identify

`floor(n/2) + ceil(n/2) = n`

at the dependent type level and transport the low/high target back to the public
`PrimitiveBasis n` register.

For `n >= 3`, the resulting permutation is stronger than the clean-branch source
contract: for every incoming promise basis state it preserves the full promise
register and performs the n-bit increment exactly when all k external controls
are one.  Hence it directly inhabits `LemmaSevenBasisSpec`.

This remains semantic implementation evidence.  The separate Figure-9 flat
`ReversibleProgram` certificate and its resource theorem are still required
before Lemma 7 is fully source-reproduced.
-/

namespace QuantumBlockEncoding
namespace ComparatorIncrementerLemma7Eq38BasisImplementation

open ComparatorIncrementerLemma7BasisContract
open ComparatorIncrementerLemma7Contract
open ComparatorIncrementerLemma7Eq38Semantics
open ComparatorIncrementerLemma7PromiseEmbedding
open PredicateControlledStrongPromise
open PrimitiveBasisRegisterSplit
open ZModPrimitiveBasisBridge

/-- Equality transport between primitive-basis register widths. -/
def basisWidthEquiv {a b : Nat} (equal : a = b) :
    PrimitiveBasis a ≃ PrimitiveBasis b := by
  subst b
  exact Equiv.refl _

@[simp] theorem basisWidthEquiv_rfl
    (a : Nat) (state : PrimitiveBasis a) :
    basisWidthEquiv (rfl : a = a) state = state := by
  rfl

/-- Width transport commutes exactly with the canonical modular incrementer. -/
theorem basisWidthEquiv_increment
    {a b : Nat} (equal : a = b) (state : PrimitiveBasis a) :
    basisWidthEquiv equal (basisModularIncrementEquiv a state) =
      basisModularIncrementEquiv b (basisWidthEquiv equal state) := by
  subst b
  rfl

/-- Split the public n-bit target into the exact Equation-(38) half widths. -/
def eq38TargetSplitEquiv (n : Nat) :
    PrimitiveBasis n ≃
      PrimitiveBasis (eq38LowWidth n) × PrimitiveBasis (eq38HighWidth n) :=
  (basisWidthEquiv (eq38_width_partition n).symm).trans
    (basisSplitEquiv (eq38LowWidth n) (eq38HighWidth n))

/-- Reader-facing register layout conversion from the public Lemma-7 order to
the structured Equation-(38) order. -/
def eq38LemmaSevenStateEquiv (k n : Nat) :
    (PrimitiveBasis k ×
      PrimitiveBasis (lemmaSevenPromiseWidth n) ×
      PrimitiveBasis n) ≃
    Eq38PromiseState
      k (lemmaSevenPromiseWidth n) (eq38LowWidth n) (eq38HighWidth n) where
  toFun state :=
    let split := eq38TargetSplitEquiv n state.2.2
    ((state.1, split.1), state.2.1, split.2)
  invFun state :=
    (state.1.1, state.2.1,
      (eq38TargetSplitEquiv n).symm (state.1.2, state.2.2))
  left_inv state := by
    rcases state with ⟨controls, promise, target⟩
    simp [eq38LemmaSevenStateEquiv]
  right_inv state := by
    rcases state with ⟨⟨controls, lowState⟩, promise, highState⟩
    simp [eq38LemmaSevenStateEquiv]

@[simp] theorem eq38LemmaSevenStateEquiv_apply
    (k n : Nat)
    (controls : PrimitiveBasis k)
    (promise : PrimitiveBasis (lemmaSevenPromiseWidth n))
    (target : PrimitiveBasis n) :
    eq38LemmaSevenStateEquiv k n (controls, promise, target) =
      let split := eq38TargetSplitEquiv n target
      ((controls, split.1), promise, split.2) := by
  rfl

@[simp] theorem eq38LemmaSevenStateEquiv_symm_apply
    (k n : Nat)
    (controls : PrimitiveBasis k)
    (lowState : PrimitiveBasis (eq38LowWidth n))
    (promise : PrimitiveBasis (lemmaSevenPromiseWidth n))
    (highState : PrimitiveBasis (eq38HighWidth n)) :
    (eq38LemmaSevenStateEquiv k n).symm
        ((controls, lowState), promise, highState) =
      (controls, promise,
        (eq38TargetSplitEquiv n).symm (lowState, highState)) := by
  rfl

/-- The source promise register is nonempty in the Equation-(38) regime, so its
first qubit can be selected as the borrowed dirty bit. -/
def lemmaSevenBorrowedDirtyWire
    (n : Nat) (large : 3 ≤ n) : Fin (lemmaSevenPromiseWidth n) :=
  ⟨0, by
    unfold lemmaSevenPromiseWidth
    omega⟩

/-- Semantic Equation-(38) implementation in the exact public Lemma-7 basis
register layout. -/
def eq38LemmaSevenBasisEquiv
    (k n : Nat) (large : 3 ≤ n) :
    Equiv.Perm
      (PrimitiveBasis k ×
        PrimitiveBasis (lemmaSevenPromiseWidth n) ×
        PrimitiveBasis n) :=
  (eq38LemmaSevenStateEquiv k n).trans
    ((eq38BorrowedPromiseEquiv
        k (lemmaSevenPromiseWidth n)
        (eq38LowWidth n) (eq38HighWidth n)
        (lemmaSevenBorrowedDirtyWire n large)).trans
      (eq38LemmaSevenStateEquiv k n).symm)

/-- The output target obtained from a split pair is the public n-bit modular
increment.  This isolates the only dependent-width transport in the proof. -/
theorem eq38_active_target_transport
    (n : Nat)
    (lowState : PrimitiveBasis (eq38LowWidth n))
    (highState : PrimitiveBasis (eq38HighWidth n)) :
    let splitInput :=
      (lowState, highState)
    let combinedInput :=
      combineBasis (eq38LowWidth n) (eq38HighWidth n) splitInput
    let incrementedPair :=
      basisSplitEquiv (eq38LowWidth n) (eq38HighWidth n)
        (basisModularIncrementEquiv
          (eq38LowWidth n + eq38HighWidth n) combinedInput)
    (eq38TargetSplitEquiv n).symm incrementedPair =
      basisModularIncrementEquiv n
        ((eq38TargetSplitEquiv n).symm splitInput) := by
  dsimp
  unfold eq38TargetSplitEquiv
  simp only [Equiv.trans_symm, Equiv.trans_apply, Equiv.symm_apply_apply]
  have commute := basisWidthEquiv_increment
    (eq38_width_partition n)
    (basisModularIncrementEquiv
      (eq38LowWidth n + eq38HighWidth n) |>.symm
      ((basisSplitEquiv (eq38LowWidth n) (eq38HighWidth n)).symm
        (lowState, highState)))
  -- The explicit term above is only a transport witness; simplify the split
  -- inverses before using the width-congruence commuting theorem.
  simp only [Equiv.symm_apply_apply] at commute
  exact commute

/-- Strong action theorem for arbitrary promise contents. -/
theorem eq38LemmaSevenBasis_action
    (k n : Nat) (large : 3 ≤ n)
    (controls : PrimitiveBasis k)
    (promise : PrimitiveBasis (lemmaSevenPromiseWidth n))
    (target : PrimitiveBasis n) :
    eq38LemmaSevenBasisEquiv k n large
        (controls, promise, target) =
      if allControlsActive controls = true then
        (controls, promise, basisModularIncrementEquiv n target)
      else
        (controls, promise, target) := by
  let split := eq38TargetSplitEquiv n target
  have borrowedAction := eq38BorrowedPromise_action
    k (lemmaSevenPromiseWidth n)
    (eq38LowWidth n) (eq38HighWidth n)
    (lemmaSevenBorrowedDirtyWire n large)
    controls split.1 promise split.2
  unfold eq38LemmaSevenBasisEquiv
  simp only [Equiv.trans_apply]
  rw [eq38LemmaSevenStateEquiv_apply]
  change
    (eq38LemmaSevenStateEquiv k n).symm
      (eq38BorrowedPromiseEquiv
        k (lemmaSevenPromiseWidth n)
        (eq38LowWidth n) (eq38HighWidth n)
        (lemmaSevenBorrowedDirtyWire n large)
        ((controls, split.1), promise, split.2)) = _
  rw [borrowedAction]
  by_cases external : allControlsActive controls = true
  · rw [if_pos external]
    rw [eq38LemmaSevenStateEquiv_symm_apply]
    have whole := eq38BorrowedPromise_matches_wholeWord
      k (lemmaSevenPromiseWidth n)
      (eq38LowWidth n) (eq38HighWidth n)
      (lemmaSevenBorrowedDirtyWire n large)
      controls split.1 promise split.2
    rw [eq38BorrowedPromise_action, if_pos external] at whole
    have pairEq :
        (basisModularIncrementEquiv (eq38LowWidth n) split.1,
          if allControlsActive split.1 = true then
            basisModularIncrementEquiv (eq38HighWidth n) split.2
          else split.2) =
        basisSplitEquiv (eq38LowWidth n) (eq38HighWidth n)
          (basisModularIncrementEquiv
            (eq38LowWidth n + eq38HighWidth n)
            (combineBasis (eq38LowWidth n) (eq38HighWidth n) split)) := by
      apply (basisSplitEquiv (eq38LowWidth n) (eq38HighWidth n)).symm.injective
      simpa using whole
    rw [pairEq]
    have transported := eq38_active_target_transport n split.1 split.2
    have reconstruct : (eq38TargetSplitEquiv n).symm split = target := by
      exact (eq38TargetSplitEquiv n).symm_apply_apply target
    rw [transported, reconstruct]
  · rw [if_neg external]
    rw [eq38LemmaSevenStateEquiv_symm_apply]
    exact congrArg (fun value => (controls, promise, value))
      ((eq38TargetSplitEquiv n).symm_apply_apply target)

/-- The Equation-(38) implementation restores both key and complete promise
register for every input, not merely on the clean-promise branch. -/
theorem eq38LemmaSevenBasis_restores
    (k n : Nat) (large : 3 ≤ n)
    (controls : PrimitiveBasis k)
    (promise : PrimitiveBasis (lemmaSevenPromiseWidth n))
    (target : PrimitiveBasis n) :
    (eq38LemmaSevenBasisEquiv k n large
      (controls, promise, target)).1 = controls ∧
    (eq38LemmaSevenBasisEquiv k n large
      (controls, promise, target)).2.1 = promise := by
  rw [eq38LemmaSevenBasis_action]
  split <;> exact ⟨rfl, rfl⟩

/-- Source Lemma-7 basis contract, now inhabited by the Equation-(38) dirty
promise construction for every width in the nontrivial source regime. -/
theorem eq38LemmaSevenBasis_correct
    (k n : Nat) (large : 3 ≤ n) :
    LemmaSevenBasisSpec k n (eq38LemmaSevenBasisEquiv k n large) := by
  constructor
  · intro controls target inactive
    rw [eq38LemmaSevenBasis_action]
    rw [inactive]
    rfl
  · constructor
    · intro controls target active
      rw [eq38LemmaSevenBasis_action]
      rw [active]
      rfl
    · intro controls promise target
      exact eq38LemmaSevenBasis_restores
        k n large controls promise target

end ComparatorIncrementerLemma7Eq38BasisImplementation
end QuantumBlockEncoding

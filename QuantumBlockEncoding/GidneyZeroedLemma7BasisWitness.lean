import QuantumBlockEncoding.ComparatorIncrementerLemma7BasisContract
import QuantumBlockEncoding.GidneyZeroedSourceStrongPromise
import QuantumBlockEncoding.PredicateControlledStrongPromise
import QuantumBlockEncoding.PrimitiveBasisRegisterSplit
import Mathlib.Tactic

/-!
# Concrete Gidney semantic witness for the public Lemma-7 basis contract

For an n=c+2 target, the gate-level Gidney source circuit uses c=n-2 workspace
bits.  Lemma 7 exposes an `(n-1)=c+1`-bit promise register because one additional
promise bit is available to the later dirty-ancilla control construction.

This module embeds the proved c-bit Gidney strong-promise implementation into
that public promise register by leaving the extra one-bit factor untouched.
The embedding is an exact register equivalence based on `basisSplitEquiv c 1`.
After adding the k-control all-ones predicate, the resulting permutation
inhabits the existing `LemmaSevenBasisSpec` for every k and c.

No gate/depth claim is inferred from this semantic padding.  Figure 9 and
Equations (36)-(38) remain the resource realization of the same contract.
-/

namespace QuantumBlockEncoding
namespace GidneyZeroedLemma7BasisWitness

open ComparatorIncrementerLemma7BasisContract
open ComparatorIncrementerLemma7Contract
open GidneyZeroedSourceProgram
open GidneyZeroedSourceStrongPromise
open PredicateControlledStrongPromise
open PrimitiveBasisRegisterSplit
open ZModPrimitiveBasisBridge

/-- One extra promise bit represented as a one-wire basis register. -/
abbrev ExtraPromise := PrimitiveBasis 1

/-- Split the public `(c+1)`-bit promise register into the c Gidney workspace
bits and one untouched extra promise bit. -/
def promiseSplitEquiv (c : Nat) :
    PrimitiveBasis (c + 1) ≃ PrimitiveBasis c × ExtraPromise :=
  basisSplitEquiv c 1

/-- Reassociate `(workspace × extra) × target` as
`extra × (workspace × target)`. -/
def reassociatePromiseTarget (c : Nat) :
    (PrimitiveBasis c × ExtraPromise) × PrimitiveBasis (targetWidth c) ≃
      ExtraPromise ×
        (PrimitiveBasis c × PrimitiveBasis (targetWidth c)) where
  toFun state := (state.1.2, (state.1.1, state.2))
  invFun state := ((state.2.1, state.1), state.2.2)
  left_inv state := by
    rcases state with ⟨⟨workspace, extra⟩, target⟩
    rfl
  right_inv state := by
    rcases state with ⟨extra, workspace, target⟩
    rfl

/-- Full coordinate change from public promise × target to
extra × (Gidney-workspace × target). -/
def paddedRegisterEquiv (c : Nat) :
    PrimitiveBasis (c + 1) × PrimitiveBasis (targetWidth c) ≃
      ExtraPromise ×
        (PrimitiveBasis c × PrimitiveBasis (targetWidth c)) :=
  (Equiv.prodCongr (promiseSplitEquiv c)
      (Equiv.refl (PrimitiveBasis (targetWidth c)))).trans
    (reassociatePromiseTarget c)

/-- Same actual Gidney source permutation, padded by one untouched promise bit
and transported back to the public `(c+1)`-bit promise register. -/
def paddedGidneyImplementation (c : Nat) :
    Equiv.Perm
      (PrimitiveBasis (c + 1) × PrimitiveBasis (targetWidth c)) :=
  (paddedRegisterEquiv c).trans
    ((Equiv.prodCongr (Equiv.refl ExtraPromise)
      (GidneyZeroedSourceStrongPromise.implementation c)).trans
      (paddedRegisterEquiv c).symm)

/-- Canonical all-zero public promise register. -/
def zeroPublicPromise (c : Nat) : PrimitiveBasis (c + 1) :=
  fun _ => 0

/-- Splitting the public zero promise yields zero Gidney workspace and zero
extra promise bit. -/
theorem split_zeroPublicPromise (c : Nat) :
    promiseSplitEquiv c (zeroPublicPromise c) =
      (zeroWorkspace c, fun _ => 0) := by
  apply Prod.ext
  · funext wire
    rfl
  · funext wire
    fin_cases wire
    rfl

/-- Padded implementation is a strong promise gate with the public zero promise
state. -/
theorem paddedGidney_strongPromise (c : Nat) :
    PromiseGateOptimization.StrongPromiseSpec
      (zeroPublicPromise c)
      (paddedGidneyImplementation c)
      (basisModularIncrementEquiv (targetWidth c)) := by
  have sourceStrong := GidneyZeroedSourceStrongPromise.strongPromiseSpec c
  constructor
  · intro target
    apply (paddedRegisterEquiv c).injective
    simp [paddedGidneyImplementation, paddedRegisterEquiv,
      reassociatePromiseTarget, split_zeroPublicPromise,
      sourceStrong.1 target]
  · intro promise target
    have restored := sourceStrong.2
    apply congrArg Prod.fst
    apply (paddedRegisterEquiv c).injective
    simp [paddedGidneyImplementation, paddedRegisterEquiv,
      reassociatePromiseTarget, restored]

/-- Add the external k-control all-ones predicate to the padded actual source
circuit. -/
def controlledImplementation (k c : Nat) :
    Equiv.Perm
      (PrimitiveBasis k ×
        PrimitiveBasis (c + 1) × PrimitiveBasis (targetWidth c)) :=
  predicateControlledPromiseEquiv
    allControlsActive (paddedGidneyImplementation c)

/-- Main bridge: the actual gate-level Gidney source family, padded by the one
extra promise bit declared by Lemma 7, is a semantic witness of the existing
public basis contract. -/
theorem lemmaSevenBasisSpec
    (k c : Nat) :
    ComparatorIncrementerLemma7BasisContract.LemmaSevenBasisSpec
      k (c + 2) (controlledImplementation k c) := by
  have controlled := predicateControlledPromise_of_strong
    allControlsActive
    (zeroPublicPromise c)
    (paddedGidneyImplementation c)
    (basisModularIncrementEquiv (targetWidth c))
    (paddedGidney_strongPromise c)
  simpa [ComparatorIncrementerLemma7Contract.lemmaSevenPromiseWidth,
    targetWidth, zeroPublicPromise] using controlled

end GidneyZeroedLemma7BasisWitness
end QuantumBlockEncoding
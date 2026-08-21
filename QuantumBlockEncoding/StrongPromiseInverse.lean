import QuantumBlockEncoding.PromiseGateOptimization
import Mathlib.Tactic

/-!
# Strong promise gates are closed under inverse

A strong promise permutation preserves its promise register on every basis
input, and on the distinguished clean promise branch acts by a target
permutation U.  Since the whole implementation is bijective and preserves each
promise fibre, its inverse also preserves every promise fibre and acts by U^-1
on the clean branch.

This small lemma is shared by Vandaele's increment/decrement construction and
later compute/use/uncompute promise circuits.
-/

namespace QuantumBlockEncoding
namespace StrongPromiseInverse

open PromiseGateOptimization

/-- A strong promise specification transfers exactly to the inverse
implementation and inverse target. -/
theorem strongPromise_symm
    {ρ α : Type*}
    (cleanPromise : ρ)
    (implementation : Equiv.Perm (ρ × α))
    (target : Equiv.Perm α)
    (strong : StrongPromiseSpec cleanPromise implementation target) :
    StrongPromiseSpec cleanPromise implementation.symm target.symm := by
  constructor
  · intro value
    have forward := strong.1 (target.symm value)
    have inverse := congrArg implementation.symm forward
    simpa using inverse
  · intro promise value
    let preimage := implementation.symm (promise, value)
    have forwardPromise := strong.2 preimage.1 preimage.2
    have roundTrip := implementation.apply_symm_apply (promise, value)
    have promiseEq : preimage.1 = promise := by
      have firstRoundTrip := congrArg Prod.fst roundTrip
      simpa [preimage, forwardPromise] using firstRoundTrip
    exact promiseEq

/-- Weak clean-branch form, for consumers that do not need the full restored
promise theorem. -/
theorem weakPromise_symm
    {ρ α : Type*}
    (cleanPromise : ρ)
    (implementation : Equiv.Perm (ρ × α))
    (target : Equiv.Perm α)
    (strong : StrongPromiseSpec cleanPromise implementation target) :
    WeakPromiseSpec cleanPromise implementation.symm target.symm :=
  (strongPromise_symm cleanPromise implementation target strong).1

end StrongPromiseInverse
end QuantumBlockEncoding
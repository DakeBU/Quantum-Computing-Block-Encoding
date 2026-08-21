import QuantumBlockEncoding.PromiseGateOptimization
import QuantumBlockEncoding.VandaeleCorollary1ResourceClosure
import QuantumBlockEncoding.VandaeleLadderRefinement
import Mathlib.Tactic

/-!
# General strong-promise ladder target for Vandaele Corollary 4

Appendix A.3 first proves the second-order `L_2^(n)` strong-promise statement
and then says the general `L_k^(n)` case follows from the Appendix-A.2
construction: the outer `C^k X` layers also occur in compute/uncompute pairs.

The flat gate-level realization depends on the concrete Appendix-(63) schedule,
but the source theorem itself has a clean proof-bearing interface:

* an n-bit promise register is preserved for every incoming basis value;
* on the all-zero promise fibre the data action is the source `L_k^(n)`
  operator;
* the gate/depth/ancilla functions satisfy the same uniform Corollary-1 resource
  target.

The target permutation is not opaque: it is `naiveLadderEquiv`, already proved
in `VandaeleLadderRefinement` to realize the authoritative closed-form
Equation (5).
-/

namespace QuantumBlockEncoding
namespace VandaeleCorollary4General

open PromiseGateOptimization
open VandaeleCorollary1ResourceClosure
open VandaeleLadderContract
open VandaeleLadderPermutation
open VandaeleLadderRefinement

/-- Canonical all-zero n-bit promise register. -/
def zeroPromise (steps : Nat) : PrimitiveBasis steps :=
  fun _ => 0

/-- Source-facing strong-promise contract for general `L_k^(n)`.  The parameter
`localControls` represents k-1 fresh controls per ladder block. -/
def GeneralStrongPromiseSpec
    (localControls steps : Nat)
    (implementation : Equiv.Perm
      (PrimitiveBasis steps × LadderState localControls steps)) : Prop :=
  StrongPromiseSpec
    (zeroPromise steps)
    implementation
    (naiveLadderEquiv localControls steps)

/-- Complete source family interface for the general Corollary-4 statement. -/
structure GeneralStrongPromiseFamily where
  implementation : (localControls steps : Nat) ->
    Equiv.Perm (PrimitiveBasis steps × LadderState localControls steps)
  gateCount : Nat -> Nat -> Nat
  depth : Nat -> Nat -> Nat
  ancillas : Nat -> Nat -> Nat
  strongCorrectness : ∀ localControls steps,
    GeneralStrongPromiseSpec localControls steps
      (implementation localControls steps)
  resources :
    CorollaryOneUniformResourceTarget gateCount depth ancillas

/-- The clean promise branch executes the actual source ladder permutation. -/
theorem clean_branch_action
    (family : GeneralStrongPromiseFamily)
    (localControls steps : Nat)
    (state : LadderState localControls steps) :
    family.implementation localControls steps
        (zeroPromise steps, state) =
      (zeroPromise steps, naiveLadderEquiv localControls steps state) :=
  (family.strongCorrectness localControls steps).1 state

/-- Since the ladder target is source-certified, the clean branch is exactly the
closed-form Equation-(5) action. -/
theorem clean_branch_eq_equationFive
    (family : GeneralStrongPromiseFamily)
    (localControls steps : Nat)
    (state : LadderState localControls steps) :
    (family.implementation localControls steps
      (zeroPromise steps, state)).2 =
      equationFiveAction localControls steps state := by
  rw [clean_branch_action family localControls steps state]
  exact naiveLadderEquiv_spec localControls steps state

/-- Promise restoration is unconditional. -/
theorem restores_promise
    (family : GeneralStrongPromiseFamily)
    (localControls steps : Nat)
    (promise : PrimitiveBasis steps)
    (state : LadderState localControls steps) :
    (family.implementation localControls steps (promise, state)).1 = promise :=
  (family.strongCorrectness localControls steps).2 promise state

/-- Corollary-1 resources are inherited verbatim by the strong-promise
realization because Appendix A.3 changes the interpretation of the workspace,
not the circuit. -/
theorem family_resources
    (family : GeneralStrongPromiseFamily) :
    CorollaryOneUniformResourceTarget
      family.gateCount family.depth family.ancillas :=
  family.resources

/-- A realization constructor that keeps semantic and resource evidence tied to
one family object. -/
def ofRealization
    (implementation : (localControls steps : Nat) ->
      Equiv.Perm (PrimitiveBasis steps × LadderState localControls steps))
    (gateCount depth ancillas : Nat -> Nat -> Nat)
    (strongCorrectness : ∀ localControls steps,
      GeneralStrongPromiseSpec localControls steps
        (implementation localControls steps))
    (resources : CorollaryOneUniformResourceTarget gateCount depth ancillas) :
    GeneralStrongPromiseFamily where
  implementation := implementation
  gateCount := gateCount
  depth := depth
  ancillas := ancillas
  strongCorrectness := strongCorrectness
  resources := resources

end VandaeleCorollary4General
end QuantumBlockEncoding

import QuantumBlockEncoding.PredicateControlledConjugation
import Mathlib.Tactic

/-!
# Source-facing contract for Vandaele Lemma 5

Lemma 5 considers a layer `U = ⊗ᵢ Uᵢ` of n independent involutory gates and
shows that its k-controlled version admits O(n+k) gate count and
O(log n + log k) depth without ancillas. The source proof uses the dirty-flag
identity, splits the independent gates into two subsets, and combines fan-out
with two C^k X gates (Equations (13)-(14)).

This file fixes the exact product-register semantics and distinguishes:

* an explicit finite-instance resource inequality with named constants;
* the genuine uniform asymptotic family target, where the constants are chosen
  once and must work for every n and k.

The latter distinction prevents a vacuous per-instance interpretation of Big-O.
-/

namespace QuantumBlockEncoding
namespace VandaeleLemma5Contract

open PredicateControlledConjugation

/-- Pointwise product action of an indexed family of reversible gates. -/
def productAction {α : Type*} {n : Nat}
    (gates : Fin n → Equiv.Perm α)
    (state : Fin n → α) : Fin n → α :=
  fun index => gates index (state index)

/-- The product action is a permutation, with inverse taken componentwise. -/
def productEquiv {α : Type*} {n : Nat}
    (gates : Fin n → Equiv.Perm α) :
    Equiv.Perm (Fin n → α) where
  toFun := productAction gates
  invFun := fun state index => (gates index).symm (state index)
  left_inv state := by
    funext index
    simp [productAction]
  right_inv state := by
    funext index
    simp [productAction]

/-- Source involution hypothesis, stated pointwise. -/
def AllInvolutory {α : Type*} {n : Nat}
    (gates : Fin n → Equiv.Perm α) : Prop :=
  ∀ index value, gates index (gates index value) = value

/-- Under the source hypothesis, the whole product layer is also involutory. -/
theorem productEquiv_involutive
    {α : Type*} {n : Nat}
    (gates : Fin n → Equiv.Perm α)
    (involutory : AllInvolutory gates) :
    Function.Involutive (productEquiv gates) := by
  intro state
  funext index
  exact involutory index (state index)

/-- k-control semantics represented by an arbitrary key predicate. -/
def controlledProductEquiv {κ α : Type*} {n : Nat}
    (active : κ → Bool)
    (gates : Fin n → Equiv.Perm α) :
    Equiv.Perm (κ × (Fin n → α)) :=
  predicateControlledTargetEquiv active (productEquiv gates)

/-- Exact pointwise action: inactive keys preserve every component; active keys
apply the corresponding U_i independently. -/
theorem controlledProduct_action
    {κ α : Type*} {n : Nat}
    (active : κ → Bool)
    (gates : Fin n → Equiv.Perm α)
    (key : κ) (state : Fin n → α) :
    controlledProductEquiv active gates (key, state) =
      if active key then
        (key, fun index => gates index (state index))
      else (key, state) := by
  cases condition : active key <;>
    simp [controlledProductEquiv, predicateControlledTargetEquiv,
      productEquiv, productAction, condition]

/-- Totalized logarithmic scale in the source depth statement. -/
def depthScale (n controls : Nat) : Nat :=
  (Nat.log2 (n + 1) + 1) + (Nat.log2 (controls + 1) + 1)

/-- Non-asymptotic evidence for one concrete instance. The constants are stored
explicitly rather than existentially hidden inside the proposition. -/
def LemmaFiveInstanceResourceBound
    (n controls gateCount depth ancillas
      gateConstant depthConstant : Nat) : Prop :=
  gateCount ≤ gateConstant * (n + controls + 1) ∧
  depth ≤ depthConstant * depthScale n controls ∧
  ancillas = 0

/-- Genuine uniform O(n+k), O(log n + log k), zero-ancilla target.
The constants are chosen before n and k and therefore have real asymptotic
content. -/
def LemmaFiveUniformResourceTarget
    (gateCount depth ancillas : Nat → Nat → Nat) : Prop :=
  ∃ gateConstant depthConstant : Nat,
    ∀ n controls,
      gateCount n controls ≤ gateConstant * (n + controls + 1) ∧
      depth n controls ≤ depthConstant * depthScale n controls ∧
      ancillas n controls = 0

/-- A uniform target immediately yields an explicit bound for every finite
instance using the same constants. -/
theorem uniformResourceTarget_instance
    (gateCount depth ancillas : Nat → Nat → Nat)
    (uniform : LemmaFiveUniformResourceTarget gateCount depth ancillas) :
    ∃ gateConstant depthConstant : Nat,
      ∀ n controls,
        LemmaFiveInstanceResourceBound
          n controls (gateCount n controls) (depth n controls)
          (ancillas n controls) gateConstant depthConstant := by
  rcases uniform with ⟨gateConstant, depthConstant, bound⟩
  exact ⟨gateConstant, depthConstant, bound⟩

/-- Completion record for one concrete Equation (13)/(14) realization.
This is a finite certificate, not by itself the asymptotic Lemma 5 theorem. -/
structure LemmaFiveInstanceCertificate
    {κ α : Type*} {n : Nat}
    (active : κ → Bool)
    (gates : Fin n → Equiv.Perm α) where
  implementation : Equiv.Perm (κ × (Fin n → α))
  controlCount : Nat
  gateCount : Nat
  depth : Nat
  ancillas : Nat
  gateConstant : Nat
  depthConstant : Nat
  semanticCorrectness :
    implementation = controlledProductEquiv active gates
  resources :
    LemmaFiveInstanceResourceBound
      n controlCount gateCount depth ancillas
      gateConstant depthConstant

end VandaeleLemma5Contract
end QuantumBlockEncoding

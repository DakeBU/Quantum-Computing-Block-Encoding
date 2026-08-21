import QuantumBlockEncoding.PredicateControlledConjugation
import Mathlib.Tactic

/-!
# Source-facing contract for Vandaele Lemma 5

Lemma 5 considers a layer `U = ⊗ᵢ Uᵢ` of n independent involutory gates and
shows that its k-controlled version admits O(n+k) gate count and
O(log n + log k) depth without ancillas.  The source proof uses the dirty-flag
identity, splits the independent gates into two subsets, and combines fan-out
with two C^k X gates (Equations (13)-(14)).

This file fixes the exact product-register semantics and the quantitative target.
The actual Equation (13)/(14) circuit is still a construction obligation; no
resource claim is postulated.
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

/-- Totalized source resource target for Lemma 5. -/
def LemmaFiveResourceTarget
    (n controls gateCount depth ancillas : Nat) : Prop :=
  (∃ constant : Nat,
    gateCount ≤ constant * (n + controls + 1)) ∧
  (∃ constant : Nat,
    depth ≤ constant *
      ((Nat.log2 (n + 1) + 1) +
        (Nat.log2 (controls + 1) + 1))) ∧
  ancillas = 0

/-- Completion record for a concrete Equation (13)/(14) realization. -/
structure LemmaFiveCertificate
    {κ α : Type*} {n : Nat}
    (active : κ → Bool)
    (gates : Fin n → Equiv.Perm α) where
  implementation : Equiv.Perm (κ × (Fin n → α))
  controlCount : Nat
  gateCount : Nat
  depth : Nat
  ancillas : Nat
  semanticCorrectness :
    implementation = controlledProductEquiv active gates
  resources :
    LemmaFiveResourceTarget n controlCount gateCount depth ancillas

end VandaeleLemma5Contract
end QuantumBlockEncoding

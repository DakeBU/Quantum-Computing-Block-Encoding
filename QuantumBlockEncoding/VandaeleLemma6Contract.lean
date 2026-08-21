import QuantumBlockEncoding.ComparatorIncrementerRecurrence
import QuantumBlockEncoding.ControlledStrongPromise
import QuantumBlockEncoding.VandaeleVOperator

/-!
# Vandaele Lemma 6: controlled strong-promise V2 contract

Lemma 6 is the comparator analogue of Lemma 8.  For the source operator
`V_2^(N)`, it supplies a controlled strong promise gate with promise width
`2 ceil(sqrt N)`, O(N) gates, and O(log N) depth.

`VandaeleVOperator` now provides the actual source-certified V2 target.  This
module fixes the exact promise semantics around that target and keeps the
Figure-6 low-depth circuit as a separate implementation/resource obligation.

Our `sourceV2SuccEquiv m` denotes `V_2^(m+1)`, so all source width formulas below
use `N=m+1` explicitly rather than hiding the off-by-one in notation.
-/

namespace QuantumBlockEncoding
namespace VandaeleLemma6Contract

open ComparatorIncrementerRecurrence
open ControlledStrongPromise
open PromiseGateOptimization
open VandaeleVOperator

/-- Source V2 block parameter N represented by `sourceV2SuccEquiv m`. -/
def sourceWidth (m : Nat) : Nat := m + 1

/-- Promise width from Lemma 6. -/
def promiseWidth (m : Nat) : Nat :=
  2 * ceilSqrt (sourceWidth m)

/-- All-zero promise register. -/
def zeroPromise (m : Nat) : PrimitiveBasis (promiseWidth m) :=
  fun _ => 0

/-- Exact strong-promise target for `V_2^(m+1)`. -/
def StrongV2Spec (m : Nat)
    (implementation : Equiv.Perm
      (PrimitiveBasis (promiseWidth m) ×
        VandaeleLadderContract.LadderState 1 (m + 1))) : Prop :=
  StrongPromiseSpec
    (zeroPromise m)
    implementation
    (sourceV2SuccEquiv m)

/-- Controlled Lemma-6 target. -/
def ControlledStrongV2Spec (m : Nat)
    (implementation : Equiv.Perm
      (Bool × PrimitiveBasis (promiseWidth m) ×
        VandaeleLadderContract.LadderState 1 (m + 1))) : Prop :=
  ControlledStrongPromiseSpec
    (zeroPromise m)
    implementation
    (sourceV2SuccEquiv m)

/-- Semantic promise lift used only to show the contract is consistent; it is
not Figure 6 and carries no low-resource claim. -/
def semanticStrongV2 (m : Nat) :
    Equiv.Perm
      (PrimitiveBasis (promiseWidth m) ×
        VandaeleLadderContract.LadderState 1 (m + 1)) :=
  Equiv.prodCongr (Equiv.refl _) (sourceV2SuccEquiv m)

/-- The semantic lift is a strong promise gate. -/
theorem semanticStrongV2_correct (m : Nat) :
    StrongV2Spec m (semanticStrongV2 m) := by
  constructor
  · intro value
    rfl
  · intro promise value
    rfl

/-- Add the external Boolean control without changing promise semantics. -/
def semanticControlledStrongV2 (m : Nat) :
    Equiv.Perm
      (Bool × PrimitiveBasis (promiseWidth m) ×
        VandaeleLadderContract.LadderState 1 (m + 1)) :=
  controlledStrongPromiseEquiv (semanticStrongV2 m)

/-- Exact semantic Lemma-6 contract. -/
theorem semanticControlledStrongV2_correct (m : Nat) :
    ControlledStrongV2Spec m (semanticControlledStrongV2 m) := by
  exact controlledStrongPromise_of_strong
    (zeroPromise m)
    (semanticStrongV2 m)
    (sourceV2SuccEquiv m)
    (semanticStrongV2_correct m)

/-- Uniform source resource target for the eventual Figure-6 scheduled family. -/
def ResourceTarget (gateCount depth : Nat → Nat) : Prop :=
  (∃ gateConstant : Nat, ∀ m,
    gateCount m ≤ gateConstant * (sourceWidth m + 1)) ∧
  (∃ depthConstant : Nat, ∀ m,
    depth m ≤ depthConstant *
      (Nat.log2 (sourceWidth m + 1) + 1))

/-- Complete proof-bearing Lemma-6 family interface.  A value of this structure
must tie semantic correctness and resources to the same circuit family. -/
structure FamilyCertificate where
  implementation : (m : Nat) → Equiv.Perm
    (Bool × PrimitiveBasis (promiseWidth m) ×
      VandaeleLadderContract.LadderState 1 (m + 1))
  gateCount : Nat → Nat
  depth : Nat → Nat
  correctness : ∀ m,
    ControlledStrongV2Spec m (implementation m)
  resources : ResourceTarget gateCount depth

end VandaeleLemma6Contract
end QuantumBlockEncoding

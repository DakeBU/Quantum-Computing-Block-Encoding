import QuantumBlockEncoding.ComparatorIncrementerModularConjugation
import QuantumBlockEncoding.ComparatorIncrementerRecurrence
import QuantumBlockEncoding.ControlledStrongPromise

/-!
# Semantic contract for Vandaele Lemma 8

Lemma 8 states that a controlled strong promise gate with a promise register of
size `2 ceil(sqrt n)` and target unitary equal to the n-bit incrementer admits an
implementation with O(n) `{CCX,CX,X}` gates and O(log n) depth.

ASPBE separates this into two layers:

1. the exact controlled-strong-promise semantics, formalized here;
2. the concrete Figure 10 / source circuit and its resource bounds, still an
   implementation obligation.

The semantic target is represented by modular arithmetic on `ZMod (2^n)`.
A later little-endian representation bridge must identify the concrete n-wire
basis action with this algebraic target before the paper-wide theorem is marked
reproduced.
-/

namespace QuantumBlockEncoding
namespace ComparatorIncrementerLemma8Contract

open ComparatorIncrementerModularConjugation
open ComparatorIncrementerRecurrence
open ControlledStrongPromise
open PromiseGateOptimization

/-- All-zero promise-register basis value from Definitions 3.1/3.2. -/
def zeroPromiseBasis (width : Nat) : PrimitiveBasis width :=
  fun _ => 0

/-- Generic promise-preserving lift of a target permutation.  This is a semantic
witness only; it carries no low-resource circuit claim. -/
def preservePromiseLift {ρ α : Type*} (target : Equiv.Perm α) :
    Equiv.Perm (ρ × α) :=
  Equiv.prodCongr (Equiv.refl ρ) target

/-- The promise-preserving lift is a strong promise gate for any designated
clean promise value. -/
theorem preservePromiseLift_strong
    {ρ α : Type*} (cleanPromise : ρ) (target : Equiv.Perm α) :
    StrongPromiseSpec cleanPromise (preservePromiseLift (ρ := ρ) target) target := by
  constructor
  · intro value
    rfl
  · intro promise value
    rfl

/-- Lemma 8 promise-register width, identical to Theorem 4's `alpha`. -/
def lemmaEightPromiseWidth (n : Nat) : Nat := alpha n

@[simp] theorem lemmaEightPromiseWidth_eq (n : Nat) :
    lemmaEightPromiseWidth n = 2 * ceilSqrt n := by
  rfl

/-- Strong-promise semantic contract for an n-bit modular increment target. -/
def IncrementStrongPromiseSpec (n : Nat)
    (implementation : Equiv.Perm
      (PrimitiveBasis (lemmaEightPromiseWidth n) × ZMod (gridSize n))) : Prop :=
  StrongPromiseSpec
    (zeroPromiseBasis (lemmaEightPromiseWidth n))
    implementation
    (modularIncrementEquiv (gridSize n))

/-- Controlled form of the same source contract. -/
def ControlledIncrementStrongPromiseSpec (n : Nat)
    (implementation : Equiv.Perm
      (Bool × PrimitiveBasis (lemmaEightPromiseWidth n) × ZMod (gridSize n))) : Prop :=
  ControlledStrongPromiseSpec
    (zeroPromiseBasis (lemmaEightPromiseWidth n))
    implementation
    (modularIncrementEquiv (gridSize n))

/-- Canonical semantic strong-promise witness.  It increments the target on all
promise branches, which is stronger than required but says nothing about circuit
resources. -/
def semanticIncrementStrongPromise (n : Nat) :
    Equiv.Perm
      (PrimitiveBasis (lemmaEightPromiseWidth n) × ZMod (gridSize n)) :=
  preservePromiseLift (modularIncrementEquiv (gridSize n))

/-- The canonical semantic witness satisfies Definition 3.2 exactly. -/
theorem semanticIncrementStrongPromise_correct (n : Nat) :
    IncrementStrongPromiseSpec n (semanticIncrementStrongPromise n) := by
  exact preservePromiseLift_strong
    (zeroPromiseBasis (lemmaEightPromiseWidth n))
    (modularIncrementEquiv (gridSize n))

/-- Add the external control appearing in Lemma 8. -/
def semanticControlledIncrementStrongPromise (n : Nat) :
    Equiv.Perm
      (Bool × PrimitiveBasis (lemmaEightPromiseWidth n) × ZMod (gridSize n)) :=
  controlledStrongPromiseEquiv (semanticIncrementStrongPromise n)

/-- Lemma 8's controlled strong-promise behavior is semantically inhabited for
every n.  The missing theorem is that Figure 10 realizes this behavior with the
claimed gate/depth bounds. -/
theorem semanticControlledIncrementStrongPromise_correct (n : Nat) :
    ControlledIncrementStrongPromiseSpec n
      (semanticControlledIncrementStrongPromise n) := by
  exact controlledStrongPromise_of_strong
    (zeroPromiseBasis (lemmaEightPromiseWidth n))
    (semanticIncrementStrongPromise n)
    (modularIncrementEquiv (gridSize n))
    (semanticIncrementStrongPromise_correct n)

/-- Promise restoration is unconditional, exactly as required for the strong
variant. -/
theorem semanticControlledIncrementStrongPromise_restoresPromise
    (n : Nat) (control : Bool)
    (promise : PrimitiveBasis (lemmaEightPromiseWidth n))
    (value : ZMod (gridSize n)) :
    (semanticControlledIncrementStrongPromise n
      (control, promise, value)).2.1 = promise := by
  exact controlledStrongPromise_restores_promise
    (zeroPromiseBasis (lemmaEightPromiseWidth n))
    (semanticIncrementStrongPromise n)
    (modularIncrementEquiv (gridSize n))
    (semanticIncrementStrongPromise_correct n)
    control promise value

/-- Source resource target kept as a proposition name rather than an axiom.
A future concrete circuit family must discharge this together with the semantic
contract before Lemma 8 is considered fully formalized. -/
def LemmaEightResourceTarget
    (gateCount depth : Nat → Nat) : Prop :=
  (∃ constant : Nat, ∀ n, gateCount n ≤ constant * (n + 1)) ∧
  (∃ constant : Nat, ∀ n,
    depth n ≤ constant * (Nat.log2 (n + 1) + 1))

end ComparatorIncrementerLemma8Contract
end QuantumBlockEncoding

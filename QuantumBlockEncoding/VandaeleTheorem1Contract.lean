import QuantumBlockEncoding.PredicateControlledConjugation
import Mathlib.Tactic

/-!
# Source-facing contract for Vandaele Theorem 1

Theorem 1 is the paper's general "add controls, save ancillae" result.  If
`W = V† U V` and V/U admit implementations with m clean ancillas, source gate
counts `cV,cU`, and depths `dV,dU`, then the k-controlled W construction has

* gate count `O(cV + cU + dU*n + k)`,
* depth `O(dV + dU*log n + log k)`,
* at most `max(1, m-k+1)` clean ancillas.

Under the strong-promise preservation hypotheses and `U^2=I`, one clean ancilla
can instead be replaced by one dirty ancilla with the same asymptotic gate/depth
scales.

The exact controlled-conjugation semantics is already proved in
`PredicateControlledConjugation`.  This module freezes the source resource
parameters and ancilla arithmetic.  A complete Theorem 1 reproduction still
needs the concrete Lemma 5 / promise-register circuit refinement proving the
resource inequalities; no such implementation is assumed here.
-/

namespace QuantumBlockEncoding
namespace VandaeleTheorem1Contract

open PredicateControlledConjugation
open PromiseGateOptimization

/-- Deterministic source parameters appearing in Theorem 1. -/
structure SourceParameters where
  targetQubits : Nat
  controls : Nat
  sourceCleanAncillas : Nat
  outerGateCount : Nat
  middleGateCount : Nat
  outerDepth : Nat
  middleDepth : Nat
  deriving DecidableEq, Repr

/-- Additive gate-count scale inside the source Big-O statement. -/
def gateScale (p : SourceParameters) : Nat :=
  p.outerGateCount + p.middleGateCount +
    p.middleDepth * p.targetQubits + p.controls

/-- Totalized logarithmic scale inside the source depth statement.  `+1` makes
the expression well-defined for zero-width boundary values without changing
its asymptotic meaning in the source regime. -/
def depthScale (p : SourceParameters) : Nat :=
  p.outerDepth +
    p.middleDepth * (Nat.log2 (p.targetQubits + 1) + 1) +
    (Nat.log2 (p.controls + 1) + 1)

/-- Exact clean-ancilla budget stated by Theorem 1. -/
def cleanAncillaBudget (p : SourceParameters) : Nat :=
  max 1 (p.sourceCleanAncillas - p.controls + 1)

@[simp] theorem cleanAncillaBudget_pos (p : SourceParameters) :
    0 < cleanAncillaBudget p := by
  unfold cleanAncillaBudget
  exact lt_of_lt_of_le Nat.zero_lt_one (Nat.le_max_left _ _)

/-- When k controls replace at least all m source clean ancillas, the theorem
still retains one clean workspace bit. -/
theorem cleanAncillaBudget_eq_one_of_many_controls
    (p : SourceParameters)
    (many : p.sourceCleanAncillas ≤ p.controls) :
    cleanAncillaBudget p = 1 := by
  unfold cleanAncillaBudget
  have remaining : p.sourceCleanAncillas - p.controls = 0 :=
    Nat.sub_eq_zero_of_le many
  simp [remaining]

/-- Strong/involutory variant: replace exactly one guaranteed clean bit by a
dirty bit. -/
def dirtyVariantCleanAncillas (p : SourceParameters) : Nat :=
  cleanAncillaBudget p - 1

/-- The source strong variant uses one dirty ancilla. -/
def dirtyVariantDirtyAncillas (_p : SourceParameters) : Nat := 1

/-- Since the clean budget is always positive, replacing one clean by one dirty
preserves the total workspace count exactly. -/
theorem dirty_variant_preserves_workspace_count
    (p : SourceParameters) :
    dirtyVariantCleanAncillas p + dirtyVariantDirtyAncillas p =
      cleanAncillaBudget p := by
  unfold dirtyVariantCleanAncillas dirtyVariantDirtyAncillas
  exact Nat.sub_add_cancel (cleanAncillaBudget_pos p)

/-- Big-O-free target proposition for one concrete output circuit.  The
constants are explicit evidence supplied by a future implementation proof. -/
def ResourceTarget (p : SourceParameters)
    (gateCount depth cleanAncillas : Nat) : Prop :=
  (∃ constant : Nat, gateCount ≤ constant * (gateScale p + 1)) ∧
  (∃ constant : Nat, depth ≤ constant * (depthScale p + 1)) ∧
  cleanAncillas ≤ cleanAncillaBudget p

/-- Strong/involutory resource target with one dirty bit replacing one clean
bit. -/
def DirtyResourceTarget (p : SourceParameters)
    (gateCount depth cleanAncillas dirtyAncillas : Nat) : Prop :=
  (∃ constant : Nat, gateCount ≤ constant * (gateScale p + 1)) ∧
  (∃ constant : Nat, depth ≤ constant * (depthScale p + 1)) ∧
  cleanAncillas ≤ dirtyVariantCleanAncillas p ∧
  dirtyAncillas = 1

/-- Semantic algebraic core of Theorem 1: for an arbitrary k-control predicate,
controlling `V† U V` is exactly equivalent to leaving V,V† uncontrolled and
controlling only U. -/
theorem semantic_control_reduction
    {κ α : Type*} (active : κ → Bool)
    (outer middle : Equiv.Perm α) :
    ((liftKeyTargetEquiv outer).trans
        (predicateControlledTargetEquiv active middle)).trans
          (liftKeyTargetEquiv outer.symm) =
      predicateControlledTargetEquiv active
        (conjugatedTargetEquiv outer middle) :=
  predicateControlledConjugation_equiv active outer middle

/-- Completion certificate expected from a fully formalized source
implementation.  Merely constructing this record requires both the exact
semantic identity and explicit resource evidence. -/
structure TheoremOneCertificate
    {κ α : Type*} (active : κ → Bool)
    (outer middle : Equiv.Perm α) where
  parameters : SourceParameters
  implementation : Equiv.Perm (κ × α)
  gateCount : Nat
  depth : Nat
  cleanAncillas : Nat
  semanticCorrectness :
    implementation = predicateControlledTargetEquiv active
      (conjugatedTargetEquiv outer middle)
  resources : ResourceTarget parameters gateCount depth cleanAncillas

end VandaeleTheorem1Contract
end QuantumBlockEncoding

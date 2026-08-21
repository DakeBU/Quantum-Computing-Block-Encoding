import QuantumBlockEncoding.ComparatorIncrementerControlledAllX
import QuantumBlockEncoding.Robin.ComplexLCU
import Mathlib.Tactic

/-!
# Vandaele fan-out identity behind Eq. (37)

Definition 2.2 of arXiv:2603.12917 isolates fan-out as a structural primitive.
Equation (37) then implements the k-controlled fan-out required by Eq. (36)
using

1. one ordinary single-pivot fan-out,
2. one multi-controlled toggle of that pivot,
3. the same ordinary fan-out again.

The first fan-out copies the *old* pivot parity into every target; after the
multi-controlled toggle the second fan-out copies the *new* pivot parity.  The
old pivot cancels, so every target is toggled exactly by the external
multi-control predicate, while the pivot itself receives the same predicate.

This module proves that semantic circuit identity exactly.  It deliberately does
not claim Lemma 2's O(log n) fan-out depth: ASPBE's current concrete
`ComparatorIncrementerControlledAllX.controlledAllXProgram` is a serial CX
baseline with exact semantics, whereas the source paper's depth-optimized
fan-out implementation remains a separate construction obligation.
-/

namespace QuantumBlockEncoding
namespace ComparatorIncrementerFanoutIdentity

open Robin.ComplexLCU

/-- Toggle one finite bit exactly when a classical predicate is true. -/
def toggleBit (active : Bool) (bit : Fin 2) : Fin 2 :=
  if active then flipBit bit else bit

@[simp] theorem toggleBit_false (bit : Fin 2) :
    toggleBit false bit = bit := by
  rfl

@[simp] theorem toggleBit_true (bit : Fin 2) :
    toggleBit true bit = flipBit bit := by
  rfl

/-- Toggling by the same Boolean predicate twice is the identity. -/
theorem toggleBit_involutive (active : Bool) :
    Function.Involutive (toggleBit active) := by
  intro bit
  cases active <;> simp [toggleBit]

/-- Fan one pivot bit into an arbitrary finite family of target bits. -/
def fanoutTargets {ι : Type*} (pivot : Fin 2)
    (targets : ι → Fin 2) : ι → Fin 2 :=
  fun index => if pivot = 1 then flipBit (targets index) else targets index

/-- A fixed-pivot fan-out is self-inverse. -/
theorem fanoutTargets_involutive {ι : Type*} (pivot : Fin 2) :
    Function.Involutive (@fanoutTargets ι pivot) := by
  intro targets
  funext index
  fin_cases pivot <;> simp [fanoutTargets]

/-- Ordinary fan-out: preserve key and pivot, and use the pivot to toggle every
target bit. -/
def pivotFanoutEquiv {κ ι : Type*} :
    Equiv.Perm (κ × Fin 2 × (ι → Fin 2)) where
  toFun state :=
    (state.1, state.2.1, fanoutTargets state.2.1 state.2.2)
  invFun state :=
    (state.1, state.2.1, fanoutTargets state.2.1 state.2.2)
  left_inv state := by
    rcases state with ⟨key, pivot, targets⟩
    simp [fanoutTargets_involutive pivot targets]
  right_inv state := by
    rcases state with ⟨key, pivot, targets⟩
    simp [fanoutTargets_involutive pivot targets]

/-- Abstract multi-controlled X on the pivot.  `control key` represents the
conjunction of the k external control qubits in the source circuit. -/
def predicatePivotEquiv {κ ι : Type*} (control : κ → Bool) :
    Equiv.Perm (κ × Fin 2 × (ι → Fin 2)) where
  toFun state :=
    (state.1, toggleBit (control state.1) state.2.1, state.2.2)
  invFun state :=
    (state.1, toggleBit (control state.1) state.2.1, state.2.2)
  left_inv state := by
    rcases state with ⟨key, pivot, targets⟩
    simp [toggleBit_involutive (control key) pivot]
  right_inv state := by
    rcases state with ⟨key, pivot, targets⟩
    simp [toggleBit_involutive (control key) pivot]

/-- Eq. (37): fan out the old pivot, toggle the pivot by the k-control
predicate, then fan out the new pivot. -/
def controlledFanoutDecompositionEquiv {κ ι : Type*}
    (control : κ → Bool) :
    Equiv.Perm (κ × Fin 2 × (ι → Fin 2)) :=
  (pivotFanoutEquiv (κ := κ) (ι := ι)).trans
    ((predicatePivotEquiv (ι := ι) control).trans
      (pivotFanoutEquiv (κ := κ) (ι := ι)))

/-- Exact pointwise action of Eq. (37): the pivot and every fan-out target are
toggled by the same k-control predicate, with no dependence on the unknown
incoming pivot value. -/
theorem controlledFanoutDecomposition_action
    {κ ι : Type*} (control : κ → Bool)
    (key : κ) (pivot : Fin 2) (targets : ι → Fin 2) :
    controlledFanoutDecompositionEquiv control (key, pivot, targets) =
      (key,
        toggleBit (control key) pivot,
        fun index => toggleBit (control key) (targets index)) := by
  cases condition : control key <;> fin_cases pivot <;>
    simp [controlledFanoutDecompositionEquiv, pivotFanoutEquiv,
      predicatePivotEquiv, fanoutTargets, toggleBit, condition]

/-- The decomposition leaves the external control key unchanged. -/
theorem controlledFanoutDecomposition_preserves_key
    {κ ι : Type*} (control : κ → Bool)
    (key : κ) (pivot : Fin 2) (targets : ι → Fin 2) :
    (controlledFanoutDecompositionEquiv control (key, pivot, targets)).1 = key := by
  rw [controlledFanoutDecomposition_action]

/-- The pivot receives exactly the multi-control predicate. -/
theorem controlledFanoutDecomposition_pivot
    {κ ι : Type*} (control : κ → Bool)
    (key : κ) (pivot : Fin 2) (targets : ι → Fin 2) :
    (controlledFanoutDecompositionEquiv control (key, pivot, targets)).2.1 =
      toggleBit (control key) pivot := by
  rw [controlledFanoutDecomposition_action]

/-- Every target receives exactly the same multi-control predicate. -/
theorem controlledFanoutDecomposition_target
    {κ ι : Type*} (control : κ → Bool)
    (key : κ) (pivot : Fin 2) (targets : ι → Fin 2) (index : ι) :
    (controlledFanoutDecompositionEquiv control (key, pivot, targets)).2.2 index =
      toggleBit (control key) (targets index) := by
  rw [controlledFanoutDecomposition_action]

/-- Matrix-level unitarity follows because Eq. (37) is a basis permutation. -/
theorem controlledFanoutDecomposition_unitary
    {κ ι : Type*} [Fintype κ] [DecidableEq κ]
    [Fintype ι] [DecidableEq ι]
    (control : κ → Bool) :
    equivPermutationMatrix (controlledFanoutDecompositionEquiv
      (ι := ι) control) ∈
      _root_.Matrix.unitaryGroup (κ × Fin 2 × (ι → Fin 2)) ℂ :=
  equivPermutationMatrix_unitary _

/-- Planner-visible semantic cost shape of Eq. (37).  The two fan-out uses are
kept abstract because their source-optimal implementation is Lemma 2, not the
serial baseline used for local semantics. -/
structure ControlledFanoutDecompositionCost where
  ordinaryFanoutUses : Nat
  multiControlledXUses : Nat
  deriving DecidableEq, Repr

/-- Equation (37) uses exactly two ordinary fan-outs and one multi-controlled X. -/
def controlledFanoutDecompositionCost : ControlledFanoutDecompositionCost where
  ordinaryFanoutUses := 2
  multiControlledXUses := 1

@[simp] theorem controlledFanoutDecomposition_cost_exact :
    controlledFanoutDecompositionCost =
      { ordinaryFanoutUses := 2, multiControlledXUses := 1 } := by
  rfl

end ComparatorIncrementerFanoutIdentity
end QuantumBlockEncoding

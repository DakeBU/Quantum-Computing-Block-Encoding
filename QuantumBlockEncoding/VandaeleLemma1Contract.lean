import QuantumBlockEncoding.PrimitiveSemantics
import Mathlib.Tactic

/-!
# Source-facing contract for Vandaele Lemma 1 / Definition 2.1

Definition 2.1 fixes the exact k-controlled X action. Lemma 1 (citing Nie et
al.) supplies an implementation over `{CCX,CX,X}` with Theta(k) gate count,
Theta(log k) depth, and one dirty ancilla.  The source also recalls matching
Omega(k) / Omega(log k) lower bounds for bounded-size gate sets.

ASPBE separates these claims:

* exact C^kX semantics are formalized here;
* a genuine uniform upper-resource target is recorded here;
* the quantitative lower bounds remain external cited-result obligations until
  their assumptions/theorem are imported or re-proved.
-/

namespace QuantumBlockEncoding
namespace VandaeleLemma1Contract

/-- All k computational-basis controls are one. -/
def allControlsOne {k : Nat} (controls : PrimitiveBasis k) : Prop :=
  ∀ wire, controls wire = 1

/-- Exact Definition-2.1 basis action. -/
def multiControlledXAction (k : Nat)
    (state : PrimitiveBasis k × Fin 2) : PrimitiveBasis k × Fin 2 :=
  if allControlsOne state.1 then
    (state.1, flipBit state.2)
  else state

/-- C^kX is involutory. -/
theorem multiControlledXAction_involutive (k : Nat) :
    Function.Involutive (multiControlledXAction k) := by
  intro state
  rcases state with ⟨controls, target⟩
  by_cases active : allControlsOne controls
  · simp [multiControlledXAction, active]
  · simp [multiControlledXAction, active]

/-- Exact C^kX permutation. -/
def multiControlledXEquiv (k : Nat) :
    Equiv.Perm (PrimitiveBasis k × Fin 2) where
  toFun := multiControlledXAction k
  invFun := multiControlledXAction k
  left_inv := multiControlledXAction_involutive k
  right_inv := multiControlledXAction_involutive k

/-- Controls are preserved. -/
theorem multiControlledX_preserves_controls
    (k : Nat) (state : PrimitiveBasis k × Fin 2) :
    (multiControlledXEquiv k state).1 = state.1 := by
  by_cases active : allControlsOne state.1 <;>
    simp [multiControlledXEquiv, multiControlledXAction, active]

/-- Exact target equation. -/
theorem multiControlledX_target
    (k : Nat) (state : PrimitiveBasis k × Fin 2) :
    (multiControlledXEquiv k state).2 =
      if allControlsOne state.1 then flipBit state.2 else state.2 := by
  by_cases active : allControlsOne state.1 <;>
    simp [multiControlledXEquiv, multiControlledXAction, active]

/-- Totalized logarithmic scale used by the source upper bound. -/
def logScale (k : Nat) : Nat := Nat.log2 (k + 1) + 1

/-- Genuine uniform implementation target for Lemma 1.  The constants are
chosen once for every k. `dirtyAncillas <= 1` permits the elementary k<=2 cases
to use fewer ancillas while matching the source worst-case statement. -/
def LemmaOneUniformResourceTarget
    (gateCount depth dirtyAncillas : Nat → Nat) : Prop :=
  ∃ gateConstant depthConstant : Nat,
    ∀ k,
      gateCount k ≤ gateConstant * (k + 1) ∧
      depth k ≤ depthConstant * logScale k ∧
      dirtyAncillas k ≤ 1

/-- Non-vacuous finite-instance view under one pair of constants already fixed
for the whole family. -/
def LemmaOneInstanceResourceBound
    (k gateCount depth dirtyAncillas
      gateConstant depthConstant : Nat) : Prop :=
  gateCount ≤ gateConstant * (k + 1) ∧
  depth ≤ depthConstant * logScale k ∧
  dirtyAncillas ≤ 1

/-- A complete source implementation family must refine the exact C^kX
permutation and satisfy the uniform resource target.  The circuit syntax itself
will live in the future gate-level refinement layer. -/
structure LemmaOneResourceFamily where
  gateCount : Nat → Nat
  depth : Nat → Nat
  dirtyAncillas : Nat → Nat
  resources : LemmaOneUniformResourceTarget gateCount depth dirtyAncillas

/-- External optimality/lower-bound claim is named as a separate interface.
ASPBE does not construct a proof of this proposition in this file. -/
def BoundedGateLowerBoundTarget
    (minimumGateCount minimumDepth : Nat → Nat) : Prop :=
  (∃ constant : Nat, 0 < constant ∧ ∀ k,
    constant * k ≤ minimumGateCount k) ∧
  (∃ constant : Nat, 0 < constant ∧ ∀ k,
    constant * Nat.log2 (k + 1) ≤ minimumDepth k)

end VandaeleLemma1Contract
end QuantumBlockEncoding

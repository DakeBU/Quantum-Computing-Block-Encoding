import QuantumBlockEncoding.PrimitiveSemantics
import Mathlib.Tactic

/-!
# Vandaele Definition 2.3: ladder operators

Definition 2.3 introduces `L_k^(n)`, a ladder of n consecutive `C^k X` gates on
`kn+1` qubits. Equation (5) has an important overlap structure: the target of
one ladder step is one of the controls of the next step.

For positive order `k = localControls + 1`, ASPBE stores the register as one
initial pivot plus n blocks, each containing `k-1` fresh controls and one target.
The previous pivot/target supplies the remaining control.

This file fixes the exact source action and distinguishes explicit finite
resource inequalities from genuine uniform Lemma-3/Lemma-4/Corollary-1 family
targets. Big-O constants are never re-chosen per fixed ladder instance.
-/

namespace QuantumBlockEncoding
namespace VandaeleLadderContract

/-- One positive-order ladder block: `localControls` fresh controls plus one
target. The previous block target supplies the remaining control. -/
abbrev LadderBlock (localControls : Nat) :=
  PrimitiveBasis localControls × Fin 2

/-- Register shape for `L_(localControls+1)^(steps)`. -/
abbrev LadderState (localControls steps : Nat) :=
  Fin 2 × (Fin steps → LadderBlock localControls)

/-- Target/control pivot immediately preceding one block in the source chain. -/
def previousPivot {localControls steps : Nat}
    (state : LadderState localControls steps)
    (index : Fin steps) : Fin 2 :=
  if first : index.val = 0 then state.1
  else state.2 ⟨index.val - 1, by omega⟩ |>.2

/-- All fresh controls in one block are active. -/
def allLocalControlsOne {localControls : Nat}
    (controls : PrimitiveBasis localControls) : Prop :=
  ∀ wire, controls wire = 1

/-- Exact activation condition for one `C^(localControls+1) X` ladder step. -/
def ladderActive {localControls steps : Nat}
    (state : LadderState localControls steps)
    (index : Fin steps) : Prop :=
  previousPivot state index = 1 ∧
    allLocalControlsOne (state.2 index).1

/-- Equation (5) source action. The initial pivot and every fresh local control
are preserved; each block target toggles by the conjunction of the previous
pivot and its local controls. -/
def sourceLadderAction (localControls steps : Nat)
    (state : LadderState localControls steps) :
    LadderState localControls steps :=
  (state.1, fun index =>
    ((state.2 index).1,
      if ladderActive state index then
        flipBit (state.2 index).2
      else (state.2 index).2))

/-- Source-facing correctness proposition for a positive-order ladder
implementation. -/
def LadderSpec (localControls steps : Nat)
    (implementation : Equiv.Perm (LadderState localControls steps)) : Prop :=
  ∀ state, implementation state =
    sourceLadderAction localControls steps state

/-- The source action preserves the initial pivot. -/
theorem sourceLadder_preserves_initialPivot
    (localControls steps : Nat)
    (state : LadderState localControls steps) :
    (sourceLadderAction localControls steps state).1 = state.1 := by
  rfl

/-- The source action preserves every fresh local-control word. -/
theorem sourceLadder_preserves_localControls
    (localControls steps : Nat)
    (state : LadderState localControls steps)
    (index : Fin steps) :
    ((sourceLadderAction localControls steps state).2 index).1 =
      (state.2 index).1 := by
  rfl

/-- Exact target equation from Definition 2.3 / Equation (5). -/
theorem sourceLadder_target
    (localControls steps : Nat)
    (state : LadderState localControls steps)
    (index : Fin steps) :
    ((sourceLadderAction localControls steps state).2 index).2 =
      if ladderActive state index then
        flipBit (state.2 index).2
      else (state.2 index).2 := by
  rfl

/-- At the first ladder step, the initial `x_0` is the overlapping control. -/
theorem previousPivot_first
    (localControls : Nat) (steps : Nat)
    (state : LadderState localControls (steps + 1)) :
    previousPivot state (0 : Fin (steps + 1)) = state.1 := by
  simp [previousPivot]

/-- For a nonfirst step, the preceding block target is exactly the overlapping
source control `x_{k(i-1)}`. -/
theorem previousPivot_nonfirst
    {localControls steps : Nat}
    (state : LadderState localControls steps)
    (index : Fin steps) (nonzero : index.val ≠ 0) :
    previousPivot state index =
      (state.2 ⟨index.val - 1, by omega⟩).2 := by
  simp [previousPivot, nonzero]

/-- Totalized depth scale for Corollary 1. -/
def corollaryOneDepthScale (localControls steps : Nat) : Nat :=
  Nat.log2 ((localControls + 1) * steps + 1) + 1

/-- Explicit finite-instance Corollary-1 inequality. -/
def CorollaryOneInstanceResourceBound
    (localControls steps gateCount depth ancillas
      gateConstant depthConstant : Nat) : Prop :=
  gateCount ≤ gateConstant * ((localControls + 1) * steps + 1) ∧
  depth ≤ depthConstant * corollaryOneDepthScale localControls steps ∧
  ancillas ≤ steps

/-- Genuine uniform Corollary-1 family target. -/
def CorollaryOneUniformResourceTarget
    (gateCount depth ancillas : Nat → Nat → Nat) : Prop :=
  ∃ gateConstant depthConstant : Nat,
    ∀ localControls steps,
      gateCount localControls steps ≤
          gateConstant * ((localControls + 1) * steps + 1) ∧
      depth localControls steps ≤
          depthConstant * corollaryOneDepthScale localControls steps ∧
      ancillas localControls steps ≤ steps

/-- Uniform Lemma-3 target for `L_1^(n)`. -/
def LemmaThreeUniformResourceTarget
    (cxCount depth : Nat → Nat) : Prop :=
  ∃ gateConstant depthConstant : Nat,
    ∀ steps,
      cxCount steps ≤ gateConstant * (steps + 1) ∧
      depth steps ≤ depthConstant * (Nat.log2 (steps + 1) + 1)

/-- Uniform Lemma-4 target for `L_2^(n)`. -/
def LemmaFourUniformResourceTarget
    (ccxCount depth ancillas : Nat → Nat) : Prop :=
  ∃ gateConstant depthConstant : Nat,
    ∀ steps,
      ccxCount steps ≤ gateConstant * (steps + 1) ∧
      depth steps ≤ depthConstant * (Nat.log2 (steps + 1) + 1) ∧
      ancillas steps ≤ steps

/-- Completion record for one concrete positive-order ladder implementation.
It stores explicit constants but does not alone establish Corollary 1 uniformly. -/
structure LadderInstanceCertificate (localControls steps : Nat) where
  implementation : Equiv.Perm (LadderState localControls steps)
  gateCount : Nat
  depth : Nat
  ancillas : Nat
  gateConstant : Nat
  depthConstant : Nat
  correctness : LadderSpec localControls steps implementation
  resources :
    CorollaryOneInstanceResourceBound
      localControls steps gateCount depth ancillas
      gateConstant depthConstant

end VandaeleLadderContract
end QuantumBlockEncoding

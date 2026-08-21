import QuantumBlockEncoding.PrimitiveSemantics
import Mathlib.Tactic

/-!
# Vandaele Definition 2.3: ladder operators

Definition 2.3 introduces `L_k^(n)`, a ladder of n consecutive `C^k X` gates on
`kn+1` qubits. Equation (5) has an essential overlap structure: the target of
one ladder step is one of the controls of the next step.

For positive order `k = localControls + 1`, ASPBE stores the register as one
initial pivot plus n blocks, each containing `k-1` fresh controls and one target.
The previous pivot/target supplies the remaining control.

Crucially, the source ladder is **sequential**.  Step `i+1` reads the target
produced by step `i`; it is not a pointwise simultaneous update of all targets.
The implementation below therefore runs the block indices in chronological order
and reads every activation predicate from the current state.

The resource interfaces remain separated from this semantic contract. Big-O
constants are never re-chosen per fixed ladder instance.
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
  else (state.2 ⟨index.val - 1, by omega⟩).2

/-- All fresh controls in one block are active. -/
def allLocalControlsOne {localControls : Nat}
    (controls : PrimitiveBasis localControls) : Prop :=
  ∀ wire, controls wire = 1

/-- Exact activation condition for one `C^(localControls+1) X` ladder step,
read from the current state. -/
def ladderActive {localControls steps : Nat}
    (state : LadderState localControls steps)
    (index : Fin steps) : Prop :=
  previousPivot state index = 1 ∧
    allLocalControlsOne (state.2 index).1

/-- Execute one chronological ladder gate.  Only the current block target is
modified; the pivot and all fresh controls are preserved. -/
def sourceLadderStep (localControls steps : Nat)
    (index : Fin steps)
    (state : LadderState localControls steps) :
    LadderState localControls steps :=
  if active : ladderActive state index then
    (state.1,
      Function.update state.2 index
        ((state.2 index).1, flipBit (state.2 index).2))
  else state

/-- Run a supplied chronological list of ladder indices. -/
def runLadderSteps {localControls steps : Nat}
    (indices : List (Fin steps))
    (state : LadderState localControls steps) :
    LadderState localControls steps :=
  match indices with
  | [] => state
  | index :: rest =>
      runLadderSteps rest
        (sourceLadderStep localControls steps index state)

/-- Equation (5) source action: execute steps `0,1,...,steps-1` in order. -/
def sourceLadderAction (localControls steps : Nat)
    (state : LadderState localControls steps) :
    LadderState localControls steps :=
  runLadderSteps (List.finRange steps) state

/-- Source-facing correctness proposition for a positive-order ladder
implementation. -/
def LadderSpec (localControls steps : Nat)
    (implementation : Equiv.Perm (LadderState localControls steps)) : Prop :=
  ∀ state, implementation state =
    sourceLadderAction localControls steps state

/-- One source step preserves the initial pivot. -/
theorem sourceLadderStep_preserves_initialPivot
    (localControls steps : Nat) (index : Fin steps)
    (state : LadderState localControls steps) :
    (sourceLadderStep localControls steps index state).1 = state.1 := by
  by_cases active : ladderActive state index <;>
    simp [sourceLadderStep, active]

/-- One source step preserves every fresh local-control word, including the
controls inside the updated block. -/
theorem sourceLadderStep_preserves_localControls
    (localControls steps : Nat) (index query : Fin steps)
    (state : LadderState localControls steps) :
    ((sourceLadderStep localControls steps index state).2 query).1 =
      (state.2 query).1 := by
  by_cases active : ladderActive state index
  · by_cases same : query = index
    · subst query
      simp [sourceLadderStep, active]
    · simp [sourceLadderStep, active, Function.update_noteq same]
  · simp [sourceLadderStep, active]

/-- Exact target action of one chronological source step. -/
theorem sourceLadderStep_target
    (localControls steps : Nat) (index : Fin steps)
    (state : LadderState localControls steps) :
    ((sourceLadderStep localControls steps index state).2 index).2 =
      (if ladderActive state index then
        flipBit (state.2 index).2
      else (state.2 index).2) := by
  by_cases active : ladderActive state index <;>
    simp [sourceLadderStep, active]

/-- An arbitrary chronological sub-run preserves the initial pivot. -/
theorem runLadderSteps_preserves_initialPivot
    {localControls steps : Nat}
    (indices : List (Fin steps))
    (state : LadderState localControls steps) :
    (runLadderSteps indices state).1 = state.1 := by
  induction indices generalizing state with
  | nil => rfl
  | cons index rest induction =>
      calc
        (runLadderSteps (index :: rest) state).1 =
            (runLadderSteps rest
              (sourceLadderStep localControls steps index state)).1 := rfl
        _ = (sourceLadderStep localControls steps index state).1 :=
          induction (sourceLadderStep localControls steps index state)
        _ = state.1 :=
          sourceLadderStep_preserves_initialPivot
            localControls steps index state

/-- An arbitrary chronological sub-run preserves every fresh local control. -/
theorem runLadderSteps_preserves_localControls
    {localControls steps : Nat}
    (indices : List (Fin steps))
    (state : LadderState localControls steps)
    (query : Fin steps) :
    ((runLadderSteps indices state).2 query).1 =
      (state.2 query).1 := by
  induction indices generalizing state with
  | nil => rfl
  | cons index rest induction =>
      calc
        ((runLadderSteps (index :: rest) state).2 query).1 =
            ((runLadderSteps rest
              (sourceLadderStep localControls steps index state)).2 query).1 := rfl
        _ = ((sourceLadderStep localControls steps index state).2 query).1 :=
          induction (sourceLadderStep localControls steps index state)
        _ = (state.2 query).1 :=
          sourceLadderStep_preserves_localControls
            localControls steps index query state

/-- The complete source ladder preserves the initial pivot. -/
theorem sourceLadder_preserves_initialPivot
    (localControls steps : Nat)
    (state : LadderState localControls steps) :
    (sourceLadderAction localControls steps state).1 = state.1 := by
  exact runLadderSteps_preserves_initialPivot
    (List.finRange steps) state

/-- The complete source ladder preserves every fresh local-control word. -/
theorem sourceLadder_preserves_localControls
    (localControls steps : Nat)
    (state : LadderState localControls steps)
    (index : Fin steps) :
    ((sourceLadderAction localControls steps state).2 index).1 =
      (state.2 index).1 := by
  exact runLadderSteps_preserves_localControls
    (List.finRange steps) state index

/-- At the first ladder step, the initial `x_0` is the overlapping control. -/
theorem previousPivot_first
    (localControls : Nat) (steps : Nat)
    (state : LadderState localControls (steps + 1)) :
    previousPivot state (0 : Fin (steps + 1)) = state.1 := by
  simp [previousPivot]

/-- For a nonfirst step, the preceding block target is exactly the overlapping
source control `x_{k(i-1)}` in the **current** state. -/
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

import QuantumBlockEncoding.PrimitiveSemantics
import Mathlib.Tactic

/-!
# Vandaele Definition 2.3: ladder operators

Definition 2.3 introduces `L_k^(n)`, a ladder of n consecutive `C^k X` gates on
`kn+1` qubits.  Equation (5) has an important overlap structure: the target of
one ladder step is one of the controls of the next step.

For positive order `k = localControls + 1`, ASPBE therefore stores the register
as

* one initial pivot `x_0`;
* n blocks, each containing `k-1 = localControls` fresh control bits and one
  target bit.

The controls for a block are the previous pivot/target together with its fresh
local controls.  This representation is definitionally equivalent to the
source ordering `x_0,...,x_{kn}` but makes the overlap visible to later proofs.

This file fixes the exact source action and resource/certificate interfaces.
The low-depth Lemmas 3/4 and Corollary 1 remain concrete circuit obligations;
no asymptotic implementation is assumed merely from this semantic contract.
-/

namespace QuantumBlockEncoding
namespace VandaeleLadderContract

/-- One positive-order ladder block: `localControls` fresh controls plus one
target.  The previous block target supplies the remaining control. -/
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

/-- Equation (5) source action.  The initial pivot and every fresh local control
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

/-- Totalized resource target corresponding to Corollary 1 for positive order
`k=localControls+1`: O(k*n) gates, O(log(k*n)) depth, and n ancilla qubits. -/
def CorollaryOneResourceTarget
    (localControls steps gateCount depth ancillas : Nat) : Prop :=
  (∃ constant : Nat,
    gateCount ≤ constant * ((localControls + 1) * steps + 1)) ∧
  (∃ constant : Nat,
    depth ≤ constant *
      (Nat.log2 ((localControls + 1) * steps + 1) + 1)) ∧
  ancillas ≤ steps

/-- More specific Lemma 3 target for `L_1^(n)`: linear CX count and logarithmic
depth without an ancilla requirement. -/
def LemmaThreeResourceTarget
    (steps cxCount depth : Nat) : Prop :=
  (∃ constant : Nat, cxCount ≤ constant * (steps + 1)) ∧
  (∃ constant : Nat,
    depth ≤ constant * (Nat.log2 (steps + 1) + 1))

/-- Lemma 4 target for `L_2^(n)`: linear CCX count, logarithmic depth, and n
ancilla qubits. -/
def LemmaFourResourceTarget
    (steps ccxCount depth ancillas : Nat) : Prop :=
  (∃ constant : Nat, ccxCount ≤ constant * (steps + 1)) ∧
  (∃ constant : Nat,
    depth ≤ constant * (Nat.log2 (steps + 1) + 1)) ∧
  ancillas ≤ steps

/-- Completion record for a concrete positive-order ladder implementation. -/
structure LadderCertificate (localControls steps : Nat) where
  implementation : Equiv.Perm (LadderState localControls steps)
  gateCount : Nat
  depth : Nat
  ancillas : Nat
  correctness : LadderSpec localControls steps implementation
  resources :
    CorollaryOneResourceTarget
      localControls steps gateCount depth ancillas

end VandaeleLadderContract
end QuantumBlockEncoding

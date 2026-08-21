import QuantumBlockEncoding.PrimitiveBasisRemoveWire
import QuantumBlockEncoding.ReversibleProgramInverse
import QuantumBlockEncoding.ReversibleProgramSupport
import QuantumBlockEncoding.VandaeleParityCore
import Mathlib.Tactic

/-!
# Reversible gates factor across an unused spectator wire

If one physical qubit is untouched by an X/CX/CCX gate, the gate acts
identically on the two fibres of that spectator bit.  After splitting the
spectator from the flat basis, the global permutation is therefore

`id_(Fin 2) × localPermutation`.

`VandaeleParityCore` then implies that the global sign is the square of the
local sign and hence +1.  This file proves the semantic factorization for an
arbitrary reversible gate and a supplied unused wire; existence of such a wire
for q>=4 is handled separately.
-/

namespace QuantumBlockEncoding
namespace ReversibleGateUnusedWireParity

open PrimitiveBasisRemoveWire
open ReversibleProgramInverse
open ReversibleProgramSupport
open VandaeleParityCore

/-- A targeted wire is always touched. -/
theorem touches_of_targetsWire
    {q : Nat} (gate : ReversibleGate q) (wire : Fin q)
    (targeted : targetsWire gate wire) : gate.touches wire := by
  cases gate with
  | x target =>
      simpa [targetsWire, ReversibleGate.touches] using targeted.symm
  | cx control target distinct =>
      exact Or.inr (by simpa [targetsWire] using targeted.symm)
  | ccx control0 control1 target c01 c0t c1t =>
      exact Or.inr (Or.inr (by simpa [targetsWire] using targeted.symm))

/-- If a wire is not touched, it is certainly not targeted. -/
theorem notTargets_of_notTouches
    {q : Nat} (gate : ReversibleGate q) (wire : Fin q)
    (unused : ¬ gate.touches wire) : ¬ targetsWire gate wire := by
  intro targeted
  exact unused (touches_of_targetsWire gate wire targeted)

/-- Flat state with a chosen spectator bit and supplied other-wire values. -/
def assemble
    {q : Nat} (spectator : Fin q)
    (bit : Fin 2) (other : OtherBasis q spectator) : PrimitiveBasis q :=
  (splitWire spectator).symm (bit, other)

@[simp] theorem assemble_spectator
    {q : Nat} (spectator : Fin q)
    (bit : Fin 2) (other : OtherBasis q spectator) :
    assemble spectator bit other spectator = bit := by
  simp [assemble]

@[simp] theorem assemble_other
    {q : Nat} (spectator : Fin q)
    (bit : Fin 2) (other : OtherBasis q spectator)
    (wire : OtherWire q spectator) :
    assemble spectator bit other wire.1 = other wire := by
  simp [assemble]

/-- Two states that differ only on an unused spectator agree on every wire
actually touched by the gate. -/
theorem assemble_agree_on_touches
    {q : Nat} (gate : ReversibleGate q)
    (spectator : Fin q) (unused : ¬ gate.touches spectator)
    (leftBit rightBit : Fin 2)
    (other : OtherBasis q spectator) :
    ∀ wire, gate.touches wire →
      assemble spectator leftBit other wire =
        assemble spectator rightBit other wire := by
  intro wire touched
  have different : wire ≠ spectator := by
    intro equal
    subst wire
    exact unused touched
  let otherWire : OtherWire q spectator := ⟨wire, different⟩
  simpa [assemble, otherWire] using
    (show
      assemble spectator leftBit other otherWire.1 =
        assemble spectator rightBit other otherWire.1 by
      simp [assemble, otherWire])

/-- The output on every non-spectator wire is independent of the incoming
spectator bit. -/
theorem other_output_independent
    {q : Nat} (gate : ReversibleGate q)
    (spectator : Fin q) (unused : ¬ gate.touches spectator)
    (leftBit rightBit : Fin 2)
    (other : OtherBasis q spectator)
    (wire : OtherWire q spectator) :
    evalReversibleGate gate (assemble spectator leftBit other) wire.1 =
      evalReversibleGate gate (assemble spectator rightBit other) wire.1 := by
  by_cases touched : gate.touches wire.1
  · exact evalReversibleGate_congr_on_touches gate
      (assemble spectator leftBit other)
      (assemble spectator rightBit other)
      (assemble_agree_on_touches gate spectator unused leftBit rightBit other)
      wire.1 touched
  · have notTarget := notTargets_of_notTouches gate wire.1 touched
    rw [evalReversibleGate_apply_of_not_targets gate wire.1
      (assemble spectator leftBit other) notTarget]
    rw [evalReversibleGate_apply_of_not_targets gate wire.1
      (assemble spectator rightBit other) notTarget]
    simp [assemble]

/-- The spectator itself is preserved because it is not targeted. -/
theorem spectator_preserved
    {q : Nat} (gate : ReversibleGate q)
    (spectator : Fin q) (unused : ¬ gate.touches spectator)
    (state : PrimitiveBasis q) :
    evalReversibleGate gate state spectator = state spectator := by
  exact evalReversibleGate_apply_of_not_targets gate spectator state
    (notTargets_of_notTouches gate spectator unused)

/-- Local action induced on the spectator-zero fibre. -/
def localAction
    {q : Nat} (gate : ReversibleGate q)
    (spectator : Fin q)
    (other : OtherBasis q spectator) : OtherBasis q spectator :=
  (splitWire spectator
    (evalReversibleGate gate (assemble spectator 0 other))).2

/-- The induced local action is involutory, because the global gate is
involutory and preserves the spectator fibre. -/
theorem localAction_involutive
    {q : Nat} (gate : ReversibleGate q)
    (spectator : Fin q) (unused : ¬ gate.touches spectator) :
    Function.Involutive (localAction gate spectator) := by
  intro other
  let input := assemble spectator 0 other
  let after := evalReversibleGate gate input
  have spectatorAfter : after spectator = 0 := by
    calc
      after spectator = input spectator := spectator_preserved gate spectator unused input
      _ = 0 := by simp [input, assemble]
  have afterCoordinates :
      splitWire spectator after = (0, localAction gate spectator other) := by
    apply Prod.ext
    · exact spectatorAfter
    · rfl
  have reassembleAfter :
      assemble spectator 0 (localAction gate spectator other) = after := by
    unfold assemble
    rw [← afterCoordinates]
    exact (splitWire spectator).symm_apply_apply after
  unfold localAction
  change
    (splitWire spectator
      (evalReversibleGate gate
        (assemble spectator 0 (localAction gate spectator other)))).2 = other
  rw [reassembleAfter]
  have double := evalReversibleGate_involutive gate input
  rw [double]
  rfl

/-- Local permutation on all non-spectator wires. -/
def localEquiv
    {q : Nat} (gate : ReversibleGate q)
    (spectator : Fin q) (unused : ¬ gate.touches spectator) :
    Equiv.Perm (OtherBasis q spectator) where
  toFun := localAction gate spectator
  invFun := localAction gate spectator
  left_inv := localAction_involutive gate spectator unused
  right_inv := localAction_involutive gate spectator unused

/-- Under spectator/other coordinates, the global gate is exactly two copies of
the same local permutation. -/
theorem permutationView_eq_duplicate
    {q : Nat} (gate : ReversibleGate q)
    (spectator : Fin q) (unused : ¬ gate.touches spectator) :
    permutationView spectator (evalReversibleGate gate) =
      duplicateOverBit (localEquiv gate spectator unused) := by
  apply Equiv.ext
  intro state
  rcases state with ⟨bit,other⟩
  apply Prod.ext
  · change
      (splitWire spectator
        (evalReversibleGate gate (assemble spectator bit other))).1 = bit
    rw [splitWire_fst]
    rw [spectator_preserved gate spectator unused]
    simp [assemble]
  · funext wire
    change
      evalReversibleGate gate (assemble spectator bit other) wire.1 =
        localAction gate spectator other wire
    unfold localAction
    change
      evalReversibleGate gate (assemble spectator bit other) wire.1 =
        evalReversibleGate gate (assemble spectator 0 other) wire.1
    exact other_output_independent gate spectator unused bit 0 other wire

/-- Any reversible gate with one unused physical qubit is even as a permutation
of the complete basis. -/
theorem sign_eq_one_of_unused
    {q : Nat} [Fintype (PrimitiveBasis q)] [DecidableEq (PrimitiveBasis q)]
    (gate : ReversibleGate q)
    (spectator : Fin q) (unused : ¬ gate.touches spectator) :
    Equiv.Perm.sign (evalReversibleGate gate) = 1 := by
  apply even_of_conjugate_duplicate
    (evalReversibleGate gate)
    (localEquiv gate spectator unused)
    (splitWire spectator)
  change
    ((splitWire spectator).symm.trans (evalReversibleGate gate)).trans
        (splitWire spectator) =
      duplicateOverBit (localEquiv gate spectator unused)
  exact permutationView_eq_duplicate gate spectator unused

end ReversibleGateUnusedWireParity
end QuantumBlockEncoding

import QuantumBlockEncoding.ReversibleGateParityLowerBound
import QuantumBlockEncoding.ReversibleProgramSupport
import Mathlib.Tactic

/-!
# Linear gate lower bound for C^k X in the reversible ASPBE gate model

This module proves the gate-count half of the standard multi-controlled-X lower
bound directly for ASPBE's `{X,CX,CCX}` reversible IR.

The proof is support-theoretic:

* one logical gate touches at most three physical wires;
* if a physical wire is untouched by the entire program, the program commutes
  with X on that wire;
* C^k X does not commute with X on any of its k control wires;
* therefore all k control wires belong to the program support;
* hence `k <= 3 * program.length`.

The source paper cites a more general bounded-gate-set lower bound.  The theorem
here internalizes the linear lower bound in the concrete gate model used by the
rest of ASPBE.
-/

namespace QuantumBlockEncoding
namespace ReversibleProgramGateLowerBound

open PrimitiveBasisRegisterSplit
open ReversibleGateParityLowerBound
open ReversibleProgramSupport
open VandaeleParityCore

/-- Union of all wires touched by a reversible program. -/
def touchedFinsetProgram {q : Nat} :
    ReversibleProgram q -> Finset (Fin q)
  | [] => ∅
  | gate :: rest => touchedFinset gate ∪ touchedFinsetProgram rest

@[simp] theorem mem_touchedFinsetProgram
    {q : Nat} (wire : Fin q) : ∀ program : ReversibleProgram q,
    wire ∈ touchedFinsetProgram program ↔
      ∃ gate, gate ∈ program ∧ gate.touches wire := by
  intro program
  induction program with
  | nil => simp [touchedFinsetProgram]
  | cons gate rest induction =>
      simp [touchedFinsetProgram, mem_touchedFinset_iff, induction,
        or_left_comm, or_assoc]

/-- Program support grows by at most three wires per logical gate. -/
theorem touchedFinsetProgram_card_le
    {q : Nat} (program : ReversibleProgram q) :
    (touchedFinsetProgram program).card <= 3 * program.length := by
  induction program with
  | nil => simp [touchedFinsetProgram]
  | cons gate rest induction =>
      have unionBound := Finset.card_union_le (touchedFinset gate)
        (touchedFinsetProgram rest)
      have gateBound := touchedFinset_card_le_three gate
      simp only [touchedFinsetProgram, List.length_cons]
      omega

/-- If a gate does not touch wire u, it commutes with X on u. -/
theorem gate_commutes_with_unused_x
    {q : Nat} (gate : ReversibleGate q)
    (wire : Fin q) (unused : ¬ gate.touches wire)
    (state : PrimitiveBasis q) :
    evalReversibleGate gate (xBasisAction wire state) =
      xBasisAction wire (evalReversibleGate gate state) := by
  apply funext
  intro query
  by_cases same : query = wire
  · subst query
    have notTarget :=
      ReversibleGateUnusedWireParity.notTargets_of_notTouches gate wire unused
    rw [evalReversibleGate_apply_of_not_targets gate wire
      (xBasisAction wire state) notTarget]
    rw [evalReversibleGate_apply_of_not_targets gate wire state notTarget]
    simp [xBasisAction]
  · have inputAgreement : ∀ touchedWire, gate.touches touchedWire ->
        xBasisAction wire state touchedWire = state touchedWire := by
      intro touchedWire touched
      have different : touchedWire ≠ wire := by
        intro equal
        subst touchedWire
        exact unused touched
      simp [xBasisAction, different]
    by_cases touched : gate.touches query
    · have congruent := evalReversibleGate_congr_on_touches
        gate (xBasisAction wire state) state inputAgreement query touched
      simpa [xBasisAction, same] using congruent
    · have notTarget :=
        ReversibleGateUnusedWireParity.notTargets_of_notTouches gate query touched
      rw [evalReversibleGate_apply_of_not_targets gate query
        (xBasisAction wire state) notTarget]
      rw [evalReversibleGate_apply_of_not_targets gate query state notTarget]
      simp [xBasisAction, same]

/-- If the whole program never touches u, the complete program commutes with X
on u. -/
theorem program_commutes_with_unused_x
    {q : Nat} (program : ReversibleProgram q)
    (wire : Fin q)
    (unused : wire ∉ touchedFinsetProgram program)
    (state : PrimitiveBasis q) :
    evalReversibleProgram program (xBasisAction wire state) =
      xBasisAction wire (evalReversibleProgram program state) := by
  induction program generalizing state with
  | nil => rfl
  | cons gate rest induction =>
      have headUnused : ¬ gate.touches wire := by
        intro touched
        apply unused
        simp [touchedFinsetProgram, mem_touchedFinset_iff, touched]
      have tailUnused : wire ∉ touchedFinsetProgram rest := by
        intro member
        apply unused
        simp [touchedFinsetProgram, member]
      change
        evalReversibleProgram rest
            (evalReversibleGate gate (xBasisAction wire state)) =
          xBasisAction wire
            (evalReversibleProgram rest (evalReversibleGate gate state))
      rw [gate_commutes_with_unused_x gate wire headUnused state]
      exact induction tailUnused (evalReversibleGate gate state)

/-- Flat control wire i in the canonical `(k controls, one target)` layout. -/
def controlWire (k : Nat) (index : Fin k) : Fin (k + 1) :=
  lowWire k 1 index

/-- Flat target wire. -/
def targetWire (k : Nat) : Fin (k + 1) :=
  highWire k 1 ⟨0, by decide⟩

/-- Flat all-ones-controls / zero-target test state. -/
def activeZeroState (k : Nat) : PrimitiveBasis (k + 1) :=
  combineBasis k 1
    (allOnesControls k, fun _ => 0)

/-- Turning any one control off disables C^k X on the test state. -/
def disableControlState (k : Nat) (index : Fin k) : PrimitiveBasis (k + 1) :=
  xBasisAction (controlWire k index) (activeZeroState k)

@[simp] theorem activeZero_control
    (k : Nat) (index : Fin k) :
    activeZeroState k (controlWire k index) = 1 := by
  simp [activeZeroState, controlWire, allOnesControls]

@[simp] theorem activeZero_target (k : Nat) :
    activeZeroState k (targetWire k) = 0 := by
  simp [activeZeroState, targetWire]

/-- The flat target acts as C^k X on the active test state. -/
theorem flatTarget_active_target_one (k : Nat) :
    flatMultiControlledXEquiv k (activeZeroState k) (targetWire k) = 1 := by
  simp [flatMultiControlledXEquiv, flatControlTargetEquiv,
    activeZeroState, targetWire, oneBitEquiv,
    multiControlledXEquiv, multiControlledXAction,
    allControlsOne, allOnesControls, flipBit]

/-- Disabling one control makes the target output remain zero. -/
theorem flatTarget_disabled_target_zero
    (k : Nat) (index : Fin k) :
    flatMultiControlledXEquiv k (disableControlState k index) (targetWire k) = 0 := by
  have disabled :
      disableControlState k index (controlWire k index) = 0 := by
    simp [disableControlState, controlWire, activeZeroState,
      allOnesControls, xBasisAction, flipBit]
  have notAll :
      ¬ allControlsOne
        ((flatControlTargetEquiv k (disableControlState k index)).1) := by
    intro all
    have one := all index
    have controlCoordinate :
        (flatControlTargetEquiv k (disableControlState k index)).1 index = 0 := by
      simpa [flatControlTargetEquiv, controlWire] using disabled
    rw [controlCoordinate] at one
    decide at one
  simp [flatMultiControlledXEquiv, flatControlTargetEquiv,
    disableControlState, targetWire, oneBitEquiv,
    multiControlledXEquiv, multiControlledXAction, notAll]

/-- C^k X does not commute with X on any control wire. -/
theorem flatTarget_not_commute_controlX
    (k : Nat) (index : Fin k) :
    flatMultiControlledXEquiv k
        (xBasisAction (controlWire k index) (activeZeroState k)) ≠
      xBasisAction (controlWire k index)
        (flatMultiControlledXEquiv k (activeZeroState k)) := by
  intro equal
  have targetEq := congrFun equal (targetWire k)
  have leftZero := flatTarget_disabled_target_zero k index
  have rightOne :
      xBasisAction (controlWire k index)
          (flatMultiControlledXEquiv k (activeZeroState k))
          (targetWire k) = 1 := by
    have distinct : controlWire k index ≠ targetWire k := by
      intro wireEq
      have values := congrArg Fin.val wireEq
      simp [controlWire, targetWire, lowWire, highWire] at values
      omega
    simp [xBasisAction, distinct, flatTarget_active_target_one]
  rw [leftZero, rightOne] at targetEq
  decide at targetEq

/-- Every control wire must belong to the support of any correct C^kX program. -/
theorem every_control_touched
    (k : Nat) (program : ReversibleProgram (k + 1))
    (correct : evalReversibleProgram program = flatMultiControlledXEquiv k)
    (index : Fin k) :
    controlWire k index ∈ touchedFinsetProgram program := by
  by_contra untouched
  have commute := program_commutes_with_unused_x
    program (controlWire k index) untouched (activeZeroState k)
  rw [correct] at commute
  exact flatTarget_not_commute_controlX k index commute

/-- Finite set of all flat control wires. -/
def controlFinset (k : Nat) : Finset (Fin (k + 1)) :=
  Finset.univ.map
    ⟨controlWire k, by
      intro left right equal
      apply Fin.ext
      have values := congrArg Fin.val equal
      simp [controlWire, lowWire] at values
      exact values⟩

@[simp] theorem controlFinset_card (k : Nat) :
    (controlFinset k).card = k := by
  simp [controlFinset]

/-- A correct program's support contains every control wire. -/
theorem controlFinset_subset_support
    (k : Nat) (program : ReversibleProgram (k + 1))
    (correct : evalReversibleProgram program = flatMultiControlledXEquiv k) :
    controlFinset k ⊆ touchedFinsetProgram program := by
  intro wire member
  rcases Finset.mem_map.mp member with ⟨index, _, rfl⟩
  exact every_control_touched k program correct index

/-- Internal linear gate lower bound in the concrete reversible model. -/
theorem multiControlledX_gate_lower_bound
    (k : Nat) (program : ReversibleProgram (k + 1))
    (correct : evalReversibleProgram program = flatMultiControlledXEquiv k) :
    k <= 3 * program.length := by
  have subset := controlFinset_subset_support k program correct
  have controlCard := Finset.card_le_card subset
  rw [controlFinset_card] at controlCard
  exact controlCard.trans (touchedFinsetProgram_card_le program)

end ReversibleProgramGateLowerBound
end QuantumBlockEncoding

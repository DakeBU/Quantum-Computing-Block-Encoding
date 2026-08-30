import QuantumBlockEncoding.VandaeleLemma1ProgramFamily
import Mathlib.Tactic

/-!
# Primitive base cases and semantic refinement for Vandaele Lemma 1

This module is the first executable refinement of the source-facing `C^k X`
contract.  It does two jobs that should remain reusable when the generic
Nie/Vandaele construction is formalized later:

* prove that the flat `[controls | target | dirty]` contract really refines
  Definition 2.1 on the external controls/target subsystem while restoring the
  dirty workspace; and
* inhabit that contract for `k = 0, 1, 2` by the native reversible gates
  `X`, `CX`, and `CCX`.

The elementary cases deliberately use the final flat layout including the dirty
wire even though they do not need workspace.  Consequently their correctness,
wire-layout convention, and resource evidence already live in the same API as
the future uniform family.
-/

namespace QuantumBlockEncoding
namespace VandaeleLemma1PrimitiveBaseCases

open VandaeleLemma1Contract
open VandaeleLemma1ProgramFamily

/-- Forget the dirty workspace and expose exactly the source Definition-2.1
controls/target state. -/
def externalView (k : Nat)
    (state : PrimitiveBasis (lemmaOneFlatWidth k)) :
    PrimitiveBasis k × Fin 2 :=
  (fun wire => state (controlWire k wire), state (targetWire k))

/-- The flat-layout control predicate is exactly the source control predicate
on the external view. -/
theorem allFlatControlsOne_iff_external
    (k : Nat) (state : PrimitiveBasis (lemmaOneFlatWidth k)) :
    allFlatControlsOne k state ↔ allControlsOne (externalView k state).1 := by
  rfl

/-- Generic semantic bridge: every implementation satisfying the proof-bearing
flat contract refines Definition 2.1 on the external subsystem and restores the
unknown dirty bit.  This theorem is independent of the eventual gate synthesis
algorithm. -/
theorem flatSpec_refines_source
    (k : Nat)
    (implementation : Equiv.Perm (PrimitiveBasis (lemmaOneFlatWidth k)))
    (spec : LemmaOneFlatSpec k implementation)
    (state : PrimitiveBasis (lemmaOneFlatWidth k)) :
    externalView k (implementation state) =
        multiControlledXEquiv k (externalView k state) ∧
      implementation state (dirtyWire k) = state (dirtyWire k) := by
  rcases spec state with ⟨controls, target, dirty⟩
  constructor
  · apply Prod.ext
    · funext wire
      change
        implementation state (controlWire k wire) =
          (multiControlledXEquiv k (externalView k state)).1 wire
      calc
        implementation state (controlWire k wire) =
            state (controlWire k wire) := controls wire
        _ = (externalView k state).1 wire := rfl
        _ = (multiControlledXEquiv k (externalView k state)).1 wire := by
          symm
          exact congrFun
            (multiControlledX_preserves_controls k (externalView k state)) wire
    · rw [multiControlledX_target]
      simpa [externalView, allFlatControlsOne_iff_external] using target
  · exact dirty

/-- A control wire is never the target. -/
theorem controlWire_ne_target
    (k : Nat) (wire : Fin k) :
    controlWire k wire ≠ targetWire k := by
  intro equal
  have values := congrArg Fin.val equal
  simp [controlWire, targetWire] at values
  omega

/-- A control wire is never the dirty workspace. -/
theorem controlWire_ne_dirty
    (k : Nat) (wire : Fin k) :
    controlWire k wire ≠ dirtyWire k := by
  intro equal
  have values := congrArg Fin.val equal
  simp [controlWire, dirtyWire] at values
  omega

/-- Target and dirty-workspace wires are distinct. -/
theorem targetWire_ne_dirty (k : Nat) :
    targetWire k ≠ dirtyWire k := by
  intro equal
  have values := congrArg Fin.val equal
  simp [targetWire, dirtyWire] at values

/-- The orientation needed by `Function.update` simplification. -/
theorem dirtyWire_ne_target (k : Nat) :
    dirtyWire k ≠ targetWire k :=
  (targetWire_ne_dirty k).symm

/-- A computational-basis bit different from zero is one. -/
private theorem finTwo_eq_one_of_ne_zero
    (bit : Fin 2) (nonzero : bit ≠ 0) : bit = 1 := by
  fin_cases bit <;> simp_all

/-! ## k = 0: X -/

/-- `C^0 X` is a single `X` on the target wire. -/
def k0Program : ReversibleProgram (lemmaOneFlatWidth 0) :=
  [.x (targetWire 0)]

/-- Proof-bearing singleton schedule for `C^0 X`. -/
def k0Scheduled : ScheduledReversibleProgram (lemmaOneFlatWidth 0) :=
  ScheduledReversibleProgram.sequential k0Program

private theorem allFlatControlsOne_zero
    (state : PrimitiveBasis (lemmaOneFlatWidth 0)) :
    allFlatControlsOne 0 state := by
  intro wire
  exact Fin.elim0 wire

/-- The native `X` gate inhabits the exact flat `C^0 X` contract. -/
theorem k0_correct :
    LemmaOneFlatSpec 0 (evalReversibleProgram k0Scheduled.program) := by
  intro state
  constructor
  · intro wire
    exact Fin.elim0 wire
  · constructor
    · have active := allFlatControlsOne_zero state
      simp [k0Scheduled, k0Program, evalReversibleProgram,
        evalReversibleGate, xBasisEquiv, xBasisAction, active]
    · have distinct : dirtyWire 0 ≠ targetWire 0 := dirtyWire_ne_target 0
      simp [k0Scheduled, k0Program, evalReversibleProgram,
        evalReversibleGate, xBasisEquiv, xBasisAction, distinct]

/-- The `k=0` circuit therefore refines Definition 2.1 and restores workspace. -/
theorem k0_refines_source
    (state : PrimitiveBasis (lemmaOneFlatWidth 0)) :
    externalView 0 (evalReversibleProgram k0Scheduled.program state) =
        multiControlledXEquiv 0 (externalView 0 state) ∧
      evalReversibleProgram k0Scheduled.program state (dirtyWire 0) =
        state (dirtyWire 0) :=
  flatSpec_refines_source 0 _ k0_correct state

@[simp] theorem k0_gateCount : k0Scheduled.gateCount = 1 := by
  simp [k0Scheduled, k0Program]

@[simp] theorem k0_depth : k0Scheduled.depth = 1 := by
  simp [k0Scheduled, k0Program]

/-! ## k = 1: CX -/

private def k1Control : Fin 1 := ⟨0, by omega⟩

/-- `C^1 X` is the native `CX`. -/
def k1Program : ReversibleProgram (lemmaOneFlatWidth 1) :=
  [.cx (controlWire 1 k1Control) (targetWire 1)
    (controlWire_ne_target 1 k1Control)]

/-- Proof-bearing singleton schedule for `C^1 X`. -/
def k1Scheduled : ScheduledReversibleProgram (lemmaOneFlatWidth 1) :=
  ScheduledReversibleProgram.sequential k1Program

private theorem allFlatControlsOne_one_iff
    (state : PrimitiveBasis (lemmaOneFlatWidth 1)) :
    allFlatControlsOne 1 state ↔
      state (controlWire 1 k1Control) = 1 := by
  constructor
  · intro controls
    exact controls k1Control
  · intro active wire
    fin_cases wire
    simpa [k1Control] using active

/-- The native `CX` inhabits the exact flat `C^1 X` contract. -/
theorem k1_correct :
    LemmaOneFlatSpec 1 (evalReversibleProgram k1Scheduled.program) := by
  intro state
  constructor
  · intro wire
    fin_cases wire
    by_cases zero : state (controlWire 1 k1Control) = 0
    · simp [k1Scheduled, k1Program, evalReversibleProgram,
        evalReversibleGate, cxBasisEquiv, cxBasisAction, zero]
    · simp [k1Scheduled, k1Program, evalReversibleProgram,
        evalReversibleGate, cxBasisEquiv, cxBasisAction, zero,
        xBasisAction, controlWire_ne_target]
  · constructor
    · by_cases zero : state (controlWire 1 k1Control) = 0
      · have inactive : ¬ allFlatControlsOne 1 state := by
          rw [allFlatControlsOne_one_iff]
          intro one
          have values := congrArg Fin.val (zero.symm.trans one)
          norm_num at values
        simp [k1Scheduled, k1Program, evalReversibleProgram,
          evalReversibleGate, cxBasisEquiv, cxBasisAction, zero, inactive]
      · have one : state (controlWire 1 k1Control) = 1 :=
          finTwo_eq_one_of_ne_zero _ zero
        have active : allFlatControlsOne 1 state :=
          (allFlatControlsOne_one_iff state).2 one
        simp [k1Scheduled, k1Program, evalReversibleProgram,
          evalReversibleGate, cxBasisEquiv, cxBasisAction, zero, active,
          xBasisAction]
    · by_cases zero : state (controlWire 1 k1Control) = 0
      · simp [k1Scheduled, k1Program, evalReversibleProgram,
          evalReversibleGate, cxBasisEquiv, cxBasisAction, zero]
      · have distinct : dirtyWire 1 ≠ targetWire 1 := dirtyWire_ne_target 1
        simp [k1Scheduled, k1Program, evalReversibleProgram,
          evalReversibleGate, cxBasisEquiv, cxBasisAction, zero,
          xBasisAction, distinct]

/-- The `k=1` circuit refines Definition 2.1 and restores workspace. -/
theorem k1_refines_source
    (state : PrimitiveBasis (lemmaOneFlatWidth 1)) :
    externalView 1 (evalReversibleProgram k1Scheduled.program state) =
        multiControlledXEquiv 1 (externalView 1 state) ∧
      evalReversibleProgram k1Scheduled.program state (dirtyWire 1) =
        state (dirtyWire 1) :=
  flatSpec_refines_source 1 _ k1_correct state

@[simp] theorem k1_gateCount : k1Scheduled.gateCount = 1 := by
  simp [k1Scheduled, k1Program]

@[simp] theorem k1_depth : k1Scheduled.depth = 1 := by
  simp [k1Scheduled, k1Program]

/-! ## k = 2: CCX -/

private def k2Control0 : Fin 2 := ⟨0, by omega⟩
private def k2Control1 : Fin 2 := ⟨1, by omega⟩

private theorem k2Control0_ne_k2Control1 : k2Control0 ≠ k2Control1 := by
  intro equal
  have values := congrArg Fin.val equal
  simp [k2Control0, k2Control1] at values

/-- `C^2 X` is the native Toffoli/`CCX`. -/
def k2Program : ReversibleProgram (lemmaOneFlatWidth 2) :=
  [.ccx
    (controlWire 2 k2Control0)
    (controlWire 2 k2Control1)
    (targetWire 2)
    (by
      intro equal
      have values := congrArg Fin.val equal
      simp [controlWire, k2Control0, k2Control1] at values)
    (controlWire_ne_target 2 k2Control0)
    (controlWire_ne_target 2 k2Control1)]

/-- Proof-bearing singleton schedule for `C^2 X`. -/
def k2Scheduled : ScheduledReversibleProgram (lemmaOneFlatWidth 2) :=
  ScheduledReversibleProgram.sequential k2Program

private theorem allFlatControlsOne_two_iff
    (state : PrimitiveBasis (lemmaOneFlatWidth 2)) :
    allFlatControlsOne 2 state ↔
      state (controlWire 2 k2Control0) = 1 ∧
      state (controlWire 2 k2Control1) = 1 := by
  constructor
  · intro controls
    exact ⟨controls k2Control0, controls k2Control1⟩
  · rintro ⟨control0, control1⟩ wire
    fin_cases wire
    · simpa [k2Control0] using control0
    · simpa [k2Control1] using control1

/-- The native `CCX` inhabits the exact flat `C^2 X` contract. -/
theorem k2_correct :
    LemmaOneFlatSpec 2 (evalReversibleProgram k2Scheduled.program) := by
  intro state
  let active : Prop :=
    state (controlWire 2 k2Control0) = 1 ∧
      state (controlWire 2 k2Control1) = 1
  constructor
  · intro wire
    fin_cases wire
    · by_cases enabled : active
      · simp [k2Scheduled, k2Program, evalReversibleProgram,
          evalReversibleGate, ccxBasisEquiv, ccxBasisAction, active, enabled,
          xBasisAction, controlWire_ne_target]
      · simp [k2Scheduled, k2Program, evalReversibleProgram,
          evalReversibleGate, ccxBasisEquiv, ccxBasisAction, active, enabled]
    · by_cases enabled : active
      · simp [k2Scheduled, k2Program, evalReversibleProgram,
          evalReversibleGate, ccxBasisEquiv, ccxBasisAction, active, enabled,
          xBasisAction, controlWire_ne_target]
      · simp [k2Scheduled, k2Program, evalReversibleProgram,
          evalReversibleGate, ccxBasisEquiv, ccxBasisAction, active, enabled]
  · constructor
    · have controlsIff := allFlatControlsOne_two_iff state
      by_cases enabled : active
      · have flatActive : allFlatControlsOne 2 state := controlsIff.mpr enabled
        simp [k2Scheduled, k2Program, evalReversibleProgram,
          evalReversibleGate, ccxBasisEquiv, ccxBasisAction, active, enabled,
          flatActive, xBasisAction]
      · have flatInactive : ¬ allFlatControlsOne 2 state := by
          intro flat
          exact enabled (controlsIff.mp flat)
        simp [k2Scheduled, k2Program, evalReversibleProgram,
          evalReversibleGate, ccxBasisEquiv, ccxBasisAction, active, enabled,
          flatInactive]
    · by_cases enabled : active
      · have distinct : dirtyWire 2 ≠ targetWire 2 := dirtyWire_ne_target 2
        simp [k2Scheduled, k2Program, evalReversibleProgram,
          evalReversibleGate, ccxBasisEquiv, ccxBasisAction, active, enabled,
          xBasisAction, distinct]
      · simp [k2Scheduled, k2Program, evalReversibleProgram,
          evalReversibleGate, ccxBasisEquiv, ccxBasisAction, active, enabled]

/-- The `k=2` circuit refines Definition 2.1 and restores workspace. -/
theorem k2_refines_source
    (state : PrimitiveBasis (lemmaOneFlatWidth 2)) :
    externalView 2 (evalReversibleProgram k2Scheduled.program state) =
        multiControlledXEquiv 2 (externalView 2 state) ∧
      evalReversibleProgram k2Scheduled.program state (dirtyWire 2) =
        state (dirtyWire 2) :=
  flatSpec_refines_source 2 _ k2_correct state

@[simp] theorem k2_gateCount : k2Scheduled.gateCount = 1 := by
  simp [k2Scheduled, k2Program]

@[simp] theorem k2_depth : k2Scheduled.depth = 1 := by
  simp [k2Scheduled, k2Program]

/-- The three native base cases need no dirty workspace gates at all, while
already satisfying the worst-case one-dirty-ancilla budget. -/
theorem baseCases_instance_resources :
    LemmaOneInstanceResourceBound 0 k0Scheduled.gateCount k0Scheduled.depth 0 1 1 ∧
    LemmaOneInstanceResourceBound 1 k1Scheduled.gateCount k1Scheduled.depth 0 1 1 ∧
    LemmaOneInstanceResourceBound 2 k2Scheduled.gateCount k2Scheduled.depth 0 1 1 := by
  simp [LemmaOneInstanceResourceBound, logScale]

end VandaeleLemma1PrimitiveBaseCases
end QuantumBlockEncoding

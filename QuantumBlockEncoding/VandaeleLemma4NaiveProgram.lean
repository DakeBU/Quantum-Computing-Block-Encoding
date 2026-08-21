import QuantumBlockEncoding.ReversibleProgramSupport
import QuantumBlockEncoding.VandaeleCorollary4ProgramFamily
import QuantumBlockEncoding.VandaeleLadderRefinement
import Mathlib.Tactic

/-!
# Actual reverse-CCX baseline for Vandaele Lemma 4

The logarithmic-depth Lemma-4 schedule is obtained from the external [9]
construction plus Appendix A.1.  Independently of that scheduling improvement,
the source second-order ladder has a direct gate-level baseline: execute the n
CCX ladder gates in reverse block order.

This file writes that arbitrary-width `ReversibleProgram` on the same stable
flat layout used by `VandaeleLemma4ProgramFamily`.  The allocated workspace
wires are never targeted by the baseline, so they are restored for **every**
incoming value.  Consequently the baseline already has strong-promise
semantics, but conservative depth n.

It is not claimed to be the Lemma-4 low-depth implementation.  It is the exact
same-target gate baseline against which Appendix A.1 can be viewed as a depth
optimization.
-/

namespace QuantumBlockEncoding
namespace VandaeleLemma4NaiveProgram

open ReversibleProgramSupport
open VandaeleCorollary4ProgramFamily
open VandaeleLadderContract
open VandaeleLadderPermutation
open VandaeleLadderRefinement
open VandaeleLemma4ProgramFamily

/-- Preceding pivot/control wire of second-order block i. -/
def previousDataWire (steps : Nat) (index : Fin steps) :
    Fin (lemmaFourFlatWidth steps) :=
  if first : index.val = 0 then pivotWire steps
  else dataTargetWire steps ⟨index.val - 1, by omega⟩

/-- Previous pivot and fresh control are distinct. -/
theorem previous_ne_fresh
    (steps : Nat) (index : Fin steps) :
    previousDataWire steps index ≠ freshControlWire steps index := by
  by_cases first : index.val = 0
  · intro equal
    simp [previousDataWire, first, pivotWire, freshControlWire] at equal
  · intro equal
    have values := congrArg Fin.val equal
    simp [previousDataWire, first, dataTargetWire, freshControlWire] at values
    omega

/-- Previous pivot and current target are distinct. -/
theorem previous_ne_target
    (steps : Nat) (index : Fin steps) :
    previousDataWire steps index ≠ dataTargetWire steps index := by
  by_cases first : index.val = 0
  · intro equal
    simp [previousDataWire, first, pivotWire, dataTargetWire] at equal
  · intro equal
    have values := congrArg Fin.val equal
    simp [previousDataWire, first, dataTargetWire] at values
    omega

/-- Fresh control and current target are distinct. -/
theorem fresh_ne_target
    (steps : Nat) (index : Fin steps) :
    freshControlWire steps index ≠ dataTargetWire steps index := by
  intro equal
  have values := congrArg Fin.val equal
  simp [freshControlWire, dataTargetWire] at values
  omega

/-- One actual second-order source gate. -/
def stepGate (steps : Nat) (index : Fin steps) :
    ReversibleGate (lemmaFourFlatWidth steps) :=
  .ccx
    (previousDataWire steps index)
    (freshControlWire steps index)
    (dataTargetWire steps index)
    (previous_ne_fresh steps index)
    (previous_ne_target steps index)
    (fresh_ne_target steps index)

/-- Descending list of the first `count` source CCX gates inside a fixed total
register. -/
def descendingProgram (steps : Nat) :
    (count : Nat) -> count <= steps ->
      ReversibleProgram (lemmaFourFlatWidth steps)
  | 0, _ => []
  | count + 1, bound =>
      stepGate steps ⟨count, by omega⟩ ::
        descendingProgram steps count (by omega)

/-- Full reverse-order CCX ladder. -/
def program (steps : Nat) : ReversibleProgram (lemmaFourFlatWidth steps) :=
  descendingProgram steps steps (Nat.le_refl _)

/-- Exact logical gate count. -/
theorem descendingProgram_length
    (steps count : Nat) (bound : count <= steps) :
    (descendingProgram steps count bound).length = count := by
  induction count with
  | zero => rfl
  | succ count induction =>
      simp [descendingProgram, induction]

@[simp] theorem program_length (steps : Nat) :
    (program steps).length = steps := by
  unfold program
  exact descendingProgram_length steps steps (Nat.le_refl _)

/-- A one-wire local-control word is all one exactly when its unique bit is one. -/
theorem allLocalControlsOne_fin1_iff
    (controls : PrimitiveBasis 1) :
    allLocalControlsOne controls ↔ controls ⟨0, by decide⟩ = 1 := by
  constructor
  · intro all
    exact all ⟨0, by decide⟩
  · intro bit wire
    fin_cases wire
    exact bit

/-- The abstract preceding pivot extracted from the flat layout is exactly the
physical previous-data wire. -/
theorem previousPivot_extract_eq_previousData
    (steps : Nat) (index : Fin steps)
    (state : PrimitiveBasis (lemmaFourFlatWidth steps)) :
    previousPivot (extractLadderState steps state) index =
      state (previousDataWire steps index) := by
  by_cases first : index.val = 0
  · simp [previousPivot, first, extractLadderState,
      previousDataWire, pivotWire]
  · rw [previousPivot_nonfirst
      (extractLadderState steps state) index first]
    simp [extractLadderState, previousDataWire, first, dataTargetWire]

/-- One abstract L2 gate is active exactly when the two physical CCX controls
are one. -/
theorem ladderActive_extract_iff
    (steps : Nat) (index : Fin steps)
    (state : PrimitiveBasis (lemmaFourFlatWidth steps)) :
    ladderActive (extractLadderState steps state) index ↔
      state (previousDataWire steps index) = 1 ∧
      state (freshControlWire steps index) = 1 := by
  unfold ladderActive
  rw [previousPivot_extract_eq_previousData steps index state]
  rw [allLocalControlsOne_fin1_iff]
  rfl

/-- A source CCX target is always a data wire, never workspace. -/
theorem stepGate_not_targets_workspace
    (steps : Nat) (index : Fin steps)
    (workspace : Fin (ladderWorkspaceWidth steps)) :
    ¬ targetsWire (stepGate steps index) (workspaceWire steps workspace) := by
  simp [stepGate, targetsWire]
  intro equal
  have values := congrArg Fin.val equal
  simp [dataTargetWire, workspaceWire, ladderDataWidth] at values
  have indexLt := index.isLt
  omega

/-- One flat CCX gate is exactly one abstract second-order ladder step after
extracting data coordinates. -/
theorem extract_eval_stepGate
    (steps : Nat) (index : Fin steps)
    (state : PrimitiveBasis (lemmaFourFlatWidth steps)) :
    extractLadderState steps (evalReversibleGate (stepGate steps index) state) =
      sourceLadderStep 1 steps index (extractLadderState steps state) := by
  apply Prod.ext
  · -- Initial pivot is never the current target.
    have distinct : dataTargetWire steps index ≠ pivotWire steps := by
      intro equal
      have values := congrArg Fin.val equal
      simp [dataTargetWire, pivotWire] at values
      omega
    by_cases active :
        state (previousDataWire steps index) = 1 ∧
          state (freshControlWire steps index) = 1
    · simp [extractLadderState, stepGate, evalReversibleGate,
        ccxBasisEquiv, ccxBasisAction, active, xBasisAction, distinct]
    · simp [extractLadderState, stepGate, evalReversibleGate,
        ccxBasisEquiv, ccxBasisAction, active]
  · funext query
    apply Prod.ext
    · funext local
      fin_cases local
      have distinct : dataTargetWire steps index ≠ freshControlWire steps query := by
        intro equal
        have values := congrArg Fin.val equal
        simp [dataTargetWire, freshControlWire] at values
        omega
      by_cases active :
          state (previousDataWire steps index) = 1 ∧
            state (freshControlWire steps index) = 1
      · simp [extractLadderState, stepGate, evalReversibleGate,
          ccxBasisEquiv, ccxBasisAction, active, xBasisAction, distinct,
          sourceLadderStep_preserves_localControls]
      · simp [extractLadderState, stepGate, evalReversibleGate,
          ccxBasisEquiv, ccxBasisAction, active,
          sourceLadderStep_preserves_localControls]
    · by_cases same : query = index
      · subst query
        have activeIff := ladderActive_extract_iff steps index state
        by_cases active :
            state (previousDataWire steps index) = 1 ∧
              state (freshControlWire steps index) = 1
        · have abstractActive : ladderActive (extractLadderState steps state) index :=
            activeIff.mpr active
          simp [extractLadderState, stepGate, evalReversibleGate,
            ccxBasisEquiv, ccxBasisAction, active, sourceLadderStep,
            abstractActive, xBasisAction]
        · have abstractInactive :
              ¬ ladderActive (extractLadderState steps state) index := by
            intro sourceActive
            exact active (activeIff.mp sourceActive)
          simp [extractLadderState, stepGate, evalReversibleGate,
            ccxBasisEquiv, ccxBasisAction, active, sourceLadderStep,
            abstractInactive]
      · have targetDistinct : dataTargetWire steps index ≠ dataTargetWire steps query := by
          intro equal
          apply same
          apply Fin.ext
          have values := congrArg Fin.val equal
          simp [dataTargetWire] at values
          omega
        by_cases active :
            state (previousDataWire steps index) = 1 ∧
              state (freshControlWire steps index) = 1
        · simp [extractLadderState, stepGate, evalReversibleGate,
            ccxBasisEquiv, ccxBasisAction, active, xBasisAction,
            targetDistinct, sourceLadderStep,
            Function.update_noteq same.symm]
        · simp [extractLadderState, stepGate, evalReversibleGate,
            ccxBasisEquiv, ccxBasisAction, active, sourceLadderStep,
            Function.update_noteq same.symm]

/-- Every descending flat prefix evaluates to the corresponding abstract ladder
permutation. -/
theorem extract_eval_descending
    (steps count : Nat) (bound : count <= steps)
    (state : PrimitiveBasis (lemmaFourFlatWidth steps)) :
    extractLadderState steps
        (evalReversibleProgram (descendingProgram steps count bound) state) =
      descendingLadderEquiv 1 steps count bound
        (extractLadderState steps state) := by
  induction count generalizing state with
  | zero => rfl
  | succ count induction =>
      let index : Fin steps := ⟨count, by omega⟩
      change
        extractLadderState steps
          (evalReversibleProgram
            (descendingProgram steps count (by omega))
            (evalReversibleGate (stepGate steps index) state)) = _
      rw [induction]
      change
        descendingLadderEquiv 1 steps count (by omega)
          (extractLadderState steps
            (evalReversibleGate (stepGate steps index) state)) = _
      rw [extract_eval_stepGate]
      rfl

/-- Full data semantics of the actual reverse-CCX list. -/
theorem extract_eval_program
    (steps : Nat) (state : PrimitiveBasis (lemmaFourFlatWidth steps)) :
    extractLadderState steps (evalReversibleProgram (program steps) state) =
      naiveLadderEquiv 1 steps (extractLadderState steps state) := by
  exact extract_eval_descending steps steps (Nat.le_refl _) state

/-- Every workspace wire is restored for arbitrary incoming contents. -/
theorem descendingProgram_preserves_workspace
    (steps count : Nat) (bound : count <= steps)
    (workspace : Fin (ladderWorkspaceWidth steps)) :
    PreservesWire (descendingProgram steps count bound)
      (workspaceWire steps workspace) := by
  induction count with
  | zero =>
      simp [PreservesWire, descendingProgram]
  | succ count induction =>
      intro gate member
      simp [descendingProgram] at member
      rcases member with rfl | member
      · exact stepGate_not_targets_workspace steps ⟨count, by omega⟩ workspace
      · exact induction (by omega) gate member

/-- Product-level workspace restoration theorem for the complete baseline. -/
theorem program_restores_workspace
    (steps : Nat)
    (state : PrimitiveBasis (lemmaFourFlatWidth steps))
    (workspace : Fin (ladderWorkspaceWidth steps)) :
    evalReversibleProgram (program steps) state (workspaceWire steps workspace) =
      state (workspaceWire steps workspace) := by
  apply evalReversibleProgram_apply_of_preservesWire
  unfold program
  exact descendingProgram_preserves_workspace
    steps steps (Nat.le_refl _) workspace

/-- The actual program satisfies the ordinary clean Lemma-4 flat contract. -/
theorem program_correct (steps : Nat) :
    LemmaFourCleanFlatSpec steps (evalReversibleProgram (program steps)) := by
  intro state clean
  have actual := extract_eval_program steps state
  have source := naiveLadderEquiv_spec 1 steps (extractLadderState steps state)
  rw [source] at actual
  refine ⟨congrArg Prod.fst actual, ?_, ?_⟩
  · intro index
    constructor
    · exact congrArg (fun ladder => (ladder.2 index).1 0) actual
    · exact congrArg (fun ladder => (ladder.2 index).2) actual
  · intro workspace
    rw [program_restores_workspace]
    exact clean workspace

/-- The same program already satisfies the stronger Corollary-4 workspace
restoration contract, albeit with linear depth. -/
theorem program_strongPromise (steps : Nat) :
    LemmaFourStrongPromiseFlatSpec steps (evalReversibleProgram (program steps)) := by
  constructor
  · intro state workspace
    exact program_restores_workspace steps state workspace
  · intro state clean
    have ordinary := program_correct steps state clean
    exact ⟨ordinary.1, ordinary.2.1⟩

/-- Every logical gate in the baseline is CCX. -/
theorem descendingProgram_onlyCCX
    (steps count : Nat) (bound : count <= steps) :
    OnlyCCX (descendingProgram steps count bound) := by
  intro gate member
  induction count with
  | zero => simp [descendingProgram] at member
  | succ count induction =>
      simp [descendingProgram] at member
      rcases member with rfl | member
      · rfl
      · exact induction (by omega) gate member

@[simp] theorem program_onlyCCX (steps : Nat) : OnlyCCX (program steps) := by
  unfold program
  exact descendingProgram_onlyCCX steps steps (Nat.le_refl _)

/-- Conservative one-gate-per-layer schedule. -/
def scheduled (steps : Nat) : ScheduledReversibleProgram (lemmaFourFlatWidth steps) :=
  ScheduledReversibleProgram.sequential (program steps)

@[simp] theorem scheduled_gateCount (steps : Nat) :
    (scheduled steps).gateCount = steps := by
  simp [scheduled]

@[simp] theorem scheduled_depth (steps : Nat) :
    (scheduled steps).depth = steps := by
  simp [scheduled]

/-- Gate-level baseline certificate. It intentionally does not inhabit the
low-depth Lemma-4 family interface because its certified depth is linear. -/
structure BaselineCertificate (steps : Nat) where
  scheduledProgram : ScheduledReversibleProgram (lemmaFourFlatWidth steps)
  strongSemantics : LemmaFourStrongPromiseFlatSpec steps
    (evalReversibleProgram scheduledProgram.program)
  onlyCCX : OnlyCCX scheduledProgram.program
  gateCount : scheduledProgram.gateCount = steps
  depth : scheduledProgram.depth = steps

/-- Canonical actual reverse-CCX baseline. -/
def baselineCertificate (steps : Nat) : BaselineCertificate steps where
  scheduledProgram := scheduled steps
  strongSemantics := by simpa [scheduled] using program_strongPromise steps
  onlyCCX := by simpa [scheduled] using program_onlyCCX steps
  gateCount := scheduled_gateCount steps
  depth := scheduled_depth steps

end VandaeleLemma4NaiveProgram
end QuantumBlockEncoding

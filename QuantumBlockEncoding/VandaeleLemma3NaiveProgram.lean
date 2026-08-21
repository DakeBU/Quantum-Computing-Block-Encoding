import QuantumBlockEncoding.ReversibleProgramInverse
import QuantumBlockEncoding.VandaeleLemma3ProgramFamily
import Mathlib.Tactic

/-!
# Actual reverse-CX baseline for Vandaele Lemma 3

The low-depth Lemma-3 schedule is cited from [9], but the source first-order
ladder has a simple gate-level baseline: execute the CX ladder in reverse block
order.  This file writes that arbitrary-width `ReversibleProgram` and proves it
refines the authoritative Equation-(5) target already formalized in
`VandaeleLadderRefinement`.

This baseline has exactly n CX gates and conservative depth n.  It is **not**
claimed to be the cited O(log n)-depth implementation.  Its role is to bind the
source semantics to real gate syntax so a future [9] schedule can be proved a
same-target depth optimization rather than a separate oracle.
-/

namespace QuantumBlockEncoding
namespace VandaeleLemma3NaiveProgram

open ReversibleProgramInverse
open VandaeleLadderContract
open VandaeleLadderPermutation
open VandaeleLadderRefinement
open VandaeleLemma3ProgramFamily

/-- The preceding pivot/control of first-order block i is flat wire i. -/
def controlWire (steps : Nat) (index : Fin steps) : Fin (flatWidth steps) :=
  ⟨index.val, by
    have := index.isLt
    unfold flatWidth
    omega⟩

@[simp] theorem controlWire_val
    (steps : Nat) (index : Fin steps) :
    (controlWire steps index).val = index.val := rfl

@[simp] theorem targetWire_val
    (steps : Nat) (index : Fin steps) :
    (VandaeleLemma3ProgramFamily.targetWire steps index).val = index.val + 1 := rfl

/-- Control and target of one source CX are distinct. -/
theorem control_ne_target
    (steps : Nat) (index : Fin steps) :
    controlWire steps index ≠ VandaeleLemma3ProgramFamily.targetWire steps index := by
  intro equal
  have values := congrArg Fin.val equal
  simp only [controlWire_val, targetWire_val] at values
  omega

/-- One actual source CX gate. -/
def stepGate (steps : Nat) (index : Fin steps) :
    ReversibleGate (flatWidth steps) :=
  .cx (controlWire steps index)
    (VandaeleLemma3ProgramFamily.targetWire steps index)
    (control_ne_target steps index)

/-- Descending list of the first `count` source gates inside a fixed total
`steps`-block register. -/
def descendingProgram (steps : Nat) :
    (count : Nat) -> count <= steps -> ReversibleProgram (flatWidth steps)
  | 0, _ => []
  | count + 1, bound =>
      stepGate steps ⟨count, by omega⟩ ::
        descendingProgram steps count (by omega)

/-- Full reverse-order CX ladder. -/
def program (steps : Nat) : ReversibleProgram (flatWidth steps) :=
  descendingProgram steps steps (Nat.le_refl _)

/-- Exact gate count of every descending prefix. -/
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

/-- The extracted preceding pivot is exactly the flat CX control bit. -/
theorem previousPivot_extract_eq_control
    (steps : Nat) (index : Fin steps)
    (state : PrimitiveBasis (flatWidth steps)) :
    previousPivot (extractLadderState steps state) index =
      state (controlWire steps index) := by
  by_cases first : index.val = 0
  · have indexZero : index.val = 0 := first
    simp [previousPivot, first, extractLadderState,
      pivotWire, controlWire, indexZero]
  · rw [previousPivot_nonfirst
      (extractLadderState steps state) index first]
    simp [extractLadderState, controlWire,
      VandaeleLemma3ProgramFamily.targetWire]
    have positive : 0 < index.val := Nat.pos_of_ne_zero first
    omega

/-- For first-order ladders there are no fresh local controls, so activation is
exactly the value of the preceding flat control wire. -/
theorem ladderActive_extract_iff
    (steps : Nat) (index : Fin steps)
    (state : PrimitiveBasis (flatWidth steps)) :
    ladderActive (extractLadderState steps state) index ↔
      state (controlWire steps index) = 1 := by
  unfold ladderActive allLocalControlsOne
  rw [previousPivot_extract_eq_control steps index state]
  constructor
  · intro active
    exact active.1
  · intro active
    refine ⟨active, ?_⟩
    intro impossible
    exact Fin.elim0 impossible

/-- One flat CX gate is exactly one abstract first-order ladder step after
extracting the ladder register coordinates. -/
theorem extract_eval_stepGate
    (steps : Nat) (index : Fin steps)
    (state : PrimitiveBasis (flatWidth steps)) :
    extractLadderState steps (evalReversibleGate (stepGate steps index) state) =
      sourceLadderStep 0 steps index (extractLadderState steps state) := by
  apply Prod.ext
  · -- The pivot is never a CX target.
    unfold extractLadderState
    by_cases active : state (controlWire steps index) = 0
    · simp [stepGate, evalReversibleGate, cxBasisEquiv, cxBasisAction,
        active, pivotWire]
    · have targetNotPivot :
        VandaeleLemma3ProgramFamily.targetWire steps index ≠ pivotWire steps := by
        intro equal
        have values := congrArg Fin.val equal
        simp [VandaeleLemma3ProgramFamily.targetWire, pivotWire] at values
        omega
      simp [stepGate, evalReversibleGate, cxBasisEquiv, cxBasisAction,
        active, xBasisAction, targetNotPivot]
  · funext query
    apply Prod.ext
    · funext impossible
      exact Fin.elim0 impossible
    · by_cases same : query = index
      · subst query
        have activeIff := ladderActive_extract_iff steps index state
        by_cases controlOne : state (controlWire steps index) = 1
        · have controlNonzero : state (controlWire steps index) ≠ 0 := by
            intro zero
            have : (1 : Fin 2) = 0 := by simpa [controlOne] using zero.symm
            decide at this
        · have abstractActive : ladderActive (extractLadderState steps state) index :=
            activeIff.mpr controlOne
          simp [stepGate, evalReversibleGate, cxBasisEquiv, cxBasisAction,
            controlNonzero, extractLadderState, sourceLadderStep,
            abstractActive, xBasisAction]
        · have controlZero : state (controlWire steps index) = 0 := by
            fin_cases h : state (controlWire steps index) <;> simp_all
          have abstractInactive :
              ¬ ladderActive (extractLadderState steps state) index := by
            intro active
            have one := activeIff.mp active
            rw [controlZero] at one
            decide at one
          simp [stepGate, evalReversibleGate, cxBasisEquiv, cxBasisAction,
            controlZero, extractLadderState, sourceLadderStep,
            abstractInactive]
      · have targetDistinct :
          VandaeleLemma3ProgramFamily.targetWire steps index ≠
            VandaeleLemma3ProgramFamily.targetWire steps query := by
          intro equal
          apply same
          apply Fin.ext
          have values := congrArg Fin.val equal
          simp only [targetWire_val] at values
          omega
        by_cases controlZero : state (controlWire steps index) = 0
        · simp [stepGate, evalReversibleGate, cxBasisEquiv, cxBasisAction,
            controlZero, extractLadderState, sourceLadderStep,
            Function.update_noteq same.symm]
        · simp [stepGate, evalReversibleGate, cxBasisEquiv, cxBasisAction,
            controlZero, extractLadderState, sourceLadderStep,
            Function.update_noteq same.symm, xBasisAction, targetDistinct]

/-- Every descending flat prefix evaluates to the corresponding abstract
`descendingLadderEquiv`. -/
theorem extract_eval_descending
    (steps count : Nat) (bound : count <= steps)
    (state : PrimitiveBasis (flatWidth steps)) :
    extractLadderState steps
        (evalReversibleProgram (descendingProgram steps count bound) state) =
      descendingLadderEquiv 0 steps count bound
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
        descendingLadderEquiv 0 steps count (by omega)
          (extractLadderState steps
            (evalReversibleGate (stepGate steps index) state)) = _
      rw [extract_eval_stepGate]
      rfl

/-- Main gate-level semantic theorem: the actual reverse-CX list realizes the
source-certified naive ladder permutation. -/
theorem extract_eval_program
    (steps : Nat) (state : PrimitiveBasis (flatWidth steps)) :
    extractLadderState steps (evalReversibleProgram (program steps) state) =
      naiveLadderEquiv 0 steps (extractLadderState steps state) := by
  exact extract_eval_descending steps steps (Nat.le_refl _) state

/-- The actual CX program therefore satisfies the public Lemma-3 flat source
contract and hence closed-form Equation (5). -/
theorem program_correct (steps : Nat) :
    LemmaThreeFlatSpec steps (evalReversibleProgram (program steps)) := by
  intro state
  have actual := extract_eval_program steps state
  have source := naiveLadderEquiv_spec 0 steps (extractLadderState steps state)
  rw [source] at actual
  constructor
  · exact congrArg Prod.fst actual
  · intro index
    exact congrArg (fun ladder => (ladder.2 index).2) actual

/-- Every logical gate in the baseline is CX. -/
theorem descendingProgram_onlyCX
    (steps count : Nat) (bound : count <= steps) :
    OnlyCX (descendingProgram steps count bound) := by
  intro gate member
  induction count with
  | zero => simp [descendingProgram] at member
  | succ count induction =>
      simp [descendingProgram] at member
      rcases member with rfl | member
      · rfl
      · exact induction (by omega) gate member

@[simp] theorem program_onlyCX (steps : Nat) : OnlyCX (program steps) := by
  unfold program
  exact descendingProgram_onlyCX steps steps (Nat.le_refl _)

/-- Conservative schedule of the exact baseline list. -/
def scheduled (steps : Nat) : ScheduledReversibleProgram (flatWidth steps) :=
  ScheduledReversibleProgram.sequential (program steps)

@[simp] theorem scheduled_gateCount (steps : Nat) :
    (scheduled steps).gateCount = steps := by
  simp [scheduled]

@[simp] theorem scheduled_depth (steps : Nat) :
    (scheduled steps).depth = steps := by
  simp [scheduled]

/-- Finite baseline certificate.  This deliberately does not inhabit the
low-depth Lemma-3 family interface: its certified depth is linear. -/
structure BaselineCertificate (steps : Nat) where
  scheduledProgram : ScheduledReversibleProgram (flatWidth steps)
  semantics : LemmaThreeFlatSpec steps
    (evalReversibleProgram scheduledProgram.program)
  onlyCX : OnlyCX scheduledProgram.program
  gateCount : scheduledProgram.gateCount = steps
  depth : scheduledProgram.depth = steps

/-- Canonical baseline certificate from the actual reverse-CX program. -/
def baselineCertificate (steps : Nat) : BaselineCertificate steps where
  scheduledProgram := scheduled steps
  semantics := by simpa [scheduled] using program_correct steps
  onlyCX := by simpa [scheduled] using program_onlyCX steps
  gateCount := scheduled_gateCount steps
  depth := scheduled_depth steps

end VandaeleLemma3NaiveProgram
end QuantumBlockEncoding

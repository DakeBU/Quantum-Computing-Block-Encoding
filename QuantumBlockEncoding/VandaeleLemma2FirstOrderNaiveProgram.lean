import QuantumBlockEncoding.VandaeleLemma2ProgramFamily
import Mathlib.Tactic

/-!
# Actual first-order fan-out baseline for Vandaele Lemma 2

For order k=1, every Definition-2.2 fan-out block has exactly two controls: the
shared global bit and one local bit.  Hence the naive source circuit is a list
of n CCX gates, one per target block.

The gates share the global control, so the conservative schedule has depth n;
this is **not** the logarithmic-depth Lemma-2 construction.  Its purpose is to
bind `F_1^(n)` to real reversible gate syntax and exact source semantics.  The
low-depth construction can then be treated as a same-target optimization.
-/

namespace QuantumBlockEncoding
namespace VandaeleLemma2FirstOrderNaiveProgram

open ComparatorIncrementerFanoutSource
open VandaeleLemma2ProgramFamily

/-- The unique local control of a first-order fan-out block. -/
def localControlWire (blocks : Nat) (block : Fin blocks) :
    Fin (fanoutFlatWidth 1 blocks) :=
  localWire 1 blocks block ⟨0, by decide⟩

/-- Global and local controls are distinct. -/
theorem global_ne_local
    (blocks : Nat) (block : Fin blocks) :
    globalWire 1 blocks ≠ localControlWire blocks block := by
  intro equal
  have values := congrArg Fin.val equal
  simp [globalWire, localControlWire, localWire] at values

/-- Global control and target are distinct. -/
theorem global_ne_target
    (blocks : Nat) (block : Fin blocks) :
    globalWire 1 blocks ≠ targetWire 1 blocks block := by
  intro equal
  have values := congrArg Fin.val equal
  simp [globalWire, targetWire] at values

/-- Local control and target are distinct. -/
theorem local_ne_target
    (blocks : Nat) (block : Fin blocks) :
    localControlWire blocks block ≠ targetWire 1 blocks block := by
  intro equal
  have values := congrArg Fin.val equal
  simp [localControlWire, localWire, targetWire] at values
  omega

/-- One first-order fan-out source gate. -/
def blockGate (blocks : Nat) (block : Fin blocks) :
    ReversibleGate (fanoutFlatWidth 1 blocks) :=
  .ccx
    (globalWire 1 blocks)
    (localControlWire blocks block)
    (targetWire 1 blocks block)
    (global_ne_local blocks block)
    (global_ne_target blocks block)
    (local_ne_target blocks block)

/-- Structural chronological list of blocks 0,...,count-1.  Because distinct
blocks only share controls and have disjoint targets, their semantic order is
irrelevant; ascending order is chosen for a canonical baseline. -/
def programFrom (blocks : Nat) :
    (start count : Nat) -> start + count <= blocks ->
      ReversibleProgram (fanoutFlatWidth 1 blocks)
  | _, 0, _ => []
  | start, count + 1, bound =>
      blockGate blocks ⟨start, by omega⟩ ::
        programFrom blocks (start + 1) count (by omega)

/-- Complete naive first-order fan-out program. -/
def program (blocks : Nat) : ReversibleProgram (fanoutFlatWidth 1 blocks) :=
  programFrom blocks 0 blocks (by omega)

/-- Exact length of a program range. -/
theorem programFrom_length
    (blocks start count : Nat) (bound : start + count <= blocks) :
    (programFrom blocks start count bound).length = count := by
  induction count generalizing start with
  | zero => rfl
  | succ count induction =>
      simp [programFrom, induction (start := start + 1)]

@[simp] theorem program_length (blocks : Nat) :
    (program blocks).length = blocks := by
  unfold program
  exact programFrom_length blocks 0 blocks (by omega)

/-- One block gate preserves the shared global control. -/
theorem blockGate_preserves_global
    (blocks : Nat) (block : Fin blocks)
    (state : PrimitiveBasis (fanoutFlatWidth 1 blocks)) :
    evalReversibleGate (blockGate blocks block) state (globalWire 1 blocks) =
      state (globalWire 1 blocks) := by
  by_cases active :
      state (globalWire 1 blocks) = 1 ∧
        state (localControlWire blocks block) = 1
  · simp [blockGate, evalReversibleGate, ccxBasisEquiv,
      ccxBasisAction, active, xBasisAction, global_ne_target]
  · simp [blockGate, evalReversibleGate, ccxBasisEquiv,
      ccxBasisAction, active]

/-- One block gate preserves every local-control wire. -/
theorem blockGate_preserves_local
    (blocks : Nat) (block query : Fin blocks)
    (state : PrimitiveBasis (fanoutFlatWidth 1 blocks)) :
    evalReversibleGate (blockGate blocks block) state
        (localControlWire blocks query) =
      state (localControlWire blocks query) := by
  have targetDistinct :
      targetWire 1 blocks block ≠ localControlWire blocks query := by
    intro equal
    have values := congrArg Fin.val equal
    simp [targetWire, localControlWire, localWire] at values
    omega
  by_cases active :
      state (globalWire 1 blocks) = 1 ∧
        state (localControlWire blocks block) = 1
  · simp [blockGate, evalReversibleGate, ccxBasisEquiv,
      ccxBasisAction, active, xBasisAction, targetDistinct]
  · simp [blockGate, evalReversibleGate, ccxBasisEquiv,
      ccxBasisAction, active]

/-- One block gate only writes its own target. -/
theorem blockGate_preserves_other_target
    (blocks : Nat) (block query : Fin blocks)
    (different : query ≠ block)
    (state : PrimitiveBasis (fanoutFlatWidth 1 blocks)) :
    evalReversibleGate (blockGate blocks block) state
        (targetWire 1 blocks query) =
      state (targetWire 1 blocks query) := by
  have targetDistinct : targetWire 1 blocks block ≠ targetWire 1 blocks query := by
    intro equal
    apply different
    apply Fin.ext
    have values := congrArg Fin.val equal
    simp [targetWire] at values
    omega
  by_cases active :
      state (globalWire 1 blocks) = 1 ∧
        state (localControlWire blocks block) = 1
  · simp [blockGate, evalReversibleGate, ccxBasisEquiv,
      ccxBasisAction, active, xBasisAction, targetDistinct]
  · simp [blockGate, evalReversibleGate, ccxBasisEquiv,
      ccxBasisAction, active]

/-- Exact target action of one block gate. -/
theorem blockGate_target
    (blocks : Nat) (block : Fin blocks)
    (state : PrimitiveBasis (fanoutFlatWidth 1 blocks)) :
    evalReversibleGate (blockGate blocks block) state
        (targetWire 1 blocks block) =
      if flatFanoutActive 1 blocks state block then
        flipBit (state (targetWire 1 blocks block))
      else state (targetWire 1 blocks block) := by
  have activeIff :
      flatFanoutActive 1 blocks state block ↔
        state (globalWire 1 blocks) = 1 ∧
          state (localControlWire blocks block) = 1 := by
    unfold flatFanoutActive
    constructor
    · intro active
      exact ⟨active.1, active.2 ⟨0, by decide⟩⟩
    · intro active
      refine ⟨active.1, ?_⟩
      intro wire
      fin_cases wire
      exact active.2
  by_cases active :
      state (globalWire 1 blocks) = 1 ∧
        state (localControlWire blocks block) = 1
  · have sourceActive : flatFanoutActive 1 blocks state block := activeIff.mpr active
    simp [blockGate, evalReversibleGate, ccxBasisEquiv,
      ccxBasisAction, active, sourceActive, xBasisAction]
  · have sourceInactive : ¬ flatFanoutActive 1 blocks state block := by
      intro source
      exact active (activeIff.mp source)
    simp [blockGate, evalReversibleGate, ccxBasisEquiv,
      ccxBasisAction, active, sourceInactive]

/-- Program ranges preserve the global control. -/
theorem programFrom_preserves_global
    (blocks start count : Nat) (bound : start + count <= blocks)
    (state : PrimitiveBasis (fanoutFlatWidth 1 blocks)) :
    evalReversibleProgram (programFrom blocks start count bound) state
        (globalWire 1 blocks) = state (globalWire 1 blocks) := by
  induction count generalizing start state with
  | zero => rfl
  | succ count induction =>
      let block : Fin blocks := ⟨start, by omega⟩
      change
        evalReversibleProgram (programFrom blocks (start + 1) count (by omega))
          (evalReversibleGate (blockGate blocks block) state)
          (globalWire 1 blocks) = _
      rw [induction]
      exact blockGate_preserves_global blocks block state

/-- Program ranges preserve all local controls. -/
theorem programFrom_preserves_local
    (blocks start count : Nat) (bound : start + count <= blocks)
    (query : Fin blocks)
    (state : PrimitiveBasis (fanoutFlatWidth 1 blocks)) :
    evalReversibleProgram (programFrom blocks start count bound) state
        (localControlWire blocks query) = state (localControlWire blocks query) := by
  induction count generalizing start state with
  | zero => rfl
  | succ count induction =>
      let block : Fin blocks := ⟨start, by omega⟩
      change
        evalReversibleProgram (programFrom blocks (start + 1) count (by omega))
          (evalReversibleGate (blockGate blocks block) state)
          (localControlWire blocks query) = _
      rw [induction]
      exact blockGate_preserves_local blocks block query state

/-- Target query is toggled exactly if its block occurs in the executed range. -/
theorem programFrom_target
    (blocks start count : Nat) (bound : start + count <= blocks)
    (query : Fin blocks)
    (state : PrimitiveBasis (fanoutFlatWidth 1 blocks)) :
    evalReversibleProgram (programFrom blocks start count bound) state
        (targetWire 1 blocks query) =
      if start <= query.val ∧ query.val < start + count then
        (if flatFanoutActive 1 blocks state query then
          flipBit (state (targetWire 1 blocks query))
        else state (targetWire 1 blocks query))
      else state (targetWire 1 blocks query) := by
  induction count generalizing start state with
  | zero =>
      simp [programFrom]
  | succ count induction =>
      let block : Fin blocks := ⟨start, by omega⟩
      let after := evalReversibleGate (blockGate blocks block) state
      change
        evalReversibleProgram (programFrom blocks (start + 1) count (by omega))
          after (targetWire 1 blocks query) = _
      rw [induction]
      by_cases same : query = block
      · subst query
        have notLater : ¬ start + 1 <= block.val := by simp [block]
        have inRange : start <= block.val ∧ block.val < start + (count + 1) := by
          simp [block]
        rw [if_neg]
        · rw [if_pos inRange]
          exact blockGate_target blocks block state
        · intro later
          exact notLater later.1
      · have blockValNe : query.val ≠ start := by
          intro equal
          apply same
          apply Fin.ext
          simpa [block] using equal
        have targetPreserved :=
          blockGate_preserves_other_target blocks block query same state
        have globalPreserved := blockGate_preserves_global blocks block state
        have localPreserved := blockGate_preserves_local blocks block query state
        have activePreserved :
            flatFanoutActive 1 blocks after query ↔
              flatFanoutActive 1 blocks state query := by
          unfold flatFanoutActive
          rw [globalPreserved]
          constructor
          · intro active
            refine ⟨active.1, ?_⟩
            intro wire
            fin_cases wire
            simpa [after, localControlWire] using
              active.2 ⟨0, by decide⟩
          · intro active
            refine ⟨active.1, ?_⟩
            intro wire
            fin_cases wire
            simpa [after, localControlWire] using
              active.2 ⟨0, by decide⟩
        rw [targetPreserved]
        by_cases later : start + 1 <= query.val ∧
            query.val < start + 1 + count
        · rw [if_pos later]
          have whole : start <= query.val ∧ query.val < start + (count + 1) := by
            omega
          rw [if_pos whole]
          simp only [activePreserved]
        · rw [if_neg later]
          by_cases whole : start <= query.val ∧ query.val < start + (count + 1)
          · have equalStart : query.val = start := by omega
            exact (blockValNe equalStart).elim
          · rw [if_neg whole]

/-- Main gate-level correctness: the actual n-CCX list realizes Definition 2.2
first-order fan-out exactly. -/
theorem program_correct (blocks : Nat) :
    FanoutFlatSpec 1 blocks (evalReversibleProgram (program blocks)) := by
  intro state
  constructor
  · exact programFrom_preserves_global blocks 0 blocks (by omega) state
  · constructor
    · intro block wire
      fin_cases wire
      exact programFrom_preserves_local
        blocks 0 blocks (by omega) block state
    · intro block
      have target := programFrom_target blocks 0 blocks (by omega) block state
      have whole : 0 <= block.val ∧ block.val < 0 + blocks := by
        exact ⟨Nat.zero_le _, block.isLt⟩
      simpa [whole] using target

/-- Conservative sequential schedule. -/
def scheduled (blocks : Nat) :
    ScheduledReversibleProgram (fanoutFlatWidth 1 blocks) :=
  ScheduledReversibleProgram.sequential (program blocks)

@[simp] theorem scheduled_gateCount (blocks : Nat) :
    (scheduled blocks).gateCount = blocks := by
  simp [scheduled]

@[simp] theorem scheduled_depth (blocks : Nat) :
    (scheduled blocks).depth = blocks := by
  simp [scheduled]

/-- Gate-level first-order fan-out baseline. -/
structure BaselineCertificate (blocks : Nat) where
  scheduledProgram : ScheduledReversibleProgram (fanoutFlatWidth 1 blocks)
  semantics : FanoutFlatSpec 1 blocks
    (evalReversibleProgram scheduledProgram.program)
  gateCount : scheduledProgram.gateCount = blocks
  depth : scheduledProgram.depth = blocks

/-- Canonical baseline certificate. -/
def baselineCertificate (blocks : Nat) : BaselineCertificate blocks where
  scheduledProgram := scheduled blocks
  semantics := by simpa [scheduled] using program_correct blocks
  gateCount := scheduled_gateCount blocks
  depth := scheduled_depth blocks

end VandaeleLemma2FirstOrderNaiveProgram
end QuantumBlockEncoding

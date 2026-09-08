import QuantumBlockEncoding.VandaeleLemma1NieLayout
import Mathlib.Tactic

/-!
# Fixed-gadget semantics inside the Nie Figure-3 parent layout

The recursive correctness proof should never need to unfold the four- and
ten-CCX gadgets again.  This module transports their already-certified flat
semantics through the Figure-3 wire embeddings.

It exposes exactly the two source-facing facts used by the induction:

* Step 1 toggles the clean flag `A` iff the four reserved controls are all one,
  while restoring the outer target used as borrowed workspace;
* Step 3 toggles the outer target iff `I₁`, `I₃`, and `A` are one, while
  restoring `I₂` used as borrowed workspace.
-/

namespace QuantumBlockEncoding
namespace VandaeleLemma1NieFixedSemantics

open VandaeleLemma1ProgramFamily
open VandaeleLemma1NieLayout
open VandaeleLemma1BorrowedNCTGadgets
open ReversibleWireEmbedding
open ScheduledWireEmbedding

local instance instDecidableAllFlatControlsOne
    (k : Nat) (state : PrimitiveBasis (lemmaOneFlatWidth k)) :
    Decidable (allFlatControlsOne k state) := by
  unfold allFlatControlsOne
  infer_instance

private def i0 : Fin 4 := ⟨0, by omega⟩
private def i1 : Fin 4 := ⟨1, by omega⟩
private def i2 : Fin 4 := ⟨2, by omega⟩
private def i3 : Fin 4 := ⟨3, by omega⟩

/-- The physical parent wire of one of Figure 3's four reserved controls. -/
def reservedWire (k : Nat) (four_le : 4 ≤ k) (index : Fin 4) :
    Fin (lemmaOneFlatWidth k) :=
  controlWire k (reservedControl k four_le index)

@[simp] theorem stepOneEmbed_control
    (k : Nat) (four_le : 4 ≤ k) (index : Fin 4) :
    stepOneEmbed k four_le (controlWire 4 index) =
      reservedWire k four_le index := by
  apply Fin.ext
  simp [stepOneEmbed, reservedWire, controlWire, reservedControl, index.isLt]

@[simp] theorem stepOneEmbed_target
    (k : Nat) (four_le : 4 ≤ k) :
    stepOneEmbed k four_le (targetWire 4) = dirtyWire k := by
  apply Fin.ext
  simp [stepOneEmbed, targetWire, dirtyWire]

@[simp] theorem stepOneEmbed_dirty
    (k : Nat) (four_le : 4 ≤ k) :
    stepOneEmbed k four_le (dirtyWire 4) = targetWire k := by
  apply Fin.ext
  simp [stepOneEmbed, targetWire, dirtyWire]

/-- The four controls selected by Figure-3 Step 1 were all one. -/
def ReservedAllOne (k : Nat) (four_le : 4 ≤ k)
    (state : PrimitiveBasis (lemmaOneFlatWidth k)) : Prop :=
  ∀ index : Fin 4, state (reservedWire k four_le index) = 1

local instance instDecidableReservedAllOne
    (k : Nat) (four_le : 4 ≤ k)
    (state : PrimitiveBasis (lemmaOneFlatWidth k)) :
    Decidable (ReservedAllOne k four_le state) := by
  unfold ReservedAllOne
  infer_instance

/-- Reading the Step-1 child through its embedding preserves exactly the source
four-control activation predicate. -/
theorem stepOne_allFlatControlsOne_iff
    (k : Nat) (four_le : 4 ≤ k)
    (state : PrimitiveBasis (lemmaOneFlatWidth k)) :
    allFlatControlsOne 4 (readEmbeddedState (stepOneEmbed k four_le) state) ↔
      ReservedAllOne k four_le state := by
  constructor
  · intro active index
    have hit := active index
    simpa [readEmbeddedState] using hit
  · intro active index
    have hit := active index
    simpa [readEmbeddedState] using hit

/-- Figure-3 Step 1 toggles the parent clean flag `A` (the final flat wire)
exactly when the four reserved controls are all one. -/
theorem stepOne_dirty_action
    (k : Nat) (four_le : 4 ≤ k)
    (state : PrimitiveBasis (lemmaOneFlatWidth k)) :
    evalReversibleProgram (stepOneScheduled k four_le).program state
        (dirtyWire k) =
      if ReservedAllOne k four_le state then
        flipBit (state (dirtyWire k))
      else state (dirtyWire k) := by
  let childState : PrimitiveBasis (lemmaOneFlatWidth 4) :=
    readEmbeddedState (stepOneEmbed k four_le) state
  have transport :=
    readEmbeddedState_eval_mapScheduledWires
      (stepOneEmbed k four_le) (stepOneEmbed_injective k four_le)
      k4Scheduled state
  have atTarget := congrFun transport (targetWire 4)
  have targetSpec := (k4_correct childState).2.1
  calc
    evalReversibleProgram (stepOneScheduled k four_le).program state
        (dirtyWire k) =
        evalReversibleProgram k4Scheduled.program childState (targetWire 4) := by
      simpa [stepOneScheduled, childState, readEmbeddedState] using atTarget
    _ = if allFlatControlsOne 4 childState then
          flipBit (childState (targetWire 4))
        else childState (targetWire 4) := targetSpec
    _ = if ReservedAllOne k four_le state then
          flipBit (state (dirtyWire k))
        else state (dirtyWire k) := by
      rw [stepOne_allFlatControlsOne_iff]
      simp [childState, readEmbeddedState]

/-- Step 1 restores the outer target `T` used as its arbitrary borrowed bit. -/
theorem stepOne_restores_target
    (k : Nat) (four_le : 4 ≤ k)
    (state : PrimitiveBasis (lemmaOneFlatWidth k)) :
    evalReversibleProgram (stepOneScheduled k four_le).program state
        (targetWire k) = state (targetWire k) := by
  let childState : PrimitiveBasis (lemmaOneFlatWidth 4) :=
    readEmbeddedState (stepOneEmbed k four_le) state
  have transport :=
    readEmbeddedState_eval_mapScheduledWires
      (stepOneEmbed k four_le) (stepOneEmbed_injective k four_le)
      k4Scheduled state
  have atDirty := congrFun transport (dirtyWire 4)
  have dirtySpec := (k4_correct childState).2.2
  calc
    evalReversibleProgram (stepOneScheduled k four_le).program state
        (targetWire k) =
        evalReversibleProgram k4Scheduled.program childState (dirtyWire 4) := by
      simpa [stepOneScheduled, childState, readEmbeddedState] using atDirty
    _ = childState (dirtyWire 4) := dirtySpec
    _ = state (targetWire k) := by
      simp [childState, readEmbeddedState]

private def c0 : Fin 3 := ⟨0, by omega⟩
private def c1 : Fin 3 := ⟨1, by omega⟩
private def c2 : Fin 3 := ⟨2, by omega⟩

@[simp] theorem stepThreeEmbed_c0
    (k : Nat) (four_le : 4 ≤ k) :
    stepThreeEmbed k four_le (controlWire 3 c0) =
      reservedWire k four_le i0 := by
  apply Fin.ext
  simp [stepThreeEmbed, reservedWire, controlWire, reservedControl, c0, i0]

@[simp] theorem stepThreeEmbed_c1
    (k : Nat) (four_le : 4 ≤ k) :
    stepThreeEmbed k four_le (controlWire 3 c1) =
      reservedWire k four_le i2 := by
  apply Fin.ext
  simp [stepThreeEmbed, reservedWire, controlWire, reservedControl, c1, i2]

@[simp] theorem stepThreeEmbed_c2
    (k : Nat) (four_le : 4 ≤ k) :
    stepThreeEmbed k four_le (controlWire 3 c2) = dirtyWire k := by
  apply Fin.ext
  simp [stepThreeEmbed, controlWire, c2, dirtyWire]

@[simp] theorem stepThreeEmbed_target
    (k : Nat) (four_le : 4 ≤ k) :
    stepThreeEmbed k four_le (targetWire 3) = targetWire k := by
  apply Fin.ext
  simp [stepThreeEmbed, targetWire]

@[simp] theorem stepThreeEmbed_dirty
    (k : Nat) (four_le : 4 ≤ k) :
    stepThreeEmbed k four_le (dirtyWire 3) =
      reservedWire k four_le i1 := by
  apply Fin.ext
  simp [stepThreeEmbed, reservedWire, dirtyWire, controlWire,
    reservedControl, i1]

/-- Parent-register activation predicate of the fixed Step-3 `C³X`. -/
def StepThreeActive (k : Nat) (four_le : 4 ≤ k)
    (state : PrimitiveBasis (lemmaOneFlatWidth k)) : Prop :=
  state (reservedWire k four_le i0) = 1 ∧
  state (reservedWire k four_le i2) = 1 ∧
  state (dirtyWire k) = 1

local instance instDecidableStepThreeActive
    (k : Nat) (four_le : 4 ≤ k)
    (state : PrimitiveBasis (lemmaOneFlatWidth k)) :
    Decidable (StepThreeActive k four_le state) := by
  unfold StepThreeActive
  infer_instance

/-- Reading the embedded three-control gadget gives exactly the parent Step-3
activation predicate `I₁ ∧ I₃ ∧ A`. -/
theorem stepThree_allFlatControlsOne_iff
    (k : Nat) (four_le : 4 ≤ k)
    (state : PrimitiveBasis (lemmaOneFlatWidth k)) :
    allFlatControlsOne 3 (readEmbeddedState (stepThreeEmbed k four_le) state) ↔
      StepThreeActive k four_le state := by
  constructor
  · intro active
    refine ⟨?_, ?_, ?_⟩
    · simpa [readEmbeddedState] using active c0
    · simpa [readEmbeddedState] using active c1
    · simpa [readEmbeddedState] using active c2
  · rintro ⟨h0, h1, h2⟩ index
    fin_cases index
    · simpa [readEmbeddedState, c0] using h0
    · simpa [readEmbeddedState, c1] using h1
    · simpa [readEmbeddedState, c2] using h2

/-- Figure-3 Step 3 changes only the outer target according to the logical
three-control predicate inherited from the certified four-CCX gadget. -/
theorem stepThree_target_action
    (k : Nat) (four_le : 4 ≤ k)
    (state : PrimitiveBasis (lemmaOneFlatWidth k)) :
    evalReversibleProgram (stepThreeScheduled k four_le).program state
        (targetWire k) =
      if StepThreeActive k four_le state then
        flipBit (state (targetWire k))
      else state (targetWire k) := by
  let childState : PrimitiveBasis (lemmaOneFlatWidth 3) :=
    readEmbeddedState (stepThreeEmbed k four_le) state
  have transport :=
    readEmbeddedState_eval_mapScheduledWires
      (stepThreeEmbed k four_le) (stepThreeEmbed_injective k four_le)
      k3Scheduled state
  have atTarget := congrFun transport (targetWire 3)
  have targetSpec := (k3_correct childState).2.1
  calc
    evalReversibleProgram (stepThreeScheduled k four_le).program state
        (targetWire k) =
        evalReversibleProgram k3Scheduled.program childState (targetWire 3) := by
      simpa [stepThreeScheduled, childState, readEmbeddedState] using atTarget
    _ = if allFlatControlsOne 3 childState then
          flipBit (childState (targetWire 3))
        else childState (targetWire 3) := targetSpec
    _ = if StepThreeActive k four_le state then
          flipBit (state (targetWire k))
        else state (targetWire k) := by
      rw [stepThree_allFlatControlsOne_iff]
      simp [childState, readEmbeddedState]

/-- Step 3 restores `I₂`, the arbitrary borrowed bit of its embedded `C³X`. -/
theorem stepThree_restores_i1
    (k : Nat) (four_le : 4 ≤ k)
    (state : PrimitiveBasis (lemmaOneFlatWidth k)) :
    evalReversibleProgram (stepThreeScheduled k four_le).program state
        (reservedWire k four_le i1) =
      state (reservedWire k four_le i1) := by
  let childState : PrimitiveBasis (lemmaOneFlatWidth 3) :=
    readEmbeddedState (stepThreeEmbed k four_le) state
  have transport :=
    readEmbeddedState_eval_mapScheduledWires
      (stepThreeEmbed k four_le) (stepThreeEmbed_injective k four_le)
      k3Scheduled state
  have atDirty := congrFun transport (dirtyWire 3)
  have dirtySpec := (k3_correct childState).2.2
  calc
    evalReversibleProgram (stepThreeScheduled k four_le).program state
        (reservedWire k four_le i1) =
        evalReversibleProgram k3Scheduled.program childState (dirtyWire 3) := by
      simpa [stepThreeScheduled, childState, readEmbeddedState] using atDirty
    _ = childState (dirtyWire 3) := dirtySpec
    _ = state (reservedWire k four_le i1) := by
      simp [childState, readEmbeddedState]

end VandaeleLemma1NieFixedSemantics
end QuantumBlockEncoding
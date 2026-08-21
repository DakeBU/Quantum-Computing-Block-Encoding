import QuantumBlockEncoding.NieZiSunDirtyScheduledFamily
import QuantumBlockEncoding.NieZiSunDirtyScheduledResources
import QuantumBlockEncoding.ScheduledWireEmbedding
import QuantumBlockEncoding.VandaeleLemma1ProgramFamily
import Mathlib.Tactic

/-!
# Reproduced Nie--Zi--Sun family as the Vandaele Lemma-1 witness

The two libraries use the same total width but different suffix conventions:

* Nie gate family: `[controls | dirty A | target T]`;
* Vandaele Lemma-1 interface: `[controls | target T | dirty A]`.

A single swap of the final two physical wire names reconciles the layouts.  The
scheduled circuit itself is otherwise unchanged, and injective wire relabeling
preserves both gate count and certified depth exactly.
-/

namespace QuantumBlockEncoding
namespace NieZiSunToVandaeleLemma1

open NieZiSunDirtyScheduledFamily
open NieZiSunDirtyScheduledResources
open NieZiSunFigure3FlatCoordinates
open NieZiSunFigure3Protocol
open ScheduledWireEmbedding
open VandaeleLemma1ProgramFamily

/-- Swap old Nie `A,T` into Vandaele `T,dirty`. -/
def suffixSwap (k : Nat) : Equiv.Perm (Fin (k + 2)) :=
  Equiv.swap
    (⟨k, by omega⟩ : Fin (k + 2))
    (⟨k+1, by omega⟩ : Fin (k + 2))

/-- Vandaele control register extracted from the flat target layout. -/
def vandaeleControls (k : Nat)
    (state : PrimitiveBasis (lemmaOneFlatWidth k)) : PrimitiveBasis k :=
  fun wire => state (controlWire k wire)

/-- Reading a Vandaele-layout state through the suffix swap gives exactly the
Nie `(controls,dirty,target)` coordinate. -/
theorem swapped_input_coordinate
    (k : Nat) (state : PrimitiveBasis (lemmaOneFlatWidth k)) :
    flatProductCoordinate k
      (ReversibleWireEmbedding.readEmbeddedState (suffixSwap k) state) =
      (vandaeleControls k state,
        state (dirtyWire k), state (targetWire k)) := by
  apply Prod.ext
  · funext wire
    simp [flatProductCoordinate, ReversibleWireEmbedding.readEmbeddedState,
      suffixSwap, vandaeleControls, controlWire, lemmaOneFlatWidth,
      Equiv.swap_apply_def]
  · apply Prod.ext
    · simp [flatProductCoordinate, ReversibleWireEmbedding.readEmbeddedState,
        suffixSwap, dirtyWire, lemmaOneFlatWidth, Equiv.swap_apply_def]
    · simp [flatProductCoordinate, ReversibleWireEmbedding.readEmbeddedState,
        suffixSwap, targetWire, lemmaOneFlatWidth, Equiv.swap_apply_def]

/-- Source all-controls predicate agrees under the layout swap. -/
theorem allFlatControlsOne_iff
    (k : Nat) (state : PrimitiveBasis (lemmaOneFlatWidth k)) :
    allFlatControlsOne k state ↔ allOne (vandaeleControls k state) := by
  rfl

/-- Proof-bearing relabeled dirty schedule. -/
def scheduled (k : Nat) :
    ScheduledReversibleProgram (lemmaOneFlatWidth k) :=
  mapScheduledWires (suffixSwap k) (suffixSwap k).injective
    (dirtyScheduled k)

/-- Readback semantics of the relabeled schedule. -/
theorem scheduled_readback
    (k : Nat) (state : PrimitiveBasis (lemmaOneFlatWidth k)) :
    ReversibleWireEmbedding.readEmbeddedState (suffixSwap k)
      (evalReversibleProgram (scheduled k).program state) =
      evalReversibleProgram (dirtyScheduled k).program
        (ReversibleWireEmbedding.readEmbeddedState (suffixSwap k) state) := by
  exact readEmbeddedState_eval_mapScheduledWires
    (suffixSwap k) (suffixSwap k).injective (dirtyScheduled k) state

/-- Complete flat Vandaele Lemma-1 correctness after the suffix relabel. -/
theorem scheduled_correctness (k : Nat) :
    LemmaOneFlatSpec k (evalReversibleProgram (scheduled k).program) := by
  intro state
  let sourceInput := ReversibleWireEmbedding.readEmbeddedState (suffixSwap k) state
  have inputCoord := swapped_input_coordinate k state
  have inputEq : sourceInput =
      (flatProductCoordinate k).symm
        (vandaeleControls k state,
          state (dirtyWire k), state (targetWire k)) := by
    apply (flatProductCoordinate k).injective
    rw [Equiv.apply_symm_apply]
    exact inputCoord
  have source := dirtyScheduled_action k
    (vandaeleControls k state)
    (state (dirtyWire k)) (state (targetWire k))
  rw [← inputEq] at source
  let output := evalReversibleProgram (scheduled k).program state
  have readback := scheduled_readback k state
  have outputCoord :
      flatProductCoordinate k
        (ReversibleWireEmbedding.readEmbeddedState (suffixSwap k) output) =
      if allOne (vandaeleControls k state) then
        (vandaeleControls k state,
          state (dirtyWire k), flipBit (state (targetWire k)))
      else
        (vandaeleControls k state,
          state (dirtyWire k), state (targetWire k)) := by
    rw [readback]
    exact source
  have relabeledCoord := swapped_input_coordinate k output
  rw [relabeledCoord] at outputCoord
  constructor
  · intro wire
    have controlsEq := congrArg Prod.fst outputCoord
    by_cases active : allOne (vandaeleControls k state)
    · simp [active] at controlsEq
      exact congrFun controlsEq wire
    · simp [active] at controlsEq
      exact congrFun controlsEq wire
  · constructor
    · have targetEq := congrArg (fun tuple => tuple.2.2) outputCoord
      rw [← allFlatControlsOne_iff k state]
      by_cases active : allFlatControlsOne k state <;>
        simp [active] at targetEq ⊢ <;> exact targetEq
    · have dirtyEq := congrArg (fun tuple => tuple.2.1) outputCoord
      by_cases active : allOne (vandaeleControls k state) <;>
        simp [active] at dirtyEq <;> exact dirtyEq

/-- Relabeling preserves exact gate count. -/
@[simp] theorem scheduled_gateCount (k : Nat) :
    (scheduled k).gateCount = (dirtyScheduled k).gateCount := by
  simp [scheduled]

/-- Relabeling preserves certified depth. -/
@[simp] theorem scheduled_depth (k : Nat) :
    (scheduled k).depth = (dirtyScheduled k).depth := by
  simp [scheduled]

/-- Final reproduced Vandaele Lemma-1 family. -/
def family : LemmaOneScheduledFamily where
  scheduled := scheduled
  correctness := scheduled_correctness
  resources := by
    simpa [scheduled] using vandaele_resource_target

end NieZiSunToVandaeleLemma1
end QuantumBlockEncoding

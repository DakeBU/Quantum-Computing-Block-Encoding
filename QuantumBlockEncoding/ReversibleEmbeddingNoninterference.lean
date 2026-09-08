import QuantumBlockEncoding.ReversibleEmbeddingDisjointness
import Mathlib.Tactic

/-!
# Semantic noninterference of disjoint wire embeddings

`ReversibleEmbeddingDisjointness` supplies the scheduler-facing fact that two
mapped child circuits have disjoint gate supports.  Recursive semantic proofs
also need the dual state-view statement: running a program embedded in the left
image cannot change the state read through a disjoint right image.

This module proves that fact once at the generic reversible-program level and
then packages the scheduled-program specialization used by the Nie recursion.
-/

namespace QuantumBlockEncoding
namespace ReversibleEmbeddingNoninterference

open ReversibleWireEmbedding
open ScheduledWireEmbedding
open ReversibleEmbeddingDisjointness

/-- A program mapped through `leftEmbed` leaves the complete logical state read
through a disjoint `rightEmbed` unchanged. -/
theorem readEmbeddedState_eval_mapProgramWires_other
    {leftSize rightSize large : Nat}
    (leftEmbed : Fin leftSize → Fin large)
    (leftInjective : Function.Injective leftEmbed)
    (rightEmbed : Fin rightSize → Fin large)
    (images : ImagesDisjoint leftEmbed rightEmbed)
    (program : ReversibleProgram leftSize)
    (state : PrimitiveBasis large) :
    readEmbeddedState rightEmbed
        (evalReversibleProgram
          (mapProgramWires leftEmbed leftInjective program) state) =
      readEmbeddedState rightEmbed state := by
  funext rightWire
  exact eval_mapProgramWires_outside
    leftEmbed leftInjective program state (rightEmbed rightWire)
    (fun leftWire => images leftWire rightWire)

/-- Scheduled-program form of cross-view noninterference. -/
theorem readEmbeddedState_eval_mapScheduledWires_other
    {leftSize rightSize large : Nat}
    (leftEmbed : Fin leftSize → Fin large)
    (leftInjective : Function.Injective leftEmbed)
    (rightEmbed : Fin rightSize → Fin large)
    (images : ImagesDisjoint leftEmbed rightEmbed)
    (scheduled : ScheduledReversibleProgram leftSize)
    (state : PrimitiveBasis large) :
    readEmbeddedState rightEmbed
        (evalReversibleProgram
          (mapScheduledWires leftEmbed leftInjective scheduled).program state) =
      readEmbeddedState rightEmbed state := by
  rw [mapScheduledWires_program]
  exact readEmbeddedState_eval_mapProgramWires_other
    leftEmbed leftInjective rightEmbed images scheduled.program state

/-- Symmetric scheduled specialization: a right child leaves the left logical
view untouched whenever the original images are disjoint. -/
theorem readEmbeddedState_eval_mapScheduledWires_other_symm
    {leftSize rightSize large : Nat}
    (leftEmbed : Fin leftSize → Fin large)
    (rightEmbed : Fin rightSize → Fin large)
    (rightInjective : Function.Injective rightEmbed)
    (images : ImagesDisjoint leftEmbed rightEmbed)
    (scheduled : ScheduledReversibleProgram rightSize)
    (state : PrimitiveBasis large) :
    readEmbeddedState leftEmbed
        (evalReversibleProgram
          (mapScheduledWires rightEmbed rightInjective scheduled).program state) =
      readEmbeddedState leftEmbed state := by
  exact readEmbeddedState_eval_mapScheduledWires_other
    rightEmbed rightInjective leftEmbed (imagesDisjoint_symm images)
    scheduled state

end ReversibleEmbeddingNoninterference
end QuantumBlockEncoding
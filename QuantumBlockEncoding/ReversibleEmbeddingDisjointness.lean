import QuantumBlockEncoding.ScheduledWireEmbedding
import Mathlib.Tactic

/-!
# Cross-disjointness from disjoint wire embeddings

Recursive reversible constructions repeatedly place already-certified child
circuits on two disjoint subregisters.  The scheduler should not require a new
wire-overlap proof for every pair of child gates.  It is enough to prove once
that the two injective wire embeddings have disjoint images.

This module lifts that image-level fact to gates, layers, and complete schedules.
Its conclusions are deliberately written in the raw quantified shape later used
by `ReversibleLayer.CrossWireDisjoint` and `ReversibleSchedule.CrossWireDisjoint`,
so the parallel scheduler can consume them without new wire arithmetic.
-/

namespace QuantumBlockEncoding
namespace ReversibleEmbeddingDisjointness

open ReversibleWireEmbedding
open ScheduledWireEmbedding

/-- Two logical wire embeddings occupy disjoint physical subregisters. -/
def ImagesDisjoint {leftSize rightSize large : Nat}
    (leftEmbed : Fin leftSize → Fin large)
    (rightEmbed : Fin rightSize → Fin large) : Prop :=
  ∀ leftWire rightWire, leftEmbed leftWire ≠ rightEmbed rightWire

/-- Image disjointness is symmetric. -/
theorem imagesDisjoint_symm
    {leftSize rightSize large : Nat}
    {leftEmbed : Fin leftSize → Fin large}
    {rightEmbed : Fin rightSize → Fin large}
    (disjoint : ImagesDisjoint leftEmbed rightEmbed) :
    ImagesDisjoint rightEmbed leftEmbed := by
  intro rightWire leftWire equal
  exact disjoint leftWire rightWire equal.symm

/-- Any gate mapped through the left embedding is wire-disjoint from any gate
mapped through the right embedding. -/
theorem mapGateWires_crossWireDisjoint
    {leftSize rightSize large : Nat}
    (leftEmbed : Fin leftSize → Fin large)
    (leftInjective : Function.Injective leftEmbed)
    (rightEmbed : Fin rightSize → Fin large)
    (rightInjective : Function.Injective rightEmbed)
    (images : ImagesDisjoint leftEmbed rightEmbed)
    (leftGate : ReversibleGate leftSize)
    (rightGate : ReversibleGate rightSize) :
    ReversibleGate.WireDisjoint
      (mapGateWires leftEmbed leftInjective leftGate)
      (mapGateWires rightEmbed rightInjective rightGate) := by
  intro wire overlap
  rcases (mapGateWires_touches_iff_exists
      leftEmbed leftInjective leftGate wire).1 overlap.1 with
    ⟨leftWire, _leftTouches, leftImage⟩
  rcases (mapGateWires_touches_iff_exists
      rightEmbed rightInjective rightGate wire).1 overlap.2 with
    ⟨rightWire, _rightTouches, rightImage⟩
  exact images leftWire rightWire
    (leftImage.trans rightImage.symm)

/-- Every gate pair from two mapped layers is cross-wire-disjoint. -/
theorem mapLayerWires_crossWireDisjoint
    {leftSize rightSize large : Nat}
    (leftEmbed : Fin leftSize → Fin large)
    (leftInjective : Function.Injective leftEmbed)
    (rightEmbed : Fin rightSize → Fin large)
    (rightInjective : Function.Injective rightEmbed)
    (images : ImagesDisjoint leftEmbed rightEmbed)
    (leftLayer : ReversibleLayer leftSize)
    (rightLayer : ReversibleLayer rightSize) :
    ∀ leftGate ∈ mapLayerWires leftEmbed leftInjective leftLayer,
      ∀ rightGate ∈ mapLayerWires rightEmbed rightInjective rightLayer,
        ReversibleGate.WireDisjoint leftGate rightGate := by
  intro leftGate leftMember rightGate rightMember
  simp only [mapLayerWires, List.mem_map] at leftMember rightMember
  rcases leftMember with ⟨leftSource, _leftSourceMember, rfl⟩
  rcases rightMember with ⟨rightSource, _rightSourceMember, rfl⟩
  exact mapGateWires_crossWireDisjoint
    leftEmbed leftInjective rightEmbed rightInjective images
    leftSource rightSource

/-- Every layer pair from two mapped schedules is cross-wire-disjoint.  This is
exactly the schedule-level certificate required to put the two child schedules
in the same time slices. -/
theorem mapScheduleWires_crossWireDisjoint
    {leftSize rightSize large : Nat}
    (leftEmbed : Fin leftSize → Fin large)
    (leftInjective : Function.Injective leftEmbed)
    (rightEmbed : Fin rightSize → Fin large)
    (rightInjective : Function.Injective rightEmbed)
    (images : ImagesDisjoint leftEmbed rightEmbed)
    (leftSchedule : ReversibleSchedule leftSize)
    (rightSchedule : ReversibleSchedule rightSize) :
    ∀ leftLayer ∈ mapScheduleWires leftEmbed leftInjective leftSchedule,
      ∀ rightLayer ∈ mapScheduleWires rightEmbed rightInjective rightSchedule,
        ∀ leftGate ∈ leftLayer,
          ∀ rightGate ∈ rightLayer,
            ReversibleGate.WireDisjoint leftGate rightGate := by
  intro leftLayer leftMember rightLayer rightMember
  simp only [mapScheduleWires, List.mem_map] at leftMember rightMember
  rcases leftMember with ⟨leftSource, _leftSourceMember, rfl⟩
  rcases rightMember with ⟨rightSource, _rightSourceMember, rfl⟩
  exact mapLayerWires_crossWireDisjoint
    leftEmbed leftInjective rightEmbed rightInjective images
    leftSource rightSource

/-- Scheduled-child specialization.  Its conclusion is deliberately free of the
parallel-scheduler module, keeping this certificate reusable and independently
compilable. -/
theorem mapScheduledWires_crossWireDisjoint
    {leftSize rightSize large : Nat}
    (leftEmbed : Fin leftSize → Fin large)
    (leftInjective : Function.Injective leftEmbed)
    (rightEmbed : Fin rightSize → Fin large)
    (rightInjective : Function.Injective rightEmbed)
    (images : ImagesDisjoint leftEmbed rightEmbed)
    (left : ScheduledReversibleProgram leftSize)
    (right : ScheduledReversibleProgram rightSize) :
    ∀ leftLayer ∈
        (mapScheduledWires leftEmbed leftInjective left).layers,
      ∀ rightLayer ∈
        (mapScheduledWires rightEmbed rightInjective right).layers,
        ∀ leftGate ∈ leftLayer,
          ∀ rightGate ∈ rightLayer,
            ReversibleGate.WireDisjoint leftGate rightGate := by
  exact mapScheduleWires_crossWireDisjoint
    leftEmbed leftInjective rightEmbed rightInjective images
    left.layers right.layers

end ReversibleEmbeddingDisjointness
end QuantumBlockEncoding

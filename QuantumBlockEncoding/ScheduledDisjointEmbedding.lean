import QuantumBlockEncoding.ReversibleDisjointEmbedding
import QuantumBlockEncoding.ReversibleParallelSchedule
import QuantumBlockEncoding.ScheduledWireEmbedding

/-!
# Cross-disjointness of schedules embedded on disjoint registers

This bridges physical register geometry to the generic parallel-schedule merge.
If two injective wire embeddings have disjoint images, every gate of every
mapped left layer is wire-disjoint from every gate of every mapped right layer.
-/

namespace QuantumBlockEncoding
namespace ScheduledDisjointEmbedding

open ReversibleDisjointEmbedding
open ReversibleParallelSchedule
open ScheduledWireEmbedding

/-- One gate mapped into the left image is disjoint from one gate mapped into
the right image. -/
theorem mapped_gates_cross_disjoint
    {left right total : Nat}
    (leftEmbed : Fin left -> Fin total)
    (leftInjective : Function.Injective leftEmbed)
    (rightEmbed : Fin right -> Fin total)
    (rightInjective : Function.Injective rightEmbed)
    (disjoint : DisjointImages leftEmbed rightEmbed)
    (leftGate : ReversibleGate left)
    (rightGate : ReversibleGate right) :
    ReversibleGate.WireDisjoint
      (ReversibleWireEmbedding.mapGateWires leftEmbed leftInjective leftGate)
      (ReversibleWireEmbedding.mapGateWires rightEmbed rightInjective rightGate) := by
  intro wire overlap
  rcases (mapGateWires_touches_iff_exists
    leftEmbed leftInjective leftGate wire).1 overlap.1 with
      ⟨leftWire,leftTouched,leftImage⟩
  rcases (mapGateWires_touches_iff_exists
    rightEmbed rightInjective rightGate wire).1 overlap.2 with
      ⟨rightWire,rightTouched,rightImage⟩
  exact disjoint leftWire rightWire (leftImage.trans rightImage.symm)

/-- Complete mapped schedules are cross-disjoint. -/
theorem mapped_schedules_disjoint
    {left right total : Nat}
    (leftEmbed : Fin left -> Fin total)
    (leftInjective : Function.Injective leftEmbed)
    (rightEmbed : Fin right -> Fin total)
    (rightInjective : Function.Injective rightEmbed)
    (disjoint : DisjointImages leftEmbed rightEmbed)
    (leftScheduled : ScheduledReversibleProgram left)
    (rightScheduled : ScheduledReversibleProgram right) :
    SchedulesWireDisjoint
      (mapScheduledWires leftEmbed leftInjective leftScheduled).layers
      (mapScheduledWires rightEmbed rightInjective rightScheduled).layers := by
  intro leftLayer leftLayerMember rightLayer rightLayerMember
  simp [mapScheduledWires, mapScheduleWires] at leftLayerMember rightLayerMember
  rcases leftLayerMember with ⟨leftSource,leftSourceMember,rfl⟩
  rcases rightLayerMember with ⟨rightSource,rightSourceMember,rfl⟩
  intro leftGate leftGateMember rightGate rightGateMember
  simp [mapLayerWires] at leftGateMember rightGateMember
  rcases leftGateMember with ⟨leftSourceGate,leftGateMember,rfl⟩
  rcases rightGateMember with ⟨rightSourceGate,rightGateMember,rfl⟩
  exact mapped_gates_cross_disjoint
    leftEmbed leftInjective rightEmbed rightInjective disjoint
    leftSourceGate rightSourceGate

end ScheduledDisjointEmbedding
end QuantumBlockEncoding

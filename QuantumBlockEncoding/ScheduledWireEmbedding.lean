import QuantumBlockEncoding.ReversibleSchedule
import QuantumBlockEncoding.ReversibleWireEmbedding
import Mathlib.Tactic

/-!
# Embed a proof-bearing reversible schedule into a larger register

`ReversibleWireEmbedding` transports the semantic gate list.  Source resource
theorems also require the certified parallel schedule to move with that same
program.  This module proves that injective wire renaming preserves layer
wire-disjointness exactly.

Consequently a `ScheduledReversibleProgram` may be placed on any injectively
selected subregister while preserving both gate count and certified depth.
-/

namespace QuantumBlockEncoding
namespace ScheduledWireEmbedding

open ReversibleWireEmbedding

/-- Support characterization for a renamed gate. -/
theorem mapGateWires_touches_iff_exists
    {small large : Nat}
    (embed : Fin small → Fin large)
    (injective : Function.Injective embed)
    (gate : ReversibleGate small)
    (wire : Fin large) :
    (mapGateWires embed injective gate).touches wire ↔
      ∃ logical, gate.touches logical ∧ embed logical = wire := by
  cases gate with
  | x target =>
      change
        wire = embed target ↔
          ∃ logical, logical = target ∧ embed logical = wire
      constructor
      · intro hit
        exact ⟨target, rfl, hit.symm⟩
      · rintro ⟨logical, same, image⟩
        subst logical
        exact image.symm
  | cx control target distinct =>
      change
        (wire = embed control ∨ wire = embed target) ↔
          ∃ logical,
            (logical = control ∨ logical = target) ∧
              embed logical = wire
      constructor
      · intro hit
        rcases hit with hit | hit
        · exact ⟨control, Or.inl rfl, hit.symm⟩
        · exact ⟨target, Or.inr rfl, hit.symm⟩
      · rintro ⟨logical, touched, image⟩
        rcases touched with same | same
        · subst logical
          exact Or.inl image.symm
        · subst logical
          exact Or.inr image.symm
  | ccx control0 control1 target c0_ne_c1 c0_ne_target c1_ne_target =>
      change
        (wire = embed control0 ∨
          wire = embed control1 ∨
          wire = embed target) ↔
          ∃ logical,
            (logical = control0 ∨
              logical = control1 ∨
              logical = target) ∧
              embed logical = wire
      constructor
      · intro hit
        rcases hit with hit | hit | hit
        · exact ⟨control0, Or.inl rfl, hit.symm⟩
        · exact ⟨control1, Or.inr (Or.inl rfl), hit.symm⟩
        · exact ⟨target, Or.inr (Or.inr rfl), hit.symm⟩
      · rintro ⟨logical, touched, image⟩
        rcases touched with same | same | same
        · subst logical
          exact Or.inl image.symm
        · subst logical
          exact Or.inr (Or.inl image.symm)
        · subst logical
          exact Or.inr (Or.inr image.symm)

/-- Injective wire renaming preserves pairwise wire-disjointness. -/
theorem mapGateWires_wireDisjoint
    {small large : Nat}
    (embed : Fin small → Fin large)
    (injective : Function.Injective embed)
    {left right : ReversibleGate small}
    (disjoint : ReversibleGate.WireDisjoint left right) :
    ReversibleGate.WireDisjoint
      (mapGateWires embed injective left)
      (mapGateWires embed injective right) := by
  intro wire overlap
  rcases (mapGateWires_touches_iff_exists
    embed injective left wire).1 overlap.1 with
    ⟨leftWire, leftTouches, leftImage⟩
  rcases (mapGateWires_touches_iff_exists
    embed injective right wire).1 overlap.2 with
    ⟨rightWire, rightTouches, rightImage⟩
  have same : leftWire = rightWire := by
    apply injective
    exact leftImage.trans rightImage.symm
  subst rightWire
  exact disjoint leftWire ⟨leftTouches, rightTouches⟩

/-- Rename every gate in one parallel layer. -/
def mapLayerWires {small large : Nat}
    (embed : Fin small → Fin large)
    (injective : Function.Injective embed)
    (layer : ReversibleLayer small) : ReversibleLayer large :=
  layer.map (mapGateWires embed injective)

/-- A valid layer remains valid after injective wire renaming. -/
theorem mapLayerWires_valid
    {small large : Nat}
    (embed : Fin small → Fin large)
    (injective : Function.Injective embed)
    {layer : ReversibleLayer small}
    (valid : ReversibleLayer.Valid layer) :
    ReversibleLayer.Valid (mapLayerWires embed injective layer) := by
  unfold ReversibleLayer.Valid mapLayerWires
  exact valid.map _ (fun _ _ relation =>
    mapGateWires_wireDisjoint embed injective relation)

/-- Rename every layer in one schedule. -/
def mapScheduleWires {small large : Nat}
    (embed : Fin small → Fin large)
    (injective : Function.Injective embed)
    (schedule : ReversibleSchedule small) : ReversibleSchedule large :=
  schedule.map (mapLayerWires embed injective)

/-- Schedule validity is invariant under injective renaming. -/
theorem mapScheduleWires_valid
    {small large : Nat}
    (embed : Fin small → Fin large)
    (injective : Function.Injective embed)
    {schedule : ReversibleSchedule small}
    (valid : schedule.Valid) :
    (mapScheduleWires embed injective schedule).Valid := by
  intro layer member
  simp only [mapScheduleWires, List.mem_map] at member
  rcases member with ⟨sourceLayer, sourceMember, rfl⟩
  exact mapLayerWires_valid embed injective
    (valid sourceLayer sourceMember)

/-- Schedule flattening commutes with wire renaming. -/
theorem mapScheduleWires_program
    {small large : Nat}
    (embed : Fin small → Fin large)
    (injective : Function.Injective embed)
    (schedule : ReversibleSchedule small) :
    (mapScheduleWires embed injective schedule).program =
      mapProgramWires embed injective schedule.program := by
  induction schedule with
  | nil =>
      rfl
  | cons layer rest induction =>
      change
        mapLayerWires embed injective layer ++
            (mapScheduleWires embed injective rest).program =
          mapProgramWires embed injective (layer ++ rest.program)
      rw [induction, mapProgramWires_append]
      rfl

/-- Proof-bearing scheduled-program embedding. -/
def mapScheduledWires
    {small large : Nat}
    (embed : Fin small → Fin large)
    (injective : Function.Injective embed)
    (scheduled : ScheduledReversibleProgram small) :
    ScheduledReversibleProgram large where
  layers := mapScheduleWires embed injective scheduled.layers
  valid := mapScheduleWires_valid embed injective scheduled.valid

@[simp] theorem mapScheduledWires_program
    {small large : Nat}
    (embed : Fin small → Fin large)
    (injective : Function.Injective embed)
    (scheduled : ScheduledReversibleProgram small) :
    (mapScheduledWires embed injective scheduled).program =
      mapProgramWires embed injective scheduled.program := by
  exact mapScheduleWires_program embed injective scheduled.layers

/-- Exact gate count is preserved. -/
@[simp] theorem mapScheduledWires_gateCount
    {small large : Nat}
    (embed : Fin small → Fin large)
    (injective : Function.Injective embed)
    (scheduled : ScheduledReversibleProgram small) :
    (mapScheduledWires embed injective scheduled).gateCount =
      scheduled.gateCount := by
  change
    (mapScheduleWires embed injective scheduled.layers).program.length =
      scheduled.layers.program.length
  rw [mapScheduleWires_program]
  exact mapProgramWires_length embed injective scheduled.program

/-- Certified parallel depth is preserved exactly. -/
@[simp] theorem mapScheduledWires_depth
    {small large : Nat}
    (embed : Fin small → Fin large)
    (injective : Function.Injective embed)
    (scheduled : ScheduledReversibleProgram small) :
    (mapScheduledWires embed injective scheduled).depth =
      scheduled.depth := by
  change
    (mapScheduleWires embed injective scheduled.layers).length =
      scheduled.layers.length
  simp [mapScheduleWires]

/-- Embedded-wire semantics of the scheduled program. -/
theorem readEmbeddedState_eval_mapScheduledWires
    {small large : Nat}
    (embed : Fin small → Fin large)
    (injective : Function.Injective embed)
    (scheduled : ScheduledReversibleProgram small)
    (state : PrimitiveBasis large) :
    readEmbeddedState embed
        (evalReversibleProgram
          (mapScheduledWires embed injective scheduled).program state) =
      evalReversibleProgram scheduled.program
        (readEmbeddedState embed state) := by
  rw [mapScheduledWires_program]
  exact readEmbeddedState_eval_mapProgramWires
    embed injective scheduled.program state

end ScheduledWireEmbedding
end QuantumBlockEncoding

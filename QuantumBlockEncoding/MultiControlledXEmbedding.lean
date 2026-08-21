import QuantumBlockEncoding.MultiControlledXSchedule
import Mathlib.Tactic

/-!
# Injective wire embedding for arbitrary-MCX source schedules

Remaud--Vandaele Algorithm 2 recursively runs an MCX ladder on an irregular
selected subregister `X'`.  The lower-level reversible IR already has a general
wire-embedding theorem; the MCX source IR needs the same proof-bearing operation
without first synthesizing MCX gates.

Given an injective physical map `Fin small -> Fin large`, this module maps each
control set and target, proves exact basis semantics on the embedded wires,
proves noninterference outside the image, preserves layer disjointness, and
preserves gate count/depth exactly.
-/

namespace QuantumBlockEncoding
namespace MultiControlledXEmbedding

open MultiControlledXSchedule

/-- Read a large basis through one logical-wire embedding. -/
def readEmbedded {small large : Nat}
    (embed : Fin small → Fin large)
    (state : PrimitiveBasis large) : PrimitiveBasis small :=
  fun wire => state (embed wire)

/-- Map one finite control set through an injective physical embedding. -/
def mapControls {small large : Nat}
    (embed : Fin small → Fin large)
    (controls : Finset (Fin small)) : Finset (Fin large) :=
  controls.image embed

@[simp] theorem mem_mapControls_iff
    {small large : Nat}
    (embed : Fin small → Fin large)
    (controls : Finset (Fin small))
    (wire : Fin large) :
    wire ∈ mapControls embed controls ↔
      ∃ logical ∈ controls, embed logical = wire := by
  simp [mapControls]

/-- Map one MCX gate along the physical embedding. -/
def mapGate {small large : Nat}
    (embed : Fin small → Fin large)
    (injective : Function.Injective embed)
    (gate : MCXGate small) : MCXGate large where
  controls := mapControls embed gate.controls
  target := embed gate.target
  target_not_control := by
    intro member
    rcases (mem_mapControls_iff embed gate.controls (embed gate.target)).1 member with
      ⟨logical,logicalMember,equal⟩
    exact gate.target_not_control
      (by simpa [injective equal] using logicalMember)

/-- Source activation predicate is invariant under embedding. -/
theorem active_mapGate_iff
    {small large : Nat}
    (embed : Fin small → Fin large)
    (injective : Function.Injective embed)
    (gate : MCXGate small)
    (state : PrimitiveBasis large) :
    active (mapGate embed injective gate) state ↔
      active gate (readEmbedded embed state) := by
  constructor
  · intro mapped control member
    exact mapped (embed control)
      ((mem_mapControls_iff embed gate.controls (embed control)).2
        ⟨control,member,rfl⟩)
  · intro source physical member
    rcases (mem_mapControls_iff embed gate.controls physical).1 member with
      ⟨logical,logicalMember,rfl⟩
    exact source logical logicalMember

/-- One mapped MCX has the exact logical action on embedded wires. -/
theorem readEmbedded_gateAction
    {small large : Nat}
    (embed : Fin small → Fin large)
    (injective : Function.Injective embed)
    (gate : MCXGate small)
    (state : PrimitiveBasis large) :
    readEmbedded embed (gateAction (mapGate embed injective gate) state) =
      gateAction gate (readEmbedded embed state) := by
  funext wire
  rw [show
    active (mapGate embed injective gate) state ↔
      active gate (readEmbedded embed state) from
        active_mapGate_iff embed injective gate state]
  by_cases source : active gate (readEmbedded embed state)
  · have mapped : active (mapGate embed injective gate) state :=
      (active_mapGate_iff embed injective gate state).2 source
    by_cases target : wire = gate.target
    · subst wire
      simp [gateAction, mapped, source, readEmbedded, mapGate, xBasisAction]
    · have targetMapped : embed wire ≠ embed gate.target := by
        intro equal
        exact target (injective equal)
      simp [gateAction, mapped, source, readEmbedded, mapGate,
        xBasisAction, target, targetMapped]
  · have mapped : ¬ active (mapGate embed injective gate) state := by
      intro h
      exact source ((active_mapGate_iff embed injective gate state).1 h)
    simp [gateAction, mapped, source, readEmbedded]

/-- Mapped MCX leaves every physical wire outside the embedding image unchanged. -/
theorem gateAction_outside
    {small large : Nat}
    (embed : Fin small → Fin large)
    (injective : Function.Injective embed)
    (gate : MCXGate small)
    (state : PrimitiveBasis large)
    (wire : Fin large)
    (outside : ∀ logical, embed logical ≠ wire) :
    gateAction (mapGate embed injective gate) state wire = state wire := by
  by_cases mapped : active (mapGate embed injective gate) state
  · have targetNe : wire ≠ embed gate.target := (outside gate.target).symm
    simp [gateAction, mapped, mapGate, xBasisAction, targetNe]
  · simp [gateAction, mapped]

/-- Program wire map. -/
def mapProgram {small large : Nat}
    (embed : Fin small → Fin large)
    (injective : Function.Injective embed)
    (program : MCXProgram small) : MCXProgram large :=
  program.map (mapGate embed injective)

/-- Embedded program semantics. -/
theorem readEmbedded_evalProgram
    {small large : Nat}
    (embed : Fin small → Fin large)
    (injective : Function.Injective embed)
    (program : MCXProgram small)
    (state : PrimitiveBasis large) :
    readEmbedded embed (evalProgram (mapProgram embed injective program) state) =
      evalProgram program (readEmbedded embed state) := by
  induction program generalizing state with
  | nil => rfl
  | cons gate rest induction =>
      change
        readEmbedded embed
          (evalProgram (mapProgram embed injective rest)
            (gateAction (mapGate embed injective gate) state)) =
          evalProgram rest (gateAction gate (readEmbedded embed state))
      calc
        _ = evalProgram rest
              (readEmbedded embed
                (gateAction (mapGate embed injective gate) state)) :=
          induction (gateAction (mapGate embed injective gate) state)
        _ = evalProgram rest (gateAction gate (readEmbedded embed state)) := by
          rw [readEmbedded_gateAction]

/-- Embedded programs preserve wires outside the image. -/
theorem evalProgram_outside
    {small large : Nat}
    (embed : Fin small → Fin large)
    (injective : Function.Injective embed)
    (program : MCXProgram small)
    (state : PrimitiveBasis large)
    (wire : Fin large)
    (outside : ∀ logical, embed logical ≠ wire) :
    evalProgram (mapProgram embed injective program) state wire = state wire := by
  induction program generalizing state with
  | nil => rfl
  | cons gate rest induction =>
      change
        evalProgram (mapProgram embed injective rest)
          (gateAction (mapGate embed injective gate) state) wire = state wire
      calc
        _ = gateAction (mapGate embed injective gate) state wire :=
          induction (gateAction (mapGate embed injective gate) state)
        _ = state wire := gateAction_outside embed injective gate state wire outside

/-- Support characterization after mapping. -/
theorem mapGate_touches_iff
    {small large : Nat}
    (embed : Fin small → Fin large)
    (injective : Function.Injective embed)
    (gate : MCXGate small) (wire : Fin large) :
    touches (mapGate embed injective gate) wire ↔
      ∃ logical, touches gate logical ∧ embed logical = wire := by
  constructor
  · intro touched
    rcases touched with target | control
    · exact ⟨gate.target, Or.inl rfl, target.symm⟩
    · rcases (mem_mapControls_iff embed gate.controls wire).1 control with
        ⟨logical,member,equal⟩
      exact ⟨logical,Or.inr member,equal⟩
  · rintro ⟨logical,touched,rfl⟩
    rcases touched with rfl | member
    · exact Or.inl rfl
    · exact Or.inr ((mem_mapControls_iff embed gate.controls (embed logical)).2
        ⟨logical,member,rfl⟩)

/-- Wire-disjointness is preserved by injective mapping. -/
theorem mapGate_wireDisjoint
    {small large : Nat}
    (embed : Fin small → Fin large)
    (injective : Function.Injective embed)
    {left right : MCXGate small}
    (disjoint : WireDisjoint left right) :
    WireDisjoint (mapGate embed injective left) (mapGate embed injective right) := by
  intro wire overlap
  rcases (mapGate_touches_iff embed injective left wire).1 overlap.1 with
    ⟨leftWire,leftTouches,leftEq⟩
  rcases (mapGate_touches_iff embed injective right wire).1 overlap.2 with
    ⟨rightWire,rightTouches,rightEq⟩
  have same : leftWire = rightWire := by
    apply injective
    exact leftEq.trans rightEq.symm
  subst rightWire
  exact disjoint leftWire ⟨leftTouches,rightTouches⟩

/-- Layer/schedule mappings. -/
def mapLayer {small large : Nat}
    (embed : Fin small → Fin large)
    (injective : Function.Injective embed)
    (layer : MCXLayer small) : MCXLayer large :=
  layer.map (mapGate embed injective)

def mapSchedule {small large : Nat}
    (embed : Fin small → Fin large)
    (injective : Function.Injective embed)
    (schedule : MCXSchedule small) : MCXSchedule large :=
  schedule.map (mapLayer embed injective)

/-- Validity survives embedding. -/
theorem mapLayer_valid
    {small large : Nat}
    (embed : Fin small → Fin large)
    (injective : Function.Injective embed)
    {layer : MCXLayer small} (valid : LayerValid layer) :
    LayerValid (mapLayer embed injective layer) := by
  unfold LayerValid mapLayer
  exact valid.map _ (fun _ _ relation => mapGate_wireDisjoint embed injective relation)

theorem mapSchedule_valid
    {small large : Nat}
    (embed : Fin small → Fin large)
    (injective : Function.Injective embed)
    {schedule : MCXSchedule small} (valid : ScheduleValid schedule) :
    ScheduleValid (mapSchedule embed injective schedule) := by
  intro layer member
  simp [mapSchedule] at member
  rcases member with ⟨source,sourceMember,rfl⟩
  exact mapLayer_valid embed injective (valid source sourceMember)

/-- Proof-bearing scheduled MCX embedding. -/
def mapScheduled
    {small large : Nat}
    (embed : Fin small → Fin large)
    (injective : Function.Injective embed)
    (scheduled : ScheduledMCXProgram small) : ScheduledMCXProgram large where
  layers := mapSchedule embed injective scheduled.layers
  valid := mapSchedule_valid embed injective scheduled.valid

@[simp] theorem mapScheduled_program
    {small large : Nat}
    (embed : Fin small → Fin large)
    (injective : Function.Injective embed)
    (scheduled : ScheduledMCXProgram small) :
    (mapScheduled embed injective scheduled).program =
      mapProgram embed injective scheduled.program := by
  induction scheduled.layers with
  | nil => rfl
  | cons layer rest induction =>
      simp [mapScheduled, mapSchedule, mapLayer,
        ScheduledMCXProgram.program, scheduleProgram, induction]

@[simp] theorem mapScheduled_gateCount
    {small large : Nat}
    (embed : Fin small → Fin large)
    (injective : Function.Injective embed)
    (scheduled : ScheduledMCXProgram small) :
    (mapScheduled embed injective scheduled).gateCount = scheduled.gateCount := by
  unfold ScheduledMCXProgram.gateCount MultiControlledXSchedule.gateCount
  rw [mapScheduled_program]
  simp [mapProgram]

@[simp] theorem mapScheduled_depth
    {small large : Nat}
    (embed : Fin small → Fin large)
    (injective : Function.Injective embed)
    (scheduled : ScheduledMCXProgram small) :
    (mapScheduled embed injective scheduled).depth = scheduled.depth := by
  simp [mapScheduled, ScheduledMCXProgram.depth,
    MultiControlledXSchedule.depth, mapSchedule]

end MultiControlledXEmbedding
end QuantumBlockEncoding

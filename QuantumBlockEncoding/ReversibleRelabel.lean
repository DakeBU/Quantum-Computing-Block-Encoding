import QuantumBlockEncoding.ReversibleSchedule
import Mathlib.Tactic

/-!
# Injective wire relabeling for reversible programs and schedules

Source constructions are usually proved on a small logical register and then
embedded into a larger circuit.  This module provides one reusable operation for
that step.  Any injective wire map `Fin q → Fin Q` relabels X/CX/CCX gates,
programs, and proof-bearing schedules.

The key guarantees are exact:

* restricting the large-register output to the image reproduces the original
  small-register program;
* wires outside the image are unchanged;
* gate count and certified parallel depth are preserved by relabeling.

This is the generic infrastructure needed to place Gidney, ladder, fan-out, and
promise-gate subcircuits into the flat Lemma-7/Lemma-8 registers.
-/

namespace QuantumBlockEncoding
namespace ReversibleRelabel

/-- Read a large-register state through an injective logical wire map. -/
def restrictState {q Q : Nat}
    (wireMap : Fin q → Fin Q)
    (state : PrimitiveBasis Q) : PrimitiveBasis q :=
  fun wire => state (wireMap wire)

/-- Relabel every wire touched by one reversible gate. -/
def relabelGate {q Q : Nat}
    (wireMap : Fin q → Fin Q)
    (injective : Function.Injective wireMap) :
    ReversibleGate q → ReversibleGate Q
  | .x target => .x (wireMap target)
  | .cx control target distinct =>
      .cx (wireMap control) (wireMap target) (by
        intro equal
        exact distinct (injective equal))
  | .ccx control0 control1 target c0_ne_c1 c0_ne_target c1_ne_target =>
      .ccx (wireMap control0) (wireMap control1) (wireMap target)
        (by intro equal; exact c0_ne_c1 (injective equal))
        (by intro equal; exact c0_ne_target (injective equal))
        (by intro equal; exact c1_ne_target (injective equal))

/-- Relabel an entire reversible program. -/
def relabelProgram {q Q : Nat}
    (wireMap : Fin q → Fin Q)
    (injective : Function.Injective wireMap)
    (program : ReversibleProgram q) : ReversibleProgram Q :=
  program.map (relabelGate wireMap injective)

/-- One relabeled gate has exactly the original action when observed through the
wire map. -/
theorem restrictState_eval_relabelGate
    {q Q : Nat}
    (wireMap : Fin q → Fin Q)
    (injective : Function.Injective wireMap)
    (gate : ReversibleGate q) (state : PrimitiveBasis Q) :
    restrictState wireMap
        (evalReversibleGate (relabelGate wireMap injective gate) state) =
      evalReversibleGate gate (restrictState wireMap state) := by
  funext wire
  cases gate with
  | x target =>
      by_cases same : wire = target
      · subst wire
        simp [restrictState, relabelGate, evalReversibleGate,
          xBasisEquiv, xBasisAction]
      · have mappedNe : wireMap wire ≠ wireMap target := by
          intro equal
          exact same (injective equal)
        simp [restrictState, relabelGate, evalReversibleGate,
          xBasisEquiv, xBasisAction, same, mappedNe]
  | cx control target distinct =>
      by_cases inactive : state (wireMap control) = 0
      · have inactiveSmall : restrictState wireMap state control = 0 := by
          simpa [restrictState] using inactive
        simp [restrictState, relabelGate, evalReversibleGate,
          cxBasisEquiv, cxBasisAction, inactive, inactiveSmall]
      · have activeSmall : restrictState wireMap state control ≠ 0 := by
          simpa [restrictState] using inactive
        by_cases same : wire = target
        · subst wire
          simp [restrictState, relabelGate, evalReversibleGate,
            cxBasisEquiv, cxBasisAction, xBasisAction,
            inactive, activeSmall]
        · have mappedNe : wireMap wire ≠ wireMap target := by
            intro equal
            exact same (injective equal)
          simp [restrictState, relabelGate, evalReversibleGate,
            cxBasisEquiv, cxBasisAction, xBasisAction,
            inactive, activeSmall, same, mappedNe]
  | ccx control0 control1 target c0_ne_c1 c0_ne_target c1_ne_target =>
      by_cases active :
          state (wireMap control0) = 1 ∧ state (wireMap control1) = 1
      · have activeSmall :
            restrictState wireMap state control0 = 1 ∧
              restrictState wireMap state control1 = 1 := by
          simpa [restrictState] using active
        by_cases same : wire = target
        · subst wire
          simp [restrictState, relabelGate, evalReversibleGate,
            ccxBasisEquiv, ccxBasisAction, xBasisAction,
            active, activeSmall]
        · have mappedNe : wireMap wire ≠ wireMap target := by
            intro equal
            exact same (injective equal)
          simp [restrictState, relabelGate, evalReversibleGate,
            ccxBasisEquiv, ccxBasisAction, xBasisAction,
            active, activeSmall, same, mappedNe]
      · have inactiveSmall :
            ¬(restrictState wireMap state control0 = 1 ∧
              restrictState wireMap state control1 = 1) := by
          simpa [restrictState] using active
        simp [restrictState, relabelGate, evalReversibleGate,
          ccxBasisEquiv, ccxBasisAction, active, inactiveSmall]

/-- Relabeled program semantics commute with restriction to the logical
subregister. -/
theorem restrictState_eval_relabelProgram
    {q Q : Nat}
    (wireMap : Fin q → Fin Q)
    (injective : Function.Injective wireMap)
    (program : ReversibleProgram q) (state : PrimitiveBasis Q) :
    restrictState wireMap
        (evalReversibleProgram
          (relabelProgram wireMap injective program) state) =
      evalReversibleProgram program (restrictState wireMap state) := by
  induction program generalizing state with
  | nil => rfl
  | cons gate rest induction =>
      change
        restrictState wireMap
          (evalReversibleProgram
            (relabelProgram wireMap injective rest)
            (evalReversibleGate
              (relabelGate wireMap injective gate) state)) =
        evalReversibleProgram rest
          (evalReversibleGate gate (restrictState wireMap state))
      calc
        _ = evalReversibleProgram rest
              (restrictState wireMap
                (evalReversibleGate
                  (relabelGate wireMap injective gate) state)) :=
          induction
            (evalReversibleGate
              (relabelGate wireMap injective gate) state)
        _ = evalReversibleProgram rest
              (evalReversibleGate gate (restrictState wireMap state)) := by
          rw [restrictState_eval_relabelGate]

/-- A relabeled gate cannot modify a wire outside the image of the logical map. -/
theorem eval_relabelGate_outside
    {q Q : Nat}
    (wireMap : Fin q → Fin Q)
    (injective : Function.Injective wireMap)
    (gate : ReversibleGate q) (state : PrimitiveBasis Q)
    (wire : Fin Q)
    (outside : ∀ source : Fin q, wireMap source ≠ wire) :
    evalReversibleGate (relabelGate wireMap injective gate) state wire =
      state wire := by
  cases gate with
  | x target =>
      have wireNe : wire ≠ wireMap target := (outside target).symm
      simp [relabelGate, evalReversibleGate, xBasisEquiv,
        xBasisAction, wireNe]
  | cx control target distinct =>
      by_cases inactive : state (wireMap control) = 0
      · simp [relabelGate, evalReversibleGate, cxBasisEquiv,
          cxBasisAction, inactive]
      · have wireNe : wire ≠ wireMap target := (outside target).symm
        simp [relabelGate, evalReversibleGate, cxBasisEquiv,
          cxBasisAction, xBasisAction, inactive, wireNe]
  | ccx control0 control1 target c0_ne_c1 c0_ne_target c1_ne_target =>
      by_cases active :
          state (wireMap control0) = 1 ∧ state (wireMap control1) = 1
      · have wireNe : wire ≠ wireMap target := (outside target).symm
        simp [relabelGate, evalReversibleGate, ccxBasisEquiv,
          ccxBasisAction, xBasisAction, active, wireNe]
      · simp [relabelGate, evalReversibleGate, ccxBasisEquiv,
          ccxBasisAction, active]

/-- The complete embedded program fixes every wire outside the subregister. -/
theorem eval_relabelProgram_outside
    {q Q : Nat}
    (wireMap : Fin q → Fin Q)
    (injective : Function.Injective wireMap)
    (program : ReversibleProgram q) (state : PrimitiveBasis Q)
    (wire : Fin Q)
    (outside : ∀ source : Fin q, wireMap source ≠ wire) :
    evalReversibleProgram (relabelProgram wireMap injective program) state wire =
      state wire := by
  induction program generalizing state with
  | nil => rfl
  | cons gate rest induction =>
      change
        evalReversibleProgram
          (relabelProgram wireMap injective rest)
          (evalReversibleGate (relabelGate wireMap injective gate) state) wire =
        state wire
      calc
        _ = evalReversibleGate
              (relabelGate wireMap injective gate) state wire :=
          induction (evalReversibleGate
            (relabelGate wireMap injective gate) state)
        _ = state wire :=
          eval_relabelGate_outside
            wireMap injective gate state wire outside

/-- Relabeling does not change logical gate count. -/
@[simp] theorem relabelProgram_length
    {q Q : Nat}
    (wireMap : Fin q → Fin Q)
    (injective : Function.Injective wireMap)
    (program : ReversibleProgram q) :
    (relabelProgram wireMap injective program).length = program.length := by
  simp [relabelProgram]

/-- Any wire touched by a relabeled gate is the image of a wire touched by the
original gate. -/
theorem touches_relabelGate_exists
    {q Q : Nat}
    (wireMap : Fin q → Fin Q)
    (injective : Function.Injective wireMap)
    (gate : ReversibleGate q) (wire : Fin Q)
    (touched : (relabelGate wireMap injective gate).touches wire) :
    ∃ source : Fin q, gate.touches source ∧ wireMap source = wire := by
  cases gate with
  | x target =>
      refine ⟨target, ?_, ?_⟩
      · simp [ReversibleGate.touches]
      · simpa [relabelGate, ReversibleGate.touches] using touched.symm
  | cx control target distinct =>
      simp only [relabelGate, ReversibleGate.touches] at touched
      rcases touched with hit | hit
      · exact ⟨control, by simp [ReversibleGate.touches], hit.symm⟩
      · exact ⟨target, by simp [ReversibleGate.touches], hit.symm⟩
  | ccx control0 control1 target c0_ne_c1 c0_ne_target c1_ne_target =>
      simp only [relabelGate, ReversibleGate.touches] at touched
      rcases touched with hit | hit | hit
      · exact ⟨control0, by simp [ReversibleGate.touches], hit.symm⟩
      · exact ⟨control1, by simp [ReversibleGate.touches], hit.symm⟩
      · exact ⟨target, by simp [ReversibleGate.touches], hit.symm⟩

/-- Injective relabeling preserves within-layer wire disjointness. -/
theorem relabelGate_wireDisjoint
    {q Q : Nat}
    (wireMap : Fin q → Fin Q)
    (injective : Function.Injective wireMap)
    {left right : ReversibleGate q}
    (disjoint : ReversibleGate.WireDisjoint left right) :
    ReversibleGate.WireDisjoint
      (relabelGate wireMap injective left)
      (relabelGate wireMap injective right) := by
  intro wire overlap
  rcases touches_relabelGate_exists
      wireMap injective left wire overlap.1 with
    ⟨leftSource, leftTouches, leftMap⟩
  rcases touches_relabelGate_exists
      wireMap injective right wire overlap.2 with
    ⟨rightSource, rightTouches, rightMap⟩
  have sameSource : leftSource = rightSource := by
    apply injective
    exact leftMap.trans rightMap.symm
  subst rightSource
  exact disjoint leftSource ⟨leftTouches, rightTouches⟩

/-- Relabel a whole parallel layer. -/
def relabelLayer {q Q : Nat}
    (wireMap : Fin q → Fin Q)
    (injective : Function.Injective wireMap)
    (layer : ReversibleLayer q) : ReversibleLayer Q :=
  layer.map (relabelGate wireMap injective)

/-- Validity of one parallel layer survives injective relabeling. -/
theorem relabelLayer_valid
    {q Q : Nat}
    (wireMap : Fin q → Fin Q)
    (injective : Function.Injective wireMap)
    (layer : ReversibleLayer q)
    (valid : ReversibleLayer.Valid layer) :
    ReversibleLayer.Valid (relabelLayer wireMap injective layer) := by
  unfold ReversibleLayer.Valid relabelLayer
  exact valid.map
    (relabelGate wireMap injective)
    (fun _ _ h => relabelGate_wireDisjoint wireMap injective h)

/-- Relabel every layer of a schedule. -/
def relabelSchedule {q Q : Nat}
    (wireMap : Fin q → Fin Q)
    (injective : Function.Injective wireMap)
    (schedule : ReversibleSchedule q) : ReversibleSchedule Q :=
  schedule.map (relabelLayer wireMap injective)

/-- A valid schedule stays valid after injective embedding. -/
theorem relabelSchedule_valid
    {q Q : Nat}
    (wireMap : Fin q → Fin Q)
    (injective : Function.Injective wireMap)
    (schedule : ReversibleSchedule q)
    (valid : ReversibleSchedule.Valid schedule) :
    ReversibleSchedule.Valid (relabelSchedule wireMap injective schedule) := by
  intro layer member
  rw [List.mem_map] at member
  rcases member with ⟨source, sourceMember, rfl⟩
  exact relabelLayer_valid wireMap injective source
    (valid source sourceMember)

/-- Proof-bearing scheduled subregister embedding. -/
def relabelScheduled {q Q : Nat}
    (wireMap : Fin q → Fin Q)
    (injective : Function.Injective wireMap)
    (scheduled : ScheduledReversibleProgram q) :
    ScheduledReversibleProgram Q where
  layers := relabelSchedule wireMap injective scheduled.layers
  valid := relabelSchedule_valid
    wireMap injective scheduled.layers scheduled.valid

/-- Relabeling a schedule and then flattening agrees with relabeling the
flattened program. -/
theorem relabelSchedule_program
    {q Q : Nat}
    (wireMap : Fin q → Fin Q)
    (injective : Function.Injective wireMap)
    (schedule : ReversibleSchedule q) :
    ReversibleSchedule.program
        (relabelSchedule wireMap injective schedule) =
      relabelProgram wireMap injective
        (ReversibleSchedule.program schedule) := by
  induction schedule with
  | nil => rfl
  | cons layer rest induction =>
      simp [relabelSchedule, relabelLayer,
        ReversibleSchedule.program, relabelProgram, induction]

@[simp] theorem relabelScheduled_program
    {q Q : Nat}
    (wireMap : Fin q → Fin Q)
    (injective : Function.Injective wireMap)
    (scheduled : ScheduledReversibleProgram q) :
    (relabelScheduled wireMap injective scheduled).program =
      relabelProgram wireMap injective scheduled.program := by
  exact relabelSchedule_program wireMap injective scheduled.layers

/-- Gate count is unchanged by injective wire embedding. -/
@[simp] theorem relabelScheduled_gateCount
    {q Q : Nat}
    (wireMap : Fin q → Fin Q)
    (injective : Function.Injective wireMap)
    (scheduled : ScheduledReversibleProgram q) :
    (relabelScheduled wireMap injective scheduled).gateCount =
      scheduled.gateCount := by
  unfold ScheduledReversibleProgram.gateCount ReversibleSchedule.gateCount
  rw [relabelScheduled_program, relabelProgram_length]

/-- Certified parallel depth is unchanged by relabeling. -/
@[simp] theorem relabelScheduled_depth
    {q Q : Nat}
    (wireMap : Fin q → Fin Q)
    (injective : Function.Injective wireMap)
    (scheduled : ScheduledReversibleProgram q) :
    (relabelScheduled wireMap injective scheduled).depth =
      scheduled.depth := by
  simp [ScheduledReversibleProgram.depth, ReversibleSchedule.depth,
    relabelScheduled, relabelSchedule]

/-- Semantic commuting theorem for an embedded scheduled circuit. -/
theorem restrictState_eval_relabelScheduled
    {q Q : Nat}
    (wireMap : Fin q → Fin Q)
    (injective : Function.Injective wireMap)
    (scheduled : ScheduledReversibleProgram q)
    (state : PrimitiveBasis Q) :
    restrictState wireMap
        (evalReversibleProgram
          (relabelScheduled wireMap injective scheduled).program state) =
      evalReversibleProgram scheduled.program
        (restrictState wireMap state) := by
  rw [relabelScheduled_program]
  exact restrictState_eval_relabelProgram
    wireMap injective scheduled.program state

end ReversibleRelabel
end QuantumBlockEncoding

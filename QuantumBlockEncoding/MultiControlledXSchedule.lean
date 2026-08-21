import QuantumBlockEncoding.PrimitiveSemantics
import Mathlib.Data.Finset.Card
import Mathlib.Tactic

/-!
# Proof-bearing arbitrary multi-controlled-X schedule IR

Several upstream constructions cited by Vandaele are naturally stated at an
MCX level before they are synthesized into `{X,CX,CCX}`:

* Remaud--Vandaele Algorithm 2 uses depth-one layers of arbitrary MCX gates;
* Nie--Zi--Sun recursively construct large multi-Toffoli gates;
* Vandaele Appendix A.1 then replaces selected MCX gates by promise/Toffoli
  gadgets.

Representing those source circuits directly as `ReversibleGate` would silently
assume their synthesis.  This module introduces a separate proof IR whose gate
is exactly “flip one target iff every member of a finite control set is one”.
Parallel depth is certified by pairwise wire-disjoint layers, just as for the
lower-level reversible IR.
-/

namespace QuantumBlockEncoding
namespace MultiControlledXSchedule

/-- One arbitrary multi-controlled X gate. -/
structure MCXGate (qubits : Nat) where
  controls : Finset (Fin qubits)
  target : Fin qubits
  target_not_control : target ∉ controls

/-- Gate activation predicate. -/
def active {q : Nat} (gate : MCXGate q)
    (state : PrimitiveBasis q) : Prop :=
  ∀ control ∈ gate.controls, state control = 1

/-- Activation is constructively decidable because the control register is a
finite set and computational-basis bit equality is decidable. -/
instance instDecidableActive {q : Nat} (gate : MCXGate q)
    (state : PrimitiveBasis q) : Decidable (active gate state) := by
  unfold active
  infer_instance

/-- Exact computational-basis gate action. -/
def gateAction {q : Nat} (gate : MCXGate q)
    (state : PrimitiveBasis q) : PrimitiveBasis q :=
  if active gate state then xBasisAction gate.target state else state

/-- Controls are preserved by one MCX gate. -/
theorem gateAction_control
    {q : Nat} (gate : MCXGate q)
    (state : PrimitiveBasis q)
    (control : Fin q) (member : control ∈ gate.controls) :
    gateAction gate state control = state control := by
  by_cases h : active gate state
  · simp [gateAction, h, xBasisAction]
    intro equal
    subst control
    exact gate.target_not_control member
  · simp [gateAction, h]

/-- Therefore the activation predicate is invariant under the gate itself. -/
theorem active_gateAction_iff
    {q : Nat} (gate : MCXGate q)
    (state : PrimitiveBasis q) :
    active gate (gateAction gate state) ↔ active gate state := by
  unfold active
  constructor
  · intro after control member
    have atControl := after control member
    rw [gateAction_control gate state control member] at atControl
    exact atControl
  · intro before control member
    have atControl := before control member
    rw [gateAction_control gate state control member]
    exact atControl

/-- MCX is involutory. -/
theorem gateAction_involutive
    {q : Nat} (gate : MCXGate q) : Function.Involutive (gateAction gate) := by
  intro state
  by_cases h : active gate state
  · have h' : active gate (gateAction gate state) :=
      (active_gateAction_iff gate state).2 h
    simp [gateAction, h, h', xBasisAction_involutive]
  · have h' : ¬ active gate (gateAction gate state) := by
      intro after
      exact h ((active_gateAction_iff gate state).1 after)
    simp [gateAction, h, h']

/-- Exact basis permutation of one arbitrary MCX. -/
def gateEquiv {q : Nat} (gate : MCXGate q) : Equiv.Perm (PrimitiveBasis q) where
  toFun := gateAction gate
  invFun := gateAction gate
  left_inv := gateAction_involutive gate
  right_inv := gateAction_involutive gate

/-- Complete wire support. -/
def touches {q : Nat} (gate : MCXGate q) (wire : Fin q) : Prop :=
  wire = gate.target ∨ wire ∈ gate.controls

/-- Two source MCX gates can occupy one parallel layer exactly when their full
supports are disjoint. -/
def WireDisjoint {q : Nat} (left right : MCXGate q) : Prop :=
  ∀ wire, ¬(touches left wire ∧ touches right wire)

/-- Symmetry of MCX wire disjointness. -/
theorem wireDisjoint_symm
    {q : Nat} {left right : MCXGate q}
    (h : WireDisjoint left right) : WireDisjoint right left := by
  intro wire overlap
  exact h wire ⟨overlap.2, overlap.1⟩

/-- One chronological MCX program. -/
abbrev MCXProgram (q : Nat) := List (MCXGate q)

/-- Exact program evaluation. -/
def evalProgram {q : Nat} : MCXProgram q → Equiv.Perm (PrimitiveBasis q)
  | [] => Equiv.refl _
  | gate :: rest => (gateEquiv gate).trans (evalProgram rest)

/-- One parallel MCX layer. -/
abbrev MCXLayer (q : Nat) := List (MCXGate q)

def LayerValid {q : Nat} (layer : MCXLayer q) : Prop :=
  layer.Pairwise WireDisjoint

/-- One chronological schedule of parallel MCX layers. -/
abbrev MCXSchedule (q : Nat) := List (MCXLayer q)

def ScheduleValid {q : Nat} (schedule : MCXSchedule q) : Prop :=
  ∀ layer ∈ schedule, LayerValid layer

/-- Authoritative flattened MCX program. -/
def scheduleProgram {q : Nat} (schedule : MCXSchedule q) : MCXProgram q :=
  schedule.flatten

/-- Logical MCX count. -/
def gateCount {q : Nat} (schedule : MCXSchedule q) : Nat :=
  (scheduleProgram schedule).length

/-- Certified MCX depth. -/
def depth {q : Nat} (schedule : MCXSchedule q) : Nat := schedule.length

/-- Proof-bearing source schedule. -/
structure ScheduledMCXProgram (q : Nat) where
  layers : MCXSchedule q
  valid : ScheduleValid layers

namespace ScheduledMCXProgram

/-- Flattened program. -/
def program {q : Nat} (scheduled : ScheduledMCXProgram q) : MCXProgram q :=
  scheduleProgram scheduled.layers

/-- Exact basis permutation. -/
def eval {q : Nat} (scheduled : ScheduledMCXProgram q) :
    Equiv.Perm (PrimitiveBasis q) :=
  evalProgram scheduled.program

/-- Source gate count. -/
def gateCount {q : Nat} (scheduled : ScheduledMCXProgram q) : Nat :=
  MultiControlledXSchedule.gateCount scheduled.layers

/-- Source parallel depth. -/
def depth {q : Nat} (scheduled : ScheduledMCXProgram q) : Nat :=
  MultiControlledXSchedule.depth scheduled.layers

/-- Chronological schedule composition. -/
def seq {q : Nat}
    (left right : ScheduledMCXProgram q) : ScheduledMCXProgram q where
  layers := left.layers ++ right.layers
  valid := by
    intro layer member
    rw [List.mem_append] at member
    rcases member with member | member
    · exact left.valid layer member
    · exact right.valid layer member

@[simp] theorem seq_program {q : Nat}
    (left right : ScheduledMCXProgram q) :
    (seq left right).program = left.program ++ right.program := by
  simp [seq, program, scheduleProgram, List.flatten_append]

@[simp] theorem seq_gateCount {q : Nat}
    (left right : ScheduledMCXProgram q) :
    (seq left right).gateCount = left.gateCount + right.gateCount := by
  simp [gateCount, MultiControlledXSchedule.gateCount,
    scheduleProgram, seq, List.flatten_append]

@[simp] theorem seq_depth {q : Nat}
    (left right : ScheduledMCXProgram q) :
    (seq left right).depth = left.depth + right.depth := by
  simp [depth, MultiControlledXSchedule.depth, seq]

end ScheduledMCXProgram

/-- One valid parallel layer packaged as a schedule. -/
def oneLayer {q : Nat} (layer : MCXLayer q) (valid : LayerValid layer) :
    ScheduledMCXProgram q where
  layers := [layer]
  valid := by
    intro query member
    have equal : query = layer := by simpa using member
    subst query
    exact valid

@[simp] theorem oneLayer_program {q : Nat}
    (layer : MCXLayer q) (valid : LayerValid layer) :
    (oneLayer layer valid).program = layer := by
  simp [oneLayer, ScheduledMCXProgram.program, scheduleProgram]

@[simp] theorem oneLayer_depth {q : Nat}
    (layer : MCXLayer q) (valid : LayerValid layer) :
    (oneLayer layer valid).depth = 1 := rfl

@[simp] theorem oneLayer_gateCount {q : Nat}
    (layer : MCXLayer q) (valid : LayerValid layer) :
    (oneLayer layer valid).gateCount = layer.length := by
  simp [ScheduledMCXProgram.gateCount, gateCount,
    oneLayer, scheduleProgram]

end MultiControlledXSchedule
end QuantumBlockEncoding

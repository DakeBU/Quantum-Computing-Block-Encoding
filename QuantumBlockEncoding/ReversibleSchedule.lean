import QuantumBlockEncoding.ReversibleClassical
import Mathlib.Tactic

/-!
# Proof-bearing schedules for reversible programs

`ReversibleProgram` is the semantic gate list used by the comparator/incrementer
formalization.  To certify parallel depth we need a schedule tied to that exact
list, not an unrelated numeric field.

A reversible schedule is a list of layers.  Gates in one layer must have
disjoint wire support, proved by `List.Pairwise`.  Flattening the layers gives
the authoritative `ReversibleProgram`; gate count and depth are therefore
computed from the same proof-bearing object.
-/

namespace QuantumBlockEncoding

namespace ReversibleGate

/-- Wires touched by one reversible gate. -/
def touches {qubits : Nat}
    (gate : ReversibleGate qubits) (wire : Fin qubits) : Prop :=
  match gate with
  | .x target => wire = target
  | .cx control target _ => wire = control ∨ wire = target
  | .ccx control0 control1 target _ _ _ =>
      wire = control0 ∨ wire = control1 ∨ wire = target

/-- Two gates may share one parallel layer only when they touch no common wire. -/
def WireDisjoint {qubits : Nat}
    (left right : ReversibleGate qubits) : Prop :=
  ∀ wire, ¬(left.touches wire ∧ right.touches wire)

/-- Wire-disjointness is symmetric. -/
theorem wireDisjoint_symm {qubits : Nat}
    {left right : ReversibleGate qubits}
    (disjoint : WireDisjoint left right) :
    WireDisjoint right left := by
  intro wire overlap
  exact disjoint wire ⟨overlap.2, overlap.1⟩

end ReversibleGate

/-- One parallel reversible layer. -/
abbrev ReversibleLayer (qubits : Nat) := List (ReversibleGate qubits)

namespace ReversibleLayer

/-- Every pair of gates in the layer has disjoint wire support. -/
def Valid {qubits : Nat} (layer : ReversibleLayer qubits) : Prop :=
  layer.Pairwise ReversibleGate.WireDisjoint

@[simp] theorem valid_nil {qubits : Nat} :
    Valid ([] : ReversibleLayer qubits) := by
  simp [Valid]

@[simp] theorem valid_singleton {qubits : Nat}
    (gate : ReversibleGate qubits) :
    Valid [gate] := by
  simp [Valid]

end ReversibleLayer

/-- A chronological list of parallel layers. -/
abbrev ReversibleSchedule (qubits : Nat) := List (ReversibleLayer qubits)

namespace ReversibleSchedule

/-- Every layer is wire-disjoint. -/
def Valid {qubits : Nat} (schedule : ReversibleSchedule qubits) : Prop :=
  ∀ layer ∈ schedule, ReversibleLayer.Valid layer

/-- The authoritative sequential program represented by a schedule. -/
def program {qubits : Nat}
    (schedule : ReversibleSchedule qubits) : ReversibleProgram qubits :=
  schedule.flatten

/-- Exact logical gate count of the scheduled program. -/
def gateCount {qubits : Nat}
    (schedule : ReversibleSchedule qubits) : Nat :=
  schedule.program.length

/-- Parallel depth certified by the number of valid layers. -/
def depth {qubits : Nat}
    (schedule : ReversibleSchedule qubits) : Nat :=
  schedule.length

end ReversibleSchedule

/-- A schedule together with its non-overlap proof. -/
structure ScheduledReversibleProgram (qubits : Nat) where
  layers : ReversibleSchedule qubits
  valid : layers.Valid

namespace ScheduledReversibleProgram

/-- Flatten to the exact reversible proof IR. -/
def program {qubits : Nat}
    (scheduled : ScheduledReversibleProgram qubits) :
    ReversibleProgram qubits :=
  scheduled.layers.program

/-- Logical gate count from the same flattened program. -/
def gateCount {qubits : Nat}
    (scheduled : ScheduledReversibleProgram qubits) : Nat :=
  scheduled.layers.gateCount

/-- Certified parallel depth. -/
def depth {qubits : Nat}
    (scheduled : ScheduledReversibleProgram qubits) : Nat :=
  scheduled.layers.depth

/-- Conservative schedule with one gate per layer, available for every program.
Low-depth source theorems need a better schedule, but never need a different
semantic gate list. -/
def sequential {qubits : Nat}
    (program : ReversibleProgram qubits) :
    ScheduledReversibleProgram qubits where
  layers := program.map (fun gate => [gate])
  valid := by
    intro layer member
    simp only [List.mem_map] at member
    rcases member with ⟨gate, _, rfl⟩
    exact ReversibleLayer.valid_singleton gate

@[simp] theorem sequential_program {qubits : Nat}
    (program : ReversibleProgram qubits) :
    (sequential program).program = program := by
  induction program with
  | nil => rfl
  | cons gate rest induction =>
      simp [sequential, ScheduledReversibleProgram.program,
        ReversibleSchedule.program, induction]

@[simp] theorem sequential_gateCount {qubits : Nat}
    (program : ReversibleProgram qubits) :
    (sequential program).gateCount = program.length := by
  simp [gateCount, ReversibleSchedule.gateCount]

@[simp] theorem sequential_depth {qubits : Nat}
    (program : ReversibleProgram qubits) :
    (sequential program).depth = program.length := by
  simp [depth, ReversibleSchedule.depth, sequential]

end ScheduledReversibleProgram

/-- Semantic certificate tying one scheduled reversible program to one exact
basis permutation. -/
structure ScheduledReversibleCertificate (qubits : Nat) where
  scheduled : ScheduledReversibleProgram qubits
  target : Equiv.Perm (PrimitiveBasis qubits)
  semantics : evalReversibleProgram scheduled.program = target

namespace ScheduledReversibleCertificate

/-- Gate count and depth are read from the same scheduled circuit. -/
def resourcePair {qubits : Nat}
    (certificate : ScheduledReversibleCertificate qubits) : Nat × Nat :=
  (certificate.scheduled.gateCount, certificate.scheduled.depth)

end ScheduledReversibleCertificate

end QuantumBlockEncoding

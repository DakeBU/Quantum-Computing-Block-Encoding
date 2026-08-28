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

/-- Reversible-program evaluation respects chronological list append. -/
theorem evalReversibleProgram_append {qubits : Nat}
    (left right : ReversibleProgram qubits) :
    evalReversibleProgram (left ++ right) =
      (evalReversibleProgram left).trans (evalReversibleProgram right) := by
  induction left with
  | nil =>
      rfl
  | cons gate rest induction =>
      change
        (evalReversibleGate gate).trans
            (evalReversibleProgram (rest ++ right)) =
          ((evalReversibleGate gate).trans
            (evalReversibleProgram rest)).trans
              (evalReversibleProgram right)
      rw [induction]
      rfl

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
  change (program.map (fun gate => [gate])).flatten = program
  induction program with
  | nil => rfl
  | cons gate rest induction =>
      simp [induction]

@[simp] theorem sequential_gateCount {qubits : Nat}
    (program : ReversibleProgram qubits) :
    (sequential program).gateCount = program.length := by
  change (sequential program).program.length = program.length
  rw [sequential_program]

@[simp] theorem sequential_depth {qubits : Nat}
    (program : ReversibleProgram qubits) :
    (sequential program).depth = program.length := by
  simp [depth, ReversibleSchedule.depth, sequential]

/-- Chronological composition of two valid schedules. -/
def seq {qubits : Nat}
    (left right : ScheduledReversibleProgram qubits) :
    ScheduledReversibleProgram qubits where
  layers := left.layers ++ right.layers
  valid := by
    intro layer member
    rw [List.mem_append] at member
    rcases member with member | member
    · exact left.valid layer member
    · exact right.valid layer member

@[simp] theorem seq_program {qubits : Nat}
    (left right : ScheduledReversibleProgram qubits) :
    (seq left right).program = left.program ++ right.program := by
  simp [seq, ScheduledReversibleProgram.program,
    ReversibleSchedule.program, List.flatten_append]

@[simp] theorem seq_gateCount {qubits : Nat}
    (left right : ScheduledReversibleProgram qubits) :
    (seq left right).gateCount = left.gateCount + right.gateCount := by
  change (seq left right).program.length =
    left.program.length + right.program.length
  rw [seq_program, List.length_append]

@[simp] theorem seq_depth {qubits : Nat}
    (left right : ScheduledReversibleProgram qubits) :
    (seq left right).depth = left.depth + right.depth := by
  simp [depth, ReversibleSchedule.depth, seq]

/-- Semantic action of scheduled sequential composition. -/
theorem eval_seq {qubits : Nat}
    (left right : ScheduledReversibleProgram qubits) :
    evalReversibleProgram (seq left right).program =
      (evalReversibleProgram left.program).trans
        (evalReversibleProgram right.program) := by
  rw [seq_program, evalReversibleProgram_append]

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

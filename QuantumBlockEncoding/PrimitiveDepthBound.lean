import QuantumBlockEncoding.PrimitiveCircuit

/-!
# Actual primitive-circuit depth is bounded by instruction count

These bounds use the existing per-wire scheduling fold, not an assigned
serial-depth surrogate. They apply to every typed primitive gate list.
-/

namespace QuantumBlockEncoding.PrimitiveCircuit

theorem nextWireDepth_le {qubits : Nat} (wireDepth : Fin qubits → Nat)
    (bound : Nat) (h : ∀ wire, wireDepth wire ≤ bound)
    (gate : PrimitiveGate qubits) (wire : Fin qubits) :
    nextWireDepth wireDepth gate wire ≤ bound + 1 := by
  unfold nextWireDepth
  split
  · exact Nat.add_le_add_right (Finset.sup_le (fun j _ => h j)) 1
  · exact (h wire).trans (Nat.le_succ bound)

/-- Each scheduled instruction raises the global upper bound by at most one,
from any supplied initial wire-depth profile. -/
theorem foldl_nextWireDepth_le {qubits : Nat} (circuit : PrimitiveCircuit qubits)
    (wireDepth : Fin qubits → Nat) (bound : Nat)
    (h : ∀ wire, wireDepth wire ≤ bound) :
    ∀ wire, circuit.foldl nextWireDepth wireDepth wire ≤ bound + circuit.length := by
  induction circuit generalizing wireDepth bound with
  | nil => simpa using h
  | cons gate rest ih =>
    have ht := ih (nextWireDepth wireDepth gate) (bound + 1)
      (nextWireDepth_le wireDepth bound h gate)
    simpa only [List.foldl_cons, List.length_cons, Nat.add_assoc, Nat.add_comm,
      Nat.add_left_comm] using ht

theorem wireDepths_le_gateCount {qubits : Nat} (circuit : PrimitiveCircuit qubits)
    (wire : Fin qubits) : circuit.wireDepths wire ≤ circuit.gateCount := by
  simpa [wireDepths, gateCount] using
    foldl_nextWireDepth_le circuit (fun _ => 0) 0 (fun _ => Nat.le_refl 0) wire

theorem depth_le_gateCount {qubits : Nat} (circuit : PrimitiveCircuit qubits) :
    circuit.depth ≤ circuit.gateCount :=
  Finset.sup_le (fun wire _ => wireDepths_le_gateCount circuit wire)

/-- The actual reported resource depth, including scheduling parallelism. -/
theorem resource_depth_le_gateCount {qubits : Nat} (circuit : PrimitiveCircuit qubits) :
    circuit.resource.depth ≤ circuit.gateCount :=
  depth_le_gateCount circuit

end QuantumBlockEncoding.PrimitiveCircuit

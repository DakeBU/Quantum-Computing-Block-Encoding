import QuantumBlockEncoding.ComparatorIncrementer
import Mathlib.Tactic

/-!
# Additive logical gate counts for reversible programs

`ComparatorIncrementer` already defines X/CX/CCX counts directly from the exact
`ReversibleProgram` by `List.foldl`.  This module proves the algebra needed by
recursive source constructions: counts are additive under chronological list
append and have simple singleton forms.
-/

namespace QuantumBlockEncoding
namespace ReversibleProgramCounts

open ComparatorIncrementer

private theorem foldl_additive
    {qubits : Nat}
    (weight : ReversibleGate qubits → Nat)
    (program : ReversibleProgram qubits)
    (accumulator : Nat) :
    program.foldl (fun total gate => total + weight gate) accumulator =
      accumulator +
        program.foldl (fun total gate => total + weight gate) 0 := by
  induction program generalizing accumulator with
  | nil =>
      simp
  | cons gate rest induction =>
      simp only [List.foldl_cons]
      rw [induction]
      rw [induction (accumulator := weight gate)]
      omega

@[simp] theorem xCount_nil {qubits : Nat} :
    ComparatorIncrementer.ReversibleProgram.xCount
      ([] : ReversibleProgram qubits) = 0 := by
  rfl

@[simp] theorem cxCount_nil {qubits : Nat} :
    ComparatorIncrementer.ReversibleProgram.cxCount
      ([] : ReversibleProgram qubits) = 0 := by
  rfl

@[simp] theorem toffoliCount_nil {qubits : Nat} :
    ComparatorIncrementer.ReversibleProgram.toffoliCount
      ([] : ReversibleProgram qubits) = 0 := by
  rfl

@[simp] theorem xCount_singleton {qubits : Nat}
    (gate : ReversibleGate qubits) :
    ComparatorIncrementer.ReversibleProgram.xCount [gate] = gate.xCount := by
  simp [ComparatorIncrementer.ReversibleProgram.xCount]

@[simp] theorem cxCount_singleton {qubits : Nat}
    (gate : ReversibleGate qubits) :
    ComparatorIncrementer.ReversibleProgram.cxCount [gate] = gate.cxCount := by
  simp [ComparatorIncrementer.ReversibleProgram.cxCount]

@[simp] theorem toffoliCount_singleton {qubits : Nat}
    (gate : ReversibleGate qubits) :
    ComparatorIncrementer.ReversibleProgram.toffoliCount [gate] =
      gate.toffoliCount := by
  simp [ComparatorIncrementer.ReversibleProgram.toffoliCount]

@[simp] theorem xCount_append {qubits : Nat}
    (left right : ReversibleProgram qubits) :
    ComparatorIncrementer.ReversibleProgram.xCount (left ++ right) =
      ComparatorIncrementer.ReversibleProgram.xCount left +
        ComparatorIncrementer.ReversibleProgram.xCount right := by
  unfold ComparatorIncrementer.ReversibleProgram.xCount
  rw [List.foldl_append]
  exact foldl_additive
    ComparatorIncrementer.ReversibleGate.xCount right
    (left.foldl
      (fun total gate => total + ComparatorIncrementer.ReversibleGate.xCount gate) 0)

@[simp] theorem cxCount_append {qubits : Nat}
    (left right : ReversibleProgram qubits) :
    ComparatorIncrementer.ReversibleProgram.cxCount (left ++ right) =
      ComparatorIncrementer.ReversibleProgram.cxCount left +
        ComparatorIncrementer.ReversibleProgram.cxCount right := by
  unfold ComparatorIncrementer.ReversibleProgram.cxCount
  rw [List.foldl_append]
  exact foldl_additive
    ComparatorIncrementer.ReversibleGate.cxCount right
    (left.foldl
      (fun total gate => total + ComparatorIncrementer.ReversibleGate.cxCount gate) 0)

@[simp] theorem toffoliCount_append {qubits : Nat}
    (left right : ReversibleProgram qubits) :
    ComparatorIncrementer.ReversibleProgram.toffoliCount (left ++ right) =
      ComparatorIncrementer.ReversibleProgram.toffoliCount left +
        ComparatorIncrementer.ReversibleProgram.toffoliCount right := by
  unfold ComparatorIncrementer.ReversibleProgram.toffoliCount
  rw [List.foldl_append]
  exact foldl_additive
    ComparatorIncrementer.ReversibleGate.toffoliCount right
    (left.foldl
      (fun total gate => total + ComparatorIncrementer.ReversibleGate.toffoliCount gate) 0)

end ReversibleProgramCounts
end QuantumBlockEncoding
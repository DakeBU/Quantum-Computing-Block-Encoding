import QuantumBlockEncoding.ReversibleClassical
import Mathlib.Tactic

/-!
# Reversing a reversible program gives its inverse

Every gate in ASPBE's reversible proof IR (`X`, `CX`, `CCX`) is self-inverse.
Consequently, reversing the chronological gate list implements the inverse
basis permutation.  This is the generic compute/uncompute bridge used by
Gidney's incrementer, promise-register cleanup, and later SP/BE arithmetic
subroutines.
-/

namespace QuantumBlockEncoding
namespace ReversibleProgramInverse

/-- Every logical gate in the reversible IR is its own inverse. -/
theorem evalReversibleGate_symm
    {qubits : Nat} (gate : ReversibleGate qubits) :
    (evalReversibleGate gate).symm = evalReversibleGate gate := by
  cases gate with
  | x target =>
      apply Equiv.ext
      intro state
      rfl
  | cx control target distinct =>
      apply Equiv.ext
      intro state
      rfl
  | ccx control0 control1 target c0_ne_c1 c0_ne_target c1_ne_target =>
      apply Equiv.ext
      intro state
      rfl

/-- One singleton program evaluates to the corresponding gate permutation. -/
@[simp] theorem evalReversibleProgram_singleton
    {qubits : Nat} (gate : ReversibleGate qubits) :
    evalReversibleProgram [gate] = evalReversibleGate gate := by
  simp [evalReversibleProgram]

/-- Reverse chronological order implements the inverse permutation. -/
theorem evalReversibleProgram_reverse
    {qubits : Nat} (program : ReversibleProgram qubits) :
    evalReversibleProgram program.reverse =
      (evalReversibleProgram program).symm := by
  induction program with
  | nil =>
      rfl
  | cons gate rest induction =>
      rw [List.reverse_cons, evalReversibleProgram_append]
      rw [induction]
      rw [evalReversibleProgram_singleton]
      apply Equiv.ext
      intro state
      simp only [evalReversibleProgram, Equiv.trans_apply]
      rw [evalReversibleGate_symm]
      rfl

/-- Gate-list reversal preserves logical gate count exactly. -/
@[simp] theorem reverse_length
    {qubits : Nat} (program : ReversibleProgram qubits) :
    program.reverse.length = program.length := by
  exact List.length_reverse program

/-- Compute followed by the reversed program is identity. -/
theorem eval_then_reverse
    {qubits : Nat} (program : ReversibleProgram qubits) :
    (evalReversibleProgram program).trans
        (evalReversibleProgram program.reverse) =
      Equiv.refl (PrimitiveBasis qubits) := by
  rw [evalReversibleProgram_reverse]
  apply Equiv.ext
  intro state
  simp

/-- Reverse followed by compute is identity as well. -/
theorem reverse_then_eval
    {qubits : Nat} (program : ReversibleProgram qubits) :
    (evalReversibleProgram program.reverse).trans
        (evalReversibleProgram program) =
      Equiv.refl (PrimitiveBasis qubits) := by
  rw [evalReversibleProgram_reverse]
  apply Equiv.ext
  intro state
  simp

end ReversibleProgramInverse
end QuantumBlockEncoding
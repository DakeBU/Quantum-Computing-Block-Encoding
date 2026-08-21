import QuantumBlockEncoding.ComparatorIncrementer
import QuantumBlockEncoding.ReversibleProgramCounts
import Mathlib.Tactic

/-!
# Generic T-count law for the exact reversible compiler

ASPBE compiles X/CX/CCX proof programs to `{X,RY,RZ,CX}`.  The exact CCX macro
contains seven T/T† quarter-phase rotations, while X and CX contain none.
Therefore every compiled reversible program satisfies

`T-count = 7 * logical-Toffoli-count`.

This is a compiler theorem, not a source-paper complexity theorem.  It is shared
by Vandaele arithmetic and later SP/BE reversible subroutines.
-/

namespace QuantumBlockEncoding
namespace ReversibleCompilerTCount

open ComparatorIncrementer
open ReversibleProgramCounts

/-- Primitive T-count is additive under chronological circuit append. -/
theorem primitiveTCount_append
    {qubits : Nat} (left right : PrimitiveCircuit qubits) :
    (left ++ right).tCount = left.tCount + right.tCount := by
  unfold ComparatorIncrementer.PrimitiveCircuit.tCount
  rw [List.foldl_append]
  have additive :=
    @ReversibleProgramCounts.foldl_additive -- intentionally unavailable: use local proof below
  clear additive
  induction right generalizing left with
  | nil =>
      simp [ComparatorIncrementer.PrimitiveCircuit.tCount]
  | cons gate rest induction =>
      simp only [List.foldl_cons]
      unfold ComparatorIncrementer.PrimitiveCircuit.tCount at induction ⊢
      simp only [List.foldl_append]
      -- The accumulator is natural-number addition, so changing its initial
      -- value only adds that value to the final fold.
      induction rest generalizing left with
      | nil =>
          simp
      | cons next tail ih =>
          simp only [List.foldl_cons]
          rw [ih]
          omega

/-- One compiled logical gate contributes seven T/T† rotations exactly when it
is CCX. -/
theorem compileReversibleGate_tCount
    {qubits : Nat} (gate : ReversibleGate qubits) :
    (compileReversibleGate gate).circuit.tCount =
      7 * ComparatorIncrementer.ReversibleGate.toffoliCount gate := by
  cases gate with
  | x target =>
      simp [compileReversibleGate, primitiveXProgram,
        ComparatorIncrementer.PrimitiveCircuit.tCount,
        ComparatorIncrementer.PrimitiveGate.tCount]
  | cx control target distinct =>
      simp [compileReversibleGate, primitiveCxProgram,
        ComparatorIncrementer.PrimitiveCircuit.tCount,
        ComparatorIncrementer.PrimitiveGate.tCount]
  | ccx control0 control1 target c0_ne_c1 c0_ne_target c1_ne_target =>
      simp [compileReversibleGate, primitiveCCXProgram,
        primitiveHProgram, ComparatorIncrementer.PrimitiveCircuit.tCount,
        ComparatorIncrementer.PrimitiveGate.tCount]

/-- Generic exact compiler law. -/
theorem compileReversibleProgram_tCount
    {qubits : Nat} (program : ReversibleProgram qubits) :
    (compileReversibleProgram program).circuit.tCount =
      7 * ComparatorIncrementer.ReversibleProgram.toffoliCount program := by
  induction program with
  | nil =>
      simp [compileReversibleProgram,
        ComparatorIncrementer.PrimitiveCircuit.tCount,
        ComparatorIncrementer.ReversibleProgram.toffoliCount]
  | cons gate rest induction =>
      simp [compileReversibleProgram, PrimitiveProgram.seq,
        primitiveTCount_append, compileReversibleGate_tCount,
        induction, ComparatorIncrementer.ReversibleProgram.toffoliCount]
      ring

end ReversibleCompilerTCount
end QuantumBlockEncoding
import QuantumBlockEncoding.ComparatorIncrementer
import QuantumBlockEncoding.GidneyZeroedSourceLogicalResources
import QuantumBlockEncoding.GidneyZeroedSourceStrongPromise
import Mathlib.Tactic

/-!
# Primitive refinement of the gate-level Gidney source family

The correctness proof is carried by the reversible `{X,CX,CCX}` source program.
ASPBE already has an exact compiler from that proof IR to its primitive
`{X,RY,RZ,CX}` backend.  This module applies that compiler to the arbitrary-width
Gidney source family and records the exact permutation-matrix refinement.

No new resource model is introduced.  Logical X/CX/CCX fields are read from the
same source program; compiled T/one-qubit/CNOT/depth fields remain those of the
existing exact compiler.
-/

namespace QuantumBlockEncoding
namespace GidneyZeroedPrimitive

open ComparatorIncrementer
open GidneyZeroedSourceLogicalResources
open GidneyZeroedSourceProgram
open Robin.ComplexLCU

/-- Exact primitive program obtained from the proved source gate list. -/
noncomputable def sourcePrimitive (carryCount : Nat) :
    PrimitiveProgram (flatWidth carryCount) :=
  compileReversibleProgram (sourceProgram carryCount)

/-- Primitive semantics are exactly the basis permutation proved by the source
program. -/
theorem sourcePrimitive_exact (carryCount : Nat) :
    evalPrimitiveProgram (sourcePrimitive carryCount) =
      equivPermutationMatrix
        (evalReversibleProgram (sourceProgram carryCount)) := by
  exact compileReversibleProgram_eval (sourceProgram carryCount)

/-- The compiled source circuit is unitary. -/
theorem sourcePrimitive_unitary (carryCount : Nat) :
    evalPrimitiveProgram (sourcePrimitive carryCount) ∈
      _root_.Matrix.unitaryGroup (PrimitiveBasis (flatWidth carryCount)) ℂ :=
  evalPrimitiveProgram_unitary (sourcePrimitive carryCount)

/-- Logical source counts are preserved in the existing compiler resource
record. -/
theorem sourceCompilationCost_logical
    (carryCount : Nat) :
    let cost := compilationCost (sourceProgram carryCount)
    cost.logicalX = 1 ∧
      cost.logicalCnot = carryCount + 1 ∧
      cost.logicalToffoli = 2 * carryCount := by
  have counts := sourceProgram_counts carryCount
  simp [compilationCost, counts.1, counts.2.1, counts.2.2]

/-- The six-target-bit source benchmark therefore compiles from exactly one X,
five CX, and eight CCX logical gates. -/
theorem sixBit_sourceCompilationCost_logical :
    let cost := compilationCost (sourceProgram 4)
    cost.logicalX = 1 ∧
      cost.logicalCnot = 5 ∧
      cost.logicalToffoli = 8 := by
  simpa using sourceCompilationCost_logical 4

end GidneyZeroedPrimitive
end QuantumBlockEncoding
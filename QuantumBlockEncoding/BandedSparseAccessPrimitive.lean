import QuantumBlockEncoding.BandedSparseAccess
import QuantumBlockEncoding.ModularAdder3
import Mathlib.Tactic

/-!
# Primitive witness for banded sparse access

`BandedSparseAccess.lean` proves the arbitrary-size reversible semantics.  This
module adds a fully expanded three-bit witness in the common primitive basis
`{X, RY, RZ, CX}`.  The witness is intentionally finite: it certifies the
compiler interface used by the current executable cases without pretending to
prove the paper's arbitrary-size gate upper bound.
-/

namespace QuantumBlockEncoding
namespace BandedSparseAccess

/-- Decode three little-endian wires as an element of `Fin 8`. -/
def primitiveWord3 (state : PrimitiveBasis 7)
    (wire0 wire1 wire2 : Fin 7) : Fin 8 :=
  ⟨littleEndian3Value state wire0 wire1 wire2, by
    have h0 := (state wire0).isLt
    have h1 := (state wire1).isLt
    have h2 := (state wire2).isLt
    omega⟩

/-- The concrete source loader used by the fixed witness: `s ↦ s XOR 3`. -/
def primitiveOffset3 (slot : Fin 8) : Fin 8 :=
  ⟨(slot.val ^^^ 3) % 8, Nat.mod_lt _ (by decide)⟩

@[simp] theorem primitiveOffset3_table :
    List.ofFn primitiveOffset3 = [3, 2, 1, 0, 7, 6, 5, 4] := by
  native_decide

/--
Wire order is `address[0..2], row[0..2], work`.  Two `X` gates implement the
source loader and the existing exact three-bit adder implements modular SUM.
-/
def primitiveAccess3ReversibleProgram : ReversibleProgram 7 :=
  [.x 0, .x 1] ++ modularAdd3ReversibleProgram

/-- Full-space reversible semantics of the fixed primitive witness. -/
def primitiveAccess3BasisEquiv : PrimitiveBasis 7 ≃ PrimitiveBasis 7 :=
  evalReversibleProgram primitiveAccess3ReversibleProgram

/-- Exact clean-workspace action of the expanded access circuit. -/
theorem primitiveAccess3_cleanAction
    (state : PrimitiveBasis 7) (workClean : state 6 = 0) :
    let output := primitiveAccess3BasisEquiv state
    primitiveWord3 output 0 1 2 =
        ⟨((primitiveOffset3 (primitiveWord3 state 0 1 2)).val +
            (primitiveWord3 state 3 4 5).val) % 8,
          Nat.mod_lt _ (by decide)⟩ ∧
      primitiveWord3 output 3 4 5 = primitiveWord3 state 3 4 5 ∧
      output 6 = 0 := by
  native_decide +revert

/-- The row register is preserved by the primitive witness. -/
theorem primitiveAccess3_preserves_row
    (state : PrimitiveBasis 7) (workClean : state 6 = 0) :
    primitiveWord3 (primitiveAccess3BasisEquiv state) 3 4 5 =
      primitiveWord3 state 3 4 5 :=
  (primitiveAccess3_cleanAction state workClean).2.1

/-- The reusable work qubit is returned to zero. -/
theorem primitiveAccess3_workspaceClean
    (state : PrimitiveBasis 7) (workClean : state 6 = 0) :
    primitiveAccess3BasisEquiv state 6 = 0 :=
  (primitiveAccess3_cleanAction state workClean).2.2

/-- Primitive compilation contains no opaque oracle instruction. -/
noncomputable def primitiveAccess3Program : PrimitiveProgram 7 :=
  compileReversibleProgram primitiveAccess3ReversibleProgram

/-- Exact matrix refinement from the emitted primitive list to the reversible map. -/
theorem primitiveAccess3Program_eval :
    evalPrimitiveProgram primitiveAccess3Program =
      Robin.ComplexLCU.equivPermutationMatrix primitiveAccess3BasisEquiv := by
  exact compileReversibleProgram_eval primitiveAccess3ReversibleProgram

/-- Resource ownership is definitional: the score is computed from the gate list. -/
theorem primitiveAccess3Program_resource_faithful :
    primitiveAccess3Program.resource = primitiveAccess3Program.circuit.resource := rfl

/-- The expanded witness has zero unresolved oracle calls. -/
theorem primitiveAccess3Program_oracleCalls_eq_zero :
    primitiveAccess3Program.resource.oracleCalls = 0 :=
  PrimitiveCircuit.resource_oracleCalls_eq_zero _

/-- The primitive matrix is unitary because every emitted instruction is unitary. -/
theorem primitiveAccess3Program_unitary :
    evalPrimitiveProgram primitiveAccess3Program ∈
      _root_.Matrix.unitaryGroup (PrimitiveBasis 7) ℂ :=
  evalPrimitiveProgram_unitary _

end BandedSparseAccess
end QuantumBlockEncoding

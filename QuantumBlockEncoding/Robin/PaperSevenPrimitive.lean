import QuantumBlockEncoding.ModularAdder3
import QuantumBlockEncoding.PrimitiveRefinement
import QuantumBlockEncoding.Robin.PaperSevenLogicalUnitary
import QuantumBlockEncoding.UniformlyControlledRy
import Mathlib.Tactic

/-!
# Exact primitive refinement for the Robin paper-seven normal form

The physical order is system `q0-q2`, selector `q3-q5`, coefficient `q6`,
and clean modular-adder workspace `q7`.  All emitted gates belong to the
repository primitive basis `X`, `RY`, `RZ`, and `CX`.
-/

namespace QuantumBlockEncoding.Robin

/-- Physical SELECT in the declared eight-wire order.  CCX remains only in
the proof IR and is compiled away by `compileReversibleProgram`. -/
def warmRobinPaperSevenSelectReversibleProgram : ReversibleProgram 8 :=
  [ .x 3
  , .x 4
  , .ccx 3 0 7 (by decide) (by decide) (by decide)
  , .ccx 7 1 2 (by decide) (by decide) (by decide)
  , .ccx 3 0 7 (by decide) (by decide) (by decide)
  , .ccx 3 0 1 (by decide) (by decide) (by decide)
  , .cx 3 0 (by decide)
  , .ccx 4 1 2 (by decide) (by decide) (by decide)
  , .cx 4 1 (by decide)
  , .cx 5 2 (by decide)
  , .x 3
  , .x 4
  ]

def warmRobinPaperSevenSelectBasisEquiv :
    PrimitiveBasis 8 ≃ PrimitiveBasis 8 :=
  evalReversibleProgram warmRobinPaperSevenSelectReversibleProgram

def warmRobinPaperSevenSystemBits (bits : PrimitiveBasis 8) : Fin 8 :=
  ⟨(bits 0).val + 2 * (bits 1).val + 4 * (bits 2).val, by omega⟩

def warmRobinPaperSevenSelectorBits (bits : PrimitiveBasis 8) : Fin 8 :=
  ⟨(bits 3).val + 2 * (bits 4).val + 4 * (bits 5).val, by omega⟩

/-- Clean-workspace action of the source SELECT. -/
theorem warmRobinPaperSevenSelectProgram_cleanAction
    (bits : PrimitiveBasis 8) (workClean : bits 7 = 0) :
    let output := warmRobinPaperSevenSelectBasisEquiv bits
    warmRobinPaperSevenSystemBits output =
        warmRobinSourceDTRow (warmRobinPaperSevenSelectorBits bits)
          (warmRobinPaperSevenSystemBits bits) ∧
      warmRobinPaperSevenSelectorBits output =
        warmRobinPaperSevenSelectorBits bits ∧
      output 6 = bits 6 ∧ output 7 = 0 := by
  native_decide +revert

theorem warmRobinPaperSevenSelectProgram_workspaceClean
    (bits : PrimitiveBasis 8) (workClean : bits 7 = 0) :
    warmRobinPaperSevenSelectBasisEquiv bits 7 = 0 :=
  (warmRobinPaperSevenSelectProgram_cleanAction bits workClean).2.2.2

noncomputable def warmRobinPaperSevenSelectProgram : PrimitiveProgram 8 :=
  compileReversibleProgram warmRobinPaperSevenSelectReversibleProgram

/-- Exact primitive matrix for source SELECT, including its exact compiler
phase. -/
theorem warmRobinPaperSevenSelectProgram_eval :
    evalPrimitiveProgram warmRobinPaperSevenSelectProgram =
      ComplexLCU.equivPermutationMatrix
        warmRobinPaperSevenSelectBasisEquiv := by
  exact compileReversibleProgram_eval _

theorem warmRobinPaperSevenSelectProgram_noOracleCalls :
    warmRobinPaperSevenSelectProgram.resource.oracleCalls = 0 :=
  PrimitiveCircuit.resource_oracleCalls_eq_zero _

end QuantumBlockEncoding.Robin

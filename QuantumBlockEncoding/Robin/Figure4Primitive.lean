import QuantumBlockEncoding.Robin.PaperSevenPrimitive
import QuantumBlockEncoding.Robin.Figure4SourceData
import QuantumBlockEncoding.Robin.SourceBaseline
import Mathlib.Tactic

/-!
# Fixed-N physical leaves from the source Figure 4 route

These exact leaves replace the old transcript's `swap 0 0` placeholder.  They
do not by themselves establish the full source circuit clean-block theorem;
the derivative/boundary loaders and transported sparse cleanup remain separate
proof obligations.
-/

namespace QuantumBlockEncoding.Robin

/-- Historical row-bulk indicator for rows 2 through 5 of `D`.  Figure 4 acts
on `D^T`, so this circuit is retained only as a source-audit guard. -/
def warmRobinRowBulkIndicatorProgram : PrimitiveCircuit 4 :=
  [.cx 1 3 (by decide), .cx 2 3 (by decide)]

def warmRobinRowBulkIndicatorBasisEquiv :
    PrimitiveBasis 4 ≃ PrimitiveBasis 4 :=
  (cxBasisEquiv (1 : Fin 4) (3 : Fin 4) (by decide)).trans
    (cxBasisEquiv (2 : Fin 4) (3 : Fin 4) (by decide))

theorem warmRobinRowBulkIndicatorBasisAction (bits : PrimitiveBasis 4) :
    let output := warmRobinRowBulkIndicatorBasisEquiv bits
    output 0 = bits 0 ∧ output 1 = bits 1 ∧ output 2 = bits 2 ∧
      output 3 =
        (if 2 ≤ (bits 0).val + 2 * (bits 1).val + 4 * (bits 2).val ∧
              (bits 0).val + 2 * (bits 1).val + 4 * (bits 2).val ≤ 5 then
          Fin.cases 1 (fun _ => 0) (bits 3)
        else bits 3) := by
  native_decide +revert

theorem warmRobinRowBulkIndicatorProgram_eval :
    evalPrimitiveCircuit warmRobinRowBulkIndicatorProgram =
      ComplexLCU.equivPermutationMatrix
        warmRobinRowBulkIndicatorBasisEquiv := by
  simp only [warmRobinRowBulkIndicatorProgram, evalPrimitiveCircuit,
    evalPrimitiveGate, _root_.Matrix.one_mul]
  exact ComplexLCU.equivPermutationMatrix_mul _ _

/-- One physical SWAP expanded into the allowed primitive basis. -/
def primitiveSwapCircuit {qubits : Nat} (left right : Fin qubits)
    (distinct : left ≠ right) : PrimitiveCircuit qubits :=
  [.cx left right distinct, .cx right left (Ne.symm distinct),
    .cx left right distinct]

def primitiveSwapBasisEquiv {qubits : Nat} (left right : Fin qubits)
    (distinct : left ≠ right) : PrimitiveBasis qubits ≃ PrimitiveBasis qubits :=
  ((cxBasisEquiv left right distinct).trans
    (cxBasisEquiv right left (Ne.symm distinct))).trans
    (cxBasisEquiv left right distinct)

theorem primitiveSwapCircuit_eval {qubits : Nat} (left right : Fin qubits)
    (distinct : left ≠ right) :
    evalPrimitiveCircuit (primitiveSwapCircuit left right distinct) =
      ComplexLCU.equivPermutationMatrix
        (primitiveSwapBasisEquiv left right distinct) := by
  simp only [primitiveSwapCircuit, evalPrimitiveCircuit, evalPrimitiveGate,
    _root_.Matrix.one_mul]
  rw [ComplexLCU.equivPermutationMatrix_mul,
    ComplexLCU.equivPermutationMatrix_mul]
  rfl

/-- Swap the two fixed three-qubit registers with three actual SWAPs. -/
def warmRobinFigure4RegisterSwapProgram : PrimitiveCircuit 6 :=
  primitiveSwapCircuit 0 3 (by decide) ++
    primitiveSwapCircuit 1 4 (by decide) ++
    primitiveSwapCircuit 2 5 (by decide)

def warmRobinFigure4RegisterSwapBasisEquiv :
    PrimitiveBasis 6 ≃ PrimitiveBasis 6 :=
  ((primitiveSwapBasisEquiv 0 3 (by decide)).trans
    (primitiveSwapBasisEquiv 1 4 (by decide))).trans
    (primitiveSwapBasisEquiv 2 5 (by decide))

theorem warmRobinFigure4RegisterSwapProgram_eval :
    evalPrimitiveCircuit warmRobinFigure4RegisterSwapProgram =
      ComplexLCU.equivPermutationMatrix
        warmRobinFigure4RegisterSwapBasisEquiv := by
  unfold warmRobinFigure4RegisterSwapProgram
  rw [evalPrimitiveCircuit_append, evalPrimitiveCircuit_append,
    primitiveSwapCircuit_eval, primitiveSwapCircuit_eval,
    primitiveSwapCircuit_eval,
    ComplexLCU.equivPermutationMatrix_mul,
    ComplexLCU.equivPermutationMatrix_mul]
  rfl

theorem warmRobinFigure4RegisterSwapBasisAction
    (bits : PrimitiveBasis 6) :
    let output := warmRobinFigure4RegisterSwapBasisEquiv bits
    output 0 = bits 3 ∧ output 1 = bits 4 ∧ output 2 = bits 5 ∧
      output 3 = bits 0 ∧ output 4 = bits 1 ∧ output 5 = bits 2 := by
  native_decide +revert

theorem warmRobinFigure4RegisterSwapProgram_counts :
    warmRobinFigure4RegisterSwapProgram.ryCount = 0 ∧
      warmRobinFigure4RegisterSwapProgram.cxCount = 9 := by
  decide

/-- For homogeneous `f=1`, the coefficient oracle is physically empty. -/
def warmRobinHomogeneousCoefficientOracle : PrimitiveCircuit 1 := []

theorem warmRobinHomogeneousCoefficientOracle_eq_identity :
    evalPrimitiveCircuit warmRobinHomogeneousCoefficientOracle = 1 := by
  rfl

theorem warmRobinRowBulkIndicatorCleanup :
    evalPrimitiveCircuit
        (warmRobinRowBulkIndicatorProgram ++
          warmRobinRowBulkIndicatorProgram.reverse.map PrimitiveGate.dagger) =
      1 := by
  rw [evalPrimitiveCircuit_append, evalPrimitiveCircuit_dagger]
  exact (_root_.Matrix.mem_unitaryGroup_iff'.mp
    (evalPrimitiveCircuit_unitary warmRobinRowBulkIndicatorProgram))

/-! ## Correct D-transpose indicator -/

/-- Two disjoint pattern-controlled flips: `011` and `100`.  Wires `q3-q5`
hold the system column, `q7` is the indicator, and `q8` is reusable clean
workspace. -/
def warmRobinFigure4DTIndicatorReversibleProgram : ReversibleProgram 9 :=
  [ .x 5 ] ++
    cleanC3XReversibleProgram 3 4 5 7 8
      (by decide) (by decide) (by decide) (by decide) (by decide) (by decide) ++
    [ .x 5, .x 3, .x 4 ] ++
    cleanC3XReversibleProgram 3 4 5 7 8
      (by decide) (by decide) (by decide) (by decide) (by decide) (by decide) ++
    [ .x 4, .x 3 ]

def warmRobinFigure4DTIndicatorBasisEquiv :
    PrimitiveBasis 9 ≃ PrimitiveBasis 9 :=
  evalReversibleProgram warmRobinFigure4DTIndicatorReversibleProgram

def warmRobinFigure4SystemBits (bits : PrimitiveBasis 9) : Fin 8 :=
  ⟨(bits 3).val + 2 * (bits 4).val + 4 * (bits 5).val, by omega⟩

theorem warmRobinFigure4DTIndicatorProgram_basisAction
    (bits : PrimitiveBasis 9) (workspaceClean : bits 8 = 0) :
    let output := warmRobinFigure4DTIndicatorBasisEquiv bits
    output 7 =
        (if warmRobinFigure4TransposeBulk (warmRobinFigure4SystemBits bits)
          then flipBit (bits 7) else bits 7) ∧
      output 8 = 0 ∧
      (∀ wire : Fin 9, wire ≠ 7 → wire ≠ 8 → output wire = bits wire) := by
  native_decide +revert

theorem warmRobinFigure4DTIndicatorProgram_workspaceClean
    (bits : PrimitiveBasis 9) (workspaceClean : bits 8 = 0) :
    warmRobinFigure4DTIndicatorBasisEquiv bits 8 = 0 :=
  (warmRobinFigure4DTIndicatorProgram_basisAction bits workspaceClean).2.1

noncomputable def warmRobinFigure4DTIndicatorProgram : PrimitiveProgram 9 :=
  compileReversibleProgram warmRobinFigure4DTIndicatorReversibleProgram

theorem warmRobinFigure4DTIndicatorProgram_eval :
    evalPrimitiveProgram warmRobinFigure4DTIndicatorProgram =
      ComplexLCU.equivPermutationMatrix
        warmRobinFigure4DTIndicatorBasisEquiv := by
  exact compileReversibleProgram_eval _

theorem warmRobinFigure4DTIndicatorProgram_noOracleCalls :
    warmRobinFigure4DTIndicatorProgram.resource.oracleCalls = 0 :=
  PrimitiveCircuit.resource_oracleCalls_eq_zero _

/-- Honest remaining boundary for the fixed source route. -/
def warmRobinFigure4OpenPrimitiveContracts : List String :=
  [ "derivative-amplitude loader exact semantics"
  , "corrected boundary standard-RY loader exact semantics"
  , "pre-SWAP sparse access and transported post-SWAP cleanup"
  , "stagewise all-workspace clean-column theorem"
  , "full Figure-4 primitive clean-block promotion"
  ]

end QuantumBlockEncoding.Robin

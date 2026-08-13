import QuantumBlockEncoding.Robin.PaperSevenPrimitive
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

/-- For the fixed fourth-order `N=8` instance, bulk rows are 2 through 5.
On three little-endian system bits this predicate is `q1 XOR q2`. -/
def warmRobinFigure4IndicatorProgram : PrimitiveCircuit 4 :=
  [.cx 1 3 (by decide), .cx 2 3 (by decide)]

def warmRobinFigure4IndicatorBasisEquiv :
    PrimitiveBasis 4 ≃ PrimitiveBasis 4 :=
  (cxBasisEquiv (1 : Fin 4) (3 : Fin 4) (by decide)).trans
    (cxBasisEquiv (2 : Fin 4) (3 : Fin 4) (by decide))

theorem warmRobinFigure4IndicatorBasisAction (bits : PrimitiveBasis 4) :
    let output := warmRobinFigure4IndicatorBasisEquiv bits
    output 0 = bits 0 ∧ output 1 = bits 1 ∧ output 2 = bits 2 ∧
      output 3 =
        (if 2 ≤ (bits 0).val + 2 * (bits 1).val + 4 * (bits 2).val ∧
              (bits 0).val + 2 * (bits 1).val + 4 * (bits 2).val ≤ 5 then
          Fin.cases 1 (fun _ => 0) (bits 3)
        else bits 3) := by
  native_decide +revert

theorem warmRobinFigure4IndicatorProgram_eval :
    evalPrimitiveCircuit warmRobinFigure4IndicatorProgram =
      ComplexLCU.equivPermutationMatrix
        warmRobinFigure4IndicatorBasisEquiv := by
  simp only [warmRobinFigure4IndicatorProgram, evalPrimitiveCircuit,
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

theorem warmRobinFigure4IndicatorCleanup :
    evalPrimitiveCircuit
        (warmRobinFigure4IndicatorProgram ++
          warmRobinFigure4IndicatorProgram.reverse.map PrimitiveGate.dagger) =
      1 := by
  rw [evalPrimitiveCircuit_append, evalPrimitiveCircuit_dagger]
  exact (_root_.Matrix.mem_unitaryGroup_iff'.mp
    (evalPrimitiveCircuit_unitary warmRobinFigure4IndicatorProgram))

/-- Honest remaining boundary for the fixed source route. -/
def warmRobinFigure4OpenPrimitiveContracts : List String :=
  [ "derivative-amplitude loader exact semantics"
  , "corrected boundary standard-RY loader exact semantics"
  , "pre-SWAP sparse access and transported post-SWAP cleanup"
  , "stagewise all-workspace clean-column theorem"
  , "full Figure-4 primitive clean-block promotion"
  ]

end QuantumBlockEncoding.Robin

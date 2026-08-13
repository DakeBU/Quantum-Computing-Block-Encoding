import QuantumBlockEncoding.Robin.Figure4PreparePrimitive

/-!
# Exact middle stages of the fixed-N8 Figure-4 realization

This file composes the corrected transpose-bulk indicator, the two exact
coefficient loaders, the distinct `D^T` sparse access, register transport,
and inverse `D` cleanup.  All classical macros have already been compiled to
the primitive basis.
-/

namespace QuantumBlockEncoding.Robin

set_option maxRecDepth 100000
set_option maxHeartbeats 400000

@[simp] theorem warmRobinFigure4IndicatorBasisEquiv_clean
    (slot column : Fin 8) (coefficient : Fin 2) :
    warmRobinFigure4DTIndicatorBasisEquiv
        (warmRobinFigure4TransportInput slot column coefficient 0) =
      warmRobinFigure4TransportInput slot column coefficient
        (warmRobinFigure4IndicatorValue column) := by
  native_decide +revert

@[simp] theorem warmRobinFigure4BulkAssignment_transportInput
    (slot column : Fin 8) (coefficient indicator : Fin 2) :
    primitiveControlAssignment warmRobinFigure4BulkControlWires 6
        warmRobinFigure4BulkControlWires_ne_target
        (splitPrimitiveWire (6 : Fin 9)
          (warmRobinFigure4TransportInput slot column coefficient indicator)).2 =
      warmRobinFigure4BulkControlInput slot indicator := by
  native_decide +revert

@[simp] theorem warmRobinFigure4BoundaryAssignment_transportInput
    (slot column : Fin 8) (coefficient indicator : Fin 2) :
    primitiveControlAssignment warmRobinFigure4BoundaryControlWires 6
        warmRobinFigure4BoundaryControlWires_ne_target
        (splitPrimitiveWire (6 : Fin 9)
          (warmRobinFigure4TransportInput slot column coefficient indicator)).2 =
      warmRobinFigure4BoundaryControlInput slot column indicator := by
  native_decide +revert

/-- The physical loader's clean coefficient entry is the exact source
coefficient.  The proof reduces the two nine-wire block diagonals to their
single two-dimensional standard-RY product. -/
theorem warmRobinFigure4DerivativeLoader_physicalCleanEntry
    (slot column : Fin 8) :
    let input := warmRobinFigure4TransportInput slot column 0
      (warmRobinFigure4IndicatorValue column)
    evalPrimitiveProgram warmRobinFigure4DerivativeLoaderProgram input input =
      ((warmRobinFigure4SourceCoefficient slot column : Rat) : ℂ) := by
  dsimp only
  rw [warmRobinFigure4DerivativeLoaderProgram_eval]
  unfold controlledRyBlockMatrix
  rw [← _root_.Matrix.reindexAlgEquiv_mul,
    ← _root_.Matrix.blockDiagonal_mul]
  simp only [_root_.Matrix.reindexAlgEquiv_apply,
    _root_.Matrix.reindex_apply, _root_.Matrix.submatrix_apply,
    Equiv.symm_symm, _root_.Matrix.blockDiagonal_apply,
    warmRobinFigure4TransportInput_coefficient,
    warmRobinFigure4BulkAssignment_transportInput,
    warmRobinFigure4BoundaryAssignment_transportInput, if_pos]
  exact warmRobinFigure4DerivativeLoader_cleanEntry slot column

@[simp] theorem warmRobinFigure4TransportInput_splitCoefficient_fst
    (slot column : Fin 8) (coefficient indicator : Fin 2) :
    (splitPrimitiveWire (6 : Fin 9)
      (warmRobinFigure4TransportInput slot column coefficient indicator)).1 =
        coefficient := by
  rfl

theorem warmRobinFigure4TransportInput_splitCoefficient_context
    (slot column : Fin 8) (left right indicator : Fin 2) :
    (splitPrimitiveWire (6 : Fin 9)
        (warmRobinFigure4TransportInput slot column left indicator)).2 =
      (splitPrimitiveWire (6 : Fin 9)
        (warmRobinFigure4TransportInput slot column right indicator)).2 := by
  native_decide +revert

theorem warmRobinFigure4TransportInput_splitCoefficient_context_iff
    (leftSlot rightSlot leftColumn rightColumn : Fin 8)
    (leftCoefficient rightCoefficient leftIndicator rightIndicator : Fin 2) :
    (splitPrimitiveWire (6 : Fin 9)
        (warmRobinFigure4TransportInput leftSlot leftColumn
          leftCoefficient leftIndicator)).2 =
      (splitPrimitiveWire (6 : Fin 9)
        (warmRobinFigure4TransportInput rightSlot rightColumn
          rightCoefficient rightIndicator)).2 ↔
      leftSlot = rightSlot ∧ leftColumn = rightColumn ∧
        leftIndicator = rightIndicator := by
  native_decide +revert

theorem warmRobinFigure4DerivativeLoader_entry
    (coefficientRow coefficientColumn : Fin 2)
    (slot leftColumn rightColumn : Fin 8) :
    evalPrimitiveProgram warmRobinFigure4DerivativeLoaderProgram
        (warmRobinFigure4TransportInput slot leftColumn coefficientRow
          (warmRobinFigure4IndicatorValue leftColumn))
        (warmRobinFigure4TransportInput slot rightColumn coefficientColumn
          (warmRobinFigure4IndicatorValue rightColumn)) =
      if leftColumn = rightColumn then
        ComplexLCU.amplitudeRotation
          (((warmRobinFigure4SourceCoefficient slot rightColumn : Rat) : Real))
          coefficientRow coefficientColumn
      else 0 := by
  by_cases equal : leftColumn = rightColumn
  · subst leftColumn
    simp only [if_pos rfl]
    rw [warmRobinFigure4DerivativeLoaderProgram_eval]
    unfold controlledRyBlockMatrix
    rw [← _root_.Matrix.reindexAlgEquiv_mul,
      ← _root_.Matrix.blockDiagonal_mul]
    have contextsEqual :=
      warmRobinFigure4TransportInput_splitCoefficient_context slot rightColumn
        coefficientRow coefficientColumn
        (warmRobinFigure4IndicatorValue rightColumn)
    simp only [_root_.Matrix.reindexAlgEquiv_apply,
      _root_.Matrix.reindex_apply, _root_.Matrix.submatrix_apply,
      Equiv.symm_symm, _root_.Matrix.blockDiagonal_apply,
      contextsEqual, if_pos,
      warmRobinFigure4BulkAssignment_transportInput,
      warmRobinFigure4BoundaryAssignment_transportInput]
    rw [warmRobinFigure4BulkLoaderRy, warmRobinFigure4BoundaryLoaderRy]
    simp only [warmRobinFigure4BulkControlInput_indicator,
      warmRobinFigure4BoundaryControlInput_indicator,
      warmRobinFigure4BulkControlSlot_input,
      warmRobinFigure4BoundaryControlSlot_input,
      warmRobinFigure4BoundaryControlColumn_input,
      warmRobinFigure4TransportInput_splitCoefficient_fst]
    by_cases bulk : warmRobinFigure4TransposeBulk rightColumn
    · simp [warmRobinFigure4IndicatorValue, bulk,
        warmRobinFigure4SourceCoefficient_branch]
    · simp [warmRobinFigure4IndicatorValue, bulk]
  · simp only [equal, if_neg]
    rw [warmRobinFigure4DerivativeLoaderProgram_eval]
    unfold controlledRyBlockMatrix
    rw [← _root_.Matrix.reindexAlgEquiv_mul,
      ← _root_.Matrix.blockDiagonal_mul]
    have contextsDifferent :
        (splitPrimitiveWire (6 : Fin 9)
          (warmRobinFigure4TransportInput slot leftColumn coefficientRow
            (warmRobinFigure4IndicatorValue leftColumn))).2 ≠
        (splitPrimitiveWire (6 : Fin 9)
          (warmRobinFigure4TransportInput slot rightColumn coefficientColumn
            (warmRobinFigure4IndicatorValue rightColumn))).2 := by
      intro contextsEqual
      exact equal
        ((warmRobinFigure4TransportInput_splitCoefficient_context_iff
          slot slot leftColumn rightColumn coefficientRow coefficientColumn
          (warmRobinFigure4IndicatorValue leftColumn)
          (warmRobinFigure4IndicatorValue rightColumn)).mp contextsEqual).2.1
    simp only [_root_.Matrix.reindexAlgEquiv_apply,
      _root_.Matrix.reindex_apply, _root_.Matrix.submatrix_apply,
      Equiv.symm_symm, _root_.Matrix.blockDiagonal_apply,
      contextsDifferent, if_neg, if_false]

noncomputable def warmRobinFigure4FullRegisterSwapPrimitiveProgram :
    PrimitiveProgram 9 :=
  compileReversibleProgram warmRobinFigure4RegisterSwapReversibleProgram

theorem warmRobinFigure4RegisterSwapProgram_eval_full :
    evalPrimitiveProgram warmRobinFigure4FullRegisterSwapPrimitiveProgram =
      ComplexLCU.equivPermutationMatrix
        warmRobinFigure4RegisterSwapFullBasisEquiv :=
  compileReversibleProgram_eval _

/-- The homogeneous `f=1` stage is constant-folded to the exact identity. -/
def warmRobinFigure4HomogeneousProgram : PrimitiveProgram 9 :=
  PrimitiveProgram.identity 9

theorem warmRobinFigure4HomogeneousProgram_eval :
    evalPrimitiveProgram warmRobinFigure4HomogeneousProgram = 1 := by
  exact evalPrimitiveProgram_identity 9

noncomputable def warmRobinFigure4PostLoaderProgram : PrimitiveProgram 9 :=
  PrimitiveProgram.seq warmRobinFigure4DTSparseAccessProgram
    (PrimitiveProgram.seq warmRobinFigure4DTIndicatorProgram.dagger
      (PrimitiveProgram.seq warmRobinFigure4HomogeneousProgram
        (PrimitiveProgram.seq warmRobinFigure4FullRegisterSwapPrimitiveProgram
          warmRobinFigure4DSparseAccessProgram.dagger)))

def warmRobinFigure4PostLoaderBasisEquiv :
    PrimitiveBasis 9 ≃ PrimitiveBasis 9 :=
  warmRobinFigure4DTSparseAccessBasisEquiv.trans
    (warmRobinFigure4DTIndicatorBasisEquiv.symm.trans
      (warmRobinFigure4RegisterSwapFullBasisEquiv.trans
        warmRobinFigure4DSparseAccessBasisEquiv.symm))

theorem warmRobinFigure4PostLoaderProgram_eval :
    evalPrimitiveProgram warmRobinFigure4PostLoaderProgram =
      ComplexLCU.equivPermutationMatrix
        warmRobinFigure4PostLoaderBasisEquiv := by
  unfold warmRobinFigure4PostLoaderProgram
  rw [evalPrimitiveProgram_seq, evalPrimitiveProgram_seq,
    evalPrimitiveProgram_seq, evalPrimitiveProgram_seq,
    evalPrimitiveProgram_dagger, evalPrimitiveProgram_dagger,
    warmRobinFigure4DTSparseAccessProgram_eval,
    warmRobinFigure4DTIndicatorProgram_eval,
    warmRobinFigure4HomogeneousProgram_eval,
    warmRobinFigure4RegisterSwapProgram_eval_full,
    warmRobinFigure4DSparseAccessProgram_eval,
    star_equivPermutationMatrix, star_equivPermutationMatrix]
  simp only [_root_.Matrix.mul_one]
  rw [ComplexLCU.equivPermutationMatrix_mul,
    ComplexLCU.equivPermutationMatrix_mul,
    ComplexLCU.equivPermutationMatrix_mul]
  rfl

/-- The post-loader basis permutation restores both work wires and the
physical selector, while transporting the selected source row into the system
register. -/
theorem warmRobinFigure4PostLoader_cleanAction
    (slot column : Fin 8) (coefficient : Fin 2) :
    warmRobinFigure4PostLoaderBasisEquiv
        (warmRobinFigure4TransportInput slot column coefficient
        (warmRobinFigure4IndicatorValue column)) =
      warmRobinFigure4TransportInput slot
        (warmRobinSourceDTRow slot column) coefficient 0 := by
  rw [warmRobinFigure4PostLoaderBasisEquiv]
  simp only [Equiv.trans_apply]
  rw [warmRobinFigure4DTSparseAccess_transportInput]
  have indicatorForward :=
    warmRobinFigure4IndicatorBasisEquiv_clean
      (warmRobinSourceDTRow slot column) column coefficient
  have indicatorCleanup :
      warmRobinFigure4DTIndicatorBasisEquiv.symm
          (warmRobinFigure4TransportInput
            (warmRobinSourceDTRow slot column) column coefficient
            (warmRobinFigure4IndicatorValue column)) =
        warmRobinFigure4TransportInput
          (warmRobinSourceDTRow slot column) column coefficient 0 := by
    rw [← indicatorForward, Equiv.symm_apply_apply]
  rw [indicatorCleanup]
  rw [warmRobinFigure4RegisterSwap_transportInput]
  let sourceRow := warmRobinSourceDTRow slot column
  have dForward :
      warmRobinFigure4DSparseAccessBasisEquiv
          (warmRobinFigure4TransportInput slot sourceRow coefficient 0) =
        warmRobinFigure4TransportInput column sourceRow coefficient 0 := by
    rw [warmRobinFigure4DSparseAccess_transportInput]
    rw [show
      (⟨(sourceRow.val + (warmRobinFigure4DOffset slot).val) % 8,
        Nat.mod_lt _ (by decide)⟩ : Fin 8) = column by
          exact warmRobinFigure4DOffset_after_DT slot column]
  rw [← dForward, Equiv.symm_apply_apply]

def warmRobinFigure4SourceDTColumn (slot row : Fin 8) : Fin 8 :=
  ⟨(row.val + 8 - (warmRobinSourceDTOffset slot).val) % 8,
    Nat.mod_lt _ (by decide)⟩

theorem warmRobinFigure4SourceDTColumn_inverse
    (slot row : Fin 8) :
    warmRobinSourceDTRow slot (warmRobinFigure4SourceDTColumn slot row) = row := by
  fin_cases slot <;> fin_cases row <;> native_decide

theorem warmRobinFigure4SourceDTColumn_eq_iff
    (slot row column : Fin 8) :
    warmRobinFigure4SourceDTColumn slot row = column ↔
      warmRobinSourceDTRow slot column = row := by
  fin_cases slot <;> fin_cases row <;> fin_cases column <;> native_decide

theorem warmRobinFigure4PostLoader_inverseCleanAction
    (slot row : Fin 8) (coefficient : Fin 2) :
    warmRobinFigure4PostLoaderBasisEquiv.symm
        (warmRobinFigure4TransportInput slot row coefficient 0) =
      warmRobinFigure4TransportInput slot
        (warmRobinFigure4SourceDTColumn slot row) coefficient
        (warmRobinFigure4IndicatorValue
          (warmRobinFigure4SourceDTColumn slot row)) := by
  apply warmRobinFigure4PostLoaderBasisEquiv.injective
  rw [Equiv.apply_symm_apply, warmRobinFigure4PostLoader_cleanAction,
    warmRobinFigure4SourceDTColumn_inverse]

noncomputable def warmRobinFigure4MiddleProgram : PrimitiveProgram 9 :=
  PrimitiveProgram.seq warmRobinFigure4DTIndicatorProgram
    (PrimitiveProgram.seq warmRobinFigure4DerivativeLoaderProgram
      warmRobinFigure4PostLoaderProgram)

theorem warmRobinFigure4MiddleProgram_eval :
    evalPrimitiveProgram warmRobinFigure4MiddleProgram =
      ComplexLCU.equivPermutationMatrix warmRobinFigure4PostLoaderBasisEquiv *
        evalPrimitiveProgram warmRobinFigure4DerivativeLoaderProgram *
        ComplexLCU.equivPermutationMatrix
          warmRobinFigure4DTIndicatorBasisEquiv := by
  unfold warmRobinFigure4MiddleProgram
  rw [evalPrimitiveProgram_seq, evalPrimitiveProgram_seq,
    warmRobinFigure4DTIndicatorProgram_eval,
    warmRobinFigure4PostLoaderProgram_eval]

theorem warmRobinFigure4MiddleProgram_cleanEntry
    (coefficientRow coefficientColumn : Fin 2)
    (slot row column : Fin 8) :
    evalPrimitiveProgram warmRobinFigure4MiddleProgram
        (warmRobinFigure4TransportInput slot row coefficientRow 0)
        (warmRobinFigure4TransportInput slot column coefficientColumn 0) =
      if warmRobinSourceDTRow slot column = row then
        ComplexLCU.amplitudeRotation
          (((warmRobinFigure4SourceCoefficient slot column : Rat) : Real))
          coefficientRow coefficientColumn
      else 0 := by
  rw [warmRobinFigure4MiddleProgram_eval]
  rw [ComplexLCU.mul_equivPermutationMatrix_apply,
    ComplexLCU.equivPermutationMatrix_mul_apply]
  rw [warmRobinFigure4IndicatorBasisEquiv_clean]
  rw [warmRobinFigure4PostLoader_inverseCleanAction,
    warmRobinFigure4DerivativeLoader_entry]
  simp only [warmRobinFigure4SourceDTColumn_eq_iff]

/-! Named chronological stage roots used by the generated documentation. -/

noncomputable def warmRobinFigure4ThroughIndicator : PrimitiveProgram 9 :=
  PrimitiveProgram.seq warmRobinFigure4SelectorPrepareProgram
    warmRobinFigure4DTIndicatorProgram

theorem warmRobinFigure4_after_indicator :
    evalPrimitiveProgram warmRobinFigure4ThroughIndicator =
      evalPrimitiveProgram warmRobinFigure4DTIndicatorProgram *
        evalPrimitiveProgram warmRobinFigure4SelectorPrepareProgram := by
  exact evalPrimitiveProgram_seq _ _

noncomputable def warmRobinFigure4ThroughDerivative : PrimitiveProgram 9 :=
  PrimitiveProgram.seq warmRobinFigure4ThroughIndicator
    warmRobinFigure4DerivativeLoaderProgram

theorem warmRobinFigure4_after_derivative_loader :
    evalPrimitiveProgram warmRobinFigure4ThroughDerivative =
      evalPrimitiveProgram warmRobinFigure4DerivativeLoaderProgram *
        evalPrimitiveProgram warmRobinFigure4ThroughIndicator := by
  exact evalPrimitiveProgram_seq _ _

noncomputable def warmRobinFigure4ThroughDTAccess : PrimitiveProgram 9 :=
  PrimitiveProgram.seq warmRobinFigure4ThroughDerivative
    warmRobinFigure4DTSparseAccessProgram

theorem warmRobinFigure4_after_DT_sparse_access :
    evalPrimitiveProgram warmRobinFigure4ThroughDTAccess =
      evalPrimitiveProgram warmRobinFigure4DTSparseAccessProgram *
        evalPrimitiveProgram warmRobinFigure4ThroughDerivative := by
  exact evalPrimitiveProgram_seq _ _

noncomputable def warmRobinFigure4ThroughIndicatorCleanup : PrimitiveProgram 9 :=
  PrimitiveProgram.seq warmRobinFigure4ThroughDTAccess
    warmRobinFigure4DTIndicatorProgram.dagger

theorem warmRobinFigure4_after_indicator_cleanup :
    evalPrimitiveProgram warmRobinFigure4ThroughIndicatorCleanup =
      evalPrimitiveProgram warmRobinFigure4DTIndicatorProgram.dagger *
        evalPrimitiveProgram warmRobinFigure4ThroughDTAccess := by
  exact evalPrimitiveProgram_seq _ _

noncomputable def warmRobinFigure4ThroughSwap : PrimitiveProgram 9 :=
  PrimitiveProgram.seq warmRobinFigure4ThroughIndicatorCleanup
    warmRobinFigure4FullRegisterSwapPrimitiveProgram

theorem warmRobinFigure4_after_swap :
    evalPrimitiveProgram warmRobinFigure4ThroughSwap =
      evalPrimitiveProgram warmRobinFigure4FullRegisterSwapPrimitiveProgram *
        evalPrimitiveProgram warmRobinFigure4ThroughIndicatorCleanup := by
  exact evalPrimitiveProgram_seq _ _

noncomputable def warmRobinFigure4ThroughTransportedCleanup : PrimitiveProgram 9 :=
  PrimitiveProgram.seq warmRobinFigure4ThroughSwap
    warmRobinFigure4DSparseAccessProgram.dagger

theorem warmRobinFigure4_after_transported_cleanup :
    evalPrimitiveProgram warmRobinFigure4ThroughTransportedCleanup =
      evalPrimitiveProgram warmRobinFigure4DSparseAccessProgram.dagger *
        evalPrimitiveProgram warmRobinFigure4ThroughSwap := by
  exact evalPrimitiveProgram_seq _ _

end QuantumBlockEncoding.Robin

import QuantumBlockEncoding.Robin.Figure4Primitive

/-!
# Exact fixed-N8 Figure-4 derivative loaders

Bulk and boundary branches are compiled separately.  They are disjoint after
the certified D-transpose indicator, so their chronological product realizes
one source coefficient without introducing a handwritten controlled oracle.
-/

namespace QuantumBlockEncoding.Robin

noncomputable def warmRobinPaperLiteralBoundaryAngle
    (coefficient : Rat) : Real :=
  Real.arccos (coefficient : Real)

noncomputable def warmRobinExecutableStandardRyBoundaryAngle
    (coefficient : Rat) : Real :=
  2 * Real.arccos (coefficient : Real)

theorem warmRobinBoundaryAngle_zero_guard :
    warmRobinPaperLiteralBoundaryAngle 0 = Real.pi / 2 ∧
      warmRobinExecutableStandardRyBoundaryAngle 0 = Real.pi := by
  constructor
  · simp [warmRobinPaperLiteralBoundaryAngle, Real.arccos_zero]
  · simp [warmRobinExecutableStandardRyBoundaryAngle, Real.arccos_zero]
    ring

theorem warmRobinFigure4BulkCoefficient_abs_le_one (slot : Fin 8) :
    |((warmRobinFigure4BulkCoefficient slot : Rat) : Real)| ≤ 1 := by
  have rationalBound : |warmRobinFigure4BulkCoefficient slot| ≤ (1 : Rat) := by
    fin_cases slot <;> native_decide
  exact_mod_cast rationalBound

theorem warmRobinFigure4SourceCoefficient_abs_le_one
    (slot column : Fin 8) :
    |((warmRobinFigure4SourceCoefficient slot column : Rat) : Real)| ≤ 1 := by
  have rationalBound :
      |warmRobinFigure4SourceCoefficient slot column| ≤ (1 : Rat) := by
    fin_cases slot <;> fin_cases column <;> native_decide
  exact_mod_cast rationalBound

def warmRobinFigure4BulkControlWires : Fin 4 → Fin 9
  | 0 => 0
  | 1 => 1
  | 2 => 2
  | _ => 7

theorem warmRobinFigure4BulkControlWires_ne_target
    (wire : Fin 4) :
    warmRobinFigure4BulkControlWires wire ≠ (6 : Fin 9) := by
  fin_cases wire <;> decide

def warmRobinFigure4BulkControlSlot (bits : PrimitiveBasis 4) : Fin 8 :=
  ⟨(bits 0).val + 2 * (bits 1).val + 4 * (bits 2).val, by omega⟩

noncomputable def warmRobinFigure4BulkLoaderAngle
    (bits : PrimitiveBasis 4) : ExactAngle :=
  if bits 3 = 1 then
    .twiceArccosRational
      (warmRobinFigure4BulkCoefficient
        (warmRobinFigure4BulkControlSlot bits))
      (warmRobinFigure4BulkCoefficient_abs_le_one _)
  else .rational 0

theorem warmRobinFigure4BulkLoaderRy
    (bits : PrimitiveBasis 4) :
    standardRyMatrix (warmRobinFigure4BulkLoaderAngle bits).eval =
      if bits 3 = 1 then
        ComplexLCU.amplitudeRotation
          (((warmRobinFigure4BulkCoefficient
            (warmRobinFigure4BulkControlSlot bits) : Rat) : Real))
      else 1 := by
  by_cases active : bits 3 = 1
  · simp only [warmRobinFigure4BulkLoaderAngle, active, if_pos,
      ExactAngle.eval]
    have bounded := abs_le.mp
      (warmRobinFigure4BulkCoefficient_abs_le_one
        (warmRobinFigure4BulkControlSlot bits))
    exact standardRyMatrix_two_arccos_eq_amplitudeRotation _
      bounded.1 bounded.2
  · have angleZero : warmRobinFigure4BulkLoaderAngle bits = .rational 0 := by
      simp [warmRobinFigure4BulkLoaderAngle, active]
    rw [angleZero]
    simp only [ExactAngle.eval, if_neg active]
    simpa using standardRyMatrix_zero

noncomputable def warmRobinFigure4BulkLoaderCircuit : PrimitiveCircuit 9 :=
  compileUniformlyControlledRy 4 warmRobinFigure4BulkControlWires 6
    warmRobinFigure4BulkControlWires_ne_target
    warmRobinFigure4BulkLoaderAngle

noncomputable def warmRobinFigure4BulkLoaderProgram : PrimitiveProgram 9 where
  circuit := warmRobinFigure4BulkLoaderCircuit
  globalPhase := .rational 0

theorem warmRobinFigure4BulkLoaderProgram_eval :
    evalPrimitiveProgram warmRobinFigure4BulkLoaderProgram =
      controlledRyBlockMatrix warmRobinFigure4BulkControlWires 6
        warmRobinFigure4BulkControlWires_ne_target
        warmRobinFigure4BulkLoaderAngle := by
  change evalGlobalPhase (.rational 0) •
      evalPrimitiveCircuit warmRobinFigure4BulkLoaderCircuit = _
  have phaseZero : evalGlobalPhase (.rational 0) = 1 := by
    simp [evalGlobalPhase, ExactAngle.eval]
  rw [phaseZero, one_smul]
  unfold warmRobinFigure4BulkLoaderCircuit
  exact compileUniformlyControlledRy_eval_controlledRyBlockMatrix _ _ _ _

def warmRobinFigure4BoundaryControlWires : Fin 7 → Fin 9
  | 0 => 0
  | 1 => 1
  | 2 => 2
  | 3 => 3
  | 4 => 4
  | 5 => 5
  | _ => 7

theorem warmRobinFigure4BoundaryControlWires_ne_target
    (wire : Fin 7) :
    warmRobinFigure4BoundaryControlWires wire ≠ (6 : Fin 9) := by
  fin_cases wire <;> decide

def warmRobinFigure4BoundaryControlSlot (bits : PrimitiveBasis 7) : Fin 8 :=
  ⟨(bits 0).val + 2 * (bits 1).val + 4 * (bits 2).val, by omega⟩

def warmRobinFigure4BoundaryControlColumn (bits : PrimitiveBasis 7) : Fin 8 :=
  ⟨(bits 3).val + 2 * (bits 4).val + 4 * (bits 5).val, by omega⟩

noncomputable def warmRobinFigure4BoundaryLoaderAngle
    (bits : PrimitiveBasis 7) : ExactAngle :=
  if bits 6 = 0 ∧
      ¬ warmRobinFigure4TransposeBulk
        (warmRobinFigure4BoundaryControlColumn bits) then
    .twiceArccosRational
      (warmRobinFigure4SourceCoefficient
        (warmRobinFigure4BoundaryControlSlot bits)
        (warmRobinFigure4BoundaryControlColumn bits))
      (warmRobinFigure4SourceCoefficient_abs_le_one _ _)
  else .rational 0

theorem warmRobinFigure4BoundaryLoaderRy
    (bits : PrimitiveBasis 7) :
    standardRyMatrix (warmRobinFigure4BoundaryLoaderAngle bits).eval =
      if bits 6 = 0 ∧
          ¬ warmRobinFigure4TransposeBulk
            (warmRobinFigure4BoundaryControlColumn bits) then
        ComplexLCU.amplitudeRotation
          (((warmRobinFigure4SourceCoefficient
            (warmRobinFigure4BoundaryControlSlot bits)
            (warmRobinFigure4BoundaryControlColumn bits) : Rat) : Real))
      else 1 := by
  by_cases active : bits 6 = 0 ∧
      ¬ warmRobinFigure4TransposeBulk
        (warmRobinFigure4BoundaryControlColumn bits)
  · simp only [warmRobinFigure4BoundaryLoaderAngle, active, if_pos,
      ExactAngle.eval]
    have bounded := abs_le.mp
      (warmRobinFigure4SourceCoefficient_abs_le_one
        (warmRobinFigure4BoundaryControlSlot bits)
        (warmRobinFigure4BoundaryControlColumn bits))
    exact standardRyMatrix_two_arccos_eq_amplitudeRotation _
      bounded.1 bounded.2
  · have angleZero : warmRobinFigure4BoundaryLoaderAngle bits = .rational 0 := by
      simp [warmRobinFigure4BoundaryLoaderAngle, active]
    rw [angleZero]
    simp only [ExactAngle.eval, if_neg active]
    simpa using standardRyMatrix_zero

noncomputable def warmRobinFigure4BoundaryLoaderCircuit : PrimitiveCircuit 9 :=
  compileUniformlyControlledRy 7 warmRobinFigure4BoundaryControlWires 6
    warmRobinFigure4BoundaryControlWires_ne_target
    warmRobinFigure4BoundaryLoaderAngle

noncomputable def warmRobinFigure4BoundaryLoaderProgram : PrimitiveProgram 9 where
  circuit := warmRobinFigure4BoundaryLoaderCircuit
  globalPhase := .rational 0

theorem warmRobinFigure4BoundaryLoaderProgram_eval :
    evalPrimitiveProgram warmRobinFigure4BoundaryLoaderProgram =
      controlledRyBlockMatrix warmRobinFigure4BoundaryControlWires 6
        warmRobinFigure4BoundaryControlWires_ne_target
        warmRobinFigure4BoundaryLoaderAngle := by
  change evalGlobalPhase (.rational 0) •
      evalPrimitiveCircuit warmRobinFigure4BoundaryLoaderCircuit = _
  have phaseZero : evalGlobalPhase (.rational 0) = 1 := by
    simp [evalGlobalPhase, ExactAngle.eval]
  rw [phaseZero, one_smul]
  unfold warmRobinFigure4BoundaryLoaderCircuit
  exact compileUniformlyControlledRy_eval_controlledRyBlockMatrix _ _ _ _

noncomputable def warmRobinFigure4DerivativeLoaderProgram : PrimitiveProgram 9 :=
  PrimitiveProgram.seq warmRobinFigure4BulkLoaderProgram
    warmRobinFigure4BoundaryLoaderProgram

theorem warmRobinFigure4DerivativeLoaderProgram_eval :
    evalPrimitiveProgram warmRobinFigure4DerivativeLoaderProgram =
      controlledRyBlockMatrix warmRobinFigure4BoundaryControlWires 6
          warmRobinFigure4BoundaryControlWires_ne_target
          warmRobinFigure4BoundaryLoaderAngle *
        controlledRyBlockMatrix warmRobinFigure4BulkControlWires 6
          warmRobinFigure4BulkControlWires_ne_target
          warmRobinFigure4BulkLoaderAngle := by
  rw [warmRobinFigure4DerivativeLoaderProgram,
    evalPrimitiveProgram_seq,
    warmRobinFigure4BulkLoaderProgram_eval,
    warmRobinFigure4BoundaryLoaderProgram_eval]

def warmRobinFigure4IndicatorValue (column : Fin 8) : Fin 2 :=
  if warmRobinFigure4TransposeBulk column then 1 else 0

def warmRobinFigure4BulkControlInput
    (slot : Fin 8) (indicator : Fin 2) : PrimitiveBasis 4
  | ⟨0, _⟩ => primitiveBits3LE slot 0
  | ⟨1, _⟩ => primitiveBits3LE slot 1
  | ⟨2, _⟩ => primitiveBits3LE slot 2
  | _ => indicator

def warmRobinFigure4BoundaryControlInput
    (slot column : Fin 8) (indicator : Fin 2) : PrimitiveBasis 7
  | ⟨0, _⟩ => primitiveBits3LE slot 0
  | ⟨1, _⟩ => primitiveBits3LE slot 1
  | ⟨2, _⟩ => primitiveBits3LE slot 2
  | ⟨3, _⟩ => primitiveBits3LE column 0
  | ⟨4, _⟩ => primitiveBits3LE column 1
  | ⟨5, _⟩ => primitiveBits3LE column 2
  | _ => indicator

@[simp] theorem warmRobinFigure4BulkControlSlot_input
    (slot : Fin 8) (indicator : Fin 2) :
    warmRobinFigure4BulkControlSlot
      (warmRobinFigure4BulkControlInput slot indicator) = slot := by
  native_decide +revert

@[simp] theorem warmRobinFigure4BulkControlInput_indicator
    (slot : Fin 8) (indicator : Fin 2) :
    warmRobinFigure4BulkControlInput slot indicator 3 = indicator := by
  rfl

@[simp] theorem warmRobinFigure4BoundaryControlSlot_input
    (slot column : Fin 8) (indicator : Fin 2) :
    warmRobinFigure4BoundaryControlSlot
      (warmRobinFigure4BoundaryControlInput slot column indicator) = slot := by
  native_decide +revert

@[simp] theorem warmRobinFigure4BoundaryControlColumn_input
    (slot column : Fin 8) (indicator : Fin 2) :
    warmRobinFigure4BoundaryControlColumn
      (warmRobinFigure4BoundaryControlInput slot column indicator) = column := by
  native_decide +revert

@[simp] theorem warmRobinFigure4BoundaryControlInput_indicator
    (slot column : Fin 8) (indicator : Fin 2) :
    warmRobinFigure4BoundaryControlInput slot column indicator 6 = indicator := by
  rfl

theorem warmRobinFigure4DerivativeLoader_cleanEntry
    (slot column : Fin 8) :
    let indicator := warmRobinFigure4IndicatorValue column
    let bulk := standardRyMatrix
      (warmRobinFigure4BulkLoaderAngle
        (warmRobinFigure4BulkControlInput slot indicator)).eval
    let boundary := standardRyMatrix
      (warmRobinFigure4BoundaryLoaderAngle
        (warmRobinFigure4BoundaryControlInput slot column indicator)).eval
    (boundary * bulk) 0 0 =
      ((warmRobinFigure4SourceCoefficient slot column : Rat) : ℂ) := by
  dsimp only
  rw [warmRobinFigure4BulkLoaderRy, warmRobinFigure4BoundaryLoaderRy]
  simp only [warmRobinFigure4BulkControlInput_indicator,
    warmRobinFigure4BoundaryControlInput_indicator,
    warmRobinFigure4BulkControlSlot_input,
    warmRobinFigure4BoundaryControlSlot_input,
    warmRobinFigure4BoundaryControlColumn_input]
  by_cases isBulk : warmRobinFigure4TransposeBulk column
  · simp [warmRobinFigure4IndicatorValue, isBulk]
    have bounded := abs_le.mp
      (warmRobinFigure4BulkCoefficient_abs_le_one slot)
    rw [ComplexLCU.amplitudeRotation_cleanEntry _ bounded.1 bounded.2,
      warmRobinFigure4SourceCoefficient_branch]
    simp [isBulk]
  · simp [warmRobinFigure4IndicatorValue, isBulk]
    have bounded := abs_le.mp
      (warmRobinFigure4SourceCoefficient_abs_le_one slot column)
    rw [ComplexLCU.amplitudeRotation_cleanEntry _ bounded.1 bounded.2]
    norm_num

end QuantumBlockEncoding.Robin

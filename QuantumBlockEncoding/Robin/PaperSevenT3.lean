import QuantumBlockEncoding.Robin.PaperSevenPreparePrimitive

/-!
# Complete paper-seven T3 certificate

This module composes the exact PREPARE, coefficient loader, reversible SELECT,
and PREPARE dagger.  The program-level composition retains the exact global
phase introduced when reversible CCX gates are compiled to `{X, RY, RZ, CX}`.
-/

namespace QuantumBlockEncoding.Robin

noncomputable def warmRobinPaperSevenSelectorPrepareProgram :
    PrimitiveProgram 8 where
  circuit := warmRobinPaperSevenSelectorPrepareCircuit
  globalPhase := .rational 0

theorem warmRobinPaperSevenSelectorPrepareProgram_eval :
    evalPrimitiveProgram warmRobinPaperSevenSelectorPrepareProgram =
      _root_.Matrix.reindexAlgEquiv ℂ ℂ
        warmRobinPaperSevenBitsEquiv.symm
        (ComplexLCU.selectorLift (coefficient := Fin 2)
          (system := WarmRobinPaperSevenFullSystem)
          warmRobinPaperSevenSelectorPrepare) := by
  change evalGlobalPhase (.rational 0) •
      evalPrimitiveCircuit warmRobinPaperSevenSelectorPrepareCircuit = _
  have phaseZero : evalGlobalPhase (.rational 0) = 1 := by
    simp [evalGlobalPhase, ExactAngle.eval]
  rw [phaseZero, one_smul]
  exact warmRobinPaperSevenSelectorPrepareCircuit_eval

/-- Chronological exact primitive source program. -/
noncomputable def warmRobinPaperSevenPrimitiveProgram : PrimitiveProgram 8 :=
  PrimitiveProgram.seq warmRobinPaperSevenSelectorPrepareProgram
    (PrimitiveProgram.seq warmRobinPaperSevenAmplitudeProgram
      (PrimitiveProgram.seq warmRobinPaperSevenSelectProgram
        warmRobinPaperSevenSelectorPrepareProgram.dagger))

/-- Required T3 semantic root.  Equality includes the exact accumulated global
phase and uses the actual reversible extension on dirty `q7`. -/
theorem warmRobinPaperSevenPrimitive_eval_eq_logical :
    evalPrimitiveProgram warmRobinPaperSevenPrimitiveProgram =
      _root_.Matrix.reindexAlgEquiv ℂ ℂ
        warmRobinPaperSevenBitsEquiv.symm
        warmRobinPaperSevenWorkspaceLogicalUnitary := by
  have starReindex :
      star (_root_.Matrix.reindexAlgEquiv ℂ ℂ
        warmRobinPaperSevenBitsEquiv.symm
        (ComplexLCU.selectorLift (coefficient := Fin 2)
          (system := WarmRobinPaperSevenFullSystem)
          warmRobinPaperSevenSelectorPrepare)) =
      _root_.Matrix.reindexAlgEquiv ℂ ℂ
        warmRobinPaperSevenBitsEquiv.symm
        (star (ComplexLCU.selectorLift (coefficient := Fin 2)
          (system := WarmRobinPaperSevenFullSystem)
          warmRobinPaperSevenSelectorPrepare)) := by
    ext row column
    rfl
  unfold warmRobinPaperSevenPrimitiveProgram
  rw [evalPrimitiveProgram_seq, evalPrimitiveProgram_seq,
    evalPrimitiveProgram_seq, evalPrimitiveProgram_dagger,
    warmRobinPaperSevenSelectorPrepareProgram_eval,
    warmRobinPaperSevenAmplitudeProgram_eval,
    warmRobinPaperSevenSelectProgram_eval_reindexed, starReindex,
    ← _root_.Matrix.reindexAlgEquiv_mul,
    ← _root_.Matrix.reindexAlgEquiv_mul,
    ← _root_.Matrix.reindexAlgEquiv_mul]
  simp [warmRobinPaperSevenWorkspaceLogicalUnitary,
    ComplexLCU.prepareAmplitudeSelectUnprepare, mul_assoc]

@[simp] theorem warmRobinPaperSevenBitsEquiv_encode
    (coefficient : Fin 2) (selector : Fin 8)
    (system : WarmRobinPaperSevenFullSystem) :
    warmRobinPaperSevenBitsEquiv
        (warmRobinPaperSevenEncodeBits coefficient selector system) =
      (coefficient, (selector, system)) := by
  rw [warmRobinPaperSevenBitsEquiv_apply]
  native_decide +revert

/-- Flat eight-qubit unitary used by the operator-first block-encoding API. -/
noncomputable def warmRobinPaperSevenPrimitiveFlatUnitary :
    _root_.Matrix (Fin (gridSize 8)) (Fin (gridSize 8)) ℂ :=
  _root_.Matrix.reindexAlgEquiv ℂ ℂ (primitiveBasisLEEquiv 8)
    (evalPrimitiveProgram warmRobinPaperSevenPrimitiveProgram)

theorem warmRobinPaperSevenPrimitiveFlatUnitary_unitary :
    warmRobinPaperSevenPrimitiveFlatUnitary ∈
      _root_.Matrix.unitaryGroup (Fin (gridSize 8)) ℂ := by
  apply ComplexLCU.reindex_unitary
  exact evalPrimitiveProgram_unitary _

noncomputable def warmRobinPaperSevenPrimitiveCleanIndex
    (system : Fin 8) : Fin (gridSize 8) :=
  primitiveBasisLEEquiv 8
    (warmRobinPaperSevenEncodeBits 0 0 (system, 0))

/-- The physical primitive program has the exact `M/224 = A/(56/3)` clean
block; no numerical matrix comparison is used. -/
theorem warmRobinPaperSevenPrimitive_cleanBlock (row column : Fin 8) :
    warmRobinPaperSevenPrimitiveFlatUnitary
        (warmRobinPaperSevenPrimitiveCleanIndex row)
        (warmRobinPaperSevenPrimitiveCleanIndex column) =
      ((RobinEvolution.warmRobinTarget row column /
        RobinEvolution.warmRobinNormalizer : Rat) : ℂ) := by
  unfold warmRobinPaperSevenPrimitiveFlatUnitary
    warmRobinPaperSevenPrimitiveCleanIndex
  simp only [_root_.Matrix.reindexAlgEquiv_apply,
    _root_.Matrix.reindex_apply, _root_.Matrix.submatrix_apply,
    Equiv.symm_symm, Equiv.symm_apply_apply]
  rw [warmRobinPaperSevenPrimitive_eval_eq_logical]
  simp only [_root_.Matrix.reindexAlgEquiv_apply,
    _root_.Matrix.reindex_apply, _root_.Matrix.submatrix_apply,
    Equiv.symm_symm, warmRobinPaperSevenBitsEquiv_encode]
  rw [warmRobinPaperSevenWorkspaceLogicalUnitary_cleanEntry]
  exact_mod_cast warmRobinSourceSevenCleanFormula_eq_target row column

def warmRobinPaperSevenPrimitiveBlockContainsTarget : Prop :=
  ∀ row column : Fin 8,
    warmRobinPaperSevenPrimitiveFlatUnitary
        (warmRobinPaperSevenPrimitiveCleanIndex row)
        (warmRobinPaperSevenPrimitiveCleanIndex column) =
      warmRobinQueryTarget.operator row column /
        warmRobinQueryTarget.normalizer

theorem warmRobinPaperSevenPrimitiveBlockContainsTarget_proof :
    warmRobinPaperSevenPrimitiveBlockContainsTarget := by
  intro row column
  rw [warmRobinPaperSevenPrimitive_cleanBlock]
  norm_num [warmRobinQueryTarget, warmRobinComplexTarget]

private def PreservesPaperSevenWorkspace
    (operator : _root_.Matrix
      (ComplexLCU.LCUIndex (Fin 2) (Fin 8) WarmRobinPaperSevenFullSystem)
      (ComplexLCU.LCUIndex (Fin 2) (Fin 8) WarmRobinPaperSevenFullSystem) ℂ) :
    Prop :=
  ∀ row column, row.2.2.2 ≠ column.2.2.2 → operator row column = 0

private theorem PreservesPaperSevenWorkspace.mul
    {left right : _root_.Matrix
      (ComplexLCU.LCUIndex (Fin 2) (Fin 8) WarmRobinPaperSevenFullSystem)
      (ComplexLCU.LCUIndex (Fin 2) (Fin 8) WarmRobinPaperSevenFullSystem) ℂ}
    (leftPreserves : PreservesPaperSevenWorkspace left)
    (rightPreserves : PreservesPaperSevenWorkspace right) :
    PreservesPaperSevenWorkspace (left * right) := by
  intro row column different
  rw [_root_.Matrix.mul_apply]
  apply Finset.sum_eq_zero
  intro middle _
  by_cases first : row.2.2.2 = middle.2.2.2
  · have second : middle.2.2.2 ≠ column.2.2.2 := by
      intro equality
      exact different (first.trans equality)
    rw [rightPreserves middle column second]
    simp
  · rw [leftPreserves row middle first]
    simp

private theorem PreservesPaperSevenWorkspace.star
    {operator : _root_.Matrix
      (ComplexLCU.LCUIndex (Fin 2) (Fin 8) WarmRobinPaperSevenFullSystem)
      (ComplexLCU.LCUIndex (Fin 2) (Fin 8) WarmRobinPaperSevenFullSystem) ℂ}
    (preserves : PreservesPaperSevenWorkspace operator) :
    PreservesPaperSevenWorkspace (star operator) := by
  intro row column different
  change (starRingEnd ℂ) (operator column row) = 0
  rw [preserves column row (Ne.symm different)]
  simp

private theorem warmRobinPaperSevenSelectorLift_preservesWorkspace :
    PreservesPaperSevenWorkspace
      (ComplexLCU.selectorLift (coefficient := Fin 2)
        (system := WarmRobinPaperSevenFullSystem)
        warmRobinPaperSevenSelectorPrepare) := by
  intro row column different
  simp only [ComplexLCU.selectorLift,
    _root_.Matrix.kroneckerMap_apply, _root_.Matrix.one_apply]
  have systemDifferent : row.2.2 ≠ column.2.2 := by
    intro equality
    exact different (congrArg Prod.snd equality)
  simp [systemDifferent]

private theorem warmRobinPaperSevenAmplitudeLift_preservesWorkspace :
    PreservesPaperSevenWorkspace
      (ComplexLCU.amplitudeLift warmRobinPaperSevenWorkspaceRotation) := by
  intro row column different
  simp only [ComplexLCU.amplitudeLift,
    _root_.Matrix.blockDiagonal_apply]
  have contextDifferent : row.2 ≠ column.2 := by
    intro equality
    exact different (congrArg (fun value => value.2.2) equality)
  simp [contextDifferent]

theorem warmRobinPaperSevenFullSystemEquiv_workspace
    (slot : Fin 8) (system : WarmRobinPaperSevenFullSystem) :
    (warmRobinPaperSevenFullSystemEquiv slot system).2 = system.2 := by
  rw [warmRobinPaperSevenFullSystemEquiv_apply]
  rfl

private theorem warmRobinPaperSevenSelectLift_preservesWorkspace :
    PreservesPaperSevenWorkspace
      (ComplexLCU.selectLift (coefficient := Fin 2)
        warmRobinPaperSevenFullSystemEquiv) := by
  intro row column different
  unfold ComplexLCU.selectLift ComplexLCU.equivPermutationMatrix
  by_cases selected : row =
      ComplexLCU.controlledSystemEquiv
        warmRobinPaperSevenFullSystemEquiv column
  · have workspaceEqual : row.2.2.2 = column.2.2.2 := by
      rw [selected]
      exact warmRobinPaperSevenFullSystemEquiv_workspace _ _
    exact (different workspaceEqual).elim
  · simp [selected]

private theorem warmRobinPaperSevenWorkspaceLogicalUnitary_preservesWorkspace :
    PreservesPaperSevenWorkspace
      warmRobinPaperSevenWorkspaceLogicalUnitary := by
  unfold warmRobinPaperSevenWorkspaceLogicalUnitary
    ComplexLCU.prepareAmplitudeSelectUnprepare
  exact (PreservesPaperSevenWorkspace.star
    warmRobinPaperSevenSelectorLift_preservesWorkspace).mul
      (warmRobinPaperSevenSelectLift_preservesWorkspace.mul
        (warmRobinPaperSevenAmplitudeLift_preservesWorkspace.mul
          warmRobinPaperSevenSelectorLift_preservesWorkspace))

/-- Matrix-level workspace restoration: a clean input column has no amplitude
on a dirty workspace output row. -/
theorem warmRobinPaperSevenPrimitive_workspaceClean
    (row column : PrimitiveBasis 8)
    (columnClean : column 7 = 0) (rowDirty : row 7 ≠ 0) :
    evalPrimitiveProgram warmRobinPaperSevenPrimitiveProgram row column = 0 := by
  rw [warmRobinPaperSevenPrimitive_eval_eq_logical]
  simp only [_root_.Matrix.reindexAlgEquiv_apply,
    _root_.Matrix.reindex_apply, _root_.Matrix.submatrix_apply,
    Equiv.symm_symm, warmRobinPaperSevenBitsEquiv_apply,
    warmRobinPaperSevenBitsIndex]
  apply warmRobinPaperSevenWorkspaceLogicalUnitary_preservesWorkspace
  simpa [columnClean] using rowDirty

noncomputable def warmRobinPaperSevenPrimitivePresentation : Circuit :=
  warmRobinPaperSevenPrimitiveProgram.circuit.map fun gate =>
    match gate with
    | .x target => .oneQubit "X" target.val
    | .ry target _ => .rotationY target.val "exact-angle"
    | .rz target _ => .rotationZ target.val "exact-angle"
    | .cx control target _ => .cnot control.val target.val

noncomputable def warmRobinPaperSevenPrimitiveResource : Resource :=
  warmRobinPaperSevenPrimitiveProgram.resource

theorem warmRobinPaperSevenPrimitive_resource_faithful :
    warmRobinPaperSevenPrimitiveResource =
      warmRobinPaperSevenPrimitiveProgram.circuit.resource := rfl

noncomputable def warmRobinPaperSevenPrimitiveOperatorCandidate :
    OperatorBlockEncodingCandidate ℂ 3 where
  auxiliaryQubits := 5
  target := warmRobinQueryTarget
  unitary := warmRobinPaperSevenPrimitiveFlatUnitary
  layout := {
    systemQubits := 3
    signalQubits := 4
    pureAncillas := 1
  }
  circuit := warmRobinPaperSevenPrimitivePresentation
  resource := warmRobinPaperSevenPrimitiveResource
  layoutMatches := by decide
  isUnitary := warmRobinPaperSevenPrimitiveFlatUnitary ∈
    _root_.Matrix.unitaryGroup (Fin (gridSize 8)) ℂ
  blockContainsTarget := warmRobinPaperSevenPrimitiveBlockContainsTarget

noncomputable def warmRobinPaperSevenPrimitiveRefinement :
    PrimitiveProgramRefinement 8 where
  program := warmRobinPaperSevenPrimitiveProgram
  target := _root_.Matrix.reindexAlgEquiv ℂ ℂ
    warmRobinPaperSevenBitsEquiv.symm
    warmRobinPaperSevenWorkspaceLogicalUnitary
  exact := warmRobinPaperSevenPrimitive_eval_eq_logical

/-- Exact primitive verified block encoding for the paper-seven source route. -/
noncomputable def warmRobinPaperSevenPrimitiveVerifiedBlockEncoding :
    VerifiedOperatorBlockEncoding ℂ 3 where
  candidate := warmRobinPaperSevenPrimitiveOperatorCandidate
  unitaryProof := warmRobinPaperSevenPrimitiveFlatUnitary_unitary
  blockProof := warmRobinPaperSevenPrimitiveBlockContainsTarget_proof

end QuantumBlockEncoding.Robin

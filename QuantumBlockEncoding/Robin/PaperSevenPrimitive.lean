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

abbrev WarmRobinPaperSevenFullSystem := Fin 8 × Fin 2

/-- Encode the declared register product into the physical wire order. -/
def warmRobinPaperSevenEncodeBits
    (coefficient : Fin 2) (selector : Fin 8)
    (system : WarmRobinPaperSevenFullSystem) : PrimitiveBasis 8
  | ⟨0, _⟩ => primitiveBits3LE system.1 0
  | ⟨1, _⟩ => primitiveBits3LE system.1 1
  | ⟨2, _⟩ => primitiveBits3LE system.1 2
  | ⟨3, _⟩ => primitiveBits3LE selector 0
  | ⟨4, _⟩ => primitiveBits3LE selector 1
  | ⟨5, _⟩ => primitiveBits3LE selector 2
  | ⟨6, _⟩ => coefficient
  | _ => system.2

def warmRobinPaperSevenBitsIndex (bits : PrimitiveBasis 8) :
    ComplexLCU.LCUIndex (Fin 2) (Fin 8) WarmRobinPaperSevenFullSystem :=
  (bits 6, (warmRobinPaperSevenSelectorBits bits,
    (warmRobinPaperSevenSystemBits bits, bits 7)))

theorem warmRobinPaperSevenBitsIndex_bijective :
    Function.Bijective warmRobinPaperSevenBitsIndex := by
  native_decide

noncomputable def warmRobinPaperSevenBitsEquiv :
    PrimitiveBasis 8 ≃
      ComplexLCU.LCUIndex (Fin 2) (Fin 8) WarmRobinPaperSevenFullSystem :=
  Equiv.ofBijective warmRobinPaperSevenBitsIndex
    warmRobinPaperSevenBitsIndex_bijective

@[simp] theorem warmRobinPaperSevenBitsEquiv_apply
    (bits : PrimitiveBasis 8) :
    warmRobinPaperSevenBitsEquiv bits = warmRobinPaperSevenBitsIndex bits := rfl

def warmRobinBitXor (left right : Fin 2) : Fin 2 :=
  ⟨(left.val + right.val) % 2, by omega⟩

def warmRobinBitAnd (left right : Fin 2) : Fin 2 :=
  ⟨(left.val * right.val) % 2, Nat.mod_lt _ (by decide)⟩

/-- Explicit full-space action of the reversible adder.  On dirty workspace
this records the actual extension instead of claiming tensor identity. -/
def warmRobinPaperSevenFullSystemPerm
    (slot : Fin 8) (system : WarmRobinPaperSevenFullSystem) :
    WarmRobinPaperSevenFullSystem :=
  let a := primitiveBits3LE system.1
  let b := primitiveBits3LE (warmRobinSourceDTOffset slot)
  let work1 := warmRobinBitXor system.2 (warmRobinBitAnd (b 0) (a 0))
  let a2First := warmRobinBitXor (a 2) (warmRobinBitAnd work1 (a 1))
  let a1First := warmRobinBitXor (a 1) (warmRobinBitAnd (b 0) (a 0))
  let a0Final := warmRobinBitXor (a 0) (b 0)
  let a2Second := warmRobinBitXor a2First (warmRobinBitAnd (b 1) a1First)
  let a1Final := warmRobinBitXor a1First (b 1)
  let a2Final := warmRobinBitXor a2Second (b 2)
  (⟨a0Final.val + 2 * a1Final.val + 4 * a2Final.val, by omega⟩,
    system.2)

theorem warmRobinPaperSevenFullSystemPerm_bijective (slot : Fin 8) :
    Function.Bijective (warmRobinPaperSevenFullSystemPerm slot) := by
  fin_cases slot <;> native_decide

noncomputable def warmRobinPaperSevenFullSystemEquiv (slot : Fin 8) :
    WarmRobinPaperSevenFullSystem ≃ WarmRobinPaperSevenFullSystem :=
  Equiv.ofBijective (warmRobinPaperSevenFullSystemPerm slot)
    (warmRobinPaperSevenFullSystemPerm_bijective slot)

@[simp] theorem warmRobinPaperSevenFullSystemEquiv_apply
    (slot : Fin 8) (system : WarmRobinPaperSevenFullSystem) :
    warmRobinPaperSevenFullSystemEquiv slot system =
      warmRobinPaperSevenFullSystemPerm slot system := rfl

theorem warmRobinPaperSevenFullSystemEquiv_clean
    (slot column : Fin 8) :
    warmRobinPaperSevenFullSystemEquiv slot (column, 0) =
      (warmRobinSourceDTRow slot column, 0) := by
  rw [warmRobinPaperSevenFullSystemEquiv_apply]
  fin_cases slot <;> fin_cases column <;> native_decide

theorem warmRobinPaperSevenSelectBasisAction_index
    (bits : PrimitiveBasis 8) :
    warmRobinPaperSevenBitsEquiv
        (warmRobinPaperSevenSelectBasisEquiv bits) =
      ComplexLCU.controlledSystemEquiv
        warmRobinPaperSevenFullSystemEquiv
        (warmRobinPaperSevenBitsEquiv bits) := by
  rw [warmRobinPaperSevenBitsEquiv_apply,
    warmRobinPaperSevenBitsEquiv_apply]
  change warmRobinPaperSevenBitsIndex
      (warmRobinPaperSevenSelectBasisEquiv bits) =
    ((warmRobinPaperSevenBitsIndex bits).1,
      ((warmRobinPaperSevenBitsIndex bits).2.1,
        warmRobinPaperSevenFullSystemEquiv
          (warmRobinPaperSevenBitsIndex bits).2.1
          (warmRobinPaperSevenBitsIndex bits).2.2))
  rw [warmRobinPaperSevenFullSystemEquiv_apply]
  native_decide +revert

theorem warmRobinPaperSevenSelectProgram_eval_reindexed :
    evalPrimitiveProgram warmRobinPaperSevenSelectProgram =
      _root_.Matrix.reindexAlgEquiv ℂ ℂ
        warmRobinPaperSevenBitsEquiv.symm
        (ComplexLCU.selectLift (coefficient := Fin 2)
          warmRobinPaperSevenFullSystemEquiv) := by
  rw [warmRobinPaperSevenSelectProgram_eval]
  ext row column
  simp only [ComplexLCU.equivPermutationMatrix,
    ComplexLCU.selectLift, _root_.Matrix.reindexAlgEquiv_apply,
    _root_.Matrix.reindex_apply, _root_.Matrix.submatrix_apply,
    Equiv.symm_symm]
  by_cases selected : row = warmRobinPaperSevenSelectBasisEquiv column
  · rw [if_pos selected, if_pos]
    simpa [selected] using
      warmRobinPaperSevenSelectBasisAction_index column
  · rw [if_neg selected, if_neg]
    intro logicalHit
    apply selected
    apply warmRobinPaperSevenBitsEquiv.injective
    rw [warmRobinPaperSevenSelectBasisAction_index]
    exact logicalHit

noncomputable def warmRobinPaperSevenWorkspaceRotation
    (slot : Fin 8) (system : WarmRobinPaperSevenFullSystem) :
    _root_.Matrix (Fin 2) (Fin 2) ℂ :=
  warmRobinPaperSevenRotation slot system.1

theorem warmRobinPaperSevenWorkspaceRotation_unitary
    (slot : Fin 8) (system : WarmRobinPaperSevenFullSystem) :
    warmRobinPaperSevenWorkspaceRotation slot system ∈
      _root_.Matrix.unitaryGroup (Fin 2) ℂ :=
  warmRobinPaperSevenRotation_unitary _ _

noncomputable def warmRobinPaperSevenWorkspaceLogicalUnitary :
    _root_.Matrix
      (ComplexLCU.LCUIndex (Fin 2) (Fin 8)
        WarmRobinPaperSevenFullSystem)
      (ComplexLCU.LCUIndex (Fin 2) (Fin 8)
        WarmRobinPaperSevenFullSystem) ℂ :=
  ComplexLCU.prepareAmplitudeSelectUnprepare
    warmRobinPaperSevenSelectorPrepare
    warmRobinPaperSevenWorkspaceRotation
    warmRobinPaperSevenFullSystemEquiv

theorem warmRobinPaperSevenWorkspaceLogicalUnitary_unitary :
    warmRobinPaperSevenWorkspaceLogicalUnitary ∈
      _root_.Matrix.unitaryGroup
        (ComplexLCU.LCUIndex (Fin 2) (Fin 8)
          WarmRobinPaperSevenFullSystem) ℂ := by
  apply ComplexLCU.prepareAmplitudeSelectUnprepare_unitary
  · exact warmRobinPaperSevenSelectorPrepare_unitary_flat
  · exact warmRobinPaperSevenWorkspaceRotation_unitary

theorem warmRobinPaperSevenWorkspaceLogicalUnitary_cleanEntry
    (row column : Fin 8) :
    warmRobinPaperSevenWorkspaceLogicalUnitary
        (0, (0, (row, 0))) (0, (0, (column, 0))) =
      (warmRobinSourceSevenCleanFormula row column : ℂ) := by
  unfold warmRobinPaperSevenWorkspaceLogicalUnitary
  rw [ComplexLCU.prepareAmplitudeSelectUnprepare_cleanEntry]
  have castFormula :
      (warmRobinSourceSevenCleanFormula row column : ℂ) =
        ∑ slot : Fin 8,
          if warmRobinSourceDTRow slot column = row then
            ((warmRobinSourceSevenSelectorProbability slot : Rat) : ℂ) *
              ((warmRobinSourceSevenPaddedCoefficient slot column : Rat) : ℂ)
          else 0 := by
    norm_num [warmRobinSourceSevenCleanFormula]
    apply Finset.sum_congr rfl
    intro slot _
    by_cases selected : warmRobinSourceDTRow slot column = row <;>
      simp [selected]
  rw [castFormula]
  apply Finset.sum_congr rfl
  intro slot _
  rw [warmRobinPaperSevenFullSystemEquiv_clean]
  by_cases selected : warmRobinSourceDTRow slot column = row
  · simp only [selected, if_pos]
    unfold warmRobinPaperSevenWorkspaceRotation
    rw [warmRobinPaperSevenRotation_cleanEntry]
    change
      star (warmRobinPaperSevenSelectorPrepare slot 0) *
          (((warmRobinSourceSevenPaddedCoefficient slot column : Rat) : Real) : ℂ) *
          warmRobinPaperSevenSelectorPrepare slot 0 = _
    calc
      star (warmRobinPaperSevenSelectorPrepare slot 0) *
            (((warmRobinSourceSevenPaddedCoefficient slot column : Rat) : Real) : ℂ) *
            warmRobinPaperSevenSelectorPrepare slot 0 =
          (star (warmRobinPaperSevenSelectorPrepare slot 0) *
            warmRobinPaperSevenSelectorPrepare slot 0) *
              (((warmRobinSourceSevenPaddedCoefficient slot column : Rat) : Real) : ℂ) := by ring
      _ = _ := by
        rw [warmRobinUniformSevenPrepare_probability slot]
        by_cases active : slot.val < 7 <;>
          simp [warmRobinSourceSevenSelectorProbability, active]
  · simp [selected]

end QuantumBlockEncoding.Robin

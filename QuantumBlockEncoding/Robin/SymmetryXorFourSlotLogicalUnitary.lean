import QuantumBlockEncoding.Robin.SymmetryFourSlotBlockEncoding
import Mathlib.Data.Nat.Bitwise
import Mathlib.Tactic

/-!
# XOR four-slot Robin logical unitary

This candidate keeps the certified symmetry-sector reduction but replaces the
cyclic SELECT by two-bit XOR.  That choice has the direct primitive realization
`CX(q3,q0); CX(q4,q1)` used by the T3 layer.
-/

namespace QuantumBlockEncoding.Robin

open ComplexLCU

def warmRobinSymmetryXorPerm (slot column : Fin 4) : Fin 4 :=
  ⟨slot.val ^^^ column.val, by
    simpa using Nat.xor_lt_two_pow (n := 2) slot.isLt column.isLt⟩

theorem warmRobinSymmetryXorPerm_bijective (slot : Fin 4) :
    Function.Bijective (warmRobinSymmetryXorPerm slot) := by
  fin_cases slot <;> decide

def warmRobinSymmetrySectorBlock
    (sector : Fin 2) : Matrix 4 4 Int :=
  if sector = 0 then warmRobinSymmetryPlusBlock else warmRobinSymmetryMinusBlock

def warmRobinSymmetryXorWeight
    (sector : Fin 2) (slot column : Fin 4) : Int :=
  warmRobinSymmetrySectorBlock sector
    (warmRobinSymmetryXorPerm slot column) column

def warmRobinSymmetryXorAmplitude
    (sector : Fin 2) (slot column : Fin 4) : Rat :=
  warmRobinSymmetryXorWeight sector slot column / 56

theorem warmRobinSymmetryXorAmplitude_bounded
    (sector : Fin 2) (slot column : Fin 4) :
    |warmRobinSymmetryXorAmplitude sector slot column| ≤ 1 := by
  fin_cases sector <;> fin_cases slot <;> fin_cases column <;> native_decide

theorem warmRobinSymmetryXorDecomposition
    (sector : Fin 2) (row column : Fin 4) :
    warmRobinSymmetrySectorBlock sector row column =
      ∑ slot : Fin 4,
        if warmRobinSymmetryXorPerm slot column = row then
          warmRobinSymmetryXorWeight sector slot column
        else 0 := by
  fin_cases sector <;> fin_cases row <;> fin_cases column <;> native_decide

def warmRobinXorFourSlotSystemPerm
    (slot : Fin 4) (index : WarmRobinSymmetrySystem) :
    WarmRobinSymmetrySystem :=
  (index.1, warmRobinSymmetryXorPerm slot index.2)

theorem warmRobinXorFourSlotSystemPerm_bijective (slot : Fin 4) :
    Function.Bijective (warmRobinXorFourSlotSystemPerm slot) := by
  fin_cases slot <;> decide

noncomputable def warmRobinXorFourSlotSystemEquiv (slot : Fin 4) :
    WarmRobinSymmetrySystem ≃ WarmRobinSymmetrySystem :=
  Equiv.ofBijective (warmRobinXorFourSlotSystemPerm slot)
    (warmRobinXorFourSlotSystemPerm_bijective slot)

@[simp] theorem warmRobinXorFourSlotSystemEquiv_apply
    (slot : Fin 4) (index : WarmRobinSymmetrySystem) :
    warmRobinXorFourSlotSystemEquiv slot index =
      warmRobinXorFourSlotSystemPerm slot index := rfl

def warmRobinXorFourSlotCoefficient
    (slot : Fin 4) (column : WarmRobinSymmetrySystem) : Real :=
  ((warmRobinSymmetryXorAmplitude column.1 slot column.2 : Rat) : Real)

theorem warmRobinXorFourSlotCoefficient_abs_le_one
    (slot : Fin 4) (column : WarmRobinSymmetrySystem) :
    |warmRobinXorFourSlotCoefficient slot column| ≤ 1 := by
  rcases column with ⟨sector, system⟩
  simpa [warmRobinXorFourSlotCoefficient] using
    (show
      |((warmRobinSymmetryXorAmplitude sector slot system : Rat) : Real)| ≤ 1
      by exact_mod_cast warmRobinSymmetryXorAmplitude_bounded sector slot system)

noncomputable def warmRobinXorFourSlotRotation
    (slot : Fin 4) (column : WarmRobinSymmetrySystem) :
    _root_.Matrix (Fin 2) (Fin 2) ℂ :=
  amplitudeRotation (warmRobinXorFourSlotCoefficient slot column)

theorem warmRobinXorFourSlotRotation_unitary
    (slot : Fin 4) (column : WarmRobinSymmetrySystem) :
    warmRobinXorFourSlotRotation slot column ∈
      _root_.Matrix.unitaryGroup (Fin 2) ℂ :=
  amplitudeRotation_unitary _

theorem warmRobinXorFourSlotRotation_cleanEntry
    (slot : Fin 4) (column : WarmRobinSymmetrySystem) :
    warmRobinXorFourSlotRotation slot column 0 0 =
      (warmRobinXorFourSlotCoefficient slot column : ℂ) := by
  have bounded := abs_le.mp
    (warmRobinXorFourSlotCoefficient_abs_le_one slot column)
  exact amplitudeRotation_cleanEntry _ bounded.1 bounded.2

noncomputable def warmRobinXorFourSlotMiddleLogicalUnitary :
    _root_.Matrix
      (LCUIndex (Fin 2) (Fin 4) WarmRobinSymmetrySystem)
      (LCUIndex (Fin 2) (Fin 4) WarmRobinSymmetrySystem) ℂ :=
  prepareAmplitudeSelectUnprepare
    warmRobinFourSlotSelectorPrepare
    warmRobinXorFourSlotRotation
    warmRobinXorFourSlotSystemEquiv

theorem warmRobinXorFourSlotMiddleLogicalUnitary_unitary :
    warmRobinXorFourSlotMiddleLogicalUnitary ∈
      _root_.Matrix.unitaryGroup
        (LCUIndex (Fin 2) (Fin 4) WarmRobinSymmetrySystem) ℂ := by
  apply prepareAmplitudeSelectUnprepare_unitary
  · exact warmRobinFourSlotSelectorPrepare_unitary
  · exact warmRobinXorFourSlotRotation_unitary

def warmRobinXorFourSlotSectorCleanFormula :
    _root_.Matrix WarmRobinSymmetrySystem WarmRobinSymmetrySystem Rat :=
  fun row column =>
    (1 / 4 : Rat) * ∑ slot : Fin 4,
      if warmRobinXorFourSlotSystemPerm slot column = row then
        warmRobinSymmetryXorAmplitude column.1 slot column.2
      else 0

theorem warmRobinXorFourSlotCleanFormula_eq_target
    (row column : WarmRobinSymmetrySystem) :
    warmRobinXorFourSlotSectorCleanFormula row column =
      warmRobinFourSlotSectorTarget row column := by
  rcases row with ⟨rowSector, rowSystem⟩
  rcases column with ⟨columnSector, columnSystem⟩
  fin_cases rowSector <;> fin_cases rowSystem <;>
    fin_cases columnSector <;> fin_cases columnSystem <;> native_decide

theorem warmRobinXorFourSlotMiddleLogicalUnitary_cleanEntry
    (row column : WarmRobinSymmetrySystem) :
    warmRobinXorFourSlotMiddleLogicalUnitary
        (0, (0, row)) (0, (0, column)) =
      (warmRobinXorFourSlotSectorCleanFormula row column : ℂ) := by
  unfold warmRobinXorFourSlotMiddleLogicalUnitary
  rw [prepareAmplitudeSelectUnprepare_cleanEntry]
  change
    (∑ slot : Fin 4,
      if warmRobinXorFourSlotSystemEquiv slot column = row then
        star (warmRobinFourSlotSelectorPrepare slot 0) *
          warmRobinXorFourSlotRotation slot column 0 0 *
          warmRobinFourSlotSelectorPrepare slot 0
      else 0) = _
  simp only [warmRobinXorFourSlotSystemEquiv_apply]
  have castFormula :
      (warmRobinXorFourSlotSectorCleanFormula row column : ℂ) =
        (1 / 4 : ℂ) * ∑ slot : Fin 4,
          if warmRobinXorFourSlotSystemPerm slot column = row then
            (warmRobinSymmetryXorAmplitude column.1 slot column.2 : ℂ)
          else 0 := by
    norm_num [warmRobinXorFourSlotSectorCleanFormula]
    apply Finset.sum_congr rfl
    intro slot _
    by_cases selected : warmRobinXorFourSlotSystemPerm slot column = row
    · simp [selected]
    · simp [selected]
  rw [castFormula, Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro slot _
  by_cases selected : warmRobinXorFourSlotSystemPerm slot column = row
  · simp only [selected, if_pos]
    rw [warmRobinXorFourSlotRotation_cleanEntry]
    change
      star (warmRobinFourSlotSelectorPrepare slot 0) *
          (warmRobinSymmetryXorAmplitude column.1 slot column.2 : ℂ) *
          warmRobinFourSlotSelectorPrepare slot 0 = _
    rw [← warmRobinFourSlotSelectorPrepare_probability slot]
    ring
  · simp [selected]

theorem warmRobinXorFourSlotMiddleLogicalUnitary_cleanSystemBlock :
    cleanSystemBlock warmRobinXorFourSlotMiddleLogicalUnitary 0 0 =
      fun row column => (warmRobinFourSlotSectorTarget row column : ℂ) := by
  ext row column
  change warmRobinXorFourSlotMiddleLogicalUnitary
      (0, (0, row)) (0, (0, column)) = _
  rw [warmRobinXorFourSlotMiddleLogicalUnitary_cleanEntry]
  exact_mod_cast warmRobinXorFourSlotCleanFormula_eq_target row column

noncomputable def warmRobinXorFourSlotPairLogicalUnitary :
    _root_.Matrix
      (LCUIndex (Fin 2) (Fin 4) WarmRobinSymmetrySystem)
      (LCUIndex (Fin 2) (Fin 4) WarmRobinSymmetrySystem) ℂ :=
  conjugateSystem warmRobinSymmetryBasisChange
    warmRobinXorFourSlotMiddleLogicalUnitary

theorem warmRobinXorFourSlotPairLogicalUnitary_unitary :
    warmRobinXorFourSlotPairLogicalUnitary ∈
      _root_.Matrix.unitaryGroup
        (LCUIndex (Fin 2) (Fin 4) WarmRobinSymmetrySystem) ℂ := by
  apply conjugateSystem_unitary
  · exact warmRobinSymmetryBasisChange_unitary
  · exact warmRobinXorFourSlotMiddleLogicalUnitary_unitary

theorem warmRobinXorFourSlotPairLogicalUnitary_cleanSystemBlock :
    cleanSystemBlock warmRobinXorFourSlotPairLogicalUnitary 0 0 =
      warmRobinPairNormalizedTargetComplex := by
  rw [warmRobinXorFourSlotPairLogicalUnitary,
    cleanSystemBlock_conjugateSystem,
    warmRobinXorFourSlotMiddleLogicalUnitary_cleanSystemBlock]
  exact warmRobinSymmetryBasisChange_conjugates_target

noncomputable def warmRobinXorFourSlotFlatUnitary :
    _root_.Matrix (Fin (gridSize 6)) (Fin (gridSize 6)) ℂ :=
  _root_.Matrix.reindexAlgEquiv ℂ ℂ warmRobinFourSlotIndexEquiv
    warmRobinXorFourSlotPairLogicalUnitary

theorem warmRobinXorFourSlotFlatUnitary_unitary :
    warmRobinXorFourSlotFlatUnitary ∈
      _root_.Matrix.unitaryGroup (Fin (gridSize 6)) ℂ := by
  apply reindex_unitary
  exact warmRobinXorFourSlotPairLogicalUnitary_unitary

theorem warmRobinXorFourSlotFlatUnitary_cleanBlock
    (row column : Fin 8) :
    warmRobinXorFourSlotFlatUnitary
        (warmRobinFourSlotCleanIndex row)
        (warmRobinFourSlotCleanIndex column) =
      ((RobinEvolution.warmRobinTarget row column /
        RobinEvolution.warmRobinNormalizer : Rat) : ℂ) := by
  unfold warmRobinXorFourSlotFlatUnitary warmRobinFourSlotCleanIndex
  simp only [_root_.Matrix.reindexAlgEquiv_apply,
    _root_.Matrix.reindex_apply, _root_.Matrix.submatrix_apply,
    Equiv.symm_apply_apply]
  change warmRobinXorFourSlotPairLogicalUnitary
      (0, (0, warmRobinPairSystemEquiv.symm row))
      (0, (0, warmRobinPairSystemEquiv.symm column)) = _
  have clean := congr_fun
    (congr_fun warmRobinXorFourSlotPairLogicalUnitary_cleanSystemBlock
      (warmRobinPairSystemEquiv.symm row))
      (warmRobinPairSystemEquiv.symm column)
  change warmRobinXorFourSlotPairLogicalUnitary
      (0, (0, warmRobinPairSystemEquiv.symm row))
      (0, (0, warmRobinPairSystemEquiv.symm column)) = _ at clean
  rw [clean, warmRobinPairNormalizedTargetComplex_symm]
  have normalizedIdentity := congr_fun
    (congr_fun warmRobin_normalized_eq_integer_div_224 row) column
  exact_mod_cast normalizedIdentity.symm

end QuantumBlockEncoding.Robin

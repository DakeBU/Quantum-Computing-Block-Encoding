import QuantumBlockEncoding.Robin.Hadamard8BlockEncoding
import QuantumBlockEncoding.Robin.SymmetryFourSlot
import QuantumBlockEncoding.Robin.SystemConjugation
import Mathlib.Tactic

/-!
# T2 logical unitary for the four-slot symmetry sectors

The structural four-shift identities are lifted here to a concrete complex
LCU unitary on a coefficient qubit, two selector qubits, and the
`sector × pair-index` system basis.  Its clean block is proved to be the direct
sum of the symmetric and antisymmetric Robin blocks divided by `224`.
-/

namespace QuantumBlockEncoding.Robin

open ComplexLCU
open scoped Kronecker

/-- Two binary selector wires before flattening to `Fin 4`. -/
abbrev WarmRobinFourSlotBits := Fin 2 × Fin 2

/-- Flatten the two selector wires. -/
def warmRobinFourSlotBitsEquiv : WarmRobinFourSlotBits ≃ Fin 4 :=
  finProdFinEquiv

/-- Uniform two-bit selector PREPARE. -/
noncomputable def warmRobinFourSlotBitsPrepare :
    _root_.Matrix WarmRobinFourSlotBits WarmRobinFourSlotBits ℂ :=
  warmRobinUniformBitPrepare ⊗ₖ warmRobinUniformBitPrepare

/-- The two-bit selector PREPARE is unitary. -/
theorem warmRobinFourSlotBitsPrepare_unitary :
    warmRobinFourSlotBitsPrepare ∈
      _root_.Matrix.unitaryGroup WarmRobinFourSlotBits ℂ := by
  apply _root_.Matrix.kronecker_mem_unitary
  · exact warmRobinUniformBitPrepare_unitary
  · exact warmRobinUniformBitPrepare_unitary

/-- Flattened four-slot selector PREPARE. -/
noncomputable def warmRobinFourSlotSelectorPrepare :
    _root_.Matrix (Fin 4) (Fin 4) ℂ :=
  _root_.Matrix.reindexAlgEquiv ℂ ℂ warmRobinFourSlotBitsEquiv
    warmRobinFourSlotBitsPrepare

/-- Reindexing preserves selector unitarity. -/
theorem warmRobinFourSlotSelectorPrepare_unitary :
    warmRobinFourSlotSelectorPrepare ∈
      _root_.Matrix.unitaryGroup (Fin 4) ℂ := by
  apply reindex_unitary
  exact warmRobinFourSlotBitsPrepare_unitary

/-- Uniform clean-column amplitude before selector flattening. -/
@[simp] theorem warmRobinFourSlotBitsPrepare_cleanColumn
    (bits : WarmRobinFourSlotBits) :
    warmRobinFourSlotBitsPrepare bits (0, 0) =
      (((Real.sqrt 2 / 2 : Real) : ℂ) *
        ((Real.sqrt 2 / 2 : Real) : ℂ)) := by
  rcases bits with ⟨first, second⟩
  simp [warmRobinFourSlotBitsPrepare]

/-- Uniform clean-column amplitude after selector flattening. -/
@[simp] theorem warmRobinFourSlotSelectorPrepare_cleanColumn (slot : Fin 4) :
    warmRobinFourSlotSelectorPrepare slot 0 =
      (((Real.sqrt 2 / 2 : Real) : ℂ) *
        ((Real.sqrt 2 / 2 : Real) : ℂ)) := by
  change warmRobinFourSlotBitsPrepare
      (warmRobinFourSlotBitsEquiv.symm slot)
      (warmRobinFourSlotBitsEquiv.symm 0) = _
  have zeroIndex : warmRobinFourSlotBitsEquiv.symm 0 = (0, 0) := by
    decide
  rw [zeroIndex]
  exact warmRobinFourSlotBitsPrepare_cleanColumn _

/-- Every selector slot has probability exactly `1/4` in the clean column. -/
@[simp] theorem warmRobinFourSlotSelectorPrepare_probability (slot : Fin 4) :
    star (warmRobinFourSlotSelectorPrepare slot 0) *
        warmRobinFourSlotSelectorPrepare slot 0 = (1 / 4 : ℂ) := by
  rw [warmRobinFourSlotSelectorPrepare_cleanColumn]
  let c : Real := Real.sqrt 2 / 2
  have sqrtSquare : (Real.sqrt 2) ^ 2 = (2 : Real) :=
    Real.sq_sqrt (by norm_num)
  have cSquare : c * c = (1 / 2 : Real) := by
    dsimp [c]
    nlinarith
  have realProbability : (c * c) * (c * c) = (1 / 4 : Real) := by
    rw [cSquare]
    norm_num
  apply Complex.ext
  · simpa [c, mul_assoc] using realProbability
  · simp

/-- Sector and reversal-pair coordinate used by the middle logical unitary. -/
abbrev WarmRobinSymmetrySystem := Fin 2 × Fin 4

/-- A four-shift SELECT preserves the symmetry sector. -/
def warmRobinFourSlotSystemPerm
    (slot : Fin 4) (index : WarmRobinSymmetrySystem) :
    WarmRobinSymmetrySystem :=
  (index.1, warmRobinSymmetryFourShiftPerm slot index.2)

/-- Each sector-preserving four-shift SELECT is a basis bijection. -/
theorem warmRobinFourSlotSystemPerm_bijective (slot : Fin 4) :
    Function.Bijective (warmRobinFourSlotSystemPerm slot) := by
  fin_cases slot <;> decide

/-- Package the sector-preserving SELECT as an equivalence. -/
noncomputable def warmRobinFourSlotSystemEquiv (slot : Fin 4) :
    WarmRobinSymmetrySystem ≃ WarmRobinSymmetrySystem :=
  Equiv.ofBijective (warmRobinFourSlotSystemPerm slot)
    (warmRobinFourSlotSystemPerm_bijective slot)

/-- Real amplitude encoded by a selector slot and sector-system column. -/
def warmRobinFourSlotCoefficient
    (slot : Fin 4) (column : WarmRobinSymmetrySystem) : Real :=
  ((warmRobinSymmetryFourShiftAmplitude column.1 slot column.2 : Rat) : Real)

/-- Every four-slot real amplitude lies in `[-1,1]`. -/
theorem warmRobinFourSlotCoefficient_abs_le_one
    (slot : Fin 4) (column : WarmRobinSymmetrySystem) :
    |warmRobinFourSlotCoefficient slot column| ≤ 1 := by
  rcases column with ⟨sector, pairColumn⟩
  fin_cases sector <;> fin_cases slot <;> fin_cases pairColumn <;>
    norm_num [warmRobinFourSlotCoefficient,
      warmRobinSymmetryFourShiftAmplitude,
      warmRobinSymmetryFourShiftWeight,
      warmRobinSymmetryPlusWeight,
      warmRobinSymmetryMinusWeight]

/-- Controlled coefficient rotation for the four-slot route. -/
noncomputable def warmRobinFourSlotRotation
    (slot : Fin 4) (column : WarmRobinSymmetrySystem) :
    _root_.Matrix (Fin 2) (Fin 2) ℂ :=
  amplitudeRotation (warmRobinFourSlotCoefficient slot column)

/-- Every controlled coefficient rotation is unitary. -/
theorem warmRobinFourSlotRotation_unitary
    (slot : Fin 4) (column : WarmRobinSymmetrySystem) :
    warmRobinFourSlotRotation slot column ∈
      _root_.Matrix.unitaryGroup (Fin 2) ℂ :=
  amplitudeRotation_unitary _

/-- The clean coefficient entry is the desired signed amplitude. -/
theorem warmRobinFourSlotRotation_cleanEntry
    (slot : Fin 4) (column : WarmRobinSymmetrySystem) :
    warmRobinFourSlotRotation slot column 0 0 =
      (warmRobinFourSlotCoefficient slot column : ℂ) := by
  have bounded := abs_le.mp
    (warmRobinFourSlotCoefficient_abs_le_one slot column)
  exact amplitudeRotation_cleanEntry _ bounded.1 bounded.2

/-- Rational and real-complex views of the four-slot coefficient agree. -/
theorem warmRobinFourSlotCoefficient_complex
    (slot : Fin 4) (column : WarmRobinSymmetrySystem) :
    (warmRobinFourSlotCoefficient slot column : ℂ) =
      (warmRobinSymmetryFourShiftAmplitude
        column.1 slot column.2 : ℂ) := by
  norm_num [warmRobinFourSlotCoefficient]

/-- Product-register logical unitary in the symmetry-sector system basis. -/
noncomputable def warmRobinFourSlotMiddleLogicalUnitary :
    _root_.Matrix
      (LCUIndex (Fin 2) (Fin 4) WarmRobinSymmetrySystem)
      (LCUIndex (Fin 2) (Fin 4) WarmRobinSymmetrySystem) ℂ :=
  prepareAmplitudeSelectUnprepare
    warmRobinFourSlotSelectorPrepare
    warmRobinFourSlotRotation
    warmRobinFourSlotSystemEquiv

/-- The complete four-slot middle construction is exactly unitary. -/
theorem warmRobinFourSlotMiddleLogicalUnitary_unitary :
    warmRobinFourSlotMiddleLogicalUnitary ∈
      _root_.Matrix.unitaryGroup
        (LCUIndex (Fin 2) (Fin 4) WarmRobinSymmetrySystem) ℂ := by
  apply prepareAmplitudeSelectUnprepare_unitary
  · exact warmRobinFourSlotSelectorPrepare_unitary
  · exact warmRobinFourSlotRotation_unitary

/-- Structural clean formula on the full sector-system basis. -/
def warmRobinFourSlotSectorCleanFormula :
    _root_.Matrix WarmRobinSymmetrySystem WarmRobinSymmetrySystem Rat :=
  fun row column =>
    (1 / 4 : Rat) * ∑ slot : Fin 4,
      if warmRobinFourSlotSystemEquiv slot column = row then
        warmRobinSymmetryFourShiftAmplitude
          column.1 slot column.2
      else 0

/-- On one sector, the full-system formula is the existing four-shift formula. -/
theorem warmRobinFourSlotSectorCleanFormula_same
    (sector : Fin 2) (row column : Fin 4) :
    warmRobinFourSlotSectorCleanFormula
        (sector, row) (sector, column) =
      warmRobinSymmetryFourShiftCleanFormula sector row column := by
  simp [warmRobinFourSlotSectorCleanFormula,
    warmRobinFourSlotSystemEquiv, warmRobinFourSlotSystemPerm,
    warmRobinSymmetryFourShiftCleanFormula]

/-- Cross-sector clean entries vanish because SELECT preserves the sector. -/
theorem warmRobinFourSlotSectorCleanFormula_cross
    {rowSector columnSector : Fin 2} (sectorMismatch : rowSector ≠ columnSector)
    (row column : Fin 4) :
    warmRobinFourSlotSectorCleanFormula
        (rowSector, row) (columnSector, column) = 0 := by
  simp [warmRobinFourSlotSectorCleanFormula,
    warmRobinFourSlotSystemEquiv, warmRobinFourSlotSystemPerm,
    sectorMismatch, Ne.symm sectorMismatch]

/-- Direct-sum normalized target in the symmetry-sector basis. -/
def warmRobinFourSlotSectorTarget :
    _root_.Matrix WarmRobinSymmetrySystem WarmRobinSymmetrySystem Rat :=
  fun row column =>
    if row.1 = column.1 then
      if row.1.val = 0 then
        (warmRobinSymmetryPlusBlock row.2 column.2 : Rat) / 224
      else
        (warmRobinSymmetryMinusBlock row.2 column.2 : Rat) / 224
    else 0

/-- The structural clean formula is exactly the normalized direct sum. -/
theorem warmRobinFourSlotSectorCleanFormula_eq_target
    (row column : WarmRobinSymmetrySystem) :
    warmRobinFourSlotSectorCleanFormula row column =
      warmRobinFourSlotSectorTarget row column := by
  rcases row with ⟨rowSector, rowPair⟩
  rcases column with ⟨columnSector, columnPair⟩
  by_cases sectorMatch : rowSector = columnSector
  · subst columnSector
    rw [warmRobinFourSlotSectorCleanFormula_same]
    fin_cases rowSector
    · simpa [warmRobinFourSlotSectorTarget] using
        warmRobinSymmetryPlusFourShiftCleanFormula_eq rowPair columnPair
    · simpa [warmRobinFourSlotSectorTarget] using
        warmRobinSymmetryMinusFourShiftCleanFormula_eq rowPair columnPair
  · rw [warmRobinFourSlotSectorCleanFormula_cross sectorMatch]
    simp [warmRobinFourSlotSectorTarget, sectorMatch]

/-- The reusable clean-entry expansion specializes to the four-slot sector formula. -/
theorem warmRobinFourSlotMiddleLogicalUnitary_cleanEntry
    (row column : WarmRobinSymmetrySystem) :
    warmRobinFourSlotMiddleLogicalUnitary
        (0, (0, row)) (0, (0, column)) =
      (warmRobinFourSlotSectorCleanFormula row column : ℂ) := by
  unfold warmRobinFourSlotMiddleLogicalUnitary
  rw [prepareAmplitudeSelectUnprepare_cleanEntry]
  change
    (∑ slot : Fin 4,
      if warmRobinFourSlotSystemEquiv slot column = row then
        star (warmRobinFourSlotSelectorPrepare slot 0) *
          warmRobinFourSlotRotation slot column 0 0 *
          warmRobinFourSlotSelectorPrepare slot 0
      else 0) = _
  have castFormula :
      (warmRobinFourSlotSectorCleanFormula row column : ℂ) =
        (1 / 4 : ℂ) * ∑ slot : Fin 4,
          if warmRobinFourSlotSystemEquiv slot column = row then
            (warmRobinSymmetryFourShiftAmplitude
              column.1 slot column.2 : ℂ)
          else 0 := by
    norm_num [warmRobinFourSlotSectorCleanFormula]
    apply Finset.sum_congr rfl
    intro slot _
    by_cases selected : warmRobinFourSlotSystemEquiv slot column = row
    · simp [selected]
    · simp [selected]
  rw [castFormula, Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro slot _
  by_cases selected : warmRobinFourSlotSystemEquiv slot column = row
  · simp only [selected, if_pos]
    rw [warmRobinFourSlotRotation_cleanEntry]
    rw [warmRobinFourSlotCoefficient_complex]
    rw [← warmRobinFourSlotSelectorPrepare_probability slot]
    ring
  · simp [selected]

/-- The middle logical clean block is exactly the normalized sector target. -/
theorem warmRobinFourSlotMiddleLogicalUnitary_cleanEntry_eq_target
    (row column : WarmRobinSymmetrySystem) :
    warmRobinFourSlotMiddleLogicalUnitary
        (0, (0, row)) (0, (0, column)) =
      (warmRobinFourSlotSectorTarget row column : ℂ) := by
  rw [warmRobinFourSlotMiddleLogicalUnitary_cleanEntry]
  exact_mod_cast warmRobinFourSlotSectorCleanFormula_eq_target row column

/-- Matrix form of the middle clean-block certificate. -/
theorem warmRobinFourSlotMiddleLogicalUnitary_cleanSystemBlock :
    cleanSystemBlock warmRobinFourSlotMiddleLogicalUnitary 0 0 =
      fun row column =>
        (warmRobinFourSlotSectorTarget row column : ℂ) := by
  ext row column
  exact warmRobinFourSlotMiddleLogicalUnitary_cleanEntry_eq_target row column

end QuantumBlockEncoding.Robin

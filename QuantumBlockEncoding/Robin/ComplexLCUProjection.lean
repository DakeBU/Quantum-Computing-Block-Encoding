import QuantumBlockEncoding.Robin.ComplexLCU
import Mathlib.Tactic

/-!
# Clean projection for the logical LCU kernel

This module proves the exact clean-entry formula for the logical
`PREPARE† · SELECT · AMPLITUDE · PREPARE` matrix.  It is the reusable bridge
from local complex-unitary gates to the structural weighted-permutation sums
already certified for the Robin candidates.
-/

namespace QuantumBlockEncoding.Robin.ComplexLCU

open scoped Kronecker

@[simp] theorem amplitudeLift_apply
    {coefficient selector system : Type*}
    [Fintype coefficient] [DecidableEq coefficient]
    [Fintype selector] [DecidableEq selector]
    [Fintype system] [DecidableEq system]
    (rotation : selector → system →
      _root_.Matrix coefficient coefficient ℂ)
    (row column : LCUIndex coefficient selector system) :
    amplitudeLift rotation row column =
      if row.2 = column.2 then
        rotation row.2.1 row.2.2 row.1 column.1
      else 0 := by
  rfl

@[simp] theorem selectLift_apply
    {coefficient selector system : Type*}
    [DecidableEq coefficient] [DecidableEq selector] [DecidableEq system]
    (permutation : selector → system ≃ system)
    (row column : LCUIndex coefficient selector system) :
    selectLift (coefficient := coefficient) permutation row column =
      if row =
          (column.1, (column.2.1,
            permutation column.2.1 column.2.2)) then 1 else 0 := by
  rfl

/-- Amplitude followed by selector preparation, evaluated on a clean input. -/
theorem amplitudeLift_mul_selectorLift_clean
    {coefficient selector system : Type*}
    [Fintype coefficient] [DecidableEq coefficient]
    [Fintype selector] [DecidableEq selector]
    [Fintype system] [DecidableEq system]
    (prepare : _root_.Matrix selector selector ℂ)
    (rotation : selector → system →
      _root_.Matrix coefficient coefficient ℂ)
    (cleanCoefficient : coefficient) (cleanSelector : selector)
    (systemColumn : system)
    (row : LCUIndex coefficient selector system) :
    (amplitudeLift rotation *
        selectorLift (coefficient := coefficient) (system := system) prepare)
        row (cleanCoefficient, (cleanSelector, systemColumn)) =
      if row.2.2 = systemColumn then
        rotation row.2.1 row.2.2 row.1 cleanCoefficient *
          prepare row.2.1 cleanSelector
      else 0 := by
  classical
  rcases row with ⟨coefficientRow, ⟨selectorRow, systemRow⟩⟩
  simp [amplitudeLift, selectorLift, _root_.Matrix.mul_apply,
    _root_.Matrix.blockDiagonal_apply, Fintype.sum_prod_type]

/-- SELECT applied after amplitude and PREPARE, on one clean input column. -/
theorem selectLift_mul_amplitudeLift_mul_selectorLift_clean
    {coefficient selector system : Type*}
    [Fintype coefficient] [DecidableEq coefficient]
    [Fintype selector] [DecidableEq selector]
    [Fintype system] [DecidableEq system]
    (prepare : _root_.Matrix selector selector ℂ)
    (rotation : selector → system →
      _root_.Matrix coefficient coefficient ℂ)
    (permutation : selector → system ≃ system)
    (cleanCoefficient : coefficient) (cleanSelector : selector)
    (systemColumn : system)
    (row : LCUIndex coefficient selector system) :
    (selectLift (coefficient := coefficient) permutation *
        (amplitudeLift rotation *
          selectorLift (coefficient := coefficient) (system := system) prepare))
        row (cleanCoefficient, (cleanSelector, systemColumn)) =
      if (permutation row.2.1).symm row.2.2 = systemColumn then
        rotation row.2.1 systemColumn row.1 cleanCoefficient *
          prepare row.2.1 cleanSelector
      else 0 := by
  rw [equivPermutationMatrix_mul_apply]
  simp [selectLift, controlledSystemEquiv,
    amplitudeLift_mul_selectorLift_clean]

/-- Project an arbitrary right factor through the clean PREPARE bra. -/
theorem star_selectorLift_mul_clean
    {coefficient selector system κ : Type*}
    [Fintype coefficient] [DecidableEq coefficient]
    [Fintype selector] [DecidableEq selector]
    [Fintype system] [DecidableEq system]
    [Fintype κ]
    (prepare : _root_.Matrix selector selector ℂ)
    (operator : _root_.Matrix
      (LCUIndex coefficient selector system) κ ℂ)
    (cleanCoefficient : coefficient) (cleanSelector : selector)
    (systemRow : system) (column : κ) :
    (star (selectorLift (coefficient := coefficient) (system := system) prepare) *
        operator)
        (cleanCoefficient, (cleanSelector, systemRow)) column =
      ∑ selectorIndex : selector,
        star (prepare selectorIndex cleanSelector) *
          operator (cleanCoefficient, (selectorIndex, systemRow)) column := by
  classical
  simp [selectorLift, _root_.Matrix.mul_apply, Fintype.sum_prod_type]

/-- Exact projected clean entry of PREPARE/amplitude/SELECT/unprepare. -/
theorem prepareAmplitudeSelectUnprepare_cleanEntry
    {coefficient selector system : Type*}
    [Fintype coefficient] [DecidableEq coefficient]
    [Fintype selector] [DecidableEq selector]
    [Fintype system] [DecidableEq system]
    (prepare : _root_.Matrix selector selector ℂ)
    (rotation : selector → system →
      _root_.Matrix coefficient coefficient ℂ)
    (permutation : selector → system ≃ system)
    (cleanCoefficient : coefficient) (cleanSelector : selector)
    (systemRow systemColumn : system) :
    prepareAmplitudeSelectUnprepare prepare rotation permutation
        (cleanCoefficient, (cleanSelector, systemRow))
        (cleanCoefficient, (cleanSelector, systemColumn)) =
      ∑ selectorIndex : selector,
        if permutation selectorIndex systemColumn = systemRow then
          star (prepare selectorIndex cleanSelector) *
            rotation selectorIndex systemColumn
              cleanCoefficient cleanCoefficient *
            prepare selectorIndex cleanSelector
        else 0 := by
  rw [prepareAmplitudeSelectUnprepare]
  rw [star_selectorLift_mul_clean]
  apply Finset.sum_congr rfl
  intro selectorIndex _
  rw [selectLift_mul_amplitudeLift_mul_selectorLift_clean]
  by_cases selected :
      permutation selectorIndex systemColumn = systemRow
  · have inverse :
        (permutation selectorIndex).symm systemRow = systemColumn := by
      calc
        (permutation selectorIndex).symm systemRow =
            (permutation selectorIndex).symm
              (permutation selectorIndex systemColumn) := by rw [selected]
        _ = systemColumn :=
          (permutation selectorIndex).symm_apply_apply systemColumn
    simp [selected, inverse]
    ring
  · have inverse :
        (permutation selectorIndex).symm systemRow ≠ systemColumn := by
      intro equality
      apply selected
      calc
        permutation selectorIndex systemColumn =
            permutation selectorIndex
              ((permutation selectorIndex).symm systemRow) := by rw [equality]
        _ = systemRow :=
          (permutation selectorIndex).apply_symm_apply systemRow
    simp [selected, inverse]

end QuantumBlockEncoding.Robin.ComplexLCU

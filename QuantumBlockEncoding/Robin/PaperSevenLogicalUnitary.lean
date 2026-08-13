import QuantumBlockEncoding.Robin.ComplexLCUProjection
import QuantumBlockEncoding.Robin.Hadamard8BlockEncoding
import QuantumBlockEncoding.Robin.PaperSevenPrimitive
import QuantumBlockEncoding.Robin.SourceSevenSparseData
import QuantumBlockEncoding.Robin.SystemConjugation
import Mathlib.Tactic

/-!
# Exact logical unitary for the padded paper-seven source route

This module connects the true sparse source table to a seven-qubit logical
LCU.  Seven selector states are active; the eighth physical state has zero
PREPARE probability and an identity coefficient rotation.
-/

namespace QuantumBlockEncoding.Robin

open ComplexLCU

def warmRobinPaperSevenSystemPerm (slot column : Fin 8) : Fin 8 :=
  warmRobinSourceDTRow slot column

theorem warmRobinPaperSevenSystemPerm_bijective (slot : Fin 8) :
    Function.Bijective (warmRobinPaperSevenSystemPerm slot) :=
  warmRobinSourceDTRow_bijective_in_column slot

noncomputable def warmRobinPaperSevenSystemEquiv (slot : Fin 8) :
    Fin 8 ≃ Fin 8 :=
  Equiv.ofBijective (warmRobinPaperSevenSystemPerm slot)
    (warmRobinPaperSevenSystemPerm_bijective slot)

@[simp] theorem warmRobinPaperSevenSystemEquiv_apply
    (slot column : Fin 8) :
    warmRobinPaperSevenSystemEquiv slot column =
      warmRobinSourceDTRow slot column := rfl

def warmRobinPaperSevenCoefficientRat (slot column : Fin 8) : Rat :=
  warmRobinSourceSevenPaddedCoefficient slot column

theorem warmRobinPaperSevenCoefficientRat_abs_le_one
    (slot column : Fin 8) :
    |warmRobinPaperSevenCoefficientRat slot column| ≤ 1 := by
  fin_cases slot <;> fin_cases column <;> native_decide

def warmRobinPaperSevenCoefficient (slot column : Fin 8) : Real :=
  ((warmRobinPaperSevenCoefficientRat slot column : Rat) : Real)

theorem warmRobinPaperSevenCoefficient_abs_le_one
    (slot column : Fin 8) :
    |warmRobinPaperSevenCoefficient slot column| ≤ 1 := by
  simpa [warmRobinPaperSevenCoefficient] using
    (show
      |((warmRobinPaperSevenCoefficientRat slot column : Rat) : Real)| ≤ 1
      by exact_mod_cast
        warmRobinPaperSevenCoefficientRat_abs_le_one slot column)

noncomputable def warmRobinPaperSevenRotation (slot column : Fin 8) :
    _root_.Matrix (Fin 2) (Fin 2) ℂ :=
  amplitudeRotation (warmRobinPaperSevenCoefficient slot column)

theorem warmRobinPaperSevenRotation_unitary (slot column : Fin 8) :
    warmRobinPaperSevenRotation slot column ∈
      _root_.Matrix.unitaryGroup (Fin 2) ℂ :=
  amplitudeRotation_unitary _

theorem warmRobinPaperSevenRotation_cleanEntry (slot column : Fin 8) :
    warmRobinPaperSevenRotation slot column 0 0 =
      (warmRobinPaperSevenCoefficient slot column : ℂ) := by
  have bounded := abs_le.mp
    (warmRobinPaperSevenCoefficient_abs_le_one slot column)
  exact amplitudeRotation_cleanEntry _ bounded.1 bounded.2

noncomputable def warmRobinPaperSevenLogicalUnitary :
    _root_.Matrix
      (LCUIndex (Fin 2) (Fin 8) (Fin 8))
      (LCUIndex (Fin 2) (Fin 8) (Fin 8)) ℂ :=
  prepareAmplitudeSelectUnprepare
    warmRobinPaperSevenSelectorPrepare
    warmRobinPaperSevenRotation
    warmRobinPaperSevenSystemEquiv

theorem warmRobinPaperSevenLogicalUnitary_unitary :
    warmRobinPaperSevenLogicalUnitary ∈
      _root_.Matrix.unitaryGroup
        (LCUIndex (Fin 2) (Fin 8) (Fin 8)) ℂ := by
  apply prepareAmplitudeSelectUnprepare_unitary
  · exact warmRobinPaperSevenSelectorPrepare_unitary_flat
  · exact warmRobinPaperSevenRotation_unitary

theorem warmRobinPaperSevenLogicalUnitary_cleanEntry
    (row column : Fin 8) :
    warmRobinPaperSevenLogicalUnitary
        (0, (0, row)) (0, (0, column)) =
      (warmRobinSourceSevenCleanFormula row column : ℂ) := by
  unfold warmRobinPaperSevenLogicalUnitary
  rw [prepareAmplitudeSelectUnprepare_cleanEntry]
  simp only [warmRobinPaperSevenSystemEquiv_apply]
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
  by_cases selected : warmRobinSourceDTRow slot column = row
  · simp only [selected, if_pos]
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
              (((warmRobinSourceSevenPaddedCoefficient slot column : Rat) : Real) : ℂ) := by
            ring
      _ = _ := by
        rw [warmRobinUniformSevenPrepare_probability slot]
        by_cases active : slot.val < 7
        · simp [warmRobinSourceSevenSelectorProbability, active]
        · simp [warmRobinSourceSevenSelectorProbability, active]
  · simp [selected]

theorem warmRobinPaperSevenLogicalUnitary_cleanBlock :
    cleanSystemBlock warmRobinPaperSevenLogicalUnitary 0 0 =
      fun row column =>
        ((RobinEvolution.warmRobinTarget row column /
          RobinEvolution.warmRobinNormalizer : Rat) : ℂ) := by
  ext row column
  change warmRobinPaperSevenLogicalUnitary
      (0, (0, row)) (0, (0, column)) = _
  rw [warmRobinPaperSevenLogicalUnitary_cleanEntry]
  exact_mod_cast warmRobinSourceSevenCleanFormula_eq_target row column

/-- Flatten coefficient, selector, and system registers to seven qubits. -/
def warmRobinPaperSevenIndexEquiv :
    LCUIndex (Fin 2) (Fin 8) (Fin 8) ≃ Fin (gridSize 7) :=
  (Equiv.prodCongr (Equiv.refl (Fin 2)) finProdFinEquiv).trans
    finProdFinEquiv

noncomputable def warmRobinPaperSevenCleanIndex
    (system : Fin 8) : Fin (gridSize 7) :=
  warmRobinPaperSevenIndexEquiv (0, (0, system))

noncomputable def warmRobinPaperSevenFlatUnitary :
    _root_.Matrix (Fin (gridSize 7)) (Fin (gridSize 7)) ℂ :=
  _root_.Matrix.reindexAlgEquiv ℂ ℂ warmRobinPaperSevenIndexEquiv
    warmRobinPaperSevenLogicalUnitary

theorem warmRobinPaperSevenFlatUnitary_unitary :
    warmRobinPaperSevenFlatUnitary ∈
      _root_.Matrix.unitaryGroup (Fin (gridSize 7)) ℂ := by
  apply reindex_unitary
  exact warmRobinPaperSevenLogicalUnitary_unitary

theorem warmRobinPaperSevenFlatUnitary_cleanBlock
    (row column : Fin 8) :
    warmRobinPaperSevenFlatUnitary
        (warmRobinPaperSevenCleanIndex row)
        (warmRobinPaperSevenCleanIndex column) =
      ((RobinEvolution.warmRobinTarget row column /
        RobinEvolution.warmRobinNormalizer : Rat) : ℂ) := by
  simp only [warmRobinPaperSevenFlatUnitary,
    warmRobinPaperSevenCleanIndex,
    _root_.Matrix.reindexAlgEquiv_apply,
    _root_.Matrix.reindex_apply, _root_.Matrix.submatrix_apply,
    Equiv.symm_apply_apply]
  have clean := congr_fun
    (congr_fun warmRobinPaperSevenLogicalUnitary_cleanBlock row) column
  exact clean

def warmRobinPaperSevenBlockContainsTarget : Prop :=
  ∀ row column : Fin 8,
    warmRobinPaperSevenFlatUnitary
        (warmRobinPaperSevenCleanIndex row)
        (warmRobinPaperSevenCleanIndex column) =
      warmRobinQueryTarget.operator row column /
        warmRobinQueryTarget.normalizer

theorem warmRobinPaperSevenBlockContainsTarget_proof :
    warmRobinPaperSevenBlockContainsTarget := by
  intro row column
  rw [warmRobinPaperSevenFlatUnitary_cleanBlock]
  norm_num [warmRobinQueryTarget, warmRobinComplexTarget]

def warmRobinPaperSevenT2Schedule : LayeredCircuit :=
  [ [ Gate.oracleCall "paper-seven PREPARE" ]
  , [ Gate.oracleCall "paper-seven amplitude loader" ]
  , [ Gate.oracleCall "paper-seven SELECT" ]
  , [ Gate.oracleCall "paper-seven PREPARE dagger" ] ]

def warmRobinPaperSevenT2Circuit : Circuit :=
  warmRobinPaperSevenT2Schedule.flatten

def warmRobinPaperSevenT2Resource : Resource :=
  warmRobinPaperSevenT2Schedule.resource

noncomputable def warmRobinPaperSevenOperatorCandidate :
    OperatorBlockEncodingCandidate ℂ 3 where
  auxiliaryQubits := 4
  target := warmRobinQueryTarget
  unitary := warmRobinPaperSevenFlatUnitary
  layout := {
    systemQubits := 3
    signalQubits := 4
    pureAncillas := 0
  }
  circuit := warmRobinPaperSevenT2Circuit
  schedule := warmRobinPaperSevenT2Schedule
  resource := warmRobinPaperSevenT2Resource
  layoutMatches := by decide
  isUnitary := warmRobinPaperSevenFlatUnitary ∈
    _root_.Matrix.unitaryGroup (Fin (gridSize 7)) ℂ
  blockContainsTarget := warmRobinPaperSevenBlockContainsTarget

noncomputable def warmRobinPaperSevenVerifiedBlockEncoding :
    VerifiedOperatorBlockEncoding ℂ 3 where
  candidate := warmRobinPaperSevenOperatorCandidate
  unitaryProof := warmRobinPaperSevenFlatUnitary_unitary
  blockProof := warmRobinPaperSevenBlockContainsTarget_proof

end QuantumBlockEncoding.Robin

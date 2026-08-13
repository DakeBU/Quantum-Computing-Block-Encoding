import QuantumBlockEncoding.Robin.SymmetryFourSlotLogicalUnitary
import QuantumBlockEncoding.Robin.Hadamard8BlockEncoding
import Mathlib.Tactic

/-!
# Verified four-slot Robin block encoding in the original basis

The sector-basis logical unitary is conjugated by the exact reversal-pair
basis change, reindexed to the original `Fin 8` system order, and flattened to
six qubits.  The resulting clean block is the fixed Robin target divided by
`56/3`, so this module promotes the structural four-slot route to a complete
T2 `VerifiedOperatorBlockEncoding`.

No primitive `{u, cx}` refinement is asserted here.
-/

namespace QuantumBlockEncoding.Robin

open ComplexLCU
open scoped Kronecker

/-- Map a reversal-pair coordinate back to the original `Fin 8` basis. -/
def warmRobinPairSystemToOriginal
    (index : WarmRobinSymmetrySystem) : Fin 8 :=
  if index.1.val = 0 then
    warmRobinPairLow index.2
  else
    warmRobinPairHigh index.2

@[simp] theorem warmRobinPairSystemToOriginal_zero (pair : Fin 4) :
    warmRobinPairSystemToOriginal (0, pair) = warmRobinPairLow pair := by
  rfl

@[simp] theorem warmRobinPairSystemToOriginal_one (pair : Fin 4) :
    warmRobinPairSystemToOriginal (1, pair) = warmRobinPairHigh pair := by
  rfl

/-- Pair coordinates enumerate the original eight basis states exactly once. -/
theorem warmRobinPairSystemToOriginal_bijective :
    Function.Bijective warmRobinPairSystemToOriginal := by
  native_decide

/-- Equivalence between pair coordinates and the original Robin basis. -/
noncomputable def warmRobinPairSystemEquiv :
    WarmRobinSymmetrySystem ≃ Fin 8 :=
  Equiv.ofBijective warmRobinPairSystemToOriginal
    warmRobinPairSystemToOriginal_bijective

@[simp] theorem warmRobinPairSystemEquiv_apply
    (index : WarmRobinSymmetrySystem) :
    warmRobinPairSystemEquiv index = warmRobinPairSystemToOriginal index := by
  rfl

@[simp] theorem warmRobinPairSystemToOriginal_symm (system : Fin 8) :
    warmRobinPairSystemToOriginal (warmRobinPairSystemEquiv.symm system) = system := by
  rw [← warmRobinPairSystemEquiv_apply]
  exact warmRobinPairSystemEquiv.apply_symm_apply system

/-- The symmetry-sector-to-pair basis change: one exact Hadamard-like rotation. -/
noncomputable def warmRobinSymmetryBasisChange :
    _root_.Matrix WarmRobinSymmetrySystem WarmRobinSymmetrySystem ℂ :=
  warmRobinUniformBitPrepare ⊗ₖ
    (1 : _root_.Matrix (Fin 4) (Fin 4) ℂ)

/-- The symmetry basis change is unitary. -/
theorem warmRobinSymmetryBasisChange_unitary :
    warmRobinSymmetryBasisChange ∈
      _root_.Matrix.unitaryGroup WarmRobinSymmetrySystem ℂ := by
  apply _root_.Matrix.kronecker_mem_unitary
  · exact warmRobinUniformBitPrepare_unitary
  · exact (_root_.Matrix.unitaryGroup (Fin 4) ℂ).one_mem

/-- The common real selector amplitude has squared magnitude `1/2`. -/
@[simp] theorem warmRobinUniformScalar_square_complex :
    (((Real.sqrt 2 / 2 : Real) : ℂ) *
      ((Real.sqrt 2 / 2 : Real) : ℂ)) = (1 / 2 : ℂ) := by
  have squareRoot : (Real.sqrt 2) ^ 2 = (2 : Real) :=
    Real.sq_sqrt (by norm_num)
  have realSquare :
      (Real.sqrt 2 / 2) * (Real.sqrt 2 / 2) = (1 / 2 : Real) := by
    nlinarith
  apply Complex.ext
  · simpa using realSquare
  · simp

/-- Lower-left pair block equals the upper-right pair block by centrosymmetry. -/
theorem warmRobinIntegerTarget_pair_high_low
    (row column : Fin 4) :
    warmRobinIntegerTarget (warmRobinPairHigh row) (warmRobinPairLow column) =
      warmRobinIntegerTarget (warmRobinPairLow row) (warmRobinPairHigh column) := by
  have symmetry := warmRobinIntegerTarget_centrosymmetric
    (warmRobinPairLow row) (warmRobinPairHigh column)
  simpa [warmRobinPairHigh] using symmetry.symm

/-- The high-high pair block equals the low-low block. -/
theorem warmRobinIntegerTarget_pair_high_high
    (row column : Fin 4) :
    warmRobinIntegerTarget (warmRobinPairHigh row) (warmRobinPairHigh column) =
      warmRobinIntegerTarget (warmRobinPairLow row) (warmRobinPairLow column) := by
  have symmetry := warmRobinIntegerTarget_centrosymmetric
    (warmRobinPairLow row) (warmRobinPairLow column)
  simpa [warmRobinPairHigh] using symmetry.symm

/-- The fixed integer target, reordered by reversal pairs and divided by `224`. -/
def warmRobinPairNormalizedTargetRat :
    _root_.Matrix WarmRobinSymmetrySystem WarmRobinSymmetrySystem Rat :=
  fun row column =>
    warmRobinIntegerTargetRat
      (warmRobinPairSystemToOriginal row)
      (warmRobinPairSystemToOriginal column) / 224

@[simp] theorem warmRobinPairNormalizedTargetRat_zero_zero
    (row column : Fin 4) :
    warmRobinPairNormalizedTargetRat (0, row) (0, column) =
      (warmRobinIntegerTarget
        (warmRobinPairLow row) (warmRobinPairLow column) : Rat) / 224 := by
  rfl

@[simp] theorem warmRobinPairNormalizedTargetRat_zero_one
    (row column : Fin 4) :
    warmRobinPairNormalizedTargetRat (0, row) (1, column) =
      (warmRobinIntegerTarget
        (warmRobinPairLow row) (warmRobinPairHigh column) : Rat) / 224 := by
  rfl

@[simp] theorem warmRobinPairNormalizedTargetRat_one_zero
    (row column : Fin 4) :
    warmRobinPairNormalizedTargetRat (1, row) (0, column) =
      (warmRobinIntegerTarget
        (warmRobinPairLow row) (warmRobinPairHigh column) : Rat) / 224 := by
  unfold warmRobinPairNormalizedTargetRat
  simp only [warmRobinPairSystemToOriginal_one,
    warmRobinPairSystemToOriginal_zero, warmRobinIntegerTargetRat]
  rw [warmRobinIntegerTarget_pair_high_low]

@[simp] theorem warmRobinPairNormalizedTargetRat_one_one
    (row column : Fin 4) :
    warmRobinPairNormalizedTargetRat (1, row) (1, column) =
      (warmRobinIntegerTarget
        (warmRobinPairLow row) (warmRobinPairLow column) : Rat) / 224 := by
  unfold warmRobinPairNormalizedTargetRat
  simp only [warmRobinPairSystemToOriginal_one, warmRobinIntegerTargetRat]
  rw [warmRobinIntegerTarget_pair_high_high]

/-- Complex view of the pair-ordered normalized Robin target. -/
def warmRobinPairNormalizedTargetComplex :
    _root_.Matrix WarmRobinSymmetrySystem WarmRobinSymmetrySystem ℂ :=
  fun row column => (warmRobinPairNormalizedTargetRat row column : ℂ)

/-- Complex view of the direct-sum sector target. -/
def warmRobinFourSlotSectorTargetComplex :
    _root_.Matrix WarmRobinSymmetrySystem WarmRobinSymmetrySystem ℂ :=
  fun row column => (warmRobinFourSlotSectorTarget row column : ℂ)

/-- The exact symmetry transform reconstructs the pair-ordered Robin matrix. -/
theorem warmRobinSymmetryBasisChange_conjugates_target :
    warmRobinSymmetryBasisChange *
        (warmRobinFourSlotSectorTargetComplex *
          star warmRobinSymmetryBasisChange) =
      warmRobinPairNormalizedTargetComplex := by
  classical
  ext ⟨rowSide, rowPair⟩ ⟨columnSide, columnPair⟩
  fin_cases rowSide <;> fin_cases columnSide <;>
    fin_cases rowPair <;> fin_cases columnPair <;>
    norm_num [warmRobinSymmetryBasisChange,
      warmRobinFourSlotSectorTargetComplex,
      warmRobinPairNormalizedTargetComplex,
      warmRobinPairNormalizedTargetRat,
      warmRobinFourSlotSectorTarget,
      warmRobinUniformBitPrepare,
      realOrthogonalRotation,
      _root_.Matrix.mul_apply,
      _root_.Matrix.one_apply,
      Fintype.sum_prod_type,
      Fin.sum_univ_two,
      Fin.sum_univ_succ,
      warmRobinSymmetryPlusBlock,
      warmRobinSymmetryMinusBlock,
      warmRobinIntegerTargetRat,
      warmRobinIntegerTarget,
      warmRobinPairSystemToOriginal,
      warmRobinPairLow,
      warmRobinPairHigh,
      warmRobinReverse8] <;>
    ring_nf <;>
    norm_num [Real.sq_sqrt]

/-- Conjugate the sector logical unitary back to reversal-pair coordinates. -/
noncomputable def warmRobinFourSlotPairLogicalUnitary :
    _root_.Matrix
      (LCUIndex (Fin 2) (Fin 4) WarmRobinSymmetrySystem)
      (LCUIndex (Fin 2) (Fin 4) WarmRobinSymmetrySystem) ℂ :=
  conjugateSystem warmRobinSymmetryBasisChange
    warmRobinFourSlotMiddleLogicalUnitary

/-- The pair-basis logical unitary remains exactly unitary. -/
theorem warmRobinFourSlotPairLogicalUnitary_unitary :
    warmRobinFourSlotPairLogicalUnitary ∈
      _root_.Matrix.unitaryGroup
        (LCUIndex (Fin 2) (Fin 4) WarmRobinSymmetrySystem) ℂ := by
  apply conjugateSystem_unitary
  · exact warmRobinSymmetryBasisChange_unitary
  · exact warmRobinFourSlotMiddleLogicalUnitary_unitary

/-- Its clean system block is the pair-ordered normalized Robin target. -/
theorem warmRobinFourSlotPairLogicalUnitary_cleanSystemBlock :
    cleanSystemBlock warmRobinFourSlotPairLogicalUnitary 0 0 =
      warmRobinPairNormalizedTargetComplex := by
  rw [warmRobinFourSlotPairLogicalUnitary,
    cleanSystemBlock_conjugateSystem,
    warmRobinFourSlotMiddleLogicalUnitary_cleanSystemBlock]
  exact warmRobinSymmetryBasisChange_conjugates_target

/-- Entry form of the pair-basis clean-block certificate. -/
theorem warmRobinFourSlotPairLogicalUnitary_cleanEntry
    (row column : WarmRobinSymmetrySystem) :
    warmRobinFourSlotPairLogicalUnitary
        (0, (0, row)) (0, (0, column)) =
      warmRobinPairNormalizedTargetComplex row column := by
  have matrixEquality :=
    warmRobinFourSlotPairLogicalUnitary_cleanSystemBlock
  exact congr_fun (congr_fun matrixEquality row) column

/-- Reindex only the system component from pair order to original `Fin 8`. -/
noncomputable def warmRobinFourSlotProductSystemEquiv :
    LCUIndex (Fin 2) (Fin 4) WarmRobinSymmetrySystem ≃
      LCUIndex (Fin 2) (Fin 4) (Fin 8) :=
  Equiv.prodCongr (Equiv.refl (Fin 2))
    (Equiv.prodCongr (Equiv.refl (Fin 4)) warmRobinPairSystemEquiv)

/-- Flatten coefficient × selector × original system into six qubits. -/
def warmRobinFourSlotOriginalIndexEquiv :
    LCUIndex (Fin 2) (Fin 4) (Fin 8) ≃ Fin (gridSize 6) :=
  (Equiv.prodCongr (Equiv.refl (Fin 2)) finProdFinEquiv).trans
    finProdFinEquiv

/-- Combined system reindexing and six-qubit flattening. -/
noncomputable def warmRobinFourSlotIndexEquiv :
    LCUIndex (Fin 2) (Fin 4) WarmRobinSymmetrySystem ≃
      Fin (gridSize 6) :=
  warmRobinFourSlotProductSystemEquiv.trans
    warmRobinFourSlotOriginalIndexEquiv

/-- Flat clean index for an original Robin system basis state. -/
noncomputable def warmRobinFourSlotCleanIndex (system : Fin 8) : Fin (gridSize 6) :=
  warmRobinFourSlotIndexEquiv
    (0, (0, warmRobinPairSystemEquiv.symm system))

/-- Six-qubit matrix in the original system order. -/
noncomputable def warmRobinFourSlotFlatUnitary :
    _root_.Matrix (Fin (gridSize 6)) (Fin (gridSize 6)) ℂ :=
  _root_.Matrix.reindexAlgEquiv ℂ ℂ warmRobinFourSlotIndexEquiv
    warmRobinFourSlotPairLogicalUnitary

/-- Reindexing preserves exact unitarity. -/
theorem warmRobinFourSlotFlatUnitary_unitary :
    warmRobinFourSlotFlatUnitary ∈
      _root_.Matrix.unitaryGroup (Fin (gridSize 6)) ℂ := by
  apply reindex_unitary
  exact warmRobinFourSlotPairLogicalUnitary_unitary

/-- Applying the flat matrix at flattened indices recovers the product entry. -/
@[simp] theorem warmRobinFourSlotFlatUnitary_reindex
    (row column :
      LCUIndex (Fin 2) (Fin 4) WarmRobinSymmetrySystem) :
    warmRobinFourSlotFlatUnitary
        (warmRobinFourSlotIndexEquiv row)
        (warmRobinFourSlotIndexEquiv column) =
      warmRobinFourSlotPairLogicalUnitary row column := by
  simp [warmRobinFourSlotFlatUnitary]

/-- Pair-ordered target at inverse-reindexed indices is the original target. -/
theorem warmRobinPairNormalizedTargetComplex_symm
    (row column : Fin 8) :
    warmRobinPairNormalizedTargetComplex
        (warmRobinPairSystemEquiv.symm row)
        (warmRobinPairSystemEquiv.symm column) =
      ((warmRobinIntegerTargetRat row column / 224 : Rat) : ℂ) := by
  simp [warmRobinPairNormalizedTargetComplex,
    warmRobinPairNormalizedTargetRat]

/-- The flat clean block is exactly the original fixed Robin target. -/
theorem warmRobinFourSlotFlatUnitary_cleanBlock
    (row column : Fin 8) :
    warmRobinFourSlotFlatUnitary
        (warmRobinFourSlotCleanIndex row)
        (warmRobinFourSlotCleanIndex column) =
      ((RobinEvolution.warmRobinTarget row column /
        RobinEvolution.warmRobinNormalizer : Rat) : ℂ) := by
  unfold warmRobinFourSlotCleanIndex
  rw [warmRobinFourSlotFlatUnitary_reindex]
  rw [warmRobinFourSlotPairLogicalUnitary_cleanEntry]
  rw [warmRobinPairNormalizedTargetComplex_symm]
  have normalizedIdentity := congr_fun
    (congr_fun warmRobin_normalized_eq_integer_div_224 row) column
  exact_mod_cast normalizedIdentity.symm

/-- Fair T2 logical-stage schedule for the four-slot construction. -/
def warmRobinFourSlotT2Schedule : LayeredCircuit :=
  [ [ Gate.oneQubit "T2 selector-H-0" 0
    , Gate.oneQubit "T2 selector-H-1" 1
    , Gate.oneQubit "T2 symmetry-basis-change" 3 ]
  , [ Gate.oracleCall "T2 controlled amplitude rotation" ]
  , [ Gate.oracleCall "T2 sector-preserving SELECT" ]
  , [ Gate.oneQubit "T2 selector-H-0 dagger" 0
    , Gate.oneQubit "T2 selector-H-1 dagger" 1
    , Gate.oneQubit "T2 symmetry-basis-change dagger" 3 ]
  ]

/-- The corresponding logical gate list. -/
def warmRobinFourSlotT2Circuit : Circuit :=
  warmRobinFourSlotT2Schedule.flatten

/-- Exact resource row under the declared T2 logical-stage convention. -/
def warmRobinFourSlotT2Resource : Resource :=
  warmRobinFourSlotT2Schedule.resource

/-- The operator-first clean-block predicate for the four-slot route. -/
def warmRobinFourSlotBlockContainsTarget : Prop :=
  ∀ row column : Fin 8,
    warmRobinFourSlotFlatUnitary
        (warmRobinFourSlotCleanIndex row)
        (warmRobinFourSlotCleanIndex column) =
      warmRobinQueryTarget.operator row column /
        warmRobinQueryTarget.normalizer

/-- The clean-block predicate is discharged by the original-basis theorem. -/
theorem warmRobinFourSlotBlockContainsTarget_proof :
    warmRobinFourSlotBlockContainsTarget := by
  intro row column
  rw [warmRobinFourSlotFlatUnitary_cleanBlock]
  norm_num [warmRobinQueryTarget, warmRobinComplexTarget]

/-- Four-slot T2 candidate for the fixed `N=8` Robin target. -/
noncomputable def warmRobinFourSlotOperatorCandidate :
    OperatorBlockEncodingCandidate ℂ 3 where
  auxiliaryQubits := 3
  target := warmRobinQueryTarget
  unitary := warmRobinFourSlotFlatUnitary
  layout := {
    systemQubits := 3
    signalQubits := 3
    pureAncillas := 0
  }
  circuit := warmRobinFourSlotT2Circuit
  schedule := warmRobinFourSlotT2Schedule
  resource := warmRobinFourSlotT2Resource
  layoutMatches := by decide
  isUnitary :=
    warmRobinFourSlotFlatUnitary ∈
      _root_.Matrix.unitaryGroup (Fin (gridSize 6)) ℂ
  blockContainsTarget := warmRobinFourSlotBlockContainsTarget

/-- Fully verified T2 block encoding for the four-slot symmetry route. -/
noncomputable def warmRobinFourSlotVerifiedBlockEncoding :
    VerifiedOperatorBlockEncoding ℂ 3 where
  candidate := warmRobinFourSlotOperatorCandidate
  unitaryProof := warmRobinFourSlotFlatUnitary_unitary
  blockProof := warmRobinFourSlotBlockContainsTarget_proof

/-- Honest boundary: primitive synthesis and refinement remain a T3 obligation. -/
def warmRobinFourSlotT3BlockedLeaf : String :=
  "prove that a concrete primitive circuit refines warmRobinFourSlotFlatUnitary and certify its primitive resource counts"

end QuantumBlockEncoding.Robin

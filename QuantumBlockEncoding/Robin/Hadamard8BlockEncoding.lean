import QuantumBlockEncoding.Robin.Hadamard8Verified
import QuantumBlockEncoding.BlockEncoding
import Mathlib.Tactic

/-!
# Verified Robin block encoding from the Hadamard-8 logical unitary

This module closes the fixed `N = 8` T2 route.  It specializes the reusable
clean-entry theorem to the Robin coefficient and permutation tables, flattens
the coefficient-selector-system product to seven qubits, and promotes the
result to `VerifiedOperatorBlockEncoding`.

The resource record below uses an explicitly named T2 logical-stage
convention.  It is not a primitive `{u, cx}` refinement claim.
-/

namespace QuantumBlockEncoding.Robin

open ComplexLCU

/-- Flatten coefficient × selector × system into the seven-qubit basis. -/
def warmRobinHadamard8IndexEquiv :
    LCUIndex (Fin 2) (Fin 8) (Fin 8) ≃ Fin (gridSize 7) :=
  (Equiv.prodCongr (Equiv.refl (Fin 2)) finProdFinEquiv).trans
    finProdFinEquiv

/-- The clean coefficient/selector branch embedded in the flat seven-qubit basis. -/
def warmRobinHadamard8CleanIndex (system : Fin 8) : Fin (gridSize 7) :=
  warmRobinHadamard8IndexEquiv (0, (0, system))

@[simp] theorem warmRobinHadamard8CleanIndex_value (system : Fin 8) :
    (warmRobinHadamard8CleanIndex system).val = system.val := by
  rfl

/-- The product-register logical unitary reindexed as a seven-qubit matrix. -/
noncomputable def warmRobinHadamard8FlatUnitary :
    _root_.Matrix (Fin (gridSize 7)) (Fin (gridSize 7)) ℂ :=
  _root_.Matrix.reindexAlgEquiv ℂ ℂ warmRobinHadamard8IndexEquiv
    warmRobinHadamard8LogicalUnitary

/-- Reindexing preserves the exact Mathlib unitary-group certificate. -/
theorem warmRobinHadamard8FlatUnitary_unitary :
    warmRobinHadamard8FlatUnitary ∈
      _root_.Matrix.unitaryGroup (Fin (gridSize 7)) ℂ := by
  apply reindex_unitary
  exact warmRobinHadamard8LogicalUnitary_unitary

/-- Applying the reindexed matrix at reindexed indices recovers the product entry. -/
@[simp] theorem warmRobinHadamard8FlatUnitary_reindex
    (row column : LCUIndex (Fin 2) (Fin 8) (Fin 8)) :
    warmRobinHadamard8FlatUnitary
        (warmRobinHadamard8IndexEquiv row)
        (warmRobinHadamard8IndexEquiv column) =
      warmRobinHadamard8LogicalUnitary row column := by
  simp [warmRobinHadamard8FlatUnitary]

/-- Every row of the one-bit PREPARE has the same clean-column amplitude. -/
@[simp] theorem warmRobinUniformBitPrepare_cleanColumn (bit : Fin 2) :
    warmRobinUniformBitPrepare bit 0 =
      ((Real.sqrt 2 / 2 : Real) : ℂ) := by
  fin_cases bit <;> rfl

/-- The three-bit tensor PREPARE has a uniform clean column. -/
@[simp] theorem warmRobinHadamardBitsPrepare_cleanColumn
    (bits : WarmRobinHadamardBits) :
    warmRobinHadamardBitsPrepare bits (0, (0, 0)) =
      (((Real.sqrt 2 / 2 : Real) : ℂ) *
        ((Real.sqrt 2 / 2 : Real) : ℂ) *
        ((Real.sqrt 2 / 2 : Real) : ℂ)) := by
  rcases bits with ⟨first, ⟨second, third⟩⟩
  simp [warmRobinHadamardBitsPrepare]
  ring

/-- The flattened selector PREPARE still has a uniform clean column. -/
@[simp] theorem warmRobinHadamard8SelectorPrepare_cleanColumn (slot : Fin 8) :
    warmRobinHadamard8SelectorPrepare slot 0 =
      (((Real.sqrt 2 / 2 : Real) : ℂ) *
        ((Real.sqrt 2 / 2 : Real) : ℂ) *
        ((Real.sqrt 2 / 2 : Real) : ℂ)) := by
  change warmRobinHadamardBitsPrepare
      (warmRobinHadamardBitsEquiv.symm slot)
      (warmRobinHadamardBitsEquiv.symm 0) = _
  have zeroIndex :
      warmRobinHadamardBitsEquiv.symm 0 = (0, (0, 0)) := by
    decide
  rw [zeroIndex]
  exact warmRobinHadamardBitsPrepare_cleanColumn _

/-- Squared magnitude of each selector amplitude is exactly `1/8`. -/
@[simp] theorem warmRobinHadamard8SelectorPrepare_probability (slot : Fin 8) :
    star (warmRobinHadamard8SelectorPrepare slot 0) *
        warmRobinHadamard8SelectorPrepare slot 0 = (1 / 8 : ℂ) := by
  rw [warmRobinHadamard8SelectorPrepare_cleanColumn]
  let c : Real := Real.sqrt 2 / 2
  have sqrtSquare : (Real.sqrt 2) ^ 2 = (2 : Real) :=
    Real.sq_sqrt (by norm_num)
  have cSquare : c * c = (1 / 2 : Real) := by
    dsimp [c]
    nlinarith
  have realProbability : (c * c * c) * (c * c * c) = (1 / 8 : Real) := by
    calc
      (c * c * c) * (c * c * c) = (c * c) * (c * c) * (c * c) := by ring
      _ = (1 / 2 : Real) * (1 / 2 : Real) * (1 / 2 : Real) := by rw [cSquare]
      _ = 1 / 8 := by norm_num
  apply Complex.ext
  · simpa [c, mul_assoc] using realProbability
  · simp

/-- Rational and real-complex views of a slot coefficient agree. -/
theorem warmRobinHadamard8Coefficient_complex
    (slot column : Fin 8) :
    (warmRobinHadamard8Coefficient slot column : ℂ) =
      (warmRobinEightSlotAmplitude slot column : ℂ) := by
  norm_num [warmRobinHadamard8Coefficient]

/-- The reusable clean-entry expansion specializes to the Robin eight-slot formula. -/
theorem warmRobinHadamard8LogicalUnitary_cleanEntry
    (row column : Fin 8) :
    warmRobinHadamard8LogicalUnitary
        (0, (0, row)) (0, (0, column)) =
      (warmRobinHadamard8CleanFormula row column : ℂ) := by
  unfold warmRobinHadamard8LogicalUnitary
  rw [prepareAmplitudeSelectUnprepare_cleanEntry]
  change
    (∑ slot : Fin 8,
      if warmRobinEightSlotPerm slot column = row then
        star (warmRobinHadamard8SelectorPrepare slot 0) *
          warmRobinHadamard8Rotation slot column 0 0 *
          warmRobinHadamard8SelectorPrepare slot 0
      else 0) = _
  have castFormula :
      (warmRobinHadamard8CleanFormula row column : ℂ) =
        (1 / 8 : ℂ) * ∑ slot : Fin 8,
          if warmRobinEightSlotPerm slot column = row then
            (warmRobinEightSlotAmplitude slot column : ℂ)
          else 0 := by
    norm_num [warmRobinHadamard8CleanFormula]
    apply Finset.sum_congr rfl
    intro slot _
    by_cases selected : warmRobinEightSlotPerm slot column = row
    · simp [selected]
    · simp [selected]
  rw [castFormula, Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro slot _
  by_cases selected : warmRobinEightSlotPerm slot column = row
  · simp only [selected, if_pos]
    rw [warmRobinHadamard8Rotation_cleanEntry]
    rw [warmRobinHadamard8Coefficient_complex]
    rw [← warmRobinHadamard8SelectorPrepare_probability slot]
    ring
  · simp [selected]

/-- The product-register clean entry is the normalized fixed Robin target. -/
theorem warmRobinHadamard8LogicalUnitary_cleanEntry_eq_target
    (row column : Fin 8) :
    warmRobinHadamard8LogicalUnitary
        (0, (0, row)) (0, (0, column)) =
      ((RobinEvolution.warmRobinTarget row column /
        RobinEvolution.warmRobinNormalizer : Rat) : ℂ) := by
  rw [warmRobinHadamard8LogicalUnitary_cleanEntry]
  exact_mod_cast warmRobinHadamard8CleanFormula_eq_target row column

/-- The flat seven-qubit clean block is the normalized fixed Robin operator. -/
theorem warmRobinHadamard8FlatUnitary_cleanBlock
    (row column : Fin 8) :
    warmRobinHadamard8FlatUnitary
        (warmRobinHadamard8CleanIndex row)
        (warmRobinHadamard8CleanIndex column) =
      ((RobinEvolution.warmRobinTarget row column /
        RobinEvolution.warmRobinNormalizer : Rat) : ℂ) := by
  unfold warmRobinHadamard8CleanIndex
  rw [warmRobinHadamard8FlatUnitary_reindex]
  exact warmRobinHadamard8LogicalUnitary_cleanEntry_eq_target row column

/-- Complex view of the fixed Robin target used by the operator-first API. -/
def warmRobinComplexTarget : Matrix 8 8 ℂ := fun row column =>
  (RobinEvolution.warmRobinTarget row column : ℂ)

/-- Operator-first target contract for the fixed homogeneous Robin benchmark. -/
def warmRobinQueryTarget : QueryOperatorTarget ℂ 8 8 where
  operator := warmRobinComplexTarget
  normalizer := (RobinEvolution.warmRobinNormalizer : ℂ)
  source := "Guseynov-Huang-Liu 2025, fixed N=8 homogeneous Robin instance"
  semanticContract :=
    "the coefficient=0 and selector=0 clean block equals A/(56/3) exactly"
  freeParameters := []

/-- Four exact logical stages; no primitive decomposition is asserted here. -/
def warmRobinHadamard8T2Circuit : Circuit :=
  [ Gate.oracleCall "T2 selector PREPARE-8"
  , Gate.oracleCall "T2 controlled amplitude rotation"
  , Gate.oracleCall "T2 SELECT permutation"
  , Gate.oracleCall "T2 selector PREPARE-8 dagger"
  ]

/-- Sequential T2 schedule matching the four logical stages. -/
def warmRobinHadamard8T2Schedule : LayeredCircuit :=
  warmRobinHadamard8T2Circuit.map fun gate => [gate]

/-- Resource record under the logical-stage convention, not a T3 primitive count. -/
def warmRobinHadamard8T2Resource : Resource :=
  warmRobinHadamard8T2Circuit.resource

/-- The exact block predicate attached to the operator candidate. -/
def warmRobinHadamard8BlockContainsTarget : Prop :=
  ∀ row column : Fin 8,
    warmRobinHadamard8FlatUnitary
        (warmRobinHadamard8CleanIndex row)
        (warmRobinHadamard8CleanIndex column) =
      warmRobinQueryTarget.operator row column /
        warmRobinQueryTarget.normalizer

/-- The clean-block predicate follows from the specialized clean-entry theorem. -/
theorem warmRobinHadamard8BlockContainsTarget_proof :
    warmRobinHadamard8BlockContainsTarget := by
  intro row column
  rw [warmRobinHadamard8FlatUnitary_cleanBlock]
  norm_num [warmRobinQueryTarget, warmRobinComplexTarget]

/-- Fixed `N=8` Hadamard-8 candidate at the exact logical-unitary tier. -/
noncomputable def warmRobinHadamard8OperatorCandidate :
    OperatorBlockEncodingCandidate ℂ 3 where
  auxiliaryQubits := 4
  target := warmRobinQueryTarget
  unitary := warmRobinHadamard8FlatUnitary
  layout := {
    systemQubits := 3
    signalQubits := 4
    pureAncillas := 0
  }
  circuit := warmRobinHadamard8T2Circuit
  schedule := warmRobinHadamard8T2Schedule
  resource := warmRobinHadamard8T2Resource
  layoutMatches := by decide
  isUnitary :=
    warmRobinHadamard8FlatUnitary ∈
      _root_.Matrix.unitaryGroup (Fin (gridSize 7)) ℂ
  blockContainsTarget := warmRobinHadamard8BlockContainsTarget

/-- Fully verified T2 block encoding of the fixed Robin matrix. -/
noncomputable def warmRobinHadamard8VerifiedBlockEncoding :
    VerifiedOperatorBlockEncoding ℂ 3 where
  candidate := warmRobinHadamard8OperatorCandidate
  unitaryProof := warmRobinHadamard8FlatUnitary_unitary
  blockProof := warmRobinHadamard8BlockContainsTarget_proof

/-- Honest boundary: primitive synthesis/refinement is still a separate T3 theorem. -/
def warmRobinHadamard8T3BlockedLeaf : String :=
  "prove that a concrete primitive circuit refines warmRobinHadamard8FlatUnitary and certify its primitive resource counts"

end QuantumBlockEncoding.Robin

import QuantumBlockEncoding.ConcreteSemantics
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Basic
import Mathlib.Data.Matrix.Block
import Mathlib.LinearAlgebra.Matrix.Kronecker
import Mathlib.LinearAlgebra.Matrix.Reindex
import Mathlib.Tactic

/-!
# Reusable complex-unitary LCU semantics

This module provides the concrete finite-dimensional semantic kernel required
by the Robin T2 candidates. It proves exact complex unitarity for amplitude
rotations, block-diagonal controlled families, basis permutations, tensor
lifts, reindexing, and the complete logical
`PREPARE† · SELECT · AMPLITUDE · PREPARE` composition.
-/

namespace QuantumBlockEncoding.Robin.ComplexLCU

open scoped Kronecker

/-- A real planar rotation with explicit cosine and sine entries, embedded in `ℂ`. -/
noncomputable def realOrthogonalRotation (cosine sine : Real) :
    _root_.Matrix (Fin 2) (Fin 2) ℂ := fun row column =>
  match row.val, column.val with
  | 0, 0 => (cosine : ℂ)
  | 0, _ => -(sine : ℂ)
  | _, 0 => (sine : ℂ)
  | _, _ => (cosine : ℂ)

/-- A real planar rotation is unitary whenever its two entries lie on the unit circle. -/
theorem realOrthogonalRotation_unitary
    (cosine sine : Real) (normalization : cosine * cosine + sine * sine = 1) :
    realOrthogonalRotation cosine sine ∈
      _root_.Matrix.unitaryGroup (Fin 2) ℂ := by
  rw [_root_.Matrix.mem_unitaryGroup_iff']
  ext row column
  fin_cases row <;> fin_cases column
  · have hcast : (((cosine * cosine + sine * sine : Real) : ℂ)) = 1 := by
      exact_mod_cast normalization
    simpa [realOrthogonalRotation, _root_.Matrix.mul_apply,
      Fin.sum_univ_two] using hcast
  · simp [realOrthogonalRotation, _root_.Matrix.mul_apply,
      Fin.sum_univ_two]
    ring
  · simp [realOrthogonalRotation, _root_.Matrix.mul_apply,
      Fin.sum_univ_two]
    ring
  · have normalization' : sine * sine + cosine * cosine = 1 := by
      calc
        sine * sine + cosine * cosine =
            cosine * cosine + sine * sine := by ring
        _ = 1 := normalization
    have hcast : (((sine * sine + cosine * cosine : Real) : ℂ)) = 1 := by
      exact_mod_cast normalization'
    simpa [realOrthogonalRotation, _root_.Matrix.mul_apply,
      Fin.sum_univ_two] using hcast

/-- A real planar rotation, parameterized by an angle. -/
noncomputable def realRotation (angle : Real) :
    _root_.Matrix (Fin 2) (Fin 2) ℂ :=
  realOrthogonalRotation (Real.cos angle) (Real.sin angle)

@[simp] theorem realRotation_zero_zero (angle : Real) :
    realRotation angle 0 0 = (Real.cos angle : ℂ) := by
  rfl

@[simp] theorem realRotation_zero_one (angle : Real) :
    realRotation angle 0 1 = -(Real.sin angle : ℂ) := by
  rfl

@[simp] theorem realRotation_one_zero (angle : Real) :
    realRotation angle 1 0 = (Real.sin angle : ℂ) := by
  rfl

@[simp] theorem realRotation_one_one (angle : Real) :
    realRotation angle 1 1 = (Real.cos angle : ℂ) := by
  rfl

/-- Every real planar rotation is unitary over `ℂ`. -/
theorem realRotation_unitary (angle : Real) :
    realRotation angle ∈
      _root_.Matrix.unitaryGroup (Fin 2) ℂ := by
  apply realOrthogonalRotation_unitary
  nlinarith [Real.sin_sq_add_cos_sq angle]

/-- Rotation whose clean entry is intended to encode `coefficient`. -/
noncomputable def amplitudeRotation (coefficient : Real) :
    _root_.Matrix (Fin 2) (Fin 2) ℂ :=
  realRotation (Real.arccos coefficient)

/-- The amplitude rotation is unitary without any domain hypothesis. -/
theorem amplitudeRotation_unitary (coefficient : Real) :
    amplitudeRotation coefficient ∈
      _root_.Matrix.unitaryGroup (Fin 2) ℂ :=
  realRotation_unitary _

/-- Under the standard arccos domain, the clean entry is exactly the coefficient. -/
theorem amplitudeRotation_cleanEntry
    (coefficient : Real) (lower : -1 ≤ coefficient) (upper : coefficient ≤ 1) :
    amplitudeRotation coefficient 0 0 = (coefficient : ℂ) := by
  simp [amplitudeRotation, Real.cos_arccos lower upper]

/-- Reindexing rows and columns by the same equivalence preserves unitarity. -/
theorem reindex_unitary
    {ι κ : Type*} [Fintype ι] [DecidableEq ι]
    [Fintype κ] [DecidableEq κ]
    (equiv : ι ≃ κ) (operator : _root_.Matrix ι ι ℂ)
    (unitary : operator ∈ _root_.Matrix.unitaryGroup ι ℂ) :
    _root_.Matrix.reindexAlgEquiv ℂ ℂ equiv operator ∈
      _root_.Matrix.unitaryGroup κ ℂ := by
  rw [_root_.Matrix.mem_unitaryGroup_iff'] at unitary ⊢
  have star_reindex :
      star (_root_.Matrix.reindexAlgEquiv ℂ ℂ equiv operator) =
        _root_.Matrix.reindexAlgEquiv ℂ ℂ equiv (star operator) := by
    ext row column
    rfl
  rw [star_reindex, ← _root_.Matrix.reindexAlgEquiv_mul, unitary]
  simp

/-- A finite family of unitary blocks is unitary when placed block-diagonally. -/
theorem blockDiagonal_unitary
    {ι κ : Type*} [Fintype ι] [DecidableEq ι]
    [Fintype κ] [DecidableEq κ]
    (blocks : κ → _root_.Matrix ι ι ℂ)
    (unitary : ∀ k, blocks k ∈ _root_.Matrix.unitaryGroup ι ℂ) :
    _root_.Matrix.blockDiagonal blocks ∈
      _root_.Matrix.unitaryGroup (ι × κ) ℂ := by
  rw [_root_.Matrix.mem_unitaryGroup_iff']
  have star_blockDiagonal :
      star (_root_.Matrix.blockDiagonal blocks) =
        _root_.Matrix.blockDiagonal (fun k => star (blocks k)) := by
    ext ⟨row, blockRow⟩ ⟨column, blockColumn⟩
    by_cases h : blockRow = blockColumn
    · subst blockColumn
      simp [_root_.Matrix.blockDiagonal_apply]
    · have h' : blockColumn ≠ blockRow := Ne.symm h
      simp [_root_.Matrix.blockDiagonal_apply, h, h']
  rw [star_blockDiagonal, ← _root_.Matrix.blockDiagonal_mul]
  have pointwise :
      (fun k => star (blocks k) * blocks k) =
        (1 : κ → _root_.Matrix ι ι ℂ) := by
    funext k
    exact _root_.Matrix.mem_unitaryGroup_iff'.mp (unitary k)
  rw [pointwise, _root_.Matrix.blockDiagonal_one]

/-- Matrix of a finite basis permutation. -/
def equivPermutationMatrix
    {ι : Type*} [DecidableEq ι] (equiv : ι ≃ ι) :
    _root_.Matrix ι ι ℂ := fun row column =>
  if row = equiv column then 1 else 0

/-- Every equivalence induces a unitary permutation matrix. -/
theorem equivPermutationMatrix_unitary
    {ι : Type*} [Fintype ι] [DecidableEq ι] (equiv : ι ≃ ι) :
    equivPermutationMatrix equiv ∈
      _root_.Matrix.unitaryGroup ι ℂ := by
  rw [_root_.Matrix.mem_unitaryGroup_iff']
  ext row column
  by_cases equal : row = column
  · subst column
    simp [equivPermutationMatrix, _root_.Matrix.mul_apply]
  · have reverse_ne : column ≠ row := Ne.symm equal
    simp [equivPermutationMatrix, _root_.Matrix.mul_apply, equal, reverse_ne]

/-- Multiplication by a permutation matrix applies the inverse permutation to rows. -/
theorem equivPermutationMatrix_mul_apply
    {ι κ : Type*} [Fintype ι] [DecidableEq ι]
    (equiv : ι ≃ ι) (operator : _root_.Matrix ι κ ℂ)
    (row : ι) (column : κ) :
    (equivPermutationMatrix equiv * operator) row column =
      operator (equiv.symm row) column := by
  classical
  rw [_root_.Matrix.mul_apply]
  rw [Finset.sum_eq_single (equiv.symm row)]
  · simp [equivPermutationMatrix]
  · intro candidate _ candidate_ne
    have miss : row ≠ equiv candidate := by
      intro hit
      apply candidate_ne
      apply equiv.injective
      calc
        equiv candidate = row := hit.symm
        _ = equiv (equiv.symm row) :=
          (equiv.apply_symm_apply row).symm
    simp [equivPermutationMatrix, miss]
  · simp

/-- Product-register index for coefficient, selector, and system registers. -/
abbrev LCUIndex (coefficient selector system : Type*) :=
  coefficient × (selector × system)

/-- Lift selector PREPARE to coefficient × selector × system. -/
def selectorLift
    {coefficient selector system : Type*}
    [Fintype coefficient] [DecidableEq coefficient]
    [Fintype selector] [DecidableEq selector]
    [Fintype system] [DecidableEq system]
    (prepare : _root_.Matrix selector selector ℂ) :
    _root_.Matrix
      (LCUIndex coefficient selector system)
      (LCUIndex coefficient selector system) ℂ :=
  (1 : _root_.Matrix coefficient coefficient ℂ) ⊗ₖ
    (prepare ⊗ₖ (1 : _root_.Matrix system system ℂ))

/-- A unitary selector PREPARE remains unitary after tensoring with identities. -/
theorem selectorLift_unitary
    {coefficient selector system : Type*}
    [Fintype coefficient] [DecidableEq coefficient]
    [Fintype selector] [DecidableEq selector]
    [Fintype system] [DecidableEq system]
    (prepare : _root_.Matrix selector selector ℂ)
    (unitary : prepare ∈ _root_.Matrix.unitaryGroup selector ℂ) :
    selectorLift (coefficient := coefficient) (system := system) prepare ∈
      _root_.Matrix.unitaryGroup
        (LCUIndex coefficient selector system) ℂ := by
  apply _root_.Matrix.kronecker_mem_unitary
  · exact (_root_.Matrix.unitaryGroup coefficient ℂ).one_mem
  · apply _root_.Matrix.kronecker_mem_unitary
    · exact unitary
    · exact (_root_.Matrix.unitaryGroup system ℂ).one_mem

/-- Lift a coefficient-unitary family controlled by selector and system. -/
def amplitudeLift
    {coefficient selector system : Type*}
    [Fintype coefficient] [DecidableEq coefficient]
    [Fintype selector] [DecidableEq selector]
    [Fintype system] [DecidableEq system]
    (rotation : selector → system →
      _root_.Matrix coefficient coefficient ℂ) :
    _root_.Matrix
      (LCUIndex coefficient selector system)
      (LCUIndex coefficient selector system) ℂ :=
  _root_.Matrix.blockDiagonal (fun context => rotation context.1 context.2)

/-- A controlled family of unitary amplitude blocks is unitary. -/
theorem amplitudeLift_unitary
    {coefficient selector system : Type*}
    [Fintype coefficient] [DecidableEq coefficient]
    [Fintype selector] [DecidableEq selector]
    [Fintype system] [DecidableEq system]
    (rotation : selector → system →
      _root_.Matrix coefficient coefficient ℂ)
    (unitary : ∀ selector system,
      rotation selector system ∈
        _root_.Matrix.unitaryGroup coefficient ℂ) :
    amplitudeLift rotation ∈
      _root_.Matrix.unitaryGroup
        (LCUIndex coefficient selector system) ℂ := by
  apply blockDiagonal_unitary
  intro context
  exact unitary context.1 context.2

/-- SELECT equivalence preserving coefficient and selector and permuting the system. -/
def controlledSystemEquiv
    {coefficient selector system : Type*}
    (permutation : selector → system ≃ system) :
    LCUIndex coefficient selector system ≃
      LCUIndex coefficient selector system where
  toFun index :=
    (index.1, (index.2.1, permutation index.2.1 index.2.2))
  invFun index :=
    (index.1, (index.2.1, (permutation index.2.1).symm index.2.2))
  left_inv index := by
    simp
  right_inv index := by
    simp

/-- Logical SELECT matrix for a family of system permutations. -/
def selectLift
    {coefficient selector system : Type*}
    [DecidableEq coefficient] [DecidableEq selector] [DecidableEq system]
    (permutation : selector → system ≃ system) :
    _root_.Matrix
      (LCUIndex coefficient selector system)
      (LCUIndex coefficient selector system) ℂ :=
  equivPermutationMatrix (controlledSystemEquiv permutation)

/-- SELECT is unitary because it is a basis permutation. -/
theorem selectLift_unitary
    {coefficient selector system : Type*}
    [Fintype coefficient] [DecidableEq coefficient]
    [Fintype selector] [DecidableEq selector]
    [Fintype system] [DecidableEq system]
    (permutation : selector → system ≃ system) :
    selectLift (coefficient := coefficient) permutation ∈
      _root_.Matrix.unitaryGroup
        (LCUIndex coefficient selector system) ℂ :=
  equivPermutationMatrix_unitary _

/-- PREPARE → amplitude → SELECT → unprepare logical matrix. -/
noncomputable def prepareAmplitudeSelectUnprepare
    {coefficient selector system : Type*}
    [Fintype coefficient] [DecidableEq coefficient]
    [Fintype selector] [DecidableEq selector]
    [Fintype system] [DecidableEq system]
    (prepare : _root_.Matrix selector selector ℂ)
    (rotation : selector → system →
      _root_.Matrix coefficient coefficient ℂ)
    (permutation : selector → system ≃ system) :
    _root_.Matrix
      (LCUIndex coefficient selector system)
      (LCUIndex coefficient selector system) ℂ :=
  star (selectorLift (coefficient := coefficient) (system := system) prepare) *
    (selectLift (coefficient := coefficient) permutation *
      (amplitudeLift rotation *
        selectorLift (coefficient := coefficient) (system := system) prepare))

/-- The complete logical LCU composition is unitary from its local certificates. -/
theorem prepareAmplitudeSelectUnprepare_unitary
    {coefficient selector system : Type*}
    [Fintype coefficient] [DecidableEq coefficient]
    [Fintype selector] [DecidableEq selector]
    [Fintype system] [DecidableEq system]
    (prepare : _root_.Matrix selector selector ℂ)
    (rotation : selector → system →
      _root_.Matrix coefficient coefficient ℂ)
    (permutation : selector → system ≃ system)
    (prepareUnitary :
      prepare ∈ _root_.Matrix.unitaryGroup selector ℂ)
    (rotationUnitary : ∀ selector system,
      rotation selector system ∈
        _root_.Matrix.unitaryGroup coefficient ℂ) :
    prepareAmplitudeSelectUnprepare prepare rotation permutation ∈
      _root_.Matrix.unitaryGroup
        (LCUIndex coefficient selector system) ℂ := by
  apply (_root_.Matrix.unitaryGroup
    (LCUIndex coefficient selector system) ℂ).mul_mem
  · exact Unitary.star_mem
      (selectorLift_unitary (coefficient := coefficient) (system := system)
        prepare prepareUnitary)
  · apply (_root_.Matrix.unitaryGroup
      (LCUIndex coefficient selector system) ℂ).mul_mem
    · exact selectLift_unitary (coefficient := coefficient) permutation
    · apply (_root_.Matrix.unitaryGroup
        (LCUIndex coefficient selector system) ℂ).mul_mem
      · exact amplitudeLift_unitary rotation rotationUnitary
      · exact selectorLift_unitary (coefficient := coefficient)
          (system := system) prepare prepareUnitary

end QuantumBlockEncoding.Robin.ComplexLCU

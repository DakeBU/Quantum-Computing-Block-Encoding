import QuantumBlockEncoding.ConcreteSemantics
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Basic
import Mathlib.Tactic

/-!
# Reusable complex-unitary LCU semantics

This module begins the concrete semantic bridge required by the Robin T2
candidates. The first proof block is an exact two-dimensional real rotation,
viewed as a complex unitary matrix. Later declarations build controlled
families, permutation SELECT gates, and PREPARE/amplitude/SELECT composition on
this kernel.
-/

namespace QuantumBlockEncoding.Robin.ComplexLCU

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

end QuantumBlockEncoding.Robin.ComplexLCU

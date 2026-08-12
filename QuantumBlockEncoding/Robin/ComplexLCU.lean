import QuantumBlockEncoding.ConcreteSemantics
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Basic
import Mathlib.Tactic

/-!
# Reusable complex-unitary LCU semantics

This module begins the concrete semantic bridge required by the Robin T2
candidates.  The first proof block is an exact two-dimensional real rotation,
viewed as a complex unitary matrix.  Later declarations build controlled
families, permutation SELECT gates, and PREPARE/amplitude/SELECT composition on
this kernel.
-/

namespace QuantumBlockEncoding.Robin.ComplexLCU

/-- A real planar rotation, embedded entrywise in the complex numbers. -/
noncomputable def realRotation (angle : Real) :
    _root_.Matrix (Fin 2) (Fin 2) ℂ := fun row column =>
  match row.val, column.val with
  | 0, 0 => (Real.cos angle : ℂ)
  | 0, _ => -(Real.sin angle : ℂ)
  | _, 0 => (Real.sin angle : ℂ)
  | _, _ => (Real.cos angle : ℂ)

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
  rw [_root_.Matrix.mem_unitaryGroup_iff']
  ext row column
  fin_cases row <;> fin_cases column <;>
    simp [realRotation, _root_.Matrix.mul_apply, Fin.sum_univ_two,
      _root_.Matrix.one_apply, Real.sin_sq_add_cos_sq] <;> ring

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

import QuantumBlockEncoding.PrimitiveSemantics
import Mathlib.Analysis.CStarAlgebra.Matrix
import Mathlib.Analysis.CStarAlgebra.Basic
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Bounds

/-! conditional angle-error analysis for the actual RY primitive.
All matrix norms here are Euclidean induced L2 operator norms. The actual
wire/spectator lift is retained. The exact difference is a scalar multiple of
a lifted unitary, avoiding entrywise estimates and dimension factors.
No numerical angle computation, input perturbation, or finite-bit cost is
asserted. ExactAngle.eval still has its existing exact-real semantics.
-/
namespace QuantumBlockEncoding.PrimitiveRyPerturbation
open Robin.ComplexLCU
open scoped Matrix.Norms.L2Operator

theorem standardRy_centered_difference (u v : ℝ) :
    standardRyMatrix (u + v) - standardRyMatrix (u - v) =
      ((2 * Real.sin (v / 2) : ℝ) : ℂ) • standardRyMatrix (u + Real.pi) := by
  have ha : (u + v) / 2 = u / 2 + v / 2 := by ring
  have hs : (u - v) / 2 = u / 2 - v / 2 := by ring
  have hp : (u + Real.pi) / 2 = u / 2 + Real.pi / 2 := by ring
  ext row col
  fin_cases row <;> fin_cases col <;>
    simp [standardRyMatrix, realRotation, realOrthogonalRotation, ha, hs, hp,
      Real.cos_add, Real.sin_add, Real.cos_sub, Real.sin_sub] <;> ring

/-- The scalar sign is retained; this is equality, not equality up to phase. -/
theorem standardRy_difference_factor (a b : ℝ) :
    standardRyMatrix a - standardRyMatrix b =
      ((2 * Real.sin ((a - b) / 4) : ℝ) : ℂ) •
        standardRyMatrix ((a + b) / 2 + Real.pi) := by
  have h := standardRy_centered_difference ((a + b) / 2) ((a - b) / 2)
  have ha : (a + b) / 2 + (a - b) / 2 = a := by ring
  have hb : (a + b) / 2 - (a - b) / 2 = b := by ring
  have hv : (a - b) / 2 / 2 = (a - b) / 4 := by ring
  simpa only [ha, hb, hv] using h

theorem lift_sub {qubits : ℕ} (target : Fin qubits)
    (A B : _root_.Matrix (Fin 2) (Fin 2) ℂ) :
    liftPrimitiveOneQubit target (A - B) =
      liftPrimitiveOneQubit target A - liftPrimitiveOneQubit target B := by
  ext row col
  simp only [liftPrimitiveOneQubit_apply, _root_.Matrix.sub_apply]
  split_ifs <;> simp

theorem lift_smul {qubits : ℕ} (target : Fin qubits) (c : ℂ)
    (A : _root_.Matrix (Fin 2) (Fin 2) ℂ) :
    liftPrimitiveOneQubit target (c • A) = c • liftPrimitiveOneQubit target A := by
  ext row col
  simp only [liftPrimitiveOneQubit_apply, _root_.Matrix.smul_apply, smul_eq_mul]
  split_ifs <;> simp

theorem liftedRy_difference_factor {qubits : ℕ} (target : Fin qubits) (a b : ℝ) :
    liftPrimitiveOneQubit target (standardRyMatrix a) -
      liftPrimitiveOneQubit target (standardRyMatrix b) =
      ((2 * Real.sin ((a - b) / 4) : ℝ) : ℂ) •
        liftPrimitiveOneQubit target (standardRyMatrix ((a + b) / 2 + Real.pi)) := by
  rw [← lift_sub, standardRy_difference_factor, lift_smul]

/-- Exact L2 norm for every physical target and every number of spectators. -/
theorem liftedRy_distance {qubits : ℕ} (target : Fin qubits) (a b : ℝ) :
    ‖liftPrimitiveOneQubit target (standardRyMatrix a) -
      liftPrimitiveOneQubit target (standardRyMatrix b)‖ =
      2 * |Real.sin ((a - b) / 4)| := by
  rw [liftedRy_difference_factor, norm_smul,
    CStarRing.norm_of_mem_unitary (liftPrimitiveOneQubit_unitary target _ (standardRyMatrix_unitary _)),
    mul_one]
  rw [Complex.norm_real, Real.norm_eq_abs, abs_mul]
  norm_num

theorem liftedRy_distance_le {qubits : ℕ} (target : Fin qubits) (a b : ℝ) :
    ‖liftPrimitiveOneQubit target (standardRyMatrix a) -
      liftPrimitiveOneQubit target (standardRyMatrix b)‖ ≤ |a - b| / 2 := by
  rw [liftedRy_distance]
  calc
    _ ≤ 2 * |(a - b) / 4| :=
      mul_le_mul_of_nonneg_left (Real.abs_sin_le_abs (x := (a - b) / 4)) (by norm_num)
    _ = _ := by rw [abs_div]; norm_num; ring

/-- This names the existing actual RY gate, not an abstract error assumption. -/
theorem eval_ry_distance {qubits : ℕ} (target : Fin qubits) (a b : ExactAngle) :
    ‖evalPrimitiveGate (.ry target a) - evalPrimitiveGate (.ry target b)‖ =
      2 * |Real.sin ((a.eval - b.eval) / 4)| :=
  liftedRy_distance target a.eval b.eval

theorem eval_ry_distance_le {qubits : ℕ} (target : Fin qubits) (a b : ExactAngle) :
    ‖evalPrimitiveGate (.ry target a) - evalPrimitiveGate (.ry target b)‖ ≤
      |a.eval - b.eval| / 2 := liftedRy_distance_le target a.eval b.eval

/-- Explicit Euclidean continuous-linear-map form removes all norm-scope ambiguity. -/
theorem eval_ry_clm_distance_le {qubits : ℕ} (target : Fin qubits) (a b : ExactAngle) :
    ‖_root_.Matrix.toEuclideanCLM (𝕜 := ℂ) (n := PrimitiveBasis qubits)
      (evalPrimitiveGate (.ry target a) - evalPrimitiveGate (.ry target b))‖ ≤
      |a.eval - b.eval| / 2 := by
  rw [_root_.Matrix.l2_opNorm_toEuclideanCLM]
  exact eval_ry_distance_le target a b

end QuantumBlockEncoding.PrimitiveRyPerturbation

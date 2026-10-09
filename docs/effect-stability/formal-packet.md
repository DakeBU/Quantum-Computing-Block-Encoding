```lean
import Mathlib.Analysis.CStarAlgebra.Matrix
import Mathlib.Analysis.Matrix.Order
import Mathlib.Analysis.CStarAlgebra.ContinuousFunctionalCalculus.Order
import Mathlib.Analysis.InnerProductSpace.Positive
import Mathlib.Tactic


namespace QuantumBlockEncoding.BornStability

open scoped InnerProductSpace Matrix.Norms.L2Operator MatrixOrder

variable {ι : Type*} [Fintype ι] [DecidableEq ι]

noncomputable def probability (U P : Matrix ι ι ℂ)
    (ψ : EuclideanSpace ℂ ι) : ℝ :=
  (inner ℂ (Matrix.toEuclideanCLM (𝕜 := ℂ) U ψ)
    (Matrix.toEuclideanCLM (𝕜 := ℂ) P (Matrix.toEuclideanCLM (𝕜 := ℂ) U ψ))).re

set_option maxHeartbeats 800000 in
set_option backward.isDefEq.respectTransparency false in

theorem effect_norm_le_one (P : Matrix ι ι ℂ) (hP : 0 ≤ P) (hPI : P ≤ 1) :
    ‖P‖ ≤ 1 :=
  by
    letI : CStarAlgebra (Matrix ι ι ℂ) := {}
    exact (CStarAlgebra.norm_le_one_iff_of_nonneg (A := Matrix ι ι ℂ) P hP).mpr hPI

theorem unitary_norm_map (U : Matrix ι ι ℂ)
    (hU : U ∈ Matrix.unitaryGroup ι ℂ) (ψ : EuclideanSpace ℂ ι) :
    ‖Matrix.toEuclideanCLM (𝕜 := ℂ) U ψ‖ = ‖ψ‖ :=
  ContinuousLinearMap.norm_map_of_mem_unitary
    (Unitary.map_mem (Matrix.toEuclideanCLM (𝕜 := ℂ) (n := ι)) hU) ψ


theorem quadratic_difference_le {E : Type*} [NormedAddCommGroup E]
    [InnerProductSpace ℂ E] (P : E →L[ℂ] E) (hP : ‖P‖ ≤ 1)
    (x y : E) (hx : ‖x‖ = 1) (hy : ‖y‖ = 1) :
    |(inner ℂ x (P x)).re - (inner ℂ y (P y)).re| ≤ 2 * ‖x - y‖ := by
  have split : inner ℂ x (P x) - inner ℂ y (P y) =
      inner ℂ (x - y) (P x) + inner ℂ y (P (x - y)) := by
    simp only [map_sub, inner_sub_left, inner_sub_right]
    ring
  have hPx : ‖P x‖ ≤ 1 := by
    calc
      ‖P x‖ ≤ ‖P‖ * ‖x‖ := P.le_opNorm x
      _ ≤ 1 := by simpa [hx] using hP
  have hPxy : ‖P (x - y)‖ ≤ ‖x - y‖ := by
    calc
      _ ≤ ‖P‖ * ‖x - y‖ := P.le_opNorm _
      _ ≤ ‖x - y‖ := by nlinarith [norm_nonneg (x - y)]
  calc
    _ = |(inner ℂ x (P x) - inner ℂ y (P y)).re| := by simp
    _ ≤ ‖inner ℂ x (P x) - inner ℂ y (P y)‖ := Complex.abs_re_le_norm _
    _ ≤ ‖inner ℂ (x - y) (P x)‖ + ‖inner ℂ y (P (x - y))‖ := by
      rw [split]; exact norm_add_le _ _
    _ ≤ ‖x - y‖ * ‖P x‖ + ‖y‖ * ‖P (x - y)‖ :=
      add_le_add (norm_inner_le_norm _ _) (norm_inner_le_norm _ _)
    _ ≤ 2 * ‖x - y‖ := by rw [hy]; nlinarith [norm_nonneg (x - y)]


theorem probability_difference_le (U V P : Matrix ι ι ℂ)
    (ψ : EuclideanSpace ℂ ι) (hψ : ‖ψ‖ = 1)
    (hU : U ∈ Matrix.unitaryGroup ι ℂ) (hV : V ∈ Matrix.unitaryGroup ι ℂ)
    (hP : 0 ≤ P) (hPI : P ≤ 1) {η : ℝ} (hUV : ‖U - V‖ ≤ η) :
    |probability U P ψ - probability V P ψ| ≤ 2 * η := by
  have hPc : ‖Matrix.toEuclideanCLM (𝕜 := ℂ) P‖ ≤ 1 := by
    rw [Matrix.l2_opNorm_toEuclideanCLM]
    exact effect_norm_le_one P hP hPI
  have hd : ‖Matrix.toEuclideanCLM (𝕜 := ℂ) U ψ - Matrix.toEuclideanCLM (𝕜 := ℂ) V ψ‖ ≤ η := by
    calc
      _ = ‖Matrix.toEuclideanCLM (𝕜 := ℂ) (U - V) ψ‖ := by simp
      _ ≤ ‖Matrix.toEuclideanCLM (𝕜 := ℂ) (U - V)‖ * ‖ψ‖ :=
        (Matrix.toEuclideanCLM (𝕜 := ℂ) (U - V)).le_opNorm ψ
      _ ≤ η := by
        rw [hψ, mul_one, Matrix.l2_opNorm_toEuclideanCLM]
        exact hUV
  exact (quadratic_difference_le _ hPc _ _
    (by rw [unitary_norm_map U hU, hψ])
    (by rw [unitary_norm_map V hV, hψ])).trans (by linarith)



theorem probability_mem_Icc (U P : Matrix ι ι ℂ)
    (ψ : EuclideanSpace ℂ ι) (hψ : ‖ψ‖ = 1)
    (hU : U ∈ Matrix.unitaryGroup ι ℂ) (hP : 0 ≤ P) (hPI : P ≤ 1) :
    probability U P ψ ∈ Set.Icc (0 : ℝ) 1 := by
  let x := Matrix.toEuclideanCLM (𝕜 := ℂ) U ψ
  have hx : ‖x‖ = 1 := (unitary_norm_map U hU ψ).trans hψ
  have hpos : (Matrix.toEuclideanCLM (𝕜 := ℂ) P).IsPositive := by
    apply (ContinuousLinearMap.isPositive_toLinearMap_iff _).mp
    rw [Matrix.coe_toEuclideanCLM_eq_toEuclideanLin, Matrix.isPositive_toEuclideanLin_iff]
    exact Matrix.nonneg_iff_posSemidef.mp hP
  refine ⟨hpos.re_inner_nonneg_right x, ?_⟩
  change (inner ℂ x (Matrix.toEuclideanCLM (𝕜 := ℂ) P x)).re ≤ 1
  calc
    _ ≤ ‖inner ℂ x (Matrix.toEuclideanCLM (𝕜 := ℂ) P x)‖ := Complex.re_le_norm _
    _ ≤ ‖x‖ * ‖Matrix.toEuclideanCLM (𝕜 := ℂ) P x‖ := norm_inner_le_norm _ _
    _ ≤ 1 := by
      have hc : ‖Matrix.toEuclideanCLM (𝕜 := ℂ) P‖ ≤ 1 := by
        rw [Matrix.l2_opNorm_toEuclideanCLM]
        exact effect_norm_le_one P hP hPI
      have := (Matrix.toEuclideanCLM (𝕜 := ℂ) P).le_opNorm x
      rw [hx, one_mul]
      rw [hx] at this
      simpa using this.trans (by simpa using hc)

end QuantumBlockEncoding.BornStability
```
```lean
import QuantumBlockEncoding.BornStability
import QuantumBlockEncoding.PrimitiveCircuitPerturbation

namespace QuantumBlockEncoding.CircuitEffectStability

open scoped Matrix.Norms.L2Operator MatrixOrder
open PrimitiveCircuitPerturbation


theorem aligned_probability_difference_le {n : ℕ} {δ : ℝ} (hδ : 0 ≤ δ)
    (exact approximate : PrimitiveCircuit n) (ha : Aligned δ exact approximate)
    (P : _root_.Matrix (PrimitiveBasis n) (PrimitiveBasis n) ℂ)
    (ψ : EuclideanSpace ℂ (PrimitiveBasis n)) (hψ : ‖ψ‖ = 1)
    (hP : 0 ≤ P) (hPI : P ≤ 1) :
    |BornStability.probability (evalPrimitiveCircuit approximate) P ψ -
      BornStability.probability (evalPrimitiveCircuit exact) P ψ| ≤
        (exact.length : ℝ) * δ := by
  have h := BornStability.probability_difference_le
    (evalPrimitiveCircuit approximate) (evalPrimitiveCircuit exact) P ψ hψ
    (evalPrimitiveCircuit_unitary approximate) (evalPrimitiveCircuit_unitary exact)
    hP hPI (aligned_eval_distance_le hδ ha)
  convert h using 1; ring

end QuantumBlockEncoding.CircuitEffectStability
```

```lean
import QuantumBlockEncoding.Resources
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Inverse
import Mathlib.Data.Rat.Defs
import Mathlib.Data.Real.Basic
import Mathlib.Data.Finset.Lattice.Fold



namespace QuantumBlockEncoding

inductive ExactAngle where
  | rational (value : Rat)
  | piRational (value : Rat)
  | twiceArccosRational (value : Rat)
      (bounded : |(value : Real)| ≤ 1)
  | twiceArccosSqrtRational (value : Rat)
      (bounded : 0 ≤ (value : Real) ∧ (value : Real) ≤ 1)
  
  | real (value : Real)
  | add (left right : ExactAngle)
  | neg (value : ExactAngle)
  | scale (factor : Rat) (value : ExactAngle)

private def exactAngleRepr : ExactAngle → Nat → Std.Format
  | .rational value, p => reprPrec value p
  | .piRational value, p => "pi * " ++ reprPrec value p
  | .twiceArccosRational value _, p => "2 * arccos " ++ reprPrec value p
  | .twiceArccosSqrtRational value _, p => "2 * arccos sqrt " ++ reprPrec value p
  | .real _, _ => "<exact real angle; numerical export required>"
  | .add left right, p => "(" ++ exactAngleRepr left p ++ " + " ++ exactAngleRepr right p ++ ")"
  | .neg value, p => "-(" ++ exactAngleRepr value p ++ ")"
  | .scale factor value, p => reprPrec factor p ++ " * (" ++ exactAngleRepr value p ++ ")"

instance : Repr ExactAngle := ⟨exactAngleRepr⟩

namespace ExactAngle

noncomputable def eval : ExactAngle → Real
  | .rational value => (value : Real)
  | .piRational value => Real.pi * (value : Real)
  | .twiceArccosRational value _ => 2 * Real.arccos (value : Real)
  | .twiceArccosSqrtRational value _ =>
      2 * Real.arccos (Real.sqrt (value : Real))
  | .real value => value
  | .add left right => left.eval + right.eval
  | .neg value => -value.eval
  | .scale factor value => (factor : Real) * value.eval

@[simp] theorem eval_add (left right : ExactAngle) :
    (add left right).eval = left.eval + right.eval := rfl

@[simp] theorem eval_neg (value : ExactAngle) :
    (neg value).eval = -value.eval := rfl

@[simp] theorem eval_scale (factor : Rat) (value : ExactAngle) :
    (scale factor value).eval = (factor : Real) * value.eval := rfl

def sub (left right : ExactAngle) : ExactAngle :=
  add left (neg right)

def halfAdd (left right : ExactAngle) : ExactAngle :=
  scale (1 / 2) (add left right)

def halfSub (left right : ExactAngle) : ExactAngle :=
  scale (1 / 2) (sub left right)

@[simp] theorem eval_sub (left right : ExactAngle) :
    (sub left right).eval = left.eval - right.eval := by
  simp [sub, sub_eq_add_neg]

@[simp] theorem eval_half_add (left right : ExactAngle) :
    (halfAdd left right).eval = (left.eval + right.eval) / 2 := by
  simp only [halfAdd, eval_scale, eval_add]
  have halfCast : (((1 / 2 : Rat) : Real)) = (1 : Real) / 2 := by norm_num
  rw [halfCast]
  ring

@[simp] theorem eval_half_sub (left right : ExactAngle) :
    (halfSub left right).eval = (left.eval - right.eval) / 2 := by
  simp only [halfSub, eval_scale, eval_sub]
  have halfCast : (((1 / 2 : Rat) : Real)) = (1 : Real) / 2 := by norm_num
  rw [halfCast]
  ring

end ExactAngle

inductive PrimitiveGate (qubits : Nat) where
  | x (target : Fin qubits)
  | ry (target : Fin qubits) (angle : ExactAngle)
  | rz (target : Fin qubits) (angle : ExactAngle)
  | cx (control target : Fin qubits) (distinct : control ≠ target)

abbrev PrimitiveCircuit (qubits : Nat) := List (PrimitiveGate qubits)


structure PrimitiveProgram (qubits : Nat) where
  circuit : PrimitiveCircuit qubits
  globalPhase : ExactAngle

namespace PrimitiveGate

def dagger {qubits : Nat} : PrimitiveGate qubits → PrimitiveGate qubits
  | .x target => .x target
  | .ry target angle => .ry target (.neg angle)
  | .rz target angle => .rz target (.neg angle)
  | .cx control target distinct => .cx control target distinct

def touched {qubits : Nat} : PrimitiveGate qubits → Finset (Fin qubits)
  | .x target | .ry target _ | .rz target _ => {target}
  | .cx control target _ => {control, target}

def oneQubitCount {qubits : Nat} : PrimitiveGate qubits → Nat
  | .x _ | .ry _ _ | .rz _ _ => 1
  | .cx _ _ _ => 0

def twoQubitCount {qubits : Nat} : PrimitiveGate qubits → Nat
  | .cx _ _ _ => 1
  | _ => 0

end PrimitiveGate

namespace PrimitiveCircuit

def gateCount {qubits : Nat} (circuit : PrimitiveCircuit qubits) : Nat :=
  circuit.length

def oneQubitCount {qubits : Nat} (circuit : PrimitiveCircuit qubits) : Nat :=
  circuit.foldl (fun total gate => total + gate.oneQubitCount) 0

def twoQubitCount {qubits : Nat} (circuit : PrimitiveCircuit qubits) : Nat :=
  circuit.foldl (fun total gate => total + gate.twoQubitCount) 0

def ryCount {qubits : Nat} (circuit : PrimitiveCircuit qubits) : Nat :=
  circuit.countP fun gate => match gate with
    | .ry _ _ => true
    | _ => false

def cxCount {qubits : Nat} (circuit : PrimitiveCircuit qubits) : Nat :=
  circuit.countP fun gate => match gate with
    | .cx _ _ _ => true
    | _ => false

@[simp] theorem ryCount_append {qubits : Nat}
    (left right : PrimitiveCircuit qubits) :
    (left ++ right).ryCount = left.ryCount + right.ryCount := by
  simp [ryCount]

@[simp] theorem cxCount_append {qubits : Nat}
    (left right : PrimitiveCircuit qubits) :
    (left ++ right).cxCount = left.cxCount + right.cxCount := by
  simp [cxCount]

@[simp] theorem ryCount_singleton_ry {qubits : Nat}
    (target : Fin qubits) (angle : ExactAngle) :
    ryCount ([PrimitiveGate.ry target angle] : PrimitiveCircuit qubits) = 1 := by
  rfl

@[simp] theorem ryCount_singleton_cx {qubits : Nat}
    (control target : Fin qubits) (distinct : control ≠ target) :
    ryCount ([PrimitiveGate.cx control target distinct] : PrimitiveCircuit qubits) = 0 := by
  rfl

@[simp] theorem cxCount_singleton_ry {qubits : Nat}
    (target : Fin qubits) (angle : ExactAngle) :
    cxCount ([PrimitiveGate.ry target angle] : PrimitiveCircuit qubits) = 0 := by
  rfl

@[simp] theorem cxCount_singleton_cx {qubits : Nat}
    (control target : Fin qubits) (distinct : control ≠ target) :
    cxCount ([PrimitiveGate.cx control target distinct] : PrimitiveCircuit qubits) = 1 := by
  rfl

def nextWireDepth {qubits : Nat} (depth : Fin qubits → Nat)
    (gate : PrimitiveGate qubits) : Fin qubits → Nat :=
  let layer := gate.touched.sup depth
  fun wire => if wire ∈ gate.touched then layer + 1 else depth wire

def wireDepths {qubits : Nat} (circuit : PrimitiveCircuit qubits) :
    Fin qubits → Nat :=
  circuit.foldl nextWireDepth (fun _ => 0)

def depth {qubits : Nat} (circuit : PrimitiveCircuit qubits) : Nat :=
  Finset.univ.sup circuit.wireDepths

def resource {qubits : Nat} (circuit : PrimitiveCircuit qubits) : Resource :=
  Resource.ofCountsWithDepth circuit.oneQubitCount circuit.twoQubitCount
    0 0 circuit.depth

@[simp] theorem gateCount_eq_length {qubits : Nat}
    (circuit : PrimitiveCircuit qubits) :
    circuit.gateCount = circuit.length := rfl

@[simp] theorem resource_oracleCalls_eq_zero {qubits : Nat}
    (circuit : PrimitiveCircuit qubits) :
    circuit.resource.oracleCalls = 0 := rfl

end PrimitiveCircuit

namespace PrimitiveProgram

def identity (qubits : Nat) : PrimitiveProgram qubits where
  circuit := []
  globalPhase := .rational 0


def seq {qubits : Nat} (left right : PrimitiveProgram qubits) :
    PrimitiveProgram qubits where
  circuit := left.circuit ++ right.circuit
  globalPhase := .add left.globalPhase right.globalPhase

def dagger {qubits : Nat} (program : PrimitiveProgram qubits) :
    PrimitiveProgram qubits where
  circuit := program.circuit.reverse.map PrimitiveGate.dagger
  globalPhase := .neg program.globalPhase

def resource {qubits : Nat} (program : PrimitiveProgram qubits) : Resource :=
  program.circuit.resource

end PrimitiveProgram

end QuantumBlockEncoding

```

```lean
import QuantumBlockEncoding.PrimitiveCircuit
import QuantumBlockEncoding.Robin.Hadamard8Verified
import Mathlib.Tactic



namespace QuantumBlockEncoding

open QuantumBlockEncoding.Robin.ComplexLCU
open scoped Kronecker


noncomputable def standardRyMatrix (theta : Real) :
    _root_.Matrix (Fin 2) (Fin 2) ℂ :=
  realRotation (theta / 2)

@[simp] theorem standardRyMatrix_zero : standardRyMatrix 0 = 1 := by
  ext row column
  fin_cases row <;> fin_cases column <;>
    simp [standardRyMatrix, realRotation, realOrthogonalRotation]


theorem standardRyMatrix_add (left right : Real) :
    standardRyMatrix (left + right) =
      standardRyMatrix right * standardRyMatrix left := by
  have halfAdd : (left + right) / 2 = left / 2 + right / 2 := by ring
  rw [standardRyMatrix, halfAdd]
  ext row column
  fin_cases row <;> fin_cases column <;>
    simp [standardRyMatrix, realRotation, realOrthogonalRotation,
      _root_.Matrix.mul_apply, Fin.sum_univ_two,
      Real.sin_add, Real.cos_add] <;> ring

@[simp] theorem star_complex_cos_ofReal (theta : Real) :
    star (Complex.cos (theta : ℂ)) = Complex.cos (theta : ℂ) := by
  rw [← Complex.ofReal_cos, Complex.star_def, Complex.conj_ofReal]

@[simp] theorem conj_complex_cos_ofReal (theta : Real) :
    (starRingEnd ℂ) (Complex.cos (theta : ℂ)) =
      Complex.cos (theta : ℂ) := by
  rw [← Complex.ofReal_cos, Complex.conj_ofReal]

@[simp] theorem star_complex_sin_ofReal (theta : Real) :
    star (Complex.sin (theta : ℂ)) = Complex.sin (theta : ℂ) := by
  rw [← Complex.ofReal_sin, Complex.star_def, Complex.conj_ofReal]

@[simp] theorem conj_complex_sin_ofReal (theta : Real) :
    (starRingEnd ℂ) (Complex.sin (theta : ℂ)) =
      Complex.sin (theta : ℂ) := by
  rw [← Complex.ofReal_sin, Complex.conj_ofReal]

theorem complex_ofReal_div_two (theta : Real) :
    (theta : ℂ) / 2 = ((theta / 2 : Real) : ℂ) := by
  norm_num

@[simp] theorem conj_complex_cos_ofReal_div_two (theta : Real) :
    (starRingEnd ℂ) (Complex.cos ((theta : ℂ) / 2)) =
      Complex.cos ((theta : ℂ) / 2) := by
  rw [complex_ofReal_div_two, ← Complex.ofReal_cos, Complex.conj_ofReal]

@[simp] theorem conj_complex_sin_ofReal_div_two (theta : Real) :
    (starRingEnd ℂ) (Complex.sin ((theta : ℂ) / 2)) =
      Complex.sin ((theta : ℂ) / 2) := by
  rw [complex_ofReal_div_two, ← Complex.ofReal_sin, Complex.conj_ofReal]

@[simp] theorem standardRyMatrix_neg (theta : Real) :
    standardRyMatrix (-theta) = star (standardRyMatrix theta) := by
  change realRotation (-theta / 2) = star (realRotation (theta / 2))
  rw [show -theta / 2 = -(theta / 2) by ring]
  ext row column
  fin_cases row <;> fin_cases column <;>
    simp [realRotation, realOrthogonalRotation]


def xMatrix : _root_.Matrix (Fin 2) (Fin 2) ℂ := fun row column =>
  if row = column then 0 else 1

theorem xMatrix_conjugates_standardRy (theta : Real) :
    xMatrix * standardRyMatrix theta * xMatrix = standardRyMatrix (-theta) := by
  rw [standardRyMatrix_neg]
  ext row column
  fin_cases row <;> fin_cases column <;>
    simp [xMatrix, standardRyMatrix, realRotation, realOrthogonalRotation,
      _root_.Matrix.mul_apply, Fin.sum_univ_two]

theorem standardRyMatrix_unitary (theta : Real) :
    standardRyMatrix theta ∈ _root_.Matrix.unitaryGroup (Fin 2) ℂ :=
  realRotation_unitary _


theorem standardRyMatrix_two_arccos_eq_amplitudeRotation
    (coefficient : Real) (_lower : -1 ≤ coefficient)
    (_upper : coefficient ≤ 1) :
    standardRyMatrix (2 * Real.arccos coefficient) =
      amplitudeRotation coefficient := by
  unfold standardRyMatrix amplitudeRotation
  congr 1
  ring


theorem standardRyMatrix_pi_div_two_eq_warmRobinUniformBitPrepare :
    standardRyMatrix (Real.pi / 2) =
      QuantumBlockEncoding.Robin.warmRobinUniformBitPrepare := by
  have half : (Real.pi / 2) / 2 = Real.pi / 4 := by ring
  unfold standardRyMatrix
  rw [half]
  unfold realRotation QuantumBlockEncoding.Robin.warmRobinUniformBitPrepare
  rw [Real.cos_pi_div_four, Real.sin_pi_div_four]


abbrev PrimitiveBasis (qubits : Nat) := Fin qubits → Fin 2

def flipBit (bit : Fin 2) : Fin 2 := if bit = 0 then 1 else 0

@[simp] theorem flipBit_flipBit (bit : Fin 2) : flipBit (flipBit bit) = bit := by
  fin_cases bit <;> rfl

def xBasisAction {qubits : Nat} (target : Fin qubits)
    (state : PrimitiveBasis qubits) : PrimitiveBasis qubits :=
  Function.update state target (flipBit (state target))

theorem xBasisAction_involutive {qubits : Nat} (target : Fin qubits) :
    Function.Involutive (xBasisAction target) := by
  intro state
  funext wire
  by_cases same : wire = target
  · subst wire
    simp [xBasisAction]
  · simp [xBasisAction, same]

def xBasisEquiv {qubits : Nat} (target : Fin qubits) :
    PrimitiveBasis qubits ≃ PrimitiveBasis qubits where
  toFun := xBasisAction target
  invFun := xBasisAction target
  left_inv := xBasisAction_involutive target
  right_inv := xBasisAction_involutive target

def cxBasisAction {qubits : Nat} (control target : Fin qubits)
    (state : PrimitiveBasis qubits) : PrimitiveBasis qubits :=
  if state control = 0 then state else xBasisAction target state

theorem cxBasisAction_involutive {qubits : Nat}
    (control target : Fin qubits) (distinct : control ≠ target) :
    Function.Involutive (cxBasisAction control target) := by
  intro state
  by_cases controlZero : state control = 0
  · simp [cxBasisAction, controlZero]
  · have controlUnchanged : xBasisAction target state control = state control := by
      simp [xBasisAction, distinct]
    simp [cxBasisAction, controlZero, controlUnchanged,
      xBasisAction_involutive target state]

def cxBasisEquiv {qubits : Nat} (control target : Fin qubits)
    (distinct : control ≠ target) :
    PrimitiveBasis qubits ≃ PrimitiveBasis qubits where
  toFun := cxBasisAction control target
  invFun := cxBasisAction control target
  left_inv := cxBasisAction_involutive control target distinct
  right_inv := cxBasisAction_involutive control target distinct

abbrev OtherPrimitiveWires {qubits : Nat} (target : Fin qubits) :=
  {wire : Fin qubits // wire ≠ target}

def splitPrimitiveWire {qubits : Nat} (target : Fin qubits) :
    PrimitiveBasis qubits ≃
      Fin 2 × (OtherPrimitiveWires target → Fin 2) where
  toFun state := (state target, fun wire => state wire.1)
  invFun pair wire :=
    if same : wire = target then pair.1 else pair.2 ⟨wire, same⟩
  left_inv state := by
    funext wire
    by_cases same : wire = target
    · subst wire
      simp
    · simp [same]
  right_inv pair := by
    rcases pair with ⟨targetBit, otherBits⟩
    apply Prod.ext
    · simp
    · funext wire
      simp [wire.property]

theorem splitPrimitiveWire_other_apply {qubits : Nat}
    (target : Fin qubits) (state : PrimitiveBasis qubits)
    (wire : OtherPrimitiveWires target) :
    (splitPrimitiveWire target state).2 wire = state wire.1 := rfl


noncomputable def liftPrimitiveOneQubit {qubits : Nat} (target : Fin qubits)
    (gate : _root_.Matrix (Fin 2) (Fin 2) ℂ) :
    _root_.Matrix (PrimitiveBasis qubits) (PrimitiveBasis qubits) ℂ :=
  _root_.Matrix.reindexAlgEquiv ℂ ℂ (splitPrimitiveWire target).symm
    (gate ⊗ₖ (1 : _root_.Matrix
      (OtherPrimitiveWires target → Fin 2)
      (OtherPrimitiveWires target → Fin 2) ℂ))

@[simp] theorem liftPrimitiveOneQubit_apply {qubits : Nat}
    (target : Fin qubits) (gate : _root_.Matrix (Fin 2) (Fin 2) ℂ)
    (row column : PrimitiveBasis qubits) :
    liftPrimitiveOneQubit target gate row column =
      if (splitPrimitiveWire target row).2 =
          (splitPrimitiveWire target column).2 then
        gate (row target) (column target)
      else 0 := by
  simp only [liftPrimitiveOneQubit, _root_.Matrix.reindexAlgEquiv_apply,
    _root_.Matrix.reindex_apply, _root_.Matrix.submatrix_apply,
    _root_.Matrix.kroneckerMap_apply, _root_.Matrix.one_apply,
    Equiv.symm_symm]
  by_cases contextsEqual :
      (splitPrimitiveWire target row).2 =
        (splitPrimitiveWire target column).2
  · simp [contextsEqual, splitPrimitiveWire]
  · simp [contextsEqual, splitPrimitiveWire]

theorem liftPrimitiveOneQubit_unitary {qubits : Nat} (target : Fin qubits)
    (gate : _root_.Matrix (Fin 2) (Fin 2) ℂ)
    (unitary : gate ∈ _root_.Matrix.unitaryGroup (Fin 2) ℂ) :
    liftPrimitiveOneQubit target gate ∈
      _root_.Matrix.unitaryGroup (PrimitiveBasis qubits) ℂ := by
  apply reindex_unitary
  apply _root_.Matrix.kronecker_mem_unitary
  · exact unitary
  · exact (_root_.Matrix.unitaryGroup
      (OtherPrimitiveWires target → Fin 2) ℂ).one_mem


noncomputable def standardRzMatrix (theta : Real) :
    _root_.Matrix (Fin 2) (Fin 2) ℂ := fun row column =>
  if row = column then
    if row = 0 then
      (Real.cos (theta / 2) : ℂ) - (Real.sin (theta / 2) : ℂ) * Complex.I
    else
      (Real.cos (theta / 2) : ℂ) + (Real.sin (theta / 2) : ℂ) * Complex.I
  else 0

theorem standardRzMatrix_unitary (theta : Real) :
    standardRzMatrix theta ∈ _root_.Matrix.unitaryGroup (Fin 2) ℂ := by
  let c := Real.cos (theta / 2)
  let s := Real.sin (theta / 2)
  have trig : s ^ 2 + c ^ 2 = 1 := by
    simp [c, s, Real.sin_sq_add_cos_sq]
  have minusNorm :
      star ((c : ℂ) - (s : ℂ) * Complex.I) *
          ((c : ℂ) - (s : ℂ) * Complex.I) = 1 := by
    apply Complex.ext <;> simp <;> nlinarith
  have plusNorm :
      star ((c : ℂ) + (s : ℂ) * Complex.I) *
          ((c : ℂ) + (s : ℂ) * Complex.I) = 1 := by
    apply Complex.ext <;> simp <;> nlinarith
  rw [_root_.Matrix.mem_unitaryGroup_iff']
  ext row column
  fin_cases row <;> fin_cases column
  · simpa [standardRzMatrix, _root_.Matrix.mul_apply, c, s] using minusNorm
  · simp [standardRzMatrix, _root_.Matrix.mul_apply]
  · simp [standardRzMatrix, _root_.Matrix.mul_apply]
  · simpa [standardRzMatrix, _root_.Matrix.mul_apply, c, s] using plusNorm

@[simp] theorem standardRzMatrix_neg (theta : Real) :
    standardRzMatrix (-theta) = star (standardRzMatrix theta) := by
  ext row column
  fin_cases row <;> fin_cases column
  · change
      (Real.cos (-theta / 2) : ℂ) -
          (Real.sin (-theta / 2) : ℂ) * Complex.I =
        star ((Real.cos (theta / 2) : ℂ) -
          (Real.sin (theta / 2) : ℂ) * Complex.I)
    rw [show -theta / 2 = -(theta / 2) by ring,
      Real.cos_neg, Real.sin_neg]
    simp
  · simp [standardRzMatrix, _root_.Matrix.star_apply]
  · simp [standardRzMatrix, _root_.Matrix.star_apply]
  · change
      (Real.cos (-theta / 2) : ℂ) +
          (Real.sin (-theta / 2) : ℂ) * Complex.I =
        star ((Real.cos (theta / 2) : ℂ) +
          (Real.sin (theta / 2) : ℂ) * Complex.I)
    rw [show -theta / 2 = -(theta / 2) by ring,
      Real.cos_neg, Real.sin_neg]
    simp

theorem star_equivPermutationMatrix
    {index : Type*} [Fintype index] [DecidableEq index]
    (equiv : index ≃ index) :
    star (equivPermutationMatrix equiv) =
      equivPermutationMatrix equiv.symm := by
  ext row column
  rw [_root_.Matrix.star_apply]
  simp only [equivPermutationMatrix]
  by_cases hit : column = equiv row
  · have reverseHit : row = equiv.symm column := by
      simpa using (congrArg equiv.symm hit).symm
    rw [if_pos hit, if_pos reverseHit]
    exact star_one ℂ
  · have reverseMiss : row ≠ equiv.symm column := by
      intro reverseHit
      apply hit
      simpa using (congrArg equiv reverseHit).symm
    rw [if_neg hit, if_neg reverseMiss]
    exact star_zero ℂ

theorem star_liftPrimitiveOneQubit {qubits : Nat} (target : Fin qubits)
    (gate : _root_.Matrix (Fin 2) (Fin 2) ℂ) :
    star (liftPrimitiveOneQubit target gate) =
      liftPrimitiveOneQubit target (star gate) := by
  ext row column
  simp only [liftPrimitiveOneQubit, _root_.Matrix.reindexAlgEquiv_apply,
    _root_.Matrix.reindex_apply, _root_.Matrix.submatrix_apply,
    _root_.Matrix.star_apply, _root_.Matrix.kroneckerMap_apply,
    _root_.Matrix.one_apply, Equiv.symm_symm]
  by_cases otherEqual :
      (splitPrimitiveWire target row).2 = (splitPrimitiveWire target column).2
  · rw [if_pos otherEqual.symm, if_pos otherEqual, StarMul.star_mul,
      star_one, one_mul, mul_one]
  · rw [if_neg (Ne.symm otherEqual), if_neg otherEqual, mul_zero,
      star_zero, mul_zero]


noncomputable def evalPrimitiveGate {qubits : Nat} : PrimitiveGate qubits →
    _root_.Matrix (PrimitiveBasis qubits) (PrimitiveBasis qubits) ℂ
  | .x target => equivPermutationMatrix (xBasisEquiv target)
  | .ry target angle => liftPrimitiveOneQubit target (standardRyMatrix angle.eval)
  | .rz target angle => liftPrimitiveOneQubit target (standardRzMatrix angle.eval)
  | .cx control target distinct =>
      equivPermutationMatrix (cxBasisEquiv control target distinct)

theorem evalPrimitiveGate_unitary {qubits : Nat} (gate : PrimitiveGate qubits) :
    evalPrimitiveGate gate ∈
      _root_.Matrix.unitaryGroup (PrimitiveBasis qubits) ℂ := by
  cases gate with
  | x target => exact equivPermutationMatrix_unitary _
  | ry target angle =>
      exact liftPrimitiveOneQubit_unitary target _ (standardRyMatrix_unitary _)
  | rz target angle =>
      exact liftPrimitiveOneQubit_unitary target _ (standardRzMatrix_unitary _)
  | cx control target distinct => exact equivPermutationMatrix_unitary _

theorem xBasisEquiv_symm {qubits : Nat} (target : Fin qubits) :
    (xBasisEquiv target).symm = xBasisEquiv target := by
  rfl

theorem cxBasisEquiv_symm {qubits : Nat} (control target : Fin qubits)
    (distinct : control ≠ target) :
    (cxBasisEquiv control target distinct).symm =
      cxBasisEquiv control target distinct := by
  rfl

theorem evalPrimitiveGate_dagger {qubits : Nat}
    (gate : PrimitiveGate qubits) :
    evalPrimitiveGate gate.dagger = star (evalPrimitiveGate gate) := by
  cases gate with
  | x target =>
      rw [evalPrimitiveGate, PrimitiveGate.dagger,
        star_equivPermutationMatrix, xBasisEquiv_symm]
      rfl
  | ry target angle =>
      simp only [PrimitiveGate.dagger, evalPrimitiveGate, ExactAngle.eval_neg,
        standardRyMatrix_neg]
      rw [star_liftPrimitiveOneQubit]
  | rz target angle =>
      simp only [PrimitiveGate.dagger, evalPrimitiveGate, ExactAngle.eval_neg,
        standardRzMatrix_neg]
      rw [star_liftPrimitiveOneQubit]
  | cx control target distinct =>
      rw [evalPrimitiveGate, PrimitiveGate.dagger,
        star_equivPermutationMatrix, cxBasisEquiv_symm]
      rfl


noncomputable def evalPrimitiveCircuit {qubits : Nat} : PrimitiveCircuit qubits →
    _root_.Matrix (PrimitiveBasis qubits) (PrimitiveBasis qubits) ℂ
  | [] => 1
  | gate :: rest => evalPrimitiveCircuit rest * evalPrimitiveGate gate

theorem evalPrimitiveCircuit_unitary {qubits : Nat}
    (circuit : PrimitiveCircuit qubits) :
    evalPrimitiveCircuit circuit ∈
      _root_.Matrix.unitaryGroup (PrimitiveBasis qubits) ℂ := by
  induction circuit with
  | nil => exact (_root_.Matrix.unitaryGroup (PrimitiveBasis qubits) ℂ).one_mem
  | cons gate rest induction =>
      exact (_root_.Matrix.unitaryGroup (PrimitiveBasis qubits) ℂ).mul_mem
        induction (evalPrimitiveGate_unitary gate)

theorem evalPrimitiveCircuit_append {qubits : Nat}
    (left right : PrimitiveCircuit qubits) :
    evalPrimitiveCircuit (left ++ right) =
      evalPrimitiveCircuit right * evalPrimitiveCircuit left := by
  induction left with
  | nil => simp [evalPrimitiveCircuit]
  | cons gate rest induction =>
      simp only [List.cons_append, evalPrimitiveCircuit]
      rw [induction]
      simp [mul_assoc]

theorem evalPrimitiveCircuit_dagger {qubits : Nat}
    (circuit : PrimitiveCircuit qubits) :
    evalPrimitiveCircuit (circuit.reverse.map PrimitiveGate.dagger) =
      star (evalPrimitiveCircuit circuit) := by
  induction circuit with
  | nil => simp [evalPrimitiveCircuit]
  | cons gate rest induction =>
      simp only [List.reverse_cons, List.map_append, List.map_singleton,
        evalPrimitiveCircuit_append, evalPrimitiveCircuit]
      rw [induction, evalPrimitiveGate_dagger]
      simp


noncomputable def evalGlobalPhase (angle : ExactAngle) : ℂ :=
  Complex.exp ((angle.eval : ℂ) * Complex.I)

theorem evalGlobalPhase_unitary (angle : ExactAngle) :
    evalGlobalPhase angle ∈ unitary ℂ := by
  unfold evalGlobalPhase
  rw [Unitary.mem_iff]
  constructor
  · change (starRingEnd ℂ)
        (Complex.exp ((angle.eval : ℂ) * Complex.I)) * _ = 1
    rw [← Complex.exp_conj, ← Complex.exp_add]
    simp
  · change _ * (starRingEnd ℂ)
        (Complex.exp ((angle.eval : ℂ) * Complex.I)) = 1
    rw [← Complex.exp_conj, ← Complex.exp_add]
    simp

@[simp] theorem evalGlobalPhase_neg (angle : ExactAngle) :
    evalGlobalPhase (.neg angle) = star (evalGlobalPhase angle) := by
  unfold evalGlobalPhase
  rw [ExactAngle.eval_neg, Complex.star_def, ← Complex.exp_conj]
  congr 2
  simp


noncomputable def evalPrimitiveProgram {qubits : Nat}
    (program : PrimitiveProgram qubits) :
    _root_.Matrix (PrimitiveBasis qubits) (PrimitiveBasis qubits) ℂ :=
  evalGlobalPhase program.globalPhase • evalPrimitiveCircuit program.circuit

@[simp] theorem evalPrimitiveProgram_identity (qubits : Nat) :
    evalPrimitiveProgram (PrimitiveProgram.identity qubits) = 1 := by
  simp [evalPrimitiveProgram, evalGlobalPhase, PrimitiveProgram.identity,
    evalPrimitiveCircuit, ExactAngle.eval]

theorem evalPrimitiveProgram_seq {qubits : Nat}
    (left right : PrimitiveProgram qubits) :
    evalPrimitiveProgram (PrimitiveProgram.seq left right) =
      evalPrimitiveProgram right * evalPrimitiveProgram left := by
  simp only [evalPrimitiveProgram, PrimitiveProgram.seq,
    ExactAngle.eval_add, evalPrimitiveCircuit_append, evalGlobalPhase]
  rw [Complex.ofReal_add, add_mul, Complex.exp_add]
  ext row column
  simp only [_root_.Matrix.smul_apply, _root_.Matrix.mul_apply, smul_eq_mul]
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro wire _
  ring

theorem evalPrimitiveProgram_unitary {qubits : Nat}
    (program : PrimitiveProgram qubits) :
    evalPrimitiveProgram program ∈
      _root_.Matrix.unitaryGroup (PrimitiveBasis qubits) ℂ := by
  exact Unitary.smul_mem_of_mem (evalGlobalPhase_unitary program.globalPhase)
    (evalPrimitiveCircuit_unitary program.circuit)

theorem evalPrimitiveProgram_dagger {qubits : Nat}
    (program : PrimitiveProgram qubits) :
    evalPrimitiveProgram program.dagger = star (evalPrimitiveProgram program) := by
  change evalGlobalPhase (.neg program.globalPhase) •
      evalPrimitiveCircuit
        (program.circuit.reverse.map PrimitiveGate.dagger) =
    star (evalGlobalPhase program.globalPhase •
      evalPrimitiveCircuit program.circuit)
  rw [evalGlobalPhase_neg, evalPrimitiveCircuit_dagger]
  simp


structure PrimitiveRefinement (qubits : Nat) where
  circuit : PrimitiveCircuit qubits
  target : _root_.Matrix (PrimitiveBasis qubits) (PrimitiveBasis qubits) ℂ
  exact : evalPrimitiveCircuit circuit = target

end QuantumBlockEncoding

```

```lean
import QuantumBlockEncoding.PrimitiveRyPerturbation
import QuantumBlockEncoding.ConstructiveHermitePreparation
import Mathlib.Data.List.Forall2


namespace QuantumBlockEncoding.PrimitiveCircuitPerturbation
open PrimitiveRyPerturbation
open scoped Matrix.Norms.L2Operator

inductive GateAligned {qubits : ℕ} (δ : ℝ) : PrimitiveGate qubits → PrimitiveGate qubits → Prop
  | unchanged (gate : PrimitiveGate qubits) : GateAligned δ gate gate
  | ry (target : Fin qubits) (a b : ExactAngle) (error : |a.eval - b.eval| ≤ δ) :
      GateAligned δ (.ry target a) (.ry target b)


def Aligned {qubits : ℕ} (δ : ℝ) (exact approximate : PrimitiveCircuit qubits) : Prop :=
  List.Forall₂ (GateAligned δ) exact approximate


end QuantumBlockEncoding.PrimitiveCircuitPerturbation

```

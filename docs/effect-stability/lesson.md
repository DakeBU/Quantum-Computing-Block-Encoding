# Stability of normalized pure-state effect probabilities

Source: author-derived canonical finite-dimensional mathematical contracts,
version 1 (2026-10-09). This is a reusable library formalization, with no novelty
or algorithm-complexity claim.

Let ι be a finite decidable index type and ψ a normalized vector in complex
Euclidean space. Matrices use Loewner order and the induced Euclidean operator
norm. Define p(U)=Re⟨Uψ,P Uψ⟩, where U is unitary and 0≤P≤I is an effect.
The order bounds imply ||P||≤1; this is a proved prerequisite rather than an
extra premise of the probability theorem. Unitarity gives ||Uψ||=1, also proved
internally. Positivity gives p(U)≥0; Cauchy–Schwarz and contraction give p(U)≤1.
The literal formula is defined for all matrices; it is claimed to be a
probability only under the displayed effect and normalization hypotheses.

For normalized x,y and a contraction P, split
⟨x,Px⟩−⟨y,Py⟩=⟨x−y,Px⟩+⟨y,P(x−y)⟩.
Cauchy–Schwarz bounds the real-part difference by 2||x−y||. For two unitaries
U,V with ||U−V||≤η, operator action gives ||Uψ−Vψ||≤η, hence
|p(U)−p(V)|≤2η. A separate nonnegative η premise is unnecessary: the error
certificate already forces it. The auxiliary contraction lemma has its own
literal contraction hypothesis; the effect consumer derives that hypothesis.

For lists of primitive circuits of n qubits, use the library's existing
positionwise Aligned δ certificate, δ≥0. This certificate preserves the gate
constructors/wires and bounds corresponding Ry angle errors; it is not an
automatic synthesis theorem. Existing PrimitiveCircuitPerturbation gives
||eval approximate−eval exact||≤length(exact)·δ/2, and PrimitiveSemantics gives
both circuit unitaries. Applying the probability theorem yields effect
probability difference at most length(exact)·δ. Circuit unitarity and operator
perturbation remain genuine proof dependencies, not public hypotheses.

No additional register, garbage, ancilla or tensor identification is introduced.
Global phase is carried literally in matrices, not selected by a quotient or
claimed unique. The existing PrimitiveBasis fixes the circuit register order.
The analytic result requires no oracle access, controls or inverse black box.
No hardware noise law, state-loading cost, shot cost, gate count, physical depth,
finite-bit angle synthesis, runtime or estimator theorem follows from it.

Actual dependencies include Mathlib finite Matrix order/CStar norms, complex
inner products and operator action, and the existing library's
aligned_eval_distance_le and evalPrimitiveCircuit_unitary. The reusable
probability node has actual consumers probability_mem_Icc and
CircuitEffectStability.aligned_probability_difference_le. This contribution
adds canonical Semantics nodes, not a new research route, frontier, categorical
transport, accepted circuit compiler or resource theorem. Unaffected atlas and
progress surfaces remain unchanged with that reason.

<details><summary>Exact Lean statement and proof: QuantumBlockEncoding/BornStability.lean</summary>

```lean
import Mathlib.Analysis.CStarAlgebra.Matrix
import Mathlib.Analysis.Matrix.Order
import Mathlib.Analysis.CStarAlgebra.ContinuousFunctionalCalculus.Order
import Mathlib.Analysis.InnerProductSpace.Positive
import Mathlib.Tactic

/-! Pure-state Born probabilities on the existing finite matrix semantics.
The order is Loewner order, the matrix norm is the induced Euclidean L2 norm.
No amplitude-estimation or physical noise theorem is asserted here. -/
namespace QuantumBlockEncoding.BornStability

open scoped InnerProductSpace Matrix.Norms.L2Operator MatrixOrder

variable {ι : Type*} [Fintype ι] [DecidableEq ι]

noncomputable def probability (U P : Matrix ι ι ℂ)
    (ψ : EuclideanSpace ℂ ι) : ℝ :=
  (inner ℂ (Matrix.toEuclideanCLM (𝕜 := ℂ) U ψ)
    (Matrix.toEuclideanCLM (𝕜 := ℂ) P (Matrix.toEuclideanCLM (𝕜 := ℂ) U ψ))).re

set_option maxHeartbeats 800000 in
set_option backward.isDefEq.respectTransparency false in
/-- The contraction bound is proved from the actual effect assumptions. -/
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

/-- Auxiliary analytic leaf. The public effect theorem derives its norm premise. -/
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

/-- Normalized pure-state effect probability is Lipschitz in a pair of unitaries. -/
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


/-- A true effect measurement on a normalized unitary output lies in [0,1]. -/
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

</details>

<details><summary>Exact Lean statement and proof: QuantumBlockEncoding/CircuitEffectStability.lean</summary>

```lean
import QuantumBlockEncoding.BornStability
import QuantumBlockEncoding.PrimitiveCircuitPerturbation

namespace QuantumBlockEncoding.CircuitEffectStability

open scoped Matrix.Norms.L2Operator MatrixOrder
open PrimitiveCircuitPerturbation

/-- An alignment certificate is required; this does not synthesize rounding. -/
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

</details>

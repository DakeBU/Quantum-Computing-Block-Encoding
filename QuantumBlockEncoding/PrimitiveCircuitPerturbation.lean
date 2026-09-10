import QuantumBlockEncoding.PrimitiveRyPerturbation
import QuantumBlockEncoding.ConstructiveHermitePreparation
import Mathlib.Data.List.Forall2

/-! conditional circuit perturbation theorem. Alignment is
positional: only RY angles may change, always on the same physical target;
all other instructions remain exactly the same. No rounded-circuit supplier
or numerical angle algorithm is constructed or assumed to be free.
All norms are Euclidean induced L2 operator norms. The telescoping proof uses
the actual chronological convention eval(g::rest) = eval(rest) * eval(g).
-/
namespace QuantumBlockEncoding.PrimitiveCircuitPerturbation
open PrimitiveRyPerturbation
open scoped Matrix.Norms.L2Operator

inductive GateAligned {qubits : ℕ} (δ : ℝ) : PrimitiveGate qubits → PrimitiveGate qubits → Prop
  | unchanged (gate : PrimitiveGate qubits) : GateAligned δ gate gate
  | ry (target : Fin qubits) (a b : ExactAngle) (error : |a.eval - b.eval| ≤ δ) :
      GateAligned δ (.ry target a) (.ry target b)

/-- A Forall₂ witness preserves every position, physical label and list length. -/
def Aligned {qubits : ℕ} (δ : ℝ) (exact approximate : PrimitiveCircuit qubits) : Prop :=
  List.Forall₂ (GateAligned δ) exact approximate

theorem GateAligned.touched_eq {qubits : ℕ} {δ : ℝ} {a b : PrimitiveGate qubits}
    (h : GateAligned δ a b) : a.touched = b.touched := by
  cases h <;> rfl

theorem Aligned.length_eq {qubits : ℕ} {δ : ℝ} {exact approximate : PrimitiveCircuit qubits}
    (h : Aligned δ exact approximate) : exact.length = approximate.length :=
  List.Forall₂.length_eq h

theorem Aligned.refl {qubits : ℕ} (δ : ℝ) (circuit : PrimitiveCircuit qubits) :
    Aligned δ circuit circuit := by
  induction circuit with
  | nil => exact .nil
  | cons gate rest ih => exact .cons (.unchanged gate) ih

theorem GateAligned.distance_le {qubits : ℕ} {δ : ℝ} (hδ : 0 ≤ δ)
    {exact approximate : PrimitiveGate qubits} (h : GateAligned δ exact approximate) :
    ‖evalPrimitiveGate approximate - evalPrimitiveGate exact‖ ≤ δ / 2 := by
  cases h with
  | unchanged gate => simpa using (div_nonneg hδ (by norm_num : (0 : ℝ) ≤ 2))
  | ry target a b herror =>
      rw [norm_sub_rev]
      exact (eval_ry_distance_le target a b).trans (div_le_div_of_nonneg_right herror (by norm_num))

/-- No gate order is commuted: each induction step matches the actual evaluator. -/
theorem aligned_eval_distance_le {qubits : ℕ} {δ : ℝ} (hδ : 0 ≤ δ)
    {exact approximate : PrimitiveCircuit qubits} (aligned : Aligned δ exact approximate) :
    ‖evalPrimitiveCircuit approximate - evalPrimitiveCircuit exact‖ ≤
      (exact.length : ℝ) * δ / 2 := by
  induction aligned with
  | nil => simp
  | @cons exactGate approximateGate exactRest approximateRest head tail ih =>
      simp only [evalPrimitiveCircuit]
      have split : evalPrimitiveCircuit approximateRest * evalPrimitiveGate approximateGate -
          evalPrimitiveCircuit exactRest * evalPrimitiveGate exactGate =
          (evalPrimitiveCircuit approximateRest - evalPrimitiveCircuit exactRest) *
              evalPrimitiveGate approximateGate +
            evalPrimitiveCircuit exactRest *
              (evalPrimitiveGate approximateGate - evalPrimitiveGate exactGate) := by
        noncomm_ring
      rw [split]
      calc
        _ ≤ ‖(evalPrimitiveCircuit approximateRest - evalPrimitiveCircuit exactRest) *
                evalPrimitiveGate approximateGate‖ +
              ‖evalPrimitiveCircuit exactRest *
                (evalPrimitiveGate approximateGate - evalPrimitiveGate exactGate)‖ := norm_add_le _ _
        _ = ‖evalPrimitiveCircuit approximateRest - evalPrimitiveCircuit exactRest‖ +
              ‖evalPrimitiveGate approximateGate - evalPrimitiveGate exactGate‖ := by
          rw [CStarRing.norm_mul_mem_unitary _ (evalPrimitiveGate_unitary approximateGate),
            CStarRing.norm_mem_unitary_mul _ (evalPrimitiveCircuit_unitary exactRest)]
        _ ≤ (exactRest.length : ℝ) * δ / 2 + δ / 2 :=
          add_le_add ih (head.distance_le hδ)
        _ = _ := by simp only [List.length_cons, Nat.cast_add, Nat.cast_one]; ring

/-- Explicit Euclidean CLM formulation prevents accidental entrywise-norm use. -/
theorem aligned_eval_clm_distance_le {qubits : ℕ} {δ : ℝ} (hδ : 0 ≤ δ)
    {exact approximate : PrimitiveCircuit qubits} (aligned : Aligned δ exact approximate) :
    ‖_root_.Matrix.toEuclideanCLM (𝕜 := ℂ) (n := PrimitiveBasis qubits)
      (evalPrimitiveCircuit approximate - evalPrimitiveCircuit exact)‖ ≤
        (exact.length : ℝ) * δ / 2 := by
  rw [_root_.Matrix.l2_opNorm_toEuclideanCLM]
  exact aligned_eval_distance_le hδ aligned

/-- Sufficient uniform RY-angle budget for the existing actual prepare list. -/
noncomputable def hermiteAngleBudget (k n : ℕ) (ε : ℝ) : ℝ :=
  ε / (24 * ((n + 1 : ℕ) : ℝ) * ((2 * k + 6 : ℕ) : ℝ)^3)

theorem hermiteAngleBudget_nonneg (k n : ℕ) {ε : ℝ} (hε : 0 ≤ ε) :
    0 ≤ hermiteAngleBudget k n ε := by
  unfold hermiteAngleBudget
  positivity

/-- A conditional consumer of the actual constructed Hermite circuit and
its existing gate-count theorem. The alignment witness remains an input. -/
theorem prepare_conditional_distance_le (k n : ℕ) (L : ℝ) {ε : ℝ} (hε : 0 ≤ ε)
    (approximate : PrimitiveCircuit ((n + 1) + HermiteFiniteChain.bondQubits k))
    (aligned : Aligned (hermiteAngleBudget k n ε)
      (ConstructiveHermitePreparation.prepare k n L) approximate) :
    ‖evalPrimitiveCircuit approximate -
      evalPrimitiveCircuit (ConstructiveHermitePreparation.prepare k n L)‖ ≤ ε := by
  have hδ := hermiteAngleBudget_nonneg k n hε
  have bound := aligned_eval_distance_le hδ aligned
  have count : ((ConstructiveHermitePreparation.prepare k n L).length : ℝ) ≤
      48 * ((n + 1 : ℕ) : ℝ) * ((2 * k + 6 : ℕ) : ℝ)^3 := by
    exact_mod_cast ConstructiveHermitePreparation.prepare_gateCount k n L
  have hn : (0 : ℝ) < ((n + 1 : ℕ) : ℝ) := by positivity
  have hk : (0 : ℝ) < ((2 * k + 6 : ℕ) : ℝ) := by positivity
  calc
    _ ≤ ((ConstructiveHermitePreparation.prepare k n L).length : ℝ) *
        hermiteAngleBudget k n ε / 2 := bound
    _ ≤ (48 * ((n + 1 : ℕ) : ℝ) * ((2 * k + 6 : ℕ) : ℝ)^3) *
        hermiteAngleBudget k n ε / 2 := by gcongr
    _ = ε := by
      unfold hermiteAngleBudget
      field_simp
      ring

theorem prepare_conditional_clm_distance_le (k n : ℕ) (L : ℝ) {ε : ℝ} (hε : 0 ≤ ε)
    (approximate : PrimitiveCircuit ((n + 1) + HermiteFiniteChain.bondQubits k))
    (aligned : Aligned (hermiteAngleBudget k n ε)
      (ConstructiveHermitePreparation.prepare k n L) approximate) :
    ‖_root_.Matrix.toEuclideanCLM (𝕜 := ℂ)
      (n := PrimitiveBasis ((n + 1) + HermiteFiniteChain.bondQubits k))
      (evalPrimitiveCircuit approximate -
        evalPrimitiveCircuit (ConstructiveHermitePreparation.prepare k n L))‖ ≤ ε := by
  rw [_root_.Matrix.l2_opNorm_toEuclideanCLM]
  exact prepare_conditional_distance_le k n L hε approximate aligned

end QuantumBlockEncoding.PrimitiveCircuitPerturbation

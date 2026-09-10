import QuantumBlockEncoding.ConstructiveTensorTrainCompiler
import QuantumBlockEncoding.HermiteFiniteNorm

/-!+# An actual exact-real Hermite preparation circuit

The source uses the existing literal Hermite kernel and the local Gram-based
norm supplier. It is fed through deterministic tensor-train canonicalization,
SO completion, and primitive compilation. This closes the data-producing
quantum construction, not its whole classical evaluation-cost obligation.
-/

namespace QuantumBlockEncoding.ConstructiveHermitePreparation

open scoped BigOperators
open TensorTrainCanonical TensorTrainWord HermiteFiniteChain HermiteFiniteNorm

/-- Normalize the formula-derived cores using the local norm, not a full sample sum. -/
noncomputable def normalizedSource (k n : ℕ) (L : ℝ) : Chain (n + 1) 1 1 :=
  MatrixProductChain.ofKernel (kernel k n L)
    (fun a => rawInitial k n L a / localSampleNorm k n L) (terminal k) 0 n

theorem normalizedSource_eq_source (k n : ℕ) (L : ℝ) (hL : 0 < L) :
    normalizedSource k n L = sourceChain k n L :=
  (sourceChain_eq_local k n L hL).symm

theorem normalizedSource_maxBond (k n : ℕ) (L : ℝ) :
    maxBond (normalizedSource k n L) ≤ 2 * k + 6 := by
  have h := MatrixProductChain.ofKernel_maxBond (kernel k n L)
    (fun a => rawInitial k n L a / localSampleNorm k n L) (terminal k) 0 n
  simpa [normalizedSource, max_eq_left (show 1 ≤ 2 * k + 6 by omega)] using h

theorem normalizedSource_normalized (k n : ℕ) (L : ℝ) (hL : 0 < L) :
    (∑ x : Word (n + 1), (contract (normalizedSource k n L) x 0 0) ^ 2) = 1 := by
  rw [normalizedSource_eq_source k n L hL]
  exact sourceChain_normalized k n L hL

theorem normalizedSource_contract (k n : ℕ) (L : ℝ) (hL : 0 < L)
    (x : Word (n + 1)) :
    contract (normalizedSource k n L) x 0 0 =
      HermiteStatePreparation.sampledAmplitude k (n + 1) L (sampleEquiv (n + 1) x) /
        HermiteStatePreparation.sampleNorm k (n + 1) L := by
  rw [normalizedSource_eq_source k n L hL, sourceChain_contract k n L hL]

/-- The actual finite primitive list; no circuit witness is selected. -/
noncomputable def prepare (k n : ℕ) (L : ℝ) : PrimitiveCircuit ((n + 1) + bondQubits k) :=
  ConstructiveTensorTrainCompiler.compile (normalizedSource k n L)
    ((normalizedSource_maxBond k n L).trans (bond_fits k))

theorem prepare_gateCount (k n : ℕ) (L : ℝ) :
    (prepare k n L).gateCount ≤ 48 * (n + 1) * (2 * k + 6) ^ 3 := by
  apply (ConstructiveTensorTrainCompiler.compile_gateCount (normalizedSource k n L)
    ((normalizedSource_maxBond k n L).trans (bond_fits k))).trans
  simpa only [Nat.mul_assoc, Nat.mul_comm, Nat.mul_left_comm] using cubic_stage_budget k n

theorem prepare_depth (k n : ℕ) (L : ℝ) :
    (prepare k n L).resource.depth ≤ 48 * (n + 1) * (2 * k + 6) ^ 3 :=
  (prepare k n L).resource_depth_le_gateCount.trans (prepare_gateCount k n L)

theorem prepare_columns (k n : ℕ) (L : ℝ) (hL : 0 < L)
    (x : PrimitiveBasis (n + 1)) (b : PrimitiveBasis (bondQubits k)) :
    evalPrimitiveCircuit (prepare k n L) (Fin.append x b) (fun _ => 0) =
      if b = (fun _ => 0) then
        HermiteStatePreparation.normalizedAmplitude k (n + 1) L
          (primitiveBasisLEEquiv (n + 1) x) else 0 := by
  rw [prepare, ConstructiveTensorTrainCompiler.compile_columns _ _
    (normalizedSource_normalized k n L hL), normalizedSource_contract k n L hL,
    sampleEquiv_public]
  rfl

/-- Literal source semantics, all clean/non-clean output sectors, full unitary,
and gate/depth bounds for this particular constructed circuit. -/
theorem prepare_spec (k n : ℕ) (L : ℝ) (hL : 0 < L) :
    (prepare k n L).gateCount ≤ 48 * (n + 1) * (2 * k + 6) ^ 3 ∧
    (prepare k n L).resource.depth ≤ 48 * (n + 1) * (2 * k + 6) ^ 3 ∧
    (prepare k n L).resource.oracleCalls = 0 ∧
    evalPrimitiveCircuit (prepare k n L) ∈
      _root_.Matrix.unitaryGroup (PrimitiveBasis ((n + 1) + bondQubits k)) ℂ ∧
    ∀ (x : PrimitiveBasis (n + 1)) (b : PrimitiveBasis (bondQubits k)),
      evalPrimitiveCircuit (prepare k n L) (Fin.append x b) (fun _ => 0) =
        if b = (fun _ => 0) then
          HermiteStatePreparation.normalizedAmplitude k (n + 1) L
            (primitiveBasisLEEquiv (n + 1) x) else 0 :=
  ⟨prepare_gateCount k n L, prepare_depth k n L, rfl,
    evalPrimitiveCircuit_unitary _, prepare_columns k n L hL⟩

end QuantumBlockEncoding.ConstructiveHermitePreparation

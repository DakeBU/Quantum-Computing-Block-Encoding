import QuantumBlockEncoding.MatrixProductChain
import QuantumBlockEncoding.TensorTrainWord
import Mathlib.Data.Nat.Log

/-! The complete formula-derived Hermite kernel becomes a normalized,
bounded-width scalar-boundary tensor train. This is a source-to-chain theorem,
not yet a circuit compiler or a finite-precision error theorem. -/

namespace QuantumBlockEncoding.HermiteFiniteChain
open TensorTrainCanonical TensorTrainWord HermiteBoundaryInjection

noncomputable def bondEquiv (k : Nat) : Fin (2 * k + 6) ≃ HermiteFiniteBond k :=
  (Fintype.equivFinOfCardEq (hermiteFiniteBond_card k)).symm

noncomputable def kernel (k n : Nat) (L : ℝ) : MatrixProductChain.Kernel (2 * k + 6) :=
  fun t bit a b => hermiteKernel k n L (n - t) (decide (bit = 1))
    (bondEquiv k a) (bondEquiv k b)

noncomputable def terminal (k : Nat) : Fin (2 * k + 6) → ℝ :=
  fun a => hermiteTerminal k (bondEquiv k a)

noncomputable def initial (k n : Nat) (L : ℝ) : Fin (2 * k + 6) → ℝ :=
  fun a => hermiteInitial k n L (bondEquiv k a) / HermiteStatePreparation.sampleNorm k (n + 1) L

theorem kernel_readout (k n : Nat) (L : ℝ) (m start : Nat) (h : start + m = n + 1)
    (x : Word m) (a : Fin (2 * k + 6)) :
    MatrixProductChain.readout (kernel k n L) (terminal k) start x a =
      kernelContract (hermiteKernel k n L) (hermiteTerminal k) (toBits x) (bondEquiv k a) := by
  induction m generalizing start a with
  | zero => rfl
  | succ m ih =>
    rcases x with ⟨bit, x⟩
    have ht : n - start = m := by omega
    simp only [MatrixProductChain.readout, _root_.Matrix.mulVec, dotProduct,
      kernel, ht, toBits, kernelContract, toBits_length]
    simp_rw [ih (start + 1) (by omega)]
    exact (bondEquiv k).sum_comp (fun b =>
      hermiteKernel k n L m (decide (bit = 1)) (bondEquiv k a) b *
        kernelContract (hermiteKernel k n L) (hermiteTerminal k) (toBits x) b)

/-- Actual local cores, with normalization absorbed into the initial row. -/
noncomputable def sourceChain (k n : Nat) (L : ℝ) : Chain (n + 1) 1 1 :=
  MatrixProductChain.ofKernel (kernel k n L) (initial k n L) (terminal k) 0 n

theorem sourceChain_contract (k n : Nat) (L : ℝ) (hL : 0 < L)
    (x : Word (n + 1)) :
    contract (sourceChain k n L) x 0 0 =
      HermiteStatePreparation.sampledAmplitude k (n + 1) L (sampleEquiv (n + 1) x) /
        HermiteStatePreparation.sampleNorm k (n + 1) L := by
  rw [sourceChain, MatrixProductChain.ofKernel_contract]
  simp_rw [kernel_readout k n L (n + 1) 0 (by omega), initial, div_mul_eq_mul_div]
  rw [← Finset.sum_div]
  have he : (∑ a, hermiteInitial k n L (bondEquiv k a) *
      kernelContract (hermiteKernel k n L) (hermiteTerminal k) (toBits x) (bondEquiv k a)) =
      kernelAmplitude (hermiteKernel k n L) (hermiteInitial k n L) (hermiteTerminal k) (toBits x) :=
    (bondEquiv k).sum_comp (fun a => hermiteInitial k n L a *
      kernelContract (hermiteKernel k n L) (hermiteTerminal k) (toBits x) a)
  rw [he, hermiteKernel_eq_sample k n L hL (toBits x) (toBits_length x), wordSampleIndex_eq]

theorem sourceChain_maxBond (k n : Nat) (L : ℝ) : maxBond (sourceChain k n L) ≤ 2 * k + 6 := by
  have h := MatrixProductChain.ofKernel_maxBond (kernel k n L) (initial k n L) (terminal k) 0 n
  simpa [sourceChain, max_eq_left (show 1 ≤ 2 * k + 6 by omega)] using h

theorem sourceChain_storage (k n : Nat) (L : ℝ) :
    MatrixProductChain.storedScalars (sourceChain k n L) ≤ 2 * (n + 1) * (2 * k + 6) ^ 2 :=
  MatrixProductChain.storedScalars_le _ _ (sourceChain_maxBond k n L)

theorem sourceChain_normalized (k n : Nat) (L : ℝ) (hL : 0 < L) :
    (∑ x : Word (n + 1), (contract (sourceChain k n L) x 0 0) ^ 2) = 1 := by
  simp_rw [sourceChain_contract k n L hL]
  rw [(sampleEquiv (n + 1)).sum_comp (fun j =>
    (HermiteStatePreparation.sampledAmplitude k (n + 1) L j /
      HermiteStatePreparation.sampleNorm k (n + 1) L) ^ 2)]
  exact RealAmplitudePreparation.normalized_sum_sq_LE
    (HermiteStatePreparation.sampledAmplitude k (n + 1) L)
    (HermiteStatePreparation.sampledAmplitude_pos k (n + 1) L)

/-- Actual binary bond register; its size depends on smoothing order, not
the number of data qubits. -/
def bondQubits (k : Nat) : Nat := Nat.clog 2 (2 * k + 6)

theorem bond_fits (k : Nat) : 2 * k + 6 ≤ 2 ^ bondQubits k :=
  Nat.le_pow_clog (by decide) _

theorem padded_bond_le_twice (k : Nat) : 2 ^ bondQubits k ≤ 2 * (2 * k + 6) := by
  have hp : 0 < bondQubits k := Nat.clog_pos (by decide) (by omega)
  have h := Nat.pow_pred_clog_lt_self (by decide : 1 < 2) (by omega : 1 < 2 * k + 6)
  have he : (bondQubits k).pred + 1 = bondQubits k := Nat.succ_pred_eq_of_pos hp
  calc
    2 ^ bondQubits k = 2 ^ ((bondQubits k).pred + 1) := by rw [he]
    _ = 2 ^ (bondQubits k).pred * 2 := pow_succ _ _
    _ ≤ (2 * k + 6) * 2 := Nat.mul_le_mul_right 2 (Nat.le_of_lt h)
    _ = 2 * (2 * k + 6) := Nat.mul_comm _ _

/-- Algebraic substitution used after the actual stage compiler is supplied.
This is not itself an existence theorem for the final circuit. -/
theorem cubic_stage_budget (k n : Nat) :
    6 * (n + 1) * (2 ^ bondQubits k) ^ 3 ≤ 48 * (n + 1) * (2 * k + 6) ^ 3 := by
  calc
    _ ≤ 6 * (n + 1) * (2 * (2 * k + 6)) ^ 3 :=
      Nat.mul_le_mul_left _ (Nat.pow_le_pow_left (padded_bond_le_twice k) 3)
    _ = _ := by ring

end QuantumBlockEncoding.HermiteFiniteChain

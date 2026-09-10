import QuantumBlockEncoding.HermiteFiniteChain
import QuantumBlockEncoding.TensorTrainNormEnvironment

/-!
# A non-enumerating Hermite normalization supplier

The raw source chain contains no division by the full sample norm. Its small
Gram environments compute exactly that norm, with a polynomial syntactic
real-arithmetic budget. This does not charge construction of individual core
entries, canonicalization, angle evaluation or finite-bit arithmetic.
-/

namespace QuantumBlockEncoding.HermiteFiniteNorm
open TensorTrainCanonical TensorTrainWord HermiteBoundaryInjection HermiteFiniteChain

noncomputable def rawInitial (k n : Nat) (L : ℝ) : Fin (2 * k + 6) → ℝ :=
  fun a => hermiteInitial k n L (bondEquiv k a)

/-- A scalar-boundary source representation without a precomputed normalizer. -/
noncomputable def rawSourceChain (k n : Nat) (L : ℝ) : Chain (n + 1) 1 1 :=
  MatrixProductChain.ofKernel (kernel k n L) (rawInitial k n L) (terminal k) 0 n

theorem rawSourceChain_contract (k n : Nat) (L : ℝ) (hL : 0 < L)
    (x : Word (n + 1)) :
    contract (rawSourceChain k n L) x 0 0 =
      HermiteStatePreparation.sampledAmplitude k (n + 1) L (sampleEquiv (n + 1) x) := by
  rw [rawSourceChain, MatrixProductChain.ofKernel_contract]
  simp_rw [kernel_readout k n L (n + 1) 0 (by omega), rawInitial]
  have he : (∑ a, hermiteInitial k n L (bondEquiv k a) *
      kernelContract (hermiteKernel k n L) (hermiteTerminal k) (toBits x) (bondEquiv k a)) =
      kernelAmplitude (hermiteKernel k n L) (hermiteInitial k n L) (hermiteTerminal k) (toBits x) :=
    (bondEquiv k).sum_comp (fun a => hermiteInitial k n L a *
      kernelContract (hermiteKernel k n L) (hermiteTerminal k) (toBits x) a)
  rw [he, hermiteKernel_eq_sample k n L hL (toBits x) (toBits_length x), wordSampleIndex_eq]

theorem rawSourceChain_maxBond (k n : Nat) (L : ℝ) :
    maxBond (rawSourceChain k n L) ≤ 2 * k + 6 := by
  have h := MatrixProductChain.ofKernel_maxBond (kernel k n L) (rawInitial k n L) (terminal k) 0 n
  simpa [rawSourceChain, max_eq_left (show 1 ≤ 2 * k + 6 by omega)] using h

/-- Local matrix products followed by one real square root. -/
noncomputable def localSampleNorm (k n : Nat) (L : ℝ) : ℝ :=
  TensorTrainNormEnvironment.norm (rawSourceChain k n L)

theorem localSampleNorm_eq_sampleNorm (k n : Nat) (L : ℝ) (hL : 0 < L) :
    localSampleNorm k n L = HermiteStatePreparation.sampleNorm k (n + 1) L :=
  TensorTrainNormEnvironment.norm_eq_of_contract (rawSourceChain k n L)
    (sampleEquiv (n + 1)) (HermiteStatePreparation.sampledAmplitude k (n + 1) L)
    (rawSourceChain_contract k n L hL)

theorem localSampleNorm_pos (k n : Nat) (L : ℝ) (hL : 0 < L) :
    0 < localSampleNorm k n L := by
  rw [localSampleNorm_eq_sampleNorm k n L hL]
  exact HermiteStatePreparation.sampleNorm_pos k (n + 1) L

/-- The actual normalized source cores can use the local norm supplier. -/
theorem sourceChain_eq_local (k n : Nat) (L : ℝ) (hL : 0 < L) :
    sourceChain k n L = MatrixProductChain.ofKernel (kernel k n L)
      (fun a => rawInitial k n L a / localSampleNorm k n L) (terminal k) 0 n := by
  rw [localSampleNorm_eq_sampleNorm k n L hL]
  rfl

theorem rawSourceChain_storage (k n : Nat) (L : ℝ) :
    MatrixProductChain.storedScalars (rawSourceChain k n L) ≤
      2 * (n + 1) * (2 * k + 6) ^ 2 :=
  MatrixProductChain.storedScalars_le _ _ (rawSourceChain_maxBond k n L)

theorem norm_environment_storage (k n : Nat) (L : ℝ) :
    TensorTrainNormEnvironment.environmentScalars (rawSourceChain k n L) ≤
      (n + 2) * (2 * k + 6) ^ 2 :=
  TensorTrainNormEnvironment.environmentScalars_le _ _ (rawSourceChain_maxBond k n L)

/-- Addition/multiplication budget of the explicit Gram schedule, excluding
the final square root and the cost of supplying the raw core entries. -/
theorem norm_arithmetic_budget (k n : Nat) (L : ℝ) :
    TensorTrainNormEnvironment.arithmeticBudget (rawSourceChain k n L) ≤
      9 * (n + 1) * (2 * k + 6) ^ 3 :=
  TensorTrainNormEnvironment.arithmeticBudget_le _ _ (rawSourceChain_maxBond k n L)

end QuantumBlockEncoding.HermiteFiniteNorm

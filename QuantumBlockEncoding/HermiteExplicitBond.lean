import QuantumBlockEncoding.HermiteFiniteNorm
import Mathlib.Logic.Equiv.Fin.Basic

/-!
# A computable, fixed Hermite bond layout

This source representation replaces cardinality-based choice of an index
equivalence by explicit sum/option arithmetic. It does not change the existing
published compiler. Its raw chain is proved to produce exactly the same
literal samples; its entries are not asserted to equal the old arbitrarily
indexed matrices. No scalar-evaluation or finite-bit cost bound is claimed
by this layout adapter.
-/

namespace QuantumBlockEncoding.HermiteExplicitBond

open TensorTrainCanonical TensorTrainWord HermiteBoundaryInjection

def scalarEquiv : Fin 2 ≃ ScalarBond :=
  (finSuccEquiv 1).trans (Equiv.optionCongr finOneEquiv)

/-- Layout: two left-tail states, middle boundary then `2*k+2` Bernstein
states, and finally the right-tail state. All maps are executable. -/
def bondEquiv (k : ℕ) : Fin (2 * k + 6) ≃ HermiteFiniteBond k :=
  (finCongr (show 2 * k + 6 = 2 + ((2 * k + 1 + 1 + 1) + 1) by omega)).trans
    (finSumFinEquiv.symm.trans (Equiv.sumCongr scalarEquiv
      (finSumFinEquiv.symm.trans
        (Equiv.sumCongr (finSuccEquiv (2 * k + 1 + 1)) finOneEquiv))))

noncomputable def kernel (k n : ℕ) (L : ℝ) : MatrixProductChain.Kernel (2 * k + 6) :=
  fun t bit a b => hermiteKernel k n L (n - t) (decide (bit = 1))
    (bondEquiv k a) (bondEquiv k b)

noncomputable def initial (k n : ℕ) (L : ℝ) : Fin (2 * k + 6) → ℝ :=
  fun a => hermiteInitial k n L (bondEquiv k a)

noncomputable def terminal (k : ℕ) : Fin (2 * k + 6) → ℝ :=
  fun a => hermiteTerminal k (bondEquiv k a)

theorem kernel_readout (k n : ℕ) (L : ℝ) (m start : ℕ)
    (h : start + m = n + 1) (x : Word m) (a : Fin (2 * k + 6)) :
    MatrixProductChain.readout (kernel k n L) (terminal k) start x a =
      kernelContract (hermiteKernel k n L) (hermiteTerminal k) (toBits x)
        (bondEquiv k a) := by
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

noncomputable def rawSourceChain (k n : ℕ) (L : ℝ) : Chain (n + 1) 1 1 :=
  MatrixProductChain.ofKernel (kernel k n L) (initial k n L) (terminal k) 0 n

theorem rawSourceChain_contract (k n : ℕ) (L : ℝ) (hL : 0 < L)
    (x : Word (n + 1)) :
    contract (rawSourceChain k n L) x 0 0 =
      HermiteStatePreparation.sampledAmplitude k (n + 1) L
        (sampleEquiv (n + 1) x) := by
  rw [rawSourceChain, MatrixProductChain.ofKernel_contract]
  simp_rw [kernel_readout k n L (n + 1) 0 (by omega), initial]
  have he := (bondEquiv k).sum_comp (fun a => hermiteInitial k n L a *
    kernelContract (hermiteKernel k n L) (hermiteTerminal k) (toBits x) a)
  change (∑ a, hermiteInitial k n L (bondEquiv k a) *
    kernelContract (hermiteKernel k n L) (hermiteTerminal k) (toBits x)
      (bondEquiv k a)) = _
  rw [he]
  change kernelAmplitude (hermiteKernel k n L) (hermiteInitial k n L)
    (hermiteTerminal k) (toBits x) = _
  rw [hermiteKernel_eq_sample k n L hL (toBits x) (toBits_length x), wordSampleIndex_eq]

/-- Equality of the observable source, not an unproved equality of layouts. -/
theorem same_literal_source (k n : ℕ) (L : ℝ) (hL : 0 < L)
    (x : Word (n + 1)) :
    contract (rawSourceChain k n L) x 0 0 =
      contract (HermiteFiniteNorm.rawSourceChain k n L) x 0 0 := by
  rw [rawSourceChain_contract k n L hL, HermiteFiniteNorm.rawSourceChain_contract k n L hL]

theorem rawSourceChain_maxBond (k n : ℕ) (L : ℝ) :
    maxBond (rawSourceChain k n L) ≤ 2 * k + 6 := by
  have h := MatrixProductChain.ofKernel_maxBond (kernel k n L) (initial k n L)
    (terminal k) 0 n
  simpa [rawSourceChain, max_eq_left (show 1 ≤ 2 * k + 6 by omega)] using h

theorem rawSourceChain_norm (k n : ℕ) (L : ℝ) (hL : 0 < L) :
    TensorTrainNormEnvironment.norm (rawSourceChain k n L) =
      HermiteStatePreparation.sampleNorm k (n + 1) L :=
  TensorTrainNormEnvironment.norm_eq_of_contract (rawSourceChain k n L)
    (sampleEquiv (n + 1)) (HermiteStatePreparation.sampledAmplitude k (n + 1) L)
    (rawSourceChain_contract k n L hL)

end QuantumBlockEncoding.HermiteExplicitBond

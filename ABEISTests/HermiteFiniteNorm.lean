import QuantumBlockEncoding.HermiteFiniteNorm

namespace QuantumBlockEncoding.HermiteFiniteNormChecks
open HermiteFiniteNorm TensorTrainCanonical TensorTrainWord

example (k n : Nat) (L : ℝ) (hL : 0 < L) :
    localSampleNorm k n L = HermiteStatePreparation.sampleNorm k (n + 1) L :=
  localSampleNorm_eq_sampleNorm k n L hL

example (k n : Nat) (L : ℝ) (hL : 0 < L) (x : Word (n + 1)) :
    contract (rawSourceChain k n L) x 0 0 / localSampleNorm k n L =
      HermiteStatePreparation.sampledAmplitude k (n + 1) L (sampleEquiv (n + 1) x) /
        HermiteStatePreparation.sampleNorm k (n + 1) L := by
  rw [rawSourceChain_contract k n L hL, localSampleNorm_eq_sampleNorm k n L hL]

example (L : ℝ) : TensorTrainNormEnvironment.arithmeticBudget (rawSourceChain 0 0 L) ≤ 1944 := by
  simpa using norm_arithmetic_budget 0 0 L

example (L : ℝ) : TensorTrainNormEnvironment.environmentScalars (rawSourceChain 0 0 L) ≤ 72 := by
  simpa using norm_environment_storage 0 0 L

example (k n : Nat) (L : ℝ) (hL : 0 < L) : 0 < localSampleNorm k n L :=
  localSampleNorm_pos k n L hL

example (k n : Nat) (L : ℝ) (hL : 0 < L) :
    HermiteFiniteChain.sourceChain k n L = MatrixProductChain.ofKernel
      (HermiteFiniteChain.kernel k n L)
      (fun a => rawInitial k n L a / localSampleNorm k n L)
      (HermiteFiniteChain.terminal k) 0 n := sourceChain_eq_local k n L hL

#print axioms rawSourceChain_contract
#print axioms localSampleNorm_eq_sampleNorm
#print axioms sourceChain_eq_local
#print axioms norm_environment_storage
#print axioms norm_arithmetic_budget

end QuantumBlockEncoding.HermiteFiniteNormChecks

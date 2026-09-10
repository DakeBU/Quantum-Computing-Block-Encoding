import QuantumBlockEncoding.HermiteSampleStructure
import QuantumBlockEncoding.HermiteIntervalMass
import QuantumBlockEncoding.HermiteTransferCores

/-! Symbolic interface regressions for the structured preparation search.
These do not assert that the new efficient circuit root is closed. -/

namespace ABEISTests.HermiteStructure
open QuantumBlockEncoding HermiteCutRank HermiteSampleStructure HermiteIntervalMass
open scoped BigOperators

example (k p s : ℕ) (L : ℝ) (hL : 0 < L) :
    _root_.Matrix.rank (fun x y => HermiteStatePreparation.sampledAmplitude k (p + s) L
      (cutSampleIndex p s x y)) ≤ 8 * k + 12 := sampled_cut_rank_le k p s L hL

example (k p s : ℕ) (L : ℝ) (hL : 0 < L) :
    FactorsThrough (ι := HermiteBond k)
      (fun x y => HermiteStatePreparation.sampledAmplitude k (p + s) L
        (cutSampleIndex p s x y) / HermiteStatePreparation.sampleNorm k (p + s) L) :=
  normalized_cut_factorization k p s L hL

example (p s : ℕ) (x : Fin (gridSize p)) (y : Fin (gridSize s)) :
    (cutSampleIndex p s x y).val = gridSize s * x.val + y.val := rfl

example (k n : ℕ) (L : ℝ) :
    1 ≤ ∑ j : Fin (gridSize (n + 1)),
      (HermiteStatePreparation.sampledAmplitude k (n + 1) L j) ^ 2 :=
  sampled_mass_ge_one k n L

example (k count : ℕ) (a h : ℝ) :
    polynomialMassClosed (HermitePolynomial.sourceInterpolant k) a h count (4 * k + 2) =
      ∑ j ∈ Finset.range count, ((HermitePolynomial.sourceInterpolant k).eval (a + h * j)) ^ 2 :=
  hermite_polynomial_mass k count a h

#print axioms sampled_cut_factorization
#print axioms normalized_cut_factorization
#print axioms hermite_polynomial_mass
#print axioms exponentialMassClosed_eq
#print axioms sampled_mass_ge_one

example (k : ℕ) (origin : ℝ) (weights : List ℝ) :
    HermiteTransferCores.polynomialAmplitude (2 * k + 1)
      (HermitePolynomial.sourceInterpolant k) origin weights =
      (HermitePolynomial.sourceInterpolant k).eval (origin + weights.sum) :=
  HermiteTransferCores.sourceInterpolant_transfer k origin weights

#print axioms HermiteTransferCores.sourceInterpolant_transfer
end ABEISTests.HermiteStructure

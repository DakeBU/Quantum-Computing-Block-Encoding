import QuantumBlockEncoding.HermiteCutRank
import QuantumBlockEncoding.HermiteStatePreparation

/-! Bridge the generic cut factorization to the unchanged public sample API.
Neither a rank bound nor normalization supplies a primitive circuit compiler. -/
noncomputable section
namespace QuantumBlockEncoding.HermiteSampleStructure
open HermiteCutRank

/-- Concatenate a most-significant prefix and a least-significant suffix.
This is an index map only; it allocates no amplitude table. -/
def cutSampleIndex (pWidth sWidth : ℕ) (x : Fin (gridSize pWidth))
    (y : Fin (gridSize sWidth)) : Fin (gridSize (pWidth + sWidth)) :=
  ⟨gridSize sWidth * x.val + y.val, by
    have hx := x.isLt
    have hy := y.isLt
    have hm : 0 < gridSize sWidth := by
      change 0 < 2 ^ sWidth
      positivity
    have hg : gridSize (pWidth + sWidth) = gridSize sWidth * gridSize pWidth := by
      simp [gridSize, pow_add, Nat.mul_comm]
    rw [hg]
    nlinarith⟩

/-- The rank certificate applies to the actual frozen sample API at every cut,
including empty prefix/suffix cuts. It is not a claim about a numerical SVD. -/
theorem sampled_cut_factorization (k pWidth sWidth : ℕ) (L : ℝ) (hL : 0 < L) :
    FactorsThrough (ι := HermiteBond k)
      (fun x y => HermiteStatePreparation.sampledAmplitude k (pWidth + sWidth) L
        (cutSampleIndex pWidth sWidth x y)) := by
  have hs : 0 < 2 * Real.pi * L / (gridSize (pWidth + sWidth) : ℝ) := by
    unfold gridSize
    positivity
  have h := hermite_affine_factorization k (gridSize sWidth) (-Real.pi * L)
    (2 * Real.pi * L / (gridSize (pWidth + sWidth) : ℝ)) hs
    (fun x : Fin (gridSize pWidth) => x.val)
    (fun y : Fin (gridSize sWidth) => y.val) (fun y => y.isLt)
  simpa only [HermiteStatePreparation.sampledAmplitude,
    HermiteStatePreparation.gridPoint, cutSampleIndex, mul_comm] using h

theorem sampled_cut_rank_le (k pWidth sWidth : ℕ) (L : ℝ) (hL : 0 < L) :
    _root_.Matrix.rank (fun x y =>
      HermiteStatePreparation.sampledAmplitude k (pWidth + sWidth) L
        (cutSampleIndex pWidth sWidth x y)) ≤ 8 * k + 12 := by
  simpa only [hermiteBond_card] using
    (sampled_cut_factorization k pWidth sWidth L hL).rank_le

/-- The real amplitudes underlying the public complex state retain the same
factor width after exact normalization. -/
theorem normalized_cut_factorization (k pWidth sWidth : ℕ) (L : ℝ) (hL : 0 < L) :
    FactorsThrough (ι := HermiteBond k)
      (fun x y =>
        HermiteStatePreparation.sampledAmplitude k (pWidth + sWidth) L
          (cutSampleIndex pWidth sWidth x y) /
        HermiteStatePreparation.sampleNorm k (pWidth + sWidth) L) := by
  simpa only [div_eq_mul_inv, mul_comm] using
    (sampled_cut_factorization k pWidth sWidth L hL).scale
      (HermiteStatePreparation.sampleNorm k (pWidth + sWidth) L)⁻¹

end QuantumBlockEncoding.HermiteSampleStructure

import QuantumBlockEncoding.HermiteBoundaryInjection

open QuantumBlockEncoding HermiteBoundaryInjection HermiteBernstein

example : wordValue [true, false, true, false] = 10 := by decide

example : pathCoordinate [true, false, true] 0 = (5 : ℝ) / 8 := by
  norm_num [pathCoordinate, childCoordinate]

example : Partial 5 8 (4 * 1) 4 := by
  norm_num [Partial, Full, Outside]

example : ¬ Partial 4 8 (4 * 1) 4 := by
  norm_num [Partial, Full, Outside]

example (lower upper first : ℕ) : ¬ Partial lower upper first 1 :=
  not_partial_unit lower upper first

example (x y : ℕ)
    (hx : Partial 5 8 (4 * x) 4) (hy : Partial 5 8 (4 * y) 4) : x = y := by
  exact partial_prefix_unique 5 4 2 x y (by decide) hx hy

example (k : ℕ) :
    boundaryReadout k (-1) (1 / 8) 0 8 0 [true, false, true] =
      (HermitePolynomial.sourceInterpolant k).eval (-(3 : ℝ) / 8) := by
  rw [boundaryReadout_eq]
  · norm_num [wordValue, affinePoint]
  · intro j _ hj
    have hjr : (j : ℝ) < 8 := by exact_mod_cast hj
    dsimp [affinePoint]
    linarith

example (k : ℕ) (bits : List Bool) :
    boundaryReadout k (-1) (1 / 8) 8 8 0 bits = 0 := by
  rw [boundaryReadout_eq]
  · have hn : ¬ (8 ≤ 0 + wordValue bits ∧ 0 + wordValue bits < 8) := by omega
    exact if_neg hn
  · intro j hj hj'
    omega

example (k n : ℕ) (L : ℝ) (hL : 0 < L) (bits : List Bool)
    (hbits : bits.length = n + 1) :
    middleReadout k n L bits =
      if cutIndex n L ≤ wordValue bits ∧ wordValue bits < 2 ^ n then
        HermiteStatePreparation.sampledAmplitude k (n + 1) L
          (wordSampleIndex n bits hbits) else 0 :=
  middleReadout_eq_masked_sample k n L hL bits hbits

example (k : ℕ) : middleReadout k 2 (2 / Real.pi) [true, false, false] = 0 := by
  rw [middleReadout_eq k 2 _ (by positivity)]
  norm_num only [wordValue]
  have hc := gridPointNat_midpoint 2 (2 / Real.pi)
  norm_num at hc
  simp [hc]

example (k : ℕ) :
    middleReadout k 2 (2 / Real.pi) [false, true, false] =
      (HermitePolynomial.sourceInterpolant k).eval (-1) := by
  rw [middleReadout_eq k 2 _ (by positivity)]
  norm_num only [wordValue]
  have hc : gridPointNat 2 (2 / Real.pi) 2 = -1 := by
    norm_num [gridPointNat, affinePoint, gridStep, gridSize]
    field_simp
    ring
  simp [hc]

example : cutIndex 2 (1 / (2 * Real.pi)) = 0 := by
  rw [cutIndex_eq_clamped 2 _ (by positivity)]
  have he : (2 ^ 2 : ℕ) - (gridSize (2 + 1) : ℝ) /
      (2 * Real.pi * (1 / (2 * Real.pi))) = -4 := by
    norm_num [gridSize]
    field_simp
    ring
  rw [he]
  norm_num

example : Fintype.card (MiddleBond 8) = 19 := by decide

example : sharedCore 2 false (0 : Fin 3) (2 : Fin 3) = (1 : ℝ) / 4 := by
  rw [sharedCore_false]
  norm_num

example : sharedCore 2 true (2 : Fin 3) (0 : Fin 3) = (1 : ℝ) / 4 := by
  rw [sharedCore_true]
  norm_num

example : sharedCore 2 true (0 : Fin 3) (2 : Fin 3) = 0 := by
  rw [sharedCore_true]
  norm_num

example (k : ℕ) :
    injectedFiniteReadout k (-1) (1 / 8) 0 [true, false, true] =
      (HermitePolynomial.sourceInterpolant k).eval (-(3 : ℝ) / 8) := by
  rw [injectedFiniteReadout_eq k (-1) (1 / 8) 0 _ (by norm_num [affinePoint])]
  norm_num [affinePoint, wordValue]

example : ScheduleValid 5 8 (boundarySchedule 5) 4 := boundarySchedule_valid 5 3
example : ScheduleValid 0 5 (boundarySchedule 5) 128 := boundarySchedule_left_valid 5 128

example (k n : ℕ) (L : ℝ) (hL : 0 < L) (bits : List Bool)
    (hbits : bits.length = n + 1) :
    middleFiniteReadout k n L bits =
      if cutIndex n L ≤ wordValue bits ∧ wordValue bits < 2 ^ n then
        HermiteStatePreparation.sampledAmplitude k (n + 1) L
          (wordSampleIndex n bits hbits) else 0 :=
  middleFiniteReadout_eq_masked_sample k n L hL bits hbits

example : cutIndex 0 (2 / Real.pi) = 1 := by
  rw [cutIndex_eq_clamped 0 _ (by positivity)]
  have he : (2 ^ 0 : ℕ) - (gridSize (0 + 1) : ℝ) /
      (2 * Real.pi * (2 / Real.pi)) = 1 / 2 := by
    norm_num [gridSize]
    field_simp
    ring
  rw [he]
  norm_num
  rw [Nat.ceil_eq_iff (by decide : (1 : ℕ) ≠ 0)]
  norm_num

example (k : ℕ) : middleFiniteReadout k 0 (2 / Real.pi) [false] = 0 := by
  have hc : cutIndex 0 (2 / Real.pi) = 1 := by
    have h := gridPointNat_lt_neg_one_iff 0 (2 / Real.pi) (by positivity) 0
    have hg : gridPointNat 0 (2 / Real.pi) 0 = -2 := by
      norm_num [gridPointNat, affinePoint]
      field_simp
    rw [hg] at h
    have hlo : 0 < cutIndex 0 (2 / Real.pi) := h.mp (by norm_num)
    have hhi := cutIndex_le_midpoint 0 (2 / Real.pi) (by positivity)
    norm_num at hhi
    omega
  simp [middleFiniteReadout, hc]

example (step : ℝ) : scalarFreeContract (leftFree step) [true, true, true] = 1 := by
  simp [scalarFreeContract, leftFree]

example (step : ℝ) : scalarFreeContract (rightFree step) [false, false, false] = 1 := by
  simp [scalarFreeContract, rightFree]

example (k n : ℕ) (L : ℝ) (hL : 0 < L) (bits : List Bool)
    (hbits : bits.length = n + 1) :
    kernelAmplitude (hermiteKernel k n L) (hermiteInitial k n L) (hermiteTerminal k) bits =
      HermiteStatePreparation.sampledAmplitude k (n + 1) L
        (wordSampleIndex n bits hbits) :=
  hermiteKernel_eq_sample k n L hL bits hbits

example : Fintype.card (HermiteFiniteBond 8) = 22 := by decide
example : Fintype.card (HermiteCoreAddress 2 127) = 25600 := by
  rw [hermiteCoreAddress_card]
  norm_num

example (n : ℕ) (L : ℝ) (hL : 0 < L) (r : ℕ) (bit : Bool) :
    0 ≤ leftFree (gridStep n L) r bit ∧ leftFree (gridStep n L) r bit ≤ 1 :=
  leftFree_bounds _ (gridStep_pos n L hL).le r bit

#print axioms pathCoordinate_eq_wordValue
#print axioms partial_prefix_unique
#print axioms boundaryReadout_eq
#print axioms injection_domain
#print axioms cutIndex_eq_clamped
#print axioms middleReadout_eq_masked_sample
#print axioms sharedContract_eq_basis
#print axioms injectionContract_boundary
#print axioms middleFiniteReadout_eq_masked_sample
#print axioms scalarContract_boundary
#print axioms leftFiniteReadout_eq_masked_sample
#print axioms rightFiniteReadout_eq_masked_sample
#print axioms hermiteKernel_eq_sample
#print axioms hermiteCoreAddress_card

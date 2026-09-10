import QuantumBlockEncoding.AdjacentGivens

open QuantumBlockEncoding QuantumBlockEncoding.AdjacentGivens

example (N : ℕ) :
    stepsMatrix (decomposeSO (1 : _root_.Matrix (Fin N) (Fin N) ℝ)) = 1 :=
  decomposeSO_matrix 1 (by simp) (by simp)

example : (decomposeSO (1 : _root_.Matrix (Fin 4) (Fin 4) ℝ)).length = 6 := by
  rw [decomposeSO_length]

example : stepsMatrix (decomposeSO (!![-1, 0; 0, -1] : _root_.Matrix (Fin 2) (Fin 2) ℝ)) =
    !![-1, 0; 0, -1] := by
  apply decomposeSO_matrix
  · ext row col
    fin_cases row <;> fin_cases col <;>
      norm_num [_root_.Matrix.mul_apply, Fin.sum_univ_two]
  · norm_num [_root_.Matrix.det_fin_two]

example : eliminateEntry (1 : _root_.Matrix (Fin 4) (Fin 4) ℝ) 0 1 3 = 1 := by
  apply eliminateEntry_zero_pair <;> norm_num [_root_.Matrix.one_apply] <;> decide

example : Real.cos (eliminationAngle (-3) (-4) / 2) * (-3) -
    Real.sin (eliminationAngle (-3) (-4) / 2) * (-4) = 5 := by
  have positiveRadius := (eliminate_pair (-3) (-4)).1
  norm_num [RealAmplitudePreparation.pairNorm] at positiveRadius ⊢
  exact positiveRadius

example : (decomposeSO (1 : _root_.Matrix (Fin 0) (Fin 0) ℝ)).length = 0 := by
  rw [decomposeSO_length]

example : (decomposeSO (1 : _root_.Matrix (Fin 1) (Fin 1) ℝ)).length = 0 := by
  rw [decomposeSO_length]

#check @decomposeSO_matrix
#check @decomposeSO_length
#check @planeMatrix_selected_entry
#check @planeMatrix_fixed_column
#print axioms decomposeSO_matrix
#print axioms decomposeSO_length
#print axioms fullSweep_eq_one
#print axioms columnSweep_prefix_succ
#print axioms eliminateEntry_zero_pair

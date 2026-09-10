import QuantumBlockEncoding.GrayGivensCompiler

open QuantumBlockEncoding QuantumBlockEncoding.GrayGivensCompiler

example : ∀ i : Fin 8,
    (primitiveBasisLEEquiv 3 (GrayBasis.equiv 3 i)).val =
      (![0, 1, 3, 2, 6, 7, 5, 4] : Fin 8 → ℕ) i := by decide

example (theta : ℝ) :
    realTransport (GrayBasis.equiv 2) (AdjacentGivens.planeMatrix (2 : Fin 4) 3 theta) =
      selectedRyPlaneMatrix (0 : Fin 2)
        (splitPrimitiveWire 0 (GrayBasis.equiv 2 (2 : Fin 4))).2 (-theta) := by
  have action : GrayBasis.equiv 2 (3 : Fin 4) =
      xBasisAction (0 : Fin 2) (GrayBasis.equiv 2 (2 : Fin 4)) := by decide
  have bit : GrayBasis.equiv 2 (2 : Fin 4) (0 : Fin 2) = 1 := by decide
  simpa [bit] using edge_plane_transport (GrayBasis.equiv 2) (2 : Fin 4) 3
    (by decide) 0 action theta

example : evalPrimitiveCircuit (compileSO (q := 0)
    (-1 : _root_.Matrix (PrimitiveBasis 1) (PrimitiveBasis 1) ℝ)) =
      (-1 : _root_.Matrix (PrimitiveBasis 1) (PrimitiveBasis 1) ℝ).map Complex.ofReal := by
  apply compileSO_eval
  · rw [_root_.Matrix.transpose_neg, _root_.Matrix.transpose_one,
      neg_mul_neg, _root_.Matrix.one_mul]
  · simp [_root_.Matrix.det_neg, PrimitiveBasis]

example : (compileSO (q := 0)
    (1 : _root_.Matrix (PrimitiveBasis 1) (PrimitiveBasis 1) ℝ)).gateCount = 1 := by
  rw [compileSO_gateCount]
  norm_num

example : (compileSO (q := 1)
    (1 : _root_.Matrix (PrimitiveBasis 2) (PrimitiveBasis 2) ℝ)).gateCount = 24 := by
  rw [compileSO_gateCount]
  norm_num

example : (compileSO (q := 2)
    (1 : _root_.Matrix (PrimitiveBasis 3) (PrimitiveBasis 3) ℝ)).gateCount = 280 := by
  rw [compileSO_gateCount]
  norm_num

#check @GrayBasis.equiv
#check @GrayBasis.adjacent
#check @compileSO_eval
#check @compileSO_cubic_bound
#check @compileSO_gateCount
#check @compileSO_ryCount
#check @compileSO_cxCount
#print axioms GrayBasis.adjacent
#print axioms edge_plane_transport
#print axioms compileSO_eval
#print axioms compileSO_cubic_bound

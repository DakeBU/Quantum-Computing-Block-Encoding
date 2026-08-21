import QuantumBlockEncoding.NieZiSunFigure3FlatCoordinates

/-!
# Projection API for flat Figure-3 coordinates

These lemmas keep later circuit-refinement proofs independent of the internal
composition of `basisSplitEquiv`, the two-bit suffix view, and `splitControls`.
-/

namespace QuantumBlockEncoding
namespace NieZiSunFigure3FlatProjections

open NieZiSunControlSplit
open NieZiSunFigure3FlatCoordinates
open NieZiSunFigure3Resource
open NieZiSunFigure3ReversibleProgram

@[simp] theorem head_apply
    (n : Nat) (large : 5 <= n)
    (state : PrimitiveBasis (totalWidth n)) (i : Fin 4) :
    (flatFigure3Coordinate n large state).1 i =
      state ⟨i.val, by unfold totalWidth; omega⟩ := by
  rfl

@[simp] theorem left_apply
    (n : Nat) (large : 5 <= n)
    (state : PrimitiveBasis (totalWidth n))
    (i : Fin (leftTailWidth n)) :
    (flatFigure3Coordinate n large state).2.1 i =
      state ⟨4 + i.val, by
        have hi := i.isLt
        unfold leftTailWidth totalWidth at *
        omega⟩ := by
  rfl

@[simp] theorem right_apply
    (n : Nat) (large : 5 <= n)
    (state : PrimitiveBasis (totalWidth n))
    (i : Fin (rightTailWidth n)) :
    (flatFigure3Coordinate n large state).2.2.1 i =
      state ⟨4 + leftTailWidth n + i.val, by
        have hi := i.isLt
        have sum := NieZiSunFigure3Resource.tailWidths_sum n
        unfold totalWidth
        omega⟩ := by
  rfl

@[simp] theorem ancilla_apply
    (n : Nat) (large : 5 <= n)
    (state : PrimitiveBasis (totalWidth n)) :
    (flatFigure3Coordinate n large state).2.2.2.1 =
      state (ancillaWire n) := by
  rfl

@[simp] theorem target_apply
    (n : Nat) (large : 5 <= n)
    (state : PrimitiveBasis (totalWidth n)) :
    (flatFigure3Coordinate n large state).2.2.2.2 =
      state (finalTargetWire n) := by
  rfl

end NieZiSunFigure3FlatProjections
end QuantumBlockEncoding

import QuantumBlockEncoding.NieZiSunControlSplit
import QuantumBlockEncoding.NieZiSunFigure3RecursiveFamily
import QuantumBlockEncoding.NieZiSunFigure3ReversibleProgram
import QuantumBlockEncoding.PrimitiveBasisRegisterSplit
import QuantumBlockEncoding.ReversibleDisjointEmbedding
import QuantumBlockEncoding.ReversibleWireEmbedding
import Mathlib.Tactic

/-!
# Flat-register coordinates for the Nie--Zi--Sun Figure-3 circuit

The semantic proof uses `(head,left,right,A,T)` product coordinates, whereas the
actual gate family uses one flat `[controls | A | T]` register.  This module
provides the exact equivalence and identifies the two recursive child-register
views used in Step 2.
-/

namespace QuantumBlockEncoding
namespace NieZiSunFigure3FlatCoordinates

open NieZiSunControlSplit
open NieZiSunFigure3Protocol
open NieZiSunFigure3RecursiveFamily
open NieZiSunFigure3Resource
open NieZiSunFigure3ReversibleProgram
open PrimitiveBasisRegisterSplit
open ReversibleWireEmbedding

/-- Two little-endian physical bits as an ordinary pair. -/
def twoBitEquiv : PrimitiveBasis 2 ≃ Fin 2 × Fin 2 where
  toFun state := (state 0,state 1)
  invFun pair := fun wire => if wire = 0 then pair.1 else pair.2
  left_inv state := by
    funext wire
    fin_cases wire <;> rfl
  right_inv pair := by
    rcases pair with ⟨a,b⟩
    rfl

/-- Flat `[controls | A | T]` register as `(controls,A,T)`. -/
def flatProductCoordinate (n : Nat) :
    PrimitiveBasis (n + 2) ≃ PrimitiveBasis n × Fin 2 × Fin 2 :=
  (basisSplitEquiv n 2).trans
    (Equiv.prodCongr (Equiv.refl (PrimitiveBasis n)) twoBitEquiv)

/-- Flat physical register as the exact product state used by Figure 3. -/
def flatFigure3Coordinate
    (n : Nat) (large : 5 <= n) :
    PrimitiveBasis (totalWidth n) ≃
      Figure3State (leftTailWidth n) (rightTailWidth n) :=
  (flatProductCoordinate n).trans
    (fullCoordinate n (by omega))

/-- The first n flat wires are exactly the source control register. -/
theorem flatProduct_controls
    (n : Nat) (state : PrimitiveBasis (n + 2)) :
    (flatProductCoordinate n state).1 = fun wire => state ⟨wire.val, by omega⟩ := by
  rfl

/-- Flat A/T suffix coordinates. -/
theorem flatProduct_ancilla
    (n : Nat) (state : PrimitiveBasis (n + 2)) :
    (flatProductCoordinate n state).2.1 = state ⟨n, by omega⟩ := by
  rfl

/-- Final target is the second suffix bit. -/
theorem flatProduct_target
    (n : Nat) (state : PrimitiveBasis (n + 2)) :
    (flatProductCoordinate n state).2.2 = state ⟨n+1, by omega⟩ := by
  rfl

/-- Physical left child view, converted through its own flat-product coordinate,
is exactly `(leftTail,I2,I1)`. -/
theorem coordinate_read_leftEmbed
    (n : Nat) (large : 5 <= n)
    (state : PrimitiveBasis (totalWidth n)) :
    flatProductCoordinate (leftTailWidth n)
      (readEmbeddedState (leftEmbed n large) state) =
      let parts := flatFigure3Coordinate n large state
      (parts.2.1,parts.1 1,parts.1 0) := by
  apply Prod.ext
  · funext wire
    simp [flatProductCoordinate, readEmbeddedState, leftEmbed,
      flatFigure3Coordinate, fullCoordinate, splitControls, leftWire,
      headWire]
  · apply Prod.ext
    · simp [flatProductCoordinate, readEmbeddedState, leftEmbed,
        flatFigure3Coordinate, fullCoordinate, splitControls, headWire]
    · simp [flatProductCoordinate, readEmbeddedState, leftEmbed,
        flatFigure3Coordinate, fullCoordinate, splitControls, headWire]

/-- Equivalent raw-flat statement for the left child. -/
theorem read_leftEmbed
    (n : Nat) (large : 5 <= n)
    (state : PrimitiveBasis (totalWidth n)) :
    readEmbeddedState (leftEmbed n large) state =
      (flatProductCoordinate (leftTailWidth n)).symm
        (let parts := flatFigure3Coordinate n large state
         (parts.2.1,parts.1 1,parts.1 0)) := by
  apply (flatProductCoordinate (leftTailWidth n)).injective
  rw [Equiv.apply_symm_apply]
  exact coordinate_read_leftEmbed n large state

/-- Physical right child view, in its local flat-product coordinate, is exactly
`(rightTail,I4,I3)`. -/
theorem coordinate_read_rightEmbed
    (n : Nat) (large : 5 <= n)
    (state : PrimitiveBasis (totalWidth n)) :
    flatProductCoordinate (rightTailWidth n)
      (readEmbeddedState (rightEmbed n large) state) =
      let parts := flatFigure3Coordinate n large state
      (parts.2.2.1,parts.1 3,parts.1 2) := by
  apply Prod.ext
  · funext wire
    simp [flatProductCoordinate, readEmbeddedState, rightEmbed,
      flatFigure3Coordinate, fullCoordinate, splitControls, rightWire,
      headWire]
  · apply Prod.ext
    · simp [flatProductCoordinate, readEmbeddedState, rightEmbed,
        flatFigure3Coordinate, fullCoordinate, splitControls, headWire]
    · simp [flatProductCoordinate, readEmbeddedState, rightEmbed,
        flatFigure3Coordinate, fullCoordinate, splitControls, headWire]

/-- Equivalent raw-flat statement for the right child. -/
theorem read_rightEmbed
    (n : Nat) (large : 5 <= n)
    (state : PrimitiveBasis (totalWidth n)) :
    readEmbeddedState (rightEmbed n large) state =
      (flatProductCoordinate (rightTailWidth n)).symm
        (let parts := flatFigure3Coordinate n large state
         (parts.2.2.1,parts.1 3,parts.1 2)) := by
  apply (flatProductCoordinate (rightTailWidth n)).injective
  rw [Equiv.apply_symm_apply]
  exact coordinate_read_rightEmbed n large state

/-- The two physical child embeddings are disjoint. -/
theorem childEmbeddings_disjoint
    (n : Nat) (large : 5 <= n) :
    ReversibleDisjointEmbedding.DisjointImages
      (leftEmbed n large) (rightEmbed n large) := by
  intro left right equal
  unfold leftEmbed rightEmbed at equal
  by_cases lc : left.val < leftTailWidth n
  · by_cases rc : right.val < rightTailWidth n
    · simp [lc,rc] at equal
      have values := congrArg Fin.val equal
      have leftLt := left.isLt
      omega
    · by_cases rw : right.val = rightTailWidth n <;>
        simp [lc,rc,rw] at equal
  · by_cases lw : left.val = leftTailWidth n
    · by_cases rc : right.val < rightTailWidth n
      · simp [lc,lw,rc] at equal
      · by_cases rw : right.val = rightTailWidth n <;>
          simp [lc,lw,rc,rw] at equal
    · by_cases rc : right.val < rightTailWidth n
      · simp [lc,lw,rc] at equal
      · by_cases rw : right.val = rightTailWidth n <;>
          simp [lc,lw,rc,rw] at equal

end NieZiSunFigure3FlatCoordinates
end QuantumBlockEncoding

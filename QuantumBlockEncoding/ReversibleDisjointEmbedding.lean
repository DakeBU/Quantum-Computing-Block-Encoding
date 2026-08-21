import QuantumBlockEncoding.ReversibleWireEmbedding
import Mathlib.Tactic

/-!
# Semantics of disjoint embedded reversible subprograms

Many source constructions place two already-proved subcircuits on disjoint
physical registers and execute them in the same logical stage.  Even before a
parallel schedule is built, their flattened gate lists may be concatenated
without changing either local action.

This module records the reusable register theorem: if two injective wire maps
have disjoint images, the mapped left program preserves the complete right
register and conversely.  Consequently the concatenated program evaluates each
embedded register exactly as its own local program.
-/

namespace QuantumBlockEncoding
namespace ReversibleDisjointEmbedding

open ReversibleWireEmbedding

/-- Image-disjointness of two physical embeddings. -/
def DisjointImages
    {left right total : Nat}
    (leftEmbed : Fin left -> Fin total)
    (rightEmbed : Fin right -> Fin total) : Prop :=
  ∀ l r, leftEmbed l ≠ rightEmbed r

/-- A mapped left program preserves every right-register wire. -/
theorem left_preserves_right_wire
    {left right total : Nat}
    (leftEmbed : Fin left -> Fin total)
    (leftInjective : Function.Injective leftEmbed)
    (rightEmbed : Fin right -> Fin total)
    (disjoint : DisjointImages leftEmbed rightEmbed)
    (program : ReversibleProgram left)
    (state : PrimitiveBasis total)
    (wire : Fin right) :
    evalReversibleProgram
        (mapProgramWires leftEmbed leftInjective program) state
        (rightEmbed wire) =
      state (rightEmbed wire) := by
  exact eval_mapProgramWires_outside
    leftEmbed leftInjective program state (rightEmbed wire)
    (fun logical => disjoint logical wire)

/-- Whole right register is unchanged by a mapped left program. -/
theorem read_right_after_left
    {left right total : Nat}
    (leftEmbed : Fin left -> Fin total)
    (leftInjective : Function.Injective leftEmbed)
    (rightEmbed : Fin right -> Fin total)
    (disjoint : DisjointImages leftEmbed rightEmbed)
    (program : ReversibleProgram left)
    (state : PrimitiveBasis total) :
    readEmbeddedState rightEmbed
        (evalReversibleProgram
          (mapProgramWires leftEmbed leftInjective program) state) =
      readEmbeddedState rightEmbed state := by
  funext wire
  exact left_preserves_right_wire
    leftEmbed leftInjective rightEmbed disjoint program state wire

/-- Symmetric whole-register preservation. -/
theorem read_left_after_right
    {left right total : Nat}
    (leftEmbed : Fin left -> Fin total)
    (rightEmbed : Fin right -> Fin total)
    (rightInjective : Function.Injective rightEmbed)
    (disjoint : DisjointImages leftEmbed rightEmbed)
    (program : ReversibleProgram right)
    (state : PrimitiveBasis total) :
    readEmbeddedState leftEmbed
        (evalReversibleProgram
          (mapProgramWires rightEmbed rightInjective program) state) =
      readEmbeddedState leftEmbed state := by
  funext wire
  exact eval_mapProgramWires_outside
    rightEmbed rightInjective program state (leftEmbed wire)
    (fun logical => (disjoint wire logical).symm)

/-- After left-then-right execution, the left register has exactly the local
left-program result from the original state. -/
theorem read_left_after_both
    {left right total : Nat}
    (leftEmbed : Fin left -> Fin total)
    (leftInjective : Function.Injective leftEmbed)
    (rightEmbed : Fin right -> Fin total)
    (rightInjective : Function.Injective rightEmbed)
    (disjoint : DisjointImages leftEmbed rightEmbed)
    (leftProgram : ReversibleProgram left)
    (rightProgram : ReversibleProgram right)
    (state : PrimitiveBasis total) :
    readEmbeddedState leftEmbed
      (evalReversibleProgram
        (mapProgramWires leftEmbed leftInjective leftProgram ++
          mapProgramWires rightEmbed rightInjective rightProgram) state) =
      evalReversibleProgram leftProgram (readEmbeddedState leftEmbed state) := by
  rw [evalReversibleProgram_append]
  change
    readEmbeddedState leftEmbed
      (evalReversibleProgram
        (mapProgramWires rightEmbed rightInjective rightProgram)
        (evalReversibleProgram
          (mapProgramWires leftEmbed leftInjective leftProgram) state)) = _
  rw [read_left_after_right leftEmbed rightEmbed rightInjective disjoint]
  exact readEmbeddedState_eval_mapProgramWires
    leftEmbed leftInjective leftProgram state

/-- Right-register analogue. -/
theorem read_right_after_both
    {left right total : Nat}
    (leftEmbed : Fin left -> Fin total)
    (leftInjective : Function.Injective leftEmbed)
    (rightEmbed : Fin right -> Fin total)
    (rightInjective : Function.Injective rightEmbed)
    (disjoint : DisjointImages leftEmbed rightEmbed)
    (leftProgram : ReversibleProgram left)
    (rightProgram : ReversibleProgram right)
    (state : PrimitiveBasis total) :
    readEmbeddedState rightEmbed
      (evalReversibleProgram
        (mapProgramWires leftEmbed leftInjective leftProgram ++
          mapProgramWires rightEmbed rightInjective rightProgram) state) =
      evalReversibleProgram rightProgram (readEmbeddedState rightEmbed state) := by
  rw [evalReversibleProgram_append]
  change
    readEmbeddedState rightEmbed
      (evalReversibleProgram
        (mapProgramWires rightEmbed rightInjective rightProgram)
        (evalReversibleProgram
          (mapProgramWires leftEmbed leftInjective leftProgram) state)) = _
  rw [readEmbeddedState_eval_mapProgramWires]
  rw [read_right_after_left leftEmbed leftInjective rightEmbed disjoint]

end ReversibleDisjointEmbedding
end QuantumBlockEncoding

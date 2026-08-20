import QuantumBlockEncoding.PrimitiveBasisLE
import Mathlib.Tactic

/-!
# Four-wire little-endian basis helpers

The interval-tree State Preparation route is the first four-wire consumer of
the primitive arithmetic layer.  These finite helpers make the repository's
little-endian convention explicit rather than hiding it in repeated
`native_decide` proof fragments.
-/

namespace QuantumBlockEncoding

/-- Explicit inverse image of a four-qubit little-endian flat index. -/
def primitiveBits4LE (index : Fin 16) : PrimitiveBasis 4
  | 0 => ⟨index.val % 2, by omega⟩
  | 1 => ⟨(index.val / 2) % 2, by omega⟩
  | 2 => ⟨(index.val / 4) % 2, by omega⟩
  | _ => ⟨(index.val / 8) % 2, by omega⟩

@[simp] theorem primitiveBasisLEEquiv_four_symm (index : Fin 16) :
    (primitiveBasisLEEquiv 4).symm index = primitiveBits4LE index := by
  native_decide +revert

@[simp] theorem primitiveBasisLEEquiv_four_symm_wire_zero
    (index : Fin (gridSize 4)) :
    ((primitiveBasisLEEquiv 4).symm index) (0 : Fin 4) =
      ⟨index.val % 2, by omega⟩ := by
  native_decide +revert

@[simp] theorem primitiveBasisLEEquiv_four_symm_wire_one
    (index : Fin (gridSize 4)) :
    ((primitiveBasisLEEquiv 4).symm index) (1 : Fin 4) =
      ⟨(index.val / 2) % 2, by omega⟩ := by
  native_decide +revert

@[simp] theorem primitiveBasisLEEquiv_four_symm_wire_two
    (index : Fin (gridSize 4)) :
    ((primitiveBasisLEEquiv 4).symm index) (2 : Fin 4) =
      ⟨(index.val / 4) % 2, by omega⟩ := by
  native_decide +revert

@[simp] theorem primitiveBasisLEEquiv_four_symm_wire_three
    (index : Fin (gridSize 4)) :
    ((primitiveBasisLEEquiv 4).symm index) (3 : Fin 4) =
      ⟨(index.val / 8) % 2, by omega⟩ := by
  native_decide +revert

/-- Encode all four-wire little-endian coordinates except one target wire. -/
def primitiveBits4LEGridWithout
    (target : Fin 4) (index : Fin (gridSize 4)) : Nat :=
  match target.val with
  | 0 => index.val / 2
  | 1 => index.val % 2 + 2 * (index.val / 4)
  | 2 => index.val % 4 + 4 * (index.val / 8)
  | _ => index.val % 8

@[simp] theorem splitPrimitiveWire_primitiveBasisLEEquiv_four_symm_context_eq
    (target : Fin 4) (left right : Fin (gridSize 4)) :
    (splitPrimitiveWire target ((primitiveBasisLEEquiv 4).symm left)).2 =
        (splitPrimitiveWire target ((primitiveBasisLEEquiv 4).symm right)).2 ↔
      primitiveBits4LEGridWithout target left =
        primitiveBits4LEGridWithout target right := by
  native_decide +revert

end QuantumBlockEncoding

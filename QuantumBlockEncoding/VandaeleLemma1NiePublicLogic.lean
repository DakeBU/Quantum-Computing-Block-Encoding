import QuantumBlockEncoding.VandaeleLemma1NieSeedSemantics
import QuantumBlockEncoding.VandaeleLemma1NieFixedSemantics
import Mathlib.Tactic

/-!
# Public logical wire aliases for the Nie Figure-3 proof

The layout implementation deliberately keeps its local `r0,...,r3` Fin values
private.  Correctness proofs should not depend on those implementation names,
so this module exposes only their source-facing meaning: the four reserved
controls `I₁,...,I₄`.
-/

namespace QuantumBlockEncoding
namespace VandaeleLemma1NiePublicLogic

open VandaeleLemma1ProgramFamily
open VandaeleLemma1NieLayout
open VandaeleLemma1NieFixedSemantics
open VandaeleLemma1NieSeedSemantics

private def p0 : Fin 4 := ⟨0, by omega⟩
private def p1 : Fin 4 := ⟨1, by omega⟩
private def p2 : Fin 4 := ⟨2, by omega⟩
private def p3 : Fin 4 := ⟨3, by omega⟩

def i1Wire (k : Nat) (four_le : 4 ≤ k) : Fin (lemmaOneFlatWidth k) :=
  reservedWire k four_le p0

def i2Wire (k : Nat) (four_le : 4 ≤ k) : Fin (lemmaOneFlatWidth k) :=
  reservedWire k four_le p1

def i3Wire (k : Nat) (four_le : 4 ≤ k) : Fin (lemmaOneFlatWidth k) :=
  reservedWire k four_le p2

def i4Wire (k : Nat) (four_le : 4 ≤ k) : Fin (lemmaOneFlatWidth k) :=
  reservedWire k four_le p3

@[simp] theorem left_target_eq_i1
    (k : Nat) (four_le : 4 ≤ k) :
    leftChildEmbed k four_le (targetWire (leftSize k)) = i1Wire k four_le := by
  exact leftChildEmbed_target_reserved0 k four_le

@[simp] theorem left_dirty_eq_i2
    (k : Nat) (four_le : 4 ≤ k) :
    leftChildEmbed k four_le (dirtyWire (leftSize k)) = i2Wire k four_le := by
  exact leftChildEmbed_dirty_reserved1 k four_le

@[simp] theorem right_target_eq_i3
    (k : Nat) (four_le : 4 ≤ k) :
    rightChildEmbed k four_le (targetWire (rightSize k)) = i3Wire k four_le := by
  exact rightChildEmbed_target_reserved2 k four_le

@[simp] theorem right_dirty_eq_i4
    (k : Nat) (four_le : 4 ≤ k) :
    rightChildEmbed k four_le (dirtyWire (rightSize k)) = i4Wire k four_le := by
  exact rightChildEmbed_dirty_reserved3 k four_le

/-- Source-facing form of the Step-3 activation predicate. -/
theorem stepThreeActive_iff_public
    (k : Nat) (four_le : 4 ≤ k)
    (state : PrimitiveBasis (lemmaOneFlatWidth k)) :
    StepThreeActive k four_le state ↔
      state (i1Wire k four_le) = 1 ∧
      state (i3Wire k four_le) = 1 ∧
      state (dirtyWire k) = 1 := by
  rfl

end VandaeleLemma1NiePublicLogic
end QuantumBlockEncoding
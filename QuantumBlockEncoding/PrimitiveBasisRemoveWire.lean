import QuantumBlockEncoding.PrimitiveSemantics
import Mathlib.Tactic

/-!
# Split one named wire from a primitive computational basis

Parity arguments and many dirty-workspace constructions need to isolate one
spectator qubit from an arbitrary flat register.  For a chosen wire `u`, the
basis decomposes losslessly as

`PrimitiveBasis q  ≃  Fin 2 × ({w : Fin q // w ≠ u} -> Fin 2)`.

The construction is independent of any circuit.  Subsequent gate-specific
lemmas can prove that an operation not touching u is duplicated identically over
the two spectator-bit fibres.
-/

namespace QuantumBlockEncoding
namespace PrimitiveBasisRemoveWire

/-- All physical wires except the selected spectator. -/
abbrev OtherWire (q : Nat) (spectator : Fin q) :=
  {wire : Fin q // wire ≠ spectator}

/-- Basis state on every non-spectator wire. -/
abbrev OtherBasis (q : Nat) (spectator : Fin q) :=
  OtherWire q spectator -> Fin 2

/-- Remove one named wire from a flat basis state. -/
def splitWire
    {q : Nat} (spectator : Fin q) :
    PrimitiveBasis q ≃ Fin 2 × OtherBasis q spectator where
  toFun state :=
    (state spectator, fun wire => state wire.1)
  invFun state := fun wire =>
    if same : wire = spectator then state.1
    else state.2 ⟨wire, same⟩
  left_inv state := by
    funext wire
    by_cases same : wire = spectator
    · subst wire
      simp
    · simp [same]
  right_inv state := by
    apply Prod.ext
    · simp
    · funext wire
      simp [wire.2]

@[simp] theorem splitWire_fst
    {q : Nat} (spectator : Fin q) (state : PrimitiveBasis q) :
    (splitWire spectator state).1 = state spectator := by
  rfl

@[simp] theorem splitWire_snd
    {q : Nat} (spectator : Fin q) (state : PrimitiveBasis q)
    (wire : OtherWire q spectator) :
    (splitWire spectator state).2 wire = state wire.1 := by
  rfl

/-- Reassemble with an explicit spectator bit. -/
@[simp] theorem splitWire_symm_spectator
    {q : Nat} (spectator : Fin q)
    (state : Fin 2 × OtherBasis q spectator) :
    (splitWire spectator).symm state spectator = state.1 := by
  simp [splitWire]

/-- Reassembly preserves every other coordinate exactly. -/
@[simp] theorem splitWire_symm_other
    {q : Nat} (spectator : Fin q)
    (state : Fin 2 × OtherBasis q spectator)
    (wire : OtherWire q spectator) :
    (splitWire spectator).symm state wire.1 = state.2 wire := by
  simp [splitWire, wire.2]

/-- Two flat states are equal once spectator and all other coordinates agree. -/
theorem ext_split
    {q : Nat} (spectator : Fin q)
    {left right : PrimitiveBasis q}
    (spectatorEq : left spectator = right spectator)
    (otherEq : ∀ wire : OtherWire q spectator,
      left wire.1 = right wire.1) :
    left = right := by
  apply (splitWire spectator).injective
  apply Prod.ext
  · exact spectatorEq
  · funext wire
    exact otherEq wire

/-- Transport a flat permutation into spectator/other coordinates. -/
def permutationView
    {q : Nat} (spectator : Fin q)
    (permutation : Equiv.Perm (PrimitiveBasis q)) :
    Equiv.Perm (Fin 2 × OtherBasis q spectator) :=
  (splitWire spectator).symm.trans
    (permutation.trans (splitWire spectator))

/-- The transported permutation really is conjugate to the original one. -/
theorem permutationView_conjugate
    {q : Nat} (spectator : Fin q)
    (permutation : Equiv.Perm (PrimitiveBasis q)) :
    ((splitWire spectator).trans
      (permutationView spectator permutation)).trans
        (splitWire spectator).symm = permutation := by
  apply Equiv.ext
  intro state
  simp [permutationView]

end PrimitiveBasisRemoveWire
end QuantumBlockEncoding

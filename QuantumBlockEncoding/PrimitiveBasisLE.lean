import QuantumBlockEncoding.PrimitiveSemantics

/-!
# Little-endian primitive basis indexing

The primitive circuit semantics names qubits by `Fin q`.  This file fixes the
conversion to flat matrix indices: wire zero is the least-significant bit.
Keeping this equivalence explicit prevents executable backends from silently
choosing a different register order.
-/

namespace QuantumBlockEncoding

/-- Convert named primitive bits to a flat little-endian matrix index. -/
def primitiveBasisLEEquiv : (q : Nat) -> PrimitiveBasis q ≃ Fin (gridSize q)
  | 0 =>
      { toFun := fun _ => ⟨0, by decide⟩
        invFun := fun _ => Fin.elim0
        left_inv := fun bits => funext fun wire => Fin.elim0 wire
        right_inv := fun index => by fin_cases index; rfl }
  | q + 1 =>
      (Fin.consEquiv (fun _ : Fin (q + 1) => Fin 2)).symm
        |>.trans (Equiv.prodCongr (Equiv.refl (Fin 2)) (primitiveBasisLEEquiv q))
        |>.trans (Equiv.prodComm (Fin 2) (Fin (gridSize q)))
        |>.trans finProdFinEquiv
        |>.trans (finCongr (by simp [gridSize, pow_succ]))

@[simp] theorem primitiveBasisLEEquiv_zero_apply (bits : PrimitiveBasis 0) :
    (primitiveBasisLEEquiv 0 bits).val = 0 := by
  rfl

/-- The recursive equation makes the little-endian convention inspectable. -/
theorem primitiveBasisLEEquiv_succ_value (q : Nat)
    (bits : PrimitiveBasis (q + 1)) :
    (primitiveBasisLEEquiv (q + 1) bits).val =
      (bits 0).val + 2 *
        (primitiveBasisLEEquiv q (fun wire => bits wire.succ)).val := by
  rfl

/-- Six-wire expansion used by the fixed Robin executable benchmark. -/
theorem primitiveBasisLEEquiv_six_value (bits : PrimitiveBasis 6) :
    (primitiveBasisLEEquiv 6 bits).val =
      (bits 0).val + 2 * (bits 1).val + 4 * (bits 2).val +
      8 * (bits 3).val + 16 * (bits 4).val + 32 * (bits 5).val := by
  native_decide +revert

end QuantumBlockEncoding

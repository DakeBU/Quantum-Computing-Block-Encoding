import QuantumBlockEncoding.VandaeleFigure4AdderContractBridge
import QuantumBlockEncoding.VandaeleQuantumAdderTarget
import Mathlib.Tactic

/-!
# Figure 4 compatibility with the canonical quantum-adder target

The literal eight-slice Figure-4 circuit is already certified as a 35-gate
five-bit ripple-carry adder, while `VandaeleQuantumAdderTarget` provides the
canonical arbitrary-width semantic permutation.  This file closes the remaining
representation gap at width five.

The proof does not re-evaluate gates and does not enumerate the 2048 basis
states.  It uses the explicit `(b,z)` payload equivalence, injectivity of the
little-endian basis value, the certified Figure-4 sum/carry equations, and one
six-bit modular-arithmetic identity.
-/

namespace QuantumBlockEncoding
namespace VandaeleFigure4QuantumAdderCompatibility

open VandaeleComparatorContract
open VandaeleFigure4AdderContractBridge
open VandaeleFigure4FullSliceCorrespondence
open VandaeleQuantumAdderTarget
open PrimitiveBasisModularArithmetic

/-- The pure primitive-basis value and the Equation-(17) little-endian value are
the same integer representation. -/
theorem basisNat_eq_littleEndianValue {n : Nat} (bits : PrimitiveBasis n) :
    basisNat n bits = littleEndianValue bits := by
  unfold basisNat littleEndianValue
  exact primitiveBasisLEEquiv_value_eq_sum n bits

/-- The little-endian natural value uniquely determines a primitive basis
register. -/
theorem basisNat_injective (n : Nat) : Function.Injective (basisNat n) := by
  intro left right equal
  apply (primitiveBasisLEEquiv n).injective
  apply Fin.ext
  simpa [basisNat] using equal

/-- Reader-facing Figure-4 coordinates and the canonical quantum-adder state are
losslessly equivalent.  The canonical second register is the six-bit payload
whose low five wires are `b` and whose high wire is `z`. -/
def figure4QuantumAdderEquiv :
    Figure4AdderState ≃ QuantumAdderState 5 where
  toFun state :=
    (state.addend, (payloadBZEquiv 5).symm (state.target, state.carry))
  invFun state :=
    { addend := state.1
      target := (payloadBZEquiv 5 state.2).1
      carry := (payloadBZEquiv 5 state.2).2 }
  left_inv state := by
    apply figure4AdderState_ext
    · rfl
    · simp
    · simp
  right_inv state := by
    apply Prod.ext
    · rfl
    · simp

/-- Under the layout equivalence, the six-bit payload value is exactly
`value(b) + 32 z`. -/
theorem figure4QuantumAdder_payload_value (state : Figure4AdderState) :
    basisNat 6 (figure4QuantumAdderEquiv state).2 =
      littleEndianValue state.target + 32 * state.carry.val := by
  have source := payloadBZ_value 5 (figure4QuantumAdderEquiv state).2
  simpa [figure4QuantumAdderEquiv, basisNat_eq_littleEndianValue, gridSize]
    using source

/-- Arithmetic core of the compatibility proof.  The identity is simply the
base-32 decomposition of a six-bit modular sum, and in fact holds for arbitrary
natural `a`, `b`, and `z`. -/
theorem fiveBitPayloadAddIdentity (a b z : Nat) :
    (a + b) % 32 + 32 * ((z + (a + b) / 32) % 2) =
      (b + 32 * z + a) % 64 := by
  omega

/-- Pointwise commuting square: converting the literal Figure-4 output to the
canonical representation is exactly the same as applying the canonical
five-bit quantum adder after converting the input. -/
theorem literalFigure4_quantumAdder_commutes (state : Figure4AdderState) :
    figure4QuantumAdderEquiv (literalFigure4AdderAction state) =
      quantumAdderEquiv 5 (figure4QuantumAdderEquiv state) := by
  apply Prod.ext
  · simp [figure4QuantumAdderEquiv, literalFigure4_preserves_addend]
  · apply basisNat_injective 6
    rw [figure4QuantumAdder_payload_value]
    rw [quantumAdder_payload_value]
    rw [figure4QuantumAdder_payload_value]
    rw [literalFigure4_writes_sum, literalFigure4_writes_carry]
    simp only [figure4QuantumAdderEquiv]
    rw [basisNat_eq_littleEndianValue]
    norm_num [gridSize]
    exact fiveBitPayloadAddIdentity
      (littleEndianValue state.addend)
      (littleEndianValue state.target)
      state.carry.val

/-- The literal Figure-4 action transported into the canonical product-register
representation. -/
def literalFigure4CanonicalAction
    (state : QuantumAdderState 5) : QuantumAdderState 5 :=
  figure4QuantumAdderEquiv
    (literalFigure4AdderAction (figure4QuantumAdderEquiv.symm state))

/-- Canonical realization theorem: the transported literal 35-gate Figure-4
source action is exactly `quantumAdderEquiv 5`. -/
theorem literalFigure4CanonicalAction_eq_quantumAdder :
    literalFigure4CanonicalAction = quantumAdderEquiv 5 := by
  funext state
  unfold literalFigure4CanonicalAction
  rw [literalFigure4_quantumAdder_commutes]
  simp

/-- Reader-facing root certificate pairing the canonical semantic equality with
the exact gate count of the displayed Figure-4 source circuit. -/
theorem literalFigure4_canonical_quantumAdder_certificate :
    literalFigure4CanonicalAction = quantumAdderEquiv 5 ∧
      figure4EightSliceProgram.length = 35 :=
  ⟨literalFigure4CanonicalAction_eq_quantumAdder,
    figure4EightSlice_gateCount⟩

end VandaeleFigure4QuantumAdderCompatibility
end QuantumBlockEncoding

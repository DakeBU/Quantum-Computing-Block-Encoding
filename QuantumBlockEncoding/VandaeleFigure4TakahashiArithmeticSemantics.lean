import QuantumBlockEncoding.VandaeleFigure4TakahashiStepSemantics
import Mathlib.Tactic

/-!
# Arithmetic semantics of the Takahashi ADD5 source behind Vandaele Figure 4

The previous node proves the exact six-step X/CX/CCX source program produces an
explicit final carry/sum bit state.  This file performs the final reader-facing
conversion: the preserved and overwritten wires are interpreted as unsigned
five-bit integers.

For the exact 29-gate source program used by the displayed five-bit Figure 4,
Lean proves:

* the `a` register is preserved;
* the `b` register becomes `(a+b) mod 32`;
* the flag wire is toggled by the outgoing carry `(a+b)/32`.

No circuit gate is re-evaluated here.  The proof composes the gate-level final
state theorem with the independent scalar carry certificate, keeping the
source-transcription, gate-refinement, and arithmetic layers inspectable.
-/

namespace QuantumBlockEncoding
namespace VandaeleFigure4TakahashiArithmeticSemantics

open VandaeleFigure4TakahashiSourceProgram
open VandaeleFigure4TakahashiCarryAlgebra
open VandaeleFigure4TakahashiStepSemantics

/-- Arithmetic certificate first stated on the eleven explicit displayed
source bits. -/
theorem sourceProgram_arithmetic_certificate_bits
    (a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 z : Fin 2) :
    let input := sourceState a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 z
    let output := evalReversibleProgram sourceProgram input
    aValue output = aValue input ∧
      bValue output = (aValue input + bValue input) % 32 ∧
      zValue output =
        (zValue input + (aValue input + bValue input) / 32) % 2 := by
  dsimp only
  rw [sourceProgram_finalState]
  rcases fiveBit_arithmetic_certificate
      a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 with ⟨lowBits, outgoingCarry⟩
  constructor
  · rfl
  constructor
  · simpa [aValue, bValue, finalState, sourceState, fiveValue] using lowBits
  · simpa [aValue, bValue, zValue, finalState, sourceState, fiveValue,
      xorBit_value, outgoingCarry, Nat.add_comm]

/-- Figure-4 arithmetic theorem for an arbitrary eleven-wire computational
basis state. -/
theorem sourceProgram_arithmetic_certificate (state : SourceBasis) :
    let output := evalReversibleProgram sourceProgram state
    aValue output = aValue state ∧
      bValue output = (aValue state + bValue state) % 32 ∧
      zValue output =
        (zValue state + (aValue state + bValue state) / 32) % 2 := by
  simpa only [sourceState_eta] using
    sourceProgram_arithmetic_certificate_bits
      (state 0) (state 1) (state 2) (state 3) (state 4) (state 5)
      (state 6) (state 7) (state 8) (state 9) (state 10)

/-- The source adder preserves the displayed `a` register exactly. -/
theorem sourceProgram_preserves_a (state : SourceBasis) :
    aValue (evalReversibleProgram sourceProgram state) = aValue state := by
  exact (sourceProgram_arithmetic_certificate state).1

/-- The source adder overwrites `b` with the low five bits of `a+b`. -/
theorem sourceProgram_writes_sum (state : SourceBasis) :
    bValue (evalReversibleProgram sourceProgram state) =
      (aValue state + bValue state) % 32 := by
  exact (sourceProgram_arithmetic_certificate state).2.1

/-- The source adder toggles `z` by the outgoing carry bit. -/
theorem sourceProgram_toggles_outgoing_carry (state : SourceBasis) :
    zValue (evalReversibleProgram sourceProgram state) =
      (zValue state + (aValue state + bValue state) / 32) % 2 := by
  exact (sourceProgram_arithmetic_certificate state).2.2

end VandaeleFigure4TakahashiArithmeticSemantics
end QuantumBlockEncoding

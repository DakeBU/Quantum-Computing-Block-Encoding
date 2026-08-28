import QuantumBlockEncoding.VandaeleComparatorBitArithmetic
import QuantumBlockEncoding.VandaeleFigure4FullSliceCorrespondence
import QuantumBlockEncoding.VandaeleFigure4TakahashiArithmeticSemantics
import Mathlib.Tactic

/-!
# Figure 4 source-to-adder contract bridge

Vandaele Figure 4 is now certified at the literal source level: its displayed
eight slices form a 35-gate reversible circuit semantically equivalent to the
optimized 29-gate Takahashi--Tani--Kunihiro source program.  The source proof
also gives the exact five-bit sum and outgoing-carry arithmetic.

This module closes the representation gap to a lightweight, source-independent
five-bit adder contract.  We deliberately avoid the older generic
`VandaeleQuantumAdderTarget` dependency chain here: that legacy route currently
passes through unrelated incrementer/register-split infrastructure.  The
contract below depends only on the stable little-endian `BitRegister` layer and
states exactly the Figure-4 basis action:

* preserve the five-bit addend register `a` bit-for-bit;
* write `(a+b) mod 32` into the five-bit target register `b`;
* update the carry bit by the outgoing carry `(a+b)/32`.

The root certificate transports the literal 35-gate Figure-4 source circuit
through an explicit eleven-wire layout.  A compatibility theorem with the
older generic quantum-adder target can therefore be proved later without
reopening the gate/source proof.
-/

namespace QuantumBlockEncoding
namespace VandaeleFigure4AdderContractBridge

open VandaeleComparatorContract
open VandaeleComparatorBitArithmetic
open VandaeleFigure4TakahashiSourceProgram
open VandaeleFigure4TakahashiArithmeticSemantics
open VandaeleFigure4FullSliceCorrespondence

/-- Reader-facing five-bit state for Figure 4. -/
structure Figure4AdderState where
  addend : BitRegister 5
  target : BitRegister 5
  carry : Fin 2

/-- Extensionality for the three-field Figure-4 adder state. -/
theorem figure4AdderState_ext
    {leftState rightState : Figure4AdderState}
    (addendEq : leftState.addend = rightState.addend)
    (targetEq : leftState.target = rightState.target)
    (carryEq : leftState.carry = rightState.carry) :
    leftState = rightState := by
  rcases leftState with ⟨addend₁, target₁, carry₁⟩
  rcases rightState with ⟨addend₂, target₂, carry₂⟩
  cases addendEq
  cases targetEq
  cases carryEq
  rfl

/-- Even-position source wires form the little-endian addend register. -/
def sourceAddend (state : SourceBasis) : BitRegister 5 :=
  fun index =>
    match index.val with
    | 0 => state 0
    | 1 => state 2
    | 2 => state 4
    | 3 => state 6
    | _ => state 8

/-- Odd-position source wires form the little-endian target register. -/
def sourceTarget (state : SourceBasis) : BitRegister 5 :=
  fun index =>
    match index.val with
    | 0 => state 1
    | 1 => state 3
    | 2 => state 5
    | 3 => state 7
    | _ => state 9

/-- Read the literal interleaved Figure-4 source wires as an adder state. -/
def sourceToFigure4AdderState (state : SourceBasis) : Figure4AdderState where
  addend := sourceAddend state
  target := sourceTarget state
  carry := state 10

/-- Write a reader-facing Figure-4 adder state back into the exact interleaved
source order `a0,b0,...,a4,b4,z`. -/
def figure4AdderStateToSource (state : Figure4AdderState) : SourceBasis :=
  sourceState
    (state.addend 0) (state.target 0)
    (state.addend 1) (state.target 1)
    (state.addend 2) (state.target 2)
    (state.addend 3) (state.target 3)
    (state.addend 4) (state.target 4)
    state.carry

/-- Reading after writing the Figure-4 layout is exact. -/
theorem sourceToFigure4Adder_figure4AdderStateToSource
    (state : Figure4AdderState) :
    sourceToFigure4AdderState (figure4AdderStateToSource state) = state := by
  apply figure4AdderState_ext
  · funext index
    fin_cases index <;> rfl
  · funext index
    fin_cases index <;> rfl
  · rfl

/-- Writing after reading the Figure-4 layout is exact. -/
theorem figure4AdderStateToSource_sourceToFigure4Adder
    (state : SourceBasis) :
    figure4AdderStateToSource (sourceToFigure4AdderState state) = state := by
  simpa [figure4AdderStateToSource, sourceToFigure4AdderState,
    sourceAddend, sourceTarget] using sourceState_eta state

/-- The source wire layout and the reader-facing Figure-4 state are equivalent
representations of the same eleven computational-basis bits. -/
def sourceFigure4AdderEquiv : SourceBasis ≃ Figure4AdderState where
  toFun := sourceToFigure4AdderState
  invFun := figure4AdderStateToSource
  left_inv := figure4AdderStateToSource_sourceToFigure4Adder
  right_inv := sourceToFigure4Adder_figure4AdderStateToSource

/-- Numeric value of the source addend is exactly the source `aValue`. -/
theorem sourceAddend_littleEndianValue (state : SourceBasis) :
    littleEndianValue (sourceAddend state) = aValue state := by
  rw [littleEndianValue_succ]
  rw [littleEndianValue_succ]
  rw [littleEndianValue_succ]
  rw [littleEndianValue_succ]
  rw [littleEndianValue_succ]
  simp [littleEndianValue, tailBits, sourceAddend, aValue]
  ring

/-- Numeric value of the source target is exactly the source `bValue`. -/
theorem sourceTarget_littleEndianValue (state : SourceBasis) :
    littleEndianValue (sourceTarget state) = bValue state := by
  rw [littleEndianValue_succ]
  rw [littleEndianValue_succ]
  rw [littleEndianValue_succ]
  rw [littleEndianValue_succ]
  rw [littleEndianValue_succ]
  simp [littleEndianValue, tailBits, sourceTarget, bValue]
  ring

@[simp] theorem sourceAddend_figure4AdderStateToSource
    (state : Figure4AdderState) :
    sourceAddend (figure4AdderStateToSource state) = state.addend := by
  funext index
  fin_cases index <;> rfl

@[simp] theorem sourceTarget_figure4AdderStateToSource
    (state : Figure4AdderState) :
    sourceTarget (figure4AdderStateToSource state) = state.target := by
  funext index
  fin_cases index <;> rfl

/-- Contract/source numeric bridge for the addend. -/
theorem aValue_figure4AdderStateToSource (state : Figure4AdderState) :
    aValue (figure4AdderStateToSource state) =
      littleEndianValue state.addend := by
  rw [← sourceAddend_littleEndianValue]
  simp

/-- Contract/source numeric bridge for the target. -/
theorem bValue_figure4AdderStateToSource (state : Figure4AdderState) :
    bValue (figure4AdderStateToSource state) =
      littleEndianValue state.target := by
  rw [← sourceTarget_littleEndianValue]
  simp

@[simp] theorem zValue_figure4AdderStateToSource (state : Figure4AdderState) :
    zValue (figure4AdderStateToSource state) = state.carry.val := by
  rfl

/-- Lightweight five-bit Figure-4 functional contract.  It is intentionally a
predicate on an implementation function, so the source certificate remains
independent of the older generic adder target infrastructure. -/
def Figure4AdderSpec
    (implementation : Figure4AdderState → Figure4AdderState) : Prop :=
  ∀ state,
    (implementation state).addend = state.addend ∧
      littleEndianValue (implementation state).target =
        (littleEndianValue state.addend + littleEndianValue state.target) % 32 ∧
      (implementation state).carry.val =
        (state.carry.val +
          (littleEndianValue state.addend + littleEndianValue state.target) / 32) % 2

/-- The arithmetic certificate for the optimized source transports immediately
to the literal 35-gate eight-slice Figure-4 program. -/
theorem figure4EightSlice_arithmetic_certificate (state : SourceBasis) :
    let output := evalReversibleProgram figure4EightSliceProgram state
    aValue output = aValue state ∧
      bValue output = (aValue state + bValue state) % 32 ∧
      zValue output =
        (zValue state + (aValue state + bValue state) / 32) % 2 := by
  rw [figure4EightSlice_refines_sourceProgram]
  exact sourceProgram_arithmetic_certificate state

/-- The exact literal Figure-4 source action, expressed in the lightweight
reader-facing adder representation. -/
def literalFigure4AdderAction
    (state : Figure4AdderState) : Figure4AdderState :=
  sourceToFigure4AdderState
    (evalReversibleProgram figure4EightSliceProgram
      (figure4AdderStateToSource state))

/-- The literal Figure-4 circuit preserves the five addend bits exactly, not
merely their numeric value. -/
theorem literalFigure4_preserves_addend (state : Figure4AdderState) :
    (literalFigure4AdderAction state).addend = state.addend := by
  rcases state with ⟨addend, target, carry⟩
  unfold literalFigure4AdderAction sourceToFigure4AdderState
  unfold figure4AdderStateToSource
  rw [figure4EightSlice_finalState]
  funext index
  fin_cases index <;> rfl

/-- The literal Figure-4 target register contains the low five bits of `a+b`. -/
theorem literalFigure4_writes_sum (state : Figure4AdderState) :
    littleEndianValue (literalFigure4AdderAction state).target =
      (littleEndianValue state.addend + littleEndianValue state.target) % 32 := by
  change
    littleEndianValue
        (sourceTarget
          (evalReversibleProgram figure4EightSliceProgram
            (figure4AdderStateToSource state))) = _
  rw [sourceTarget_littleEndianValue]
  have arithmetic :=
    figure4EightSlice_arithmetic_certificate (figure4AdderStateToSource state)
  rw [arithmetic.2.1]
  rw [aValue_figure4AdderStateToSource, bValue_figure4AdderStateToSource]

/-- The literal Figure-4 carry wire is toggled by the outgoing carry of `a+b`. -/
theorem literalFigure4_writes_carry (state : Figure4AdderState) :
    (literalFigure4AdderAction state).carry.val =
      (state.carry.val +
        (littleEndianValue state.addend + littleEndianValue state.target) / 32) % 2 := by
  change
    zValue
        (evalReversibleProgram figure4EightSliceProgram
          (figure4AdderStateToSource state)) = _
  have arithmetic :=
    figure4EightSlice_arithmetic_certificate (figure4AdderStateToSource state)
  rw [arithmetic.2.2]
  rw [zValue_figure4AdderStateToSource,
    aValue_figure4AdderStateToSource, bValue_figure4AdderStateToSource]

/-- Root source-to-contract theorem: the literal 35-gate Figure-4 drawing
satisfies the five-bit ripple-carry adder contract on every basis state. -/
theorem literalFigure4_adderSpec :
    Figure4AdderSpec literalFigure4AdderAction := by
  intro state
  exact ⟨literalFigure4_preserves_addend state,
    literalFigure4_writes_sum state,
    literalFigure4_writes_carry state⟩

/-- Reader-facing certificate pairing the exact Figure-4 source cost with its
functional five-bit adder semantics. -/
theorem literalFigure4_source_certificate :
    Figure4AdderSpec literalFigure4AdderAction ∧
      figure4EightSliceProgram.length = 35 :=
  ⟨literalFigure4_adderSpec, figure4EightSlice_gateCount⟩

end VandaeleFigure4AdderContractBridge
end QuantumBlockEncoding

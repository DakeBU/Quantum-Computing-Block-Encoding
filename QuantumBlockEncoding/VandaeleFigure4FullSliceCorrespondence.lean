import QuantumBlockEncoding.VandaeleFigure4LadderSliceCorrespondence
import Mathlib.Tactic

/-!
# Full source correspondence for Vandaele Figure 4

Vandaele, arXiv:2603.12917v1, Figure 4 draws the five-bit Takahashi adder as
red slices `U₁,...,U₈`.  A source audit of the literal diagram reveals an
important distinction from the six-step Takahashi source program already
certified in Lean: the displayed slicing is not a 29-gate list regrouping.

To expose the adjoint pairs `U₅ = U₃†` and `U₇ = U₂†`, Figure 4 pulls the
four Step-4 sum CNOTs in front of the descending Toffoli ladder and inserts a
three-X conjugation layer on `b₁,b₂,b₃` on both sides of that ladder.  The
literal eight-slice diagram therefore has 35 gates, while the cited TTK source
has the optimized `7n-6 = 29` gates at `n=5`.

This module transcribes all eight literal slices and proves the two circuits
semantically equal on every computational-basis state.  Thus downstream
arithmetic theorems may safely use the source-certified 29-gate implementation,
while source-facing statements about Vandaele Figure 4 retain the exact
35-gate drawing and its `U_i` factorization.
-/

namespace QuantumBlockEncoding
namespace VandaeleFigure4FullSliceCorrespondence

open VandaeleFigure4TakahashiSourceProgram
open VandaeleFigure4TakahashiCarryAlgebra
open VandaeleFigure4TakahashiStepSemantics
open VandaeleFigure4LadderSliceCorrespondence

/-- Figure-4 slice 1: the four parallel pre-sum CNOTs followed by the
`A₄ -> z` CNOT that starts Takahashi Step 2. -/
def figure4U1 : ReversibleProgram 11 :=
  step1 ++ [ .cx 8 10 (by decide) ]

/-- Figure-4 slice 4 as literally drawn.  After the outgoing-carry Toffoli,
the four Step-4 sum CNOTs are collected into one layer; the lower three `b`
wires are then conjugated by X before the descending Toffoli ladder. -/
def figure4U4 : ReversibleProgram 11 :=
  [ .ccx 9 8 10 (by decide) (by decide) (by decide),
    .cx 8 9 (by decide),
    .cx 6 7 (by decide),
    .cx 4 5 (by decide),
    .cx 2 3 (by decide),
    .x 3,
    .x 5,
    .x 7 ]

/-- Figure-4 slice 6: the second half of the three-X conjugation around
`U₅ = U₃†`. -/
def figure4U6 : ReversibleProgram 11 :=
  [ .x 3, .x 5, .x 7 ]

/-- Figure-4 slice 8: the five parallel final sum CNOTs, i.e. Takahashi Step 6. -/
def figure4U8 : ReversibleProgram 11 :=
  step6

/-- Literal chronological eight-slice program displayed in Figure 4. -/
def figure4EightSliceProgram : ReversibleProgram 11 :=
  figure4U1 ++ figure4U2 ++ figure4U3 ++ figure4U4 ++
    figure4U5 ++ figure4U6 ++ figure4U7 ++ figure4U8

/-- The four formerly-open visual slices have lengths 5, 8, 3, and 5. -/
theorem figure4U1_U4_U6_U8_gateCounts :
    (figure4U1.length, figure4U4.length, figure4U6.length, figure4U8.length) =
      (5, 8, 3, 5) := by
  native_decide

/-- The literal sliced Figure 4 has 35 gates.  The six extra gates are the two
three-X layers used by the source refactor; they are absent from the optimized
29-gate TTK list. -/
theorem figure4EightSlice_gateCount : figure4EightSliceProgram.length = 35 := by
  native_decide

/-- The outer source pieces are literal list splits: Steps 1--2 become
`U₁;U₂`. -/
theorem step1_step2_eq_figure4U1_U2 :
    step1 ++ step2 = figure4U1 ++ figure4U2 := by
  simp [step2, figure4U1, figure4U2]

/-- Takahashi Step 5 is exactly the displayed adjoint CX ladder `U₇`. -/
theorem step5_eq_figure4U7 : step5 = figure4U7 := by
  simp [step5, figure4U7, figure4U2, step2]

/-- Takahashi Step 6 is exactly displayed slice `U₈`. -/
theorem step6_eq_figure4U8 : step6 = figure4U8 := by
  rfl

/-- X as a scalar bit flip on exactly one target wire. -/
def xUpdate {qubits : Nat} (target : Fin qubits)
    (state : PrimitiveBasis qubits) : PrimitiveBasis qubits :=
  Function.update state target (flipBit (state target))

/-- Exact bridge from the reversible X evaluator to scalar bit flip. -/
theorem evalReversibleGate_x_eq_update
    {qubits : Nat} (target : Fin qubits) (state : PrimitiveBasis qubits) :
    evalReversibleGate (.x target) state = xUpdate target state := by
  funext wire
  by_cases same : wire = target
  · subst wire
    simp [evalReversibleGate, xBasisEquiv, xBasisAction, xUpdate]
  · simp [evalReversibleGate, xBasisEquiv, xBasisAction, xUpdate, same]

/-- Boolean identity behind the Figure-4 Step-4 refactor.  Once `b` has first
been toggled by control `a`, complementing that control restores exactly the
old `b` whenever the Toffoli is active. -/
@[simp] theorem andBit_flip_xor_self (a b : Fin 2) :
    andBit a (flipBit (xorBit a b)) = andBit a b := by
  fin_cases a <;> fin_cases b <;> rfl

/-- The literal middle slices `U₄;U₅;U₆` are semantically equal to the final
Toffoli of Takahashi Step 3 followed by Step 4.  This is the nontrivial source
refinement: it is semantic circuit algebra, not list equality. -/
theorem figure4_middle_refactor_bits
    (a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 z : Fin 2) :
    evalReversibleProgram (step3.drop 4 ++ step4)
        (sourceState a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 z) =
      evalReversibleProgram (figure4U4 ++ figure4U5 ++ figure4U6)
        (sourceState a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 z) := by
  funext wire
  fin_cases wire <;>
    simp [step3, step4, figure4U4, figure4U5, figure4U3, figure4U6,
      evalReversibleProgram,
      evalReversibleGate_x_eq_update,
      evalReversibleGate_cx_eq_update,
      evalReversibleGate_ccx_eq_update,
      xUpdate, cxUpdate, ccxUpdate, sourceState,
      andBit_flip_xor_self]

/-- Arbitrary-state form of the middle source refactor. -/
theorem figure4_middle_refactor (state : SourceBasis) :
    evalReversibleProgram (step3.drop 4 ++ step4) state =
      evalReversibleProgram (figure4U4 ++ figure4U5 ++ figure4U6) state := by
  have bits := figure4_middle_refactor_bits
    (state 0) (state 1) (state 2) (state 3) (state 4) (state 5)
    (state 6) (state 7) (state 8) (state 9) (state 10)
  rw [sourceState_eta state] at bits
  exact bits

/-- Shared prefix before the source-refactored middle block. -/
def figure4Prefix : ReversibleProgram 11 :=
  step1 ++ step2 ++ figure4U3

/-- Middle block as literally displayed by Vandaele. -/
def figure4SlicedMiddle : ReversibleProgram 11 :=
  figure4U4 ++ figure4U5 ++ figure4U6

/-- Same middle computation in the optimized Takahashi source order. -/
def figure4SourceMiddle : ReversibleProgram 11 :=
  step3.drop 4 ++ step4

/-- Shared suffix after the middle block. -/
def figure4Suffix : ReversibleProgram 11 :=
  step5 ++ step6

/-- The literal eight-slice circuit factors into one shared prefix, the
Vandaele middle refactor, and one shared suffix. -/
theorem figure4EightSliceProgram_eq_chunks :
    figure4EightSliceProgram =
      figure4Prefix ++ figure4SlicedMiddle ++ figure4Suffix := by
  unfold figure4EightSliceProgram figure4Prefix figure4SlicedMiddle figure4Suffix
  rw [← step1_step2_eq_figure4U1_U2]
  rw [← step5_eq_figure4U7]
  rw [← step6_eq_figure4U8]
  simp [List.append_assoc]

/-- Step 3 splits into the displayed `U₃` and its final outgoing-carry gate. -/
theorem step3_eq_figure4U3_then_tail :
    step3 = figure4U3 ++ step3.drop 4 := by
  simpa only [figure4U3] using (List.take_append_drop 4 step3).symm

/-- The optimized 29-gate source has the same prefix and suffix, with only the
middle block written in Takahashi order. -/
theorem sourceProgram_eq_chunks :
    sourceProgram =
      figure4Prefix ++ figure4SourceMiddle ++ figure4Suffix := by
  unfold sourceProgram figure4Prefix figure4Suffix
  rw [step3_eq_figure4U3_then_tail]
  unfold figure4SourceMiddle
  simp [List.append_assoc]

/-- Named-chunk form of the already certified middle semantic refactor. -/
theorem figure4_middle_refactor_chunks (state : SourceBasis) :
    evalReversibleProgram figure4SourceMiddle state =
      evalReversibleProgram figure4SlicedMiddle state := by
  simpa [figure4SourceMiddle, figure4SlicedMiddle] using
    figure4_middle_refactor state

/-- Semantic equality between the cited optimized 29-gate TTK source and the
literal 35-gate eight-slice Vandaele Figure-4 drawing. -/
theorem figure4EightSlice_refines_sourceProgram :
    evalReversibleProgram figure4EightSliceProgram =
      evalReversibleProgram sourceProgram := by
  apply Equiv.ext
  intro state
  rw [figure4EightSliceProgram_eq_chunks, sourceProgram_eq_chunks]
  simp only [evalReversibleProgram_append_apply_local]
  rw [← figure4_middle_refactor_chunks]

end VandaeleFigure4FullSliceCorrespondence
end QuantumBlockEncoding

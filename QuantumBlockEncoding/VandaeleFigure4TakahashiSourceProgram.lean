import QuantumBlockEncoding.ReversibleClassical
import Mathlib.Tactic

/-!
# Gate-level source program behind Vandaele Figure 4

Vandaele's Figure 4 (arXiv:2603.12917v1, Figure 4) is explicitly presented as
an ancilla-free five-bit ripple-carry adder from Takahashi--Tani--Kunihiro [12].
The cited source, arXiv:0910.2530, Section 2.2, gives the adder as six exact
steps over CNOT and Toffoli gates and states that the five-bit circuit is its
Figure 2 instance.

This file is the source-transcription node.  It writes those six authoritative
steps in the repository's existing `ReversibleProgram` IR, after the harmless
wire relabelling used by Vandaele:

`a0, b0, a1, b1, a2, b2, a3, b3, a4, b4, z`.

The exact source size is certified here: the six step lengths are
`4,4,5,8,3,5`, hence 29 gates, the `7n-6` count at `n=5` stated by the cited
construction.  Arithmetic correctness is deliberately *not* discharged by a
single 2^11-state `native_decide`: that representation made Lean evaluate
function-valued reversible equivalences for hours.  Instead the downstream
proof is factored into a small carry-algebra node and local gate-refinement
lemmas.  This keeps the proof source-grounded and CI-sustainable.

A downstream source-correspondence node audits Vandaele's red `U₁,...,U₈`
slices separately.  The literal Figure 4 is not a gate-for-gate regrouping of
this optimized list: its displayed X-conjugation layers give 35 gates, with
semantic equivalence proved compositionally.
-/

namespace QuantumBlockEncoding
namespace VandaeleFigure4TakahashiSourceProgram

/-- Five-bit Vandaele/Takahashi source layout has ten data wires plus `z`. -/
abbrev SourceBasis := PrimitiveBasis 11

/-- Canonical constructor exposing all eleven displayed source wires. -/
def sourceState
    (a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 z : Fin 2) : SourceBasis :=
  fun wire =>
    match wire.val with
    | 0 => a0
    | 1 => b0
    | 2 => a1
    | 3 => b1
    | 4 => a2
    | 5 => b2
    | 6 => a3
    | 7 => b3
    | 8 => a4
    | 9 => b4
    | _ => z

/-- Every source basis state is recovered from its eleven displayed wires. -/
theorem sourceState_eta (state : SourceBasis) :
    sourceState
      (state 0) (state 1) (state 2) (state 3) (state 4) (state 5)
      (state 6) (state 7) (state 8) (state 9) (state 10) = state := by
  funext wire
  fin_cases wire <;> rfl

/-- Unsigned little-endian value of the displayed `a` register. -/
def aValue (state : SourceBasis) : Nat :=
  (state 0).val +
    2 * (state 2).val +
    4 * (state 4).val +
    8 * (state 6).val +
    16 * (state 8).val

/-- Unsigned little-endian value of the displayed `b` register. -/
def bValue (state : SourceBasis) : Nat :=
  (state 1).val +
    2 * (state 3).val +
    4 * (state 5).val +
    8 * (state 7).val +
    16 * (state 9).val

/-- Value of the outgoing-carry flag wire. -/
def zValue (state : SourceBasis) : Nat :=
  (state 10).val

/-- Takahashi Section 2.2, Step 1: for `i=1,...,4`, CNOT `A_i -> B_i`. -/
def step1 : ReversibleProgram 11 :=
  [ .cx 2 3 (by decide),
    .cx 4 5 (by decide),
    .cx 6 7 (by decide),
    .cx 8 9 (by decide) ]

/-- Takahashi Section 2.2, Step 2: descending CNOT ladder
`A_4 -> A_5=z, ..., A_1 -> A_2`. -/
def step2 : ReversibleProgram 11 :=
  [ .cx 8 10 (by decide),
    .cx 6 8 (by decide),
    .cx 4 6 (by decide),
    .cx 2 4 (by decide) ]

/-- Takahashi Section 2.2, Step 3: ascending Toffoli carry ladder with
controls `(B_i,A_i)` and target `A_{i+1}`, where `A_5=z`. -/
def step3 : ReversibleProgram 11 :=
  [ .ccx 1 0 2 (by decide) (by decide) (by decide),
    .ccx 3 2 4 (by decide) (by decide) (by decide),
    .ccx 5 4 6 (by decide) (by decide) (by decide),
    .ccx 7 6 8 (by decide) (by decide) (by decide),
    .ccx 9 8 10 (by decide) (by decide) (by decide) ]

/-- Takahashi Section 2.2, Step 4: descending sum/carry cleanup.  For each
`i=4,...,1`, first CNOT `A_i -> B_i`, then Toffoli
`(B_{i-1},A_{i-1}) -> A_i`. -/
def step4 : ReversibleProgram 11 :=
  [ .cx 8 9 (by decide),
    .ccx 7 6 8 (by decide) (by decide) (by decide),
    .cx 6 7 (by decide),
    .ccx 5 4 6 (by decide) (by decide) (by decide),
    .cx 4 5 (by decide),
    .ccx 3 2 4 (by decide) (by decide) (by decide),
    .cx 2 3 (by decide),
    .ccx 1 0 2 (by decide) (by decide) (by decide) ]

/-- Takahashi Section 2.2, Step 5: ascending CNOT ladder
`A_1 -> A_2, A_2 -> A_3, A_3 -> A_4`. -/
def step5 : ReversibleProgram 11 :=
  [ .cx 2 4 (by decide),
    .cx 4 6 (by decide),
    .cx 6 8 (by decide) ]

/-- Takahashi Section 2.2, Step 6: for `i=0,...,4`, CNOT `A_i -> B_i`. -/
def step6 : ReversibleProgram 11 :=
  [ .cx 0 1 (by decide),
    .cx 2 3 (by decide),
    .cx 4 5 (by decide),
    .cx 6 7 (by decide),
    .cx 8 9 (by decide) ]

/-- Chronological 5-bit ancilla-free source program. -/
def sourceProgram : ReversibleProgram 11 :=
  step1 ++ step2 ++ step3 ++ step4 ++ step5 ++ step6

/-- The source's exact `7n-6` gate count specializes to 29 gates for `n=5`. -/
theorem sourceProgram_gateCount : sourceProgram.length = 29 := by
  native_decide

/-- The six source steps have exactly the sizes stated by the construction. -/
theorem sourceProgram_stepLengths :
    (step1.length, step2.length, step3.length,
      step4.length, step5.length, step6.length) =
      (4, 4, 5, 8, 3, 5) := by
  native_decide

end VandaeleFigure4TakahashiSourceProgram
end QuantumBlockEncoding

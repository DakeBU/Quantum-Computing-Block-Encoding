import QuantumBlockEncoding.VandaeleFigure4TakahashiStepSemantics
import Mathlib.Tactic

/-!
# Source correspondence for the ladder slices of Vandaele Figure 4

Vandaele, arXiv:2603.12917v1, Figure 4 divides the five-bit Takahashi adder into
red slices `U₁,...,U₈`.  The prose immediately below the figure explicitly
identifies two adjoint pairs:

* slice 2 is a CX ladder `U₂`, and slice 7 is `U₇ = U₂†`;
* slice 3 is a CCX ladder `U₃`, and slice 5 is `U₅ = U₃†`.

Those four slices are source-unambiguous and can be tied directly to the exact
six-step Takahashi program already certified in Lean.  This file closes that
part of the source-correspondence edge without guessing the remaining visual
slices `U₁,U₄,U₆,U₈`.

The node also proves a reusable fact about the repository's reversible proof
IR: because X, CX, and CCX are involutions, evaluating a reversed reversible
program is exactly the inverse equivalence of evaluating the original program.
This turns the paper's dagger statements into semantic equalities rather than
mere list conventions.
-/

namespace QuantumBlockEncoding
namespace VandaeleFigure4LadderSliceCorrespondence

open VandaeleFigure4TakahashiSourceProgram
open VandaeleFigure4TakahashiStepSemantics

/-- Every gate of the reversible-classical proof IR is an involution on basis
states. -/
theorem evalReversibleGate_involutive
    {qubits : Nat} (gate : ReversibleGate qubits) :
    Function.Involutive (fun state => evalReversibleGate gate state) := by
  intro state
  cases gate with
  | x target =>
      change xBasisAction target (xBasisAction target state) = state
      exact xBasisAction_involutive target state
  | cx control target distinct =>
      change
        cxBasisAction control target (cxBasisAction control target state) = state
      exact cxBasisAction_involutive control target distinct state
  | ccx control0 control1 target c0_ne_c1 c0_ne_target c1_ne_target =>
      change
        ccxBasisAction control0 control1 target
            (ccxBasisAction control0 control1 target state) = state
      exact ccxBasisAction_involutive control0 control1 target
        c0_ne_target c1_ne_target state

/-- Executing a reversible program and then the same gate list in reverse
restores the input basis state. -/
theorem evalReversibleProgram_reverse_cancel
    {qubits : Nat} (program : ReversibleProgram qubits)
    (state : PrimitiveBasis qubits) :
    evalReversibleProgram program.reverse
        (evalReversibleProgram program state) = state := by
  induction program generalizing state with
  | nil =>
      rfl
  | cons gate rest induction =>
      rw [List.reverse_cons, evalReversibleProgram_append_apply_local]
      change
        evalReversibleGate gate
            (evalReversibleProgram rest.reverse
              (evalReversibleProgram rest (evalReversibleGate gate state))) =
          state
      rw [induction]
      exact evalReversibleGate_involutive gate state

/-- Program reversal is exactly adjoint/inverse at the reversible-basis
semantics level. -/
theorem evalReversibleProgram_reverse_eq_symm
    {qubits : Nat} (program : ReversibleProgram qubits) :
    evalReversibleProgram program.reverse =
      (evalReversibleProgram program).symm := by
  apply Equiv.ext
  intro state
  apply (evalReversibleProgram program).injective
  calc
    evalReversibleProgram program
        (evalReversibleProgram program.reverse state) = state := by
      simpa using evalReversibleProgram_reverse_cancel program.reverse state
    _ = evalReversibleProgram program
          ((evalReversibleProgram program).symm state) := by
      symm
      exact (evalReversibleProgram program).apply_symm_apply state

/-- Figure-4 slice 2: the three data-targeting CX gates of Takahashi Step 2.
The preceding `A₄ -> z` gate belongs outside this ladder slice. -/
def figure4U2 : ReversibleProgram 11 :=
  step2.drop 1

/-- Figure-4 slice 3: the four data-targeting carry Toffolis of Step 3.
The final Toffoli writing the outgoing carry to `z` lies outside this ladder. -/
def figure4U3 : ReversibleProgram 11 :=
  step3.take 4

/-- Figure-4 slice 5, explicitly identified in the paper as `U₃†`. -/
def figure4U5 : ReversibleProgram 11 :=
  figure4U3.reverse

/-- Figure-4 slice 7, explicitly identified in the paper as `U₂†`. -/
def figure4U7 : ReversibleProgram 11 :=
  figure4U2.reverse

/-- The two CX ladder slices contain three gates each. -/
theorem figure4U2_U7_gateCounts :
    (figure4U2.length, figure4U7.length) = (3, 3) := by
  native_decide

/-- The two CCX ladder slices contain four gates each. -/
theorem figure4U3_U5_gateCounts :
    (figure4U3.length, figure4U5.length) = (4, 4) := by
  native_decide

/-- Exact source split of Takahashi Step 2: the carry-flag CNOT followed by the
Figure-4 `U₂` ladder. -/
theorem step2_eq_flagWrite_then_figure4U2 :
    step2 =
      [ .cx 8 10 (by decide) ] ++ figure4U2 := by
  simp [step2, figure4U2]

/-- Exact source split of Takahashi Step 3: the Figure-4 `U₃` ladder followed
by the outgoing-carry Toffoli. -/
theorem step3_eq_figure4U3_then_flagWrite :
    step3 =
      figure4U3 ++
        [ .ccx 9 8 10 (by decide) (by decide) (by decide) ] := by
  simp [step3, figure4U3]

/-- The semantics of slice 5 is exactly the inverse of slice 3. -/
theorem figure4U5_eq_U3_symm :
    evalReversibleProgram figure4U5 =
      (evalReversibleProgram figure4U3).symm := by
  exact evalReversibleProgram_reverse_eq_symm figure4U3

/-- The semantics of slice 7 is exactly the inverse of slice 2. -/
theorem figure4U7_eq_U2_symm :
    evalReversibleProgram figure4U7 =
      (evalReversibleProgram figure4U2).symm := by
  exact evalReversibleProgram_reverse_eq_symm figure4U2

/-- Operational two-sided cancellation for the inner CCX-ladder pair. -/
theorem figure4U3_then_U5_identity (state : SourceBasis) :
    evalReversibleProgram figure4U5
        (evalReversibleProgram figure4U3 state) = state := by
  exact evalReversibleProgram_reverse_cancel figure4U3 state

/-- Operational two-sided cancellation for the outer CX-ladder pair. -/
theorem figure4U2_then_U7_identity (state : SourceBasis) :
    evalReversibleProgram figure4U7
        (evalReversibleProgram figure4U2 state) = state := by
  exact evalReversibleProgram_reverse_cancel figure4U2 state

end VandaeleFigure4LadderSliceCorrespondence
end QuantumBlockEncoding

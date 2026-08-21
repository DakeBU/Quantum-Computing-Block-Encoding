import QuantumBlockEncoding.ReversibleClassical
import Mathlib.Tactic

/-!
# Constant-order Toffoli macros used by Nie--Zi--Sun Figure 3

Nie--Zi--Sun work over B2, while Vandaele later cites their construction inside
the classical reversible gate set `{X,CX,CCX}`.  The Figure-3 recursion itself
uses only X gates and constant-order multi-controlled X gates.  This module
closes the first gate-model bridge with actual reversible programs.

* C^3X uses one dirty wire and four CCX gates via compute/use/uncompute/use.
* C^4X uses one external dirty wire.  After computing the first two controls
  into that dirty wire, each C^3X use borrows the first source control as its
  own dirty workspace; that control is restored before the outer uncompute.
  The resulting program has ten CCX gates.

Both claims are finite exact truth-table theorems, not resource annotations.
-/

namespace QuantumBlockEncoding
namespace NieZiSunConstantToffoliMacros

/-- Fixed five-wire layout for C^3X: controls 0,1,2; target 3; dirty 4. -/
def c3Program : ReversibleProgram 5 :=
  [ .ccx 0 1 4 (by decide) (by decide) (by decide),
    .ccx 4 2 3 (by decide) (by decide) (by decide),
    .ccx 0 1 4 (by decide) (by decide) (by decide),
    .ccx 4 2 3 (by decide) (by decide) (by decide) ]

/-- Canonical C^3X target on the same five-wire layout, with dirty wire fixed. -/
def c3Action (state : PrimitiveBasis 5) : PrimitiveBasis 5 :=
  if active : state 0 = 1 ∧ state 1 = 1 ∧ state 2 = 1 then
    xBasisAction 3 state
  else state

/-- Exact four-CCX dirty-workspace implementation of C^3X. -/
theorem c3Program_correct :
    ∀ state : PrimitiveBasis 5,
      evalReversibleProgram c3Program state = c3Action state := by
  native_decide

/-- The dirty wire is restored exactly. -/
theorem c3Program_restores_dirty
    (state : PrimitiveBasis 5) :
    evalReversibleProgram c3Program state 4 = state 4 := by
  rw [c3Program_correct]
  by_cases active : state 0 = 1 ∧ state 1 = 1 ∧ state 2 = 1 <;>
    simp [c3Action, active, xBasisAction]

@[simp] theorem c3Program_length : c3Program.length = 4 := by rfl

/-- Fixed six-wire layout for C^4X: controls 0,1,2,3; target 4; dirty 5. -/
def c4Program : ReversibleProgram 6 :=
  [ .ccx 0 1 5 (by decide) (by decide) (by decide),
    -- First C^3X(d,c,e;t), borrowing control 0 as a temporary dirty bit.
    .ccx 5 2 0 (by decide) (by decide) (by decide),
    .ccx 0 3 4 (by decide) (by decide) (by decide),
    .ccx 5 2 0 (by decide) (by decide) (by decide),
    .ccx 0 3 4 (by decide) (by decide) (by decide),
    -- Restore the external dirty bit.
    .ccx 0 1 5 (by decide) (by decide) (by decide),
    -- Cancel the branch depending on its incoming dirty value.
    .ccx 5 2 0 (by decide) (by decide) (by decide),
    .ccx 0 3 4 (by decide) (by decide) (by decide),
    .ccx 5 2 0 (by decide) (by decide) (by decide),
    .ccx 0 3 4 (by decide) (by decide) (by decide) ]

/-- Canonical C^4X action with all five non-target wires preserved. -/
def c4Action (state : PrimitiveBasis 6) : PrimitiveBasis 6 :=
  if active :
      state 0 = 1 ∧ state 1 = 1 ∧ state 2 = 1 ∧ state 3 = 1 then
    xBasisAction 4 state
  else state

/-- Exact ten-CCX implementation of C^4X with one restored dirty wire. -/
theorem c4Program_correct :
    ∀ state : PrimitiveBasis 6,
      evalReversibleProgram c4Program state = c4Action state := by
  native_decide

/-- The external dirty wire is restored. -/
theorem c4Program_restores_dirty
    (state : PrimitiveBasis 6) :
    evalReversibleProgram c4Program state 5 = state 5 := by
  rw [c4Program_correct]
  by_cases active :
      state 0 = 1 ∧ state 1 = 1 ∧ state 2 = 1 ∧ state 3 = 1 <;>
    simp [c4Action, active, xBasisAction]

/-- The source control borrowed internally as dirty workspace is also restored. -/
theorem c4Program_restores_borrowed_control
    (state : PrimitiveBasis 6) :
    evalReversibleProgram c4Program state 0 = state 0 := by
  rw [c4Program_correct]
  by_cases active :
      state 0 = 1 ∧ state 1 = 1 ∧ state 2 = 1 ∧ state 3 = 1 <;>
    simp [c4Action, active, xBasisAction]

@[simp] theorem c4Program_length : c4Program.length = 10 := by rfl

/-- Reader-facing constant-cost summary for the two Figure-3 macros. -/
theorem constant_macro_bounds :
    c3Program.length ≤ 10 ∧ c4Program.length ≤ 10 := by
  norm_num [c3Program, c4Program]

end NieZiSunConstantToffoliMacros
end QuantumBlockEncoding

import QuantumBlockEncoding.NieZiSunFigure3FirstHalf
import QuantumBlockEncoding.NieZiSunFigure3Protocol
import Mathlib.Tactic

/-!
# Nie--Zi--Sun Corollary 3: source dirty-ancilla protocol

For an involutory target, the paper replaces the clean Figure-3 sequence
`1,2,3,4,5` by

`2,3,4,1,2,3,4,5`.

Let `M = 2,3,4`.  Since Step 4 is the inverse of Step 2 and Step 3 changes only
T, `M` preserves every non-target register.  Its target action has the form

`T <- T xor (q(head,left,right) and A)`

for some routing predicate q independent of A.  Step 1 toggles A by the
predicate p = `headAllOne`.  Applying M on both sides of Step 1 therefore
cancels the incoming dirty value A; the net target toggle is q*p.  On p=true,
the source clean-midpoint theorem identifies q with the AND of the two tail
registers.  Hence q*p is exactly the conjunction of all controls.

This proof intentionally never constrains q on the violated-condition branch
p=false.
-/

namespace QuantumBlockEncoding
namespace NieZiSunDirtyProtocol

open NieZiSunFigure3FirstHalf
open NieZiSunFigure3Protocol

/-- Source middle conjugation `Step2 ; Step3 ; Step4`. -/
def middle
    {leftWidth rightWidth : Nat}
    (left : HalfComputation leftWidth)
    (right : HalfComputation rightWidth)
    (state : Figure3State leftWidth rightWidth) :
    Figure3State leftWidth rightWidth :=
  step4 left right (step3 (step2 left right state))

/-- Routing predicate seen by Step 3 when A=1.  A and T are deliberately set to
fixed values because Step 2 ignores both. -/
def routingPredicate
    {leftWidth rightWidth : Nat}
    (left : HalfComputation leftWidth)
    (right : HalfComputation rightWidth)
    (head : Head4)
    (leftGroup : PrimitiveBasis leftWidth)
    (rightGroup : PrimitiveBasis rightWidth) : Prop :=
  let after2 := step2 left right (head,leftGroup,rightGroup,0,0)
  after2.1 0 = 1 ∧ after2.1 2 = 1

/-- Step 2's head/tail outputs are independent of A and the final target. -/
theorem step2_independent_of_work_target
    {leftWidth rightWidth : Nat}
    (left : HalfComputation leftWidth)
    (right : HalfComputation rightWidth)
    (head : Head4)
    (leftGroup : PrimitiveBasis leftWidth)
    (rightGroup : PrimitiveBasis rightWidth)
    (work target work' target' : Fin 2) :
    let first := step2 left right (head,leftGroup,rightGroup,work,target)
    let second := step2 left right (head,leftGroup,rightGroup,work',target')
    first.1 = second.1 ∧ first.2.1 = second.2.1 ∧
      first.2.2.1 = second.2.2.1 := by
  rfl

/-- Central Step-3 activation after Step 2 is exactly `q and A`. -/
theorem middle_activation_iff
    {leftWidth rightWidth : Nat}
    (left : HalfComputation leftWidth)
    (right : HalfComputation rightWidth)
    (head : Head4)
    (leftGroup : PrimitiveBasis leftWidth)
    (rightGroup : PrimitiveBasis rightWidth)
    (work target : Fin 2) :
    let after2 := step2 left right (head,leftGroup,rightGroup,work,target)
    (after2.1 0 = 1 ∧ after2.1 2 = 1 ∧ after2.2.2.2.1 = 1) ↔
      routingPredicate left right head leftGroup rightGroup ∧ work = 1 := by
  dsimp [routingPredicate]
  have independent := step2_independent_of_work_target
    left right head leftGroup rightGroup work target 0 0
  simp [step2] at independent ⊢
  tauto

/-- The middle conjugation preserves all non-target registers and toggles T
exactly on the `routingPredicate and A` branch. -/
theorem middle_action
    {leftWidth rightWidth : Nat}
    (left : HalfComputation leftWidth)
    (right : HalfComputation rightWidth)
    (head : Head4)
    (leftGroup : PrimitiveBasis leftWidth)
    (rightGroup : PrimitiveBasis rightWidth)
    (work target : Fin 2) :
    middle left right (head,leftGroup,rightGroup,work,target) =
      if routingPredicate left right head leftGroup rightGroup ∧ work = 1 then
        (head,leftGroup,rightGroup,work,flipBit target)
      else (head,leftGroup,rightGroup,work,target) := by
  let input : Figure3State leftWidth rightWidth :=
    (head,leftGroup,rightGroup,work,target)
  let after2 := step2 left right input
  have activation := middle_activation_iff
    left right head leftGroup rightGroup work target
  by_cases fires : routingPredicate left right head leftGroup rightGroup ∧ work = 1
  · have central : after2.1 0 = 1 ∧ after2.1 2 = 1 ∧ after2.2.2.2.1 = 1 :=
      activation.mpr fires
    have restored := step4_undoes_step2 left right input
    simp [middle, step3, after2, central] at restored ⊢
    exact Prod.ext restored.1 (Prod.ext restored.2.1
      (Prod.ext restored.2.2.1 (Prod.ext restored.2.2.2.1 restored.2.2.2.2)))
  · have central : ¬(after2.1 0 = 1 ∧ after2.1 2 = 1 ∧ after2.2.2.1 = 1) := by
      intro active
      exact fires (activation.mp active)
    have undo := step4_step2 left right input
    simp [middle, step3, after2, central, fires]
    exact undo

/-- On the only branch where Step 1 changes A, the routing predicate is exactly
the AND of the two tail groups. -/
theorem routingPredicate_of_headAllOne
    {leftWidth rightWidth : Nat}
    (left : HalfComputation leftWidth)
    (right : HalfComputation rightWidth)
    (head : Head4) (headActive : headAllOne head)
    (leftGroup : PrimitiveBasis leftWidth)
    (rightGroup : PrimitiveBasis rightWidth) :
    routingPredicate left right head leftGroup rightGroup ↔
      allOne leftGroup ∧ allOne rightGroup := by
  have midpoint := step2_clean_midpoint_targets
    left right head headActive leftGroup rightGroup 0
  dsimp [routingPredicate] at midpoint ⊢
  rw [show step1 (head,leftGroup,rightGroup,0,0) =
      (head,leftGroup,rightGroup,1,0) by
        simp [step1, headActive, flipBit]] at midpoint
  have independent := step2_independent_of_work_target
    left right head leftGroup rightGroup 1 0 0 0
  simp [step2] at independent
  by_cases l : allOne leftGroup <;> by_cases r : allOne rightGroup <;>
    simp [l,r] at midpoint ⊢ <;> tauto

/-- Corollary-3 source sequence `M ; Step1 ; M ; Step5`. -/
def dirtyProtocol
    {leftWidth rightWidth : Nat}
    (left : HalfComputation leftWidth)
    (right : HalfComputation rightWidth)
    (state : Figure3State leftWidth rightWidth) :
    Figure3State leftWidth rightWidth :=
  step5 (middle left right (step1 (middle left right state)))

/-- Main dirty-ancilla theorem.  Incoming A is arbitrary and is restored. -/
theorem dirtyProtocol_correct
    {leftWidth rightWidth : Nat}
    (left : HalfComputation leftWidth)
    (right : HalfComputation rightWidth)
    (head : Head4)
    (leftGroup : PrimitiveBasis leftWidth)
    (rightGroup : PrimitiveBasis rightWidth)
    (work target : Fin 2) :
    dirtyProtocol left right (head,leftGroup,rightGroup,work,target) =
      if fullActive head leftGroup rightGroup then
        (head,leftGroup,rightGroup,work,flipBit target)
      else (head,leftGroup,rightGroup,work,target) := by
  let q := routingPredicate left right head leftGroup rightGroup
  by_cases p : headAllOne head
  · have qIff := routingPredicate_of_headAllOne
      left right head p leftGroup rightGroup
    by_cases l : allOne leftGroup <;> by_cases r : allOne rightGroup <;>
      fin_cases work <;> fin_cases target <;>
      simp [dirtyProtocol, middle_action, step1, step5,
        p, q, qIff, l, r, fullActive, flipBit]
  · have notFull : ¬ fullActive head leftGroup rightGroup := by
      intro active
      exact p active.1
    fin_cases work <;> fin_cases target <;>
      simp [dirtyProtocol, middle_action, step1, step5,
        p, notFull, q, flipBit]

end NieZiSunDirtyProtocol
end QuantumBlockEncoding

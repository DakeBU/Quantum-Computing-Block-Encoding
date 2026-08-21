import QuantumBlockEncoding.PrimitiveSemantics
import Mathlib.Tactic

/-!
# Nie--Zi--Sun 2024 Figure 3: conditional-clean recursive protocol

Nie, Zi and Sun prove their logarithmic-depth n-Toffoli construction by splitting
it into five steps.  The essential recursive object is not a complete smaller
Toffoli circuit: Step 2 executes only the *first half* of two recursive
subcircuits, and Step 4 executes the corresponding inverse/second halves.

This module formalizes that source proof pattern without committing to a gate
synthesis model.  A `HalfComputation` may arbitrarily scramble its group and
clean-work bit at the midpoint; on the designated clean branch it only has to
write the AND of the group into its target.  Applying its exact inverse after
the central use restores every temporary change.

The five Figure-3 steps are then:

1. compute the AND of the first four controls into clean ancilla A;
2. X the first four controls and run two recursive forward halves, using I2/I4
   as conditionally clean work bits and I1/I3 as their targets;
3. flip the final target controlled by A,I1,I3;
4. run the two inverse halves and undo the X gates;
5. uncompute A with the same four-control predicate.

The main theorem proves exact restoration and the full multi-control target
action.  Resource/gate-set realization is intentionally a later layer: the
source paper's physical theorem is over B2 = {CNOT + arbitrary single-qubit
unitaries}, not ASPBE's reversible `{X,CX,CCX}` IR.
-/

namespace QuantumBlockEncoding
namespace NieZiSunFigure3Protocol

/-- Boolean conjunction of an arbitrary finite control word. -/
def allOne {n : Nat} (controls : PrimitiveBasis n) : Prop :=
  ∀ wire, controls wire = 1

/-- A recursive first-half computation on one tail group.  Coordinates are
`(group, cleanWork, targetBit)`.  Only its midpoint target on `(work,target)=00`
is constrained; the inverse is supplied automatically by `Equiv`. -/
structure HalfComputation (n : Nat) where
  forward : Equiv.Perm (PrimitiveBasis n × Fin 2 × Fin 2)
  cleanTarget : ∀ group,
    (forward (group, 0, 0)).2.2 =
      if allOne group then 1 else 0

/-- Four distinguished leading controls. -/
abbrev Head4 := Fin 4 → Fin 2

/-- Complete Figure-3 logical state. -/
abbrev Figure3State (leftWidth rightWidth : Nat) :=
  Head4 × PrimitiveBasis leftWidth × PrimitiveBasis rightWidth × Fin 2 × Fin 2

/-- First-four activation predicate. -/
def headAllOne (head : Head4) : Prop := ∀ i, head i = 1

/-- Flip all four distinguished controls. -/
def flipHead (head : Head4) : Head4 := fun i => flipBit (head i)

/-- Four-control toggle of the clean ancilla A. -/
def step1
    {leftWidth rightWidth : Nat}
    (state : Figure3State leftWidth rightWidth) :
    Figure3State leftWidth rightWidth :=
  if active : headAllOne state.1 then
    (state.1, state.2.1, state.2.2.1, flipBit state.2.2.2.1,
      state.2.2.2.2)
  else state

/-- Apply one recursive first half to `(group,work,target)`. -/
def applyHalf {n : Nat}
    (half : HalfComputation n)
    (group : PrimitiveBasis n) (work target : Fin 2) :
    PrimitiveBasis n × Fin 2 × Fin 2 :=
  half.forward (group, work, target)

/-- Apply the exact recursive inverse/second half. -/
def unapplyHalf {n : Nat}
    (half : HalfComputation n)
    (group : PrimitiveBasis n) (work target : Fin 2) :
    PrimitiveBasis n × Fin 2 × Fin 2 :=
  half.forward.symm (group, work, target)

/-- Step 2: X I1..I4 and execute the two recursive forward halves.
I2/I4 are work bits; I1/I3 are the recursive targets. -/
def step2
    {leftWidth rightWidth : Nat}
    (left : HalfComputation leftWidth)
    (right : HalfComputation rightWidth)
    (state : Figure3State leftWidth rightWidth) :
    Figure3State leftWidth rightWidth :=
  let head := flipHead state.1
  let leftMid := applyHalf left state.2.1 (head 1) (head 0)
  let rightMid := applyHalf right state.2.2.1 (head 3) (head 2)
  ((fun i =>
      if h0 : i = 0 then leftMid.2.2
      else if h1 : i = 1 then leftMid.2.1
      else if h2 : i = 2 then rightMid.2.2
      else rightMid.2.1),
    leftMid.1, rightMid.1, state.2.2.2.1, state.2.2.2.2)

/-- Step 3 central constant-size use: A,I1,I3 control the final target. -/
def step3
    {leftWidth rightWidth : Nat}
    (state : Figure3State leftWidth rightWidth) :
    Figure3State leftWidth rightWidth :=
  if active : state.1 0 = 1 ∧ state.1 2 = 1 ∧ state.2.2.2.1 = 1 then
    (state.1, state.2.1, state.2.2.1, state.2.2.2.1,
      flipBit state.2.2.2.2)
  else state

/-- Step 4: exact inverse recursive halves, then undo the four X gates. -/
def step4
    {leftWidth rightWidth : Nat}
    (left : HalfComputation leftWidth)
    (right : HalfComputation rightWidth)
    (state : Figure3State leftWidth rightWidth) :
    Figure3State leftWidth rightWidth :=
  let leftRestored := unapplyHalf left state.2.1 (state.1 1) (state.1 0)
  let rightRestored := unapplyHalf right state.2.2.1 (state.1 3) (state.1 2)
  let midpointHead : Head4 := fun i =>
    if h0 : i = 0 then leftRestored.2.2
    else if h1 : i = 1 then leftRestored.2.1
    else if h2 : i = 2 then rightRestored.2.2
    else rightRestored.2.1
  (flipHead midpointHead,
    leftRestored.1, rightRestored.1,
    state.2.2.2.1, state.2.2.2.2)

/-- Step 5 is the same four-control clean-ancilla toggle as Step 1. -/
def step5 := @step1

/-- Complete Figure-3 protocol. -/
def protocol
    {leftWidth rightWidth : Nat}
    (left : HalfComputation leftWidth)
    (right : HalfComputation rightWidth)
    (state : Figure3State leftWidth rightWidth) :
    Figure3State leftWidth rightWidth :=
  step5 (step4 left right (step3 (step2 left right (step1 state))))

/-- Flipping all-one head gives four zero bits. -/
theorem flipHead_allOne_zero
    (head : Head4) (active : headAllOne head) :
    flipHead head = fun _ => 0 := by
  funext i
  have one := active i
  fin_cases h : head i <;> simp_all [flipHead, flipBit]

/-- Flipping the head twice restores it. -/
theorem flipHead_involutive : Function.Involutive flipHead := by
  intro head
  funext i
  exact flipBit_flipBit (head i)

/-- Step 1 preserves all data registers and the final target. -/
theorem step1_data_preserved
    {leftWidth rightWidth : Nat}
    (state : Figure3State leftWidth rightWidth) :
    (step1 state).1 = state.1 ∧
    (step1 state).2.1 = state.2.1 ∧
    (step1 state).2.2.1 = state.2.2.1 ∧
    (step1 state).2.2.2.2 = state.2.2.2.2 := by
  by_cases active : headAllOne state.1 <;>
    simp [step1, active]

/-- Step 1 records the first-four AND in a clean ancilla. -/
theorem step1_cleanAncilla
    {leftWidth rightWidth : Nat}
    (head : Head4)
    (left : PrimitiveBasis leftWidth)
    (right : PrimitiveBasis rightWidth)
    (target : Fin 2) :
    (step1 (head,left,right,0,target)).2.2.2.1 =
      if headAllOne head then 1 else 0 := by
  by_cases active : headAllOne head
  · simp [step1, active, flipBit]
  · simp [step1, active]

/-- The two recursive forward halves are exactly undone by Step 4 when the
central Step 3 is ignored, since Step 3 changes only the final target. -/
theorem step4_undoes_step2
    {leftWidth rightWidth : Nat}
    (left : HalfComputation leftWidth)
    (right : HalfComputation rightWidth)
    (state : Figure3State leftWidth rightWidth) :
    let after2 := step2 left right state
    let withTarget : Figure3State leftWidth rightWidth :=
      (after2.1, after2.2.1, after2.2.2.1, after2.2.2.2.1,
        flipBit after2.2.2.2.2)
    let restored := step4 left right withTarget
    restored.1 = state.1 ∧
      restored.2.1 = state.2.1 ∧
      restored.2.2.1 = state.2.2.1 ∧
      restored.2.2.2.1 = state.2.2.2.1 ∧
      restored.2.2.2.2 = flipBit state.2.2.2.2 := by
  dsimp
  simp [step2, step4, applyHalf, unapplyHalf,
    flipHead_involutive]

/-- On the branch where the first four controls are all one and A starts clean,
Step 2 presents two genuinely clean recursive work/target pairs. -/
theorem step2_clean_midpoint_targets
    {leftWidth rightWidth : Nat}
    (left : HalfComputation leftWidth)
    (right : HalfComputation rightWidth)
    (head : Head4) (headActive : headAllOne head)
    (leftGroup : PrimitiveBasis leftWidth)
    (rightGroup : PrimitiveBasis rightWidth)
    (target : Fin 2) :
    let after1 := step1 (head,leftGroup,rightGroup,0,target)
    let after2 := step2 left right after1
    after2.1 0 = (if allOne leftGroup then 1 else 0) ∧
      after2.1 2 = (if allOne rightGroup then 1 else 0) ∧
      after2.2.2.2.1 = 1 := by
  have flipped := flipHead_allOne_zero head headActive
  dsimp
  rw [show step1 (head,leftGroup,rightGroup,0,target) =
      (head,leftGroup,rightGroup,1,target) by
        simp [step1, headActive, flipBit]]
  simp [step2, applyHalf, flipped,
    left.cleanTarget, right.cleanTarget]

/-- Conjunction of the full source control register. -/
def fullActive
    {leftWidth rightWidth : Nat}
    (head : Head4)
    (left : PrimitiveBasis leftWidth)
    (right : PrimitiveBasis rightWidth) : Prop :=
  headAllOne head ∧ allOne left ∧ allOne right

/-- Main Figure-3 semantic theorem.  Starting from a clean ancilla, the protocol
restores every control and A, and toggles T iff all source controls are one. -/
theorem protocol_correct
    {leftWidth rightWidth : Nat}
    (left : HalfComputation leftWidth)
    (right : HalfComputation rightWidth)
    (head : Head4)
    (leftGroup : PrimitiveBasis leftWidth)
    (rightGroup : PrimitiveBasis rightWidth)
    (target : Fin 2) :
    let output := protocol left right (head,leftGroup,rightGroup,0,target)
    output.1 = head ∧
      output.2.1 = leftGroup ∧
      output.2.2.1 = rightGroup ∧
      output.2.2.2.1 = 0 ∧
      output.2.2.2.2 =
        (if fullActive head leftGroup rightGroup then
          flipBit target else target) := by
  by_cases headActive : headAllOne head
  · have midpoint := step2_clean_midpoint_targets
      left right head headActive leftGroup rightGroup target
    by_cases leftActive : allOne leftGroup
    · by_cases rightActive : allOne rightGroup
      · -- Central use fires; all temporary recursive data are then uncomputed.
        have central : fullActive head leftGroup rightGroup :=
          ⟨headActive,leftActive,rightActive⟩
        simp [protocol, step3, midpoint, leftActive, rightActive,
          central, step1, step5, headActive, step2, step4,
          applyHalf, unapplyHalf, flipHead_allOne_zero head headActive]
      · have central : ¬ fullActive head leftGroup rightGroup := by
          intro active
          exact rightActive active.2.2
        simp [protocol, step3, midpoint, leftActive, rightActive,
          central, step1, step5, headActive, step2, step4,
          applyHalf, unapplyHalf, flipHead_allOne_zero head headActive]
    · have central : ¬ fullActive head leftGroup rightGroup := by
        intro active
        exact leftActive active.2.1
      simp [protocol, step3, midpoint, leftActive, central,
        step1, step5, headActive, step2, step4,
        applyHalf, unapplyHalf, flipHead_allOne_zero head headActive]
  · have central : ¬ fullActive head leftGroup rightGroup := by
      intro active
      exact headActive active.1
    -- A stays zero, so Step 3 cannot fire. Step 4 is the exact inverse of Step 2.
    simp [protocol, step1, step5, headActive, step3, central,
      step2, step4, applyHalf, unapplyHalf,
      flipHead_involutive]

end NieZiSunFigure3Protocol
end QuantumBlockEncoding

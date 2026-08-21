import QuantumBlockEncoding.NieZiSunFigure3Protocol
import Mathlib.Tactic

/-!
# Nie--Zi--Sun Figure 3: the recursive first half as an actual permutation

The source proof recursively invokes only the first half of a smaller Figure-3
construction.  To make that statement formal, the first half itself must be a
reversible object, not a prose phrase.

For fixed recursive `HalfComputation`s on the two tail groups we prove:

* Step 1 is involutory;
* Step 3 is involutory;
* Step 2 and Step 4 are exact inverses;
* therefore `Step1 ; Step2 ; Step3` is a permutation;
* starting from clean work A=0 and target T=0, its target bit is exactly the AND
  of all source controls.

This permutation can therefore be fed recursively into the parent Figure-3
construction.
-/

namespace QuantumBlockEncoding
namespace NieZiSunFigure3FirstHalf

open NieZiSunFigure3Protocol

/-- Step 1 is self-inverse because its predicate depends only on the unchanged
head controls. -/
theorem step1_involutive
    {leftWidth rightWidth : Nat} :
    Function.Involutive (@step1 leftWidth rightWidth) := by
  intro state
  by_cases active : headAllOne state.1
  · simp [step1, active, flipBit_flipBit]
  · simp [step1, active]

/-- Step 3 is self-inverse because it changes only T, while A,I1,I3 are
preserved. -/
theorem step3_involutive
    {leftWidth rightWidth : Nat} :
    Function.Involutive (@step3 leftWidth rightWidth) := by
  intro state
  by_cases active : state.1 0 = 1 ∧ state.1 2 = 1 ∧ state.2.2.2.1 = 1
  · simp [step3, active, flipBit_flipBit]
  · simp [step3, active]

/-- Step 4 exactly undoes Step 2. -/
theorem step4_step2
    {leftWidth rightWidth : Nat}
    (left : HalfComputation leftWidth)
    (right : HalfComputation rightWidth) :
    Function.LeftInverse (step4 left right) (step2 left right) := by
  intro state
  rcases state with ⟨head,leftGroup,rightGroup,work,target⟩
  simp [step2, step4, applyHalf, unapplyHalf,
    flipHead, flipBit_flipBit]
  funext i
  fin_cases i <;> rfl

/-- Conversely Step 2 undoes Step 4. -/
theorem step2_step4
    {leftWidth rightWidth : Nat}
    (left : HalfComputation leftWidth)
    (right : HalfComputation rightWidth) :
    Function.RightInverse (step4 left right) (step2 left right) := by
  intro state
  rcases state with ⟨head,leftGroup,rightGroup,work,target⟩
  simp [step2, step4, applyHalf, unapplyHalf,
    flipHead, flipBit_flipBit]
  funext i
  fin_cases i <;> rfl

/-- Step-1 permutation. -/
def step1Equiv
    {leftWidth rightWidth : Nat} :
    Equiv.Perm (Figure3State leftWidth rightWidth) where
  toFun := step1
  invFun := step1
  left_inv := step1_involutive
  right_inv := step1_involutive

/-- Step-2 permutation, whose inverse is source Step 4. -/
def step2Equiv
    {leftWidth rightWidth : Nat}
    (left : HalfComputation leftWidth)
    (right : HalfComputation rightWidth) :
    Equiv.Perm (Figure3State leftWidth rightWidth) where
  toFun := step2 left right
  invFun := step4 left right
  left_inv := step4_step2 left right
  right_inv := step2_step4 left right

/-- Central Step-3 permutation. -/
def step3Equiv
    {leftWidth rightWidth : Nat} :
    Equiv.Perm (Figure3State leftWidth rightWidth) where
  toFun := step3
  invFun := step3
  left_inv := step3_involutive
  right_inv := step3_involutive

/-- Actual source first half `Step1 ; Step2 ; Step3`. -/
def firstHalfEquiv
    {leftWidth rightWidth : Nat}
    (left : HalfComputation leftWidth)
    (right : HalfComputation rightWidth) :
    Equiv.Perm (Figure3State leftWidth rightWidth) :=
  (step1Equiv.trans (step2Equiv left right)).trans step3Equiv

/-- The clean midpoint target of the first half is the full AND. -/
theorem firstHalf_cleanTarget
    {leftWidth rightWidth : Nat}
    (left : HalfComputation leftWidth)
    (right : HalfComputation rightWidth)
    (head : Head4)
    (leftGroup : PrimitiveBasis leftWidth)
    (rightGroup : PrimitiveBasis rightWidth) :
    (firstHalfEquiv left right
      (head,leftGroup,rightGroup,0,0)).2.2.2.2 =
      if fullActive head leftGroup rightGroup then 1 else 0 := by
  by_cases headActive : headAllOne head
  · have midpoint := step2_clean_midpoint_targets
      left right head headActive leftGroup rightGroup 0
    by_cases leftActive : allOne leftGroup
    · by_cases rightActive : allOne rightGroup
      · have full : fullActive head leftGroup rightGroup :=
          ⟨headActive,leftActive,rightActive⟩
        simp [firstHalfEquiv, step1Equiv, step2Equiv, step3Equiv,
          midpoint, full, leftActive, rightActive, step3, flipBit]
      · have notFull : ¬ fullActive head leftGroup rightGroup := by
          intro full
          exact rightActive full.2.2
        simp [firstHalfEquiv, step1Equiv, step2Equiv, step3Equiv,
          midpoint, notFull, leftActive, rightActive, step3]
    · have notFull : ¬ fullActive head leftGroup rightGroup := by
        intro full
        exact leftActive full.2.1
      simp [firstHalfEquiv, step1Equiv, step2Equiv, step3Equiv,
        midpoint, notFull, leftActive, step3]
  · have notFull : ¬ fullActive head leftGroup rightGroup := by
      intro full
      exact headActive full.1
    have ancillaZero := step1_cleanAncilla
      head leftGroup rightGroup (0 : Fin 2)
    simp [firstHalfEquiv, step1Equiv, step2Equiv, step3Equiv,
      step3, notFull, headActive, ancillaZero]

/-- Reader-facing recursive-half object extracted from one Figure-3 level. -/
def asHalfComputation
    {leftWidth rightWidth : Nat}
    (left : HalfComputation leftWidth)
    (right : HalfComputation rightWidth)
    (pack :
      (PrimitiveBasis leftWidth × PrimitiveBasis rightWidth × Head4) ≃
        PrimitiveBasis (leftWidth + rightWidth + 4))
    (unpack :
      PrimitiveBasis (leftWidth + rightWidth + 4) ≃
        Head4 × PrimitiveBasis leftWidth × PrimitiveBasis rightWidth)
    (coordinateRoundtrip : ∀ head leftGroup rightGroup,
      unpack (pack (leftGroup,rightGroup,head)) =
        (head,leftGroup,rightGroup)) :
    HalfComputation (leftWidth + rightWidth + 4) where
  forward :=
    let registerEquiv :
        (PrimitiveBasis (leftWidth + rightWidth + 4) × Fin 2 × Fin 2) ≃
          Figure3State leftWidth rightWidth :=
      { toFun := fun state =>
          let decoded := unpack state.1
          (decoded.1,decoded.2.1,decoded.2.2,state.2.1,state.2.2)
        invFun := fun state =>
          (pack (state.2.1,state.2.2.1,state.1),state.2.2.2.1,state.2.2.2.2)
        left_inv := by
          intro state
          rcases state with ⟨controls,work,target⟩
          simp
        right_inv := by
          intro state
          rcases state with ⟨head,leftGroup,rightGroup,work,target⟩
          simp [coordinateRoundtrip] }
    (registerEquiv.trans (firstHalfEquiv left right)).trans registerEquiv.symm
  cleanTarget := by
    intro controls
    let decoded := unpack controls
    have source := firstHalf_cleanTarget left right
      decoded.1 decoded.2.1 decoded.2.2
    simpa using source

end NieZiSunFigure3FirstHalf
end QuantumBlockEncoding

import QuantumBlockEncoding.VandaeleLemma1NiePublicLogic
import QuantumBlockEncoding.VandaeleLemma1NieParallelChildSemantics
import QuantumBlockEncoding.VandaeleLemma1NieControlPartition
import QuantumBlockEncoding.VandaeleLemma1CleanPromise
import Mathlib.Tactic

/-!
# Recursive forward-AND correctness for Nie Figure 3

This is the semantic induction step consumed by the clean-ancilla recursion.
Given two child `CleanSplitCertificate`s, the Figure-3 parent `forwardHalf`
computes the AND of all parent controls on a zero target, under a clean outer
workspace promise.

The proof deliberately uses only already-certified interfaces:

* Step-1 + normalization seed promises;
* logical views of the parallel child schedule;
* each child's `forwardAnd` certificate;
* the public Step-3 activation predicate; and
* the exact parent control partition.

No fixed CCX gadget or parallel layer is unfolded here.
-/

namespace QuantumBlockEncoding
namespace VandaeleLemma1NieRecursiveForwardCorrectness

open VandaeleLemma1ProgramFamily
open VandaeleLemma1CleanPromise
open VandaeleLemma1NieLayout
open VandaeleLemma1NieRecursiveStep
open VandaeleLemma1NieFixedSemantics
open VandaeleLemma1NieSeedSemantics
open VandaeleLemma1NieParallelChildSemantics
open VandaeleLemma1NieControlPartition
open VandaeleLemma1NiePublicLogic
open ReversibleWireEmbedding

/-- Exact state exposed to the central Step-3 gadget by the parent's
`forwardHalf`. -/
private theorem eval_recursive_forwardHalf_eq_stepThree
    {k : Nat} (five_le : 5 ≤ k)
    (left : ReversibleComputeActionUncompute
      (lemmaOneFlatWidth (leftSize k)))
    (right : ReversibleComputeActionUncompute
      (lemmaOneFlatWidth (rightSize k)))
    (state : PrimitiveBasis (lemmaOneFlatWidth k)) :
    evalReversibleProgram
        (recursiveSplit five_le left right).forwardHalf.program state =
      evalReversibleProgram
        (stepThreeScheduled k (by omega : 4 ≤ k)).program
        (evalReversibleProgram (parallelForward five_le left right).program
          (seedState k (by omega : 4 ≤ k) state)) := by
  simp [recursiveSplit, ReversibleComputeActionUncompute.forwardHalf,
    prepare, stepTwo, commit, seedState, evalReversibleProgram_append]

/-- The generic Figure-3 recursive node preserves the stronger intermediate
invariant required by its own parent: on zero child target / clean outer flag,
its exposed first half stores the AND of every parent control on the target. -/
theorem recursive_forwardAnd
    {k : Nat} (five_le : 5 ≤ k)
    (left : CleanSplitCertificate (leftSize k))
    (right : CleanSplitCertificate (rightSize k)) :
    ForwardComputesAnd k
      (recursiveSplit five_le left.split right.split) := by
  classical
  intro state targetZero dirtyZero
  let four_le : 4 ≤ k := by omega
  let seed : PrimitiveBasis (lemmaOneFlatWidth k) :=
    seedState k four_le state
  let children : PrimitiveBasis (lemmaOneFlatWidth k) :=
    evalReversibleProgram
      (parallelForward five_le left.split right.split).program seed

  have forwardState :
      evalReversibleProgram
          (recursiveSplit five_le left.split right.split).forwardHalf.program state =
        evalReversibleProgram (stepThreeScheduled k four_le).program children := by
    simpa [four_le, seed, children] using
      (eval_recursive_forwardHalf_eq_stepThree
        five_le left.split right.split state)

  have childrenTargetZero : children (targetWire k) = 0 := by
    change
      evalReversibleProgram
          (parallelForward five_le left.split right.split).program seed
          (targetWire k) = 0
    rw [parallelForward_preserves_target five_le left.split right.split seed]
    simpa [seed] using seed_preserves_target k four_le state

  by_cases reservedActive : ReservedAllOne k four_le state
  · have leftClean :=
      leftSeed_target_dirty_zero k four_le state reservedActive
    have rightClean :=
      rightSeed_target_dirty_zero k four_le state reservedActive

    have leftForwardTarget :=
      left.forwardAnd
        (readEmbeddedState (leftChildEmbed k four_le) seed)
        (by simpa [seed] using leftClean.1)
        (by simpa [seed] using leftClean.2)
    have rightForwardTarget :=
      right.forwardAnd
        (readEmbeddedState (rightChildEmbed k four_le) seed)
        (by simpa [seed] using rightClean.1)
        (by simpa [seed] using rightClean.2)

    have leftView :=
      leftView_eval_parallelForward five_le left.split right.split seed
    have rightView :=
      rightView_eval_parallelForward five_le left.split right.split seed

    have leftBit :
        children (i1Wire k four_le) =
          if LeftBlockAllOne k four_le state then 1 else 0 := by
      calc
        children (i1Wire k four_le) =
            readEmbeddedState (leftChildEmbed k four_le) children
              (targetWire (leftSize k)) := by
          simp [readEmbeddedState]
        _ = evalReversibleProgram left.split.forwardHalf.program
              (readEmbeddedState (leftChildEmbed k four_le) seed)
              (targetWire (leftSize k)) := by
          exact congrFun leftView (targetWire (leftSize k))
        _ = if allFlatControlsOne (leftSize k)
                (readEmbeddedState (leftChildEmbed k four_le) seed)
              then 1 else 0 := leftForwardTarget
        _ = if LeftBlockAllOne k four_le state then 1 else 0 := by
          by_cases active : LeftBlockAllOne k four_le state
          · have childActive :
                allFlatControlsOne (leftSize k)
                  (readEmbeddedState (leftChildEmbed k four_le) seed) := by
              exact (leftSeed_allControls_iff k four_le state).2 active
            simp [active, childActive]
          · have childInactive :
                ¬ allFlatControlsOne (leftSize k)
                  (readEmbeddedState (leftChildEmbed k four_le) seed) := by
              intro childActive
              exact active ((leftSeed_allControls_iff k four_le state).1 childActive)
            simp [active, childInactive]

    have rightBit :
        children (i3Wire k four_le) =
          if RightBlockAllOne k four_le state then 1 else 0 := by
      calc
        children (i3Wire k four_le) =
            readEmbeddedState (rightChildEmbed k four_le) children
              (targetWire (rightSize k)) := by
          simp [readEmbeddedState]
        _ = evalReversibleProgram right.split.forwardHalf.program
              (readEmbeddedState (rightChildEmbed k four_le) seed)
              (targetWire (rightSize k)) := by
          exact congrFun rightView (targetWire (rightSize k))
        _ = if allFlatControlsOne (rightSize k)
                (readEmbeddedState (rightChildEmbed k four_le) seed)
              then 1 else 0 := rightForwardTarget
        _ = if RightBlockAllOne k four_le state then 1 else 0 := by
          by_cases active : RightBlockAllOne k four_le state
          · have childActive :
                allFlatControlsOne (rightSize k)
                  (readEmbeddedState (rightChildEmbed k four_le) seed) := by
              exact (rightSeed_allControls_iff k four_le state).2 active
            simp [active, childActive]
          · have childInactive :
                ¬ allFlatControlsOne (rightSize k)
                  (readEmbeddedState (rightChildEmbed k four_le) seed) := by
              intro childActive
              exact active ((rightSeed_allControls_iff k four_le state).1 childActive)
            simp [active, childInactive]

    have childrenDirtyOne : children (dirtyWire k) = 1 := by
      change
        evalReversibleProgram
            (parallelForward five_le left.split right.split).program seed
            (dirtyWire k) = 1
      rw [parallelForward_preserves_dirty five_le left.split right.split seed]
      simpa [seed] using
        seed_dirty_one k four_le state dirtyZero reservedActive

    have stepActiveIff :
        StepThreeActive k four_le children ↔
          LeftBlockAllOne k four_le state ∧
          RightBlockAllOne k four_le state := by
      rw [stepThreeActive_iff_public]
      constructor
      · rintro ⟨i1One, i3One, _aOne⟩
        constructor
        · by_contra inactive
          simp [inactive] at leftBit
          omega
        · by_contra inactive
          simp [inactive] at rightBit
          omega
      · rintro ⟨leftActive, rightActive⟩
        refine ⟨?_, ?_, childrenDirtyOne⟩
        · simpa [leftActive] using leftBit
        · simpa [rightActive] using rightBit

    have parentActiveIff :
        allFlatControlsOne k state ↔
          LeftBlockAllOne k four_le state ∧
          RightBlockAllOne k four_le state := by
      rw [allFlatControlsOne_iff_parts k four_le state]
      simp [reservedActive]

    have stepParentIff :
        StepThreeActive k four_le children ↔ allFlatControlsOne k state :=
      stepActiveIff.trans parentActiveIff.symm

    have stepTarget := stepThree_target_action k four_le children
    rw [forwardState]
    by_cases parentActive : allFlatControlsOne k state
    · have stepActive : StepThreeActive k four_le children :=
        stepParentIff.2 parentActive
      simpa [parentActive, stepActive, childrenTargetZero, flipBit] using stepTarget
    · have stepInactive : ¬ StepThreeActive k four_le children := by
        intro stepActive
        exact parentActive (stepParentIff.1 stepActive)
      simpa [parentActive, stepInactive, childrenTargetZero] using stepTarget

  · have seedDirtyZero : seed (dirtyWire k) = 0 := by
      change seedState k four_le state (dirtyWire k) = 0
      rw [seedState, normalize_preserves_dirty, stepOne_dirty_action]
      simp [reservedActive, dirtyZero]

    have childrenDirtyZero : children (dirtyWire k) = 0 := by
      change
        evalReversibleProgram
            (parallelForward five_le left.split right.split).program seed
            (dirtyWire k) = 0
      rw [parallelForward_preserves_dirty five_le left.split right.split seed]
      exact seedDirtyZero

    have stepInactive : ¬ StepThreeActive k four_le children := by
      intro active
      have activePublic :=
        (stepThreeActive_iff_public k four_le children).1 active
      have aOne := activePublic.2.2
      rw [childrenDirtyZero] at aOne
      exact zero_ne_one aOne

    have parentInactive : ¬ allFlatControlsOne k state := by
      intro active
      have parts :=
        (allFlatControlsOne_iff_parts k four_le state).1 active
      exact reservedActive parts.1

    have stepTarget := stepThree_target_action k four_le children
    rw [forwardState]
    simpa [parentInactive, stepInactive, childrenTargetZero] using stepTarget

end VandaeleLemma1NieRecursiveForwardCorrectness
end QuantumBlockEncoding
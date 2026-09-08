import QuantumBlockEncoding.VandaeleLemma1NieControlPartition
import QuantumBlockEncoding.ReversibleEmbeddingNoninterference
import Mathlib.Tactic

/-!
# Figure-3 seed semantics: Step 1 plus reserved-control normalization

The recursive calls in Nie Figure 3 are not given globally clean workspace.
Their target/dirty pairs become clean only on the branch where Step 1 certifies
that the four reserved controls were all one.  This module proves that promise
from the executable schedules.

Let `seedState` be the state after Step 1 and the four normalization X gates.
Then:

* every non-reserved parent control is unchanged;
* every reserved control is flipped exactly once;
* the outer target `T` is unchanged;
* if the Step-1 flag is active and the incoming `A` is zero, then `A = 1` and
  the four reserved controls are all zero;
* consequently both recursive child views have target = dirty = 0, while their
  logical control predicates are exactly the original left/right block
  predicates.
-/

namespace QuantumBlockEncoding
namespace VandaeleLemma1NieSeedSemantics

open VandaeleLemma1ProgramFamily
open VandaeleLemma1PrimitiveBaseCases
open VandaeleLemma1NieLayout
open VandaeleLemma1NieFixedSemantics
open VandaeleLemma1NieControlPartition
open ReversibleWireEmbedding
open ScheduledWireEmbedding

private def s0 : Fin 4 := ⟨0, by omega⟩
private def s1 : Fin 4 := ⟨1, by omega⟩
private def s2 : Fin 4 := ⟨2, by omega⟩
private def s3 : Fin 4 := ⟨3, by omega⟩

/-- Public presentation of the four normalization gates.  It is definitionally
the source schedule from `NieLayout`, but mentions no private `r0,...,r3` names. -/
def publicNormalizeProgram (k : Nat) (four_le : 4 ≤ k) :
    ReversibleProgram (lemmaOneFlatWidth k) :=
  [ .x (reservedWire k four_le s0),
    .x (reservedWire k four_le s1),
    .x (reservedWire k four_le s2),
    .x (reservedWire k four_le s3) ]

/-- The layout's executable normalization list is exactly the public four-wire
presentation above. -/
theorem normalizeProgram_eq_public (k : Nat) (four_le : 4 ≤ k) :
    normalizeProgram k four_le = publicNormalizeProgram k four_le := by
  rfl

/-- Step 1 preserves every one of its four source controls. -/
theorem stepOne_preserves_reserved
    (k : Nat) (four_le : 4 ≤ k)
    (state : PrimitiveBasis (lemmaOneFlatWidth k))
    (index : Fin 4) :
    evalReversibleProgram (stepOneScheduled k four_le).program state
        (reservedWire k four_le index) =
      state (reservedWire k four_le index) := by
  let childState : PrimitiveBasis (lemmaOneFlatWidth 4) :=
    readEmbeddedState (stepOneEmbed k four_le) state
  have transport :=
    readEmbeddedState_eval_mapScheduledWires
      (stepOneEmbed k four_le) (stepOneEmbed_injective k four_le)
      VandaeleLemma1BorrowedNCTGadgets.k4Scheduled state
  have atControl := congrFun transport (controlWire 4 index)
  have controlSpec :=
    (VandaeleLemma1BorrowedNCTGadgets.k4_correct childState).1 index
  calc
    evalReversibleProgram (stepOneScheduled k four_le).program state
        (reservedWire k four_le index) =
        evalReversibleProgram
          VandaeleLemma1BorrowedNCTGadgets.k4Scheduled.program childState
          (controlWire 4 index) := by
      simpa [stepOneScheduled, childState, readEmbeddedState] using atControl
    _ = childState (controlWire 4 index) := controlSpec
    _ = state (reservedWire k four_le index) := by
      simp [childState, readEmbeddedState]

/-- Every non-reserved parent control lies outside the fixed Step-1 embedding. -/
theorem stepOneEmbed_outside_nonreserved_control
    (k : Nat) (four_le : 4 ≤ k)
    (wire : Fin k) (nonreserved : 4 ≤ wire.val) :
    ∀ logical, stepOneEmbed k four_le logical ≠ controlWire k wire := by
  intro logical equal
  have values := congrArg Fin.val equal
  by_cases control : logical.val < 4
  · simp [stepOneEmbed, control, controlWire] at values
    omega
  · by_cases target : logical.val = 4
    · simp [stepOneEmbed, control, target, dirtyWire, controlWire] at values
      have upper := wire.isLt
      omega
    · simp [stepOneEmbed, control, target, targetWire, controlWire] at values
      have upper := wire.isLt
      omega

/-- Step 1 preserves every parent control, including the unreserved recursive
blocks which are outside its embedded k=4 gadget. -/
theorem stepOne_preserves_control
    (k : Nat) (four_le : 4 ≤ k)
    (state : PrimitiveBasis (lemmaOneFlatWidth k))
    (wire : Fin k) :
    evalReversibleProgram (stepOneScheduled k four_le).program state
        (controlWire k wire) = state (controlWire k wire) := by
  by_cases reserved : wire.val < 4
  · let index : Fin 4 := ⟨wire.val, reserved⟩
    have same : controlWire k wire = reservedWire k four_le index := by
      apply Fin.ext
      rfl
    rw [same]
    exact stepOne_preserves_reserved k four_le state index
  · have four_le_wire : 4 ≤ wire.val := by omega
    rw [stepOneScheduled, mapScheduledWires_program]
    exact eval_mapProgramWires_outside
      (stepOneEmbed k four_le) (stepOneEmbed_injective k four_le)
      VandaeleLemma1BorrowedNCTGadgets.k4Scheduled.program
      state (controlWire k wire)
      (stepOneEmbed_outside_nonreserved_control
        k four_le wire four_le_wire)

/-- The four reserved physical wires are pairwise distinct. -/
theorem reservedWire_injective (k : Nat) (four_le : 4 ≤ k) :
    Function.Injective (reservedWire k four_le) := by
  intro left right equal
  apply Fin.ext
  have values := congrArg Fin.val equal
  simpa [reservedWire, reservedControl, controlWire] using values

/-- Exact action of normalization on one selected reserved wire. -/
theorem normalize_reserved_action
    (k : Nat) (four_le : 4 ≤ k)
    (state : PrimitiveBasis (lemmaOneFlatWidth k))
    (index : Fin 4) :
    evalReversibleProgram (normalizeScheduled k four_le).program state
        (reservedWire k four_le index) =
      flipBit (state (reservedWire k four_le index)) := by
  rw [ScheduledReversibleProgram.sequential_program, normalizeProgram_eq_public]
  fin_cases index <;>
    simp [publicNormalizeProgram, evalReversibleProgram, evalReversibleGate,
      xBasisEquiv, xBasisAction, reservedWire, reservedControl, controlWire,
      s0, s1, s2, s3]

/-- Normalization leaves every parent control at index >=4 untouched. -/
theorem normalize_preserves_nonreserved_control
    (k : Nat) (four_le : 4 ≤ k)
    (state : PrimitiveBasis (lemmaOneFlatWidth k))
    (wire : Fin k) (nonreserved : 4 ≤ wire.val) :
    evalReversibleProgram (normalizeScheduled k four_le).program state
        (controlWire k wire) = state (controlWire k wire) := by
  rw [ScheduledReversibleProgram.sequential_program, normalizeProgram_eq_public]
  have ne0 : controlWire k wire ≠ reservedWire k four_le s0 := by
    intro equal
    have values := congrArg Fin.val equal
    simp [reservedWire, reservedControl, controlWire, s0] at values
    omega
  have ne1 : controlWire k wire ≠ reservedWire k four_le s1 := by
    intro equal
    have values := congrArg Fin.val equal
    simp [reservedWire, reservedControl, controlWire, s1] at values
    omega
  have ne2 : controlWire k wire ≠ reservedWire k four_le s2 := by
    intro equal
    have values := congrArg Fin.val equal
    simp [reservedWire, reservedControl, controlWire, s2] at values
    omega
  have ne3 : controlWire k wire ≠ reservedWire k four_le s3 := by
    intro equal
    have values := congrArg Fin.val equal
    simp [reservedWire, reservedControl, controlWire, s3] at values
    omega
  simp [publicNormalizeProgram, evalReversibleProgram, evalReversibleGate,
    xBasisEquiv, xBasisAction, ne0, ne1, ne2, ne3]

/-- Normalization never touches the outer target. -/
theorem normalize_preserves_target
    (k : Nat) (four_le : 4 ≤ k)
    (state : PrimitiveBasis (lemmaOneFlatWidth k)) :
    evalReversibleProgram (normalizeScheduled k four_le).program state
        (targetWire k) = state (targetWire k) := by
  rw [ScheduledReversibleProgram.sequential_program, normalizeProgram_eq_public]
  simp [publicNormalizeProgram, evalReversibleProgram, evalReversibleGate,
    xBasisEquiv, xBasisAction, reservedWire, controlWire_ne_target]

/-- Nor does normalization touch the Step-1 flag / outer dirty wire. -/
theorem normalize_preserves_dirty
    (k : Nat) (four_le : 4 ≤ k)
    (state : PrimitiveBasis (lemmaOneFlatWidth k)) :
    evalReversibleProgram (normalizeScheduled k four_le).program state
        (dirtyWire k) = state (dirtyWire k) := by
  rw [ScheduledReversibleProgram.sequential_program, normalizeProgram_eq_public]
  simp [publicNormalizeProgram, evalReversibleProgram, evalReversibleGate,
    xBasisEquiv, xBasisAction, reservedWire, controlWire_ne_dirty]

/-- State immediately before the two recursive child first halves. -/
def seedState (k : Nat) (four_le : 4 ≤ k)
    (state : PrimitiveBasis (lemmaOneFlatWidth k)) :
    PrimitiveBasis (lemmaOneFlatWidth k) :=
  evalReversibleProgram (normalizeScheduled k four_le).program
    (evalReversibleProgram (stepOneScheduled k four_le).program state)

/-- Seed construction preserves the outer target exactly. -/
theorem seed_preserves_target
    (k : Nat) (four_le : 4 ≤ k)
    (state : PrimitiveBasis (lemmaOneFlatWidth k)) :
    seedState k four_le state (targetWire k) = state (targetWire k) := by
  rw [seedState, normalize_preserves_target, stepOne_restores_target]

/-- Non-reserved recursive control blocks are unchanged by the complete seed. -/
theorem seed_preserves_nonreserved_control
    (k : Nat) (four_le : 4 ≤ k)
    (state : PrimitiveBasis (lemmaOneFlatWidth k))
    (wire : Fin k) (nonreserved : 4 ≤ wire.val) :
    seedState k four_le state (controlWire k wire) =
      state (controlWire k wire) := by
  rw [seedState, normalize_preserves_nonreserved_control k four_le _ wire nonreserved,
    stepOne_preserves_control]

/-- On the active Step-1 branch the four reserved controls become clean zeroes. -/
theorem seed_reserved_zero
    (k : Nat) (four_le : 4 ≤ k)
    (state : PrimitiveBasis (lemmaOneFlatWidth k))
    (active : ReservedAllOne k four_le state)
    (index : Fin 4) :
    seedState k four_le state (reservedWire k four_le index) = 0 := by
  rw [seedState, normalize_reserved_action,
    stepOne_preserves_reserved k four_le state index]
  have one := active index
  rw [one]
  rfl

/-- If the incoming flag is clean zero, Step 1 sets it to one exactly on the
active reserved-control branch; normalization leaves it there. -/
theorem seed_dirty_one
    (k : Nat) (four_le : 4 ≤ k)
    (state : PrimitiveBasis (lemmaOneFlatWidth k))
    (clean : state (dirtyWire k) = 0)
    (active : ReservedAllOne k four_le state) :
    seedState k four_le state (dirtyWire k) = 1 := by
  rw [seedState, normalize_preserves_dirty, stepOne_dirty_action]
  simp [active, clean, flipBit]

@[simp] theorem leftChildEmbed_target_reserved0
    (k : Nat) (four_le : 4 ≤ k) :
    leftChildEmbed k four_le (targetWire (leftSize k)) =
      reservedWire k four_le s0 := by
  apply Fin.ext
  simp [leftChildEmbed, targetWire, reservedWire, s0, controlWire,
    reservedControl]

@[simp] theorem leftChildEmbed_dirty_reserved1
    (k : Nat) (four_le : 4 ≤ k) :
    leftChildEmbed k four_le (dirtyWire (leftSize k)) =
      reservedWire k four_le s1 := by
  apply Fin.ext
  simp [leftChildEmbed, dirtyWire, reservedWire, s1, controlWire,
    reservedControl]

@[simp] theorem rightChildEmbed_target_reserved2
    (k : Nat) (four_le : 4 ≤ k) :
    rightChildEmbed k four_le (targetWire (rightSize k)) =
      reservedWire k four_le s2 := by
  apply Fin.ext
  simp [rightChildEmbed, targetWire, reservedWire, s2, controlWire,
    reservedControl]

@[simp] theorem rightChildEmbed_dirty_reserved3
    (k : Nat) (four_le : 4 ≤ k) :
    rightChildEmbed k four_le (dirtyWire (rightSize k)) =
      reservedWire k four_le s3 := by
  apply Fin.ext
  simp [rightChildEmbed, dirtyWire, reservedWire, s3, controlWire,
    reservedControl]

/-- Active seed gives the left recursive child a clean target and clean borrowed
workspace. -/
theorem leftSeed_target_dirty_zero
    (k : Nat) (four_le : 4 ≤ k)
    (state : PrimitiveBasis (lemmaOneFlatWidth k))
    (active : ReservedAllOne k four_le state) :
    readEmbeddedState (leftChildEmbed k four_le) (seedState k four_le state)
        (targetWire (leftSize k)) = 0 ∧
    readEmbeddedState (leftChildEmbed k four_le) (seedState k four_le state)
        (dirtyWire (leftSize k)) = 0 := by
  constructor <;>
    simp [readEmbeddedState, seed_reserved_zero k four_le state active]

/-- Symmetric right-child clean promise. -/
theorem rightSeed_target_dirty_zero
    (k : Nat) (four_le : 4 ≤ k)
    (state : PrimitiveBasis (lemmaOneFlatWidth k))
    (active : ReservedAllOne k four_le state) :
    readEmbeddedState (rightChildEmbed k four_le) (seedState k four_le state)
        (targetWire (rightSize k)) = 0 ∧
    readEmbeddedState (rightChildEmbed k four_le) (seedState k four_le state)
        (dirtyWire (rightSize k)) = 0 := by
  constructor <;>
    simp [readEmbeddedState, seed_reserved_zero k four_le state active]

/-- The left child sees exactly the original left-block activation predicate. -/
theorem leftSeed_allControls_iff
    (k : Nat) (four_le : 4 ≤ k)
    (state : PrimitiveBasis (lemmaOneFlatWidth k)) :
    allFlatControlsOne (leftSize k)
        (readEmbeddedState (leftChildEmbed k four_le) (seedState k four_le state)) ↔
      LeftBlockAllOne k four_le state := by
  rw [leftChild_allFlatControlsOne_iff]
  constructor
  · intro all j
    have hit := all j
    have nonreserved : 4 ≤ (leftParentControl k four_le j).val := by
      simp [leftParentControl]
    have unchanged := seed_preserves_nonreserved_control k four_le state
      (leftParentControl k four_le j) nonreserved
    rw [unchanged] at hit
    exact hit
  · intro all j
    have nonreserved : 4 ≤ (leftParentControl k four_le j).val := by
      simp [leftParentControl]
    have unchanged := seed_preserves_nonreserved_control k four_le state
      (leftParentControl k four_le j) nonreserved
    rw [unchanged]
    exact all j

/-- The right child sees exactly the original right-block activation predicate. -/
theorem rightSeed_allControls_iff
    (k : Nat) (four_le : 4 ≤ k)
    (state : PrimitiveBasis (lemmaOneFlatWidth k)) :
    allFlatControlsOne (rightSize k)
        (readEmbeddedState (rightChildEmbed k four_le) (seedState k four_le state)) ↔
      RightBlockAllOne k four_le state := by
  rw [rightChild_allFlatControlsOne_iff]
  constructor
  · intro all j
    have hit := all j
    have nonreserved : 4 ≤ (rightParentControl k four_le j).val := by
      simp [rightParentControl]
      omega
    have unchanged := seed_preserves_nonreserved_control k four_le state
      (rightParentControl k four_le j) nonreserved
    rw [unchanged] at hit
    exact hit
  · intro all j
    have nonreserved : 4 ≤ (rightParentControl k four_le j).val := by
      simp [rightParentControl]
      omega
    have unchanged := seed_preserves_nonreserved_control k four_le state
      (rightParentControl k four_le j) nonreserved
    rw [unchanged]
    exact all j

end VandaeleLemma1NieSeedSemantics
end QuantumBlockEncoding
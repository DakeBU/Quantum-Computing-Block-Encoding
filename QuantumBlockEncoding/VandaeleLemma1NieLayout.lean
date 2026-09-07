import QuantumBlockEncoding.ReversibleEmbeddingDisjointness
import QuantumBlockEncoding.VandaeleLemma1BorrowedNCTGadgets
import Mathlib.Tactic

/-!
# Wire layout for the Nie / Vandaele logarithmic-depth recursion

For `k > 4`, Figure 3 reserves the first four controls `I₁,...,I₄` and splits
the remaining controls into two balanced blocks.  The left recursive child uses
`I₁` as target and `I₂` as borrowed workspace; the right child uses `I₃` as
target and `I₄` as borrowed workspace.

This module makes that picture an exact flat-wire contract.  It also embeds the
fixed NCT gadgets already certified for the two constant-depth source blocks:

* Step 1: `C⁴X(I₁,I₂,I₃,I₄ → A)`, borrowing the outer target `T`;
* Step 3: `C³X(I₁,I₃,A → T)`, borrowing `I₂`.

The four X gates used to expose conditionally-clean controls are kept as a
constant-depth sequential schedule.  Optimising those four gates into one layer
is unnecessary for the asymptotic theorem and would obscure the source-facing
wire contract.
-/

namespace QuantumBlockEncoding
namespace VandaeleLemma1NieLayout

open VandaeleLemma1ProgramFamily
open VandaeleLemma1PrimitiveBaseCases
open VandaeleLemma1BorrowedNCTGadgets
open ScheduledWireEmbedding
open ReversibleEmbeddingDisjointness

/-- Size of the left recursive control block. -/
def leftSize (k : Nat) : Nat := (k - 4) / 2

/-- Size of the right recursive control block. -/
def rightSize (k : Nat) : Nat := k - 4 - leftSize k

private theorem leftSize_le_remainder (k : Nat) :
    leftSize k ≤ k - 4 := by
  unfold leftSize
  exact Nat.div_le_self _ _

/-- The four reserved controls plus the two child blocks partition all controls. -/
theorem split_size (k : Nat) (four_le : 4 ≤ k) :
    4 + leftSize k + rightSize k = k := by
  have left_le : leftSize k ≤ k - 4 := leftSize_le_remainder k
  unfold rightSize
  omega

/-- The `i`th one of the four reserved controls, as a source control index. -/
def reservedControl (k : Nat) (four_le : 4 ≤ k)
    (i : Fin 4) : Fin k :=
  ⟨i.val, by omega⟩

private def r0 (k : Nat) (four_le : 4 ≤ k) : Fin k :=
  reservedControl k four_le ⟨0, by omega⟩
private def r1 (k : Nat) (four_le : 4 ≤ k) : Fin k :=
  reservedControl k four_le ⟨1, by omega⟩
private def r2 (k : Nat) (four_le : 4 ≤ k) : Fin k :=
  reservedControl k four_le ⟨2, by omega⟩
private def r3 (k : Nat) (four_le : 4 ≤ k) : Fin k :=
  reservedControl k four_le ⟨3, by omega⟩

/-- Embed the left child layout
`[left block controls | target=I₁ | dirty=I₂]` into the parent. -/
def leftChildEmbed (k : Nat) (four_le : 4 ≤ k) :
    Fin (lemmaOneFlatWidth (leftSize k)) → Fin (lemmaOneFlatWidth k) :=
  fun wire =>
    if control : wire.val < leftSize k then
      ⟨4 + wire.val, by
        unfold lemmaOneFlatWidth
        have left_le := leftSize_le_remainder k
        omega⟩
    else if target : wire.val = leftSize k then
      controlWire k (r0 k four_le)
    else
      controlWire k (r1 k four_le)

/-- The left child uses pairwise distinct physical wires. -/
theorem leftChildEmbed_injective (k : Nat) (four_le : 4 ≤ k) :
    Function.Injective (leftChildEmbed k four_le) := by
  intro a b equal
  have values := congrArg Fin.val equal
  by_cases ac : a.val < leftSize k
  · by_cases bc : b.val < leftSize k
    · simp [leftChildEmbed, ac, bc] at values
      apply Fin.ext
      omega
    · by_cases bt : b.val = leftSize k
      · simp [leftChildEmbed, ac, bc, bt, controlWire, r0,
          reservedControl] at values
      · simp [leftChildEmbed, ac, bc, bt, controlWire, r1,
          reservedControl] at values
        omega
  · by_cases aTarget : a.val = leftSize k
    · by_cases bc : b.val < leftSize k
      · simp [leftChildEmbed, ac, aTarget, bc, controlWire, r0,
          reservedControl] at values
        omega
      · by_cases bt : b.val = leftSize k
        · apply Fin.ext
          omega
        · simp [leftChildEmbed, ac, aTarget, bc, bt, controlWire, r0, r1,
            reservedControl] at values
    · by_cases bc : b.val < leftSize k
      · simp [leftChildEmbed, ac, aTarget, bc, controlWire, r1,
          reservedControl] at values
        omega
      · by_cases bt : b.val = leftSize k
        · simp [leftChildEmbed, ac, aTarget, bc, bt, controlWire, r0, r1,
            reservedControl] at values
        · apply Fin.ext
          have a_lt : a.val < leftSize k + 2 := by
            simpa [lemmaOneFlatWidth] using a.isLt
          have b_lt : b.val < leftSize k + 2 := by
            simpa [lemmaOneFlatWidth] using b.isLt
          omega

/-- Embed the right child layout
`[right block controls | target=I₃ | dirty=I₄]` into the parent. -/
def rightChildEmbed (k : Nat) (four_le : 4 ≤ k) :
    Fin (lemmaOneFlatWidth (rightSize k)) → Fin (lemmaOneFlatWidth k) :=
  fun wire =>
    if control : wire.val < rightSize k then
      ⟨4 + leftSize k + wire.val, by
        unfold lemmaOneFlatWidth
        have partition := split_size k four_le
        omega⟩
    else if target : wire.val = rightSize k then
      controlWire k (r2 k four_le)
    else
      controlWire k (r3 k four_le)

/-- The right child uses pairwise distinct physical wires. -/
theorem rightChildEmbed_injective (k : Nat) (four_le : 4 ≤ k) :
    Function.Injective (rightChildEmbed k four_le) := by
  intro a b equal
  have values := congrArg Fin.val equal
  by_cases ac : a.val < rightSize k
  · by_cases bc : b.val < rightSize k
    · simp [rightChildEmbed, ac, bc] at values
      apply Fin.ext
      omega
    · by_cases bt : b.val = rightSize k
      · simp [rightChildEmbed, ac, bc, bt, controlWire, r2,
          reservedControl] at values
        omega
      · simp [rightChildEmbed, ac, bc, bt, controlWire, r3,
          reservedControl] at values
        omega
  · by_cases aTarget : a.val = rightSize k
    · by_cases bc : b.val < rightSize k
      · simp [rightChildEmbed, ac, aTarget, bc, controlWire, r2,
          reservedControl] at values
        omega
      · by_cases bt : b.val = rightSize k
        · apply Fin.ext
          omega
        · simp [rightChildEmbed, ac, aTarget, bc, bt, controlWire, r2, r3,
            reservedControl] at values
    · by_cases bc : b.val < rightSize k
      · simp [rightChildEmbed, ac, aTarget, bc, controlWire, r3,
          reservedControl] at values
        omega
      · by_cases bt : b.val = rightSize k
        · simp [rightChildEmbed, ac, aTarget, bc, bt, controlWire, r2, r3,
            reservedControl] at values
        · apply Fin.ext
          have a_lt : a.val < rightSize k + 2 := by
            simpa [lemmaOneFlatWidth] using a.isLt
          have b_lt : b.val < rightSize k + 2 := by
            simpa [lemmaOneFlatWidth] using b.isLt
          omega

/-- The two recursive child images are physically disjoint. -/
theorem childImagesDisjoint (k : Nat) (four_le : 4 ≤ k) :
    ImagesDisjoint (leftChildEmbed k four_le) (rightChildEmbed k four_le) := by
  intro leftWire rightWire equal
  have values := congrArg Fin.val equal
  have partition := split_size k four_le
  by_cases lc : leftWire.val < leftSize k
  · by_cases rc : rightWire.val < rightSize k
    · simp [leftChildEmbed, rightChildEmbed, lc, rc] at values
      omega
    · by_cases rt : rightWire.val = rightSize k
      · simp [leftChildEmbed, rightChildEmbed, lc, rc, rt, controlWire, r2,
          reservedControl] at values
        omega
      · simp [leftChildEmbed, rightChildEmbed, lc, rc, rt, controlWire, r3,
          reservedControl] at values
        omega
  · by_cases lt : leftWire.val = leftSize k
    · by_cases rc : rightWire.val < rightSize k
      · simp [leftChildEmbed, rightChildEmbed, lc, lt, rc, controlWire, r0,
          reservedControl] at values
        omega
      · by_cases rt : rightWire.val = rightSize k
        · simp [leftChildEmbed, rightChildEmbed, lc, lt, rc, rt, controlWire,
            r0, r2, reservedControl] at values
        · simp [leftChildEmbed, rightChildEmbed, lc, lt, rc, rt, controlWire,
            r0, r3, reservedControl] at values
    · by_cases rc : rightWire.val < rightSize k
      · simp [leftChildEmbed, rightChildEmbed, lc, lt, rc, controlWire, r1,
          reservedControl] at values
        omega
      · by_cases rt : rightWire.val = rightSize k
        · simp [leftChildEmbed, rightChildEmbed, lc, lt, rc, rt, controlWire,
            r1, r2, reservedControl] at values
        · simp [leftChildEmbed, rightChildEmbed, lc, lt, rc, rt, controlWire,
            r1, r3, reservedControl] at values

/-- Wire renaming for the fixed `C⁴X` in Figure-3 Step 1.  The native gadget's
workspace wire is mapped to the outer target `T`, which it restores exactly. -/
def stepOneEmbed (k : Nat) (four_le : 4 ≤ k) :
    Fin (lemmaOneFlatWidth 4) → Fin (lemmaOneFlatWidth k) :=
  fun wire =>
    if control : wire.val < 4 then
      ⟨wire.val, by unfold lemmaOneFlatWidth; omega⟩
    else if target : wire.val = 4 then
      dirtyWire k
    else
      targetWire k

/-- Step-1 wire renaming is injective. -/
theorem stepOneEmbed_injective (k : Nat) (four_le : 4 ≤ k) :
    Function.Injective (stepOneEmbed k four_le) := by
  intro a b equal
  have values := congrArg Fin.val equal
  by_cases ac : a.val < 4
  · by_cases bc : b.val < 4
    · simp [stepOneEmbed, ac, bc] at values
      apply Fin.ext
      omega
    · by_cases bt : b.val = 4
      · simp [stepOneEmbed, ac, bc, bt, dirtyWire] at values
        omega
      · simp [stepOneEmbed, ac, bc, bt, targetWire] at values
        omega
  · by_cases aTarget : a.val = 4
    · by_cases bc : b.val < 4
      · simp [stepOneEmbed, ac, aTarget, bc, dirtyWire] at values
        omega
      · by_cases bt : b.val = 4
        · apply Fin.ext
          omega
        · simp [stepOneEmbed, ac, aTarget, bc, bt, dirtyWire, targetWire] at values
    · by_cases bc : b.val < 4
      · simp [stepOneEmbed, ac, aTarget, bc, targetWire] at values
        omega
      · by_cases bt : b.val = 4
        · simp [stepOneEmbed, ac, aTarget, bc, bt, dirtyWire, targetWire] at values
        · apply Fin.ext
          have a_lt : a.val < 6 := by
            simpa [lemmaOneFlatWidth] using a.isLt
          have b_lt : b.val < 6 := by
            simpa [lemmaOneFlatWidth] using b.isLt
          omega

/-- Executable NCT implementation of Figure-3 Step 1. -/
def stepOneScheduled (k : Nat) (four_le : 4 ≤ k) :
    ScheduledReversibleProgram (lemmaOneFlatWidth k) :=
  mapScheduledWires (stepOneEmbed k four_le)
    (stepOneEmbed_injective k four_le) k4Scheduled

@[simp] theorem stepOne_gateCount (k : Nat) (four_le : 4 ≤ k) :
    (stepOneScheduled k four_le).gateCount = 10 := by
  simp [stepOneScheduled]

@[simp] theorem stepOne_depth (k : Nat) (four_le : 4 ≤ k) :
    (stepOneScheduled k four_le).depth = 10 := by
  simp [stepOneScheduled]

/-- Four source X gates which expose `I₁,...,I₄` as conditionally-clean wires
on the active Step-1 branch. -/
def normalizeProgram (k : Nat) (four_le : 4 ≤ k) :
    ReversibleProgram (lemmaOneFlatWidth k) :=
  [ .x (controlWire k (r0 k four_le)),
    .x (controlWire k (r1 k four_le)),
    .x (controlWire k (r2 k four_le)),
    .x (controlWire k (r3 k four_le)) ]

/-- Conservative constant-depth schedule for the normalization X gates. -/
def normalizeScheduled (k : Nat) (four_le : 4 ≤ k) :
    ScheduledReversibleProgram (lemmaOneFlatWidth k) :=
  ScheduledReversibleProgram.sequential (normalizeProgram k four_le)

@[simp] theorem normalize_gateCount (k : Nat) (four_le : 4 ≤ k) :
    (normalizeScheduled k four_le).gateCount = 4 := by
  simp [normalizeScheduled, normalizeProgram]

@[simp] theorem normalize_depth (k : Nat) (four_le : 4 ≤ k) :
    (normalizeScheduled k four_le).depth = 4 := by
  simp [normalizeScheduled, normalizeProgram]

/-- Wire renaming for the fixed `C³X(I₁,I₃,A → T)` in Figure-3 Step 3.
`I₂` is only borrowed as dirty workspace and is restored by the certified gadget. -/
def stepThreeEmbed (k : Nat) (four_le : 4 ≤ k) :
    Fin (lemmaOneFlatWidth 3) → Fin (lemmaOneFlatWidth k) :=
  fun wire =>
    if h0 : wire.val = 0 then controlWire k (r0 k four_le)
    else if h1 : wire.val = 1 then controlWire k (r2 k four_le)
    else if h2 : wire.val = 2 then dirtyWire k
    else if h3 : wire.val = 3 then targetWire k
    else controlWire k (r1 k four_le)

/-- Step-3 wire renaming is injective. -/
theorem stepThreeEmbed_injective (k : Nat) (four_le : 4 ≤ k) :
    Function.Injective (stepThreeEmbed k four_le) := by
  intro a b equal
  apply Fin.ext
  have values := congrArg Fin.val equal
  fin_cases a <;> fin_cases b <;>
    simp [stepThreeEmbed, controlWire, r0, r1, r2, reservedControl,
      targetWire, dirtyWire] at values ⊢ <;> omega

/-- Executable NCT implementation of Figure-3 Step 3. -/
def stepThreeScheduled (k : Nat) (four_le : 4 ≤ k) :
    ScheduledReversibleProgram (lemmaOneFlatWidth k) :=
  mapScheduledWires (stepThreeEmbed k four_le)
    (stepThreeEmbed_injective k four_le) k3Scheduled

@[simp] theorem stepThree_gateCount (k : Nat) (four_le : 4 ≤ k) :
    (stepThreeScheduled k four_le).gateCount = 4 := by
  simp [stepThreeScheduled]

@[simp] theorem stepThree_depth (k : Nat) (four_le : 4 ≤ k) :
    (stepThreeScheduled k four_le).depth = 4 := by
  simp [stepThreeScheduled]

end VandaeleLemma1NieLayout
end QuantumBlockEncoding

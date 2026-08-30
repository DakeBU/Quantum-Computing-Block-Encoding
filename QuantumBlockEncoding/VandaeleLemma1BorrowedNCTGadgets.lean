import QuantumBlockEncoding.VandaeleLemma1PrimitiveBaseCases
import Mathlib.Tactic

/-!
# Borrowed-bit NCT gadgets for the fixed Nie/Vandaele recursion blocks

The Nie source theorem is stated over `B₂`, whereas Vandaele Lemma 1 advertises
`{X,CX,CCX}`.  The logarithmic-depth recursion only needs a constant collection
of small multi-controlled-X blocks.  This module closes the first concrete
piece of that gate-set fidelity gap without appealing to an opaque synthesis
claim.

For `C³X`, one arbitrary borrowed bit `d` is enough:

```
d ^= a b
t ^= c d
d ^= a b
t ^= c d
```

The two target hits cancel the unknown incoming value of `d`, leaving exactly
`t ^= a b c` while restoring `d`.

For `C⁴X`, the same four-gate `C³X` borrowed-bit gadget is used to toggle the
outer dirty bit by `a b c`, temporarily borrowing the final target.  Two outer
`CCX(d,e,t)` hits then cancel the incoming dirty value and leave exactly
`t ^= a b c e`.  This costs ten `CCX` gates and again restores the borrowed bit.

Both gadgets inhabit the same flat `[controls | target | dirty]` contract as the
future uniform family.  Because these are fixed 5- and 6-wire circuits, their
semantic contracts are kernel-checked by finite `native_decide` evaluation;
resource counts still come from the proof-bearing schedules themselves.
-/

namespace QuantumBlockEncoding
namespace VandaeleLemma1BorrowedNCTGadgets

open VandaeleLemma1Contract
open VandaeleLemma1ProgramFamily
open VandaeleLemma1PrimitiveBaseCases

private theorem controlWire_injective (k : Nat) :
    Function.Injective (controlWire k) := by
  intro left right equal
  apply Fin.ext
  have values := congrArg Fin.val equal
  simpa [controlWire] using values

/-! ## Three controls: four-CCX borrowed-bit gadget -/

private def k3c0 : Fin 3 := ⟨0, by omega⟩
private def k3c1 : Fin 3 := ⟨1, by omega⟩
private def k3c2 : Fin 3 := ⟨2, by omega⟩

private theorem k3c0_ne_k3c1 : k3c0 ≠ k3c1 := by decide

/-- Exact `C³X` over NCT with one arbitrary dirty workspace. -/
def k3Program : ReversibleProgram (lemmaOneFlatWidth 3) :=
  [ .ccx
      (controlWire 3 k3c0) (controlWire 3 k3c1) (dirtyWire 3)
      (controlWire_injective 3 k3c0_ne_k3c1)
      (controlWire_ne_dirty 3 k3c0)
      (controlWire_ne_dirty 3 k3c1),
    .ccx
      (controlWire 3 k3c2) (dirtyWire 3) (targetWire 3)
      (controlWire_ne_dirty 3 k3c2)
      (controlWire_ne_target 3 k3c2)
      (dirtyWire_ne_target 3),
    .ccx
      (controlWire 3 k3c0) (controlWire 3 k3c1) (dirtyWire 3)
      (controlWire_injective 3 k3c0_ne_k3c1)
      (controlWire_ne_dirty 3 k3c0)
      (controlWire_ne_dirty 3 k3c1),
    .ccx
      (controlWire 3 k3c2) (dirtyWire 3) (targetWire 3)
      (controlWire_ne_dirty 3 k3c2)
      (controlWire_ne_target 3 k3c2)
      (dirtyWire_ne_target 3) ]

/-- Sequential proof-bearing schedule.  Constant depth is sufficient for the
fixed recursion gadget; logarithmic depth comes from recursive parallelism. -/
def k3Scheduled : ScheduledReversibleProgram (lemmaOneFlatWidth 3) :=
  ScheduledReversibleProgram.sequential k3Program

/-- Exhaustive exact semantic certificate on the 32 computational-basis states. -/
theorem k3_correct :
    LemmaOneFlatSpec 3 (evalReversibleProgram k3Scheduled.program) := by
  native_decide

/-- The fixed NCT gadget refines the source Definition-2.1 permutation. -/
theorem k3_refines_source
    (state : PrimitiveBasis (lemmaOneFlatWidth 3)) :
    externalView 3 (evalReversibleProgram k3Scheduled.program state) =
        multiControlledXEquiv 3 (externalView 3 state) ∧
      evalReversibleProgram k3Scheduled.program state (dirtyWire 3) =
        state (dirtyWire 3) :=
  flatSpec_refines_source 3 _ k3_correct state

@[simp] theorem k3_gateCount : k3Scheduled.gateCount = 4 := by
  simp [k3Scheduled, k3Program]

@[simp] theorem k3_depth : k3Scheduled.depth = 4 := by
  simp [k3Scheduled, k3Program]

/-! ## Four controls: ten-CCX borrowed-bit gadget -/

private def k4c0 : Fin 4 := ⟨0, by omega⟩
private def k4c1 : Fin 4 := ⟨1, by omega⟩
private def k4c2 : Fin 4 := ⟨2, by omega⟩
private def k4c3 : Fin 4 := ⟨3, by omega⟩

private theorem k4c0_ne_k4c1 : k4c0 ≠ k4c1 := by decide

/-- Four-gate inner gadget: toggle the outer dirty bit by the first three
controls while using the final target itself as an arbitrary borrowed wire. -/
def k4InnerProgram : ReversibleProgram (lemmaOneFlatWidth 4) :=
  [ .ccx
      (controlWire 4 k4c0) (controlWire 4 k4c1) (targetWire 4)
      (controlWire_injective 4 k4c0_ne_k4c1)
      (controlWire_ne_target 4 k4c0)
      (controlWire_ne_target 4 k4c1),
    .ccx
      (controlWire 4 k4c2) (targetWire 4) (dirtyWire 4)
      (controlWire_ne_target 4 k4c2)
      (controlWire_ne_dirty 4 k4c2)
      (targetWire_ne_dirty 4),
    .ccx
      (controlWire 4 k4c0) (controlWire 4 k4c1) (targetWire 4)
      (controlWire_injective 4 k4c0_ne_k4c1)
      (controlWire_ne_target 4 k4c0)
      (controlWire_ne_target 4 k4c1),
    .ccx
      (controlWire 4 k4c2) (targetWire 4) (dirtyWire 4)
      (controlWire_ne_target 4 k4c2)
      (controlWire_ne_dirty 4 k4c2)
      (targetWire_ne_dirty 4) ]

private def k4OuterHit : ReversibleGate (lemmaOneFlatWidth 4) :=
  .ccx
    (controlWire 4 k4c3) (dirtyWire 4) (targetWire 4)
    (controlWire_ne_dirty 4 k4c3)
    (controlWire_ne_target 4 k4c3)
    (dirtyWire_ne_target 4)

/-- Exact `C⁴X`: inner borrowed computation, outer hit, inner restoration,
second outer hit. -/
def k4Program : ReversibleProgram (lemmaOneFlatWidth 4) :=
  k4InnerProgram ++ [k4OuterHit] ++ k4InnerProgram ++ [k4OuterHit]

/-- Proof-bearing constant-depth schedule for the fixed four-control block. -/
def k4Scheduled : ScheduledReversibleProgram (lemmaOneFlatWidth 4) :=
  ScheduledReversibleProgram.sequential k4Program

/-- Exhaustive exact semantic certificate on the 64 computational-basis states. -/
theorem k4_correct :
    LemmaOneFlatSpec 4 (evalReversibleProgram k4Scheduled.program) := by
  native_decide

/-- The ten-CCX circuit refines Definition 2.1 and restores the arbitrary dirty
workspace exactly. -/
theorem k4_refines_source
    (state : PrimitiveBasis (lemmaOneFlatWidth 4)) :
    externalView 4 (evalReversibleProgram k4Scheduled.program state) =
        multiControlledXEquiv 4 (externalView 4 state) ∧
      evalReversibleProgram k4Scheduled.program state (dirtyWire 4) =
        state (dirtyWire 4) :=
  flatSpec_refines_source 4 _ k4_correct state

@[simp] theorem k4_gateCount : k4Scheduled.gateCount = 10 := by
  simp [k4Scheduled, k4Program, k4InnerProgram, k4OuterHit]

@[simp] theorem k4_depth : k4Scheduled.depth = 10 := by
  simp [k4Scheduled, k4Program, k4InnerProgram, k4OuterHit]

/-- The fixed gadgets therefore satisfy the one-dirty-ancilla instance budget
with exact resource numbers, rather than an opaque `O(1)` placeholder. -/
theorem borrowedGadgets_exact_resources :
    (k3Scheduled.gateCount = 4 ∧ k3Scheduled.depth = 4) ∧
    (k4Scheduled.gateCount = 10 ∧ k4Scheduled.depth = 10) := by
  simp

end VandaeleLemma1BorrowedNCTGadgets
end QuantumBlockEncoding

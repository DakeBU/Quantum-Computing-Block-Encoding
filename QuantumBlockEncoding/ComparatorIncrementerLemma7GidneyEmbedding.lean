import QuantumBlockEncoding.ComparatorIncrementerLemma7FlatContract
import QuantumBlockEncoding.GidneyIncrementerProgramFamily
import QuantumBlockEncoding.ReversibleRelabel
import Mathlib.Tactic

/-!
# Embed the Gidney base incrementer into the Lemma-7 flat register

This is the first concrete program edge in the Figure-9 line.  The external
Gidney component has layout

`[ n target | n-2 clean workspace ]`.

The Lemma-7 register has layout

`[ k controls | n-1 promise | n target ]`.

We embed the Gidney target into the final n target wires and its clean workspace
into the first n-2 promise wires.  The external controls are untouched, and for
`n >= 2` the final promise wire is outside the embedding, exactly matching the
workspace reserved later for the Equation-(36) dirty conversion.

Because the embedding is performed with `ReversibleRelabel`, the scheduled gate
count and certified depth are definitionally preserved.
-/

namespace QuantumBlockEncoding
namespace ComparatorIncrementerLemma7GidneyEmbedding

open ComparatorIncrementerLemma7Contract
open ComparatorIncrementerLemma7FlatContract
open GidneyIncrementerProgramFamily
open PrimitiveBasisRegisterSplit
open ReversibleRelabel

/-- Embed one Gidney workspace index into the first `n-2` promise wires. -/
def workspacePromiseIndex (n : Nat)
    (wire : Fin (workspaceWidth n)) :
    Fin (lemmaSevenPromiseWidth n) :=
  ⟨wire.val, by
    have bound := wire.isLt
    unfold workspaceWidth lemmaSevenPromiseWidth at bound ⊢
    omega⟩

/-- Source target wire in the Gidney flat layout. -/
def gidneyTargetWire (n : Nat) (wire : Fin n) : Fin (flatWidth n) :=
  lowWire n (workspaceWidth n) wire

/-- Source workspace wire in the Gidney flat layout. -/
def gidneyWorkspaceWire (n : Nat) (wire : Fin (workspaceWidth n)) :
    Fin (flatWidth n) :=
  highWire n (workspaceWidth n) wire

/-- Inject the entire Gidney register into the larger Lemma-7 register. -/
def gidneyWireMap (k n : Nat) (wire : Fin (flatWidth n)) :
    Fin (lemmaSevenFlatWidth k n) :=
  if target : wire.val < n then
    targetWire k n ⟨wire.val, target⟩
  else
    promiseWire k n
      ⟨wire.val - n, by
        have sourceBound := wire.isLt
        unfold flatWidth workspaceWidth at sourceBound
        unfold lemmaSevenPromiseWidth
        omega⟩

@[simp] theorem gidneyWireMap_target
    (k n : Nat) (wire : Fin n) :
    gidneyWireMap k n (gidneyTargetWire n wire) =
      targetWire k n wire := by
  apply Fin.ext
  simp [gidneyWireMap, gidneyTargetWire, lowWire, targetWire]

@[simp] theorem gidneyWireMap_workspace
    (k n : Nat) (wire : Fin (workspaceWidth n)) :
    gidneyWireMap k n (gidneyWorkspaceWire n wire) =
      promiseWire k n (workspacePromiseIndex n wire) := by
  apply Fin.ext
  have notTarget : ¬(n + wire.val < n) := by omega
  simp [gidneyWireMap, gidneyWorkspaceWire, highWire,
    promiseWire, workspacePromiseIndex, notTarget]

/-- The flat register embedding is injective. -/
theorem gidneyWireMap_injective (k n : Nat) :
    Function.Injective (gidneyWireMap k n) := by
  intro left right equal
  have valueEqual := congrArg Fin.val equal
  have leftBound := left.isLt
  have rightBound := right.isLt
  unfold flatWidth workspaceWidth at leftBound rightBound
  by_cases leftTarget : left.val < n <;>
    by_cases rightTarget : right.val < n
  · simp [gidneyWireMap, leftTarget, rightTarget,
      targetWire] at valueEqual
    apply Fin.ext
    omega
  · simp [gidneyWireMap, leftTarget, rightTarget,
      targetWire, promiseWire, lemmaSevenPromiseWidth] at valueEqual
    omega
  · simp [gidneyWireMap, leftTarget, rightTarget,
      targetWire, promiseWire, lemmaSevenPromiseWidth] at valueEqual
    omega
  · simp [gidneyWireMap, leftTarget, rightTarget,
      promiseWire] at valueEqual
    apply Fin.ext
    omega

/-- Proof-bearing Gidney schedule embedded into the Lemma-7 flat register. -/
def embeddedGidney
    (family : ScheduledFamily) (k n : Nat) :
    ScheduledReversibleProgram (lemmaSevenFlatWidth k n) :=
  relabelScheduled
    (gidneyWireMap k n) (gidneyWireMap_injective k n)
    (family.scheduled n)

@[simp] theorem embeddedGidney_gateCount
    (family : ScheduledFamily) (k n : Nat) :
    (embeddedGidney family k n).gateCount =
      (family.scheduled n).gateCount := by
  simp [embeddedGidney]

@[simp] theorem embeddedGidney_depth
    (family : ScheduledFamily) (k n : Nat) :
    (embeddedGidney family k n).depth =
      (family.scheduled n).depth := by
  simp [embeddedGidney]

/-- View the target suffix of one Lemma-7 flat state. -/
def targetSlice (k n : Nat)
    (state : PrimitiveBasis (lemmaSevenFlatWidth k n)) : PrimitiveBasis n :=
  fun wire => state (targetWire k n wire)

/-- View the promise prefix consumed as Gidney clean workspace. -/
def gidneyWorkspaceSlice (k n : Nat)
    (state : PrimitiveBasis (lemmaSevenFlatWidth k n)) :
    PrimitiveBasis (workspaceWidth n) :=
  fun wire => state (promiseWire k n (workspacePromiseIndex n wire))

/-- Restricting a Lemma-7 state along the Gidney wire map reproduces exactly the
source target/workspace state. -/
theorem registerEquiv_restrict_gidneyWireMap
    (k n : Nat)
    (state : PrimitiveBasis (lemmaSevenFlatWidth k n)) :
    registerEquiv n (restrictState (gidneyWireMap k n) state) =
      (targetSlice k n state, gidneyWorkspaceSlice k n state) := by
  apply Prod.ext
  · funext wire
    change state (gidneyWireMap k n (gidneyTargetWire n wire)) =
      state (targetWire k n wire)
    rw [gidneyWireMap_target]
  · funext wire
    change state (gidneyWireMap k n (gidneyWorkspaceWire n wire)) =
      state (promiseWire k n (workspacePromiseIndex n wire))
    rw [gidneyWireMap_workspace]

/-- On a clean embedded Gidney workspace, the target suffix increments and the
same promise prefix is returned clean. -/
theorem embeddedGidney_clean_action
    (family : ScheduledFamily) (k n : Nat)
    (state : PrimitiveBasis (lemmaSevenFlatWidth k n))
    (clean : workspaceClean n (gidneyWorkspaceSlice k n state)) :
    basisNat n
        (targetSlice k n
          (evalReversibleProgram (embeddedGidney family k n).program state)) =
        (basisNat n (targetSlice k n state) + 1) % gridSize n ∧
    workspaceClean n
      (gidneyWorkspaceSlice k n
        (evalReversibleProgram (embeddedGidney family k n).program state)) := by
  have sourceAction := flatSpec_action n
    (evalReversibleProgram (family.scheduled n).program)
    (family.correctness n)
    (restrictState (gidneyWireMap k n) state)
    (by simpa [registerEquiv_restrict_gidneyWireMap] using clean)
  have commuting := restrictState_eval_relabelScheduled
    (gidneyWireMap k n) (gidneyWireMap_injective k n)
    (family.scheduled n) state
  rw [show embeddedGidney family k n =
      relabelScheduled (gidneyWireMap k n)
        (gidneyWireMap_injective k n) (family.scheduled n) by rfl]
  have registerCommuting := congrArg (registerEquiv n) commuting
  rw [registerEquiv_restrict_gidneyWireMap] at registerCommuting
  rw [registerEquiv_restrict_gidneyWireMap] at sourceAction
  rw [registerCommuting]
  exact sourceAction

/-- The final promise wire is reserved for the dirty conversion. -/
def reservedPromiseIndex
    (n : Nat) (large : 2 ≤ n) : Fin (lemmaSevenPromiseWidth n) :=
  ⟨n - 2, by
    unfold lemmaSevenPromiseWidth
    omega⟩

/-- Reserved dirty-workspace wire in the flat Lemma-7 layout. -/
def reservedPromiseWire
    (k n : Nat) (large : 2 ≤ n) :
    Fin (lemmaSevenFlatWidth k n) :=
  promiseWire k n (reservedPromiseIndex n large)

/-- No Gidney source wire maps to the reserved final promise bit. -/
theorem reservedPromise_outside_gidney
    (k n : Nat) (large : 2 ≤ n) :
    ∀ source : Fin (flatWidth n),
      gidneyWireMap k n source ≠ reservedPromiseWire k n large := by
  intro source equal
  have valueEqual := congrArg Fin.val equal
  have sourceBound := source.isLt
  unfold flatWidth workspaceWidth at sourceBound
  by_cases target : source.val < n
  · simp [gidneyWireMap, target, targetWire,
      reservedPromiseWire, reservedPromiseIndex, promiseWire,
      lemmaSevenPromiseWidth] at valueEqual
    omega
  · simp [gidneyWireMap, target,
      reservedPromiseWire, reservedPromiseIndex, promiseWire] at valueEqual
    omega

/-- Therefore the embedded Gidney stage leaves the bit reserved for Equation
(36) completely unchanged, for arbitrary incoming value. -/
theorem embeddedGidney_preserves_reservedPromise
    (family : ScheduledFamily) (k n : Nat) (large : 2 ≤ n)
    (state : PrimitiveBasis (lemmaSevenFlatWidth k n)) :
    evalReversibleProgram (embeddedGidney family k n).program state
        (reservedPromiseWire k n large) =
      state (reservedPromiseWire k n large) := by
  unfold embeddedGidney
  rw [relabelScheduled_program]
  exact eval_relabelProgram_outside
    (gidneyWireMap k n) (gidneyWireMap_injective k n)
    (family.scheduled n).program state
    (reservedPromiseWire k n large)
    (reservedPromise_outside_gidney k n large)

end ComparatorIncrementerLemma7GidneyEmbedding
end QuantumBlockEncoding

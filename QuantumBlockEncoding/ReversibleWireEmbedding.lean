import QuantumBlockEncoding.ReversibleClassical
import Mathlib.Tactic

/-!
# Embed a reversible program into an arbitrary larger wire register

Source constructions repeatedly place one already-proved reversible subprogram
on a selected subset of a larger circuit register.  The special successor-wire
lift is not enough for Figure 9 / Figure 10, where controls, promise workspace,
and target blocks occupy several separated intervals.

This module provides the reusable general operation.  Given an injective wire
map `Fin small → Fin large`, every `X`, `CX`, and `CCX` instruction is renamed
along that map.  The resulting program satisfies three exact contracts:

* reading the embedded wires after execution equals executing the original
  program on the corresponding small state;
* every wire outside the embedding image is unchanged;
* instruction count is preserved exactly.

The theorem is circuit-agnostic and is intended to be shared by the Vandaele
formalization and later State Preparation / Block Encoding subregister routes.
-/

namespace QuantumBlockEncoding
namespace ReversibleWireEmbedding

/-- Read a large basis state through one injective logical-wire embedding. -/
def readEmbeddedState {small large : Nat}
    (embed : Fin small → Fin large)
    (state : PrimitiveBasis large) : PrimitiveBasis small :=
  fun wire => state (embed wire)

/-- Rename one reversible gate along an injective wire embedding. -/
def mapGateWires {small large : Nat}
    (embed : Fin small → Fin large)
    (injective : Function.Injective embed) :
    ReversibleGate small → ReversibleGate large
  | .x target => .x (embed target)
  | .cx control target distinct =>
      .cx (embed control) (embed target) (by
        intro equal
        exact distinct (injective equal))
  | .ccx control0 control1 target c0_ne_c1 c0_ne_target c1_ne_target =>
      .ccx (embed control0) (embed control1) (embed target)
        (by intro equal; exact c0_ne_c1 (injective equal))
        (by intro equal; exact c0_ne_target (injective equal))
        (by intro equal; exact c1_ne_target (injective equal))

/-- Rename an entire reversible program along the same embedding. -/
def mapProgramWires {small large : Nat}
    (embed : Fin small → Fin large)
    (injective : Function.Injective embed)
    (program : ReversibleProgram small) : ReversibleProgram large :=
  program.map (mapGateWires embed injective)

/-- One embedded gate has exactly the original logical action when restricted
back to the embedded wires. -/
theorem readEmbeddedState_eval_mapGateWires
    {small large : Nat}
    (embed : Fin small → Fin large)
    (injective : Function.Injective embed)
    (gate : ReversibleGate small)
    (state : PrimitiveBasis large) :
    readEmbeddedState embed
        (evalReversibleGate (mapGateWires embed injective gate) state) =
      evalReversibleGate gate (readEmbeddedState embed state) := by
  funext wire
  cases gate with
  | x target =>
      by_cases same : wire = target
      · subst wire
        simp [readEmbeddedState, mapGateWires, evalReversibleGate,
          xBasisEquiv, xBasisAction]
      · have mappedNe : embed wire ≠ embed target := by
          intro equal
          exact same (injective equal)
        simp [readEmbeddedState, mapGateWires, evalReversibleGate,
          xBasisEquiv, xBasisAction, same, mappedNe]
  | cx control target distinct =>
      by_cases controlZero : state (embed control) = 0
      · have smallControlZero :
            readEmbeddedState embed state control = 0 := by
          exact controlZero
        simp [readEmbeddedState, mapGateWires, evalReversibleGate,
          cxBasisEquiv, cxBasisAction, controlZero, smallControlZero]
      · have smallControlNonzero :
            readEmbeddedState embed state control ≠ 0 := by
          exact controlZero
        by_cases same : wire = target
        · subst wire
          simp [readEmbeddedState, mapGateWires, evalReversibleGate,
            cxBasisEquiv, cxBasisAction, xBasisAction,
            controlZero, smallControlNonzero]
        · have mappedNe : embed wire ≠ embed target := by
            intro equal
            exact same (injective equal)
          simp [readEmbeddedState, mapGateWires, evalReversibleGate,
            cxBasisEquiv, cxBasisAction, xBasisAction,
            controlZero, smallControlNonzero, same, mappedNe]
  | ccx control0 control1 target c0_ne_c1 c0_ne_target c1_ne_target =>
      by_cases active :
          state (embed control0) = 1 ∧ state (embed control1) = 1
      · have smallActive :
            readEmbeddedState embed state control0 = 1 ∧
              readEmbeddedState embed state control1 = 1 := by
          exact active
        by_cases same : wire = target
        · subst wire
          simp [readEmbeddedState, mapGateWires, evalReversibleGate,
            ccxBasisEquiv, ccxBasisAction, xBasisAction,
            active, smallActive]
        · have mappedNe : embed wire ≠ embed target := by
            intro equal
            exact same (injective equal)
          simp [readEmbeddedState, mapGateWires, evalReversibleGate,
            ccxBasisEquiv, ccxBasisAction, xBasisAction,
            active, smallActive, same, mappedNe]
      · have smallInactive :
            ¬(readEmbeddedState embed state control0 = 1 ∧
              readEmbeddedState embed state control1 = 1) := by
          exact active
        simp [readEmbeddedState, mapGateWires, evalReversibleGate,
          ccxBasisEquiv, ccxBasisAction, active, smallInactive]

/-- A mapped gate leaves every wire outside the embedding image untouched. -/
theorem eval_mapGateWires_outside
    {small large : Nat}
    (embed : Fin small → Fin large)
    (injective : Function.Injective embed)
    (gate : ReversibleGate small)
    (state : PrimitiveBasis large)
    (wire : Fin large)
    (outside : ∀ logical, embed logical ≠ wire) :
    evalReversibleGate (mapGateWires embed injective gate) state wire =
      state wire := by
  cases gate with
  | x target =>
      have targetNe : wire ≠ embed target := (outside target).symm
      simp [mapGateWires, evalReversibleGate, xBasisEquiv,
        xBasisAction, targetNe]
  | cx control target distinct =>
      have targetNe : wire ≠ embed target := (outside target).symm
      by_cases controlZero : state (embed control) = 0 <;>
        simp [mapGateWires, evalReversibleGate, cxBasisEquiv,
          cxBasisAction, xBasisAction, targetNe, controlZero]
  | ccx control0 control1 target c0_ne_c1 c0_ne_target c1_ne_target =>
      have targetNe : wire ≠ embed target := (outside target).symm
      by_cases active :
          state (embed control0) = 1 ∧ state (embed control1) = 1 <;>
        simp [mapGateWires, evalReversibleGate, ccxBasisEquiv,
          ccxBasisAction, xBasisAction, targetNe, active]

/-- Complete semantic refinement of one embedded program. -/
theorem readEmbeddedState_eval_mapProgramWires
    {small large : Nat}
    (embed : Fin small → Fin large)
    (injective : Function.Injective embed)
    (program : ReversibleProgram small)
    (state : PrimitiveBasis large) :
    readEmbeddedState embed
        (evalReversibleProgram
          (mapProgramWires embed injective program) state) =
      evalReversibleProgram program (readEmbeddedState embed state) := by
  induction program generalizing state with
  | nil =>
      rfl
  | cons gate rest induction =>
      change
        readEmbeddedState embed
          (evalReversibleProgram
            (mapProgramWires embed injective rest)
            (evalReversibleGate
              (mapGateWires embed injective gate) state)) =
          evalReversibleProgram rest
            (evalReversibleGate gate (readEmbeddedState embed state))
      calc
        _ = evalReversibleProgram rest
              (readEmbeddedState embed
                (evalReversibleGate
                  (mapGateWires embed injective gate) state)) :=
          induction
            (evalReversibleGate
              (mapGateWires embed injective gate) state)
        _ = evalReversibleProgram rest
              (evalReversibleGate gate
                (readEmbeddedState embed state)) := by
          rw [readEmbeddedState_eval_mapGateWires]

/-- Complete noninterference theorem for wires outside the embedded subregister. -/
theorem eval_mapProgramWires_outside
    {small large : Nat}
    (embed : Fin small → Fin large)
    (injective : Function.Injective embed)
    (program : ReversibleProgram small)
    (state : PrimitiveBasis large)
    (wire : Fin large)
    (outside : ∀ logical, embed logical ≠ wire) :
    evalReversibleProgram (mapProgramWires embed injective program) state wire =
      state wire := by
  induction program generalizing state with
  | nil =>
      rfl
  | cons gate rest induction =>
      change
        evalReversibleProgram
          (mapProgramWires embed injective rest)
          (evalReversibleGate
            (mapGateWires embed injective gate) state) wire = state wire
      calc
        _ = (evalReversibleGate
              (mapGateWires embed injective gate) state) wire :=
          induction
            (evalReversibleGate
              (mapGateWires embed injective gate) state)
        _ = state wire :=
          eval_mapGateWires_outside
            embed injective gate state wire outside

/-- Wire renaming preserves the exact number of reversible instructions. -/
@[simp] theorem mapProgramWires_length
    {small large : Nat}
    (embed : Fin small → Fin large)
    (injective : Function.Injective embed)
    (program : ReversibleProgram small) :
    (mapProgramWires embed injective program).length = program.length := by
  simp [mapProgramWires]

/-- Embedding distributes over chronological program concatenation. -/
@[simp] theorem mapProgramWires_append
    {small large : Nat}
    (embed : Fin small → Fin large)
    (injective : Function.Injective embed)
    (left right : ReversibleProgram small) :
    mapProgramWires embed injective (left ++ right) =
      mapProgramWires embed injective left ++
        mapProgramWires embed injective right := by
  simp [mapProgramWires]

end ReversibleWireEmbedding
end QuantumBlockEncoding

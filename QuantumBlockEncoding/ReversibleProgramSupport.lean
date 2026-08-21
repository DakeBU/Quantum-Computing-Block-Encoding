import QuantumBlockEncoding.ReversibleClassical
import Mathlib.Tactic

/-!
# Wire-support lemmas for reversible programs

A recurring compute/use/uncompute proof only needs local support facts.  If no
gate in a subprogram targets a named wire, that wire is unchanged.  At the gate
level, the value produced on a touched wire depends only on the values of the
wires touched by that gate.

These two facts let later proofs reason about compute/use/uncompute without
expanding the complete basis state.  They are used by the arbitrary-width
Gidney workspace-restoration induction and are reusable for SP/BE register
cleanup.
-/

namespace QuantumBlockEncoding
namespace ReversibleProgramSupport

/-- Whether a logical reversible gate writes the named wire. -/
def targetsWire {qubits : Nat}
    (gate : ReversibleGate qubits) (wire : Fin qubits) : Prop :=
  match gate with
  | .x target => target = wire
  | .cx _ target _ => target = wire
  | .ccx _ _ target _ _ _ => target = wire

/-- One gate preserves every wire it does not target. -/
theorem evalReversibleGate_apply_of_not_targets
    {qubits : Nat} (gate : ReversibleGate qubits)
    (wire : Fin qubits) (state : PrimitiveBasis qubits)
    (notTarget : ¬ targetsWire gate wire) :
    evalReversibleGate gate state wire = state wire := by
  cases gate with
  | x target =>
      have distinct : target ≠ wire := by
        simpa [targetsWire] using notTarget
      simp [evalReversibleGate, xBasisEquiv, xBasisAction, distinct]
  | cx control target distinctControl =>
      have distinct : target ≠ wire := by
        simpa [targetsWire] using notTarget
      by_cases inactive : state control = 0
      · simp [evalReversibleGate, cxBasisEquiv, cxBasisAction,
          xBasisAction, inactive, distinct]
      · simp [evalReversibleGate, cxBasisEquiv, cxBasisAction,
          xBasisAction, inactive, distinct]
  | ccx control0 control1 target c0_ne_c1 c0_ne_target c1_ne_target =>
      have distinct : target ≠ wire := by
        simpa [targetsWire] using notTarget
      by_cases active : state control0 = 1 ∧ state control1 = 1
      · simp [evalReversibleGate, ccxBasisEquiv, ccxBasisAction,
          xBasisAction, active, distinct]
      · simp [evalReversibleGate, ccxBasisEquiv, ccxBasisAction,
          xBasisAction, active]

/-- If two basis states agree on every wire touched by one gate, then applying
that gate gives the same value on every touched wire. -/
theorem evalReversibleGate_congr_on_touches
    {qubits : Nat} (gate : ReversibleGate qubits)
    (left right : PrimitiveBasis qubits)
    (agree : ∀ wire, gate.touches wire → left wire = right wire) :
    ∀ wire, gate.touches wire →
      evalReversibleGate gate left wire =
        evalReversibleGate gate right wire := by
  intro wire touched
  cases gate with
  | x target =>
      have wireEq : wire = target := by
        simpa [ReversibleGate.touches] using touched
      subst wire
      simp [evalReversibleGate, xBasisEquiv, xBasisAction,
        agree target (by simp [ReversibleGate.touches])]
  | cx control target distinct =>
      have controlAgree : left control = right control :=
        agree control (by simp [ReversibleGate.touches])
      have targetAgree : left target = right target :=
        agree target (by simp [ReversibleGate.touches])
      rcases touched with wireControl | wireTarget
      · subst wire
        by_cases inactive : left control = 0
        · have inactiveRight : right control = 0 := by
            simpa [controlAgree] using inactive
          simp [evalReversibleGate, cxBasisEquiv, cxBasisAction,
            inactive, inactiveRight, controlAgree]
        · have inactiveRight : right control ≠ 0 := by
            simpa [controlAgree] using inactive
          simp [evalReversibleGate, cxBasisEquiv, cxBasisAction,
            xBasisAction, inactive, inactiveRight, distinct,
            controlAgree]
      · subst wire
        by_cases inactive : left control = 0
        · have inactiveRight : right control = 0 := by
            simpa [controlAgree] using inactive
          simp [evalReversibleGate, cxBasisEquiv, cxBasisAction,
            inactive, inactiveRight, targetAgree]
        · have inactiveRight : right control ≠ 0 := by
            simpa [controlAgree] using inactive
          simp [evalReversibleGate, cxBasisEquiv, cxBasisAction,
            xBasisAction, inactive, inactiveRight, targetAgree]
  | ccx control0 control1 target c0_ne_c1 c0_ne_target c1_ne_target =>
      have c0Agree : left control0 = right control0 :=
        agree control0 (by simp [ReversibleGate.touches])
      have c1Agree : left control1 = right control1 :=
        agree control1 (by simp [ReversibleGate.touches])
      have targetAgree : left target = right target :=
        agree target (by simp [ReversibleGate.touches])
      rcases touched with wireC0 | wireC1 | wireTarget
      · subst wire
        by_cases active : left control0 = 1 ∧ left control1 = 1
        · have activeRight : right control0 = 1 ∧ right control1 = 1 := by
            simpa [c0Agree, c1Agree] using active
          simp [evalReversibleGate, ccxBasisEquiv, ccxBasisAction,
            xBasisAction, active, activeRight, c0_ne_target, c0Agree]
        · have activeRight : ¬(right control0 = 1 ∧ right control1 = 1) := by
            simpa [c0Agree, c1Agree] using active
          simp [evalReversibleGate, ccxBasisEquiv, ccxBasisAction,
            active, activeRight, c0Agree]
      · subst wire
        by_cases active : left control0 = 1 ∧ left control1 = 1
        · have activeRight : right control0 = 1 ∧ right control1 = 1 := by
            simpa [c0Agree, c1Agree] using active
          simp [evalReversibleGate, ccxBasisEquiv, ccxBasisAction,
            xBasisAction, active, activeRight, c1_ne_target, c1Agree]
        · have activeRight : ¬(right control0 = 1 ∧ right control1 = 1) := by
            simpa [c0Agree, c1Agree] using active
          simp [evalReversibleGate, ccxBasisEquiv, ccxBasisAction,
            active, activeRight, c1Agree]
      · subst wire
        by_cases active : left control0 = 1 ∧ left control1 = 1
        · have activeRight : right control0 = 1 ∧ right control1 = 1 := by
            simpa [c0Agree, c1Agree] using active
          simp [evalReversibleGate, ccxBasisEquiv, ccxBasisAction,
            xBasisAction, active, activeRight, targetAgree]
        · have activeRight : ¬(right control0 = 1 ∧ right control1 = 1) := by
            simpa [c0Agree, c1Agree] using active
          simp [evalReversibleGate, ccxBasisEquiv, ccxBasisAction,
            active, activeRight, targetAgree]

/-- Program-level support predicate: no gate writes the named wire. -/
def PreservesWire {qubits : Nat}
    (program : ReversibleProgram qubits) (wire : Fin qubits) : Prop :=
  ∀ gate, gate ∈ program → ¬ targetsWire gate wire

/-- A program satisfying the support predicate leaves the wire exactly
unchanged on every computational-basis state. -/
theorem evalReversibleProgram_apply_of_preservesWire
    {qubits : Nat} (program : ReversibleProgram qubits)
    (wire : Fin qubits) (state : PrimitiveBasis qubits)
    (preserves : PreservesWire program wire) :
    evalReversibleProgram program state wire = state wire := by
  induction program generalizing state with
  | nil =>
      rfl
  | cons gate rest induction =>
      change
        evalReversibleProgram rest (evalReversibleGate gate state) wire =
          state wire
      have headNotTarget : ¬ targetsWire gate wire :=
        preserves gate (by simp)
      have tailPreserves : PreservesWire rest wire := by
        intro tailGate member
        exact preserves tailGate (by simp [member])
      calc
        evalReversibleProgram rest (evalReversibleGate gate state) wire =
            evalReversibleGate gate state wire :=
          induction (evalReversibleGate gate state) tailPreserves
        _ = state wire :=
          evalReversibleGate_apply_of_not_targets
            gate wire state headNotTarget

/-- The support predicate is preserved by concatenation. -/
theorem preservesWire_append
    {qubits : Nat} (left right : ReversibleProgram qubits)
    (wire : Fin qubits)
    (leftPreserves : PreservesWire left wire)
    (rightPreserves : PreservesWire right wire) :
    PreservesWire (left ++ right) wire := by
  intro gate member
  rw [List.mem_append] at member
  rcases member with member | member
  · exact leftPreserves gate member
  · exact rightPreserves gate member

/-- Reverse order does not change the set of target wires. -/
theorem preservesWire_reverse
    {qubits : Nat} (program : ReversibleProgram qubits)
    (wire : Fin qubits)
    (preserves : PreservesWire program wire) :
    PreservesWire program.reverse wire := by
  intro gate member
  apply preserves gate
  simpa using member

end ReversibleProgramSupport
end QuantumBlockEncoding
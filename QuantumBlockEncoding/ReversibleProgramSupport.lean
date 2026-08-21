import QuantumBlockEncoding.ReversibleClassical
import Mathlib.Tactic

/-!
# Wire-support lemmas for reversible programs

A recurring compute/use/uncompute proof only needs a local fact: if no gate in a
subprogram targets a named wire, that wire is unchanged by the complete
subprogram.  Controls may read the wire arbitrarily.

This module records that support discipline once for the reversible proof IR.
It is used by the arbitrary-width Gidney workspace-restoration induction and is
also reusable for SP/BE register-cleanup proofs.
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
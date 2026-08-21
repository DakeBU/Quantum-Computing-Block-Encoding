import QuantumBlockEncoding.ReversibleClassical
import Mathlib.Tactic

/-!
# Reversible-program register lift

A recursive arithmetic construction repeatedly embeds an n-wire reversible
program into a larger register.  This module provides one reusable exact lift:
insert a fresh wire at little-endian position 0 and shift every old wire to its
`Fin.succ` position.

The semantic contract is deliberately stronger than a gate-count helper:

* the fresh head wire is preserved;
* the shifted tail evolves exactly as the original program;
* no circuit-specific reasoning is hidden in later consumers.

This node is intended to be shared by the Vandaele all-X / incrementer recursion
and later State Preparation / Block Encoding subregister constructions.
-/

namespace QuantumBlockEncoding
namespace ReversibleRegisterLift

/-- View the successor wires of an `(n+1)`-wire state as an n-wire state. -/
def tailState {n : Nat} (state : PrimitiveBasis (n + 1)) : PrimitiveBasis n :=
  fun wire => state wire.succ

/-- Shift every wire touched by a reversible gate by one position. -/
def liftGateSucc {n : Nat} :
    ReversibleGate n → ReversibleGate (n + 1)
  | .x target => .x target.succ
  | .cx control target distinct =>
      .cx control.succ target.succ (by
        intro equal
        apply distinct
        exact Fin.succ_injective equal)
  | .ccx control0 control1 target c0_ne_c1 c0_ne_target c1_ne_target =>
      .ccx control0.succ control1.succ target.succ
        (by
          intro equal
          apply c0_ne_c1
          exact Fin.succ_injective equal)
        (by
          intro equal
          apply c0_ne_target
          exact Fin.succ_injective equal)
        (by
          intro equal
          apply c1_ne_target
          exact Fin.succ_injective equal)

/-- Shift an entire reversible program to the successor wires. -/
def liftProgramSucc {n : Nat}
    (program : ReversibleProgram n) : ReversibleProgram (n + 1) :=
  program.map liftGateSucc

/-- A lifted gate cannot modify the fresh head wire. -/
theorem eval_liftGateSucc_head {n : Nat}
    (gate : ReversibleGate n) (state : PrimitiveBasis (n + 1)) :
    (evalReversibleGate (liftGateSucc gate) state) 0 = state 0 := by
  cases gate with
  | x target =>
      simp [liftGateSucc, evalReversibleGate, xBasisEquiv, xBasisAction]
  | cx control target distinct =>
      by_cases active : state control.succ = 0
      · simp [liftGateSucc, evalReversibleGate, cxBasisEquiv, cxBasisAction,
          xBasisAction, active]
      · simp [liftGateSucc, evalReversibleGate, cxBasisEquiv, cxBasisAction,
          xBasisAction, active]
  | ccx control0 control1 target c0_ne_c1 c0_ne_target c1_ne_target =>
      by_cases active : state control0.succ = 1 ∧ state control1.succ = 1
      · simp [liftGateSucc, evalReversibleGate, ccxBasisEquiv, ccxBasisAction,
          xBasisAction, active]
      · simp [liftGateSucc, evalReversibleGate, ccxBasisEquiv, ccxBasisAction,
          xBasisAction, active]

/-- The tail action of one lifted gate is exactly the original gate action. -/
theorem tailState_eval_liftGateSucc {n : Nat}
    (gate : ReversibleGate n) (state : PrimitiveBasis (n + 1)) :
    tailState (evalReversibleGate (liftGateSucc gate) state) =
      evalReversibleGate gate (tailState state) := by
  funext wire
  cases gate with
  | x target =>
      by_cases same : wire = target
      · subst wire
        simp [tailState, liftGateSucc, evalReversibleGate,
          xBasisEquiv, xBasisAction]
      · have succNe : wire.succ ≠ target.succ := by
          intro equal
          exact same (Fin.succ_injective equal)
        simp [tailState, liftGateSucc, evalReversibleGate,
          xBasisEquiv, xBasisAction, same, succNe]
  | cx control target distinct =>
      by_cases active : state control.succ = 0
      · simp [tailState, liftGateSucc, evalReversibleGate,
          cxBasisEquiv, cxBasisAction, active]
      · have tailActive : tailState state control ≠ 0 := by
          simpa [tailState] using active
        by_cases same : wire = target
        · subst wire
          simp [tailState, liftGateSucc, evalReversibleGate,
            cxBasisEquiv, cxBasisAction, xBasisAction, active, tailActive]
        · have succNe : wire.succ ≠ target.succ := by
            intro equal
            exact same (Fin.succ_injective equal)
          simp [tailState, liftGateSucc, evalReversibleGate,
            cxBasisEquiv, cxBasisAction, xBasisAction, active, tailActive,
            same, succNe]
  | ccx control0 control1 target c0_ne_c1 c0_ne_target c1_ne_target =>
      by_cases active : state control0.succ = 1 ∧ state control1.succ = 1
      · have tailActive :
            tailState state control0 = 1 ∧ tailState state control1 = 1 := by
          simpa [tailState] using active
        by_cases same : wire = target
        · subst wire
          simp [tailState, liftGateSucc, evalReversibleGate,
            ccxBasisEquiv, ccxBasisAction, xBasisAction, active, tailActive]
        · have succNe : wire.succ ≠ target.succ := by
            intro equal
            exact same (Fin.succ_injective equal)
          simp [tailState, liftGateSucc, evalReversibleGate,
            ccxBasisEquiv, ccxBasisAction, xBasisAction, active, tailActive,
            same, succNe]
      · have tailInactive :
            ¬(tailState state control0 = 1 ∧ tailState state control1 = 1) := by
          simpa [tailState] using active
        simp [tailState, liftGateSucc, evalReversibleGate,
          ccxBasisEquiv, ccxBasisAction, active, tailInactive]

/-- A lifted program preserves the fresh head wire. -/
theorem eval_liftProgramSucc_head {n : Nat}
    (program : ReversibleProgram n) (state : PrimitiveBasis (n + 1)) :
    (evalReversibleProgram (liftProgramSucc program) state) 0 = state 0 := by
  induction program generalizing state with
  | nil =>
      rfl
  | cons gate rest induction =>
      change
        (evalReversibleProgram (liftProgramSucc rest)
          (evalReversibleGate (liftGateSucc gate) state)) 0 = state 0
      calc
        _ = (evalReversibleGate (liftGateSucc gate) state) 0 :=
          induction (evalReversibleGate (liftGateSucc gate) state)
        _ = state 0 := eval_liftGateSucc_head gate state

/-- The complete tail semantics of a lifted program agrees with the original
program. -/
theorem tailState_eval_liftProgramSucc {n : Nat}
    (program : ReversibleProgram n) (state : PrimitiveBasis (n + 1)) :
    tailState (evalReversibleProgram (liftProgramSucc program) state) =
      evalReversibleProgram program (tailState state) := by
  induction program generalizing state with
  | nil =>
      rfl
  | cons gate rest induction =>
      change
        tailState
          (evalReversibleProgram (liftProgramSucc rest)
            (evalReversibleGate (liftGateSucc gate) state)) =
          evalReversibleProgram rest
            (evalReversibleGate gate (tailState state))
      calc
        _ = evalReversibleProgram rest
              (tailState (evalReversibleGate (liftGateSucc gate) state)) :=
          induction (evalReversibleGate (liftGateSucc gate) state)
        _ = evalReversibleProgram rest
              (evalReversibleGate gate (tailState state)) := by
          rw [tailState_eval_liftGateSucc]

end ReversibleRegisterLift
end QuantumBlockEncoding

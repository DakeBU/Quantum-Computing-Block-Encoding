import QuantumBlockEncoding.ComparatorIncrementerAllX
import QuantumBlockEncoding.ReversibleRegisterLift
import Mathlib.Tactic

/-!
# Controlled all-X fan-out for Vandaele Eq. (36)

The previous Vandaele layers established the inverse-by-conjugation identity
abstractly and then identified the unconstrained all-X permutation on an
arbitrary little-endian register.  This module closes the next representation
leaf: an actual reversible gate program with one external control qubit and
`n` target qubits.

The register convention is chosen to make the recursion transparent:

* target wires occupy positions `0, ..., n-1`;
* the external control is the highest wire `n`;
* when a new low target wire is inserted, the reusable
  `ReversibleRegisterLift.liftProgramSucc` shifts the previous targets and
  control together.

This is an exact semantic fan-out baseline.  It uses one logical `CX` per target
and therefore has `n` logical two-qubit gates.  It is **not yet** the paper's
log-depth controlled fan-out construction; that source-specific scheduling /
promise-gate refinement remains the next resource layer.
-/

namespace QuantumBlockEncoding
namespace ComparatorIncrementerControlledAllX

open ReversibleRegisterLift

/-- Highest wire of an `n`-target plus one-control register. -/
def controlWire (n : Nat) : Fin (n + 1) :=
  ⟨n, by omega⟩

/-- Embed one target wire below the highest control. -/
def targetWire (n : Nat) (wire : Fin n) : Fin (n + 1) :=
  ⟨wire.val, by omega⟩

@[simp] theorem controlWire_succ (n : Nat) :
    (controlWire n).succ = controlWire (n + 1) := by
  apply Fin.ext
  rfl

@[simp] theorem targetWire_zero (n : Nat) :
    targetWire (n + 1) (0 : Fin (n + 1)) = (0 : Fin (n + 2)) := by
  apply Fin.ext
  rfl

@[simp] theorem targetWire_succ (n : Nat) (wire : Fin n) :
    targetWire (n + 1) wire.succ = (targetWire n wire).succ := by
  apply Fin.ext
  rfl

/-- The new low-target `CX` used at the successor step. -/
def headControlledXGate (n : Nat) : ReversibleGate (n + 2) :=
  .cx (controlWire (n + 1)) (0 : Fin (n + 2)) (by
    intro equal
    have valueEqual := congrArg Fin.val equal
    simp [controlWire] at valueEqual)

/-- One controlled-X per target wire, with the unique control stored on the
highest wire. -/
def controlledAllXProgram : (n : Nat) → ReversibleProgram (n + 1)
  | 0 => []
  | n + 1 =>
      headControlledXGate n :: liftProgramSucc (controlledAllXProgram n)

/-- The head `CX` leaves every successor wire untouched.  This is the exact
state-level fact that lets the old controlled fan-out be reused after shifting
it by one wire. -/
theorem tailState_eval_headControlledXGate
    (n : Nat) (state : PrimitiveBasis (n + 2)) :
    tailState (evalReversibleGate (headControlledXGate n) state) =
      tailState state := by
  funext wire
  by_cases inactive : state (controlWire (n + 1)) = 0
  · simp [tailState, headControlledXGate, evalReversibleGate,
      cxBasisEquiv, cxBasisAction, inactive]
  · simp [tailState, headControlledXGate, evalReversibleGate,
      cxBasisEquiv, cxBasisAction, xBasisAction, inactive]

/-- The head gate never changes its own control. -/
theorem eval_headControlledXGate_control
    (n : Nat) (state : PrimitiveBasis (n + 2)) :
    (evalReversibleGate (headControlledXGate n) state)
        (controlWire (n + 1)) =
      state (controlWire (n + 1)) := by
  by_cases inactive : state (controlWire (n + 1)) = 0
  · simp [headControlledXGate, evalReversibleGate,
      cxBasisEquiv, cxBasisAction, inactive]
  · have control_ne_zero :
        controlWire (n + 1) ≠ (0 : Fin (n + 2)) := by
      intro equal
      have valueEqual := congrArg Fin.val equal
      simp [controlWire] at valueEqual
    simp [headControlledXGate, evalReversibleGate,
      cxBasisEquiv, cxBasisAction, xBasisAction, inactive, control_ne_zero]

/-- Exact action of the newly inserted target wire. -/
theorem eval_headControlledXGate_zero
    (n : Nat) (state : PrimitiveBasis (n + 2)) :
    (evalReversibleGate (headControlledXGate n) state) 0 =
      if state (controlWire (n + 1)) = 0 then
        state 0
      else
        flipBit (state 0) := by
  by_cases inactive : state (controlWire (n + 1)) = 0 <;>
    simp [headControlledXGate, evalReversibleGate,
      cxBasisEquiv, cxBasisAction, xBasisAction, inactive]

/-- The external control is restored exactly for every width and basis input. -/
theorem controlledAllXProgram_preserves_control
    (n : Nat) (state : PrimitiveBasis (n + 1)) :
    (evalReversibleProgram (controlledAllXProgram n) state) (controlWire n) =
      state (controlWire n) := by
  induction n generalizing state with
  | zero =>
      simp [controlledAllXProgram, evalReversibleProgram, controlWire]
  | succ n induction =>
      let first := evalReversibleGate (headControlledXGate n) state
      have tailEval :=
        tailState_eval_liftProgramSucc (controlledAllXProgram n) first
      have point := congrFun tailEval (controlWire n)
      calc
        (evalReversibleProgram (controlledAllXProgram (n + 1)) state)
            (controlWire (n + 1)) =
          (evalReversibleProgram (controlledAllXProgram n) (tailState first))
            (controlWire n) := by
              simpa [controlledAllXProgram, evalReversibleProgram,
                first, tailState, controlWire] using point
        _ = (tailState first) (controlWire n) :=
          induction (tailState first)
        _ = first (controlWire (n + 1)) := by
          simp [tailState, controlWire]
        _ = state (controlWire (n + 1)) := by
          exact eval_headControlledXGate_control n state

/-- Every target is unchanged when the external control is zero and flipped
when it is one. -/
theorem controlledAllXProgram_target_action
    (n : Nat) (state : PrimitiveBasis (n + 1)) (wire : Fin n) :
    (evalReversibleProgram (controlledAllXProgram n) state)
        (targetWire n wire) =
      if state (controlWire n) = 0 then
        state (targetWire n wire)
      else
        flipBit (state (targetWire n wire)) := by
  induction n generalizing state with
  | zero =>
      exact Fin.elim0 wire
  | succ n induction =>
      refine Fin.cases ?_ (fun oldWire => ?_) wire
      · let first := evalReversibleGate (headControlledXGate n) state
        change
          (evalReversibleProgram
              (liftProgramSucc (controlledAllXProgram n)) first) 0 =
            if state (controlWire (n + 1)) = 0 then state 0
            else flipBit (state 0)
        rw [eval_liftProgramSucc_head]
        exact eval_headControlledXGate_zero n state
      · let first := evalReversibleGate (headControlledXGate n) state
        have tailEval :=
          tailState_eval_liftProgramSucc (controlledAllXProgram n) first
        have point := congrFun tailEval (targetWire n oldWire)
        have step := induction (tailState first) oldWire
        have tailFirst := tailState_eval_headControlledXGate n state
        rw [tailFirst] at step
        calc
          (evalReversibleProgram (controlledAllXProgram (n + 1)) state)
              (targetWire (n + 1) oldWire.succ) =
            (evalReversibleProgram (controlledAllXProgram n) (tailState first))
              (targetWire n oldWire) := by
                simpa [controlledAllXProgram, evalReversibleProgram,
                  first, tailState, targetWire] using point
          _ = if state (controlWire (n + 1)) = 0 then
                state (targetWire (n + 1) oldWire.succ)
              else
                flipBit (state (targetWire (n + 1) oldWire.succ)) := by
                  simpa [tailState, controlWire, targetWire] using step

/-- A compact full-register specification assembled from the separate target and
control theorems. -/
def ControlledAllXSpec (n : Nat)
    (permutation : PrimitiveBasis (n + 1) ≃ PrimitiveBasis (n + 1)) : Prop :=
  (∀ state,
    permutation state (controlWire n) = state (controlWire n)) ∧
  (∀ state wire,
    permutation state (targetWire n wire) =
      if state (controlWire n) = 0 then state (targetWire n wire)
      else flipBit (state (targetWire n wire)))

/-- The recursive CX fan-out satisfies its exact arbitrary-width contract. -/
theorem controlledAllXProgram_correct (n : Nat) :
    ControlledAllXSpec n
      (evalReversibleProgram (controlledAllXProgram n)) := by
  constructor
  · exact controlledAllXProgram_preserves_control n
  · exact controlledAllXProgram_target_action n

/-- The semantic baseline has exactly one reversible instruction per target. -/
@[simp] theorem controlledAllXProgram_length (n : Nat) :
    (controlledAllXProgram n).length = n := by
  induction n with
  | zero =>
      rfl
  | succ n induction =>
      simp [controlledAllXProgram, liftProgramSucc, induction]

/-- Predicate used to certify that the logical fan-out contains no hidden X or
Toffoli gates. -/
def IsCx {qubits : Nat} : ReversibleGate qubits → Prop
  | .cx _ _ _ => True
  | _ => False

/-- Register lifting preserves the property of being a CX gate. -/
theorem IsCx.liftGateSucc {n : Nat} (gate : ReversibleGate n)
    (isCx : IsCx gate) : IsCx (liftGateSucc gate) := by
  cases gate <;> simp [IsCx, liftGateSucc] at isCx ⊢

/-- Every instruction in the semantic fan-out baseline is exactly a CX. -/
theorem controlledAllXProgram_gate_isCx
    (n : Nat) (gate : ReversibleGate (n + 1))
    (member : gate ∈ controlledAllXProgram n) : IsCx gate := by
  induction n with
  | zero =>
      simp [controlledAllXProgram] at member
  | succ n induction =>
      simp only [controlledAllXProgram, List.mem_cons, liftProgramSucc,
        List.mem_map] at member
      rcases member with head | ⟨oldGate, oldMember, lifted⟩
      · subst gate
        simp [headControlledXGate, IsCx]
      · subst gate
        exact IsCx.liftGateSucc oldGate (induction oldGate oldMember)

end ComparatorIncrementerControlledAllX
end QuantumBlockEncoding

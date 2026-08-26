import QuantumBlockEncoding.VandaeleFigure4TakahashiSourceProgram
import QuantumBlockEncoding.VandaeleFigure4TakahashiCarryAlgebra
import Mathlib.Tactic

/-!
# Local gate semantics for the Takahashi ADD5 source behind Vandaele Figure 4

This is the refinement node between the authoritative six-step gate list and
the pure carry algebra.  The proof deliberately follows the source algorithm
step by step instead of evaluating all `2^11` basis states at once.

The intermediate states expose the exact proof idea:

1. precompute `a_i XOR b_i` for `i>0`;
2. form the descending prefix XORs on the `A` wires;
3. sweep carries upward using the TTK majority identity;
4. write each sum-side carry and immediately uncompute the temporary carry;
5. restore the `A` register;
6. XOR the restored `A` bits into `B` to obtain the final sum.

Each source step is proved by local CX/CCX semantics plus the Boolean lemmas in
`VandaeleFigure4TakahashiCarryAlgebra`.  No global truth-table proof over
function-valued reversible states is used.
-/

namespace QuantumBlockEncoding
namespace VandaeleFigure4TakahashiStepSemantics

open VandaeleFigure4TakahashiSourceProgram
open VandaeleFigure4TakahashiCarryAlgebra

/-- CX as a scalar XOR update of exactly one target wire. -/
def cxUpdate {qubits : Nat} (control target : Fin qubits)
    (state : PrimitiveBasis qubits) : PrimitiveBasis qubits :=
  Function.update state target (xorBit (state control) (state target))

/-- Toffoli as a scalar `(control0 AND control1) XOR target` update. -/
def ccxUpdate {qubits : Nat} (control0 control1 target : Fin qubits)
    (state : PrimitiveBasis qubits) : PrimitiveBasis qubits :=
  Function.update state target
    (xorBit (andBit (state control0) (state control1)) (state target))

/-- Exact bridge from the repository's reversible CX evaluator to scalar XOR. -/
theorem evalReversibleGate_cx_eq_update
    {qubits : Nat} (control target : Fin qubits)
    (distinct : control ≠ target) (state : PrimitiveBasis qubits) :
    evalReversibleGate (.cx control target distinct) state =
      cxUpdate control target state := by
  funext wire
  by_cases same : wire = target
  · subst wire
    by_cases controlZero : state control = 0
    · simp [evalReversibleGate, cxBasisEquiv, cxBasisAction,
        cxUpdate, xorBit, controlZero]
    · simp [evalReversibleGate, cxBasisEquiv, cxBasisAction,
        cxUpdate, xorBit, xBasisAction, controlZero]
  · by_cases controlZero : state control = 0
    · simp [evalReversibleGate, cxBasisEquiv, cxBasisAction,
        cxUpdate, xorBit, controlZero, same]
    · simp [evalReversibleGate, cxBasisEquiv, cxBasisAction,
        cxUpdate, xorBit, xBasisAction, controlZero, same]

/-- Exact bridge from the repository's reversible Toffoli evaluator to scalar
AND/XOR. -/
theorem evalReversibleGate_ccx_eq_update
    {qubits : Nat} (control0 control1 target : Fin qubits)
    (c0_ne_c1 : control0 ≠ control1)
    (c0_ne_target : control0 ≠ target)
    (c1_ne_target : control1 ≠ target)
    (state : PrimitiveBasis qubits) :
    evalReversibleGate
        (.ccx control0 control1 target c0_ne_c1 c0_ne_target c1_ne_target)
        state =
      ccxUpdate control0 control1 target state := by
  funext wire
  by_cases same : wire = target
  · subst wire
    by_cases active : state control0 = 1 ∧ state control1 = 1
    · simp [evalReversibleGate, ccxBasisEquiv, ccxBasisAction,
        ccxUpdate, andBit, xorBit, xBasisAction, active]
    · simp [evalReversibleGate, ccxBasisEquiv, ccxBasisAction,
        ccxUpdate, andBit, xorBit, active]
  · by_cases active : state control0 = 1 ∧ state control1 = 1
    · simp [evalReversibleGate, ccxBasisEquiv, ccxBasisAction,
        ccxUpdate, andBit, xorBit, xBasisAction, active, same]
    · simp [evalReversibleGate, ccxBasisEquiv, ccxBasisAction,
        ccxUpdate, andBit, xorBit, active, same]

/-- Lowest-bit carry is the ordinary AND because its incoming carry is zero. -/
theorem leastCarry_eq_and (a b : Fin 2) :
    c1 a b = andBit a b := by
  fin_cases a <;> fin_cases b <;> rfl

/-- The special final Toffoli of the descending sweep removes the least carry. -/
theorem leastCarry_uncompute (a b next : Fin 2) :
    xorBit (andBit a b) (xorBit (c1 a b) next) = next := by
  fin_cases a <;> fin_cases b <;> fin_cases next <;> rfl

/-- State after TTK Step 1. -/
def afterStep1
    (a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 z : Fin 2) : SourceBasis :=
  sourceState
    a0 b0
    a1 (xorBit a1 b1)
    a2 (xorBit a2 b2)
    a3 (xorBit a3 b3)
    a4 (xorBit a4 b4)
    z

/-- State after TTK Step 2. -/
def afterStep2
    (a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 z : Fin 2) : SourceBasis :=
  sourceState
    a0 b0
    a1 (xorBit a1 b1)
    (xorBit a1 a2) (xorBit a2 b2)
    (xorBit a2 a3) (xorBit a3 b3)
    (xorBit a3 a4) (xorBit a4 b4)
    (xorBit a4 z)

/-- State after the ascending carry sweep, TTK Step 3. -/
def afterStep3
    (a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 z : Fin 2) : SourceBasis :=
  sourceState
    a0 b0
    (xorBit (c1 a0 b0) a1) (xorBit a1 b1)
    (xorBit (c2 a0 b0 a1 b1) a2) (xorBit a2 b2)
    (xorBit (c3 a0 b0 a1 b1 a2 b2) a3) (xorBit a3 b3)
    (xorBit (c4 a0 b0 a1 b1 a2 b2 a3 b3) a4) (xorBit a4 b4)
    (xorBit (c5 a0 b0 a1 b1 a2 b2 a3 b3 a4 b4) z)

/-- State after the descending sum/carry-uncompute sweep, TTK Step 4. -/
def afterStep4
    (a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 z : Fin 2) : SourceBasis :=
  sourceState
    a0 b0
    a1 (xorBit (c1 a0 b0) b1)
    (xorBit a1 a2) (xorBit (c2 a0 b0 a1 b1) b2)
    (xorBit a2 a3) (xorBit (c3 a0 b0 a1 b1 a2 b2) b3)
    (xorBit a3 a4) (xorBit (c4 a0 b0 a1 b1 a2 b2 a3 b3) b4)
    (xorBit (c5 a0 b0 a1 b1 a2 b2 a3 b3 a4 b4) z)

/-- State after restoration of the `A` register, TTK Step 5. -/
def afterStep5
    (a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 z : Fin 2) : SourceBasis :=
  sourceState
    a0 b0
    a1 (xorBit (c1 a0 b0) b1)
    a2 (xorBit (c2 a0 b0 a1 b1) b2)
    a3 (xorBit (c3 a0 b0 a1 b1 a2 b2) b3)
    a4 (xorBit (c4 a0 b0 a1 b1 a2 b2 a3 b3) b4)
    (xorBit (c5 a0 b0 a1 b1 a2 b2 a3 b3 a4 b4) z)

/-- Final source state after TTK Step 6. -/
def finalState
    (a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 z : Fin 2) : SourceBasis :=
  sourceState
    a0 (s0 a0 b0)
    a1 (s1 a0 b0 a1 b1)
    a2 (s2 a0 b0 a1 b1 a2 b2)
    a3 (s3 a0 b0 a1 b1 a2 b2 a3 b3)
    a4 (s4 a0 b0 a1 b1 a2 b2 a3 b3 a4 b4)
    (xorBit (c5 a0 b0 a1 b1 a2 b2 a3 b3 a4 b4) z)

/-- TTK Step 1 is exactly the four independent pre-sum CNOTs. -/
theorem step1_semantics
    (a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 z : Fin 2) :
    evalReversibleProgram step1
        (sourceState a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 z) =
      afterStep1 a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 z := by
  funext wire
  fin_cases wire <;>
    simp [step1, evalReversibleProgram, evalReversibleGate_cx_eq_update,
      cxUpdate, sourceState, afterStep1]

/-- TTK Step 2 is the descending `A_i -> A_{i+1}` CNOT ladder. -/
theorem step2_semantics
    (a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 z : Fin 2) :
    evalReversibleProgram step2
        (afterStep1 a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 z) =
      afterStep2 a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 z := by
  funext wire
  fin_cases wire <;>
    simp [step2, evalReversibleProgram, evalReversibleGate_cx_eq_update,
      cxUpdate, sourceState, afterStep1, afterStep2]

/-- TTK Step 3 propagates carries upward. -/
theorem step3_semantics
    (a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 z : Fin 2) :
    evalReversibleProgram step3
        (afterStep2 a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 z) =
      afterStep3 a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 z := by
  funext wire
  fin_cases wire <;>
    simp [step3, evalReversibleProgram, evalReversibleGate_ccx_eq_update,
      ccxUpdate, sourceState, afterStep2, afterStep3,
      leastCarry_eq_and, c2, c3, c4, c5,
      forwardCarry_identity]

/-- TTK Step 4 writes the carry contribution into each `B_i` and uncomputes
the temporary carry in the corresponding `A_i`. -/
theorem step4_semantics
    (a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 z : Fin 2) :
    evalReversibleProgram step4
        (afterStep3 a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 z) =
      afterStep4 a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 z := by
  funext wire
  fin_cases wire <;>
    simp [step4, evalReversibleProgram,
      evalReversibleGate_cx_eq_update, evalReversibleGate_ccx_eq_update,
      cxUpdate, ccxUpdate, sourceState, afterStep3, afterStep4,
      c2, c3, c4, c5, uncomputeCarry_identity, leastCarry_uncompute]

/-- TTK Step 5 restores all higher `A` wires. -/
theorem step5_semantics
    (a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 z : Fin 2) :
    evalReversibleProgram step5
        (afterStep4 a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 z) =
      afterStep5 a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 z := by
  funext wire
  fin_cases wire <;>
    simp [step5, evalReversibleProgram, evalReversibleGate_cx_eq_update,
      cxUpdate, sourceState, afterStep4, afterStep5]

/-- TTK Step 6 writes the final sum bits into the `B` register. -/
theorem step6_semantics
    (a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 z : Fin 2) :
    evalReversibleProgram step6
        (afterStep5 a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 z) =
      finalState a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 z := by
  funext wire
  fin_cases wire <;>
    simp [step6, evalReversibleProgram, evalReversibleGate_cx_eq_update,
      cxUpdate, sourceState, afterStep5, finalState,
      s0, s1, s2, s3, s4, sumBit]

/-- Composition theorem: the exact 29-gate TTK source program implements the
explicit carry/sum final state. -/
theorem sourceProgram_finalState
    (a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 z : Fin 2) :
    evalReversibleProgram sourceProgram
        (sourceState a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 z) =
      finalState a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 z := by
  simp only [sourceProgram, evalReversibleProgram_append]
  change
    evalReversibleProgram step6
      (evalReversibleProgram step5
        (evalReversibleProgram step4
          (evalReversibleProgram step3
            (evalReversibleProgram step2
              (evalReversibleProgram step1
                (sourceState a0 b0 a1 b1 a2 b2 a3 b3 a4 b4 z)))))) = _
  rw [step1_semantics, step2_semantics, step3_semantics,
    step4_semantics, step5_semantics, step6_semantics]

end VandaeleFigure4TakahashiStepSemantics
end QuantumBlockEncoding

import QuantumBlockEncoding.PrimitiveMacros
import Mathlib.Tactic

/-!
# Comparator and incrementer arithmetic kernel

This module connects ASPBE's reversible-classical proof IR to the exact
`{X, RY, RZ, CX}` primitive semantics.  It deliberately separates three claims:

1. exact basis-permutation semantics of a reversible program;
2. exact refinement to the existing primitive CCX compiler;
3. finite resource accounting of that same compiled program.

The fixed 3-bit incrementer and `< 3` comparator below are reusable finite
certificates and teaching/memory-card anchors.  They do **not** claim the full
arbitrary-width constructions or asymptotic optimality theorem of
arXiv:2603.12917.
-/

namespace QuantumBlockEncoding
namespace ComparatorIncrementer

open Robin.ComplexLCU

/-! ## Exact compiler from the reversible proof IR -/

def primitiveXProgram {qubits : Nat} (target : Fin qubits) :
    PrimitiveProgram qubits where
  circuit := [.x target]
  globalPhase := .rational 0

@[simp] theorem primitiveXProgram_eval {qubits : Nat} (target : Fin qubits) :
    evalPrimitiveProgram (primitiveXProgram target) =
      equivPermutationMatrix (xBasisEquiv target) := by
  simp [primitiveXProgram, evalPrimitiveProgram, evalGlobalPhase,
    ExactAngle.eval, evalPrimitiveCircuit, evalPrimitiveGate]

theorem phasePermutationMatrix_one_eq_equivPermutationMatrix
    {index : Type*} [Fintype index] [DecidableEq index]
    (equiv : index ≃ index) :
    phasePermutationMatrix (fun _ => 1) equiv =
      equivPermutationMatrix equiv := by
  ext row column
  simp [phasePermutationMatrix, equivPermutationMatrix]

@[simp] theorem primitiveCxProgram_eval_equiv {qubits : Nat}
    (control target : Fin qubits) (distinct : control ≠ target) :
    evalPrimitiveProgram (primitiveCxProgram control target distinct) =
      equivPermutationMatrix (cxBasisEquiv control target distinct) := by
  rw [primitiveCxProgram_eval,
    phasePermutationMatrix_one_eq_equivPermutationMatrix]

noncomputable def compileReversibleGate {qubits : Nat} :
    ReversibleGate qubits → PrimitiveProgram qubits
  | .x target => primitiveXProgram target
  | .cx control target distinct => primitiveCxProgram control target distinct
  | .ccx control0 control1 target c0_ne_c1 c0_ne_target c1_ne_target =>
      primitiveCCXProgram control0 control1 target c0_ne_c1
        c0_ne_target c1_ne_target

@[simp] theorem compileReversibleGate_eval {qubits : Nat}
    (gate : ReversibleGate qubits) :
    evalPrimitiveProgram (compileReversibleGate gate) =
      equivPermutationMatrix (evalReversibleGate gate) := by
  cases gate with
  | x target => exact primitiveXProgram_eval target
  | cx control target distinct =>
      exact primitiveCxProgram_eval_equiv control target distinct
  | ccx control0 control1 target c0_ne_c1 c0_ne_target c1_ne_target =>
      exact primitiveCCXProgram_eval control0 control1 target c0_ne_c1
        c0_ne_target c1_ne_target

noncomputable def compileReversibleProgram {qubits : Nat} :
    ReversibleProgram qubits → PrimitiveProgram qubits
  | [] => PrimitiveProgram.identity qubits
  | gate :: rest =>
      (compileReversibleGate gate).seq (compileReversibleProgram rest)

theorem compileReversibleProgram_eval {qubits : Nat}
    (program : ReversibleProgram qubits) :
    evalPrimitiveProgram (compileReversibleProgram program) =
      equivPermutationMatrix (evalReversibleProgram program) := by
  induction program with
  | nil =>
      simp [compileReversibleProgram, evalReversibleProgram,
        equivPermutationMatrix]
  | cons gate rest induction =>
      change evalPrimitiveProgram
          ((compileReversibleGate gate).seq
            (compileReversibleProgram rest)) =
        equivPermutationMatrix
          ((evalReversibleGate gate).trans (evalReversibleProgram rest))
      rw [evalPrimitiveProgram_seq, compileReversibleGate_eval, induction,
        equivPermutationMatrix_mul]

/-! ## Resource accounting derived from the compiled circuit -/

namespace ReversibleGate

def xCount {qubits : Nat} : ReversibleGate qubits → Nat
  | .x _ => 1
  | _ => 0

def cxCount {qubits : Nat} : ReversibleGate qubits → Nat
  | .cx _ _ _ => 1
  | _ => 0

def toffoliCount {qubits : Nat} : ReversibleGate qubits → Nat
  | .ccx _ _ _ _ _ _ => 1
  | _ => 0
end ReversibleGate

namespace ReversibleProgram

def xCount {qubits : Nat} (program : ReversibleProgram qubits) : Nat :=
  program.foldl (fun total gate => total + gate.xCount) 0

def cxCount {qubits : Nat} (program : ReversibleProgram qubits) : Nat :=
  program.foldl (fun total gate => total + gate.cxCount) 0

def toffoliCount {qubits : Nat} (program : ReversibleProgram qubits) : Nat :=
  program.foldl (fun total gate => total + gate.toffoliCount) 0
end ReversibleProgram

namespace PrimitiveGate
/-- Count physical `T`/`T†` quarter-phase rotations in ASPBE's exact primitive
compiler.  The `RZ(π)` appearing inside the exact H macro is not counted. -/
def tCount {qubits : Nat} : PrimitiveGate qubits → Nat
  | .rz _ (.piRational angle) =>
      if angle = (1 / 4 : Rat) ∨ angle = (-1 / 4 : Rat) then 1 else 0
  | _ => 0
end PrimitiveGate

namespace PrimitiveCircuit
def tCount {qubits : Nat} (circuit : PrimitiveCircuit qubits) : Nat :=
  circuit.foldl (fun total gate => total + gate.tCount) 0
end PrimitiveCircuit

structure CompilationCost where
  logicalX : Nat
  logicalCnot : Nat
  logicalToffoli : Nat
  tCount : Nat
  primitiveOneQubit : Nat
  primitiveCnot : Nat
  primitiveDepth : Nat
  cleanAncillas : Nat
deriving Repr, DecidableEq

noncomputable def compilationCost {qubits : Nat}
    (program : ReversibleProgram qubits) (cleanAncillas : Nat := 0) :
    CompilationCost :=
  let compiled := compileReversibleProgram program
  {
    logicalX := program.xCount
    logicalCnot := program.cxCount
    logicalToffoli := program.toffoliCount
    tCount := compiled.circuit.tCount
    primitiveOneQubit := compiled.resource.oneQubit
    primitiveCnot := compiled.resource.cnot
    primitiveDepth := compiled.resource.depth
    cleanAncillas := cleanAncillas
  }

/-! ## Fixed three-bit incrementer -/

/-- Little-endian `x ↦ x+1 mod 8`: first carry to bit 2, then bit 1, then bit 0. -/
def incrementer3Program : ReversibleProgram 3 :=
  [
    .ccx 0 1 2 (by decide) (by decide) (by decide),
    .cx 0 1 (by decide),
    .x 0
  ]

def incrementer3Expected (state : PrimitiveBasis 3) : PrimitiveBasis 3 :=
  fun wire =>
    match wire.val with
    | 0 => flipBit (state 0)
    | 1 => if state 0 = 1 then flipBit (state 1) else state 1
    | _ =>
        if state 0 = 1 ∧ state 1 = 1 then flipBit (state 2) else state 2

/-- Exact ripple-carry basis action of the finite incrementer. -/
theorem incrementer3_action (state : PrimitiveBasis 3) :
    evalReversibleProgram incrementer3Program state =
      incrementer3Expected state := by
  have bitCases (bit : Fin 2) : bit = 0 ∨ bit = 1 := by
    fin_cases bit <;> simp
  rcases bitCases (state 0) with h0 | h0 <;>
    rcases bitCases (state 1) with h1 | h1 <;>
    rcases bitCases (state 2) with h2 | h2
  all_goals
    funext wire
    fin_cases wire <;>
      simp [incrementer3Program, incrementer3Expected, evalReversibleProgram,
        evalReversibleGate, ccxBasisEquiv, ccxBasisAction, cxBasisEquiv,
        cxBasisAction, xBasisEquiv, xBasisAction, flipBit, h0, h1, h2]

noncomputable def incrementer3Primitive : PrimitiveProgram 3 :=
  compileReversibleProgram incrementer3Program

/-- The exact primitive circuit refines the incrementer's proved permutation. -/
theorem incrementer3Primitive_exact :
    evalPrimitiveProgram incrementer3Primitive =
      equivPermutationMatrix (evalReversibleProgram incrementer3Program) := by
  exact compileReversibleProgram_eval incrementer3Program

/-- Exact finite cost of the same compiled incrementer circuit.  `T=7` is the
cost of the repository's standard exact CCX decomposition, not an asymptotic
optimality claim. -/
theorem incrementer3_compilationCost :
    compilationCost incrementer3Program =
      {
        logicalX := 1,
        logicalCnot := 1,
        logicalToffoli := 1,
        tCount := 7,
        primitiveOneQubit := 12,
        primitiveCnot := 7,
        primitiveDepth := 14,
        cleanAncillas := 0
      } := by
  decide

/-! ## Fixed two-bit comparator `address < 3` -/

/-- Wires 0 and 1 hold a two-bit address; wire 2 is the predicate flag.
The program toggles the flag exactly for addresses 0, 1, and 2. -/
def comparatorLtThreeProgram : ReversibleProgram 3 :=
  [
    .x 2,
    .ccx 0 1 2 (by decide) (by decide) (by decide)
  ]

def comparatorLtThreeExpected (state : PrimitiveBasis 3) : PrimitiveBasis 3 :=
  if state 0 = 1 ∧ state 1 = 1 then state else xBasisAction 2 state

/-- Exact comparator permutation, valid for an arbitrary incoming flag. -/
theorem comparatorLtThree_action (state : PrimitiveBasis 3) :
    evalReversibleProgram comparatorLtThreeProgram state =
      comparatorLtThreeExpected state := by
  have bitCases (bit : Fin 2) : bit = 0 ∨ bit = 1 := by
    fin_cases bit <;> simp
  rcases bitCases (state 0) with h0 | h0 <;>
    rcases bitCases (state 1) with h1 | h1 <;>
    rcases bitCases (state 2) with h2 | h2
  all_goals
    funext wire
    fin_cases wire <;>
      simp [comparatorLtThreeProgram, comparatorLtThreeExpected,
        evalReversibleProgram, evalReversibleGate, ccxBasisEquiv,
        ccxBasisAction, xBasisEquiv, xBasisAction, flipBit, h0, h1, h2]

/-- On a clean flag, the comparator writes precisely `[address < 3]`. -/
theorem comparatorLtThree_cleanFlag (state : PrimitiveBasis 3)
    (clean : state 2 = 0) :
    (evalReversibleProgram comparatorLtThreeProgram state) 2 =
      if state 0 = 1 ∧ state 1 = 1 then 0 else 1 := by
  rw [comparatorLtThree_action]
  simp [comparatorLtThreeExpected, xBasisAction, clean, flipBit]

noncomputable def comparatorLtThreePrimitive : PrimitiveProgram 3 :=
  compileReversibleProgram comparatorLtThreeProgram

theorem comparatorLtThreePrimitive_exact :
    evalPrimitiveProgram comparatorLtThreePrimitive =
      equivPermutationMatrix
        (evalReversibleProgram comparatorLtThreeProgram) := by
  exact compileReversibleProgram_eval comparatorLtThreeProgram

theorem comparatorLtThree_compilationCost :
    compilationCost comparatorLtThreeProgram =
      {
        logicalX := 1,
        logicalCnot := 0,
        logicalToffoli := 1,
        tCount := 7,
        primitiveOneQubit := 12,
        primitiveCnot := 6,
        primitiveDepth := 13,
        cleanAncillas := 0
      } := by
  decide

/-! ## Clean interval selector for the first interval-tree State Preparation route -/

/-- Four-wire compute/use/uncompute circuit.  Wires 0,1 are the address, wire 2
is a clean work flag, and wire 3 is the selected target bit. -/
def intervalLtThreeSelectProgram : ReversibleProgram 4 :=
  [
    .x 2,
    .ccx 0 1 2 (by decide) (by decide) (by decide),
    .cx 2 3 (by decide),
    .ccx 0 1 2 (by decide) (by decide) (by decide),
    .x 2
  ]

/-- The work flag is restored for every basis input, even though the selected
target has the intended predicate meaning only on the declared clean branch. -/
theorem intervalLtThreeSelect_restoresFlag (state : PrimitiveBasis 4) :
    (evalReversibleProgram intervalLtThreeSelectProgram state) 2 = state 2 := by
  have bitCases (bit : Fin 2) : bit = 0 ∨ bit = 1 := by
    fin_cases bit <;> simp
  rcases bitCases (state 0) with h0 | h0 <;>
    rcases bitCases (state 1) with h1 | h1 <;>
    rcases bitCases (state 2) with h2 | h2 <;>
    rcases bitCases (state 3) with h3 | h3
  all_goals
    simp [intervalLtThreeSelectProgram, evalReversibleProgram,
      evalReversibleGate, ccxBasisEquiv, ccxBasisAction, cxBasisEquiv,
      cxBasisAction, xBasisEquiv, xBasisAction, flipBit, h0, h1, h2, h3]

/-- On a clean work flag, the target is toggled exactly for the interval
`address ∈ {0,1,2}`, and the work flag is returned to zero. -/
theorem intervalLtThreeSelect_clean_action (state : PrimitiveBasis 4)
    (clean : state 2 = 0) :
    evalReversibleProgram intervalLtThreeSelectProgram state =
      if state 0 = 1 ∧ state 1 = 1 then state else xBasisAction 3 state := by
  have bitCases (bit : Fin 2) : bit = 0 ∨ bit = 1 := by
    fin_cases bit <;> simp
  rcases bitCases (state 0) with h0 | h0 <;>
    rcases bitCases (state 1) with h1 | h1 <;>
    rcases bitCases (state 2) with h2 | h2 <;>
    rcases bitCases (state 3) with h3 | h3
  all_goals
    funext wire
    fin_cases wire <;>
      simp [intervalLtThreeSelectProgram, evalReversibleProgram,
        evalReversibleGate, ccxBasisEquiv, ccxBasisAction, cxBasisEquiv,
        cxBasisAction, xBasisEquiv, xBasisAction, flipBit, clean,
        h0, h1, h2, h3]

noncomputable def intervalLtThreeSelectPrimitive : PrimitiveProgram 4 :=
  compileReversibleProgram intervalLtThreeSelectProgram

theorem intervalLtThreeSelectPrimitive_exact :
    evalPrimitiveProgram intervalLtThreeSelectPrimitive =
      equivPermutationMatrix
        (evalReversibleProgram intervalLtThreeSelectProgram) := by
  exact compileReversibleProgram_eval intervalLtThreeSelectProgram

/-- The interval selector uses one declared clean work bit.  The primitive
resource fields are derived from the exact compute/use/uncompute circuit. -/
theorem intervalLtThreeSelect_compilationCost :
    compilationCost intervalLtThreeSelectProgram 1 =
      {
        logicalX := 2,
        logicalCnot := 1,
        logicalToffoli := 2,
        tCount := 14,
        primitiveOneQubit := 24,
        primitiveCnot := 13,
        primitiveDepth := 27,
        cleanAncillas := 1
      } := by
  decide

end ComparatorIncrementer
end QuantumBlockEncoding

import QuantumBlockEncoding.QuantumQueryWord
import QuantumBlockEncoding.PrimitiveSemantics

namespace QuantumBlockEncoding.QueryCircuitCost

inductive Instruction (n : ℕ)
  | known (circuit : PrimitiveCircuit n)
  | forward
  | inverse

abbrev Word (n : ℕ) := List (Instruction n)

def Instruction.expand {n : ℕ} (g : Instruction n) (oracle : PrimitiveCircuit n) :
    PrimitiveCircuit n :=
  match g with
  | .known c => c
  | .forward => oracle
  | .inverse => oracle.reverse.map PrimitiveGate.dagger

noncomputable def Instruction.erase {n : ℕ} (g : Instruction n) :
    QuantumQueryWord.Instruction (PrimitiveBasis n) :=
  match g with
  | .known c => .known ⟨evalPrimitiveCircuit c, evalPrimitiveCircuit_unitary c⟩
  | .forward => .forward
  | .inverse => .inverse

def Instruction.knownGates {n : ℕ} : Instruction n → ℕ
  | .known c => c.length
  | _ => 0

def expand {n : ℕ} (w : Word n) (oracle : PrimitiveCircuit n) : PrimitiveCircuit n :=
  w.flatMap fun g => g.expand oracle

noncomputable def erase {n : ℕ} (w : Word n) : QuantumQueryWord.Word (PrimitiveBasis n) :=
  w.map Instruction.erase

def knownGates {n : ℕ} (w : Word n) : ℕ := (w.map Instruction.knownGates).sum

/-- Known primitive gates and both oracle directions have explicit realization costs. -/
theorem expanded_length {n : ℕ} (w : Word n) (oracle : PrimitiveCircuit n) :
    (expand w oracle).length = knownGates w +
      QuantumQueryWord.queryCount (erase w) * oracle.length := by
  induction w with
  | nil => simp [expand, knownGates, erase, QuantumQueryWord.queryCount]
  | cons g rest ih =>
    cases g <;> simp [expand, knownGates, erase, Instruction.expand,
      Instruction.erase, Instruction.knownGates, QuantumQueryWord.queryCount,
      QuantumQueryWord.Instruction.queryCost, Nat.add_mul] at * <;> omega

/-- The charged realization executes the same chronological unitary word. -/
theorem expanded_semantics {n : ℕ} (w : Word n) (oracle : PrimitiveCircuit n) :
    evalPrimitiveCircuit (expand w oracle) =
      QuantumQueryWord.eval (erase w) (evalPrimitiveCircuit oracle) := by
  induction w with
  | nil => simp [expand, erase, evalPrimitiveCircuit, QuantumQueryWord.eval]
  | cons g rest ih =>
    simp only [expand, List.flatMap_cons, evalPrimitiveCircuit_append] at *
    rw [ih]
    cases g <;> simp only [erase, List.map_cons, Instruction.expand, Instruction.erase,
      QuantumQueryWord.eval, QuantumQueryWord.Instruction.eval,
      evalPrimitiveCircuit_dagger]

end QuantumBlockEncoding.QueryCircuitCost

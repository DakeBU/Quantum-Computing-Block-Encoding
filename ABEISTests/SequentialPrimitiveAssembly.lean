import QuantumBlockEncoding.SequentialPrimitiveAssembly

open QuantumBlockEncoding QuantumBlockEncoding.SequentialPrimitiveAssembly

example (q n : Nat) (stages : Nat → PrimitiveCircuit (q + 1))
    (a b : PrimitiveBasis q) (x : PrimitiveBasis n) :
    evalPrimitiveCircuit (assemble q stages n)
        (Fin.append b x) (Fin.append a (fun _ => 0)) =
      SequentialBondPreparation.run (fun t => SequentialBondPreparation.circuitStage (stages t))
        (SequentialBondPreparation.basisBoundary a) n (x, b) :=
  assemble_clean_column q stages n a b x

-- No bond register is also allowed; the stage acts on the fresh bit.
example (t : Nat) : stageWires 0 t (Fin.castAdd t (Fin.last 0)) = Fin.last (0 + t) :=
  stageWires_fresh 0 t

-- Nontrivial placement: the fresh local wire moves past three passive bits.
example : stageWires 2 3 2 = 5 := by decide
example : stageWires 2 3 3 = 2 := by decide
example : stageWires 2 3 4 = 3 := by decide
example : stageWires 2 3 5 = 4 := by decide
example : stageWires 2 3 1 = 1 := by decide

-- A repeated two-instruction stage gives one of each primitive per emitted bit.
def twoGateStage (angle : ExactAngle) : PrimitiveCircuit 2 :=
  [.ry 1 angle, .cx 0 1 (by decide)]

example (angle : ExactAngle) (n : Nat) : (assemble 1 (fun _ => twoGateStage angle) n).ryCount = n := by
  rw [assemble_ryCount]
  simp [twoGateStage, PrimitiveCircuit.ryCount]

example (angle : ExactAngle) (n : Nat) : (assemble 1 (fun _ => twoGateStage angle) n).cxCount = n := by
  rw [assemble_cxCount]
  simp [twoGateStage, PrimitiveCircuit.cxCount]

example (q : Nat) (stages : Nat → PrimitiveCircuit (q + 1)) :
    assemble q stages 0 = [] := rfl

#print axioms eval_assemble
#print axioms assemble_clean_column
#print axioms assemble_ryCount
#print axioms assemble_cxCount

example : outputWires 2 3 0 = 3 := by decide
example : outputWires 2 3 1 = 4 := by decide
example : outputWires 2 3 2 = 2 := by decide
example : outputWires 2 3 3 = 1 := by decide
example : outputWires 2 3 4 = 0 := by decide

#print axioms withInitial_column
#print axioms withInitial_primitive_bound
#print axioms publicCircuit_column

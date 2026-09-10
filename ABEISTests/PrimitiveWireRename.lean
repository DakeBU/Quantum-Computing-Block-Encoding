import QuantumBlockEncoding.PrimitiveWireRename

open QuantumBlockEncoding

example {n : Nat} (e : Fin n ≃ Fin n) (c : PrimitiveCircuit n) :
    evalPrimitiveCircuit (PrimitiveWireRename.circuit e c) =
      PrimitiveWireRename.matrix e (evalPrimitiveCircuit c) :=
  PrimitiveWireRename.eval_circuit e c

example (a : ExactAngle) :
    PrimitiveWireRename.gate (Equiv.swap (0 : Fin 3) 2) (.ry 0 a) = .ry 2 a := by
  simp [PrimitiveWireRename.gate]

example {n : Nat} (e : Fin n ≃ Fin n) (c : PrimitiveCircuit n) :
    (PrimitiveWireRename.circuit e c).ryCount = c.ryCount ∧
    (PrimitiveWireRename.circuit e c).cxCount = c.cxCount := by simp

#print axioms PrimitiveWireRename.eval_circuit

import QuantumBlockEncoding.PrimitiveSemantics

/-!
# Primitive-refinement acceptance boundary

This module deliberately keeps executable screening separate from proof
authority.  A numerical report may prioritize a circuit, but only an exact
`PrimitiveRefinement` equality can promote it to the T3 semantic tier.
-/

namespace QuantumBlockEncoding

/-- Exact refinement for a primitive program, including its declared global
phase. This is the acceptance record used by phase-sensitive macro compilers. -/
structure PrimitiveProgramRefinement (qubits : Nat) where
  program : PrimitiveProgram qubits
  target : _root_.Matrix (PrimitiveBasis qubits) (PrimitiveBasis qubits) ℂ
  exact : evalPrimitiveProgram program = target

def PrimitiveProgramRefinement.resource {qubits : Nat}
    (refinement : PrimitiveProgramRefinement qubits) : Resource :=
  refinement.program.resource

theorem PrimitiveProgramRefinement.oracleCalls_eq_zero {qubits : Nat}
    (refinement : PrimitiveProgramRefinement qubits) :
    refinement.resource.oracleCalls = 0 := by
  exact PrimitiveCircuit.resource_oracleCalls_eq_zero refinement.program.circuit

def PrimitiveRefinement.resource {qubits : Nat}
    (refinement : PrimitiveRefinement qubits) : Resource :=
  refinement.circuit.resource

theorem PrimitiveRefinement.oracleCalls_eq_zero {qubits : Nat}
    (refinement : PrimitiveRefinement qubits) :
    refinement.resource.oracleCalls = 0 := by
  exact PrimitiveCircuit.resource_oracleCalls_eq_zero refinement.circuit

end QuantumBlockEncoding

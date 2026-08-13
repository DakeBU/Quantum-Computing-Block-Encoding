import QuantumBlockEncoding.PrimitiveSemantics

/-!
# Primitive-refinement acceptance boundary

This module deliberately keeps executable screening separate from proof
authority.  A numerical report may prioritize a circuit, but only an exact
`PrimitiveRefinement` equality can promote it to the T3 semantic tier.
-/

namespace QuantumBlockEncoding

def PrimitiveRefinement.resource {qubits : Nat}
    (refinement : PrimitiveRefinement qubits) : Resource :=
  refinement.circuit.resource

theorem PrimitiveRefinement.oracleCalls_eq_zero {qubits : Nat}
    (refinement : PrimitiveRefinement qubits) :
    refinement.resource.oracleCalls = 0 := by
  exact PrimitiveCircuit.resource_oracleCalls_eq_zero refinement.circuit

end QuantumBlockEncoding

import QuantumBlockEncoding.Resources

/-!
# Circuit language

This is deliberately a small certificate-oriented IR.  A synthesis agent can
return a list of gates, then later files can attach matrix semantics and prove
that the circuit realizes a required block encoding.
-/

namespace QuantumBlockEncoding

inductive Gate where
  | oneQubit (name : String) (target : Nat)
  | rotationY (target : Nat) (angleLabel : String)
  | rotationZ (target : Nat) (angleLabel : String)
  | cnot (control target : Nat)
  | swap (left right : Nat)
  | multiControlled (controls : List (Nat × Bool)) (body : Gate)
  | oracleCall (name : String)
deriving Repr, DecidableEq

abbrev Circuit := List Gate

namespace Gate

/--
Conservative elementary-resource estimate for the current IR.
Oracle calls have zero local cost here because their implementation should be
expanded or certified separately.
-/
def resource : Gate -> Resource
  | oneQubit _ _ => Resource.ofCounts 1 0 0
  | rotationY _ _ => Resource.ofCounts 1 0 0
  | rotationZ _ _ => Resource.ofCounts 1 0 0
  | cnot _ _ => Resource.ofCounts 0 1 0
  | swap _ _ => Resource.ofCounts 0 3 0
  | oracleCall _ => Resource.ofCountsWithDepth 0 0 1 0 1
  | multiControlled controls body =>
      body.resource + Resource.ofCounts
        (16 * controls.length) (12 * controls.length) controls.length

end Gate

/--
A layer is a list of gates intended to be scheduled in parallel.  The current
IR does not yet prove non-overlap of qubits inside a layer; that belongs to
the semantic proof obligations for a concrete backend.
-/
abbrev CircuitLayer := List Gate

namespace CircuitLayer

def resource (layer : CircuitLayer) : Resource :=
  layer.foldl (fun acc gate => Resource.parallel acc gate.resource) 0

end CircuitLayer

/-- A layered circuit is the schedule used for depth comparisons. -/
abbrev LayeredCircuit := List CircuitLayer

namespace LayeredCircuit

def resource : LayeredCircuit → Resource
  | [] => 0
  | layer :: rest => CircuitLayer.resource layer + resource rest

def depth (circuit : LayeredCircuit) : Nat :=
  (resource circuit).depth

end LayeredCircuit

namespace Circuit

def resource : Circuit -> Resource
  | [] => 0
  | gate :: rest => Gate.resource gate + resource rest

@[simp] theorem resource_nil : resource [] = 0 := rfl

@[simp] theorem resource_cons (gate : Gate) (rest : Circuit) :
    resource (gate :: rest) = Gate.resource gate + resource rest := rfl

def depth (circuit : Circuit) : Nat :=
  (resource circuit).depth

end Circuit

end QuantumBlockEncoding

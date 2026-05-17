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
  | oracleCall _ => 0
  | multiControlled controls body =>
      body.resource + Resource.ofCounts (16 * controls.length) (12 * controls.length) controls.length

end Gate

namespace Circuit

def resource : Circuit -> Resource
  | [] => 0
  | gate :: rest => Gate.resource gate + resource rest

@[simp] theorem resource_nil : resource [] = 0 := rfl

@[simp] theorem resource_cons (gate : Gate) (rest : Circuit) :
    resource (gate :: rest) = Gate.resource gate + resource rest := rfl

end Circuit

end QuantumBlockEncoding

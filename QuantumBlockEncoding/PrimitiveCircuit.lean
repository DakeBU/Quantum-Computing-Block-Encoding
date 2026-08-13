import QuantumBlockEncoding.Resources
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Inverse
import Mathlib.Data.Rat.Defs
import Mathlib.Data.Real.Basic
import Mathlib.Data.Finset.Lattice.Fold

/-!
# Typed exact primitive circuits

This is the proof-bearing circuit language.  Unlike the older presentation
`Gate`, rotation angles are typed expressions with exact real semantics.
Only the frozen Robin T3 basis `{X, RY, RZ, CX}` is admitted.
-/

namespace QuantumBlockEncoding

inductive ExactAngle where
  | rational (value : Rat)
  | piRational (value : Rat)
  | twiceArccosRational (value : Rat)
      (bounded : |(value : Real)| ≤ 1)
  | add (left right : ExactAngle)
  | neg (value : ExactAngle)
deriving Repr

namespace ExactAngle

noncomputable def eval : ExactAngle → Real
  | .rational value => (value : Real)
  | .piRational value => Real.pi * (value : Real)
  | .twiceArccosRational value _ => 2 * Real.arccos (value : Real)
  | .add left right => left.eval + right.eval
  | .neg value => -value.eval

@[simp] theorem eval_add (left right : ExactAngle) :
    (add left right).eval = left.eval + right.eval := rfl

@[simp] theorem eval_neg (value : ExactAngle) :
    (neg value).eval = -value.eval := rfl

end ExactAngle

inductive PrimitiveGate (qubits : Nat) where
  | x (target : Fin qubits)
  | ry (target : Fin qubits) (angle : ExactAngle)
  | rz (target : Fin qubits) (angle : ExactAngle)
  | cx (control target : Fin qubits) (distinct : control ≠ target)

abbrev PrimitiveCircuit (qubits : Nat) := List (PrimitiveGate qubits)

namespace PrimitiveGate

def touched {qubits : Nat} : PrimitiveGate qubits → Finset (Fin qubits)
  | .x target | .ry target _ | .rz target _ => {target}
  | .cx control target _ => {control, target}

def oneQubitCount {qubits : Nat} : PrimitiveGate qubits → Nat
  | .x _ | .ry _ _ | .rz _ _ => 1
  | .cx _ _ _ => 0

def twoQubitCount {qubits : Nat} : PrimitiveGate qubits → Nat
  | .cx _ _ _ => 1
  | _ => 0

end PrimitiveGate

namespace PrimitiveCircuit

def gateCount {qubits : Nat} (circuit : PrimitiveCircuit qubits) : Nat :=
  circuit.length

def oneQubitCount {qubits : Nat} (circuit : PrimitiveCircuit qubits) : Nat :=
  circuit.foldl (fun total gate => total + gate.oneQubitCount) 0

def twoQubitCount {qubits : Nat} (circuit : PrimitiveCircuit qubits) : Nat :=
  circuit.foldl (fun total gate => total + gate.twoQubitCount) 0

def nextWireDepth {qubits : Nat} (depth : Fin qubits → Nat)
    (gate : PrimitiveGate qubits) : Fin qubits → Nat :=
  let layer := gate.touched.sup depth
  fun wire => if wire ∈ gate.touched then layer + 1 else depth wire

def wireDepths {qubits : Nat} (circuit : PrimitiveCircuit qubits) :
    Fin qubits → Nat :=
  circuit.foldl nextWireDepth (fun _ => 0)

def depth {qubits : Nat} (circuit : PrimitiveCircuit qubits) : Nat :=
  Finset.univ.sup circuit.wireDepths

def resource {qubits : Nat} (circuit : PrimitiveCircuit qubits) : Resource :=
  Resource.ofCountsWithDepth circuit.oneQubitCount circuit.twoQubitCount
    0 0 circuit.depth

@[simp] theorem gateCount_eq_length {qubits : Nat}
    (circuit : PrimitiveCircuit qubits) :
    circuit.gateCount = circuit.length := rfl

@[simp] theorem resource_oracleCalls_eq_zero {qubits : Nat}
    (circuit : PrimitiveCircuit qubits) :
    circuit.resource.oracleCalls = 0 := rfl

end PrimitiveCircuit

end QuantumBlockEncoding

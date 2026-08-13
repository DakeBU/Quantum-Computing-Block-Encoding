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
  | twiceArccosSqrtRational (value : Rat)
      (bounded : 0 ≤ (value : Real) ∧ (value : Real) ≤ 1)
  | add (left right : ExactAngle)
  | neg (value : ExactAngle)
  | scale (factor : Rat) (value : ExactAngle)
deriving Repr

namespace ExactAngle

noncomputable def eval : ExactAngle → Real
  | .rational value => (value : Real)
  | .piRational value => Real.pi * (value : Real)
  | .twiceArccosRational value _ => 2 * Real.arccos (value : Real)
  | .twiceArccosSqrtRational value _ =>
      2 * Real.arccos (Real.sqrt (value : Real))
  | .add left right => left.eval + right.eval
  | .neg value => -value.eval
  | .scale factor value => (factor : Real) * value.eval

@[simp] theorem eval_add (left right : ExactAngle) :
    (add left right).eval = left.eval + right.eval := rfl

@[simp] theorem eval_neg (value : ExactAngle) :
    (neg value).eval = -value.eval := rfl

@[simp] theorem eval_scale (factor : Rat) (value : ExactAngle) :
    (scale factor value).eval = (factor : Real) * value.eval := rfl

def sub (left right : ExactAngle) : ExactAngle :=
  add left (neg right)

def halfAdd (left right : ExactAngle) : ExactAngle :=
  scale (1 / 2) (add left right)

def halfSub (left right : ExactAngle) : ExactAngle :=
  scale (1 / 2) (sub left right)

@[simp] theorem eval_sub (left right : ExactAngle) :
    (sub left right).eval = left.eval - right.eval := by
  simp [sub, sub_eq_add_neg]

@[simp] theorem eval_half_add (left right : ExactAngle) :
    (halfAdd left right).eval = (left.eval + right.eval) / 2 := by
  simp only [halfAdd, eval_scale, eval_add]
  have halfCast : (((1 / 2 : Rat) : Real)) = (1 : Real) / 2 := by norm_num
  rw [halfCast]
  ring

@[simp] theorem eval_half_sub (left right : ExactAngle) :
    (halfSub left right).eval = (left.eval - right.eval) / 2 := by
  simp only [halfSub, eval_scale, eval_sub]
  have halfCast : (((1 / 2 : Rat) : Real)) = (1 : Real) / 2 := by norm_num
  rw [halfCast]
  ring

end ExactAngle

inductive PrimitiveGate (qubits : Nat) where
  | x (target : Fin qubits)
  | ry (target : Fin qubits) (angle : ExactAngle)
  | rz (target : Fin qubits) (angle : ExactAngle)
  | cx (control target : Fin qubits) (distinct : control ≠ target)

abbrev PrimitiveCircuit (qubits : Nat) := List (PrimitiveGate qubits)

/-- A primitive circuit together with an exact global phase. -/
structure PrimitiveProgram (qubits : Nat) where
  circuit : PrimitiveCircuit qubits
  globalPhase : ExactAngle

namespace PrimitiveGate

def dagger {qubits : Nat} : PrimitiveGate qubits → PrimitiveGate qubits
  | .x target => .x target
  | .ry target angle => .ry target (.neg angle)
  | .rz target angle => .rz target (.neg angle)
  | .cx control target distinct => .cx control target distinct

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

def ryCount {qubits : Nat} (circuit : PrimitiveCircuit qubits) : Nat :=
  circuit.countP fun gate => match gate with
    | .ry _ _ => true
    | _ => false

def cxCount {qubits : Nat} (circuit : PrimitiveCircuit qubits) : Nat :=
  circuit.countP fun gate => match gate with
    | .cx _ _ _ => true
    | _ => false

@[simp] theorem ryCount_append {qubits : Nat}
    (left right : PrimitiveCircuit qubits) :
    (left ++ right).ryCount = left.ryCount + right.ryCount := by
  simp [ryCount]

@[simp] theorem cxCount_append {qubits : Nat}
    (left right : PrimitiveCircuit qubits) :
    (left ++ right).cxCount = left.cxCount + right.cxCount := by
  simp [cxCount]

@[simp] theorem ryCount_singleton_ry {qubits : Nat}
    (target : Fin qubits) (angle : ExactAngle) :
    ryCount ([PrimitiveGate.ry target angle] : PrimitiveCircuit qubits) = 1 := by
  rfl

@[simp] theorem ryCount_singleton_cx {qubits : Nat}
    (control target : Fin qubits) (distinct : control ≠ target) :
    ryCount ([PrimitiveGate.cx control target distinct] : PrimitiveCircuit qubits) = 0 := by
  rfl

@[simp] theorem cxCount_singleton_ry {qubits : Nat}
    (target : Fin qubits) (angle : ExactAngle) :
    cxCount ([PrimitiveGate.ry target angle] : PrimitiveCircuit qubits) = 0 := by
  rfl

@[simp] theorem cxCount_singleton_cx {qubits : Nat}
    (control target : Fin qubits) (distinct : control ≠ target) :
    cxCount ([PrimitiveGate.cx control target distinct] : PrimitiveCircuit qubits) = 1 := by
  rfl

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

namespace PrimitiveProgram

def identity (qubits : Nat) : PrimitiveProgram qubits where
  circuit := []
  globalPhase := .rational 0

/-- Execute `left`, then `right`, using chronological list semantics. -/
def seq {qubits : Nat} (left right : PrimitiveProgram qubits) :
    PrimitiveProgram qubits where
  circuit := left.circuit ++ right.circuit
  globalPhase := .add left.globalPhase right.globalPhase

def dagger {qubits : Nat} (program : PrimitiveProgram qubits) :
    PrimitiveProgram qubits where
  circuit := program.circuit.reverse.map PrimitiveGate.dagger
  globalPhase := .neg program.globalPhase

def resource {qubits : Nat} (program : PrimitiveProgram qubits) : Resource :=
  program.circuit.resource

end PrimitiveProgram

end QuantumBlockEncoding

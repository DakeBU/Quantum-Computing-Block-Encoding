import QuantumBlockEncoding.SelectedRyTrace
import Lean.Data.Json

/-! Execute the checked rational compiler, producing portable local traces.
The output is a deterministic test artifact, not a Hermite acceptance JSON. -/

open Lean QuantumBlockEncoding

def traceGateJson {n : Nat} : SelectedRyTrace.Gate n → Json
  | .ry target coefficient => Json.mkObj
      [("op", toJson "ry"), ("target", toJson target.val),
       ("numerator", toJson coefficient.num), ("denominator", toJson coefficient.den)]
  | .cx control target _ => Json.mkObj
      [("op", toJson "cx"), ("control", toJson control.val), ("target", toJson target.val)]

def selectedCaseJson (controls : Nat) (target : Fin (controls + 1)) (pattern : Nat) : Json :=
  let chosen : PrimitiveBasis controls := fun i => ⟨(pattern / 2 ^ i.val) % 2, Nat.mod_lt _ (by decide)⟩
  let trace := SelectedRyTrace.selected (Fin.succAbove target) target
    (Fin.succAbove_ne target) chosen
  Json.mkObj [("qubits", toJson (controls + 1)), ("target", toJson target.val),
    ("controls", toJson ((List.finRange controls).map (fun i => (target.succAbove i).val))),
    ("pattern", toJson pattern), ("gates", toJson (trace.map traceGateJson))]

def main (args : List String) : IO UInt32 := do
  match args with
  | [output] =>
    let cases := (List.range 5).flatMap fun controls =>
      (List.finRange (controls + 1)).flatMap fun target =>
        (List.range (2 ^ controls)).map (selectedCaseJson controls target)
    let artifact := Json.mkObj [("schema", toJson "aspbe-selected-ry-traces-v1"),
      ("scope", toJson "local_symbolic_rotation_trace_not_state_acceptance"),
      ("lean_root", toJson "QuantumBlockEncoding.SelectedRyTrace.selected_refines"),
      ("control_order", toJson "physical wires ascending; pattern LSB is first control"),
      ("cases", toJson cases)]
    IO.FS.writeFile output (artifact.pretty ++ "\n")
    IO.println s!"emitted {cases.length} checked-algorithm trace cases"
    return 0
  | _ =>
    IO.eprintln "usage: lake env lean --run experiments/hermite-polynomial/mps/EmitSelectedRyTraces.lean OUTPUT.json"
    return 2

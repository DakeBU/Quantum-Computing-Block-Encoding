import QuantumBlockEncoding.BlockEncoding

/-!
# Optimal-control operator block-encoding sandbox

This file starts the exploratory task
`QBE-OP-OPTCTRL-001`: construct a block encoding for the operator family

`E_k := |0><k|_time ⊗ |0><1|_type ⊗ I_n`.

The first Lean-checked candidate is intentionally small and concrete:

* one time qubit, so `k = 1`;
* one type qubit;
* one state qubit, so the identity factor has dimension `2`;
* one auxiliary qubit for a reversible/unitary completion.

The operator is a partial isometry, not a unitary on the system register.
The candidate below embeds it as the clean block of a permutation unitary on
one extra qubit.  Later explore-mode agents can mutate this baseline into a
gate-level implementation and generalize the state register.
-/

namespace QuantumBlockEncoding
namespace OptimalControl

/-- Local finite-permutation certificate used as a lightweight unitarity proxy. -/
def IsPermutation {n : Nat} (f : Fin n → Fin n) : Prop :=
  (∀ x y, f x = f y → x = y) ∧ ∀ y, ∃ x, f x = y

/-- System index for `time=0`, `type=0`, `state=0`. -/
def targetState0 : Fin 8 := ⟨0, by decide⟩

/-- System index for `time=0`, `type=0`, `state=1`. -/
def targetState1 : Fin 8 := ⟨1, by decide⟩

/-- System index for `time=1`, `type=1`, `state=0`. -/
def sourceState0 : Fin 8 := ⟨6, by decide⟩

/-- System index for `time=1`, `type=1`, `state=1`. -/
def sourceState1 : Fin 8 := ⟨7, by decide⟩

/--
The concrete `E_1` operator for one time qubit, one type qubit, and one state
qubit.  It maps `|1>_time |1>_type |s>` to
`|0>_time |0>_type |s>` and annihilates every other basis state.
-/
def exampleOperator : Matrix 8 8 Rat :=
  fun row col =>
    if (row = targetState0 ∧ col = sourceState0) ∨
        (row = targetState1 ∧ col = sourceState1) then
      1
    else
      0

/-- Clean-ancilla embedding into the first half of the one-ancilla space. -/
def cleanIndex (i : Fin 8) : Fin 16 :=
  ⟨i.val, by omega⟩

/--
Permutation image for the one-ancilla unitary completion.

For each state bit `s`, the four-cycle is

`(0, source_s) -> (0, target_s) -> (1, source_s)
 -> (1, target_s) -> (0, source_s)`.

Every other system basis state just swaps the auxiliary qubit.
-/
def exampleImage (x : Fin 16) : Fin 16 :=
  if x.val = 0 then ⟨14, by decide⟩
  else if x.val = 1 then ⟨15, by decide⟩
  else if x.val = 2 then ⟨10, by decide⟩
  else if x.val = 3 then ⟨11, by decide⟩
  else if x.val = 4 then ⟨12, by decide⟩
  else if x.val = 5 then ⟨13, by decide⟩
  else if x.val = 6 then ⟨0, by decide⟩
  else if x.val = 7 then ⟨1, by decide⟩
  else if x.val = 8 then ⟨6, by decide⟩
  else if x.val = 9 then ⟨7, by decide⟩
  else if x.val = 10 then ⟨2, by decide⟩
  else if x.val = 11 then ⟨3, by decide⟩
  else if x.val = 12 then ⟨4, by decide⟩
  else if x.val = 13 then ⟨5, by decide⟩
  else if x.val = 14 then ⟨8, by decide⟩
  else ⟨9, by decide⟩

/-- Inverse permutation for `exampleImage`. -/
def exampleImageInv (x : Fin 16) : Fin 16 :=
  if x.val = 0 then ⟨6, by decide⟩
  else if x.val = 1 then ⟨7, by decide⟩
  else if x.val = 2 then ⟨10, by decide⟩
  else if x.val = 3 then ⟨11, by decide⟩
  else if x.val = 4 then ⟨12, by decide⟩
  else if x.val = 5 then ⟨13, by decide⟩
  else if x.val = 6 then ⟨8, by decide⟩
  else if x.val = 7 then ⟨9, by decide⟩
  else if x.val = 8 then ⟨14, by decide⟩
  else if x.val = 9 then ⟨15, by decide⟩
  else if x.val = 10 then ⟨2, by decide⟩
  else if x.val = 11 then ⟨3, by decide⟩
  else if x.val = 12 then ⟨4, by decide⟩
  else if x.val = 13 then ⟨5, by decide⟩
  else if x.val = 14 then ⟨0, by decide⟩
  else ⟨1, by decide⟩

theorem exampleImage_leftInverse :
    ∀ x : Fin 16, exampleImageInv (exampleImage x) = x := by
  native_decide

theorem exampleImage_rightInverse :
    ∀ x : Fin 16, exampleImage (exampleImageInv x) = x := by
  native_decide

/-- The image function is a finite permutation, hence a permutation unitary. -/
theorem exampleImage_isPermutation : IsPermutation exampleImage := by
  constructor
  · intro x y hxy
    have h := congrArg exampleImageInv hxy
    simpa [exampleImage_leftInverse x, exampleImage_leftInverse y] using h
  · intro y
    exact ⟨exampleImageInv y, exampleImage_rightInverse y⟩

/-!
## Expanded logical reversible circuit

The oracle-level candidate above is a correct block encoding, but it hides the
permutation completion inside one opaque oracle call.  The first explore-mode
mutation expands the active three-bit permutation on `(aux,time,type)` while
leaving the state bit passive.  The gate library here is the logical reversible
library `{X, CNOT, Toffoli}`; later hardware backends can decompose Toffoli into
elementary one- and two-qubit gates.
-/

/-- The reduced three-bit permutation induced by `exampleImage` on `(aux,time,type)`. -/
def reducedTargetImage (x : Fin 8) : Fin 8 :=
  if x.val = 0 then ⟨7, by decide⟩
  else if x.val = 1 then ⟨5, by decide⟩
  else if x.val = 2 then ⟨6, by decide⟩
  else if x.val = 3 then ⟨0, by decide⟩
  else if x.val = 4 then ⟨3, by decide⟩
  else if x.val = 5 then ⟨1, by decide⟩
  else if x.val = 6 then ⟨2, by decide⟩
  else ⟨4, by decide⟩

/-- Logical `X` on reduced bit 0. -/
def redX0 (x : Fin 8) : Fin 8 :=
  if x.val = 0 then ⟨1, by decide⟩
  else if x.val = 1 then ⟨0, by decide⟩
  else if x.val = 2 then ⟨3, by decide⟩
  else if x.val = 3 then ⟨2, by decide⟩
  else if x.val = 4 then ⟨5, by decide⟩
  else if x.val = 5 then ⟨4, by decide⟩
  else if x.val = 6 then ⟨7, by decide⟩
  else ⟨6, by decide⟩

/-- Logical `X` on reduced bit 2. -/
def redX2 (x : Fin 8) : Fin 8 :=
  if x.val = 0 then ⟨4, by decide⟩
  else if x.val = 1 then ⟨5, by decide⟩
  else if x.val = 2 then ⟨6, by decide⟩
  else if x.val = 3 then ⟨7, by decide⟩
  else if x.val = 4 then ⟨0, by decide⟩
  else if x.val = 5 then ⟨1, by decide⟩
  else if x.val = 6 then ⟨2, by decide⟩
  else ⟨3, by decide⟩

/-- Logical CNOT with control reduced bit 0 and target reduced bit 1. -/
def redCX01 (x : Fin 8) : Fin 8 :=
  if x.val = 1 then ⟨3, by decide⟩
  else if x.val = 3 then ⟨1, by decide⟩
  else if x.val = 5 then ⟨7, by decide⟩
  else if x.val = 7 then ⟨5, by decide⟩
  else x

/-- Logical CNOT with control reduced bit 1 and target reduced bit 0. -/
def redCX10 (x : Fin 8) : Fin 8 :=
  if x.val = 2 then ⟨3, by decide⟩
  else if x.val = 3 then ⟨2, by decide⟩
  else if x.val = 6 then ⟨7, by decide⟩
  else if x.val = 7 then ⟨6, by decide⟩
  else x

/-- Logical Toffoli with controls reduced bits 0,1 and target reduced bit 2. -/
def redCCX012 (x : Fin 8) : Fin 8 :=
  if x.val = 3 then ⟨7, by decide⟩
  else if x.val = 7 then ⟨3, by decide⟩
  else x

/--
Depth-5 logical circuit found by the first EoH-style explore pass:

1. `CCX(0,1;2)`
2. `CX(0,1)`
3. `CX(1,0)`
4. `X(0)`
5. parallel layer `{X(2), CX(0,1)}`
-/
def reducedDepth5Image (x : Fin 8) : Fin 8 :=
  redCX01 (redX2 (redX0 (redCX10 (redCX01 (redCCX012 x)))))

/-- The expanded logical circuit realizes the same reduced permutation. -/
theorem reducedDepth5Image_eq_target :
    ∀ x : Fin 8, reducedDepth5Image x = reducedTargetImage x := by
  native_decide

/-- Extract the active `(aux,time,type)` register from the full index. -/
def reducedOfFull (x : Fin 16) : Fin 8 :=
  ⟨x.val / 2, by omega⟩

/-- Extract the passive state bit from the full index. -/
def stateOfFull (x : Fin 16) : Fin 2 :=
  ⟨x.val % 2, Nat.mod_lt x.val (by decide)⟩

/-- Lift a reduced active-register permutation while leaving the state bit fixed. -/
def liftReducedImage (f : Fin 8 → Fin 8) (x : Fin 16) : Fin 16 :=
  ⟨2 * (f (reducedOfFull x)).val + (stateOfFull x).val, by
    have hf : (f (reducedOfFull x)).val < 8 := (f (reducedOfFull x)).isLt
    have hs : (stateOfFull x).val < 2 := (stateOfFull x).isLt
    omega⟩

/--
The depth-5 reduced circuit lifts to the full one-ancilla permutation because
the state bit is passive.
-/
theorem reducedDepth5_lifts_exampleImage :
    ∀ x : Fin 16, liftReducedImage reducedDepth5Image x = exampleImage x := by
  native_decide

/-- Lightweight score for the logical reversible gate library `{X,CNOT,Toffoli}`. -/
structure LogicalReversibleCost where
  auxiliaryQubits : Nat
  xGates : Nat
  cnotGates : Nat
  toffoliGates : Nat
  depth : Nat
  oracleCalls : Nat
deriving Repr, DecidableEq

namespace LogicalReversibleCost

def gateCount (c : LogicalReversibleCost) : Nat :=
  c.xGates + c.cnotGates + c.toffoliGates

end LogicalReversibleCost

/-- Expanded score for `reducedDepth5Image` before hardware decomposition. -/
def reducedDepth5Cost : LogicalReversibleCost where
  auxiliaryQubits := 1
  xGates := 2
  cnotGates := 3
  toffoliGates := 1
  depth := 5
  oracleCalls := 0

theorem reducedDepth5Cost_gateCount :
    reducedDepth5Cost.gateCount = 6 := by
  rfl

theorem reducedDepth5Cost_oracleFree :
    reducedDepth5Cost.oracleCalls = 0 := by
  rfl

/-- Matrix of the one-ancilla permutation unitary completion. -/
def exampleUnitary : Matrix 16 16 Rat :=
  fun row col => if row = exampleImage col then 1 else 0

/--
The clean block of `exampleUnitary` is exactly the optimal-control operator
`E_1` on the 8-dimensional system register.
-/
theorem example_cleanBlock :
    ∀ row col : Fin 8,
      exampleUnitary (cleanIndex row) (cleanIndex col) =
        exampleOperator row col := by
  native_decide

def exampleTarget : QueryOperatorTarget Rat 8 8 where
  operator := exampleOperator
  normalizer := 1
  source := "QBE-OP-OPTCTRL-001: E_k = |0><k|_time ⊗ |0><1|_type ⊗ I_n"
  semanticContract := "clean one-ancilla block equals E_1 exactly"
  freeParameters := ["time qubits = 1", "type qubits = 1", "state qubits = 1", "k = 1"]

def exampleLayout : RegisterLayout where
  systemQubits := 3
  signalQubits := 1
  pureAncillas := 0

def exampleCircuit : Circuit :=
  [Gate.oracleCall "optimal-control-one-ancilla-permutation-completion"]

def exampleSchedule : LayeredCircuit :=
  [[Gate.oracleCall "optimal-control-one-ancilla-permutation-completion"]]

def exampleResource : Resource :=
  Resource.ofCountsWithDepth 0 0 1 0 1

def exampleCandidate : OperatorBlockEncodingCandidate Rat 3 where
  auxiliaryQubits := 1
  target := exampleTarget
  unitary := exampleUnitary
  layout := exampleLayout
  circuit := exampleCircuit
  schedule := exampleSchedule
  resource := exampleResource
  layoutMatches := rfl
  isUnitary := IsPermutation exampleImage
  blockContainsTarget :=
    ∀ row col : Fin 8,
      exampleUnitary (cleanIndex row) (cleanIndex col) =
        exampleOperator row col

def exampleVerified : VerifiedOperatorBlockEncoding Rat 3 where
  candidate := exampleCandidate
  unitaryProof := exampleImage_isPermutation
  blockProof := example_cleanBlock

theorem exampleCandidate_cost :
    exampleCandidate.cost =
      { auxiliaryQubits := 1, gateCount := 1, depth := 1, oracleCalls := 1 } := by
  rfl

end OptimalControl
end QuantumBlockEncoding

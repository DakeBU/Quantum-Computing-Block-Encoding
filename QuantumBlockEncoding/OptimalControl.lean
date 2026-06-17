import QuantumBlockEncoding.CircuitSemantics

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
mutation expands the active three-bit permutation while leaving the state bit
passive.  In the reduced index used below, bit `0` is `type`, bit `1` is
`time`, and bit `2` is the block-encoding auxiliary bit.  The gate library here
is the logical reversible library `{X, CNOT, Toffoli}`; later hardware backends
can decompose Toffoli into elementary one- and two-qubit gates.
-/

/-- The reduced three-bit permutation induced by `exampleImage` on `(type,time,aux)`. -/
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

/-- Logical `X` on reduced bit 1. -/
def redX1 (x : Fin 8) : Fin 8 :=
  if x.val = 0 then ⟨2, by decide⟩
  else if x.val = 1 then ⟨3, by decide⟩
  else if x.val = 2 then ⟨0, by decide⟩
  else if x.val = 3 then ⟨1, by decide⟩
  else if x.val = 4 then ⟨6, by decide⟩
  else if x.val = 5 then ⟨7, by decide⟩
  else if x.val = 6 then ⟨4, by decide⟩
  else ⟨5, by decide⟩

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

/-- Logical CNOT with control reduced bit 2 and target reduced bit 0. -/
def redCX20 (x : Fin 8) : Fin 8 :=
  if x.val = 4 then ⟨5, by decide⟩
  else if x.val = 5 then ⟨4, by decide⟩
  else if x.val = 6 then ⟨7, by decide⟩
  else if x.val = 7 then ⟨6, by decide⟩
  else x

/-- Logical CNOT with control reduced bit 2 and target reduced bit 1. -/
def redCX21 (x : Fin 8) : Fin 8 :=
  if x.val = 4 then ⟨6, by decide⟩
  else if x.val = 6 then ⟨4, by decide⟩
  else if x.val = 5 then ⟨7, by decide⟩
  else if x.val = 7 then ⟨5, by decide⟩
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

/-- Extract the active `(type,time,aux)` register from the full index. -/
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

/-- The depth-5 full active-plus-state completion is a permutation. -/
theorem reducedDepth5Full_isPermutation :
    IsPermutation (liftReducedImage reducedDepth5Image) := by
  unfold IsPermutation
  native_decide

/--
Matrix induced by a reduced active-register permutation lifted over the passive
state bit.
-/
def unitaryFromReducedImage (f : Fin 8 → Fin 8) : Matrix 16 16 Rat :=
  fun row col => if row = liftReducedImage f col then 1 else 0

/-- The clean block condition for the concrete optimal-control target. -/
def CleanBlockE1 (f : Fin 8 → Fin 8) : Prop :=
  ∀ row col : Fin 8,
    unitaryFromReducedImage f (cleanIndex row) (cleanIndex col) =
      exampleOperator row col

/-- Column inner products for concrete rational matrix-level unitarity checks. -/
def columnInner {n : Nat} (U : Matrix n n Rat) (i j : Fin n) : Rat :=
  (List.finRange n).foldl (fun acc k => acc + U k i * U k j) 0

/-- Row inner products for concrete rational matrix-level unitarity checks. -/
def rowInner {n : Nat} (U : Matrix n n Rat) (i j : Fin n) : Rat :=
  (List.finRange n).foldl (fun acc k => acc + U i k * U j k) 0

/--
Concrete real/rational unitary proxy for this finite permutation-matrix
sandbox.  Since all entries are rational and all current exact circuits are
real, this is the finite `UᵀU = I` and `UUᵀ = I` condition.
-/
def IsRationalOrthogonal {n : Nat} (U : Matrix n n Rat) : Prop :=
  (∀ i j : Fin n, columnInner U i j = Matrix.identity n Rat i j) ∧
    (∀ i j : Fin n, rowInner U i j = Matrix.identity n Rat i j)

/--
The target operator itself is not unitary.  Therefore an exact unscaled
zero-auxiliary block encoding cannot use `E_1` as the whole unitary matrix.
One auxiliary qubit is locally necessary for this concrete exact construction
model.
-/
theorem exampleOperator_not_rationalOrthogonal :
    ¬ IsRationalOrthogonal exampleOperator := by
  intro h
  have hbad :
      columnInner exampleOperator targetState0 targetState0 ≠
        Matrix.identity 8 Rat targetState0 targetState0 := by
    native_decide
  exact hbad (h.1 targetState0 targetState0)

/-- The depth-5 fixed-completion candidate has the required clean block. -/
theorem reducedDepth5_cleanBlock : CleanBlockE1 reducedDepth5Image := by
  unfold CleanBlockE1
  native_decide

/-- Matrix of the depth-5 fixed-completion logical circuit. -/
def reducedDepth5Unitary : Matrix 16 16 Rat :=
  unitaryFromReducedImage reducedDepth5Image

/-- The depth-5 fixed-completion matrix is rational orthogonal/unitary. -/
theorem reducedDepth5Unitary_isRationalOrthogonal :
    IsRationalOrthogonal reducedDepth5Unitary := by
  unfold IsRationalOrthogonal columnInner rowInner reducedDepth5Unitary
    unitaryFromReducedImage liftReducedImage reducedOfFull stateOfFull
    reducedDepth5Image redCX01 redX2 redX0 redCX10 redCCX012
  native_decide

/-- The depth-5 fixed-completion matrix has the required clean block. -/
theorem reducedDepth5Unitary_cleanBlock :
    ∀ row col : Fin 8,
      reducedDepth5Unitary (cleanIndex row) (cleanIndex col) =
        exampleOperator row col :=
  reducedDepth5_cleanBlock

/--
ChatGPT Pro's structured equality-flag/transfer construction specialized to
the concrete `r = 1, k = 1` instance:

1. `CCX(type,time;aux)` flags `time=1,type=1`.
2. `CX(aux,time)` transfers flagged `time` to `0`.
3. `CX(aux,type)` transfers flagged `type` to `0`.
4. `X(aux)` moves the selected branch back into the clean block.
-/
def proEqTransferImage (x : Fin 8) : Fin 8 :=
  redX2 (redCX20 (redCX21 (redCCX012 x)))

/-- Pro's reduced active-register map is a permutation. -/
theorem proEqTransferImage_isPermutation :
    IsPermutation proEqTransferImage := by
  unfold IsPermutation
  native_decide

/-- Pro's full active-plus-state completion is a permutation. -/
theorem proEqTransferFull_isPermutation :
    IsPermutation (liftReducedImage proEqTransferImage) := by
  unfold IsPermutation
  native_decide

/-- Pro's construction has the required clean block for the concrete target. -/
theorem proEqTransfer_cleanBlock : CleanBlockE1 proEqTransferImage := by
  unfold CleanBlockE1
  native_decide

/-- Matrix of Pro's equality-flag/transfer construction. -/
def proEqTransferUnitary : Matrix 16 16 Rat :=
  unitaryFromReducedImage proEqTransferImage

/-- Pro's equality-flag/transfer matrix is rational orthogonal/unitary. -/
theorem proEqTransferUnitary_isRationalOrthogonal :
    IsRationalOrthogonal proEqTransferUnitary := by
  unfold IsRationalOrthogonal columnInner rowInner proEqTransferUnitary
    unitaryFromReducedImage liftReducedImage reducedOfFull stateOfFull
    proEqTransferImage redX2 redCX20 redCX21 redCCX012
  native_decide

/-- Pro's equality-flag/transfer matrix has the required clean block. -/
theorem proEqTransferUnitary_cleanBlock :
    ∀ row col : Fin 8,
      proEqTransferUnitary (cleanIndex row) (cleanIndex col) =
        exampleOperator row col :=
  proEqTransfer_cleanBlock

/--
An evolved child of the Pro construction.  The same equality flag is followed
by a parallel layer of three `X` gates on `(type,time,aux)`.  This uses the
freedom in the unitary completion: it does not reproduce `exampleImage`, but it
does satisfy the same clean-block contract.
-/
def evolvedEqFlipImage (x : Fin 8) : Fin 8 :=
  redX2 (redX1 (redX0 (redCCX012 x)))

/-- The evolved reduced active-register map is a permutation. -/
theorem evolvedEqFlipImage_isPermutation :
    IsPermutation evolvedEqFlipImage := by
  unfold IsPermutation
  native_decide

/-- The evolved full active-plus-state completion is a permutation. -/
theorem evolvedEqFlipFull_isPermutation :
    IsPermutation (liftReducedImage evolvedEqFlipImage) := by
  unfold IsPermutation
  native_decide

/-- The evolved depth-2 construction has the required clean block. -/
theorem evolvedEqFlip_cleanBlock : CleanBlockE1 evolvedEqFlipImage := by
  unfold CleanBlockE1
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

/-- Lexicographic order inside one fixed logical reversible gate library. -/
def betterThan (x y : LogicalReversibleCost) : Prop :=
  x.depth < y.depth ∨
  (x.depth = y.depth ∧
    (x.gateCount < y.gateCount ∨
      (x.gateCount = y.gateCount ∧
        (x.auxiliaryQubits < y.auxiliaryQubits ∨
          (x.auxiliaryQubits = y.auxiliaryQubits ∧
            x.oracleCalls < y.oracleCalls)))))

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

/-- Expanded score for Pro's equality-flag/transfer construction. -/
def proEqTransferCost : LogicalReversibleCost where
  auxiliaryQubits := 1
  xGates := 1
  cnotGates := 2
  toffoliGates := 1
  depth := 4
  oracleCalls := 0

theorem proEqTransferCost_gateCount :
    proEqTransferCost.gateCount = 4 := by
  rfl

theorem proEqTransferCost_betterThan_depth5 :
    proEqTransferCost.betterThan reducedDepth5Cost := by
  unfold LogicalReversibleCost.betterThan
  native_decide

/-- Expanded score for the evolved equality-flag/parallel-flip construction. -/
def evolvedEqFlipCost : LogicalReversibleCost where
  auxiliaryQubits := 1
  xGates := 3
  cnotGates := 0
  toffoliGates := 1
  depth := 2
  oracleCalls := 0

theorem evolvedEqFlipCost_gateCount :
    evolvedEqFlipCost.gateCount = 4 := by
  rfl

theorem evolvedEqFlipCost_betterThan_pro :
    evolvedEqFlipCost.betterThan proEqTransferCost := by
  unfold LogicalReversibleCost.betterThan
  native_decide

theorem evolvedEqFlipCost_betterThan_depth5 :
    evolvedEqFlipCost.betterThan reducedDepth5Cost := by
  unfold LogicalReversibleCost.betterThan
  native_decide

/-- Matrix of the evolved depth-2 logical gate product. -/
def evolvedEqFlipUnitary : Matrix 16 16 Rat :=
  unitaryFromReducedImage evolvedEqFlipImage

/--
The evolved matrix is a concrete rational unitary matrix in the project-local
real/permutation sense: both its column and row Gram matrices are identity.
-/
theorem evolvedEqFlipUnitary_isRationalOrthogonal :
    IsRationalOrthogonal evolvedEqFlipUnitary := by
  unfold IsRationalOrthogonal columnInner rowInner evolvedEqFlipUnitary
    unitaryFromReducedImage liftReducedImage reducedOfFull stateOfFull
    evolvedEqFlipImage redX2 redX1 redX0 redCCX012
  native_decide

/-- The evolved concrete matrix has the required clean block. -/
theorem evolvedEqFlipUnitary_cleanBlock :
    ∀ row col : Fin 8,
      evolvedEqFlipUnitary (cleanIndex row) (cleanIndex col) =
        exampleOperator row col :=
  evolvedEqFlip_cleanBlock

/-- Full-space gate matrix for a reduced active-register permutation. -/
def reducedGateMatrix (gate : Gate) (f : Fin 8 → Fin 8) :
    GateMatrix Rat 4 where
  gate := gate
  matrix := unitaryFromReducedImage f
  unitary := {
    description := "logical reversible permutation gate matrix"
    source := "QBE-OP-OPTCTRL-001 concrete logical gate library"
    proved := true
  }

/-- Logical Toffoli gate `CCX(type,time;aux)` in the concrete layout. -/
def gateCCX_type_time_aux : Gate :=
  Gate.multiControlled [(1, true), (2, true)] (Gate.oneQubit "X" 3)

/-- Logical `X` on the type bit in the concrete layout. -/
def gateX_type : Gate :=
  Gate.oneQubit "X" 1

/-- Logical `X` on the time bit in the concrete layout. -/
def gateX_time : Gate :=
  Gate.oneQubit "X" 2

/-- Logical `X` on the block-encoding auxiliary bit in the concrete layout. -/
def gateX_aux : Gate :=
  Gate.oneQubit "X" 3

/-- Logical CNOT from type to time in the concrete layout. -/
def gateCX_type_time : Gate :=
  Gate.cnot 1 2

/-- Logical CNOT from time to type in the concrete layout. -/
def gateCX_time_type : Gate :=
  Gate.cnot 2 1

/-- Logical CNOT from auxiliary to type in the concrete layout. -/
def gateCX_aux_type : Gate :=
  Gate.cnot 3 1

/-- Logical CNOT from auxiliary to time in the concrete layout. -/
def gateCX_aux_time : Gate :=
  Gate.cnot 3 2

/-- The depth-5 fixed-completion circuit in sequential-list form. -/
def reducedDepth5Circuit : Circuit :=
  [ gateCCX_type_time_aux
  , gateCX_type_time
  , gateCX_time_type
  , gateX_type
  , gateX_aux
  , gateCX_type_time
  ]

/-- The depth-5 fixed-completion schedule. -/
def reducedDepth5Schedule : LayeredCircuit :=
  [ [gateCCX_type_time_aux]
  , [gateCX_type_time]
  , [gateCX_time_type]
  , [gateX_type]
  , [gateX_aux, gateCX_type_time]
  ]

/-- Gate matrices for the depth-5 fixed-completion circuit. -/
def reducedDepth5GateMatrices : List (GateMatrix Rat 4) :=
  [ reducedGateMatrix gateCCX_type_time_aux redCCX012
  , reducedGateMatrix gateCX_type_time redCX01
  , reducedGateMatrix gateCX_time_type redCX10
  , reducedGateMatrix gateX_type redX0
  , reducedGateMatrix gateX_aux redX2
  , reducedGateMatrix gateCX_type_time redCX01
  ]

/-- The gate-matrix labels match the depth-5 circuit transcript. -/
theorem reducedDepth5GateMatrices_matchCircuit :
    gateMatricesMatchCircuit reducedDepth5Circuit reducedDepth5GateMatrices = true := by
  native_decide

/-- Evaluate reduced logical reversible gates as basis-state permutations. -/
def evalReducedGateImages (gates : List (Fin 8 → Fin 8)) (x : Fin 8) : Fin 8 :=
  gates.foldl (fun y gateImage => gateImage y) x

/-- Reduced permutation images of the depth-5 logical circuit. -/
def reducedDepth5GateImages : List (Fin 8 → Fin 8) :=
  [redCCX012, redCX01, redCX10, redX0, redX2, redCX01]

/-- The depth-5 logical reversible circuit implements `reducedDepth5Image`. -/
theorem reducedDepth5GateImages_eval :
    ∀ x : Fin 8,
      evalReducedGateImages reducedDepth5GateImages x = reducedDepth5Image x := by
  native_decide

/-- Pro's equality-flag/transfer circuit in sequential-list form. -/
def proEqTransferCircuit : Circuit :=
  [gateCCX_type_time_aux, gateCX_aux_time, gateCX_aux_type, gateX_aux]

/-- Pro's equality-flag/transfer schedule. -/
def proEqTransferSchedule : LayeredCircuit :=
  [[gateCCX_type_time_aux], [gateCX_aux_time], [gateCX_aux_type], [gateX_aux]]

/-- Gate matrices for Pro's equality-flag/transfer circuit. -/
def proEqTransferGateMatrices : List (GateMatrix Rat 4) :=
  [ reducedGateMatrix gateCCX_type_time_aux redCCX012
  , reducedGateMatrix gateCX_aux_time redCX21
  , reducedGateMatrix gateCX_aux_type redCX20
  , reducedGateMatrix gateX_aux redX2
  ]

/-- The gate-matrix labels match Pro's circuit transcript. -/
theorem proEqTransferGateMatrices_matchCircuit :
    gateMatricesMatchCircuit proEqTransferCircuit proEqTransferGateMatrices = true := by
  native_decide

/-- Reduced permutation images of Pro's logical circuit. -/
def proEqTransferGateImages : List (Fin 8 → Fin 8) :=
  [redCCX012, redCX21, redCX20, redX2]

/-- Pro's logical reversible circuit implements `proEqTransferImage`. -/
theorem proEqTransferGateImages_eval :
    ∀ x : Fin 8,
      evalReducedGateImages proEqTransferGateImages x = proEqTransferImage x := by
  native_decide

/-- The evolved depth-2 circuit in sequential-list form. -/
def evolvedEqFlipCircuit : Circuit :=
  [gateCCX_type_time_aux, gateX_type, gateX_time, gateX_aux]

/-- The evolved depth-2 schedule: one Toffoli layer, then three parallel flips. -/
def evolvedEqFlipSchedule : LayeredCircuit :=
  [[gateCCX_type_time_aux], [gateX_type, gateX_time, gateX_aux]]

/-- Gate matrices for the evolved concrete circuit. -/
def evolvedEqFlipGateMatrices : List (GateMatrix Rat 4) :=
  [ reducedGateMatrix gateCCX_type_time_aux redCCX012
  , reducedGateMatrix gateX_type redX0
  , reducedGateMatrix gateX_time redX1
  , reducedGateMatrix gateX_aux redX2
  ]

/-- The gate-matrix labels match the evolved circuit transcript. -/
theorem evolvedEqFlipGateMatrices_matchCircuit :
    gateMatricesMatchCircuit evolvedEqFlipCircuit evolvedEqFlipGateMatrices = true := by
  native_decide

/-- Reduced permutation images of the evolved logical circuit. -/
def evolvedEqFlipGateImages : List (Fin 8 → Fin 8) :=
  [redCCX012, redX0, redX1, redX2]

/--
The logical reversible circuit implements exactly the reduced permutation used
to build `evolvedEqFlipUnitary`.  This is the efficient semantic bridge for the
current logical reversible tier; the heavier raw `evalGateMatrices` product is
left to a later backend if the project chooses a hardware decomposition.
-/
theorem evolvedEqFlipGateImages_eval :
    ∀ x : Fin 8,
      evalReducedGateImages evolvedEqFlipGateImages x = evolvedEqFlipImage x := by
  native_decide

/-- The lifted logical circuit implements the full active-plus-state image. -/
theorem evolvedEqFlipGateImages_lift_eval :
    ∀ x : Fin 16,
      liftReducedImage (evalReducedGateImages evolvedEqFlipGateImages) x =
        liftReducedImage evolvedEqFlipImage x := by
  native_decide

/--
Resource record for the depth-5 logical `{X,CNOT,Toffoli}` interpretation.
The current `Resource` type has no Toffoli field, so `cnot` stores all
controlled logical gates in this tier.
-/
def reducedDepth5Resource : Resource :=
  Resource.ofCountsWithDepth 2 4 0 0 5

/--
Resource record for Pro's logical `{X,CNOT,Toffoli}` interpretation.  The
current `Resource` type has no Toffoli field, so `cnot` stores all controlled
logical gates in this tier.
-/
def proEqTransferResource : Resource :=
  Resource.ofCountsWithDepth 1 3 0 0 4

/--
Resource record for the evolved logical `{X,CNOT,Toffoli}` interpretation.
The current `Resource` type has no Toffoli field, so `cnot` stores the single
logical Toffoli in this tier.
-/
def evolvedEqFlipResource : Resource :=
  Resource.ofCountsWithDepth 3 1 0 0 2

/-- Verified candidate data for the older depth-5 concrete logical BE. -/
def reducedDepth5Candidate : OperatorBlockEncodingCandidate Rat 3 where
  auxiliaryQubits := 1
  target := exampleTarget
  unitary := reducedDepth5Unitary
  layout := exampleLayout
  circuit := reducedDepth5Circuit
  schedule := reducedDepth5Schedule
  resource := reducedDepth5Resource
  layoutMatches := rfl
  isUnitary := IsRationalOrthogonal reducedDepth5Unitary
  blockContainsTarget :=
    ∀ row col : Fin 8,
      reducedDepth5Unitary (cleanIndex row) (cleanIndex col) =
        exampleOperator row col

/-- Verified concrete depth-5 block encoding for `E_1`. -/
def reducedDepth5Verified : VerifiedOperatorBlockEncoding Rat 3 where
  candidate := reducedDepth5Candidate
  unitaryProof := by
    unfold reducedDepth5Candidate
    exact reducedDepth5Unitary_isRationalOrthogonal
  blockProof := by
    unfold reducedDepth5Candidate
    exact reducedDepth5Unitary_cleanBlock

/-- The verified depth-5 candidate has the advertised logical-library score. -/
theorem reducedDepth5Candidate_cost :
    reducedDepth5Candidate.cost =
      { auxiliaryQubits := 1, gateCount := 6, depth := 5, oracleCalls := 0 } := by
  native_decide

/-- Verified candidate data for Pro's equality-flag/transfer BE. -/
def proEqTransferCandidate : OperatorBlockEncodingCandidate Rat 3 where
  auxiliaryQubits := 1
  target := exampleTarget
  unitary := proEqTransferUnitary
  layout := exampleLayout
  circuit := proEqTransferCircuit
  schedule := proEqTransferSchedule
  resource := proEqTransferResource
  layoutMatches := rfl
  isUnitary := IsRationalOrthogonal proEqTransferUnitary
  blockContainsTarget :=
    ∀ row col : Fin 8,
      proEqTransferUnitary (cleanIndex row) (cleanIndex col) =
        exampleOperator row col

/-- Verified concrete Pro block encoding for `E_1`. -/
def proEqTransferVerified : VerifiedOperatorBlockEncoding Rat 3 where
  candidate := proEqTransferCandidate
  unitaryProof := by
    unfold proEqTransferCandidate
    exact proEqTransferUnitary_isRationalOrthogonal
  blockProof := by
    unfold proEqTransferCandidate
    exact proEqTransferUnitary_cleanBlock

/-- The verified Pro candidate has the advertised logical-library score. -/
theorem proEqTransferCandidate_cost :
    proEqTransferCandidate.cost =
      { auxiliaryQubits := 1, gateCount := 4, depth := 4, oracleCalls := 0 } := by
  native_decide

/--
Final concrete block-encoding candidate for the one-time-bit, one-type-bit,
one-state-bit optimal-control target.  This is final only for this concrete
logical gate-matrix tier; general `k`, wider time registers, and hardware
decomposition remain separate tasks.
-/
def evolvedEqFlipCandidate : OperatorBlockEncodingCandidate Rat 3 where
  auxiliaryQubits := 1
  target := exampleTarget
  unitary := evolvedEqFlipUnitary
  layout := exampleLayout
  circuit := evolvedEqFlipCircuit
  schedule := evolvedEqFlipSchedule
  resource := evolvedEqFlipResource
  layoutMatches := rfl
  isUnitary := IsRationalOrthogonal evolvedEqFlipUnitary
  blockContainsTarget :=
    ∀ row col : Fin 8,
      evolvedEqFlipUnitary (cleanIndex row) (cleanIndex col) =
        exampleOperator row col

/-- Verified concrete depth-2 block encoding for `E_1`. -/
def evolvedEqFlipVerified : VerifiedOperatorBlockEncoding Rat 3 where
  candidate := evolvedEqFlipCandidate
  unitaryProof := by
    unfold evolvedEqFlipCandidate
    exact evolvedEqFlipUnitary_isRationalOrthogonal
  blockProof := by
    unfold evolvedEqFlipCandidate
    exact evolvedEqFlipUnitary_cleanBlock

/-- The verified evolved candidate has the advertised logical-library score. -/
theorem evolvedEqFlipCandidate_cost :
    evolvedEqFlipCandidate.cost =
      { auxiliaryQubits := 1, gateCount := 4, depth := 2, oracleCalls := 0 } := by
  native_decide

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

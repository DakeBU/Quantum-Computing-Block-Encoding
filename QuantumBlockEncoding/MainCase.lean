import QuantumBlockEncoding.BlockEncodingClassics
import QuantumBlockEncoding.CircuitSemantics

/-!
# Main-case transfer operator, Pro-isolated arm

Task `QBE-MAIN-CASE-HIER-PRO-001` fixes the concrete operator
`E_1 = |0><1|_T tensor |0><1|_tau tensor I_S` on three one-qubit system
registers ordered as `(T, tau, S)`.

The candidate below is task-local to the Pro-isolated harness.  It records the
same matrix-unit target and a concrete one-clean-signal finite permutation
candidate without importing earlier optimal-control or cold-start candidate
names as proof shortcuts.
-/

namespace QuantumBlockEncoding

/-- System-register index for one-bit registers ordered as `(T, tau, S)`. -/
def mainCaseProSystemIndex (T tau S : Fin 2) : Fin 8 :=
  ⟨4 * T.val + 2 * tau.val + S.val, by
    have hT : T.val ≤ 1 := Nat.le_of_lt_succ T.isLt
    have hTau : tau.val ≤ 1 := Nat.le_of_lt_succ tau.isLt
    have hS : S.val ≤ 1 := Nat.le_of_lt_succ S.isLt
    omega⟩

/--
The target matrix for `E_1`.

It maps `|1>_T |1>_tau |s>_S` to `|0>_T |0>_tau |s>_S`
and annihilates every other computational-basis column.
-/
def mainCaseProTarget : Matrix 8 8 Rat :=
  fun row col =>
    if (row = mainCaseProSystemIndex 0 0 0 ∧
          col = mainCaseProSystemIndex 1 1 0) ∨
        (row = mainCaseProSystemIndex 0 0 1 ∧
          col = mainCaseProSystemIndex 1 1 1) then
      1
    else
      0

/-- Operator-first target metadata for the Pro-isolated main-case benchmark. -/
def mainCaseProQueryTarget : QueryOperatorTarget Rat 8 8 where
  operator := mainCaseProTarget
  normalizer := 1
  source :=
    "QBE-MAIN-CASE-HIER-PRO-001: E_1 = |0><1|_T tensor |0><1|_tau tensor I_S"
  semanticContract :=
    "exact one-clean-signal block projection equals E_1; signalDim=2; signalIndex=0; epsilon=0"
  freeParameters := [
    "time qubits = 1",
    "type qubits = 1",
    "state qubits = 1",
    "register order = (T,tau,S)",
    "Pro insight remains isolated until task-local Lean declarations compile"
  ]

/-- The clean block-selection index for the single signal ancilla. -/
def mainCaseProSignalIndex : Fin 2 := 0

/-- Clean embedding into the signal-system product basis. -/
def mainCaseProCleanEmbed (i : Fin 8) : Fin 16 :=
  BlockEncodingClassics.productIndex mainCaseProSignalIndex i

/--
Exact clean-block predicate for a one-signal-qubit candidate matrix.

The block projection is the `(signalIndex, signalIndex)` block of `U`, and it
must equal `mainCaseProTarget` pointwise.
-/
def mainCaseProBlockProjection
    (U : Matrix (2 * 8) (2 * 8) Rat) : Prop :=
  Matrix.PointwiseEq
    (signalSystemBlockProjection 2 8 8 U mainCaseProSignalIndex)
    mainCaseProTarget

/-- Exact normalizer for the requested block encoding. -/
def mainCaseProExactNormalizer : Rat := 1

/-- Exact error for the requested block encoding. -/
def mainCaseProExactError : Rat := 0

/-- Source-facing layout: three system qubits and one clean signal ancilla. -/
def mainCaseProSourceLayout : RegisterLayout where
  systemQubits := 3
  signalQubits := 1
  pureAncillas := 0

/-- Logical `{X,CNOT,Toffoli}` transcript for the Pro equality-transfer idea. -/
def mainCaseProCircuit : Circuit :=
  [ Gate.multiControlled [(1, true), (2, true)] (Gate.oneQubit "X" 3)
  , Gate.cnot 3 2
  , Gate.cnot 3 1
  , Gate.oneQubit "X" 3
  ]

/-- Sequential high-level schedule for the current logical transcript. -/
def mainCaseProSchedule : LayeredCircuit :=
  [ [Gate.multiControlled [(1, true), (2, true)] (Gate.oneQubit "X" 3)]
  , [Gate.cnot 3 2]
  , [Gate.cnot 3 1]
  , [Gate.oneQubit "X" 3]
  ]

/--
High-level logical-library resource record for the Pro equality-transfer
transcript.  The current `Resource` type has no Toffoli field, so controlled
logical gates are counted in the `cnot` bucket at this semantic tier.
-/
def mainCaseProHighLevelResource : Resource :=
  Resource.ofCountsWithDepth 1 3 0 0 4

/-- Source-facing high-level score `(gateCount, depth, auxiliaryQubits, oracleCalls)`. -/
def mainCaseProHighLevelSeedCost : BlockEncodingCost :=
  BlockEncodingCost.fromLayoutAndResource
    mainCaseProSourceLayout mainCaseProHighLevelResource

theorem mainCaseProHighLevelSeedCost_gateCount :
    mainCaseProHighLevelSeedCost.gateCount = 4 := rfl

theorem mainCaseProHighLevelSeedCost_depth :
    mainCaseProHighLevelSeedCost.depth = 4 := rfl

theorem mainCaseProHighLevelSeedCost_auxiliaryQubits :
    mainCaseProHighLevelSeedCost.auxiliaryQubits = 1 := rfl

theorem mainCaseProHighLevelSeedCost_oracleCalls :
    mainCaseProHighLevelSeedCost.oracleCalls = 0 := rfl

/--
Matrix-table metadata for `mainCaseProCandidate`.

This incumbent is a finite permutation witness, not the advertised Pro
four-gate transcript.  The single oracle call marks the unresolved executable
realization instead of reusing `mainCaseProCircuit`.
-/
def mainCaseProMatrixTableResource : Resource :=
  Resource.ofCountsWithDepth 0 0 1 0 1

def mainCaseProMatrixTableCircuit : Circuit := []

def mainCaseProMatrixTableSchedule : LayeredCircuit := []

/--
Candidate `MAINCASE-PRO-PERM-001` as a finite image table on
`(signal,T,tau,S)` basis states.

The full index convention is `signal * 8 + mainCaseProSystemIndex T tau S`.
-/
def mainCaseProCandidateImage : Fin 16 → Fin 16
  | ⟨0, _⟩ => ⟨8, by decide⟩
  | ⟨1, _⟩ => ⟨9, by decide⟩
  | ⟨2, _⟩ => ⟨10, by decide⟩
  | ⟨3, _⟩ => ⟨11, by decide⟩
  | ⟨4, _⟩ => ⟨12, by decide⟩
  | ⟨5, _⟩ => ⟨13, by decide⟩
  | ⟨6, _⟩ => ⟨0, by decide⟩
  | ⟨7, _⟩ => ⟨1, by decide⟩
  | ⟨8, _⟩ => ⟨2, by decide⟩
  | ⟨9, _⟩ => ⟨3, by decide⟩
  | ⟨10, _⟩ => ⟨4, by decide⟩
  | ⟨11, _⟩ => ⟨5, by decide⟩
  | ⟨12, _⟩ => ⟨6, by decide⟩
  | ⟨13, _⟩ => ⟨7, by decide⟩
  | ⟨14, _⟩ => ⟨14, by decide⟩
  | ⟨15, _⟩ => ⟨15, by decide⟩
  | ⟨_ + 16, h⟩ => by omega

/-- Column-vector permutation matrix for `MAINCASE-PRO-PERM-001`. -/
def mainCaseProCandidateMatrix : Matrix (2 * 8) (2 * 8) Rat :=
  BlockEncodingClassics.permMatrix mainCaseProCandidateImage

theorem mainCaseProCandidateImage_clean_source_state0 :
    mainCaseProCandidateImage ⟨6, by decide⟩ = ⟨0, by decide⟩ := by
  native_decide

theorem mainCaseProCandidateImage_clean_source_state1 :
    mainCaseProCandidateImage ⟨7, by decide⟩ = ⟨1, by decide⟩ := by
  native_decide

theorem mainCaseProCandidateImage_injective_pointwise :
    ∀ x y : Fin 16,
      mainCaseProCandidateImage x = mainCaseProCandidateImage y → x = y := by
  native_decide

theorem mainCaseProCandidateImage_injective :
    Function.Injective mainCaseProCandidateImage := by
  intro x y h
  exact mainCaseProCandidateImage_injective_pointwise x y h

/-- Explicit inverse image table for the task-local permutation certificate. -/
def mainCaseProCandidatePreimage : Fin 16 → Fin 16
  | ⟨0, _⟩ => ⟨6, by decide⟩
  | ⟨1, _⟩ => ⟨7, by decide⟩
  | ⟨2, _⟩ => ⟨8, by decide⟩
  | ⟨3, _⟩ => ⟨9, by decide⟩
  | ⟨4, _⟩ => ⟨10, by decide⟩
  | ⟨5, _⟩ => ⟨11, by decide⟩
  | ⟨6, _⟩ => ⟨12, by decide⟩
  | ⟨7, _⟩ => ⟨13, by decide⟩
  | ⟨8, _⟩ => ⟨0, by decide⟩
  | ⟨9, _⟩ => ⟨1, by decide⟩
  | ⟨10, _⟩ => ⟨2, by decide⟩
  | ⟨11, _⟩ => ⟨3, by decide⟩
  | ⟨12, _⟩ => ⟨4, by decide⟩
  | ⟨13, _⟩ => ⟨5, by decide⟩
  | ⟨14, _⟩ => ⟨14, by decide⟩
  | ⟨15, _⟩ => ⟨15, by decide⟩
  | ⟨_ + 16, h⟩ => by omega

theorem mainCaseProCandidateImage_preimage :
    ∀ y : Fin 16,
      mainCaseProCandidateImage (mainCaseProCandidatePreimage y) = y := by
  native_decide

theorem mainCaseProCandidateImage_surjective :
    Function.Surjective mainCaseProCandidateImage := by
  intro y
  exact ⟨mainCaseProCandidatePreimage y,
    mainCaseProCandidateImage_preimage y⟩

/-- Task-local finite-permutation certificate for the candidate image. -/
def mainCaseProCandidateImageIsPermutation : Prop :=
  Function.Injective mainCaseProCandidateImage ∧
    Function.Surjective mainCaseProCandidateImage

theorem mainCaseProCandidateImage_permutation_certificate :
    mainCaseProCandidateImageIsPermutation :=
  ⟨mainCaseProCandidateImage_injective, mainCaseProCandidateImage_surjective⟩

theorem mainCaseProCandidateMatrix_isRationalOrthogonal :
    BlockEncodingClassics.IsRationalOrthogonal mainCaseProCandidateMatrix := by
  unfold mainCaseProCandidateMatrix
  exact BlockEncodingClassics.permMatrix_isRationalOrthogonal_of_bijective
    mainCaseProCandidateImage
    ⟨mainCaseProCandidateImage_injective, mainCaseProCandidateImage_surjective⟩

/-- Reduced active index for the Pro transcript bits `(tau,T,signal)`. -/
def mainCaseProReducedOfFull (x : Fin 16) : Fin 8 :=
  ⟨x.val / 2, by omega⟩

/-- Passive state bit in the full `(signal,T,tau,S)` convention. -/
def mainCaseProStateOfFull (x : Fin 16) : Fin 2 :=
  ⟨x.val % 2, Nat.mod_lt x.val (by decide)⟩

/-- Lift a reduced active-register image while preserving the passive state bit. -/
def mainCaseProLiftReducedImage (f : Fin 8 → Fin 8) (x : Fin 16) : Fin 16 :=
  ⟨2 * (f (mainCaseProReducedOfFull x)).val + (mainCaseProStateOfFull x).val, by
    have hf : (f (mainCaseProReducedOfFull x)).val < 8 :=
      (f (mainCaseProReducedOfFull x)).isLt
    have hs : (mainCaseProStateOfFull x).val < 2 :=
      (mainCaseProStateOfFull x).isLt
    omega⟩

/-- Reduced Toffoli `CCX012`, with controls `tau,T` and target `signal`. -/
def mainCaseProRedCCX012 (x : Fin 8) : Fin 8 :=
  if x.val = 3 then ⟨7, by decide⟩
  else if x.val = 7 then ⟨3, by decide⟩
  else x

/-- Reduced `CX21`, with control `signal` and target `T`. -/
def mainCaseProRedCX21 (x : Fin 8) : Fin 8 :=
  if x.val = 4 then ⟨6, by decide⟩
  else if x.val = 6 then ⟨4, by decide⟩
  else if x.val = 5 then ⟨7, by decide⟩
  else if x.val = 7 then ⟨5, by decide⟩
  else x

/-- Reduced `CX20`, with control `signal` and target `tau`. -/
def mainCaseProRedCX20 (x : Fin 8) : Fin 8 :=
  if x.val = 4 then ⟨5, by decide⟩
  else if x.val = 5 then ⟨4, by decide⟩
  else if x.val = 6 then ⟨7, by decide⟩
  else if x.val = 7 then ⟨6, by decide⟩
  else x

/-- Reduced final `X2`, flipping the signal bit. -/
def mainCaseProRedX2 (x : Fin 8) : Fin 8 :=
  if x.val = 0 then ⟨4, by decide⟩
  else if x.val = 1 then ⟨5, by decide⟩
  else if x.val = 2 then ⟨6, by decide⟩
  else if x.val = 3 then ⟨7, by decide⟩
  else if x.val = 4 then ⟨0, by decide⟩
  else if x.val = 5 then ⟨1, by decide⟩
  else if x.val = 6 then ⟨2, by decide⟩
  else ⟨3, by decide⟩

/-- Task-local reduced image for the transcript `CCX012; CX21; CX20; X2`. -/
def mainCaseProCircuitReducedImage (x : Fin 8) : Fin 8 :=
  mainCaseProRedX2
    (mainCaseProRedCX20
      (mainCaseProRedCX21
        (mainCaseProRedCCX012 x)))

/--
Task-local full image induced by the advertised Pro four-gate transcript under
the full wire map `S=0`, `tau=1`, `T=2`, `signal=3`.
-/
def mainCaseProCircuitImage : Fin 16 → Fin 16 :=
  mainCaseProLiftReducedImage mainCaseProCircuitReducedImage

theorem mainCaseProCircuitImage_clean_source_state0 :
    mainCaseProCircuitImage ⟨6, by decide⟩ = ⟨0, by decide⟩ := by
  native_decide

theorem mainCaseProCircuitImage_clean_source_state1 :
    mainCaseProCircuitImage ⟨7, by decide⟩ = ⟨1, by decide⟩ := by
  native_decide

/--
The advertised transcript and the finite-permutation incumbent differ exactly
on dirty columns `8`, `9`, `12`, and `13`.
-/
theorem mainCaseProCircuitImage_candidate_mismatch_set :
    ∀ x : Fin 16,
      (mainCaseProCircuitImage x ≠ mainCaseProCandidateImage x) ↔
        x.val ∈ [8, 9, 12, 13] := by
  native_decide

theorem mainCaseProCircuitImage_not_pointwise_candidate :
    ¬ ∀ x : Fin 16, mainCaseProCircuitImage x = mainCaseProCandidateImage x := by
  intro h
  have hneq :
      mainCaseProCircuitImage ⟨8, by decide⟩ ≠
        mainCaseProCandidateImage ⟨8, by decide⟩ := by
    native_decide
  exact hneq (h ⟨8, by decide⟩)

/-- Column-vector permutation matrix induced by the advertised Pro transcript. -/
def mainCaseProCircuitMatrix : Matrix (2 * 8) (2 * 8) Rat :=
  BlockEncodingClassics.permMatrix mainCaseProCircuitImage

theorem mainCaseProCircuitImage_injective_pointwise :
    ∀ x y : Fin 16,
      mainCaseProCircuitImage x = mainCaseProCircuitImage y → x = y := by
  native_decide

theorem mainCaseProCircuitImage_injective :
    Function.Injective mainCaseProCircuitImage := by
  intro x y h
  exact mainCaseProCircuitImage_injective_pointwise x y h

theorem mainCaseProCircuitImage_surjective_pointwise :
    ∀ y : Fin 16, ∃ x : Fin 16, mainCaseProCircuitImage x = y := by
  native_decide

theorem mainCaseProCircuitImage_surjective :
    Function.Surjective mainCaseProCircuitImage :=
  mainCaseProCircuitImage_surjective_pointwise

/-- Task-local finite-permutation certificate for the Pro transcript image. -/
def mainCaseProCircuitImageIsPermutation : Prop :=
  Function.Injective mainCaseProCircuitImage ∧
    Function.Surjective mainCaseProCircuitImage

theorem mainCaseProCircuitImage_permutation_certificate :
    mainCaseProCircuitImageIsPermutation :=
  ⟨mainCaseProCircuitImage_injective, mainCaseProCircuitImage_surjective⟩

theorem mainCaseProCircuitMatrix_isRationalOrthogonal :
    BlockEncodingClassics.IsRationalOrthogonal mainCaseProCircuitMatrix := by
  unfold mainCaseProCircuitMatrix
  exact BlockEncodingClassics.permMatrix_isRationalOrthogonal_of_bijective
    mainCaseProCircuitImage
    ⟨mainCaseProCircuitImage_injective, mainCaseProCircuitImage_surjective⟩

/-- Clean-entry calculation for the gate-derived Pro transcript image. -/
theorem mainCaseProCircuit_cleanEntry :
    ∀ row col : Fin 8,
      (if mainCaseProCleanEmbed row =
            mainCaseProCircuitImage (mainCaseProCleanEmbed col) then
          1
        else
          0) =
        mainCaseProTarget row col := by
  native_decide

theorem mainCaseProCircuit_blockProjection :
    mainCaseProBlockProjection mainCaseProCircuitMatrix := by
  intro i j
  simp [signalSystemBlockProjection, mainCaseProSignalIndex,
    mainCaseProCircuitMatrix, BlockEncodingClassics.permMatrix,
    mainCaseProTarget, mainCaseProSystemIndex,
    signalSystemBlockRowIndex, signalSystemBlockColIndex,
    mainCaseProCircuitImage, mainCaseProLiftReducedImage,
    mainCaseProReducedOfFull, mainCaseProStateOfFull,
    mainCaseProCircuitReducedImage, mainCaseProRedX2,
    mainCaseProRedCX20, mainCaseProRedCX21, mainCaseProRedCCX012]
  native_decide +revert

theorem mainCaseProTarget_support_state0 :
    mainCaseProTarget
      (mainCaseProSystemIndex 0 0 0)
      (mainCaseProSystemIndex 1 1 0) = 1 := by
  native_decide

theorem mainCaseProTarget_support_state1 :
    mainCaseProTarget
      (mainCaseProSystemIndex 0 0 1)
      (mainCaseProSystemIndex 1 1 1) = 1 := by
  native_decide

/-- Entrywise image calculation for the reusable partial-permutation wrapper. -/
theorem mainCaseProCandidate_cleanEntry :
    ∀ row col : Fin 8,
      (if mainCaseProCleanEmbed row =
            mainCaseProCandidateImage (mainCaseProCleanEmbed col) then
          1
        else
          0) =
        mainCaseProTarget row col := by
  intro row col
  simp [mainCaseProCleanEmbed, BlockEncodingClassics.productIndex,
    mainCaseProCandidateImage, mainCaseProTarget, mainCaseProSystemIndex]
  native_decide +revert

/-- Exact clean-block package from the compiled partial-permutation leaf. -/
def mainCaseProExactCleanBlockCertificate :
    BlockEncodingClassics.ExactCleanBlock 8 16 :=
  BlockEncodingClassics.partialPermutationCertificate
    mainCaseProCleanEmbed
    mainCaseProCandidateImage
    mainCaseProTarget
    mainCaseProCandidate_cleanEntry

theorem mainCaseProExactCleanBlock_correct :
    Matrix.PointwiseEq
      (BlockEncodingClassics.ExactCleanBlock.clean
        mainCaseProExactCleanBlockCertificate)
      mainCaseProTarget :=
  BlockEncodingClassics.ExactCleanBlock.clean_eq_target
    mainCaseProExactCleanBlockCertificate

theorem mainCaseProCandidate_blockProjection :
    mainCaseProBlockProjection mainCaseProCandidateMatrix := by
  intro i j
  simp [signalSystemBlockProjection, mainCaseProSignalIndex,
    mainCaseProCandidateMatrix, BlockEncodingClassics.permMatrix,
    mainCaseProTarget, mainCaseProSystemIndex,
    signalSystemBlockRowIndex, signalSystemBlockColIndex]
  native_decide +revert

theorem mainCaseProQueryTarget_normalizer :
    mainCaseProQueryTarget.normalizer = mainCaseProExactNormalizer := rfl

theorem mainCaseProSourceLayout_auxiliaryQubits :
    mainCaseProSourceLayout.auxiliaryQubits = 1 := rfl

/--
Reusable proof obligation for a later shared bridge from finite bijections to
the project-local rational-orthogonality matrix predicate.
-/
def mainCaseProRationalOrthogonalBridgeObligation : SemanticObligation where
  description :=
    "prove a shared theorem that a bijective finite image induces a rational orthogonal permMatrix"
  source := "QBE-MAIN-CASE-HIER-PRO-001, MAINCASE-PRO-ORTHO-BRIDGE-001"
  proved := true

/-- Candidate record at the finite-permutation semantic tier. -/
def mainCaseProCandidate : OperatorBlockEncodingCandidate Rat 3 where
  auxiliaryQubits := 1
  target := mainCaseProQueryTarget
  unitary := mainCaseProCandidateMatrix
  layout := mainCaseProSourceLayout
  circuit := mainCaseProMatrixTableCircuit
  schedule := mainCaseProMatrixTableSchedule
  resource := mainCaseProMatrixTableResource
  layoutMatches := rfl
  isUnitary := mainCaseProCandidateImageIsPermutation
  blockContainsTarget := mainCaseProBlockProjection mainCaseProCandidateMatrix

/-- Gate-derived candidate for the advertised Pro four-gate transcript. -/
def mainCaseProCircuitCandidate : OperatorBlockEncodingCandidate Rat 3 where
  auxiliaryQubits := 1
  target := mainCaseProQueryTarget
  unitary := mainCaseProCircuitMatrix
  layout := mainCaseProSourceLayout
  circuit := mainCaseProCircuit
  schedule := mainCaseProSchedule
  resource := mainCaseProHighLevelResource
  layoutMatches := rfl
  isUnitary := mainCaseProCircuitImageIsPermutation
  blockContainsTarget := mainCaseProBlockProjection mainCaseProCircuitMatrix

/--
Verified task-local candidate at the finite-permutation semantic tier.

This certificate proves the block entry and the image bijection.  The stronger
matrix-orthogonality bridge is closed by
`mainCaseProRationalOrthogonalBridgeObligation`.
-/
def mainCaseProVerified : VerifiedOperatorBlockEncoding Rat 3 where
  candidate := mainCaseProCandidate
  unitaryProof := by
    unfold mainCaseProCandidate
    exact mainCaseProCandidateImage_permutation_certificate
  blockProof := by
    unfold mainCaseProCandidate
    exact mainCaseProCandidate_blockProjection

/-- Verified task-local candidate for the advertised Pro transcript image. -/
def mainCaseProCircuitVerified : VerifiedOperatorBlockEncoding Rat 3 where
  candidate := mainCaseProCircuitCandidate
  unitaryProof := by
    unfold mainCaseProCircuitCandidate
    exact mainCaseProCircuitImage_permutation_certificate
  blockProof := by
    unfold mainCaseProCircuitCandidate
    exact mainCaseProCircuit_blockProjection

theorem mainCaseProCandidate_cost :
    mainCaseProCandidate.cost =
      { auxiliaryQubits := 1, gateCount := 1, depth := 1, oracleCalls := 1 } := by
  native_decide

theorem mainCaseProCandidate_uses_matrix_table_metadata :
    mainCaseProCandidate.circuit = mainCaseProMatrixTableCircuit ∧
      mainCaseProCandidate.schedule = mainCaseProMatrixTableSchedule ∧
      mainCaseProCandidate.resource = mainCaseProMatrixTableResource := by
  native_decide

theorem mainCaseProCircuitCandidate_cost :
    mainCaseProCircuitCandidate.cost =
      { auxiliaryQubits := 1, gateCount := 4, depth := 4, oracleCalls := 0 } := by
  native_decide

/-!
## Main-case transfer operator, no-Pro COLD arm

Task `QBE-MAIN-CASE-HIER-COLD-001` uses the same operator contract as the
main-case benchmark, but the declarations below are task-local to the no-Pro
isolated harness.  They use the COLD finite completion table recorded in the
cycle-2 conversion window.
-/

/-- System-register index for one-bit registers ordered as `(T, tau, S)`. -/
def mainCaseColdSystemIndex (T tau S : Fin 2) : Fin 8 :=
  ⟨4 * T.val + 2 * tau.val + S.val, by
    have hT : T.val ≤ 1 := Nat.le_of_lt_succ T.isLt
    have hTau : tau.val ≤ 1 := Nat.le_of_lt_succ tau.isLt
    have hS : S.val ≤ 1 := Nat.le_of_lt_succ S.isLt
    omega⟩

/--
The COLD target matrix for `E_1`.

It maps `|1>_T |1>_tau |s>_S` to `|0>_T |0>_tau |s>_S`
and annihilates every other computational-basis column.
-/
def mainCaseColdTarget : Matrix 8 8 Rat :=
  fun row col =>
    if (row = mainCaseColdSystemIndex 0 0 0 ∧
          col = mainCaseColdSystemIndex 1 1 0) ∨
        (row = mainCaseColdSystemIndex 0 0 1 ∧
          col = mainCaseColdSystemIndex 1 1 1) then
      1
    else
      0

/-- Exact normalizer for the no-Pro COLD target. -/
def mainCaseColdExactNormalizer : Rat := 1

/-- Exact error for the no-Pro COLD target. -/
def mainCaseColdExactError : Rat := 0

/-- Operator-first target metadata for the no-Pro COLD benchmark. -/
def mainCaseColdQueryTarget : QueryOperatorTarget Rat 8 8 where
  operator := mainCaseColdTarget
  normalizer := mainCaseColdExactNormalizer
  source :=
    "QBE-MAIN-CASE-HIER-COLD-001: E_1 = |0><1|_T tensor |0><1|_tau tensor I_S"
  semanticContract :=
    "exact one-clean-signal block projection equals E_1; signalDim=2; signalIndex=0; epsilon=0"
  freeParameters := [
    "time qubits = 1",
    "type qubits = 1",
    "state qubits = 1",
    "register order = (T,tau,S)",
    "finite completion table is task-local to the no-Pro COLD harness"
  ]

/-- The clean block-selection index for the single signal ancilla. -/
def mainCaseColdCleanSignal : Fin 2 := 0

/-- Clean embedding into the signal-system product basis. -/
def mainCaseColdCleanEmbed (i : Fin 8) : Fin 16 :=
  BlockEncodingClassics.productIndex mainCaseColdCleanSignal i

/--
Exact clean-block predicate for a one-signal-qubit COLD candidate matrix.

The block projection is the `(signal,signal) = (0,0)` block of `U`, and it
must equal `mainCaseColdTarget` pointwise.
-/
def mainCaseColdBlockProjection
    (U : Matrix (2 * 8) (2 * 8) Rat) : Prop :=
  Matrix.PointwiseEq
    (signalSystemBlockProjection 2 8 8 U mainCaseColdCleanSignal)
    mainCaseColdTarget

/-- Source-facing layout: three system qubits and one clean signal ancilla. -/
def mainCaseColdSourceLayout : RegisterLayout where
  systemQubits := 3
  signalQubits := 1
  pureAncillas := 0

/--
Candidate `MAIN-PARTIAL-PERM-001` as a COLD task-local finite image table on
the `(signal,T,tau,S)` basis.

The full index convention is `signal * 8 + mainCaseColdSystemIndex T tau S`.
-/
def mainCaseColdPartialPermImage : Fin 16 → Fin 16
  | ⟨0, _⟩ => ⟨14, by decide⟩
  | ⟨1, _⟩ => ⟨15, by decide⟩
  | ⟨2, _⟩ => ⟨8, by decide⟩
  | ⟨3, _⟩ => ⟨9, by decide⟩
  | ⟨4, _⟩ => ⟨10, by decide⟩
  | ⟨5, _⟩ => ⟨11, by decide⟩
  | ⟨6, _⟩ => ⟨0, by decide⟩
  | ⟨7, _⟩ => ⟨1, by decide⟩
  | ⟨8, _⟩ => ⟨2, by decide⟩
  | ⟨9, _⟩ => ⟨3, by decide⟩
  | ⟨10, _⟩ => ⟨4, by decide⟩
  | ⟨11, _⟩ => ⟨5, by decide⟩
  | ⟨12, _⟩ => ⟨6, by decide⟩
  | ⟨13, _⟩ => ⟨7, by decide⟩
  | ⟨14, _⟩ => ⟨12, by decide⟩
  | ⟨15, _⟩ => ⟨13, by decide⟩
  | ⟨_ + 16, h⟩ => by omega

/-- Column-vector permutation matrix for `MAIN-PARTIAL-PERM-001`. -/
def mainCaseColdPartialPermMatrix : Matrix (2 * 8) (2 * 8) Rat :=
  BlockEncodingClassics.permMatrix mainCaseColdPartialPermImage

/-- Reduced active index for the COLD table bits `(tau,T,signal)`. -/
def mainCaseColdReducedOfFull (x : Fin 16) : Fin 8 :=
  ⟨x.val / 2, by omega⟩

/-- Passive state bit in the full `(signal,T,tau,S)` convention. -/
def mainCaseColdStateOfFull (x : Fin 16) : Fin 2 :=
  ⟨x.val % 2, Nat.mod_lt x.val (by decide)⟩

/-- Lift a reduced active-register image while preserving the passive state bit. -/
def mainCaseColdLiftReducedImage (f : Fin 8 → Fin 8) (x : Fin 16) : Fin 16 :=
  ⟨2 * (f (mainCaseColdReducedOfFull x)).val +
      (mainCaseColdStateOfFull x).val, by
    have hf : (f (mainCaseColdReducedOfFull x)).val < 8 :=
      (f (mainCaseColdReducedOfFull x)).isLt
    have hs : (mainCaseColdStateOfFull x).val < 2 :=
      (mainCaseColdStateOfFull x).isLt
    omega⟩

/-- Reduced `X` on the `T` bit. -/
def mainCaseColdRedXT (x : Fin 8) : Fin 8 :=
  if x.val = 0 then ⟨2, by decide⟩
  else if x.val = 1 then ⟨3, by decide⟩
  else if x.val = 2 then ⟨0, by decide⟩
  else if x.val = 3 then ⟨1, by decide⟩
  else if x.val = 4 then ⟨6, by decide⟩
  else if x.val = 5 then ⟨7, by decide⟩
  else if x.val = 6 then ⟨4, by decide⟩
  else ⟨5, by decide⟩

/-- Reduced Toffoli with controls `tau,T` and target `signal`. -/
def mainCaseColdRedCCXTauTSignal (x : Fin 8) : Fin 8 :=
  if x.val = 3 then ⟨7, by decide⟩
  else if x.val = 7 then ⟨3, by decide⟩
  else x

/-- Reduced `X` on the `tau` bit. -/
def mainCaseColdRedXTau (x : Fin 8) : Fin 8 :=
  if x.val = 0 then ⟨1, by decide⟩
  else if x.val = 1 then ⟨0, by decide⟩
  else if x.val = 2 then ⟨3, by decide⟩
  else if x.val = 3 then ⟨2, by decide⟩
  else if x.val = 4 then ⟨5, by decide⟩
  else if x.val = 5 then ⟨4, by decide⟩
  else if x.val = 6 then ⟨7, by decide⟩
  else ⟨6, by decide⟩

/-- Reduced CNOT with control `signal` and target `T`. -/
def mainCaseColdRedCXSignalT (x : Fin 8) : Fin 8 :=
  if x.val = 4 then ⟨6, by decide⟩
  else if x.val = 6 then ⟨4, by decide⟩
  else if x.val = 5 then ⟨7, by decide⟩
  else if x.val = 7 then ⟨5, by decide⟩
  else x

/-- Reduced CNOT with control `tau` and target `signal`. -/
def mainCaseColdRedCXTauSignal (x : Fin 8) : Fin 8 :=
  if x.val = 1 then ⟨5, by decide⟩
  else if x.val = 5 then ⟨1, by decide⟩
  else if x.val = 3 then ⟨7, by decide⟩
  else if x.val = 7 then ⟨3, by decide⟩
  else x

/-- Evaluate reduced logical reversible gates as basis-state permutations. -/
def mainCaseColdEvalReducedGateImages
    (gates : List (Fin 8 → Fin 8)) (x : Fin 8) : Fin 8 :=
  gates.foldl (fun y gateImage => gateImage y) x

/-- Reduced COLD table induced by `mainCaseColdPartialPermImage`. -/
def mainCaseColdPartialPermReducedImage (x : Fin 8) : Fin 8 :=
  if x.val = 0 then ⟨7, by decide⟩
  else if x.val = 1 then ⟨4, by decide⟩
  else if x.val = 2 then ⟨5, by decide⟩
  else if x.val = 3 then ⟨0, by decide⟩
  else if x.val = 4 then ⟨1, by decide⟩
  else if x.val = 5 then ⟨2, by decide⟩
  else if x.val = 6 then ⟨3, by decide⟩
  else ⟨6, by decide⟩

/-- Reduced gate-image transcript for the COLD resource schema. -/
def mainCaseColdReducedGateImages : List (Fin 8 → Fin 8) :=
  [ mainCaseColdRedXT
  , mainCaseColdRedCCXTauTSignal
  , mainCaseColdRedXTau
  , mainCaseColdRedCXSignalT
  , mainCaseColdRedCXTauSignal
  ]

/-- Reduced active-register image induced by the COLD resource schema. -/
def mainCaseColdCircuitReducedImage (x : Fin 8) : Fin 8 :=
  mainCaseColdEvalReducedGateImages mainCaseColdReducedGateImages x

/-- The COLD logical reversible circuit implements the reduced table. -/
theorem mainCaseColdReducedGateImages_eval :
    ∀ x : Fin 8,
      mainCaseColdCircuitReducedImage x =
        mainCaseColdPartialPermReducedImage x := by
  native_decide

/-- Full active-plus-passive image induced by the COLD resource schema. -/
def mainCaseColdCircuitImage : Fin 16 → Fin 16 :=
  mainCaseColdLiftReducedImage mainCaseColdCircuitReducedImage

/-- The COLD logical reversible circuit implements the finite table. -/
theorem mainCaseColdCircuitImage_eq_partialPermImage :
    ∀ x : Fin 16,
      mainCaseColdCircuitImage x = mainCaseColdPartialPermImage x := by
  native_decide

/-- Logical `X` on the time register `T` in the full wire layout. -/
def mainCaseColdGateXT : Gate :=
  Gate.oneQubit "X" 2

/-- Logical Toffoli with controls `tau,T` and target `signal`. -/
def mainCaseColdGateCCXTauTSignal : Gate :=
  Gate.multiControlled [(1, true), (2, true)] (Gate.oneQubit "X" 3)

/-- Logical `X` on the type register `tau` in the full wire layout. -/
def mainCaseColdGateXTau : Gate :=
  Gate.oneQubit "X" 1

/-- Logical CNOT with control `signal` and target `T`. -/
def mainCaseColdGateCXSignalT : Gate :=
  Gate.cnot 3 2

/-- Logical CNOT with control `tau` and target `signal`. -/
def mainCaseColdGateCXTauSignal : Gate :=
  Gate.cnot 1 3

/-- COLD task-local logical circuit for the finite partial-permutation table. -/
def mainCaseColdCircuit : Circuit :=
  [ mainCaseColdGateXT
  , mainCaseColdGateCCXTauTSignal
  , mainCaseColdGateXTau
  , mainCaseColdGateCXSignalT
  , mainCaseColdGateCXTauSignal
  ]

/-- Sequential COLD schedule for the current logical transcript. -/
def mainCaseColdSchedule : LayeredCircuit :=
  [ [mainCaseColdGateXT]
  , [mainCaseColdGateCCXTauTSignal]
  , [mainCaseColdGateXTau]
  , [mainCaseColdGateCXSignalT]
  , [mainCaseColdGateCXTauSignal]
  ]

/--
High-level logical-library resource record for the COLD transcript.  At this
semantic tier, Toffoli and CNOT are counted together as controlled logical
gates, matching the main-case resource convention.
-/
def mainCaseColdHighLevelResource : Resource :=
  Resource.ofCountsWithDepth 2 3 0 0 5

/-- Source-facing COLD score `(gateCount, depth, auxiliaryQubits, oracleCalls)`. -/
def mainCaseColdPartialPermCost : BlockEncodingCost :=
  BlockEncodingCost.fromLayoutAndResource
    mainCaseColdSourceLayout mainCaseColdHighLevelResource

theorem mainCaseColdPartialPermCost_gateCount :
    mainCaseColdPartialPermCost.gateCount = 5 := rfl

theorem mainCaseColdPartialPermCost_depth :
    mainCaseColdPartialPermCost.depth = 5 := rfl

theorem mainCaseColdPartialPermCost_auxiliaryQubits :
    mainCaseColdPartialPermCost.auxiliaryQubits = 1 := rfl

theorem mainCaseColdPartialPermCost_oracleCalls :
    mainCaseColdPartialPermCost.oracleCalls = 0 := rfl

theorem mainCaseColdPartialPermImage_injective_pointwise :
    ∀ x y : Fin 16,
      mainCaseColdPartialPermImage x = mainCaseColdPartialPermImage y → x = y := by
  native_decide

theorem mainCaseColdPartialPermImage_injective :
    Function.Injective mainCaseColdPartialPermImage := by
  intro x y h
  exact mainCaseColdPartialPermImage_injective_pointwise x y h

/-- Explicit inverse image table for the COLD partial-permutation certificate. -/
def mainCaseColdPartialPermPreimage : Fin 16 → Fin 16
  | ⟨0, _⟩ => ⟨6, by decide⟩
  | ⟨1, _⟩ => ⟨7, by decide⟩
  | ⟨2, _⟩ => ⟨8, by decide⟩
  | ⟨3, _⟩ => ⟨9, by decide⟩
  | ⟨4, _⟩ => ⟨10, by decide⟩
  | ⟨5, _⟩ => ⟨11, by decide⟩
  | ⟨6, _⟩ => ⟨12, by decide⟩
  | ⟨7, _⟩ => ⟨13, by decide⟩
  | ⟨8, _⟩ => ⟨2, by decide⟩
  | ⟨9, _⟩ => ⟨3, by decide⟩
  | ⟨10, _⟩ => ⟨4, by decide⟩
  | ⟨11, _⟩ => ⟨5, by decide⟩
  | ⟨12, _⟩ => ⟨14, by decide⟩
  | ⟨13, _⟩ => ⟨15, by decide⟩
  | ⟨14, _⟩ => ⟨0, by decide⟩
  | ⟨15, _⟩ => ⟨1, by decide⟩
  | ⟨_ + 16, h⟩ => by omega

theorem mainCaseColdPartialPermImage_preimage :
    ∀ y : Fin 16,
      mainCaseColdPartialPermImage (mainCaseColdPartialPermPreimage y) = y := by
  native_decide

theorem mainCaseColdPartialPermImage_surjective :
    Function.Surjective mainCaseColdPartialPermImage := by
  intro y
  exact ⟨mainCaseColdPartialPermPreimage y,
    mainCaseColdPartialPermImage_preimage y⟩

/-- Task-local finite-permutation certificate for `MAIN-PARTIAL-PERM-001`. -/
def mainCaseColdPartialPermImageIsPermutation : Prop :=
  Function.Injective mainCaseColdPartialPermImage ∧
    Function.Surjective mainCaseColdPartialPermImage

theorem mainCaseColdPartialPermImage_bijective :
    mainCaseColdPartialPermImageIsPermutation :=
  ⟨mainCaseColdPartialPermImage_injective,
    mainCaseColdPartialPermImage_surjective⟩

/-- Entrywise image calculation for the reusable partial-permutation wrapper. -/
theorem mainCaseColdPartialPerm_entry :
    ∀ row col : Fin 8,
      (if mainCaseColdCleanEmbed row =
            mainCaseColdPartialPermImage (mainCaseColdCleanEmbed col) then
          1
        else
          0) =
        mainCaseColdTarget row col := by
  intro row col
  simp [mainCaseColdCleanEmbed, BlockEncodingClassics.productIndex,
    mainCaseColdCleanSignal, mainCaseColdPartialPermImage,
    mainCaseColdTarget, mainCaseColdSystemIndex]
  native_decide +revert

/-- Exact clean-block package from the compiled partial-permutation leaf. -/
def mainCaseColdPartialPermExactCleanBlock :
    BlockEncodingClassics.ExactCleanBlock 8 16 :=
  BlockEncodingClassics.partialPermutationCertificate
    mainCaseColdCleanEmbed
    mainCaseColdPartialPermImage
    mainCaseColdTarget
    mainCaseColdPartialPerm_entry

theorem mainCaseColdPartialPerm_clean_eq_target :
    Matrix.PointwiseEq
      (BlockEncodingClassics.ExactCleanBlock.clean
        mainCaseColdPartialPermExactCleanBlock)
      mainCaseColdTarget :=
  BlockEncodingClassics.ExactCleanBlock.clean_eq_target
    mainCaseColdPartialPermExactCleanBlock

theorem mainCaseColdPartialPerm_blockProjection :
    mainCaseColdBlockProjection mainCaseColdPartialPermMatrix := by
  intro i j
  simp [signalSystemBlockProjection, mainCaseColdCleanSignal,
    mainCaseColdPartialPermMatrix, BlockEncodingClassics.permMatrix,
    mainCaseColdTarget, mainCaseColdSystemIndex,
    signalSystemBlockRowIndex, signalSystemBlockColIndex]
  native_decide +revert

theorem mainCaseColdQueryTarget_normalizer :
    mainCaseColdQueryTarget.normalizer = mainCaseColdExactNormalizer := rfl

theorem mainCaseColdSourceLayout_auxiliaryQubits :
    mainCaseColdSourceLayout.auxiliaryQubits = 1 := rfl

/--
Resource-schema obligation for `MAIN-RESOURCE-001`.

The finite permutation and clean block are proved, but a complete COLD
candidate package still needs a task-local circuit or schedule whose gate count
and depth justify the advertised resource tuple.
-/
def mainCaseColdResourceSchemaObligation : SemanticObligation where
  description :=
    "derive a COLD-local circuit/schedule and honest resource tuple before packaging a verified candidate"
  source := "QBE-MAIN-CASE-HIER-COLD-001, MAIN-RESOURCE-001"
  proved := false

end QuantumBlockEncoding

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
  proved := false

/-- Candidate record at the finite-permutation semantic tier. -/
def mainCaseProCandidate : OperatorBlockEncodingCandidate Rat 3 where
  auxiliaryQubits := 1
  target := mainCaseProQueryTarget
  unitary := mainCaseProCandidateMatrix
  layout := mainCaseProSourceLayout
  circuit := mainCaseProCircuit
  schedule := mainCaseProSchedule
  resource := mainCaseProHighLevelResource
  layoutMatches := rfl
  isUnitary := mainCaseProCandidateImageIsPermutation
  blockContainsTarget := mainCaseProBlockProjection mainCaseProCandidateMatrix

/--
Verified task-local candidate at the finite-permutation semantic tier.

This certificate proves the block entry and the image bijection.  The stronger
matrix-orthogonality bridge is recorded by
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

theorem mainCaseProCandidate_cost :
    mainCaseProCandidate.cost =
      { auxiliaryQubits := 1, gateCount := 4, depth := 4, oracleCalls := 0 } := by
  native_decide

end QuantumBlockEncoding

import QuantumBlockEncoding.BlockEncoding
import QuantumBlockEncoding.CircuitSemantics

/-!
# Strict cold-start transfer-operator target

Task `QBE-OP-OPTCTRL-COLD-CLEAN-001` fixes the concrete operator
`E_1 = |0><1|_T tensor |0><1|_tau tensor I_S` on three one-qubit system
registers ordered as `(T, tau, S)`.

This file records only the target-side contract for the first lower Lean
packet.  Candidate circuits, permutation proofs, and resource certification are
separate leaves.
-/

namespace QuantumBlockEncoding

/-- System-register index for one-bit registers ordered as `(T, tau, S)`. -/
def coldE1SystemIndex (T tau S : Fin 2) : Fin 8 :=
  ⟨4 * T.val + 2 * tau.val + S.val, by
    have hT : T.val ≤ 1 := Nat.le_of_lt_succ T.isLt
    have hTau : tau.val ≤ 1 := Nat.le_of_lt_succ tau.isLt
    have hS : S.val ≤ 1 := Nat.le_of_lt_succ S.isLt
    omega⟩

/--
The target matrix for `E_1`.

It has support exactly on the two entries mapping
`|1>_T |1>_tau |s>_S` to `|0>_T |0>_tau |s>_S`.
-/
def coldE1Target : Matrix 8 8 Rat :=
  fun row col =>
    if (row = coldE1SystemIndex 0 0 0 ∧ col = coldE1SystemIndex 1 1 0) ∨
        (row = coldE1SystemIndex 0 0 1 ∧ col = coldE1SystemIndex 1 1 1) then
      1
    else
      0

/-- Operator-first target metadata for the strict cold-start benchmark. -/
def coldE1QueryTarget : QueryOperatorTarget Rat 8 8 where
  operator := coldE1Target
  normalizer := 1
  source := "QBE-OP-OPTCTRL-COLD-CLEAN-001: E_1 = |0><1|_T tensor |0><1|_tau tensor I_S"
  semanticContract :=
    "exact one-clean-signal block projection equals E_1; signalDim=2; signalIndex=0; epsilon=0"
  freeParameters := [
    "time qubits = 1",
    "type qubits = 1",
    "state qubits = 1",
    "register order = (T,tau,S)"
  ]

/-- The clean block-selection index for the single signal ancilla. -/
def coldE1SignalIndex : Fin 2 := 0

/--
Exact clean-block predicate for a one-signal-qubit candidate matrix.

The block projection is the `(signalIndex, signalIndex)` block of `U`, and it
must equal `coldE1Target` pointwise.
-/
def coldE1BlockProjection
    (U : Matrix (2 * 8) (2 * 8) Rat) : Prop :=
  Matrix.PointwiseEq
    (signalSystemBlockProjection 2 8 8 U coldE1SignalIndex)
    coldE1Target

/-- Exact normalizer for the requested block encoding. -/
def coldE1ExactNormalizer : Rat := 1

/-- Exact error for the requested block encoding. -/
def coldE1ExactError : Rat := 0

/-- Source-facing layout: three system qubits and one clean signal ancilla. -/
def coldE1SourceLayout : RegisterLayout where
  systemQubits := 3
  signalQubits := 1
  pureAncillas := 0

/--
Source-facing seed cost under the high-level reversible-gate convention in the
conversion window.  This is not a certified `Circuit.resource` expansion.
-/
def coldE1HighLevelSeedCost : BlockEncodingCost where
  auxiliaryQubits := 1
  gateCount := 4
  depth := 4
  oracleCalls := 0

theorem coldE1HighLevelSeedCost_gateCount :
    coldE1HighLevelSeedCost.gateCount = 4 := rfl

theorem coldE1HighLevelSeedCost_depth :
    coldE1HighLevelSeedCost.depth = 4 := rfl

theorem coldE1HighLevelSeedCost_auxiliaryQubits :
    coldE1HighLevelSeedCost.auxiliaryQubits = 1 := rfl

theorem coldE1HighLevelSeedCost_oracleCalls :
    coldE1HighLevelSeedCost.oracleCalls = 0 := rfl

/--
Candidate `COLD-CLEAN-PERM-001` as a finite image table on
`(signal,T,tau,S)` basis states.

The full index convention is `signal * 8 + coldE1SystemIndex T tau S`.
-/
def coldE1CandidateImage : Fin 16 → Fin 16
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

/-- Column-vector permutation matrix for `COLD-CLEAN-PERM-001`. -/
def coldE1CandidateMatrix : Matrix (2 * 8) (2 * 8) Rat :=
  fun row col => if row = coldE1CandidateImage col then 1 else 0

theorem coldE1CandidateImage_clean_source_state0 :
    coldE1CandidateImage ⟨6, by decide⟩ = ⟨0, by decide⟩ := by
  native_decide

theorem coldE1CandidateImage_clean_source_state1 :
    coldE1CandidateImage ⟨7, by decide⟩ = ⟨1, by decide⟩ := by
  native_decide

theorem coldE1CandidateImage_injective_pointwise :
    ∀ x y : Fin 16, coldE1CandidateImage x = coldE1CandidateImage y → x = y := by
  native_decide

theorem coldE1CandidateImage_injective :
    Function.Injective coldE1CandidateImage := by
  intro x y h
  exact coldE1CandidateImage_injective_pointwise x y h

/-- Explicit inverse image table for the task-local permutation certificate. -/
def coldE1CandidatePreimage : Fin 16 → Fin 16
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

theorem coldE1CandidateImage_preimage :
    ∀ y : Fin 16, coldE1CandidateImage (coldE1CandidatePreimage y) = y := by
  native_decide

theorem coldE1CandidateImage_surjective :
    Function.Surjective coldE1CandidateImage := by
  intro y
  exact ⟨coldE1CandidatePreimage y, coldE1CandidateImage_preimage y⟩

theorem coldE1CandidateImage_permutation_certificate :
    Function.Injective coldE1CandidateImage ∧
      Function.Surjective coldE1CandidateImage :=
  ⟨coldE1CandidateImage_injective, coldE1CandidateImage_surjective⟩

theorem coldE1Target_support_state0 :
    coldE1Target (coldE1SystemIndex 0 0 0) (coldE1SystemIndex 1 1 0) = 1 := by
  native_decide

theorem coldE1Target_support_state1 :
    coldE1Target (coldE1SystemIndex 0 0 1) (coldE1SystemIndex 1 1 1) = 1 := by
  native_decide

theorem coldE1Candidate_blockProjection :
    coldE1BlockProjection coldE1CandidateMatrix := by
  intro i j
  simp [signalSystemBlockProjection, coldE1SignalIndex,
    coldE1CandidateMatrix, coldE1Target, coldE1SystemIndex,
    signalSystemBlockRowIndex, signalSystemBlockColIndex]
  native_decide +revert

theorem coldE1QueryTarget_normalizer :
    coldE1QueryTarget.normalizer = coldE1ExactNormalizer := rfl

theorem coldE1SourceLayout_auxiliaryQubits :
    coldE1SourceLayout.auxiliaryQubits = 1 := rfl

end QuantumBlockEncoding

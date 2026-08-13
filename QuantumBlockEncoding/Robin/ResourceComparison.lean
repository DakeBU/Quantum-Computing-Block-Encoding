import QuantumBlockEncoding.Robin.EvolvedCandidates

/-!
# Honest Robin resource comparison boundary
-/

namespace QuantumBlockEncoding.Robin

inductive RobinSemanticTier where
  | paperTranscript
  | exactStructuralLCU
  | exactLogicalUnitary
  | exactPrimitiveCircuit
deriving Repr, DecidableEq

structure RobinResourceRow where
  identity : String
  tier : RobinSemanticTier
  convention : String
  cost : Option BlockEncodingCost
  blockedLeaf : Option String
deriving Repr, DecidableEq

def warmRobinPrimitiveConvention : String :=
  "logical one-qubit rotations plus CNOT; SWAP is three CNOTs; all truth-table logic, PREPARE, SELECT, and uncompute are expanded"

def warmRobinSourceResourceRow : RobinResourceRow where
  identity := "source-standard-Ry-fixed-N8"
  tier := .paperTranscript
  convention := warmRobinPrimitiveConvention
  cost := none
  blockedLeaf := some "source oracle matrices and primitive expansion remain open"

def warmRobinFiveShiftResourceRow : RobinResourceRow where
  identity := "five-shift-weighted-permutation"
  tier := .exactStructuralLCU
  convention := warmRobinPrimitiveConvention
  cost := none
  blockedLeaf := some warmRobinStructuralCandidateBlockedLeaf

def warmRobinHadamard8ResourceRow : RobinResourceRow where
  identity := "hadamard-eight-weighted-permutation"
  tier := .exactLogicalUnitary
  convention := warmRobinPrimitiveConvention
  cost := none
  blockedLeaf := some warmRobinStructuralCandidateBlockedLeaf

inductive RobinComparison where
  | dominates
  | tied
  | incomparable
deriving Repr, DecidableEq

noncomputable def compareRobinRows
    (candidate baseline : RobinResourceRow) : RobinComparison := by
  classical
  exact if candidate.tier != baseline.tier ||
      candidate.convention != baseline.convention then
    .incomparable
  else
    match candidate.cost, baseline.cost with
    | some x, some y =>
        if x.betterThan y then .dominates
        else if x = y then .tied else .incomparable
    | _, _ => .incomparable

theorem warmRobinFiveShift_source_incomparable :
    compareRobinRows warmRobinFiveShiftResourceRow warmRobinSourceResourceRow =
      .incomparable := by
  simp [compareRobinRows, warmRobinFiveShiftResourceRow,
    warmRobinSourceResourceRow]

theorem warmRobinHadamard8_source_incomparable :
    compareRobinRows warmRobinHadamard8ResourceRow warmRobinSourceResourceRow =
      .incomparable := by
  simp [compareRobinRows, warmRobinHadamard8ResourceRow,
    warmRobinSourceResourceRow]

end QuantumBlockEncoding.Robin

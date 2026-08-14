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

/-- Historical paper-literal transcript row. This is not the certified fixed-N8
standard-RY realization, whose exact primitive cost is recorded in
`T3ResourceComparison.lean`. -/
def warmRobinPaperLiteralTranscriptResourceRow : RobinResourceRow where
  identity := "paper-literal-unexpanded-transcript"
  tier := .paperTranscript
  convention := warmRobinPrimitiveConvention
  cost := none
  blockedLeaf := some
    "arbitrary-n source interpretation and the paper-literal single-arccos convention remain open"

def warmRobinFiveShiftResourceRow : RobinResourceRow where
  identity := "five-shift-weighted-permutation"
  tier := .exactStructuralLCU
  convention := warmRobinPrimitiveConvention
  cost := none
  blockedLeaf := some warmRobinHistoricalStructuralCandidateBlockedLeaf

def warmRobinHadamard8ResourceRow : RobinResourceRow where
  identity := "hadamard-eight-weighted-permutation"
  tier := .exactLogicalUnitary
  convention := warmRobinPrimitiveConvention
  cost := none
  blockedLeaf := none

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

theorem warmRobinFiveShift_paperTranscript_incomparable :
    compareRobinRows warmRobinFiveShiftResourceRow
        warmRobinPaperLiteralTranscriptResourceRow =
      .incomparable := by
  simp [compareRobinRows, warmRobinFiveShiftResourceRow,
    warmRobinPaperLiteralTranscriptResourceRow]

theorem warmRobinHadamard8_paperTranscript_incomparable :
    compareRobinRows warmRobinHadamard8ResourceRow
        warmRobinPaperLiteralTranscriptResourceRow =
      .incomparable := by
  simp [compareRobinRows, warmRobinHadamard8ResourceRow,
    warmRobinPaperLiteralTranscriptResourceRow]

/-- Historical compatibility alias; this row is generic and paper-literal, not
the certified fixed-N8 standard-RY source realization. -/
abbrev warmRobinSourceResourceRow : RobinResourceRow :=
  warmRobinPaperLiteralTranscriptResourceRow

theorem warmRobinFiveShift_source_incomparable :
    compareRobinRows warmRobinFiveShiftResourceRow warmRobinSourceResourceRow =
      .incomparable :=
  warmRobinFiveShift_paperTranscript_incomparable

theorem warmRobinHadamard8_source_incomparable :
    compareRobinRows warmRobinHadamard8ResourceRow warmRobinSourceResourceRow =
      .incomparable :=
  warmRobinHadamard8_paperTranscript_incomparable

end QuantumBlockEncoding.Robin

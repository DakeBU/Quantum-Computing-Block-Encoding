import QuantumBlockEncoding.Robin.PaperSevenT3
import QuantumBlockEncoding.Robin.Figure4T3
import QuantumBlockEncoding.Robin.SymmetryXorFourSlotPrimitive

/-!
# Same-tier Robin T3 resource comparisons

Every count below reduces from the corresponding `PrimitiveProgram` circuit
list.  The comparison fixes exact global-phase semantics, all-to-all
connectivity, little-endian indexing, zero oracle calls, and lexicographic
order `(gate count, depth, auxiliary qubits, oracle calls)`.
-/

namespace QuantumBlockEncoding.Robin

set_option maxRecDepth 100000

theorem warmRobinPaperSevenPrimitiveResource_exact :
    warmRobinPaperSevenPrimitiveResource = {
      oneQubit := 137
      cnot := 175
      oracleCalls := 0
      pureAncilla := 0
      depth := 266
    } := by
  decide

theorem warmRobinXorFourSlotPrimitiveResource_exact :
    warmRobinXorFourSlotPrimitiveResource = {
      oneQubit := 38
      cnot := 68
      oracleCalls := 0
      pureAncilla := 0
      depth := 96
    } := by
  decide

theorem warmRobinFigure4PrimitiveResource_exact :
    warmRobinFigure4PrimitiveResource = {
      oneQubit := 427
      cnot := 454
      oracleCalls := 0
      pureAncilla := 0
      depth := 674
    } := by
  decide

/-- The accepted XOR route uses 106 gates versus the source normal form's 312;
the later score fields therefore do not decide this comparison. -/
theorem warmRobinFourSlotT3Cost_betterThan_paperSeven :
    warmRobinXorFourSlotPrimitiveOperatorCandidate.cost.betterThan
      warmRobinPaperSevenPrimitiveOperatorCandidate.cost := by
  unfold BlockEncodingCost.betterThan
  left
  change warmRobinXorFourSlotPrimitiveResource.gates <
    warmRobinPaperSevenPrimitiveResource.gates
  rw [warmRobinXorFourSlotPrimitiveResource_exact,
    warmRobinPaperSevenPrimitiveResource_exact]
  decide

/-- Under the fixed exact primitive convention, the XOR four-slot route uses
106 gates while the fixed-N8 Figure-4 realization uses 881.  This theorem does
not assert optimality outside that declared compiler and score convention. -/
theorem warmRobinFourSlotT3Cost_betterThan_figure4 :
    warmRobinXorFourSlotPrimitiveOperatorCandidate.cost.betterThan
      warmRobinFigure4PrimitiveOperatorCandidate.cost := by
  unfold BlockEncodingCost.betterThan
  left
  change warmRobinXorFourSlotPrimitiveResource.gates <
    warmRobinFigure4PrimitiveResource.gates
  rw [warmRobinXorFourSlotPrimitiveResource_exact,
    warmRobinFigure4PrimitiveResource_exact]
  decide

/-- The best fully verified Robin candidate under the frozen T3 comparison. -/
noncomputable abbrev warmRobinBestVerified :
    VerifiedOperatorBlockEncoding ℂ 3 :=
  warmRobinXorFourSlotPrimitiveVerifiedBlockEncoding

/-- Machine-readable publication guard, enabled only after both source-side
same-tier comparisons have compiled. -/
def paperLevelWinnerCertified : Bool := true

end QuantumBlockEncoding.Robin

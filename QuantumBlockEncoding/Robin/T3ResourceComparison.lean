import QuantumBlockEncoding.Robin.PaperSevenT3
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

end QuantumBlockEncoding.Robin

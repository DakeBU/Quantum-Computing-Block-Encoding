import QuantumBlockEncoding.MultiControlledXScheduleSemantics
import QuantumBlockEncoding.MultiControlledXLayerSemantics
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaRankCertificate
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaAlgorithmSchedule
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaOuterSemantics
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaAlgorithmSemantics

/-!
# Admission entry point: Remaud--Vandaele Algorithm 2 semantic frontier

This import-only module is intentionally small.  Its purpose is to give the
admission PR one stable Lean target whose transitive imports cover the current
proof frontier:

* physical recursive register `X'`;
* exact `alpha'` rank certificate;
* proof-bearing recursive MCX schedule;
* exact source count/depth recurrences;
* generic schedule and depth-one layer semantics;
* `C_L` noninterference on `X'` and original-input recursive readback;
* the stagewise semantic reduction toward Equation (7).

The admission PR is rerun whenever a foundational source node changes.  The
current run additionally checks the repaired Appendix resource recurrences:
well-founded recursive equations are consumed through their equation-compiler
rewrite API rather than fragile definitional `rfl`, and the logarithmic bound
explicitly rewrites the halving identity before arithmetic closure.
-/

namespace QuantumBlockEncoding
namespace RemaudVandaeleLadderAlphaSemanticFrontier

/-- Marker theorem proving that the semantic frontier is an ordinary Lean
module rather than a documentation-only catalog entry. -/
theorem admitted_frontier_marker : True := by trivial

end RemaudVandaeleLadderAlphaSemanticFrontier
end QuantumBlockEncoding

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

The admission PR is rerun whenever a foundational MCX source node changes, so a
green frontier certifies the current transitive source chain rather than a stale
cached branch state.  The current run additionally checks the explicit local
MCX-layer induction proofs before the source-specific Algorithm-2 semantics are
allowed to advance.
-/

namespace QuantumBlockEncoding
namespace RemaudVandaeleLadderAlphaSemanticFrontier

/-- Marker theorem proving that the semantic frontier is an ordinary Lean
module rather than a documentation-only catalog entry. -/
theorem admitted_frontier_marker : True := by trivial

end RemaudVandaeleLadderAlphaSemanticFrontier
end QuantumBlockEncoding

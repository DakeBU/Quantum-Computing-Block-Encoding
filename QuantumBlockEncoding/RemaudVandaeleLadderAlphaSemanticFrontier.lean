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
* the stagewise semantic reduction toward Equation (7).

Once this frontier is green, later source-semantics lemmas can be added below
this node without re-opening the already closed combinatorial/resource layers.
-/

namespace QuantumBlockEncoding
namespace RemaudVandaeleLadderAlphaSemanticFrontier

/-- Marker theorem proving that the semantic frontier is an ordinary Lean
module rather than a documentation-only catalog entry. -/
theorem admitted_frontier_marker : True := by trivial

end RemaudVandaeleLadderAlphaSemanticFrontier
end QuantumBlockEncoding

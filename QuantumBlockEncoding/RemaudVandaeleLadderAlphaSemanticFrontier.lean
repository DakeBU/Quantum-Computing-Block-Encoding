import QuantumBlockEncoding.MultiControlledXScheduleSemantics
import QuantumBlockEncoding.MultiControlledXLayerSemantics
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaRankCertificate
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaAlgorithmSchedule
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaOuterSemantics
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaAlgorithmSemantics

/-!
# Admission entry point: Remaud--Vandaele Algorithm 2 semantic frontier

This import-only module gives the admission PR one stable Lean target whose
transitive imports cover the current proof frontier: physical `X'`, exact
`alpha'` rank, the proof-bearing Algorithm-2 schedule, source resource
recurrences, generic MCX semantics, `C_L` noninterference, and the stagewise
reduction toward Equation (7).

This run checks Algorithm 2's recursive target order explicitly.  In the
ordinary branch the source indices are `2j+2`; in the even-k special-tail branch
the final child target is `k-3`.  The proof now exposes the parity/last-index
conditions to arithmetic reasoning, unfolds the final compact index directly,
and proves equality of mapped final targets by congruence rather than applying
injectivity in the wrong direction.
-/

namespace QuantumBlockEncoding
namespace RemaudVandaeleLadderAlphaSemanticFrontier

theorem admitted_frontier_marker : True := by trivial

end RemaudVandaeleLadderAlphaSemanticFrontier
end QuantumBlockEncoding

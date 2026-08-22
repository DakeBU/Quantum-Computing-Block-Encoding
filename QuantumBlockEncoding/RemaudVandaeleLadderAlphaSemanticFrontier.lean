import QuantumBlockEncoding.MultiControlledXScheduleSemantics
import QuantumBlockEncoding.MultiControlledXLayerSemantics
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaRankCertificate
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaAlgorithmSchedule
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaOuterSemantics
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaAlgorithmSemantics

/-!
# Admission entry point: Remaud--Vandaele Algorithm 2 semantic frontier

This import-only module gives the admission PR one stable Lean target whose
transitive imports cover physical `X'`, exact `alpha'` rank, the proof-bearing
Algorithm-2 schedule, generic MCX semantics, `C_L` noninterference, and the
stagewise reduction toward Equation (7).

This run proceeds past the now-verified recursive source-target ordering and
checks target membership/rank in the unfiltered physical interval.  The alpha_0
lower bound is expressed directly as index monotonicity, proof-irrelevant `Fin`
representatives of the same physical offset are identified through the existing
interval-wire theorem, and the exact list rank uses Mathlib's current
`List.get_idxOf` API rather than the removed dot-field form.
-/

namespace QuantumBlockEncoding
namespace RemaudVandaeleLadderAlphaSemanticFrontier

theorem admitted_frontier_marker : True := by trivial

end RemaudVandaeleLadderAlphaSemanticFrontier
end QuantumBlockEncoding

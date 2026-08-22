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

This run checks the final selected-register endpoint equalities explicitly:
the zero source index is exposed to `Fin` order, and the recursive end wire is
recovered by the exact natural-number identity `a + (b-a) = b` under `a ≤ b`.
-/

namespace QuantumBlockEncoding
namespace RemaudVandaeleLadderAlphaSemanticFrontier

theorem admitted_frontier_marker : True := by trivial

end RemaudVandaeleLadderAlphaSemanticFrontier
end QuantumBlockEncoding

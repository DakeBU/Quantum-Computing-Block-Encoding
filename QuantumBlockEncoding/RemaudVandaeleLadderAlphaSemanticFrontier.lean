import QuantumBlockEncoding.MultiControlledXScheduleSemantics
import QuantumBlockEncoding.MultiControlledXLayerSemantics
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaRankCertificate
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaAlgorithmSchedule
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaTargetSupport
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaOuterSemantics
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaOuterIndexCoverage
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaSelectedOrder
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaIntervalFactorization
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaCancellationAlgebra
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaAlgorithmSemantics

/-!
# Admission entry point: Remaud--Vandaele Algorithm 2 semantic frontier

This import-only module gives the admission PR one stable Lean target whose
transitive imports cover physical `X'`, exact `alpha'` rank, the proof-bearing
Algorithm-2 schedule, generic MCX semantics, `C_L` noninterference, the
recursive-target semantic bridge, and the stagewise reduction toward Equation
(7).

The current frontier additionally exposes the geometry needed by the final
strong induction.  The two outer walls now have an explicit source-index
coverage API distinguishing the even-k child special target `k-3` from the
extra final left-wall gate `k-2`; the filtered recursive register is certified
to preserve strict physical order; and every nonfirst source interval factors
into its predecessor alpha bit times the strict interior interval.  Together
with the independent finite-bit cancellation identity, these nodes isolate the
ordinary pair, special-tail, final-target, and non-alpha cases of Equation (7).
-/

namespace QuantumBlockEncoding
namespace RemaudVandaeleLadderAlphaSemanticFrontier

theorem admitted_frontier_marker : True := by trivial

end RemaudVandaeleLadderAlphaSemanticFrontier
end QuantumBlockEncoding

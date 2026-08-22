import QuantumBlockEncoding.MultiControlledXScheduleSemantics
import QuantumBlockEncoding.MultiControlledXLayerSemantics
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaRankCertificate
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaAlgorithmSchedule
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaTargetSupport
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaOuterSemantics
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaOuterIndexCoverage
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaSelectedOrder
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaRecursiveControlGeometry
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

The exact deleted-prefix rank chain now closes its last physical-offset identity
with the structural natural-number theorem `Nat.add_sub_of_le`, rather than
asking arithmetic automation to reconstruct subtraction semantics.  Above that,
the frontier checks that `X'` is an order embedding of compact coordinates into
physical wires, translates every child control interval back to its exact
physical endpoints, distinguishes the even-k child special target `k-3` from
the extra final left-wall gate `k-2`, and keeps the ordinary Boolean
left/child/right cancellation as an independent algebraic node.
-/

namespace QuantumBlockEncoding
namespace RemaudVandaeleLadderAlphaSemanticFrontier

theorem admitted_frontier_marker : True := by trivial

end RemaudVandaeleLadderAlphaSemanticFrontier
end QuantumBlockEncoding

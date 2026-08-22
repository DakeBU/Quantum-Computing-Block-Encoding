import QuantumBlockEncoding.MultiControlledXScheduleSemantics
import QuantumBlockEncoding.MultiControlledXLayerSemantics
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaRankCertificate
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaAlgorithmSchedule
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaOuterSemantics
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaCancellationAlgebra
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaAlgorithmSemantics

/-!
# Admission entry point: Remaud--Vandaele Algorithm 2 semantic frontier

This import-only module gives the admission PR one stable Lean target whose
transitive imports cover physical `X'`, exact `alpha'` rank, the proof-bearing
Algorithm-2 schedule, generic MCX semantics, `C_L` noninterference, the
recursive-target semantic bridge, and the stagewise reduction toward Equation
(7).

The current admission also checks two purified combinatorial foundations.  The
generic filtered-list rank API now targets current Mathlib `idxOf` theorems, and
the count of deleted odd source targets is proved by the correct one-step
parity recurrence: moving from `r` to `r+1` adds the endpoint `r` iff `r` is
odd.  Finally, the ordinary Algorithm-2 left/child/right correction is isolated
as a finite-bit cancellation identity, so the remaining semantic proof can
focus on interval geometry rather than Boolean case algebra.
-/

namespace QuantumBlockEncoding
namespace RemaudVandaeleLadderAlphaSemanticFrontier

theorem admitted_frontier_marker : True := by trivial

end RemaudVandaeleLadderAlphaSemanticFrontier
end QuantumBlockEncoding

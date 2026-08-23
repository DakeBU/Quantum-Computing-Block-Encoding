import QuantumBlockEncoding.RemaudVandaeleLadderAlphaEquationSeven
import QuantumBlockEncoding.VandaeleLadderAlphaEquationBridge
import QuantumBlockEncoding.VandaeleLadderEquationFiveSemantics

/-!
# Final Vandaele ladder semantic bridge

This module composes the three independently verified semantic layers:

1. Remaud--Vandaele Algorithm 2 refines the general alpha-ladder Equation (7);
2. for the regular alpha plan, Equation (7) is exactly flattened Vandaele
   Equation (5);
3. the original reverse-order source ladder exactly refines Equation (5).

Consequently the parallel Algorithm-2 implementation and the original source
ladder have exactly the same computational-basis action after the canonical
regular-ladder flattening.  No new circuit or correctness assumption is
introduced here: this is intentionally a thin theorem-composition node in the
Lean dependency graph.
-/

namespace QuantumBlockEncoding
namespace VandaeleLadderAlgorithmTwoEquationFiveBridge

open RemaudVandaeleLadderAlphaAlgorithmSchedule
open RemaudVandaeleLadderAlphaContract
open VandaeleLadderAlphaRepresentation
open VandaeleLadderAlphaEquationBridge
open VandaeleLadderContract
open VandaeleLadderEquationFiveSemantics

/-- The concrete proof-bearing Algorithm-2 circuit, specialized to the regular
alpha plan, computes exactly the flattened closed-form Vandaele Equation (5). -/
theorem algorithmTwo_regular_refines_equationFive
    (localControls steps : Nat)
    (state : LadderState localControls steps) :
    (algorithm (regularAlphaPlan localControls steps)).eval
        (flattenLadderState state) =
      flattenLadderState (equationFiveAction localControls steps state) := by
  calc
    (algorithm (regularAlphaPlan localControls steps)).eval
        (flattenLadderState state) =
        equationSevenAction (regularAlphaPlan localControls steps)
          (flattenLadderState state) :=
      RemaudVandaeleLadderAlphaEquationSeven.algorithm_refines_equationSeven
        (regularAlphaPlan localControls steps) (flattenLadderState state)
    _ = flattenLadderState (equationFiveAction localControls steps state) :=
      equationSeven_regular_eq_flatten_equationFive
        localControls steps state

/-- Final direct semantic equality: the parallel Algorithm-2 circuit and the
original reverse-order Vandaele ladder implement the same regular ladder map,
expressed on the common physical computational basis. -/
theorem algorithmTwo_regular_eq_flatten_sourceLadder
    (localControls steps : Nat)
    (state : LadderState localControls steps) :
    (algorithm (regularAlphaPlan localControls steps)).eval
        (flattenLadderState state) =
      flattenLadderState (sourceLadderAction localControls steps state) := by
  calc
    (algorithm (regularAlphaPlan localControls steps)).eval
        (flattenLadderState state) =
        flattenLadderState (equationFiveAction localControls steps state) :=
      algorithmTwo_regular_refines_equationFive localControls steps state
    _ = flattenLadderState (sourceLadderAction localControls steps state) := by
      exact congrArg (fun structured => flattenLadderState structured)
        ((sourceLadder_refines_equationFive localControls steps state).symm)

/-- Reader-facing symmetric form: flattening the original Figure-1(b) source
ladder equals the verified parallel Algorithm-2 realization. -/
theorem flatten_sourceLadder_eq_algorithmTwo_regular
    (localControls steps : Nat)
    (state : LadderState localControls steps) :
    flattenLadderState (sourceLadderAction localControls steps state) =
      (algorithm (regularAlphaPlan localControls steps)).eval
        (flattenLadderState state) :=
  (algorithmTwo_regular_eq_flatten_sourceLadder
    localControls steps state).symm

end VandaeleLadderAlgorithmTwoEquationFiveBridge
end QuantumBlockEncoding

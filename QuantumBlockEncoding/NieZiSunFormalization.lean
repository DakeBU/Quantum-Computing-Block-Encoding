import QuantumBlockEncoding.NieZiSunConstantToffoliMacros
import QuantumBlockEncoding.NieZiSunControlSplit
import QuantumBlockEncoding.NieZiSunControlSplitAllOne
import QuantumBlockEncoding.NieZiSunDirtyProtocol
import QuantumBlockEncoding.NieZiSunDirtyScheduledFamily
import QuantumBlockEncoding.NieZiSunDirtyScheduledResources
import QuantumBlockEncoding.NieZiSunFigure3ChildRefinement
import QuantumBlockEncoding.NieZiSunFigure3ExactRecurrence
import QuantumBlockEncoding.NieZiSunFigure3FirstHalf
import QuantumBlockEncoding.NieZiSunFigure3FlatCoordinates
import QuantumBlockEncoding.NieZiSunFigure3FlatProjections
import QuantumBlockEncoding.NieZiSunFigure3FullGateCorrectness
import QuantumBlockEncoding.NieZiSunFigure3GateCorrectness
import QuantumBlockEncoding.NieZiSunFigure3LocalStepRefinement
import QuantumBlockEncoding.NieZiSunFigure3MacroEmbedding
import QuantumBlockEncoding.NieZiSunFigure3MacroFamily
import QuantumBlockEncoding.NieZiSunFigure3Protocol
import QuantumBlockEncoding.NieZiSunFigure3RecursiveFamily
import QuantumBlockEncoding.NieZiSunFigure3Resource
import QuantumBlockEncoding.NieZiSunFigure3ReversibleProgram
import QuantumBlockEncoding.NieZiSunFigure3ScheduledCorrectness
import QuantumBlockEncoding.NieZiSunFigure3ScheduledFamily
import QuantumBlockEncoding.NieZiSunFigure3ScheduledResources
import QuantumBlockEncoding.NieZiSunToVandaeleLemma1

/-!
# Nie--Zi--Sun upstream reproduction spine

Thin aggregation of the construction cited by Vandaele Lemma 1.

The dependency chain represented here is no longer a theorem-name citation:

1. Figure-3 semantic first-half/second-half protocol and odd/even control split;
2. exact recursive source tree and finite C^3X/C^4X macro synthesis;
3. actual `{X,CX,CCX}` recursive gate lists;
4. exact flat-register refinement to the semantic recursion;
5. proof-bearing parallel scheduling with linear gate count/logarithmic depth;
6. one-clean C^nX correctness;
7. Nie Corollary-3 one-dirty protocol on the same scheduled components;
8. suffix-wire relabel into Vandaele's `[controls|target|dirty]` layout;
9. a concrete `VandaeleLemma1ProgramFamily.LemmaOneScheduledFamily` witness.

All newest declarations remain branch obligations until Lean admission is
observable and green.
-/

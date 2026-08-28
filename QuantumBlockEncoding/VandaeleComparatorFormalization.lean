import QuantumBlockEncoding.ComparatorQuantumToClassicalRestriction
import QuantumBlockEncoding.ComparatorSemanticTargets
import QuantumBlockEncoding.ComparatorSubtractionSemantics
import QuantumBlockEncoding.ComparatorSubtractionTargetBridge
import QuantumBlockEncoding.VandaeleComparatorEq3Reduction
import QuantumBlockEncoding.VandaeleComparatorLowerBoundReduction
import QuantumBlockEncoding.VandaeleComparatorOptimalityContract
import QuantumBlockEncoding.VandaeleComparatorTheorem2RecursiveSplit
import QuantumBlockEncoding.VandaeleComparatorTheorem2Resource
import QuantumBlockEncoding.VandaeleComparatorTheorem3BorrowedInput
import QuantumBlockEncoding.VandaeleComparatorTheorem3Resource
import QuantumBlockEncoding.VandaeleControlledComparatorResource
import QuantumBlockEncoding.VandaeleControlledComparatorTargets
import QuantumBlockEncoding.VandaeleControlledV2Resource
import QuantumBlockEncoding.VandaeleFigure5ComparatorContractBridge
import QuantumBlockEncoding.VandaeleLadderPermutation
import QuantumBlockEncoding.VandaeleLadderRefinement
import QuantumBlockEncoding.VandaeleLemma1ParityLowerBound
import QuantumBlockEncoding.VandaeleLemma6Contract
import QuantumBlockEncoding.VandaeleLemma6ResourceClosure
import QuantumBlockEncoding.VandaeleVOperator

/-!
# Vandaele comparator formalization spine

Thin aggregation module for the current source-facing comparator proof graph.
It contains no new theorem.  The QQ/CQ canonical and controlled semantic targets,
subtraction bridge, Equation-(3) reduction, corrected Equation-(5) ladder
realization, Definition-2.4 V operator, Lemma-6 promise/resource contract,
Equation-(28) controlled V2 resources, Theorem-2 Equation-(25) recursive
register split and recurrence closure, Theorem-3 real borrowed-input/resource
closure, and parity-backed ancilla optimality remain separately inspectable
Lean nodes.

The Figure-5 source path is now connected back to the canonical Equation-(17)
contract as well: the displayed 34-gate circuit is certified to have the
reversed predicate `b < a`, while the minimal endpoint-X repair restores both
data registers and satisfies `ComparatorSpec` for the intended `a < b`
action, with the same 34-gate count.

The bounded-gate linear/logarithmic lower theorem for C^kX remains source-backed;
the one-ancilla parity obstruction is now proved internally in the repository.
-/

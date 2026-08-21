import QuantumBlockEncoding.ComparatorQuantumToClassicalRestriction
import QuantumBlockEncoding.ComparatorSemanticTargets
import QuantumBlockEncoding.ComparatorSubtractionSemantics
import QuantumBlockEncoding.ComparatorSubtractionTargetBridge
import QuantumBlockEncoding.VandaeleComparatorEq3Reduction
import QuantumBlockEncoding.VandaeleComparatorLowerBoundReduction
import QuantumBlockEncoding.VandaeleComparatorTheorem2Resource
import QuantumBlockEncoding.VandaeleComparatorTheorem3BorrowedInput
import QuantumBlockEncoding.VandaeleComparatorTheorem3Resource
import QuantumBlockEncoding.VandaeleControlledV2Resource
import QuantumBlockEncoding.VandaeleLadderPermutation
import QuantumBlockEncoding.VandaeleLadderRefinement
import QuantumBlockEncoding.VandaeleLemma6Contract
import QuantumBlockEncoding.VandaeleVOperator

/-!
# Vandaele comparator formalization spine

Thin aggregation module for the current source-facing comparator proof graph.
It contains no new theorem.  The QQ/CQ semantic targets, subtraction bridge,
Equation-(3) lower-bound reduction, corrected Equation-(5) ladder realization,
Definition-2.4 V operator, Lemma-6 promise contract, Theorem-2 recurrence
closure, and Theorem-3 real borrowed-input/resource closure remain separately
inspectable Lean nodes.
-/

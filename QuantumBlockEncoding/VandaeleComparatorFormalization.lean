import QuantumBlockEncoding.ComparatorQuantumToClassicalRestriction
import QuantumBlockEncoding.ComparatorSemanticTargets
import QuantumBlockEncoding.ComparatorSubtractionSemantics
import QuantumBlockEncoding.ComparatorSubtractionTargetBridge
import QuantumBlockEncoding.VandaeleComparatorEq3Reduction
import QuantumBlockEncoding.VandaeleComparatorLowerBoundReduction
import QuantumBlockEncoding.VandaeleComparatorTheorem2Resource
import QuantumBlockEncoding.VandaeleComparatorTheorem3Resource

/-!
# Vandaele comparator formalization spine

Thin aggregation module for the current source-facing comparator proof graph.
It contains no new theorem.  The QQ/CQ semantic targets, subtraction bridge,
Equation-(3) lower-bound reduction, Theorem-2 recurrence closure, and Theorem-3
split/borrow resource closure remain separately inspectable Lean nodes.
-/

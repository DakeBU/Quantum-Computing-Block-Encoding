import QuantumBlockEncoding.VandaeleClassicalAdderTarget
import QuantumBlockEncoding.VandaeleControlledAdderTarget
import QuantumBlockEncoding.VandaeleCorollary7ControlledIncrementer
import QuantumBlockEncoding.VandaeleCorollary8ControlledAdderResource
import QuantumBlockEncoding.VandaeleTheorem5AdderBasisSplit
import QuantumBlockEncoding.VandaeleTheorem5AdderCarry
import QuantumBlockEncoding.VandaeleTheorem5RecurrenceClosure
import QuantumBlockEncoding.VandaeleTheorem5Resource

/-!
# Vandaele adder formalization spine

Thin aggregation module for Section 6 and its controlled-increment dependency.
It introduces no theorem.  Canonical adders, Figure-11 split/carry semantics,
Theorem-5 local/master resource closure, Corollary-7 controlled incrementers,
and Corollary-8 controlled-adder resources remain separately inspectable nodes.
-/

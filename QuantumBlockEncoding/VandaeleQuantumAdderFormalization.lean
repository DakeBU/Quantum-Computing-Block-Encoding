import QuantumBlockEncoding.VandaeleCorollary3ControlledQuantumAdderResource
import QuantumBlockEncoding.VandaeleCorollary3ControlledQuantumAdderTarget
import QuantumBlockEncoding.VandaeleQuantumAdderTarget
import QuantumBlockEncoding.VandaeleStructuralPrimitivesFormalization

/-!
# Vandaele quantum-adder formalization spine

Thin aggregation module for the Section-3 ripple-carry adder application of the
structural primitives. It contains no new theorem. The imported leaves expose
three separate evidence layers:

* canonical uncontrolled quantum-adder target on `(a,b,z)`;
* canonical k-controlled target for Corollary 3;
* Corollary-3 uniform resource closure obtained from Lemma 3, Lemma 4,
  Theorem 1, and Lemma 5.

The external [12] Figure-4 gate-level schedule remains a proof-bearing
realization obligation; it is not silently identified with the semantic target.
-/

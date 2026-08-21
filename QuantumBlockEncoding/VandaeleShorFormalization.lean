import QuantumBlockEncoding.VandaeleAdderFormalization
import QuantumBlockEncoding.VandaeleControlledComparatorResource
import QuantumBlockEncoding.VandaeleCorollary8ControlledAdderResource
import QuantumBlockEncoding.VandaeleModularAdditionSemantics
import QuantumBlockEncoding.VandaeleShorResourceApplication

/-!
# Vandaele modular-multiplication / Shor application spine

Thin aggregation module for Section 6.2.  It introduces no new theorem.  The
imported leaves keep the application proof graph explicit:

* Figure-12 modular-addition arithmetic and comparator-uncomputation invariant;
* Corollary-6 singly-controlled comparator resources;
* Corollary-8 doubly-controlled classical-adder resources;
* the external Häner architecture call-count contract;
* the resulting `O(n^3 log n)` gate, `O(n^2 log^2 n)` depth, and exact `2n+2`
  qubit bookkeeping for the Shor application.

The Häner modular-multiplication schedule remains an external architecture
input; Vandaele's contribution is the arithmetic primitive replacement and the
resource composition formalized by these nodes.
-/

import QuantumBlockEncoding.StrongPromiseCleanToDirtyInvolution
import QuantumBlockEncoding.StrongPromiseComputeUseUncompute
import QuantumBlockEncoding.VandaeleCorollary1ResourceClosure
import QuantumBlockEncoding.VandaeleCorollary4General
import QuantumBlockEncoding.VandaeleCorollary4ProgramFamily
import QuantumBlockEncoding.VandaeleEquation58GenericBridge
import QuantumBlockEncoding.VandaeleEquation58PromiseGadget
import QuantumBlockEncoding.VandaeleLadderContract
import QuantumBlockEncoding.VandaeleLadderPermutation
import QuantumBlockEncoding.VandaeleLadderRefinement
import QuantumBlockEncoding.VandaeleLemma1Contract
import QuantumBlockEncoding.VandaeleLemma1ProgramFamily
import QuantumBlockEncoding.VandaeleLemma2ProgramFamily
import QuantumBlockEncoding.VandaeleLemma4AppendixResource
import QuantumBlockEncoding.VandaeleLemma4ProgramFamily
import QuantumBlockEncoding.VandaeleLemma5Contract
import QuantumBlockEncoding.VandaeleLemma5Equations13_14
import QuantumBlockEncoding.VandaeleLemma5ResourceClosure
import QuantumBlockEncoding.VandaeleLemma5SplitBudget
import QuantumBlockEncoding.VandaeleTheorem1Contract
import QuantumBlockEncoding.VandaeleTheorem1ResourceClosure
import QuantumBlockEncoding.VandaeleTheorem1SemanticClosure

/-!
# Vandaele structural-primitives formalization spine

Thin aggregation module for the reusable structural core of
arXiv:2603.12917.  It introduces no new mathematical statement.  The imported
nodes keep the source proof graph inspectable:

* Definition 2.1 / Lemma 1 multi-controlled X;
* Definition 2.3 ladder semantics and its source-certified gate ordering;
* Lemma 4 Appendix-A.1 transformation and Equation (58);
* Corollary 1 general ladder resource closure;
* Corollary 4 strong-promise ladder interpretation;
* Lemma 5 control/product identities and borrowing budget;
* Theorem 1 controlled conjugation, resource closure, and clean-to-dirty
  involution upgrade.

Comparator, incrementer, and adder formalization spines may depend on this
single shared module without hiding the underlying leaf theorems.
-/

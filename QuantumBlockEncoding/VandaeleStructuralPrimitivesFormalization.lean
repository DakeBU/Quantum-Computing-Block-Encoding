import QuantumBlockEncoding.PromiseGatePermutationMatrixBridge
import QuantumBlockEncoding.PromiseGateUnitary
import QuantumBlockEncoding.PromiseGateUnitaryMux
import QuantumBlockEncoding.StrongPromiseCleanToDirtyInvolution
import QuantumBlockEncoding.StrongPromiseComputeUseUncompute
import QuantumBlockEncoding.VandaeleCorollary1ResourceClosure
import QuantumBlockEncoding.VandaeleCorollary2GateSetSpecialization
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
import QuantumBlockEncoding.VandaeleLemma3NaiveProgram
import QuantumBlockEncoding.VandaeleLemma3ProgramFamily
import QuantumBlockEncoding.VandaeleLemma4AppendixResource
import QuantumBlockEncoding.VandaeleLemma4NaiveProgram
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
arXiv:2603.12917. It introduces no new mathematical statement. The imported
nodes keep the source proof graph inspectable:

* Definitions 3.1/3.2 at the general matrix/unitary level, including the QMUX
  constructor and the exact embedding of reversible promise permutations;
* Definition 2.1 / Lemma 1 multi-controlled X;
* Definition 2.3 ladder semantics and its source-certified gate ordering;
* Lemma 3 first-order CX-ladder proof-bearing family interface plus an actual
  reverse-CX gate-level baseline with exact linear count/depth;
* Lemma 4 Appendix-A.1 transformation and Equation (58), plus an actual
  reverse-CCX strong-promise baseline with exact linear count/depth;
* Corollary 1 general ladder resource closure;
* Corollary 2 direct `{CCX,CX,X}` specialization of Theorem 1;
* Corollary 4 strong-promise ladder interpretation;
* Lemma 5 control/product identities and borrowing budget;
* Theorem 1 controlled conjugation, resource closure, and clean-to-dirty
  involution upgrade.

The reversible promise-gate layer is now explicitly a specialization of the
paper's arbitrary-unitary definitions rather than a parallel notion.  The naive
ladder programs remain semantic/gate baselines, not substitutes for the
external [9] logarithmic-depth schedules. Appendix A.1 is formalized as a
same-target scheduling/resource transformation on top of those source targets.

Comparator, incrementer, quantum-adder, and classical-adder formalization spines
may depend on this single shared module without hiding the underlying leaf
theorems.
-/

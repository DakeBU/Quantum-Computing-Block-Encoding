import QuantumBlockEncoding.PromiseGateCircuitIdentities
import QuantumBlockEncoding.PromiseGatePermutationMatrixBridge
import QuantumBlockEncoding.PromiseGateReversibleComposition
import QuantumBlockEncoding.PromiseGateUnitary
import QuantumBlockEncoding.PromiseGateUnitaryMux
import QuantumBlockEncoding.ReversibleProgramGateLowerBound
import QuantumBlockEncoding.RemaudVandaeleLadder1Family
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
import QuantumBlockEncoding.VandaeleLemma1ParityLowerBound
import QuantumBlockEncoding.VandaeleLemma1ProgramFamily
import QuantumBlockEncoding.VandaeleLemma2FirstOrderNaiveProgram
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
* Equations (10)-(12) plus reusable weak/strong promise composition in the
  reversible specialization;
* Definition 2.1 / Lemma 1 multi-controlled X, including two internal lower
  bounds in the concrete `{X,CX,CCX}` model: `k <= 3 * gateCount` and the parity
  proof that k>=3 cannot be implemented ancilla-free;
* Definition 2.2 / Lemma 2 fan-out, including an actual first-order n-CCX
  gate-level baseline tied to the source semantics;
* Definition 2.3 ladder semantics and its source-certified gate ordering;
* Lemma 3 first-order CX ladder: besides the simple reverse-CX semantic
  baseline, the upstream Remaud--Vandaele 2025 Algorithm 1 has now been traced
  to its source pseudocode and represented by one recursive proof-bearing
  schedule whose correctness and O(n)/O(log n) resource bounds feed the
  Vandaele Lemma-3 family interface;
* Lemma 4 Appendix-A.1 transformation and Equation (58), plus an actual
  reverse-CCX strong-promise baseline with exact linear count/depth;
* Corollary 1 general ladder resource closure;
* Corollary 2 direct `{CCX,CX,X}` specialization of Theorem 1;
* Corollary 4 strong-promise ladder interpretation;
* Lemma 5 control/product identities and borrowing budget;
* Theorem 1 controlled conjugation, resource closure, and clean-to-dirty
  involution upgrade.

The reversible promise-gate layer is explicitly a specialization of the
paper's arbitrary-unitary definitions rather than a parallel notion. The
ancilla lower bound and a constant-factor linear gate lower bound of Lemma 1 are
now internal to the repository's reversible gate model; the source's more
general bounded-gate-set theorem and logarithmic depth lower bound remain cited.
For Lemma 3 the previously external logarithmic-depth schedule is no longer a
black-box citation: the relevant Remaud--Vandaele Algorithm-1 construction is
now a branch proof dependency.  Lemma 4 still has an upstream Algorithm-2/MCX
source leaf that is being traced separately.

Comparator, incrementer, quantum-adder, and classical-adder formalization spines
may depend on this single shared module without hiding the underlying leaf
theorems.
-/
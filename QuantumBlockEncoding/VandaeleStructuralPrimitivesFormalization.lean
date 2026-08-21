import QuantumBlockEncoding.MultiControlledXSchedule
import QuantumBlockEncoding.NieZiSunFigure3RecursiveFamily
import QuantumBlockEncoding.NieZiSunFigure3Resource
import QuantumBlockEncoding.PromiseGateCircuitIdentities
import QuantumBlockEncoding.PromiseGatePermutationMatrixBridge
import QuantumBlockEncoding.PromiseGateReversibleComposition
import QuantumBlockEncoding.PromiseGateUnitary
import QuantumBlockEncoding.PromiseGateUnitaryMux
import QuantumBlockEncoding.ReversibleProgramGateLowerBound
import QuantumBlockEncoding.RemaudVandaeleLadder1Family
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaContract
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaOuterLayers
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaRecursiveParameters
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaResource
import QuantumBlockEncoding.RemaudVandaeleLadderAlphaSelectedRegister
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
nodes keep the source proof graph inspectable and now include the upstream
constructions actually used by the 2026 paper.

* Definitions 3.1/3.2 at the general matrix/unitary level, including the QMUX
  constructor and the exact embedding of reversible promise permutations;
* Equations (10)-(12) plus reusable weak/strong promise composition;
* Definition 2.1 / Lemma 1 multi-controlled X, including internal gate-count
  and ancilla lower bounds in the concrete reversible model;
* Nie--Zi--Sun 2024 Figure 3 traced upstream: conditional-clean five-step
  semantics, odd/even physical register split, recursively constructed
  first-half permutation, complete clean-ancilla n-Toffoli semantic family, and
  a direct proof that its source recurrence closes to O(log n) depth/O(n) size.
  Its remaining physical realization leaf is explicitly over Nie's B2 gate set,
  not silently identified with `{X,CX,CCX}`;
* Definition 2.2 / Lemma 2 fan-out, including an actual first-order n-CCX
  gate-level baseline tied to the source semantics;
* Definition 2.3 ladder semantics and its source-certified gate ordering;
* Lemma 3 first-order CX ladder: the upstream Remaud--Vandaele 2025 Algorithm 1
  is now represented by one recursive proof-bearing scheduled circuit whose
  correctness and O(n)/O(log n) resource bounds inhabit the Vandaele family;
* Lemma 4 upstream trace is active rather than a black-box citation:
  Remaud--Vandaele Definition 6 `L_alpha`, an arbitrary-MCX source IR,
  Algorithm-2 outer MCX walls, exact k-recursion resource closure, alpha-prime
  reindex arithmetic, and the ordered physical recursive register X' are all
  branch proof nodes. The remaining leaf is to prove target-rank=alpha-prime,
  recursively assemble the complete Algorithm-2 MCX schedule, and then apply
  Vandaele Appendix-A.1's already-formalized Eq.(58) transformation;
* Corollary 1 general ladder resource closure;
* Corollary 2 direct `{CCX,CX,X}` specialization of Theorem 1;
* Corollary 4 strong-promise ladder interpretation;
* Lemma 5 control/product identities and borrowing budget;
* Theorem 1 controlled conjugation, resource closure, and clean-to-dirty
  involution upgrade.

The reversible promise-gate layer is explicitly a specialization of the
paper's arbitrary-unitary definitions rather than a parallel notion. The
ancilla lower bound and a constant-factor linear gate lower bound of Lemma 1 are
internal to the repository's reversible gate model; the source's more general
bounded-gate-set theorem and logarithmic depth lower bound remain separately
identified. Upstream source tracing never changes gate models without an
explicit realization theorem.
-/
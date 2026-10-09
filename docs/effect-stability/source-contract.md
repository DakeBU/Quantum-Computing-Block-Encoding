# Stability of normalized pure-state effect probabilities

Source: author-derived canonical finite-dimensional mathematical contracts,
version 1 (2026-10-09). This is a reusable library formalization, with no novelty
or algorithm-complexity claim.

Let ι be a finite decidable index type and ψ a normalized vector in complex
Euclidean space. Matrices use Loewner order and the induced Euclidean operator
norm. Define p(U)=Re⟨Uψ,P Uψ⟩, where U is unitary and 0≤P≤I is an effect.
The order bounds imply ||P||≤1; this is a proved prerequisite rather than an
extra premise of the probability theorem. Unitarity gives ||Uψ||=1, also proved
internally. Positivity gives p(U)≥0; Cauchy–Schwarz and contraction give p(U)≤1.
The literal formula is defined for all matrices; it is claimed to be a
probability only under the displayed effect and normalization hypotheses.

For normalized x,y and a contraction P, split
⟨x,Px⟩−⟨y,Py⟩=⟨x−y,Px⟩+⟨y,P(x−y)⟩.
Cauchy–Schwarz bounds the real-part difference by 2||x−y||. For two unitaries
U,V with ||U−V||≤η, operator action gives ||Uψ−Vψ||≤η, hence
|p(U)−p(V)|≤2η. A separate nonnegative η premise is unnecessary: the error
certificate already forces it. The auxiliary contraction lemma has its own
literal contraction hypothesis; the effect consumer derives that hypothesis.

For lists of primitive circuits of n qubits, use the library's existing
positionwise Aligned δ certificate, δ≥0. This certificate preserves the gate
constructors/wires and bounds corresponding Ry angle errors; it is not an
automatic synthesis theorem. Existing PrimitiveCircuitPerturbation gives
||eval approximate−eval exact||≤length(exact)·δ/2, and PrimitiveSemantics gives
both circuit unitaries. Applying the probability theorem yields effect
probability difference at most length(exact)·δ. Circuit unitarity and operator
perturbation remain genuine proof dependencies, not public hypotheses.

No additional register, garbage, ancilla or tensor identification is introduced.
Global phase is carried literally in matrices, not selected by a quotient or
claimed unique. The existing PrimitiveBasis fixes the circuit register order.
The analytic result requires no oracle access, controls or inverse black box.
No hardware noise law, state-loading cost, shot cost, gate count, physical depth,
finite-bit angle synthesis, runtime or estimator theorem follows from it.

Actual dependencies include Mathlib finite Matrix order/CStar norms, complex
inner products and operator action, and the existing library's
aligned_eval_distance_le and evalPrimitiveCircuit_unitary. The reusable
probability node has actual consumers probability_mem_Icc and
CircuitEffectStability.aligned_probability_difference_le. This contribution
adds canonical Semantics nodes, not a new research route, frontier, categorical
transport, accepted circuit compiler or resource theorem. Unaffected atlas and
progress surfaces remain unchanged with that reason.

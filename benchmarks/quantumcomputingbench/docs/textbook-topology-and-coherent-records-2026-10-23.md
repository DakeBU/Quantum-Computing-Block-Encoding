# Textbook checkpoint: topology, linearity and coherent records

This additive mathematical-reader checkpoint corrects six existing targets.
It is not a stable-data release. Core IDs, families, splits, graph/source scope
and ordered exposition-node lists are preserved. Five corrections explicitly
change the question contract; plan404 changes only its answer, rubric and
explanation. Frozen preview records and all previous findings remain unchanged.
Natural-language and Lean contributions still use one shared registry.

## Boundary is not extremality

**plan003, question version 2:** density matrices form a convex set whose extreme
points are rank-one projectors. This does not generally identify its topological
boundary. In the real affine space of trace-one Hermitian matrices, positive
definite states are interior and singular states are boundary. For dimension at
least three, `diag(1/2,1/2,0,...)` is mixed yet boundary. Dimension two is the
special coincidence with pure states; in dimension one the singleton is its own
relative interior with empty relative boundary. In the full Hermitian or complex
matrix space, every state is boundary because the trace constraint leaves empty
interior. Dimension zero has no trace-one state. The answer proves both
extremality directions and the relevant perturbation arguments rather than
silently replacing the old false boundary request by an extreme-point theorem.

## Equivariance is not linearity

**plan104, question version 2:** an equivariant function between irreducible
representations need not have a linear kernel or image. Odd nonlinear functions
on the one-dimensional sign representation give explicit counterexamples, even
under finite, unitary, continuous and analytic conditions. A nonzero *linear*
intertwiner does have invariant linear kernel and image, so irreducibility makes
it an isomorphism over a common field. This part needs neither finite dimension
nor algebraic closure; zero carriers and the zero alternative are explicit.

**plan105, question version 2:** a linear endomorphism of a nonzero finite-
dimensional irreducible representation over an algebraically closed field has
an eigenvalue. Applying the previous linear-intertwiner argument to its scalar
shift proves it is scalar. Real rotation and infinite-dimensional complex
multiplication representations exhibit the missing-hypothesis boundaries. The
commutant is taken inside linear endomorphisms, not all equivariant functions.
An eigenvalue for the particular map is a weaker sufficient condition, not a
claim that every excluded case fails. Compactness, continuity and Hilbert-space
irreducibility are not silently substituted for algebraic irreducibility.

## A clean union is a valid common projector

**plan206, question version 2:** disjoint, unequal-width ancillas can be embedded
in their ordered union, initialized to zero and extended by identity on idle
registers. Projecting that whole union to zero is well defined. Physical sharing
of one pre-existing ancilla register is sufficient, not necessary. Dirty or
unembedded interfaces are different cases.

For branch blocks `K_i/beta_i` and normalized index amplitudes `alpha_i`, the
successful map is `C=sum_i (alpha_i/beta_i)|i>K_i`. Its effects are
`|alpha_i|^2 K_i^dagger K_i/beta_i^2`; the failure effect completes the POVM.
Choose `alpha_i=beta_i/B`, with `B^2=sum_i beta_i^2`, for the coherent target at
success probability `1/B^2`. Dividing instead by `max beta_i` need not normalize
PREP. Zero effects, relative phases and zero-probability conditioning are handled
explicitly. Extra attenuation flags and their acceptance conditions are paid
constructions, not free amplification or optimality certificates.

## Joint coherence is not a signal marginal

**plan207, question version 2:** exact controlled rotations implement the actual
stored finite-bit angle `q`, not an arbitrary real arccosine asserted to have a
finite expansion. Their amplitudes are `cos(pi q), sin(pi q)` with the correct
half-angle convention. The index-controlled inverse restores the complete work
register, including arithmetic scratch, on both signal branches. The retained
index zero-signal block is diagonal, not the original full entry matrix.

Without cleanup, tracing out the angle record dephases the *joint* signal/index
state between distinct record classes. The signal marginal is nevertheless the
same as after cleanup. Basis inputs and equal records expose the false universal
decoherence claim. A two-bit signed example distinguishes the joint states by
an interference measurement. Tracing work is not projection onto the same
clean flag, nor a unitary erasure. The answer keeps these three operations
separate and charges inverse/arithmetic/precision work rather than hiding it.

## Excess copies are not total copies

**plan404, answer correction:** the pure/mixed de Finetti sufficient bounds use
`sqrt(d k/(n-k))` and `sqrt(d^2 k/(n-k))` in the specified trace-distance
convention. At fixed tolerance it is the unrounded *excess* `n-k` that changes
by the exact dimension factor. The sufficient total counts add `k` and round;
their ratio is not generally that factor. Strict versus non-strict tolerances,
zero kept copies, dimension one, varying dimension and vanishing-error regimes
are explicit. These sufficient estimates are not optimal sample-complexity
lower bounds. The question itself is unchanged, so no new question version or
second core is created.

## Evidence and compatible continuation

Each candidate has a substantive distinct-author review bound to its exact
contents, full predecessor and question contract. The complete reference,
rubric and ordered explanation steps were assessed. Exposure is disclosed, not
called blind or human review. Root separately retrieved matching primary PDF
bytes and inspected bounded operative text and selected rendered formulas or
circuits; reviewers' own text-only access does not inherit those executions.
Primary statements are assessed rather than assumed infallible. For example,
unit trace alone does not characterize purity; the answer reconstructs the
rank-one criterion and does not import that erroneous printed equivalence.
These are bounded mathematical checks, not whole-paper approval or new Lean
kernel evidence.

Plan104's kernel/image argument supports part of plan105. Plan206/207 share
projection and garbage bookkeeping, but ask different complete questions.
Plan404/420 share the symmetric purification bridge. These bounded overlaps do
not prove whole-question aliases, global deduplication or independent held-out
splits. Do not pool shared fragments across inherited splits as independent
evaluation samples. Export the current registry before either contributor track
adds a view; old question hashes for the five versioned targets are stale.
An unchanged plan404 question hash does not approve a previous answer.

The current reader has **193 active core IDs and 20 reserved corrections** in
the original 213-obligation scope. The three admitted native library-lemma Lean
companions are unchanged. Global semantic reconciliation remains incomplete,
isolated untrusted Lean evaluation is environment-blocked and model baselines
are unmeasured. Stable acceptance gates and the frozen public preview tag are
not bypassed by this editorial checkpoint.

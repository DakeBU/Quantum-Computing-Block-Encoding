# State-Preparation Route-Intuition Guide

State Preparation asks for a unitary satisfying

\[
U|0^n\rangle=|\psi\rangle,
\qquad
\sum_x |\psi_x|^2=1.
\]

Equivalently, the first computational-basis column of \(U\) is the target
amplitude vector. Every candidate route must preserve this invariant.

This page is the **State Preparation route selector**. For the cross-cutting
question “should this task be constructible under the stated access model?”,
start with `../construction-methodology/index.md`.

## Before choosing a circuit: what information can be computed coherently?

A classical formula for \(\psi_x\) is useful only when the corresponding data
can be exposed by a coherent reversible procedure at acceptable cost. The
planner should ask, in this order:

1. Is the target normalized, or is a normalization constant efficiently known?
2. Can amplitudes, phases, support labels, or conditional masses be computed
   coherently?
3. Can intermediate arithmetic be uncomputed so that promised clean ancillas
   are restored?
4. Is the requested approximation metric and precision explicit?
5. Does the same information expose a more structured route than generic dense
   synthesis?

For a tree or interval construction, the central object is often the mass of a
node \(v\),

\[
M(v)=\sum_{x\in\mathrm{leaves}(v)} |\psi_x|^2,
\]

and the controlled split probability

\[
p(b\mid v)=\frac{M(vb)}{M(v)}.
\]

If these quantities can be evaluated coherently and converted into controlled
rotations, recursive preparation is a natural route. Comparator and incrementer
circuits become reusable memory whenever the leaves are ranges, prefixes, or
piecewise arithmetic regions.

## Route matrix

| Target/access model | Route worth trying first | Main proof leaf | Warning sign |
| --- | --- | --- | --- |
| one-qubit or small named gate | direct gate action | exact basis/state action | no scaling story |
| explicit small normalized vector | dense unitary completion / UCRY | normalization, unitarity, first column | dimension grows exponentially |
| tensor/product state | independent local preparations | factor normalization and tensor action | hidden cross-coordinate correlation |
| recursively splittable amplitudes | binary split / UCRY tree | partial masses and controlled rotations | partial masses are expensive or unstable |
| interval/prefix-defined state | interval tree + reversible comparator/incrementer | exact predicate action, ancilla restoration, split amplitudes | range arithmetic dominates the state loader |
| sparse support + amplitudes | pruned sparse preparation | support routing + amplitude action | support lookup itself is dense |
| efficiently integrable probability law | Grover–Rudolph-style recursive probabilities | coherent integration / prefix-mass oracle | integration is only classically efficient, not coherently compiled |
| coherent data lookup | SELECT/SWAP-style loading | lookup correctness + workspace restoration | QRAM/table access assumptions are unclear |
| formula-defined amplitudes | reversible arithmetic amplitude loading | value computation, controlled rotation, uncompute, error | precision/error not budgeted |
| approximate target | approximate preparation interface | norm/error theorem in declared metric | finite numerical check used as symbolic proof |
| unnormalized vector | normalize, or route \(|v\rangle\langle0|\) to BE | nonzero norm / rank-one contract | silently calling an unnormalized vector a state |

## Useful structural shortcuts

### Product structure

If

\[
|\psi\rangle=\bigotimes_{j=1}^m |\psi_j\rangle,
\]

prepare the factors independently before retrieving a generic tree. ASPBE's
Grover–Rudolph finite benchmark already demonstrates why recognizing this
structure can remove unnecessary controlled branches.

### Sparse structure

If only \(d\) basis labels carry amplitude, route selection should depend on how
the labels themselves are accessed. “Sparse as a vector” does not automatically
mean “cheap as a circuit”; the support-address oracle is part of the contract.

### Interval and prefix structure

For states whose amplitudes or labels are piecewise over ranges, prefer an
arithmetic predicate such as

\[
[x<\tau],\qquad [a\le x<b],
\]

computed reversibly into a flag, use the flag for the controlled operation, and
uncompute it. The comparator/incrementer technical memory card is intended to
make this pattern reusable rather than rediscovered case by case.

## Certificate boundary

A full exact State Preparation certificate needs all of:

- target normalization;
- unitary circuit semantics;
- exact state action \(U|0^n\rangle=|\psi\rangle\);
- restoration of any promised clean workspace;
- resource numbers derived from the same circuit that proves the state action.

A source paper's asymptotic circuit-size or depth theorem is a separate claim
unless ASPBE has formalized that resource proof as well.

## Agent discipline

Upper freezes the target and access model. Middle retrieves the shortest
compatible route and its memory cards. Lower proves one ready leaf at a time.
The reviewer rejects any resource comparison whose candidates do not inhabit
the same semantic fibre.

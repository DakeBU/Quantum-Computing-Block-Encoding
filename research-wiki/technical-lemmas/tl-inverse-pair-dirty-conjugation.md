# Inverse-Pair Dirty Ancilla by Controlled Conjugation

- `id`: `tl-inverse-pair-dirty-conjugation`
- `source`: Vivien Vandaele, *Asymptotically Optimal Quantum Circuits for Comparators and Incrementers*, Eqs. (35)–(36), arXiv:2603.12917
- `statement`: replace an involution-only dirty-ancilla trick by a forward/inverse protocol when a self-inverse conjugator maps the forward operation to its inverse
- `lean_status`: `obligation` — implemented on `codex/sp-papers-comparator-proof-cost`, not promoted until the branch Lean gate is observable and green
- `used_by`: Vandaele incrementer; future modular shift/adder routes; reversible arithmetic inside State Preparation and Block Encoding
- `dependencies`: `PromiseGateOptimization`, `ReversibleRegisterLift`, little-endian basis semantics
- `next_action`: refine the externally controlled all-X conjugator to the source paper's controlled fan-out circuit and cost, then consume it inside the recursive strong-promise incrementer
- `tags`: `dirty-ancilla`; `inverse-pair`; `conjugation`; `incrementer`; `reversible-arithmetic`; `promise-gate`

## Why this is separate from the involution trick

The repository already has a useful dirty-flag protocol for a target operation
\(U\) satisfying

\[
U^2=I.
\]

An incrementer does not satisfy that condition. Treating it as an involution
would erase exactly the technical issue solved by the source paper.

The replacement pattern uses a forward operation \(F\), its inverse \(F^{-1}\),
and a self-inverse conjugator \(X\) satisfying

\[
X^2=I,
\qquad
X F X=F^{-1}.
\]

For modular successor, \(F=\mathrm{Inc}\), \(F^{-1}=\mathrm{Dec}\), and \(X\)
is bitwise X on the whole target register.

## Branch proof ladder

### Abstract inverse-by-conjugation

`ComparatorIncrementerDirtyAncilla.InverseByConjugation` records

\[
XFX=F^{-1}.
\]

`forward_conjugator_forward_conjugator_eq_refl` derives the cancellation
identity underlying source Eq. (35).

### Dirty forward/inverse protocol

`dirtyControlledInversePairEquiv` uses the unknown dirty bit without requiring
that \(F\) itself be an involution. The intended theorem
`dirtyControlledInversePair_action` states

\[
(k,d,y)\longmapsto
(k,d,\;F(y))
\]

when the external control predicate holds, and identity on the target otherwise.
The same incoming dirty value \(d\) is restored.

### Controlled-conjugation realization

`ComparatorIncrementerControlledConjugation.lean` eliminates a hidden
"choose forward or backward" oracle. Two externally controlled conjugators are
placed around the dirty-controlled inverse branch. The branch cases are:

1. external control false: the conjugators are identities and \(F,F^{-1}\)
   cancel;
2. external control true, dirty zero: the two conjugators cancel;
3. external control true, dirty one: \(X F^{-1} X=F\).

This is the semantic content of the source Eq. (36) pattern.

### Modular arithmetic instance

`ComparatorIncrementerModularConjugation.lean` instantiates the algebra on
`ZMod N`:

\[
\mathrm{Inc}(x)=x+1,
\qquad
X_{\rm all}(x)=-x-1,
\]

and proves the inverse-by-conjugation condition for arbitrary modulus.
For \(N=2^n\), \(-x-1\) is the modular form of bitwise complement.

### Little-endian all-X representation

`ComparatorIncrementerAllX.lean` defines all-X on the actual repository
`PrimitiveBasis n` and proves

\[
\operatorname{LE}(X^{\otimes n}x)
=2^n-1-\operatorname{LE}(x).
\]

The same file now builds a recursive `ReversibleProgram n` consisting of one X
per wire and proves its exact basis action equals the all-X permutation.

`ComparatorIncrementerAllXResources.lean` records the syntax-level facts that
this program has exactly \(n\) instructions and every instruction is an X gate.
This is only the uncontrolled logical all-X cost.

### Shared register embedding

`ReversibleRegisterLift.lean` is deliberately not Vandaele-specific. It proves
that shifting any reversible program to successor wires preserves the new head
wire and reproduces the original tail semantics. The all-X compiler consumes
this node, and future recursive arithmetic/SP/BE constructions should reuse it
instead of rebuilding subregister embeddings.

## What is still open

The following are not yet source reproduction claims:

- controlled all-X fan-out over arbitrary control size;
- refinement of that fan-out to the source Clifford+Toffoli construction;
- its gate/depth recurrence and clean/dirty workspace cost;
- the recursive strong-promise incrementer of Figure 10 / Eq. (44);
- the \(\Theta(n)\) gate and \(\Theta(\log n)\) depth theorem;
- the source lower bound and minimum-qubit optimality statements.

The distinction matters: exact permutation semantics of Eq. (35)/(36) is an
important reusable proof node, but it is not yet the source paper's complete
asymptotic construction.

## Retrieval rule beyond Vandaele

Retrieve this card whenever a parent construction has all three features:

1. a possibly dirty workspace bit;
2. a reversible target operation that is not involutory;
3. an efficiently implementable conjugator that maps the target to its inverse.

Examples may include modular shifts, add/subtract pairs, arithmetic address
updates, and clean-up subroutines inside State Preparation or Block Encoding.
The parent proof must still certify its own query model, target action, error,
and total resources.

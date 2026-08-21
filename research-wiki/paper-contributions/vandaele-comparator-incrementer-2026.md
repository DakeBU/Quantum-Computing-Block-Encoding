# Vandaele 2026 Comparator / Incrementer Formalization Map

- **source**: Vivien Vandaele, *Asymptotically Optimal Quantum Circuits for Comparators and Incrementers*, arXiv:2603.12917
- **branch**: `codex/sp-papers-comparator-proof-cost`
- **evidence status**: `obligation` until the branch Lean gate is observable and green
- **rule**: a source asymptotic/optimality claim is not promoted merely because its semantic contract or recurrence algebra has been formalized

## Current dependency graph

The branch now follows the paper's actual proof dependency rather than jumping directly to Figure 10:

```text
ReversibleClassical / Primitive semantics
        |
        +--> finite comparator/incrementer seed
        |
        +--> ReversibleRegisterLift
        |       |
        |       +--> arbitrary-width all-X ReversibleProgram
        |       +--> serial controlled all-X semantic baseline
        |
        +--> promise-gate algebra
                |
                +--> controlled / predicate-controlled strong promise
                +--> predicate-controlled conjugation
                |
                +--> Lemma 5 semantic/resource contract
                |        |
                |        +--> Theorem 1 source resource contract
                |                 |
                |                 +--> Lemma 7 semantic/resource contract
                |                          |
                |                          +--> Lemma 8 semantic contract
                |                                  |
                |                                  +--> Eq. (40) control invariant
                |                                  +--> Eq. (41)-(42) two-round schedule
                |                                  +--> Eq. (42) promise cleanliness
                |                                  +--> sqrt block budget/composition
                |
Eq. (34) split/carry -------------------------------+
        |
Eq. (35) Inc/Dec all-X conjugation
        |
Eq. (36) dirty inverse-pair + controlled conjugation
        |
Eq. (37) controlled fan-out identity
        |
Eq. (44) semantic high-carry constructor
        |
Theorem 4 recurrences
        +--> Eq. (45) generic linear gate upper closure
        +--> Eq. (46) generic geometric depth closure
        +--> Eq. (2) C^kX reduction for the lower-bound route
```

## Source statements already represented semantically on the branch

### Definition 2.2 / Equation (37): fan-out

`ComparatorIncrementerFanoutSource.lean` fixes the exact `F_k^(n)` basis action: one global control, `k` local controls per block, target toggle by the conjunction, and preservation of all controls.

`ComparatorIncrementerFanoutIdentity.lean` proves the Eq. (37) semantic decomposition into two ordinary fan-outs and one multi-controlled pivot toggle. The serial CX fan-out in `ComparatorIncrementerControlledAllX.lean` is only a semantic baseline; it is **not** identified with Lemma 2's O(log n)-depth implementation.

### Definitions 3.1/3.2 and controlled promise gates

`PromiseGateOptimization.lean`, `ControlledStrongPromise.lean`, and `PredicateControlledStrongPromise.lean` separate weak/strong promise semantics and show that strong promise preservation survives one control or an arbitrary computational-basis control predicate.

### Figure 3(a) / Theorem 1 semantic algebra

`PredicateControlledConjugation.lean` proves for an arbitrary key predicate that controlling `V† U V` is exactly equivalent to leaving `V,V†` uncontrolled and controlling only `U`.

`VandaeleTheorem1Contract.lean` records the source resource scale

\[
O(c_V+c_U+d_U n+k),\qquad
O(d_V+d_U\log n+\log k),
\]

and the clean-workspace budget

\[
\max(1,m-k+1).
\]

The strong/involutory one-clean-to-one-dirty replacement is represented as exact workspace bookkeeping. The concrete Lemma-5/promise-register circuit producing these resource inequalities is still open.

### Lemma 5

`VandaeleLemma5Contract.lean` fixes the semantic target of a `k`-controlled product layer `\bigotimes_i U_i`, together with the source O(n+k), O(log n + log k), zero-ancilla resource target. Equations (13)-(14) have not yet been refined to an actual low-resource circuit certificate.

### Lemma 7

`ComparatorIncrementerLemma7Contract.lean` fixes:

- `k` computational-basis controls with all-ones activation predicate;
- promise width `n-1`;
- modular n-bit increment target;
- strong-promise preservation;
- source resource target O(k+n) gates and O(log(kn)) depth.

The semantic family is inhabited, but the low-resource source implementation is still open.

### Lemma 8 / Figure 10

`ComparatorIncrementerLemma8Contract.lean` fixes the controlled strong-promise incrementer with promise width

\[
2\lceil\sqrt n\rceil.
\]

The branch also formalizes several proof ingredients instead of treating Figure 10 as an opaque circuit:

- `ComparatorIncrementerEq40ControlInvariant.lean`: all ones → increment → zero → all-X → all ones;
- `ComparatorIncrementerLemma8TwoRoundSchedule.lean`: adjacent promise gates form a path and parity gives two register-disjoint rounds;
- `ComparatorIncrementerLemma8PromiseCleanliness.lean`: before-increment all-X and after-increment no-X give the same clean promise state on the active branch;
- `ComparatorIncrementerLemma8Budget.lean`: `ceil(sqrt n)^2` admits an explicit linear envelope;
- `ComparatorIncrementerLemma8Composition.lean`: local ladder/fan-out/promise bounds mechanically compose to global linear gate and logarithmic depth targets.

What remains is to construct the concrete Figure-10 `{CCX,CX,X}` family and prove that its components inhabit those local resource contracts.

## Incrementer-specific source identities

### Equation (34)

`ComparatorIncrementerRecursiveSplit.lean` proves the exact low/high successor decomposition and carry semantics.

### Equations (35)-(36)

`ComparatorIncrementerDirtyAncilla.lean`, `ComparatorIncrementerModularConjugation.lean`, and `ComparatorIncrementerControlledConjugation.lean` formalize the increment/decrement inverse-pair technique without incorrectly assuming the incrementer is involutory. Dirty-bit restoration is part of the theorem statement.

### All-X representation and circuit

`ComparatorIncrementerAllX.lean` proves the little-endian identity

\[
\operatorname{LE}(X^{\otimes n}x)=2^n-1-\operatorname{LE}(x)
\]

and provides an actual arbitrary-width `ReversibleProgram n` using the shared `ReversibleRegisterLift` node.

`ComparatorIncrementerAllXResources.lean` records the safe logical statement: exactly `n` instructions, all X gates. `ComparatorIncrementerControlledAllX.lean` analogously gives an exact serial one-control CX baseline with `n` CX instructions; this is not the source low-depth fan-out theorem.

### Equation (44)

`ComparatorIncrementerEq44Semantics.lean` connects the Eq. (34) carry to the Eq. (36) dirty high-register modular increment and proves dirty workspace restoration at the Theorem-4 `alpha/beta` split. This is a semantic constructor, not yet the full Figure-10/44 gate network.

## Theorem 4 resource and optimality path

`ComparatorIncrementerRecurrence.lean` defines

\[
\alpha(n)=2\lceil\sqrt n\rceil,\qquad \beta(n)=n-\alpha(n)
\]

and proves `alpha(n) < n` in the recursive regime, so the future circuit family has a real well-founded induction measure.

`ComparatorIncrementerTheorem4GateBound.lean` proves a generic explicit linear upper bound from a recurrence of the source Eq. (45) form. Thus the recurrence-to-O(n) step is represented independently of Figure 10.

`ComparatorIncrementerTheorem4DepthBound.lean` proves the generic geometric-potential closure needed for Eq. (46). The concrete remaining arithmetic leaf is `LogRankContraction cutoff`, asserting a fixed-factor contraction of `log2(n+1)+1` under `alpha(n)` beyond a finite cutoff.

`ComparatorIncrementerLowerBoundReduction.lean` formalizes the semantic Equation (2) reduction

\[
C^kX = \mathrm{Inc}_{k+1}\; ;\; \mathrm{Dec}_{k}
\]

in integer-coded control/target semantics. The external lower bound for exact `C^kX` over bounded-size gates remains a cited-result theorem; it has not been re-proved in Lean.

## Exact next leaves

1. **Lemma 5 implementation**: refine Equations (13)-(14), using the already formalized dirty-involution and fan-out primitives, into a concrete certificate for `VandaeleLemma5Contract`.
2. **Theorem 1 resource realization**: use the Lemma-5 certificate plus promise-register replacement to inhabit `VandaeleTheorem1Contract` rather than only its semantic/resource interface.
3. **Lemma 7 realization**: instantiate Theorem 1 for the incrementer construction and prove its local O(k+n), O(log(kn)) bounds.
4. **Figure 10 realization**: construct the exact two-round block circuit, prove the strong-promise semantics, and feed component bounds into `ComparatorIncrementerLemma8Composition`.
5. **Eq. (44) recursive ReversibleProgram**: connect Figure 10 to the `alpha/beta` split and produce the arbitrary-width one-dirty-ancilla incrementer family.
6. **Depth arithmetic**: discharge a concrete `LogRankContraction cutoff` and close the Eq. (46) O(log n) upper bound.
7. **Optimality admission**: connect Equation (2) to a formally represented external C^kX lower-bound theorem and separately encode the source ancilla/minimum-qubit assumptions before using `Theta`/“optimal” in the registry.

## Promotion discipline

Everything listed above is still branch implementation evidence until the branch Lean gate is observable and green. Do not add these declarations to the formalized technical-lemma registry, do not describe Lemma 8/Theorem 4 as reproduced on the public site, and do not promote the source's asymptotic optimality claim solely from the semantic contracts.

# Comparator / Incrementer Reversible Arithmetic Memory

- `id`: `tl-comparator-incrementer-arithmetic`
- `source`: Vivien Vandaele, *Asymptotically Optimal Quantum Circuits for Comparators and Incrementers*, arXiv:2603.12917
- `statement`: reuse comparator/incrementer arithmetic as a shared reversible routing primitive for interval/prefix State Preparation and arithmetic/sparse Block Encoding
- `lean_decl`: `QuantumBlockEncoding.ComparatorIncrementer.*`, `ComparatorIncrementerGeneral.*`, `ComparatorIncrementerRecursiveSplit.*`, `ComparatorIncrementerDirtyAncilla.*`, `ComparatorIncrementerControlledConjugation.*`, `ComparatorIncrementerModularConjugation.*`, `ComparatorIncrementerAllX.*`, together with `QuantumBlockEncoding.PromiseGateOptimization.*`
- `lean_status`: `obligation` — branch implementations exist, but this card must not enter `registry.json` as `formalized` until the Lean gate accepts the exact branch
- `used_by`: interval-tree State Preparation; piecewise-amplitude routing; sparse-address Block Encoding; finite-difference/banded address logic; promise-register circuit mutations
- `dependencies`: `ReversibleClassical`, `PrimitiveMacros`, little-endian basis transport, exact CCX refinement
- `next_action`: admit the branch Lean gate; then refine arbitrary-width all-X to a concrete reversible program and controlled fan-out, connect the Eq. (34) split to Vandaele's recursive strong-promise circuit, and prove the resource recurrence
- `tags`: `comparator`; `incrementer`; `reversible-arithmetic`; `interval`; `state-preparation`; `block-encoding`; `resource`; `dirty-ancilla`; `controlled-conjugation`

## Why this is a high-value ASPBE memory card

Many constructions that look unrelated at the matrix level share the same
circuit skeleton: compute an arithmetic predicate or shifted address, use it to
route amplitudes/operators, then uncompute all promised workspace. The reusable
object is therefore not “a comparator paper” in isolation; it is a shared
proof/circuit interface between State Preparation and Block Encoding.

A typical clean predicate route is

\[
|x\rangle|0\rangle_f|y\rangle
\longmapsto
|x\rangle|p(x)\rangle_f|y\rangle
\longmapsto
|x\rangle|p(x)\rangle_f|F_{p(x)}(y)\rangle
\longmapsto
|x\rangle|0\rangle_f|F_{p(x)}(y)\rangle.
\]

The final restoration equation is part of the reusable contract. A circuit
that computes the right predicate but leaves garbage is not interchangeable
with a clean oracle required by a parent SP/BE theorem.

## Source theorem boundary

The source paper proves asymptotically optimal comparator and incrementer
families in a Clifford+Toffoli setting, with linear gate count and logarithmic
depth and minimum-qubit statements under its declared model. ASPBE must keep
those claims separate from its current branch implementation.

**Do not infer the arbitrary-width source theorem from the semantic layers
below.** To reproduce the paper-wide result, ASPBE still needs the concrete
recursive strong-promise circuit family, gate-level controlled fan-out,
parameterized correctness induction, resource recurrences, and matching
lower-bound/model assumptions in Lean.

## ASPBE finite proof-bearing seed on the current branch

`QuantumBlockEncoding/ComparatorIncrementer.lean` introduces one exact compiler
bridge instead of hand-assigning costs beside a logical circuit:

```text
ReversibleProgram
  -> compileReversibleProgram
  -> PrimitiveProgram over {X, RY, RZ, CX}
  -> exact permutation-matrix equality
  -> resource extraction from that same primitive program
```

The important local roots are intended to be:

- `compileReversibleProgram_eval` — generic exact reversible-to-primitive refinement;
- `incrementer3_action` and `incrementer3Primitive_exact` — finite 3-bit incrementer semantics/refinement;
- `comparatorLtThree_action`, `comparatorLtThree_cleanFlag`, and `comparatorLtThreePrimitive_exact` — finite `< 3` comparator;
- `intervalLtThreeSelect_restoresFlag` and `intervalLtThreeSelect_clean_action` — compute/use/uncompute selector;
- `incrementer3_compilationCost`, `comparatorLtThree_compilationCost`, and `intervalLtThreeSelect_compilationCost` — costs derived from those exact circuits.

Until the branch Lean gate accepts these declarations, treat this list as a
proof obligation, not as promoted compiled memory.

## Finite resource model

For the current seed, ASPBE records both logical and compiled fields:

\[
C=(N_X,N_{\mathrm{CX}},N_{\mathrm{CCX}},N_T,
N_{1q}^{\mathrm{primitive}},N_{\mathrm{CX}}^{\mathrm{primitive}},D,a_{\mathrm{clean}}).
\]

The intended finite records are:

| circuit | logical X | logical CX | Toffoli | T/T† | primitive 1q | primitive CX | depth | clean work |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 3-bit incrementer | 1 | 1 | 1 | 7 | 12 | 7 | 14 | 0 |
| 2-bit `<3` comparator | 1 | 0 | 1 | 7 | 12 | 6 | 13 | 0 |
| clean `<3` interval selector | 2 | 1 | 2 | 14 | 24 | 13 | 27 | 1 |

These are **finite compiler records**, not the source paper's asymptotic
optimality theorem.

## First State Preparation consumer

`QuantumBlockEncoding/StatePreparationIntervalTree.lean` uses the clean `<3`
selector on the address distribution

\[
|\phi\rangle=
\frac{9}{25}|00\rangle+
\frac{12}{25}|01\rangle+
\frac{12}{25}|10\rangle+
\frac{16}{25}|11\rangle.
\]

With a clean work flag and target bit, the selector routes addresses
`0,1,2` to target bit one and address `3` to target bit zero. Under the
repository's little-endian convention the intended four-qubit output support is

\[
\{8,9,10,3\}
\]

with amplitudes `9/25, 12/25, 12/25, 16/25` respectively.

The former missing clean-extension leaf is now implemented in
`QuantumBlockEncoding/StatePreparationIntervalTreeEndToEnd.lean`. It embeds the
already-certified two independent Grover--Rudolph address rotations on low
wires 0 and 1, composes them with the exact selector, packages an intended
`ComplexStatePreparationCertificate 4`, and derives the intended unified
primitive cost

\[
(N_T,N_{1q},N_{CX},D,a_{\rm clean})=(14,26,13,27,1).
\]

This is **branch implementation evidence only until Lean admission**. The card
must not describe the end-to-end certificate as compiled before the build is
observable and green.

## Arbitrary-width source ladder now represented on the branch

The branch deliberately separates the paper into semantic layers rather than
encoding Figure 10 first and repairing its meaning afterward.

### Layer 1 — parameterized contracts

`ComparatorIncrementerGeneral.lean` fixes:

- `IncrementerSpec n` for modular `n`-bit successor;
- `ClassicalComparatorSpec n c` preserving the address and toggling an arbitrary
  incoming flag iff the address is below the classical threshold;
- `QuantumComparatorSpec n` preserving both quantum inputs and toggling the flag
  iff the left value is less than the right value;
- proof-bearing family interfaces whose correctness fields must be discharged by
  real circuit constructions rather than assumed globally.

The finite 3-bit incrementer and 2-bit `<3` comparator are connected to these
parameterized contracts as finite seed theorems.

### Layer 2 — Eq. (34) recursive split/carry semantics

`ComparatorIncrementerRecursiveSplit.lean` names the incremented low block, the
low-block carry, and the carry-updated high block of an `(n+k)`-bit word and
proves the exact decomposition

\[
(x+1)\bmod 2^{n+k}
=
\operatorname{low}' + 2^n\operatorname{high}'.
\]

This is the arithmetic induction target for the paper's recursive circuit.

### Layer 3 — Eq. (35) inverse-by-conjugation

The source incrementer is not involutory, so the existing generic
`dirtyControlledInvolution_action` is the wrong theorem. The branch instead
introduces the source-appropriate condition

\[
X_{\rm all}\,\mathrm{Inc}\,X_{\rm all}=\mathrm{Inc}^{-1}=\mathrm{Dec}.
\]

`ComparatorIncrementerDirtyAncilla.lean` records the abstract
`InverseByConjugation` interface and derives the corresponding cancellation
identity.

`ComparatorIncrementerModularConjugation.lean` then discharges this algebraic
hypothesis on `ZMod N` with

\[
\mathrm{Inc}(x)=x+1,
\qquad
X_{\rm all}(x)=-x-1.
\]

Thus Eq. (35) is no longer merely assumed at the arithmetic level.

### Layer 4 — Eq. (36) dirty inverse-pair protocol

`ComparatorIncrementerDirtyAncilla.lean` formalizes a dirty protocol for a
forward operation and its inverse. When the external control is false the
forward/backward pair cancels; when it is true the branch is arranged so exactly
one forward operation remains. The theorem records exact target action and dirty
flag restoration for every incoming dirty value.

This is strictly more appropriate than pretending the incrementer satisfies
`U^2=I`.

### Layer 5 — controlled-conjugation realization of the choice

`ComparatorIncrementerControlledConjugation.lean` removes a hidden semantic
choice from Layer 4. It proves that two externally controlled conjugators around
the dirty-controlled inverse operation realize the source-style branch:

- control false: the conjugators are identities and increment/decrement cancel;
- control true, dirty zero: the two conjugators cancel;
- control true, dirty one: conjugation converts decrement into increment.

The resulting theorem gives the Eq. (36)-style action and dirty restoration as
an exact finite basis permutation identity.

### Layer 6 — arbitrary-width all-X little-endian semantics

`ComparatorIncrementerAllX.lean` defines all-X directly on
`PrimitiveBasis n` and proves

\[
\operatorname{LE}(X^{\otimes n}|x\rangle)
=2^n-1-\operatorname{LE}(|x\rangle).
\]

It also transports the operation to `Fin (2^n)` and proves the transported
permutation is involutory. This connects the modular `-x-1` description to the
repository's actual little-endian basis convention at the representation level.

The remaining gap is **gate-level**, not semantic: construct the arbitrary-width
all-X `ReversibleProgram`, prove its evaluation equals this basis permutation,
and then refine the externally controlled all-X to the paper's controlled
fan-out resource model.

## Next Vandaele proof leaves

Proceed in this order:

1. compile arbitrary-width all-X from `ReversibleGate.x` and prove exact equality
   with `allXBasisEquiv`;
2. define/refine the controlled all-X fan-out used by Eq. (36), including its
   gate/depth contribution under the source model;
3. connect the Eq. (34) low/high split to the strong-promise incrementer used in
   the recursive construction;
4. encode the Figure 10 / Eq. (44) recursive family with correctness induction;
5. derive the source recurrences for the chosen split
   `alpha = 2 * ceil(sqrt n)`;
6. only then prove the asymptotic `Theta(n)` gate and `Theta(log n)` depth claims;
7. formalize lower-bound/minimum-qubit assumptions separately before using the
   word “optimal” in the Lean registry.

## Block Encoding consumers to retrieve later

The same card should be retrieved when a BE construction contains:

- an interval or threshold mask;
- a banded/sparse offset lookup;
- modular index shifts;
- piecewise coefficients selected by range predicates;
- compute/use/uncompute arithmetic around a value-to-amplitude oracle;
- promise-register cleanup in a controlled conjugation.

The parent BE theorem must still prove its clean block, normalization and error;
this card only discharges the arithmetic subroutine appropriate to its evidence
status.

## Promotion rule

Promote local roots to `registry.json` only after the exact branch declarations
build. At promotion time, record each declaration's exact signature and source
file separately. The source paper's asymptotic theorem should remain a distinct
`paper-cited`/partial-route record until the recursive construction, resource
recurrence, and optimality proof are themselves formalized.

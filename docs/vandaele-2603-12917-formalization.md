# Formalization roadmap: Vandaele 2026 comparators and incrementers

Primary source: Vivien Vandaele,
[Asymptotically Optimal Quantum Circuits for Comparators and Incrementers](https://arxiv.org/abs/2603.12917).

**Status boundary.** ASPBE currently has only a partial route. The compiled module
`QuantumBlockEncoding/PromiseGateOptimization.lean` proves reusable
controlled-conjugation and dirty-flag/involution identities as exact finite
basis permutations (plus a small abstract cost comparison). It does **not**
currently certify the paper's Figure 4 adder, Figure 5 comparator, the
arbitrary-width comparator/incrementer families, their asymptotic resource
theorems, or the lower-bound/optimality claims.

This document refines the Vandaele worked example in `HARNESS.md`. It is a
proof-frontier plan, not evidence that the planned declarations exist.

## 1. Source targets to freeze

The formalization should pin one paper version and transcribe, at minimum, the
following source objects before proof search:

- the `C^k X` convention and the source gate/resource model
  `{CCX, CX, X}`;
- the structural operators used by the paper `F_k^(n)`, `L_k^(n)`, and `V_k^(n)` and the exact wire ordering;
- the promise-gate definitions and the controlled-conjugation identities;
- Figure 4 and its slices `U₁,…,U₈`;
- Eq. (16), which rewrites the controlled adder in terms of controlled
  `Uᵢ` blocks;
- Figure 5 and Eq. (17), the advertised quantum–quantum comparator map;
- the recursive comparator construction and the recurrence/resource argument
  used for the `Θ(n)` gate and `Θ(log n)` depth result;
- the classical–quantum comparator, incrementer, classical–quantum adder and
  downstream modular-multiplication/Shor claims if/when those later sections
  enter scope.

The source statement and the literal circuit are different evidence objects.
If a figure and prose appear to select different operand/carry conventions,
ASPBE records the mismatch and proves the literal circuit first; it never
silently swaps registers to make the advertised equation true.

## 2. Existing certified frontier

Already compiled in `PromiseGateOptimization.lean`:

1. basis-permutation semantics for controlled targets;
2. Figure-3-style controlled conjugation:
   only the middle operation needs the control when the surrounding operation
   is applied and un-applied coherently;
3. weak/strong promise-spec interfaces;
4. dirty-flag compute/use/uncompute/use for an involutory target;
5. restoration of the dirty flag and exact controlled action;
6. unitarity of the induced basis-permutation matrix;
7. an abstract cost fact: replacing a clean flag by a dirty flag in this
   involutory protocol costs one additional controlled-target use.

Reusable but **not source closure**:

- `QuantumBlockEncoding/ModularAdder3.lean` demonstrates how a concrete
  reversible gate list can be given basis semantics and compiled to the
  repository primitive layer. Its three-bit clean-workspace adder is not
  Figure 4 and must not be used as a replacement proof of the Vandaele adder.

## 3. Root acceptance target

For the quantum–quantum comparator, the root is the entire chain

```text
literal Figure 4 gates
  -> exact U1,...,U8 slice semantics
  -> arbitrary-width adder semantics, including the high carry/output bit
  -> literal X–ADD–X Figure 5 semantics
  -> Eq. (17) comparator predicate with the proved operand convention
  -> no-ancilla circuit theorem
  -> gate/depth recurrence and asymptotic theorem
  -> lower-bound bridge needed for "optimal"
```

No arithmetic theorem disconnected from the printed circuit closes this root.

## 4. Phased formalization

### V0 — Source and convention packet

Deliverables:

- commit-pinned source/version metadata;
- typed register schema: (a)-register, (b)-register, flag/carry qubit,
  little-/big-endian choice, overwritten/preserved registers;
- exact chronological gate order for every Figure 4 slice;
- exact interpretation of the Figure 5 X layers and the adder orientation;
- a finite discriminator table for the smallest nontrivial widths.

Acceptance: source reviewer and an independent decoder agree on the register
map without seeing an intended correction.

### V1 — Structural primitives and promise layer

Formalize paper-faithful semantics for the structural operators required later,
rather than only the generic identities already present.

Candidate interfaces (names are proposals, not existing declarations):

```text
Vandaele.F
Vandaele.L
Vandaele.V
Vandaele.strongPromiseSpec
Vandaele.controlledStrongPromise
```

Prove exact basis action, inverses/restoration, and their relation to the
generic `PromiseGateOptimization` lemmas through narrow adapters. Do not
duplicate the generic controlled-conjugation theorem.

Resource statements here should be split into:

- algebraic gate-count identities for the declared gate list;
- depth/scheduling facts;
- ancilla cleanliness/dirty restoration;
- asymptotic bounds;
- external lower bounds.

A proof in one tier does not certify the others.

### V2 — Figure 4 adder, finite witness then arbitrary width

First transcribe the printed 5-bit Figure 4 literally. Give each slice a named
basis permutation and prove their composition. The finite witness is a
source/convention discriminator, not the final theorem.

Then generalize to arbitrary width. The proof should expose local carry
invariants sufficient to compose (U_1,ldots,U_8), rather than prove only a
closed-form modular arithmetic identity.

Required outputs:

- preservation theorem for the untouched operand;
- exact sum on the overwritten data register;
- exact high carry/flag bit;
- cleanup/restoration theorem for every temporary/promise sector that the
  source circuit relies on;
- one theorem that states the complete Figure 4 action in the source register
  order.

### V3 — Figure 5 comparator and the orientation audit

The paper advertises

`|a⟩|b⟩|z⟩ → |a⟩|b⟩|z ⊕ [a<b]⟩`

ASPBE must derive this from the **literal** Figure 5 circuit.

The critical audit is to separate

**data subtraction modulo `2ⁿ`** from the **raw high carry/borrow predicate**.

For every finite discriminator, report both candidate predicates
`[a<b]` and `[b<a]`; then prove which one follows from the exact Figure 4
operand convention and the X–ADD–X wrapper. A one-bit or five-bit truth table
may falsify an interpretation, but only the arbitrary-width theorem closes
Eq. (17).

If the literal source circuit and Eq. (17) disagree under the pinned
convention, preserve:

1. source equation;
2. literal-circuit theorem;
3. mismatch/counterexample;
4. proposed minimal repair

as four separate objects. The repair needs its own independent review.

### V4 — Recursive comparator and Theorem 2 resources

Once Figure 5 semantics is closed, formalize the recursive `V₂^(n)`
construction and its promise-register use.

Keep correctness and complexity separate:

- gate-list/circuit correctness;
- recurrence for gate count;
- recurrence for depth;
- proof that no extra clean/dirty ancilla is used by the advertised comparator;
- asymptotic closure (Theta(n)) gates and (Theta(log n)) depth under the
  source gate model;
- lower-bound bridge before the word **optimal** is exposed publicly.

The recurrence proof should become reusable graph memory for other
divide/square-root-recursive circuit constructions rather than a comparator-
specific arithmetic script.

### V5 — Controlled and classical–quantum comparators

Formalize the paper's controlled comparator only after the uncontrolled root is
stable. Reuse the existing controlled-conjugation theorem through a checked
adapter; do not re-prove it inside the comparator module.

For the classical–quantum comparator, make the classical constant encoding and
its cost model explicit. A classically fixed control is not automatically free
at the logical-circuit tier unless the source model treats it that way.

### V6 — Incrementers

Formalize

`|x⟩ → |(x+1) mod 2ⁿ⟩`

from the paper's literal recursive circuit. Required evidence mirrors the
comparator path:

- finite printed-circuit witness;
- arbitrary-width action;
- workspace/dirty-ancilla restoration;
- gate/depth recurrence;
- upper bound and the separate lower-bound reduction used for optimality.

### V7 — Classical–quantum adder and downstream algorithmic consequence

Only after comparator/incrementer roots compile should they be used to certify
the paper's improved classical–quantum adder. The downstream Shor claim is a
separate integration theorem because it depends on the cost model and the
specific modular-multiplication construction being substituted into.

Do not promote the abstract paper-level asymptotic consequence from the
existence of local comparator lemmas alone.

## 5. Proposed module boundaries

These are planning boundaries, not committed APIs.

```text
QuantumBlockEncoding/PromiseGateOptimization.lean      -- existing generic identities
QuantumBlockEncoding/Vandaele/SourcePrimitives.lean    -- F/L/V + source register conventions
QuantumBlockEncoding/Vandaele/Adder.lean               -- Figure 4 + Eq. (16) adapters
QuantumBlockEncoding/Vandaele/Comparator.lean          -- Figure 5 / Eq. (17)
QuantumBlockEncoding/Vandaele/ComparatorResources.lean -- recurrences + asymptotics + lower-bound adapters
QuantumBlockEncoding/Vandaele/Incrementer.lean
QuantumBlockEncoding/Vandaele/ClassicalQuantum.lean
```

A module should be created only when its first substantive theorem/interface is
ready; placeholder files do not count as progress.

## 6. Graph contribution

Prefer the following reusable nodes/hyperedges:

- controlled conjugation (already shared);
- dirty flag + involutory target (already shared);
- multi-controlled-X resource interface;
- ladder/fan-in/fan-out circuit semantics;
- ripple-carry slice invariant;
- carry-to-comparison predicate;
- divide/square-root recurrence solver for circuit resources;
- comparator and incrementer as consumers of those lower nodes.

The comparator should not carry private copies of Boolean arithmetic,
permutation unitarity, resource tuples, or primitive compilation if the
repository already supplies them.

## 7. Protocol and CI gates per phase

Every phase uses all five ASPBE gates:

| Gate | Vandaele-specific question |
| --- | --- |
| Source | Is the exact printed gate/register convention frozen? |
| Semantic | Does the literal circuit implement the claimed basis map? |
| Lean | Does the named arbitrary-width theorem compile with no hidden proof hole? |
| Integration | Are ancilla restoration, gate tier, depth and resource records compatible with the shared library? |
| Exposition | Can a reader track every data/carry wire and identify the theorem behind every advertised arrow? |

For a changed production module, the theorem-publication protocol additionally
requires the whole-module publication binding, source-blind reconstruction,
distinct anti-anchored review, assumptions classification and typed graph delta.

## 8. Parallel work that is actually independent

After V0 freezes conventions, useful parallel objectives are:

- **literal-circuit worker:** exact 5-bit Figure 4/5 transcript and exhaustive
  basis discriminator;
- **arbitrary-width arithmetic worker:** carry invariants and `Uᵢ` composition;
- **source-adversarial worker:** Eq. (17) orientation and minimal
  counterexamples, without assuming the advertised predicate;
- **resource worker:** recurrence/depth/gate proofs and lower-bound source
  dependencies;
- **reader worker:** theorem-linked data-flow/carry-flow diagrams only after the
  relevant semantics are stable.

The Master merges these only when their register order and source digest agree.

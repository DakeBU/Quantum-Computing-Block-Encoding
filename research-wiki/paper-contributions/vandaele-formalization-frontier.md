# Vandaele 2026 formalization frontier

> Branch status: **proof obligations on `codex/sp-papers-comparator-proof-cost`**.
> This page records what has been written and how the proof graph is organized.
> It is **not** a Lean-admission certificate.  No item below should be promoted
> to the formalized registry until a readable Lean build report exists.

Source: Vivien Vandaele, *Asymptotically Optimal Quantum Circuits for
Comparators and Incrementers*, arXiv:2603.12917.

## Evidence classes used below

- **actual gate candidate** — a concrete `ReversibleProgram` / scheduled circuit
  and a Lean correctness proof have been written on the branch;
- **source semantic closure** — the source operator/circuit identity has an exact
  Lean theorem, but the low-depth physical family may still be an imported
  proof-bearing input;
- **resource closure** — actual component resource functions imply the source
  asymptotic target with uniform constants;
- **external realization leaf** — a cited circuit family from an earlier paper
  is represented by a proof-bearing interface but has not yet been reconstructed
  gate-by-gate in this repository;
- **external lower leaf** — a stronger lower theorem from the literature is
  still cited rather than reproved.

All current items remain branch obligations until Lean admission is observable.

## Source traps already resolved

### Definition 2.3 ladder chronology

Equation (5) is now the authoritative source target.  The naive ladder circuit
must execute block gates in **reverse block order** so that a block never reads a
preceding target after it has already been modified.  The earlier forward-order
interpretation was removed.

Current chain:

`Equation (5) closed form`
→ `descendingLadderEquiv`
→ `naiveLadderEquiv`
→ actual reverse-CX / reverse-CCX flat programs.

### Classical–quantum comparator convention

The paper contains two related conventions that cannot be silently identified:

- the Equation-(3) lower-bound diagram tests `a >= 2^k-1`;
- Equation (29) defines the strict classical–quantum comparator by `c < a`.

For `k>=1`, the Equation-(3) diagram is represented by the strict convention
with shifted constant `2^k-2`.  ASPBE also keeps `address < constant` as a
separate query-oracle contract instead of overwriting it with the paper's
orientation.

## Structural primitive spine

Aggregator: `VandaeleStructuralPrimitivesFormalization.lean`.

### General promise gates — source Definitions 3.1/3.2

**Source semantic closure**

- `PromiseGateUnitary.lean`
  - matrix-level weak promise specification;
  - matrix-level strong/QMUX specification;
  - strong → weak.
- `PromiseGateUnitaryMux.lean`
  - constructive block-diagonal QMUX from arbitrary unitary blocks.
- `PromiseGatePermutationMatrixBridge.lean`
  - reversible promise permutations embed into the general matrix definitions.
- `PromiseGateCircuitIdentities.lean`
  - Equation (10) clean-fibre cancellation for involutory targets;
  - Equation (11) inverse/adjoint convention;
  - controlled promise gate distinguished from a promise gate whose target is
    controlled-U.
- `PromiseGateReversibleComposition.lean`
  - weak/strong promise composition on one promise register.

### Generic compute/use/uncompute

**Source semantic closure**

- `StrongPromiseComputeUseUncompute.lean`
  - compute predicate into a temporary promise bit;
  - use the bit as control;
  - uncompute;
  - promise restored for arbitrary incoming bit;
  - clean branch implements predicate-controlled target without requiring U to
    be involutory.
- `StrongPromiseCleanToDirtyInvolution.lean`
  - one extra controlled-U use upgrades the clean strong-promise protocol to a
    dirty-bit protocol when `U^2=I`.

### Lemma 1 — multi-controlled X

**Source semantic closure**

- canonical `C^k X` permutation already existed in `VandaeleLemma1Contract`.

**Internal lower bounds in ASPBE's `{X,CX,CCX}` model**

- `VandaeleParityCore.lean`:
  - `C^k X` is exactly one transposition, hence odd;
  - duplicated action over an unused binary fibre is even.
- `PrimitiveBasisRemoveWire.lean` +
  `ReversibleGateUnusedWireParity.lean`:
  - split one spectator wire;
  - any gate not touching it factors into two identical fibres.
- `ReversibleGateParityLowerBound.lean`:
  - every X/CX/CCX gate on `q>=4` is even;
  - every program is even;
  - `k>=3` therefore forbids ancilla-free `C^k X`.
- `VandaeleLemma1ParityLowerBound.lean`:
  - converts zero-ancilla circuit impossibility to minimum-ancilla ≥1 once the
    numerical minimum is linked to circuit existence;
  - discharges the comparator/incrementer ancilla-lower-bound premise.
- `ReversibleProgramGateLowerBound.lean`:
  - every correct program must touch all k control wires;
  - each gate touches at most three wires;
  - hence `k <= 3 * program.length`.

**Still external**

- the stronger arbitrary bounded-gate-set lower theorem;
- the logarithmic depth lower bound;
- the low-depth constructive Lemma-1 circuit family from the cited source.

### Lemma 2 — fan-out

- source semantics and low-depth family interface already existed.
- **actual gate candidate:** `VandaeleLemma2FirstOrderNaiveProgram.lean`
  gives the real `F_1^(n)` n-CCX serial baseline with exact Definition-2.2
  semantics and gate/depth = n.
- `F_2` and the logarithmic-depth source family remain external realization
  leaves; a three-control block is not silently replaced by a CCX.

### Lemma 3 — first-order ladder

- `VandaeleLemma3ProgramFamily.lean`: proof-bearing external low-depth family.
- **actual gate candidate:** `VandaeleLemma3NaiveProgram.lean`
  - reverse-CX list;
  - exact Equation-(5) semantics;
  - only CX;
  - gate count = depth = n.

The naive family is a same-target baseline, not the cited logarithmic-depth
schedule.

### Lemma 4 / Appendix A.1 — second-order ladder

- **actual gate candidate:** `VandaeleLemma4NaiveProgram.lean`
  - reverse-CCX list;
  - exact Equation-(5) data action;
  - arbitrary workspace restored;
  - only CCX;
  - gate count = depth = n.
- `VandaeleEquation58PromiseGadget.lean`
  - actual Equation-(58) five-bit CCX gadget;
  - arbitrary promise restoration;
  - clean target action.
- `VandaeleEquation58GenericBridge.lean`
  - exact identification of Equation (58) with the generic strong-promise
    compute/use/uncompute theorem.
- `VandaeleLemma4AppendixResource.lean`
  - Equation-(60)/(61)/(62) transformation;
  - exact source closed-form regime begins at `n>=2` because the printed
    `floor(log2(2n/3))` is negative at n=1;
  - totalized resource envelope remains valid for all natural widths.
- `VandaeleLemma4ProgramFamily.lean`
  - same scheduled family must satisfy semantic and Appendix resource envelopes.
- `VandaeleCorollary4ProgramFamily.lean`
  - same schedule must satisfy strong restoration + clean semantics + OnlyCCX +
    resource envelopes.

**Still external:** the actual logarithmic-depth baseline schedule from [9].
Vandaele's transformation of that baseline is formalized; the cited baseline is
not invented.

### Appendix A.2 / Corollary 1

`VandaeleCorollary1ResourceClosure.lean` composes actual Lemma-4 and Lemma-1
resource functions into the general `L_k^(n)` uniform target.

### Appendix A.3 / Corollary 4

`VandaeleCorollary4General.lean` records the general `L_k` strong-promise source
target: n promise wires, clean target = source-certified Equation-(5) ladder,
promise restored for arbitrary input, resources inherited from Corollary 1.

### Lemma 5 and Theorem 1

- exact Equations (13)/(14) semantics;
- half-split dirty-qubit borrowing arithmetic;
- uniform resource closures;
- arbitrary-key controlled conjugation;
- clean/dirty Theorem-1 semantic closure;
- Corollary-2 `{CCX,CX,X}` specialization.

## Quantum-adder application — Section 3.3

Aggregator: `VandaeleQuantumAdderFormalization.lean`.

- `VandaeleQuantumAdderTarget.lean`:
  canonical `(a,b,z)` target by treating `(b,z)` as one `(n+1)`-bit modular
  register.
- `VandaeleCorollary3ControlledQuantumAdderTarget.lean`:
  canonical k-controlled target.
- `VandaeleCorollary3ControlledQuantumAdderResource.lean`:
  two Lemma-3 ladders + central Theorem-1 block + three Lemma-5 layers close
  `O(n+k)`, `O(log n + log k)`, `max(1,n-k+1)` clean workspace.

**External realization leaf:** the cited Figure-4 ripple-carry schedule itself.

## Comparator spine

Aggregator: `VandaeleComparatorFormalization.lean`.

Completed source-facing branch nodes include:

- canonical QQ and CQ targets;
- subtraction/high-bit interpretation of QQ comparison;
- QQ → CQ restriction;
- Equation-(3) exact `C^k X` reduction with the convention mismatch preserved;
- Definition-2.4 `V_k` and Equation-(18) source identity;
- Lemma-6 promise/resource contract;
- Equation-(25) recursive register split;
- Equation-(28) controlled-V2 resource closure;
- Theorem-2 linear/log upper recurrence closure;
- Theorem-3 real input-wire borrowing and one-dirty resource closure;
- controlled Corollary-5/6 targets and resources;
- parity-backed CQ ancilla optimality;
- QQ/CQ lower-bound transfer chain `QQ -> CQ -> C^k X`.

**Remaining concrete realization:** source Figure-5/6 low-depth scheduled circuit
families, ultimately depending on the external low-depth ladder/fan-out
primitives.

## Incrementer spine

Aggregator: `VandaeleIncrementerFormalization.lean`.

Major branch nodes include:

- actual arbitrary-width Gidney zeroed-ancilla `{CCX,CX,X}` source program;
- clean increment correctness and arbitrary workspace restoration;
- strong promise/decrement/Eq.-(35) bridges;
- Lemma-7 Eq.-(38) clean/dirty/promise semantics and resource closures;
- Figure-9 source controlled-conjugation assembly;
- Equation-(39) mixed-radix block cascade;
- canonical square-root block partition;
- Equation-(40)/(42) promise-cleanliness and two-round scheduling;
- actual finite gate-sum / round-max resource envelopes for Lemma 8;
- Equation-(44) recursive arithmetic semantics;
- gate/depth recurrence upper closures;
- Equation-(2) lower-bound transfer;
- parity-backed one-ancilla optimality;
- Corollary-7 controlled increment target/resources.

**Remaining concrete realization:** Figure-9/10 low-depth schedules must be bound
to actual low-depth Lemma-1/2/3/4/Corollary-4 implementations.  The source
semantic/resource graph is already separated so those future circuits cannot
borrow resources from a different implementation.

## Classical adder / Section 6

Aggregator: `VandaeleAdderFormalization.lean`.

- canonical classical `+c mod 2^n` target and all-X conjugation;
- Figure-11 carry comparator arithmetic and basis-register split;
- exact floor/ceiling recurrence interfaces;
- strong-induction closure to `O(n log n)` gates / `O(log^2 n)` depth;
- Corollary-8 controlled target and resource closure.

## Modular multiplication / Shor — Section 6.2

Aggregator: `VandaeleShorFormalization.lean`.

- `VandaeleModularAdditionSemantics.lean`:
  Figure-12 arithmetic; second comparator uncomputes the clean flag by an exact
  iff.
- `VandaeleShorResourceApplication.lean`:
  external Häner architecture call-count contract + Corollary-6/8 resource
  functions imply explicit
  `O(n^3 log n)` gate and `O(n^2 log^2 n)` depth envelopes;
  exact `2n+2` qubit bookkeeping.

The Häner architecture schedule remains external; the replacement primitives
and resource composition are explicit.

## Current highest-priority remaining leaves

1. **Lean admission.**  The connector still exposes no readable push-run ID and
   the branch admission reporter has produced no bot report.  All items above
   therefore remain obligations.
2. **External low-depth structural families.**  Reconstruct or formally import
   the cited Lemma-1, Lemma-2, Lemma-3/[9], and Lemma-4/[9] low-depth schedules.
3. **Bind source Figures 5/6/9/10 to those actual scheduled families.**  Semantic
   and resource targets are already fixed, so this is refinement rather than
   specification design.
4. **Depth lower bound.**  The logarithmic `C^k X` depth lower theorem remains a
   cited result.  A natural internal route is a backward-lightcone proof for
   valid reversible schedules.
5. **General bounded-gate-set lower theorem.**  ASPBE now proves the linear
   gate-count and parity lower bounds in its concrete reversible model; the
   stronger source gate-set statement remains external.

## Promotion rule

Do not mark any declaration from this branch `formalized` in the technical
registry until a Lean build for the relevant proof spine is visible and passes.

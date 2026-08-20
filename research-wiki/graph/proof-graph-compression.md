# Proof-Graph Compression: Evidence-Preserving Design

## Current conclusion

ASPBE should **not** introduce ZDD or MIP compression into the authoritative
Lean graph yet.

The public `website/lean-graph-contract.json` currently certifies only:

- internal Lean module-import edges;
- module-to-public-declaration containment;
- curated chapter, example-case, and paper overlays.

It explicitly does **not** claim theorem-level proof-term dependencies. A ZDD of
lemma-support sets built from this graph would therefore compress a weaker
object than the proof structure we ultimately care about, while giving readers
a misleading impression that dependent proof state had been preserved.

The first compression task is consequently an **audit and view problem**, not a
proof-state replacement problem.

## Authoritative layer versus compressed views

The authoritative data must retain every object required to replay Lean:

1. declaration names and exact types;
2. module/import environment;
3. theorem-level constants referenced by elaborated proof terms, once exported;
4. metavariable and obligation information for partial proofs, when available;
5. typeclass/coercion/unification constraints needed by the actual Lean state;
6. source/proof-term identity needed for checker replay.

Any future compressed representation is an auxiliary index or visualization.
It must carry a lossless link back to the authoritative object.

## Library-aware proof cost

For a completed or partial proof object \(P\), ASPBE may record a vector rather
than prematurely force one scalar objective:

\[
C(P)=\bigl(
N_{\rm newDef},
N_{\rm newLemma},
N_{\rm reused},
|V_P|,
|E_P|,
\operatorname{depth}(P),
L_{\rm term},
T_{\rm check},
\mathcal O_{\rm open}
\bigr).
\]

Interpretation:

- new definitions and lemmas measure library expansion;
- reused declarations measure leverage of existing mathematics;
- proof-DAG size/depth measure structural complexity;
- proof-term/source length is a syntactic measurement, not automatically a
  mathematical simplicity metric;
- checker time is machine-dependent telemetry and must be stored separately
  from deterministic proof identity;
- open obligations retain their typed structure rather than only a count.

A weighted scalar can be derived for one search policy, but the raw vector
should remain available for later reweighting and human interpretation.

## When a support hypergraph becomes legitimate

After theorem-level dependencies are exported, one may define an auxiliary
support hypergraph

\[
H=(O,L,E),
\]

where obligations \(O\) are connected to candidate declarations \(L\) through
support/decomposition hyperedges \(E\). This is a **relaxation** of Lean proof
search. Membership of a lemma-support set never by itself certifies that Lean's
dependent typing, unification, application order, or metavariable constraints
can be satisfied.

### Safe lower bounds

Branch-and-bound pruning is permitted only after an admissibility proof for the
chosen relaxation. A schematic bound

\[
\mathrm{LB}(S)=C_{\rm committed}(S)+\mathrm{LB}_{\rm remaining}(S)
\]

is safe only when:

- every charged cost is nonnegative;
- extending a support cannot reduce already committed cost;
- remaining obligations are not double-counted;
- any heuristic bonus/penalty is excluded from the admissible lower bound.

Only then may ASPBE prune when

\[
\mathrm{LB}(S)\ge C_{\rm incumbent}.
\]

Without those conditions, the score is a ranking heuristic, not a safe pruning
certificate.

## Why ZDD is not the default

ZDDs are attractive when the main object is a large family
\(\mathcal F\subseteq 2^L\) of sparse, highly overlapping lemma-support sets.
They do not naturally encode all of Lean's dependent proof state. Therefore a
ZDD backend becomes justified only if real theorem-level traces show that:

1. candidate supports are the dominant repeated object;
2. support families are large enough for compression to matter;
3. support overlap is high;
4. the cost of reconstructing/checking Lean states from a support candidate is
   acceptable.

The repository should measure these quantities before adding the dependency.

## Why MIP is not the default

A MIP relaxation may be useful for set cover, shared-lemma selection, or a
library-design problem such as “choose a small reusable lemma basis covering
many target proofs.” It is less natural for elaborator state, nonlinear term
construction, and dependent type compatibility. MIP should therefore be used
only for a clearly isolated combinatorial subproblem with a proved relation to
the underlying proof objective.

## Immediate implementation roadmap

### Phase A — non-lossy graph audit

Keep the current public graph unchanged. Add measurements of module/declaration
counts, repeated import signatures, overlays, and later theorem-level dependency
fan-in/fan-out. A compact visualization may group nodes, but clicking a group
must expand to the original nodes and edges.

### Phase B — theorem dependency export

Extract dependencies from the elaborated Lean environment/proof terms and label
edge provenance. Do not infer theorem dependence from source proximity alone.

### Phase C — proof-cost telemetry

Record deterministic structural cost and machine-dependent checker telemetry in
separate fields. Validate the data against known proofs.

### Phase D — only then test compression

Compare plain adjacency, transitive/reachability views, support-family
compression, and any ZDD/MIP prototype on **real ASPBE traces**. Adopt a method
only if it reduces search/storage/visual complexity without weakening replay or
misstating evidence.

## Reader-facing principle

Compression should reveal recurring mathematics — shared lemmas, reusable
construction motifs, and genuinely new topology in the proof network — while
never becoming the authority for correctness. The uncompressed Lean objects and
the kernel checker remain the source of truth.

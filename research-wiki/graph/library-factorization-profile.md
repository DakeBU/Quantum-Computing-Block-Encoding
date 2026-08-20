# Library Factorization Profile

## Purpose

This card measures whether ASPBE's formal library is becoming more reusable
without treating a smaller graph as automatically better mathematics.

It is a **read-only diagnostic** over a chosen authoritative dependency graph.
It never authorizes Lean declarations or edges to be merged, removed, or
replaced.  The current implementation runs on the module-import graph and is
therefore explicitly labeled `module-import-proxy`.  The same definitions are
intended for the future theorem-level proof dependency DAG.

## Target-relative support

Fix a directed support DAG \(G=(V,E)\) and a chosen set of target roots \(T\).
For each target \(t\), let \(S_t\) be all support nodes that can reach \(t\),
including \(t\) itself.  Define the target-reuse count of a node

\[
r(v)=|\{t\in T:v\in S_t\}|.
\]

The choice of \(T\) matters. Useful future views include:

- all public theorem roots;
- one textbook chapter's terminal theorems;
- all reproduced State Preparation papers;
- all reproduced Block Encoding papers;
- the target leaves of one ASPBE synthesis task;
- old results versus one newly added paper, to measure its structural effect.

## 1. Unique support burden versus unfolded proof mass

Let

\[
U=\left|\bigcup_{t\in T}S_t\right|,
\qquad
I=\sum_{t\in T}|S_t|.
\]

`U` is how many unique support nodes the shared library maintains. `I` is how
many node occurrences would appear if every target were expanded separately and
no support were shared.

Define

\[
F_{\mathrm{share}}=\frac{I}{U},
\qquad
G_{\mathrm{reuse}}=1-\frac{U}{I}.
\]

These are best understood through the standard expression-tree versus
expression-DAG / term-graph analogy: a DAG represents a common subexpression
once and lets multiple parents reuse it, whereas unfolding the DAG duplicates
that subexpression.  This analogy is useful only after fixing the semantic
identity of a Lean node; ASPBE does not merge merely similar theorems.

## 2. How much of the library is genuinely shared?

Define

\[
V_{\mathrm{shared}}=\{v:r(v)\ge2\},
\qquad
\rho_{\mathrm{shared}}=
\frac{|V_{\mathrm{shared}}|}{U}.
\]

Also retain

\[
\bar r_{\mathrm{shared}}=
\frac{\sum_{v\in V_{\mathrm{shared}}}r(v)}{|V_{\mathrm{shared}}|},
\qquad
r_{\max}=\max_v r(v),
\]

and the full histogram

\[
k\longmapsto |\{v:r(v)=k\}|.
\]

This prevents `F_share` from hiding two very different topologies: one universal
foundation theorem plus many one-off leaves, versus many reusable middle-layer
lemmas shared across construction families.

## 3. Pairwise sharing mass: reward nodes reused many times

A particularly useful statistic for ASPBE is

\[
P_{\mathrm{mass}}
=
\sum_{v\in V}\binom{r(v)}{2}.
\]

By double counting,

\[
\boxed{
\sum_v\binom{r(v)}2
=
\sum_{\{s,t\}\subseteq T}|S_s\cap S_t|
}.
\]

So this is not an arbitrary score: it is exactly the total number of shared
support-node incidences across all unordered pairs of targets.  Normalizing by
\(\binom{|T|}{2}\) gives

\[
\bar P=
\frac{P_{\mathrm{mass}}}{\binom{|T|}{2}},
\]

the **mean number of shared support nodes per target pair**.

Because \(\binom{r}{2}\) grows quadratically, a node reused by many targets
contributes more than many nodes each reused only twice.  This matches the
project intuition that a lemma used throughout State Preparation and Block
Encoding is a more important structural hub than a local convenience lemma,
while still exposing the raw reuse histogram for interpretation.

## 4. Direct fan-out is a local diagnostic, not the main objective

For each node record its direct out-degree / fan-out

\[
d^+(v)=|\{u:(v,u)\in E\}|.
\]

High fan-out is often evidence of a reusable API boundary.  But it only measures
immediate import/proof consumers; target-relative \(r(v)\) captures transitive
reuse and is therefore more aligned with a mathematical library.

## 5. Weighted profiles come later

When theorem-level proof telemetry exists, one may retain separate weighted
versions

\[
U_w=\sum_{v\in\cup_t S_t}w(v),
\qquad
I_w=\sum_{t\in T}\sum_{v\in S_t}w(v),
\qquad
F_{\mathrm{share}}^{(w)}=I_w/U_w.
\]

Possible weights include proof-term size, source length, elaboration/check time,
or human-curated mathematical burden.  These must remain separate channels.
ASPBE should not silently collapse them into one scalar because “short proof
term”, “fast checker”, and “conceptually simple lemma” are different notions.

## 6. Contribution profile for a new paper or construction

For an incoming formalization compare the graph before and after admission and
record at least:

1. **new semantic nodes** — genuinely new definitions/theorems;
2. **new support edges** — new dependency relations;
3. **reuse of existing nodes** — how much old formal mathematics the result
   factors through;
4. **new shared nodes** — new lemmas subsequently used by multiple targets;
5. **bridge edges / bridge lemmas** — connections between previously weakly
   connected SP/BE proof families;
6. changes in \(F_{share}\), \(\rho_{shared}\), \(\bar r_{shared}\), and
   \(\bar P\), always alongside the raw graph counts.

A strong contribution need not add many nodes.  A small lemma that exposes the
right invariant and causes many previously separate proofs to factor through a
shared branch may be more structurally important than a large isolated proof.
This is exactly the distinction ASPBE wants the formal graph to make visible.

## 7. Anti-gaming rule

Never optimize

```text
minimize node count; maximize fan-out
```

as a naked objective.  One can game it by placing unrelated mathematics inside
one huge theorem/definition.  A useful factorization must preserve:

- exact theorem statements and Lean replay;
- source fidelity;
- typed dependency provenance;
- reasonable human-facing lemma boundaries;
- proof/elaboration telemetry;
- the uncompressed authoritative graph.

The profile is therefore a Pareto-style library diagnostic, not a compression
certificate.

## Relation to existing graph / compiler ideas

The nearest established ideas are:

- **term graphs / expression DAGs**: common subexpressions are represented once
  and shared rather than duplicated in an expression tree;
- **DAG tree compression**: repeated subtrees can be represented by shared DAG
  nodes, with lossless reconstruction when the equivalence relation is fixed;
- **fan-out**: the local number of immediate consumers of a node;
- **reachability / descendant support**: the transitive analogue used by
  target-reuse count `r(v)`;
- **transitive reduction**: useful only as an optional reachability-preserving
  visualization layer, never as permission to delete Lean dependency evidence;
- **betweenness / bridge diagnostics**: potentially useful later for identifying
  lemmas that connect formalization families, but not an optimization target by
  itself.

Useful background on sharing-aware DAG representations includes Avanzini--Moser,
*Complexity of Acyclic Term Graph Rewriting* (FSCD 2016,
https://doi.org/10.4230/LIPIcs.FSCD.2016.10) and Bahr--Axelsson,
*Generalising tree traversals and tree transformations to DAGs: Exploiting
sharing without the pain* (Science of Computer Programming 2017,
https://doi.org/10.1016/j.scico.2016.03.006).  ASPBE borrows the structural
sharing viewpoint, not their objects as a replacement for dependent Lean proof
states.

## Implementation

`tools/lean_graph_reuse_metrics.py` currently emits these statistics from the
generated module graph.  `scripts/build-website.sh` publishes the result as
`data/lean-graph-reuse-metrics.json`.  The schema and evidence class should be
kept stable enough that a future theorem-dependency exporter can produce a
parallel profile for direct comparison.

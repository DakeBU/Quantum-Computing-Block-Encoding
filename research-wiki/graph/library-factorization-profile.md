# Library Factorization Profile

## Purpose

This profile measures whether the ASPBE Lean library is becoming a genuinely
shared mathematical DAG rather than a collection of duplicated proof trees.
It is a **read-only diagnostic layer**. It does not replace Lean proof objects,
delete dependencies, quotient theorem states, or certify semantic equivalence.

The same definitions are intended to survive the migration from today's
module-import proxy to a future theorem-level proof-term dependency DAG.
Every metric snapshot must therefore record both its evidence layer and its
selected target family.

## Target-relative support

Fix a declared target family \(T\). A target may later be a theorem, an example
case, a paper reproduction root, or another explicitly named frontier object.
For each target \(t\in T\), let \(S_t\) be its full transitive dependency
support, including \(t\) itself.

For each support node \(v\), define its target reuse

\[
r(v)=|\{t\in T:v\in S_t\}|.
\]

This separates two questions that should not be conflated:

- direct graph fan-out: how many immediate users does a node have?;
- target reuse: how many selected end targets ultimately depend on it?

The second quantity is usually closer to the library-design question we care
about.

## Core factorization quantities

Define the unique support size

\[
U=\left|\bigcup_{t\in T}S_t\right|
\]

and the expanded support incidence count

\[
I=\sum_{t\in T}|S_t|=\sum_v r(v).
\]

`U` counts each maintained support node once. `I` is the support mass obtained
if every target is conceptually expanded into its own dependency tree and
shared nodes are counted again for every target that uses them.

The basic structural sharing factor is

\[
F_{\mathrm{share}}=\frac{I}{U}.
\]

The equivalent normalized reuse gain is

\[
G_{\mathrm{reuse}}=1-\frac{U}{I}.
\]

The shared-node coverage is

\[
C_{\mathrm{shared}}
=\frac{|\{v:r(v)\ge2\}|}{U}.
\]

All raw quantities must remain available; no single scalar is the authoritative
library score.

## Reuse concentration

A central lemma reused by many targets should be distinguishable from many
small local lemmas each reused only twice. Record the full histogram of \(r(v)\),
its maximum, and the pairwise sharing mass

\[
P_{\mathrm{share}}
=\sum_v \binom{r(v)}{2}
=\sum_{\{s,t\}\subseteq T}|S_s\cap S_t|.
\]

The equality is a double-counting identity: each node used by \(r(v)\) targets
is shared by exactly \(\binom{r(v)}2\) unordered target pairs. Thus
`P_share` measures total pairwise overlap without throwing away high-reuse
nodes.

For \(|T|\ge2\), also report

\[
\overline P_{\mathrm{share}}
=\frac{P_{\mathrm{share}}}{\binom{|T|}{2}},
\]

the mean number of shared support nodes per target pair.

## Contribution profile for a new paper or construction

When a new formalization is added, record a vector rather than asking only how
many new declarations appeared:

\[
\Delta_{\rm topology}
=(N_{\rm newV},N_{\rm newE},N_{\rm reusedOld},N_{\rm newShared},
N_{\rm bridge},\Delta F_{\rm share},\Delta P_{\rm share}).
\]

Here `bridge` means an edge or reusable node that connects previously separated
proof families under an explicitly stated graph/evidence layer. A paper that
adds only one leaf can still be mathematically important, and a paper that adds
many declarations can still contribute little reusable topology. The vector is
intended to make that distinction inspectable, not automatic.

## Anti-gaming constraints

Never optimize node count, fan-out, or any sharing statistic in isolation.
Packing many concepts into one giant opaque lemma would reduce node count and
increase apparent reuse while damaging the library.

A refactor is admissible only when it preserves:

1. exact Lean types and kernel replay;
2. theorem-level dependencies once available;
3. source/proof provenance;
4. open obligations and dependent constraints where relevant;
5. reader-meaningful theorem boundaries;
6. evidence status and access/query-model assumptions.

Therefore the factorization profile is a Pareto-style diagnostic vector. Search
heuristics may derive temporary scalarizations, but those scalarizations are not
stored as mathematical truth.

## Current public layer

The current `Underlying Lean Graph of Libraries` contains module import edges
and module-to-public-declaration containment, not theorem-level proof-term
edges. Its displayed factorization values therefore use a
`module-import-proxy` evidence class. The root barrel module is excluded, and
non-barrel frontier modules are temporary targets.

This current number is useful as a baseline for the shape of the repository,
not as a claim about proof compression.

## Upgrade path

1. Export theorem dependencies from the elaborated Lean environment/proof terms.
2. Define explicit theorem/case/paper target families.
3. Recompute the same \(S_t,r(v),U,I,F_{\rm share},G_{\rm reuse},
   C_{\rm shared},P_{\rm share}\) quantities.
4. Compare module-proxy and theorem-DAG profiles rather than silently replacing
   one by the other.
5. Only after observing real support-family size and overlap should ZDD, MIP,
   quotienting, or other compressed indexes be benchmarked.

The uncompressed Lean environment remains the authority throughout.

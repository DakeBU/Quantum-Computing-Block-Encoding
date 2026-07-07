<div align=center>

# ABEIS: State Preparation and Block Encoding for Quantum Computing

<h3 align="center">
A Platform for Lean-validated quantum state-preparation and block-encoding construction.
</h3>

[![Github][Github-image]][Github-url]
[![License][License-image]][License-url]


[Github-image]: https://img.shields.io/badge/github-12100E.svg?style=flat-square
[License-image]: https://img.shields.io/badge/License-MIT-orange?style=flat-square




[Github-url]: https://github.com/DakeBU/Quantum-Computing-Block-Encoding
[License-url]: https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/LICENSE


</div>

## News 🔥

* **June 2026.** ABEIS is now public as a testing preview for Lean-certified
  quantum construction.  The library now presents two application directions:
  state preparation first, then block encoding.  The API-user website
  placeholder is available at https://dakebu.github.io/Quantum-Computing-Block-Encoding/
  while the hosted workflow is still being tested.  Feedback, issue reports,
  and suggested state/operator/oracle benchmarks are welcome.


---
ABEIS is a Lean 4 project and multi-agent harness for turning a requested
quantum construction into concrete unitary candidates, gate-level circuit
matrices, resource scores, and Lean-checked certificates.  It now exposes two
application directions, ordered by difficulty:

1. **State Preparation.**  Given a normalized target state `|psi>`, synthesize
   a unitary `U` such that `U |0^n> = |psi>`.  Equivalently, in the standard
   computational basis, the first column of `U` is the target state.  This is
   the minimal concrete quantum-construction task and a useful PREPARE
   primitive for later algorithms.
2. **Block Encoding.**  Given a non-unitary operator `A`, synthesize a larger
   unitary whose clean ancilla block equals `A / alpha`.  This is the original
   ABEIS target and is more general, but also more abstract.

![ABEIS application overview](docs/assets/abeis_contract_pipeline_2x.png)


Basic gates make the state-preparation target concrete:

```text
H |0> = (|0> + |1>) / sqrt(2)
X |0> = |1>,   X |1> = |0>
```

So the user's intuition is right: Hadamard maps the zero state to an equal
superposition, and the Pauli-X gate swaps the computational-basis states.

The project is built around two related contracts.  The state-preparation
contract is:

```text
U |0^n> = |psi>
```

or, equivalently:

```text
column_0(U) = |psi>
```

For unnormalized vectors, ABEIS requires the task to say whether the target is
the normalized state `|psi / ||psi||>` or the rank-one operator `|v><0^n|`.
The latter becomes a block-encoding-style operator target.

The block-encoding contract is:

```text
operator/query-oracle contract A
-> candidate unitary U_A and circuit schedule
-> Lean-checked block-entry and unitarity certificate
-> resource-ranked construction
-> post-Lean executable exports such as Qiskit, QuantumKatas, and QASM
```






ABEIS does not stop at "assume an oracle exists".  A task should state the
operator `A`, normalizer `alpha`, clean ancilla projector, and the desired
exact block-entry equation:

```text
(<0^a| ⊗ I) U_A (|0^a> ⊗ I) = A / alpha
```

It may also state an accepted approximation budget:

```text
|| A - alpha * ((<0^a| ⊗ I) U_A (|0^a> ⊗ I)) || <= epsilon
```

Among Lean-certified candidates, ABEIS ranks constructions by asymptotic tier
first.  Inside the same tier it compares:

```text
(gateCount, depth, auxiliaryQubits, oracleCalls)
```

Paper constructions are treated as baselines and training data.  Once a paper
baseline is formalized, the same system can try to improve the construction
for the same fixed operator target.

ABEIS currently exposes two harness profiles.  Users can run either profile, or
run both in isolated workspaces and compare the certified population curves.

![Hierarchical Harness](docs/assets/hierarchical_harness.png)

![Game Harness](docs/assets/game_harness.png)

## Core Workflow

```mermaid
flowchart LR
  A["user chooses state prep or block encoding"] --> A1["state prep: target |psi> and U|0^n>=|psi>"]
  A --> A0["block encoding: A, alpha, projector"]
  A1 --> B["upper fixes target"]
  A0 --> B
  A --> A2["user gives resource floor, epsilon, iteration limits"]
  B --> B1["Natural-Language Team explores ideas"]
  B --> B2["Lean Team plans formalizable routes"]
  B1 --> P["Game Council exchanges insights and sets capacity"]
  B2 --> P
  P --> C["middle keeps Lean <-> natural-language map"]
  C --> D["Game Harness lower population proposes exact U_A"]
  D --> E["finite/unitarity/block-entry diagnostics"]
  E --> F["Lean exact certificate attempt"]
  F --> G{"meets resource floor before limit?"}
  G -- yes --> H["Scenario 1: approximate-improvement phase"]
  G -- no/stalled --> I["Scenario 2: relaxed approximate search"]
  H --> J["Lean approximate certificate attempt"]
  I --> J
  J --> K["resource score and certified archive"]
  K --> L["post-Lean executable exports"]
  L --> M["Qiskit / QuantumKatas / QASM checks"]
  M --> N["dynamic agent-count audit"]
```

ABEIS treats diagnostics as search signals, not as proofs.  A candidate enters
the certified population only after Lean proves the advertised theorem at the
task's semantic tier.

## State-Preparation Memory

State preparation is the first ABEIS application direction because it asks for
one concrete action:

```text
prepare |psi> from |0^n>
```

The main invariant is simple and useful for agents: the candidate unitary's
first column must be the target state.  Upper agents should first normalize or
classify the target vector, middle agents should expose a small proof DAG for
`U |0^n> = |psi>`, and lower agents should avoid turning an unnormalized
vector into a unitary-output claim.  If the target vector is unnormalized, the
task must either normalize it or switch to the rank-one operator
`|v><0^n|`, which is then a block-encoding target.

Classic routes exposed to users and agents:

| Route | Natural case | Core proof move | Where to read |
| --- | --- | --- | --- |
| Single-qubit gate anchor | teaching examples such as `H` and `X` | prove the first column/action on `|0>` directly | [`SP.SingleQubitGates`](research-wiki/state-preparation-library/route-selector.md) |
| Recursive amplitude split | explicit normalized vector | split mass into a rotation plus conditional sub-preparations | [`SP.RecursiveAmplitudeSplit`](research-wiki/state-preparation-library/route-selector.md) |
| Reversible arithmetic amplitude | formula-defined amplitudes such as grid polynomials | compute value, rotate/load amplitude, then uncompute workspace | [`SP.ArithmeticAmplitude`](research-wiki/state-preparation-library/route-selector.md) |
| Dense fallback | small fixed dimension | synthesize a full unitary whose first column is the target | [`SP.DenseCompletion`](research-wiki/state-preparation-library/route-selector.md) |
| PREPARE primitive for BE | LCU weights, sparse/Gram routes, or density/purification | certify state preparation first, then consume it inside a clean-block proof | [`SP.ToBlockEncoding`](research-wiki/state-preparation-library/route-selector.md) |

## Block-Encoding Textbook Memory

ABEIS keeps a small textbook-style memory library for block-encoding
construction.  Its backbone is Lin Lin's lecture notes
([arXiv:2201.08309](https://arxiv.org/abs/2201.08309)), together with the
standard LCU, sparse-access, dilation, qubitization, and QSVT proof patterns.
The library is not a rigid detector and it is not meant to make agents
memorize recipes.  Block-encoding construction is often closer to technical
design search than to routine theorem replay.  Upper agents use these memories
as inspiration: recall several plausible constructions, keep a diverse
candidate population, and let middle agents split promising routes into small
Lean leaves.  Only compiled Lean leaves are reusable proof tools; route cards
that are not compiled remain ideas, contracts, or obligations.

A useful mental model is:

```text
operator/oracle target
-> textbook memories suggest route hypotheses, not mandatory recipes
-> middle layer maintains an insight pool and proof DAG
-> lower Lean/natural-language workers attack one leaf at a time
-> reviewer promotes only Lean-certified claims
```

Use the memory library in two different ways:

| Layer | Role in search | What agents may do |
| --- | --- | --- |
| Idea cards | brainstorming and population diversity | mutate, recombine, compare, or reject a route after upper/middle discussion |
| Compiled Lean leaves | reusable proof infrastructure | import, instantiate, or write a narrow adapter instead of reproving the theorem |
| Contract-only cards | safe high-level dependency markers | use as a proof-DAG node only when the task accepts that external contract status |

For example, if a task calls for a polynomial transform and a proved input
block encoding is already available, agents should first retrieve the QSVT
consumer memory and any compiled `QSVTConsumerContract`/Chebyshev leaves.  They
should not spend a lower-worker cycle trying to reprove the whole QSVT theorem
unless the active task explicitly asks for that foundational formalization.

Classic routes exposed to users and agents:

| Route | Natural case | Core proof move | Where to read |
| --- | --- | --- | --- |
| Entrywise clean block | explicit finite candidate | prove `U(clean,row)(clean,col)=A(row,col)/alpha` | [`BE.EntrywiseExact.CleanBlock`](research-wiki/block-encoding-library/cards/BE.EntrywiseExact.CleanBlock.md) |
| Partial permutation | `|dst><src| \otimes I`, reset maps, basis injections | complete a partial map to a permutation; non-target branches leave the clean block | [`BE.PartialPermutation.MatrixUnitTensorId`](research-wiki/block-encoding-library/cards/BE.PartialPermutation.MatrixUnitTensorId.md) |
| One-sparse support | one possible nonzero row per column | support permutation plus a Kronecker-delta entry proof | [`BE.Sparse.OneSparsePermutation`](research-wiki/block-encoding-library/cards/BE.Sparse.OneSparsePermutation.md) |
| Sparse access | row/column location and value oracles | uniform slot preparation and finite delta-sum collapse | [`BE.Sparse.ColumnOracle`](research-wiki/block-encoding-library/cards/BE.Sparse.ColumnOracle.md), [`BE.Sparse.RowColumnOracle`](research-wiki/block-encoding-library/cards/BE.Sparse.RowColumnOracle.md) |
| LCU / PREPARE--SELECT | finite sums of known blocks | prepare weights, select a block, project back | [`BE.LCU.PrepareSelect`](research-wiki/block-encoding-library/cards/BE.LCU.PrepareSelect.md) |
| Dilation fallback | dense contraction or small seed | 2-by-2 contraction rotations give an exact fallback unitary | [`BE.Contraction.SVDDilation`](research-wiki/block-encoding-library/cards/BE.Contraction.SVDDilation.md) |
| Qubitization / QSVT consumer | polynomial transform after a BE exists | consume a proved BE; do not hide the original oracle construction inside QSVT | [`BE.QSVT.ConsumerContract`](research-wiki/block-encoding-library/cards/BE.QSVT.ConsumerContract.md), [`qsvt-hard-hint-route.md`](research-wiki/block-encoding-library/qsvt-hard-hint-route.md) |

The graph below is the public Lean leaf module graph.  It is closer to the
`quantum-computing-lean` module graph than to an agent-flow diagram: files are
the main spine, compiled theorem leaves are shown as reusable nodes, and
external Lean libraries are shown only as searchable reference memories.

![ABEIS Lean leaf module graph](docs/assets/abeis_lean_leaf_module_graph.svg)

Compiled proof-weapon families:

| Family | Main Lean surface | Representative compiled leaves | Why it matters |
| --- | --- | --- | --- |
| Finite matrix core | `Core.lean`, `CircuitSemantics.lean` | `Matrix`, `PointwiseEq`, `evalWith_mul_apply`, `evalWith_mul_unique_path`, `evalWith_mul_two_path` | keeps circuit products and branch sums small enough for one-agent leaves |
| Clean-block/projector extraction | `BlockEncodingClassics.lean` | `cleanBlockBy_permMatrix_entry`, `cleanBlockProduct_permMatrix_entry`, `cleanBlockBy_permMatrix_eq_target_of_entry`, `ExactCleanBlock.clean_eq_target` | turns a block-encoding theorem into entrywise matrix equalities |
| Permutation and unitarity | `BlockEncodingClassics.lean`, `MainCase.lean` | `permMatrix`, `columnInner`, `rowInner`, `permMatrix_isRationalOrthogonal_of_bijective`, `partialPermutationCertificate` | proves exact reversible completions and main-case transfer operators |
| Sparse and value-oracle routes | `BlockEncodingClassics.lean` | `oneSparseMatrix_entry_if`, `oneSparse_from_support`, `sparseColumnCleanEntry_unique_slot`, `rowColumnSparseDeltaEntry`, `ValueToAmplitudeContract.correct` | formalizes the textbook sparse-access and compute-rotate-uncompute patterns |
| LCU/product/dilation/QSVT | `BlockEncodingClassics.lean` | `oneTermLCU_cleanBlock`, `weightedSum2_entry`, `productExactCleanBlockCertificate`, `scalarDilation_cleanEntry`, `chebyshevT_*`, `QSVTConsumerContract` | gives route skeletons for composition, fallback seeds, and polynomial consumers |
| Approximate/resource layer | `BlockEncoding.lean`, `Resources.lean`, `Circuit.lean`, `BlockEncodingClassics.lean` | approximate-BE records, `exactAsZeroErrorApproxCleanBlock_bound`, resource tuple/depth/gate leaves | separates correctness from the optimization objective |
| Task consumers | `MainCase.lean`, `CubicStatePreparation.lean`, `GHL2025.lean` | task-local verified candidates and paper/source wrappers | examples should consume generic leaves rather than redefine them |

External Lean code is kept as memory/reference material, not silently copied
into ABEIS proofs.  The relevant cards are:

- [`quantum-computing-lean`](research-wiki/external-lean-libraries/quantum-computing-lean.md): finite matrices, states, gates, projectors, gate actions, and unitarity proof organization.
- [`Lean-QuantumInfo`](research-wiki/external-lean-libraries/lean-quantuminfo.md): finite-dimensional quantum-information proof style.
- [`lean-quantum`](research-wiki/external-lean-libraries/lean-quantum.md): channels, qudits, trace/norm, and operator-oriented conventions.
- [`research-wiki/mathlib-lemmas/`](research-wiki/mathlib-lemmas/): Mathlib hits that should be reused or adapted before inventing local infrastructure.

Machine-readable and human-readable retrieval files:

- [`compiled-lean-leaf-index.md`](research-wiki/block-encoding-library/compiled-lean-leaf-index.md) and [`compiled-lean-leaf-index.json`](research-wiki/block-encoding-library/compiled-lean-leaf-index.json): generated declaration ledger.
- [`lean-leaf-module-graph.md`](research-wiki/block-encoding-library/lean-leaf-module-graph.md): textual ledger behind the graph.
- [`quantum-lean-leaf-atlas.md`](research-wiki/block-encoding-library/quantum-lean-leaf-atlas.md): relationship between ABEIS leaves, Mathlib, and nearby quantum Lean projects.
- [`route-selector.md`](research-wiki/block-encoding-library/route-selector.md): route-intuition guide for upper/middle agents.
- [`proof-network.md`](research-wiki/block-encoding-library/proof-network.md): proof-DAG view of reusable textbook leaves.
- [`classic_leaves.tex`](paper-notes/block-encoding-library/classic_leaves.tex): human-facing LaTeX proof templates.

Harness proof-engineering rules:

1. Decompose aggressively: each active theorem should fit one agent context and one stable local API.
2. Specify more than the theorem: include intended definitions, proof route, parent theorem, and Mathlib search terms.
3. Treat persistent failure as mathematical signal: recheck the statement, missing assumptions, or counterexamples before retrying tactics.
4. Make hidden regularity reusable: cleanup, boundedness, nonemptiness, injectivity, support uniqueness, and norm bounds become named contracts.
5. Do not frequently change the proof route once reviewer accepts a well-typed leaf; if the route changes, write a failure-memory packet.

Before adding generic Lean infrastructure, agents should search Mathlib:

```bash
python3 tools/qbe.py mathlib-search "Matrix.mul_apply"
```

If the theorem exists but cannot be imported directly yet, the proof packet
should still name the Mathlib module and assign only the smallest ABEIS adapter
as local work.

Human interaction is a first-class upper-layer input, not an out-of-band chat.
ABEIS records three human-facing intervention moments: scheduled 6h closeout,
direct user questions, and user status checks followed by new top-level
instructions.  Upper and middle agents should treat those interventions as
strategy updates, then translate them into task packets, proof obligations, or
candidate-population changes before lower agents continue.

If exact search fails to meet the user-specified resource floor within the
configured budget, the upper layer may switch to approximate BE search.  If a
fixed number of generations does not improve the population, the upper layer
may increase upper/middle/lower parallel agent counts up to the configured
maximum.  More agents are not assumed to be better; the increase is itself a
controlled experiment.
Once Scenario 2 approximate search is opened, that is a phase lock: old exact
leaves may remain as bounded dependencies or negative evidence, but the active
objective must name an epsilon tier, an error budget, and a Lean-checkable
approximate statement.

## Main Case Study

The current technical-report case study is the transfer-operator task:

```text
E_k = |0><k|_time ⊗ |0><1|_type ⊗ I
```

ABEIS records two parallel attempts for the concrete `r = 1, k = 1` instance.
Both report only Lean-certified candidates as achieved points, and both include
a post-Lean Qiskit export check.

| Run | Harness and inputs | Certified result | Score |
| --- | --- | --- | --- |
| `QBE-OP-OPTCTRL-COLD-CLEAN-001` | no-Pro Hierarchical Harness attempt | `coldE1Candidate_blockProjection`, `coldE1CandidateImage_permutation_certificate` | `(4,4,1,0)`; Qiskit export passed |
| `QBE-OP-OPTCTRL-001` | Pro-assisted evolution attempt | `OptimalControl.evolvedEqFlipVerified`, `OptimalControl.evolvedEqFlipZeroErrorApprox` | `(4,2,1,0)`; Qiskit export passed |

The no-Pro attempt shows the base harness recovering a correct finite
permutation block encoding from the operator contract.  The Pro-assisted
attempt injects an external Pro construction/proof packet after the run has
already started, just like a human intervention; the packet affects planning
only after the task-local Lean proof obligations are generated and discharged.

![Two parallel transfer-operator attempts](docs/assets/optctrl_hier_vs_pro.png)

Circuit storyboards and Qiskit export checks:

![No-Pro Hierarchical checkpoint storyboard](docs/assets/optctrl_cold_clean_storyboard.png)

![Lean-certified transfer-operator candidates](docs/assets/optctrl_storyboard.png)

![Post-Lean Qiskit export checks](docs/assets/qiskit_export_results.png)

This is a concrete `r = 1, k = 1` logical reversible permutation-matrix
certificate.  It is not claimed as a hardware-decomposed theorem, a general
arbitrary-register theorem, or a Lean-proved global optimality theorem.

Detailed human-readable status:

```text
reports/QBE-OP-OPTCTRL-COLD-CLEAN-001/latest.md
reports/QBE-OP-OPTCTRL-COLD-CLEAN-001/zh_summary.md
paper-notes/problem-exports/QBE-OP-OPTCTRL-COLD-CLEAN-001/latest.tex
reports/QBE-OP-OPTCTRL-001/latest.md
paper-notes/problem-exports/QBE-OP-OPTCTRL-001/latest.tex
executable-exports/QBE-OP-OPTCTRL-COLD-CLEAN-001/qiskit/export.py
executable-exports/QBE-OP-OPTCTRL-001/qiskit/export.py
```

## Active Hard Benchmark

`QBE-OP-CUBIC-STATEPREP-001` is the first hard state-preparation-style
benchmark:

```text
O_n |0^n> = sum_j (j / 2^n)^3 |j>
```

The vector on the right is not normalized.  The task therefore records the
user-level state-preparation intention and the Lean-checkable fallback
operator `O_n = |v_n><0^n|`.  A normalized state-preparation target would be
`|v_n / ||v_n||>`, while the rank-one fallback can feed the block-encoding
pipeline.  ABEIS should try exact candidates briefly, then switch to
approximate search with the requested tolerance `epsilon = 1e-10`.

Current status:

- Lean target declarations compile in `QuantumBlockEncoding.CubicStatePreparation`;
- the task, proof blueprint, proof obligations, candidate population, and
  verifier feedback are initialized;
- dense executable checks are treated as small-instance diagnostics, while the
  intended scalable route is symbolic arithmetic plus Lean family proof;
- no final approximate state-preparation or block-encoding candidate has been
  promoted yet.

Human-readable diagnostics:

```text
reports/cubic-stateprep/latest.md
reports/cubic-stateprep/zh_summary.md
```

## Why Lean For State Preparation And Block Encodings

Executable quantum tooling such as Qiskit, QuantumKatas, and QASM evaluators is
very useful for small concrete circuits: it can run a statevector, materialize
a unitary, or check a sample OpenQASM program.  That is not enough for many
state-preparation and block-encoding tasks, where the real claim is a symbolic
family of circuits indexed by register sizes, amplitude formulas,
sparse-access promises, normalizers, and ancilla cleanup conditions.

For an `r`-qubit time register, dense statevector/unitary validation pays the
Hilbert-space dimension directly.  Even a structurally simple family like

```text
E_k = |0><k|_time ⊗ |0><1|_type ⊗ I_state
```

requires a dense `2^(r+3) × 2^(r+3)` matrix if we insist on checking it by
materializing the full unitary.  ABEIS instead aims to prove symbolic Lean
theorems about the circuit family.  The proof checker follows the proof
structure; it does not need to enumerate the whole Hilbert space for every
larger `r`.

![Dense verifier memory forecast](docs/assets/verifier_hard_scaling_forecast.png)

At `r = 20`, a full dense complex128 unitary for this simple family would
already require about `1 PiB` of memory.  At `r = 32`, it is about `16 ZiB`.
This is where ABEIS should stop asking a simulator to materialize the whole
matrix and instead ask Lean for a symbolic theorem about the circuit family.

ABEIS still uses finite executable checks when they help.  They are useful as
small-instance checks, counterexample generators, and necessary-condition
diagnostics.  They are not promoted to scientific claims until the
advertised block-entry, unitarity, cleanup, and resource statements are closed
by Lean.

After a Lean certificate closes, ABEIS can emit runnable artifacts for users:
Qiskit Python circuits with exact finite assertions, QuantumKatas-style task
and test files, and OpenQASM transcripts with parser and fixed-instance checks.  These
exports are engineering deliverables, not replacements for the Lean theorem.
For symbolic families, the exported code records the concrete instantiation it
implements; the Lean theorem remains the reusable, parameterized certificate.

Current Qiskit exports:

- `executable-exports/QBE-OP-OPTCTRL-001/qiskit/export.py`: exported from a
  Lean-certified exact concrete champion.
- `executable-exports/QBE-OP-OPTCTRL-COLD-CLEAN-001/qiskit/export.py`:
  exported from the no-Pro Lean-certified cold-clean checkpoint.
- `executable-exports/QBE-OP-CUBIC-STATEPREP-001/qiskit/export.py`: finite
  dense baseline for small `n`; useful evidence, not a symbolic certificate.

Current executable-export self-tests:

| Task | Qiskit artifact | Status | What it checks |
| --- | --- | --- | --- |
| `QBE-OP-OPTCTRL-001` | `executable-exports/QBE-OP-OPTCTRL-001/qiskit/export.py` | passed: clean block error `0`, unitary error `0` | the exported four-qubit Qiskit circuit matches the Lean-certified concrete clean block and resources `(4,2,1,0)` |
| `QBE-OP-OPTCTRL-COLD-CLEAN-001` | `executable-exports/QBE-OP-OPTCTRL-COLD-CLEAN-001/qiskit/export.py` | passed: clean block error `0`, unitary error `0`, export error `0` | the no-Pro finite permutation export matches the Lean-certified clean block and resources `(4,4,1,0)` |
| `QBE-OP-CUBIC-STATEPREP-001` | `executable-exports/QBE-OP-CUBIC-STATEPREP-001/qiskit/export.py` | passed for finite `n=3`; clean block error about `2.8e-17` | a dense fixed-instance baseline only; not a symbolic family certificate |

## Why The ABEIS Harness

Qiskit QuantumKatas and QASM-Eval are good at testing submitted executable
artifacts.  QUASAR and AI-Mandel are useful examples of tool-feedback loops
for quantum artifacts.  Local public artifacts checked so far do not expose a
direct generic constructor for "given a target state or operator `A`,
synthesize and prove a symbolic unitary family."  ABEIS targets that stricter
task:

```text
given a state-preparation or oracle/operator requirement,
construct a candidate unitary U,
prove the state-action or block-entry theorem in Lean,
rank certified candidates by resources,
and then export runnable circuits for users.
```

ABEIS currently tests two compatible harness profiles.  Neither is declared
better in advance.

| Harness | Organization | When it may help |
| --- | --- | --- |
| **Hierarchical Harness** | One upper/middle/lower/reviewer stack, with human and ChatGPT Pro as upper-level intervention channels.  The lower layer has a natural-language architect, a Lean worker, and a necessary-condition verifier.  Middle agents coordinate their handoffs and maintain the insight population. | Targets where one coherent planner can keep the natural-language and Lean tracks synchronized without much duplicated strategy work. |
| **Game Harness** | Two semi-independent hierarchical teams plus a Game Council.  The Natural-Language Team has its own upper/middle/lower stack and competes by producing reviewer-plausible human proofs.  The Lean Team has its own upper/middle/lower stack and competes by producing compiled Lean certificates.  The independent team directors and middle curators can run in parallel; the Game Council then transfers insights both ways, decides capacity increases, and controls exact-to-approximate phase switches. | Targets where strategic diversity matters, or where natural-language insight and Lean formalization keep failing to reuse each other. |

Both harnesses use the same acceptance rule: only Lean-certified constructions
enter the certified population or appear as achieved points in evolution
curves.  Natural-language sketches, simulator checks, Qiskit tests, and Pro
answers can guide search, but they are not final certificates.

Both harnesses also have the same user-facing closeout and external-input rule.  Users may inject their own strategy notes, ChatGPT Pro answers, external AI suggestions, candidate block encodings, or natural-language proofs.  These inputs enter the run as explicit intervention packets.  The harness may route them into the active plan, the insight population, or rejected-route memory; in the Game Harness, the Game Council decides whether to send them to the Natural-Language Team, the Lean Team, or both.  They are never accepted, plotted, or exported as achieved solutions until Lean certifies them.

If the Lean Team closes a certificate, the Natural-Language Team translates it into a human-readable proof note.  If the Natural-Language Team finds a reviewer-plausible construction first, the Game Council sends it to the Lean Team for formalization.  After a Lean certificate closes, ABEIS should export:

- a step-by-step LaTeX block-encoding statement and proof that a user can copy
  into a paper;
- circuit diagrams and evolution curves for every Lean-certified exact or
  approximate candidate used in the case study;
- checked executable artifacts such as Qiskit, QuantumKatas-style tests, or
  QASM for the certified construction.
- a proof-DAG figure showing the root target, dependencies, verified leaves,
  rejected leaves, and postponed external contracts such as QSVT.

Detailed timing, route-ablation, external-verifier records, and harness-profile
comparisons are kept in `reports/` and run directories.  The README states the
scientific contract and the user workflow; the detailed evidence belongs in the
technical report and generated case-study summaries.

## Benchmark Paper Cases

Paper reproduction remains important, but as benchmark data for the core
operator-construction system.

The first active paper benchmark is:

- Guseynov--Huang--Liu,
  [Quantum framework for simulating linear PDEs with Robin boundary conditions](https://arxiv.org/abs/2506.20478).

The benchmark Lean file is:

```text
QuantumBlockEncoding/GHL2025.lean
```

Paper-benchmark mode should reproduce the paper construction and resource
score first.  Any improvement search belongs in a separate operator task with
the same target operator.

## Quick Start

```bash
cd /path/to/Auto-Quantum-Computing-Bloack-Encoding-In-Sleep

python3 tools/qbe.py init
python3 tools/qbe.py list-literature
python3 tools/qbe.py next-task
python3 tools/qbe.py check
```

The mandatory acceptance gate is:

```bash
lake build && lake build Tests
```

## Use ABEIS

ABEIS has three equivalent user entrypoints.  All three must produce the same kind of task packet, agent profile, run logs, Lean gate, human-language summary, Pro-prompt, and optional post-Lean executable exports.  The intended rule is: if the same model backend and prompt profile are used, the CLI template, an AI chat window, and the website should differ only in convenience, not in scientific target or acceptance criteria.

1. **Local CLI template.**  Download the repository, replace the state or operator text in a template command, and run `tools/qbe.py`.
2. **AI chat window.**  Download the repository and tell Codex, Claude, GLM, Gemini, Minimax, or another coding agent: “Use the ABEIS system in this repository to solve the following state-preparation or block-encoding problem.”  The agent should call the same `ingest-user-problem`, `sleep-run`, and `check` commands as the CLI template.
3. **Website task builder and dashboard.**  Use the website in `web/` in either
   local mode or hosted mode.  Local mode means: download the repository, serve
   `web/` in a browser, paste the oracle description, then run the generated
   local CLI/runner command with Codex, Claude, GLM, Gemini, Minimax, or a
   custom wrapper installed on that machine.  Hosted mode means: use the public
   page without downloading first, but provide a user-owned API key or
   self-hosted runner endpoint.  In both modes, the page generates the same task
   packet and renders the same dashboard artifacts: exact/approximate curves,
   certified circuit storyboards, selected-language summaries, Pro prompts, and
   post-Lean Qiskit/QuantumKatas/QASM export status.

Main local CLI workflow for the simpler state-preparation direction:

```bash
python3 tools/qbe.py new-task QBE-SP-001 \
  --kind statePreparation \
  --mode statePreparation \
  --title "Prepare my target quantum state" \
  --target-lean "QuantumBlockEncoding/MyStatePreparation.lean"

python3 tools/qbe.py sleep-run QBE-SP-001 \
  --cycles 2 \
  --agent-profile codex-parallel.example.json \
  --execute \
  --check-each-cycle
```

Main local CLI workflow for block encoding:

```bash
python3 tools/qbe.py new-task QBE-OP-001 \
  --kind operatorBlockEncoding \
  --mode operatorBlockEncoding \
  --title "Construct a block encoding for my query operator" \
  --target-lean "QuantumBlockEncoding/MyOperator.lean"

python3 tools/qbe.py sleep-run QBE-OP-001 \
  --cycles 2 \
  --agent-profile codex-parallel.example.json \
  --execute \
  --check-each-cycle
```

`sleep-run` uses adaptive capacity by default: it starts with a small queue
(upper director, middle coordinator, one lower worker, reviewer/build gate) and
expands upper, middle, or lower capacity only after upper/reviewer memory
records stagnation.  For state-preparation and operator-construction tasks, the default
`--exact-stall-cycles 2` allows the controller to open Scenario 2 approximate
search after a short exact-search patience budget when no Lean-certified exact
candidate exists.  Add `--fixed-capacity` only for ablation runs where every
cycle should consume the requested full panel and lower-agent counts.

Choose a harness profile explicitly when you want controlled comparisons:

```bash
# Hierarchical Harness, the default
python3 tools/qbe.py sleep-run QBE-OP-001 \
  --cycles 2 \
  --hierarchical-harness \
  --agent-profile codex-parallel.example.json \
  --execute \
  --check-each-cycle

# Game Harness
python3 tools/qbe.py sleep-run QBE-OP-001 \
  --cycles 2 \
  --game-harness \
  --natural-lower-count 2 \
  --lean-lower-count 2 \
  --agent-profile codex-parallel.example.json \
  --execute \
  --check-each-cycle
```

The harness-specific lower counts above are maxima under adaptive capacity, not
a promise to run every listed agent in every cycle.  The controller starts
small, expands only on recorded stagnation, and writes the effective capacity
policy into each run's `00_context.md`.

Case-study hyperparameters are recorded under `run-presets/`.  In particular,
`run-presets/main_case_hierarchical_reproduction.md` is the current public
entry point for replaying the transfer-operator main case with isolated no-Pro
and mid-run Pro-assisted Hierarchical Harness arms.  The cubic-diagonal hard case is
recorded in `run-presets/hard_hier_hinted_exact_to_approx.md`.

For a fair profile comparison, run both harnesses in isolated worktrees with
the same task packet, model profile, report language, active-time budget, and
Lean gate.  Both profiles must produce the same closeout artifacts: selected-
language summaries, ChatGPT Pro prompt if unresolved, a user-copyable LaTeX BE
proof after Lean closure, and checked executable exports such as Qiskit,
QuantumKatas-style tests, or QASM.

The harness is vendor-neutral: a profile under `agent-profiles/` can dispatch roles to Codex, Claude, GPT/OpenAI wrappers, Gemini, GLM, Minimax, or local tools.  The web page is not a public model-credit service.  In local-web mode it helps a downloaded checkout run local CLIs and then renders runner JSON.  In hosted-web mode it uses the user's API key or self-hosted runner endpoint.  For comparable results across the three entrypoints, keep the same task id, raw source artifact, report language, agent profile, active-budget policy, and Lean gate.  Long runs write summaries in the user's chosen language and export a problem-specific LaTeX proof note at `paper-notes/problem-exports/<task-id>/latest.tex`.

Users can also request post-certification executable outputs.  The static web
builder and task packets support Qiskit, QuantumKatas-style exercises, and
OpenQASM/QASM exports.  The harness should generate and check those artifacts
only after the corresponding Lean certificate is accepted, unless a task
explicitly marks them as pre-Lean diagnostics.  See
[`docs/executable_exports.md`](docs/executable_exports.md).

Progress during a run is visible in these files:

- `runs/<run-id>/dialogue.md`: role-tagged upper/middle/lower/reviewer handoffs.
- `runs/<run-id>/summary.md` and `zh_summary.md` or the selected-language equivalent: human-readable closeout.
- `runs/<run-id>/chatgpt_pro_prompt.md`: self-contained prompt for external deep reasoning if unresolved leaves remain.
- `runs/<run-id>/todo.md` and `memory_digest.md`: compact next-cycle state.
- `runs/logs/*.log`: raw execution log.
- `paper-notes/problem-exports/<task-id>/latest.tex`: user-copyable proof note after closeout.
- `reports/<task-id>/dashboard.json`, `evolution.json`, and
  `circuit_storyboard.json`: optional web-dashboard inputs for rendering
  champion status, exact/approximate curves, BE diagrams, and executable export
  checks.
- `reports/<task-id>/figures/`: reader-facing PNGs for the same information:
  evolution curve, certified-circuit storyboard, Qiskit/export status, and
  proof-DAG blueprint.  Only Lean-certified candidates may be plotted as
  achieved solutions.

Project layout:

- `QuantumBlockEncoding/`: Lean definitions, circuits, resources, and theorem
  certificates.
- `tasks/`: operator or paper-benchmark contracts.
- `candidate-populations/`: Lean-certified candidates and rejected routes.
- `failure-memory/`: compact typed failure packets and rejected-route lessons.
- `research-wiki/block-encoding-library/`: reusable construction memory cards
  and route selector for partial permutations, LCU, product/tensor arithmetic,
  sparse-access, dilation, QSVT consumers, and approximate dense/structured
  block encodings.
- `research-wiki/state-preparation-library/`: state-preparation route memory,
  including first-column checks, gate anchors, arithmetic amplitude loading,
  dense completion, and PREPARE-to-block-encoding handoffs.
- `conversion-windows/`, `proof-blueprints/`, `proof-obligations/`: compact
  proof state and Lean/natural-language correspondence.
- `executable-exports/`: post-Lean Qiskit, QuantumKatas, QASM, and related
  runnable artifacts for certified constructions.
- `tools/qbe.py`: orchestration CLI.
- `docs/`: deployment and long-run guides.

## Related Work And Similar Patterns

ABEIS adapts patterns from adjacent systems, but specializes them to
gate-level quantum block-encoding certificates.

| Work | Similar pattern | ABEIS counterpart design |
| --- | --- | --- |
| [ARIS][aris] | Plain-file autonomous research workflow and review. | Task files, skills, manifests, reviews, run logs. |
| [Learning Beyond Gradients][lbg] | Layered feedback and trial memory. | Upper/middle/lower/reviewer loops and compact summaries. |
| [EoH][eoh] | Evolutionary candidate populations. | Mutate/recombine candidate block-encoding circuits under a fixed target. |
| [LeanMarathon][leanmarathon] | Proof blueprint, dynamic leaves, CI gates. | Proof-blueprint snapshots and focused theorem-closure work. |
| [LeanSearch v2][leansearch-v2], [REAL-Prover][real-prover] | Global premise retrieval and retrieval-augmented Lean proof search. | Before inventing a block-encoding proof leaf, retrieve Mathlib/external premises and pass them to lower Lean workers with the intended route. |
| [Matlas][matlas-paper] | Semantic mathematical statement retrieval with dependency context. | Upper/middle agents use it as source-discovery inspiration for analogous block-encoding constructions, never as a proof certificate. |
| [Rethlas][rethlas-repo], [Archon][archon-repo], [Automated Conjecture Resolution][acr-paper] | Natural-language exploration paired with Lean formalization. | Game/Hierarchical harnesses keep NL construction and Lean construction cooperating, but Lean clean-block/unitarity certificates remain final. |
| [Chain-of-States][chain-of-states-paper], [Herald][herald-paper] | Intermediate proof-state chains and NL annotations of Lean declarations. | Middle agents translate candidate circuit proofs into explicit state chains and human-readable proof packets before assigning leaves. |
| [Iteris][iteris-paper] | Explore--plan--execute loops with durable project-local state. | ABEIS keeps operator targets, candidate populations, cost curves, verifier feedback, and exports as inspectable state. |
| [AlphaProof Nexus][alphaproof-paper], [repo][alphaproof-repo] | Independent Lean subagents plus evolutionary coordination for hard proof search. | Evidence for ABEIS's evolve/recombine candidate population, but ABEIS adds block-encoding cost metrics and Qiskit export. |
| [MathCode][mathcode] | Proof diagnostics and theorem reuse. | Hidden-assumption scans and reusable proof-attempt memory. |
| [Visored][visored-paper], [repo][visored-repo] | Controlled-natural-language proof surface with localized diagnostics and optional Lean emission. | Structured proof packets as a two-way exchange format between natural-language construction, Lean proof work, and human proof exports. |
| [Lean4Agent][lean4agent-paper] | Workflow/trajectory verification. | Lean-side process contracts in `Automation.lean`. |
| [EAGER-style failure traces][eager-paper] | Reasoning-trace failure representation and failure-scope retrieval. | `failure-memory/` packets that distinguish fine proof-leaf failures from coarse route/source failures. |
| [MADE-style judge evolution][made-paper] | Decomposed requirement judging for evolutionary search. | Reviewer vectors over target, unitarity, clean block, normalizer/error, resources, proof reuse, source faithfulness, and exportability. |
| [quantum-computing-lean][quantum-computing-lean], [Lean-QuantumInfo][lean-quantuminfo], [lean-quantum][lean-quantum] | Quantum formalization references: finite matrices, states, gates, projectors, quantum-information semantics. | Leaf-atlas references for small gate/action lemmas, clean-projector APIs, and future semantic alignment. |
| [QASM-Eval][qasm-eval], [Qiskit QuantumKatas][qiskit-quantumkatas] | Typed circuit/test feedback and executable Qiskit/QASM checks. | ABEIS distinguishes inspired feedback, optional exact finite Qiskit checks, and Lean-certified theorem closure. |
| [QUASAR][quasar-paper], [AI-Mandel][ai-mandel-paper] | Tool-feedback loops for quantum artifacts. | Search signals only; not proof certificates. |
| [LLM4AD_Next][llm4ad-next] | Low-entry-barrier web interface. | Static oracle-to-task-packet builder. |
| [Lexicographic bandits][lexelim-bandits] | Lexicographic active-set filtering. | Prioritize correctness, diagnostics, asymptotic tier, and cost tuple. |
| [Hierarchical provers][hierarchical-provers], [statistical provability][statistical-provability] | Reusable proof cuts and finite-budget proof progress. | Named proof-DAG nodes and run-efficiency metrics. |

More detail is in [`docs/automation_deployment.md`](docs/automation_deployment.md),
[`docs/attribution.md`](docs/attribution.md), and [`NOTICE.md`](NOTICE.md).

## Literature Roadmap

The source of truth is `QuantumBlockEncoding/Literature.lean`.

Selected block-encoding and oracle-construction targets:

| Status | Paper | Target |
| --- | --- | --- |
| `active` | Guseynov--Huang--Liu, [Quantum framework for simulating linear PDEs with Robin boundary conditions](https://arxiv.org/abs/2506.20478) | `QuantumBlockEncoding/GHL2025.lean` |
| `planned` | Guseynov--Huang--Liu, [Efficient explicit gate construction of block-encoding for Hamiltonians needed for simulating partial differential equations](https://arxiv.org/abs/2405.12855) | `QuantumBlockEncoding/GHL2025.lean` |
| `planned` | Camps--Lin--Van Beeumen--Yang, [Explicit quantum circuits for block encodings of certain sparse matrices](https://arxiv.org/abs/2203.10236) | `QuantumBlockEncoding/Circuit.lean` |
| `planned` | Camps--Van Beeumen, [FABLE: Fast Approximate Quantum Circuits for Block-Encodings](https://arxiv.org/abs/2205.00081) | `QuantumBlockEncoding/Circuit.lean` |
| `planned` | Gilyen--Su--Low--Wiebe, [Quantum singular value transformation and beyond](https://arxiv.org/abs/1806.01838) | `QuantumBlockEncoding/BlockEncoding.lean` |
| `planned` | Childs--Wiebe, [Hamiltonian simulation using linear combinations of unitary operations](https://arxiv.org/abs/1202.5822) | `QuantumBlockEncoding/BlockEncoding.lean` |
| `planned` | Low--Chuang, [Hamiltonian Simulation by Qubitization](https://quantum-journal.org/papers/q-2019-07-12-163/) | `QuantumBlockEncoding/BlockEncoding.lean` |
| `planned` | Sunderhauf--Campbell--Camps, [Block-encoding structured matrices for data input in quantum computing](https://arxiv.org/abs/2302.10949) | `QuantumBlockEncoding/Circuit.lean` |

The construction memory library is in
`research-wiki/state-preparation-library/` and
`research-wiki/block-encoding-library/`.  The state-preparation memory records
first-column checks, gate anchors, dense completion, and arithmetic amplitude
loading.  The block-encoding memory is organized as a route selector plus
theorem cards, so an agent can recognize when a target should be solved by
partial permutation, LCU, product/tensor arithmetic, sparse-access Gram
construction, density/purification, dilation, QSVT consumer contracts, or
approximate dense/structured synthesis.

## Citation

```bibtex
@misc{abeis2026,
  author = {Bu, Dake and Huang, Xiajie and Liu, Nana and Nitanda, Atsushi and Wong, Hau-san and Zhang, Qingfu},
  title = {{ABEIS: State Preparation and Block Encoding for Quantum Computing}},
  year = {2026},
  note = {Project page: \url{https://github.com/DakeBU/Quantum-Computing-Block-Encoding}}
}
```

[aris]: https://github.com/wanshuiyin/Auto-claude-code-research-in-sleep
[lbg]: https://github.com/Trinkle23897/learning-beyond-gradients
[eoh]: https://github.com/FeiLiu36/EoH
[leanmarathon]: https://github.com/YuanheZ/LeanMarathon
[mathcode]: https://github.com/math-ai-org/mathcode
[visored-paper]: https://arxiv.org/abs/2606.17581
[visored-repo]: https://github.com/xiyuzhai-husky-lang/visored
[llm4ad-next]: https://github.com/Optima-CityU/LLM4AD_Next
[lexelim-bandits]: https://xueb1996.github.io/pdf/AAAI-2026-Xue.pdf
[lean4agent-paper]: https://arxiv.org/abs/2606.06523
[eager-paper]: https://arxiv.org/abs/2603.21522
[made-paper]: https://arxiv.org/abs/2511.19489
[quasar-paper]: https://arxiv.org/abs/2510.00967
[qasm-eval]: https://github.com/fuzhenxiao/QASM-Eval
[qiskit-quantumkatas]: https://github.com/qiskit-community/Qiskit-QuantumKatas
[ai-mandel-paper]: https://arxiv.org/abs/2511.11752
[hierarchical-provers]: https://arxiv.org/abs/2602.10512
[statistical-provability]: https://arxiv.org/abs/2602.10538
[quantum-computing-lean]: https://github.com/duckki/quantum-computing-lean
[lean-quantuminfo]: https://github.com/Timeroot/Lean-QuantumInfo
[lean-quantum]: https://github.com/Hayata-Yamasaki-Group/lean-quantum
[leansearch-v2]: https://github.com/frenzymath/LeanSearch-v2
[real-prover]: https://github.com/frenzymath/REAL-Prover
[matlas-paper]: https://arxiv.org/abs/2604.17484
[rethlas-repo]: https://github.com/frenzymath/Rethlas
[archon-repo]: https://github.com/frenzymath/Archon
[acr-paper]: https://arxiv.org/abs/2604.03789
[chain-of-states-paper]: https://arxiv.org/abs/2512.10317
[herald-paper]: https://arxiv.org/abs/2410.10878
[iteris-paper]: https://arxiv.org/abs/2606.02484
[alphaproof-paper]: https://arxiv.org/abs/2605.22763
[alphaproof-repo]: https://github.com/google-deepmind/alphaproof-nexus-results

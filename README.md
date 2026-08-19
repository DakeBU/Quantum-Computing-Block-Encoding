<div align="center">

# ASPBE

### Automatic State Preparation and Block Encoding for Quantum Computing

A Lean-checked library and construction system for turning **state / query-oracle requirements** into
**mathematical constructions, Lean certificates, and executable quantum artifacts**.

[![Lean 4](https://img.shields.io/badge/Lean-4-6f42c1?style=flat-square)](https://lean-lang.org/)
[![Mathlib](https://img.shields.io/badge/Mathlib-pinned-2f705c?style=flat-square)](https://github.com/leanprover-community/mathlib4)
[![Qiskit](https://img.shields.io/badge/Qiskit-executable_exports-6929c4?style=flat-square)](https://www.ibm.com/quantum/qiskit)
[![QuantumComputinglib](https://img.shields.io/badge/QuantumComputinglib-read_online-0f62fe?style=flat-square)](https://dakebu.github.io/Quantum-Computing-Block-Encoding/)
[![License: MIT](https://img.shields.io/badge/License-MIT-35657d?style=flat-square)](LICENSE)

[**Read QuantumComputinglib**](https://dakebu.github.io/Quantum-Computing-Block-Encoding/) ·
[**Browse Lean declarations**](https://dakebu.github.io/Quantum-Computing-Block-Encoding/library/) ·
[**Example cases**](https://dakebu.github.io/Quantum-Computing-Block-Encoding/example-cases/) ·
[**Implementation map**](https://dakebu.github.io/Quantum-Computing-Block-Encoding/implementation-map/)

</div>

---

## What problem does ASPBE solve?

A quantum-computing researcher should be able to start from the **mathematical oracle contract**, rather than from a pre-existing circuit implementation.

| Task | Input contract | ASPBE tries to return |
| --- | --- | --- |
| **State Preparation** | a normalized target $|\psi\rangle$ | a unitary $U$ with $U|0^n\rangle=|\psi\rangle$, a human proof, a named Lean certificate, and optional circuit exports |
| **Block Encoding** | an operator $A$, normalization $\alpha$, clean ancilla convention, and optional error $\varepsilon$ | a unitary $U$ with $\|A-\alpha\Pi U\Pi^\dagger\|\le\varepsilon$, together with proof, resources, and optional executable exports |

A state-preparation theorem can later provide a **PREPARE** primitive inside a block-encoding construction, but the two acceptance contracts remain distinct.

![State preparation and block encoding contracts](docs/assets/abeis_application_overview.svg)

### The intended user interaction

**You specify** the object to prepare or encode, the available query oracles, register conventions, normalization/error requirements, and the resource quantities you care about.

**ASPBE searches** among construction routes such as finite permutations, sparse access, LCU, products, rational Householder completions, dilation, and typed QSVT consumers.

**A result is scientific evidence only after a named Lean root closes the advertised theorem.** Qiskit/OpenQASM checks are useful implementation evidence, not substitutes for the symbolic certificate.

---

## Current mathematical surface

**State Preparation.** Complete one-qubit Pauli-$X$ and Hadamard examples already certify normalization, unitarity, state action, and circuit resources.

**Block Encoding.** Reusable finite-matrix APIs cover exact/approximate clean blocks, partial permutations, sparse-access interfaces, LCU/product composition, rational Householder routes, resource records, and typed consumer boundaries.

**Paper-facing work.** The Guseynov–Huang–Liu one-dimensional Theorem-4 composition is source-audited through $A,A^\dagger,S_1,S_2$ and $H$; the remaining frontier is the uniform arbitrary-width primitive compiler/resource theorem for the Theorem-3 source oracles.

For exact per-declaration status, use the [Implementation Map](https://dakebu.github.io/Quantum-Computing-Block-Encoding/implementation-map/) rather than prose counts in this README.

<details>
<summary><strong>Recent project milestones</strong></summary>

- **15 August 2026:** Concept / Math / Lean reading modes and the source-audited GHL Theorem-4 route were added to QuantumComputinglib.
- **12 August 2026:** complete Mathlib-backed Pauli-$X$ and Hadamard state-preparation certificates were added.
- **10 August 2026:** the project adopted the name **ASPBE** and the public library/site name **QuantumComputinglib**.
- **July 2026:** the public site gained the Verso Blueprint and searchable Lean Library Explorer.
- **17 May 2026:** the public auditable automation history begins with commit [`af59b03`](https://github.com/DakeBU/Quantum-Computing-Block-Encoding/commit/af59b03c58c2cedec52b14a80b4d909031d62521) and [`MANIFEST.md`](MANIFEST.md).

</details>

---

## Certified examples

### BE Case 1 — transfer operator

The target is the finite non-unitary transfer

$$
E_1=|0\rangle\!\langle1|_{\mathrm{time}}\otimes |0\rangle\!\langle1|_{\mathrm{type}}\otimes I_2,
\qquad
\langle0|_a U |0\rangle_a=E_1.
$$

One clean signal qubit is enough to complete the target to a permutation unitary. In the same expanded logical resource tier, Lean-certified candidates improve

$$
(6,5,1,0)\;\longrightarrow\;(4,4,1,0)\;\longrightarrow\;\mathbf{(4,2,1,0)},
$$

where the tuple records **gate count, depth, auxiliary qubits, unresolved oracle calls**.

![BE Case 1 certified candidate sequence](docs/assets/be_case1_candidates.svg)

**Lean roots:** `coldE1Candidate_blockProjection`, `proEqTransferVerified`, `evolvedEqFlipVerified`.

### BE Case 2 — cubic diagonal operator

For $N=2^n$,

$$
D_n=\operatorname{diag}_{0\le j<N}\!\left(\frac{j}{N}\right)^3,
\qquad
\Pi U_n\Pi^\dagger=D_n.
$$

The selected exact family uses **rational Householder completions**. A cold route constructs the cubic completion directly; a hinted route first recognizes

$$
O_0=\operatorname{diag}(j/N),\qquad D_n=O_0^3,
$$

and reuses the linear supplier. The direct cubic Householder root closes the target exactly with $\alpha=1$; a finite Qiskit instance is an export, not the proof of the family.

![BE Case 2 exact Householder routes](docs/assets/be_case2_candidates.svg)

**Lean root:** `CubicDiagonalOracle.cubicDiagonalHouseholderExactBEContract_complete`.

### Textbook State Preparation — $X$ and $H$

The smallest complete certificates are deliberately elementary:

$$
X|0\rangle=|1\rangle,
\qquad
H|0\rangle=\frac{|0\rangle+|1\rangle}{\sqrt2}.
$$

`pauliXVerified` and `hadamardVerified` package the normalized target, Mathlib unitarity proof, state-action theorem, circuit, schedule, and resource record. These examples are the bridge from beginner circuit notation to the reusable State Preparation API.

### GHL Robin — source-audited Theorem 4

The compiled composition follows the source-level chain

$$
A=\sum_k A_k,
\qquad
A^\dagger=\sum_k A_k^\dagger,
\qquad
H=S_1\otimes x_\xi+S_2\otimes I_\xi.
$$

![GHL Theorem 4 source-audited composition](docs/assets/ghl_theorem4_source_audit.svg)

Two facts are intentionally kept separate:

- **Closed:** finite-sum/adjoint bridge, the $S_1/S_2$ clean-block algebra, the final Hamiltonian composition, normalization/layout/resource records, and the source-phase audit.
- **Still open:** a uniform arbitrary-width primitive compiler that expands all Theorem-3 source oracles at the claimed resource tier.

The audit also records a real source-level subtlety: under a literal full-clean-matrix reading, the first printed $S_1$ LCU phase pair leaves a nonzero filler block. Lean proves that obstruction and separately proves a phase-balanced correction giving the intended $S_1$.

<details>
<summary><strong>Replay and evidence details for the public cases</strong></summary>

```bash
python3 tools/replay_public_cases.py
```

The machine-readable replay record is [`reports/public-case-replay/latest.json`](reports/public-case-replay/latest.json). It rebuilds the relevant Lean modules and reruns the applicable Qiskit/QASM exports. **Certification still comes from the named Lean roots**, not from the replay JSON or a floating-point match.

</details>

---

## From oracle contract to certificate

![ASPBE contract-to-certificate flow](docs/assets/aspbe_harness_flow.svg)

The public loop is deliberately simple:

**freeze the contract → retrieve proved components → choose a construction → reject cheap failures → close a Lean root → export the certified construction.**

The internal controller records more detail so that failed routes, population changes, proof dependencies, and resource comparisons are reproducible. Those mechanics are useful to developers, but they should not dominate the mathematical introduction.

<details>
<summary><strong>One controlled cycle</strong></summary>

1. **Freeze** the State Preparation or Block Encoding contract and its register conventions.
2. **Retrieve** compatible compiled lemmas, construction memories, and known obstructions.
3. **Select** one candidate route and one ready proof-DAG leaf.
4. **Screen** obvious dimension, unitarity, clean-block, or finite-circuit failures.
5. **Prove** the smallest named Lean obligation and run its tests.
6. **Promote or revise** the population using typed evidence; otherwise stop with an explicit obstruction.
7. **Export** only the artifacts requested by the task.

A repeated attempt against the **same leaf and same evidence digest** is not progress. The next cycle must change the proof frontier, candidate population, capacity decision, or declared tolerance rung.

</details>

<details>
<summary><strong>Candidate and evidence policy</strong></summary>

ASPBE keeps three evidence classes:

| Class | Meaning | May be presented as a theorem? |
| --- | --- | --- |
| **Lean-certified** | all advertised named Lean roots compile | **Yes** |
| **Finite executable** | Qiskit/NumPy/QASM/exact finite checks pass, symbolic root incomplete | **No — provisional evidence** |
| **Insight** | construction idea, failed route, paper suggestion, or partial argument | **No** |

Within the **same semantic and implementation tier**, certified candidates are compared lexicographically by gate count, depth, auxiliary qubits, and unresolved oracle calls. Correctness and target fidelity are gates, not weighted score terms. An opaque oracle label is never silently cost-compared with its expanded logical circuit.

For the fixed Robin benchmark, displayed `881`, `312`, and `106` counts are exact `{X, RY, RZ, CX}` primitive-list lengths; they are not identified with a simulator count that leaves multi-controlled rotations undecomposed.

</details>

<details>
<summary><strong>Adaptive capacity and tolerance</strong></summary>

The controller may increase **one named planning/proof capacity level at a time** after a recorded bottleneck.

Exact search begins at $\varepsilon=0$. Approximation opens only after the configured exact-stall condition or an explicit external boundary, and then advances through the task-declared tolerance ladder one adjacent rung at a time.

Relaxing $\varepsilon$ **cannot change** the target state/operator, normalization $\alpha$, register order, clean-state convention, or declared norm.

See [`docs/agent_orchestration.md`](docs/agent_orchestration.md) and [`docs/agent_blueprint_formalization.md`](docs/agent_blueprint_formalization.md) for the operational protocol.

</details>

<details>
<summary><strong>Optional executable outputs</strong></summary>

Lean is the symbolic acceptance gate. Executable tooling serves two narrower purposes: **early rejection of bad finite candidates** and **delivery of runnable artifacts after certification**.

A task may independently request:

- Qiskit Python;
- OpenQASM 3;
- canonical backend-neutral IR;
- resource/diagnostic JSON;
- a manifest linking the executable artifact to the matching Lean root.

Both Qiskit and OpenQASM adapters consume the same canonical IR. A floating-point backend match is never promoted as an exact symbolic-family proof.

```bash
python3 -m pip install -r requirements-executable.txt
python3 tools/replay_public_cases.py
```

Generated artifacts live under [`executable-exports/`](executable-exports/).

</details>

---

## QuantumComputinglib

[QuantumComputinglib](https://dakebu.github.io/Quantum-Computing-Block-Encoding/) is the reader-facing textbook and formal library built from this repository. The main reading path is intentionally **Concept → Math → Lean**:

- **Concept:** what the circuit/oracle construction is doing;
- **Math:** the exact state, matrix, projection, and resource equations;
- **Lean:** the declaration that certifies the claim and the reusable dependency leaves.

The site also contains the chapter map, implementation map, Example Cases, searchable declaration explorer, external Lean atlas, Verso Blueprint, and editable case workbench.

<details>
<summary><strong>Formalization workspace</strong></summary>

Build the site and start the loopback-only companion server:

```bash
python3 -m pip install -r requirements-executable.txt
bash scripts/build-all.sh
python3 website/scripts/ide_server.py --directory _site
```

Then open `http://127.0.0.1:8000/ide/`.

The static workspace always renders mathematics, reviewed LaTeX↔Lean mappings, source links, and dependency navigation. The local companion can additionally run real `lake env lean` compilation in temporary files; it never turns a merely compiling draft into a claim of mathematical equivalence without review.

An optional locally authenticated Codex adapter can propose drafts:

```bash
python3 website/scripts/ide_server.py \
  --directory _site \
  --translator-command "python3 website/scripts/codex_translator.py"
```

A separate user-owned runner can execute task packets without project-owned model credits:

```bash
python3 website/scripts/ide_server.py \
  --directory _site \
  --runner-command "python3 website/scripts/qbe_task_runner.py --execute --cycles 1"
```

Public GitHub Pages never runs untrusted Lean code.

</details>

---

## Lean library

The public modules are organized around reusable mathematical boundaries rather than benchmark-specific scripts:

```text
QuantumBlockEncoding/
├── Core.lean                    finite matrices and common contracts
├── StatePreparation.lean        exact / approximate preparation certificates
├── Circuit.lean                 gate and circuit syntax
├── CircuitSemantics.lean        circuit evaluation and register semantics
├── PrimitiveCircuit.lean        exact {X, RY, RZ, CX} syntax and resources
├── PrimitiveSemantics.lean      primitive matrices and products
├── ConcreteSemantics.lean       ket / column / clean-projection bridges
├── TextbookStatePreparation.lean
├── BlockEncoding.lean           operator targets and verified block encodings
├── BlockEncodingClassics.lean   permutation, sparse, LCU, product, dilation, QSVT APIs
├── Resources.lean               deterministic resource records
├── TechnicalLemmas.lean         reusable proof leaves
├── MainCase.lean                BE Case 1
├── CubicStatePreparation.lean   cubic diagonal routes
├── GHLHamiltonian.lean          source-audited Hamiltonian composition
├── Automation.lean              typed controller contracts
└── OpenProblems.lean            explicit unfinished routes
```

The [Lean Library Explorer](https://dakebu.github.io/Quantum-Computing-Block-Encoding/library/) is the authoritative searchable declaration surface.

<details>
<summary><strong>Build and verify locally</strong></summary>

Linux/macOS:

```bash
python3 -m pip install -r requirements-executable.txt
python3 tools/qbe.py check
bash scripts/build-all.sh
```

Windows PowerShell:

```powershell
python -m pip install -r requirements-executable.txt
python tools/qbe.py check
powershell -ExecutionPolicy Bypass -File scripts/build-all.ps1
```

The complete build runs the Lean gate, tests, proof-trust checks, declaration inventory, public-case replay, Blueprint consistency checks, website build, link/source checks, and local-path leakage scans.

</details>

<details>
<summary><strong>Contribute</strong></summary>

Two supported routes are available:

1. use the [Live Formalization Workspace](https://dakebu.github.io/Quantum-Computing-Block-Encoding/ide/) to prepare a versioned lemma packet; or
2. submit a focused pull request following [`CONTRIBUTING.md`](CONTRIBUTING.md).

A contribution becomes public positive retrieval memory only after maintainer review and the full repository gate. Case packets use the review states `draft`, `pendingReview`, `verified`, and `rejected`.

```bash
python3 tools/qbe.py ingest-case path/to/case.json --review-only
python3 tools/qbe.py promote-case case-id --lean-root Namespace.declaration
```

The promotion command rejects unpublished review states, missing consent, unknown Lean roots, failed full gates, or missing advertised executable evidence.

</details>

<details>
<summary><strong>Related systems and design lineage</strong></summary>

ASPBE borrows engineering ideas from adjacent systems while keeping its acceptance contracts specific to this repository: durable file-backed state (ARIS), typed layered feedback, population evolution (EoH), proof-DAG decomposition (LeanMarathon), natural-language/formal pairing (Rethlas/Archon), quantum theorem-proving evaluation (QBench), and readable Blueprint-style formal documentation.

External quantum Lean projects such as [quantum-computing-lean](https://github.com/duckki/quantum-computing-lean), [Lean-QuantumInfo](https://github.com/Timeroot/Lean-QuantumInfo), and [lean-quantum](https://github.com/Hayata-Yamasaki-Group/lean-quantum) are recorded in the reference atlas. A linked external theorem is not presented as a local proof unless an explicit compiled adapter imports or re-establishes the required boundary.

See [`docs/attribution.md`](docs/attribution.md) and [`NOTICE.md`](NOTICE.md).

</details>

---

## Citation

```bibtex
@misc{aspbe2026,
  author = {Bu, Dake and Huang, Xiajie and Liu, Nana and Nitanda, Atsushi and Wong, Hau-san and Zhang, Qingfu},
  title = {{ASPBE: Automatic State Preparation and Block Encoding for Quantum Computing}},
  year = {2026},
  note = {QuantumComputinglib and project source: \url{https://github.com/DakeBU/Quantum-Computing-Block-Encoding}}
}
```

## License

[MIT](LICENSE). External libraries and cited results retain their own licenses and attribution.

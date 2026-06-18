# Auto-Lean-in-Sleep: Block Encoding for Quantum Computing

ABEIS is a Lean 4 project and multi-agent harness for turning a requested
quantum query operator into concrete block-encoding candidates, gate-level
circuit matrices, resource scores, and Lean-checked certificates.

The project is built around one contract:

```text
operator/query-oracle contract A
-> candidate unitary U_A and circuit schedule
-> Lean-checked block-entry and unitarity certificate
-> resource-ranked construction
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

![QBE automation pipeline](docs/assets/qbe_pipeline.svg)

## Core Workflow

```mermaid
flowchart LR
  A["user gives A, alpha, projector"] --> B["upper fixes target"]
  A --> A2["user gives resource floor, epsilon, iteration limits"]
  B --> C["middle keeps Lean <-> natural-language map"]
  C --> D["lower population proposes exact U_A"]
  D --> E["finite/unitarity/block-entry diagnostics"]
  E --> F["Lean exact certificate attempt"]
  F --> G{"meets resource floor before limit?"}
  G -- yes --> H["Scenario 1: approximate-improvement phase"]
  G -- no/stalled --> I["Scenario 2: relaxed approximate search"]
  H --> J["Lean approximate certificate attempt"]
  I --> J
  J --> K["resource score and candidate archive"]
  K --> L["dynamic agent-count audit"]
```

ABEIS uses diagnostics as search signals, not as proofs.  A candidate enters
the certified population only after Lean proves the advertised theorem at the
task's semantic tier.

![Adaptive exact-to-approximate block-encoding loop](docs/assets/adaptive_be_policy.png)

If exact search fails to meet the user-specified resource floor within the
configured budget, the upper layer may switch to approximate BE search.  If a
fixed number of generations does not improve the population, the upper layer
may increase upper/middle/lower parallel agent counts up to the configured
maximum.  More agents are not assumed to be better; the increase is itself a
controlled experiment.

## Main Case Study

The current technical-report case study is the operator task
`QBE-OP-OPTCTRL-001`:

```text
E_k = |0><k|_time ⊗ |0><1|_type ⊗ I
```

The run demonstrates the intended loop:

1. fix the operator target;
2. start from a correct one-ancilla block-encoding seed;
3. maintain a population of candidate completions;
4. keep Pro/simulator/Python ideas in the insight pool until Lean promotes
   them;
5. after exact convergence, enter the approximate phase with the exact
   champion as an `epsilon = 0` incumbent;
6. plot only Lean-certified candidates.

Current certified logical champion:

```text
evolved-eq-flip-r1-k1
Lean certificate = OptimalControl.evolvedEqFlipVerified
zero-error approximate certificate = OptimalControl.evolvedEqFlipZeroErrorApprox
comparison tuple = (gateCount, depth, auxiliaryQubits, oracleCalls) = (4, 2, 1, 0)
```

Certified metric curve, in the EoH-style sense that each plotted point is a
generation champion and lower values are better.  Blue is exact search; green
is the post-convergence approximate phase:

![Certified evolution for E_k](docs/assets/optctrl_evolution.png)

Lean-certified snapshots:

| Generation | Circuit | Lean certificate | Tuple |
| --- | --- | --- | --- |
| 0 | <img src="docs/assets/optctrl_oracle_baseline.png" alt="Oracle-level seed" width="220"> | `OptimalControl.exampleVerified` | `(1, 1, 1, 1)` |
| 2 | <img src="docs/assets/optctrl_depth5.png" alt="Depth-5 logical completion" width="220"> | `OptimalControl.reducedDepth5Verified` | `(6, 5, 1, 0)` |
| 6 | <img src="docs/assets/optctrl_pro.png" alt="Equality-transfer candidate" width="220"> | `OptimalControl.proEqTransferVerified` | `(4, 4, 1, 0)` |
| 7 | <img src="docs/assets/optctrl_evolved.png" alt="Evolved champion" width="220"> | `OptimalControl.evolvedEqFlipVerified` | `(4, 2, 1, 0)` |
| 8-9 | same exact champion reused as approximate incumbent | `OptimalControl.evolvedEqFlipZeroErrorApprox` | `(4, 2, 1, 0)`, `epsilon = 0` |

This is a concrete `r = 1, k = 1` logical reversible permutation-matrix
certificate.  It is not claimed as a hardware-decomposed theorem, a general
arbitrary-register theorem, or a Lean-proved global optimality theorem.

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

## Web Task Builder

ABEIS includes a static web task builder in `web/`.  It lets a user paste a
LaTeX oracle, matrix, or natural-language operator description, choose their
report language, record a baseline construction, and generate a Markdown task
packet for the agent loop.

The page does not run agents and does not certify proofs.  Lean remains the
verification authority.

For a public repository, GitHub Pages can publish `web/` through
`.github/workflows/pages.yml`.  The deployed project page normally has this
shape:

```text
https://<github-user>.github.io/<repo-name>/
```

Report language is also available from the CLI:

```bash
export QBE_REPORT_LANGUAGE=ja
python3 tools/qbe.py sleep-run QBE-OP-OPTCTRL-001 --report-language ja ...
python3 tools/qbe.py cycle-summary QBE-OP-OPTCTRL-001 --run-id latest --language ja
```

## Repository Map

Lean source:

- `QuantumBlockEncoding/Core.lean`: finite-index and grid helpers.
- `QuantumBlockEncoding/Circuit.lean`: circuit and gate-level interfaces.
- `QuantumBlockEncoding/BlockEncoding.lean`: operator targets, candidates,
  verified certificates, and `BlockEncodingCost`.
- `QuantumBlockEncoding/Resources.lean`: gate count, depth, auxiliary qubits,
  oracle calls, and schedule bookkeeping.
- `QuantumBlockEncoding/GHL2025.lean`: first paper-benchmark case.
- `QuantumBlockEncoding/Automation.lean`: compiled automation contracts.

Agent and proof artifacts:

- `tools/qbe.py`: project CLI.
- `tasks/`: task contracts.
- `conversion-windows/`: Lean and natural-language proof maps.
- `candidate-populations/`: certified and rejected candidate records.
- `proof-obligations/`: explicit proof and oracle gaps.
- `proof-blueprints/`: compact system-of-record snapshots.
- `runs/`: prompt decks, dialogue boards, trial logs, summaries, and Pro
  prompts.
- `paper-notes/problem-exports/`: closeout LaTeX proof notes for users.
- `research-wiki/`: persistent cited-result, lemma, and retrieval memory.

Public project artifacts cite original GitHub repositories, arXiv URLs,
theorem/equation anchors, or bundled paper notes.  They should not depend on
machine-specific local paths.

## Agent Harness

ABEIS uses a layered multi-agent harness:

| Layer | Responsibility |
| --- | --- |
| Upper | Fix the operator target, choose strategy, audit source/candidate drift. |
| Middle | Maintain Lean/natural-language correspondence, retrieval memory, and closeout reports. |
| Lower 1 | Natural-language construction/proof architect. |
| Lower 2 | Lean implementation worker for one ready proof leaf. |
| Lower 3 | Necessary-condition verifier for exact finite checks. |
| Reviewer | Reject hidden assumptions, wrong resources, stale routes, and unsupported promotions. |

The harness is vendor-neutral.  A profile under `agent-profiles/` can dispatch
different roles to Codex, Claude, GPT/OpenAI wrappers, Gemini, GLM, Minimax,
or local tools:

```bash
python3 tools/qbe.py sleep-run QBE-OP-001 \
  --cycles 6 \
  --lower-count 3 \
  --parallel-lower \
  --agent-profile mixed-vendors.example.json \
  --execute \
  --check-each-cycle
```

The profile changes search diversity and cost.  It does not change what counts
as success: only Lean-certified declarations and the build gate certify a
candidate.

### Memory And Feedback Loop

```mermaid
flowchart TD
  A["operator or paper source"] --> B["upper planning"]
  B --> C["middle memory + correspondence"]
  C --> D["lower architect / Lean worker / verifier"]
  D --> E["Lean gate + typed feedback"]
  E --> F["trial logs"]
  F --> G["retrieval index + todos"]
  G --> H["preferred-language summary"]
  G --> I["ChatGPT Pro prompt"]
  G --> J["LaTeX proof export"]
  H --> B
  I --> B
```

Long runs write a human-facing summary in the requested language, a
self-contained ChatGPT Pro prompt when unresolved leaves remain, and a
problem-specific LaTeX note for users to copy into their own manuscripts.
Updates to the ABEIS authors' technical report are maintainer-only and are not
part of the default user workflow.

## Strategy Modes

| Mode | Use when | Main rule |
| --- | --- | --- |
| `operatorBlockEncoding` | The user gives `A`, `alpha`, and a projector. | Search candidate `U_A`, prove unitarity and block entry, rank by cost. |
| `paperBenchmark` | A paper already gives a construction. | Reproduce the paper baseline without mutating the construction. |
| `exploratoryConstruction` | A baseline exists or the paper assumes an oracle. | Improve the same fixed target using candidate populations and Lean gates. |

Create an operator task:

```bash
python3 tools/qbe.py new-task QBE-OP-001 \
  --kind operatorBlockEncoding \
  --mode operatorBlockEncoding \
  --title "Construct a block encoding for my query operator" \
  --source "operator supplied by user / arXiv:XXXX.XXXXX" \
  --target-lean "QuantumBlockEncoding/MyOperator.lean"
```

The task file should also record:

```text
maxExactIterations, exactStallIterations, requiredCost,
requestedEpsilon, allowRelaxedEpsilon,
maxUpperAgents, maxMiddleAgents, maxLowerAgents
```

Run a small search batch:

```bash
python3 tools/qbe.py update-task QBE-OP-001 --status active --active
python3 tools/qbe.py sleep-run QBE-OP-001 \
  --cycles 2 \
  --lower-count 3 \
  --parallel-lower \
  --agent-profile mixed-vendors.example.json \
  --execute \
  --check-each-cycle
```

For longer unattended runs and theorem-closure batches, see
[`docs/sleep_run_guide.md`](docs/sleep_run_guide.md).

## Human Outputs

Use the curated public artifacts first:

- [`tasks/QBE-OP-OPTCTRL-001.md`](tasks/QBE-OP-OPTCTRL-001.md): the main
  operator task.
- [`candidate-populations/QBE-OP-OPTCTRL-001.md`](candidate-populations/QBE-OP-OPTCTRL-001.md):
  Lean-checked candidate population and final choice.
- [`candidate-populations/QBE-OP-OPTCTRL-001-metrics.png`](candidate-populations/QBE-OP-OPTCTRL-001-metrics.png):
  convergence plot for the main case.
- `paper-notes/problem-exports/<task-id>/latest.tex`: problem-specific LaTeX
  proof note.

Local runs also generate maintainer-only summaries such as
`HUMAN_STATUS.md`, `REPORTS.<lang>.md`, `runs/<run-id>/summary.<lang>.md`,
and `runs/<run-id>/chatgpt_pro_prompt.md`. These files are intentionally
ignored by git so public releases do not accumulate raw agent traces.

## Related Work And Similar Patterns

ABEIS adapts patterns from adjacent systems, but specializes them to
gate-level quantum block-encoding certificates.

| Work | Similar pattern | ABEIS use |
| --- | --- | --- |
| [ARIS][aris] | Plain-file autonomous research workflow and review. | Task files, skills, manifests, reviews, run logs. |
| [Learning Beyond Gradients][lbg] | Layered feedback and trial memory. | Upper/middle/lower/reviewer loops and compact summaries. |
| [EoH][eoh] | Evolutionary candidate populations. | Mutate/recombine candidate block-encoding circuits under a fixed target. |
| [LeanMarathon][leanmarathon] | Proof blueprint, dynamic leaves, CI gates. | Proof-blueprint snapshots and focused theorem-closure work. |
| [MathCode][mathcode] | Proof diagnostics and theorem reuse. | Hidden-assumption scans and reusable proof-attempt memory. |
| [Lean4Agent][lean4agent-paper] | Workflow/trajectory verification. | Lean-side process contracts in `Automation.lean`. |
| [Lean-QuantumInfo][lean-quantuminfo], [lean-quantum][lean-quantum] | Quantum formalization references. | Style and semantic references for finite-dimensional quantum objects. |
| [QASM-Eval][qasm-eval], [Qiskit QuantumKatas][qiskit-quantumkatas] | Typed circuit/test feedback. | Necessary-condition diagnostics before Lean proof closure. |
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

## Citation

```bibtex
@misc{abeis2026,
  author = {{Anonymous ABEIS Contributors}},
  title = {{Auto-Lean-in-Sleep: Block Encoding for Quantum Computing}},
  year = {2026},
  note = {Project page: \url{https://github.com/DakeBU/Quantum-Computing-Block-Encoding}}
}
```

[aris]: https://github.com/wanshuiyin/Auto-claude-code-research-in-sleep
[lbg]: https://github.com/Trinkle23897/learning-beyond-gradients
[eoh]: https://github.com/FeiLiu36/EoH
[leanmarathon]: https://github.com/YuanheZ/LeanMarathon
[mathcode]: https://github.com/math-ai-org/mathcode
[llm4ad-next]: https://github.com/Optima-CityU/LLM4AD_Next
[lexelim-bandits]: https://xueb1996.github.io/pdf/AAAI-2026-Xue.pdf
[lean4agent-paper]: https://arxiv.org/abs/2606.06523
[quasar-paper]: https://arxiv.org/abs/2510.00967
[qasm-eval]: https://github.com/fuzhenxiao/QASM-Eval
[qiskit-quantumkatas]: https://github.com/qiskit-community/Qiskit-QuantumKatas
[ai-mandel-paper]: https://arxiv.org/abs/2511.11752
[hierarchical-provers]: https://arxiv.org/abs/2602.10512
[statistical-provability]: https://arxiv.org/abs/2602.10538
[lean-quantuminfo]: https://github.com/Timeroot/Lean-QuantumInfo
[lean-quantum]: https://github.com/Hayata-Yamasaki-Group/lean-quantum

# Evidence-Routed Memory and Cost-Aware Scheduling Protocol

This protocol complements `HARNESS.md` and
`docs/proof-digestion-protocol.md`. It adapts the useful cross-round learning
mechanisms of arXiv:2609.40324 while preserving the strongest lesson from
ASPBE's own route-ablation data:

> **More coordination is not automatically more progress. The control plane
> should be deterministic or low-token by default; expensive model calls are
> reserved for genuine mathematical uncertainty.**

## 1. Typed failure before scheduling

Every failed/rejected route is classified as exactly one of:

- `REFUTED`: a quantum/mathematical claim is ruled out by a checked
  counterexample or rigorous reviewed proof;
- `SOURCE_INVALID`: the pinned paper theorem/circuit/resource contract is
  false, ambiguous, or needs a separately reviewed repair;
- `API_BLOCKED`: the mathematics may be correct but the current Lean/quantum
  library interface blocks the route;
- `ENV_BLOCKED`: dependency, package, filesystem, CI, toolchain, simulator, or
  runtime environment blocked execution;
- `IMPLEMENTATION_FAILED`: this implementation/proof attempt failed without
  evidence that the mathematical contract is false;
- `NONE`: no failure.

Only `REFUTED` or independently reviewed `SOURCE_INVALID` evidence can retire
a mathematical route. Simulator/package/path failures are never theorem
counterexamples.

## 2. Salvage before branch cleanup

Before a blocked construction or rejected proof is discarded, audit it for
independently useful fragments:

- gate/subcircuit semantics;
- tensor/register identities;
- state/isometry preparation interfaces;
- PREPARE/SELECT/unprepare lemmas;
- resource-counting facts;
- minimal counterexamples exposing a convention error.

A candidate fragment becomes reusable only after isolation, assumption/import
minimization, independent Lean compilation, source/semantic review when
applicable, and canonical-node/reuse audit. A failed whole circuit does not
invalidate every verified component; conversely, text from a failed route is
not proof memory.

This salvage gate runs before PURIFICATION deletes dead code.

## 3. Durable process and negative memory

Public curated memory lives in `reports/process-memory.json` and is validated
by `tools/check_process_memory.py`.

Raw generated run logs remain local/untracked by design. A durable memory item
must cite tracked evidence such as route-ablation, verifier-comparison, source
audit, or checked publication records.

Standing instructions are **process-only**. They may choose a verifier layer or
scheduling mode; they may not invent a quantum lemma or declare an unverified
construction correct.

## 4. Control plane has no mathematical authority

The Master/router may map evidence to the next process:

| Failure | Default next process |
| --- | --- |
| `REFUTED` | retire same sealed route; salvage fragments; choose distinct construction |
| `SOURCE_INVALID` | source/circuit contract audit and repair |
| `API_BLOCKED` | local/Mathlib/external quantum API retrieval or narrow adapter |
| `ENV_BLOCKED` | deterministic dependency/environment repair |
| `IMPLEMENTATION_FAILED` | change implementation fingerprint or run a discriminator |
| `NONE` | ordinary frontier scheduling |

The router may not decide that LCU, QSP, tensor-network, amplitude-amplification,
or another construction is mathematically valid without Worker/source evidence.

## 5. Cost-aware parallelism admission

ASPBE's tracked route-total ablation on QBE-OP-OPTCTRL-001 found the direct Lean
route substantially cheaper than the then-current multi-agent route, while both
reached reusable Lean-level evidence. Therefore:

- scheduler/frontier refresh, summarization, memory lookup, and routine
  coordination default to deterministic code or a low-token profile;
- expensive parallel Workers are admitted only for **independent uncertainty**;
- every fork has a distinct `direction_fingerprint`, explicit
  `expected_information_gain`, and bounded context;
- all forks share the same frozen quantum contract and verified-memory digest;
- route-specific failed history is selective, not broadcast wholesale;
- two Workers may not attack the same unclassified leaf with duplicated context
  merely to increase sample count.

Good parallel forks include competing circuit families, source audit versus
symbolic proof, finite falsification versus parametric Lean construction, or
disjoint theorem leaves.

A new claim that multi-agent scheduling is superior requires a controlled
matched ablation with comparable target, model/budget, semantic level, and
route-total accounting. External success stories do not override local data.

## 6. Cross-route common-blind-spot review

If two or more serious constructions/proofs survive to verification for the
same Source Anchor, a separate side-by-side reviewer searches for shared errors:

- identical register-order or basis mismatch;
- hidden clean-ancilla or garbage-cleanup assumption;
- stronger coherent-oracle access than the source provides;
- common relative-phase error;
- shared switch from query complexity to gate/finite-bit complexity;
- a source figure/convention misread inherited by every route.

Parallel multi-route source claims require this review before Proof Seal.

## 7. Verifier-layer discipline

Executable feedback is typed by semantic strength:

- parser/syntax/timeline/distribution checks;
- finite matrix/operator/block-entry checks;
- symbolic Lean concrete theorem;
- symbolic Lean parametric theorem/resource theorem.

A faster lower-semantic verifier never substitutes for a stronger acceptance
layer. In particular, the recorded Qiskit import failure is environment
evidence, and QASM-style distribution/timeline checks are not block-encoding
proofs.

Dense simulation remains useful for small fixed instances and counterexamples;
tracked scaling evidence shows why it is not the large-register verification
strategy.

## 8. Reader backpressure and Exposition Seal

Track:

- merged Source Anchors not yet PURIFIED;
- time from merge to purification;
- fine source/Lean nodes per reviewed conceptual construction move.

When proof production outruns explanation, reserve capacity for purification and
reader synthesis instead of opening only new construction targets.

A PURIFIED quantum result additionally requires an **Exposition Seal**. The
compressed explanation must reconstruct:

- register/basis/order conventions;
- relative/global phase boundary;
- ancilla/workspace cleanup;
- success/error and resource tier;
- source and Lean expansion nodes;
- the remaining unproved boundary.

The reviewer should not need the agent transcript to understand the proof.

## 9. Handoff fields

Every substantive Worker handoff records:

- failure class;
- salvage candidates/results;
- process-memory IDs consulted;
- direction fingerprint and expected information gain;
- whether parallel work was admitted and why;
- common-blind-spot review status when multiple routes survive;
- purification / Exposition-Seal state for reader-facing integration.

These fields are scheduling evidence, not new theorem premises.

## Design provenance

This protocol is informed by arXiv:2609.40324's cross-round attempt memory,
verified-fragment reuse, process learning, multi-proof comparison, and final
writeup verification. ASPBE deliberately keeps a different execution policy:
its own ablations make coordination cost visible, Lean remains the symbolic
acceptance gate, and the objective is verified reusable quantum structure plus
human-readable proof digestion rather than maximum agent throughput.

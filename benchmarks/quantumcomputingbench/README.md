# QuantumComputingBench

Reproducible graph-grounded quantum QA over QuantumComputinglib's implemented Lean
inventory and its explicitly planned curriculum.

**Status: local working release, not completion of the full benchmark goal.**
Read [AGENT_GOAL.md](AGENT_GOAL.md) for the adopted objective and acceptance criteria,
[DATASET_CARD.md](DATASET_CARD.md) for evidence/privacy/licensing limits, and the
[latest coverage report](reports/release-v2/coverage.md) for actual released scope.
No real model baseline has been measured. No new Lean task is certified here.

## 当前完成情况与完整验收结论（release-v2）

**尚未完全满足 `AGENT_GOAL.md` 的全部要求。当前交付是经过测试的阶段版本，
不是完整验收通过，也不能将其描述为全图基准已经建成。**

### 已经完成

- 完整读取目标文件，并将目标、里程碑和剩余工作保存到可恢复 manifest。
- 实现快照、题目生成／入库、校验、分组拆分、评分和覆盖报告流水线。
- 从试点扩展到多个数学领域，发布 **30 道经过数学内容复核的题目**；
  复核包括独立上下文 AI 复核，不代表人工审查或 Lean 证明认证。
- 为 **5,153 个节点**建立明确状态台账，区分规划材料、源码证据与未解决问题。
- **56 项基准测试、98 项仓库 harness 测试通过**；原有证明和历史报告未改动。
- 遵循后续“不直接 push”的要求，没有推送远程仓库。

### 尚未满足的两个核心条件

1. **Lean 能力任务尚未完成真实隔离验证。** 当前有冻结目标、验证器接口和候选题，
   但没有实际通过完整证明重放及传递公理审计；工程测试通过不能替代形式验证。
   因此 **Lean 认证题数仍为 0**。严格按目标文件，包含已验证 Lean 任务的完整
   跨类别端到端试点也尚未全部验收通过。
2. **全图数学 QA 覆盖仍明显不足。** 每个节点有状态，不等于每个支持的数学区域
   都有充分、有意义、已验证的 QA。当前仍有 **4,689 个节点缺少题目或证据**；
   不能用“台账完整”冒充“全图覆盖完成”。其余未发布候选也不能计入已发布覆盖。

真实模型 baseline 尚未测量。目标文件允许在没有可用的授权端点和预算时提供
运行器并明确保留为未测，因此这与上述两个硬性验收缺口不同；不能为补齐表格
而编造模型分数。

### 准确结论与下一步

**已有可复现的实质成果，不只是脚手架；但完整要求尚未完成。**
对已交付、已测试的部分有记录支持，不能对尚未达到的完整验收作出保证。
下一阶段应先在受控环境完成真实 Lean 隔离重放、公理审计和仓库 Lean 门禁，
再按 [后续批次清单](manifests/release-v2/next-batches.json) 持续补题、检查完整前提
并独立复核，直到全图支持区域达到有意义的覆盖。完成前应保持 `complete=false`。
以上数量对应冻结的 `release-v2`，后续版本须以各自覆盖和验证报告更新状态。

## What is implemented

- Deterministic snapshot using the supported `build_lean_graph_payload` exporter,
  exact declaration/module IDs and dependency-to-importer edge direction.
- Full node-disposition ledger: released support, candidate, explicit exclusion,
  or missing mathematical evidence. All four textbook parts, shared foundations,
  source records, conditional AND transports and external adapter plans retained.
- Original knowledge, natural-language mathematical proofs/compositions, negative
  examples, register/phase/resource questions, planned-source questions and frozen
  Lean capability candidates. Expansion batches go beyond State Preparation.
- Schema/source/target/review binding validation; deterministic solution-family
  union splits; prompts exported without reference answers, rubrics or proofs.
- Exact grading and hash-bound evaluator rubrics; uncertain NL ratings remain
  pending. Formal tasks fail closed pending isolated proof/axiom replay.
- Bounded offline-first model-adapter runner with call/token/time/cost reservation,
  actual usage requirements and crash-safe resume. Fixtures never count as baselines.
- Versioned candidate/review/release artifacts, resumable inventory batches,
  coverage and next-authoring queues. Old versions and rejected authoring retained.

This does **not** mean every declaration has a useful released question. The
coverage report explicitly exposes the remaining graph and evidence gaps.

## Reproduce locally

Python 3.11+; install the pinned validator dependency when needed:

```bash
python -m pip install -r benchmarks/quantumcomputingbench/requirements.txt
python -m unittest discover -s benchmarks/quantumcomputingbench/tests -v
```

Run from the project root. For a new version label, freeze sources, generate
candidates, then admit real review artifacts. Re-running with the same inputs is
idempotent; source/adapter changes require a new snapshot/version.

```bash
Q=benchmarks/quantumcomputingbench/scripts/qcb.py
python "$Q" snapshot --version release-v2
python "$Q" generate --version release-v2 --dry-run
python "$Q" generate --version release-v2
python "$Q" review --version release-v2 --reviews benchmarks/quantumcomputingbench/reports/reviews/pilot-review.json
python "$Q" review --version release-v2 --reviews benchmarks/quantumcomputingbench/reports/reviews/expansion-review.json
python "$Q" review --version release-v2 --reviews benchmarks/quantumcomputingbench/reports/reviews/planned-admitted-review.json
python "$Q" review --version release-v2 --reviews benchmarks/quantumcomputingbench/reports/reviews/breadth-review.json
python "$Q" validate --version release-v2
python "$Q" export --version release-v2
python "$Q" coverage --version release-v2
python benchmarks/quantumcomputingbench/scripts/report.py --version release-v2
```

`generate --batches pilot.json planned.json` supports an explicit bounded authoring
subset. `supersedes` links select corrected successors while preserving rejected
originals and their historical review. Candidates are never coverage by default.
`release.json` and prompt/release manifests are frozen; `items.json` is the mutable
admission ledger. `candidates.json` is the original frozen candidate set.

## Resume the entire inventory

```bash
python "$Q" batch --version release-v2 --batch-size 128
```

Call repeatedly until the inventory is processed. The local manifest records
objective/goal hash, source snapshot, processed nodes, batch fingerprints and the
next node. **Inventory processing is triage, not mathematical validation.**
[Next batches](manifests/release-v2/next-batches.json) list actual remaining
mathematical authoring/evidence work; each requires source inspection and review.
Do not fill the ledger with trivial name-recall or unreviewed generated dumps.

## Score predictions

Predictions: JSON array `[{"id":"qcb-…","answer":"…"}]`. Write evaluator logs
outside the public repository; no private gold belongs in this tree.

```bash
python "$Q" score --version release-v2 --predictions predictions.json
python "$Q" score --version release-v2 --predictions predictions.json --ratings evaluator-ratings.json
```

NL ratings require `kind=human_rubric`, real reviewer identity, `item_hash`,
`prediction_hash`, all criterion marks in [0,1] and separately stated
`semantic_fidelity=faithful|unfaithful|uncertain`. Ratings are operator/evaluator
input, not inferred by substring or word-count. Uncertain stays ungraded. The
[scoring smoke report](reports/release-v2/scoring-smoke.json) is explicitly
fixture-only, not human evaluation or model performance.

## Lean capability and isolation boundary

```bash
python "$Q" verify-lean --version release-v2 --item ITEM_ID --proof candidate.lean --image IMAGE@sha256:DIGEST
```

The verifier accepts a deliberately restricted lemma-application proof grammar,
freezes imports/target, generates an independent theorem/axiom harness, and
requires a network-disabled, non-root, read-only, resource-limited pinned image.
Candidate items cannot widen the foundational axiom policy or resource caps.
A successful tactic/exit code alone is never a certificate; `sorryAx` and unknown
transitive axioms reject. Failures are not mathematical refutations.

**Blocked here:** Lean/Lake/container runtime and a tested pinned verifier image
are unavailable; harness integration has not run. Certification is disabled in
code, including environment-variable bypasses. This implementation supports
future replay but is not yet a fully validated formal-evaluation release.
Required future gate: actual isolated replay/axiom inspection plus
`lake build && lake build Tests`. Production Lean and historical evidence remain
unchanged. No generated Lean is executed unsandboxed.

## Model baseline adapter

Configure a trusted operator-owned executable adapter using
[baseline.example.json](configs/baseline.example.json). Its stdin receives only a
closed-book prompt and enforced request limits; stdout must supply model,
checkpoint, complete answer, stop reason and actual token/cost usage. No shell
string, credentials or gold are passed to it. Without explicit `--authorized`,
the command is dry-run (zero model calls). No paid calls were made here.

```bash
python "$Q" baseline --version release-v2 --config approved-config.json --output EVALUATOR_DIRECTORY
```

The runner currently supports closed-book only. Open-library prompt export is not
a sandboxed tool harness. Approved-interface retrieval is limited to explicitly
bound name/type statements; arbitrary files/proofs are disallowed.

## Evidence and contamination

`source_inspected` is literal local source inspection, not current-run Lean
compilation or source-faithfulness to an external paper. `planned_source_inspected`
requires actual pinned primary text and remains non-Lean. Review artifact hashes,
authoring hashes, exact context hashes and typed issues are separate fields.
Distinct-context AI review is not called human review. Historical legacy debt is
never cleared by benchmark ingestion.

`support_count`, reviewed semantic inference steps and structural graph distance
are separate. Structural distance remains unknown; module imports are not
elaborated theorem dependencies. Hyperedges retain all AND premises and failure
maps. No claimed free universal PRM, theorem-level depth, or physical certificate.

Released `test_public` questions **and answers are public**. They are not secret,
blind, contamination-free or known unexposed to pretraining. Shared foundational
support may cross splits; target-solution families stay grouped. MIT covers this
original authoring/code, not external textbooks. Primary PDFs and long source
proofs are not redistributed. See the dataset card for source/license boundaries.

## Local handoff and preservation

The user-provided copy is a source archive with no `.git`; its source commit is
unknown and source input hashes are recorded instead. Per user instruction no
remote push is attempted and no Git repository is initialized in the archive.
Review the accompanying change report/patch before importing into a real checkout.
Only benchmark files are changed; original proofs, source audits and historical
reports are protected by a before/after file-hash comparison.

Canonical repository:
https://github.com/DakeBU/QuantumComputinglib-QuantumComputingBench

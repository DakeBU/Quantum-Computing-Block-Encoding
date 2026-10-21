# Coverage: release-v1

Snapshot: `qcb-snapshot-fb5abbac40331cbc6b85e84d`.
Universe: **5153 nodes**, 4524 public declarations, 143 exporter module nodes.
Curated items: **41**; released after distinct-context review: **30**; remaining candidates: **11**.
**Goal not complete. Lean-certified items: 0. Real model baseline: unmeasured.**

| Node disposition | Count |
|---|---:|
| blocked_by_missing_evidence | 4689 |
| candidate_pending_review | 16 |
| covered_by_released_qa | 107 |
| deliberately_excluded | 341 |

All nodes have a disposition; this is **accounting completeness**, not mathematical QA coverage.
Released support membership does not resolve legacy semantic/source-faithfulness debt.
The exporter includes the umbrella module in addition to recursively discovered Lean source modules.

## Released tracks

| Track | Items |
|---|---:|
| knowledge | 5 |
| planned | 4 |
| quantum_semantics | 7 |
| reasoning | 14 |

## Reasoning measures

`support_count`: distinct target/support nodes; `semantic_step_count`: authored, reviewed inference steps.
Structural graph distance remains unknown (`null`); imports/ownership are not theorem proof dependencies.
Buckets are not padded and do not independently establish difficulty.

| Measure | Bucket | Released items |
|---|---|---:|
| support_bucket | 1 | 1 |
| support_bucket | 2 | 6 |
| support_bucket | 3-4 | 13 |
| support_bucket | 5-8 | 9 |
| support_bucket | 9+ | 1 |
| reviewed_semantic_step_bucket | 1 | 1 |
| reviewed_semantic_step_bucket | 2 | 8 |
| reviewed_semantic_step_bucket | 3-4 | 19 |
| reviewed_semantic_step_bucket | 5-8 | 2 |

## Uncovered areas and next action

124 exporter modules still have no released source-linked question.
See module-coverage.json for every module and next-batches.json for bounded, resumable authoring queues.
Priority: Block Encoding composition and LCU/SELECT, stored-cost refinements, Hermite/cubic/banded/Robin/GHL routes, then remaining paper families.
Planned Quantum Information and Scientific Computing require pinned primary-source review; external adapter candidates are never local Lean certificates.
Rejected items stay in authored files with review reasons; corrected successors retain `supersedes` lineage.

## Reproduction and privacy

Run the documented snapshot, generate, review, validate, export, coverage and report commands.
All released test questions/answers are public; no secrecy/contamination-free claim.
Private gold/raw generations/evaluation logs are not in the tracked public tree.
scoring-smoke.json is fixture-only and does not report model performance.

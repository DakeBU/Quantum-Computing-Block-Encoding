# QuantumComputingBench v0.1.0-preview.1

This preview consolidates the corrected `loty` benchmark pipeline and the
maintainer-supplied native-NL delivery. It is not a completed whole-graph benchmark
or a newly trained/certified mathematical teacher.

## Preserved contributions

- Main baseline: `51e6bbba3d4783fadfcda3566fb174299a9d118c`.
- Loty baseline: `05ebd4225d015bb84338e05cc9dfb870404e8e6d`.
- Lossless integration/import commit: `dae799f286f8026ec93d55279af220f7c25693ed`.
- Native delivery: `nl-v12`, 238 active records, 217 inherited admissions and 21
  provisional records. The current integration overlay excludes four additional
  problematic records, leaving 213 retained core IDs and 25 non-gold records.
  Nine inherited same-core repairs add no new cores.
- Legacy `release-v3`: 26 inherited-review diagnostics and 12 provisional
  repairs/diagnostics, with eight other unreleased historical candidates.

Imported reviews are retained with their actual claimed AI provenance and exact
content bindings. Passing software checks is not a fresh independent mathematical
review of all 217 answers or proof of reviewer independence in the world.

## Distribution, not fabricated shared-core approval

The maintainer requested consolidation and publication. This authorizes a
co-release, not inventing acknowledgment by the external Lean collaborator.
Existing core-registry proposals and their pending status remain unchanged.
Native training/dev/public-test data and legacy diagnostics remain separate
cohorts. There is deliberately no aggregate distinct-core count, pooled training
set, or claim that cross-cohort semantic deduplication is finished.

The current native evidence classes are 60 local-source-supported answers, 53 original
NL bridges and 100 primary-source NL-only answers. None receives a new Lean
certificate merely because it is in this distribution. Its public split is
train=74, dev=21, test_public=118. Public answers are not blind or
contamination-free evaluation. Graph support, semantic steps and structural
distance are different quantities; a complete disposition ledger is not complete
mathematical QA coverage.

## Mathematical integration audit

The four quarantines are bound to exact frozen item digests in `admission.json`.
They concern an incorrect positive-square-root claim/instrument distinction,
the omitted trivial-factor case in the PPT dimensional boundary, an unqualified
fixed-unitary impossibility and invalid norm-bound equivalence, and a tensor
action using the wrong second representation. They remain audit material until
separately reviewed repairs exist; no replacement independent review is invented.
For example, every state on a 1x7 system is separable, and for scalar x any fixed
scalar unitary u satisfies abs(tr(xu))=abs(x). These are explicit counterexamples
to the unqualified QA claims, not failures of proof search.

The source distinction between a POVM's probabilities and a stated projective
update can be inspected in [Leditzky's notes, Section 2.2](https://www.felixleditzky.info/teaching/FT25/math595-repth-qit.pdf).
The nontrivial 2x2/2x3 PPT result is [Horodecki et al.](https://arxiv.org/abs/quant-ph/9605038).
Our counterexamples/diagnoses are integration reasoning, not newly compiled
theorems or a claim that the source itself made every erroneous QA assertion.

One clear cross-cohort overlap was also recorded: native `qcb-core-sp-009` and
legacy `qcb-authored-0007` both target real-core to complex-isometry conversion.
NL versus API-facing presentation does not make two independent mathematical
cores. The remainder of cross-cohort reconciliation remains explicitly incomplete.

## Explicit compatibility and path repair

The author/organizer update added Outongyi Lv to the website script after the
frozen snapshot was made. The original input hashes and all frozen QA/review
artifacts are preserved. `qcb_migration.py` admits only this exact attribution
change and the narrowly documented loader-call substitutions. It requires:

1. the exact original file/hash in a reachable historical Git commit;
2. the exact current digest recorded in the compatibility ledger;
3. AST equality after reversing only the permitted attribution/loader changes.

Mathematical inputs, rubrics, reviews, targets, arbitrary code changes, unknown
paths and changed migration digests remain fail-closed. This is an explicit
compatibility migration, not a claim that old and current pipeline bytes match.
Full Git history is required; the data ZIP alone is not a validation checkout.

The 55 JSON files uploaded at repository-root `data/` were compared with their
canonical counterparts using LF-canonical UTF-8 hashes. Identical contents remain
under `benchmarks/quantumcomputingbench/data/`; only the redundant paths are
removed. `path-migration.json` records the mapping and hashes, and the original
paths/blobs remain recoverable in Git history. The downloaded delivery and its
historical ZIP/patch attachments are not modified or republished wholesale.

## Reproduction and boundaries

Run `python benchmarks/quantumcomputingbench/scripts/release.py validate` for the
combined checks. `build` creates a deterministic, checksum-bearing data ZIP from
a committed clean checkout. `score --cohort native` applies current withdrawal
policy; legacy diagnostics require an explicit separate cohort. Explanatory
answers need content-bound real rubric ratings; reference copies are not an
automatic pass. No model results are invented.

Original QA/code use the repository MIT terms; external textbook/paper rights
remain separate. No PDFs, credentials, private gold or raw generations are in the
release asset. Isolated untrusted Lean evaluation remains **ENV_BLOCKED** and
real-model baseline performance remains **UNMEASURED**. No training, paid API,
GPU experiment, administrator action or production Lean change is part of this
release.

## Local verification completed for this integration

The complete pinned Lean 4.29.1 gate was rerun on a cached checkout with identical
production/test/toolchain/dependency inputs: `lake build`, `lake build Tests`, and
all 202 module targets. Its proof-input digest is
`1e65e7d2984e4542ca2747837d71c516847e4e987d3bbd6c48b8a803eb36806e`.
The integration checkout was matched against that digest before and after the
trusted fixed-reference run. All 16 reference roots and three application
harnesses passed; actual `sorryAx` and wrong-type controls were rejected.
The complete public report is in `reports/integration-20261022/lean-reference-checks.json`.
Its build commit identifies the matching cached proof tree, not a new claim that
the entire native corpus was compiled. The report explicitly remains nonisolated
trusted-reference evidence and is not independent NL semantic review.

# QBench Integration Final Evidence Report

Generated: 2026-07-29 JST

This report closes the bounded QBench-informed integration experiment for the
current ABEIS checkout. It does not claim that ABEIS solves either benchmark,
that the old cubic route is complete, or that source/build improvements reduce
model tokens without a matched model rerun.

## 1. Reproducible identity

| Item | Value |
| --- | --- |
| ABEIS repository | `DakeBU/Quantum-Computing-Block-Encoding` |
| Branch and checkout | `main`, `1a84db83894bd8b7ab65d1d8cd72615a90343186` |
| Upstream state at baseline | `origin/main` at the same commit |
| ABEIS Lean | `4.29.1` |
| Lean-QAlg-Bench | `7f964d2b34a63c8ea7cae87937ede7740abe7dda`, Lean `4.31.0` |
| Lean-QIT-Bench | `e4f0230e14c35da9c658b58c8663b3e6825e6663`, Lean `4.30.0` |
| External licenses | Apache-2.0 |
| Current source-link policy | Commit links only for files present and clean at the remote commit; new local files use local declaration anchors |

The integration worktree is intentionally uncommitted. The 19 declarations in
the new `ConcreteSemantics.lean` file therefore do not receive false GitHub
links. The generated site has 1,646 commit-pinned source links for declarations
whose files satisfy the policy.

## 2. Initial baseline and selected failure

The baseline build passed with 1,646 public declaration records. The active
state named `QBE-OP-CUBIC-DIAGONAL-001`, while `HUMAN_STATUS.md` still named an
older task and was not trusted for scheduling.

The historical active-task ledger contains:

| Measure | Baseline |
| --- | ---: |
| Trial events | 707 |
| Agent attempts | 267 |
| Lower / middle / upper / reviewer calls | 83 / 82 / 82 / 20 |
| Estimated prompt-input tokens | 3,377,240 |
| Summed agent wall time | 77,500.66 s (21.53 h) |
| Retained attempts / feedback packets | 38 / 90 |

The token value is a local prompt-size proxy, not provider billing.

Failure classes extracted from the verifier feedback were:

| Failure class | Count |
| --- | ---: |
| `symbolic_bridge_gap` | 73 |
| `shape_or_register_gap` | 6 |
| `lean_tactic_gap` | 4 |
| `stale_leaf` | 3 |
| `source_translation_gap` | 2 |
| no error | 1 |

The dominant problem was not the finite target matrix. Agents repeatedly
searched below proposition-valued semantic interfaces after concrete
arithmetic had compiled. The missing work was a reusable representation
prerequisite and a controller branch that stops lower-level search when such a
prerequisite is unchanged.

The old arithmetic/rotation route remains incomplete. Two later isolated
Householder Hard Case routes are complete and were revalidated through Lean,
finite export, and Qiskit:

| Route | Lean root | Clean-block error | Qiskit |
| --- | --- | ---: | --- |
| COLD | `CubicDiagonalOracle.cubicDiagonalHouseholderExactBEContract_complete` | `0` | pass |
| HINTED | `CubicDiagonalOracle.linearDiagonalHouseholderInputBEContract_complete` plus the cubic root | `0` | pass |

The finite validation used Qiskit `2.4.2`, OpenQASM `1.0.1`, and `n = 2`.
QASM reconstruction errors were approximately `1.857e-12` for the cubic
route and `3.718e-13` for the hinted linear route. These validations do not
close the stale active-task ledger.

## 3. External benchmark audit

Both external repositories were cloned and built only in an isolated temporary
directory. They were not added as ABEIS dependencies because their Lean pins
differ.

| Repository | Files audited | Public lexical declarations | Build result |
| --- | --- | ---: | --- |
| Lean-QuantumAlg-Bench | 19 Base, 36 Definitions, 36 Statements | 431 Base, 160 Definitions, 44 Statements | pass, 2,506 jobs, 515.63 s cold wall |
| Lean-QIT-Bench | 10 Base, 40 Definitions, 40 Statements | 209 Base, 175 Definitions, 40 Statements | pass, 2,791 jobs |

The first QIT build completed, but its cold duration was not retained from the
combined log. A warm replay took 2.33 s; no cold duration is inferred from it.
Neither audited checkout contains separate `Hints.lean` files.

Relevant verified Base/Definitions surfaces inspected include:

- QAlg finite operator action: `QAlgBench.HilbertOperator.applyVec`,
  `applyVec_ket`, and `ext_of_applyVec_eq`;
- QAlg tensor and adjoint closure: `tensor_mul_tensor`,
  `conjTranspose_tensor`, `tensor_mem_unitaryGroup`, and
  `tensor_applyVec_tensor`;
- QAlg projected blocks: `QAlgBench.projectedBlock`,
  `ExactBlockEncoding.projected_block_eq`, `block_entry`, and
  `toBlockEncoding`;
- QAlg resource syntax: `ResourceProfile` and `CountedGateWord`;
- QIT pure-state and product-state infrastructure, including
  `QITBench.rankOneMatrix`, `PureVector`, and product partial-trace lemmas;
- QIT matrix-map, Choi, Kraus, and channel definitions as future references.

Every benchmark Statement file contains an unresolved `sorry`. Those
declarations are benchmark-only proof targets and are excluded from ABEIS
retrieval. The complete declaration-level audit, including source, line,
imports, layer, proof-hole flag, and disposition, is stored in
`qbench-external-declarations.json`.

The QAlg LCU definitions were not imported. The inspected `selectOp` is zero
outside the image of an injected label map, so general unitarity requires
either full label coverage or identity completion on unused labels. ABEIS does
not claim a general PREPARE--SELECT theorem.

## 4. Hypotheses and controlled intervention

| Hypothesis | Intervention | Fixed consumers | Result |
| --- | --- | --- | --- |
| H1: first-column contracts need a concrete action bridge | finite basis/zero ket, `mulVec`, standard complex unitarity, and first-column/action equivalence | bit flip, cubic rank-one operator, complex identity certificate | compiled |
| H2: flat and product-register views need a named bridge | explicit product-register view and clean-block projection equalities | square `2x2`, square `3x4`, rectangular `2*(3x5)`, rectangular `4*(2x7)`, BE Case 1 COLD | compiled |
| H3: proof-hole scans need a syntax-aware trust gate | comment/string-aware source scanner with an exact allowlist | four synthetic scanner tests plus the source tree | pass |
| H4: structural gaps must not expand ordinary proof search | prerequisite classification, frozen lower/capacity/epsilon, one unchanged-pass stop | 39 deterministic controller tests | pass |

This was an A/B source-and-build experiment:

- Arm A required consumers to reconstruct matrix action and register
  arithmetic locally and allowed structural gaps to trigger repeated
  allocation.
- Arm B imports named compiled adapters and routes unchanged structural gaps
  to a bounded prerequisite pass.

No model proof session was launched, so attempts, wall time, and token
consumption are not compared causally.

## 5. Implemented and Lean-verified declarations

All seven promoted technical lemmas compile under Lean `4.29.1`, introduce no
new proof hole or axiom, and are registered with exact signatures, imports,
assumptions, compatible shapes, source, attribution, successful consumers,
failed uses, and local/broader status.

| Declaration | Source | Purpose and downstream use |
| --- | --- | --- |
| `ConcreteSemantics.applyVec_basisKet` | `ConcreteSemantics.lean` | identifies matrix action on a basis ket with a matrix column; supports the zero-ket bridge |
| `ConcreteSemantics.applyVec_zeroKet` | same | specializes basis action to the all-zero basis state |
| `ConcreteSemantics.firstColumnMatches_iff_applyVec_zeroKet` | same | equates ABEIS first-column state preparation with `U |0^n> = psi`; used by bit-flip and cubic consumers |
| `ConcreteSemantics.ComplexStatePreparationCertificate.preparesVector` | same | exposes the action theorem from a certificate whose matrix satisfies Mathlib `unitaryGroup`; used by the complex identity certificate |
| `ConcreteSemantics.productRegisterBlockProjection_flatToProductRegister` | same | proves explicit product-view projection agrees with the flattened matrix entry; used by two rectangular shapes |
| `ConcreteSemantics.productIndex_val_eq_signalSystemBlockRowIndex` | same | names the flattening-order arithmetic fact without an opaque cast |
| `ConcreteSemantics.signalSystemBlockProjection_eq_cleanBlockProduct` | same | connects the circuit-level flattened projection to the existing clean-block view; used by square shapes and BE Case 1 COLD |

Local declaration completion is `complete` for all seven. Broader route status
is either `reusable prerequisite only` or `partial route`; none is presented
as a complete candidate-level block-encoding proof.

## 6. Harness and memory changes

Controller version 6 now:

- classifies `symbolic_bridge_gap`, `shape_or_register_gap`, and
  `source_translation_gap` as structural prerequisite failures;
- freezes lower workers, population capacity, epsilon relaxation, and normal
  search expansion while such a failure is active;
- permits one upper/middle/reviewer prerequisite pass and stops as blocked if
  the evidence is unchanged on the next pass;
- records prerequisite leaf and error classes in the cycle decision;
- preserves those fields in runtime-stop records;
- supports explicit `task-only`, `LAD`, and `full-abeis` evaluation modes.

`task-only` and `LAD` each use one bounded `lower2` attempt plus deterministic
review. They do not enable population growth, capacity expansion, epsilon
relaxation, or full historical trial memory. LAD may retrieve the verified
technical-lemma registry; task-only may not. Full ABEIS retains the proof DAG,
population, failure memory, role hierarchy, diagnostics, and resource-aware
selection.

The old repeated cubic failure has a structured failure-memory record. The
technical registry contains seven compiled entries plus two human-readable
cards and two machine retrieval records. The registry checker is part of both
Linux/macOS and PowerShell build scripts.

## 7. Proof and semantic trust boundary

The syntax-aware gate reports exactly two pre-existing, explicitly allowed
experimental Robin holes:

- `oneTermRobinGamma3BoundaryUnitaryEntry_eq_backendFold_n3`;
- `oneTermRobinGamma3BoundaryEvalGateMatrices_eq_sevenGateMatrix_n3`.

There are zero unapproved source `sorry`s and zero source `axiom` commands.
The new bridge module is hole-free. The integration does not:

- replace ABEIS symbolic/Rat semantics;
- reinterpret arbitrary proposition fields as standard unitarity;
- turn zero pointwise error into an operator-norm theorem;
- infer resources from trusted record annotations;
- import a QBench Statement theorem;
- claim general LCU, QSVT, density/channel, or partial-trace support.

## 8. Accepted, rejected, and deferred changes

### Implemented and Lean-verified

- finite matrix action and zero-ket/first-column equivalence;
- a concrete complex certificate boundary using Mathlib unitarity;
- flat/product-register and clean-block projection bridges;
- syntax-aware proof trust gate;
- compiled technical-lemma registry and deterministic retrieval metadata;
- prerequisite-aware scheduling and isolated evaluation modes.

### Imported/reimplemented with attribution

No external code or theorem body was copied. QBench Base/Definitions APIs were
used as design references. The ABEIS bridges were independently proved on the
existing toolchain. Exact commits, licenses, and the independent-rewrite
boundary are recorded in `NOTICE.md` and `docs/attribution.md`.

### Benchmark-only unsolved targets

All QBench Statement declarations remain external unresolved tasks. They are
present in the external audit inventory but excluded from the trusted
technical registry.

### Rejected after audit

- direct benchmark dependencies, due to Lean pin differences and unnecessary
  trust/build expansion;
- direct reuse of the partial-label LCU SELECT as a unitary operator;
- presenting Statement wrappers that compile with `sorry` as verified lemmas;
- broad QIT imports unrelated to the selected failure;
- any claim that current entrywise exactness proves operator-norm accuracy.

### Experimentally useful but not yet generalized

- the complex certificate is an optional concrete acceptance layer and has not
  replaced every legacy candidate;
- the projection bridges close representation prerequisites, not full
  candidate unitarity or approximation;
- scheduler tests prove bounded behavior, not mathematical convergence.

### Future work

- total LCU SELECT with full coverage or identity completion;
- a separately named operator-norm approximation layer and finite-dimensional
  comparison theorem;
- density, partial-trace, and channel semantics only when a logged route
  requires them;
- syntax-derived resource-soundness theorems;
- matched model/backend/budget ablations for task-only, LAD, and full ABEIS.

## 9. Verification gates

| Gate | Result |
| --- | --- |
| `lake build` | pass, 1,917 jobs |
| `lake build Tests` | pass, 1,920 jobs |
| `lake build ABEISTests.QBenchIntegration` | pass, 1,908 jobs |
| `python3 tools/qbe.py check` | pass |
| controller tests | 39 pass |
| proof-trust scanner tests | 4 pass |
| proof-trust source gate | pass; 2 approved experimental holes, 0 unapproved, 0 axioms |
| technical-lemma registry check | pass, 7/7 entries |
| Blueprint catalog consistency | pass |
| Verso Blueprint build | pass |
| unified site build | pass |
| internal links and fragments | pass across 74 HTML files; 37 Blueprint declaration anchors materialized |
| source-link check | pass |
| local-path leakage check | pass across 146 publication text files |
| preview server test | pass |
| desktop themes | Firefox smoke pass for Blueprint, Modern, and Bold |
| mobile layout | Firefox smoke pass at `390x844` for home and Library Explorer |
| Mermaid / MathJax | 7 Mermaid sources detected; browser-rendered formula smoke pass |
| artifact layout | pass; root, Library Explorer, 8 chapters, 18 module pages, Blueprint, workflow, roadmap, attribution |
| PowerShell build | not run on Linux; script updated in parity with the executed shell pipeline |
| LaTeX paper | pass with an isolated official Tectonic `0.16.9` binary; 30 pages, 0 undefined citations, 0 undefined references, 0 overfull boxes, 0 fatal errors |

Generated documentation statistics:

| Measure | Count |
| --- | ---: |
| Public declarations | 1,665 |
| Private/internal declarations excluded | 177 |
| Source docstrings | 1,317 |
| Generated reader cues | 1,665 |
| Search entries | 1,678 = 1,665 declarations + 13 pages |
| Guided chapters | 8 |
| Module pages | 18 |
| Mermaid diagrams | 7 |
| Commit-pinned source links | 1,646 |
| Local-only new declarations | 19 |

The host had no preinstalled TeX command, so the paper was compiled with an
official Tectonic `0.16.9` binary under `/tmp`. The validated output was then
synced to the paper directory, including `main.pdf`, `main.bbl`, `main.aux`,
`main.out`, `main.log`, and `main.blg`. The final 30-page build has no
undefined citation, undefined reference, overfull box, or fatal error.

## 10. Documentation and paper changes

README now:

- adds `ConcreteSemantics.lean` to the module map;
- documents the seven-lemma registry and three evaluation modes;
- adds the QBench paper and both repositories to the existing literature
  table;
- states that Statement `sorry`s are tasks rather than verified lemmas;
- records the partial-label SELECT limitation and the current pointwise/error
  boundary.

The paper source now:

- adds QBench and repository BibTeX entries;
- treats QBench theorem-completion evaluation and ABEIS construction search as
  complementary;
- describes the generic, symbolic/Rat, and narrow concrete semantic layers;
- documents structural-prerequisite scheduling and task-only/LAD/full-ABEIS
  modes;
- reports the source/build bridge experiment without unsupported token or
  ranking claims;
- updates generated declaration and documentation counts.

The modified paper sections are `related`, `harness`, `lean_platform`,
`evidence`, and `documentation_surface`, plus `main.tex` and `reference.bib`.

## 11. Changed files

Core Lean and tests:

- `QuantumBlockEncoding/ConcreteSemantics.lean` (new);
- `ABEISTests/QBenchIntegration.lean` (new);
- `QuantumBlockEncoding.lean`;
- `QuantumBlockEncoding/TechnicalLemmas.lean`;
- `lakefile.lean`.

Harness, checks, and build:

- `tools/qbe_control.py`, `tools/test_qbe_control.py`, `tools/qbe.py`;
- `tools/proof_trust.py`, `tools/check_proof_trust.py`,
  `tools/test_proof_trust.py` (new);
- `tools/check_technical_lemma_registry.py` (new);
- `tools/generate_qbench_audit.py` (new);
- `tools/export_lean_leaf_index.py`;
- `scripts/build-all.sh`, `scripts/build-all.ps1`,
  `scripts/generate-blueprint-catalog.py`.

Evidence and technical memory:

- this report and the baseline, external-audit, semantic-bridge, and
  declaration-inventory reports;
- `failure-memory/QBE-OP-CUBIC-DIAGONAL-001-structural-prerequisite.json`;
- `research-wiki/technical-lemmas/registry.json`, its README, and two cards;
- two `research-wiki/retrieval-index/` records;
- regenerated compiled Lean leaf indexes.

Documentation and site:

- `README.md`, `NOTICE.md`, `docs/attribution.md`;
- `website/content.py`;
- `ABEISBlueprint/Catalog/Semantics.lean`;
- regenerated `docs/blueprint-coverage.json` and
  `web/library/declarations.json`.

Paper source outside the ABEIS Git worktree:

- `reference.bib`, `main.tex`;
- `main/related.tex`, `main/harness.tex`, `main/lean_platform.tex`,
  `main/evidence.tex`, and `main/documentation_surface.tex`;
- regenerated `main.pdf`, `main.bbl`, `main.aux`, `main.out`, `main.log`, and
  `main.blg`.

## 12. Remaining semantic gaps and next minimum goal

The old `QBE-OP-CUBIC-DIAGONAL-001` route still lacks a concrete replacement
for its opaque rotation/workspace semantics and is not reconciled with the
completed Householder certificates. General LCU, operator-norm approximation,
density/channel semantics, partial trace, and derived resource proofs remain
open.

The next minimum evidence-driven goal should be:

1. reconcile the stale cubic task ledger with the already compiled
   Householder roots and mark the obsolete arithmetic/rotation branch as
   superseded rather than searching it again;
2. select one logged resource/circuit mismatch or one LCU consumer;
3. implement only the required syntax-to-resource theorem or total-SELECT
   prerequisite;
4. run a fixed theorem/model/backend/budget comparison in `task-only`, `LAD`,
   and `full-abeis` modes before making any efficiency claim.

# Proof Blueprint: QBE-MAIN-CASE-HIER-COLD-001

Task id: `QBE-MAIN-CASE-HIER-COLD-001`
Title: Main case transfer-operator block encoding, no-Pro isolated Hierarchical Harness
Mode: `exploratoryConstruction`
Updated: `2026-06-25 23:07:17`
Blueprint stage: `Stage 1 target/contract stabilization; exploratory exact-phase COLD Lean-surface repair`

This is QBE's compact system-of-record snapshot for long-horizon Lean proof
automation.  It follows a similar control pattern to LeanMarathon's evolving
blueprint, but QBE keeps the human-facing proof map split across Lean,
Markdown, LaTeX, proof obligations, and cited-results memory because
block-encoding papers require source notation, register conventions, and
oracle contracts to stay explicit.

## Current Directive

````text
# Main case transfer-operator block encoding, no-Pro isolated Hierarchical Harness

Task id: `QBE-MAIN-CASE-HIER-COLD-001`
Kind: `operatorBlockEncoding`
Mode: `exploratoryConstruction`
Status: `active`
Created: `2026-06-25 22:24`

## Goal

State the query-operator target precisely.  The preferred input is a finite
matrix/operator `A`, a normalizer `alpha`, and the requested block-entry
contract:

```text
(<0^a| ⊗ I) U_A (|0^a> ⊗ I) = A / alpha
```

The system should construct a unitary candidate `U_A`, prove in Lean that it
contains the requested operator block, and score the candidate by:

1. asymptotic tier first, especially polylogarithmic versus polynomial growth,
2. gate count inside one tier,
3. depth / parallel schedule length,
4. auxiliary qubits `a`,
5. unresolved oracle calls.

State whether this is a direct operator-to-block-encoding construction task, a
paper benchmark task, or an exploratory improvement task.  Paper benchmark
tasks reproduce a cited construction as a baseline; improvement tasks may
search for a better construction only after the original target is fixed.

Hybrid strategy:

- `operatorBlockEncoding`: given `A`, search for candidate `U_A`
  constructions, prove the block-entry and unitarity contracts, and rank
  candidates by asymptotic tier, then gate count, depth, auxiliary qubits, and
  unresolved oracle calls.
- `paperBenchmark` / `faithfulPaper`: reproduce a cited construction as a
  source-faithful baseline.  Do not mutate the paper construction while proving
  the baseline.
- `exploratoryConstruction`: use Learning-Beyond-Gradients-style trial memory
  plus EoH-style candidate populations for circuit ideas.  Candidate scores are
  search hints only; Lean proof obligations decide acceptance.  This mode may
  improve a baseline after the original operator target is fixed.

LexElim scheduler discipline:

- Use LexElim-Out for faithful paper/theorem closure: filter routes by source
  faithfulness, correct Lean statement, necessary diagnostics, then proof
  progress/resources.
- Use LexElim-In for exploratory operator construction: read all feedback
  fields each round, but do not let lower-priority soft rewards override hard
  Lean correctness or necessary-condition diagnostics.

## Source

- Paper/open problem: `main case transfer operator E_k := |0><k|_time ⊗ |0><1|_type ⊗ I`
- Lean target: `QuantumBlockEncoding/MainCase.lean`

## Operator Contract

- Operator/matrix `A`:

  ```text
  E_k = |0><k|_T ⊗ |0><1|_tau ⊗ I_S
  ```

  For the reproducible main-case benchmark use `r = 1`, `k = 1`, and one
  passive qubit in `S`.
- System qubits `n`: two active qubits (`T`, `tau`) plus one passive qubit in
  the benchmark instantiation.
- Normalizer `alpha`: exact target uses `alpha = 1`.
- Required block: clean block on the block-encoding ancilla state `|0>`.
- Free parameters allowed in the oracle: candidate completion of the unitary,
  block ancilla convention, and reversible gate scheduling.  The target
  operator itself may not be changed.
- Required exactness or error tolerance: exact first.  After configured exact
  convergence, enter the approximate phase with the exact champion as
  `epsilon = 0` incumbent.

## Isolation Rule

This is the no-Pro isolated Hierarchical Harness arm.  Agents may use the
current compiled Lean library, the textbook memory cards, and general quantum
computing knowledge, but they must not use previous main-case candidate names,
previous Pro answers, previous task-specific proof scripts, or previous
Qiskit exports as a shortcut.  If they rediscover a known construction, they
must prove it under this task's own names and record it as an independent
attempt.

## Textbook-Memory Guidance

Upper agents should first consider partial permutation and clean-block
entrywise routes, because the target is a matrix-unit tensor identity.  LCU,
QSVT, and sparse access may remain in the insight pool only as comparison
routes; they should not be the first proof route unless the partial-permutation
route is shown to be blocked.

## Post-Lean Executable Exports

- Requested targets: `qiskit,qasm3`
- Export policy: Lean-first.  Generate executable code only after a named Lean
  declaration proves the advertised block-encoding theorem at the task's
  semantic tier.
- Concrete export instantiation: `r=1,k=1,passiveQubits=1`
- Expected artifact root: `executable-exports/QBE-MAIN-CASE-HIER-COLD-001/`

Supported target labels include `qiskit`, `quantum-katas`, and `qasm3`.
Each export must state its Lean source declaration, register sizes, parameter
values, normalizer, projector, resource tuple, and export check command.

## Candidate Score

The default candidate score is defined in Lean as `BlockEncodingCost`.
ABEIS first compares asymptotic tiers, because polylogarithmic growth in
the system size is qualitatively different from polynomial growth.  Inside
one fixed asymptotic/logical-library tier, the concrete comparison tuple is:

```text
(gateCount, depth, auxiliaryQubits, oracleCalls)
```

Selection is lexicographic in that order after the asymptotic tier check.
In particular, fewer gates beats a shallower schedule; depth breaks
gate-count ties; auxiliary qubits break gate/depth ties.

## Conversion Window

### Markdown

Human explanation, scope, and dependencies.

### LaTeX

Paste-ready theorem/proof statement.  Keep notation synchronized with Lean names.

### Lean

Expected file and declarations:

```lean
-- target: QuantumBlockEncoding/MainCase.lean
```

## Proof Obligations

- [ ] Matrix/operator target `A` is defined.
- [ ] Candidate unitary `U_A` or circuit schema is defined.
- [ ] Block-entry contract is stated with the exact ancilla projector.
- [ ] Unitarity of `U_A` is proved or recorded as a named obligation.
- [ ] Normalization `alpha` is explicit.
- [ ] Auxiliary qubit count `a` is explicit.
- [ ] Asymptotic tier and concrete resource score `(gateCount, depth, a, oracleCalls)` are explicit.
- [ ] Candidate comparison against the current baseline is recorded when relevant.
- [ ] `lake build && lake build Tests` succeeds.

## Agent Notes

Do not mark this task complete unless the Lean build gate passes.

Use trial logging for every substantial attempt:

```bash
python3 tools/qbe.py trial-log --task QBE-MAIN-CASE-HIER-COLD-001 --role lower --kind attempt --status running --notes "starting construction search"
python3 tools/qbe.py trial-summary
```
````

## Dynamic Leaf Queue

These are the current local proof or repair candidates.  Lower agents should
work on one item at a time; if an item is stale, upper/middle must retire it
before spending more proof-search tokens.

| Leaf | Status |
|---|---|
| MAIN-SOURCE-001: Translate `E_1`, `(T,tau,S)`, clean signal, `alpha = 1`, and `epsilon = 0` into Lean declarations.; status: active leaf prerequisite; Lean: `mainCaseColdSystemIndex`, `mainCaseColdTarget`, `mainCaseColdExactNormalizer`, `mainCaseColdExactError`, `mainCaseColdCleanEmbed` | candidate |
| MAIN-CAND-IMAGE-001: Define the `Fin 16` finite image for `MAIN-PARTIAL-PERM-001`.; status: active leaf prerequisite; Lean: `mainCaseColdPartialPermImage`, `mainCaseColdPartialPermMatrix` | candidate |
| MAIN-CLEAN-ENTRY-001: Prove the clean block of the permutation matrix equals `mainCaseColdTarget` via `partialPermutationCertificate`.; status: active Lean leaf; Lean: `mainCaseColdPartialPerm_entry`, `mainCaseColdPartialPermExactCleanBlock`, `mainCaseColdPartialPerm_clean_eq_target` | candidate |
| MAIN-EXPORT-001: Create Qiskit and QASM3 exports for `r=1,k=1,passiveQubits=1`.; status: blocked until Lean certificate; Lean: export manifest and checks | candidate |

## Open Obligation Signals

```text
add COLD task-local Lean target surface: Lean `mainCaseCold*` declarations in `QuantumBlockEncoding/MainCase.lean` or child import; class internal construction leaf; status active
keep task file imported into the library: Lean `import QuantumBlockEncoding.MainCase` in `QuantumBlockEncoding.lean`; class build integration; status present
define matrix/operator target `A`: Lean `mainCaseColdTarget`; class source translation; status active
define clean projector/embedding: Lean `mainCaseColdCleanEmbed`; class shape/register; status active
define candidate unitary matrix: Lean `mainCaseColdPartialPermImage`, `mainCaseColdPartialPermMatrix`; class candidate construction; status active
prove clean-block equality: Lean `mainCaseColdPartialPerm_clean_eq_target`; class symbolic bridge; status active
prove permutation/unitarity: Lean `mainCaseColdPartialPermImage_bijective`; later unitary theorem if needed; class unitarity layer; status open
make normalizer explicit: Lean `mainCaseColdExactNormalizer = 1`; class source translation; status active
make auxiliary qubit count explicit: Lean `mainCaseColdPartialPermCost.auxiliaryQubits = 1` or layout theorem; class resource layer; status open
make resource tuple explicit: Lean field theorems for `(gateCount, depth, auxiliaryQubits, oracleCalls)`; class resource layer; status open; gate/depth need circuit schema
compare against baseline: Lean candidate-population row for `MAIN-PARTIAL-PERM-001`; class exploratory memory; status queued
run gate: Lean `python3 tools/qbe.py check`; class project gate; status required after edits
```

## Lean Declaration Index

Recent task-relevant declarations:

| Kind | Lean name | File |
|---|---|---|
| def | `gateMatricesMatchCircuit` | `QuantumBlockEncoding/CircuitSemantics.lean:41` |
| def | `evalGateMatrices` | `QuantumBlockEncoding/CircuitSemantics.lean:54` |
| theorem | `evalWith_foldl_add_mul` | `QuantumBlockEncoding/CircuitSemantics.lean:71` |
| theorem | `evalWith_mul_apply` | `QuantumBlockEncoding/CircuitSemantics.lean:92` |
| theorem | `evalWith_mul_eq_zero_of_all_paths_zero` | `QuantumBlockEncoding/CircuitSemantics.lean:131` |
| theorem | `about` | `QuantumBlockEncoding/CircuitSemantics.lean:300` |
| theorem | `evalWith_mul_unique_path` | `QuantumBlockEncoding/CircuitSemantics.lean:304` |
| theorem | `evalWith_mul_two_path` | `QuantumBlockEncoding/CircuitSemantics.lean:328` |
| theorem | `evalWith_mul_identity_right_apply` | `QuantumBlockEncoding/CircuitSemantics.lean:355` |
| theorem | `cast_square_apply` | `QuantumBlockEncoding/CircuitSemantics.lean:371` |
| theorem | `evalWith_evalGateMatrices_single` | `QuantumBlockEncoding/CircuitSemantics.lean:389` |
| structure | `CircuitMatrixSemantics` | `QuantumBlockEncoding/CircuitSemantics.lean:404` |
| def | `ofGateMatrices` | `QuantumBlockEncoding/CircuitSemantics.lean:415` |
| structure | `PreparedCircuitEntryTarget` | `QuantumBlockEncoding/CircuitSemantics.lean:436` |
| def | `entryEqualityStatement` | `QuantumBlockEncoding/CircuitSemantics.lean:454` |
| def | `matrixEntryEqualityStatement` | `QuantumBlockEncoding/CircuitSemantics.lean:459` |
| theorem | `entryEqualityStatement_iff_matrixEntryEqualityStatement` | `QuantumBlockEncoding/CircuitSemantics.lean:470` |
| structure | `BlockExtractionTarget` | `QuantumBlockEncoding/CircuitSemantics.lean:502` |
| def | `blockExtractionBranchContributionSum` | `QuantumBlockEncoding/CircuitSemantics.lean:520` |
| structure | `BlockExtractionBranchContributionTarget` | `QuantumBlockEncoding/CircuitSemantics.lean:535` |
| def | `selectedBranchStatement` | `QuantumBlockEncoding/CircuitSemantics.lean:559` |
| def | `projectionSummationStatement` | `QuantumBlockEncoding/CircuitSemantics.lean:569` |
| def | `backendExpansionStatement` | `QuantumBlockEncoding/CircuitSemantics.lean:586` |
| theorem | `selectedBranchStatement_of_eq` | `QuantumBlockEncoding/CircuitSemantics.lean:595` |
| theorem | `projectionSummationStatement_iff_backendExpansionStatement` | `QuantumBlockEncoding/CircuitSemantics.lean:603` |
| theorem | `projectionSummationStatement_of_backendExpansionStatement` | `QuantumBlockEncoding/CircuitSemantics.lean:629` |
| theorem | `backendExpansionStatement_of_projectionSummationStatement` | `QuantumBlockEncoding/CircuitSemantics.lean:640` |
| structure | `CircuitBlockEncodingClaim` | `QuantumBlockEncoding/CircuitSemantics.lean:661` |
| structure | `FiniteBlockCompositionContract` | `QuantumBlockEncoding/CircuitSemantics.lean:676` |
| def | `signalSystemBlockRowIndex` | `QuantumBlockEncoding/CircuitSemantics.lean:696` |
| def | `signalSystemBlockColIndex` | `QuantumBlockEncoding/CircuitSemantics.lean:700` |
| theorem | `signalSystemBlockRowIndex_lt` | `QuantumBlockEncoding/CircuitSemantics.lean:712` |
| theorem | `signalSystemBlockColIndex_lt` | `QuantumBlockEncoding/CircuitSemantics.lean:727` |
| def | `signalSystemBlockProjection` | `QuantumBlockEncoding/CircuitSemantics.lean:753` |
| def | `totalCircuitQubits` | `QuantumBlockEncoding/CircuitSemantics.lean:778` |
| def | `CircuitMatrixSemantics.blockExtractionTarget` | `QuantumBlockEncoding/CircuitSemantics.lean:786` |
| abbrev | `Matrix` | `QuantumBlockEncoding/Core.lean:15` |
| def | `PointwiseEq` | `QuantumBlockEncoding/Core.lean:20` |
| def | `zero` | `QuantumBlockEncoding/Core.lean:25` |
| def | `identity` | `QuantumBlockEncoding/Core.lean:29` |
| def | `mul` | `QuantumBlockEncoding/Core.lean:34` |
| def | `gridSize` | `QuantumBlockEncoding/Core.lean:44` |
| def | `clog2` | `QuantumBlockEncoding/Core.lean:52` |
| theorem | `log2_pred_two_pow_succ` | `QuantumBlockEncoding/Core.lean:64` |
| inductive | `BoundaryKind` | `QuantumBlockEncoding/Core.lean:103` |
| structure | `Stencil` | `QuantumBlockEncoding/Core.lean:111` |
| def | `width` | `QuantumBlockEncoding/Core.lean:121` |
| structure | `BulkWindow` | `QuantumBlockEncoding/Core.lean:134` |
| def | `paperBoundaryLines` | `QuantumBlockEncoding/Core.lean:142` |
| inductive | `Coeff` | `QuantumBlockEncoding/Core.lean:148` |
| def | `sub` | `QuantumBlockEncoding/Core.lean:170` |
| def | `evalWith` | `QuantumBlockEncoding/Core.lean:176` |
| theorem | `rat_zero` | `QuantumBlockEncoding/Core.lean:199` |
| theorem | `evalWith_rat_add` | `QuantumBlockEncoding/Core.lean:210` |
| theorem | `evalWith_rat_mul` | `QuantumBlockEncoding/Core.lean:215` |
| theorem | `evalWith_rat_neg` | `QuantumBlockEncoding/Core.lean:220` |
| theorem | `evalWith_eq_zero_of_rat_zero` | `QuantumBlockEncoding/Core.lean:225` |
| theorem | `evalWith_eq_one_of_rat_one` | `QuantumBlockEncoding/Core.lean:229` |
| def | `divNat` | `QuantumBlockEncoding/Core.lean:232` |
| structure | `StencilEntry` | `QuantumBlockEncoding/Core.lean:238` |

## Correspondence Artifacts

| Artifact | Role |
|---|---|
| `tasks/QBE-MAIN-CASE-HIER-COLD-001.md` | task/proof map |
| `conversion-windows/QBE-MAIN-CASE-HIER-COLD-001.md` | Lean/natural-language conversion |
| `proof-obligations/QBE-MAIN-CASE-HIER-COLD-001.md` | open obligations |

## Latest Dialogue Signal

````text
python3 tools/qbe.py check.

## 20260625-223031-QBE-MAIN-CASE-HIER-COLD-001-cycle01

# Dialogue: QBE-MAIN-CASE-HIER-COLD-001 cycle 1

Append short role-tagged handoffs here.

## 2026-06-25 22:32:55 - upper

Mode exploratory construction. Objective for cycle 1: instantiate the exact r=1,k=1,one-passive-qubit target in QuantumBlockEncoding/MainCase.lean and certify the first partial-permutation clean-block candidate under task-local names, reusing BlockEncodingClassics clean-block leaves but not copying prior main-case/Pro/circuit exports. Proof DAG root: MainCase exact block encoding for E_1 with alpha=1 and a=1. Dependencies: target matrix/register layout, clean embedding, finite permutation image, clean-entry equality, permutation/unitarity, resource tuple. Active leaves: middle creates conversion window and DAG table; lower 1 writes the natural-language partial-permutation proof sketch; lower 2 implements only the target plus one clean-entry/ExactCleanBlock certificate leaf; lower 3 checks finite 16x16 support, block entry, normalizer, ancilla, and resource fields. Retire LCU/QSVT/sparse routes for this cycle unless partial permutation is falsified. Reviewer blocks any use of ColdStartTransferE1/OptimalControl candidate names as a shortcut and requires qbe.py check.

## 2026-06-25 22:46:50 - middle

Created COLD conversion window, proof-obligation ledger, candidate population, lower split packet, verifier-feedback target, memory digest/todo, and retrieval index. Primary route is MAIN-PARTIAL-PERM-001 via partial permutation; middle finite table sanity check passed for permutation/passive-S/clean support [(0,6),(1,7)]. Existing mainCasePro* Lean declarations are from the separate Pro arm and are out of scope for this no-Pro COLD task. Next lower leaf: add independent mainCaseCold* declarations and prove mainCaseColdPartialPerm_clean_eq_target through BlockEncodingClassics.partialPermutationCertificate. Gate passed: python3 tools/qbe.py check.

## 2026-06-25 22:51:28 - lower

Lower architect packet written for MAIN-CLEAN-ENTRY-001: source fragment is the task operator E_1, route is partial permutation via BlockEncodingClassics.partialPermutationCertificate, clean block has ones only at (0,6) and (1,7), and next Lean route is to implement mainCaseColdPartialPerm_entry plus mainCaseColdPartialPermExactCleanBlock. Gate passed: python3 tools/qbe.py check.

## 2026-06-25 22:55:05 - reviewer

Reviewer gate: python3 tools/qbe.py check passed (lake build and lake build Tests). Blocking for QBE-MAIN-CASE-HIER-COLD-001 acceptance: the current Lean surface has only mainCasePro* declarations and tests; no independent mainCaseCold* target, candidate image, clean-entry theorem, permutation/unitarity certificate, or resource tuple exists yet. Treat finite diagnostics as guidance only; closed_theorem_ok remains false. Next smallest repair: implement MAIN-SOURCE-001, MAIN-CAND-IMAGE-001, and MAIN-CLEAN-ENTRY-001 under mainCaseCold* names, then rerun qbe.py check.
````

## Gate Policy

- Stage 1 target/transcript stabilization: upper and middle must verify that
  Lean statements, source-paper prose, register layouts, normalizers, and
  cited contracts match before broad lower proving.
- Stage 2 DAG proof discharge: lower agents work on dynamic leaves only;
  reviewer accepts inner-cycle progress only through `python3 tools/qbe.py check`
  and synchronized Lean-to-natural-language proof status.  LaTeX exports are
  checked at 6h/convergence closeout.
- Mixed lower-agent proof mode: lower 1 writes the natural-language dependency
  proof and active-leaf table; lower 2 compiles exactly one ready Lean leaf;
  lower 3, when available, runs necessary-condition diagnostics such as finite
  matrix/path/support checks and typed verifier-feedback packets before lower 2
  spends time on a large Lean proof.
- Refiner behavior: when several failures share a dependency, repair the
  connected illness area once instead of stacking independent patches.
- No agent may mark a proof complete from self-assessment, partial score, or
  process memory.  Lean plus explicit proof-map correspondence is the gate.

# Proof Blueprint: QBE-MAIN-CASE-HIER-COLD-001

Task id: `QBE-MAIN-CASE-HIER-COLD-001`
Title: Main case transfer-operator block encoding, no-Pro isolated Hierarchical Harness
Mode: `exploratoryConstruction`
Updated: `2026-06-26 00:23:03`
Blueprint stage: `Stage 1 target/transcript stabilization`

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
| MAIN-CANDIDATE-PACKAGE-001: Package the COLD candidate and verified certificate without changing the target or hiding resource assumptions.; status: active leaf; Lean: `mainCaseColdPartialPermCandidate`, `mainCaseColdPartialPermVerified` | candidate |
| MAIN-EXPORT-001: Create Qiskit and QASM3 exports for `r=1,k=1,passiveQubits=1`.; status: blocked until Lean certificate; Lean: export manifest and checks | candidate |

## Open Obligation Signals

```text
add COLD task-local Lean target surface: Lean `mainCaseCold*` declarations in `QuantumBlockEncoding/MainCase.lean`; class internal construction leaf; status proved
keep task file imported into the library: Lean `import QuantumBlockEncoding.MainCase` in `QuantumBlockEncoding.lean`; class build integration; status present
define matrix/operator target `A`: Lean `mainCaseColdTarget`; class source translation; status proved
define clean projector/embedding: Lean `mainCaseColdCleanEmbed`; class shape/register; status proved
define candidate unitary matrix: Lean `mainCaseColdPartialPermImage`, `mainCaseColdPartialPermMatrix`; class candidate construction; status proved
prove clean-block equality: Lean `mainCaseColdPartialPerm_clean_eq_target`; class symbolic bridge; status proved
prove permutation/unitarity: Lean `mainCaseColdPartialPermImage_bijective`; later unitary theorem if needed; class unitarity layer; status finite bijection proved; retired from active queue
state operator-first target metadata: Lean `mainCaseColdQueryTarget`; class source translation; status proved
state project-local block projection and prove candidate matrix satisfies it: Lean `mainCaseColdBlockProjection`, `mainCaseColdPartialPerm_blockProjection`; class semantic bridge; status proved
make normalizer explicit: Lean `mainCaseColdExactNormalizer = 1`; class source translation; status compiled
make auxiliary qubit count explicit: Lean `mainCaseColdSourceLayout_auxiliaryQubits`, `mainCaseColdPartialPermCost_auxiliaryQubits`; class resource layer; status proved
make resource tuple explicit: Lean field theorems for `(gateCount, depth, auxiliaryQubits, oracleCalls)`; class resource layer; status proved as `(5,5,1,0)` after COLD-local circuit schema
package COLD candidate and verified certificate: Lean `mainCaseColdPartialPermCandidate`, `mainCaseColdPartialPermVerified`; class candidate packaging; status active next leaf; resource tuple now ready
compare against baseline: Lean candidate-population row for `MAIN-PARTIAL-PERM-001`; class exploratory memory; status updated with compiled resource tuple; full candidate ranking still awaits verified package
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
e memory, retrieval index, proof blueprint, run todo, and verifier-feedback sync. Gates passed: python3 tools/qbe.py check; lake build && lake build Tests.

## 2026-06-26 00:09:53 - middle

Closed MAIN-BLOCK-PROJECTION-001 under task-local COLD declarations: mainCaseColdQueryTarget, mainCaseColdBlockProjection, mainCaseColdPartialPerm_blockProjection, mainCaseColdSourceLayout_auxiliaryQubits, and mainCaseColdResourceSchemaObligation compile. Refreshed conversion window, obligations, candidate population, proof blueprint, retrieval index, run todo, lower resource packet, and verifier feedback. Active leaf is MAIN-RESOURCE-001; candidate packaging and Qiskit/QASM3 export remain blocked until an honest COLD circuit/resource tuple and cost theorems compile. Gates passed: python3 tools/qbe.py check; lake build && lake build Tests.

## 2026-06-26 00:13:36 - lower

Necessary-condition verifier checked MAIN-RESOURCE-001. Added verifier-feedback/QBE-MAIN-CASE-HIER-COLD-001/main-case-cold-resource-cycle03.{py,md,feedback.json}; the executable rechecks the COLD Fin16 table, clean support {(0,6),(1,7)}, alpha=1, and open resource state. finite_matrix_ok=true, block_entry_ok=true, source_correspondence_ok=true, closed_theorem_ok=false for the resource leaf, error_class=symbolic_bridge_gap. Rejection: do not add mainCaseColdPartialPermCandidate, mainCaseColdPartialPermVerified, or Qiskit/QASM3 export before a COLD-local circuit/resource schema and mainCaseColdPartialPermCost_* field theorems compile. Gate passed: python3 tools/qbe.py check.

## 2026-06-26 00:16:27 - lower

Lower architect packet written for MAIN-RESOURCE-001 at proof-attempts/QBE-MAIN-CASE-HIER-COLD-001-lower-architect-cycle03-main-resource.md. It derives an independent COLD-local five-gate logical reversible schema on wires signal,T,tau,S: X_signal; CCX_T_tau_signal; CX_tau_T; CX_signal_T; X_tau. Finite table check matches mainCaseColdPartialPermImage, proposed logical tuple is (gateCount,depth,auxiliaryQubits,oracleCalls)=(5,4,1,0), but closed_theorem_ok=false until mainCaseColdCircuit/mainCaseColdSchedule/mainCaseColdLogicalResource/mainCaseColdPartialPermCost_* compile. Gates passed: python3 tools/qbe.py check; lake build && lake build Tests.

## 2026-06-26 00:20:17 - lower

Closed MAIN-RESOURCE-001 at the high-level logical resource tier. Added COLD-local circuit/schema declarations in QuantumBlockEncoding/MainCase.lean: mainCaseColdCircuit, mainCaseColdSchedule, mainCaseColdCircuitImage_eq_partialPermImage, mainCaseColdHighLevelResource, mainCaseColdPartialPermCost, and cost field theorems for score (gateCount,depth,auxiliaryQubits,oracleCalls)=(5,5,1,0). Did not promote mainCaseColdResourceSchemaObligation.proved and did not package a candidate. Next exact Lean leaf: MAIN-CANDIDATE-PACKAGE-001, define mainCaseColdPartialPermCandidate and mainCaseColdPartialPermVerified from existing finite-permutation, block-projection, and resource declarations. Gate passed: python3 tools/qbe.py check.
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

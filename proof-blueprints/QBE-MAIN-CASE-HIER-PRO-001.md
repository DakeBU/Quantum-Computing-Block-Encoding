# Proof Blueprint: QBE-MAIN-CASE-HIER-PRO-001

Task id: `QBE-MAIN-CASE-HIER-PRO-001`
Title: Main case transfer-operator block encoding, Pro-assisted isolated Hierarchical Harness
Mode: `exploratoryConstruction`
Updated: `2026-06-25 23:09:27`
Blueprint stage: `Stage 1 target/transcript stabilization`

This is QBE's compact system-of-record snapshot for long-horizon Lean proof
automation.  It follows a similar control pattern to LeanMarathon's evolving
blueprint, but QBE keeps the human-facing proof map split across Lean,
Markdown, LaTeX, proof obligations, and cited-results memory because
block-encoding papers require source notation, register conventions, and
oracle contracts to stay explicit.

## Current Directive

````text
# Main case transfer-operator block encoding, Pro-assisted isolated Hierarchical Harness

Task id: `QBE-MAIN-CASE-HIER-PRO-001`
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

- Paper/open problem: `main case transfer operator E_k := |0><k|_time ⊗ |0><1|_type ⊗ I with a mid-run external Pro construction/proof input`
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

This is the Pro-assisted isolated Hierarchical Harness arm.  It is a staged
comparison experiment:

1. run the same initial Hierarchical Harness setup as the no-Pro arm;
2. inject an external Pro construction/proof packet as an official upper-level
   input event, analogous to a human expert intervention;
3. let upper and middle agents decide how to translate that packet into proof
   leaves, candidate mutations, and executable-export tasks;
4. accept or plot the construction only after this task's own Lean declarations
   prove the corresponding block-entry, unitarity, and resource claims.

The Pro packet is not part of the initial task assumptions.  It is a mid-run
input artifact located at:

```text
task-inbox/QBE-MAIN-CASE-HIER-PRO-001/pro_construction_packet.md
```

To reproduce the intervention point, append it to the current run dialogue
after the first ordinary cycle:

```bash
python3 tools/qbe.py agent-note latest \
  --role upper \
  --file task-inbox/QBE-MAIN-CASE-HIER-PRO-001/pro_construction_packet.md
```

## External Pro Construction Packet

The packet proposes an equality flag for the source subspace `T = k` and
`tau = 1`, a controlled transfer to `T = 0`, `tau = 0`, and a final ancilla
flip.  For the concrete bit order `bit 0 = tau`, `bit 1 = T`, `bit 2 = a`,
the proposed four-gate transcript is:

```text
CCX012; CX21; CX20; X2
```

The packet also records the previously observed mutation target
`CCX012; {X0, X1, X2}` as a historical endpoint to reproduce or improve, not
as a theorem available to this isolated task.

## Textbook-Memory Guidance

Upper agents should compare the Pro hint against the partial-permutation and
entrywise clean-block textbook leaves.  The Pro hint should be translated into
a candidate permutation/function only if it preserves the exact target and
does not introduce hidden oracle calls.

## Post-Lean Executable Exports

- Requested targets: `qiskit,qasm3`
- Export policy: Lean-first.  Generate executable code only after a named Lean
  declaration proves the advertised block-encoding theorem at the task's
  semantic tier.
- Concrete export instantiation: `r=1,k=1,passiveQubits=1`
- Expected artifact root: `executable-exports/QBE-MAIN-CASE-HIER-PRO-001/`

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
python3 tools/qbe.py trial-log --task QBE-MAIN-CASE-HIER-PRO-001 --role lower --kind attempt --status running --notes "starting construction search"
python3 tools/qbe.py trial-summary
```
````

## Dynamic Leaf Queue

These are the current local proof or repair candidates.  Lower agents should
work on one item at a time; if an item is stale, upper/middle must retire it
before spending more proof-search tokens.

| Leaf | Status |
|---|---|
| MAINCASE-PRO-CIRCUIT-IMAGE-001: Prove the Pro transcript realizes the current task-local image, or split the finite-permutation candidate from a corrected gate-derived candidate.; status: active leaf; Lean: none yet | candidate |
| MAINCASE-PRO-EXPORT-001: Prepare Qiskit and QASM3 packets only after the accepted Lean semantic tier is named.; status: blocked on export policy; Lean: none yet | candidate |

## Open Obligation Signals

```text
# Proof Obligations: QBE-MAIN-CASE-HIER-PRO-001
| Obligation | Lean declaration or artifact | Status |
| Pro four-gate transcript realizes the advertised image/resource layer | no task-local theorem yet; proposed leaf `MAINCASE-PRO-CIRCUIT-IMAGE-001` | active contract-alignment obligation |
| full matrix rational-orthogonality bridge | `mainCaseProRationalOrthogonalBridgeObligation` | active obligation |
| `MAINCASE-PRO-ORTHO-BRIDGE-001` | Shared rational-orthogonality theorem for permutation matrices. | `MAINCASE-PRO-PERM-UNITARY-001` | lower 2/refiner | `mainCaseProRationalOrthogonalBridgeObligation` | verifier feedback | `python3 tools/qbe.py check` | queued after circuit-image alignment |
## Next Lean Leaf
The next useful implementation leaf is `MAINCASE-PRO-CIRCUIT-IMAGE-001`.
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
| `tasks/QBE-MAIN-CASE-HIER-PRO-001.md` | task/proof map |
| `conversion-windows/QBE-MAIN-CASE-HIER-PRO-001.md` | Lean/natural-language conversion |
| `proof-obligations/QBE-MAIN-CASE-HIER-PRO-001.md` | open obligations |

## Latest Dialogue Signal

````text
rt
intervention or a ChatGPT Pro answer pasted into the ABEIS loop after the
ordinary harness has already started.  It is not a theorem and not a certified
candidate.  ABEIS may use it only by translating it into Lean declarations and
then proving the advertised block-entry, unitarity, and resource claims.

## Target

For `r = 1`, `k = 1`, and one passive state qubit, the target is

$$
E_1
=
|0\rangle\langle 1|_T
\otimes
|0\rangle\langle 1|_\tau
\otimes I_S .
$$

The required clean block is

$$
(\langle 0|_a \otimes I)\,U\,(|0\rangle_a\otimes I)=E_1 .
$$

## Pro Construction Idea

Use a single block-encoding ancilla `a`.

1. Compute an equality flag for the source subspace `T = k` and `tau = 1`.
   For the concrete benchmark `k = 1`, this is a Toffoli-style operation
   controlled by `T = 1` and `tau = 1`, targeting `a`.
2. When `a = 1`, transfer the selected active source basis state
   `|T=1, tau=1>` to the target basis state `|T=0, tau=0>`.
3. Flip the ancilla at the end so that the selected branch returns to the
   clean `a = 0` block and all unselected clean inputs are sent outside that
   block.

In the previously used reduced bit order

```text
bit 0 = type tau
bit 1 = time T
bit 2 = block ancilla a
```

the Pro construction is the four-gate transcript

```text
CCX(type,time;aux); CX(aux,time); CX(aux,type); X(aux)
```

or, in compact gate names,

```text
CCX012; CX21; CX20; X2
```

## Expected Proof Shape

The proof should be entrywise, not by informal circuit drawing.

For every passive state `s`:

- source branch:

  ```text
  |a=0, T=1, tau=1, s>
    -> |a=0, T=0, tau=0, s>
  ```

- non-source clean branches:

  ```text
  |a=0, T,tau,s> with (T,tau) != (1,1)
    -> a = 1 branch
  ```

Therefore the clean block has entry `1` exactly from active source
`(T,tau)=(1,1)` to active target `(T,tau)=(0,0)`, and entry `0` elsewhere.
The passive `S` register is unchanged, giving the tensor factor `I_S`.

## Expected Resource Claim

At the logical `{X, CNOT, Toffoli}` tier, before any later mutation, the Pro
construction has

```text
(gateCount, depth, auxiliaryQubits, oracleCalls) = (4, 4, 1, 0)
```

ABEIS may try to mutate or simplify it.  In the previous successful run, a
mutation/collaboration step found the depth-2 variant

```text
CCX012; {X0, X1, X2}
```

with score

```text
(gateCount, depth, auxiliaryQubits, oracleCalls) = (4, 2, 1, 0)
```

This previous endpoint is included only so the new isolated run can be checked
against the old result.  The current task must reproduce or improve it under
its own declarations and build gate.

## Acceptance Rule

The packet may guide the upper/middle plan immediately after injection.  It is
not accepted until Lean proves:

1. the candidate image/function is a permutation or the candidate matrix is
   unitary at the chosen semantic tier;
2. the clean block equals the target `E_1`;
3. the resource tuple is stated and checked;
4. any Qiskit/QASM export is generated only after the named Lean certificate.
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

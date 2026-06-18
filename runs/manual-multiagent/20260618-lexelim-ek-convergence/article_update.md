# Project Article Update: QBE-OP-OPTCTRL-001 cycle 1

Generated: `2026-06-18 20:23:41`

Run directory: `runs/manual-multiagent/20260618-lexelim-ek-convergence`

Task title: Operator of optimal control paper

This file is the article-facing update packet for the technical report
`Auto-Lean-in-Sleep: Block Encoding for Quantum Computing`.  It is written at
the end of an active proof cycle so the project paper can track what the Lean
system actually proved, failed, or learned.  It is not a polished manuscript
section; middle agents should fold stable claims into
the ABEIS technical report directory only when the claims are supported by
Lean declarations, source anchors, or explicit obligations.

## Article-facing delta

- Keep the main system claim: ABEIS is an auto-proof harness for turning quantum oracle assumptions into Lean-checked block-encoding/circuit certificates.
- Update the generated appendix with the current optimal-control construction status: concrete logical reversible permutation-matrix certificate `evolvedEqFlipVerified`, comparison tuple `(4,2,1,0)`, and the remaining generalization/hardware/lower-bound obligations.
- Do not replay the full population history in Overleaf; keep history in `candidate-populations/` and verifier-feedback packets.
- State the semantic tier precisely: concrete `r=1,k=1` logical `{X,CNOT,Toffoli}` permutation-matrix BE, not a hardware-decomposed or general-family theorem.
- State the certified-population rule: only candidates with named Lean certificates can be evolutionary parents or plotted solution points; Pro/Python/simulator ideas stay in the insight pool until Lean promotes them.

## Lean status signal

- `QuantumBlockEncoding/RobinMatrix.lean:26968:  sorry`
- `QuantumBlockEncoding/RobinMatrix.lean:26998:  sorry`

## Plain-language status for readers

This cycle is an exploratory block-encoding construction task.  The target is the concrete optimal-control transfer operator E_1.  The current report should state the best Lean-certified concrete logical reversible permutation-matrix block encoding, its resource score, and the remaining generalization, lower-bound, and hardware-decomposition obligations.

## Current construction status

### Current construction status: `QBE-OP-OPTCTRL-001`

Task title: Operator of optimal control paper

Current concrete logical BE certificate: `OptimalControl.evolvedEqFlipVerified`.

- Target: concrete `E_1 = |0><1|_time ⊗ |0><1|_type ⊗ I_state` with one time bit, one type bit, one passive state bit, and one block-encoding auxiliary bit.
- Lean certificates: `evolvedEqFlipVerified`, `evolvedEqFlipUnitary_isRationalOrthogonal`, `evolvedEqFlipUnitary_cleanBlock`, `evolvedEqFlipGateImages_eval`, `evolvedEqFlipCandidate_cost`, and `exampleOperator_not_rationalOrthogonal`.
- Certified logical record fields: `depth = 2`, `gateCount = 4`, `auxiliaryQubits = 1`, `oracleCalls = 0`; comparison tuple `(gateCount, depth, auxiliaryQubits, oracleCalls) = (4, 2, 1, 0)` in the concrete `{X,CNOT,Toffoli}` logical reversible permutation-matrix tier.
- Finite verifier convergence signal: exact enumeration of the reduced three-bit `{X,CNOT,Toffoli}` orientation library found no clean-block candidate with at most 3 gates and no depth-1 layered candidate with at most 4 gates; the depth-2 witness matches `evolvedEqFlipVerified`.
- Scope: finite-verifier-converged for this concrete `r=1,k=1` logical-library instance, with the zero-auxiliary whole-matrix obstruction closed; not yet generalized to arbitrary time width/state dimension, not hardware-decomposed, and not a Lean-proved depth lower bound.
- Plot policy: plotted points must name rational-orthogonal matrix and clean-block Lean certificates at this semantic tier.
- Next manuscript-facing action: state the concrete certificate and list the generalization, hardware-decomposition, and lower-bound obligations.

Latest human-readable cycle summary in the project run artifacts: `runs/manual-multiagent/20260618-lexelim-ek-convergence/summary.md`.
Candidate population ledger in the project repository: `candidate-populations/QBE-OP-OPTCTRL-001.md`.

## Pre-Lean verifier candidates

These checks are necessary-condition filters, not proofs.  They are useful
because a failing exact finite check usually means the Lean target, circuit
transcript, or index map is wrong.  A passing check only means the candidate
survived this cheaper test; the final claim still needs a Lean theorem.

| proof part | fast check | why this is a necessary condition | what Lean still proves |
| --- | --- | --- | --- |
| active [0,0] entry | exact rational matrix or path-sum evaluation | if the exact finite entry is not the target coefficient, the Lean equality for that entry cannot be true | a passing check is only a counterexample filter; Lean must still prove the named entry lemma |
| remaining branch vanish/cancel | support and path checker for the remaining backend slots | if an unwanted clean-branch path survives numerically, the block projection cannot match the paper target | Lean must still prove the zero/cancellation lemma in the formal circuit semantics |
| Ry boundary convention | symbolic 2-by-2 rotation check | a mismatched half-angle convention changes the boundary amplitude before any Lean tactic is relevant | Lean must still record the convention bridge as a source-supported theorem |
| sparse-access map | finite range/injectivity/permutation check | a reversible oracle cannot exist for a colliding or out-of-range finite map | Lean must still prove the reversible extension and cleanup obligations |
| coefficient oracle clean branch | exact finite evaluator for f(x_i)/N_f | the final block entry uses this coefficient, so a wrong clean branch invalidates the target theorem | Lean must still prove bounds, orthogonality, and unitary completion or keep them as contracts |

## Current proof-DAG frontier

- No dynamic leaf was detected; refresh the proof blueprint before the next run.

## Open obligation signal

- No compact obligation signal was detected; inspect `proof-obligations/` directly.

## Open current-task contribution obligations

_Not applicable to this task._

## Open current-task cited-contract obligations

_No task-specific cited-contract obligations were detected by the compact memory layer._

## Recent typed verifier feedback

| leaf | class | finite | entry | next |
| --- | --- | --- | --- | --- |
| lexelim-convergence-finite-search-20260618 | manual-packet |  |  |  |
| pro-construction-search | manual-packet |  |  |  |
| evolved-cleanblock-search | manual-packet |  |  |  |
| reduced-depth-search | manual-packet |  |  |  |

## Recent proof-attempt memory

- No proof-attempt files were found for this task.

## Suggested project-paper edits

| Report location | Safe update |
|---|---|
| `main/evidence.tex` | Mention the concrete explore-mode improvement only as process evidence and name the Lean declarations supporting it. |
| `main/lean_platform.tex` | Note that candidate populations can optimize over non-unique unitary completions, with Lean checking clean-block equality. |
| `appendix/generated_cycle_status.tex` | This file is overwritten automatically and should show only the latest current construction status. |
| Figures/tables | Reuse the PNG only as a certified concrete logical BE curve; label it clearly as not hardware-decomposed and not generalized.  Never plot insight-pool proposals as achieved points. |

## Do not claim

- Do not claim a generalized optimal-control theorem while the construction is only proved for the concrete `r=1,k=1` finite instance.
- Do not claim hardware-gate optimality before choosing and proving a hardware decomposition/resource model.
- Do not treat finite verifier scores or population-search convergence as mathematical optimality theorems.
- Do not use unverified Pro/Python/simulator proposals as evolutionary parents; they are insight-pool records until Lean certificates promote them.

## Dialogue tail

```text
ean anchors are:

- `OptimalControl.evolvedEqFlipVerified`;
- `OptimalControl.evolvedEqFlipUnitary_isRationalOrthogonal`;
- `OptimalControl.evolvedEqFlipUnitary_cleanBlock`;
- `OptimalControl.evolvedEqFlipGateImages_eval`;
- `OptimalControl.evolvedEqFlipCandidate_cost`;
- `OptimalControl.evolvedEqFlipCost_betterThan_pro`;
- `OptimalControl.evolvedEqFlipCost_betterThan_depth5`.

`python3 tools/qbe.py check` passes.  Remaining repository `sorry`s are in
the separate GHL RobinMatrix track, not this target.

## lower-3-necessary-condition-verifier

Exact enumeration over the full reduced three-bit `{X,CNOT,Toffoli}` logical
library found:

- no correct clean-block candidate with at most 3 gates;
- 36 ordered correct candidates with exactly 4 gates;
- no depth-1 layered candidate with at most 4 gates;
- one depth-2 layered witness matching the champion: `CCX012` followed by
  parallel `{X0,X1,X2}`.

## reviewer

Accept convergence only at the stated concrete logical-library tier.  The
project may say:

```text
For r=1,k=1 and the full three-bit logical {X,CNOT,Toffoli} library, the
current Lean-certified champion has score (4,2,1,0), and an exact finite
verifier found no gate-count <4 or depth-1 candidate in that library.
```

The project must not say that it has a hardware-level optimum, a theorem for
all `k`, or a Lean-formalized lower-bound theorem unless those are later
proved.
```

## Current changed files

- `MANIFEST.md`
- `QuantumBlockEncoding/Automation.lean`
- `README.md`
- `candidate-populations/QBE-OP-OPTCTRL-001-metrics.csv`
- `candidate-populations/QBE-OP-OPTCTRL-001.md`
- `docs/agent_orchestration.md`
- `docs/assets/optctrl_depth5.png`
- `docs/assets/optctrl_evolution.png`
- `docs/assets/optctrl_evolved.png`
- `docs/assets/optctrl_oracle_baseline.png`
- `docs/assets/optctrl_pro.png`
- `docs/attribution.md`
- `docs/automation_deployment.md`
- `docs/lexelim_scheduler_notes.md`
- `paper-notes/problem-exports/QBE-OP-OPTCTRL-001/20260618-lexelim-ek-convergence.tex`
- `paper-notes/problem-exports/QBE-OP-OPTCTRL-001/latest.tex`
- `paper-notes/project-paper/cycle-updates/20260618-lexelim-ek-convergence.md`
- `paper-notes/project-paper/cycle-updates/20260618-lexelim-ek-convergence.tex`
- `paper-notes/project-paper/cycle-updates/latest.md`
- `paper-notes/project-paper/cycle-updates/latest.tex`
- `research-wiki/retrieval-index/QBE-OP-OPTCTRL-001.json`
- `runs/manual-multiagent/20260618-lexelim-ek-convergence/`
- `tools/qbe.py`
- `verifier-feedback/QBE-OP-OPTCTRL-001/lexelim-convergence-finite-search-20260618.md`

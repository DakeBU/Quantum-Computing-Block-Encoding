# Proof Blueprint: QBE-OP-OPTCTRL-001

Task id: `QBE-OP-OPTCTRL-001`
Title: Operator of optimal control paper
Mode: `operatorBlockEncoding`
Updated: `2026-06-19 02:55`
Blueprint stage: `operator construction / Stage 2 DAG discharge for passive-state generalization`

This is the compact system-of-record snapshot for the current OPTCTRL cycle.
The fixed operator target is
$E_1 := |0\rangle\langle 1|_\mathrm{time} \otimes
|0\rangle\langle 1|_\mathrm{type} \otimes I_\mathrm{state}$ with normalizer
`alpha = 1` and one clean signal auxiliary.  The concrete depth-2 logical
candidate is already compiled for one passive state bit; the active objective
is to lift that construction to arbitrary positive passive state dimension.

## Current Directive

```text
Objective: passive-state generalization for the already compiled evolvedEqFlip
E1 block encoding.  Define E1 tensor I_state, a passive-preserving lift of the
reduced active permutation, and the clean-block theorem for arbitrary passive
dimension while preserving alpha=1, a=1, and logical score (4,2,1,0).

Do not reopen approximate search, route ablation, GHL/Robin work, hardware
transpilation, or arbitrary-k generalization in this cycle.
```

## Dynamic Leaf Queue

| Leaf | Status |
|---|---|
| `passive-target` | active leaf: define $E_1 \otimes I_d$ on `Fin (4 * stateDim)` with row branch `0`, column branch `3`, and equal passive index |
| `passive-lift` | active leaf: define quotient/remainder views and lift `Fin 8 -> Fin 8` to `Fin (8 * stateDim)` while preserving passive state |
| `passive-clean-block` | active leaf: prove the clean block of lifted `evolvedEqFlipImage` equals the passive target |
| `passive-state-finite-diagnostic` | verifier leaf: check passive dimensions `1`, `2`, and `4` before broad symbolic proof search |
| `passive-resource` | pending: record that the active logical circuit keeps score `(4,2,1,0)` after the clean-block theorem |
| `direct-route-ablation-E1` | stale: already compiled as `OptimalControl.directRouteAblation_cleanBlock` |
| `fixed-exampleImage-completion` | stale: corrected acceptance predicate is clean-block equality, not equality of non-clean completion data |
| `approximate-search` | stale for this cycle: no cheaper approximate candidate or precise norm target is active |

## Proof-DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `root-passive-state-family-r1-k1` | exact block encoding of $E_1 \otimes I_d$ for all positive passive dimensions | `passive-target`, `passive-lift`, `passive-clean-block`, `passive-resource` | middle/reviewer | planned theorem packaging | `conversion-windows/QBE-OP-OPTCTRL-001.md` | `python3 tools/qbe.py check` | active root |
| `active-reduced-circuit` | `CCX(type,time;aux); X(type); X(time); X(aux)` implements `evolvedEqFlipImage` | none | closed | `OptimalControl.evolvedEqFlipGateImages_eval` | candidate population Gen 7 | compiled | proved |
| `active-reduced-permutation` | reduced active map is a permutation | none | closed | `OptimalControl.evolvedEqFlipImage_isPermutation` | candidate population Gen 7 | compiled | proved |
| `concrete-clean-block` | one-state-bit clean block equals `exampleOperator` | `active-reduced-circuit` | closed | `OptimalControl.evolvedEqFlipUnitary_cleanBlock` | candidate population Gen 7 | compiled | proved |
| `passive-target` | define target $E_1 \otimes I_d$ | quotient/remainder layout | lower 2 | planned `OptimalControl.passiveTargetOperator` | conversion window Symbol Map | `lake build Tests` | active leaf |
| `passive-lift` | lift active reduced map while preserving passive index | quotient/remainder layout | lower 2 | planned `OptimalControl.liftReducedImagePassive` | conversion window Lean Contract | `lake build Tests` | active leaf |
| `passive-clean-block` | prove clean block of the passive lift equals `passiveTargetOperator` | `passive-target`, `passive-lift`, active branch table | lower 2 | planned `OptimalControl.evolvedEqFlipPassive_cleanBlock` | conversion window Proof Map | `lake build Tests` | active leaf |
| `passive-state-finite-diagnostic` | finite checks for passive dimensions `1`, `2`, `4` | layout choice | lower 3 | verifier packet, not a theorem | `verifier-feedback/QBE-OP-OPTCTRL-001/` | diagnostic only | active verifier leaf |

## Open Obligation Signals

```text
passive-target: Lean target planned but unproved.
passive-lift: Lean target planned but unproved.
passive-clean-block: Lean target planned but unproved.
passive-resource: pending after clean-block theorem.
general time width and arbitrary k: later task, not this cycle.
hardware decomposition: later task, not this cycle.
```

## Lean Declaration Index

Recent task-relevant declarations:

| Kind | Lean name | File |
|---|---|---|
| def | `OptimalControl.exampleOperator` | `QuantumBlockEncoding/OptimalControl.lean:48` |
| def | `OptimalControl.cleanIndex` | `QuantumBlockEncoding/OptimalControl.lean:58` |
| def | `OptimalControl.reducedOfFull` | `QuantumBlockEncoding/OptimalControl.lean:248` |
| def | `OptimalControl.stateOfFull` | `QuantumBlockEncoding/OptimalControl.lean:252` |
| def | `OptimalControl.liftReducedImage` | `QuantumBlockEncoding/OptimalControl.lean:256` |
| def | `OptimalControl.unitaryFromReducedImage` | `QuantumBlockEncoding/OptimalControl.lean:281` |
| def | `OptimalControl.CleanBlockE1` | `QuantumBlockEncoding/OptimalControl.lean:285` |
| def | `OptimalControl.evolvedEqFlipImage` | `QuantumBlockEncoding/OptimalControl.lean:399` |
| theorem | `OptimalControl.evolvedEqFlipImage_isPermutation` | `QuantumBlockEncoding/OptimalControl.lean:403` |
| theorem | `OptimalControl.evolvedEqFlipFull_isPermutation` | `QuantumBlockEncoding/OptimalControl.lean:409` |
| theorem | `OptimalControl.evolvedEqFlip_cleanBlock` | `QuantumBlockEncoding/OptimalControl.lean:415` |
| theorem | `OptimalControl.evolvedEqFlipUnitary_cleanBlock` | `QuantumBlockEncoding/OptimalControl.lean:527` |
| theorem | `OptimalControl.evolvedEqFlipGateImages_eval` | `QuantumBlockEncoding/OptimalControl.lean:686` |
| def | `OptimalControl.evolvedEqFlipVerified` | `QuantumBlockEncoding/OptimalControl.lean:808` |
| def | `OptimalControl.evolvedEqFlipZeroErrorApprox` | `QuantumBlockEncoding/OptimalControl.lean:823` |
| theorem | `OptimalControl.evolvedEqFlipCandidate_cost` | `QuantumBlockEncoding/OptimalControl.lean:828` |
| theorem | `OptimalControl.directRouteAblation_cleanBlock` | `QuantumBlockEncoding/OptimalControl.lean:910` |
| theorem | `OptimalControl.directRouteAblationResourceTuple_eq` | `QuantumBlockEncoding/OptimalControl.lean:948` |

## Correspondence Artifacts

| Artifact | Role |
|---|---|
| `tasks/QBE-OP-OPTCTRL-001.md` | task contract and certified-generation memory |
| `conversion-windows/QBE-OP-OPTCTRL-001.md` | Lean/natural-language conversion and lower packets |
| `proof-obligations/QBE-OP-OPTCTRL-001.md` | active obligation ledger |
| `candidate-populations/QBE-OP-OPTCTRL-001.md` | certified population and stale-route memory |
| `research-wiki/retrieval-index/QBE-OP-OPTCTRL-001.json` | compact retrieval index |
| `runs/20260619-024155-QBE-OP-OPTCTRL-001-cycle01/dialogue.md` | run-local handoff board |
| `runs/20260619-024155-QBE-OP-OPTCTRL-001-cycle01/todo.md` | lower-agent packet for this cycle |
| `runs/20260619-024155-QBE-OP-OPTCTRL-001-cycle01/memory_digest.md` | run-local compact memory |

## Gate Policy

- Lower agents work on one active leaf at a time and must not change the fixed
  operator target, normalizer, or clean projector.
- Lower 1 writes the natural-language dependency proof before lower 2 broadens
  the Lean proof search.
- Lower 2 edits only `QuantumBlockEncoding/OptimalControl.lean` and
  `Tests/Basic.lean` for this cycle.
- Lower 3 records necessary-condition feedback for passive dimensions `1`,
  `2`, and `4`; diagnostics guide search but do not prove theorem closure.
- Reviewer accepts progress only through `python3 tools/qbe.py check` and a
  synchronized Lean-to-natural-language proof status.

# Dialogue: QBE-OP-OPTCTRL-001 LexElim convergence run

This run treats the live chat with the human expert as the external
human-interaction top module.  The agents below are role-separated decisions
from the formal convergence audit after the top module corrected the resource
order to:

```text
asymptotic tier first, then gateCount, depth, auxiliaryQubits, oracleCalls
```

## upper-control

Use `LexElim-In`, not scalar scoring.  Because this is an exploratory
operator-construction task with one already-certified champion, run one upper
decision panel, one middle memory/correspondence panel, three lower roles, and
one reviewer:

- lower 1: natural-language proof architect;
- lower 2: Lean certificate auditor;
- lower 3: finite necessary-condition verifier.

Do not promote or plot any candidate that lacks a Lean certificate at the
declared semantic tier.

## upper-domain

The target is the concrete transfer operator

```text
E_1 = |0><1|_time ⊗ |0><1|_type ⊗ I_state
```

in the current one-time-qubit, one-type-qubit, one-state-qubit Lean instance.
The current champion is the evolved equality-flag/parallel-flip circuit:

```text
CCX(type,time -> aux); then X_type, X_time, X_aux in parallel
```

Its Lean-certified score is `(gateCount, depth, auxiliaryQubits, oracleCalls)
= (4, 2, 1, 0)`.

## middle-memory

The certified population contains:

- depth-5 logical completion, dominated;
- Pro equality-transfer construction, dominated but useful parent memory;
- evolved equality-flag/parallel-flip construction, current champion.

The insight pool may keep zero-auxiliary and two-ancilla ideas, but they cannot
serve as parents until Lean-certified.  The zero-auxiliary whole-matrix route
is already rejected by `OptimalControl.exampleOperator_not_rationalOrthogonal`.

## lower-1-natural-language-proof-architect

The champion proof is short:

1. `CCX012` writes the selected branch `(type,time)=(1,1)` into the auxiliary.
2. The parallel layer `{X0,X1,X2}` sends the selected clean source
   `aux=0,type=1,time=1` to `aux=0,type=0,time=0`.
3. Every other clean input branch has auxiliary `1` after the parallel layer,
   so it vanishes under the clean left projection.
4. The passive state bit is lifted unchanged, giving tensor factor `I_state`.

## lower-2-lean-certificate-auditor

The current Lean anchors are:

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

# Lean4Agent Process Verification Notes

Reference paper:
[Lean4Agent: Formal Modeling and Verification for Agent Workflow and
Trajectory](https://arxiv.org/abs/2606.06523)

## Core Lesson

Lean4Agent argues that an agent workflow can itself be a formal object.  It
separates:

- structural workflow checks: nodes, edges, reads, writes, and reachability;
- semantic workflow checks: preconditions and postconditions for each step;
- trajectory checks: after a run, localize the step whose actual result broke
  the workflow contract.

ABEIS uses this idea only at the orchestration layer.  It never replaces the
Lean proof of a block-encoding theorem.

## ABEIS Adaptation

ABEIS already has a compiled Lean file,
`QuantumBlockEncoding/Automation.lean`, that records role types, task kinds,
acceptance gates, post-cycle artifacts, and workflow check specifications.
This is the first process-contract layer.

The current practical rules are:

- a candidate can enter the certified population only after the Lean theorem
  closes;
- a Pro answer, Python diagnostic, QASM check, or simulator output can enter
  only the insight pool until Lean promotes it;
- every long run must write a Chinese human summary and a self-contained Pro
  prompt if the task remains unfinished;
- inner cycles maintain Lean/natural-language correspondence, while LaTeX
  proof export is a closeout artifact.

## Not Yet Implemented

ABEIS does not yet prove a theorem over the JSON/Markdown run logs.  The
planned next step is a lightweight `WorkflowCertificate` layer:

1. parse a compact retrieval index;
2. prove required artifact paths exist in the generated manifest model;
3. prove no stale route was reassigned unchanged after reviewer rejection;
4. prove no uncertified candidate is plotted or used as a parent.

Those checks would make the harness more reliable, but they would still be
process checks.  Mathematical correctness remains the block-encoding theorem.


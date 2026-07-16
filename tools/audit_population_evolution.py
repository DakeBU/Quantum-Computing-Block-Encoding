#!/usr/bin/env python3
"""Deterministic cold-start replay for the ABEIS typed population gate."""

from __future__ import annotations

import argparse
import json
from pathlib import Path

try:
    from qbe_control import decide_cycle
except ModuleNotFoundError:
    from tools.qbe_control import decide_cycle


ROOT = Path(__file__).resolve().parents[1]


def proposed_feedback(prefix: str) -> list[dict[str, object]]:
    return [
        {
            "trial_id": f"{prefix}-review-select-a",
            "role": "reviewer",
            "candidate_id": f"{prefix}-a",
            "population_action": "select",
            "fitness_evidence": "best current named support leaf",
        },
        {
            "trial_id": f"{prefix}-middle-propose-b",
            "role": "middle",
            "candidate_id": f"{prefix}-b",
            "candidate_family": "independent alternative",
            "population_action": "propose",
            "fitness_evidence": "distinct finite diagnostic",
        },
        {
            "trial_id": f"{prefix}-middle-propose-a",
            "role": "middle",
            "candidate_id": f"{prefix}-a",
            "candidate_family": "retrieved exact route",
            "population_action": "propose",
            "fitness_evidence": "named compiled support leaf",
        },
    ]


def evolved_feedback(prefix: str) -> list[dict[str, object]]:
    return [
        {
            "trial_id": f"{prefix}-review-select-child",
            "role": "reviewer",
            "candidate_id": f"{prefix}-child",
            "population_action": "select",
            "fitness_evidence": "parents cover complementary obligations",
        },
        {
            "trial_id": f"{prefix}-middle-retire-b",
            "role": "middle",
            "candidate_id": f"{prefix}-b",
            "population_action": "retire",
            "fitness_evidence": "subsumed by selected child",
        },
        {
            "trial_id": f"{prefix}-middle-retire-a",
            "role": "middle",
            "candidate_id": f"{prefix}-a",
            "population_action": "retire",
            "fitness_evidence": "stalled parent retained in history only",
        },
        {
            "trial_id": f"{prefix}-middle-cross-child",
            "role": "middle",
            "candidate_id": f"{prefix}-child",
            "candidate_family": "recombined exact route",
            "population_action": "crossover",
            "parent_ids": f"{prefix}-a,{prefix}-b",
            "fitness_evidence": "new ready leaf after recombination",
        },
        *proposed_feedback(prefix),
    ]


def replay(task_kind: str, prefix: str) -> dict[str, object]:
    row = f"{prefix.upper()}-L1: one exact leaf; status: active next; Lean: {prefix}Leaf"
    initial = decide_cycle(
        task_id=f"AUDIT-{prefix}",
        cycle=1,
        frontier_rows=[row],
        obligation_rows=[],
        feedback=[],
        evidence_digest="lean-cold-start",
        task_kind=task_kind,
        population_gate_required=True,
    )
    selected = decide_cycle(
        task_id=f"AUDIT-{prefix}",
        cycle=2,
        frontier_rows=[row],
        obligation_rows=[],
        feedback=proposed_feedback(prefix),
        evidence_digest="lean-cold-start",
        task_kind=task_kind,
        population_gate_required=True,
    )
    stalled = decide_cycle(
        task_id=f"AUDIT-{prefix}",
        cycle=3,
        frontier_rows=[row],
        obligation_rows=[],
        feedback=proposed_feedback(prefix),
        evidence_digest="lean-cold-start",
        previous_state={**selected.to_dict(), "execution_started": True},
        max_no_progress_cycles=2,
        task_kind=task_kind,
        population_gate_required=True,
    )
    evolved = decide_cycle(
        task_id=f"AUDIT-{prefix}",
        cycle=4,
        frontier_rows=[row],
        obligation_rows=[],
        feedback=evolved_feedback(prefix),
        evidence_digest="lean-cold-start",
        previous_state={**stalled.to_dict(), "execution_started": True},
        max_no_progress_cycles=2,
        task_kind=task_kind,
        population_gate_required=True,
    )
    expected = {
        "initial_mode": "population",
        "selected_mode": "execute",
        "stalled_mode": "population",
        "evolved_mode": "execute",
        "evolved_direction": f"{prefix}-child",
    }
    actual = {
        "initial_mode": initial.mode,
        "selected_mode": selected.mode,
        "stalled_mode": stalled.mode,
        "evolved_mode": evolved.mode,
        "evolved_direction": evolved.population_direction,
    }
    return {
        "task_kind": task_kind,
        "expected": expected,
        "actual": actual,
        "passed": actual == expected,
        "lower_scheduling": {
            "initial": list(initial.prompt_plan),
            "selected": list(selected.prompt_plan),
            "stalled": list(stalled.prompt_plan),
            "evolved": list(evolved.prompt_plan),
        },
        "active_after_evolution": list(evolved.population_active_candidate_ids),
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--output",
        default="reports/ABEIS-CONTROL-V5/cold-start-population-audit.json",
    )
    args = parser.parse_args()
    rows = [
        replay("statePreparation", "stateprep"),
        replay("operatorBlockEncoding", "blockencoding"),
    ]
    payload = {
        "scope": "deterministic controller replay; not a mathematical synthesis benchmark",
        "invariant": "no lower call before selection; stagnation returns to typed evolution; changed population reopens one ordered lower attempt",
        "rows": rows,
        "passed": all(row["passed"] for row in rows),
    }
    output = ROOT / args.output
    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    print(json.dumps(payload, indent=2, sort_keys=True))
    if not payload["passed"]:
        raise SystemExit(1)


if __name__ == "__main__":
    main()

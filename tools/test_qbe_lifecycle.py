#!/usr/bin/env python3

from __future__ import annotations

import json
import tempfile
import unittest
from pathlib import Path

try:
    from qbe_lifecycle import (
        executable_contract_digest,
        lean_workspace_digest,
        resolve_task_lifecycle,
        shadow_replay,
    )
except ModuleNotFoundError:
    from tools.qbe_lifecycle import (
        executable_contract_digest,
        lean_workspace_digest,
        resolve_task_lifecycle,
        shadow_replay,
    )


def write_json(path: Path, payload: object) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(payload) + "\n", encoding="utf-8")


class LifecycleReplayTests(unittest.TestCase):
    def setUp(self) -> None:
        self.temporary = tempfile.TemporaryDirectory()
        self.root = Path(self.temporary.name)
        (self.root / "tasks").mkdir()
        (self.root / "runs" / "control").mkdir(parents=True)
        (self.root / ".qbe").mkdir()

    def tearDown(self) -> None:
        self.temporary.cleanup()

    def add_completed_task(self, task_id: str) -> None:
        (self.root / "tasks" / f"{task_id}.md").write_text("Status: `active`\n", encoding="utf-8")
        artifact = self.root / "executable-exports" / task_id / "acceptance.json"
        artifact.parent.mkdir(parents=True)
        artifact.write_text("{}\n", encoding="utf-8")
        exporter = self.root / "exporter.py"
        exporter.write_text("print('ok')\n", encoding="utf-8")
        command = "python3 exporter.py"
        artifacts = [f"executable-exports/{task_id}/acceptance.json"]
        write_json(
            self.root / "runs" / "control" / f"{task_id}.json",
            {
                "task_id": task_id,
                "status": "complete",
                "stop": True,
                "lean_acceptance_complete": True,
                "certified_root_anchors": ["Root.complete"],
                "executable_acceptance_required": True,
                "executable_acceptance_complete": True,
                "executable_acceptance_command": command,
                "executable_acceptance_artifacts": artifacts,
            },
        )
        write_json(
            self.root / "runs" / "control" / f"{task_id}-executable.json",
            {
                "exit_code": 0,
                "artifacts_present": True,
                "artifacts": artifacts,
                "input_digest": executable_contract_digest(
                    self.root, command, artifacts
                ),
            },
        )
        row = {
            "task_id": task_id,
            "trial_id": f"{task_id}-qiskit",
            "status": "accepted",
            "verifier_feedback": {
                "lean_build_ok": True,
                "qasm_acceptance_ok": True,
                "qiskit_acceptance_ok": True,
            },
        }
        with (self.root / "runs" / "trials.jsonl").open("a", encoding="utf-8") as handle:
            handle.write(json.dumps(row) + "\n")
        write_json(
            self.root / ".qbe" / "state.json",
            {
                "active_task": None,
                "last_check": {
                    "exit_code": 0,
                    "lean_workspace_digest": lean_workspace_digest(self.root),
                },
            },
        )

    def test_shadow_replay_keeps_completed_hard_cases_closed_and_flags_stale_status(self) -> None:
        cold = "HARD-COLD"
        hinted = "HARD-HINTED"
        active = "CUBIC-DIAGONAL"
        self.add_completed_task(cold)
        self.add_completed_task(hinted)
        (self.root / "tasks" / f"{active}.md").write_text("Status: `active`\n", encoding="utf-8")
        write_json(
            self.root / ".qbe" / "state.json",
            {
                "active_task": active,
                "last_check": {
                    "exit_code": 0,
                    "lean_workspace_digest": lean_workspace_digest(self.root),
                },
            },
        )
        (self.root / "HUMAN_STATUS.md").write_text(
            "Task: `OLD-STATEPREP` - stale\n", encoding="utf-8"
        )

        report = shadow_replay(self.root, [cold, hinted])
        lifecycle = {row["task_id"]: row["lifecycle"] for row in report["tasks"]}
        self.assertEqual(lifecycle[cold], "completed")
        self.assertEqual(lifecycle[hinted], "completed")
        self.assertEqual(lifecycle[active], "active")
        self.assertTrue(report["human_status_stale"])

    def test_missing_executable_artifact_prevents_false_completion(self) -> None:
        task_id = "HARD"
        self.add_completed_task(task_id)
        (self.root / "executable-exports" / task_id / "acceptance.json").unlink()
        rows = [json.loads(line) for line in (self.root / "runs" / "trials.jsonl").read_text().splitlines()]
        result = resolve_task_lifecycle(
            self.root,
            task_id,
            state={"active_task": "OTHER"},
            trial_rows=rows,
        )
        self.assertNotEqual(result["lifecycle"], "completed")
        self.assertFalse(result["evidence"]["executable_complete"])

    def test_stale_lean_gate_prevents_reusing_old_completion(self) -> None:
        task_id = "HARD"
        self.add_completed_task(task_id)
        lean = self.root / "QuantumBlockEncoding" / "Changed.lean"
        lean.parent.mkdir()
        lean.write_text("def changed : Nat := 1\n", encoding="utf-8")
        rows = [json.loads(line) for line in (self.root / "runs" / "trials.jsonl").read_text().splitlines()]
        result = resolve_task_lifecycle(
            self.root,
            task_id,
            state={"active_task": "OTHER"},
            trial_rows=rows,
        )
        self.assertNotEqual(result["lifecycle"], "completed")
        self.assertFalse(result["evidence"]["current_lean_gate"])

    def test_changed_exporter_prevents_reusing_old_qiskit_acceptance(self) -> None:
        task_id = "HARD"
        self.add_completed_task(task_id)
        (self.root / "exporter.py").write_text("print('changed')\n", encoding="utf-8")
        rows = [json.loads(line) for line in (self.root / "runs" / "trials.jsonl").read_text().splitlines()]
        result = resolve_task_lifecycle(
            self.root,
            task_id,
            state={"active_task": "OTHER"},
            trial_rows=rows,
        )
        self.assertNotEqual(result["lifecycle"], "completed")
        self.assertFalse(result["evidence"]["executable_complete"])

    def test_explicit_superseded_blocked_and_archived_states_are_distinct(self) -> None:
        (self.root / "tasks" / "OLD.md").write_text("Superseded by: `NEW`\n", encoding="utf-8")
        (self.root / "tasks" / "BLOCK.md").write_text("Lifecycle: `blocked`\n", encoding="utf-8")
        (self.root / "tasks" / "ARCH.md").write_text("Lifecycle: `archived`\n", encoding="utf-8")
        for task_id, expected in [("OLD", "superseded"), ("BLOCK", "blocked"), ("ARCH", "archived")]:
            result = resolve_task_lifecycle(
                self.root,
                task_id,
                state={"active_task": "NEW"},
                trial_rows=[],
            )
            self.assertEqual(result["lifecycle"], expected)


if __name__ == "__main__":
    unittest.main()

#!/usr/bin/env python3

from __future__ import annotations

import json
import os
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

try:
    from qbe_runtime import (
        append_jsonl_locked,
        atomic_write_json,
        file_lock,
        LockUnavailable,
        lock_path_for,
        semantic_route_fingerprint,
        update_json_locked,
    )
except ModuleNotFoundError:
    from tools.qbe_runtime import (
        append_jsonl_locked,
        atomic_write_json,
        file_lock,
        LockUnavailable,
        lock_path_for,
        semantic_route_fingerprint,
        update_json_locked,
    )


ROOT = Path(__file__).resolve().parents[1]


class CrossProcessRuntimeTests(unittest.TestCase):
    def test_concurrent_jsonl_appends_remain_complete_and_parseable(self) -> None:
        with tempfile.TemporaryDirectory() as raw:
            path = Path(raw) / "events.jsonl"
            code = """
import sys
from pathlib import Path
from tools.qbe_runtime import append_jsonl_locked
path = Path(sys.argv[1])
worker = int(sys.argv[2])
for index in range(40):
    append_jsonl_locked(path, {"worker": worker, "index": index, "payload": "x" * 200})
"""
            processes = [
                subprocess.Popen(
                    [sys.executable, "-c", code, str(path), str(worker)],
                    cwd=ROOT,
                )
                for worker in range(6)
            ]
            self.assertEqual([process.wait() for process in processes], [0] * 6)
            rows = [json.loads(line) for line in path.read_text(encoding="utf-8").splitlines()]
            self.assertEqual(len(rows), 240)
            self.assertEqual(
                {(row["worker"], row["index"]) for row in rows},
                {(worker, index) for worker in range(6) for index in range(40)},
            )

    def test_concurrent_atomic_json_writes_never_leave_partial_state(self) -> None:
        with tempfile.TemporaryDirectory() as raw:
            path = Path(raw) / "state.json"
            code = """
import sys
from pathlib import Path
from tools.qbe_runtime import atomic_write_json
path = Path(sys.argv[1])
worker = int(sys.argv[2])
for index in range(30):
    atomic_write_json(path, {"worker": worker, "index": index, "payload": "y" * 1000})
"""
            processes = [
                subprocess.Popen(
                    [sys.executable, "-c", code, str(path), str(worker)],
                    cwd=ROOT,
                )
                for worker in range(5)
            ]
            while any(process.poll() is None for process in processes):
                if path.exists():
                    json.loads(path.read_text(encoding="utf-8"))
            self.assertEqual([process.wait() for process in processes], [0] * 5)
            payload = json.loads(path.read_text(encoding="utf-8"))
            self.assertIn(payload["worker"], range(5))
            self.assertEqual(payload["index"], 29)

    def test_json_read_modify_write_does_not_lose_budget_updates(self) -> None:
        with tempfile.TemporaryDirectory() as raw:
            path = Path(raw) / "budget.json"
            code = """
import sys
from pathlib import Path
from tools.qbe_runtime import update_json_locked
path = Path(sys.argv[1])
for _ in range(50):
    update_json_locked(path, lambda row: {"tokens": int(row.get("tokens", 0)) + 1})
"""
            processes = [
                subprocess.Popen([sys.executable, "-c", code, str(path)], cwd=ROOT)
                for _ in range(5)
            ]
            self.assertEqual([process.wait() for process in processes], [0] * 5)
            self.assertEqual(json.loads(path.read_text())["tokens"], 250)

    @unittest.skipIf(os.name == "nt", "symlink creation may require elevated Windows privileges")
    def test_symlink_aliases_share_one_canonical_lock(self) -> None:
        with tempfile.TemporaryDirectory() as raw:
            root = Path(raw)
            target = root / "target.json"
            alias = root / "alias.json"
            target.write_text("{}\n", encoding="utf-8")
            alias.symlink_to(target)
            self.assertEqual(lock_path_for(target), lock_path_for(alias))

    def test_kernel_lock_recovers_after_holder_is_killed(self) -> None:
        with tempfile.TemporaryDirectory() as raw:
            path = Path(raw) / "task.lease"
            code = """
import sys, time
from pathlib import Path
from tools.qbe_runtime import file_lock
with file_lock(Path(sys.argv[1])):
    print("locked", flush=True)
    time.sleep(30)
"""
            process = subprocess.Popen(
                [sys.executable, "-c", code, str(path)],
                cwd=ROOT,
                text=True,
                stdout=subprocess.PIPE,
            )
            self.assertEqual(process.stdout.readline().strip(), "locked")
            process.kill()
            process.wait()
            process.stdout.close()
            with file_lock(path, timeout=1.0):
                pass

    def test_nonblocking_task_lease_rejects_duplicate_dispatch(self) -> None:
        with tempfile.TemporaryDirectory() as raw:
            path = Path(raw) / "task.lease"
            code = """
import sys, time
from pathlib import Path
from tools.qbe_runtime import file_lock
with file_lock(Path(sys.argv[1])):
    print("locked", flush=True)
    time.sleep(30)
"""
            process = subprocess.Popen(
                [sys.executable, "-c", code, str(path)],
                cwd=ROOT,
                text=True,
                stdout=subprocess.PIPE,
            )
            self.assertEqual(process.stdout.readline().strip(), "locked")
            with self.assertRaises(LockUnavailable):
                with file_lock(path, timeout=0):
                    pass
            process.kill()
            process.wait()
            process.stdout.close()


class RouteFingerprintTests(unittest.TestCase):
    def test_roles_and_free_form_notes_do_not_split_one_semantic_route(self) -> None:
        base = {
            "task_id": "T",
            "leaf_signature": "leaf-hash",
            "evidence_digest": "evidence-hash",
            "ready_leaf_ids": ["L1"],
            "search_phase": "exact",
            "effective_epsilon": "0",
        }
        first = {**base, "role": "upper", "notes": "first prose"}
        second = {**base, "role": "lower", "notes": "different prose"}
        self.assertEqual(
            semantic_route_fingerprint(first), semantic_route_fingerprint(second)
        )

    def test_tolerance_transition_changes_route_fingerprint(self) -> None:
        base = {
            "task_id": "T",
            "leaf_signature": "leaf-hash",
            "evidence_digest": "evidence-hash",
            "search_phase": "approximate",
        }
        first = {**base, "effective_epsilon": "1e-10"}
        second = {**base, "effective_epsilon": "1e-9"}
        self.assertNotEqual(
            semantic_route_fingerprint(first), semantic_route_fingerprint(second)
        )

    def test_feedback_only_route_has_a_stable_fingerprint(self) -> None:
        record = {
            "task_id": "T",
            "verifier_feedback": {
                "leaf": "BLOCK-PROJECTION",
                "error_class": "missing_dependency",
                "missing_dependency": "cleanAncillaBridge",
                "register_order": "ancilla,system",
                "alpha": "1",
            },
        }
        self.assertEqual(len(semantic_route_fingerprint(record)), 64)


if __name__ == "__main__":
    unittest.main()

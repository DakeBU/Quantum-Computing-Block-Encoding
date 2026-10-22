"""Model runner tests use local fixtures; no endpoint/model validation."""
from pathlib import Path
import copy
import sys
import tempfile
import unittest

BASE = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(BASE / "src"))
from qcb_runner import run
from qcb_core import prepare

class RunnerTests(unittest.TestCase):
    def config(self):
        return {"adapter": [sys.executable, "-c", "raise RuntimeError('must not run')"],
                "provider": "operator_adapter", "model": "UNMEASURED", "checkpoint": "UNMEASURED",
                "max_calls": 1, "max_input_tokens": 4000, "max_output_tokens": 100,
                "max_seconds": 5, "max_cost_usd": 1, "per_call_cost_ceiling_usd": 0.1,
                "max_input_bytes": 20000, "max_output_bytes": 5000, "exposure": "closed_book"}

    def test_dry_run_no_subprocess(self):
        with tempfile.TemporaryDirectory() as d:
            result = run([], self.config(), d, BASE)
            self.assertEqual(result["status"], "dry_run")
            self.assertFalse((Path(d) / "run.json").exists())

    def test_no_logs_under_public_tree(self):
        with self.assertRaises(ValueError):
            run([], self.config(), BASE / ".local/log", BASE)

    def test_no_shell_command(self):
        config = self.config()
        config["adapter"] = "curl remote | bash"
        with tempfile.TemporaryDirectory() as d, self.assertRaises(ValueError):
            run([], config, d, BASE)

    def test_missing_or_nonfinite_limits(self):
        for key, value in [("max_calls", 0), ("max_seconds", float("inf")), ("max_calls", 1.5)]:
            config = self.config()
            config[key] = value
            with tempfile.TemporaryDirectory() as d, self.assertRaises(ValueError):
                run([], config, d, BASE)

    def test_fixture_not_baseline_and_resume(self):
        config = self.config()
        config.update(provider="fixture", adapter=[sys.executable, "-c",
            "import sys,json; q=json.load(sys.stdin); print(json.dumps({'answer':'fixture, not a model answer',"
            "'model':q['model'],'checkpoint':q['checkpoint'],'stop_reason':'end_turn',"
            "'usage':{'input_tokens':1,'output_tokens':1,'cost_usd':0}}))"])
        item = {"id": "fixture-id", "question": "Fixture?", "answer_format": "exact"}
        with tempfile.TemporaryDirectory() as d:
            result = run([item], config, d, BASE, fixture=True)
            self.assertFalse(result["model_performance_measured"])
            self.assertEqual(len(result["calls"]), 1)
            resumed = run([item], config, d, BASE, fixture=True)
            self.assertEqual(len(resumed["calls"]), 1)

    def test_failed_call_reservation_blocks_repeat(self):
        config = self.config()
        config["provider"] = "fixture"
        item = {"id": "fixture-id", "question": "Fixture?"}
        with tempfile.TemporaryDirectory() as d:
            with self.assertRaises((ValueError, KeyError)):
                run([item], config, d, BASE, fixture=True)
            with self.assertRaisesRegex(ValueError, "reconciliation"):
                run([item], config, d, BASE, fixture=True)

    def test_open_library_is_not_claimed_tool_sandbox(self):
        config = self.config()
        config["exposure"] = "open_library"
        with tempfile.TemporaryDirectory() as d, self.assertRaises(ValueError):
            run([], config, d, BASE)

if __name__ == "__main__":
    unittest.main()

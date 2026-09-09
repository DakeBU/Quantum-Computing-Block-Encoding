"""Regression tests for the inherited missing-file false-green failure."""

from pathlib import Path
import subprocess
import sys
import tempfile
import unittest

from tools.check_hermite_artifacts import REQUIRED_FILES, missing_inputs


class HermiteInputGateTests(unittest.TestCase):
    def test_workflow_keeps_real_gates_without_archive_transport(self):
        workflows = Path(__file__).resolve().parents[1] / ".github/workflows"
        gate = (workflows / "hermite-state-preparation.yml").read_text(encoding="utf-8")
        for command in (
            "python3 tools/check_hermite_artifacts.py",
            "lake build QuantumBlockEncoding.HermiteStatePreparation",
            "lake build Tests",
            "python3 tools/check_proof_trust.py",
            "qiskit/export.py --self-test",
            "qiskit/replay.py",
        ):
            self.assertIn(command, gate)
        self.assertNotIn("if:", gate)
        self.assertNotIn("upload-artifact", gate)
        self.assertNotIn("download-artifact", gate)
        for name in ("hermite-offline-replay.yml", "hermite-offline-split.yml"):
            retired = (workflows / name).read_text(encoding="utf-8")
            self.assertIn("workflow_dispatch:", retired)
            self.assertIn("exit 1", retired)
            self.assertNotIn("upload-artifact", retired)
            self.assertNotIn("download-artifact", retired)
            self.assertNotIn("push:", retired)

    def test_each_required_file_is_mandatory(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            for name in REQUIRED_FILES:
                path = root / name
                path.parent.mkdir(parents=True, exist_ok=True)
                path.write_text("fixture\n", encoding="utf-8")
            self.assertEqual(missing_inputs(root), [])
            for name in REQUIRED_FILES:
                with self.subTest(name=name):
                    path = root / name
                    path.unlink()
                    self.assertEqual(missing_inputs(root), [name])
                    path.mkdir()
                    self.assertEqual(missing_inputs(root), [name])
                    path.rmdir()
                    path.touch()
                    self.assertEqual(missing_inputs(root), [name])
                    path.write_text("fixture\n", encoding="utf-8")

    def test_missing_checkout_returns_nonzero(self):
        script = Path(__file__).with_name("check_hermite_artifacts.py")
        with tempfile.TemporaryDirectory() as tmp:
            result = subprocess.run(
                [sys.executable, str(script), "--root", tmp],
                capture_output=True, text=True, check=False,
            )
            self.assertEqual(result.returncode, 1)
            self.assertIn("FAILED", result.stdout)
            for name in REQUIRED_FILES:
                self.assertIn(name, result.stdout)


if __name__ == "__main__":
    unittest.main()

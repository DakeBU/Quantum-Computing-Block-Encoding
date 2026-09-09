"""End-to-end fail-closed regressions for Lean publication evidence.

Input discovery and hashing are real. Only external Git/Lean processes are
mocked; every fixture and generated report lives in a temporary directory.
"""

from __future__ import annotations

import contextlib
import datetime as dt
import io
import json
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch

from website.scripts import run_lean_gate as gate
from website.scripts.proof_inputs import CONFIG, SOURCE_DIRS, proof_input_digest


class LeanPublicationGateTests(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.addCleanup(self.tmp.cleanup)
        self.root = Path(self.tmp.name)
        self.output = self.root / "_out" / "lean-gate.json"
        self.commands = []
        self.commit = "0123456789abcdef0123456789abcdef01234567"
        for name in CONFIG:
            (self.root / name).write_text("fixture input\n", encoding="utf-8")
        (self.root / "QuantumBlockEncoding.lean").write_text(
            "import QuantumBlockEncoding.Core\n", encoding="utf-8"
        )
        (self.root / "Tests.lean").write_text("import ABEISTests.Basic\n", encoding="utf-8")
        for name in SOURCE_DIRS:
            (self.root / name).mkdir()
        self.core = self.root / "QuantumBlockEncoding" / "Core.lean"
        self.core.write_text("theorem core : True := True.intro\n", encoding="utf-8")
        (self.root / "ABEISTests" / "Basic.lean").write_text(
            "import QuantumBlockEncoding.Core\n", encoding="utf-8"
        )
        self.unimported = self.root / "QuantumBlockEncoding" / "Unimported.lean"
        self.unimported.write_text(
            "theorem otherwise_omitted : True := True.intro\n", encoding="utf-8"
        )
        self.expected_modules = [
            "ABEISTests.Basic", "QuantumBlockEncoding.Core", "QuantumBlockEncoding.Unimported"
        ]

    def seed_old_success(self):
        self.output.parent.mkdir(parents=True, exist_ok=True)
        self.output.write_text(
            json.dumps({"passed": True, "proofInputsSha256": "obsolete-success"}),
            encoding="utf-8",
        )

    def invoke(self, *, fail=None, during_command=None):
        """Exercise main, its command wrappers, and its real filesystem checks."""
        self.commands = []

        def fake_process(command, **kwargs):
            command = tuple(command)
            self.commands.append(command)
            self.assertEqual(kwargs.get("cwd"), self.root)
            self.assertIs(kwargs.get("check"), True)
            if fail is not None and fail(command):
                raise subprocess.CalledProcessError(1, command)
            if during_command is not None:
                during_command(command)
            if command == ("git", "rev-parse", "HEAD"):
                stdout = self.commit + "\n"
            elif command == ("lake", "env", "lean", "--version"):
                stdout = "Lean (fixture version)\nAdditional fixture diagnostics\n"
            else:
                self.assertEqual(command[:2], ("lake", "build"))
                stdout = ""
            return subprocess.CompletedProcess(command, 0, stdout=stdout, stderr="")

        with (
            patch.object(gate, "ROOT", self.root),
            patch.object(sys, "argv", ["run_lean_gate.py", "--output", str(self.output)]),
            patch.object(gate.subprocess, "run", side_effect=fake_process),
            contextlib.redirect_stdout(io.StringIO()),
        ):
            return gate.main()

    def explicit_builds(self):
        return [command for command in self.commands
                if command[:2] == ("lake", "build")
                and command not in (("lake", "build"), ("lake", "build", "Tests"))]

    def test_missing_required_root_source_or_config_fails_without_success_report(self):
        for name in CONFIG:
            with self.subTest(missing=name):
                source = self.root / name
                original = source.read_bytes()
                source.unlink()
                self.seed_old_success()
                try:
                    with self.assertRaisesRegex(RuntimeError, "required proof input missing"):
                        self.invoke()
                    self.assertFalse(self.output.exists())
                    self.assertEqual(self.commands, [])
                finally:
                    source.write_bytes(original)

    def test_missing_source_directory_fails_before_external_commands(self):
        for name in SOURCE_DIRS:
            with self.subTest(missing=name):
                source = self.root / name
                displaced = self.root / ("displaced-" + name)
                source.rename(displaced)
                self.seed_old_success()
                try:
                    with self.assertRaisesRegex(RuntimeError, "required proof directory missing"):
                        self.invoke()
                    self.assertFalse(self.output.exists())
                    self.assertEqual(self.commands, [])
                finally:
                    displaced.rename(source)

    def test_every_lake_failure_removes_stale_success_including_later_batches(self):
        extra = self.root / "QuantumBlockEncoding" / "Extra"
        extra.mkdir()
        for index in range(41):
            (extra / f"Leaf{index:02d}.lean").write_text(
                "example : True := True.intro\n", encoding="utf-8"
            )
        modules = sorted(self.expected_modules + [
            f"QuantumBlockEncoding.Extra.Leaf{index:02d}" for index in range(41)
        ])
        failures = [
            ("lake", "build"),
            ("lake", "build", "Tests"),
            ("lake", "build", *modules[:40]),
            ("lake", "build", *modules[40:]),
            ("lake", "env", "lean", "--version"),
        ]
        for failed_command in failures:
            with self.subTest(failed_command=failed_command):
                self.seed_old_success()
                with self.assertRaises(subprocess.CalledProcessError):
                    self.invoke(fail=lambda command: command == failed_command)
                self.assertIn(failed_command, self.commands)
                self.assertEqual(self.commands[-1], failed_command)
                self.assertFalse(self.output.exists())

    def test_unimported_source_is_explicitly_built_and_failure_cannot_green(self):
        self.seed_old_success()
        self.unimported.write_text("this is deliberately invalid Lean\n", encoding="utf-8")
        with self.assertRaises(subprocess.CalledProcessError):
            self.invoke(fail=lambda command: "QuantumBlockEncoding.Unimported" in command[2:])
        self.assertEqual(self.commands[:2], [("lake", "build"), ("lake", "build", "Tests")])
        self.assertTrue(any("QuantumBlockEncoding.Unimported" in command[2:]
                            for command in self.explicit_builds()))
        self.assertFalse(self.output.exists())

    def test_source_changed_during_build_invalidates_evidence(self):
        self.seed_old_success()

        def change_source(command):
            if command == ("lake", "build", "Tests"):
                self.core.write_text("theorem changed : True := True.intro\n", encoding="utf-8")

        with self.assertRaisesRegex(SystemExit, "Lean sources changed during compilation"):
            self.invoke(during_command=change_source)
        self.assertFalse(self.output.exists())
        self.assertNotIn(("git", "rev-parse", "HEAD"), self.commands)

    def test_source_deleted_during_explicit_build_invalidates_evidence(self):
        self.seed_old_success()

        def delete_source(command):
            if "QuantumBlockEncoding.Unimported" in command[2:]:
                self.unimported.unlink()

        with self.assertRaisesRegex(SystemExit, "Lean sources changed during compilation"):
            self.invoke(during_command=delete_source)
        self.assertFalse(self.output.exists())

    def test_successful_stable_inputs_record_every_module_and_current_hash(self):
        original_digest = proof_input_digest(self.root)
        self.seed_old_success()
        self.assertEqual(self.invoke(), 0)
        report = json.loads(self.output.read_text(encoding="utf-8"))
        self.assertIs(report["passed"], True)
        self.assertEqual(report["schemaVersion"], 1)
        self.assertEqual(report["proofInputsSha256"], original_digest)
        self.assertEqual(report["proofInputsSha256"], proof_input_digest(self.root))
        self.assertEqual(report["compiledModules"], self.expected_modules)
        built_modules = [module for command in self.explicit_builds() for module in command[2:]]
        self.assertEqual(built_modules, self.expected_modules)
        self.assertEqual(report["commit"], self.commit)
        self.assertEqual(report["leanVersion"], "Lean (fixture version)")
        completed = dt.datetime.fromisoformat(report["completedAtUtc"])
        self.assertEqual(completed.utcoffset(), dt.timedelta(0))
        self.assertEqual(report["commands"], ["lake build", "lake build Tests"])
        self.assertNotIn(str(self.root), self.output.read_text(encoding="utf-8"))


if __name__ == "__main__":
    unittest.main()

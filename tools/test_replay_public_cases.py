"""Python child processes use the active environment without exposing its path."""

import subprocess
import sys
import unittest
from unittest.mock import patch

from tools import replay_public_cases as replay


class ReplayInterpreterTests(unittest.TestCase):
    def test_active_python_is_executed_but_recorded_portably(self):
        command = [sys.executable, "tools/audit_population_evolution.py", "--help"]
        completed = subprocess.CompletedProcess(command, 0, stdout="{}\n", stderr="")
        with patch.object(replay.subprocess, "run", return_value=completed) as run:
            report = replay.run(command)
        self.assertEqual(run.call_args.args[0], command)
        self.assertEqual(report["command"], ["python3", *command[1:]])
        self.assertNotIn(sys.executable, report["command"])
        self.assertTrue(report["passed"])

    def test_non_python_command_and_failure_are_preserved(self):
        command = ["lake", "build", "QuantumBlockEncoding.MainCase"]
        completed = subprocess.CompletedProcess(command, 1, stdout="", stderr="build failed")
        with patch.object(replay.subprocess, "run", return_value=completed) as run:
            report = replay.run(command)
        self.assertEqual(run.call_args.args[0], command)
        self.assertEqual(report["command"], command)
        self.assertEqual(report["stderr"], "build failed")
        self.assertFalse(report["passed"])


if __name__ == "__main__":
    unittest.main()

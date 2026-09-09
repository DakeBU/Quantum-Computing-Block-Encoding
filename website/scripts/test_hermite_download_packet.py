"""Exercise the real downloadable packet, including isolated finite replay."""

from __future__ import annotations

import hashlib
import json
import os
from pathlib import Path
import re
import subprocess
import sys
import tempfile
import unittest

from website.scripts import publish_extensions as publisher
from website.scripts.check_site import check_hermite_publication


PACKET = Path("executable-exports/SP-HERMITE-001")
RESTORED = ("circuit.qasm2", "circuit.qasm3", "mass-tree.json", "endpoint-jets.json")


def download_python_command(script: Path) -> list[str]:
    """Isolate import paths, not the user's installed verification dependencies."""
    if sys.version_info < (3, 11):
        raise RuntimeError("Download-only replay requires Python 3.11 or later (-P support)")
    return [sys.executable, "-E", "-P", "-B", str(script)]


def child_diagnostic(value: str | bytes | None) -> str:
    """Keep useful failure categories without publishing host paths or tokens."""
    if isinstance(value, bytes):
        value = value.decode("utf-8", errors="replace")
    text = value or "<no child diagnostic>"
    text = re.sub(r"\x1b\[[0-?]*[ -/]*[@-~]", "", text)
    text = re.sub(r"(?:github_pat_[A-Za-z0-9_]+|gh[pousr]_[A-Za-z0-9]+)",
                  "<redacted-token>", text)
    # Tracebacks and OSError messages normally quote filenames; handle spaces
    # and Windows escaping before replacing remaining unquoted absolute paths.
    text = re.sub(r'''(["'])(?:[A-Za-z]:[\\/]|/)[^"'\r\n]*\1''',
                  '"<path>"', text)
    text = re.sub(r'''(?<![\w:/])(?:[A-Za-z]:[\\/]|/(?!/))[^\s<>"']+''',
                  "<path>", text)
    return ("[truncated] " if len(text) > 3000 else "") + text[-3000:]


class HermiteDownloadPacketTests(unittest.TestCase):
    def setUp(self) -> None:
        payload = json.loads(publisher.HERMITE_PATH.read_text(encoding="utf-8"))
        self.case = next(case for case in payload["cases"]
                         if case["slug"] == "hermite-smooth-state-preparation")
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.site = Path(self.temp.name)
        self.download_root = self.site / "downloads" / self.case["slug"]
        self.packet = self.download_root / PACKET

    def publish(self) -> str:
        rendered = publisher.publish_case_assets(self.site, self.case)
        page = self.site / "example-cases" / self.case["slug"] / "index.html"
        page.parent.mkdir(parents=True)
        page.write_text("<!doctype html><html><body>" + rendered + "</body></html>",
                        encoding="utf-8")
        return rendered

    def run_child(self, command: list[str], *, env: dict[str, str] | None = None) -> subprocess.CompletedProcess:
        try:
            return subprocess.run(command, cwd=self.site, env=env, check=False,
                                  capture_output=True, text=True, timeout=120)
        except subprocess.TimeoutExpired as error:
            self.fail("Download-only child timed out after 120 seconds: " +
                      child_diagnostic(error.stderr or error.stdout))
        except OSError as error:
            self.fail(f"Download-only child could not start: {type(error).__name__}, errno={error.errno}")

    def assert_child_succeeded(self, completed: subprocess.CompletedProcess) -> None:
        self.assertEqual(completed.returncode, 0,
                         f"Download-only child failed (exit={completed.returncode}): " +
                         child_diagnostic(completed.stderr or completed.stdout))

    def test_registry_contains_every_accepted_artifact_and_both_replay_sources(self) -> None:
        registered = [asset["path"] for asset in self.case["supplementaryAssets"]]
        self.assertEqual(len(registered), len(set(registered)))
        acceptance = json.loads((publisher.ROOT / PACKET / "acceptance.json").read_text(encoding="utf-8"))
        required = set(acceptance["artifact_sha256"]) | {
            "acceptance.json", "qiskit/export.py", "qiskit/replay.py",
        }
        self.assertTrue({(PACKET / name).as_posix() for name in required} <= set(registered))

    def test_real_publisher_preserves_all_asset_bytes_and_display_links(self) -> None:
        rendered = self.publish()
        for asset in self.case["supplementaryAssets"]:
            relative = Path(asset["path"])
            with self.subTest(asset=relative.as_posix()):
                self.assertEqual((self.download_root / relative).read_bytes(),
                                 (publisher.ROOT / relative).read_bytes())
                self.assertIn("../../downloads/" + self.case["slug"] + "/" + relative.as_posix(),
                              rendered)
        self.assertEqual(check_hermite_publication(self.site, publisher.ROOT), [])

    def test_final_gate_rejects_each_missing_restored_file(self) -> None:
        self.publish()
        for name in RESTORED:
            with self.subTest(name=name):
                target = self.packet / name
                contents = target.read_bytes()
                target.unlink()
                errors = check_hermite_publication(self.site, publisher.ROOT)
                self.assertEqual(len(errors), 1)
                self.assertIn(name, errors[0])
                target.write_bytes(contents)

    def test_download_only_replay_runs_with_no_repository_artifact_fallback(self) -> None:
        self.publish()
        before = {p.relative_to(self.packet).as_posix(): hashlib.sha256(p.read_bytes()).hexdigest()
                  for p in self.packet.rglob("*") if p.is_file()}
        script = (Path("downloads") / self.case["slug"] / PACKET / "qiskit/replay.py")
        # -E ignores PYTHONPATH; -P excludes cwd/script-directory import fallback;
        # -B preserves packet bytes. Unlike -I, this does not imply -s: CI may
        # legitimately install NumPy/Qiskit in its user site. This is artifact
        # independence, not a security sandbox against installed site hooks.
        # Both cwd and __file__ still refer only to the temporary website.
        completed = self.run_child(download_python_command(script))
        self.assert_child_succeeded(completed)
        result = json.loads(completed.stdout)
        self.assertIs(result["passed"], True)
        self.assertEqual(result["evidence_class"], "independent-finite-replay")
        self.assertIs(result["lean_certificate_claimed"], False)
        self.assertTrue(set(RESTORED) <= set(result["checked_artifacts"]))
        self.assertLessEqual(max(result["qasm_max_amplitude_errors"].values()), 1e-10)
        after = {p.relative_to(self.packet).as_posix(): hashlib.sha256(p.read_bytes()).hexdigest()
                 for p in self.packet.rglob("*") if p.is_file()}
        self.assertEqual(after, before, "Independent replay must not mutate accepted artifacts")

    def test_missing_download_artifact_cannot_fall_back_to_original_packet(self) -> None:
        self.publish()
        self.assertTrue((publisher.ROOT / PACKET / "mass-tree.json").is_file())
        (self.packet / "mass-tree.json").unlink()
        script = Path("downloads") / self.case["slug"] / PACKET / "qiskit/replay.py"
        completed = self.run_child(download_python_command(script))
        self.assertNotEqual(completed.returncode, 0)
        self.assertIn("required artifact is missing: mass-tree.json",
                      child_diagnostic(completed.stderr))

    def test_environment_cwd_and_script_directory_cannot_supply_imports(self) -> None:
        repository = self.site / "repository-fallback"
        scripts = self.site / "download-probe"
        repository.mkdir()
        scripts.mkdir()
        names = ("qbe_fake_repository_sentinel", "qbe_fake_cwd_sentinel", "qbe_fake_script_sentinel")
        for directory, name in zip((repository, self.site, scripts), names):
            (directory / (name + ".py")).write_text("raise RuntimeError('unexpected fallback')\n", encoding="utf-8")
        script = scripts / "probe.py"
        script.write_text(
            "import importlib.util,json,sys\n"
            "print(json.dumps({'found': {name: importlib.util.find_spec(name) is not None "
            "for name in sys.argv[1:]}, 'ignore_environment': sys.flags.ignore_environment, "
            "'safe_path': sys.flags.safe_path, 'no_user_site': sys.flags.no_user_site}))\n",
            encoding="utf-8")
        environment = dict(os.environ, PYTHONPATH=str(repository))
        completed = self.run_child(download_python_command(script.relative_to(self.site)) + list(names),
                                   env=environment)
        self.assert_child_succeeded(completed)
        result = json.loads(completed.stdout)
        self.assertEqual(result["found"], {name: False for name in names})
        self.assertEqual(result["ignore_environment"], 1)
        self.assertIs(result["safe_path"], True)
        self.assertEqual(result["no_user_site"], 0)

    def test_user_site_policy_can_load_a_simulated_dependency_without_host_writes(self) -> None:
        user_site = self.site / "simulated-user-site"
        user_site.mkdir()
        module = "qbe_fake_user_dependency"
        (user_site / (module + ".py")).write_text("VALUE = 1\n", encoding="utf-8")
        # Repeat the standard library's user-site addition stage with a temporary
        # directory. No real user site, HOME, APPDATA or dependency is modified.
        # The base interpreter avoids a venv's separate include-system-site policy.
        probe = (
            "import importlib.util,json,site,sys; "
            "before=importlib.util.find_spec(sys.argv[2]) is not None; "
            "site.USER_BASE=sys.argv[1]; site.USER_SITE=sys.argv[1]; "
            "site.ENABLE_USER_SITE=site.check_enableusersite(); "
            "site.addusersitepackages(set()); "
            "print(json.dumps({'before':before,'found':importlib.util.find_spec(sys.argv[2]) is not None,"
            "'enabled':site.ENABLE_USER_SITE,'no_user_site':sys.flags.no_user_site}))"
        )
        interpreter = getattr(sys, "_base_executable", sys.executable)
        for flags, expected in [(["-E", "-P", "-B"], True), (["-I", "-B"], False)]:
            with self.subTest(flags=flags):
                completed = self.run_child([interpreter, *flags, "-c", probe, str(user_site), module])
                self.assert_child_succeeded(completed)
                result = json.loads(completed.stdout)
                self.assertIs(result["before"], False)
                self.assertIs(result["found"], expected)
                self.assertIs(result["enabled"], expected)
                self.assertEqual(result["no_user_site"], int(not expected))

    def test_child_failure_reports_missing_module_but_redacts_host_details(self) -> None:
        stderr = ('Traceback:\n  File "Z:/private host/runner/replay.py", line 16\n'
                  '  File "/private/runner/site/numpy.py", line 1\n'
                  'ModuleNotFoundError: No module named \'numpy\'\n'
                  'github_pat_nonsecret_test_fixture\n')
        completed = subprocess.CompletedProcess(["python"], 1, "", stderr)
        with self.assertRaises(AssertionError) as context:
            self.assert_child_succeeded(completed)
        message = str(context.exception)
        self.assertIn("exit=1", message)
        self.assertIn("ModuleNotFoundError", message)
        self.assertIn("numpy", message)
        self.assertNotIn("Z:/", message)
        self.assertNotIn("/private/", message)
        self.assertNotIn("github_pat_", message)
        self.assertIn("<redacted-token>", message)
        self.assertLessEqual(len(child_diagnostic("x" * 5000)), 3012)


if __name__ == "__main__":
    unittest.main()

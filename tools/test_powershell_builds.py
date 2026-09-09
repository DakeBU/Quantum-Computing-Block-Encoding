"""Keep native Windows publication gates aligned without running a full build."""

from __future__ import annotations

import os
from pathlib import Path
import re
import shlex
import shutil
import subprocess
import tempfile
import unittest


ROOT = Path(__file__).resolve().parents[1]
NAMES = ("build-all", "build-blueprint", "build-website")
POWERSHELL = shutil.which("pwsh") or shutil.which("powershell")


def joined_lines(path: Path, continuation: str) -> list[str]:
    source = path.read_text(encoding="utf-8-sig")
    return re.sub(re.escape(continuation) + r"\r?\n[ \t]*", " ", source).splitlines()


def python_commands(path: Path, *, windows: bool) -> list[list[str]]:
    prefix = "& $PythonCommand " if windows else "python3 "
    commands = []
    for line in joined_lines(path, "`" if windows else "\\"):
        if line.startswith(prefix) and "<<" not in line:
            commands.append(shlex.split(line[len(prefix):]))
    return commands


class PowerShellParityTests(unittest.TestCase):
    def test_every_canonical_python_step_is_present_in_order(self):
        for name in NAMES:
            with self.subTest(script=name):
                canonical = python_commands(ROOT / f"scripts/{name}.sh", windows=False)
                native = iter(python_commands(ROOT / f"scripts/{name}.ps1", windows=True))
                for command in canonical:
                    self.assertTrue(any(candidate == command for candidate in native), command)

    def test_native_external_commands_propagate_failure(self):
        for name in NAMES:
            lines = joined_lines(ROOT / f"scripts/{name}.ps1", "`")
            for index, line in enumerate(lines):
                if line.startswith(("& $PythonCommand ", "& $LakeCommand ", "& scripts/")):
                    with self.subTest(script=name, command=line):
                        self.assertEqual(lines[index + 1].strip(),
                                         "if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }")

    def test_canonical_final_files_markers_and_graph_assertions_are_preserved(self):
        for name in ("build-blueprint", "build-website"):
            shell = (ROOT / f"scripts/{name}.sh").read_text(encoding="utf-8")
            native = (ROOT / f"scripts/{name}.ps1").read_text(encoding="utf-8")
            for line in shell.splitlines():
                if line.startswith("test -f "):
                    path = shlex.split(line)[-1]
                    if "$" not in path:
                        self.assertIn(path, native)
                if line.startswith(("grep -", "! grep -")):
                    marker, path = shlex.split(line)[-2:]
                    if "Möttönen" in marker:
                        marker = marker.replace("ö", "{0}")
                    self.assertIn(marker, native)
                    self.assertIn(path, native)
            for anchor in re.findall(r"QuantumBlockEncoding\.SemanticFidelity\.[A-Za-z]+", shell):
                self.assertIn(anchor, native)

    def test_required_hermite_publication_and_inner_cycle_guard(self):
        all_source = (ROOT / "scripts/build-all.ps1").read_text()
        website = (ROOT / "scripts/build-website.ps1").read_text()
        self.assertIn("QBE_AGENT_INNER_CYCLE", all_source)
        self.assertIn("exit 64", all_source)
        self.assertIn("tools/check_hermite_artifacts.py", all_source)
        self.assertIn("website/scripts/run_lean_gate.py", all_source)
        self.assertIn("SP-HERMITE-001/qiskit/replay.py", all_source)
        self.assertIn("website/scripts/publish_extensions.py", website)
        self.assertIn("_site/example-cases/hermite-smooth-state-preparation/index.html", website)


@unittest.skipUnless(POWERSHELL, "PowerShell is required for native-script execution checks")
class PowerShellExecutionTests(unittest.TestCase):
    def run_script(self, code: str, *args: str, engine: str = POWERSHELL) -> subprocess.CompletedProcess:
        with tempfile.TemporaryDirectory() as directory:
            script = Path(directory) / "test.ps1"
            script.write_text(code, encoding="utf-8-sig")
            return subprocess.run([engine, "-NoProfile", "-NonInteractive", "-File",
                                   str(script), *args], text=True, capture_output=True, timeout=30)

    def test_all_native_scripts_parse(self):
        engines = {path for name in ("pwsh", "powershell") if (path := shutil.which(name))}
        for engine in engines:
            for name in NAMES:
                source = str(ROOT / f"scripts/{name}.ps1").replace("'", "''")
                code = r'''
$tokens = $null
$errors = $null
[void][Management.Automation.Language.Parser]::ParseFile('__SOURCE__', [ref]$tokens, [ref]$errors)
if ($errors.Count -ne 0) { $errors | ForEach-Object { Write-Host $_.Message }; exit 1 }
'''.replace("__SOURCE__", source)
                # Parse read-only in the older shell even when its normal
                # script-file execution policy is restricted; change no policy.
                result = subprocess.run([engine, "-NoProfile", "-NonInteractive", "-Command", code],
                                        text=True, capture_output=True, timeout=30)
                self.assertEqual(result.returncode, 0, result.stdout + result.stderr)

    def output_guard(self, name: str, root: Path, relative: str) -> subprocess.CompletedProcess:
        return self.run_script(r'''
param([string]$Source, [string]$Fixture, [string]$Relative)
$ErrorActionPreference = "Stop"
$tokens = $null
$errors = $null
$ast = [Management.Automation.Language.Parser]::ParseFile($Source, [ref]$tokens, [ref]$errors)
if ($errors.Count) { throw "script syntax error" }
foreach ($definition in $ast.FindAll({ param($node)
    $node -is [Management.Automation.Language.FunctionDefinitionAst] }, $true)) {
  . ([ScriptBlock]::Create($definition.Extent.Text))
}
$repoRoot = $Fixture
if (Get-Command Assert-RepositoryOutput -ErrorAction SilentlyContinue) {
  Assert-RepositoryOutput $Relative
} else {
  Assert-BlueprintOutput
}
''', str(ROOT / f"scripts/{name}.ps1"), str(root), relative)

    def test_only_designated_outputs_are_accepted_and_user_images_are_untouched(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            image = root / "untracked-user-image.png"
            image.write_bytes(b"user-owned image fixture")
            for name, relative in (("build-website", "_site"), ("build-blueprint", "_out/blueprint")):
                (root / relative).mkdir(parents=True, exist_ok=True)
                result = self.output_guard(name, root, relative)
                self.assertEqual(result.returncode, 0, result.stderr)
                self.assertEqual(Path(result.stdout.strip()), root / relative)
            rejected = self.output_guard("build-website", root, "../outside")
            self.assertNotEqual(rejected.returncode, 0)
            self.assertEqual(image.read_bytes(), b"user-owned image fixture")

    def create_link(self, path: Path, target: Path) -> None:
        if os.name == "nt":
            result = self.run_script(r'''
param([string]$Link, [string]$Target)
$ErrorActionPreference = "Stop"
New-Item -ItemType Junction -Path $Link -Target $Target | Out-Null
''', str(path), str(target))
            self.assertEqual(result.returncode, 0, result.stderr)
        else:
            path.symlink_to(target, target_is_directory=True)

    def test_reparse_outputs_ancestors_and_descendants_are_rejected(self):
        for name, relative, linked in (
            ("build-website", "_site", "_site"),
            ("build-website", "_out/site", "_out"),
            ("build-website", "_site", "_site/nested"),
            ("build-blueprint", "_out/blueprint", "_out"),
            ("build-blueprint", "_out/blueprint", "_out/blueprint/nested"),
        ):
            with self.subTest(script=name, linked=linked), tempfile.TemporaryDirectory() as directory:
                workspace = Path(directory)
                root = workspace / "repo"
                outside = workspace / "outside"
                root.mkdir()
                outside.mkdir()
                (outside / "keep.txt").write_text("keep")
                link = root / linked
                link.parent.mkdir(parents=True, exist_ok=True)
                self.create_link(link, outside)
                try:
                    result = self.output_guard(name, root, relative)
                    self.assertNotEqual(result.returncode, 0)
                    self.assertEqual((outside / "keep.txt").read_text(), "keep")
                finally:
                    # Delete only the test-created link itself, never its target.
                    if os.name == "nt":
                        os.rmdir(link)
                    else:
                        link.unlink()

    def test_missing_website_inputs_fail_before_any_external_command(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / "scripts").mkdir()
            shutil.copyfile(ROOT / "scripts/build-website.ps1", root / "scripts/build-website.ps1")
            fake = root / "fake.ps1"
            fake.write_text('Write-Host "UNEXPECTED_EXTERNAL_COMMAND"\nexit 0\n')
            result = subprocess.run([POWERSHELL, "-NoProfile", "-File",
                                     str(root / "scripts/build-website.ps1"), "-PythonCommand", str(fake)],
                                    capture_output=True, text=True, timeout=30)
            self.assertNotEqual(result.returncode, 0)
            self.assertNotIn("UNEXPECTED_EXTERNAL_COMMAND", result.stdout)

    def test_dangling_output_link_is_rejected(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory) / "repo"
            target = Path(directory) / "gone"
            root.mkdir()
            target.mkdir()
            link = root / "_site"
            self.create_link(link, target)
            target.rmdir()
            try:
                result = self.output_guard("build-website", root, "_site")
                self.assertNotEqual(result.returncode, 0)
            finally:
                if os.name == "nt":
                    os.rmdir(link)
                else:
                    link.unlink()

    def test_failed_first_gate_stops_build_all(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / "scripts").mkdir()
            shutil.copyfile(ROOT / "scripts/build-all.ps1", root / "scripts/build-all.ps1")
            fake = root / "fake.ps1"
            fake.write_text('Write-Host "FIRST_GATE_ONLY"\nexit 23\n')
            env = dict(os.environ, QBE_AGENT_INNER_CYCLE="0")
            result = subprocess.run([POWERSHELL, "-NoProfile", "-File",
                                     str(root / "scripts/build-all.ps1"), "-PythonCommand", str(fake)],
                                    capture_output=True, text=True, env=env, timeout=30)
            self.assertEqual(result.returncode, 23, result.stdout + result.stderr)
            self.assertEqual(result.stdout.count("FIRST_GATE_ONLY"), 1)


if __name__ == "__main__":
    unittest.main()

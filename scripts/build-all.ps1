param(
  [string]$PythonCommand = "python",
  [string]$LakeCommand = "lake",
  [string[]]$LakeArguments = @()
)

$ErrorActionPreference = "Stop"
$repoRoot = Split-Path -Parent $PSScriptRoot
Set-Location -LiteralPath $repoRoot

& $PythonCommand tools/qbe.py harness-check
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
& $PythonCommand tools/test_proof_trust.py
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
& $PythonCommand tools/check_proof_trust.py
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
& $PythonCommand tools/check_technical_lemma_registry.py
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
& $PythonCommand website/scripts/run_lean_gate.py
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
& $PythonCommand scripts/generate-blueprint-catalog.py --check
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
& $PythonCommand scripts/test-sanitize-blueprint-paths.py
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
& scripts/build-blueprint.ps1 `
  -PythonCommand $PythonCommand `
  -LakeCommand $LakeCommand `
  -LakeArguments $LakeArguments
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
& scripts/build-website.ps1 -PythonCommand $PythonCommand
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

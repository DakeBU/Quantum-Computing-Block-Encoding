param(
  [string]$PythonCommand = "python"
)

$ErrorActionPreference = "Stop"
$repoRoot = Split-Path -Parent $PSScriptRoot
Set-Location -LiteralPath $repoRoot

foreach ($required in @(
  "_out/lean-gate.json",
  "_out/blueprint/html-multi/index.html"
)) {
  if (-not (Test-Path -LiteralPath $required)) {
    throw "Required build input is missing: $required"
  }
}

& $PythonCommand website/scripts/build_site.py `
  --lean-gate-report _out/lean-gate.json `
  --output _out/site
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

$site = Join-Path $repoRoot "_site"
if (Test-Path -LiteralPath $site) {
  Remove-Item -LiteralPath $site -Recurse -Force
}
New-Item -ItemType Directory -Path (Join-Path $site "blueprint") -Force | Out-Null
Copy-Item -Path "_out/site/*" -Destination $site -Recurse -Force
Copy-Item -Path "_out/blueprint/*" -Destination (Join-Path $site "blueprint") -Recurse -Force
New-Item -ItemType File -Path (Join-Path $site ".nojekyll") -Force | Out-Null

& $PythonCommand website/scripts/check_site.py --root _site --require-blueprint
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
& $PythonCommand website/scripts/check_source_links.py --root _site
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
& $PythonCommand website/scripts/test_preview.py
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
& $PythonCommand scripts/sanitize-blueprint-paths.py --scan-only _site
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

Write-Host "Unified ABEIS site assembled at _site/index.html"

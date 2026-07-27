param(
  [string]$PythonCommand = "python",
  [string]$LakeCommand = "lake",
  [string[]]$LakeArguments = @()
)

$ErrorActionPreference = "Stop"
$repoRoot = Split-Path -Parent $PSScriptRoot
Set-Location -LiteralPath $repoRoot

& $PythonCommand scripts/generate-blueprint-catalog.py --check
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

& $LakeCommand @LakeArguments build "ABEISBlueprint.Assembly:olean"
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

$outputRoot = Join-Path $repoRoot "_out"
$blueprintOutput = Join-Path $outputRoot "blueprint"
$resolvedRepo = [System.IO.Path]::GetFullPath($repoRoot)
$resolvedOutput = [System.IO.Path]::GetFullPath($blueprintOutput)
if (-not $resolvedOutput.StartsWith($resolvedRepo + [System.IO.Path]::DirectorySeparatorChar)) {
  throw "Refusing to clean a Blueprint output outside the repository"
}
if (Test-Path -LiteralPath $resolvedOutput) {
  Remove-Item -LiteralPath $resolvedOutput -Recurse -Force
}

& $LakeCommand @LakeArguments lean ABEISBlueprintMain.lean -- --run ABEISBlueprintMain.lean --without-preview-data --output _out/blueprint
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

$assetOutput = Join-Path $blueprintOutput "html-multi/assets"
New-Item -ItemType Directory -Path $assetOutput -Force | Out-Null
Copy-Item -LiteralPath "web/assets/abeis-evidence-pipeline.svg" -Destination $assetOutput
Copy-Item -LiteralPath "web/assets/abeis-library-map.svg" -Destination $assetOutput

& $PythonCommand scripts/sanitize-blueprint-paths.py _out/blueprint
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
& $PythonCommand website/scripts/repair_blueprint_fragments.py _out/blueprint/html-multi
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
& $PythonCommand website/scripts/repair_blueprint_fragments.py --check _out/blueprint/html-multi
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

$required = @(
  "_out/blueprint/html-multi/index.html",
  "_out/blueprint/html-multi/xref.json",
  "_out/blueprint/html-multi/assets/abeis-evidence-pipeline.svg",
  "_out/blueprint/html-multi/assets/abeis-library-map.svg",
  "_out/blueprint/html-multi/overview/index.html",
  "_out/blueprint/html-multi/foundations/index.html",
  "_out/blueprint/html-multi/routes/index.html",
  "_out/blueprint/html-multi/case-studies/index.html",
  "_out/blueprint/html-multi/catalog-foundations/index.html",
  "_out/blueprint/html-multi/catalog-semantics/index.html",
  "_out/blueprint/html-multi/catalog-classic-routes/index.html",
  "_out/blueprint/html-multi/catalog-certified-cases/index.html",
  "_out/blueprint/html-multi/catalog-cubic/index.html",
  "_out/blueprint/html-multi/catalog-paper-and-examples/index.html",
  "_out/blueprint/html-multi/catalog-automation-and-memory/index.html",
  "_out/blueprint/html-multi/catalog-experimental-robin-matrix/index.html"
)
foreach ($path in $required) {
  if (-not (Test-Path -LiteralPath $path)) {
    throw "Blueprint output is missing: $path"
  }
}

$index = Get-Content -LiteralPath "_out/blueprint/html-multi/index.html" -Raw
foreach ($style in @("blueprint", "modern", "bold")) {
  if (-not $index.Contains($style)) {
    throw "Verso Blueprint style picker is missing style: $style"
  }
}

Write-Host "Blueprint built at _out/blueprint/html-multi/index.html"

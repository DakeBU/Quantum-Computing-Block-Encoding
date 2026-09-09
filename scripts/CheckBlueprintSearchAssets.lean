import VersoManual

/-!
Cheap preflight for the pinned Verso search resources, before rendering the book.
Run from the repository root with:
  lake env lean --run scripts/CheckBlueprintSearchAssets.lean

Validate every embedded output name before writing anything, then exercise the
actual Verso emitter and compare all emitted binary assets with their inputs.
The fixed output directory is disposable, repository-relative build output.
-/

private def safeAssetName (name : String) : Bool :=
  !name.isEmpty && !(System.FilePath.mk name).isAbsolute &&
  !name.contains '\\' && !name.contains ':' &&
  (name.splitOn "/").all (fun part => !part.isEmpty && part != "." && part != "..")

private def checkOutputPath (root path : System.FilePath) : IO Unit := do
  let mut current : System.FilePath := ""
  for component in path.components do
    current := current / component
    match (← current.symlinkMetadata.toBaseIO) with
    | .error (.noFileOrDirectory ..) => pure ()
    | .error _ =>
      throw <| IO.userError "Blueprint search preflight: cannot inspect output path"
    | .ok metadata =>
      if metadata.type == .symlink then
        throw <| IO.userError "Blueprint search preflight: linked output path"
      let actual ← IO.FS.realPath current
      if actual.normalize != (root / current).normalize then
        throw <| IO.userError "Blueprint search preflight: redirected output path"

def main : IO UInt32 := do
  let assets := Verso.Search.searchBoxCode
  if assets.isEmpty then
    throw <| IO.userError "Blueprint search preflight: no embedded assets"
  let mut seen : Array String := #[]
  for (name, _) in assets do
    if !safeAssetName name then
      -- Do not echo an unsafe asset name, which could contain a private path.
      throw <| IO.userError "Blueprint search preflight: unsafe embedded asset name"
    if seen.contains name then
      throw <| IO.userError "Blueprint search preflight: duplicate embedded asset name"
    seen := seen.push name
  let output : System.FilePath := "_out/blueprint-search-preflight"
  let root ← IO.FS.realPath "."
  checkOutputPath root output
  for (name, _) in assets do
    checkOutputPath root (output / name)
  for name in ["domain-mappers.js", "domain-display.css"] do
    checkOutputPath root (output / name)
  Verso.Genre.Manual.emitSearchBox output {}
  for (name, expected) in assets do
    let file := output / name
    if !(← file.pathExists) then
      throw <| IO.userError s!"Blueprint search preflight: missing {name}"
    if (← IO.FS.readBinFile file) != expected then
      throw <| IO.userError s!"Blueprint search preflight: changed contents for {name}"
  for name in ["domain-mappers.js", "domain-display.css"] do
    if !(← (output / name).pathExists) then
      throw <| IO.userError s!"Blueprint search preflight: missing generated {name}"
  IO.println s!"Blueprint search preflight: PASS ({assets.size} embedded assets + 2 generated files)"
  return 0

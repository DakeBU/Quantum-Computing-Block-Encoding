import Lake
open Lake DSL

package quantum_block_encoding where
  version := v!"0.1.0"

require VersoBlueprint from git
  "https://github.com/leanprover/verso-blueprint" @ "v4.29.0"

-- Keep Mathlib last so that its pins win when transitive dependencies overlap.
require mathlib from git
  "https://github.com/leanprover-community/mathlib4.git" @ "v4.29.1"

@[default_target]
lean_lib QuantumBlockEncoding

lean_lib Tests where
  roots := #[`Tests, `ABEISTests.Basic]

lean_lib ABEISBlueprint

lean_exe blueprintGen where
  root := `ABEISBlueprintMain
  supportInterpreter := true

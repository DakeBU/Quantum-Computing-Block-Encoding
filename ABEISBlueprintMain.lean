import VersoManual
import VersoBlueprint.PreviewManifest
import ABEISBlueprint.Assembly

open Verso Doc
open Verso.Genre Manual

def main (args : List String) : IO UInt32 :=
  if args.contains "--without-preview-data" then
    let options := args.filter (· != "--without-preview-data")
    Informal.PreviewManifest.blueprintMain
      ABEISBlueprint.assembledBlueprint
      (extensionImpls := by exact extension_impls%)
      options
      (config := Informal.PreviewManifest.withBlueprintAssets {})
  else
    Informal.PreviewManifest.blueprintMainWithPreviewData
      ABEISBlueprint.assembledBlueprint
      args
      (extensionImpls := by exact extension_impls%)

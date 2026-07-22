import VersoManual
import VersoBlueprint.PreviewManifest
import ABEISBlueprint.Assembly

open Verso Doc
open Verso.Genre Manual

def main (args : List String) : IO UInt32 :=
  Informal.PreviewManifest.blueprintMainWithPreviewData
    ABEISBlueprint.assembledBlueprint
    args
    (extensionImpls := by exact extension_impls%)

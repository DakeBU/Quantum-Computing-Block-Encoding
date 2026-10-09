import Lean
import Lean.DeclarationRange
import Lean.Util.FoldConsts
import Lean.Util.NumObjs

/-! Direct type/value constant occurrences extracted from compiled Lean modules.
Module imports are reported separately; this does not assert transitive proof support. -/

open Lean

namespace LibraryCertificateGraph

private def projectRoot : Name := `QuantumBlockEncoding.CircuitEffectStability

private def nameLt (a b : Name) : Bool :=
  a.toString < b.toString

private def stringLt (a b : String) : Bool :=
  a < b

private def isProjectModule (moduleName : Name) : Bool :=
  #[`QuantumBlockEncoding.BornStability, `QuantumBlockEncoding.CircuitEffectStability].contains moduleName

private def moduleOf? (env : Environment) (declName : Name) : Option Name := do
  let idx ← env.getModuleIdxFor? declName
  env.header.moduleNames[idx.toNat]?

private def isProjectDecl (env : Environment) (declName : Name) : Bool :=
  (moduleOf? env declName).any isProjectModule

private def declarationKind : ConstantInfo → String
  | .axiomInfo _  => "axiom"
  | .defnInfo _   => "definition"
  | .thmInfo _    => "theorem"
  | .opaqueInfo _ => "opaque"
  | .quotInfo _   => "quotient"
  | .inductInfo _ => "inductive"
  | .ctorInfo _   => "constructor"
  | .recInfo _    => "recursor"

private def lastComponent : Name → String
  | .anonymous => ""
  | .str _ s   => s
  | .num _ n   => toString n

private def sourcePath (moduleName : Name) : String :=
  moduleName.toString.replace "." "/" ++ ".lean"

private def jsonNat (n : Nat) : Json :=
  toJson n

private def jsonBool (b : Bool) : Json :=
  toJson b

private def sourceJson (env : Environment) (declName moduleName : Name) : Json :=
  let range? := declRangeExt.find? (level := .exported) env declName
  Json.mkObj [
    ("file", sourcePath moduleName),
    ("line_start", range?.map (fun r => jsonNat (r.range.pos.line + 1)) |>.getD Json.null),
    ("line_end", range?.map (fun r => jsonNat (r.range.endPos.line + 1)) |>.getD Json.null)
  ]

private def dependencies (expr : Expr) : Array Name :=
  expr.getUsedConstantsAsSet.toArray.qsort nameLt

private def valueDependencies (info : ConstantInfo) : Array Name :=
  match info.value? (allowOpaque := true) with
  | some value => dependencies value
  | none       => #[]

private def exprObjectCount (expr : Expr) : IO Nat :=
  expr.numObjs

private def nodeJson (env : Environment) (declName : Name) (scope : String) : IO Json := do
  let some info := env.find? declName
    | throw <| IO.userError s!"environment is missing declaration {declName}"
  let some moduleName := moduleOf? env declName
    | throw <| IO.userError s!"environment is missing module ownership for {declName}"
  let typeDeps := dependencies info.type
  let valueDeps := valueDependencies info
  let typeObjects ← exprObjectCount info.type
  let valueObjects ← match info.value? (allowOpaque := true) with
    | some value => exprObjectCount value
    | none       => pure 0
  pure <| Json.mkObj [
    ("name", declName.toString),
    ("namespace", declName.getPrefix.toString),
    ("short_name", lastComponent declName),
    ("kind", declarationKind info),
    ("scope", scope),
    ("module", moduleName.toString),
    ("source", sourceJson env declName moduleName),
    ("status", "compiled"),
    ("has_value", jsonBool <| (info.value? (allowOpaque := true)).isSome),
    ("type_expr_objects", jsonNat typeObjects),
    ("value_expr_objects", jsonNat valueObjects),
    ("type_dependency_count", jsonNat typeDeps.size),
    ("value_dependency_count", jsonNat valueDeps.size)
  ]

structure Edge where
  source      : Name
  target      : Name
  kind        : String
  alsoInValue : Bool
  targetScope : String

private def edgeKey (edge : Edge) : String :=
  edge.source.toString ++ "\u0000" ++ edge.target.toString ++ "\u0000" ++ edge.kind

private def edgeJson (edge : Edge) : Json :=
  Json.mkObj [
    ("source", edge.source.toString),
    ("target", edge.target.toString),
    ("kind", edge.kind),
    ("also_in_value", jsonBool edge.alsoInValue),
    ("target_scope", edge.targetScope)
  ]

private def edgesFor (env : Environment) (source : Name) (info : ConstantInfo) : Array Edge :=
  let typeDeps := dependencies info.type
  let valueDeps := valueDependencies info
  let valueSet := NameSet.ofList valueDeps.toList
  let typeSet := NameSet.ofList typeDeps.toList
  let typeEdges := typeDeps.map fun target => {
    source
    target
    kind := "type"
    alsoInValue := valueSet.contains target
    targetScope := if isProjectDecl env target then "project" else "external"
  }
  let valueEdges := (valueDeps.filter fun target => !typeSet.contains target).map fun target => {
    source
    target
    kind := "value"
    alsoInValue := false
    targetScope := if isProjectDecl env target then "project" else "external"
  }
  typeEdges ++ valueEdges

private def projectDeclarations (env : Environment) : Array Name := Id.run do
  -- `ModuleData.constNames` can repeat generated equation/simp declarations.  Environment names are
  -- globally unique, so canonicalize through a set before sorting and serializing.
  let mut result : NameSet := {}
  for h : idx in [0:env.header.moduleData.size] do
    let moduleName := env.header.moduleNames[idx]!
    if isProjectModule moduleName then
      for declName in env.header.moduleData[idx].constNames do
        result := result.insert declName
  return result.toArray.qsort nameLt

private def directExternalBoundary (env : Environment) (projectDecls : Array Name) : Array Name := Id.run do
  let mut external : NameSet := {}
  for source in projectDecls do
    if let some info := env.find? source then
      for edge in edgesFor env source info do
        if edge.targetScope == "external" && (env.find? edge.target).isSome then
          external := external.insert edge.target
  return external.toArray.qsort nameLt

private def moduleImportJson (moduleName : Name) (imp : Import) : Json :=
  Json.mkObj [
    ("source", moduleName.toString),
    ("target", imp.module.toString),
    ("import_all", jsonBool imp.importAll),
    ("exported", jsonBool imp.isExported),
    ("meta", jsonBool imp.isMeta),
    ("target_scope", if isProjectModule imp.module then "project" else "external")
  ]

private def projectModuleImports (env : Environment) : Array Json := Id.run do
  let mut rows : Array (String × Json) := #[]
  for h : idx in [0:env.header.moduleData.size] do
    let moduleName := env.header.moduleNames[idx]!
    if isProjectModule moduleName then
      for imp in env.header.moduleData[idx].imports do
        let key := moduleName.toString ++ "\u0000" ++ imp.module.toString ++ "\u0000" ++
          toString imp.importAll ++ "\u0000" ++ toString imp.isExported ++ "\u0000" ++
          toString imp.isMeta
        rows := rows.push (key, moduleImportJson moduleName imp)
  return (rows.qsort fun a b => stringLt a.1 b.1).map (·.2)

def exportJson (env : Environment) : IO Json := do
  let projectDecls := projectDeclarations env
  let externalDecls := directExternalBoundary env projectDecls
  let mut nodes : Array Json := #[]
  for declName in projectDecls do
    nodes := nodes.push (← nodeJson env declName "project")
  for declName in externalDecls do
    nodes := nodes.push (← nodeJson env declName "external")
  let mut edges : Array Edge := #[]
  for source in projectDecls do
    if let some info := env.find? source then
      edges := edges ++ edgesFor env source info
  edges := edges.qsort fun a b => stringLt (edgeKey a) (edgeKey b)
  pure <| Json.mkObj [
    ("schema_version", jsonNat 1),
    ("project", "Reusable library certificate module slice"),
    ("root_module", projectRoot.toString),
    ("namespace", projectRoot.toString),
    ("lean_version", Lean.versionString),
    ("extraction", Json.mkObj [
      ("source", "compiled-environment"),
      ("dependency_semantics", "direct-constant-occurrence"),
      ("closure", "project-direct-with-external-boundary"),
      ("deterministic", true),
      ("type_precedence", true)
    ]),
    ("status_vocabulary", toJson #["compiled", "prototype", "partial", "planned", "blocked"]),
    ("counts", Json.mkObj [
      ("project_nodes", jsonNat projectDecls.size),
      ("external_boundary_nodes", jsonNat externalDecls.size),
      ("edges", jsonNat edges.size),
      ("module_imports", jsonNat (projectModuleImports env).size)
    ]),
    ("nodes", Json.arr nodes),
    ("edges", Json.arr <| edges.map edgeJson),
    ("module_imports", Json.arr <| projectModuleImports env)
  ]

end LibraryCertificateGraph

private def usage : String :=
  "usage: lake env lean --run docs/effect-stability/DependencyExport.lean [--compact] OUTPUT.json"

unsafe def main (args : List String) : IO UInt32 := do
  let (compact, output?) := match args with
    | [output]              => (false, some output)
    | ["--compact", output] => (true, some output)
    | _                     => (false, none)
  let some output := output?
    | IO.eprintln usage; return 2
  Lean.initSearchPath (← Lean.findSysroot)
  Lean.enableInitializersExecution
  let env ← Lean.importModules #[{ module := `QuantumBlockEncoding.BornStability }, { module := `QuantumBlockEncoding.CircuitEffectStability }] {} (loadExts := true)
  let graph ← LibraryCertificateGraph.exportJson env
  let rendered := if compact then graph.compress else graph.pretty
  IO.FS.writeFile output (rendered ++ "\n")
  return 0

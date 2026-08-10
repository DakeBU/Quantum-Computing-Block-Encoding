import VersoManual
import VersoBlueprint
import ABEISBlueprint.Blueprint
import ABEISBlueprint.Chapters.Overview
import ABEISBlueprint.Chapters.Foundations
import ABEISBlueprint.Chapters.Routes
import ABEISBlueprint.Chapters.CaseStudies
import ABEISBlueprint.Catalog.Foundations
import ABEISBlueprint.Catalog.Semantics
import ABEISBlueprint.Catalog.ClassicRoutes
import ABEISBlueprint.Catalog.CertifiedCases
import ABEISBlueprint.Catalog.Cubic
import ABEISBlueprint.Catalog.PaperAndExamples
import ABEISBlueprint.Catalog.AutomationAndMemory
import ABEISBlueprint.Catalog.ExperimentalRobinMatrix

open Verso.Doc
open Verso.Genre

namespace ABEISBlueprint

set_option compiler.extract_closed false

attribute [local irreducible]
  ABEISBlueprint.Blueprint.«the canonical document object name»
  ABEISBlueprint.Chapters.Overview.«the canonical document object name»
  ABEISBlueprint.Chapters.Foundations.«the canonical document object name»
  ABEISBlueprint.Chapters.Routes.«the canonical document object name»
  ABEISBlueprint.Chapters.CaseStudies.«the canonical document object name»
  ABEISBlueprint.Catalog.Foundations.«the canonical document object name»
  ABEISBlueprint.Catalog.Semantics.«the canonical document object name»
  ABEISBlueprint.Catalog.ClassicRoutes.«the canonical document object name»
  ABEISBlueprint.Catalog.CertifiedCases.«the canonical document object name»
  ABEISBlueprint.Catalog.Cubic.«the canonical document object name»
  ABEISBlueprint.Catalog.PaperAndExamples.«the canonical document object name»
  ABEISBlueprint.Catalog.AutomationAndMemory.«the canonical document object name»
  ABEISBlueprint.Catalog.ExperimentalRobinMatrix.«the canonical document object name»

private opaque overviewPart : Part Manual :=
  (%doc ABEISBlueprint.Chapters.Overview)

private opaque foundationsPart : Part Manual :=
  (%doc ABEISBlueprint.Chapters.Foundations)

private opaque routesPart : Part Manual :=
  (%doc ABEISBlueprint.Chapters.Routes)

private opaque caseStudiesPart : Part Manual :=
  (%doc ABEISBlueprint.Chapters.CaseStudies)

private opaque catalogFoundationsPart : Part Manual :=
  (%doc ABEISBlueprint.Catalog.Foundations)

private opaque catalogSemanticsPart : Part Manual :=
  (%doc ABEISBlueprint.Catalog.Semantics)

private opaque catalogClassicRoutesPart : Part Manual :=
  (%doc ABEISBlueprint.Catalog.ClassicRoutes)

private opaque catalogCertifiedCasesPart : Part Manual :=
  (%doc ABEISBlueprint.Catalog.CertifiedCases)

private opaque catalogCubicPart : Part Manual :=
  (%doc ABEISBlueprint.Catalog.Cubic)

private opaque catalogPaperAndExamplesPart : Part Manual :=
  (%doc ABEISBlueprint.Catalog.PaperAndExamples)

private opaque catalogAutomationAndMemoryPart : Part Manual :=
  (%doc ABEISBlueprint.Catalog.AutomationAndMemory)

private opaque catalogExperimentalRobinMatrixPart : Part Manual :=
  (%doc ABEISBlueprint.Catalog.ExperimentalRobinMatrix)

/-- The complete public Verso document tree for ASPBE. -/
opaque assembledBlueprint : Part Manual :=
  { (%doc ABEISBlueprint.Blueprint) with
    subParts := #[overviewPart, foundationsPart, routesPart, caseStudiesPart,
      catalogFoundationsPart, catalogSemanticsPart, catalogClassicRoutesPart,
      catalogCertifiedCasesPart, catalogCubicPart, catalogPaperAndExamplesPart,
      catalogAutomationAndMemoryPart, catalogExperimentalRobinMatrixPart] }

end ABEISBlueprint

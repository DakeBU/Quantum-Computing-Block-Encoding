#!/usr/bin/env python3
"""Generate the exhaustive, auditable Verso Blueprint declaration catalog."""

from __future__ import annotations

import argparse
import json
import re
from dataclasses import asdict, dataclass
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
SOURCE_ROOT = ROOT / "QuantumBlockEncoding"
OUTPUT_ROOT = ROOT / "ABEISBlueprint" / "Catalog"
REPORT_PATH = ROOT / "docs" / "blueprint-coverage.json"
GITHUB_BASE = (
    "https://github.com/DakeBU/Quantum-Computing-Block-Encoding/blob/main/"
)

KINDS = (
    "def",
    "abbrev",
    "opaque",
    "inductive",
    "structure",
    "class",
    "theorem",
    "lemma",
)
THEOREM_KINDS = {"theorem", "lemma"}
DECL_RE = re.compile(
    r"^\s*(?:(?:@\[[^\n]*?\])\s*)*"
    r"(?P<mods>(?:(?:private|protected|noncomputable|unsafe|partial)\s+)*)"
    r"(?P<kind>" + "|".join(KINDS) + r")\s+"
    r"(?P<name>[^\s\(\{\[\:]+)"
)
SCOPE_RE = re.compile(r"^\s*(namespace|section)\s*([^\s-]*)")
END_RE = re.compile(r"^\s*end(?:\s+([^\s-]+))?")


@dataclass(frozen=True)
class Declaration:
    kind: str
    name: str
    full_name: str
    source: str
    line: int
    doc: str
    experimental: bool


@dataclass
class Scope:
    kind: str
    name: str


CATALOGS = [
    (
        "Foundations",
        "catalog-foundations",
        {
            "Core.lean",
            "Resources.lean",
            "Circuit.lean",
            "BlockEncoding.lean",
            "StatePreparation.lean",
            "TechnicalLemmas.lean",
        },
    ),
    ("Semantics", "catalog-semantics", {"CircuitSemantics.lean"}),
    ("ClassicRoutes", "catalog-classic-routes", {"BlockEncodingClassics.lean"}),
    (
        "CertifiedCases",
        "catalog-certified-cases",
        {"ColdStartTransferE1.lean", "MainCase.lean", "OptimalControl.lean"},
    ),
    ("Cubic", "catalog-cubic", {"CubicStatePreparation.lean"}),
    (
        "PaperAndExamples",
        "catalog-paper-and-examples",
        {"GHL2025.lean", "Papers/GHL2025.lean", "Examples/RobinHeat.lean"},
    ),
    (
        "AutomationAndMemory",
        "catalog-automation-and-memory",
        {"Automation.lean", "Literature.lean", "OpenProblems.lean"},
    ),
    (
        "ExperimentalRobinMatrix",
        "catalog-experimental-robin-matrix",
        {"RobinMatrix.lean"},
    ),
]


def relative_source(path: Path) -> str:
    return path.relative_to(ROOT).as_posix()


def clean_doc(text: str) -> str:
    text = re.sub(r"\s+", " ", text).strip()
    text = text.replace(chr(96), "'")
    text = text.replace(":::", "").replace("%%%", "")
    text = text.replace("#", "number ")
    return text


def doc_before(text: str, offset: int) -> str:
    prefix = text[:offset]
    end = prefix.rfind("-/")
    if end < 0:
        return ""
    start = prefix.rfind("/--", 0, end)
    if start < 0:
        return ""
    between = prefix[end + 2 :]
    stripped = re.sub(r"@\[[^\n]*?\]", "", between)
    stripped = re.sub(r"/-.*?-/", "", stripped, flags=re.S)
    stripped = re.sub(r"--[^\n]*", "", stripped)
    if stripped.strip():
        return ""
    return clean_doc(prefix[start + 3 : end])


def namespace_parts(scopes: list[Scope]) -> list[str]:
    parts: list[str] = []
    for scope in scopes:
        if scope.kind == "namespace" and scope.name:
            parts.extend(scope.name.split("."))
    return parts


def qualify(name: str, scopes: list[Scope]) -> str:
    if name.startswith("_root_."):
        return name.removeprefix("_root_.")
    return ".".join([*namespace_parts(scopes), name])


def parse_source(path: Path) -> tuple[list[Declaration], list[dict[str, object]]]:
    text = path.read_text(encoding="utf-8")
    lines = text.splitlines(keepends=True)
    scopes: list[Scope] = []
    declarations: list[Declaration] = []
    exclusions: list[dict[str, object]] = []
    offset = 0
    comment_depth = 0

    for line_no, line in enumerate(lines, start=1):
        starts_in_comment = comment_depth > 0
        match = None if starts_in_comment else DECL_RE.match(line)
        if match:
            kind = match.group("kind")
            name = match.group("name")
            modifiers = match.group("mods").split()
            full_name = qualify(name, scopes)
            if "private" in modifiers:
                exclusions.append(
                    {
                        "kind": kind,
                        "name": full_name,
                        "source": relative_source(path),
                        "line": line_no,
                        "reason": "private declaration",
                    }
                )
            else:
                declarations.append(
                    Declaration(
                        kind=kind,
                        name=name,
                        full_name=full_name,
                        source=relative_source(path),
                        line=line_no,
                        doc=doc_before(text, offset),
                        experimental=relative_source(path)
                        == "QuantumBlockEncoding/RobinMatrix.lean",
                    )
                )

        scope_match = None if starts_in_comment else SCOPE_RE.match(line)
        if scope_match:
            scopes.append(Scope(scope_match.group(1), scope_match.group(2)))
        else:
            end_match = None if starts_in_comment else END_RE.match(line)
            if end_match and scopes:
                expected = end_match.group(1)
                if expected:
                    for index in range(len(scopes) - 1, -1, -1):
                        if scopes[index].name == expected:
                            del scopes[index:]
                            break
                    else:
                        scopes.pop()
                else:
                    scopes.pop()
        comment_depth += line.count("/-") - line.count("-/")
        if comment_depth < 0:
            comment_depth = 0
        offset += len(line)

    return declarations, exclusions


def lean_string(text: str) -> str:
    return text.replace("\\", "\\\\").replace('"', '\\"')


def render_declaration(decl: Declaration) -> str:
    directive = "theorem" if decl.kind in THEOREM_KINDS else "definition"
    if decl.experimental:
        status = (
            "This declaration belongs to the experimental Robin-matrix development; "
            "the chapter header records its proof status."
        )
    else:
        status = "This declaration is part of the default ABEIS import surface."
    explanation = decl.doc or (
        "No source docstring is present yet. The Lean signature below is the "
        f"authoritative contract for this {decl.kind}."
    )
    url = f"{GITHUB_BASE}{decl.source}#L{decl.line}"
    return (
        f':::{directive} "{lean_string(decl.full_name)}" '
        f'(lean := "{lean_string(decl.full_name)}")\n'
        f"Source documentation: {chr(96)}{explanation}{chr(96)}.\n\n"
        f"Kind: {decl.kind}. {status}\n\n"
        f"Source: [{decl.source}:{decl.line}]({url}).\n"
        ":::\n"
    )


def render_catalog(
    module_name: str, slug: str, declarations: list[Declaration]
) -> str:
    by_source: dict[str, list[Declaration]] = {}
    for declaration in declarations:
        by_source.setdefault(declaration.source, []).append(declaration)

    imports = ["import QuantumBlockEncoding"]
    if any(decl.experimental for decl in declarations):
        imports.append("import QuantumBlockEncoding.RobinMatrix")
    body = [
        *imports,
        "import Verso",
        "import VersoManual",
        "import VersoBlueprint",
        "",
        "open Verso.Genre",
        "open Verso.Genre.Manual",
        "open Informal",
        "",
        "set_option linter.hashCommand false",
        "set_option linter.style.longLine false",
        "set_option verso.blueprint.externalCode.strictResolve true",
        "",
        f'#doc (Manual) "Declaration catalog: {module_name}" =>',
        "%%%",
        f'file := "{slug}"',
        "%%%",
        "",
        "This chapter is generated from the Lean source. Every node denotes one explicit public",
        "declaration, and every Lean link is checked during the Blueprint build. Definitions appear",
        "in source order before later results whenever the source module does so.",
        "",
    ]
    if any(decl.experimental for decl in declarations):
        body.extend(
            [
                "*Experimental status.* RobinMatrix.lean is not imported by the default library",
                "surface. It is catalogued for completeness and currently contains two sorry-guarded",
                "diagnostic theorems. Those nodes are visible obligations, not certified facts.",
                "",
            ]
        )
    for source, source_declarations in by_source.items():
        body.extend(
            [
                f"# {source}",
                "",
                f"{len(source_declarations)} explicit public declarations, in source order.",
                "",
            ]
        )
        for declaration in source_declarations:
            body.append(render_declaration(declaration))
    return "\n".join(body).rstrip() + "\n"


def collect() -> tuple[list[Declaration], list[dict[str, object]]]:
    declarations: list[Declaration] = []
    exclusions: list[dict[str, object]] = []
    for source in sorted(SOURCE_ROOT.rglob("*.lean")):
        found, excluded = parse_source(source)
        declarations.extend(found)
        exclusions.extend(excluded)
    return declarations, exclusions


def generate(check: bool) -> int:
    declarations, exclusions = collect()
    assigned: set[str] = set()
    outputs: dict[Path, str] = {}

    for module_name, slug, source_names in CATALOGS:
        selected = [
            declaration
            for declaration in declarations
            if declaration.source.removeprefix("QuantumBlockEncoding/") in source_names
        ]
        assigned.update(declaration.full_name for declaration in selected)
        outputs[OUTPUT_ROOT / f"{module_name}.lean"] = render_catalog(
            module_name, slug, selected
        )

    unassigned = [
        declaration
        for declaration in declarations
        if declaration.full_name not in assigned
    ]
    counts: dict[str, int] = {}
    for declaration in declarations:
        counts[declaration.full_name] = counts.get(declaration.full_name, 0) + 1
    duplicate_names = sorted(name for name, count in counts.items() if count > 1)
    if unassigned or duplicate_names:
        details = {
            "unassigned": [asdict(declaration) for declaration in unassigned],
            "duplicateNames": duplicate_names,
        }
        raise SystemExit(
            "catalog partition is incomplete:\n"
            + json.dumps(details, indent=2, ensure_ascii=False)
        )

    by_kind: dict[str, int] = {}
    by_source: dict[str, int] = {}
    for declaration in declarations:
        by_kind[declaration.kind] = by_kind.get(declaration.kind, 0) + 1
        by_source[declaration.source] = by_source.get(declaration.source, 0) + 1
    report = {
        "schemaVersion": 1,
        "scope": (
            "Explicit public def/abbrev/opaque/inductive/structure/class/"
            "theorem/lemma declarations"
        ),
        "publicDeclarationCount": len(declarations),
        "privateDeclarationExclusionCount": len(exclusions),
        "byKind": dict(sorted(by_kind.items())),
        "bySource": dict(sorted(by_source.items())),
        "excluded": exclusions,
        "generatedCatalogs": [
            path.relative_to(ROOT).as_posix() for path in outputs
        ],
    }
    outputs[REPORT_PATH] = (
        json.dumps(report, indent=2, ensure_ascii=False) + "\n"
    )

    stale: list[str] = []
    for path, content in outputs.items():
        if check:
            if not path.exists() or path.read_text(encoding="utf-8") != content:
                stale.append(path.relative_to(ROOT).as_posix())
        else:
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_text(content, encoding="utf-8", newline="\n")

    if stale:
        print("Generated Blueprint files are stale:")
        for path in stale:
            print(f"  {path}")
        return 1

    action = "checked" if check else "generated"
    print(
        f"{action} {len(declarations)} public declarations; "
        f"excluded {len(exclusions)} private declarations"
    )
    return 0


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--check",
        action="store_true",
        help="fail if committed generated files differ from the source inventory",
    )
    args = parser.parse_args()
    return generate(args.check)


if __name__ == "__main__":
    raise SystemExit(main())

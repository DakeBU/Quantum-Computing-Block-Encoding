#!/usr/bin/env python3
"""Build and query a license-aware local memory index for ATLAS v1.

ATLAS v1 is an external, separately licensed Lean project.  This tool keeps
its source under ``outer_repos`` and writes generated retrieval data only to
the ignored ``.qbe`` directory.  The ASPBE repository stores the generator,
the pinned provenance manifest, and curated relevance notes, but not copied
ATLAS theorem bodies.
"""

from __future__ import annotations

import argparse
import datetime as dt
import json
import os
import re
import subprocess
import sys
from dataclasses import dataclass
from pathlib import Path
from typing import Iterable


ROOT = Path(__file__).resolve().parents[1]
MANIFEST_PATH = (
    ROOT / "research-wiki" / "external-lean-libraries" / "atlas-lean.json"
)
MEMORY_ROOT = ROOT / ".qbe" / "external-memory" / "atlas-lean"
INDEX_PATH = MEMORY_ROOT / "theorems.jsonl"
SUMMARY_PATH = MEMORY_ROOT / "summary.json"
GATE_PATH = MEMORY_ROOT / "gate.json"

DECL_KINDS = ("theorem", "lemma")
DECL_RE = re.compile(
    r"^\s*(?:(?:@\[[^\n]*?\])\s*)*"
    r"(?P<mods>(?:(?:private|protected|noncomputable|unsafe|partial)\s+)*)"
    r"(?P<kind>theorem|lemma)\s+"
    r"(?P<name>[^\s\(\{\[\:]+)"
)
ANY_DECL_RE = re.compile(
    r"^\s*(?:(?:@\[[^\n]*?\])\s*)*"
    r"(?:(?:private|protected|noncomputable|unsafe|partial)\s+)*"
    r"(?:def|abbrev|opaque|inductive|structure|class|instance|theorem|lemma)\s+"
)
SCOPE_RE = re.compile(r"^\s*(namespace|section)\s*([^\s-]*)")
END_RE = re.compile(r"^\s*end(?:\s+([^\s-]+))?")
SORRY_RE = re.compile(r"\b(?:sorry|sorryAx)\b")

RELEVANCE_RULES: tuple[tuple[str, tuple[str, ...]], ...] = (
    (
        "linear-algebra-and-matrices",
        ("matrix", "linear", "basis", "eigen", "spectral", "orthogonal", "adjoint"),
    ),
    (
        "norms-inner-products-and-normalization",
        ("norm", "innerproduct", "inner_product", "cauchy", "holder", "parseval"),
    ),
    (
        "complex-fourier-and-polynomials",
        ("complex", "fourier", "polynomial", "chebyshev", "character", "vandermonde"),
    ),
    (
        "finite-sums-products-and-tensors",
        ("finsum", "finset", "sum_", "prod_", "tensor", "directsum", "direct_sum"),
    ),
    (
        "boolean-permutation-and-reversible-arithmetic",
        ("boolean", "bool", "xor", "bit", "permutation", "involutive", "modular"),
    ),
    (
        "probability-and-concentration",
        ("probability", "expectation", "variance", "concentration", "markov", "chernoff"),
    ),
    (
        "algorithms-complexity-and-resource-reasoning",
        ("algorithm", "runtime", "complexity", "bitops", "spacecomplexity", "timecomplexity"),
    ),
)


@dataclass(frozen=True)
class Scope:
    kind: str
    name: str


def load_manifest() -> dict[str, object]:
    return json.loads(MANIFEST_PATH.read_text(encoding="utf-8"))


def atlas_root(manifest: dict[str, object]) -> Path:
    override = os.environ.get("ASPBE_ATLAS_ROOT", "").strip()
    if override:
        root = Path(override).expanduser()
    else:
        root = ROOT.parent / str(manifest["localCheckout"])
    if (root / "v1" / "Atlas").is_dir():
        return root / "v1"
    return root


def run_git(root: Path, *args: str) -> str:
    result = subprocess.run(
        ["git", *args], cwd=root, text=True, capture_output=True, check=False
    )
    return result.stdout.strip() if result.returncode == 0 else ""


def source_url(manifest: dict[str, object], source: str, line: int) -> str:
    repository = str(manifest["upstreamRepository"]).removesuffix(".git")
    revision = str(manifest["revision"])
    return f"{repository}/blob/{revision}/v1/{source}#L{line}"


def report_records(root: Path) -> dict[tuple[str, str], list[dict[str, object]]]:
    records: dict[tuple[str, str], list[dict[str, object]]] = {}
    for report_path in sorted((root / "Atlas").glob("*/report.json")):
        report = json.loads(report_path.read_text(encoding="utf-8"))
        book = report_path.parent.name
        details = report.get("statements", {}).get("details", [])
        for item in details:
            declaration = item.get("lean_declaration")
            if not declaration:
                continue
            record = dict(item)
            record["book"] = book
            records.setdefault((book, str(declaration)), []).append(record)
    return records


def merge_report_variants(
    variants: list[dict[str, object]] | None,
) -> dict[str, object] | None:
    """Conservatively merge duplicate evaluations of one declaration."""
    if not variants:
        return None
    merged = dict(variants[0])
    merged["passed"] = all(item.get("passed") is True for item in variants)
    merged["report_variant_count"] = len(variants)

    score_keys = ("compilation", "faithfulness", "proof_integrity", "code_quality")
    merged_scores: dict[str, object] = {}
    for key in score_keys:
        values = [
            item.get("scores", {}).get(key)
            for item in variants
            if isinstance(item.get("scores"), dict)
            and isinstance(item.get("scores", {}).get(key), (int, float))
        ]
        merged_scores[key] = min(values) if values else None
    merged["scores"] = merged_scores

    for key in ("axioms", "sorry_deps"):
        values = sorted(
            {
                str(item.get(key, "")).strip()
                for item in variants
                if str(item.get(key, "")).strip()
            }
        )
        merged[key] = "\n".join(values)
    return merged


def active_code_lines(lines: list[str]) -> list[bool]:
    """Return whether each line starts in Lean code rather than a block comment."""
    active: list[bool] = []
    block_depth = 0
    for line in lines:
        active.append(block_depth == 0)
        index = 0
        in_string = False
        escaped = False
        while index < len(line):
            if block_depth > 0:
                if line.startswith("/-", index):
                    block_depth += 1
                    index += 2
                    continue
                if line.startswith("-/", index):
                    block_depth -= 1
                    index += 2
                    continue
                index += 1
                continue
            char = line[index]
            if in_string:
                if escaped:
                    escaped = False
                elif char == "\\":
                    escaped = True
                elif char == "\"":
                    in_string = False
                index += 1
                continue
            if line.startswith("--", index):
                break
            if line.startswith("/-", index):
                block_depth += 1
                index += 2
                continue
            if char == "\"":
                in_string = True
            index += 1
    return active


def declaration_blocks(path: Path) -> Iterable[tuple[int, int, re.Match[str], list[str], list[Scope]]]:
    lines = path.read_text(encoding="utf-8", errors="replace").splitlines()
    scopes: list[Scope] = []
    declarations: list[tuple[int, re.Match[str], list[Scope]]] = []
    line_is_active = active_code_lines(lines)

    for index, line in enumerate(lines):
        if not line_is_active[index] or line.lstrip().startswith("--"):
            continue

        match = DECL_RE.match(line)
        if match:
            declarations.append((index, match, list(scopes)))

        scope_match = SCOPE_RE.match(line)
        if scope_match:
            scopes.append(Scope(scope_match.group(1), scope_match.group(2)))
            continue
        end_match = END_RE.match(line)
        if end_match and scopes:
            named = end_match.group(1)
            if named:
                for scope_index in range(len(scopes) - 1, -1, -1):
                    if scopes[scope_index].name == named:
                        scopes = scopes[:scope_index]
                        break
                else:
                    scopes.pop()
            else:
                scopes.pop()

    for offset, (start, match, decl_scopes) in enumerate(declarations):
        next_start = declarations[offset + 1][0] if offset + 1 < len(declarations) else len(lines)
        end = next_start
        for candidate in range(start + 1, next_start):
            if line_is_active[candidate] and ANY_DECL_RE.match(lines[candidate]):
                end = candidate
                break
        yield start + 1, end, match, lines[start:end], decl_scopes


def full_name(name: str, scopes: list[Scope]) -> str:
    namespace = ".".join(scope.name for scope in scopes if scope.kind == "namespace" and scope.name)
    return f"{namespace}.{name}" if namespace else name


def relevance_tags(record: dict[str, object]) -> list[str]:
    haystack = " ".join(
        str(record.get(key, ""))
        for key in ("fullName", "source", "description", "location")
    ).lower()
    return [
        category
        for category, needles in RELEVANCE_RULES
        if any(needle in haystack for needle in needles)
    ]


def quality_status(report: dict[str, object] | None, direct_sorry: bool) -> str:
    if report is None:
        return "upstream-compiled-not-evaluated"
    axioms = str(report.get("axioms", ""))
    if report.get("passed") is True and "sorryAx" not in axioms and not direct_sorry:
        return "upstream-evaluated-clean"
    return "upstream-evaluated-rejected"


def build_records(root: Path, manifest: dict[str, object]) -> list[dict[str, object]]:
    reports = report_records(root)
    records: list[dict[str, object]] = []
    source_root = root / "Atlas"
    for path in sorted(source_root.rglob("*.lean")):
        relative = path.relative_to(root).as_posix()
        book = path.relative_to(source_root).parts[0]
        for line, _end, match, block, scopes in declaration_blocks(path):
            name = match.group("name")
            qualified = full_name(name, scopes)
            report = merge_report_variants(reports.get((book, qualified)))
            block_text = "\n".join(block)
            statement_lines: list[str] = []
            for source_line in block[:40]:
                statement_lines.append(source_line)
                if ":= by" in source_line or source_line.rstrip().endswith(" :="):
                    break
            record: dict[str, object] = {
                "kind": match.group("kind"),
                "name": name,
                "fullName": qualified,
                "book": book,
                "source": relative,
                "line": line,
                "private": "private" in match.group("mods").split(),
                "protected": "protected" in match.group("mods").split(),
                "directSorry": bool(SORRY_RE.search(block_text)),
                "statementPreview": "\n".join(statement_lines)[:5000],
                "sourceUrl": source_url(manifest, relative, line),
                "upstreamTarget": report is not None,
            }
            if report is not None:
                scores = dict(report.get("scores", {}))
                record.update(
                    {
                        "reportPassed": bool(report.get("passed")),
                        "matchConfidence": report.get("match_confidence"),
                        "description": report.get("description"),
                        "location": report.get("location"),
                        "compilationScore": scores.get("compilation"),
                        "reportVariantCount": report.get("report_variant_count", 1),
                        "faithfulnessScore": scores.get("faithfulness"),
                        "proofIntegrityScore": scores.get("proof_integrity"),
                        "codeQualityScore": scores.get("code_quality"),
                        "axioms": report.get("axioms"),
                        "sorryDependencies": report.get("sorry_deps"),
                        "dependencies": report.get("deps"),
                    }
                )
            record["qualityStatus"] = quality_status(report, bool(record["directSorry"]))
            record["aspbeStatus"] = "external-memory-only"
            record["relevanceTags"] = relevance_tags(record)
            records.append(record)
    return records


def write_index(root: Path, manifest: dict[str, object]) -> dict[str, object]:
    revision = run_git(root, "rev-parse", "HEAD")
    expected = str(manifest["revision"])
    if revision != expected:
        raise SystemExit(f"ATLAS revision mismatch: expected {expected}, found {revision or 'unknown'}")

    records = build_records(root, manifest)
    MEMORY_ROOT.mkdir(parents=True, exist_ok=True)
    INDEX_PATH.write_text(
        "".join(json.dumps(record, ensure_ascii=False, sort_keys=True) + "\n" for record in records),
        encoding="utf-8",
    )
    tag_counts: dict[str, int] = {}
    status_counts: dict[str, int] = {}
    for record in records:
        status = str(record["qualityStatus"])
        status_counts[status] = status_counts.get(status, 0) + 1
        for tag in record["relevanceTags"]:
            tag_counts[str(tag)] = tag_counts.get(str(tag), 0) + 1
    summary: dict[str, object] = {
        "schemaVersion": 1,
        "generatedAt": dt.datetime.now(dt.timezone.utc).isoformat(),
        "revision": revision,
        "toolchain": (root / "lean-toolchain").read_text(encoding="utf-8").strip(),
        "leanFiles": len(list((root / "Atlas").rglob("*.lean"))),
        "theoremLemmaCount": len(records),
        "publicCount": sum(not bool(record["private"]) for record in records),
        "directSorryCount": sum(bool(record["directSorry"]) for record in records),
        "evaluatedTargetCount": sum(bool(record["upstreamTarget"]) for record in records),
        "qualityStatusCounts": dict(sorted(status_counts.items())),
        "relevanceTagCounts": dict(sorted(tag_counts.items())),
        "indexPath": str(INDEX_PATH.relative_to(ROOT)),
        "licenseBoundary": manifest["licenseBoundary"],
    }
    SUMMARY_PATH.write_text(json.dumps(summary, indent=2) + "\n", encoding="utf-8")
    return summary


def ensure_index() -> dict[str, object]:
    manifest = load_manifest()
    root = atlas_root(manifest)
    if not (root / "Atlas").is_dir():
        raise SystemExit(
            "ATLAS checkout not found. Follow the pinned checkout command in "
            "research-wiki/external-lean-libraries/atlas-lean.md or set ASPBE_ATLAS_ROOT."
        )
    revision = run_git(root, "rev-parse", "HEAD")
    if not SUMMARY_PATH.exists():
        return write_index(root, manifest)
    summary = json.loads(SUMMARY_PATH.read_text(encoding="utf-8"))
    if summary.get("revision") != revision:
        return write_index(root, manifest)
    return summary


def iter_index() -> Iterable[dict[str, object]]:
    ensure_index()
    for line in INDEX_PATH.read_text(encoding="utf-8").splitlines():
        if line.strip():
            yield json.loads(line)


def search_records(
    query: str,
    *,
    limit: int,
    include_private: bool,
    clean_only: bool,
    relevance: str,
) -> list[dict[str, object]]:
    tokens = [token.lower() for token in query.split() if token]
    scored: list[tuple[int, str, dict[str, object]]] = []
    for record in iter_index():
        if record.get("private") and not include_private:
            continue
        if clean_only and record.get("qualityStatus") != "upstream-evaluated-clean":
            continue
        if relevance and relevance not in record.get("relevanceTags", []):
            continue
        searchable = " ".join(
            str(record.get(key, ""))
            for key in ("fullName", "source", "description", "location", "statementPreview")
        ).lower()
        if tokens and not all(token in searchable for token in tokens):
            continue
        name = str(record["fullName"]).lower()
        score = sum(8 if token in name else 1 for token in tokens)
        score += 3 if record.get("qualityStatus") == "upstream-evaluated-clean" else 0
        score += 1 if record.get("relevanceTags") else 0
        scored.append((-score, str(record["fullName"]), record))
    scored.sort(key=lambda item: (item[0], item[1]))
    return [item[2] for item in scored[: max(1, limit)]]


def print_records(records: Iterable[dict[str, object]], *, json_output: bool) -> None:
    rows = list(records)
    if json_output:
        print(json.dumps(rows, indent=2, ensure_ascii=False))
        return
    for record in rows:
        tags = ",".join(record.get("relevanceTags", [])) or "general"
        scores = ""
        if record.get("upstreamTarget"):
            scores = (
                f" scores=f{record.get('faithfulnessScore')}/"
                f"i{record.get('proofIntegrityScore')}/q{record.get('codeQualityScore')}"
            )
        print(
            f"{record['fullName']} [{record['qualityStatus']}; {tags}]{scores}\n"
            f"  {record['source']}:{record['line']}\n"
            f"  {record['sourceUrl']}"
        )


def command_index(_: argparse.Namespace) -> int:
    manifest = load_manifest()
    summary = write_index(atlas_root(manifest), manifest)
    print(json.dumps(summary, indent=2))
    return 0


def command_search(args: argparse.Namespace) -> int:
    records = search_records(
        args.query,
        limit=args.limit,
        include_private=args.include_private,
        clean_only=args.clean_only,
        relevance=args.relevance,
    )
    print_records(records, json_output=args.json)
    return 0 if records else 1


def command_show(args: argparse.Namespace) -> int:
    matches = [
        record
        for record in iter_index()
        if record["fullName"] == args.declaration or record["name"] == args.declaration
    ]
    if len(matches) != 1:
        print_records(matches[:20], json_output=False)
        print(f"expected one declaration, found {len(matches)}", file=sys.stderr)
        return 1
    record = matches[0]
    manifest = load_manifest()
    root = atlas_root(manifest)
    path = root / str(record["source"])
    selected = None
    for line, _end, _match, block, scopes in declaration_blocks(path):
        if line == record["line"]:
            selected = "\n".join(block).rstrip()
            if "\n\n/--" in selected:
                selected = selected.split("\n\n/--", 1)[0].rstrip()
            break
    if selected is None:
        raise SystemExit("indexed declaration could not be recovered from the pinned source")
    print(
        f"-- External ATLAS v1 source: {record['sourceUrl']}\n"
        f"-- License: CC BY-NC 4.0 plus the upstream no-training rider.\n"
        f"-- ASPBE status: external memory only; write and compile a local adapter before promotion.\n"
    )
    print(selected)
    return 0


def command_verify(_: argparse.Namespace) -> int:
    manifest = load_manifest()
    root = atlas_root(manifest)
    summary = write_index(root, manifest)
    started = dt.datetime.now(dt.timezone.utc)
    result = subprocess.run(["lake", "build"], cwd=root, check=False)
    finished = dt.datetime.now(dt.timezone.utc)
    gate = {
        "schemaVersion": 1,
        "revision": summary["revision"],
        "toolchain": summary["toolchain"],
        "command": "lake build",
        "exitCode": result.returncode,
        "passed": result.returncode == 0,
        "startedAt": started.isoformat(),
        "finishedAt": finished.isoformat(),
        "theoremLemmaCount": summary["theoremLemmaCount"],
        "directSorryCount": summary["directSorryCount"],
        "scope": "ATLAS v1 compiles under its own pin; this is not an ASPBE adapter gate and does not prove semantic fidelity.",
    }
    MEMORY_ROOT.mkdir(parents=True, exist_ok=True)
    GATE_PATH.write_text(json.dumps(gate, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(gate, indent=2))
    return result.returncode


def command_status(_: argparse.Namespace) -> int:
    summary = ensure_index()
    gate = json.loads(GATE_PATH.read_text(encoding="utf-8")) if GATE_PATH.exists() else None
    print(json.dumps({"summary": summary, "gate": gate}, indent=2))
    return 0


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description="ASPBE external ATLAS v1 memory")
    sub = parser.add_subparsers(dest="command", required=True)
    sub.add_parser("index", help="rebuild the local full theorem/lemma index").set_defaults(func=command_index)
    search = sub.add_parser("search", help="search the local ATLAS theorem/lemma memory")
    search.add_argument("query")
    search.add_argument("--limit", type=int, default=20)
    search.add_argument("--include-private", action="store_true")
    search.add_argument("--clean-only", action="store_true")
    search.add_argument("--relevance", default="")
    search.add_argument("--json", action="store_true")
    search.set_defaults(func=command_search)
    show = sub.add_parser("show", help="show one exact declaration from the pinned checkout")
    show.add_argument("declaration")
    show.set_defaults(func=command_show)
    sub.add_parser("verify", help="index and run ATLAS's own pinned lake build").set_defaults(func=command_verify)
    sub.add_parser("status", help="show local index and external build-gate status").set_defaults(func=command_status)
    return parser


def main() -> int:
    args = build_parser().parse_args()
    return int(args.func(args))


if __name__ == "__main__":
    raise SystemExit(main())

#!/usr/bin/env python3
"""Lean source trust-boundary scanner used by ABEIS build gates."""

from __future__ import annotations

import re
from dataclasses import dataclass
from pathlib import Path
from typing import Iterable


HOLE_PATTERN = re.compile(r"\b(sorry|admit|axiom)\b")
DECLARATION_PATTERN = re.compile(
    r"\b(?:theorem|lemma|def|abbrev|instance|opaque|axiom)\s+"
    r"([A-Za-z_][A-Za-z0-9_'.]*)"
)


@dataclass(frozen=True)
class TrustFinding:
    path: Path
    line: int
    token: str
    declaration: str


def strip_lean_comments_and_strings(source: str) -> str:
    """Replace comments and strings with spaces while preserving line numbers."""

    output: list[str] = []
    index = 0
    block_depth = 0
    in_line_comment = False
    in_string = False
    escaped = False
    while index < len(source):
        char = source[index]
        pair = source[index : index + 2]
        if in_line_comment:
            if char == "\n":
                in_line_comment = False
                output.append("\n")
            else:
                output.append(" ")
            index += 1
            continue
        if block_depth:
            if pair == "/-":
                block_depth += 1
                output.extend((" ", " "))
                index += 2
            elif pair == "-/":
                block_depth -= 1
                output.extend((" ", " "))
                index += 2
            else:
                output.append("\n" if char == "\n" else " ")
                index += 1
            continue
        if in_string:
            output.append("\n" if char == "\n" else " ")
            if escaped:
                escaped = False
            elif char == "\\":
                escaped = True
            elif char == '"':
                in_string = False
            index += 1
            continue
        if pair == "--":
            in_line_comment = True
            output.extend((" ", " "))
            index += 2
        elif pair == "/-":
            block_depth = 1
            output.extend((" ", " "))
            index += 2
        elif char == '"':
            in_string = True
            output.append(" ")
            index += 1
        else:
            output.append(char)
            index += 1
    return "".join(output)


def scan_lean_source(path: Path, source: str) -> list[TrustFinding]:
    stripped = strip_lean_comments_and_strings(source)
    declarations: list[tuple[int, str]] = [
        (match.start(), match.group(1))
        for match in DECLARATION_PATTERN.finditer(stripped)
    ]
    findings: list[TrustFinding] = []
    for match in HOLE_PATTERN.finditer(stripped):
        declaration = ""
        for position, name in declarations:
            if position > match.start():
                break
            declaration = name
        findings.append(
            TrustFinding(
                path=path,
                line=stripped.count("\n", 0, match.start()) + 1,
                token=match.group(1),
                declaration=declaration,
            )
        )
    return findings


def lean_files(root: Path) -> Iterable[Path]:
    """Yield theorem-bearing library and test sources, not Verso prose modules."""

    top_level = (root / "QuantumBlockEncoding.lean", root / "Tests.lean")
    for path in top_level:
        if path.exists():
            yield path
    for directory in (root / "QuantumBlockEncoding", root / "ABEISTests"):
        if directory.exists():
            yield from directory.rglob("*.lean")


def scan_repository(root: Path) -> list[TrustFinding]:
    findings: list[TrustFinding] = []
    for path in sorted(lean_files(root)):
        source = path.read_text(encoding="utf-8", errors="replace")
        findings.extend(scan_lean_source(path.relative_to(root), source))
    return findings

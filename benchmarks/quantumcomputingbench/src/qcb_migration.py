"""Narrow, explicit compatibility for the 2026-10-22 integration release.

Frozen artifacts and their original hashes are never rewritten. Historical
pipeline bytes must exist in Git, current bytes must match the migration ledger,
and AST checks admit only the documented attribution/loader changes. This is
compatibility evidence, not a claim that the historical pipeline was rerun.
"""
from __future__ import annotations

import ast
from functools import lru_cache
import hashlib
import json
from pathlib import Path
import subprocess

from qcb_integrity import matches, snapshot_input_matches, text_sha

BASE = "benchmarks/quantumcomputingbench/"
LEDGER = BASE + "manifests/integration-20261022/compatibility.json"
SOURCE_PATH = "website/scripts/build_site.py"
PIPELINE_PATHS = {
    BASE + "scripts/qcb.py",
    BASE + "scripts/nl_qa.py",
    BASE + "src/qcb_nl.py",
}


@lru_cache(maxsize=16)
def _historical(root, commit, relative):
    return subprocess.check_output(
        ["git", "-C", root, "show", f"{commit}:{relative}"],
        stderr=subprocess.DEVNULL, timeout=20,
    ).replace(b"\r\n", b"\n")


class _LoaderCompatibility(ast.NodeTransformer):
    def visit_ImportFrom(self, node):
        return None if node.module == "qcb_migration" else node

    def visit_UnaryOp(self, node):
        if (isinstance(node.op, ast.Not) and isinstance(node.operand, ast.Call)
                and isinstance(node.operand.func, ast.Name)
                and node.operand.func.id == "pipeline_matches"
                and self.relative.endswith("/scripts/qcb.py")):
            path, expected = node.operand.args
            return ast.Compare(
                left=ast.Call(func=ast.Name(id="text_sha", ctx=ast.Load()),
                              args=[path], keywords=[]),
                ops=[ast.NotEq()], comparators=[expected],
            )
        return self.generic_visit(node)

    def visit_Name(self, node):
        aliases = {"source_matches": "snapshot_input_matches",
                   "pipeline_matches": "matches"}
        if node.id in aliases:
            return ast.copy_location(ast.Name(id=aliases[node.id], ctx=node.ctx), node)
        return node


def equivalent(old, current, relative):
    """Fail closed on any code/semantic delta outside the declared migration."""
    before, after = ast.parse(old), ast.parse(current)
    if relative == SOURCE_PATH:
        def organizer(tree):
            return next(n for n in tree.body if isinstance(n, ast.Assign)
                        and any(isinstance(t, ast.Name) and t.id == "ORGANIZERS"
                                for t in n.targets))
        first, second = organizer(before), organizer(after)
        old_people = ast.literal_eval(first.value)
        new_people = ast.literal_eval(second.value)
        index = next(i for i, row in enumerate(old_people) if row[0] == "Xiajie Huang")
        expected = old_people[:index + 1] + (("Outongyi Lv", "Shanghai Jiao Tong University"),) + old_people[index + 1:]
        if new_people != expected:
            return False
        second.value = first.value
    elif relative in PIPELINE_PATHS:
        transformer = _LoaderCompatibility()
        transformer.relative = relative
        after = transformer.visit(after)
    else:
        return False
    return ast.dump(before, include_attributes=False) == ast.dump(after, include_attributes=False)


def _approved(root, relative, expected, kind):
    root = Path(root).resolve()
    path = (root / relative).resolve()
    if not path.is_relative_to(root) or not path.is_file():
        return False
    if ((kind == "source" and relative != SOURCE_PATH)
            or (kind == "pipeline" and relative not in PIPELINE_PATHS)):
        return False
    try:
        ledger = json.loads((root / LEDGER).read_text(encoding="utf-8"))
        record = ledger["inputs"][relative]
        if (record["kind"] != kind or record["original_sha256"] != expected
                or record["current_sha256"] != text_sha(path)):
            return False
        old = _historical(str(root), record["original_commit"], relative)
        if hashlib.sha256(old).hexdigest() != expected:
            return False
        return equivalent(old.decode("utf-8"), path.read_text(encoding="utf-8"), relative)
    except (KeyError, ValueError, OSError, subprocess.SubprocessError, StopIteration, SyntaxError):
        return False


def source_matches(root, relative, expected):
    return (snapshot_input_matches(root, relative, expected)
            or _approved(root, relative, expected, "source"))


def pipeline_matches(path, expected):
    path = Path(path).resolve()
    if matches(path, expected):
        return True
    for relative in PIPELINE_PATHS:
        suffix = Path(relative).parts
        if path.parts[-len(suffix):] == suffix:
            root = path.parents[len(suffix) - 1]
            return _approved(root, relative, expected, "pipeline")
    return False

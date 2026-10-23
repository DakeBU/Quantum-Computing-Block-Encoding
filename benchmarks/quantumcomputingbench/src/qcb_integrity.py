"""Explicit text hashing and immutable release checks, including legacy v2.

LF normalization is the only permitted working-tree transformation. Historical
snapshot adapters are checked against their exact committed blob, never silently
replaced by the currently running adapter. Library inputs must still match.
"""
import hashlib
from pathlib import Path
import subprocess

LEGACY_ADAPTER = "benchmarks/quantumcomputingbench/src/qcb_snapshot.py"
LEGACY_SHA = "b4f56a0e17945fd6e11605be3cb903c4792225ed0a4829883dc3003b4a58b3ac"
LEGACY_COMMIT = "86b9e677566498da04faebcf4e5ed57f177c6bb1"


def text_sha(path):
    return hashlib.sha256(Path(path).read_bytes().replace(b"\r\n", b"\n")).hexdigest()


def matches(path, expected):
    return Path(path).is_file() and text_sha(path) == expected


def snapshot_input_matches(root, relative, expected):
    root = Path(root).resolve()
    path = (root / relative).resolve()
    if not path.is_relative_to(root):
        return False
    if matches(path, expected):
        return True
    if relative == LEGACY_ADAPTER and expected == LEGACY_SHA:
        try:
            blob = subprocess.check_output(
                ["git", "-C", str(root), "show", f"{LEGACY_COMMIT}:{relative}"],
                stderr=subprocess.DEVNULL, timeout=20)
        except (OSError, subprocess.SubprocessError):
            return False
        return hashlib.sha256(blob).hexdigest() == expected
    return False


# Frozen older releases are retained for audit, but withdrawn answers must not
# silently re-enter training/scoring. Corrected successors need fresh review.
WITHDRAWN = {
    "qs-resource-depth-parallel-vs-serial": "max ancilla bookkeeping is not disjoint physical peak",
    "neg-prepare-firstcolumn-positivity": "strict positivity is sufficient, not necessary",
    "neg-ry-not-half-only-at-pi": "amplitude-plane angle and Bloch angle conflated",
    "k-becost-lexicographic-order": "abstract oracle unit count versus expanded elementary cost",
}


def check_not_withdrawn(items):
    bad = sorted({i["key"] for i in items} & WITHDRAWN.keys())
    if bad:
        raise ValueError("withdrawn gold: " + ", ".join(bad) + "; use release-v3; historical files are audit-only")

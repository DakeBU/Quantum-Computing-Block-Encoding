#!/usr/bin/env python3
"""Build QuantumComputinglib from the ASPBE Lean inventory and teaching content."""

from __future__ import annotations

import argparse
import datetime as dt
import html
import json
import os
import re
import shutil
import subprocess
import sys
import unicodedata
from collections import Counter
from pathlib import Path
from urllib.parse import quote


ROOT = Path(__file__).resolve().parents[2]
WEBSITE_ROOT = ROOT / "website"
SCRIPT_ROOT = Path(__file__).resolve().parent
# `build_site.py` is used both as an executable script and as a dynamically
# loaded module in the site-contract tests.  Keep both the website package root
# and this sibling-script directory importable in either mode.
sys.path.insert(0, str(WEBSITE_ROOT))
sys.path.insert(0, str(SCRIPT_ROOT))

from content import (  # noqa: E402
    CHAPTERS,
    IMPLEMENTATION_MAP,
    LESSONS,
    ROADMAP,
    STATUS_ORDER,
    WORKFLOW_STAGES,
)
from case_assets import STAGE_CIRCUITS, stage_circuit_latex  # noqa: E402
from lean_graph import build_lean_graph_payload, render_lean_graph_body  # noqa: E402


NAVIGATION = [
    ("Home", ""),
    ("Book map", "learning/"),
    ("Lean library", "library/"),
    ("Underlying Lean Graph of Libraries", "lean-graph/"),
    ("Implementation map", "implementation-map/"),
    ("Robin paper map", "case-studies/robin/"),
    ("Live workspace", "ide/"),
    ("Run with your API", "task-builder/"),
    ("Quantum ecosystem", "ecosystem/"),
    ("Progress", "roadmap/"),
    ("Contribute", "community/"),
    ("Contributors", "contributors/"),
    ("Organizers", "organizers/"),
]

PROJECT_REPOSITORY = "DakeBU/Quantum-Computing-Block-Encoding"
PROJECT_REPOSITORY_URL = f"https://github.com/{PROJECT_REPOSITORY}"
ORGANIZERS = (
    {
        "name": "Dake Bu",
        "role": "Project lead",
        "affiliation": "City University of Hong Kong",
        "url": "https://dakebu.github.io/",
    },
    {
        "name": "Xiajie Huang",
        "role": "Quantum algorithms and source correspondence",
        "affiliation": "",
        "url": "",
    },
    {
        "name": "Nana Liu",
        "role": "Quantum algorithms and source correspondence",
        "affiliation": "",
        "url": "",
    },
    {
        "name": "Atsushi Nitanda",
        "role": "Learning theory and formalization guidance",
        "affiliation": "A*STAR / Kyushu Institute of Technology",
        "url": "",
    },
    {
        "name": "Hau-san Wong",
        "role": "Research supervision",
        "affiliation": "City University of Hong Kong",
        "url": "",
    },
    {
        "name": "Qingfu Zhang",
        "role": "Optimization and search guidance",
        "affiliation": "City University of Hong Kong",
        "url": "",
    },
)

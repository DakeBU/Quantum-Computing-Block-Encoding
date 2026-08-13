#!/usr/bin/env python3
"""Run the fixed Robin Qiskit export from its public task directory."""

from __future__ import annotations

import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[3]
sys.path.insert(0, str(ROOT))

from tools.export_robin_evolution import main  # noqa: E402


if __name__ == "__main__":
    raise SystemExit(main())

#!/usr/bin/env python3
"""Deterministic local agent for qiskit-only route-ablation harness tests.

This script is intentionally not an AI baseline.  It only verifies that
`tools/run_route_ablation.py qiskit_only` enforces a real executable artifact:
the runner sets `QBE_ROUTE_ARTIFACT`, this script writes the artifact there,
and the runner executes that file as the checker.
"""

from __future__ import annotations

import os
from pathlib import Path


ARTIFACT = '''#!/usr/bin/env python3
import numpy as np
from qiskit import QuantumCircuit
from qiskit.quantum_info import Operator


def build_circuit():
    qc = QuantumCircuit(4)
    qc.ccx(1, 2, 3)
    qc.x(1)
    qc.x(2)
    qc.x(3)
    return qc


def resource_tuple():
    return (4, 2, 1, 0)


def main():
    data = np.asarray(Operator(build_circuit()).data)
    target = np.zeros((8, 8), dtype=complex)
    target[0, 6] = 1
    target[1, 7] = 1
    if not np.allclose(data[:8, :8], target, atol=1e-12):
        raise SystemExit("clean block does not equal E_1")
    print("qiskit route artifact passed")


if __name__ == "__main__":
    main()
'''


def main() -> int:
    target = os.environ.get("QBE_ROUTE_ARTIFACT")
    if not target:
        raise SystemExit("QBE_ROUTE_ARTIFACT is not set")
    path = Path(target)
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(ARTIFACT, encoding="utf-8")
    path.chmod(0o755)
    print("wrote deterministic qiskit route artifact to QBE_ROUTE_ARTIFACT")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

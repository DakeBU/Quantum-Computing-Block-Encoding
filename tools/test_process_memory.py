import json
import tempfile
import unittest
from pathlib import Path

from tools import check_process_memory


ROOT = Path(__file__).resolve().parents[1]


class ProcessMemoryTests(unittest.TestCase):
    def test_current_memory_validates(self):
        self.assertEqual(check_process_memory.validate(), [])

    def test_environment_failure_cannot_retire_math(self):
        data = json.loads((ROOT / "reports/process-memory.json").read_text(encoding="utf-8"))
        entry = next(item for item in data["entries"] if item["id"] == "QBE-NK-QISKIT-ENV-PREFLIGHT")
        entry["route_effect"] = "retire-same-target"
        with tempfile.TemporaryDirectory(dir=ROOT) as tmp:
            path = Path(tmp) / "process-memory.json"
            path.write_text(json.dumps(data), encoding="utf-8")
            errors = check_process_memory.validate(path)
        self.assertTrue(any("may not retire" in error for error in errors))


if __name__ == "__main__":
    unittest.main()

"""Tests for the Hermite proof-digestion presentation layer."""

from __future__ import annotations

import tempfile
import unittest
from pathlib import Path

from website.scripts import enrich_hermite_insight as insight


class HermiteInsightTests(unittest.TestCase):
    def test_data_states_the_structural_invariant_and_evidence_boundary(self):
        data = insight.load_data()
        self.assertEqual(data["caseSlug"], insight.CASE_SLUG)
        self.assertIn("internal memory", data["headline"])
        self.assertIn("D=2k+6", data["compressionFormula"])
        self.assertIn("48\\,n_p", data["resourceFormula"])
        topology = data["topology"]
        kinds = {item["kind"] for item in topology["contributions"]}
        self.assertEqual(kinds, {"BRIDGE", "SHORTCUT", "HUB", "REORGANIZATION"})
        self.assertIn("theorem-level proof-term", topology["evidenceBoundary"])

    def test_case_insight_renders_math_in_mathjax_environments(self):
        data = insight.load_data()
        page = insight.render_case_insight(data)
        self.assertIn('id="hermite-insight"', page)
        self.assertIn("\\[g_k(p_j)=", page)
        self.assertIn("48\\,n_pD^3", page)
        self.assertIn("Mathematical cross-pollination", page)
        self.assertIn("Bernstein", page)
        self.assertIn("tensor networks", page.lower())

    def test_case_enrichment_fixes_reader_math_and_preserves_code(self):
        data = insight.load_data()
        source = """<!doctype html><html><head></head><body>
<div class="case-status-line"><span class="status">Lean certified</span><span>Prepare 2^n_p amplitudes with O(n_p (k+1)^3).</span></div>
<section class="casebook-tutorial"><p>Their joint input is |g_k&gt; tensor |u_0&gt;.</p></section>
<section><p class="contract-reading">The new Bernstein–MPS circuit has at most 48 n_p (2k+6)^3 Ry/CNOT instructions and ceil(log2(2k+6)) clean bond qubits.</p></section>
<pre><code>literal 48 n_p (2k+6)^3 Ry/CNOT reference</code></pre>
</body></html>"""
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "index.html"
            path.write_text(source, encoding="utf-8")
            insight.enrich_case(path, data)
            text = path.read_text(encoding="utf-8")
            self.assertIn('id="hermite-insight"', text)
            self.assertIn("../../static/hermite-insight.css", text)
            self.assertIn("\\[G,\\operatorname{depth}", text)
            self.assertIn("\\lvert g_k\\rangle_p\\otimes\\lvert u_0\\rangle", text)
            self.assertNotIn("The new Bernstein–MPS circuit has at most 48 n_p", text)
            self.assertIn("literal 48 n_p (2k+6)^3 Ry/CNOT reference", text)
            insight.enrich_case(path, data)
            again = path.read_text(encoding="utf-8")
            self.assertEqual(again.count('id="hermite-insight"'), 1)
            self.assertEqual(again.count("hermite-insight.css"), 1)

    def test_graph_enrichment_explains_topology_without_upgrading_evidence(self):
        data = insight.load_data()
        source = """<!doctype html><html><head></head><body>
<section class="content-section lean-graph-app" id="interactive-graph" data-lean-graph></section>
</body></html>"""
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "index.html"
            path.write_text(source, encoding="utf-8")
            insight.enrich_graph(path, data)
            text = path.read_text(encoding="utf-8")
            self.assertIn('id="hermite-topology"', text)
            self.assertLess(text.index('id="hermite-topology"'), text.index('id="interactive-graph"'))
            for label in ("BRIDGE", "SHORTCUT", "HUB", "REORGANIZATION"):
                self.assertIn(f">{label}<", text)
            self.assertIn("theorem-level proof-term dependency", text)
            self.assertIn("data-show-hermite-graph", text)
            insight.enrich_graph(path, data)
            again = path.read_text(encoding="utf-8")
            self.assertEqual(again.count('id="hermite-topology"'), 1)
            self.assertEqual(again.count("hermite-insight.css"), 1)

    def test_reader_prose_mathifier_does_not_touch_code_panels(self):
        source = (
            "<p>48 n_p (2k+6)^3 Ry/CNOT and ceil(log2(2k+6)); 2^n_p</p>"
            "<code>48 n_p (2k+6)^3 Ry/CNOT and 2^n_p</code>"
        )
        text = insight.mathify_reader_prose(source)
        self.assertIn(r"\(48\,n_p(2k+6)^3\)", text)
        self.assertIn(r"\(\lceil\log_2(2k+6)\rceil\)", text)
        self.assertIn(r"\(2^{n_p}\)", text)
        self.assertIn("<code>48 n_p (2k+6)^3 Ry/CNOT and 2^n_p</code>", text)


if __name__ == "__main__":
    unittest.main()

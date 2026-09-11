"""Tests for the Hermite proof-digestion presentation layer."""

from __future__ import annotations

import tempfile
import unittest
from pathlib import Path

from website.scripts import enrich_hermite_insight as insight


class HermiteInsightTests(unittest.TestCase):
    def test_data_defines_baseline_objects_before_the_compression(self):
        data = insight.load_data()
        self.assertEqual(data["caseSlug"], insight.CASE_SLUG)
        self.assertIn("short preparation rule", data["headline"])
        self.assertIn("2^{n_p}", data["targetFormula"])
        terms = {item["term"] for item in data["baselineObjects"]}
        self.assertEqual(terms, {"Explicit amplitude list", "Binary mass tree"})
        self.assertIn("without first materializing", data["question"])
        self.assertEqual(len(data["compressionSteps"]), 5)
        self.assertIn("D=2k+6", data["compressionFormula"])
        self.assertIn("48\\,n_p", data["resourceFormula"])

    def test_data_records_real_certification_time_without_inventing_generations(self):
        data = insight.load_data()
        evolution = data["evolution"]
        self.assertIn("No generation counter", evolution["provenance"])
        self.assertIn("not continuous agent compute time", evolution["provenance"])
        stages = evolution["stages"]
        self.assertEqual(stages[0]["commit"], "19a7e740f0c9c60d5a9d44d04bc8d44d96a856b9")
        self.assertEqual(stages[1]["commit"], "d638f725b7ed07fc471c25730cdf3bcfebe00510")
        self.assertEqual(stages[1]["elapsed"], "+22 h 56 min 06 s")
        self.assertIn("different scopes", evolution["comparisonBoundary"])
        self.assertIn("does not label", evolution["comparisonBoundary"])

    def test_case_insight_reads_target_then_baseline_then_compression(self):
        data = insight.load_data()
        page = insight.render_case_insight(data)
        self.assertIn('id="hermite-insight"', page)
        self.assertIn('id="hermite-baseline-objects"', page)
        self.assertIn('id="hermite-compression"', page)
        self.assertLess(page.index("hermite-baseline-objects"), page.index("hermite-compression"))
        self.assertIn("Amplitude list", page)
        self.assertIn("Binary mass tree", page)
        self.assertIn("\\[N=2^{n_p}", page)
        self.assertIn("48\\,n_pD^3", page)
        self.assertIn("Mathematical cross-pollination", page)

    def test_certified_evolution_shows_both_routes_and_scope_boundary(self):
        data = insight.load_data()
        page = insight.render_evolution(data)
        self.assertIn('id="evolution"', page)
        self.assertIn("Reference mass-tree / UCRY route", page)
        self.assertIn("Bernstein–MPS / bounded-memory route", page)
        self.assertIn("+22 h 56 min 06 s", page)
        self.assertIn("19a7e740f0c", page)
        self.assertIn("d638f725b7ed", page)
        self.assertIn("48n_p(2k+6)^3", page)
        self.assertIn("different scopes", page)
        self.assertIn("not continuous agent compute time", page)

    def test_reference_circuit_uses_page_math_and_keeps_archival_artifact_link(self):
        rendered = insight.render_reference_rotation_tree(
            "../../downloads/hermite-smooth-state-preparation/executable-exports/SP-HERMITE-001/circuit.svg"
        )
        self.assertIn('id="hermite-reference-circuit"', rendered)
        self.assertIn(r"\(R_y(\theta_{0,0})\)", rendered)
        self.assertIn(r"m_{d,s}=\sum", rendered)
        self.assertIn(r"\theta_{d,s}=2\operatorname{atan2}", rendered)
        self.assertIn(r"|\Psi_d\rangle", rendered)
        self.assertIn("baked vector text rather than MathJax", rendered)
        self.assertIn("SP-HERMITE-001/circuit.svg", rendered)
        self.assertNotIn("<img", rendered)

    def test_case_enrichment_fixes_proof_and_circuit_math_and_replaces_old_evolution(self):
        data = insight.load_data()
        source = """<!doctype html><html><head></head><body>
<div class="case-status-line"><span class="status">Lean certified</span><span>Prepare 2^n_p amplitudes with O(n_p (k+1)^3).</span></div>
<section class="casebook-tutorial">
<section class="casebook-subsection"><p class="eyebrow">Read the circuit</p><h2>Old guide</h2><p>q0 is the low bit. Label j is the sum of 2^r q_r; the rightmost bit in a ket is q0.</p></section>
<p>Their joint input is |g_k&gt; tensor |u_0&gt;.</p>
<li><strong>Truncate</strong><span>A_k keeps the first k+1 coefficients of exp(t)/(1−t)^(k+1). Multiplication restores the exponential coefficients through order k.</span></li>
<li><strong>Endpoint</strong><span>A factor t^(k+1) kills the first k derivatives at t=0. Reflect t to 1−t to obtain the right endpoint.</span></li>
</section>
<section><p class="contract-reading">The new Bernstein–MPS circuit has at most 48 n_p (2k+6)^3 Ry/CNOT instructions and ceil(log2(2k+6)) clean bond qubits.</p></section>
<section class="content-section" id="circuit"><span class="gate-chip">k, n, L</span><span class="gate-chip">g_k(p_j)</span><span class="gate-chip">m(d,s)</span><span class="gate-chip">UCRY_0</span><span class="gate-chip">|g_k&gt;</span></section>
<section class="content-section" id="evolution"><p>old only</p></section>
<figure><img src="../../downloads/hermite-smooth-state-preparation/executable-exports/SP-HERMITE-001/circuit.svg" alt="Example k=1, n=3, L=1: all 7 Ry gates and 8 CNOTs, shown in execution order" style="width:100%;height:auto"><figcaption>Example k=1, n=3, L=1: all 7 Ry gates and 8 CNOTs, shown in execution order</figcaption></figure>
<pre><code>literal A_k and 48 n_p (2k+6)^3 Ry/CNOT reference</code></pre>
</body></html>"""
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "index.html"
            path.write_text(source, encoding="utf-8")
            insight.enrich_case(path, data)
            text = path.read_text(encoding="utf-8")
            self.assertIn('id="hermite-insight"', text)
            self.assertIn("../../static/hermite-insight.css", text)
            self.assertIn("hermite-circuit-reading", text)
            self.assertIn('class="content-section hermite-certified-evolution"', text)
            self.assertIn("+22 h 56 min 06 s", text)
            self.assertIn(r"\(A_k\) keeps the first \(k+1\) coefficients", text)
            self.assertIn(r"\(\exp(t)/(1-t)^{k+1}\)", text)
            self.assertIn(r"A factor \(t^{k+1}\) kills the first \(k\) derivatives", text)
            self.assertIn(r">\(k,n,L\)<", text)
            self.assertIn(r">\(g_k(p_j)\)<", text)
            self.assertIn(r">\(m_{d,s}\)<", text)
            self.assertIn(r">\(\mathrm{UCRY}_0\)<", text)
            self.assertIn(r">\(|g_k\rangle\)<", text)
            self.assertIn("\\[G,\\operatorname{depth}", text)
            self.assertIn("\\lvert g_k\\rangle_p\\otimes\\lvert u_0\\rangle", text)
            self.assertNotIn("The new Bernstein–MPS circuit has at most 48 n_p", text)
            self.assertIn("literal A_k and 48 n_p (2k+6)^3 Ry/CNOT reference", text)
            self.assertIn('id="hermite-reference-circuit"', text)
            self.assertIn(r"m_{d,s}=\sum", text)
            self.assertIn(r"\theta_{d,s}=2\operatorname{atan2}", text)
            self.assertIn("baked vector text rather than MathJax", text)
            self.assertIn("SP-HERMITE-001/circuit.svg", text)
            self.assertNotIn('<img src="../../downloads/hermite-smooth-state-preparation/executable-exports/SP-HERMITE-001/circuit.svg"', text)
            insight.enrich_case(path, data)
            again = path.read_text(encoding="utf-8")
            self.assertEqual(again.count('id="hermite-insight"'), 1)
            self.assertEqual(again.count("hermite-insight.css"), 1)
            self.assertEqual(again.count('class="content-section hermite-certified-evolution"'), 1)
            self.assertEqual(again.count('id="hermite-reference-circuit"'), 1)

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
            self.assertIn("explicit amplitude list", text)
            self.assertIn("data-show-hermite-graph", text)
            insight.enrich_graph(path, data)
            again = path.read_text(encoding="utf-8")
            self.assertEqual(again.count('id="hermite-topology"'), 1)
            self.assertEqual(again.count("hermite-insight.css"), 1)

    def test_reader_prose_mathifier_does_not_touch_code_panels(self):
        source = (
            "<p>A_k keeps the first k+1 coefficients of exp(t)/(1−t)^(k+1). "
            "Multiplication restores the exponential coefficients through order k.</p>"
            "<p>48 n_p (2k+6)^3 Ry/CNOT and ceil(log2(2k+6)); 2^n_p</p>"
            "<code>A_k keeps the first k+1 coefficients of exp(t)/(1−t)^(k+1). "
            "48 n_p (2k+6)^3 Ry/CNOT and 2^n_p</code>"
        )
        text = insight.mathify_reader_prose(source)
        self.assertIn(r"\(A_k\) keeps the first \(k+1\) coefficients", text)
        self.assertIn(r"\(\exp(t)/(1-t)^{k+1}\)", text)
        self.assertIn(r"\(48\,n_p(2k+6)^3\)", text)
        self.assertIn(r"\(\lceil\log_2(2k+6)\rceil\)", text)
        self.assertIn(r"\(2^{n_p}\)", text)
        self.assertIn("<code>A_k keeps the first k+1 coefficients", text)


if __name__ == "__main__":
    unittest.main()

"""Render and fail-closed tests for the mandatory Hermite website source packet."""
import html
import json
import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch

from website.scripts import publish_extensions as publisher
from website.scripts.check_site import check_hermite_publication


class HermitePublicationTests(unittest.TestCase):
    def test_final_assembly_rejects_absent_empty_and_stale_downloads(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            repository, site = root / "repo", root / "site"
            slug = "hermite-smooth-state-preparation"
            (repository / "website").mkdir(parents=True)
            (repository / "proof.lean").write_text("source\n", encoding="utf-8")
            (repository / "website/hermite-case.json").write_text(json.dumps({"cases": [{
                "slug": slug, "supplementaryAssets": [{"path": "proof.lean"}]
            }]}), encoding="utf-8")
            page = site / "example-cases" / slug / "index.html"
            download = site / "downloads" / slug / "proof.lean"
            page.parent.mkdir(parents=True)
            download.parent.mkdir(parents=True)
            self.assertEqual(len(check_hermite_publication(site, repository)), 2)
            page.write_text("<html>case</html>", encoding="utf-8")
            download.write_text("source\n", encoding="utf-8")
            self.assertEqual(check_hermite_publication(site, repository), [])
            for invalid in ("", "stale source\n"):
                download.write_text(invalid, encoding="utf-8")
                self.assertEqual(len(check_hermite_publication(site, repository)), 1)
            download.unlink()
            self.assertEqual(len(check_hermite_publication(site, repository)), 1)

    def test_real_hermite_case_renders_complete_page_and_tutorial(self):
        """Exercise the actual page, evolution, score, circuit, and tutorial renderers."""
        data = json.loads(publisher.HERMITE_PATH.read_text(encoding="utf-8"))
        case = data["cases"][0]
        # Declaration metadata is a small fixture; the case and every renderer are real.
        declarations = {
            name: {
                "fullName": name,
                "source": "QuantumBlockEncoding/HermiteStatePreparation.lean",
                "line": 1,
                "localSourceUrl": "library/modules/hermite-state-preparation/index.html",
            }
            for name in case["leanAnchors"]
        }
        with patch.dict(publisher.case_assets.STAGE_CIRCUITS):
            publisher.register_circuits(data)
            page = publisher.build_site.render_example_case(
                case, declarations, {"publicDeclarationCount": len(declarations)},
                {"passed": True}, {"shortCommit": "render-fixture"},
            )
            page = publisher.casebook.ensure_css(page, "../../static/casebook.css")
            page = publisher.casebook.inject_after_hero(
                page,
                publisher.casebook.render_case_tutorial(
                    case["slug"], data["teaching"][case["slug"]], declarations,
                ),
            )
        self.assertTrue(page.lstrip().startswith("<!doctype html>"))
        self.assertTrue(page.rstrip().endswith("</html>"))
        self.assertIn("<h1>" + html.escape(case["title"]) + "</h1>", page)
        for section in ("mathematical-target", "circuit", "evolution", "case-workbench",
                        "copy-construction", "lean-certificate", "executable-evidence",
                        "case-tutorial", "case-theorems"):
            self.assertIn(f'id="{section}"', page, section)
        self.assertLess(page.index('id="case-tutorial"'), page.index('id="mathematical-target"'))
        self.assertIn(html.escape(case["evolution"]["caption"]), page)
        for stage in case["evolution"]["stages"]:
            self.assertIn(html.escape(str(stage["iteration"])), page)
            self.assertIn(html.escape(stage["description"]), page)
            self.assertIn(html.escape(stage["instructionTier"]), page)
            self.assertIn(html.escape(data["circuits"][case["slug"]][stage["name"]]), page)
        self.assertIn('<div class="stage-circuit-canvas"><svg', page)
        for anchor in case["leanAnchors"]:
            self.assertIn(html.escape(anchor), page)
        self.assertNotIn("Strictly better", page)

    def test_extension_and_renderer_share_the_circuit_registry(self):
        data = json.loads(publisher.HERMITE_PATH.read_text(encoding="utf-8"))
        publisher.register_circuits(data)
        self.assertIs(publisher.case_assets.STAGE_CIRCUITS, publisher.build_site.STAGE_CIRCUITS)
        self.assertEqual(publisher.build_site.stage_circuit_latex(
            "hermite-smooth-state-preparation", "Hermite rotation tree"),
            data["circuits"]["hermite-smooth-state-preparation"]["Hermite rotation tree"])

    def test_missing_case_catalog_fails(self):
        with tempfile.TemporaryDirectory() as directory:
            with patch.object(publisher, "HERMITE_PATH", Path(directory) / "missing.json"):
                with self.assertRaises(FileNotFoundError):
                    publisher.load_extension_payload()

    def test_missing_or_empty_download_fails(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            case = {"slug": "hermite-test", "supplementaryAssets": [
                {"path": "source.lean", "label": "Lean source"}]}
            with patch.object(publisher, "ROOT", root):
                with self.assertRaises(RuntimeError):
                    publisher.publish_case_assets(root / "site", case)
                (root / "source.lean").touch()
                with self.assertRaises(RuntimeError):
                    publisher.publish_case_assets(root / "site", case)

    def test_nonportable_and_escaping_downloads_fail(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            with patch.object(publisher, "ROOT", root):
                for name in ("../secret.txt", "/private/source.lean", "Z:/private/source.lean",
                             "Z:\\private\\source.lean"):
                    with self.subTest(name=name), self.assertRaises(RuntimeError):
                        publisher.publish_case_assets(root / "site", {
                            "slug": "hermite-test", "supplementaryAssets": [
                                {"path": name, "label": "Not allowed"}]})

    def test_complete_copy_packet_is_not_truncated(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            source = "theorem first : True := trivial\n-- last source line\n"
            (root / "source.lean").write_text(source, encoding="utf-8")
            with patch.object(publisher, "ROOT", root):
                page = publisher.publish_case_assets(root / "site", {
                    "slug": "hermite-test", "supplementaryAssets": [
                        {"path": "source.lean", "label": "Complete Lean", "copy": True}]})
            self.assertIn("last source line", page)
            self.assertIn("../../downloads/hermite-test/source.lean", page)
            self.assertEqual((root / "site/downloads/hermite-test/source.lean").read_text(), source)
            self.assertNotIn(str(root), page)

    def test_real_catalog_keeps_source_and_evidence_boundary(self):
        data = json.loads(publisher.HERMITE_PATH.read_text(encoding="utf-8"))
        case = data["cases"][0]
        self.assertIn("hermiteStatePreparation_complete", " ".join(case["leanAnchors"]))
        paths = {asset["path"] for asset in case["supplementaryAssets"]}
        self.assertIn("QuantumBlockEncoding/HermiteStatePreparation.lean", paths)
        self.assertIn("docs/hermite-state-preparation.tex", paths)
        self.assertIn("executable-exports/SP-HERMITE-001/acceptance.json", paths)


if __name__ == "__main__":
    unittest.main()

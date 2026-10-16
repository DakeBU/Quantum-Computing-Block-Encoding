"""WIP integrity tests. Passing these is neither Lean nor publication admission."""
import base64
import hashlib
import json
from pathlib import Path
import re
import unittest

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
load = lambda p: json.loads(p.read_bytes())
digest = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()

class CubicCheckpointTests(unittest.TestCase):
    def test_frozen_author_manifest(self):
        self.assertEqual(digest(HERE/'outputs-manifest.json'), '555194f534a537e7d68c450caa8605a3d4a2a37dc02d5ac39f97422b28d0fd0c')
        for row in load(HERE/'outputs-manifest.json')['artifacts']:
            file = ROOT/row['planned_canonical_path']
            self.assertEqual(digest(file), row['sha256'], row['path'])
            self.assertEqual(file.stat().st_size, row['bytes'])

    def test_raw_transport_receipts(self):
        for name, count in [('parent-author-transport-c29.json', 20), ('parent-decoder-initial-transport-c29.json', 16)]:
            receipt = load(HERE/name)
            self.assertFalse(receipt['native_acceptance'])
            self.assertFalse(receipt['main_admission'])
            self.assertFalse(receipt['scientific_ROOT'])
            self.assertEqual(len(receipt['files']), count)
            for row in receipt['files']:
                file = ROOT/row['path']
                self.assertEqual(digest(file), row['sha256'])
                self.assertEqual(file.stat().st_size, row['bytes'])

    def test_retained_partial_is_not_valid_context(self):
        receipt = load(HERE/'parent-author-transport-c29.json')
        partial = receipt['historical_invalid_partial']
        self.assertFalse(partial['valid_formal_input'])
        with self.assertRaises(json.JSONDecodeError):
            load(ROOT/partial['path'])
        context = load(HERE/'author-formal-context.json')
        self.assertEqual(len(context['inventory']), 319)

    def test_inventory_includes_private_structures_and_opaque(self):
        roots = load(HERE/'author-formal-context.json')['inventory']
        self.assertEqual(len({r['name'] for r in roots}), 319)
        self.assertEqual(sum(r['private'] for r in roots), 50)
        self.assertEqual(sum(not r['private'] for r in roots), 269)
        self.assertEqual(sum(r['kind']=='structure' for r in roots), 11)
        self.assertEqual(sum(r['kind']=='opaque' for r in roots), 7)

    def test_formal_raw_source_not_transformed_copy(self):
        context = load(HERE/'author-formal-context.json')
        for row in context['target_files'] + context['dependency_context']:
            raw = base64.b64decode(''.join(row['full_source_utf8_base64_chunks']))
            self.assertEqual(raw, ''.join(row['full_source_lines']).encode())
            self.assertEqual(raw, (ROOT/row['path']).read_bytes())
            self.assertEqual(hashlib.sha256(raw).hexdigest(), row['sha256'])

    def test_lossless_source_coverage_and_complete_name_mapping(self):
        coverage = load(HERE/'author-source-coverage.json')
        source = (HERE/'source-only.md').read_bytes()
        self.assertEqual(''.join(p['exact_text'] for p in coverage['source_paragraphs']).encode(), source)
        inventory = load(HERE/'author-formal-context.json')['inventory']
        self.assertEqual({r['name'] for r in coverage['whole_module_inventory']}, {r['name'] for r in inventory})
        for row in coverage['whole_module_inventory']:
            self.assertTrue(row['source_paragraphs'])
        for paragraph in coverage['source_paragraphs']:
            self.assertIn(paragraph['disposition'], ('NODE', 'EXCLUDED'))
            if paragraph['source_region']=='S13':
                self.assertFalse(paragraph['counts_as_scientific_closure'])

    def test_complete_and_edges_and_open_boundaries(self):
        views = load(HERE/'author-graph-views.json')['views']
        graph = views['source-construction-graph']
        ids = {n['id'] for n in graph['nodes']}
        self.assertEqual(len(graph['AND_hyperedges']), 26)
        self.assertEqual(len(graph['open_source_gap_ids']), 10)
        for edge in graph['AND_hyperedges'] + views['functor-hypergraph']['hyperedges']:
            self.assertEqual(edge['logic'], 'AND')
            self.assertTrue(set(edge['tails'] + edge['heads']) <= ids)
        self.assertEqual(len(views['lean-graph']['ownership_edges']), 319)

    def test_initial_decoder_is_zero_call_environment_evidence(self):
        packet = load(HERE/'decoder-c29/packet.json')
        self.assertEqual(packet['leanInvocationCount'], 0)
        self.assertFalse(packet['nativeAccepted'])
        self.assertFalse(packet['cleanTransitive'])
        self.assertIsNone(packet['sourceAgreement'])
        self.assertIsNone(packet['publicationBinding'])
        self.assertEqual(packet['compile'], 'NOT_RUN_ENV_BLOCKED')
        self.assertFalse(packet['importClosure']['compilerBackedImportInventory'])

    def test_publication_candidate_stays_wip(self):
        candidate = load(HERE/'publication-candidate-CubicStatePreparation.json')
        self.assertEqual(candidate['status'], 'AUTHOR_WIP_NOT_ADMITTED')
        self.assertFalse(candidate['independent_acceptance'])
        self.assertFalse(candidate['main_admission'])
        self.assertEqual(candidate['binding_sha256'], '5c23037871778ce883584e8aed865321c69ace57eff995915104a600253ff2bc')
        self.assertEqual(len(candidate['declarations']), 269)

    def test_exported_frozen_files_have_no_private_machine_path(self):
        pattern = re.compile(r'(?i)(?<![A-Za-z0-9])[a-z]:[\\/]|' + 'file:' + '///|/' + 'Users/|/' + 'home/')
        for receipt in ['parent-author-transport-c29.json', 'parent-decoder-initial-transport-c29.json']:
            for row in load(HERE/receipt)['files']:
                self.assertIsNone(pattern.search((ROOT/row['path']).read_text(encoding='utf-8')), row['path'])

if __name__ == '__main__':
    unittest.main()

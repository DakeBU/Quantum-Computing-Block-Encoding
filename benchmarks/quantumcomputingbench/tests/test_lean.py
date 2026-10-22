"""Offline verifier-contract tests. No mock result counts as Lean evidence."""
from pathlib import Path
import copy
import sys
import tempfile
import unittest
from unittest.mock import patch
BASE = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(BASE / "src"))
import qcb_lean as q
ROOT = BASE.parents[1]
PINNED = "registry.example/lean@sha256:" + "a"*64
ITEM = {"id":"fixture", "task_hash":"fixture", "formal_context":{
    "imports":["QuantumBlockEncoding.PrimitiveSemantics"],
    "target":"QuantumBlockEncoding.standardRyMatrix 0 = 1"},
    "formal":{"approved_axioms":["propext","Classical.choice","Quot.sound"]}}

class LeanContractTests(unittest.TestCase):
    def test_lemma_application_grammar(self):
        self.assertEqual(q.validate_proof_grammar("by exact Foo.bar x"),"by exact Foo.bar x")
        self.assertEqual(q.validate_proof_grammar("Foo.bar (Baz.qux 2)"),"Foo.bar ( Baz.qux 2 )")

    def test_injection_and_placeholders_rejected(self):
        for proof in ["by sorry", "by exact sorry", "by admit", "a; b", "#eval IO.println 1",
                      "a := b", '"canary"', "a --comment", "a /-comment-/", "fun x => x",
                      "by exact foo\nimport System", "by exact by exact foo"]:
            with self.subTest(proof=proof), self.assertRaises(q.ProofGrammarError):
                q.validate_proof_grammar(proof)

    def test_balanced_length(self):
        for proof in ["", "(foo", "foo)", "a "*3000]:
            with self.assertRaises(q.ProofGrammarError):q.validate_proof_grammar(proof)

    def test_policy_not_item_controlled(self):
        item=copy.deepcopy(ITEM)
        item['formal']['axiom_policy']=['sorryAx','Mystery.axiom']
        self.assertEqual(q.axiom_policy(item),frozenset({'propext','Classical.choice','Quot.sound'}))
        self.assertFalse(q.classify_axioms(['sorryAx'],False)[0])
        self.assertFalse(q.classify_axioms(['Mystery.axiom'],False)[0])
        self.assertTrue(q.classify_axioms(['propext'],False)[0])

    def test_frozen_harness_and_fixed_fuel(self):
        item=copy.deepcopy(ITEM);item['formal']['max_heartbeats']=10**9
        source,name=q.build_harness(item,'by exact QuantumBlockEncoding.standardRyMatrix_zero','nonce')
        self.assertIn('import Lean',source)
        self.assertIn(f'theorem {name} : '+ITEM['formal_context']['target'],source)
        self.assertIn('maxHeartbeats 400000',source)
        self.assertIn('collectAxioms',source)
        self.assertEqual(source.count('QCB_AXIOM_REPORT'),1)

    def test_statement_and_import_escape(self):
        for context in [{'imports':['Foo; #eval IO.print 1'],'target':'True'},
                        {'imports':['Foo'],'target':'True := by sorry'},
                        {'imports':[],'target':'True'}]:
            item=copy.deepcopy(ITEM);item['formal_context']=context
            with self.assertRaises(ValueError):q.build_harness(item,'trivial','n')

    def test_marker_strict(self):
        good=q.parse_harness_output('QCB_AXIOM_REPORT|n|false|propext','n')
        self.assertFalse(good['sorry_seen'])
        for text in ['no marker','QCB_AXIOM_REPORT|wrong|false|',
                     'QCB_AXIOM_REPORT|n|maybe|','QCB_AXIOM_REPORT|n|false',
                     'QCB_AXIOM_REPORT|n|false|\nQCB_AXIOM_REPORT|n|false|']:
            with self.assertRaises(ValueError):q.parse_harness_output(text,'n')

    def test_exit_zero_not_certificate(self):
        self.assertEqual(q.evaluate_report(0,'no marker','','n')['status'],'blocked')
        self.assertEqual(q.evaluate_report(137,'','','n')['reason'],'resource_kill')
        self.assertEqual(q.evaluate_report(1,'type mismatch','','n')['reason'],'unproven')
        self.assertEqual(q.evaluate_report(0,'QCB_AXIOM_REPORT|n|true|sorryAx','','n')['status'],'rejected')

    def test_sanitized_mount_flags(self):
        with tempfile.TemporaryDirectory() as temp:
            root=Path(temp);(root/'lean-toolchain').write_text('fixture')
            (root/'.env').write_text('PRIVATE_CANARY');(root/'benchmarks').mkdir()
            cmd=q.container_command('docker',PINNED,root,Path('/trusted-harness'),'qcb-test')
            text=' '.join(cmd)
            for expected in ['--network none','--read-only','--user 65534:65534','--cap-drop ALL',
                             '--security-opt no-new-privileges','--pull never','--memory','--cpus','--pids-limit']:
                self.assertIn(expected,text)
            self.assertNotIn('target=/library,',text)
            self.assertNotIn('.env',text);self.assertNotIn('benchmarks',text)

    def test_no_enable_env_bypass(self):
        with patch.dict('os.environ',{'QCB_LEAN_ENABLE':'1'}):
            self.assertFalse(q.certification_enabled(ROOT))
            receipt=q.verify(ROOT,ITEM,'by exact QuantumBlockEncoding.standardRyMatrix_zero',PINNED)
            self.assertEqual(receipt['status'],'blocked')
            self.assertEqual(receipt['reason'],'env_blocked')

    def test_invalid_or_missing_image(self):
        self.assertEqual(q.verify(ROOT,ITEM,'trivial')['reason'],'no_image')
        self.assertEqual(q.verify(ROOT,ITEM,'trivial','lean:latest')['reason'],'unpinned_image')

    def test_no_unsandboxed_execution(self):
        with patch.object(q.subprocess,'run',side_effect=AssertionError('must not execute')):
            self.assertEqual(q.verify(ROOT,ITEM,'trivial',PINNED)['status'],'blocked')

if __name__ == '__main__':unittest.main()

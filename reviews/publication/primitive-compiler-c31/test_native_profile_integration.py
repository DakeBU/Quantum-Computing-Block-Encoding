"""Exact optional diagnostic transport and no acceptance authority."""
import hashlib
import json
from pathlib import Path
import unittest
ROOT=Path(__file__).resolve().parents[3]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
load=lambda p:json.loads(p.read_bytes())

class NativeProfileIntegrationTests(unittest.TestCase):
    def test_exact_original_package_and_parent_transport(self):
        receipt=load(ROOT/'reports/lean-433-migration/c31-native-profile-integration.json')
        for row in receipt['files']:
            self.assertEqual(sha(ROOT/row['path']),row['sha256'])
        package=ROOT/'tools/primitive_compiler_native_profile_v1'
        manifest=load(package/'proposal-bindings.json')
        for name,digest in manifest['files'].items():self.assertEqual(sha(package/name),digest)
        profile=load(package/'profile.json')
        self.assertEqual(len(profile['roots']),87)
        for name,digest in profile['projectInputs'].items():self.assertEqual(sha(ROOT/name),digest)

    def test_optional_workflow_exact_three_scope_edits_only(self):
        package=ROOT/'tools/primitive_compiler_native_profile_v1'
        original=(package/'c31-native-diagnostic.workflow.PROPOSAL.yml').read_text()
        expected=original.replace('# PROPOSAL ONLY: parent review/integration required. Not an installed workflow.','# Optional WIP diagnostic; not a required scientific acceptance gate.').replace('name: C31 three-module fresh native diagnostic proposal','name: C31 three-module fresh native diagnostic WIP').replace('    paths:\n',"    paths:\n      - '.github/workflows/c31-native-diagnostic.yml'\n")
        self.assertEqual((ROOT/'.github/workflows/c31-native-diagnostic.yml').read_text(),expected)
        self.assertIn('contents: read',expected);self.assertIn('cancel-in-progress: false',expected)

    def test_actual_python_is_not_native_and_local_gate_failure_is_environment(self):
        receipt=load(ROOT/'reports/lean-433-migration/c31-native-profile-integration.json')
        launch=receipt['local_launch']
        self.assertEqual(launch['Lean_calls'],0);self.assertEqual(launch['lake_calls'],0)
        self.assertLess(launch['commit_free_GiB'],launch['commit_threshold_GiB'])
        self.assertEqual(launch['failure_class'],'ENV_BLOCKED')
        self.assertFalse(receipt['trusted_verifier_changed']);self.assertFalse(receipt['nativeAccepted'])
        parent=load(ROOT/'reports/lean-433-migration/c31-native-profile-parent-check.json')
        self.assertEqual(parent['tests_run'],18);self.assertEqual(parent['exit_code'],0)

if __name__=='__main__':unittest.main()

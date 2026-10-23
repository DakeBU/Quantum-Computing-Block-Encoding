"""Python-only native core contracts. No Lean executable or paid endpoint."""
from pathlib import Path
import copy
import json
import sys
import unittest
B=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(B/'src'))
from qcb_nl import prepare_native,native_errors,nl_coverage,core_registry,check_baseline,dedup_report,assign_native_splits,paths,review_admits,WITHDRAWN_NATIVE
from qcb_core import digest,content_hash,model_input
S={'snapshot_id':'fixture','nodes':[{'id':'declaration:a','kind':'declaration','topic':'linear_algebra','status':'legacy','source':'a.lean'}], 'edges':[],'hyperedges':[]}
RAW={'core_id':'qcb-core-la-001','key':'qcb-core-la-001','topic':'linear_algebra','track':'reasoning','task_kind':'proof',
 'question':'Let V be a finite-dimensional complex vector space. Explain why an isometry has no nonzero vector in its kernel.',
 'reference_answer':'An isometry preserves squared norm. If Vx=0 then the squared norm of x is zero, hence x=0. This proves injectivity, not surjectivity into a larger codomain.',
 'rubric':[{'id':'norm','criterion':'Use preservation of norm and conclude injectivity without claiming surjectivity','weight':1}],
 'target_nodes':['declaration:a'],'supporting_nodes':[],'assumptions':['Positive definite inner products'],'conventions':['Column vectors'],
 'semantic_steps':[{'claim':'Zero image and norm preservation force zero input.','supporting_nodes':['declaration:a']}],
 'difficulty':{'level':'easy','rationale':'One norm identity with a boundary distinction'},
 'source_refs':[{'path':'a.lean','sha256':'0'*64,'anchor':'full statement','license':'MIT'}],
 'family':'isometry-injectivity','answer_format':'rubric','evidence_status':'source_inspected','formal':None,'unresolved_issues':[],
 'native_nl':{'core_summary':'Isometry injectivity from positive definite norm','evidence_relation':'local_source_supported','formal_counterpart':'existing_source_not_freshly_verified','author_identity':'fixture-author','new_problem_core':True,'existing_core_aliases':[]}}

class NativeContractTests(unittest.TestCase):
 def test_candidate_valid_and_not_compiled(self):
  x=prepare_native([RAW],S)
  self.assertEqual(native_errors(x,S),[])
  self.assertEqual(x[0]['lifecycle'],'candidate')
  self.assertIsNone(x[0]['reviewed_semantic_step_count'])
  self.assertFalse(x[0]['formal_evidence']['local_verification_performed'])
  self.assertEqual(x[0]['author']['identity'],'fixture-author')

 def test_api_question_rejected(self):
  for forbidden in ['Lean','QuantumBlockEncoding','simp','declaration:a','Matrix.foo_bar_baz','file.lean']:
   raw=copy.deepcopy(RAW);raw['question']+=' '+forbidden
   self.assertTrue(native_errors(prepare_native([raw],S),S))

 def test_lean_context_cannot_enter_native_view(self):
  x=prepare_native([RAW],S);x[0]['formal_context']={'target':'True'}
  self.assertTrue(native_errors(x,S))

 def test_core_duplicates_and_alias_count(self):
  x=prepare_native([RAW,RAW],S)
  self.assertTrue(native_errors(x,S))
  raw=copy.deepcopy(RAW);raw['native_nl']['existing_core_aliases']=['old-core']
  self.assertTrue(native_errors(prepare_native([raw],S),S))
  raw['native_nl']['new_problem_core']=False
  self.assertEqual(native_errors(prepare_native([raw],S),S),[])

 def test_no_fake_review_promotion(self):
  x=prepare_native([RAW],S);x[0]['lifecycle']='released'
  self.assertTrue(native_errors(x,S))

 def test_primary_source_track_requires_exact_anchor(self):
  raw=copy.deepcopy(RAW);raw['track']='planned';raw['evidence_status']='planned_source_inspected'
  raw['native_nl'].update(evidence_relation='primary_source_nl_only',formal_counterpart='none')
  self.assertTrue(native_errors(prepare_native([raw],S),S))

 def test_node_support_not_primary_target(self):
  snap=copy.deepcopy(S);snap['nodes'].append({'id':'declaration:b','kind':'declaration','topic':'linear_algebra','status':'legacy','source':'b.lean'})
  raw=copy.deepcopy(RAW);raw['supporting_nodes']=['declaration:b']
  item=prepare_native([raw],snap)[0]
  # Fixture lifecycle only exercises ledger accounting; not release admission.
  item['lifecycle']='released';item['reviewed_semantic_step_count']=1
  report=nl_coverage(snap,[item])
  self.assertEqual(report['primary_target_nodes'],1)
  self.assertEqual(report['support_only_nodes'],1)
  self.assertFalse(next(n for n in report['ledger'] if n['id']=='declaration:b')['primary_target_covered'])

 def test_prompt_hides_core_solution_metadata(self):
  item=prepare_native([RAW],S)[0];prompt=model_input(item)
  for key in ['reference_answer','rubric','native_nl','formal_evidence','reviews','semantic_steps']:
   self.assertNotIn(key,prompt)

 def test_registry_never_invents_collaborator_ack(self):
  registry=core_registry(prepare_native([RAW],S),[])
  self.assertFalse(registry['integration_allowed'])
  self.assertIn('pending',registry['coordination_status'])

 def test_old_view_alias_never_new_core_count(self):
  raw=copy.deepcopy(RAW);raw['native_nl'].update(new_problem_core=False,existing_core_aliases=['old-key'])
  report=dedup_report(prepare_native([raw],S),[])
  self.assertEqual(report['new_core_candidates'],0)

 def test_independent_novelty_verdict_required_for_release(self):
  item=prepare_native([RAW],S)[0]
  item['lifecycle']='released';item['reviewed_semantic_step_count']=1
  item['validation'].update(nl_alignment='reviewed',answer_quality='reviewed')
  item['reviews']=[{'reviewer':'other','verdict':'accept','content_hash':content_hash(item),
                    'method':'distinct-context-source-review','artifact':'review.json','core_verdict':'existing_view'}]
  self.assertTrue(any('novelty' in e for e in native_errors([item],S)))

 def test_same_target_family_splits_stay_grouped(self):
  second=copy.deepcopy(RAW);second.update(core_id='qcb-core-la-002',key='qcb-core-la-002',family='other-family')
  second['question']='Let a square isometry act on a finite vector space. Prove the map is invertible and distinguish the rectangular case.'
  second['native_nl']['core_summary']='Square versus rectangular isometry invertibility'
  items=prepare_native([RAW,second],S)
  self.assertEqual(items[0]['split'],items[1]['split'])
  self.assertEqual(items[0]['split_group'],items[1]['split_group'])

 def test_version_support_and_path_escape(self):
  self.assertEqual(paths(B.parents[1],'nl-v2')[1].name,'nl-v2')
  for name in ['release-v3','..','nl-v0','nl-v1/../../escape']:
   with self.assertRaises(ValueError):paths(B.parents[1],name)

 def test_single_underscore_api_rejected_but_math_subscript_allowed(self):
  for api in ['Matrix.mul_assoc','row_isometry']:
   raw=copy.deepcopy(RAW);raw['question']+=' '+api
   self.assertTrue(native_errors(prepare_native([raw],S),S))
  raw=copy.deepcopy(RAW);raw['question']+=' Write sum_i p_i for the relevant scalar sum.'
  self.assertEqual(native_errors(prepare_native([raw],S),S),[])

 def test_cross_version_target_stays_in_legacy_test(self):
  legacy=prepare_native([RAW],S)[0];legacy['id']='legacy';legacy['split']='test_public'
  raw=copy.deepcopy(RAW);raw.update(key='qcb-core-la-002',core_id='qcb-core-la-002',family='new-distinct')
  result=assign_native_splits(prepare_native([raw],S),[legacy])[0]
  self.assertEqual(result['split'],'test_public')
  self.assertEqual(result['legacy_split_constraints'],['test_public'])

 def test_cross_version_conflict_is_public_diagnostic_not_silent_train(self):
  old1=prepare_native([RAW],S)[0];old1.update(id='old1',split='train')
  old2=copy.deepcopy(old1);old2.update(id='old2',split='test_public',family='other',target_nodes=['declaration:b'])
  raw=copy.deepcopy(RAW);raw.update(key='qcb-core-la-002',core_id='qcb-core-la-002',target_nodes=['declaration:a','declaration:b'])
  result=assign_native_splits(prepare_native([raw],S),[old1,old2])[0]
  self.assertTrue(result['cross_version_split_conflict'])
  self.assertEqual(result['split'],'test_public')

 def test_legacy_dedup_comparison_really_occurs(self):
  item=prepare_native([RAW],S)[0];old=copy.deepcopy(item)
  self.assertTrue(dedup_report([item],[old])['legacy_overlap_candidates'])

 def test_reviewed_alias_views_are_indivisible_even_without_shared_targets(self):
  first=prepare_native([RAW],S)[0]
  raw=copy.deepcopy(RAW);raw.update(core_id='qcb-core-la-002',key='qcb-core-la-002',family='different',target_nodes=['declaration:b'],supporting_nodes=[])
  raw['semantic_steps']=[{'claim':'Distinct view same solution','supporting_nodes':['declaration:b']}]
  second=prepare_native([raw],S)[0]
  second['reviews']=[{'core_aliases':[first['core_id']]}]
  result=assign_native_splits([first,second],[])
  self.assertEqual(result[0]['split_group'],result[1]['split_group'])
  self.assertEqual(result[0]['split'],result[1]['split'])
  self.assertEqual(result[1]['family'],'different')

 def test_same_core_repair_requires_explicit_independent_admission(self):
  raw=copy.deepcopy(RAW);raw.update(supersedes='old-key',key='qcb-core-la-001-repair')
  raw['native_nl'].update(new_problem_core=False,existing_core_aliases=['old-key'])
  item=prepare_native([raw],S)[0]
  record={'verdict':'accept','core_verdict':'existing_view'}
  self.assertFalse(review_admits(record,item))
  record['repair_admission']=True
  self.assertTrue(review_admits(record,item))
  self.assertFalse(review_admits(record,prepare_native([RAW],S)[0]))

 def test_withdrawn_native_answers_are_explicitly_listed(self):
  self.assertEqual(set(WITHDRAWN_NATIVE),{'qcb-core-be-001','qcb-core-be-002','qcb-core-be-010'})

 def test_reviewed_steps_not_inferred_from_graph_distance(self):
  item=prepare_native([RAW],S)[0]
  self.assertIsNone(item['structural_graph_distance'])
  self.assertIsNone(item['reviewed_semantic_step_count'])
  self.assertEqual(item['semantic_step_count'],1)

class NativeActualReleaseTests(unittest.TestCase):
 @classmethod
 def setUpClass(cls):
  public=B/'data/public/nl-v4'
  if not public.exists():raise unittest.SkipTest('native candidate milestone not built yet')
  cls.items=json.loads((public/'items.json').read_text())
  cls.release=json.loads((public/'release.json').read_text())

 def test_real_native_authoring_hash_sources_and_review_bindings(self):
  snap=check_baseline(B.parents[1])
  self.assertEqual(native_errors(self.items,snap,B.parents[1]),[])

 def test_no_duplicate_or_existing_view_enters_gold(self):
  for item in self.release:
   self.assertTrue(all(review_admits(r,item) for r in item['reviews']))
   self.assertNotIn(item['key'],WITHDRAWN_NATIVE)
   self.assertFalse(item['formal_evidence']['local_verification_performed'])
   self.assertTrue(all(r['verdict']=='accept' for r in item['reviews']))

 def test_full_primary_and_support_dispositions(self):
  report=nl_coverage(check_baseline(B.parents[1]),self.items)
  self.assertEqual(len(report['ledger']),5153)
  self.assertEqual(sum(report['dispositions'].values()),5153)
  primary={n for i in self.release for n in i['target_nodes']}
  self.assertEqual(report['primary_target_nodes'],len(primary))

class NativeBaselineTests(unittest.TestCase):
 def test_v3_files_still_hash_match(self):
  snap=check_baseline(B.parents[1]);self.assertEqual(len(snap['nodes']),5153)

if __name__=='__main__':unittest.main()

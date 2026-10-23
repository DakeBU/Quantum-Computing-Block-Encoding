#!/usr/bin/env python3
"""Readable native-core coverage, review queue and formal-collaborator handoff."""
from pathlib import Path
from collections import Counter
import json
import sys
B=Path(__file__).resolve().parents[1];R=B.parents[1]
sys.path.insert(0,str(B/'src'));sys.path.insert(0,str(B/'scripts'))
from qcb_core import write_json,digest,score,read_json
from qcb_nl import paths,VERSION,nl_coverage
from nl_qa import load_checked,summary


def main():
 import argparse
 parser=argparse.ArgumentParser(description=__doc__)
 parser.add_argument('--version',default=VERSION)
 args=parser.parse_args()
 snap,items,released=load_checked(args.version);_,m,_,reports=paths(R,args.version)
 report=nl_coverage(snap,items)
 write_json(reports/'coverage.json',report)
 write_json(reports/'summary.json',summary(items,args.version))
 review_queue=[{'core_id':i['core_id'],'key':i['key'],'authored_hash':i['authored_hash'],
                'task_kind':i['task_kind'],'question':i['question'],'unresolved_issues':i['unresolved_issues'],
                'latest_reviews':i['reviews'],'status':'pending_mathematical_or_novelty_review'}
               for i in items if i['lifecycle']!='released']
 write_json(m/'review-queue.json',{'items':review_queue,'note':'Candidates are not released coverage.'})
 formal_targets=[{'core_id':i['core_id'],'family':i['family'],'split_group':i['split_group'],'split':i['split'],
                  'mathematical_target':i['question'],'assumptions':i['assumptions'],'conventions':i['conventions'],
                  'source_refs':i['source_refs'],'target_nodes':i['target_nodes'],'supporting_nodes':i['supporting_nodes'],
                  'evidence_relation':i['evidence_relation'],'status':'candidate formal target; not a proof or verification receipt',
                  'collaborator_acknowledged':False}
                 for i in items if i['track']!='planned']
 write_json(m/'lean-collaborator-targets.json',{'coordination':'pending real collaborator acknowledgment',
            'integration_allowed':False,'no_new_local_lean_verification':True,'targets':formal_targets})
 # Same solution core, every view and family is grouped; supporting foundations
 # can appear across splits. This is not a private/contamination-free test.
 write_json(m/'splits.json',{'core_alias_policy':'One mathematical core across NL/Lean/hybrid views; actual collaborator confirmation pending.',
            'public_test':True,'pretraining_exposure':'unknown','shared_support_may_cross_splits':True,
            'assignments':[{'core_id':i['core_id'],'family':i['family'],'split_group':i['split_group'],'split':i['split']} for i in items]})
 empty=score(released,[]);copy_answers=score(released,[{'id':i['id'],'answer':i['reference_answer']} for i in released])
 write_json(reports/'scoring-fixtures.json',{'fixture_only':True,'model_performance_measured':False,
            'missing_predictions_zero':all(r['correctness']==0 for r in empty['results']),
            'copied_reference_not_automatic_rubric_credit':all(r['correctness'] is None for r in copy_answers['results']),
            'note':'Software fixtures only; no model or human result invented.'})
 pending=[n for n in report['ledger'] if not n['primary_target_covered'] and n['disposition']!='deliberately_excluded']
 write_json(m/'next-batches.json',{'goal_complete':False,'target_reviewed_cores':'several hundred; no silent cap',
            'node_primary_coverage_pending':len(pending),
            'batches':[{'index':j//128,'node_ids':[n['id'] for n in pending[j:j+128]],
                        'state':'requires actual source inspection, new problem core, review; packet is not QA'} for j in range(0,len(pending),128)]})
 lines=['# Native NL mathematical QA status','',
        f'Baseline: corrected release-v3, snapshot `{snap["snapshot_id"]}`.',
        '**No new local Lean verification was performed.** Source inspection and inherited formal evidence are distinct.',
        '',f'Candidate core records: **{len(items)}**. Independently content-reviewed records admitted: **{len(released)}**.',
        'Novel mathematical core counts require reviewer novelty verdicts and real collaborator reconciliation; views/repairs are not new cores.',
        'Goal remains in progress: first50 candidate cores is a starting milestone, not several-hundred-core completion.','',
        '| Topic | Candidates | Released |','|---|---:|---:|']
 for topic in sorted({i['topic'] for i in items}):
  lines.append(f'| {topic} | {sum(i["topic"]==topic for i in items)} | {sum(i["topic"]==topic for i in released)} |')
 lines+=['','## Evidence and depth','', '| Evidence relation | Released |','|---|---:|']
 lines += [f'| {k} | {v} |' for k,v in sorted(Counter(i['evidence_relation'] for i in released).items())]
 lines+=['','| Reviewed semantic steps | Cores |','|---|---:|']
 lines += [f'| {k} | {v} |' for k,v in sorted(Counter(i['reviewed_semantic_step_count'] for i in released).items())]
 lines+=['',f'Primary target nodes: **{report["primary_target_nodes"]}**; incidental support-only nodes: **{report["support_only_nodes"]}**.',
         f'All **{len(snap["nodes"])}** frozen nodes retain a disposition. Import distance is not mathematical inference depth.',
         'Structural graph distance remains unknown. Full AND premises/failure boundaries of conceptual transports are preserved by snapshot inheritance.',
         '', '## Next steps and collaboration','',
         'Review-queue lists unresolved mathematical/source/novelty issues. Next-batches prioritize uncovered primary targets, not incidental mentions.',
         'Core-registry and Lean-collaborator-targets are coordination proposals, not an invented collaborator acknowledgment; shared integration is blocked pending real agreement.',
         'Public tests and answers are public diagnostics, not blind or contamination-free. No model pretraining exposure is claimed.',
         'No paid endpoints, training, GPU jobs or system administration changes were run.','']
 (reports/'coverage.md').write_text('\n'.join(lines),encoding='utf-8')
 print(json.dumps(summary(items,args.version),indent=2))

if __name__=='__main__':main()

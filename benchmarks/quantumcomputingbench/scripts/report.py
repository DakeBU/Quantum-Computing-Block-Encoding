#!/usr/bin/env python3
"""Regenerate readable coverage, next batches and fixture scoring checks.

No fixture prediction/rating is represented as a model or human result.
"""
from pathlib import Path
from collections import Counter, defaultdict
import argparse
import json
import sys
B = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(B/'src'))
from qcb_core import read_json, write_json, score, digest, content_hash, validate
from qcb_snapshot import coverage


def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--version',default='release-v1')
    a=p.parse_args()
    if not a.version or a.version in {'.','..'} or any(c not in 'abcdefghijklmnopqrstuvwxyz0123456789.-' for c in a.version):
        p.error('invalid version label')
    m=B/'manifests'/a.version; d=B/'data/public'/a.version; r=B/'reports'/a.version
    snap=read_json(m/'snapshot.json');items=read_json(d/'items.json')
    errors=validate(items,snap,B.parents[1])
    if errors:raise ValueError('\n'.join(errors))
    report=coverage(snap,items);write_json(r/'coverage.json',report,immutable=True)
    released=[i for i in items if i['lifecycle']=='released']
    modules=defaultdict(list)
    for n in snap['nodes']:
        if n['kind']=='module':modules[n['source']].append(n['id'])
    areas=[]
    for source,ids in sorted(modules.items()):
        qa=[i for i in released if any(ref['path']==source for ref in i['source_refs'])]
        areas.append({'source':source,'module_ids':ids,'released_item_ids':[i['id'] for i in qa],
                      'status':'meaningful_qa_available' if qa else 'requires_substantive_authoring',
                      'next_action':'Review additional mathematical interfaces and edge cases; do not generate name recall.'})
    write_json(r/'module-coverage.json',areas,immutable=True)
    pending=[n for n in report['ledger'] if n['disposition'] in ['blocked_by_missing_evidence','candidate_pending_review']]
    batches=[{'index':i//128,'node_ids':[n['id'] for n in pending[i:i+128]],
              'status':'pending_mathematical_authoring_or_evidence','max_nodes':128}
             for i in range(0,len(pending),128)]
    write_json(m/'next-batches.json',{'snapshot_id':snap['snapshot_id'],'batches':batches,
                                     'note':'Inventory triage is not QA validation. Every batch needs substantive source inspection and review.'},immutable=True)
    # Honest software-level smoke test. All rubric answers remain ungraded
    # without real evaluator marks; missing prediction is zero.
    blank=score(released,[])
    selfcopy=score(released,[{'id':i['id'],'answer':i['reference_answer']} for i in released])
    smoke={'schema_version':'qcb.scoring_smoke.v1','fixture_only':True,'model_performance_measured':False,
           'note':'Synthetic transport/scoring checks, not a model baseline or mathematical validation.',
           'missing_predictions_all_zero':all(i['correctness']==0 for i in blank['results']),
           'rubric_answers_not_automatically_accepted':all(row['correctness'] is None for row in selfcopy['results'] if next(i for i in released if i['id']==row['id'])['answer_format']=='rubric'),
           'by_track_fixture_pending':selfcopy['by_track']}
    write_json(r/'scoring-smoke.json',smoke,immutable=True)
    counts=report['dispositions'];kind_counts=Counter(n['kind'] for n in snap['nodes'])
    lines=[f'# Coverage: {a.version}','',f'Snapshot: `{snap["snapshot_id"]}`.',
           f'Universe: **{len(snap["nodes"])} nodes**, {kind_counts["declaration"]} public declarations, {kind_counts["module"]} exporter module nodes.',
           f'Curated items: **{len(items)}**; released after distinct-context review: **{len(released)}**; remaining candidates: **{len(items)-len(released)}**.',
           '**Goal not complete. Lean-certified items: 0. Real model baseline: unmeasured.**','',
           '| Node disposition | Count |','|---|---:|']
    lines += [f'| {k} | {v} |' for k,v in sorted(counts.items())]
    lines += ['', 'All nodes have a disposition; this is **accounting completeness**, not mathematical QA coverage.',
              'Released support membership does not resolve legacy semantic/source-faithfulness debt.',
              'The exporter includes the umbrella module in addition to recursively discovered Lean source modules.',
              '', '## Released tracks','', '| Track | Items |','|---|---:|']
    lines += [f'| {k} | {v} |' for k,v in sorted(Counter(i['track'] for i in released).items())]
    lines += ['', '## Reasoning measures','',
              '`support_count`: distinct target/support nodes; `semantic_step_count`: authored, reviewed inference steps.',
              'Structural graph distance remains unknown (`null`); imports/ownership are not theorem proof dependencies.',
              'Buckets are not padded and do not independently establish difficulty.','',
              '| Measure | Bucket | Released items |','|---|---|---:|']
    for axis in ['support_bucket','reviewed_semantic_step_bucket']:
        lines += [f'| {axis} | {k} | {v} |' for k,v in report['released_axes'][axis].items()]
    lines += ['', '## Uncovered areas and next action','',
              f'{len([m for m in areas if not m["released_item_ids"]])} exporter modules still have no released source-linked question.',
              'See module-coverage.json for every module and next-batches.json for bounded, resumable authoring queues.',
              'Priority: Block Encoding composition and LCU/SELECT, stored-cost refinements, Hermite/cubic/banded/Robin/GHL routes, then remaining paper families.',
              'Planned Quantum Information and Scientific Computing require pinned primary-source review; external adapter candidates are never local Lean certificates.',
              'Rejected items stay in authored files with review reasons; corrected successors retain `supersedes` lineage.',
              '', '## Reproduction and privacy','',
              'Run the documented snapshot, generate, review, validate, export, coverage and report commands.',
              'All released test questions/answers are public; no secrecy/contamination-free claim.',
              'Private gold/raw generations/evaluation logs are not in the tracked public tree.',
              'scoring-smoke.json is fixture-only and does not report model performance.','']
    r.mkdir(parents=True,exist_ok=True);text='\n'.join(lines)
    target=r/'coverage.md'
    if target.exists() and target.read_text()!=text:raise ValueError('frozen readable report differs; use a new version')
    target.write_text(text,encoding='utf-8')
    print(json.dumps({'released':len(released),'universe':len(snap['nodes']),'remaining_authoring_batches':len(batches),'benchmark_complete':False}))

if __name__=='__main__':main()

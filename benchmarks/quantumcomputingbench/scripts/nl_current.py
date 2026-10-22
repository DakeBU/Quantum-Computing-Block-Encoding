#!/usr/bin/env python3
"""Validate/score an immutable native release under current withdrawal policy.

Use this additive current entry point; historical nl_qa.py and frozen pipeline
files remain byte-identical for provenance. No model or Lean execution occurs.
"""
from pathlib import Path
import argparse,json,sys
B=Path(__file__).resolve().parents[1];R=B.parents[1]
sys.path.insert(0,str(B/'src'));sys.path.insert(0,str(B/'scripts'))
from qcb_core import read_json,write_json,score
from qcb_nl import paths
from qcb_nl_release_policy import check_current_gold
from nl_qa import load_checked,summary


def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('command',choices=['validate','summary','score'])
    p.add_argument('--version',default='nl-v12')
    p.add_argument('--predictions')
    p.add_argument('--ratings')
    p.add_argument('--output')
    a=p.parse_args()
    try:
        _,items,released=load_checked(a.version)
        check_current_gold(released)
        if a.command=='score':
            if not a.predictions:raise ValueError('predictions JSON is required')
            result=score(released,read_json(a.predictions),read_json(a.ratings) if a.ratings else None)
            if a.output:
                target=Path(a.output).resolve()
                if target.is_relative_to(R):raise ValueError('private evaluation logs must remain outside public repository')
                write_json(target,result)
            print(json.dumps(result['by_track'],indent=2))
        else:
            print(json.dumps(summary(items,a.version),indent=2))
        return 0
    except (ValueError,KeyError,OSError) as error:
        print('ERROR: '+str(error),file=sys.stderr)
        return 1

if __name__=='__main__':raise SystemExit(main())

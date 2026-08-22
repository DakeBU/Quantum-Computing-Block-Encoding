# Formalization frontier

This file is generated manually only for the current admission branch and is not a substitute for Lean compilation.

## Remaud--Vandaele Algorithm 2 semantic DAG

1. `MultiControlledXSchedule`
   - arbitrary MCX basis semantics;
   - constructive activation decidability;
   - exact schedule count/depth.
2. `MultiControlledXEmbedding`
   - injective physical wire embedding;
   - exact logical readback;
   - outside-image noninterference.
3. `MultiControlledXScheduleSemantics` / `MultiControlledXLayerSemantics`
   - sequential composition semantics;
   - local semantics of one gate inside a certified depth-one layer.
4. `RemaudVandaeleLadderAlpha*` combinatorial chain
   - recursive parameters;
   - physical selected register `X'`;
   - recursive source order;
   - retained-target membership;
   - deleted-prefix count;
   - exact `alpha'` rank certificate.
5. `RemaudVandaeleLadderAlphaAlgorithmSchedule`
   - actual recursive source schedule `C_L ; Algorithm(X') ; C_R`;
   - exact source MCX-count and depth recurrences.
6. `RemaudVandaeleLadderAlphaOuterSemantics`
   - exact local action of `C_L` and `C_R`.
7. `RemaudVandaeleLadderAlphaSelectedNoninterference`
   - `C_L` does not target any physical wire retained in `X'`;
   - child readback therefore starts from the original parent input restricted to `X'`.
8. Next: recursive-target semantic bridge
   - under the strong-induction hypothesis for the child plan, identify every child `alpha'_j` target with its parent physical target.
9. Next: interval/cancellation bridge
   - split the parent interval predicate into the left-wall prefix and right-wall suffix;
   - prove the conditional-toggle cancellation identity used by the odd/even recursion.
10. Next: strong-induction semantic closure
   - prove the stagewise source schedule equals `equationSevenAction`;
   - conclude complete Algorithm-2 correctness.
11. Then: MCX-to-Toffoli refinement and resource propagation
   - connect the source-level MCX theorem to the Nie--Zi--Sun / Vandaele synthesis layer;
   - propagate concrete resources into comparator, incrementer, and adder results.

No node is considered admitted until its Lean target compiles in the admission CI.

# Current-source Blueprint admission

QuantumComputinglib publication must build the Verso Blueprint from the same current Lean checkout used to generate the Library Explorer and the Underlying Lean Graph.  This file is intentionally inside the proof/Blueprint change set so the 2026-08-20 State Preparation admission cannot inherit a pre-State-Preparation Blueprint artifact.

The admission is fail-closed: Lean and tests, declaration inventory, Blueprint, unified-site link checks, and Pages deployment must all succeed before obsolete development branches are pruned.

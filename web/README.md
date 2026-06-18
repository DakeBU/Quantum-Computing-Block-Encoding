# ABEIS Web Task Builder

This is a static local prototype for researchers who do not want to start from
GitHub commands.

Run it locally:

```bash
cd /path/to/Auto-Quantum-Computing-Bloack-Encoding-In-Sleep
python3 -m http.server 8080 -d web
```

Then open:

```text
http://localhost:8080/
```

The page does not run agents and does not upload data.  It turns a pasted
operator/oracle description, baseline construction, constraints, and preferred
report language into a Markdown task packet that can be given to ABEIS agents.

The scoring policy shown on the page is the repository policy:

1. compare asymptotic tiers first;
2. inside one tier, rank by `(gateCount, depth, auxiliaryQubits, oracleCalls)`;
3. accept correctness only after Lean proves the unitarity and block-entry
   certificates.

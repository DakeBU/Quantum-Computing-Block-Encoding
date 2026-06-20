const taskName = document.getElementById("taskName");
const mode = document.getElementById("mode");
const languagePreset = document.getElementById("languagePreset");
const languageCustom = document.getElementById("languageCustom");
const oracleDescription = document.getElementById("oracleDescription");
const normalizer = document.getElementById("normalizer");
const projector = document.getElementById("projector");
const baseline = document.getElementById("baseline");
const constraints = document.getElementById("constraints");
const exportQiskit = document.getElementById("exportQiskit");
const exportQuantumKatas = document.getElementById("exportQuantumKatas");
const exportQasm3 = document.getElementById("exportQasm3");
const exportInstantiation = document.getElementById("exportInstantiation");
const upperBackend = document.getElementById("upperBackend");
const middleBackend = document.getElementById("middleBackend");
const lower1Backend = document.getElementById("lower1Backend");
const lower2Backend = document.getElementById("lower2Backend");
const lower3Backend = document.getElementById("lower3Backend");
const reviewerBackend = document.getElementById("reviewerBackend");
const packet = document.getElementById("packet");
const copyStatus = document.getElementById("copyStatus");

function selectedLanguage() {
  if (languagePreset.value === "custom") {
    return languageCustom.value.trim() || "custom";
  }
  return languagePreset.value;
}

function modeDescription(value) {
  const descriptions = {
    operatorBlockEncoding:
      "Construct and evolve a block encoding for a user-specified operator.",
    paperBenchmark:
      "Faithfully reproduce a paper construction before any improvement search.",
    exploratoryConstruction:
      "Improve a known correct construction under a fixed operator target.",
  };
  return descriptions[value] || descriptions.operatorBlockEncoding;
}

function backendCommand(value) {
  const commands = {
    codex:
      'cd {root} && codex exec --dangerously-bypass-approvals-and-sandbox "$(cat {prompt})"',
    claude:
      'cd {root} && claude -p --permission-mode bypassPermissions "$(cat {prompt})"',
    gpt:
      'cd {root} && bash tools/vendor_agent_wrapper.example.sh gpt "{prompt}"',
    gemini:
      'cd {root} && bash tools/vendor_agent_wrapper.example.sh gemini "{prompt}"',
    glm:
      'cd {root} && bash tools/vendor_agent_wrapper.example.sh glm "{prompt}"',
    minimax:
      'cd {root} && bash tools/vendor_agent_wrapper.example.sh minimax "{prompt}"',
    custom:
      'cd {root} && bash tools/vendor_agent_wrapper.example.sh custom "{prompt}"',
  };
  return commands[value] || commands.custom;
}

function backendProfileJson() {
  return JSON.stringify(
    {
      commands: {
        upper: backendCommand(upperBackend.value),
        upper_natural_party: backendCommand(upperBackend.value),
        upper_lean_party: backendCommand(upperBackend.value),
        upper_parliament: backendCommand(upperBackend.value),
        middle: backendCommand(middleBackend.value),
        middle_natural_party: backendCommand(middleBackend.value),
        middle_lean_party: backendCommand(middleBackend.value),
        middle_parliament: backendCommand(middleBackend.value),
        natural_lower1: backendCommand(lower1Backend.value),
        natural_lower2: backendCommand(lower1Backend.value),
        lean_lower1: backendCommand(lower2Backend.value),
        lean_lower2: backendCommand(lower2Backend.value),
        lower1: backendCommand(lower1Backend.value),
        lower2: backendCommand(lower2Backend.value),
        lower3: backendCommand(lower3Backend.value),
        reviewer: backendCommand(reviewerBackend.value),
      },
      selectedBackends: {
        upper: upperBackend.value,
        upper_natural_party: upperBackend.value,
        upper_lean_party: upperBackend.value,
        upper_parliament: upperBackend.value,
        middle: middleBackend.value,
        middle_natural_party: middleBackend.value,
        middle_lean_party: middleBackend.value,
        middle_parliament: middleBackend.value,
        natural_lower1: lower1Backend.value,
        natural_lower2: lower1Backend.value,
        lean_lower1: lower2Backend.value,
        lean_lower2: lower2Backend.value,
        lower1: lower1Backend.value,
        lower2: lower2Backend.value,
        lower3: lower3Backend.value,
        reviewer: reviewerBackend.value,
      },
    },
    null,
    2,
  );
}

function selectedExportTargets() {
  const targets = [];
  if (exportQiskit.checked) {
    targets.push("qiskit");
  }
  if (exportQuantumKatas.checked) {
    targets.push("quantum-katas");
  }
  if (exportQasm3.checked) {
    targets.push("qasm3");
  }
  return targets;
}

function buildPacket() {
  const lang = selectedLanguage();
  const title = taskName.value.trim() || "operator-block-encoding-task";
  const date = new Date().toISOString();
  const exportTargets = selectedExportTargets();
  const md = `# ABEIS Task Packet: ${title}

Generated by the static web task builder at ${date}.

## Mode

- Mode: \`${mode.value}\`
- Meaning: ${modeDescription(mode.value)}
- Preferred human report language: \`${lang}\`

## Agent Backend Preferences

The web page does not call model APIs.  It records the user's preferred model
backend for each ABEIS role.  The local harness should map these preferences
to installed CLIs or wrappers.

\`\`\`json
${backendProfileJson()}
\`\`\`

## Operator Contract

Target operator or oracle requirement:

\`\`\`latex
${oracleDescription.value.trim() || "TBD"}
\`\`\`

Normalizer:

\`\`\`text
alpha = ${normalizer.value.trim() || "TBD"}
\`\`\`

Block projector / clean state:

\`\`\`text
${projector.value.trim() || "TBD"}
\`\`\`

Known baseline construction:

\`\`\`text
${baseline.value.trim() || "None supplied."}
\`\`\`

Constraints, free parameters, source links, and non-goals:

\`\`\`text
${constraints.value.trim() || "TBD"}
\`\`\`

## Post-Lean Executable Exports

- Export policy: Lean-first.  Generate runnable artifacts only after a named
  Lean declaration proves the advertised block-encoding theorem at the stated
  semantic tier.
- Requested targets: ${exportTargets.length ? exportTargets.map((target) => `\`${target}\``).join(", ") : "none"}
- Concrete export instantiation:

\`\`\`text
${exportInstantiation.value.trim() || "TBD"}
\`\`\`

Export requirements:

1. Qiskit export, if selected: write Python/Qiskit code for the certified
   circuit and run exact finite assertions whenever the instance is small
   enough to materialize.
2. QuantumKatas export, if selected: write a kata-style task plus deterministic
   tests that match the certified construction.
3. OpenQASM export, if selected: emit an OpenQASM 3 transcript and parser/smoke
   checks.
4. Each export must state its register sizes, parameter values, normalizer,
   projector, and whether it is a concrete instantiation or a symbolic-family
   wrapper.

## Required ABEIS Discipline

1. Fix the mathematical target before candidate search.
2. Keep natural-language proof plans separate from Lean-certified claims.
3. A candidate enters the certified population only after Lean proves:
   - the candidate matrix/unitary is unitary in the chosen semantics;
   - the requested block-entry equation equals the target operator divided by \`alpha\`;
   - the resource record matches the circuit schedule.
4. Necessary-condition checks may reject candidates early, but may not certify them.
5. Post-Lean executable exports may be delivered to users after certification,
   but they do not replace the Lean theorem.
6. Compare asymptotic tiers first.  Inside one tier, use the concrete tuple:

\`\`\`text
(gateCount, depth, auxiliaryQubits, oracleCalls)
\`\`\`

## Suggested Agent Packet

- Natural-language opposition party: explore circuit ideas, proof DAGs, approximate relaxations, and insight-population entries without editing Lean.
- Lean governing party: translate selected ideas into Lean declarations, resource-score theorems, and post-Lean executable exports.
- Parliament/chief-justice layer: compare the two parties, decide capacity increases, decide exact-to-approximate phase switches, and trigger preferred-language ChatGPT Pro prompts when progress stalls.
- Middle coordination: keep the Lean-to-natural-language and natural-language-to-Lean correspondence current so each party can reuse the other party ideas.
- Reviewer: reject hidden assumptions, wrong metric ordering, simulator-only claims, and unverified candidates in plots.

## First Command Sketch

\`\`\`bash
export QBE_REPORT_LANGUAGE="${lang}"
python3 tools/qbe.py new-task "${title}" \\
  --mode "${mode.value}" \\
  --source "web task packet" \\
  --target-lean "TBD" \\
  --export-targets "${exportTargets.length ? exportTargets.join(",") : "none"}" \\
  --export-instantiation "${(exportInstantiation.value.trim() || "TBD").replace(/"/g, '\\"')}"
python3 tools/qbe.py run-cycle "${title}"
# Optional after saving the JSON above as agent-profiles/${title}.json.
# This command uses the party-parliament profile.  For the classic tri-role profile,
# remove --party-parliament, --natural-lower-count, and --lean-lower-count:
python3 tools/qbe.py sleep-run "${title}" \\
  --cycles 2 \\
  --party-parliament \\
  --natural-lower-count 2 \\
  --lean-lower-count 2 \\
  --agent-profile "${title}.json" \\
  --execute \\
  --check-each-cycle
\`\`\`
`;
  packet.textContent = md;
}

async function copyPacket() {
  await navigator.clipboard.writeText(packet.textContent);
  copyStatus.textContent = "Copied";
  window.setTimeout(() => {
    copyStatus.textContent = "";
  }, 1600);
}

function downloadPacket() {
  const blob = new Blob([packet.textContent], { type: "text/markdown" });
  const url = URL.createObjectURL(blob);
  const a = document.createElement("a");
  const safeName = (taskName.value.trim() || "abeis-task")
    .replace(/[^a-z0-9._-]+/gi, "-")
    .replace(/^-+|-+$/g, "");
  a.href = url;
  a.download = `${safeName || "abeis-task"}.md`;
  document.body.appendChild(a);
  a.click();
  a.remove();
  URL.revokeObjectURL(url);
}

languagePreset.addEventListener("change", () => {
  languageCustom.disabled = languagePreset.value !== "custom";
  buildPacket();
});

[
  taskName,
  mode,
  languageCustom,
  oracleDescription,
  normalizer,
  projector,
  baseline,
  constraints,
  exportQiskit,
  exportQuantumKatas,
  exportQasm3,
  exportInstantiation,
  upperBackend,
  middleBackend,
  lower1Backend,
  lower2Backend,
  lower3Backend,
  reviewerBackend,
].forEach((element) => {
  element.addEventListener("input", buildPacket);
  element.addEventListener("change", buildPacket);
});

document.getElementById("buildPacket").addEventListener("click", buildPacket);
document.getElementById("copyPacket").addEventListener("click", copyPacket);
document.getElementById("downloadPacket").addEventListener("click", downloadPacket);

buildPacket();

const taskName = document.getElementById("taskName");
const mode = document.getElementById("mode");
const harnessMode = document.getElementById("harnessMode");
const runLocation = document.getElementById("runLocation");
const apiProvider = document.getElementById("apiProvider");
const defaultModel = document.getElementById("defaultModel");
const runnerEndpoint = document.getElementById("runnerEndpoint");
const apiKey = document.getElementById("apiKey");
const redactApiKey = document.getElementById("redactApiKey");
const languagePreset = document.getElementById("languagePreset");
const languageCustom = document.getElementById("languageCustom");
const oracleDescription = document.getElementById("oracleDescription");
const normalizer = document.getElementById("normalizer");
const projector = document.getElementById("projector");
const baseline = document.getElementById("baseline");
const userInsight = document.getElementById("userInsight");
const proAdvice = document.getElementById("proAdvice");
const proposedBE = document.getElementById("proposedBE");
const proposedProof = document.getElementById("proposedProof");
const insightPolicy = document.getElementById("insightPolicy");
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
const dashboardJson = document.getElementById("dashboardJson");
const dashboardView = document.getElementById("dashboardView");

const sampleDashboard = {
  task: "QBE-OP-OPTCTRL-COLD-CLEAN-001",
  harness: "Hierarchical Harness",
  phase: "exact search, continued convergence test",
  champion: {
    name: "COLD-CLEAN-PERM-001",
    lean: "coldE1Candidate_blockProjection",
    score: { gateCount: 4, depth: 4, auxiliaryQubits: 1, oracleCalls: 0 },
    status: "Lean-certified checkpoint",
  },
  curves: [
    { generation: 1, phase: "exact", gateCount: 4, depth: 4, auxiliaryQubits: 1 },
    { generation: 2, phase: "exact", gateCount: 4, depth: 4, auxiliaryQubits: 1 },
  ],
  circuits: [
    {
      name: "COLD-CLEAN-PERM-001",
      kind: "finite permutation",
      lean: "coldE1CandidateImage_permutation_certificate",
      score: "(4,4,1,0)",
      sketch: "selected clean inputs (a,T,tau,S)=(0,1,1,S) map to (0,0,0,S); other clean inputs leave the clean block",
    },
  ],
  exports: [
    { target: "Qiskit", status: "passed", detail: "finite matrix, block-entry, unitarity, and Qiskit operator checks pass" },
  ],
  nextAction: "Continue exact convergence; if no improvement, enter approximate phase and plot epsilon ladder.",
};

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

function harnessDescription(value) {
  const descriptions = {
    hierarchical:
      "Hierarchical Harness: one upper/middle/lower/reviewer stack; middle coordinates the natural-language architect, Lean worker, and verifier.",
    game:
      "Game Harness: two hierarchical teams compete and collaborate; the Natural-Language Team writes human proofs, the Lean Team writes compiled certificates, and the Game Council transfers user/Pro insights.",
    parallel:
      "Parallel comparison: run Hierarchical and Game harnesses in isolated worktrees with the same task, model profile, budget, and Lean gate.",
  };
  return descriptions[value] || descriptions.hierarchical;
}
function apiKeyLine() {
  if (!apiKey.value.trim()) {
    return "- API key present: no";
  }
  if (redactApiKey.checked) {
    return "- API key present: yes, redacted from packet; pass it through your local shell or self-hosted runner secret store";
  }
  return `- API key present: yes, user chose to include it in the generated packet: ${apiKey.value.trim()}`;
}

function runnerEnvTemplate() {
  const provider = apiProvider.value;
  const endpoint = runnerEndpoint.value.trim() || "TBD";
  const model = defaultModel.value.trim() || "use agent-profile defaults";
  const keyName = {
    openai: "OPENAI_API_KEY",
    anthropic: "ANTHROPIC_API_KEY",
    gemini: "GEMINI_API_KEY",
    glm: "GLM_API_KEY",
    minimax: "MINIMAX_API_KEY",
    custom: "CUSTOM_LLM_API_KEY",
  }[provider] || "LLM_API_KEY";
  return `ABEIS_RUN_LOCATION=${runLocation.value}
ABEIS_API_PROVIDER=${provider}
ABEIS_DEFAULT_MODEL=${model}
ABEIS_RUNNER_ENDPOINT=${endpoint}
# Set this in your shell or self-hosted runner secret store, not in Git:
${keyName}=...`;
}

function localRunnerCommand(title) {
  const profileName = `${title}.json`;
  const harnessFlag = harnessMode.value === "game" ? "--game-harness" : "--hierarchical-harness";
  const extra = harnessMode.value === "game" ? "  --natural-lower-count 2 \\\n  --lean-lower-count 2 \\\n" : "";
  return `# In a downloaded checkout, serve the UI and run the task with local tools.
python3 -m http.server 8080 -d web

# In another terminal, save this packet and the generated profile, then run:
python3 tools/qbe.py sleep-run "${title}" \\
  ${harnessFlag} \\
${extra}  --agent-profile "agent-profiles/${profileName}" \\
  --execute \\
  --check-each-cycle

# The web dashboard can render:
# reports/${title}/dashboard.json
# reports/${title}/evolution.json
# reports/${title}/circuit_storyboard.json`;
}


function sleepRunCommands(title, profileName) {
  const common = String.raw`  --cycles 2 \
  --agent-profile "${profileName}" \
  --execute \
  --check-each-cycle`;
  const hierarchical = String.raw`python3 tools/qbe.py sleep-run "${title}" \
  --hierarchical-harness \
${common}`;
  const game = String.raw`python3 tools/qbe.py sleep-run "${title}" \
  --game-harness \
  --natural-lower-count 2 \
  --lean-lower-count 2 \
${common}`;
  if (harnessMode.value === "game") {
    return game;
  }
  if (harnessMode.value === "parallel") {
    return `# Run these in isolated worktrees or separate output directories for a fair comparison.
${hierarchical}

${game}`;
  }
  return hierarchical;
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
        upper_nl_team: backendCommand(upperBackend.value),
        upper_lean_team: backendCommand(upperBackend.value),
        upper_game_council: backendCommand(upperBackend.value),
        middle: backendCommand(middleBackend.value),
        middle_nl_team: backendCommand(middleBackend.value),
        middle_lean_team: backendCommand(middleBackend.value),
        middle_game_council: backendCommand(middleBackend.value),
        nl_lower1: backendCommand(lower1Backend.value),
        nl_lower2: backendCommand(lower1Backend.value),
        lean_lower1: backendCommand(lower2Backend.value),
        lean_lower2: backendCommand(lower2Backend.value),
        lower1: backendCommand(lower1Backend.value),
        lower2: backendCommand(lower2Backend.value),
        lower3: backendCommand(lower3Backend.value),
        reviewer: backendCommand(reviewerBackend.value),
      },
      runner: {
        runLocation: runLocation.value,
        apiProvider: apiProvider.value,
        defaultModel: defaultModel.value,
        runnerEndpoint: runnerEndpoint.value,
        apiKeyPresent: Boolean(apiKey.value.trim()),
        apiKeyRedacted: redactApiKey.checked,
      },
      selectedBackends: {
        upper: upperBackend.value,
        upper_nl_team: upperBackend.value,
        upper_lean_team: upperBackend.value,
        upper_game_council: upperBackend.value,
        middle: middleBackend.value,
        middle_nl_team: middleBackend.value,
        middle_lean_team: middleBackend.value,
        middle_game_council: middleBackend.value,
        nl_lower1: lower1Backend.value,
        nl_lower2: lower1Backend.value,
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
- Harness strategy: \`${harnessMode.value}\`
- Harness meaning: ${harnessDescription(harnessMode.value)}
- Preferred human report language: \`${lang}\`

## Runner And API Ownership

- Run location: \`${runLocation.value}\`
- API provider: \`${apiProvider.value}\`
- Default model: \`${defaultModel.value.trim() || "use agent-profile defaults"}\`
- Runner endpoint: \`${runnerEndpoint.value.trim() || "TBD"}\`
${apiKeyLine()}

Environment template for local CLI or a self-hosted web runner:

\`\`\`bash
${runnerEnvTemplate()}
\`\`\`

The public ABEIS website should not spend project-owned model credits for users.
Users either run the CLI locally, connect the page to their own self-hosted
runner, or paste this task packet into their preferred AI coding agent.

Local repository web mode uses the same packet.  Open \`web/index.html\`
through a local static server, run the command below in the downloaded
repository, and paste the resulting dashboard JSON back into the page:

\`\`\`bash
${localRunnerCommand(title)}
\`\`\`

Hosted web mode is different only in execution ownership: the page may talk to
a user-owned runner endpoint or API-backed service, but the runner must still
write the same ABEIS artifacts and the same Lean gate output.

## Agent Backend Preferences

The web page records the user's preferred model backend for each ABEIS role.
The local harness or self-hosted runner should map these preferences to
installed CLIs, API wrappers, or provider-specific endpoints.

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

## User / Pro Insight Injection

These optional inputs are search guidance, not proof certificates.  In Game
Harness mode, the Game Council must route them explicitly: Natural-Language
Team proof review, Lean Team formalization, parallel review/formalization, or
rejected-route memory.  In Hierarchical Harness mode, upper and middle must
turn them into work packets or record why they are ignored.  No candidate from
this section may enter the certified population until Lean proves it.

- Injection policy: \`${insightPolicy.value}\`

User intuition or strategy notes:

\`\`\`text
${userInsight.value.trim() || "None supplied."}
\`\`\`

ChatGPT Pro / external AI advice:

\`\`\`text
${proAdvice.value.trim() || "None supplied."}
\`\`\`

Proposed candidate block encoding:

\`\`\`text
${proposedBE.value.trim() || "None supplied."}
\`\`\`

Proposed proof or correctness argument:

\`\`\`text
${proposedProof.value.trim() || "None supplied."}
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

- Hierarchical Harness: upper and middle agents maintain the target, proof DAG, insight population, and lower work packets for one natural-language architect, one Lean worker, and one verifier.
- Game Harness: run two semi-independent hierarchical teams.  The Natural-Language Team competes by writing reviewer-plausible mathematical constructions and proofs.  The Lean Team competes by writing compiled Lean constructions and certificates.  The Game Council coordinates insight transfer, user/ChatGPT-Pro input routing, capacity increases, exact-to-approximate phase switches, and team-to-team translation.
- Translation rule: Lean-certified BE candidates go to the Natural-Language Team for human-readable LaTeX proof export.  Reviewer-plausible natural-language constructions go through the Game Council/reviewer and then to the Lean Team for formalization.
- Reviewer: reject hidden assumptions, wrong metric ordering, simulator-only claims, and unverified candidates in plots.
- Closeout: after Lean certification, export a step-by-step LaTeX BE proof, circuit diagrams, exact/approximate evolution curves, and checked executable artifacts such as Qiskit, QuantumKatas-style tests, or QASM.

## Web Dashboard And Report Outputs

The runner should write machine-readable status files that the web page can render:

- \`reports/<task-id>/dashboard.json\`: active phase, current champion, blocked leaf, and next action per harness.
- \`reports/<task-id>/evolution.json\`: exact and approximate BE curves; only Lean-certified candidates count as achieved points.
- \`reports/<task-id>/circuit_storyboard.json\`: diagram metadata for every certified candidate shown in the report.
- \`runs/<run-id>/<language>_summary.md\`: selected-language human summary.
- \`runs/<run-id>/chatgpt_pro_prompt.md\`: self-contained external-reasoning prompt if unresolved.
- \`paper-notes/problem-exports/<task-id>/latest.tex\`: user-copyable LaTeX proof after Lean closure.

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
# Optional after saving the JSON above as agent-profiles/${title}.json:
${sleepRunCommands(title, `${title}.json`)}
\`\`\`
`;
  packet.textContent = md;
}

function htmlEscape(value) {
  return String(value)
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;");
}

function normalizeScore(score) {
  if (!score) {
    return "unknown";
  }
  if (typeof score === "string") {
    return score;
  }
  return `(${score.gateCount ?? "?"},${score.depth ?? "?"},${score.auxiliaryQubits ?? "?"},${score.oracleCalls ?? "?"})`;
}

function phaseClass(phase) {
  return String(phase || "").toLowerCase().includes("approx") ? "approx" : "exact";
}

function renderCurve(curves) {
  if (!Array.isArray(curves) || curves.length === 0) {
    return `<p class="dashboard-empty">No certified evolution curve supplied yet.</p>`;
  }
  const maxValue = Math.max(
    1,
    ...curves.flatMap((point) => [Number(point.gateCount || 0), Number(point.depth || 0)]),
  );
  const rows = curves
    .map((point) => {
      const gate = Number(point.gateCount || 0);
      const depth = Number(point.depth || 0);
      const gateWidth = Math.max(4, (gate / maxValue) * 100);
      const depthWidth = Math.max(4, (depth / maxValue) * 100);
      return `<div class="curve-row ${phaseClass(point.phase)}">
        <div class="curve-gen">Gen ${htmlEscape(point.generation ?? "?")}</div>
        <div class="curve-bars">
          <div class="bar-line"><span>gates</span><i style="width:${gateWidth}%"></i><b>${htmlEscape(gate)}</b></div>
          <div class="bar-line depth"><span>depth</span><i style="width:${depthWidth}%"></i><b>${htmlEscape(depth)}</b></div>
        </div>
        <div class="curve-phase">${htmlEscape(point.phase || "exact")}</div>
      </div>`;
    })
    .join("");
  return `<div class="curve-list">${rows}</div>`;
}

function renderCircuitCards(circuits) {
  if (!Array.isArray(circuits) || circuits.length === 0) {
    return `<p class="dashboard-empty">No certified circuit storyboard supplied yet.</p>`;
  }
  return `<div class="circuit-grid">${circuits
    .map(
      (circuit) => `<article class="circuit-card-web">
        <header>
          <h4>${htmlEscape(circuit.name || "candidate")}</h4>
          <span>${htmlEscape(circuit.score || normalizeScore(circuit.resource_score))}</span>
        </header>
        <div class="mini-circuit" aria-hidden="true">
          <div class="wire-row"><b>a</b><i></i><em>U</em><i></i></div>
          <div class="wire-row"><b>T</b><i></i><em>${htmlEscape(circuit.kind || "BE")}</em><i></i></div>
          <div class="wire-row"><b>sys</b><i></i><em>I</em><i></i></div>
        </div>
        <p><strong>Lean:</strong> ${htmlEscape(circuit.lean || "pending")}</p>
        <p>${htmlEscape(circuit.sketch || "No human-readable sketch supplied.")}</p>
      </article>`,
    )
    .join("")}</div>`;
}

function renderExports(exports) {
  if (!Array.isArray(exports) || exports.length === 0) {
    return `<p class="dashboard-empty">No post-Lean executable export status supplied yet.</p>`;
  }
  return `<ul class="export-status">${exports
    .map(
      (item) => `<li><strong>${htmlEscape(item.target || "export")}:</strong> ${htmlEscape(item.status || "unknown")} — ${htmlEscape(item.detail || "")}</li>`,
    )
    .join("")}</ul>`;
}

function renderDashboardFromJson() {
  let data;
  try {
    data = JSON.parse(dashboardJson.value.trim());
  } catch (error) {
    dashboardView.innerHTML = `<p class="dashboard-error">Could not parse JSON: ${htmlEscape(error.message)}</p>`;
    return;
  }
  const champion = data.champion || {};
  dashboardView.innerHTML = `<div class="dashboard-summary">
      <div><span>Task</span><strong>${htmlEscape(data.task || "unknown")}</strong></div>
      <div><span>Harness</span><strong>${htmlEscape(data.harness || "unknown")}</strong></div>
      <div><span>Phase</span><strong>${htmlEscape(data.phase || "unknown")}</strong></div>
      <div><span>Champion</span><strong>${htmlEscape(champion.name || "none")}</strong></div>
      <div><span>Score</span><strong>${htmlEscape(normalizeScore(champion.score))}</strong></div>
      <div><span>Status</span><strong>${htmlEscape(champion.status || "unknown")}</strong></div>
    </div>
    <h4>Certified exact/approximate curve</h4>
    ${renderCurve(data.curves || data.evolution)}
    <h4>Certified circuit storyboard</h4>
    ${renderCircuitCards(data.circuits || data.storyboard)}
    <h4>Post-Lean executable exports</h4>
    ${renderExports(data.exports)}
    <h4>Next action</h4>
    <p class="next-action">${htmlEscape(data.nextAction || data.next_action || "No next action supplied.")}</p>`;
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
  harnessMode,
  runLocation,
  apiProvider,
  defaultModel,
  runnerEndpoint,
  apiKey,
  redactApiKey,
  languageCustom,
  oracleDescription,
  normalizer,
  projector,
  baseline,
  userInsight,
  proAdvice,
  proposedBE,
  proposedProof,
  insightPolicy,
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
document.getElementById("renderDashboard").addEventListener("click", renderDashboardFromJson);
document.getElementById("sampleDashboard").addEventListener("click", () => {
  dashboardJson.value = JSON.stringify(sampleDashboard, null, 2);
  renderDashboardFromJson();
});

buildPacket();
dashboardJson.value = JSON.stringify(sampleDashboard, null, 2);
renderDashboardFromJson();

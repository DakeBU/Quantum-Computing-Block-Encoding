(() => {
  "use strict";

  const $ = (id) => document.getElementById(id);
  const fields = {
    preset: $("benchmarkPreset"), task: $("taskName"), mode: $("mode"),
    harness: $("harnessMode"), target: $("oracleDescription"),
    normalizer: $("normalizer"), projector: $("projector"),
    constraints: $("constraints"), baseline: $("baseline"),
    insight: $("userInsight"), proof: $("proposedProof"),
    runLocation: $("runLocation"), provider: $("apiProvider"),
    model: $("defaultModel"), endpoint: $("runnerEndpoint"), key: $("apiKey"),
    checkRequired: $("checkRequired"), unitaryTolerance: $("unitarityTolerance"),
    cleanBlockTolerance: $("cleanBlockTolerance"), roundTrip: $("requireCanonicalRoundTrip"),
    exportCanonical: $("exportCanonicalIr"), exportQiskit: $("exportQiskitPython"),
    exportQasm: $("exportOpenQasm3"), exportMetrics: $("exportMetricsJson"),
    exportText: $("exportCircuitText"), packet: $("packet"),
  };
  let cases = [];

  function selectedCase() {
    return cases.find((item) => item.slug === fields.preset.value);
  }

  function applyPreset(caseItem) {
    if (!caseItem) return;
    const preset = caseItem.preset;
    fields.task.value = preset.taskName;
    fields.mode.value = preset.mode;
    fields.target.value = preset.target;
    fields.normalizer.value = preset.normalizer;
    fields.projector.value = preset.projector;
    fields.baseline.value = `${caseItem.title}: ${caseItem.summary}`;
    fields.constraints.value = caseItem.limitations;
    buildPacket();
  }

  function packetData() {
    const backend = document.querySelector('input[name="intermediateBackend"]:checked')?.value || "none";
    const formats = [
      [fields.exportCanonical, "canonicalIrJson"],
      [fields.exportQiskit, "qiskitPython"],
      [fields.exportQasm, "openqasm3"],
      [fields.exportMetrics, "metricsJson"],
      [fields.exportText, "circuitText"],
    ].filter(([control]) => control.checked).map(([, name]) => name);
    return {
      schemaVersion: 2,
      generatedAt: new Date().toISOString(),
      caseSlug: selectedCase()?.slug || null,
      taskName: fields.task.value.trim(),
      kind: fields.mode.value,
      target: fields.target.value.trim(),
      normalizer: fields.normalizer.value.trim(),
      projector: fields.projector.value.trim(),
      constraints: fields.constraints.value.trim(),
      baseline: fields.baseline.value.trim(),
      userInsight: fields.insight.value.trim(),
      proposedProof: fields.proof.value.trim(),
      harness: fields.harness.value,
      runner: {
        location: fields.runLocation.value,
        provider: fields.provider.value,
        model: fields.model.value.trim(),
        endpoint: fields.endpoint.value.trim(),
        apiKeyPresentInSession: Boolean(fields.key.value),
        apiKeyExported: false,
      },
      executablePolicy: {
        intermediateCheck: {
          backend,
          required: fields.checkRequired.checked && backend !== "none",
          unitarityTolerance: Number(fields.unitaryTolerance.value),
          cleanBlockTolerance: Number(fields.cleanBlockTolerance.value),
          requireCanonicalRoundTrip: fields.roundTrip.checked,
        },
        exports: {formats},
      },
      status: "draft",
    };
  }

  function buildPacket() {
    const data = packetData();
    fields.packet.textContent = `# ASPBE Task Packet: ${data.taskName || "untitled"}\n\n` +
      `- Application: \`${data.kind}\`\n- Harness: \`${data.harness}\`\n` +
      `- Runner: \`${data.runner.location}\`, provider \`${data.runner.provider}\`\n` +
      `- API key: ${data.runner.apiKeyPresentInSession ? "present in this session; never exported" : "not provided"}\n\n` +
      `## Mathematical contract\n\n\`\`\`text\n${data.target}\n\`\`\`\n\n` +
      `Normalizer: \`${data.normalizer}\`\n\nInitial / clean state: \`${data.projector}\`\n\n` +
      `## Constraints\n\n${data.constraints || "None supplied."}\n\n` +
      `## Baseline and guidance\n\n${data.baseline || "No baseline supplied."}\n\n${data.userInsight}\n\n${data.proposedProof}\n\n` +
      `## Executable policy\n\nIntermediate checker: \`${data.executablePolicy.intermediateCheck.backend}\` (${data.executablePolicy.intermediateCheck.required ? "required" : "optional"}).\n\n` +
      `Requested artifacts: ${data.executablePolicy.exports.formats.map((item) => `\`${item}\``).join(", ") || "none"}.\n\n` +
      `## Acceptance boundary\n\nExecutable checks may reject, rank, and queue candidates for proof. Exact certification requires a named Lean root, or an external exact certificate checked by Lean.`;
    return data;
  }

  async function copyPacket() {
    await navigator.clipboard.writeText(fields.packet.textContent);
    $("runnerStatus").textContent = "Packet copied without credentials.";
  }

  function downloadPacket() {
    const blob = new Blob([fields.packet.textContent], {type: "text/markdown"});
    const link = document.createElement("a");
    link.href = URL.createObjectURL(blob);
    link.download = `${fields.task.value.trim() || "aspbe-task"}.md`;
    link.click();
    URL.revokeObjectURL(link.href);
  }

  async function runWithApi() {
    const status = $("runnerStatus");
    if (!fields.endpoint.value.trim()) {
      status.textContent = "Enter a runner endpoint you control.";
      return;
    }
    const headers = {"Content-Type": "application/json"};
    if (fields.key.value) headers.Authorization = `Bearer ${fields.key.value}`;
    status.textContent = "Sending to your runner...";
    try {
      const taskPacket = packetData();
      const taskId = (taskPacket.taskName || "aspbe-user-task")
        .toLowerCase().replace(/[^a-z0-9._-]+/g, "-").replace(/^-+|-+$/g, "")
        .slice(0, 96) || "aspbe-user-task";
      const request = {
        task: {
          id: taskId,
          target: taskPacket.target,
          mode: taskPacket.kind,
          harness: taskPacket.harness,
          language: "en",
          executablePolicy: taskPacket.executablePolicy,
        },
        provider: taskPacket.runner.provider,
        model: taskPacket.runner.model,
        packet: fields.packet.textContent,
      };
      const response = await fetch(fields.endpoint.value.trim(), {
        method: "POST", headers, body: JSON.stringify(request), cache: "no-store",
      });
      if (!response.ok) throw new Error(`runner returned ${response.status}`);
      $("dashboardJson").value = JSON.stringify(await response.json(), null, 2);
      status.textContent = "Runner response received.";
    } catch (error) {
      status.textContent = `Runner request failed: ${error.message}`;
    }
  }

  function renderDashboard() {
    const view = $("dashboardView");
    try {
      const result = JSON.parse($("dashboardJson").value);
      view.textContent = JSON.stringify(result, null, 2);
    } catch (error) {
      view.textContent = `Invalid JSON: ${error.message}`;
    }
  }

  async function loadCases() {
    const response = await fetch("../data/example-cases.json", {cache: "no-store"});
    if (!response.ok) throw new Error("Example-case data is unavailable");
    cases = (await response.json()).cases;
    cases.forEach((item) => fields.preset.add(new Option(item.title, item.slug)));
    const requested = new URLSearchParams(location.search).get("case");
    const match = cases.find((item) => item.slug === requested);
    if (match) {
      fields.preset.value = match.slug;
      applyPreset(match);
    }
  }

  $("buildPacket").addEventListener("click", buildPacket);
  $("copyPacket").addEventListener("click", copyPacket);
  $("downloadPacket").addEventListener("click", downloadPacket);
  $("runWithApi").addEventListener("click", runWithApi);
  $("renderDashboard").addEventListener("click", renderDashboard);
  fields.preset.addEventListener("change", () => applyPreset(selectedCase()));
  document.querySelectorAll(".task-builder input, .task-builder textarea, .task-builder select")
    .forEach((control) => control.addEventListener("change", buildPacket));
  function migratePacket(packet) {
    if (Number(packet?.schemaVersion || 1) !== 1) return structuredClone(packet);
    const old = packet.exports || {};
    const formats = ["canonicalIrJson", "metricsJson"];
    if (old.qiskit) formats.push("qiskitPython");
    if (old.qasm3) formats.push("openqasm3");
    const backend = old.qiskit && old.qasm3 ? "both" : old.qiskit ? "qiskitOperator" : old.qasm3 ? "openqasm3RoundTrip" : "none";
    const migrated = structuredClone(packet);
    delete migrated.exports;
    migrated.schemaVersion = 2;
    migrated.executablePolicy = {
      intermediateCheck: {backend, required: backend !== "none", unitarityTolerance: 1e-10, cleanBlockTolerance: 1e-10, requireCanonicalRoundTrip: true},
      exports: {formats: [...new Set(formats)]},
    };
    return migrated;
  }

  window.AspbeTaskBuilder = {packetData, buildPacket, migratePacket};
  loadCases().catch((error) => { $("runnerStatus").textContent = error.message; });
  buildPacket();
})();

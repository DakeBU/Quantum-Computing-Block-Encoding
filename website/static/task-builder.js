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
    qiskit: $("exportQiskit"), qasm: $("exportQasm3"), packet: $("packet"),
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
    return {
      schemaVersion: 1,
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
      exports: {qiskit: fields.qiskit.checked, qasm3: fields.qasm.checked},
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
      `## Acceptance boundary\n\nLean is the proof authority. Executable exports are cross-checks and must name the accepted Lean root.`;
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
      const response = await fetch(fields.endpoint.value.trim(), {
        method: "POST", headers, body: JSON.stringify(packetData()), cache: "no-store",
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
  window.AspbeTaskBuilder = {packetData, buildPacket};
  loadCases().catch((error) => { $("runnerStatus").textContent = error.message; });
  buildPacket();
})();

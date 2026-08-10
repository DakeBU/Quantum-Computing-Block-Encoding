(() => {
  "use strict";

  const app = document.querySelector("[data-ide-app]");
  if (!app) return;

  const $ = (selector) => document.querySelector(selector);
  const select = $("[data-ide-declaration]");
  const latex = $("[data-ide-latex]");
  const lean = $("[data-ide-lean]");
  const preview = $("[data-ide-math-preview]");
  const plain = $("[data-ide-plain]");
  const diagnostics = $("[data-ide-diagnostics]");
  const duration = $("[data-ide-duration]");
  const mode = $("[data-ide-mode]");
  const modeTitle = $("[data-ide-mode-title]");
  const modeDetail = $("[data-ide-mode-detail]");
  const translationStatus = $("[data-translation-status]");
  const declarationLink = $("[data-ide-declaration-link]");
  const sourceLink = $("[data-ide-source-link]");
  const tree = $("[data-ide-tree]");
  const treeSummary = $("[data-ide-tree-summary]");
  const autoCompile = $("[data-ide-auto]");
  const compileButton = $("[data-ide-compile]");
  const translateButton = $("[data-ide-translate]");
  const loadButton = $("[data-ide-load]");
  const scaffoldButton = $("[data-ide-scaffold]");
  const exportButton = $("[data-ide-export]");
  const submitButton = $("[data-ide-submit]");
  const exportNote = $("[data-ide-export-note]");
  const contributorName = $("[data-contributor-name]");
  const contributorCredit = $("[data-contributor-credit]");
  const contributorSource = $("[data-contributor-source]");

  let items = [];
  let current = null;
  let localLean = false;
  let translatorAvailable = false;
  let compileTimer = null;
  let lastCompiledSource = "";
  let lastCompileOk = false;

  const setMode = (available, translator, detail) => {
    localLean = available;
    translatorAvailable = translator;
    mode?.classList.toggle("local", available);
    if (modeTitle) {
      modeTitle.textContent = available
        ? "Local ASPBE Lean compiler connected"
        : "Static teaching mode";
    }
    if (modeDetail) modeDetail.textContent = detail;
    if (compileButton) compileButton.disabled = !available;
    if (translateButton) {
      translateButton.disabled = !translator;
      translateButton.title = translator
        ? "Ask the configured local agent for a Lean draft"
        : "Start ide_server.py with --translator-command to enable this action";
    }
    if (autoCompile) {
      autoCompile.disabled = !available;
      if (!available) autoCompile.checked = false;
    }
  };

  const typeset = async () => {
    try {
      if (window.MathJax?.startup?.promise) await window.MathJax.startup.promise;
      window.MathJax?.typesetClear?.([preview]);
      await window.MathJax?.typesetPromise?.([preview]);
    } catch (error) {
      console.error("MathJax preview failed", error);
    }
  };

  const renderMath = () => {
    if (!preview || !latex) return;
    preview.textContent = latex.value.trim() || "Enter a LaTeX statement.";
    typeset();
  };

  const treeNode = (label, href, className = "") => {
    const node = document.createElement(href ? "a" : "div");
    node.className = `dependency-node ${className}`.trim();
    node.textContent = label;
    if (href) node.href = href;
    return node;
  };

  const renderTree = (item) => {
    if (!tree) return;
    tree.replaceChildren();
    tree.append(treeNode(item.name, item.url, "root"));
    tree.append(treeNode(`module: ${item.module}`, item.source_url, "module"));
    item.dependencies.forEach((dependency) => {
      tree.append(treeNode(dependency.name, dependency.url, "dependency"));
    });
    if (!item.dependencies.length) {
      tree.append(treeNode("No curated dependency recorded", "", "empty"));
    }
    if (treeSummary) {
      treeSummary.textContent = `${item.dependencies.length} teaching dependencies`;
    }
  };

  const invalidateCompile = () => {
    lastCompiledSource = "";
    lastCompileOk = false;
    diagnostics?.classList.remove("success", "failure");
  };

  const loadMapping = (item) => {
    current = item;
    if (latex) latex.value = item.latex;
    if (lean) lean.value = item.compile_source;
    if (plain) plain.textContent = item.plain;
    if (translationStatus) {
      translationStatus.textContent = "Reviewed mapping";
      translationStatus.className = "reviewed";
    }
    if (declarationLink) declarationLink.href = item.url;
    if (sourceLink) sourceLink.href = item.source_url;
    renderMath();
    renderTree(item);
    if (diagnostics) {
      diagnostics.textContent = "Reviewed mapping loaded. Compile to check it with the pinned ASPBE toolchain.";
    }
    invalidateCompile();
    scheduleCompile();
  };

  const safeDraftScaffold = () => {
    const source = (latex?.value || "")
      .replace(/\r?\n/g, " ")
      .replace(/--/g, "-")
      .slice(0, 1200);
    if (lean) {
      lean.value = [
        "import QuantumBlockEncoding",
        "",
        "-- DRAFT ONLY: the LaTeX below has not been translated into a proposition.",
        `-- ${source}`,
        "-- Replace True with the reviewed mathematical statement.",
        "example : True := by",
        "  trivial",
        "",
      ].join("\n");
    }
    if (translationStatus) {
      translationStatus.textContent = "Draft; translation required";
      translationStatus.className = "edited";
    }
    if (diagnostics) {
      diagnostics.textContent = "The scaffold can compile, but True is not a translation of the mathematics. Replace it before requesting review.";
    }
    invalidateCompile();
  };

  const compile = async () => {
    if (!localLean || !lean || !diagnostics) return;
    compileButton.disabled = true;
    diagnostics.textContent = "Lean is elaborating the temporary snippet...";
    diagnostics.classList.remove("success", "failure");
    if (duration) duration.textContent = "";
    try {
      const response = await fetch("../api/compile", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ code: lean.value }),
      });
      const result = await response.json();
      diagnostics.textContent = result.output || "Lean returned no diagnostics.";
      diagnostics.classList.toggle("success", Boolean(result.ok));
      diagnostics.classList.toggle("failure", !result.ok);
      if (duration) duration.textContent = Number.isFinite(result.duration_ms) ? `${result.duration_ms} ms` : "";
      lastCompiledSource = lean.value;
      lastCompileOk = Boolean(result.ok);
    } catch (error) {
      diagnostics.textContent = `The local Lean service is unavailable: ${error.message}`;
      diagnostics.classList.add("failure");
      setMode(false, false, "Run website/scripts/ide_server.py to restore local compilation.");
    } finally {
      compileButton.disabled = !localLean;
    }
  };

  const translate = async () => {
    if (!translatorAvailable || !latex || !lean || !diagnostics) return;
    translateButton.disabled = true;
    diagnostics.textContent = "The configured local agent is preparing a Lean draft...";
    try {
      const response = await fetch("../api/translate", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          latex: latex.value,
          reviewed_context: current,
        }),
      });
      const result = await response.json();
      if (!response.ok || !result.ok) throw new Error(result.output || `HTTP ${response.status}`);
      lean.value = result.code;
      if (plain && result.plain) plain.textContent = result.plain;
      if (translationStatus) {
        translationStatus.textContent = "Agent draft; review required";
        translationStatus.className = "edited";
      }
      diagnostics.textContent = "Draft received. Compilation and mathematical review are still required.";
      invalidateCompile();
      scheduleCompile();
    } catch (error) {
      diagnostics.textContent = `Translation failed: ${error.message}`;
      diagnostics.classList.add("failure");
    } finally {
      translateButton.disabled = !translatorAvailable;
    }
  };

  const scheduleCompile = () => {
    window.clearTimeout(compileTimer);
    if (localLean && autoCompile?.checked) {
      compileTimer = window.setTimeout(compile, 850);
    }
  };

  const packetId = () => {
    const base = current?.name || "quantumcomputinglib-lemma";
    return base
      .replace(/^QuantumBlockEncoding\./, "")
      .replace(/[^A-Za-z0-9]+/g, "-")
      .replace(/^-|-$/g, "")
      .toLowerCase()
      .slice(0, 96) || "quantumcomputinglib-lemma";
  };

  const makePacket = () => {
    const code = lean?.value || "";
    const accepted = lastCompileOk && lastCompiledSource === code;
    const name = contributorName?.value.trim() || "";
    const credit = contributorCredit?.value.trim() || "";
    const source = contributorSource?.value.trim() || "";
    const missing = [];
    if (!source) missing.push("provenance.source");
    if (!name) missing.push("contributor.name");
    if (!credit) missing.push("contributor.credit");
    return {
      schema_version: "1.0",
      id: packetId(),
      title: current?.plain || "QuantumComputinglib lemma proposal",
      domain: current?.chapter || "Unclassified quantum computing",
      status: accepted ? "lean-checked" : "proposed",
      mathematics: { plain: plain?.textContent || "", latex: latex?.value || "" },
      lean: {
        imports: code.split(/\r?\n/).map((line) => line.match(/^\s*import\s+([A-Za-z0-9_.]+)/)?.[1]).filter(Boolean),
        code,
        proposed_name: current?.name || "",
        dependencies: (current?.dependencies || []).map((dependency) => dependency.name),
      },
      provenance: { source, locator: "", notes: "" },
      contributor: { name, credit, contact: "" },
      verification: {
        compiler: accepted ? "local ASPBE pinned Lean toolchain" : "not run or source changed",
        accepted,
        diagnostics: accepted ? diagnostics?.textContent || "Lean accepted the snippet." : "",
      },
      license: { spdx: "MIT", agreed: false },
      created_at: new Date().toISOString(),
      draft_missing_fields: [...missing, "license.agreed"],
    };
  };

  const exportPacket = () => {
    const packet = makePacket();
    const blob = new Blob([`${JSON.stringify(packet, null, 2)}\n`], { type: "application/json" });
    const url = URL.createObjectURL(blob);
    const link = document.createElement("a");
    link.href = url;
    link.download = `${packet.id}.json`;
    document.body.append(link);
    link.click();
    link.remove();
    URL.revokeObjectURL(url);
    if (exportNote) exportNote.textContent = "Lemma packet downloaded. Complete provenance and license consent before review.";
  };

  const requestSubmission = () => {
    const packet = makePacket();
    if (!packet.contributor.name || !packet.contributor.credit || !packet.provenance.source) {
      exportNote.textContent = "Add your name, preferred credit, and mathematical source before requesting submission.";
      return;
    }
    const code = packet.lean.code.slice(0, 5500);
    const body = [
      "## Mathematical statement",
      packet.mathematics.plain,
      "",
      packet.mathematics.latex,
      "",
      "## Source and credit",
      `Source: ${packet.provenance.source}`,
      `Contributor: ${packet.contributor.name}`,
      `Preferred credit: ${packet.contributor.credit}`,
      "",
      "## Lean draft",
      "```lean",
      code,
      "```",
      "",
      `Local status: ${packet.status}`,
      packet.verification.diagnostics ? `Diagnostics: ${packet.verification.diagnostics}` : "",
      "",
      "I will confirm the MIT contribution license in the issue checklist.",
    ].filter(Boolean).join("\n");
    const params = new URLSearchParams({
      title: `[QuantumComputinglib lemma] ${packet.id}`,
      body,
    });
    window.open(`https://github.com/DakeBU/Quantum-Computing-Block-Encoding/issues/new?${params}`, "_blank", "noopener");
  };

  const checkHealth = async () => {
    try {
      const response = await fetch("../api/health", { headers: { Accept: "application/json" } });
      if (!response.ok) throw new Error(`HTTP ${response.status}`);
      const health = await response.json();
      const translator = Boolean(health.translator_available);
      setMode(true, translator, `${health.lean_version}; temporary snippets only.${translator ? " Local agent translation is enabled." : " Add --translator-command to enable agent drafts."}`);
    } catch (_error) {
      setMode(false, false, "Formula rendering and reviewed mappings remain available; code execution is disabled.");
    }
  };

  fetch(app.dataset.ideData)
    .then((response) => response.json())
    .then((data) => {
      items = data.items || [];
      select.replaceChildren(...items.map((item, index) => {
        const option = document.createElement("option");
        option.value = String(index);
        option.textContent = `${item.chapter} · ${item.name}`;
        return option;
      }));
      if (items.length) loadMapping(items[0]);
    })
    .catch((error) => {
      diagnostics.textContent = `Could not load reviewed mappings: ${error.message}`;
    });

  select?.addEventListener("change", () => loadMapping(items[Number(select.value)]));
  loadButton?.addEventListener("click", () => current && loadMapping(current));
  scaffoldButton?.addEventListener("click", safeDraftScaffold);
  translateButton?.addEventListener("click", translate);
  compileButton?.addEventListener("click", compile);
  exportButton?.addEventListener("click", exportPacket);
  submitButton?.addEventListener("click", requestSubmission);
  latex?.addEventListener("input", () => {
    renderMath();
    if (translationStatus) {
      translationStatus.textContent = "Edited; mapping review required";
      translationStatus.className = "edited";
    }
  });
  lean?.addEventListener("input", () => {
    invalidateCompile();
    scheduleCompile();
  });
  autoCompile?.addEventListener("change", scheduleCompile);
  checkHealth();
})();

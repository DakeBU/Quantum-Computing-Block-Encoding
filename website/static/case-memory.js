(() => {
  "use strict";
  const DB_NAME = "aspbe-private-cases";
  const STORE = "cases";
  const STATES = new Set(["draft", "pendingReview", "verified", "rejected"]);
  const status = () => document.getElementById("memoryStatus");

  function openDb() {
    return new Promise((resolve, reject) => {
      const request = indexedDB.open(DB_NAME, 1);
      request.onupgradeneeded = () => request.result.createObjectStore(STORE, {keyPath: "uuid"});
      request.onsuccess = () => resolve(request.result);
      request.onerror = () => reject(request.error);
    });
  }

  function transact(mode, action) {
    return openDb().then((db) => new Promise((resolve, reject) => {
      const tx = db.transaction(STORE, mode);
      const result = action(tx.objectStore(STORE));
      tx.oncomplete = () => { db.close(); resolve(result?.result); };
      tx.onerror = () => reject(tx.error);
    }));
  }

  async function canonicalHash(packet) {
    const identity = JSON.stringify({kind: packet.kind, target: packet.target.trim(), normalizer: packet.normalizer.trim(), projector: packet.projector.trim(), semanticTier: packet.semanticTier || "draft", epsilon: packet.epsilon || "unspecified"});
    const digest = await crypto.subtle.digest("SHA-256", new TextEncoder().encode(identity));
    return Array.from(new Uint8Array(digest), (byte) => byte.toString(16).padStart(2, "0")).join("");
  }

  function scrub(packet) {
    const clean = structuredClone(packet);
    if (clean.runner) {
      delete clean.runner.authorization;
      delete clean.runner.apiKey;
      clean.runner.apiKeyPresentInSession = false;
      clean.runner.apiKeyExported = false;
    }
    return clean;
  }

  async function savePrivate() {
    const packet = scrub(window.AspbeTaskBuilder.packetData());
    packet.uuid = crypto.randomUUID();
    packet.caseHash = await canonicalHash(packet);
    packet.status = "draft";
    packet.timestamp = new Date().toISOString();
    await transact("readwrite", (store) => store.put(packet));
    sessionStorage.setItem("aspbe-last-private-case", packet.uuid);
    status().textContent = "Saved privately in this browser. No credential was stored.";
  }

  async function forget() {
    const uuid = sessionStorage.getItem("aspbe-last-private-case");
    if (uuid) await transact("readwrite", (store) => store.delete(uuid));
    sessionStorage.removeItem("aspbe-last-private-case");
    status().textContent = "The current private case was forgotten.";
  }

  async function allCases() {
    return transact("readonly", (store) => store.getAll()).then((items) => items || []);
  }

  async function exportCases() {
    const payload = {schemaVersion: 1, exportedAt: new Date().toISOString(), cases: (await allCases()).map(scrub)};
    const blob = new Blob([JSON.stringify(payload, null, 2)], {type: "application/json"});
    const link = document.createElement("a");
    link.href = URL.createObjectURL(blob); link.download = "aspbe-private-cases.json"; link.click();
    URL.revokeObjectURL(link.href);
  }

  async function importCases(event) {
    const payload = JSON.parse(await event.target.files[0].text());
    for (const item of payload.cases || []) {
      if (!item.uuid || !STATES.has(item.status) || JSON.stringify(item).match(/api[_-]?key|authorization/i)) throw new Error("Import contains an invalid state or credential field");
      await transact("readwrite", (store) => store.put(scrub(item)));
    }
    status().textContent = "Private cases imported after credential-field validation.";
  }

  async function submit() {
    const packet = scrub(window.AspbeTaskBuilder.packetData());
    packet.status = "pendingReview";
    packet.caseHash = await canonicalHash(packet);
    const blob = new Blob([JSON.stringify(packet, null, 2)], {type: "application/json"});
    const link = document.createElement("a");
    link.href = URL.createObjectURL(blob); link.download = `${packet.taskName || "aspbe-case"}-review.json`; link.click();
    URL.revokeObjectURL(link.href);
    status().textContent = "Review packet created. It is not public retrieval memory until repository review and promotion pass.";
  }

  document.getElementById("savePrivateCase").addEventListener("click", () => savePrivate().catch((error) => { status().textContent = error.message; }));
  document.getElementById("forgetPrivateCase").addEventListener("click", forget);
  document.getElementById("exportPrivateCases").addEventListener("click", exportCases);
  document.getElementById("importPrivateCases").addEventListener("change", (event) => importCases(event).catch((error) => { status().textContent = error.message; }));
  document.getElementById("submitCase").addEventListener("click", submit);
})();

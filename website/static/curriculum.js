/* Progressive enhancement: the canonical chapter cards are readable without JS. */
(() => {
  "use strict";
  const root = document.querySelector("[data-curriculum-explorer]");
  if (!root) return;
  const query = root.querySelector("[data-curriculum-query]");
  const part = root.querySelector("[data-curriculum-part]");
  const status = root.querySelector("[data-curriculum-status]");
  const cards = [...root.querySelectorAll("[data-curriculum-card]")];
  const count = root.querySelector("[data-curriculum-count]");
  const normalize = value => value.normalize("NFKC").toLocaleLowerCase();
  function update() {
    const terms = normalize(query.value).trim().split(/\s+/).filter(Boolean);
    let visible = 0;
    for (const card of cards) {
      const text = normalize(card.dataset.search);
      card.hidden = Boolean((part.value && card.dataset.part !== part.value) ||
        (status.value && card.dataset.status !== status.value) ||
        !terms.every(term => text.includes(term)));
      if (!card.hidden) visible++;
    }
    count.textContent = `${visible} of ${cards.length} chapter entries. Filters do not change proof status.`;
    root.querySelector("[data-curriculum-empty]").hidden = visible !== 0;
  }
  query.addEventListener("input", update);
  part.addEventListener("change", update);
  status.addEventListener("change", update);
  root.querySelector("[data-curriculum-reset]").addEventListener("click", () => {
    query.value = part.value = status.value = "";
    update();
    query.focus();
  });
  root.querySelector("[data-curriculum-controls]").hidden = false;
  update();
})();

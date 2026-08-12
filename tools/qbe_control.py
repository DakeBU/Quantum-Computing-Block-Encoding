#!/usr/bin/env python3
"""Deterministic control policy for long-running ABEIS agent cycles.

The orchestration layer must decide whether useful work is executable before
it spends model tokens.  This module intentionally has no repository-specific
I/O so its state reduction and stop rules can be regression tested.
"""

from __future__ import annotations

import hashlib
import json
import re
from dataclasses import asdict, dataclass
from decimal import Decimal, InvalidOperation
from pathlib import Path
from typing import Iterable, Mapping, Sequence

try:
    from qbe_runtime import update_json_locked
except ModuleNotFoundError:
    from tools.qbe_runtime import update_json_locked


CONTROL_VERSION = 6
CONTROL_STOP_EXIT_CODE = 75
MAX_CAPACITY_LEVEL = 3
POLICY_TASK_KINDS = {"statePreparation", "operatorBlockEncoding"}
STRUCTURAL_PREREQUISITE_ERRORS = {
    "shape_or_register_gap",
    "source_translation_gap",
    "symbolic_bridge_gap",
}

CLOSED_MARKERS = (
    "formalized",
    "closed",
    "retired",
    "discharged",
    "proved",
    "compiled feeder",
    "compiled support",
    "compiled bridge",
    "compiled conditional",
)
EXTERNAL_MARKERS = (
    "external_contract_gap",
    "external contract",
    "external-contract",
    "blocked external",
    "contract-only",
    "paper-cited",
    "missing import",
    "cited-result",
    "cited result",
)
BLOCKED_MARKERS = (
    "blocked",
    "suspended",
    "stale",
    "invalid",
    "not tactic-ready",
    "not tactic ready",
    "no-edit",
    "no edit",
    "read-only",
    "read only",
    "no lean statement",
)
READY_MARKERS = (
    "active next",
    "ready-for-lean",
    "ready for lean",
    "tactic-ready",
    "tactic ready",
    "next internal",
    "open active mathematical leaf",
    "active mathematical leaf",
    "active lower",
)
INVALID_TARGET_MARKERS = (
    "external",
    "unknown",
    "upper must",
    "middle must",
    "to be named",
    "contract-only",
    "none",
    "n/a",
)


def _normalized(value: object) -> str:
    return re.sub(r"\s+", " ", str(value or "")).strip()


def _lower(value: object) -> str:
    return _normalized(value).lower()


def _contains_any(text: str, markers: Iterable[str]) -> bool:
    lowered = text.lower()
    return any(marker in lowered for marker in markers)


def _field(text: str, name: str) -> str:
    match = re.search(
        rf"(?:^|;\s*){re.escape(name)}\s*:\s*(.*?)(?=;\s*[A-Za-z][A-Za-z -]*\s*:|$)",
        text,
        flags=re.I,
    )
    return _normalized(match.group(1)) if match else ""


def _leaf_id(text: str) -> str:
    head = text.split(":", 1)[0].strip().strip("`| ")
    return head or hashlib.sha256(text.encode("utf-8")).hexdigest()[:12]


def _has_concrete_lean_target(target: str) -> bool:
    lowered = _lower(target)
    if not lowered or _contains_any(lowered, INVALID_TARGET_MARKERS):
        return False
    return bool(re.search(r"[A-Za-z_][A-Za-z0-9_'.]*", target))


def _looks_approximate(leaf: "LeafState") -> bool:
    text = _lower(f"{leaf.leaf_id} {leaf.raw} {leaf.lean_target} {leaf.status}")
    return bool(re.search(r"\b(approx|approximate|epsilon|tolerance)\b", text))


@dataclass(frozen=True)
class LeafState:
    leaf_id: str
    raw: str
    lean_target: str
    status: str
    dependency_class: str
    source: str
    closed: bool
    external: bool
    blocked: bool
    ready_for_lean: bool
    diagnostic_ready: bool


def parse_leaf_state(raw: str, source: str) -> LeafState:
    text = _normalized(raw)
    lowered = text.lower()
    lean_target = _field(text, "Lean")
    if not lean_target:
        match = re.search(r":\s*Lean\s+(.*?)(?=;\s*class\b|;\s*status\b|$)", text, flags=re.I)
        lean_target = _normalized(match.group(1)) if match else ""
    status = _field(text, "status")
    dependency_class = _field(text, "class")
    status_scope = f"{status} {dependency_class}"
    closed = _contains_any(status_scope, CLOSED_MARKERS) and not _contains_any(
        status_scope, ("open", "active", "blocked", "obligation")
    )
    external = _contains_any(f"{text} {dependency_class}", EXTERNAL_MARKERS)
    blocked = (
        _contains_any(status_scope, BLOCKED_MARKERS)
        or "no lean statement" in lowered
        or external
    )
    explicit_ready = _contains_any(status, READY_MARKERS)
    if source == "frontier" and re.search(r"\b(active|next|ready)\b", status.lower()):
        explicit_ready = True
    ready_for_lean = (
        not closed
        and not blocked
        and explicit_ready
        and _has_concrete_lean_target(lean_target)
    )
    diagnostic_ready = ready_for_lean and _contains_any(
        lowered,
        (
            "diagnostic",
            "necessary-condition",
            "necessary condition",
            "finite matrix",
            "path support",
            "support check",
            "counterexample",
        ),
    )
    return LeafState(
        leaf_id=_leaf_id(text),
        raw=text,
        lean_target=lean_target,
        status=status,
        dependency_class=dependency_class,
        source=source,
        closed=closed,
        external=external,
        blocked=blocked,
        ready_for_lean=ready_for_lean,
        diagnostic_ready=diagnostic_ready,
    )


def classify_leaves(
    frontier_rows: Sequence[str], obligation_rows: Sequence[str]
) -> list[LeafState]:
    """Reduce current frontier/obligation rows to one state per leaf id."""

    reduced: dict[str, LeafState] = {}
    for source, rows in (("obligation", obligation_rows), ("frontier", frontier_rows)):
        for raw in rows:
            leaf = parse_leaf_state(raw, source)
            previous = reduced.get(leaf.leaf_id)
            if previous is None or source == "frontier":
                reduced[leaf.leaf_id] = leaf
    return list(reduced.values())


def latest_obligation_rows(text: str, limit: int = 20) -> list[str]:
    """Read the canonical active obligation table and omit completed rows."""

    if not text:
        return []
    active_sections = [
        (start, section)
        for start, heading, section in _markdown_sections(text)
        if "current obligation" in heading.lower() and "[active]" in heading.lower()
    ]
    if active_sections:
        lines = max(active_sections, key=lambda item: item[0])[1].splitlines()
        header_index = -1
        headers: list[str] = []
        for index, raw in enumerate(lines):
            if not raw.strip().startswith("|"):
                continue
            cells = [cell.strip() for cell in raw.strip().strip("|").split("|")]
            lowered = [cell.lower() for cell in cells]
            if lowered and lowered[0] in {"node", "leaf", "obligation"} and any(
                "status" in cell for cell in lowered
            ):
                header_index = index
                headers = lowered
                break
        if header_index >= 0:
            status_index = next(i for i, value in enumerate(headers) if "status" in value)
            lean_index = next((i for i, value in enumerate(headers) if "lean" in value), -1)
            class_index = next(
                (i for i, value in enumerate(headers) if "class" in value or "dependency" in value),
                -1,
            )
            interface_index = next(
                (i for i, value in enumerate(headers) if "interface" in value or "statement" in value),
                -1,
            )
            rows: list[str] = []
            for raw in lines[header_index + 2 :]:
                if not raw.strip().startswith("|"):
                    if rows:
                        break
                    continue
                cells = [cell.strip() for cell in raw.strip().strip("|").split("|")]
                if len(cells) <= status_index or not cells[0] or cells[0] == "---":
                    continue
                obligation = cells[0].strip("`")
                lean_target = cells[lean_index] if 0 <= lean_index < len(cells) else ""
                dependency_class = cells[class_index] if 0 <= class_index < len(cells) else ""
                interface = cells[interface_index] if 0 <= interface_index < len(cells) else ""
                leaf = parse_leaf_state(
                    f"{obligation}: {_normalized(interface)}; Lean: {_normalized(lean_target)}; "
                    f"class: {_normalized(dependency_class)}; status: {_normalized(cells[status_index])}",
                    "obligation",
                )
                if not leaf.closed:
                    rows.append(leaf.raw)
                if len(rows) >= limit:
                    break
            return rows
    matches = list(
        re.finditer(
            r"(?mi)^\|\s*Obligation\s*\|\s*Lean declaration or target\s*\|"
            r"\s*Dependency class\s*\|\s*Status\s*\|\s*$\n"
            r"^\|[-| :]+\|\s*$\n(?P<body>(?:^\|[^\n]*\|\s*(?:\n|$))+)",
            text,
        )
    )
    if matches:
        lines = matches[-1].group("body").splitlines()
    else:
        start = text.lower().rfind("current obligation state:")
        if start < 0:
            return []
        lines = text[start:].splitlines()[1:]
    rows: list[str] = []
    for raw in lines:
        if not raw.strip().startswith("|"):
            if rows:
                break
            continue
        cells = [cell.strip() for cell in raw.strip().strip("|").split("|")]
        if len(cells) < 4 or cells[0].lower() in {"obligation", "---"}:
            continue
        obligation, lean_target, dependency_class, status = cells[:4]
        leaf = parse_leaf_state(
            f"{obligation}: Lean {lean_target}; class: {dependency_class}; status: {status}",
            "obligation",
        )
        if leaf.closed:
            continue
        rows.append(leaf.raw)
        if len(rows) >= limit:
            break
    return rows


def _markdown_sections(text: str) -> list[tuple[int, str, str]]:
    headings = list(re.finditer(r"(?m)^##\s+(.+?)\s*$", text))
    sections: list[tuple[int, str, str]] = []
    for index, heading in enumerate(headings):
        end = headings[index + 1].start() if index + 1 < len(headings) else len(text)
        sections.append((heading.start(), heading.group(1), text[heading.start():end]))
    return sections


def latest_frontier_rows(text: str, limit: int = 8) -> list[str]:
    """Read the highest-priority latest proof-DAG frontier generically."""

    candidates = []
    for start, heading, section in _markdown_sections(text):
        lowered = heading.lower()
        is_frontier = "proof-dag frontier" in lowered or "proof dag frontier" in lowered
        is_translation_dag = (
            "proof" in lowered and "translation" in lowered and "dag" in lowered
        )
        if not is_frontier and not is_translation_dag:
            continue
        priority = 2 if "current" in lowered else 1 if "updated" in lowered else 0
        candidates.append((priority, start, section))
    if not candidates:
        return []
    section = max(candidates, key=lambda item: (item[0], item[1]))[2]
    lines = section.splitlines()
    header_index = -1
    headers: list[str] = []
    for index, raw in enumerate(lines):
        if not raw.strip().startswith("|"):
            continue
        cells = [cell.strip() for cell in raw.strip().strip("|").split("|")]
        if cells and cells[0].lower() in {"node", "leaf", "obligation"}:
            header_index = index
            headers = [cell.lower() for cell in cells]
            break
    if header_index < 0:
        return []
    status_index = next((i for i, value in enumerate(headers) if "status" in value), len(headers) - 1)
    lean_index = next((i for i, value in enumerate(headers) if "lean" in value), -1)
    interface_index = next(
        (i for i, value in enumerate(headers) if "interface" in value or "statement" in value),
        1 if len(headers) > 1 else 0,
    )
    rows: list[str] = []
    for raw in lines[header_index + 2 :]:
        if not raw.strip().startswith("|"):
            if rows:
                break
            continue
        cells = [cell.strip() for cell in raw.strip().strip("|").split("|")]
        if len(cells) <= status_index or not cells[0] or cells[0] == "---":
            continue
        node = cells[0].strip("`")
        status = cells[status_index]
        lean_target = cells[lean_index] if 0 <= lean_index < len(cells) else ""
        interface = cells[interface_index] if interface_index < len(cells) else ""
        leaf = parse_leaf_state(
            f"{node}: {_normalized(interface)}; status: {_normalized(status)}; Lean: {_normalized(lean_target)}",
            "frontier",
        )
        if leaf.closed:
            continue
        rows.append(leaf.raw)
        if len(rows) >= limit:
            break
    return rows


def reduce_latest_feedback(records: Sequence[Mapping[str, object]]) -> list[dict[str, object]]:
    """Keep newest leaf state plus independent privileged policy packets.

    Callers pass newest-first records.  An old failure must never override a
    newer success for the same leaf.  A later middle/lower status packet must
    not erase an upper/reviewer capacity or tolerance decision for that leaf.
    """

    newest: dict[str, dict[str, object]] = {}
    anonymous = 0
    for record in records:
        leaf = _normalized(record.get("leaf", ""))
        privileged_policy = _lower(record.get("role", "")) in {"upper", "reviewer"} and any(
            _normalized(record.get(field, ""))
            for field in (
                "capacity_decision",
                "tolerance_decision",
                "search_decision",
            )
        )
        candidate_id = _normalized(record.get("candidate_id", ""))
        key = f"__candidate_{candidate_id}_{_lower(record.get('role', ''))}" if candidate_id else leaf
        if privileged_policy:
            packet_id = _normalized(record.get("trial_id", record.get("timestamp", "")))
            key = f"__policy_{packet_id or leaf or anonymous}"
        if not key:
            key = f"__anonymous_{anonymous}"
            anonymous += 1
        if key not in newest:
            newest[key] = dict(record)
    return list(newest.values())


def content_digest(parts: Sequence[object]) -> str:
    payload = json.dumps(list(parts), ensure_ascii=True, sort_keys=True, default=str)
    return hashlib.sha256(payload.encode("utf-8")).hexdigest()


def _epsilon_text(value: Decimal) -> str:
    if value == 0:
        return "0"
    exponent = value.normalize().adjusted()
    coefficient = value.scaleb(-exponent).normalize()
    coefficient_text = format(coefficient, "f").rstrip("0").rstrip(".")
    return f"{coefficient_text}e{exponent}"


def _same_epsilon(left: str, right: str) -> bool:
    try:
        return Decimal(left) == Decimal(right)
    except InvalidOperation:
        return _lower(left) == _lower(right)


def infer_epsilon_ladder(task_text: str, max_rungs: int = 7) -> tuple[str, ...]:
    """Infer a gradual, decade-by-decade tolerance ladder from a task contract."""

    values: list[Decimal] = []
    ladder_matches = re.findall(
        r"(?:epsilon|tolerance)[^\n]{0,80}(?:ladder|levels?)"
        r"(?:[^\n]*?\[([^\]]+)\]|\s*:\s*([^\n]+))",
        task_text,
        flags=re.I,
    )
    for bracket_body, line_body in ladder_matches:
        body = bracket_body or line_body
        for raw in re.findall(r"(?<![A-Za-z0-9_])(?:\d+(?:\.\d*)?|\.\d+)[eE][+-]?\d+", body):
            try:
                value = Decimal(raw)
            except InvalidOperation:
                continue
            if value > 0:
                values.append(value)
    requested_matches = re.findall(
        r"(?:requested\s+(?:epsilon|tolerance)|(?:epsilon|tolerance)\s*=)"
        r"[^0-9]{0,20}((?:\d+(?:\.\d*)?|\.\d+)[eE][+-]?\d+)",
        task_text,
        flags=re.I,
    )
    for raw in requested_matches:
        try:
            value = Decimal(raw)
        except InvalidOperation:
            continue
        if value > 0:
            values.append(value)
    if not values:
        return ()

    ordered = sorted(set(values))
    requested = ordered[0]
    explicit_limit = ordered[-1]
    if explicit_limit == requested:
        explicit_limit = requested * (Decimal(10) ** 4)
    ladder: list[Decimal] = []
    current = requested
    while current <= explicit_limit and len(ladder) < max(1, max_rungs):
        ladder.append(current)
        current *= 10
    for value in ordered:
        if value not in ladder and len(ladder) < max(1, max_rungs):
            ladder.append(value)
    return tuple(_epsilon_text(value) for value in sorted(set(ladder)))


def infer_route_lock(task_text: str) -> tuple[tuple[str, ...], tuple[str, ...]]:
    """Read optional task-level route-prefix allow/deny directives.

    The directives are intentionally explicit.  Natural-language hints remain
    useful context, while a `Route lock:` line is an executable scheduling
    constraint that lower agents cannot override through prose refreshes.
    """

    def values(label: str) -> tuple[str, ...]:
        match = re.search(rf"(?im)^\s*{re.escape(label)}\s*:\s*(.+)$", task_text)
        if not match:
            return ()
        return tuple(
            value.strip().strip("`")
            for value in re.split(r"[,;]", match.group(1))
            if value.strip().strip("`")
        )

    return values("Route lock"), values("Forbidden leaf prefixes")


def infer_acceptance_anchors(task_text: str) -> tuple[str, ...]:
    """Read the explicit Lean theorems that certify the root task.

    Root acceptance is deliberately separate from the append-only proof-DAG.
    A stale open leaf must not keep scheduling agents after every declared root
    theorem has compiled, and a prose claim such as "certificate exists" must
    not count as acceptance.
    """

    match = re.search(
        r"(?im)^\s*Lean acceptance anchors\s*:\s*(.+)$", task_text
    )
    if not match:
        return ()
    raw = match.group(1)
    quoted = re.findall(r"`([^`]+)`", raw)
    values = quoted or re.split(r"[,;]", raw)
    return tuple(dict.fromkeys(value.strip() for value in values if value.strip()))


@dataclass(frozen=True)
class ExecutableAcceptance:
    command: str
    artifacts: tuple[str, ...]


def infer_executable_acceptance(task_text: str) -> ExecutableAcceptance:
    """Read the deterministic post-Lean acceptance command and its outputs."""

    command_match = re.search(
        r"(?im)^\s*Executable acceptance command\s*:\s*(.+)$", task_text
    )
    artifact_match = re.search(
        r"(?im)^\s*Executable acceptance artifacts\s*:\s*(.+)$", task_text
    )
    command = command_match.group(1).strip().strip("`") if command_match else ""
    artifacts: tuple[str, ...] = ()
    if artifact_match:
        raw = artifact_match.group(1)
        quoted = re.findall(r"`([^`]+)`", raw)
        values = quoted or re.split(r"[,;]", raw)
        artifacts = tuple(
            dict.fromkeys(value.strip().strip("`") for value in values if value.strip().strip("`"))
        )
    return ExecutableAcceptance(command=command, artifacts=artifacts)


def infer_population_gate(task_text: str) -> bool:
    """Return whether exploratory work requires a typed population decision."""

    match = re.search(r"(?im)^\s*Population gate\s*:\s*(.+)$", task_text)
    return bool(
        match
        and _lower(match.group(1)).strip("`") in {"required", "on", "true", "yes"}
    )


@dataclass(frozen=True)
class PopulationState:
    active_candidate_ids: tuple[str, ...]
    selected_candidate_ids: tuple[str, ...]
    direction: str
    digest: str
    invalid_packets: tuple[str, ...]


def summarize_candidate_population(
    feedback: Sequence[Mapping[str, object]],
) -> PopulationState:
    """Reduce typed middle/reviewer packets into an auditable population state.

    Middle owns proposal, retention, mutation, crossover, and retirement.  An
    upper or reviewer packet may select only a candidate that middle currently
    keeps active.  This prevents free-form prose from silently authorizing more
    lower-agent work.
    """

    middle_actions = {"propose", "retain", "mutate", "crossover", "retire", "reject"}
    active_actions = {"propose", "retain", "mutate", "crossover"}
    latest_middle: dict[str, dict[str, object]] = {}
    selectors: list[dict[str, object]] = []
    invalid: list[str] = []
    for row in reversed(list(feedback)):
        candidate_id = _normalized(row.get("candidate_id", ""))
        action = _lower(row.get("population_action", ""))
        role = _lower(row.get("role", ""))
        if not candidate_id and not action:
            continue
        packet = _normalized(row.get("trial_id", row.get("timestamp", "packet"))) or "packet"
        if not candidate_id or not action:
            invalid.append(f"{packet}: candidate_id and population_action are both required")
            continue
        parents_raw = row.get("parent_ids", "")
        parents = (
            [_normalized(value) for value in parents_raw]
            if isinstance(parents_raw, (list, tuple))
            else [_normalized(value) for value in re.split(r"[,;\s]+", str(parents_raw))]
        )
        parents = [value for value in parents if value]
        evidence = _normalized(row.get("fitness_evidence", row.get("fitness", "")))
        if role == "middle":
            if action not in middle_actions:
                invalid.append(f"{packet}: middle cannot apply population action {action}")
                continue
            if action == "mutate" and len(parents) < 1:
                invalid.append(f"{packet}: mutation requires one parent")
                continue
            if action == "crossover" and len(parents) < 2:
                invalid.append(f"{packet}: crossover requires two parents")
                continue
            if action in active_actions and not evidence:
                invalid.append(f"{packet}: active candidate requires fitness_evidence")
                continue
            latest_middle[candidate_id] = {
                "candidate_id": candidate_id,
                "candidate_family": _normalized(row.get("candidate_family", "")),
                "action": action,
                "parent_ids": parents,
                "fitness_evidence": evidence,
                "route": _normalized(row.get("next_route", row.get("route", ""))),
            }
        elif role in {"upper", "reviewer"} and action == "select":
            selectors.append(
                {
                    "candidate_id": candidate_id,
                    "role": role,
                    "reason": evidence or _normalized(row.get("selection_reason", "")),
                }
            )
        elif role in {"upper", "reviewer"} and action == "reject":
            if not evidence:
                invalid.append(f"{packet}: rejected candidate requires fitness_evidence")
        else:
            invalid.append(f"{packet}: role {role or 'unknown'} cannot apply population action {action}")

    active = tuple(
        sorted(
            candidate_id
            for candidate_id, row in latest_middle.items()
            if row["action"] in active_actions
        )
    )
    selected = tuple(
        dict.fromkeys(
            row["candidate_id"]
            for row in reversed(selectors)
            if row["candidate_id"] in active
        )
    )
    direction = selected[0] if selected else ""
    payload = {
        "active": [latest_middle[candidate_id] for candidate_id in active],
        "selected": list(selected),
        "direction": direction,
    }
    return PopulationState(
        active_candidate_ids=active,
        selected_candidate_ids=selected,
        direction=direction,
        digest=content_digest([payload]) if active or selected else "",
        invalid_packets=tuple(invalid),
    )


@dataclass(frozen=True)
class PolicyRequest:
    capacity_authorizations: tuple[str, ...]
    advance_tolerance: bool
    requested_epsilon: str
    digest: str


def _feedback_policy_request(
    feedback: Sequence[Mapping[str, object]], leaf_signature: str, evidence_digest: str
) -> PolicyRequest:
    allowed = {"increase_upper", "increase_middle", "increase_lower", "increase_exploration"}
    selected: list[str] = []
    advance_tolerance = False
    requested_epsilon = ""
    signed_rows: list[dict[str, object]] = []
    for row in feedback:
        if _lower(row.get("role", "")) not in {"upper", "reviewer"}:
            continue
        row_signature = _normalized(row.get("leaf_signature", ""))
        row_evidence = _normalized(row.get("evidence_digest", ""))
        if row_signature != leaf_signature or row_evidence != evidence_digest:
            continue
        raw = row.get("capacity_decision", "")
        values = raw if isinstance(raw, list) else re.split(r"[,;\s]+", str(raw))
        row_selected: list[str] = []
        for value in values:
            value = _normalized(value)
            if value in allowed and value not in selected:
                selected.append(value)
            if value in allowed and value not in row_selected:
                row_selected.append(value)
        transition = _lower(
            row.get("tolerance_decision", row.get("search_decision", ""))
        )
        row_advance = transition in {
            "open_approximate",
            "advance_epsilon",
            "relax_epsilon",
            "increase_exploration",
        } or "increase_exploration" in row_selected
        advance_tolerance = advance_tolerance or row_advance
        row_requested = _normalized(
            row.get("epsilon_next", row.get("requested_epsilon", ""))
        )
        if row_requested:
            requested_epsilon = row_requested
        if row_selected or row_advance:
            signed_rows.append(
                {
                    "trial_id": _normalized(row.get("trial_id", row.get("timestamp", ""))),
                    "role": _lower(row.get("role", "")),
                    "capacity": sorted(row_selected),
                    "advance_tolerance": row_advance,
                    "requested_epsilon": row_requested,
                }
            )
    digest = content_digest(sorted(signed_rows, key=lambda row: json.dumps(row, sort_keys=True))) if signed_rows else ""
    return PolicyRequest(tuple(selected), advance_tolerance, requested_epsilon, digest)


@dataclass(frozen=True)
class CycleDecision:
    task_id: str
    cycle: int
    mode: str
    status: str
    reason: str
    leaf_signature: str
    evidence_digest: str
    ready_leaf_ids: tuple[str, ...]
    external_leaf_ids: tuple[str, ...]
    unresolved_leaf_ids: tuple[str, ...]
    route_rejected_leaf_ids: tuple[str, ...]
    prompt_plan: tuple[str, ...]
    capacity_authorizations: tuple[str, ...]
    unchanged_cycles: int
    external_gap_cycles: int
    stop: bool
    task_kind: str = ""
    upper_capacity_level: int = 0
    middle_capacity_level: int = 0
    lower_capacity_level: int = 0
    search_phase: str = "exact"
    epsilon_ladder: tuple[str, ...] = ()
    epsilon_index: int = -1
    active_epsilon: str = "0"
    effective_epsilon: str = "0"
    auto_retired_leaf_ids: tuple[str, ...] = ()
    certified_root_anchors: tuple[str, ...] = ()
    policy_decision_digest: str = ""
    policy_transition_applied: bool = False
    policy_rejections: tuple[str, ...] = ()
    lean_acceptance_complete: bool = False
    executable_acceptance_required: bool = False
    executable_acceptance_complete: bool = False
    executable_acceptance_command: str = ""
    executable_acceptance_artifacts: tuple[str, ...] = ()
    population_gate_required: bool = False
    population_digest: str = ""
    population_active_candidate_ids: tuple[str, ...] = ()
    population_selected_candidate_ids: tuple[str, ...] = ()
    population_direction: str = ""
    population_invalid_packets: tuple[str, ...] = ()
    prerequisite_leaf_ids: tuple[str, ...] = ()
    prerequisite_error_classes: tuple[str, ...] = ()
    evaluation_mode: str = "full-abeis"

    def to_dict(self) -> dict[str, object]:
        return asdict(self)


def decide_cycle(
    *,
    task_id: str,
    cycle: int,
    frontier_rows: Sequence[str],
    obligation_rows: Sequence[str],
    feedback: Sequence[Mapping[str, object]],
    evidence_digest: str,
    previous_state: Mapping[str, object] | None = None,
    max_no_progress_cycles: int = 2,
    max_external_gap_cycles: int = 1,
    task_kind: str = "",
    epsilon_ladder: Sequence[str] = (),
    exact_stall_cycles: int = 2,
    max_capacity_level: int = MAX_CAPACITY_LEVEL,
    allowed_leaf_prefixes: Sequence[str] = (),
    forbidden_leaf_prefixes: Sequence[str] = (),
    verified_closed_leaf_ids: Sequence[str] = (),
    verified_root_anchors: Sequence[str] = (),
    executable_acceptance_required: bool = False,
    executable_acceptance_complete: bool = False,
    executable_acceptance_command: str = "",
    executable_acceptance_artifacts: Sequence[str] = (),
    lean_acceptance_required: bool = False,
    population_gate_required: bool = False,
    evaluation_mode: str = "full-abeis",
) -> CycleDecision:
    normalized_evaluation_mode = _lower(evaluation_mode).replace("_", "-")
    if normalized_evaluation_mode not in {
        "task-only", "lad", "isolated-abeis", "full-abeis"
    }:
        normalized_evaluation_mode = "full-abeis"
    benchmark_limited = normalized_evaluation_mode in {"task-only", "lad"}
    if benchmark_limited:
        population_gate_required = False
    leaves = classify_leaves(frontier_rows, obligation_rows)
    verified_closed = {_lower(value) for value in verified_closed_leaf_ids if _lower(value)}
    auto_retired = [
        leaf for leaf in leaves if not leaf.closed and _lower(leaf.leaf_id) in verified_closed
    ]
    pending = [
        leaf
        for leaf in leaves
        if not leaf.closed and _lower(leaf.leaf_id) not in verified_closed
    ]
    allowed_prefixes = tuple(_lower(value) for value in allowed_leaf_prefixes if _lower(value))
    forbidden_prefixes = tuple(
        _lower(value) for value in forbidden_leaf_prefixes if _lower(value)
    )

    def route_allowed(leaf: LeafState) -> bool:
        leaf_id = leaf.leaf_id.lower()
        if any(leaf_id.startswith(prefix) for prefix in forbidden_prefixes):
            return False
        return not allowed_prefixes or any(
            leaf_id.startswith(prefix) for prefix in allowed_prefixes
        )

    route_rejected = [leaf for leaf in pending if not route_allowed(leaf)]
    eligible = [leaf for leaf in pending if route_allowed(leaf)]
    eligible_ids = {_lower(leaf.leaf_id) for leaf in eligible}
    ready = [leaf for leaf in eligible if leaf.ready_for_lean]
    external = [leaf for leaf in eligible if leaf.external]
    unresolved = [
        leaf for leaf in eligible if not leaf.ready_for_lean and not leaf.external
    ]
    leaf_payload = [
        {
            "id": leaf.leaf_id,
            "target": leaf.lean_target,
            "status": leaf.status,
            "class": leaf.dependency_class,
            "ready": leaf.ready_for_lean,
            "external": leaf.external,
            "blocked": leaf.blocked,
            "route_allowed": route_allowed(leaf),
        }
        for leaf in sorted(pending, key=lambda item: item.leaf_id)
    ]
    prerequisite_feedback = [
        row
        for row in feedback
        if _lower(row.get("leaf", "")) in eligible_ids
        and (
            not ready
            or _lower(row.get("leaf", ""))
            in {_lower(leaf.leaf_id) for leaf in ready}
        )
        and _lower(row.get("error_class", "")) in STRUCTURAL_PREREQUISITE_ERRORS
        and row.get("closed_theorem_ok") is not True
    ]
    prerequisite_leaf_ids = tuple(
        dict.fromkeys(
            _normalized(row.get("leaf", ""))
            for row in prerequisite_feedback
            if _normalized(row.get("leaf", ""))
        )
    )
    prerequisite_error_classes = tuple(
        sorted(
            {
                _lower(row.get("error_class", ""))
                for row in prerequisite_feedback
                if _lower(row.get("error_class", ""))
            }
        )
    )
    population = summarize_candidate_population(feedback)
    leaf_signature = content_digest(
        [leaf_payload, evidence_digest, population.digest if population_gate_required else ""]
    )
    previous = dict(previous_state or {})
    same_signature = (
        previous.get("leaf_signature") == leaf_signature
        and bool(previous.get("execution_started", False))
    )
    unchanged_cycles = int(previous.get("unchanged_cycles", 0)) + 1 if same_signature else 0
    external_gap_cycles = (
        int(previous.get("external_gap_cycles", 0)) + 1
        if same_signature and external and not ready
        else 0
    )
    request = _feedback_policy_request(feedback, leaf_signature, evidence_digest)
    if benchmark_limited:
        request = PolicyRequest((), False, "", "")
    previous_signature = _normalized(previous.get("leaf_signature", ""))
    previous_evidence = _normalized(previous.get("evidence_digest", ""))
    if (
        not request.digest
        and previous_signature
        and previous_signature != leaf_signature
        and previous_evidence == evidence_digest
        and bool(previous.get("execution_started", False))
    ):
        # A privileged policy decision may survive one prose-frontier refresh.
        # Lean evidence must be unchanged, and the next persisted state replaces
        # the old signature, so older packets cannot continue propagating.
        request = _feedback_policy_request(feedback, previous_signature, evidence_digest)
    authorizations = request.capacity_authorizations
    previous_policy_digest = _normalized(previous.get("policy_decision_digest", ""))
    new_policy_request = bool(request.digest and request.digest != previous_policy_digest)
    capacity_limit = max(0, max_capacity_level)
    upper_level = min(capacity_limit, max(0, int(previous.get("upper_capacity_level", 0) or 0)))
    middle_level = min(capacity_limit, max(0, int(previous.get("middle_capacity_level", 0) or 0)))
    lower_level = min(capacity_limit, max(0, int(previous.get("lower_capacity_level", 0) or 0)))
    policy_applied = False
    policy_rejections: list[str] = []
    if new_policy_request and prerequisite_feedback:
        policy_rejections.append(
            "Capacity and tolerance changes are disabled while a structural "
            "prerequisite gap is unresolved."
        )

    ladder = tuple(_normalized(value) for value in epsilon_ladder if _normalized(value))
    previous_index_raw = previous.get("epsilon_index", -1)
    previous_index = int(previous_index_raw if previous_index_raw is not None else -1)
    epsilon_index = min(max(previous_index, -1), len(ladder) - 1) if ladder else -1
    requested_epsilon_index = epsilon_index
    if new_policy_request and request.advance_tolerance:
        if task_kind not in POLICY_TASK_KINDS:
            policy_rejections.append("Tolerance changes are disabled for this task kind.")
        elif not ladder:
            policy_rejections.append("No task-declared tolerance ladder is available.")
        elif (
            epsilon_index < 0
            and unchanged_cycles < max(1, exact_stall_cycles)
            and not any(_looks_approximate(leaf) for leaf in ready)
            and not (external and not ready)
        ):
            policy_rejections.append(
                "Exact search has not consumed the configured stall budget."
            )
        elif epsilon_index >= 0 and unchanged_cycles < 1:
            policy_rejections.append(
                "The current approximate rung has not consumed one unchanged cycle."
            )
        elif epsilon_index + 1 >= len(ladder):
            policy_rejections.append("The task-declared tolerance ladder is exhausted.")
        else:
            next_epsilon = ladder[epsilon_index + 1]
            if request.requested_epsilon and not _same_epsilon(
                request.requested_epsilon, next_epsilon
            ):
                policy_rejections.append(
                    f"Requested epsilon {request.requested_epsilon} skips the next rung {next_epsilon}."
                )
            else:
                requested_epsilon_index += 1

    # A signed policy packet is atomic: a rejected tolerance transition cannot
    # partially increase capacity or consume the replay-protection digest.
    if new_policy_request and not policy_rejections:
        previous_levels = (upper_level, middle_level, lower_level)
        if "increase_upper" in authorizations and upper_level < capacity_limit:
            upper_level += 1
        if "increase_middle" in authorizations and middle_level < capacity_limit:
            middle_level += 1
        if "increase_lower" in authorizations and lower_level < capacity_limit:
            lower_level += 1
        epsilon_index = requested_epsilon_index
        policy_applied = previous_levels != (upper_level, middle_level, lower_level) or (
            epsilon_index != previous_index
        )

    if policy_applied:
        unchanged_cycles = 0
        external_gap_cycles = 0
    active_epsilon = ladder[epsilon_index] if epsilon_index >= 0 else "0"
    search_phase = (
        "exact"
        if epsilon_index < 0
        else "approximate_requested"
        if epsilon_index == 0
        else "approximate_relaxed"
    )
    if verified_root_anchors and executable_acceptance_required and not executable_acceptance_complete:
        search_phase = "post_lean_export"
    elif prerequisite_feedback or (external and not ready):
        search_phase = "dependency"
    effective_epsilon = "n/a" if search_phase == "dependency" else active_epsilon
    policy_digest = (
        request.digest
        if new_policy_request and not policy_rejections
        else previous_policy_digest
    )

    def make_decision(
        mode: str,
        status: str,
        reason: str,
        ready_ids: tuple[str, ...],
        external_ids: tuple[str, ...],
        unresolved_ids: tuple[str, ...],
        prompt_plan: tuple[str, ...],
        stop: bool,
    ) -> CycleDecision:
        return CycleDecision(
            task_id=task_id,
            cycle=cycle,
            mode=mode,
            status=status,
            reason=reason,
            leaf_signature=leaf_signature,
            evidence_digest=evidence_digest,
            ready_leaf_ids=ready_ids,
            external_leaf_ids=external_ids,
            unresolved_leaf_ids=unresolved_ids,
            route_rejected_leaf_ids=tuple(leaf.leaf_id for leaf in route_rejected),
            prompt_plan=prompt_plan,
            capacity_authorizations=authorizations,
            unchanged_cycles=unchanged_cycles,
            external_gap_cycles=external_gap_cycles,
            stop=stop,
            task_kind=task_kind,
            upper_capacity_level=upper_level,
            middle_capacity_level=middle_level,
            lower_capacity_level=lower_level,
            search_phase=search_phase,
            epsilon_ladder=ladder,
            epsilon_index=epsilon_index,
            active_epsilon=active_epsilon,
            effective_epsilon=effective_epsilon,
            auto_retired_leaf_ids=tuple(leaf.leaf_id for leaf in auto_retired),
            certified_root_anchors=tuple(verified_root_anchors),
            policy_decision_digest=policy_digest,
            policy_transition_applied=policy_applied,
            policy_rejections=tuple(policy_rejections),
            lean_acceptance_complete=bool(verified_root_anchors),
            executable_acceptance_required=executable_acceptance_required,
            executable_acceptance_complete=executable_acceptance_complete,
            executable_acceptance_command=executable_acceptance_command,
            executable_acceptance_artifacts=tuple(executable_acceptance_artifacts),
            population_gate_required=population_gate_required,
            population_digest=population.digest,
            population_active_candidate_ids=population.active_candidate_ids,
            population_selected_candidate_ids=population.selected_candidate_ids,
            population_direction=population.direction,
            population_invalid_packets=population.invalid_packets,
            prerequisite_leaf_ids=prerequisite_leaf_ids,
            prerequisite_error_classes=prerequisite_error_classes,
            evaluation_mode=normalized_evaluation_mode,
        )

    if verified_root_anchors:
        if executable_acceptance_required and not executable_acceptance_complete:
            return make_decision(
                "export",
                "running",
                "Lean root acceptance is complete; the declared deterministic executable acceptance gate is still open.",
                ("POST-LEAN-EXPORT",),
                (),
                (),
                ("middle", "exporter", "reviewer"),
                False,
            )
        return make_decision(
            "closeout",
            "complete",
            (
                "All task-declared Lean root anchors compile and the deterministic executable acceptance gate passes."
                if executable_acceptance_required
                else "All task-declared Lean root acceptance anchors compile under the current source digest."
            ),
            (),
            (),
            (),
            (),
            True,
        )
    if prerequisite_feedback:
        if same_signature and _lower(previous.get("mode", "")) == "prerequisite":
            return make_decision(
                "human_blocked",
                "blocked",
                "The structural prerequisite pass did not change Lean evidence; "
                "lower retries, capacity growth, and epsilon relaxation remain frozen.",
                (),
                tuple(leaf.leaf_id for leaf in external),
                tuple(leaf.leaf_id for leaf in unresolved + ready),
                (),
                True,
            )
        return make_decision(
            "prerequisite",
            "running",
            "Verifier feedback identifies a representation or semantic bridge "
            "gap. One bounded upper/middle pass must expose a named, independently "
            "compilable prerequisite lemma or replace the opaque interface before "
            "lower proof search can resume.",
            (),
            tuple(leaf.leaf_id for leaf in external),
            tuple(leaf.leaf_id for leaf in unresolved + ready),
            ("upper", "middle", "reviewer"),
            False,
        )
    if population_gate_required and not population.direction:
        return make_decision(
            "population",
            "running",
            "Exploratory work requires a middle-maintained active population and a current upper/reviewer selection before lower execution.",
            (),
            tuple(leaf.leaf_id for leaf in external),
            tuple(leaf.leaf_id for leaf in unresolved + ready),
            ("upper", "middle", "reviewer"),
            False,
        )
    if not pending and (lean_acceptance_required or executable_acceptance_required):
        missing = []
        if lean_acceptance_required:
            missing.append("declared Lean root acceptance anchor")
        if executable_acceptance_required:
            missing.append("deterministic executable acceptance gate")
        return make_decision(
            "decompose",
            "running",
            "No proof-DAG leaf was parsed, but the " + " and ".join(missing) +
            " remain unsatisfied. Upper and middle must initialize a concrete root-to-leaf DAG.",
            (),
            (),
            ("ROOT-INITIALIZATION",),
            ("upper", "middle", "reviewer"),
            False,
        )
    if not pending:
        return make_decision(
            "closeout",
            "complete",
            "No current open proof-DAG leaf or obligation remains.",
            (),
            (),
            (),
            (),
            True,
        )
    if route_rejected and not eligible:
        if unchanged_cycles >= max(1, max_no_progress_cycles):
            return make_decision(
                "human_blocked",
                "blocked",
                "Every open leaf violates the task route lock; the bounded DAG-repair budget is exhausted.",
                (),
                (),
                tuple(leaf.leaf_id for leaf in route_rejected),
                (),
                True,
            )
        return make_decision(
            "decompose",
            "running",
            "Every open leaf violates the task route lock; upper/middle must expose a dependency-ordered leaf on the locked route.",
            (),
            (),
            tuple(leaf.leaf_id for leaf in route_rejected),
            ("upper", "middle", "reviewer"),
            False,
        )
    approximate_ready = [leaf for leaf in ready if _looks_approximate(leaf)]
    exact_ready = [leaf for leaf in ready if not _looks_approximate(leaf)]
    if search_phase == "exact" and approximate_ready and not exact_ready:
        if unchanged_cycles >= max(1, max_no_progress_cycles):
            return make_decision(
                "human_blocked",
                "blocked",
                "The exact/approximate phase mismatch remained unresolved for the no-progress budget.",
                (),
                tuple(leaf.leaf_id for leaf in external),
                tuple(leaf.leaf_id for leaf in unresolved + approximate_ready),
                (),
                True,
            )
        return make_decision(
            "phase_decision",
            "running",
            "Only approximate leaves are ready while the controller is exact; a current upper/reviewer packet must open the first tolerance rung before lower work.",
            (),
            tuple(leaf.leaf_id for leaf in external),
            tuple(leaf.leaf_id for leaf in unresolved + approximate_ready),
            ("upper", "middle", "reviewer"),
            False,
        )
    if search_phase != "exact":
        if approximate_ready:
            ready = approximate_ready
        elif ready:
            if unchanged_cycles >= max(1, max_no_progress_cycles):
                return make_decision(
                    "human_blocked",
                    "blocked",
                    "The active approximate phase did not produce an approximate-ready leaf within the no-progress budget.",
                    (),
                    tuple(leaf.leaf_id for leaf in external),
                    tuple(leaf.leaf_id for leaf in unresolved + ready),
                    (),
                    True,
                )
            return make_decision(
                "phase_decision",
                "running",
                "The controller is approximate but only exact-route leaves are marked ready; upper/middle must expose a leaf for the active epsilon rung or explicitly stop.",
                (),
                tuple(leaf.leaf_id for leaf in external),
                tuple(leaf.leaf_id for leaf in unresolved + ready),
                ("upper", "middle", "reviewer"),
                False,
            )
    if ready:
        if benchmark_limited and same_signature:
            return make_decision(
                "benchmark_complete",
                "blocked",
                "The bounded benchmark attempt has already executed against this "
                "unchanged theorem and evidence. Evaluation modes task-only and "
                "LAD do not adapt capacity, tolerance, population, or route history.",
                tuple(leaf.leaf_id for leaf in ready),
                tuple(leaf.leaf_id for leaf in external),
                tuple(leaf.leaf_id for leaf in unresolved),
                (),
                True,
            )
        if (
            population_gate_required
            and same_signature
            and unchanged_cycles >= 1
            and unchanged_cycles < max(1, max_no_progress_cycles)
        ):
            return make_decision(
                "population",
                "running",
                "The selected route did not change Lean evidence; middle must retain, retire, mutate, or cross candidates before another lower attempt.",
                (),
                tuple(leaf.leaf_id for leaf in external),
                tuple(leaf.leaf_id for leaf in unresolved + ready),
                ("upper", "middle", "reviewer"),
                False,
            )
        if unchanged_cycles >= max(1, max_no_progress_cycles):
            return make_decision(
                "human_blocked",
                "blocked",
                "The same executable Lean leaf and Lean evidence remained unchanged for the no-progress budget.",
                tuple(leaf.leaf_id for leaf in ready),
                tuple(leaf.leaf_id for leaf in external),
                tuple(leaf.leaf_id for leaf in unresolved),
                (),
                True,
            )
        if benchmark_limited:
            return make_decision(
                "execute",
                "running",
                "The bounded benchmark mode exposes one Lean implementation "
                "attempt and deterministic review without adaptive ABEIS state.",
                tuple(leaf.leaf_id for leaf in ready),
                tuple(leaf.leaf_id for leaf in external),
                tuple(leaf.leaf_id for leaf in unresolved),
                ("lower2", "reviewer"),
                False,
            )
        plan: list[str] = []
        compiled_leaf_adapter = all(
            "compiled-leaf adapter" in _lower(leaf.dependency_class)
            or "compiled leaf adapter" in _lower(leaf.dependency_class)
            for leaf in ready
        )
        if (not same_signature or policy_applied) and not compiled_leaf_adapter:
            plan.append("lower1")
            if any(leaf.diagnostic_ready for leaf in ready):
                plan.append("lower3")
        plan.append("lower2")
        if lower_level >= 1 and same_signature:
            plan.append("lower4")
        if lower_level >= 2 and len(ready) > 1:
            plan.append("lower_aux")
        plan.append("reviewer")
        return make_decision(
            "execute",
            "running",
            "At least one named current leaf has a concrete Lean target and an explicit ready status.",
            tuple(leaf.leaf_id for leaf in ready),
            tuple(leaf.leaf_id for leaf in external),
            tuple(leaf.leaf_id for leaf in unresolved),
            tuple(plan),
            False,
        )
    if external:
        if external_gap_cycles >= max(1, max_external_gap_cycles):
            return make_decision(
                "human_blocked",
                "blocked",
                "The same external contract gap remained after its bounded dependency-decision cycle.",
                (),
                tuple(leaf.leaf_id for leaf in external),
                tuple(leaf.leaf_id for leaf in unresolved),
                (),
                True,
            )
        return make_decision(
            "dependency_decision",
            "running",
            "No Lean-ready leaf exists; one bounded upper/middle pass must choose local lemma, dependency import, explicit contract, or human escalation.",
            (),
            tuple(leaf.leaf_id for leaf in external),
            tuple(leaf.leaf_id for leaf in unresolved),
            ("upper", "middle", "reviewer"),
            False,
        )
    if unchanged_cycles >= max(1, max_no_progress_cycles):
        return make_decision(
            "human_blocked",
            "blocked",
            "Task decomposition did not produce a concrete Lean-ready leaf within the no-progress budget.",
            (),
            (),
            tuple(leaf.leaf_id for leaf in unresolved),
            (),
            True,
        )
    return make_decision(
        "decompose",
        "running",
        "Open work exists, but no leaf has both a concrete Lean target and explicit ready status.",
        (),
        (),
        tuple(leaf.leaf_id for leaf in unresolved),
        ("upper", "middle", "reviewer"),
        False,
    )


def load_control_state(path: Path) -> dict[str, object]:
    if not path.exists():
        return {}
    try:
        payload = json.loads(path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError):
        return {}
    return payload if isinstance(payload, dict) else {}


def write_control_state(
    path: Path,
    decision: CycleDecision,
    *,
    estimated_input_tokens: int | None = None,
) -> dict[str, object]:
    def update(previous: dict[str, object]) -> dict[str, object]:
        payload = decision.to_dict()
        payload["control_version"] = CONTROL_VERSION
        previous_total = int(previous.get("estimated_run_input_tokens", 0) or 0)
        if estimated_input_tokens is None:
            payload["execution_started"] = False
            payload["estimated_run_input_tokens"] = previous_total
        else:
            payload["execution_started"] = estimated_input_tokens > 0
            payload["estimated_cycle_input_tokens"] = estimated_input_tokens
            payload["estimated_run_input_tokens"] = previous_total + estimated_input_tokens
        return payload

    return update_json_locked(path, update)


def prompt_budget_violation(
    prompt_tokens: Mapping[str, int],
    *,
    max_prompt_tokens: int,
    max_cycle_tokens: int,
    run_tokens_used: int,
    max_run_tokens: int,
) -> str:
    oversized = [name for name, count in prompt_tokens.items() if count > max_prompt_tokens > 0]
    if oversized:
        details = ", ".join(f"{name}={prompt_tokens[name]}" for name in oversized)
        return f"per-prompt token budget exceeded: {details}; limit={max_prompt_tokens}"
    cycle_total = sum(prompt_tokens.values())
    if max_cycle_tokens > 0 and cycle_total > max_cycle_tokens:
        return f"cycle token budget exceeded: estimated={cycle_total}; limit={max_cycle_tokens}"
    if max_run_tokens > 0 and run_tokens_used + cycle_total > max_run_tokens:
        return (
            "run token budget exceeded: "
            f"used={run_tokens_used}; next={cycle_total}; limit={max_run_tokens}"
        )
    return ""

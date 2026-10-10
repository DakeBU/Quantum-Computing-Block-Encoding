"""Shared, fail-closed coverage contract for generated and deployed readers."""
from __future__ import annotations

ROUTES = (
    "mathematical-methods", "functor-hypergraph", "state-preparation-wiki",
    "progress", "lean-graph", "quantum-information",
    "quantum-scientific-computing",
)
WIDTHS = (390, 1280)
THEMES = ("blueprint", "modern", "bold")


def validate_browser_report(report: dict) -> int:
    """Require every distinct route/viewport/theme, not an arbitrary row count."""
    expected = {(route, width, theme)
                for route in ROUTES for width in WIDTHS for theme in THEMES}
    records = report.get("automated_browser_checks")
    if report.get("failures") != [] or not isinstance(records, list):
        raise ValueError("live browser acceptance evidence is missing or failed")
    seen = set()
    for record in records:
        if not isinstance(record, dict):
            raise ValueError("invalid live browser coverage record")
        key = (record.get("route"), record.get("width"), record.get("theme"))
        if key not in expected or key in seen:
            raise ValueError("unexpected or duplicate live browser combination")
        seen.add(key)
        if type(record.get("math_errors")) is not int or record["math_errors"] != 0:
            raise ValueError("live browser record has missing or failed math evidence")
        scroll = record.get("scroll_width")
        if type(scroll) is not int or not 0 < scroll <= record["width"] + 2:
            raise ValueError("live browser record has missing or failed layout evidence")
    if seen != expected:
        raise ValueError("live browser coverage is incomplete")
    if (report.get("blueprint_search_required") is not True
            or report.get("blueprint_search_passed") is not True):
        raise ValueError("live Blueprint search acceptance is missing or failed")
    return len(expected)

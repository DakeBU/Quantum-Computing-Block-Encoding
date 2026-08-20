"""Compatibility import for repository-level dynamic website tests.

The production site builder runs from ``website/scripts`` and imports its local
``lean_graph`` module directly.  Some regression tests load ``build_site.py``
with ``importlib`` from the repository root; in that context Python resolves
this shim, which re-exports the same implementation without duplicating it.
"""

from website.scripts.lean_graph import *  # noqa: F401,F403

---
name: digvation-feature
description: Use when implementing or modifying a Digvation feature, vertical slice, business rule, API behavior, Backoffice behavior, or Operational behavior.
---

# Digvation Feature Work

First use `digvation-router`.

Treat Superpowers as a supporting implementation methodology; Digvation lifecycle gates remain authoritative.

Before editing:
- inspect Git status/log as required by the applicable `AGENTS.md`;
- verify current contracts and determine whether backend work is actually required;
- preserve accepted behavior outside the requested work unit.

During implementation:
- keep the change at the narrowest correct owner;
- reuse healthy existing abstractions before extending or creating;
- use targeted tests/checks for the changed behavior, especially auth, RBAC, tenant isolation, money, migrations, concurrency, and cross-system contracts;
- do not perform unrelated cleanup or broad verification.

At completion:
- inspect the diff and dirty tree;
- remove task-created dead code/files;
- report executed validation truthfully;
- stop at `READY_FOR_MANUAL_REVIEW` when that gate applies.

Do not infer permission to commit, push, merge, release, or deploy.

<!-- DIGVATION_CLAUDE_BOOTSTRAP -->



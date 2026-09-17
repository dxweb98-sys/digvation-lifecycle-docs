---
name: digvation-router
description: Use when a task concerns Digvation Lifecycle and the correct repository, domain owner, scope contract, standard, or supporting tool must be selected.
---

# Digvation Router

Use the lifecycle root as the orchestration boundary.

1. Read root `AGENTS.md`.
2. Identify the actual repository or repositories involved and read their applicable `AGENTS.md`.
3. Classify ownership before touching code: CORE, business domain, shared business/platform foundation, Backoffice, Operational, cross-domain integration, database/migration, infrastructure, release, or architecture.
4. Read only the one or two relevant `scopes/*.md` contracts and only conditionally required standards named by `AGENTS.md`.
5. Use Codebase Memory before broad grep/find when available. Select the graph for the repository being changed. Query another repository only for a material cross-repository contract.
6. Verify important graph findings against source and Git state.
7. Apply `REUSE -> EXTEND -> NEW`.
8. If repository reality conflicts with the request or a required authority is missing, stop and report instead of inventing a contract.

Do not turn routing into a broad architecture audit.

<!-- DIGVATION_CLAUDE_BOOTSTRAP -->



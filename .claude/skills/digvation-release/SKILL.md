---
name: digvation-release
description: Use when a Digvation task reaches commit, push, merge, versioning, pull-request finalization, staging, release, deployment, installation, or production handoff.
---

# Digvation Release Gate

Read the root and repository `AGENTS.md`, then `standards/DELIVERY_RELEASE_STANDARD.md`. Add infrastructure/client/security standards only when the release scope requires them.

Before any remote mutation:
- confirm the current lifecycle state and explicit user authorization;
- inspect Git status and intended diff;
- ensure unrelated local work is not included;
- use the exact accepted branch/artifact rather than rebuilding an arbitrary state.

Feature completion is not deployment authorization. `READY_FOR_MANUAL_REVIEW` is not approval.

The installed `code-review` plugin may post GitHub comments. Do not invoke remote-posting review flows unless the user explicitly asks for that remote action and the lifecycle state allows it. Prefer local review skills when only local inspection is requested.

Never infer approval from silence or from passing checks.

<!-- DIGVATION_CLAUDE_BOOTSTRAP -->



# Digvation Lifecycle

Digvation canonical authority:
1. Current explicit instruction
2. Applicable repository AGENTS.md
3. Canonical lifecycle contracts
4. Current repository reality

## Context strategy

Do not broadly scan the workspace.

For source-code discovery:
- use Codebase Memory MCP first
- select the exact repository graph
- query only relevant symbols, routes, dependencies, callers/callees,
  and change impact
- verify MCP findings against current source before editing

Do not inspect sibling repositories unless a concrete cross-repository
dependency requires it.

For documentation:
- read root AGENTS.md
- load only the applicable standard/scope
- never preload the whole standards/ or scopes/ directories

For GitHub:
- use GitHub only when current remote state, branches, PRs, commits,
  or remote files are required.

REUSE â†’ EXTEND â†’ NEW.

Stop at READY_FOR_MANUAL_REVIEW unless explicitly authorized otherwise.

<!-- DIGVATION_CLAUDE_BOOTSTRAP:BEGIN -->
# Digvation Lifecycle â€” Claude Code entry contract

This workspace is the Digvation Lifecycle orchestration root.

For any Digvation implementation, review, debugging, architecture, release, or deployment task:

1. Read the `AGENTS.md` located beside this `CLAUDE.md` with the Read tool. Do not assume Claude Code loaded `AGENTS.md` automatically.
2. When work enters a nested repository, read that repository's applicable `AGENTS.md` before editing it.
3. Follow source precedence from the Digvation contract. Repository reality beats historical prompts.
4. Read only the scope contract and standards materially relevant to the task. Do not recursively study all lifecycle documents.
5. Prefer Codebase Memory for structural discovery, then verify important findings against source.
6. Treat installed plugins and skills as supporting capabilities only. Digvation `AGENTS.md`, accepted architecture, current repository contracts, and the user's current instruction remain authoritative.
7. Remote writes are gated. Do not commit, push, merge, post PR review comments, create releases, deploy, or perform other remote mutations unless the current Digvation lifecycle state and explicit user instruction authorize them.
8. For UI work, existing Digvation Design System/components/tokens win over generic UI recommendations.
9. Start Claude Code from this lifecycle root using `start-claude.ps1` so shared Digvation skills are reliably discovered.

Keep context lean: load evidence on demand, not the whole ecosystem.
<!-- DIGVATION_CLAUDE_BOOTSTRAP:END -->

## graphify

This project has a knowledge graph at graphify-out/ with god nodes, community structure, and cross-file relationships.

Rules:
- For codebase questions, first run `graphify query "<question>"` when graphify-out/graph.json exists. Use `graphify path "<A>" "<B>"` for relationships and `graphify explain "<concept>"` for focused concepts. These return a scoped subgraph, usually much smaller than GRAPH_REPORT.md or raw grep output.
- If graphify-out/wiki/index.md exists, use it for broad navigation instead of raw source browsing.
- Read graphify-out/GRAPH_REPORT.md only for broad architecture review or when query/path/explain do not surface enough context.
- After modifying code, run `graphify update .` to keep the graph current (AST-only, no API cost).

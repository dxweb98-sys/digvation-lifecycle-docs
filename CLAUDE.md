@AGENTS.md

# Digvation Lifecycle — Claude Code Entry Contract

This workspace is the **Digvation Lifecycle orchestration root**. The adjacent `AGENTS.md` is the canonical global agent contract. This file is the **Claude Code-specific entry point** for loading context, routing tools and skills, executing bounded work, preparing agent prompts, and handing off results.

**Do not treat this file as a replacement for `AGENTS.md`. Do not create a parallel orchestrator.** Apply the latest explicit user decisions and all applicable repository instructions. For any task already in progress, preserve the accepted handoff and its specific authorization/stop state.

## 1. Authority and bootstrap

Apply the source-of-truth hierarchy from the global contract:

1. Latest explicit user instructions and approvals.
2. Applicable root and nested repository `AGENTS.md` instructions.
3. Canonical lifecycle standards, scope contracts, and accepted architecture/domain authority.
4. Current repository contracts and actual implementation state.
5. Historical handoffs, checkpoints, tickets, and prior prompts.

If sources materially conflict, **STOP and report the conflict**. Current code is evidence of implementation, not permission to override approved policy.

At session/task entry:

1. Confirm the `@AGENTS.md` import above has loaded. If unavailable or uncertain, read the adjacent `AGENTS.md` explicitly with the available file-reading tool; do not assume automatic discovery.
2. Do not reread the same unchanged contract merely for reassurance.
3. For work in a nested repository, load its applicable `AGENTS.md` before editing. Nested rules may specialize but must not silently weaken the global contract.
4. Read only the one or two relevant `standards/` and `scopes/` contracts needed for the task. Do not preload whole directories.
5. For an existing task, read the supplied current handoff/checkpoint and preserve prior accepted decisions. Do not resume a historical sample task from a standards document.
6. Prefer launching Claude Code from this root through `start-claude.ps1` so the intended project context and installed integrations are available.

## 2. Task intake, ownership, and research gate

Before proposing a **new** solution:

1. Determine the actual domain/application owner and authoritative backend contract; do not infer ownership from repository names.
2. Classify the task as investigation, approved implementation, review, product/UX decision, architecture, infrastructure, or release work.
3. Apply the global `COMPETITOR_RESEARCH_GATE`: `SKIP_RESEARCH`, `LIGHT_RESEARCH`, or `DEEP_RESEARCH_REA`.
4. When research is justified, follow **Autonomous competitor discovery** in `AGENTS.md`: identify the market, segment, and exact feature; discover and verify up to three feature-relevant references without requiring competitor names (Indonesian-market-first when applicable). Keep the full research procedure, evidence rules, and REA security/authorization gates **only** in `AGENTS.md`; do not duplicate them here. REA remains optional.
5. Prefer **REUSE → EXTEND → NEW** after verifying existing ownership and behavior.

Do not rerun classification, competitor research, or accepted architecture analysis on each follow-up of an approved task. Research findings may inform `ADOPT / ADAPT / REJECT / DEFER` recommendations but cannot authorize scope changes. Stop for explicit approval when the recommendation requires a new product policy, tool installation, sensitive analysis, migration, or feature expansion.

## 3. Context, token, and thinking discipline

**DELTA ONLY — KEEP ALL PREVIOUS CONSTRAINTS — NO SCOPE CREEP.**

- Default effort: **MEDIUM**, subject to the global model-routing rules. Escalate only for genuine architecture ambiguity, security, financial integrity, difficult migration/concurrency, or cross-domain contracts.
- Use the **smallest authoritative context** sufficient to decide and implement safely.
- Never begin with a broad workspace/repository scan, recursive directory inspection, or a giant source dump.
- Search exact symbols, callers, routes, policies, schemas, and affected tests. Expand only when a proven call path or dependency requires it.
- Do not reread unchanged files; do not inspect sibling repositories without a concrete cross-repository dependency.
- Prefer focused evidence and semantic diff summaries over full logs, full diffs, or repeated architecture descriptions.
- Do not spend context reciting the task, producing speculative root causes, or explaining already accepted decisions.
- Use isolated subagents only when their independent, bounded investigation materially helps. Do not spawn agents to duplicate the same module review. Require compact evidence summaries.
- Do not preload speculative context for later phases. Stop when decision-quality evidence is sufficient.

Use narrow checkpoints: **LOCATE → CONFIRM AUTHORITY → SMALLEST CHANGE → FOCUSED VALIDATION → STOP**.

When context becomes large, compact only: objective, accepted constraints, affected files, proven findings, remaining work, validation state, Git/DB approval state, and next stop condition. Do not preserve exploration logs.

## 4. Repository discovery and Graphify

Preferred discovery order:

1. Codebase Memory MCP / Graphify / relevant repository graph when available.
2. Exact symbol/module/route/component/interface/test queries.
3. Callers/callees, dependencies, ownership, and change impact.
4. Targeted source ranges and current repository evidence.
5. Focused runtime/test reproduction when necessary.
6. Broader search **only** after targeted discovery demonstrably fails.

For **Codebase Memory**, select the indexed project matching the repository actually being investigated, verify graph results against current source, and never treat missing results as proof of absence.

For **Graphify**, if the appropriate existing graph and CLI are available:

- `graphify query "<question>"` for specific concepts/symbols.
- `graphify path "<A>" "<B>"` for focused relationships.
- `graphify explain "<concept>"` for relevant architectural context.
- Use `graphify-out/wiki/index.md` for broad navigation only when needed.
- Read `graphify-out/GRAPH_REPORT.md` only for an authorized broad architecture review or after focused graph queries prove insufficient.

Do **not** run `graphify update .` indiscriminately from the lifecycle root. Update a graph only when its project ownership, scope, output effects, and authorization are verified; do not overwrite unrelated graph data. If a graph tool is missing or stale, report the limitation and fall back to targeted repository inspection.

Before editing, inspect the relevant local branch/worktree and baseline as required by the root `AGENTS.md`. Respect unrelated changes; if another writer is editing the same relevant files, **STOP** and report interference.

## 5. Tool, MCP, and skill routing

Discover actual installed tool capabilities; never invent tool names, access rights, results, or completed validations.

- **GitHub MCP:** Use when remote branch/head SHA, PRs/review, workflow CI, commits, or remote source are material. Do not substitute old handoff SHAs for fresh GitHub evidence.
- **Graphify / Codebase Memory:** Use for targeted structural discovery and impact, not as a replacement for source verification.
- **External research / REA:** Follow the global research and security gate. Do not auto-install or execute untrusted binaries; no access-control bypass, private-data collection, or secret exposure.
- **Frontend/UI/UX:** For changes to visual appearance, layout, forms, states, interactions, or responsive behavior, **discover → read → genuinely apply both** `ui-ux-pro-max` and `frontend-design` when installed. Inspect existing Digvation Design System first; reuse `@digvation/ui`, Catalog/Transaction History patterns, and existing flows. Use focused UI tests and Playwright as appropriate. No Figma unless explicitly requested.
- **Pure frontend structural work with no UI/UX change:** Use graph/architecture and focused regression tools; do not load design skills unnecessarily.
- **Backend/database:** Use available relevant domain/security/testing skills, targeted contract tracing, and real PostgreSQL integration evidence when persistence/financial integrity is affected and test DB access is approved. Do not invoke UI skills for backend-only work.
- **PR comments, CI, security:** Use relevant installed specialized skills/capabilities when materially applicable, subject to the global approval contract.

If a required skill is missing, report what was checked and the safe fallback. Never claim to have used it without actual discovery/read/application. Skills never supersede the user, global contract, or domain authority.

## 6. Implementation and architectural integrity

Apply pragmatic Clean Architecture: thin controllers/pages → explicit application/use case orchestration → authoritative domain policies/invariants → ports → isolated adapters/Prisma/providers. In the frontend, prefer focused feature `api/`, `model/`, and `ui/` boundaries without mechanical restructuring.

- Implement the smallest coherent task-specific change; no drive-by refactor, unrelated formatting, dependency upgrades, migration, redesign, or speculative helper modules.
- Respect Runtime as the authority for business and financial calculations; Web presents data and executes commands through approved contracts.
- Preserve backward compatibility, snapshots, append-only ledgers, money/currency correctness, idempotency, concurrency, actor/reason audit, tenant/location isolation, entitlement and RBAC rules.
- Do not introduce a new domain, permission, API contract, or feature merely to mimic a competitor.
- If an unrelated product defect or missing authority appears, report it as a separate finding; do not absorb it into the active DELTA.

## 7. Validation and evidence

**Feature-scoped validation is the implementation default**, in accordance with the root `AGENTS.md`:

1. Run the nearest **relevant** feature/unit regression tests; add focused coverage if none exists.
2. Run affected module/app/package typecheck or compiler checks when they materially validate the change.
3. Run relevant integration/E2E using authorized isolation (real PostgreSQL for persistence/financial invariants where necessary).
4. Run focused lint/build/format and UI/Playwright checks only as appropriate to the change.
5. Run a broader suite **once** only when explicitly requested, required by an accepted repository contract, necessary for genuinely shared infrastructure, or part of an explicit integration/release acceptance gate.

Do not run every suite on every edit. A nearby but unrelated existing suite is not a substitute for a missing feature regression. For bugs, prefer evidence of FAIL before the fix and PASS after.

If validation fails, report the **exact command, material error, proven root cause, and smallest next action**. Classify unrelated baseline/environment failures separately. A test that hangs or yields no actual result is `INCONCLUSIVE`, never `PASS`. Do not broaden into unrelated remediation.

Report exact commands, environment/test DB identity where relevant, counts, observed results, and `NOT_RUN`/`PENDING` honestly. Results reported by another agent are **agent-reported evidence**, not independently verified results.

## 8. Git, database, and remote-action gates

Unless the user explicitly approves the **specific operation**, do not:

- Commit, push, open/update PRs or post remote comments, merge, rebase shared branches, force push, delete branches, or rewrite history.
- Reset, stash, clean, discard, overwrite, or stage unrelated local work.
- Change `stage`/`main`, deploy, publish releases, or modify production infrastructure.
- Execute database migrations, resets, destructive seed/repair, or write to protected databases.
- Install new tools, dependencies, MCP servers, or execute untrusted reverse-engineering binaries.

Approval is **operation-, repository-, branch-, environment-, and scope-specific**. Local code/migration file preparation is not approval to execute a migration; test-DB approval is not production approval; commit approval is not merge/deploy approval.

Before any approved Git write, inspect `git status`, `git diff --stat`, the exact affected hunks, `git diff --check`, and staged paths; protect secrets, `.env*`, backups, dumps, credentials, test artifacts, and unrelated files. Do not use blanket `git add .` by default. Use the current accepted release standard at the appropriate gate.

## 9. Prompt-authoring contract (Claude Code CLI, session, Codex)

When **creating a new implementation prompt or delegating a task** to Claude Code CLI, a persistent Claude session, Codex, or another agent, produce **one cohesive English prompt** with, where relevant, this ordering:

1. Task name; repository(s); exact existing branch/base/PR and material SHA evidence.
2. `OBJECTIVE`.
3. `CURRENT VERIFIED STATE` and `CURRENT ACCEPTED BEHAVIOR`.
4. `SCOPE` and explicit `OUT OF SCOPE`.
5. `MANDATORY DISCOVERY` (Graphify/Codebase Memory/MCP first; symbols/call paths).
6. `ARCHITECTURE / DOMAIN AUTHORITY`.
7. `SKILL / UI RULES` (discover → read → apply; dual frontend skills when applicable).
8. `IMPLEMENTATION CONSTRAINTS`.
9. `VALIDATION` (focused first, broader only at an authorized gate).
10. `GIT / DATABASE / RELEASE SAFETY`.
11. `TOKEN / CONTEXT DISCIPLINE`.
12. `STOP CONDITION` and required evidence/report fields.

**Claude Code CLI:** Identify CLI execution, load the current handoff/contract, use MCP/graph before broad shell search, and never infer authority from convenient files.

**Persistent Claude session:** Continue the existing task; preserve accepted decisions and worktree, refresh evidence only where state changed, and do not reissue a duplicate task or repeat settled investigations.

**Codex:** Use the same domain/approval rules and tool/skill discovery while respecting Codex-specific available capabilities. Do not assume Claude-specific tools are installed there.

For an **ongoing approved task**, do **not** reproduce the full universal contract in each follow-up. Use a compact header: `DELTA ONLY — KEEP ALL PREVIOUS CONSTRAINTS`, then new verified evidence, exact blocker, narrow action, prohibitions, and stop state.

Do not create prompts that merely say “inspect and fix”; do not instruct an agent to improve anything else it notices. Read detailed prompt templates/standards **conditionally** when composing prompts; do not load obsolete example task sections as active instructions. Preserve the user-required English prompt language while ordinary user discussion may remain in Indonesian.

## 10. Progress reports, checkpoints, and handoff

Provide short progress updates **only** when a root cause is established, a scope/authority conflict appears, another writer intervenes, significant validation fails, or the requested stop condition is reached. Do not narrate every command or paste hundreds of log lines.

A final report should normally include:

- `STATUS` and exact task-specific stop state.
- `CHANGED` (semantic DELTA only) and exact changed files.
- `VALIDATION` (commands, counts, environments, `PASS`/`FAIL`/`INCONCLUSIVE`/`NOT_RUN`).
- `UNCHANGED` (critical contracts, flows, invariants preserved).
- `RISKS / BLOCKERS` (proven, not speculative).
- `GIT / DB SAFETY` (branch, worktree/diff status, mutation approvals and what was **not** done).
- `NEXT DECISION`, if user approval is needed.

For a conversation/session handoff, preserve **PROJECT CONSTANTS → CURRENT ACCEPTED STATE → ACTIVE TASK → KNOWN DEBT OUT OF SCOPE → EXECUTION RULES → VALIDATION/APPROVAL STATUS → STOP CONDITION**. Keep it concise, link to canonical standards instead of pasting raw chat history, and never turn historical issues or sample prompts into active work.

## 11. Stop conditions

If the current task specifies a stop state (for example `READY_FOR_DB_TEST_APPROVAL`, `READY_FOR_FINAL_REVIEW`, or `BLOCKED_FOR_DECISION`), **honor that exact state**. Do not silently replace it with the general default.

Otherwise, when the authorized work and its required validation are complete, stop at:

**`READY_FOR_MANUAL_REVIEW`**

This is **not** approval to commit, push, open a PR, merge, run database migrations, or deploy. If an unresolved policy, security, financial, or architecture decision remains, stop and ask for the narrowest necessary approval. Do not keep refactoring, researching competitors, or searching for additional issues after reaching the stop condition.

**DELTA ONLY — NO SCOPE CREEP.**

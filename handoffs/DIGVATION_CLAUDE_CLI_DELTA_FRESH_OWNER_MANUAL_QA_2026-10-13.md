# DIGVATION LIFECYCLE — CLAUDE CODE CLI DELTA
## Dedicated Owner Activation — Fresh Local QA & Security Closure
**Date:** 2026-10-13
**Status:** APPROVED_FOR_SCOPED_TEST_DB_RESET_AND_MANUAL_QA; GIT_COMMIT_PUSH_NOT_APPROVED

> DELTA ONLY. Continue the existing local Claude Code CLI session and both local branches `feat/dedicated-owner-invitation-activation`. Inherit the initial handoff, Digvation Agent Prompting & Execution Standard, both repositories' `AGENTS.md`, and all prior accepted decisions. Do not start a new audit.

## DGV-CORE — Locked architecture
- Dedicated-first. `RUNTIME_BINDING_MODE=deployment`, `DEPLOYMENT_PROFILE=DEDICATED`, `IDENTITY_MODE=account`. No CORE dependency.
- Initial entitlements: `MULTI_BRANCH=false`, `CATALOG_SERVICE_COMPOSITION=true`.
- Reuse existing tenant seed, canonical OWNER role, `AuthService.provisionInitialOwner`, invitation repository, login/session, verification sender, and Backoffice auth shell. No second authentication or provisioning authority.
- No new business-domain model, unrelated code refactors, Inventory work, or Multi-Branch rewrite.

## DGV-TOOLS / DGV-DISCIPLINE
- Graphify/codebase-memory/repository MCP FIRST if available; otherwise targeted exact-symbol/file reads. No broad scans.
- Medium effort by default; escalate only for identity/security/data-integrity concerns.
- Inspect actual local file changes, current uncommitted diff, relevant commands and startup configs; preserve all unrelated local work.
- UI changes only: consult @digvation/ui, Digvation Design System, ui-ux-pro-max, frontend-design; run Playwright for user-visible behavior. Do not use Figma unless requested.
- Focused regression tests first, then required repository verification ONCE after stabilizing.

## CURRENT EVIDENCE REPORTED BY CLI (not independently verified by orchestrator)
- Fresh Owner invitation/link activation implemented locally and not committed; Runtime + Web have local changes only.
- Runtime real PostgreSQL integration 8/8 PASS; Runtime verify PASS; Web activation unit 11/11 PASS; Web verify PASS; Web separate test 1392/1393 with one unrelated intermittent operational-members-page case, which passed 26/26 in isolation.
- Live Playwright covered activation/login/reload and one-time token replay, desktop/mobile; logout, password recovery, BOM and Single-Location UI were NOT_RUN.
- Existing business DB `127.0.0.1:5432/digvation_pos_local#public` remained unchanged (reported original counts include 224 sales).
- Test DB `127.0.0.1:5432/digvation_dedicated_onboarding_test#public` contains disposable Owner and test-generated tenants; initial invitation already consumed.

## ACTION 1 — EXACTLY ONE SAFE FRESH RESET AUTHORIZED
**Authorized target only:** `127.0.0.1:5432/digvation_dedicated_onboarding_test`, schema `public`.

You MAY perform ONE destructive reset of this disposable test database for a genuinely fresh manual onboarding run. You MAY NOT delete any tables/users selectively from the old business DB, drop Docker volumes, reset another DB, or modify server/staging/production DBs. Existing `digvation_pos_local` is explicitly PROTECTED.

Before any destructive command:
1. Inspect and print sanitized target host, port, database, schema, `NODE_ENV`, and database contents/counts; exclude credentials.
2. Verify **the database connection used by the exact Prisma CLI command**, not merely the application settings. `ENV_FILE=.env.onboarding-test` does not automatically prove that `prisma migrate reset` will use the intended URL. Explicitly establish/verify the effective `DATABASE_URL` used by the CLI; use a Windows PowerShell-compatible invocation when applicable.
3. Verify host is loopback, name matches exactly `digvation_dedicated_onboarding_test`, schema exactly `public`, and no other process/test is concurrently using that DB.
4. If any check differs, STOP as `BLOCKED_RESET_TARGET_MISMATCH` without destructive action.
5. Optional local `pg_dump` only if you discover unexpected user-owned data in the **test** DB; in that case STOP and ask before wiping it.
6. Reset only that DB; apply current migrations, then run the existing development seed/initialization with isolated config. Do not create an active Owner from seed. Verify exactly one intended initial tenant, Main Location and canonical OWNER role, and zero active Owner users/pending invitations before provisioning.
7. Do not re-use old invitation links or secrets; generate a new pending Owner invitation with the existing dev-only CLI. Never paste a live activation token in the final report, source, screenshots, audit, or logs.
8. Check and report preserved counts of `digvation_pos_local` before and after reset.

**IMPORTANT — reviewer's manual activation:** Leave the fresh Owner invitation **PENDING and unused** for the user to click and activate. Do not consume this final review link in Playwright/integration tests. Run automated tests with isolated fixtures or different disposable test tenants/databases; do not mutate the prepared reviewer Owner invitation. Supply the link to the user through the agreed secure local/dev-only channel without putting its token in the final shared report.

## ACTION 2 — TARGETED SECURITY / RELIABILITY REVIEW
Review only the new activation-code delta. Prove with focused tests or implement the smallest bounded fix for:
- Invalid `inspect` or `activate` requests with a known invitation ID must not let an unauthenticated actor exhaust the old OTP attempt budget and lock out an otherwise valid link. Keep link and legacy OTP attempts appropriately isolated; avoid a schema migration unless justified. If the current design makes this impossible, STOP with exact evidence.
- Public inspect/activate request abuse: use an existing rate-limit/abuse-control mechanism if present; if none is available, identify the specific residual risk and state the minimal production ingress/WAF control requirement. Never claim it is protected without evidence.
- Link token protection: 32-byte random token, purpose-separated HMAC hash only at rest, constant-time comparison, TTL, revoked/expired/reused errors, tenant/workspace binding, atomic single consumption, no plaintext token/password in logs or redirects. Preserve OTP invitation behavior and password recovery.
- Frontend: no accidental token leakage to analytics, referer, localStorage, query string, API errors, screenshots, or client logs. Reload after fragment is removed should present a safe recoverable state (reopen invitation link), not misleading success.
- Invitation delivery failure, cooldown, and resend behavior; do not activate account after failed delivery.
- Activation base URL and local Runtime/Web origin alignment. Do not disturb existing ports/processes `4003` and `5174` unless the user separately authorizes it. Reuse spare ports and isolated config; report verified URLs instead of guessing them.

## ACTION 3 — COMPLETE MANUAL ACCEPTANCE SUPPORT
Run focused validations without consuming the reviewer's pending invitation:
- `ACT-01..ACT-10` and INVALID/EXPIRED/REUSED token, TENANT_ISOLATION, OTP_COMPATIBILITY.
- Actual logout after first activation/login and subsequent login; password-reset smoke test for an activated Owner if feasible.
- Single-Location UI: `MULTI_BRANCH=false`, one main location, no redundant selector; direct API attempt to create an additional active location denied.
- BOM ON: create a valid Service + Product component in Backoffice, complete one test Sale through Operational, inspect authoritative amount/component snapshot; Inventory not required. If this cannot be done without consuming the review Owner, use a distinct fixture or provide steps marked NOT_RUN.
- Desktop and mobile viewport layout, invalid password/confirmation, replay link, refresh/reopen behavior.
- Keep per-scenario results precisely PASS/FAIL/NOT_RUN; do not merge automated tests, CI, live Playwright, and human manual review into one PASS claim.

## DGV-GIT — STRICT
- Existing local branches in BOTH repos: `feat/dedicated-owner-invitation-activation`, branched from the current Batch B feature heads. Stay on these branches; no new worktree/branch unless user explicitly approves.
- You MAY modify local worktrees and add focused tests. No commit, push, PR, merge, rebase, forced reset of git, stage/main/dev edits, or deploy.
- No modifications to CORE. No changes to remote Batch B PRs #113/#148.

## STOP OUTPUT
Stop at `READY_FOR_MANUAL_REVIEW` (or exact blocker) and report compactly:
1. SAFE RESET: precise sanitized DB target, command, before/after counts, proof old DB untouched; if any destructive command was skipped, say so.
2. REVIEW INVITATION: state PENDING, URL origin/path and secure handoff method (**never paste token**), test Owner username/workspace, exact local startup commands and ports, where/how the reviewer obtains their link.
3. CHANGED: semantic changes and changed-file paths (delta from previous checkpoint only).
4. VALIDATION: commands/results/counts, failed/retried tests, E2E and Playwright evidence, NOT_RUN details.
5. MANUAL MATRIX: ACT-01..ACT-10 + single location + BOM + token security, with expected result and manual status blank/NOT_TESTED for reviewer.
6. SECURITY: abuse-control/attemptCount finding, OTP compatibility, remaining risks.
7. GIT: `git status --short --branch` and `git diff --stat` in both repos. Confirm no commit/push/PR/merge/deploy.

**Final gate:** STOP. Do not commit/push until user manually approves after orchestrator review.

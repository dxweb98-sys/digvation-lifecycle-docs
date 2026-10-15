# DIGVATION LIFECYCLE — CLAUDE CODE CLI
## DELTA TASK: Local Dedicated First-Owner Invitation & Activation

**Execution mode:** CLAUDE CODE CLI — LOCAL ONLY. **STOP = READY_FOR_MANUAL_REVIEW**.

### REPOSITORIES / BRANCH CONTEXT
- Runtime: `dxweb98-sys/digvation-business-runtime`
- Web: `dxweb98-sys/digvation-business-web`
- Batch B under manual review: `feat/multi-location-service-composition` (Runtime PR #113; Web PR #148). Do not touch the existing remote PRs.
- This is an **independent onboarding/auth work unit** needed to test Batch B from a clean dedicated-local installation. Do not silently mix this into Batch B commit/PR.
- **Before code edits:** inspect local Git status and latest refs in both repos, preserve unrelated local edits. Propose a same-named **local-only** isolated feature branch/worktree, e.g. `feat/dedicated-owner-invitation-activation`, based on the current local Batch B feature head for integration testing; if local state is dirty or the proper base is uncertain, STOP for direction. Do not push/create remote branch or PR.

### DIGVATION EXECUTION CONTRACT
Follow `DIGVATION_AGENT_PROMPTING_STANDARD(2).md`, repository `AGENTS.md`, relevant Lifecycle `standards/ENGINEERING_STANDARD.md`, `standards/SECURITY_ACCEPTANCE_STANDARD.md`, `scopes/IDENTITY_ACCESS.md`, and `scopes/ORGANIZATION_LOCATION.md`. Authority order: latest explicit decision -> canonical docs -> repository reality -> domain contracts -> task -> graph/MCP evidence -> implementation.

Act as a senior developer on an existing production system. Use **MEDIUM thinking** by default. Graphify/codebase-memory/repository MCP first (when available); otherwise targeted symbol search. **graph -> symbol -> callers -> exact files -> focused tests**. Avoid broad scans, unrelated refactors, or redundant domain authorities. Use subagents only for isolated research. Do not waste tokens repeating specs, dumping files/logs, or re-reading unchanged modules.

**No commit, push, PR, merge, rebase, reset of Git history, stage/main changes, deployment, or server operations.** Editing working-tree files and running local test/validation are allowed. Do not execute database-destructive commands until the user confirms the exact target and operation.

### OBJECTIVE
Simulate CORE-like customer onboarding **manually** for a dedicated Digvation installation while CORE remains absent:

1. An operator prepares a clean **local dedicated** Tenant + Business Profile/Preferences + exactly one active Main Location + canonical OWNER role, through the existing authoritative bootstrap/seed infrastructure.
2. The operator manually initiates initial Owner provisioning, creating a **pending one-time invitation**, never an active credential/known starter password.
3. The Owner receives or can open a trusted **single-use activation link**. Following it opens a public Backoffice activation page (not behind login), which shows appropriate business context, offers **New Password** and **Confirm Password**, and completes activation against Runtime.
4. **Only after successful activation** does Owner become a login-capable ACTIVE account, with canonical OWNER role. Owner then logs in normally and sees single-location Backoffice and POS according to effective entitlements.
5. Keep dedicated entitlement authority from deployment/manifest/flat env; **no CORE runtime dependency**, no fake CORE DB, no subscription/tenant self-service admin.
6. Existing invited-user flow, password reset, login, RBAC, audit, multi-branch, Catalog/BOM, payment, and member flows must remain unchanged unless a demonstrated narrow compatibility update is essential.

### VERIFIED STARTING POINT (DO NOT REBUILD)
Runtime currently has:
- `scripts/db/seed-dev.ts` + `development-baseline.ts`: local Tenant, Profile/Preferences, main Location and OWNER role. Intentionally **does not create Owner account**.
- `scripts/local-database-safety.cjs`: enforces loopback and `digvation_<profile>_local` / `_test` database naming; destructive reset requires distinct approval.
- `scripts/installation/provision-initial-installation.ts`: production-oriented plan and `AuthService.provisionInitialOwner()`; inspect exact restrictions before reuse. **Do not run production bootstrap scripts as a local shortcut.**
- `AuthService.provisionInitialOwner`, `AuthRepository.provisionInitialOwner`, `UserInvitation`, `ActivateInvitationDto`, `POST /api/v1/auth/invitations/activate`, and verification sender infrastructure.
- Existing activation is invitationId + numeric verificationCode + password. Activation transaction creates the `UserAccount` ACTIVE only on successful validation. Treat pending **invitation** as the pending Owner account lifecycle representation unless source evidence proves a separate UserAccount row is necessary.
- Current local verification sender deliberately does not log secret codes. Webhook/WhatsApp transports exist; do not claim email delivery exists without proof.
- Web `apps/backoffice/src/app/router/backoffice-router.tsx` has public login and password recovery routes, **not** invitation-link activation route; reuse `BackofficeAuthShell` and `@digvation/ui`.

Inspect targeted callers/tests and actual current changes before implementation:
`src/modules/auth/{auth.service.ts,auth.controller.ts,auth.dto.ts,auth-crypto.ts,auth.repository.ts,verification-sender.*}`,
`src/infrastructure/database/prisma-auth.repository.ts`,
`src/config/environment.ts`, relevant Prisma `UserInvitation` schema,
`apps/backoffice/src/auth/*`, `apps/backoffice/src/app/router/backoffice-router.tsx`,
`packages/auth/src/*`, and the nearest existing unit/integration/E2E tests.

### PHASE 0 — SAFE LOCAL DATABASE PLAN (MANDATORY HUMAN GATE)
- Inspect `.env` configuration without exposing secret values. Print **only** DB hostname, port, database name, schema, `NODE_ENV`, binding mode, deployment profile, and account verification mode, with credentials redacted.
- Confirm DB is a disposable **loopback** local/test PostgreSQL target following the canonical safety script. Verify it is NOT staging/production, remote, shared with another app, or containing user data that needs preservation.
- Show the user exactly what reset affects and whether backup is needed. **STOP for explicit approval of destructive reset**. Do not infer approval merely from the phrase “reset local”.
- After approval, reset ONLY the approved local database/schema by the repo-supported Prisma migration path; no blanket `docker volume rm`, no dropping other DBs, no deleting credentials or user files. Reapply migrations, then existing dev baseline seed. Do not seed an active Owner or fake historical transactions.
- Keep `MULTI_BRANCH=false`, `CATALOG.SERVICE_COMPOSITION=true`, and dedicated deployment binding when available. For local single-location tests, use a known dedicated profile and valid Account identity settings; do not invoke CORE.

### PHASE 1 — INITIAL OWNER INVITATION (NARROW DESIGN)
- Prefer a local-only **manual provisioning command/config** using the existing `AuthService.provisionInitialOwner()` and tenant/OWNER authority. Idempotent and tenant-scoped. No public anonymous endpoint to create Owner/tenant.
- Accept only operator-provided business workspace, Owner display name, username where valid, phone in E.164 (national `08...` input may normalize through existing boundary). Validate the target tenant and OWNER role; do not hardcode client identity.
- No default password. Before activation, Owner cannot log in.
- A **true click-and-set-password link** must carry a **cryptographically strong, unguessable, time-limited, one-use opaque token** (e.g. 32 random bytes) tied to invitation/workspace; do **not** put the existing 6-digit OTP in a URL and call it a secure token. Store only verifier/hash, enforce expiry, replay prevention, resend rotation, revoked invitation and tenant scoping, and atomically consume with activation. Reuse invitation infrastructure and existing DB columns if safe; if this cannot be done without introducing a new security model or migration, stop with a precise proposal before proceeding.
- Preserve the existing OTP activation endpoint for old invitations. Do not weaken password policy, verification attempt limits, login throttling, or session protection.
- Link base origin must come from a trusted allowlisted/configured Backoffice base URL; never from client-supplied redirect. No tokens/passwords in audit logs, regular server logs, API response objects, metrics, analytics, referrers, or URL history after client captures token. Activation page should clear sensitive query params promptly; use a restrictive referrer policy and avoid third-party scripts on this page.
- For local preview, if provider unavailable, offer an **explicit opt-in, development-only** way for the operator to copy the one-time link (never enabled in production or accessible anonymously). For real delivery use the existing configured WhatsApp/webhook sender; do not invent an SMTP provider/email transport. If secure delivery cannot be implemented within the existing sender contract, report the gap instead of claiming sent.

### PHASE 2 — BACKOFFICE ACTIVATION PAGE
- Add a public route (e.g. `/activate`) outside authenticated shell. Route accepts workspace, invitation id, and opaque token from link; password and confirmation are entered **only in the form**, never in URL.
- Reuse current Backoffice auth shell, Digvation `@digvation/ui` components, localization convention, responsive behavior, and accepted spacing/interaction. Consult Design System first, then `ui-ux-pro-max`, `frontend-design`, and Playwright when available; **no Figma** unless requested.
- Show valid, expired, already-used, revoked, invalid, and network-error states without leaking tenant/user identity. Disable Submit until valid; prevent duplicate submission. Show password visibility toggles and policy feedback if supported by Design System.
- Activation completion must not implicitly bypass normal login/session policy. Prefer “Account activated -> Go to login”, followed by a genuine login/session; make the choice consistent with existing auth contracts.

### PHASE 3 — FOCUSED VALIDATION THEN REPOSITORY GATES
Run nearest unit tests first, then relevant integration/real-PostgreSQL E2E, then affected lint/format/typecheck and existing `npm run verify` (Runtime) and `pnpm verify` (Web) once stable. Use Playwright if available for public activation, login, single-location experience, and responsive checks. Be exact about tests RUN vs NOT_RUN; no fabricated PASS.

Required regression scenarios (provide executable steps, accounts/fixtures, expected outcomes, evidence fields, manual status):
- `ACT-01` Fresh disposable local DB seed -> one Tenant/Profile/Main/OWNER role, no active Owner.
- `ACT-02` One manual Owner invite -> pending; Owner login denied before activation.
- `ACT-03` Trusted invite link opens public activation form without login, shows set+confirm password.
- `ACT-04` Wrong/missing/expired/revoked/replayed token rejected; no account activated.
- `ACT-05` Cross-workspace/tenant token misuse rejected; idempotency and one Owner enforced.
- `ACT-06` Password policy & mismatch rejected; valid password activates exactly once with OWNER role.
- `ACT-07` Post-activation normal login/session/logout work; refresh retains authorized access.
- `ACT-08` Resend rotates old token, delivery failures handled, no secret leakage.
- `ACT-09` No CORE dependency when binding is `deployment` and dedicated capability manifest is configured.
- `ACT-10` Existing invited users OTP flow and password recovery do not regress.
- `LOC-01` Single-location `MULTI_BRANCH=OFF`: Main auto-resolves, no unnecessary branch selector, second active branch denied.
- `BOM-01` `CATALOG_SERVICE_COMPOSITION=ON` with Inventory absent: Service components can be configured and used; amounts remain authoritative.
- `BOM-02` BOM OFF after configured: new BOM editing denied; old Sale/history/pricing preserved.

### REPORT / STOP
Return only:
`STATUS: READY_FOR_MANUAL_REVIEW` or `BLOCKED_SAFE_RESET_APPROVAL` / `DECISION_REQUIRED` with exact reason;
verified local DB target **without secrets**; current branch/worktrees; changed files; delta behavior; validation commands/results/counts; not-run items; screenshots/API examples where possible; security/regression risks; manual testing matrix ACT-01..10 + LOC/BOM checks; Git status/diff summary. Explicitly state **NO COMMIT, NO PUSH, NO PR, NO MERGE, NO DEPLOY**. The first stop for DB reset is not a failure: obtain approval, then continue this same CLI session.

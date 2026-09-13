# Digvation Prompt Library — USER TOOLBOX

> This file is for the USER to copy/paste prompts.
>
> Agents do **not** need to read/study this file as permanent project context.
>
> Permanent behavior belongs in `AGENTS.md` and architecture/engineering standards.

The prompts below are intentionally short because the standards already carry the repeated rules.

---

## 1. Standards Bootstrap / Reconciliation

Use once after replacing the old documentation.

```text
DIGVATION STANDARDS RECONCILIATION

Work from the lifecycle workspace root.

Read and obey the applicable AGENTS.md hierarchy.

Read these canonical standards once for this reconciliation:

- README.md
- ECOSYSTEM_ARCHITECTURE.md
- ENGINEERING_STANDARD.md
- DELIVERY_RELEASE_STANDARD.md
- NEW_PRODUCT_STANDARD.md
- ../scopes/README.md

Then read only the currently active/next scope contracts materially relevant to the repositories being reconciled.

Then inspect the existing repository-local AGENTS.md and documentation for:
- core-v2
- digvation-core-ui
- digvation-business-runtime
- digvation-business-web
- apps/cashier
- apps/backoffice

This is DOCUMENTATION / INSTRUCTION RECONCILIATION ONLY.

Do not modify production code.
Do not implement roadmap features.
Do not run tests/builds.
Do not change versions.
Do not deploy.

Report:
1. rules that conflict with the new standard
2. unique repository/domain rules that must be preserved
3. obsolete/duplicated docs that can be archived/deleted
4. proposed final AGENTS.md placement
5. exact files you recommend changing

STOP for my approval before modifying repository documentation.
```

Recommended model: **TERRA MEDIUM**.
Use **TERRA HIGH** only if the existing docs contain major conflicting architecture.

---

## 2. New Feature — Single Repository

```text
Continue <PRODUCT/APP> with <FEATURE NAME>.

Work from the latest accepted integration baseline.

Follow all applicable AGENTS.md instructions.
Read the owning `scopes/<SCOPE>.md` contract before implementation.
Use Codebase Memory MCP before broad repository exploration and verify important findings against source.
For frontend/UI work, use `uiuxpromax` automatically and preserve the Digvation Design System.

Scope:
<short feature scope>

Do not expand into the next roadmap item.
Do not redesign accepted architecture.
Reuse existing contracts/components before creating new ones.

Complete the coherent feature, run only the required scoped final validation,
then STOP for my manual review.

Do not commit, push, merge, version, or deploy.
```

Default model: **TERRA MEDIUM**.

---

## 3. New Feature — Backend + Frontend Vertical Slice

```text
Continue <PRODUCT> with <FEATURE NAME> as one backend/frontend vertical slice.

Follow all applicable AGENTS.md instructions.
Read the owning and directly integrated `scopes/<SCOPE>.md` contracts only.
Use Codebase Memory MCP in each materially involved repository before broad exploration.
For frontend/UI work, use `uiuxpromax` automatically and preserve the Digvation Design System.

First verify the current backend contract and classify:
- NO_BACKEND_CHANGE
or
- ADDITIVE_BACKEND_WORK_REQUIRED

Do not modify backend if the existing contract is sufficient.

Then complete the frontend against the verified contract.

Scope:
<feature behavior>

Run only the repository-scoped final validation required for repositories that changed.

STOP for my manual review.
Do not commit, push, merge, version, deploy, or start the next roadmap item.
```

Default model: **TERRA MEDIUM**.

Use **TERRA HIGH** for settlement/reconciliation/security/financial authority or difficult cross-contract work.

---

## 4. Manual Review Request

Use when the agent says implementation is complete but does not provide a useful review path.

```text
Prepare this work for MANUAL REVIEW only.

Do not change code unless you discover a direct blocker.

Give me:
1. exact screen/API to open
2. exact steps/actions to try
3. expected result
4. important responsive/error/permission cases relevant to this task
5. current scoped validation result

Do not commit, push, merge, version, deploy, or continue the roadmap.
```

---

## 5. APPROVE Current Feature

```text
APPROVED.

Finalize only the currently reviewed feature.

First confirm:
- working tree/diff contains only intended changes
- no task-created dead code/files remain
- scoped validation is still valid

Then recommend the exact commit message.

Do not create a release or deploy.
Do not start the next roadmap item yet.

Report:
1. final files/diff summary
2. recommended commit message
3. exact commit/push/merge steps for the repository
4. what the next roadmap item should be

STOP.
```

If you want the agent to perform Git writes too, append:

```text
You are authorized to commit and push this accepted feature branch.
Do not merge until I explicitly authorize merge.
```

---

## 6. APPROVE + Merge to Development

```text
The current feature is APPROVED and already manually reviewed.

Finalize and merge only this accepted feature into the repository's development integration branch.

Follow the applicable AGENTS.md and delivery standard.

Before merge:
- verify clean/intended feature diff
- verify latest remote integration branch
- preserve unrelated work
- do not change feature scope

Use a clean merge/squash strategy appropriate to the current branch history.

Do not bump release version unless this is explicitly a release boundary.
Do not deploy.
Do not start the next feature.

Report the resulting integration branch HEAD and recommended next roadmap item.
```

---

## 7. REJECT Current Feature

```text
REJECTED — remain on the current feature branch.

Fix only these review findings:

- <finding 1>
- <finding 2>
- <finding 3>

Preserve everything that already passed review.

Do not redesign the feature.
Do not touch unrelated repositories.
Do not start the next roadmap item.

After remediation, run only the permitted scoped final validation and STOP for manual review again.

Do not commit, push, merge, version, or deploy.
```

Default model: **TERRA MEDIUM**.

---

## 8. Review-Only / Independent Audit

```text
READ-ONLY REVIEW.

Repository:
<repo>

Target branch/SHA:
<branch or SHA>

Review only this scope:
<scope>

Follow applicable AGENTS.md and architecture contracts.

Do NOT:
- modify files
- commit
- push
- merge
- tag
- release
- deploy
- redesign architecture because of preference

Report findings ordered by severity with file/behavior evidence,
then give PASS / PASS_WITH_REMEDIATION / FAIL.
```

Use **TERRA HIGH** for security/financial/release reviews.

---

## 9. New Application inside Existing Product

Example: another POS frontend app.

```text
Plan a NEW APPLICATION inside <PRODUCT>.

Follow lifecycle standards and the owning product AGENTS.md.

Application:
<name/purpose>

Before implementation, define only:
- application responsibility
- why it is independently deployable or app-owned
- relationship to existing apps/backend
- Design System/shared dependency strategy
- auth/session boundary
- server-state boundary
- independent version/deployment identity
- required AGENTS.md delta
- minimum Docker/CI/release baseline

Do not generate the full application yet.

Do not duplicate another app's internals.
Do not create cross-app imports.

Return the proposed tree, ownership boundaries, delivery plan, and first coherent feature.
STOP for approval.
```

Recommended model: **TERRA HIGH** for the initial app boundary; **TERRA MEDIUM** after it is locked.

---

## 10. New Digvation Product / System

```text
Plan a NEW DIGVATION PRODUCT using NEW_PRODUCT_STANDARD.md.

Product:
<product name>

Problem / intended scope:
<scope>

Follow ECOSYSTEM_ARCHITECTURE.md.

Before coding, define:
1. product responsibility and non-responsibilities
2. operational domain ownership
3. CORE relationship: Product/ProductFeature/Entitlement/Installation
4. tenant/isolation model
5. cross-product integration needs
6. repository/app topology
7. Clean Architecture boundaries
8. application versions/deployables
9. Docker/CI/environments
10. first MVP vertical slices
11. first-release gate

Do not implement yet.
Do not copy POS domains merely because POS exists.
Do not use direct cross-product DB access.

Return a proposed architecture and delivery sequence.
STOP for my architecture approval.
```

Recommended model: **SOL** for initial product architecture, then **TERRA MEDIUM/HIGH** for implementation.

---

## 11. Architecture Decision / Brainstorm

```text
ARCHITECTURE DECISION ONLY.

Question:
<decision>

Use the current Digvation ecosystem standards and actual repository constraints.

Do not modify code.

Give:
- current constraints
- 2–3 viable options
- tradeoffs
- recommended decision
- what becomes permanently locked if approved
- which canonical document should be updated

Do not create extra documents.
STOP for my decision.
```

Recommended model: **SOL** for ecosystem-level decisions; **TERRA HIGH** for repository-level design.

---

## 12. Refactor / Cleanup

```text
Perform a scoped CLEANUP/REFACTOR of:

<scope>

Behavior must remain unchanged unless explicitly listed.

Follow applicable AGENTS.md and ENGINEERING_STANDARD.md.

Goals:
- remove unused/task-obsolete code
- remove duplicate abstractions
- improve ownership/naming where materially justified
- preserve public/domain contracts
- do not restructure unrelated modules
- do not create new documentation

Run only the required scoped validation, then STOP for manual/source review.

Do not commit, push, merge, version, or deploy.
```

Recommended model: **TERRA MEDIUM**.

---

## 13. Release Candidate Preparation

```text
Prepare a RELEASE CANDIDATE for:

Product/components:
<components>

Target accepted integration SHAs:
<SHAs or ask agent to resolve>

Follow DELIVERY_RELEASE_STANDARD.md.

This is a release gate, not feature development.

Do not add new product features.

Verify:
- release scope
- clean Git state
- application version changes
- backend/frontend compatibility
- migrations
- full required repository validation
- production builds
- immutable artifact/image creation readiness
- configuration requirements
- known issues
- rollback/backup plan
- staging deployment plan

Report blockers before tagging/releasing.

Do not deploy production.
STOP for my RC approval.
```

Recommended model: **TERRA HIGH**.

---

## 14. Staging Deployment

```text
Deploy/prepare the APPROVED release candidate to STAGING only.

Use the exact accepted immutable artifacts.

Follow DELIVERY_RELEASE_STANDARD.md.

Verify:
- artifact/version/build identity
- environment configuration
- migrations
- health/readiness
- critical smoke flows
- runtime errors/logs

Do not rebuild different production artifacts.
Do not deploy production.

Report staging PASS/FAIL and any blockers.
STOP for my approval.
```

Recommended model: **TERRA HIGH**.

---

## 15. Production Deployment Approval

```text
PRODUCTION DEPLOYMENT AUTHORIZED for the already accepted release candidate.

Target Installation/environment:
<target>

Use the exact staging-accepted immutable artifacts.

Follow DELIVERY_RELEASE_STANDARD.md.

Before deployment confirm:
- exact versions/build revisions
- target Installation
- configuration/secrets readiness
- migration plan
- backup/rollback readiness

Deploy only the approved scope.

After deployment verify:
- deployed versions
- health/readiness
- migration status
- critical smoke flow
- runtime errors/logs

Do not start unrelated work.

Report deployment result and post-deploy status.
```

Recommended model: **TERRA HIGH**.

---

## 16. Hotfix

```text
PRODUCTION HOTFIX.

Affected component:
<component>

Observed production issue:
<issue>

Follow the hotfix flow in DELIVERY_RELEASE_STANDARD.md.

Keep the fix minimal.
Do not bundle unrelated cleanup/features.

Start from the current stable release.
Implement the smallest safe fix.
Run targeted + required release validation.
Prepare PATCH version and immutable artifact.
Use staging/equivalent smoke before production.

STOP at each human approval gate.
```

Recommended model:
- **TERRA MEDIUM** for straightforward isolated bug;
- **TERRA HIGH** for auth/money/data/migration outage.

---

## 17. Ask “What is the Next Step?”

```text
Determine the NEXT DELIVERY STEP from current repository reality.

Inspect only:
- current integration branch HEAD
- active feature branch/worktree state
- current accepted roadmap/context

Follow applicable AGENTS.md.

Do not implement anything.

Report:
1. what is currently accepted
2. what is still unapproved/in progress
3. the single next coherent work unit
4. which repository/repositories it touches
5. recommended branch name(s)
6. recommended model
7. a short prompt I can paste to start it

Do not create documentation.
```

---

## 18. Design System Gap

```text
A product UI needs this capability:

<capability>

First verify the current @digvation/ui public API.

Classify:
- EXISTING_COMPONENT_CAN_HANDLE_IT
- EXISTING_COMPONENT_NEEDS_EXTENSION
- NEW_DESIGN_SYSTEM_CAPABILITY_REQUIRED

Do not create a local duplicate inside the product app.

If a Design System change is required, propose the smallest generic API and its real consumers.

Do not modify product and Design System in the same uncontrolled pass.
STOP for approval.
```

Recommended model: **TERRA MEDIUM**.

---

# Model cheat sheet

Use this unless a task clearly needs escalation:

| Task | Model |
|---|---|
| CRUD/page/adapter/ordinary vertical slice | TERRA MEDIUM |
| UI consistency / Design System consumption | TERRA MEDIUM |
| routine bug/refactor | TERRA MEDIUM |
| security/auth internals | TERRA HIGH |
| settlement/reconciliation/financial authority | TERRA HIGH |
| difficult migration/concurrency | TERRA HIGH |
| release/deployment gate | TERRA HIGH |
| new app architecture | TERRA HIGH initially |
| new product/ecosystem architecture | SOL |
| major cross-product architecture decision | SOL |

The agent cannot recover wasted tokens by using a stronger model for a trivial task.

Use the cheapest model that matches the decision risk.


---

## 19. New Server / Installation Bootstrap

```text
Prepare a NEW SERVER / INSTALLATION for Digvation.

Target:
<server/provider/environment/client installation>

Follow:
- applicable AGENTS.md
- INFRASTRUCTURE_STANDARD.md
- DELIVERY_RELEASE_STANDARD.md
- SECURITY_ACCEPTANCE_STANDARD.md

This is infrastructure work, not product feature development.

First inspect/resolve:
1. Installation identity and environment
2. isolation mode: SHARED or DEDICATED
3. infrastructure owner: DIGVATION or CLIENT
4. required application components/versions
5. CPU/RAM/disk/network suitability
6. DNS/hostname
7. backup responsibility
8. monitoring responsibility

Then prepare the server using the standard baseline:
- host hardening
- firewall/SSH
- /opt/digvation layout
- container runtime
- ingress/TLS
- private networks
- secrets/config boundary
- backup
- lightweight monitoring/alerts

Do not deploy unapproved application versions.
Do not place source repositories or secrets into Git.

STOP before production traffic switch and report readiness + blockers.
```

Recommended model: **TERRA HIGH**.

---

## 20. Move Installation to Another Server

```text
MIGRATE an existing Digvation Installation to a new server.

Installation:
<installation>

Follow INFRASTRUCTURE_STANDARD.md exactly.

Do not change application product behavior during this migration.

Resolve the currently accepted:
- application versions/build revisions
- deployment manifests/config schema
- database/data backup
- DNS/hostname
- secrets
- monitoring/backup ownership

Bootstrap the destination from the standard, restore state, deploy the SAME
accepted artifacts, verify health/security/backup/monitoring, then prepare the
traffic/DNS cutover.

Keep the old server available for rollback until I explicitly approve the new node.

Do not decommission the old server automatically.
```

Recommended model: **TERRA HIGH**.

---

## 21. Security Acceptance / Pentest Gate

```text
SECURITY ACCEPTANCE REVIEW for:

<product/release/installation>

Follow:
- SECURITY_ACCEPTANCE_STANDARD.md
- INFRASTRUCTURE_STANDARD.md
- DELIVERY_RELEASE_STANDARD.md

This is a security/release gate, not feature development.

Determine the required validation level based on the change risk.

Review/execute applicable:
- dependency/SCA scan
- secret scan
- container image scan
- static security analysis
- auth/RBAC checks
- tenant isolation checks
- TLS/security headers
- network exposure
- staging DAST/runtime checks
- backup/restore readiness
- monitoring/alerting
- penetration-test scope/status

Do not run destructive tests against production without explicit authorization.

Report:
1. PASS / BLOCKED / RISK_ACCEPTANCE_REQUIRED
2. Critical/High/Medium findings
3. exact production blockers
4. required remediation
5. whether deeper/external pentest is required before production

Do not deploy.
```

Recommended model: **TERRA HIGH**.

---

## 22. First-Time Standards Study / Bootstrap

Use this once after placing the standards under `lifecycle/`.

```text
DIGVATION STANDARDS BOOTSTRAP

Work from the `lifecycle/` workspace root.

First read and obey:

- AGENTS.md

Then read these canonical standards once for this bootstrap:

1. standards/README.md
2. standards/ECOSYSTEM_ARCHITECTURE.md
3. standards/ENGINEERING_STANDARD.md
4. standards/DELIVERY_RELEASE_STANDARD.md
5. standards/INFRASTRUCTURE_STANDARD.md
6. standards/CLIENT_INSTALLATION_STANDARD.md
7. standards/SECURITY_ACCEPTANCE_STANDARD.md
8. standards/NEW_PRODUCT_STANDARD.md
9. standards/ECOSYSTEM_ROADMAP.md

Do NOT study standards/PROMPT_LIBRARY.md as permanent agent context.
That file is the user's prompt toolbox.

Then inspect the nested AGENTS.md files for the currently existing repositories/apps.

This task is ONLY to build an accurate Digvation operating model and reconcile
existing local instructions.

Do not:
- modify production code
- run tests/builds
- change application versions
- create releases
- deploy
- create additional documentation

Report:
1. understood instruction hierarchy
2. repository/app-specific instruction coverage
3. conflicting or obsolete existing rules/docs
4. unique durable rules that would be lost if old docs were removed
5. missing repository/app AGENTS.md files
6. recommended cleanup/reconciliation actions

STOP for my approval before changing anything.
```

Recommended model: **TERRA MEDIUM**.

---

## 23. Deploy New Client Installation

```text
PREPARE A NEW CLIENT INSTALLATION.

Client/Product:
<client and product>

Requested deployment:
<DEDICATED_DIGVATION_INFRA | DEDICATED_CLIENT_INFRA | SAAS>

Follow:
- applicable AGENTS.md
- CLIENT_INSTALLATION_STANDARD.md
- INFRASTRUCTURE_STANDARD.md
- DELIVERY_RELEASE_STANDARD.md
- SECURITY_ACCEPTANCE_STANDARD.md

First resolve and report:
1. Installation identity
2. deployment mode
3. environment
4. branding/config requirements
5. exact approved application versions/builds
6. infrastructure responsibility
7. DNS/TLS ownership
8. secrets ownership
9. database/storage plan
10. backup responsibility
11. monitoring responsibility
12. migration/rollback plan

Do not modify product source just because the infrastructure target differs.

If Dedicated Client Infrastructure, run the client-infrastructure preflight before deployment.

If SaaS, use the existing Digvation SaaS platform standard. Do not invent client-specific infrastructure.

STOP before production activation unless I explicitly authorize production.
```

Recommended model: **TERRA HIGH**.

---

## 24. Move Dedicated Client from Digvation Infra to Client Infra

```text
MIGRATE this existing Dedicated Installation from Digvation infrastructure to client infrastructure.

Installation:
<installation>

Follow:
- CLIENT_INSTALLATION_STANDARD.md
- INFRASTRUCTURE_STANDARD.md
- SECURITY_ACCEPTANCE_STANDARD.md

Do not change product behavior or source code.

Preserve the currently accepted application versions unless a separate release has already been approved.

First:
1. capture current component versions/builds
2. validate target client infrastructure preflight
3. resolve DNS/TLS/secrets/backup/monitoring responsibilities
4. prepare verified database/data backup
5. prepare rollback/cutback plan

Then prepare the target environment, restore state, deploy the same accepted artifacts,
verify health/security/smoke/monitoring/backup, and prepare traffic cutover.

Do not decommission Digvation infrastructure until I explicitly approve the new Installation.
```

Recommended model: **TERRA HIGH**.


---

## Scope Contract Update — New Domain / Major Module

Use when a durable domain or major reusable capability is being defined or materially changed.

```text
DIGVATION SCOPE CONTRACT UPDATE

This is architecture/scope documentation only unless I explicitly add implementation scope.

Read:
- applicable AGENTS.md hierarchy
- standards/ECOSYSTEM_ARCHITECTURE.md
- scopes/README.md
- only directly related existing scope contracts

Use Codebase Memory MCP to understand existing implementation and avoid defining a second authority for behavior that already exists.

Scope to define/update:
<DOMAIN / FOUNDATION / SHARED CAPABILITY>

Business intent / workflow:
<USER DEFINITION>

Update the canonical scope contract so it clearly states:
- Kind and Status
- Purpose
- Owns / Authority
- Consumes / Depends On
- Does Not Own
- Backoffice Contribution
- Operational Contribution
- Dashboard Projection
- Report Projection
- Current Scope
- Deferred / Future
- Integration Rules

Do not convert Deferred/Future items into implementation work.
Do not redesign unrelated domains.
If the ecosystem-level boundary itself changes, update ECOSYSTEM_ARCHITECTURE.md; otherwise only update the scope contract.

STOP after the scope update/report unless implementation was explicitly requested.
```

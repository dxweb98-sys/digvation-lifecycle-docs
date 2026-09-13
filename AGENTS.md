# Digvation Global Agent Contract

This file applies to all Digvation repositories and applications under the `lifecycle/` workspace.

Repository/app `AGENTS.md` files may add more specific rules but must not silently weaken this contract.

## 1. Start from repository reality

Before editing a repository:

```bash
git status --short --branch
git log --oneline --decorate -10
```

Fetch when remote freshness matters and determine the actual latest accepted baseline.

Never assume an old SHA, branch state, generated file, migration state, or transport contract when the repository can answer it directly.

Preserve valid user changes.

Do not use destructive Git commands on unknown local work.

## 2. Scope is a hard boundary

Implement only the requested work unit.

Do not automatically:

- start the next roadmap item;
- redesign accepted architecture;
- refactor unrelated modules;
- update another repository unless the requested work genuinely crosses that boundary;
- bump versions;
- create a release;
- deploy;
- write new process documentation.

If an unrelated problem is discovered, report it separately.

Planning labels such as `BO-04`, `CP-02`, internal phase labels, or ticket shorthand must not leak into production:

- branch names;
- commit messages;
- file/folder names;
- variables/functions/types;
- endpoints;
- permissions;
- database objects;
- comments;
- release names.

Use actual domain/responsibility names.

## 3. Determine ownership before implementation

Classify the requested change by actual ecosystem owner:

- CORE control plane;
- business domain authority such as POS, Workshop, Inventory, or another owned domain;
- shared business/platform foundation;
- Backoffice experience;
- Operational experience;
- cross-domain integration;
- database/migration;
- deployment/runtime composition;
- release;
- architecture decision.

Repository names are not ownership authority. Historical `pos` repository/folder names may currently contain code whose durable owner is a different business domain or shared experience.

Use the narrowest correct ownership.

For backend + frontend vertical slices:

1. identify the owning business domain first;
2. verify the existing backend/domain contract;
3. classify backend work as `NO_BACKEND_CHANGE` or `ADDITIVE_BACKEND_WORK_REQUIRED`;
4. do not add backend code if current contracts are sufficient;
5. do not invent frontend authority to avoid a missing backend/domain contract.

Backoffice and Operational are shared experiences. They compose the effective product/capability entitlements granted to the client but do not become the authority for those business domains.

## 4. Reuse before creating

Use:

`REUSE -> EXTEND -> NEW`

Before adding a module/component/helper:

1. find the existing owner;
2. reuse if healthy;
3. extend if the responsibility remains the same;
4. create new only when ownership is genuinely different.

Do not duplicate abstractions because it is faster for one task.

## 5. Production code first

During active implementation, focus on production code.

Do not repeatedly run:

- full test suites;
- workspace-wide typechecks;
- workspace-wide lint;
- prettier;
- broad builds;
- E2E;
- release checks;
- broad repository verification.

Use targeted checks during implementation only when materially useful, especially for:

- authentication/security;
- authorization/RBAC;
- tenant isolation;
- money;
- migrations;
- concurrency/idempotency;
- cross-system contracts.

When the coherent requested work unit is complete, run only the scoped final validation required by the owning repository/app contract.

Full acceptance belongs to explicit acceptance/release gates.

Never claim an unexecuted check passed.

## 6. Manual review is a real gate

`READY_FOR_MANUAL_REVIEW` means:

> implementation is ready for the user to inspect.

It does **not** mean approved.

At that point:

- stop implementation;
- do not commit/push/merge unless explicitly authorized;
- give the exact manual review path and important behaviors to inspect;
- wait for `APPROVE` or `REJECT`.

If rejected:

- remain on the same feature branch/worktree;
- fix only rejected items and necessary regressions;
- do not broaden scope;
- rerun only the permitted scoped validation;
- return to manual review.

If approved:

- follow the accepted-feature finalization flow in `standards/DELIVERY_RELEASE_STANDARD.md`;
- feature approval does not authorize production deployment.

## 7. Git cleanliness

A dirty tree is normal during active work.

An unexplained dirty tree is not acceptable at a gate.

Before handoff, commit, merge, release, or deployment:

- inspect `git status --short`;
- understand every modified/untracked file;
- separate unrelated work;
- do not commit logs, build output, local env files, IDE state, temporary patches, secrets, or generated junk;
- remove task-created dead files/code;
- confirm the staged diff matches the intended work.

Never erase unrelated local work just to obtain a clean tree.

## 8. No code or documentation garbage

If task-created code, files, styles, imports, helpers, flags, scripts, or dependencies are no longer used, remove them before handoff.

Do not leave:

- commented-out old implementations;
- duplicate `v2`, `new`, `temp`, `final-final` files;
- speculative empty modules;
- unused dependencies;
- dead exports;
- abandoned CSS;
- client-specific hacks.

Do not create documentation merely because implementation happened.

Prefer updating an existing canonical owner over creating a new document.

## 9. Clean ownership and naming

Follow `standards/ENGINEERING_STANDARD.md`.

Names describe domain/technical responsibility, not delivery history.

Avoid generic dumping grounds and client-specific source structures.

Do not restructure a healthy tree just to make repositories visually identical.

Clean Architecture is about dependency/ownership boundaries, not forcing one universal folder template.

## 10. Ecosystem boundaries

Follow `standards/ECOSYSTEM_ARCHITECTURE.md`.

Key rules:

- CORE is the control plane.
- Business domains such as POS, Workshop, and Inventory own operational rules/data.
- Backoffice is the shared business-management experience.
- Operational is the shared live-execution experience.
- Product/domain modules contribute to Backoffice and/or Operational; they do not automatically create new permanent UI shells.
- Browser applications do not bypass authoritative business-domain backends for normal behavior.
- No direct cross-domain database or repository shortcut.
- Cross-domain behavior uses explicit contracts/events/APIs/ports/trusted bindings.
- Product entitlement, capability/add-on entitlement, business profile, deployment isolation, infrastructure ownership, operational management, and branding are separate authorities.
- Dedicated or white-label deployment does not grant all products.
- Historical repository names are not architecture authority.
- Existing accepted functionality is moved/re-homed before rewrite when system boundaries change.

## 11. Version and deployment boundaries

API namespace version is not application version.

Every independently deployable service/app owns its own application SemVer and exact build revision.

Do not bump runtime SemVer for every commit.

Do not deploy arbitrary feature branches.

At production, prefer promoting the exact immutable artifact that passed staging.

Follow `standards/DELIVERY_RELEASE_STANDARD.md`.

For server/Installation work, also follow `standards/INFRASTRUCTURE_STANDARD.md`.
For client onboarding, dedicated deployment, client-owned infrastructure, handover, or SaaS Installation work, follow `standards/CLIENT_INSTALLATION_STANDARD.md`.
For production/security acceptance, also follow `standards/SECURITY_ACCEPTANCE_STANDARD.md`.

## 12. Model routing and token discipline

Default implementation model:

`TERRA MEDIUM`

Use `TERRA HIGH` only for material complexity involving:

- security/auth architecture;
- financial/accounting authority;
- settlement/reconciliation;
- difficult migration/concurrency behavior;
- cross-product contract design;
- significant repository restructuring.

Use `SOL` only for genuine architecture ambiguity or decisions with large ecosystem consequences.

Do not escalate because a task has many files.

Do not spend tokens on broad audits when scope and ownership are already known.

## 13. Stop conditions

Stop and report instead of guessing when:

- a required product decision is genuinely ambiguous;
- repository reality contradicts the requested behavior;
- a Design System/public contract lacks a required capability;
- a destructive migration/data operation is required;
- another product contract is required but does not exist;
- production secrets/infrastructure approval are needed;
- human acceptance is required.

Do not invent missing authority.

## 14. Source-of-truth precedence

When sources materially conflict:

1. explicit current user decision;
2. applicable `AGENTS.md` hierarchy;
3. current accepted architecture/domain contract;
4. current repository contracts/implementation;
5. historical checkpoint/review documents;
6. old prompts/chat notes.

If a durable decision changes, update the canonical owner rather than duplicating the new rule elsewhere.

Durable business scope belongs in the applicable `scopes/<SCOPE>.md` contract. Ecosystem-level ownership/composition rules belong in `standards/ECOSYSTEM_ARCHITECTURE.md`. Keep feature prompts/checkpoint details out of durable scope unless they redefine the product/domain envelope.

## 15. Conditional reading — do not read everything every task

Do **not** recursively read all standards/docs before ordinary work.

Read:

- `standards/ECOSYSTEM_ARCHITECTURE.md` for cross-product, client/install, entitlement, deployment-model, or ownership-sensitive work;
- `standards/ENGINEERING_STANDARD.md` when changing structure/shared abstractions or when repository conventions are unclear;
- `standards/DELIVERY_RELEASE_STANDARD.md` at commit/merge/version/release/deploy gates;
- `standards/INFRASTRUCTURE_STANDARD.md` for server, Installation, ingress, backup, monitoring, migration, or client-managed infrastructure work;
- `standards/CLIENT_INSTALLATION_STANDARD.md` for client onboarding, Dedicated Digvation infra, Dedicated client infra, SaaS, handover, or Installation production acceptance;
- `standards/SECURITY_ACCEPTANCE_STANDARD.md` for security-sensitive work and production security acceptance;
- `standards/NEW_PRODUCT_STANDARD.md` only when creating a new product/app/service.

Repository-local `AGENTS.md` may identify one or two additional durable documents for a specific domain.

For business feature/domain work, also read the applicable contract under `scopes/`:

- read `scopes/README.md` when scope ownership/classification is unclear or when adding a new durable domain/module;
- read only the one or two scope contracts materially involved in the current work;
- do not read every scope file for ordinary tasks;
- `Current Scope` is implementable only when the current user task activates it; `Deferred`, `Planned`, or conceptual envelope items are not roadmap authorization.

Do not perform documentation archaeology as a substitute for implementation.


## 16. Documentation creation gate

Do not create documentation as an implementation side effect.

Before creating a new Markdown/process/report file, classify it:

- durable ecosystem architecture;
- durable engineering standard;
- durable repository/app instruction;
- durable public/integration contract;
- release/client operational record explicitly required by the current gate;
- temporary implementation narration.

Only the first five may justify documentation.

Temporary implementation narration belongs in the chat/PR/commit history, not a new repository document.

If an existing canonical file already owns the rule, update that owner instead of creating another file.

## 17. Automatic specialist skill routing

Installed specialist skills are supporting capabilities under this contract, not alternative authorities.

The user does not need to explicitly name or invoke a skill when the task clearly matches its purpose.

Use relevant installed skills automatically when they materially improve the requested work.

### UI / UX

Use the installed `uiuxpromax` skill automatically for work involving:

* frontend UI;
* pages and layouts;
* reusable UI components;
* Design System components;
* forms and interaction states;
* responsive behavior;
* accessibility;
* typography, color, spacing, visual hierarchy, or UX review.

Repository reality and the Digvation Design System remain authoritative.

Prefer existing Digvation components, tokens, patterns, and dependencies.

Do not introduce a new UI framework, component library, icon library, styling system, or dependency merely because the skill recommends one.

### Pull request review feedback

Use `gh-address-comments` automatically when work involves:

* pull-request review comments;
* reviewer feedback;
* requested changes;
* unresolved review threads.

Inspect and classify feedback before implementation.

A reviewer suggestion is not automatically authoritative.

Classify relevant feedback as:

* accept;
* reject with technical rationale;
* clarification required;
* already resolved.

Apply the manual-review, scope, Git, and delivery gates in this contract.

Do not resolve threads, reply remotely, commit, push, or merge unless the current lifecycle state authorizes it.

### CI failures

Use `gh-fix-ci` automatically when work involves:

* failing GitHub Actions;
* failed PR checks;
* CI failures;
* requests to diagnose why a GitHub pipeline is red.

Find the first meaningful failure and determine the actual root cause before editing code.

Distinguish:

* application/code failure;
* test failure;
* typecheck/lint failure;
* dependency failure;
* environment/infrastructure failure;
* flaky or unrelated failure.

Fix only failures owned by the requested work unit unless explicitly asked to broaden scope.

Follow the normal implementation and validation gates in this contract.

### Security-sensitive work

For authentication, authorization, permissions, tenant isolation, credentials, payments, sensitive data, database authority, uploads, webhooks, external callbacks, or other security boundaries:

* apply the applicable Digvation security standards;
* use available Codex security-review capabilities when materially useful;
* prefer existing repository security tooling;
* do not add third-party security dependencies merely to perform a review.

### Skill governance

Skill instructions never override:

1. explicit current user decisions;
2. this Digvation Global Agent Contract;
3. applicable repository `AGENTS.md`;
4. accepted architecture and domain ownership;
5. current repository contracts.

Do not invoke unrelated skills merely because they are installed.

Do not load multiple specialist skills when one is sufficient.

Prefer implicit skill selection so normal user requests remain concise.

## Codebase Memory

Codebase Memory MCP is the preferred structural discovery layer when available.

Rules:

- Keep `/lifecycle` as the orchestration root.
- Treat each nested Git repository as its own Codebase Memory project.
- Use Codebase Memory before broad repository-wide grep/find exploration.
- Select the graph matching the repository currently being modified.
- Use graph queries to locate relevant symbols, callers, callees, routes,
  dependencies, and likely change impact.
- Query another indexed repository only when cross-repository contracts or
  dependencies are materially relevant.
- Verify important graph findings against the actual source before editing.
- Use Codebase Memory change-impact information to help choose targeted
  validation after implementation.
- Missing graph results are not proof that code or dependencies do not exist.
- AGENTS.md, lifecycle standards, accepted architecture, source code, Git state,
  and tests remain authoritative.
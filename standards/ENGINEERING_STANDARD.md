# Digvation Engineering Standard

## 1. Standardization goal

Every Digvation repository should feel like part of the same engineering organization without forcing unrelated technologies/domains into one identical folder tree.

Consistency means shared principles for:

- ownership;
- dependency direction;
- naming;
- Git cleanliness;
- tree quality;
- testing cadence;
- configuration;
- security;
- observability;
- release readiness.

Clean Architecture is a dependency discipline, not a folder cosplay exercise.

## 2. Clean Architecture

Business/domain policy must not directly depend on transport, framework, UI, database, or vendor details.

Typical backend dependency direction:

```text
domain
  <- application / use cases
      <- ports / contracts
          <- adapters / infrastructure
              <- HTTP / runtime composition
```

Exact folder names may vary.

Required outcome:

- domain owns business vocabulary/rules;
- application orchestrates use cases;
- ports/contracts describe required capabilities;
- infrastructure implements ports;
- controllers/transport translate external requests;
- runtime composition wires dependencies.

Do not import raw database/framework clients into domain code for convenience.

Typical frontend separation:

```text
app/runtime/shell
features/routes
query-command/application boundaries
API/data adapters
domain/view models
UI composition
```

UI components must not become the authoritative owner of server/financial truth.

## 3. Ownership-oriented source tree

Prefer domain/feature ownership.

Good examples:

```text
modules/
  catalog/
  auth/
  payments/
  settlement/

features/
  catalog/
  employees/
  business-settings/
```

Avoid dumping grounds:

```text
utils/
common/
misc/
helpers/
temp/
new/
```

A `shared` area is valid only when shared ownership is real and has multiple legitimate consumers.

Do not create client-specific source trees.

Do not reorganize a healthy repository merely to make it visually match another project.

## 4. Naming

Use canonical domain vocabulary consistently across:

- database;
- backend;
- API;
- frontend;
- tests;
- docs.

Good:

- `selling-location.service.ts`
- `payment-routing.repository.ts`
- `business-settings-page.tsx`
- `revenue-summary.query.ts`

Avoid:

- roadmap/ticket labels;
- client names;
- `foo2`;
- `new-foo`;
- `final-foo`;
- `temp-*`;
- `backup-*`.

Names should reveal responsibility.

Avoid vague `Manager`, `Helper`, or `Utils` abstractions that collect unrelated behavior.

## 5. Functions/classes/types

Prefer intention-revealing units.

A function/class should have one coherent responsibility.

Do not introduce wrappers that only rename another primitive without adding ownership or behavior.

Do not duplicate domain types in multiple layers without a translation reason.

## 6. Dead code policy

Before handoff remove task-created:

- unused imports/exports;
- unused files;
- abandoned helpers/components;
- unused dependencies;
- superseded code paths;
- commented-out implementations;
- stale CSS;
- temporary debug statements.

Do not keep unused code “for later”.

Git history is the archive.

Do not broaden a feature to clean unrelated legacy code; report unrelated debt separately.

## 7. Reuse before new code

Use:

`REUSE -> EXTEND -> NEW`

Before creating a reusable abstraction:

1. inspect current owner;
2. reuse;
3. extend if same responsibility;
4. create new only for a real boundary.

Avoid speculative shared code.

## 8. Design System rule

For Digvation web applications, the canonical Design System is authoritative for reusable UI primitives.

If a suitable Design System component exists, use it.

Application code owns composition, feature behavior, and page layout — not duplicate buttons, tables, pagination, dialogs, inputs, tooltips, etc.

If the Design System cannot satisfy a real requirement:

1. identify the exact capability gap;
2. decide whether the capability belongs in Design System;
3. do not silently create a duplicate local primitive.

For current POS UI, use `@digvation/ui`.

## 9. App-level UI consistency

Each app owns a consistent composition standard for:

- page width/gutters;
- responsive layout;
- shell/header/sidebar;
- spacing;
- page actions;
- loading/empty/error states;
- forms;
- dialogs;
- tables/lists;
- pagination.

If a shared UI rule changes, apply it cross-cutting to all current relevant pages.

Do not make users request the same consistency fix page by page.

## 10. Server-state authority

Frontend state is not a second server database.

Use query/cache mechanisms for server state.

Use local state for local interaction state.

Do not compute authoritative accounting/revenue/settlement results in UI merely because raw data is available.

## 11. Database and migration rules

Migrations are additive and reviewable.

Do not rewrite accepted historical migrations to make new work easier.

Production upgrade paths must work against an existing maintained database, not only a fresh database.

Destructive migrations require:

- explicit data migration plan;
- backup/rollback consideration;
- human approval.

Tenant isolation constraints must live at authoritative boundaries.

## 12. API and integration contracts

Use stable domain vocabulary.

Application SemVer is separate from API namespace.

`/api/v1` describes contract namespace/lifecycle, not which binary/app version is currently deployed.

Cross-product integrations must use explicit compatible contracts.

Generated API clients, when used, must not be manually edited.

## 13. Runtime configuration

Configuration belongs outside source code when it varies by installation/environment.

Use runtime/environment configuration for:

- endpoints;
- infrastructure bindings;
- branding/presentation;
- deployment settings;
- legitimate feature/config flags;
- secret references.

Never commit real secrets.

Do not encode client identity as source branching behavior.

## 14. Security baseline

Internet-facing services/apps should support, where applicable:

- authentication;
- authorization;
- input validation;
- safe error handling;
- secret isolation;
- dependency vulnerability awareness;
- logs without secret leakage;
- secure production defaults;
- tenant isolation;
- least-privilege integration credentials.

Security-sensitive changes justify early targeted validation.

## 15. Observability baseline

Production deployables should expose enough information to determine:

- application version;
- build revision;
- environment;
- health/readiness;
- startup/migration failure;
- runtime/request failures;
- deployment identity when safe.

Do not log tokens/passwords/secrets or unnecessary sensitive client data.

## 16. Loading/error/empty behavior

Data-driven UI must intentionally represent:

- loading;
- empty;
- permission denied;
- validation error;
- network/server error;
- retry when appropriate.

Do not use silent failure as UX.

## 17. Pagination and scale

Potentially unbounded domain data should be server-paginated when contracts support it.

Do not fetch arbitrary “large enough” limits as a permanent design.

Do not fake server pagination by slicing a full dataset if server-side scale is expected.

## 18. Dependency policy

Every dependency needs a purpose.

Prefer established project/platform libraries over one-off replacements.

Remove task-created dependencies that end unused.

Do not add a large library for trivial functionality already provided by the stack.

## 19. Documentation restraint

Do not create a new document for:

- every feature;
- every fix;
- every agent run;
- every manual review;
- every commit.

Update canonical docs only when durable truth changes.

## 20. Feature-scoped validation

Ordinary feature implementation uses the narrowest validation that proves the changed work is correct.

Default rule:

- test the feature/module being changed;
- typecheck the affected app/package/module;
- run focused lint/build checks only when they materially validate the change;
- do not run repository-wide or workspace-wide validation merely as a precaution.

Do not substitute nearby but unrelated regression suites for a missing feature test. If focused coverage does not exist, add or extend a focused test owned by the changed feature and execute it directly.

Unrelated repository failures are baseline debt unless the current change caused them. Record them separately, do not fix or repeatedly rerun them, and do not broaden the feature scope because they exist.

A focused test that hangs or emits no actual result is `INCONCLUSIVE`, not passed. Diagnose the focused test or harness rather than using unrelated broad suites as substitute evidence.

Broad/full test suites, workspace-wide typecheck/lint/build, broad E2E, and full regression are reserved for explicit gates such as:

- direct user request;
- repository contracts that explicitly require broad validation for the current work;
- genuinely shared infrastructure changes that cannot be validated safely through narrower consumers;
- integration, release, staging, production, or full-regression acceptance.

Feature completion alone is not a full-regression gate.

Validation reports must distinguish focused checks that actually ran, actual results, baseline/unrelated failures, and deferred broad regression. Compilation alone is not evidence that feature tests passed.

## 21. Definition of clean implementation

A work unit is clean when:

- ownership is obvious;
- dependency direction is healthy;
- no duplicate domain/UI authority was introduced;
- no task-created dead code remains;
- naming uses canonical vocabulary;
- no client-specific source behavior exists;
- diff is limited and explainable;
- required scoped validation passes;
- manual review can be executed predictably.

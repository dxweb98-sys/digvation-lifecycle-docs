# Digvation New Product / Service / App Standard

Use this only when creating a genuinely new Digvation product, service, application, or independently deployable component.

## 1. Decide what is being created

Classify:

- new Product;
- new backend Service;
- new frontend App;
- new shared Platform capability;
- new integration adapter.

Do not create a new product when the capability clearly belongs to an existing domain owner.

## 2. Product ownership statement

Before implementation, create or update one readable lifecycle scope contract under `../scopes/` using `../scopes/README.md`. That contract is the durable product/domain/module scope authority.

Before implementation define:

- product purpose;
- owned operational domains;
- data authority;
- users/personas;
- what CORE controls for it;
- integrations with existing products;
- what it explicitly does **not** own.

This should fit on one page. Keep `Current Scope` separate from `Deferred / Future` so agents can understand the larger domain without treating the whole envelope as implementation authority.

## 3. CORE registration model

For a new business product/domain determine:

- Product identity;
- ProductFeatures;
- Subscription/Entitlement implications;
- Backoffice/Operational module contribution;
- Installation/runtime-composition model;
- deployment isolation options;
- infrastructure ownership options;
- component/domain versions that CORE should track.

Do not make normal product runtime synchronously dependent on CORE unless an explicit architecture requirement needs it.

## 4. Repository decision

Create a new repository only when deployment/ownership/lifecycle justify it.

Do not split repositories merely for visual symmetry.

Every repository needs:

- root `AGENTS.md`;
- README with local setup;
- license/ownership policy if applicable;
- `.gitignore`;
- environment example without secrets;
- formatter/linter/typecheck/build scripts appropriate to stack;
- CI baseline;
- version source;
- Dockerfile if independently deployable;
- `.dockerignore`.

## 5. Clean Architecture baseline

Define:

- domain/application/infrastructure boundaries;
- dependency direction;
- configuration boundary;
- external integration ports;
- error model;
- authentication/authorization boundary where needed;
- tenant/isolation boundary where needed.

Do not generate dozens of empty folders before real ownership exists.

## 6. Data baseline

If it owns persistence:

- database ownership;
- migration strategy;
- backup expectations;
- tenant/isolation model;
- seed strategy;
- local development strategy;
- production upgrade strategy.

No cross-product direct DB access.

## 7. API/integration baseline

Define:

- public/internal APIs;
- contract namespace strategy;
- integration events/messages where needed;
- idempotency/retry needs;
- authentication/trust boundary;
- compatibility policy.

Do not confuse API namespace with application SemVer.

## 8. Experience baseline

For a new business domain, first define which capabilities it contributes to the shared Digvation experiences:

- Backoffice — management/configuration/supervision/reporting;
- Operational — live day-to-day execution.

Do not create a product-specific permanent UI shell merely because a new domain is added.

Create a genuinely new frontend app only when a real device/runtime/security/operational boundary requires it.

For any new frontend app/module define:

- routing;
- auth/session boundary;
- server-state strategy;
- entitlement/permission/location composition;
- Design System package;
- app shell/composition standard;
- error/loading/empty behavior;
- responsive expectation;
- version/About visibility.

Do not use business type, client name, deployment mode, or white-label status as product-entitlement authority.

Do not build a second local Design System.

## 9. Security baseline

Before first production:

- secret handling;
- auth/authz;
- input validation;
- dependency audit process;
- safe error/logging;
- CORS/cookie/token policy where applicable;
- tenant boundary;
- least-privilege integration credentials.

## 10. Observability baseline

Have:

- structured logs where appropriate;
- health/readiness;
- application version/build metadata;
- error visibility;
- deployment identity;
- basic operational metrics appropriate to system criticality.

## 11. Version baseline

Each independently deployable component gets its own SemVer source.

Also expose exact build revision.

Define which repository branch is:

- development integration;
- stable.

Define release tagging before first release.

## 12. Container/deployment baseline

Every independently deployable component should have:

- Dockerfile;
- `.dockerignore`;
- deterministic production build;
- no embedded secrets;
- environment configuration;
- health/readiness where applicable;
- immutable image/artifact CI flow.

Define:

- development environment;
- staging/equivalent;
- production deployment target;
- rollback method.

Server/Installation setup must follow `INFRASTRUCTURE_STANDARD.md`.
Client deployment modes and onboarding must follow `CLIENT_INSTALLATION_STANDARD.md`.
First-production security acceptance must follow `SECURITY_ACCEPTANCE_STANDARD.md`.

## 13. Testing baseline

Before coding hundreds of features, establish:

- unit/integration strategy;
- database test strategy where relevant;
- contract/API test strategy;
- frontend component/E2E strategy where relevant;
- scoped development checks;
- full release gate.

Do not run full acceptance after every edit.

## 14. First feature flow

The first feature must use the same normal lifecycle:

```text
feature branch
 -> production code
 -> scoped validation
 -> manual review
 -> approve/reject
 -> merge development
```

Do not invent a temporary “prototype workflow” that becomes permanent.

## 15. First release gate

Before first production:

- domain ownership reviewed;
- architecture boundaries reviewed;
- Git tree clean;
- no unused scaffolding;
- exact versions/builds known;
- full relevant validation passes;
- migrations tested on existing DB path where applicable;
- images/artifacts built;
- staging/equivalent acceptance passes;
- configuration/secrets ready;
- backup/rollback ready;
- human production approval given.

## 16. After first release

Register/track the product Installation and deployed component versions in CORE as the control-plane capability becomes available.

Future Digvation products should integrate through explicit ecosystem contracts, not ad-hoc database coupling.

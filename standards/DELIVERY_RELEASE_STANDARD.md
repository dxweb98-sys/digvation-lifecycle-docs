# Digvation Delivery, Git, Versioning and Deployment Standard

> Architecture note: POS-specific names in examples are historical/current component examples. Current ecosystem ownership follows `ECOSYSTEM_ARCHITECTURE.md`; Backoffice and Operational are shared experiences and POS is a business domain.

## 1. Branch roles

Every repository identifies:

- stable branch — normally `main`;
- development integration branch — repository-specific;
- short-lived feature/fix/refactor branches.

Current POS examples:

```text
POS Backend
feature/fix branch
  -> digvation-pos-dev
  -> main

POS Web
feature/fix branch
  -> dev
  -> main
```

Do not implement directly on stable or integration branches.

Do not create client-specific source branches.

## 2. Branch naming

Use responsibility-oriented names:

```text
feat/catalog-management
feat/employee-management
feat/payment-routing
feat/revenue-analytics
fix/backoffice-shell
fix/receipt-printing
refactor/auth-session
```

Do not use:

- roadmap labels such as `bo-04`;
- checkpoint labels;
- client names;
- vague names such as `fix-stuff`.

## 3. Commit message standard

Use concise Conventional Commit style:

```text
feat(catalog): add item variant management
fix(backoffice): align dialog actions
fix(receipt): support thermal print widths
refactor(auth): simplify session composition
chore(release): prepare 0.4.0
```

Rules:

- describe actual behavior/responsibility;
- use canonical scope;
- no roadmap labels;
- no client-specific delivery labels;
- one commit should represent a coherent accepted change;
- avoid noisy commits for formatting/checkpoint narration.

A feature branch may contain working commits, but the accepted integration history should remain understandable.

Squash when it meaningfully removes noisy implementation history; do not squash merely as ritual.

## 4. Feature delivery state machine

```text
LATEST ACCEPTED INTEGRATION BASELINE
        |
        v
FEATURE BRANCH
        |
        v
IMPLEMENT COHERENT WORK UNIT
        |
        v
TARGETED CHECKS ONLY WHEN MATERIALLY USEFUL
        |
        v
COMPLETE REQUESTED FEATURE/PAGE/SLICE
        |
        v
ONE SCOPED FINAL VALIDATION
        |
        v
READY_FOR_MANUAL_REVIEW
        |
        +---- REJECT ----> REMEDIATE SAME BRANCH
        |                     |
        |                     +--> scoped validation
        |                     +--> manual review again
        |
        +---- APPROVE ---> COMMIT/PUSH AS AUTHORIZED
                              |
                              v
                         MERGE TO DEV
                              |
                              v
                             STOP
```

Do not start the next roadmap item automatically.

## 5. Cross-repository vertical slice

Backend and frontend may form one product slice while remaining separate Git repositories.

Flow:

1. identify required product behavior;
2. inspect backend contract first;
3. use existing backend contract if sufficient;
4. add only missing additive backend capability;
5. implement frontend against verified contract;
6. validate each changed repository with its own scoped gate;
7. perform human/manual review;
8. approve/reject;
9. commit/push/merge repositories independently;
10. record compatibility at release boundary when needed.

Do not create duplicate frontend business authority because backend work is inconvenient.

## 6. Manual review standard

When implementation reaches manual review, report:

- what changed;
- exact screen/API/flow to open;
- exact actions to try;
- expected outcome;
- known intentional limitations;
- scoped validation result.

Do not give a giant QA plan for a small UI change.

Human approval is explicit.

`READY_FOR_MANUAL_REVIEW != APPROVED`.

## 7. Git cleanliness at gates

Before commit/merge/release/deployment:

```bash
git status --short --branch
git diff --stat
```

At a final integration/release gate:

- no unexplained modified/untracked files;
- no unrelated changes;
- no secrets/local env/build output/logs;
- no task-created dead files;
- staged diff matches intended scope.

A working branch may be dirty while actively implementing.

## 8. Application versioning

Each independently deployable artifact owns its own SemVer.

Examples:

- CORE Service;
- CORE UI;
- POS Service;
- POS Cashier;
- POS Backoffice;
- future Workshop Service/UI;
- future Accounting Service/UI.

A monorepo does not force one runtime version.

Commit SHA is not an application version.

Use:

```text
applicationVersion = semantic release version
buildRevision      = exact Git SHA / CI revision
```

SemVer changes at meaningful accepted release boundaries, not every edit/commit.

General classification:

- PATCH — backward-compatible fixes;
- MINOR — backward-compatible product capability;
- MAJOR — intentionally incompatible product/runtime contract.

Pre-release versions such as `0.x.y-alpha.n` / `-rc.n` are allowed when the repository release strategy uses them.

## 9. Application version != API namespace

Do not use API namespace as deployed app version.

Examples:

```text
API namespace: /api/v1
POS Service app version: 0.4.0
Build revision: a1b2c3d
```

Keep them separate.

## 10. Version visibility to operators/clients

Every deployable should make safe runtime metadata available.

At minimum:

- application name/component;
- application version;
- build revision;
- environment;
- build/deploy timestamp if useful.

Frontend may expose this in an About/Diagnostics surface.

Backend may expose it through safe health/metadata output.

CORE should eventually record deployed component versions per Installation.

Do not expose secrets or sensitive infrastructure data.

## 11. Release candidate boundary

Accepted features may accumulate on development integration branches.

They do not automatically become production.

A release starts only when release scope is explicitly locked.

Before Release Candidate:

- selected source SHA(s) are known;
- working trees are clean;
- runtime versions are finalized/classified;
- backend/frontend compatibility is known;
- migration path is identified.

Then execute the full release gate.

## 12. Full release gate

The exact repository commands may differ, but a production release should cover applicable:

- compile/typecheck;
- full relevant automated tests;
- lint/static checks used by repository CI;
- production build;
- migration/schema validation;
- upgrade from an existing database;
- backend/frontend contract reconciliation;
- security-sensitive validation;
- configuration validation;
- artifact creation;
- smoke test plan;
- rollback/backup readiness.

Full release checks are run on the exact intended release SHA/artifact, not repeatedly after every small implementation edit.

## 13. Docker/container standard

Every independently deployable service/app must be reproducibly containerizable unless an explicitly approved deployment target does not use containers.

Required:

- repository/app-owned `Dockerfile`;
- `.dockerignore`;
- deterministic build;
- production target/stage;
- development target/stage when useful for local/container development;
- no secrets baked into images;
- minimal production runtime;
- non-root execution where the stack supports it;
- explicit ports/runtime command;
- health/readiness integration where applicable;
- image labels/build metadata when useful.

Frontend static apps may use a build stage plus a minimal web server/runtime stage.

Docker Compose is allowed for local/integration convenience but is not the production architecture authority.

## 14. Build once, promote

Preferred release:

```text
Git SHA
  -> CI
  -> immutable image/artifact
  -> staging
  -> accepted
  -> SAME artifact
  -> production
```

Do not rebuild different production bits after staging acceptance when promotion is possible.

Tag artifacts with version plus immutable build identity.

Example conceptually:

```text
digvation/pos-service:0.4.0
digvation/pos-service:sha-a1b2c3d
```

## 15. Environment configuration

The same source/artifact supports different installations/environments through external configuration.

Do not build client-specific source artifacts merely for branding/deployment ownership.

Separate:

- application artifact;
- environment;
- installation;
- branding config;
- secrets;
- infrastructure target.

## 16. Staging gate

Before production:

- deploy the intended release artifact to staging or an equivalent pre-production environment;
- apply the intended migration path;
- validate service health;
- perform smoke/integration checks;
- validate critical user flows;
- review runtime errors/logs;
- confirm version/build identity.

For client-managed dedicated infrastructure, an equivalent acceptance environment/process may be agreed, but the artifact must remain traceable.

## 17. Production approval gate

Production deployment requires explicit human approval.

Minimum readiness:

- RC accepted;
- exact artifact/image known;
- staging/equivalent acceptance passed;
- migrations understood;
- backup/rollback ready;
- required configuration/secrets present;
- deployment target/Installation identified;
- release notes/known issues available when relevant.

Do not deploy because a feature was merely approved.

## 18. Production deployment

Deployment should consume immutable artifacts, not compile source manually on the server.

Preferred:

```text
GitHub/CI
 -> registry/artifact store
 -> target Installation pulls/promotes artifact
```

Server owns runtime state such as:

- manifests;
- configuration;
- secrets;
- data;
- backups;
- logs.

Source control remains the code authority.

## 19. Post-deploy verification

After production:

- verify expected application/build version;
- verify health/readiness;
- verify migration status;
- execute critical smoke flow;
- inspect errors/logs;
- confirm externally reachable behavior;
- record deployment state/version in the appropriate control-plane/ops system when available.

## 20. Rollback

Every production release needs an understood rollback path.

Rollback may include:

- previous immutable application artifact;
- configuration rollback;
- forward-fix migration if DB rollback is unsafe;
- backup restore only when explicitly necessary.

Never assume a destructive database migration can be safely reverted.

## 21. Hotfix flow

Production hotfix:

```text
stable release
 -> dedicated fix branch
 -> minimal fix
 -> targeted validation
 -> explicit review
 -> required release gate
 -> PATCH version
 -> immutable artifact
 -> staging/equivalent smoke
 -> production approval
 -> production
 -> reconcile development branch
```

Do not leave a production hotfix only on `main` without reconciling active development.

## 22. Infrastructure and security acceptance

Before a production release is accepted:

- target server/Installation must conform to `INFRASTRUCTURE_STANDARD.md`;
- release security gate must conform to `SECURITY_ACCEPTANCE_STANDARD.md`;
- first public releases and major security/tenant/payment/network changes require deeper security assessment;
- production approval requires both application release readiness and infrastructure/security readiness.

A feature approval is never equivalent to production security approval.


## 23. CI and branch protection baseline

Policy should be enforced by automation wherever practical.

For stable and development integration branches:

- direct implementation commits should be avoided;
- required CI checks must pass before accepted merge/release;
- force-push should be disabled on stable branches;
- release tags must reference accepted source;
- CI must build from committed source, not untracked local files;
- release artifacts must be traceable to exact Git SHA;
- secrets must come from protected CI/environment stores;
- production deployment jobs require explicit approval;
- production deployment should consume an already accepted immutable artifact.

Repository CI should separate:

```text
fast feature checks
release acceptance checks
artifact build/publish
deployment promotion
```

Do not make every tiny feature edit pay the full production-release cost.

## 24. Release evidence

A production release should be reconstructable from:

- component/application version;
- Git SHA;
- immutable image/artifact digest;
- migration version/state;
- CI run;
- target Installation/environment;
- deployment timestamp;
- approval result;
- post-deploy health result.

As CORE Installation capabilities mature, this metadata should be recorded centrally instead of maintained as ad-hoc per-client documents.

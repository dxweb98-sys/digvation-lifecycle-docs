# Digvation Client Installation Standard

This is the canonical standard for how the Digvation Business Platform and its entitled business domains are deployed for clients.

It applies to Backoffice, Operational, POS, Workshop, Inventory, Accounting, and future Digvation components/domains unless a later approved architecture explicitly changes the model.

`ECOSYSTEM_ARCHITECTURE.md` is authoritative for system/domain ownership. Historical repository names such as `digvation-pos-*` do not redefine the deployment boundary.

The standard intentionally supports only these operational deployment cases:

1. Dedicated Installation on Digvation infrastructure.
2. Dedicated Installation on client infrastructure.
3. Shared/SaaS Installation operated under the Digvation platform standard.

Shared/SaaS is always Digvation-operated and does not introduce a client-specific infrastructure mode.

## 0. Installation composition rule

An Installation is not synonymous with a single product backend.

A client may have multiple product and capability entitlement records while one runtime composition delivers the effective entitled capabilities through shared experiences and domain runtimes.

Conceptually:

```text
Client
  -> Product Entitlements
       - POS
       - Workshop
       - Inventory
  -> Capability / Add-on Entitlements
       - Promotions (example)
       - Loyalty Points (example)
  -> Installation
       -> Runtime Composition
            - Backoffice
            - Operational
            - entitled domain runtime(s)
```

Backoffice and Operational are platform experiences. They are not automatically separate commercial products.

A dedicated/white-label client receives only its effective entitled products and capabilities. Dedicated deployment, client-owned infrastructure, or white-label branding never grants all Digvation products or add-ons.

---

## 1. Core rule: canonical source, no client forks

A client deployment must never create a source-code fork.

Forbidden:

```text
branch-client-a
branch-nova
repo-pos-client-x
client-specific backend fork
client-specific frontend fork
```

Required:

```text
ONE CANONICAL SOURCE LINE PER COMPONENT/DOMAIN
ONE AUTHORITATIVE OWNER PER BUSINESS CONCEPT
NO CLIENT SOURCE FORKS
```

Client/install differences are expressed through:

- Installation configuration;
- branding configuration;
- product/capability entitlements and resolved features;
- environment configuration;
- infrastructure target;
- secrets;
- deployment manifests;
- operational data.

Never implement client-specific behavior as:

```text
if client == "Nova"
```

unless a real product capability has first been modeled generically.

---

## 2. Installation is the deployment boundary

Deployment-specific properties belong to `Installation`, not permanently to `Client`.

Conceptually:

```text
Client
  -> Product + Capability Entitlements
  -> Installation
       -> Runtime Composition
```

An Installation identifies one concrete logical/deployed runtime boundary for the client/environment and the composition through which entitled capabilities are delivered.

Relevant properties may include:

```text
environment
isolation
infrastructureOwner
managementMode
brandingProfile
entitledDomainBindings
deployedComponents
deploymentState
```

A client may have more than one Installation over time or across environments.

---

## 3. Supported deployment modes

### Mode A — Dedicated / Digvation Infrastructure

```text
Isolation: DEDICATED
Infrastructure Owner: DIGVATION
Operations: DIGVATION
```

The runtime is exclusive to one client.

Digvation owns and operates the hosting environment.

Typical shape:

```text
Digvation Infrastructure
└── Client Installation
    ├── Backoffice
    ├── Operational
    ├── entitled business-domain runtime(s)
    ├── private application network
    ├── domain-owned persistence as required
    ├── secrets/configuration
    ├── persistent storage
    ├── backup
    ├── monitoring
    └── ingress/TLS
```

This is the default dedicated model when the client wants Digvation to host and operate the system.

### Mode B — Dedicated / Client Infrastructure

```text
Isolation: DEDICATED
Infrastructure Owner: CLIENT
```

The runtime remains exclusive to one client.

The product source code and release artifacts are the same as Digvation-hosted dedicated deployments.

Only the infrastructure target and responsibility boundary differ.

Typical shape:

```text
Client Infrastructure
└── Client Installation
    ├── approved Backoffice artifact
    ├── approved Operational artifact
    ├── approved entitled domain runtime artifact(s)
    ├── private network
    ├── domain-owned persistence as required
    ├── client/Digvation agreed secrets
    ├── backup
    ├── monitoring
    └── ingress/TLS
```

Client infrastructure must satisfy the Digvation infrastructure baseline before production acceptance.

### Mode C — Shared / SaaS

```text
Isolation: SHARED
Infrastructure Owner: DIGVATION
Operations: DIGVATION
```

Shared/SaaS is operated under Digvation infrastructure and platform rules.

There is no separate "client-hosted SaaS" deployment model.

Individual SaaS clients do not receive unique infrastructure behavior.

Variation is limited to legitimate:

- tenant data;
- product/capability entitlements and resolved features;
- branding when product policy allows;
- business configuration.

The shared runtime follows the same Digvation release, security, monitoring, backup, and infrastructure standards.

---

## 4. Dedicated does not mean different product behavior

Dedicated deployment changes runtime isolation, not business-domain semantics or product/capability entitlement.

The same POS, Workshop, Inventory, Accounting, or other domain must behave according to the same canonical domain rules in:

- Dedicated / Digvation infrastructure;
- Dedicated / Client infrastructure;
- Shared/SaaS.

Do not create dedicated-only source behavior simply because the database/runtime is isolated.

A dedicated deployment must remain tenant-aware where the product architecture requires tenant/runtime scope.

---

## 5. Branding is separate from deployment mode

White-label is not a deployment type.

Valid examples:

```text
DEDICATED + DIGVATION INFRA + WHITE LABEL
DEDICATED + CLIENT INFRA + WHITE LABEL
DEDICATED + DIGVATION INFRA + DIGVATION BRAND
SHARED/SaaS + DIGVATION PLATFORM RULES
```

Branding/configuration does not create a source fork.

---

## 6. Product creation must declare supported deployment modes

When a new Digvation product/system is created, its initial architecture must explicitly answer:

```text
Does this product support Dedicated / Digvation Infrastructure?
Does this product support Dedicated / Client Infrastructure?
Does this product support Shared/SaaS?
```

Default Digvation expectation for reusable business products:

```text
Dedicated / Digvation Infrastructure: SUPPORTED
Dedicated / Client Infrastructure: SUPPORTED
Shared/SaaS: ARCHITECTURALLY VIABLE
```

A product may initially ship dedicated-first, but the domain/source architecture must not deliberately prevent future shared/SaaS operation unless explicitly approved.

---

## 7. Dedicated / Digvation Infrastructure responsibilities

Digvation is responsible for the production hosting baseline.

At minimum:

- server/compute;
- supported OS/runtime;
- host hardening;
- SSH/firewall;
- Docker/container runtime;
- reverse proxy/ingress;
- TLS;
- DNS configuration under Digvation-controlled scope;
- private network;
- database/runtime storage;
- production secrets;
- backup;
- offsite backup;
- monitoring;
- alerts;
- server patching;
- product deployment;
- migrations;
- rollback;
- post-deploy smoke verification.

Exact commercial SLA/support commitments are contractual and not defined by this engineering standard.

---

## 8. Dedicated / Client Infrastructure responsibilities

Client infrastructure is allowed only if the target environment satisfies Digvation deployment requirements.

Before implementation or deployment, responsibility must be explicit for:

- server/VM provisioning;
- operating system;
- network/firewall;
- DNS;
- TLS/domain ownership;
- remote administration access;
- secrets ownership;
- database/storage;
- backups;
- offsite backup;
- monitoring;
- alert routing;
- OS patching;
- incident response;
- infrastructure replacement;
- product deployment access.

### Default technical responsibility model

Unless an agreement says otherwise:

Client provides and owns:

- infrastructure account/VM/server;
- underlying network;
- required DNS/domain access;
- infrastructure billing;
- client-controlled credentials/secrets where applicable.

Digvation provides:

- supported infrastructure requirements;
- product Docker images/artifacts;
- deployment manifests/templates;
- application configuration schema;
- application migrations;
- product deployment procedure;
- product release/version information;
- product-level smoke test;
- product-level troubleshooting/support as agreed.

Whether Digvation also operates the client's server after installation must be explicitly agreed.

Do not assume permanent root/admin access to client infrastructure.

---

## 9. Client infrastructure preflight gate

A Dedicated / Client Infrastructure Installation is BLOCKED until the environment passes preflight.

Minimum:

```text
[ ] supported OS/runtime
[ ] sufficient CPU/RAM/disk
[ ] stable network
[ ] required inbound ports available
[ ] required outbound access available
[ ] DNS ownership/access resolved
[ ] TLS/certificate approach resolved
[ ] SSH/admin access agreed
[ ] firewall policy compatible
[ ] Docker/container runtime supported
[ ] private database/network possible
[ ] persistent storage available
[ ] backup responsibility accepted
[ ] offsite backup path accepted
[ ] monitoring responsibility accepted
[ ] production secrets delivery method accepted
[ ] rollback responsibility accepted
```

Do not begin production cutover while these are ambiguous.

---

## 10. Standard client onboarding flow

Every client runtime deployment should follow the same high-level lifecycle.

```text
CLIENT
  ↓
CLIENT PRODUCTS / COMMERCIAL ENTITLEMENTS CONFIRMED
  ↓
INSTALLATION + RUNTIME COMPOSITION DEFINED
  ↓
REQUIRED DOMAIN COMPONENTS RESOLVED
  ↓
DEPLOYMENT MODE SELECTED
  ├── Dedicated / Digvation Infra
  ├── Dedicated / Client Infra
  └── Shared/SaaS
  ↓
ENVIRONMENT & RESPONSIBILITY RESOLVED
  ↓
DNS / CONFIG / SECRETS RESOLVED
  ↓
DATABASE / STORAGE / BACKUP PROVISIONED
  ↓
MONITORING / ALERTING PROVISIONED
  ↓
APPROVED COMPONENT/DOMAIN RELEASES SELECTED
  ↓
IMMUTABLE ARTIFACTS DEPLOYED
  ↓
DATABASE MIGRATIONS
  ↓
HEALTH CHECK
  ↓
COMPOSED BUSINESS RUNTIME SMOKE TEST
  ↓
SECURITY ACCEPTANCE
  ↓
CLIENT / INTERNAL ACCEPTANCE
  ↓
PRODUCTION ACTIVATION
  ↓
INSTALLATION VERSION / STATE RECORDED
```

Do not deploy arbitrary development branches as client production.

---

## 11. Development and staging before client production

Client production must never be the first place a release is validated.

Normal release path:

```text
feature development
  -> development integration
  -> release candidate
  -> full release gate
  -> Digvation staging/equivalent
  -> approved immutable artifact
  -> target client Installation
```

For Dedicated / Client Infrastructure, a client-side UAT/pre-production environment is desirable when practical.

If only one client server is available, production cutover still requires:

- Digvation staging acceptance first;
- fresh backup/rollback readiness;
- controlled maintenance/cutover;
- immediate post-deploy verification.

---

## 12. Artifact rules

Both dedicated models and SaaS use the same release artifacts for the same application version.

Example:

```text
Inventory Runtime 1.0.0
buildRevision a1b2c3d
image digest sha256:...
```

That exact artifact may be deployed to any compatible entitled Installation, for example:

```text
Client A Dedicated / Digvation Infra
Client B Dedicated / Client Infra
Digvation Shared/SaaS
```

Do not rebuild a client-specific binary/image merely because the deployment target differs.

Installation configuration is external to the image.

---

## 13. Version tracking per Installation

Every deployed component must be traceable.

Example:

```text
Installation: client-a-production
Mode: DEDICATED
Infrastructure Owner: DIGVATION
Branding: WHITE_LABEL

Entitled Domains:
- Workshop
- Inventory

Components:
- Backoffice 1.0.0 / build a1b2c3d
- Operational 1.0.0 / build d4e5f6a
- Workshop Runtime 1.0.0 / build 7a8b9c0
- Inventory Runtime 1.0.0 / build 9d0e1f2
```

For client infrastructure, record the same information.

CORE should eventually become the authoritative control-plane registry for Installation deployment metadata.

Until then, deployment records must still identify exact versions/builds.

Application version is separate from API namespace.

---

## 14. Database rules

### Dedicated

Dedicated Installations should use dedicated database ownership.

Default:

```text
one client Installation
  -> one product database
```

The database may share a physical server only when infrastructure architecture explicitly permits it, but logical ownership and credentials remain isolated.

Never reuse one client's database for another client.

### Shared/SaaS

Shared/SaaS may use shared database infrastructure only with authoritative tenant isolation.

Tenant isolation must be validated before production.

---

## 15. Secrets

Each Installation/environment gets separate production secrets.

Never reuse one client's:

- DB password;
- signing keys;
- integration credentials;
- provider secrets;

for another Installation unless the credential is intentionally a shared platform credential with an approved scope.

Client infrastructure secrets must be transferred/stored using an agreed secure mechanism.

No production secret belongs in source control.

---

## 16. DNS and hostname

Every Installation has explicit hostname ownership.

Dedicated / Digvation Infrastructure may use:

```text
<client-product>.digvation.id
```

or a white-label/client-owned domain according to agreement.

Dedicated / Client Infrastructure may use client-owned DNS.

Regardless of owner:

- DNS target is documented;
- TLS is valid;
- cutover owner is known;
- rollback/cutback is possible during migration.

---

## 17. Backup and restore

Production activation requires a valid backup strategy.

Dedicated / Digvation Infrastructure:

Digvation provisions and monitors backup/offsite backup.

Dedicated / Client Infrastructure:

backup ownership is explicitly agreed before production.

A statement such as "the client handles backups" is not enough unless:

- backup mechanism exists;
- schedule exists;
- retention exists;
- offsite destination exists where required;
- restore procedure is understood.

Restore testing is part of ongoing operational quality.

---

## 18. Monitoring

Every production Installation must have monitoring.

Dedicated / Digvation Infrastructure:

Digvation monitoring/alerting standard is mandatory.

Dedicated / Client Infrastructure:

the client may provide infrastructure monitoring, but Digvation still needs enough application-level visibility/support information to validate product health according to the support agreement.

Minimum target signals are defined by `INFRASTRUCTURE_STANDARD.md`.

---

## 19. Security acceptance

Every new client production Installation must pass applicable security acceptance.

Follow:

`SECURITY_ACCEPTANCE_STANDARD.md`

At minimum validate:

- correct approved artifact;
- TLS;
- intended public ports only;
- private database/internal services;
- auth/RBAC;
- tenant/client isolation where applicable;
- protected secrets;
- dependency/container risk at release gate;
- backup;
- monitoring;
- no Critical/High unaccepted blockers.

Client-owned infrastructure does not waive Digvation product security requirements.

Infrastructure findings outside Digvation control must be reported and accepted/remediated before production if they materially affect product security.

---

## 20. Production acceptance

An Installation is `PRODUCTION_ACTIVE` only after all applicable gates pass.

```text
[ ] commercial/product entitlement confirmed
[ ] Installation identity defined
[ ] deployment mode recorded
[ ] infrastructure responsibility known
[ ] approved application release selected
[ ] exact versions/builds recorded
[ ] infrastructure preflight passed
[ ] secrets/config ready
[ ] database/storage ready
[ ] backup/offsite backup ready
[ ] monitoring/alerts ready
[ ] TLS/DNS ready
[ ] migrations passed
[ ] health/readiness passed
[ ] critical product smoke flow passed
[ ] security acceptance passed
[ ] client/internal acceptance passed
[ ] rollback path understood
[ ] explicit production activation approval given
```

A successful Docker startup alone is not production acceptance.

---

## 21. Post-deploy acceptance

Immediately after production activation:

- verify application versions/builds;
- verify health/readiness;
- verify migration state;
- verify login/auth;
- perform critical business smoke flow;
- verify permissions;
- verify Installation/client isolation;
- verify TLS/domain;
- verify no unintended public ports;
- inspect logs/errors;
- verify monitoring receives telemetry;
- verify backup scheduler/status;
- record final deployment state.

Do not perform destructive pentest activity against production as routine smoke testing.

---

## 22. Upgrade flow for an existing client

A client upgrade uses the normal Digvation release process.

```text
new release accepted
  ↓
exact artifact selected
  ↓
Installation compatibility checked
  ↓
backup confirmed
  ↓
maintenance/cutover plan
  ↓
deploy artifact
  ↓
migration
  ↓
health/smoke/security-sensitive checks
  ↓
record new versions
```

Do not upgrade one client using unmerged/unreleased source simply because the client requested a quick change.

Urgent production fixes follow the Hotfix flow.

---

## 23. Moving a dedicated client to another server

Moving infrastructure does not create a new product fork.

Follow `INFRASTRUCTURE_STANDARD.md`.

High-level:

```text
record current versions
  ↓
bootstrap target server
  ↓
restore config/secrets/data
  ↓
deploy same approved artifacts
  ↓
verify
  ↓
switch DNS/traffic
  ↓
stabilization
  ↓
approve new server
  ↓
decommission old server
```

The old server remains available for rollback until the new server is explicitly accepted.

---

## 24. Moving Dedicated / Digvation Infra to Client Infra

This is a supported lifecycle transition.

Example:

```text
Client originally:
DEDICATED + DIGVATION INFRA

later:
DEDICATED + CLIENT INFRA
```

The transition must not require product source changes.

Required:

1. resolve target client infrastructure;
2. pass client infrastructure preflight;
3. record currently accepted product versions;
4. create verified database/data backup;
5. provision target secrets/config;
6. deploy same approved application artifacts;
7. restore/migrate data;
8. validate application/security;
9. switch DNS/traffic;
10. stabilize;
11. explicitly accept handover;
12. update Installation infrastructure metadata;
13. retire old Digvation infrastructure only after approval.

Commercial/operational responsibility after handover is governed by the client agreement.

---

## 25. New system implementation rule

When building a new Digvation system that may be sold to clients, do not postpone deployment architecture until the end.

During product foundation, ensure:

- no client-specific code;
- externalized configuration;
- independent application version/build metadata;
- production Dockerfile;
- health/readiness;
- migration strategy;
- backup/restore compatibility;
- tenant/runtime boundary;
- explicit CORE relationship;
- dedicated deployment works;
- client-infrastructure deployment does not require code change;
- shared/SaaS remains architecturally viable when relevant.

The first production deployment must follow this standard rather than inventing a one-off setup.

---

## 26. SaaS rule

SaaS is not customized per client at the infrastructure level.

Digvation owns:

- hosting;
- runtime;
- database/platform;
- ingress/TLS;
- backups;
- monitoring;
- security baseline;
- release cadence;
- deployment.

Client-level differences stay inside supported product configuration/data/entitlement boundaries.

Do not introduce `SaaS on client infrastructure`.

If a client requires isolated/client-owned infrastructure, use the Dedicated / Client Infrastructure model instead.

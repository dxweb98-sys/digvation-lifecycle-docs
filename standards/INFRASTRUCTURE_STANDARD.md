# Digvation Infrastructure and Server Standard

> Architecture note: POS-specific deployment examples are historical reference topologies. Current Installation/runtime composition follows `ECOSYSTEM_ARCHITECTURE.md` and may include Backoffice, Operational, and only the client's entitled business-domain runtimes.

This is the canonical infrastructure baseline for Digvation-managed and client-managed installations.

The goal is portability:

> A Digvation product must be deployable to a replacement server without inventing a new operational model.

Application source repositories do not own server-specific secrets or client-specific infrastructure state.

## 1. Infrastructure ownership is separate from product code

Keep these dimensions separate:

- Product: POS, Workshop, CORE, Accounting, etc.
- Installation: one deployed product instance/runtime.
- Environment: development, staging, production.
- Isolation: shared or dedicated.
- Branding: Digvation default or white-label.
- Infrastructure ownership: Digvation-managed or client-managed.

Do not create a client-specific application branch because infrastructure differs.

## 2. Reference server filesystem

Digvation-managed Linux hosts should use a predictable top-level layout:

```text
/opt/digvation/
├── infra/        # shared host/platform configuration
├── manifests/    # deployment manifests / compose definitions
├── data/         # persistent app/platform data where host paths are intentionally used
├── backup/       # local backup staging area, not the only backup copy
└── logs/         # host/platform operational logs when file logging is required
```

Per-installation deployment definitions belong under:

```text
/opt/digvation/manifests/<installation-slug>/
```

Do not scatter production manifests across user home directories.

Do not keep application source repositories on the production host as the deployment authority.

## 3. Host bootstrap baseline

For a production Linux node, establish before application deployment:

- supported LTS/stable operating system;
- correct timezone;
- dedicated non-root administrative account;
- sudo policy documented;
- SSH public-key authentication;
- password SSH disabled;
- direct root SSH disabled;
- conservative SSH retry/session settings;
- host firewall default-deny inbound;
- only required inbound ports exposed;
- fail2ban or equivalent brute-force protection;
- security updates/patch process;
- NTP/time synchronization;
- swap only when appropriate to node size/workload;
- disk capacity checked before deployment;
- Docker/container runtime installed from a trusted source;
- container runtime starts on boot;
- log rotation configured;
- host reboot/recovery procedure understood.

Exact package versions are not permanently hard-coded into this standard.
Supported versions are selected at provisioning time and recorded by automation/inventory.

## 4. Network exposure

Default production exposure:

```text
Internet
   |
80 / 443
   |
Reverse Proxy / Ingress
   |
Application containers
   |
Private internal network
   |
Database / internal services
```

Rules:

- public HTTP should redirect to HTTPS where appropriate;
- TLS is mandatory for internet-facing production;
- database ports are not publicly exposed;
- Redis/message brokers/internal admin ports are not publicly exposed;
- application-to-database traffic stays on a private container/network boundary;
- only the reverse proxy/ingress should normally bind public web ports;
- administrative SSH is restricted as tightly as practical.

## 5. Reverse proxy and TLS

Use one controlled ingress layer per host or platform.

Current Digvation deployments may use Traefik; another ingress may be adopted only through an infrastructure decision.

Required behavior:

- 80/443 ingress;
- HTTPS certificate automation or a documented certificate lifecycle;
- hostname-based routing;
- secure headers where appropriate;
- request/body limits appropriate to application;
- upstream health behavior;
- access/error logging;
- no secrets embedded in public routing configuration.

DNS is external infrastructure configuration and must be documented per Installation.

## 6. Container standard

Application deployment consumes immutable images/artifacts produced by CI.

Production hosts should not compile application source.

Each independently deployable service/app has:

- production-ready Dockerfile;
- `.dockerignore`;
- deterministic image build;
- explicit runtime command;
- minimal production runtime;
- no baked secrets;
- non-root runtime where supported;
- health/readiness where applicable;
- application version/build metadata.

Use explicit container/service names and networks that identify the Installation responsibility without creating client-specific application code.

## 7. Installation isolation

### Dedicated Installation

A dedicated Installation should have isolated runtime resources.

Typical shape:

```text
<installation>
├── web/app containers
├── backend/API containers
├── private application network
├── database
├── persistent volumes
├── installation environment/secrets
└── backup policy
```

For small Digvation-managed dedicated POS deployments, the database may run on the same host when resource/risk requirements allow.

Dedicated means runtime/environment exclusivity, not source-code forking.

### Shared Installation

Shared/SaaS runtime must enforce tenant isolation in the product application and persistence layer.

A shared deployment may use a shared database only when:

- every tenant-owned record is correctly scoped;
- trusted tenant context is established at runtime;
- persistence queries enforce the boundary;
- high-risk tenant-isolation behavior is tested;
- optional DB-level protections such as PostgreSQL RLS may be used when justified.

Do not infer tenant identity from arbitrary client input.

## 8. Container/network naming

Use predictable names by Installation and role.

Conceptual example:

```text
compose project: digvation-pos-<installation>
network: <installation>-internal

services:
- <installation>-pos-api
- <installation>-pos-cashier
- <installation>-pos-backoffice
- <installation>-postgres
```

Do not hard-code a specific client name into application source.
Operational resource names may identify the Installation because infrastructure needs to distinguish deployed instances.

## 9. Secrets and environment configuration

Secrets are installation/environment state.

Do not commit:

- production `.env`;
- DB passwords;
- JWT/private signing keys;
- provider credentials;
- API secrets;
- TLS private keys;
- SSH private keys.

Use:

- protected environment files with strict filesystem permissions;
- CI/CD secret storage;
- cloud secret managers when appropriate;
- client-owned secret management for client-managed infrastructure.

Maintain a non-secret `.env.example` / configuration schema in the owning application repository.

Every required production variable should be documented/validated at startup or deployment.

## 10. Database baseline

For production:

- database is private;
- credentials are unique per Installation/environment;
- persistent storage is explicit;
- migrations run through the release process;
- backups exist before risky migration/deploy work;
- restore procedures are tested periodically;
- connection pool and database resource settings fit node capacity;
- schema/data ownership stays with the product.

For dedicated client deployments, prefer per-Installation database ownership.

Do not copy databases between clients.

## 11. Resource controls

Set reasonable container/service resource expectations.

On small nodes, prioritize:

- application runtime;
- database;
- reverse proxy;
- backup/health agents.

Do not install heavyweight observability stacks on a small node merely to follow a generic platform pattern.

Use limits/reservations when appropriate to prevent one workload from exhausting the host.

Scale or move the Installation when observed resource pressure justifies it.

## 12. Logging

Applications should log to stdout/stderr in structured form where practical.

The container platform/runtime captures those logs.

Required:

- log rotation/retention;
- no unbounded local log growth;
- timestamps;
- service/application identity;
- request/correlation IDs where useful;
- no passwords/tokens/secrets;
- avoid unnecessary sensitive client data.

Central log aggregation can be added based on scale/risk.

## 13. Monitoring baseline

Every production Installation must have at least lightweight monitoring for:

- host reachable/unreachable;
- CPU;
- memory;
- disk usage;
- disk exhaustion risk;
- container/service up/down;
- container restart count;
- OOMKilled/repeated crash signals;
- application health/readiness;
- TLS certificate expiry;
- critical HTTP endpoint reachability;
- backup success/failure;
- database availability;
- deployment/version identity.

Alerts must reach an operator; dashboards without alerts are not sufficient.

For small nodes, prefer lightweight/remote monitoring over colocating a heavy metrics/logging stack.

As the fleet grows, CORE/operations should aggregate Installation health/version/deployment state.

## 14. Backup baseline

A production backup is not complete merely because a file exists on the same server.

Required:

- database backup;
- backup schedule based on business criticality;
- retention policy;
- off-host/offsite copy;
- encrypted transport/storage where appropriate;
- backup result monitoring;
- periodic restore test;
- documented recovery owner.

For migration/deployment involving data risk, create/confirm a fresh restorable backup before proceeding.

## 15. Server portability

An Installation must be movable without changing product source code.

Portable state consists of:

- immutable application image versions;
- deployment manifests;
- non-secret configuration schema;
- protected secrets;
- database backup;
- persistent data backup where applicable;
- DNS/hostname records;
- TLS/ingress configuration;
- application/database migration version;
- Installation/component version record.

The old server is not the source of truth for application code.

## 16. Server migration / replacement flow

Use this for moving an Installation to a new server:

```text
1. identify Installation and accepted artifact versions
2. bootstrap new server from infrastructure standard
3. install ingress/container platform
4. create required private networks/volumes
5. provision secrets/configuration
6. restore database/data from verified backup
7. deploy the SAME accepted application artifacts
8. run migrations only if release requires them
9. verify health/readiness
10. run application smoke tests
11. verify tenant/client isolation
12. verify logs/monitoring/backup on new node
13. switch DNS/traffic
14. monitor during stabilization window
15. keep old node available for rollback until accepted
16. decommission old node only after explicit approval
```

Do not combine server migration with unrelated application feature changes unless unavoidable and explicitly approved.

## 17. Client-managed infrastructure

Client-managed dedicated infrastructure uses the same Digvation product/release model.

Before installation, validate:

- supported OS/runtime;
- required ports/DNS;
- outbound registry/certificate access;
- CPU/RAM/disk baseline;
- backup responsibility;
- monitoring responsibility;
- secret ownership;
- remote support/access agreement;
- database/storage availability;
- rollback responsibility.

Digvation should deliver versioned immutable artifacts and installation configuration requirements, not a source fork.

## 18. Infrastructure as Code direction

Manual server setup should become the exception.

Digvation should maintain a dedicated infrastructure repository, for example:

```text
lifecycle/
└── infra/
    └── digvation-infrastructure/
        ├── AGENTS.md
        ├── ansible/
        ├── templates/
        ├── monitoring/
        ├── backup/
        └── README.md
```

No production secrets belong in this repository.

Its purpose is to make the server baseline reproducible:

- host hardening;
- Docker/runtime bootstrap;
- reverse proxy;
- directory layout;
- firewall;
- monitoring agent;
- backup tooling;
- shared deployment templates.

Cloud-provider-specific code should be adapter/configuration, not a different Digvation operational standard.

## 19. Reference small dedicated POS node

The current `stark` node is a useful reference for a small Digvation-managed dedicated POS deployment, but it is not a forever-fixed hardware specification.

The operational pattern is:

- hardened Linux host;
- SSH key-only access;
- firewall + brute-force protection;
- Docker runtime;
- reverse proxy/TLS;
- dedicated POS runtime/database;
- private database networking;
- offsite backups;
- lightweight monitoring;
- conservative resource use.

Upgrade/move when metrics show the node no longer has safe headroom.

## 20. Infrastructure acceptance

A server/Installation is not production-ready until:

- host baseline is applied;
- only intended ports are exposed;
- TLS works;
- application health is good;
- database is private;
- secrets are protected;
- backup + offsite copy work;
- restore path is known;
- monitoring/alerts work;
- application/version identity is visible;
- security acceptance is satisfied;
- production deployment approval is explicit.

See `SECURITY_ACCEPTANCE_STANDARD.md` and `DELIVERY_RELEASE_STANDARD.md`.


## 21. Client deployment mode

Infrastructure implementation for a specific client/Installation must follow `CLIENT_INSTALLATION_STANDARD.md`.

That standard defines the only supported client deployment variants:

- Dedicated / Digvation Infrastructure;
- Dedicated / Client Infrastructure;
- Shared/SaaS under Digvation infrastructure.

Do not invent a one-off infrastructure model for an individual client.

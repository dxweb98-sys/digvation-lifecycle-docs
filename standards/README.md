# Digvation Standards in the Lifecycle Workspace

This folder contains Digvation's canonical reference standards.

Routine coding agents should not read every file on every task.

The instruction hierarchy is:

```text
lifecycle/AGENTS.md
+
repository AGENTS.md
+
application/module AGENTS.md
+
current task
```

For architecture meaning, `ECOSYSTEM_ARCHITECTURE.md` is authoritative even when current repository/folder names still contain historical `pos` terminology.

Current canonical ecosystem vocabulary:

```text
CORE        = control plane
POS / Workshop / Inventory / ... = business domains
Workforce / Customer / ...       = shared business foundations
Promotion/Commercial Rules       = shared business capability
Tax/Fiscal                       = shared business capability
Backoffice  = shared management experience
Operational = shared execution experience
Dashboard / Reports = shared experience projections
Deployment  = independent runtime/infrastructure/branding composition
```

Durable business scope is cataloged under `../scopes/`. Read `../scopes/README.md` and only the scope contracts materially involved in the current task. `Deferred`/`Planned` entries are not automatic implementation authority.

Read standards conditionally:

- ecosystem/domain/client/entitlement/composition behavior -> `ECOSYSTEM_ARCHITECTURE.md`
- architecture/tree/naming/refactor -> `ENGINEERING_STANDARD.md`
- commit/merge/version/release/deploy -> `DELIVERY_RELEASE_STANDARD.md`
- server/infra -> `INFRASTRUCTURE_STANDARD.md`
- client deployment -> `CLIENT_INSTALLATION_STANDARD.md`
- production security -> `SECURITY_ACCEPTANCE_STANDARD.md`
- new system/product/domain -> `NEW_PRODUCT_STANDARD.md` + `../scopes/README.md`
- business feature/domain work -> applicable `../scopes/<SCOPE>.md` only
- strategic direction -> `ECOSYSTEM_ROADMAP.md`

`PROMPT_LIBRARY.md` is the user's copy/paste toolbox and is not routine agent study material.

The first-time bootstrap prompt is inside `PROMPT_LIBRARY.md`.

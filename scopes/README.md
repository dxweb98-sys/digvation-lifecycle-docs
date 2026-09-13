# Digvation Scope Contracts

This folder is the readable, extensible catalog of durable Digvation business scope.

It exists to answer two different questions without mixing them:

1. **Domain envelope** — what a domain/foundation/capability conceptually owns and may support.
2. **Current delivery scope** — what is actually approved to exist or be implemented now.

A scope contract is NOT a roadmap authorization. Agents must never implement `Deferred`, `Planned`, or merely conceptual items unless the current user task explicitly activates them.

## Scope kinds

Use one of these labels in `Kind`:

- `BUSINESS_DOMAIN` — authoritative operational domain such as POS, Inventory, Workshop.
- `SHARED_BUSINESS_FOUNDATION` — reusable business identity/foundation such as Workforce or Customer.
- `SHARED_BUSINESS_CAPABILITY` — reusable rules/behavior consumed by multiple domains, such as Tax/Fiscal or Operational Access.
- `EXPERIENCE_PROJECTION` — shared Backoffice/Operational composition such as Dashboard/Reporting. It does not become source-of-truth for contributing domains.

## Status vocabulary

- `ACTIVE` — scope exists and is currently part of the Digvation platform.
- `NEXT` — next intended scope, but implementation still requires an explicit task.
- `PLANNED` — boundary is reserved/understood, but detailed feature scope is not yet locked.
- `DRAFT` — still being discussed; do not use as implementation authority.

## Entitlement and commercial availability

Every durable scope must declare how availability is controlled. Do not infer availability from source-code presence, business type, deployment mode, or branding.

Use these `Entitlement Class` values:

- `PLATFORM_FOUNDATION` — required/shared platform foundation. It is not automatically a separately sold product, although visibility and actions still require context/permission.
- `PRODUCT` — separately entitled business domain/product such as POS, Inventory, or Workshop.
- `CAPABILITY` — optional reusable capability enabled only when the client's effective entitlement set grants it.
- `EXPERIENCE` — Backoffice/Operational projection/composition; availability comes from the entitled capabilities it composes rather than a separate business-data authority.

Use `Commercial Packaging` only as a packaging hint, not authorization:

- `BASE` — platform/base capability;
- `PRODUCT` — top-level product/domain offering;
- `ADD_ON_CAPABLE` — may be sold separately or bundled by a SaaS plan/contract;
- `BUNDLED_OR_OPTIONAL` — may be bundled by a product/plan or enabled explicitly;
- `N/A` — not a standalone commercial item.

The runtime/frontend must consume the **effective entitlement set** resolved by CORE/control-plane commercial configuration. A SaaS package may bundle products/capabilities, but business runtimes must not infer package contents from a plan name.

Example:

```text
SaaS Plan: Retail Pro
  -> Product: POS
  -> Product: Inventory
  -> Capability: Promotions
  -> Capability: Loyalty Points

Effective Entitlement Set
  POS = enabled
  INVENTORY = enabled
  PROMOTIONS = enabled
  LOYALTY_POINTS = enabled
```

A different client may have POS without Inventory, Promotions, or Loyalty Points. Dedicated/white-label deployment follows the same entitlement rules.

## Required structure

Each scope file should stay short and use this structure where applicable:

```text
# <Scope Name>

Kind:
Status:
Entitlement Class:
Commercial Packaging:
Purpose:

Owns / Authority
Consumes / Depends On
Does Not Own

Backoffice Contribution
Operational Contribution
Dashboard Projection
Report Projection

Current Scope
Deferred / Future
Integration Rules
```

Sections that genuinely do not apply may say `None` rather than inventing behavior.

## Adding a new Digvation domain or major module

When the user defines a new durable domain/module such as Workshop:

1. update or create exactly one scope contract;
2. define authority and non-authority first;
3. define shared dependencies instead of duplicating them;
4. state what it contributes to Backoffice and/or Operational;
5. state dashboard/report projections if relevant;
6. separate `Current Scope` from `Deferred / Future`;
7. update `ECOSYSTEM_ARCHITECTURE.md` only when the ecosystem-level boundary itself changes.

Do not duplicate the same durable rule into multiple scope files.

## Agent reading rule

For ordinary implementation, read only:

- the applicable `AGENTS.md` hierarchy;
- this README when scope classification is unclear;
- the one or two scope contracts materially involved in the task;
- additional lifecycle standards only when their conditional trigger applies.

Then use Codebase Memory MCP to map the scope contract to current repository reality and verify important findings against source.

For frontend/UI work, use the installed `uiuxpromax` UI/UX skill automatically and preserve the existing Digvation Design System as the implementation authority.

## Current scope catalog

```text
POS.md                  ACTIVE   Business domain
ORGANIZATION_LOCATION.md ACTIVE   Shared organization/location foundation
CATALOG.md               ACTIVE   Shared catalog foundation
WORKFORCE.md             ACTIVE   Shared workforce foundation
IDENTITY_ACCESS.md       ACTIVE   Shared account/identity/RBAC foundation
OPERATIONAL_ACCESS.md    ACTIVE   Shared operational location-access capability
AUDIT_ACTIVITY.md        ACTIVE   Shared audit/activity foundation
DASHBOARD_REPORTING.md   ACTIVE   Shared projection/composition contract
FINANCE_OPERATIONS.md    ACTIVE   Shared finance/financial-operations capability
CUSTOMER_MEMBERSHIP.md  NEXT     Shared customer + membership capability
PROMOTION_COMMERCIAL.md NEXT     Shared promotion/commercial-rules capability
TAX_FISCAL.md           NEXT     Shared dynamic tax/fiscal capability
INVENTORY.md            PLANNED  Business domain boundary reserved
WORKSHOP.md             PLANNED  Business domain boundary reserved
```

This table is descriptive. Actual repository/source reality must still be verified before implementation.

## Current entitlement/packaging examples

```text
POS                    PRODUCT              PRODUCT
INVENTORY              PRODUCT              PRODUCT
WORKSHOP               PRODUCT              PRODUCT
PROMOTIONS             CAPABILITY           ADD_ON_CAPABLE
LOYALTY_POINTS          CAPABILITY           ADD_ON_CAPABLE
TAX_FISCAL              CAPABILITY           BUNDLED_OR_OPTIONAL
CUSTOMER_MANAGEMENT     CAPABILITY           BUNDLED_OR_OPTIONAL
MEMBERSHIP              CAPABILITY           BUNDLED_OR_OPTIONAL
FINANCE_OPERATIONS      CAPABILITY           ADD_ON_CAPABLE

Organization/Location  PLATFORM_FOUNDATION  BASE
Identity/RBAC           PLATFORM_FOUNDATION  BASE
Operational Access      PLATFORM_FOUNDATION  BASE
Audit/Activity          PLATFORM_FOUNDATION  BASE
Catalog foundation      PLATFORM_FOUNDATION  BASE
Workforce foundation    PLATFORM_FOUNDATION  BASE
Dashboard/Reporting     EXPERIENCE           N/A
```

This matrix describes entitlement shape, not final pricing. `ADD_ON_CAPABLE` means the capability can be sold separately or bundled. A future commercial decision may change packaging without changing domain ownership.

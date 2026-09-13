# Digvation Ecosystem Direction

This file records current ecosystem direction and priority context.
It is not a staged implementation mandate and must not be converted into artificial phase labels in branches, commits, code, or prompts.

Durable feature/domain details live in `../scopes/`. This file should stay high-level.

## Current platform meaning

```text
Digvation CORE
  -> control plane

Digvation Business Platform
  -> business domains / shared business capabilities

Digvation Experiences
  -> Backoffice
  -> Operational
```

Repository names may temporarily retain historical naming. Architecture ownership follows `ECOSYSTEM_ARCHITECTURE.md` and the applicable `scopes/` contract, not repository labels.

## Current business focus

The immediate business focus is intentionally narrower than the full future platform:

```text
ACTIVE / CURRENTLY RELEVANT
- POS
- Finance / Financial Operations
- Workforce / Employee Management
- Dashboard & Reporting composition

NEXT TO DEFINE / DELIVER BY EXPLICIT TASK
- Customer & Membership / Loyalty
- Promotion / Commercial Rules
- Dynamic Tax / Fiscal configuration and rule capability

PLANNED, NOT YET IMPLEMENTATION AUTHORITY
- Inventory
- Workshop
- later business domains
```

The status above is directional context only. The current user task is always the implementation boundary.

## CORE direction

CORE remains control-plane authority for Client, Product, ClientProduct, Subscription/Entitlement, Installation, infrastructure/runtime registry, deployment/release visibility, and operational control-plane state.

CORE does not absorb business transactions.

## Business domain direction

One business concept has one authority.

Current canonical examples:

```text
POS
- selling
- checkout
- payment execution
- receipt
- cashier/session

Finance / Financial Operations
- general financial accounts
- expenses and general cash movements
- settlement and reconciliation
- optional `FINANCE_OPERATIONS` capability independent from POS

Workforce
- canonical employee identity/status/organizational assignment

Customer / Membership
- shared customer identity
- reusable membership/loyalty capability when explicitly activated

Promotion / Commercial Rules
- reusable cross-domain promotion/campaign authority when explicitly activated
- Catalog-targeted and Membership-aware offers without transferring Catalog or loyalty-ledger ownership
- Owner organization-wide and Manager assigned-location authority through RBAC/Operational Access

Tax / Fiscal
- reusable dynamic tax rule/configuration/evaluation capability

Inventory
- canonical stock authority when activated

Workshop
- first-class sibling business domain when its detailed scope is later locked
```

Existing accepted code is migration/reuse source and must be moved/re-homed rather than discarded and rebuilt when ownership changes.

## Experience direction

Digvation standardizes on two primary human-facing experiences:

```text
Backoffice
Operational
```

Business domains and shared capabilities contribute modules/projections to these experiences.

Current `apps/backoffice` is the Backoffice foundation.
Current `apps/cashier` is the existing POS Operational implementation and migration source for the broader Operational experience.

Do not create product-specific permanent UI shells merely because a new business domain is added.

## Dashboard and reporting direction

Dashboard and Reports are shared composition/projection experiences.

They adapt to the client's entitled domains, permissions, runtime/location context, and available domain projections.

Business profile may supply recommended presets and terminology but must not grant capabilities.

Adding a new domain should normally mean registering its dashboard/report projections, not creating a separate dashboard/report framework.

See `../scopes/DASHBOARD_REPORTING.md`.

## Finance / Financial Operations direction

Finance / Financial Operations is an active shared business capability because accepted functionality already exists. It owns general financial accounts, expenses, cash movements, settlements, reconciliations, and their projections independently from POS.

POS retains its transaction, payment-execution, and Cashier Session authority. Business domains integrate with Finance through explicit contracts. Full Accounting remains a separate future domain decision and is not implied by the current Finance capability.

See `../scopes/FINANCE_OPERATIONS.md`.

## Tax / Fiscal direction

Tax/Fiscal is shared across business domains such as POS and future Workshop.

It has its own Backoffice configuration surface, but available configuration follows enabled business domains, catalog/service classifications, location/jurisdiction context, and permission.

Do not duplicate independent tax engines inside POS and Workshop.

See `../scopes/TAX_FISCAL.md`.

## Promotion / Commercial Rules direction

Promotion is shared across business domains such as POS and future Workshop. It owns time-bound commercial offers, location/catalog/member applicability, benefit definition, and optional approval lifecycle when explicitly activated.

Catalog remains the catalog authority, Membership remains loyalty/points authority, and Tax/Fiscal remains tax authority. Manager promotion scope follows assigned branch/location access; Owner may manage organization-wide scope subject to permission/policy.

See `../scopes/PROMOTION_COMMERCIAL.md`.

## Composition direction

Client-visible capability is driven by:

```text
Entitlement
+ runtime capability
+ user permission
+ location/operational context
+ available domain/shared-capability projections
```

Business type is onboarding/profile metadata, not feature authority.

## Deployment direction

Deployment is orthogonal to product ownership.

Supported conceptual dimensions remain:

- SHARED or DEDICATED;
- DIGVATION or CLIENT infrastructure ownership;
- DIGVATION / CLIENT / agreed shared operational management;
- DIGVATION_DEFAULT or WHITE_LABEL branding.

Dedicated/white-label does not imply access to all Digvation products.

## Domain separation direction

Hard rules:

- one authority per business concept;
- no direct cross-domain database/repository access;
- explicit APIs/ports/events/contracts between domains;
- do not duplicate existing behavior during extraction;
- repository/service extraction may happen when authorized without changing business ownership.

## Adding or changing major scope

When a new durable domain/module is defined, update one scope contract using `../scopes/README.md`.

Examples:

- detailed Workshop workflow -> update `../scopes/WORKSHOP.md`;
- Inventory feature envelope -> update `../scopes/INVENTORY.md`;
- new shared capability -> add a new scope contract with explicit authority and consumers.

Do not rewrite this roadmap for ordinary feature additions unless overall ecosystem direction changes.

## Release and operations direction

Each independently deployable component retains its own version/build identity.
CORE should observe deployed component composition per Installation without assuming every client has the same business domains.

## Ongoing rules

- no client source forks;
- no client-name behavior branching;
- entitlement independent from branding/deployment;
- Backoffice/Operational are shared experiences;
- business domains/shared capabilities own their authority;
- explicit cross-domain contracts;
- independently deployable components have independent versions;
- existing accepted behavior is preserved during architecture migration;
- no artificial phase labels are required to apply this direction.

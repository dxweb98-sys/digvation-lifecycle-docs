# Dashboard & Reporting Composition Contract

Kind: `EXPERIENCE_PROJECTION`
Status: `ACTIVE`
Entitlement Class: `EXPERIENCE`
Commercial Packaging: `N/A`

## Purpose

Dashboard and Reporting are shared Digvation experiences that compose projections from the business domains and shared foundations a client is entitled and permitted to use.

They are not a new source-of-truth domain and must not absorb transactional authority from POS, Finance / Financial Operations, Workshop, Inventory, Workforce, Customer/Membership, Promotion/Commercial Rules, Tax/Fiscal, or future domains.

## Composition Authority

Dashboard/report visibility is composed from authoritative context such as:

```text
Effective Product/Capability Entitlements
INTERSECT Installation Runtime Capability
INTERSECT User Permission
INTERSECT Location / Organization Context
INTERSECT Available Domain Projection
```

Business profile may select sensible defaults/presets, terminology, and initial layout. SaaS plan names may describe commercial bundles. Neither grants runtime capability directly; Dashboard/Reports consume the effective entitlement set resolved by CORE.

## Domain Contribution Model

Each domain/foundation may register or expose its own projection definitions.

Conceptually a contribution may describe:

```text
id
ownerDomain
label
description
requiredCapability / permission
supported filters
metric/report query contract
drilldown target
presentation hints
```

Presentation hints are not permission or data authority.

The shared experience decides composition/layout; the owning domain decides the meaning and authoritative data contract of its metric/report.

## Dashboard

Dashboard is a composable overview, not one static screen for every business.

Examples:

POS client may receive:
- sales;
- transaction count;
- payment mix;
- refund/void indicators.

Workshop client may later receive:
- active/open work orders;
- jobs waiting/blocked;
- mechanic/workload indicators;
- service revenue/throughput where defined.

Inventory client may later receive:
- stock health;
- low stock;
- receiving/movement indicators.

Finance-enabled client may receive:
- approved expense and cash-movement indicators;
- settlement status/amounts;
- reconciliation status/differences.

Workforce/Customer/Membership/Promotion may contribute reusable summary widgets when relevant.

### Dashboard customization

The architecture should allow safe customization such as:

- domain-aware default dashboard presets;
- role-aware/default presets;
- show/hide permitted widgets;
- reorder permitted widgets;
- selected location/time context;
- reset to recommended default.

Customization never allows a user to reveal data/capabilities they are not entitled or permitted to access.

Do not implement customization unless the current feature scope asks for it.

## Reports

Reports is a shared catalog/composition experience.

Each owning domain registers reports it can authoritatively answer.

POS contributes authoritative sales and POS payment projections. Finance contributes authoritative financial-account, expense, cash-movement, settlement, and reconciliation projections. Shared Reporting composes these projections but does not duplicate their calculations.

The Reports experience may provide common cross-report behavior such as:

- date/time range;
- location/branch filters;
- export/print when supported;
- saved filter/view preferences when scoped;
- consistent report navigation and result presentation.

It must not implement domain calculations independently from the domain authority.

### Cross-domain reports

A genuine cross-domain report is allowed only with an explicit projection/analytics contract.

Do not produce a cross-domain report by directly joining another domain's tables from the UI, the shared Reporting layer, or an unrelated service. Cross-domain business-performance reporting must consume explicit projections from each owning authority.

## Backoffice Contribution

Dashboard and Reports primarily live in Backoffice.

The exact navigation and information hierarchy must be composed from available domains and permissions and must use `uiuxpromax` for UI/UX implementation.

## Operational Contribution

Operational may show compact live summaries/context where useful, but broad management dashboards/reporting belong in Backoffice unless a real operational need is explicitly scoped.

## Current Scope

- establish Dashboard/Reporting as shared projection/composition architecture;
- preserve current accepted dashboards/reports;
- migrate current direct POS/Finance persistence composition toward explicit owner projections without changing accepted report behavior;
- future domain additions contribute projections instead of creating parallel dashboard/report frameworks.

## Deferred / Future

- advanced analytics warehouse;
- BI semantic layer;
- user-defined formulas;
- arbitrary cross-domain report builder;
- scheduled report delivery;
- any capability not explicitly activated.

## Integration Rules

- dashboard/reporting is read-oriented projection/composition;
- source domains remain authoritative;
- projection definitions must declare their owning domain and required permission/capability;
- no client-name hard-coding;
- business type may drive presets, not authorization;
- adding a new domain should require registering its projections, not rewriting the whole Dashboard/Reports shell.

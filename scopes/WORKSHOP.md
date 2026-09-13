# Workshop Scope Contract

Kind: `BUSINESS_DOMAIN`
Status: `PLANNED`
Entitlement Class: `PRODUCT`
Commercial Packaging: `PRODUCT`

## Commercial Availability / Effective Entitlement

`WORKSHOP` is a product-level entitlement. A client may use this domain only when CORE/control-plane resolves `WORKSHOP` as enabled in the effective entitlement set. Bundling in a SaaS plan is commercial packaging only; runtimes must consume the resolved entitlement rather than infer access from plan name, business type, deployment mode, or source-code presence.

## Purpose

Workshop is reserved as a first-class Digvation business domain for service/work execution. It is not a POS submodule.

## Boundary Envelope

The following concepts have been discussed as likely Workshop-owned concepts, but detailed feature scope is intentionally not locked yet:

- vehicle;
- inspection;
- estimate;
- work order;
- work-order job;
- mechanic profile/assignment;
- labor execution;
- quality control;
- service history.

## Consumes / Depends On

Potential shared dependencies:

- Workforce employee identity;
- Customer identity;
- Membership/Loyalty;
- Promotion/Commercial Rules;
- Tax/Fiscal;
- Inventory for parts/stock;
- Scheduling when defined later.

## Does Not Own

- canonical stock;
- canonical employee identity;
- canonical customer identity;
- POS selling workflow;
- Promotion/Commercial Rules authority;
- CORE lifecycle.

## Backoffice Contribution

Not yet locked. Will be defined when Workshop scope is activated.

## Operational Contribution

Not yet locked. Expected to represent workshop-floor/mechanic execution inside the shared Operational experience, not a permanent separate app by default.

## Dashboard Projection

Not yet locked. Workshop will contribute its own metrics when detailed scope is defined.

## Report Projection

Not yet locked. Workshop will contribute authoritative service/work-order reports when detailed scope is defined.

## Current Scope

None. Do not implement Workshop from this placeholder.

## Deferred / Future

When the user is ready to build Workshop, replace this placeholder with the explicitly agreed workflow, entities, states, permissions, Backoffice/Operational contributions, dashboard metrics, reports, integrations, and deferred scope.

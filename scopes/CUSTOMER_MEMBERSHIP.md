# Customer & Membership Scope Contract

Kind: `SHARED_BUSINESS_FOUNDATION` + `SHARED_BUSINESS_CAPABILITY`
Status: `NEXT`
Entitlement Class: `PLATFORM_FOUNDATION` + `CAPABILITY`
Commercial Packaging: customer identity foundation + `BUNDLED_OR_OPTIONAL` Customer Management/Membership + `ADD_ON_CAPABLE` Loyalty Points

## Purpose

Provide one reusable customer identity and a reusable Membership/Loyalty capability that can be consumed by POS, Workshop, and future Digvation domains without making those domains depend on POS.

Customer identity and Membership/Loyalty are related but must not be collapsed into one giant model.

## Commercial Availability / Effective Entitlements

Customer, Membership, and Loyalty Points are related but are not one indivisible commercial switch.

Canonical availability model:

```text
CUSTOMER_IDENTITY
  -> shared foundation/reference used when an entitled product/capability needs customer identity

CUSTOMER_MANAGEMENT
  -> optional management capability; may be bundled or enabled explicitly

MEMBERSHIP
  -> optional membership capability; may be bundled by a product/SaaS plan or enabled explicitly

LOYALTY_POINTS
  -> optional capability entitlement; may be sold as an add-on or bundled
```

Do not assume customer identity automatically grants the Customer Management UI, and do not assume `MEMBERSHIP` automatically grants `LOYALTY_POINTS`. A client may use customer records and basic membership identification without points.

For SaaS, plan/package configuration may grant these capabilities, but CORE/control-plane must resolve the package into explicit effective entitlements. POS/Workshop/frontend code must consume the resolved capability set rather than checking a plan name.

Dedicated, client-hosted, and white-label installations follow the same rule. Deployment mode never grants Loyalty Points.

## Customer Authority

Customer foundation may own:

- customer identity;
- name/contact/basic profile;
- customer status;
- tenant-scoped customer reference;
- shared customer attributes explicitly approved later.

## Membership / Loyalty Authority

The Membership/Loyalty capability may own, when activated by explicit feature scope:

- membership program;
- member identity/number;
- enrollment;
- membership status;
- tier;
- benefits/eligibility;
- points balance/ledger;
- earning rules;
- redemption;
- expiry;
- membership history.

These are the domain envelope, not automatic implementation scope.

### Catalog-based point earning

Membership/Loyalty owns normal point-earning rules even when a rule targets Catalog entries. Do not store `point` as durable loyalty authority directly on Catalog.

When points are activated, an earning rule may reference Catalog scope such as:

```text
ALL_CATALOG
CATEGORY / CLASSIFICATION
ITEM / PRODUCT
SERVICE
TAG
```

and may define an explicitly supported earning model such as fixed points or spend/quantity-based earning. Exact rule types remain feature scope.

Promotion/Commercial Rules may temporarily add bonus points or a point multiplier, but the points ledger and durable membership earning authority remain Membership-owned.

## Consumes / Depends On

- Customer identity;
- tenant/client runtime context;
- Catalog for earning/redemption applicability references such as item/service/category/classification when activated;
- Promotion/Commercial Rules for temporary bonus-point, multiplier, member-offer, or campaign benefits when activated;
- Tax/Fiscal only if future rules genuinely depend on member/customer tax classification;
- explicit business-domain transaction references for earn/redemption behavior.

## Does Not Own

- POS sales;
- Workshop work orders/vehicles;
- Inventory stock;
- employee identity;
- promotion/campaign authority, which belongs to `PROMOTION_COMMERCIAL.md`;
- generic marketing/campaign automation unless explicitly added later.

## Backoffice Contribution

Potential shared Backoffice modules:

- Customers;
- Customer Detail;
- Membership configuration;
- member enrollment/status/tier visibility;
- loyalty ledger/history when activated.

The exact menu shape is UI scope and must follow `uiuxpromax` plus current Design System patterns.

## Operational Contribution

Domains may surface customer/member lookup or identification inside their operational flow.

Examples:

- POS identifies a member during a sale;
- Workshop identifies the same customer/member on a work order.

Membership does not require a standalone Operational app.

## Dashboard Projection

When activated, may contribute metrics such as:

- total/active members;
- new enrollments;
- membership tier distribution;
- member vs non-member transaction mix via domain projections;
- points issued/redeemed where points are active.

## Report Projection

When activated, may register:

- customer list/activity reports;
- membership enrollment/status report;
- tier report;
- points/earn/redemption ledger reports.

Cross-domain spend/service reports must preserve the owning transaction domains and use explicit projections/contracts.

## Current Scope

Not yet locked as an implemented feature in the lifecycle.

The intended next design focus is:

- Customer Management foundation;
- basic Membership foundation only when explicitly enabled;
- POS integration.

`LOYALTY_POINTS` is not part of the default Membership implementation scope. It requires an explicit capability entitlement and an explicit feature checkpoint.

The exact first feature checkpoint must be explicitly supplied by the user before implementation.

## Deferred / Future

Unless explicitly activated:

- points;
- tier progression automation;
- redemption;
- advanced loyalty segmentation;
- advanced catalog-based earning rules beyond the explicitly activated checkpoint;
- Workshop integration.

## Integration Rules

- POS must not own canonical Membership/Loyalty;
- Workshop must be able to consume the same customer/member identity later;
- historical transaction ownership stays in the originating domain;
- no duplicate customer authority per product;
- normal catalog-based loyalty earning remains Membership-owned; temporary campaign modifiers use Promotion/Commercial Rules;
- point earning/redemption that affects a transaction is backend-authoritative and must preserve a historical ledger/reference.

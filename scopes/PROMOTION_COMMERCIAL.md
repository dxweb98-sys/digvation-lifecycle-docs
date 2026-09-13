# Promotion & Commercial Rules Scope Contract

Kind: `SHARED_BUSINESS_CAPABILITY`
Status: `NEXT`
Entitlement Class: `CAPABILITY`
Commercial Packaging: `ADD_ON_CAPABLE`

## Purpose

Provide one reusable Promotion/Commercial Rules authority that can be consumed by POS, Workshop, and future Digvation business domains without duplicating promotion engines inside each domain.

Promotion is responsible for time-bound commercial offers and eligibility/benefit rules. It does not own the base Catalog, Membership ledger, Tax/Fiscal calculation, POS sale, or Workshop work order.

## Commercial Availability / Effective Entitlement

Promotion is **not automatically enabled** merely because a client owns POS, Workshop, Catalog, or Membership.

Canonical capability:

```text
PROMOTIONS
```

`PROMOTIONS` is add-on-capable. A SaaS plan may sell it separately or bundle it, but CORE/control-plane must resolve that commercial package into an explicit effective capability entitlement.

Examples:

```text
Client A
POS = enabled
PROMOTIONS = disabled

Client B
POS = enabled
PROMOTIONS = enabled   # bundled in SaaS plan or purchased add-on

Client C
Workshop = enabled
PROMOTIONS = enabled
```

Source-code presence, a visible menu implementation, dedicated deployment, or white-label branding never grants Promotion capability. Backend authorization is authoritative.

## Owns / Authority

When activated by an explicit feature task, Promotion may own:

- promotion/campaign identity and lifecycle;
- promotion validity/effective period;
- applicable business-domain scope;
- applicable branch/location scope;
- Catalog targeting references such as all catalog, category/classification, item/product, service, or reusable tags when supported by Catalog;
- customer/member eligibility references such as membership program/tier/segment where the authoritative capability exists;
- commercial benefit definition such as percentage/fixed discount, fixed promotional price, member price, bonus points, or point multiplier when explicitly supported;
- minimum-spend/quantity and other eligibility conditions when explicitly supported;
- priority and stacking/exclusivity policy;
- usage limits where explicitly supported;
- draft/active/inactive/expired lifecycle;
- promotion approval state/policy when approval is enabled;
- applied-promotion result/reference semantics required by historical transactions.

This is the domain envelope, not automatic implementation authorization.

## Consumes / Depends On

Promotion may consume explicit contracts from:

- Catalog for product/item/service/category/classification references;
- Customer & Membership for member identity, tier, eligibility, and loyalty capability where applicable;
- Organization & Location for branch/location scope;
- Account/Identity/RBAC for actor permission;
- Operational Access for Manager/location authority;
- Audit & Activity for immutable business-semantic change records;
- authoritative transaction context from POS, Workshop, or another consuming domain.

Promotion must not directly read another domain's repository/database to evaluate eligibility.

## Catalog Relationship

Promotion references Catalog; it does not own Catalog.

Do not store durable promotion rules directly on a catalog entry merely because a promotion targets that entry.

Conceptually:

```text
Catalog
  -> Product / Item / Service / Category / Classification
                         |
                         v
                  Promotion Rule
```

A rule may target, when explicitly supported:

```text
ALL_CATALOG
CATEGORY / CLASSIFICATION
ITEM / PRODUCT
SERVICE
TAG
```

The exact targeting vocabulary should follow the actual Catalog contract rather than introducing a parallel classification system.

## Membership / Loyalty Relationship

Membership owns durable loyalty state such as program enrollment, tier, points balance/ledger, earning rules, and redemption rules when those capabilities are active.

Promotion may define temporary commercial benefits that reference Membership, for example:

- Gold members receive an additional discount during a validity period;
- members receive bonus points for selected catalog items;
- members receive a temporary point multiplier.

Promotion must not become the points ledger authority.

A normal catalog-based loyalty earning rule remains Membership-owned. A temporary campaign that modifies/boosts the earning outcome is Promotion-owned and must resolve through an explicit Membership/Loyalty contract.

## Owner / Manager Promotion Authority

Promotion management must follow Account/Identity/RBAC and Operational location access rather than trusting role labels only in the UI.

Canonical default scope:

- **Owner** may manage promotions across the organization and all active locations, subject to entitlement/runtime/permission checks;
- **Manager** may create/manage promotions only for branch/location assignments they are authorized to manage;
- a Manager assigned to Branch A and Branch B must not create or activate a promotion for Branch C;
- other roles may manage promotions only when an explicit permission/policy grants it, and still within their authorized scope.

Backend enforcement is authoritative.

For location selection:

```text
0 permitted locations -> deny promotion location scope
1 permitted location  -> auto-resolve; no forced selector
2+ permitted locations -> allow selection only from permitted locations
```

An organization-wide promotion is not implicitly available to a Manager merely because that Manager can access multiple branches. Organization-wide authority requires the appropriate organization-level permission/policy.

## Approval Policy

The architecture must allow promotion approval policy without forcing it on every client.

Examples:

```text
Manager creates -> ACTIVE
```

or, when configured:

```text
Manager creates DRAFT
      -> submit
      -> authorized approver (for example Owner)
      -> ACTIVE / REJECTED
```

Do not implement approval workflow unless the current feature scope activates it.

## Tax / Fiscal Relationship

Promotion does not calculate Tax/Fiscal rules.

Money-affecting evaluation must use an explicit backend-authoritative ordering/policy between:

```text
Base/List Price
-> Promotion / Membership benefit outcome
-> Tax/Fiscal evaluation
-> Final transaction snapshot
```

The exact calculation/stacking/tax-base policy must be defined by the applicable transaction/commercial contract before implementation. Frontends must not independently infer the ordering.

Historical transactions must preserve the applied promotion/benefit outcome and relevant rule/reference snapshot so later edits do not rewrite past monetary results.

## Backoffice Contribution

Promotion contributes a shared Backoffice commercial-management surface, conceptually such as:

```text
Commercial
  -> Promotions
```

Potential management capabilities, only when activated:

- promotion list/search/filter;
- create/edit/detail;
- validity/effective period;
- domain applicability;
- branch/location applicability;
- Catalog target selection;
- Customer/Membership eligibility;
- benefit configuration;
- stacking/priority/usage rules;
- lifecycle/approval status;
- audit/history visibility.

The UI must adapt to available business domains and Catalog capabilities instead of displaying every future rule at the same visual level.

Any Promotion UI work must use `uiuxpromax` and the existing Digvation Design System.

## Operational Contribution

Promotion normally does not create a standalone Operational module.

Operational domains such as POS or Workshop consume authoritative promotion evaluation and may show:

- eligible/applied offer;
- discount/benefit result;
- member benefit;
- promotion reference where appropriate.

Operational clients must not become promotion-rule authorities.

## Dashboard Projection

When activated, Promotion may contribute safe commercial indicators such as:

- active/upcoming promotions;
- promotions nearing expiry;
- promotion utilization counts where transaction-domain projections exist;
- discount/benefit value where authoritative financial projections exist.

Performance metrics that depend on sales/work-order data must use explicit projections from the owning transaction domains rather than direct cross-domain table access.

## Report Projection

When activated, Promotion may register reports such as:

- promotion master/status report;
- promotion validity/location/catalog-scope report;
- promotion utilization report through authoritative transaction projections;
- discount/benefit impact report through authoritative monetary projections.

## Audit & Activity

Important promotion administration must emit business-semantic audit activity, for example:

- `PROMOTION_CREATED`;
- `PROMOTION_UPDATED`;
- `PROMOTION_SUBMITTED`;
- `PROMOTION_APPROVED`;
- `PROMOTION_REJECTED`;
- `PROMOTION_ACTIVATED`;
- `PROMOTION_DEACTIVATED`.

Audit records must preserve actor, tenant, authorized location scope, affected promotion reference, meaningful changes, timestamp, and result without storing secrets.

## Current Scope

The Promotion/Commercial Rules **boundary and domain envelope are now defined**.

No promotion engine, page, API, migration, approval flow, discount type, or loyalty bonus behavior is automatically authorized by this document.

The first implementation checkpoint must be explicitly supplied by the user.

## Deferred / Future

Unless explicitly activated:

- coupons/vouchers/codes;
- buy-X-get-Y;
- free item/free service;
- advanced audience segmentation;
- campaign budget/cost controls;
- promotion scheduling automation beyond basic validity;
- channel-specific promotions;
- campaign orchestration/marketing automation;
- complex combinability engines;
- external promotion providers;
- any benefit type not explicitly scoped.

## Integration Rules

- one reusable Promotion authority for cross-domain commercial offers;
- POS and Workshop must not create separate drifting promotion engines;
- Catalog is referenced, not owned by Promotion;
- Membership owns loyalty state/ledger; Promotion may temporarily modify eligible benefits through explicit contracts;
- Tax/Fiscal remains the tax authority;
- promotion effects on money are backend-authoritative;
- Owner/Manager location authority is backend-enforced;
- organization-wide vs location-scoped authority must be explicit;
- historical monetary transactions preserve applied promotion outcomes;
- promotion visibility/configuration follows entitlement, runtime capability, permission, location scope, Catalog capability, and relevant business-domain context;
- no client-name or hard-coded business-type branching as authority.

# Promotion & Commercial Rules Scope Contract

Kind: `SHARED_BUSINESS_CAPABILITY`  
Status: `NEXT`  
Entitlement Class: `CAPABILITY`  
Commercial Packaging: integrated customer-loyalty/commercial suite, add-on/bundle capable

## Purpose

Provide one reusable Promotion/Commercial Rules authority for temporary commercial offers consumed by POS, Scheduling, Workshop, and future Digvation domains.

For the current product direction, **Promotion is part of one integrated Membership + Loyalty Points + Promotion business suite**, while preserving separate durable authorities:

```text
Customer
  -> Membership
      -> Loyalty Points

Promotion
  -> temporary discount/member/bonus-point outcomes
```

Promotion does not own Customer identity, Membership state, the Loyalty ledger, Catalog master data, Tax/Fiscal rules, POS Sale/payment, or another transaction domain.

## Commercial Availability / Effective Entitlement

Canonical capability:

```text
PROMOTIONS
```

Promotion may be commercially bundled together with Membership and Loyalty Points.

That packaging decision does not collapse runtime authority.

The effective capability set remains authoritative.

Source-code presence, navigation presence, business type, deployment mode, or branding never grants Promotion.

## Current Integrated Suite Decision

Current Digvation business experience treats these features as one coherent commercial/customer-retention suite:

- Membership;
- Loyalty Points;
- Promotions.

Conceptually:

```text
Membership
  -> identifies eligible member

Loyalty
  -> durable earn/redeem rules
  -> balance/ledger

Promotion
  -> temporary offer/rule
  -> may reference Membership
  -> may temporarily modify Loyalty outcome
```

The Backoffice may present these areas cohesively, but services/models must preserve ownership boundaries.

## Owns / Authority

Promotion owns:

- promotion identity;
- promotion name/description;
- promotion lifecycle;
- validity/effective period;
- applicable location scope;
- Catalog target references;
- Customer/Member eligibility;
- temporary commercial benefit;
- temporary loyalty bonus/multiplier;
- priority;
- simple stacking/exclusivity policy where current scope supports it;
- applied-promotion historical result/reference needed by transactions.

Promotion does not directly mutate point balances.

## Current Promotion Lifecycle

Use a minimal lifecycle:

- `DRAFT`
- `ACTIVE`
- `INACTIVE`
- `EXPIRED`

Current scope does not require approval workflow.

If approval is activated later, additional states/actions must be explicitly designed.

Runtime is authoritative for whether a promotion is currently effective.

## Validity

A promotion may define:

- start date/time;
- end date/time.

Runtime evaluates validity.

Frontend display must not be the only enforcement.

## Location Scope

A promotion may apply to:

- explicitly selected authorized location(s);
- organization-wide only when the actor has organization-level authority.

Permissions and location scope are backend-authoritative.

Do not use literal `Owner` or `Manager` role names as durable authorization logic.

## Catalog Targeting

Promotion references Catalog and does not own it.

Current first checkpoint supports targeting:

- all eligible Catalog entries;
- selected Catalog item/product/service entries.

Category/classification/tag targeting may be added later when explicitly activated.

Current Promotion must work with both product and service Catalog entries when the consuming domain supports them.

Promotion must not store temporary campaign state directly on Catalog entries.

## Customer / Membership Eligibility

Current promotion eligibility may be:

- `ALL_CUSTOMERS`;
- `MEMBERS_ONLY`.

`MEMBERS_ONLY` requires Membership capability/context.

Advanced tier/segment eligibility is deferred until those concepts are explicitly activated.

A Promotion may be valid without Membership.

## Current Benefit Types

Current first checkpoint supports a deliberately small set of benefit types.

### 1. Percentage Discount

Example:

```text
10% discount
```

### 2. Fixed Amount Discount

Example:

```text
Rp20.000 discount
```

### 3. Loyalty Bonus Points

Example:

```text
+5 bonus points
```

The resulting point ledger entry remains Loyalty-owned.

### 4. Loyalty Point Multiplier

Example:

```text
2x normal points
```

Promotion determines the temporary multiplier.
Loyalty applies/finalizes the resulting earning outcome in its ledger.

Fixed promotional price, BOGO, free item/service, coupons, vouchers, and advanced discount formulas are deferred unless explicitly activated.

## Promotion and Loyalty Rule Relationship

Normal/durable rules belong to Loyalty:

```text
Rp10.000 = 1 point
Hair Coloring = 20 fixed points
Gift Card = no normal points
10 points = Rp10.000 redemption value
```

Temporary campaign rules belong to Promotion:

```text
This weekend:
Haircut earns 2x points

September:
Members receive +5 bonus points on Service A
```

Promotion does not replace the underlying normal earning rule.

Conceptually:

```text
Loyalty normal earning result
       |
       +---- Promotion temporary modifier
       |
       v
Final earned-points outcome
       |
       v
Loyalty ledger
```

## Promotion and Membership Relationship

Membership provides member identity/status.

Promotion may require:

```text
MEMBERS_ONLY
```

Promotion must not create a second Membership record or membership status authority.

If Membership is not available, member-only promotion evaluation must not silently treat every customer as eligible.

## Discount Calculation Boundary

Promotion supplies a backend-authoritative commercial benefit outcome to the consuming transaction domain.

POS or another transaction owner remains responsible for authoritative transaction totals.

Conceptually:

```text
Catalog/base transaction input
       |
       v
Promotion evaluation
       |
       v
applied promotion outcome/reference
       |
       v
Transaction domain calculates authoritative monetary snapshot
```

Promotion must not become POS Sale authority.

## Interaction with Loyalty Earning

Current policy:

Normal spend-based Loyalty earning uses the accepted eligible transaction amount after ordinary Promotion discounts.

Example:

```text
Service price        Rp100.000
Promotion discount   Rp20.000
Eligible spend       Rp80.000

Loyalty:
Rp10.000 = 1 point

Normal earn = 8 points
```

If the Promotion also defines:

```text
2x points
```

then the Promotion modifier applies to the normal Loyalty result according to the explicit evaluation contract:

```text
8 normal points
x2 promotion multiplier
= 16 final earned points
```

The final ledger history remains Loyalty-owned and must preserve the promotion reference used to derive the result.

## Interaction with Loyalty Redemption

Loyalty redemption is governed by Membership/Loyalty configuration, not Promotion.

Promotion may reduce the monetary transaction outcome.

Loyalty then validates any redemption against the authoritative eligible transaction context and configured redemption limits.

Do not let Promotion directly debit points.

## Current Stacking Policy

Avoid a complex combinability engine in the first checkpoint.

Current rule:

- monetary promotions are non-stackable by default;
- when multiple monetary promotions are eligible, an explicit deterministic priority/evaluation rule must choose the applicable promotion;
- loyalty bonus/multiplier may coexist with one monetary promotion only when explicitly configured/supported by the evaluation contract.

Do not invent arbitrary frontend stacking.

Advanced stack groups, combinability matrices, and optimizer behavior are deferred.

## Usage / Historical Integrity

When a Promotion affects a transaction, the transaction/loyalty integration must preserve enough historical references/snapshots so later Promotion edits do not rewrite past outcomes.

At minimum, historical application should preserve:

- promotion identifier/reference;
- benefit type;
- applied monetary or loyalty outcome;
- applicable rule/version/snapshot information required by current Runtime design.

Do not recalculate old Sale history using the current Promotion configuration.

## Authorization

Promotion management is permission-based.

Conceptual permission areas:

- promotion read;
- promotion create;
- promotion update;
- promotion activate/deactivate;
- promotion delete/archive if current repository policy allows;
- promotion organization-wide management;
- promotion location-scoped management.

Location/organization scope remains authoritative.

Examples of business users who may receive these permissions include owners/managers, but literal role labels are not the authority.

## Backoffice Contribution

Promotion participates in the unified customer-loyalty/commercial experience.

Conceptually:

```text
Customers
  -> Membership
  -> Points

Commercial / Customer Loyalty
  -> Promotions

Configuration
  -> Membership & Loyalty
  -> Promotion defaults/policies where applicable
```

Exact navigation must follow current Backoffice information architecture and Design System conventions.

Current Promotion management surface may include:

- list/search/filter;
- create;
- detail;
- edit;
- activate/deactivate;
- validity period;
- location scope;
- Catalog targets;
- customer/member eligibility;
- benefit type/value;
- simple priority;
- current lifecycle/status;
- audit/history when Activity integration is implemented.

## Operational Contribution

Promotion normally has no standalone Operational application.

POS or another operational domain may show:

- eligible Promotion;
- applied discount;
- member-only benefit;
- bonus-point/multiplier result;
- promotion reference/name where useful.

Operational clients must not own/evaluate durable promotion truth independently.

## Dashboard Projection

When activated:

- active promotions;
- upcoming promotions;
- promotions nearing expiry;
- promotion usage count through explicit transaction projections;
- promotional discount/benefit value through authoritative projections;
- bonus points issued through Loyalty projection.

Promotion does not own sales/revenue authority.

## Report Projection

When activated:

- promotion master/status;
- promotion validity/location/target scope;
- promotion utilization through transaction-domain projections;
- promotion discount impact through monetary projections;
- promotion bonus-point impact through Loyalty projections.

No direct cross-domain database joins.

## Audit & Activity

Important administration should emit business-semantic Activity/Audit records when implemented.

Examples:

- `PROMOTION_CREATED`
- `PROMOTION_UPDATED`
- `PROMOTION_ACTIVATED`
- `PROMOTION_DEACTIVATED`

Approval-related audit events remain deferred with approval workflow.

## Current Scope

The current locked first Promotion checkpoint includes:

- Promotion capability-aware availability;
- `DRAFT`, `ACTIVE`, `INACTIVE`, `EXPIRED`;
- start/end validity;
- location scope;
- all-catalog or selected Catalog-entry targeting;
- all-customer or member-only eligibility;
- percentage discount;
- fixed-amount discount;
- loyalty bonus points;
- loyalty point multiplier;
- deterministic simple priority;
- non-stackable monetary promotion default;
- backend-authoritative evaluation;
- historical applied-promotion reference/outcome;
- POS consumption/integration;
- explicit Membership/Loyalty integration;
- Backoffice management surface;
- no standalone Operational module.

## Deferred / Future

Unless explicitly activated:

- coupons/codes;
- voucher system;
- buy-X-get-Y;
- free item/free service;
- fixed promotional price;
- advanced Catalog category/tag targeting;
- Membership tiers;
- customer segmentation;
- birthday campaign;
- referral campaign;
- campaign budget/cost controls;
- advanced usage quotas;
- channel-specific campaigns;
- approval workflow;
- advanced stacking/combinability matrices;
- automatic promotion optimization;
- external promotion providers;
- marketing automation/orchestration;
- push/email campaign delivery;
- cross-tenant campaigns.

## Integration Rules

- one reusable Promotion authority across business domains;
- Membership + Loyalty + Promotion form one integrated business suite but remain separate durable authorities;
- Promotion may reference Customer/Member eligibility;
- Promotion may temporarily modify Loyalty earning;
- Promotion never owns Loyalty balance/ledger;
- Loyalty owns normal earning/redemption rules;
- Catalog is referenced, not owned;
- POS owns Sale/payment;
- Promotion returns authoritative benefit outcomes/references but does not own Sale totals;
- monetary promotion effects are backend-authoritative;
- point bonus/multiplier effects are resolved through Loyalty;
- historical outcomes preserve applied Promotion references;
- permission and location/organization scope are backend-enforced;
- no literal role-name branching as authority;
- no direct cross-domain database/repository access;
- no client-name/business-type branching as feature authority;
- capability availability follows the effective entitlement set.

## Implementation Gate

This scope locks Promotion behavior and its relationship with Membership/Loyalty.

It does not authorize implementation by itself.

Implementation should begin only after the current Operational baseline is accepted, unless the user explicitly changes that priority.

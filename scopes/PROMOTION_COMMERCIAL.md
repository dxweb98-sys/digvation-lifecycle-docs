# Promotion & Commercial Rules Scope Contract

Kind: `SHARED_BUSINESS_CAPABILITY`  
Status: `PARTIAL`
Entitlement Class: `CAPABILITY`  
Commercial Packaging: integrated customer-loyalty/commercial suite, add-on/bundle capable

## Verified Delivery State

Monetary Promotion management/evaluation and member-only eligibility have accepted source in `dev`. The wider commercial/Loyalty suite is only partially delivered: bonus-point/multiplier benefits are not supported by the verified Promotion discount contract.

Evidence (verified 2026-10-16, Asia/Jakarta): Runtime `1190ec6d9b21628a23af78e299beb576c1f75c27` [types](https://github.com/dxweb98-sys/digvation-business-runtime/blob/1190ec6d9b21628a23af78e299beb576c1f75c27/src/modules/promotions/promotion.types.ts) and [evaluator](https://github.com/dxweb98-sys/digvation-business-runtime/blob/1190ec6d9b21628a23af78e299beb576c1f75c27/src/modules/promotions/promotion.policy.ts); Web `48341a9949f04f048d39e628ab33605b82dcea25` [management model](https://github.com/dxweb98-sys/digvation-business-web/blob/48341a9949f04f048d39e628ab33605b82dcea25/apps/backoffice/src/modules/promotions/promotion-editor-form.ts).

Release/deployment: `NOT_VERIFIED` here. Client availability still requires effective `PROMOTIONS`, permission/location scope, and Membership context for member-only benefits. Commercial bundling and scope status do not enable a client. Wider benefit/projection examples below remain envelope unless included in the verified `Current Scope`.

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
- temporary loyalty bonus/multiplier when separately implemented;
- deterministic selection/priority semantics supported by the accepted evaluator;
- simple stacking/exclusivity policy where current scope supports it;
- applied-promotion historical result/reference needed by transactions.

Promotion does not directly mutate point balances.

## Current Promotion Lifecycle

The current Runtime derives these statuses from the enabled flag and effective period:

- `ACTIVE`
- `SCHEDULED`
- `EXPIRED`
- `DISABLED`

There is no separate `DRAFT` approval state in the verified contract. Do not substitute conceptual `INACTIVE`/`DRAFT` enums for Runtime's transport vocabulary.

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

Current evaluation supports `ITEM`, `CATEGORY`, and `TRANSACTION` scope, with item, variant, category, and location references as applicable. A parent-item target covers its eligible variants; a variant target is precise. An overlap is one eligible candidate/benefit, not a second discount merely because both references match.

Advanced classification/tag targeting beyond the implemented category contract remains deferred.

Current Promotion must work with both product and service Catalog entries when the consuming domain supports them.

Promotion must not store temporary campaign state directly on Catalog entries.

## Customer / Membership Eligibility

Current promotion eligibility may be:

- `ALL`;
- `MEMBERS_ONLY`.

`MEMBERS_ONLY` requires Membership capability/context.

Advanced tier/segment eligibility is deferred until those concepts are explicitly activated.

A Promotion may be valid without Membership.

## Current Benefit Types

The current `PromotionDiscountType` supports two monetary benefit types.

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

## Deferred Loyalty Benefit Envelope

The following benefits retain their intended Promotion/Loyalty ownership, but are not implemented by the current monetary Promotion contract. They require an explicitly authorized work unit.

### Loyalty Bonus Points

Example:

```text
+5 bonus points
```

The resulting point ledger entry remains Loyalty-owned.

### Loyalty Point Multiplier

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

Current monetary integration policy:

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

For a future explicitly implemented Loyalty modifier, a conceptual example is:

```text
2x points
```

then the Promotion modifier applies to the normal Loyalty result according to the explicit evaluation contract:

```text
8 normal points
x2 promotion multiplier
= 16 final earned points
```

That future ledger integration remains Loyalty-owned and must preserve its Promotion reference. This example does not declare a current `2x` benefit type.

## Interaction with Loyalty Redemption

Loyalty redemption is governed by Membership/Loyalty configuration, not Promotion.

Promotion may reduce the monetary transaction outcome.

Loyalty then validates any redemption against the authoritative eligible transaction context and configured redemption limits.

Do not let Promotion directly debit points.

## Current Stacking Policy

Current Runtime ordering is explicit:

- choose one best eligible `ITEM`/`CATEGORY` monetary Promotion per line;
- choose one best eligible `TRANSACTION` Promotion on the remainder after line Promotions;
- choose by greatest discount amount, then stable Promotion identifier on a tie;
- apply manual discounts later under the Sale calculation contract, then Loyalty redemption and captured tax;
- automatic and submitted-code eligibility share the same backend evaluation; a changed cart may make a saved code temporarily ineligible without granting another discount.

Line and transaction benefits may therefore coexist in that defined order. There is no configurable priority/stack-group field or delivered Loyalty modifier to combine in the verified contract.

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
- backend-determined selection outcome;
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

The verified accepted monetary subset includes:

- Promotion capability-aware availability;
- enabled flag with derived `ACTIVE`, `SCHEDULED`, `EXPIRED`, `DISABLED`;
- start/end validity;
- location scope;
- `ITEM`, `CATEGORY`, and `TRANSACTION` targeting;
- parent-item and precise Variant targets without duplicated overlap benefits;
- `AUTOMATIC` or `CODE` mode, with supported minimum-purchase/maximum-discount configuration;
- all-customer or member-only eligibility;
- percentage discount;
- fixed-amount discount;
- deterministic best-per-line then best-per-transaction monetary evaluation;
- backend-authoritative evaluation;
- historical applied-promotion reference/outcome;
- POS consumption/integration;
- active-Membership eligibility; Loyalty ledger and durable earning rules remain separately owned;
- Backoffice management surface;
- no standalone Operational module.

## Deferred / Future

Unless explicitly activated:

- a voucher system beyond the implemented Promotion-code mode;
- Loyalty bonus points and point multipliers;
- buy-X-get-Y;
- free item/free service;
- fixed promotional price;
- advanced Catalog tag/classification targeting beyond implemented category scope;
- Membership tiers;
- customer segmentation;
- birthday campaign;
- referral campaign;
- campaign budget/cost controls;
- advanced usage quotas;
- channel-specific campaigns;
- approval workflow;
- a separate draft/approval lifecycle;
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

Further implementation requires an explicit work unit against the latest accepted baseline. Do not restart accepted monetary Promotion or infer implementation authority for the deferred Loyalty benefits.

# Customer, Membership & Loyalty Scope Contract

Kind: `SHARED_BUSINESS_FOUNDATION` + `SHARED_BUSINESS_CAPABILITY`  
Status: `NEXT`  
Entitlement Class: `PLATFORM_FOUNDATION` + `CAPABILITY`  
Commercial Packaging: customer identity foundation + bundled/optional Membership + Loyalty capability

## Purpose

Provide one reusable customer identity, Membership capability, and Loyalty Points authority that can be consumed by POS, Scheduling, Workshop, and future Digvation business domains.

For the current product direction, **Membership, Loyalty Points, and Promotion are treated as one integrated customer-loyalty/commercial experience**, but their durable authorities remain explicit:

```text
Customer
  -> Membership
      -> Loyalty Points

Promotion
  -> may target Customer / Membership
  -> may temporarily modify commercial or loyalty outcomes
```

Do not collapse these authorities into POS, Catalog, or one giant table.

Customer identity may exist without Membership.
Membership may exist without Loyalty Points when the effective capability set does not enable points.
Promotion may consume Membership/Loyalty but does not own the loyalty ledger.

## Current Product Decision

The current intended customer-loyalty feature set is:

- Customer identity/management;
- Membership enrollment and member status;
- Loyalty Points earning;
- Loyalty Points redemption;
- item/service-specific point rules;
- configurable default earning and redemption rules;
- POS integration;
- Promotion integration through the separate Promotion/Commercial authority.

This scope does not create paid subscription billing.

In current vocabulary, a customer "becomes a member" by enrollment into the business Membership program.

Paid membership fees, recurring subscription billing, renewal billing, and subscription plans are deferred unless explicitly activated later.

## Commercial Availability / Effective Entitlements

Customer identity, Membership, Loyalty Points, and Promotion are integrated from a business-user perspective but remain capability-aware.

Conceptually:

```text
CUSTOMER_IDENTITY
  -> shared reusable customer reference

CUSTOMER_MANAGEMENT
  -> optional customer-management surface

MEMBERSHIP
  -> member enrollment/status/identity

LOYALTY_POINTS
  -> point earning, balance, ledger, redemption

PROMOTIONS
  -> temporary commercial offers and loyalty modifiers
```

Commercial packaging may bundle Membership, Loyalty Points, and Promotions together for a client, but Runtime must consume the resolved effective capability set rather than infer access from a plan name, business type, deployment mode, or source-code presence.

## Customer Authority

Customer foundation owns reusable customer identity such as:

- tenant-scoped customer identity;
- customer number/reference where applicable;
- name;
- contact information;
- basic profile;
- customer status;
- reusable customer attributes explicitly approved later.

Customer identity is not a POS-local concept.

POS, Scheduling, Workshop, and future domains reference the same canonical customer.

## Membership Authority

Membership owns:

- membership enrollment;
- member number;
- membership status;
- membership joined/enrolled timestamp;
- link to exactly one canonical Customer;
- membership history required for durable business truth.

### Current Membership Model

Conceptually:

```text
Membership
- id
- tenantId
- customerId
- memberNumber
- status
- joinedAt
- createdAt
- updatedAt
```

Current status vocabulary should remain minimal:

- `ACTIVE`
- `INACTIVE`

Additional states such as suspended, expired, pending approval, or tier-specific state require explicit scope.

The canonical member number is backend-authoritative.

### Current Membership Enrollment

Membership may be enrolled from authorized Backoffice or Operational/POS flows.

Examples:

```text
Backoffice
Customer Detail
  -> Enroll Membership

Operational / POS
Customer lookup
  -> identify/create customer
  -> enroll as member when permitted
```

Authorization is permission-based.

Do not use literal role names such as `OWNER`, `MANAGER`, or `CASHIER` as the durable action authority.

## Loyalty Points Authority

When `LOYALTY_POINTS` is active, Membership/Loyalty owns:

- point balance;
- immutable point ledger/history;
- earning rules;
- item/service-specific earning overrides;
- earning exclusions;
- redemption rules;
- redemption validation;
- earn/redeem/reversal references to authoritative business transactions;
- historical point outcomes.

Catalog must not own durable `point` fields as loyalty authority.

POS must not own the loyalty ledger.

## Loyalty Ledger

The point ledger is historical authority.

Do not implement points only as a mutable balance.

Conceptually:

```text
PointLedgerEntry
- id
- tenantId
- membershipId
- type
- pointsDelta
- balanceAfter or derived balance reference
- sourceDomain
- sourceReference
- reason
- createdAt
```

Current ledger event concepts:

- `EARN`
- `REDEEM`
- `EARN_REVERSAL`
- `REDEEM_REVERSAL`
- `ADJUSTMENT` only when an explicitly permitted administrative correction is implemented

Accepted behavior:

```text
Sale completed
+10 EARN

Later refund
-10 EARN_REVERSAL
```

Historical entries are not deleted or rewritten merely because a transaction is later refunded/voided.

A cached/materialized balance may exist for performance, but the ledger remains the durable historical authority.

## Default Point Earning Configuration

Loyalty Points provides a tenant-level default earning configuration.

Current default model:

```text
Spend X currency units
earns
Y points
```

Example:

```text
Rp10.000 = 1 point
```

For spend-based earning, current calculation is conceptually:

```text
earnedPoints =
FLOOR(eligibleAmount / spendUnit) * pointsPerUnit
```

Example:

```text
eligibleAmount = Rp99.000
spendUnit      = Rp10.000
pointsPerUnit  = 1

earnedPoints = 9
```

Do not use client-side rounding as authority.

Money/decimal rounding follows the Runtime monetary conventions.

## Eligible Amount for Spend-Based Points

Current loyalty policy:

- use authoritative transaction line outcomes from the originating transaction domain;
- use the actual eligible merchandise/service amount after ordinary discounts/promotions;
- exclude tax from point-earning basis where tax is represented separately;
- do not use mutable Catalog list price as historical earning truth;
- point calculation is backend-authoritative.

Loyalty redemption is not treated as a Catalog price mutation.

The exact monetary projection must use the accepted POS/transaction contract at implementation time rather than duplicating transaction math inside Loyalty.

## Catalog-Targeted Point Rules

Loyalty may target Catalog entries but does not own Catalog.

Current first checkpoint supports:

### 1. Default Spend Rule

An eligible Catalog item/service uses the tenant default earning rule.

Example:

```text
Default:
Rp10.000 = 1 point

Haircut Rp50.000
-> 5 points
```

### 2. Fixed Point Override Per Catalog Entry

An authorized administrator may define:

```text
Hair Coloring
-> 20 points per purchased quantity
```

This rule is stored under Membership/Loyalty authority while referencing the Catalog entry.

It is not stored as canonical `Catalog.point`.

### 3. Point Earning Exclusion

An eligible Catalog entry may explicitly earn no normal points.

Example:

```text
Gift Card
-> earning disabled
```

### Rule Precedence

Current precedence:

```text
Catalog-specific Loyalty rule
    -> if FIXED_POINTS, apply fixed rule
    -> if EXCLUDED, earn zero normal points
    -> otherwise
Default Spend Rule
```

Advanced category/tag/classification rules are deferred unless explicitly activated.

## Multiple Quantities

For `FIXED_POINTS`:

```text
earnedPoints =
fixedPointsPerUnit * eligibleQuantity
```

For spend-rate rules, points are derived from the authoritative eligible monetary amount.

## When Points Are Earned

Normal points are not issued when an item is merely:

- viewed;
- added to cart;
- reserved;
- placed in an Appointment;
- placed in an unpaid transaction.

Current POS integration rule:

```text
Sale reaches accepted completed/paid business outcome
    -> Loyalty receives authoritative sale reference/outcome
    -> Loyalty evaluates earning
    -> ledger EARN is recorded
```

The integration must be idempotent.

Retrying the same completed Sale must not duplicate earned points.

## Refund / Void / Reversal

Refund/void behavior must preserve history.

When an earning transaction is reversed in whole or part, Loyalty records compensating ledger entries rather than mutating the original earning record.

Conceptually:

```text
SALE-001
+10 EARN

REFUND-001
-10 EARN_REVERSAL
```

Partial refunds reverse only the authoritative loyalty outcome attributable to the refunded portion according to the accepted POS refund contract.

If redeemed points must be restored because a transaction is reversed, use `REDEEM_REVERSAL` or equivalent repository-consistent vocabulary.

Do not silently recalculate historical points using today's rules.

## Redemption Configuration

Loyalty Points provides tenant-level redemption configuration.

Current model:

```text
A points = B currency value
```

Example:

```text
10 points = Rp10.000
```

Current configurable constraints:

- conversion unit;
- minimum points per redemption;
- maximum redemption percentage of the eligible transaction value;
- enabled/disabled redemption.

Example:

```text
10 points = Rp10.000
minimum redemption = 10 points
maximum redemption = 50% of eligible transaction value
```

All redemption math is backend-authoritative.

### Redemption Validation

Runtime validates:

- member is active;
- Loyalty Points capability is active;
- sufficient point balance;
- minimum redemption;
- maximum redemption;
- transaction is eligible;
- requested redemption has not already been consumed;
- tenant/location/permission context where applicable.

Operational UI may preview the result but is not monetary or loyalty authority.

## POS Redemption Flow

Conceptually:

```text
POS identifies Customer/Member
        |
        v
Loyalty provides current balance + redeemable outcome
        |
        v
Authorized redemption request
        |
        v
Loyalty validates/reserves or records redemption according to transaction contract
        |
        v
POS completes authoritative Sale/payment flow
        |
        v
Loyalty finalizes historical ledger references
```

The exact transactional consistency strategy must be designed against current POS Runtime reality before implementation.

Loyalty must not become POS payment authority.

POS must not mutate point balance directly.

## Relationship with Promotion

Membership/Loyalty and Promotion form one integrated business experience but retain separate rule authority.

### Loyalty Owns Durable Rules

Examples:

- default `Rp10.000 = 1 point`;
- item A = 20 fixed points;
- item B earns no points;
- `10 points = Rp10.000` redemption;
- point balance/ledger.

### Promotion Owns Temporary Modifiers

Examples:

- members receive 10% discount during a date range;
- Haircut earns 2x points this weekend;
- members receive +5 bonus points for Service A;
- selected members receive a temporary member price.

Promotion may call/compose with Loyalty to produce a bonus outcome.

Promotion never writes or owns the point ledger directly.

The resulting earned/redeemed point history remains Loyalty-owned.

## Owner / Manager Configuration Intent

Business users such as owners/managers are expected to configure Membership/Loyalty behavior through Backoffice when their effective permissions and location/organization scope allow it.

Do not hard-code role labels as authority.

Conceptual permission areas:

- customer read/manage;
- membership read/enroll/update;
- loyalty configuration read/update;
- loyalty rule read/update;
- loyalty ledger read;
- loyalty administrative adjustment when explicitly activated.

Organization-wide configuration requires the appropriate organization-level permission/policy.

Location-specific rules, if introduced later, require explicit design rather than assuming a Manager's branch scope automatically changes global loyalty configuration.

## Backoffice Contribution

Customer/Membership/Loyalty may contribute one coherent customer-loyalty management experience.

Conceptually:

```text
Customers
  -> Customer List
  -> Customer Detail
       -> Profile
       -> Membership
       -> Points Balance
       -> Points History

Configuration
  -> Membership & Loyalty
       -> Membership
       -> Earning
       -> Redemption
       -> Item Overrides
```

Exact navigation follows accepted Backoffice information architecture and Design System patterns.

### Item Override Presentation

Conceptually:

| Catalog Entry | Current Price | Earning Rule |
| --- | ---: | --- |
| Haircut | Rp50.000 | Default |
| Hair Coloring | Rp150.000 | Fixed 20 points |
| Shampoo | Rp30.000 | Default |
| Gift Card | Rp100.000 | No points |

Displayed price is informational; Loyalty rule authority remains separate from Catalog price authority.

## Operational Contribution

Operational/POS may:

- search/select customer;
- identify Membership;
- enroll customer as member when permitted;
- display active member state;
- display current point balance when Loyalty Points is enabled;
- preview points to be earned;
- request redemption;
- display final earned/redeemed balance outcome after authoritative Runtime processing.

Operational does not own Membership/Loyalty rules.

## Dashboard Projection

When activated, Membership/Loyalty may contribute:

- total members;
- active members;
- new member enrollments;
- points issued;
- points redeemed;
- outstanding point balance;
- member vs non-member transaction contribution through explicit POS projections.

Cross-domain monetary/performance metrics must preserve POS or other transaction-domain authority.

## Report Projection

When activated:

- customer list/status;
- membership enrollment/status;
- point ledger/history;
- point earn/redemption report;
- loyalty adjustment report if administrative adjustment is implemented.

Member spend or transaction performance must use explicit POS/domain projections rather than direct cross-domain table access.

## Current Scope

The current locked Customer/Membership/Loyalty checkpoint includes:

### Customer

- canonical customer identity;
- basic customer management required for Membership/POS integration.

### Membership

- enroll existing/new Customer as Member;
- backend-authoritative member number;
- `ACTIVE` / `INACTIVE`;
- joined date;
- member lookup/status;
- Backoffice management;
- Operational/POS identification/enrollment when permitted.

### Loyalty Points

- optional capability-aware points feature;
- immutable ledger;
- balance;
- default spend-based earning rule;
- per-Catalog-entry fixed point override;
- per-Catalog-entry earning exclusion;
- earn after accepted completed POS Sale outcome;
- idempotent Sale earn integration;
- refund/void earning reversal;
- configurable redemption conversion;
- minimum redemption;
- maximum redemption percentage;
- POS redemption integration;
- points history.

### Integrated Promotion Relationship

Promotion may:

- target members;
- provide temporary member benefits;
- add bonus points;
- apply a temporary point multiplier.

Promotion remains governed by `PROMOTION_COMMERCIAL.md`.

## Deferred / Future

Unless explicitly activated:

- paid Membership subscription;
- recurring Membership fee;
- Membership renewal billing;
- multiple membership programs per tenant;
- Silver/Gold/Platinum or other tiers;
- automatic tier progression;
- point expiry;
- birthday points;
- referral points;
- point transfer;
- household/shared points;
- manual bonus campaigns outside Promotion;
- advanced segmentation;
- category/tag/classification earning rules;
- complex point wallets;
- external loyalty providers;
- cross-tenant loyalty;
- customer self-service portal/app;
- advanced adjustment/approval workflows.

## Integration Rules

- one canonical Customer identity across business domains;
- Membership references Customer and does not duplicate Customer master data;
- Membership and Loyalty Points are reusable cross-domain capabilities, not POS-local features;
- POS owns Sale/payment and only supplies authoritative transaction outcomes;
- Catalog owns item/service identity, not loyalty rules;
- item-specific point rules are Loyalty-owned references to Catalog;
- Promotion owns temporary campaign benefits/modifiers;
- Loyalty owns durable earning/redemption rules and all point ledger history;
- normal point earning is backend-authoritative;
- redemption is backend-authoritative;
- historical ledger entries are immutable/compensated rather than rewritten;
- retries must be idempotent;
- no direct cross-domain database/repository access;
- permission and location/organization scope remain backend-enforced;
- do not use literal role names as durable authority;
- Membership/Loyalty availability follows effective capabilities rather than menu/source presence;
- no client-name/business-type branching as authority.

## Implementation Gate

This scope locks business/domain behavior only.

It does not authorize implementation by itself.

Implementation must begin only through an explicit work unit after the current Operational baseline is accepted, unless the user explicitly changes that priority.

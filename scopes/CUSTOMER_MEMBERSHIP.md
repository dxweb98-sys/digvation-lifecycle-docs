# Customer, Membership & Loyalty Scope Contract

Kind: `SHARED_BUSINESS_FOUNDATION` + `SHARED_BUSINESS_CAPABILITY`  
Status: `PARTIAL`
Entitlement Class: `PLATFORM_FOUNDATION` + `CAPABILITY`  
Commercial Packaging: customer identity foundation + bundled/optional Membership + Loyalty capability

## Verified Delivery State

The Customer directory, Membership enrollment/management, Loyalty configuration/ledger/earn/redeem, finalized-Sale compensation, member import/opening points/manual adjustment, and member portal have accepted source in `dev`. This is a delivered subset of the wider integrated suite; it does not imply campaign point modifiers or every conceptual configuration below is implemented.

Evidence (verified 2026-10-16, Asia/Jakarta): Runtime `1190ec6d9b21628a23af78e299beb576c1f75c27` [enrollment](https://github.com/dxweb98-sys/digvation-business-runtime/blob/1190ec6d9b21628a23af78e299beb576c1f75c27/src/modules/membership/membership.dto.ts), [earning/configuration](https://github.com/dxweb98-sys/digvation-business-runtime/blob/1190ec6d9b21628a23af78e299beb576c1f75c27/src/modules/loyalty/loyalty-configuration.types.ts), [ledger facts](https://github.com/dxweb98-sys/digvation-business-runtime/blob/1190ec6d9b21628a23af78e299beb576c1f75c27/src/modules/loyalty/loyalty-ledger.types.ts), and [member portal](https://github.com/dxweb98-sys/digvation-business-runtime/blob/1190ec6d9b21628a23af78e299beb576c1f75c27/src/modules/member-portal/member-portal.controller.ts); Web `48341a9949f04f048d39e628ab33605b82dcea25` [Loyalty configuration](https://github.com/dxweb98-sys/digvation-business-web/blob/48341a9949f04f048d39e628ab33605b82dcea25/apps/backoffice/src/modules/loyalty/loyalty-configuration-model.ts) and accepted [member administration change](https://github.com/dxweb98-sys/digvation-business-web/commit/555a09044cea30db97204269a47ea44f28ff6515).

Release/deployment: `NOT_VERIFIED` by this reconciliation. Client enabled/disabled state is separate: Customer identity remains reusable, and Membership/Loyalty require their own effective grants and permissions. Do not infer live availability from `PARTIAL`, source presence, or commercial bundling. Wider suite behavior below is an envelope unless identified in `Current Scope` as implemented.

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

Current new-Member enrollment uses name and phone, or references an existing canonical Customer. NIK is not part of the current enrollment DTO. Preserve the accepted phone normalization contract and backend-authoritative member identity.

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
- `OPENING_BALANCE`
- `IMPORT_POINTS`
- `MANUAL_ADJUSTMENT` with actor/reason and the accepted administrative permission

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

Current Runtime supports exactly one earning mode per Sale:

- `PER_ITEM` (compatibility default): tenant default behavior is `FIXED` or `EXCLUDED`, with a fixed-points-per-unit value and optional item overrides.
- `TRANSACTION_TOTAL`: the configured transaction amount/points step determines spend-based earning. Item earning rules do not stack with this mode.

The independent `earnWhileRedeemingPolicy` selects `EARN_WHEN_REDEEMING` or `NO_EARN_WHEN_REDEEMING` (compatibility default). Do not silently enable both modes or imply that every Sale earns while redeeming.

For `TRANSACTION_TOTAL`, the spend-based model is:

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

Within `PER_ITEM`, current configuration supports:

### 1. Tenant Default Item Rule

An eligible Catalog item/service without an override uses the tenant default `FIXED` points-per-unit or `EXCLUDED` behavior.

Example:

```text
Default: FIXED 5 points per unit
Haircut quantity 1 -> 5 points
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

Current `PER_ITEM` precedence:

```text
Catalog-specific Loyalty rule
    -> if FIXED, apply fixed rule
    -> if EXCLUDED, earn zero normal points
    -> otherwise
Tenant Default Item Rule
```

`TRANSACTION_TOTAL` instead uses its transaction-level step rule. Advanced category/tag/classification rules are deferred unless explicitly activated.

## Multiple Quantities

For `FIXED`:

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
Sale reaches FINALIZED under the accepted POS contract
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

The verified Sale reversal command is a finalized-Sale compensation flow, not authorization for a new partial-refund engine. If partial refunds are activated later, reverse only the authoritative loyalty outcome attributable to the refunded portion under an explicitly accepted POS contract.

If redeemed points must be restored because a transaction is reversed, use `REDEEM_REVERSAL` or equivalent repository-consistent vocabulary.

Do not silently recalculate historical points using today's rules.

## Redemption Configuration

Loyalty Points provides tenant-level redemption configuration.

Current configuration exposes the currency value of one point (`pointValue`); the following conversion is an equivalent business presentation:

```text
A points = B currency value
```

Example:

```text
10 points = Rp10.000
```

Current requests carry a positive points amount; Runtime bounds redemption by the eligible pre-tax Sale amount and available balance. Capability availability is distinct from the configured point value. A separately configurable minimum, maximum percentage, or redemption toggle is not established by the verified configuration contract; those remain future configuration envelope, not delivered settings.

All redemption math is backend-authoritative.

### Redemption Validation

Runtime validates:

- member is active;
- Loyalty Points capability is active;
- sufficient point balance;
- positive requested points and the eligible pre-tax amount bound;
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
Runtime validates redemption through the accepted Sale contract
        |
        v
POS completes authoritative Sale/payment flow
        |
        v
Loyalty finalizes historical ledger references
```

Preserve the accepted Runtime Sale/finalization consistency and idempotency strategy. Do not redesign it from this conceptual flow.

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

Monetary member offers are implemented; bonus-point/multiplier and temporary member-price examples describe the wider envelope and are not current delivered Loyalty modifiers.

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

The verified accepted subset includes:

### Customer

- canonical customer identity;
- basic customer management required for Membership/POS integration.
- canonical customer directory lookup/pagination and reuse rather than a separate Member customer identity.

### Membership

- enroll existing/new Customer as Member;
- backend-authoritative member number;
- `ACTIVE` / `INACTIVE`;
- joined date;
- member lookup/status;
- Backoffice management;
- Operational/POS identification/enrollment when permitted.
- name/phone enrollment without NIK, existing-customer enrollment, and accepted import support.
- phone/WhatsApp-OTP member portal with summary, points, and transaction views; this does not imply a general customer app.

### Loyalty Points

- optional capability-aware points feature;
- immutable ledger;
- balance;
- mutually exclusive `PER_ITEM` and `TRANSACTION_TOTAL` earning modes;
- tenant default `FIXED` / `EXCLUDED` behavior and transaction amount/points steps;
- per-Catalog-entry fixed point override;
- per-Catalog-entry earning exclusion;
- earn after accepted `FINALIZED` POS Sale outcome;
- idempotent Sale earn integration;
- finalized-Sale reversal with compensating earn/redeem facts;
- configurable redemption conversion;
- Runtime validation of requested points, available balance, and eligible pre-tax amount;
- POS redemption integration;
- points history.
- opening balances, legacy import credit, and permission-controlled manual point adjustment with actor/reason history.

### Integrated Promotion Relationship

Implemented Promotion may target active members for monetary discounts. Loyalty bonus points and temporary point multipliers remain deferred; integration boundaries do not prove those benefit types exist in Runtime.

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
- separately configurable minimum/maximum-percentage redemption settings beyond the current point-value and Sale-bound contract;
- Promotion bonus-point/multiplier integration;
- external loyalty providers;
- cross-tenant loyalty;
- a general customer self-service app beyond the implemented member portal;
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

Further implementation requires an explicit work unit against the latest accepted baseline. Do not restart already accepted features or activate the wider suite/deferred envelope from this contract alone.

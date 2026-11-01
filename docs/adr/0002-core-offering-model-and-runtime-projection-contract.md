# ADR 0002: CORE Offering Model and Runtime Projection Contract

- **Status:** Accepted (2026-11-01).
- **Refines:** [ADR 0001](0001-commercial-offerings-and-operational-applications.md) implementation step 4; resolves its gates G1 and G2.
- **Scope:** Ecosystem architecture and the CORE → Runtime integration contract. Not implementation authority: each [work unit](#implementation-work-units) needs its own approval.
- **Evidence:** CORE `digvation-core-dev` `49c591e5` and Runtime `dev` `25f49078`, verified 2026-11-01.

## Context

Today CORE emits `Product.code` directly as the Runtime product code. `ProductCapability` expresses compatibility only, with no inclusion. Add-ons belong to one Product, and `RuntimeBinding` references one `ClientProduct`. The projection resolves client-wide and does not consider which offerings the bound runtime serves. Runtime rejects unknown codes, requires `coreClientProductId`, and ignores extra payload fields.

## Decisions (product owner, 2026-11-01)

| ID | Decision |
| --- | --- |
| G1 | **A.** Client-scoped shared add-on subscriptions, billed once per client. A synthetic platform product (B) is rejected. |
| G2 | **Approved.** The Runtime binding moves from `ClientProduct` to the Installation through an expand/contract migration. |
| D1 | Application codes: legacy Operational = `OPERATIONAL_APP`; POS Salon = `POS_SALON_APP`. `BACKOFFICE` is emitted in the application set whenever any offering is active. |
| D2 | The nine `DRAFT` capabilities used by the live installation are activated through the catalog lifecycle when CORE is prepared for release, never by seed. |
| D3 | Shared add-ons are four packages: Customer Engagement (`MEMBERSHIP`, `LOYALTY_POINTS`, `PROMOTIONS`), Attendance (`WORKFORCE_ATTENDANCE`), Multi-Location (`MULTI_BRANCH`), Finance Operations (`FINANCE_OPERATIONS`). |
| D4 | `BUSINESS_ANALYTICS` is not included in POS Salon; basic reporting does not require it. |
| D5 | An offering keeps following the operator-set `ClientProduct` status. Subscription-driven deactivation is later work. |

### POS Salon packaging

| Offering | Domain | Application | Included capabilities | Compatible shared add-ons |
| --- | --- | --- | --- | --- |
| `POS_SALON` | `POS` | `POS_SALON_APP` | `POS_PRODUCT_SALES`, `POS_SERVICE_SALES`, `POS_PRODUCT_COMMISSION`, `CATALOG_SERVICE_COMPOSITION`, `EMPLOYEE_WORKFORCE`, `TAX_FISCAL` | Customer Engagement, Attendance, Multi-Location, Finance Operations |

Dedicated white-label offerings may include `MULTI_BRANCH` with a branch limit. Quantity limits are a later, separate decision (see [Quantity limits](#quantity-limits-reserved)).

## Offering model

An offering is a CORE `Product` (priced, held through `ClientProduct`, subscribed through `Subscription`). Its Runtime meaning comes only from explicit mappings, never from `Product.code`.

| Concept | Model | Rule |
| --- | --- | --- |
| Domain grant | `ProductDomainGrant` (new) | Codes from the Runtime domain vocabulary (`POS`, `INVENTORY`, `WORKSHOP`) |
| Application grant | `ProductApplicationGrant` (new) | Codes from the application vocabulary (`OPERATIONAL_APP`, `POS_SALON_APP`, …) |
| Included capability | `ProductCapability.inclusion = INCLUDED` (extension) | An included capability is compatible by construction |
| Compatible capability | `ProductCapability.inclusion = COMPATIBLE` (current meaning) | Allows a grant; grants nothing by itself |

- Domain and application vocabularies are owned in code and mirrored with Runtime, like the capability vocabulary. Writes reject unknown codes, and a contract test proves that CORE output is a subset of the Runtime vocabulary.
- Existing products are backfilled as follows. `POS` → domain `POS`, application `OPERATIONAL_APP`, nothing included, so current projections are unchanged. `WORKSHOP` → `WORKSHOP` and `INVENTORY` → `INVENTORY`.
- Changing an inclusion or mapping on an `ACTIVE` product that effective clients hold changes their effective set. Like the existing compatibility guard, such a change is rejected (409) unless an explicit operator decision allows it. Seed creates missing rows only and never changes an existing status, inclusion, or mapping.
- `POS_SALON` is seeded as `DRAFT`.

```prisma
enum CapabilityInclusion { COMPATIBLE INCLUDED }
model ProductCapability { /* existing */ inclusion CapabilityInclusion @default(COMPATIBLE) }

model ProductDomainGrant {
  productId  String @db.Uuid
  domainCode String @db.Citext
  @@id([productId, domainCode]) @@map("product_domain_grants")
}
model ProductApplicationGrant {
  productId       String @db.Uuid
  applicationCode String @db.Citext
  @@id([productId, applicationCode]) @@map("product_application_grants")
}
```

## Client-scoped shared add-ons

| Concept | Model | Rule |
| --- | --- | --- |
| Catalog | `AddOnOffering.scope` = `PRODUCT` \| `CLIENT` | `productId` is required for `PRODUCT` and absent for `CLIENT`. Codes are unique per product (`PRODUCT`) or globally (`CLIENT`). Feature grants are allowed for `PRODUCT` only. |
| Holding | `ClientAddOn` (new) | One per client and add-on, with a lifecycle that mirrors `ClientProduct` |
| Commercial term | `Subscription` | Owned by exactly one of `ClientProduct` or `ClientAddOn`, and reuses `SubscriptionTerm`, renewal, lifecycle, and audit |
| Compatibility | `ProductCapability` (reused) | No separate add-on compatibility table |

- **Lifetime rule:** a shared add-on capability is effective only while the holding is effective, its subscription is effective, a term covers now, the capability is `ACTIVE`, and at least one effective offering in the same projection scope is compatible with it.
- Activation is rejected (409) unless every capability of the add-on is compatible with at least one effective offering of the client.
- A shared add-on has its own term starting at purchase, so it needs no co-term proration. `CO_TERM_PRORATED` remains for `PRODUCT` add-ons.
- Existing `PRODUCT` add-ons stay valid. New `PRODUCT`-scope grants of a capability sold as a shared add-on are rejected, to prevent double billing.
- The compatibility guard also counts effective `ClientAddOn` dependents.

```prisma
enum AddOnScope { PRODUCT CLIENT }
model AddOnOffering { productId String? @db.Uuid  scope AddOnScope @default(PRODUCT) }   // CHECK + partial uniques in SQL
model ClientAddOn {
  id              String @id @db.Uuid
  clientId        String @db.Uuid
  addOnOfferingId String @db.Uuid
  status          ClientAddOnStatus @default(PROVISIONING)
  @@unique([clientId, addOnOfferingId]) @@map("client_add_ons")
}
model Subscription { clientProductId String? @unique  clientAddOnId String? @unique }   // CHECK num_nonnulls(...) = 1
```

## Installation-centered binding

- `RuntimeBinding.installationId` replaces `clientProductId`. There is at most one `ACTIVE` binding per Installation.
- `InstallationProductBinding` carries `clientId`, with composite foreign keys to the Installation and the `ClientProduct`. The database therefore rejects binding another client's offering.
- A client may serve a domain from at most one Installation per environment, which keeps a single POS ledger. Service validation enforces this.
- Decommissioning an Installation revokes its bindings in the same transaction.
- Projection scope = the client's effective set limited to offerings bound to that Installation, plus that Installation's grandfathered grants.

**Migration (expand/contract):**

1. **Expand:** add nullable `installation_id`. Backfill a row only when exactly one Installation binds its `client_product_id`. If any row has zero or several candidates, the migration fails and lists those rows; it never guesses.
2. **Contract**, after the Runtime consumer is released: make `installation_id` `NOT NULL` and drop `client_product_id`.

```prisma
model RuntimeBinding { clientProductId String? @db.Uuid  installationId String? @db.Uuid }   // UQ(installation_id) WHERE status = 'ACTIVE'
model InstallationProductBinding { clientId String @db.Uuid }                               // composite FKs (…, client_id)
model InstallationGrandfatheredGrant {
  installationId String @db.Uuid
  kind           GrandfatheredGrantKind   // DOMAIN | APPLICATION | CAPABILITY
  code           String @db.Citext
  status         RuntimeBindingStatus     // ACTIVE | REVOKED
  sourceEvidence String                   // e.g. manifest sha256
  @@unique([installationId, kind, code])
}
```

## Resolution

```text
O = offerings of the client with ClientProduct TRIAL/ACTIVE and Product ACTIVE, bound to the Installation   (D5)
G = ACTIVE grandfathered grants of the Installation
live(c)       = Capability c is ACTIVE
compatible(c) = ∃ o ∈ O : ProductCapability(o, c)

domains      = ∪ ProductDomainGrant(O)      ∪ G.DOMAIN
applications = ∪ ProductApplicationGrant(O) ∪ G.APPLICATION ∪ { BACKOFFICE if O ≠ ∅ }   (D1)
capabilities = { c INCLUDED by o ∈ O              | live(c) }
             ∪ { c of effective ClientCapability   | live(c) ∧ compatible(c) }
             ∪ { c of live PRODUCT add-on on o ∈ O | live(c) ∧ ProductCapability(o, c) }
             ∪ { c of effective CLIENT add-on      | live(c) ∧ compatible(c) ∧ term covers now }
             ∪ { c ∈ G.CAPABILITY                  | live(c) }
```

- An inactive client resolves to the empty set.
- Grandfathered grants bypass compatibility but **still follow catalog status**, so a `DRAFT` capability never becomes effective. Grandfather snapshots record `BACKOFFICE` and `OPERATIONAL_APP` as application grants, so a technical migration never removes Backoffice.
- Every emitted code is validated against the Runtime vocabulary. A failure rejects the projection (an error response, logged); codes are never silently dropped.
- **Live baseline:** grandfathered `POS` plus the twelve live capabilities, or `POS_SALON` plus the four shared add-ons, each reproduce the live set as a superset once D2 has activated the nine `DRAFT` capabilities. Until then, no-loss verification blocks cutover.

## Projection contract

| Field | v1 (current) | v2 (expand) | After contract |
| --- | --- | --- | --- |
| `contractVersion` | absent | `2` | `2` |
| `runtimeBindingId`, `runtimeId`, `resolvedAt` | present | present | present |
| `coreClientProductId` | required | only while the binding still has one | removed |
| `coreInstallationId` | — | present | required |
| `effectiveEntitlements.products` | `Product.code` of effective ClientProducts | domain codes from `ProductDomainGrant` | same |
| `effectiveEntitlements.capabilities` | v1 resolution | [Resolution](#resolution) | same |
| `effectiveEntitlements.applications` | — | present; ignored by current Runtime | consumed after ADR 0001 step 6 |

- Offering codes never appear in `products`. Application codes never appear in `products` or `capabilities`, because Runtime would reject the whole projection.
- **Sequence:**
  1. CORE emits v2 alongside the v1 fields.
  2. Runtime accepts v2 and validates `coreInstallationId` against a new tenant anchor column (Runtime migration). It stores `applications` without enforcing them.
  3. CORE removes `coreClientProductId`.
- Once Runtime enforces applications, an unknown application code rejects the projection.

## Quantity limits (reserved)

This is not part of the contract yet. A later decision may attach limits to a grant source (included capability, client add-on, or client capability). For example, `EntitlementLimit(sourceKind, sourceId, capabilityId, limitKey, maxValue)` would surface as an optional `effectiveEntitlements.limits[]`. An absent limit means unlimited, which preserves today's on/off semantics. How limits combine is part of that decision.

## Implementation work units

Each unit is separately approved. Migrations run on a test database first, under their own approval.

1. **CORE offering mapping:** inclusion, domain and application grants, vocabulary validation, `POS_SALON` seeded `DRAFT`, backfill of existing products, mapping change guard.
2. **CORE resolution v2:** domains and included capabilities from the mapping. No behavior change for `POS`.
3. **CORE client-scoped shared add-ons:** scope, `ClientAddOn`, Subscription ownership, lifetime rule.
4. **CORE Installation binding and projection v2 (expand):** `installationId`, client-consistent bindings, one Installation per domain per client and environment.
5. **Runtime consumer:** v2 contract, installation identity, stored applications without enforcement.
6. **Grandfather snapshot tooling:** `InstallationGrandfatheredGrant`, snapshot import, no-loss verification per Installation.
7. **CORE contract phase:** drop `RuntimeBinding.clientProductId` and `coreClientProductId`.

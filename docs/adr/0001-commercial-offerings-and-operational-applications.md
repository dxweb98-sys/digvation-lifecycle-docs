# ADR 0001: Commercial Offerings, Domain Grants, and Operational Applications

- **Status:** Accepted in principle (2026-10-28). Items marked **Decision gate** are not final contracts.
- **Scope:** Ecosystem architecture. Not implementation authority; each step in [Implementation sequence](#implementation-sequence) needs its own approval.
- **Refines:** [ECOSYSTEM_ARCHITECTURE.md](../../standards/ECOSYSTEM_ARCHITECTURE.md) §5 (operational application identity), §6, §15, §16, §24.
- **Current-state evidence:** [docs/CURRENT_PLATFORM.md](../CURRENT_PLATFORM.md); audit evidence recorded in the 2026-10-27/28 architecture review.

## Context

Digvation wants independently purchased and deployed operational applications (POS Salon, a future POS Laundry, Inventory, Workshop) while keeping one Backoffice, reusable business domains, and exactly one POS financial authority.

Verified constraints (2026-10-28):

- No current behavior is Salon-specific. Queue, service performers, commission, and Service composition are generic POS behavior; "Salon" appears only in placeholder copy.
- CORE `Product`, `ClientProduct`, `Subscription`, `AddOnOffering`, and `ProductPrice` exist. `ProductPrice` allows one price per product, cycle, and currency; `AddOnOffering` belongs to one Product; `Subscription` belongs to one `ClientProduct`.
- `RuntimeBinding` references one `ClientProduct`; Runtime CORE sync requires exactly one CORE-bound tenant per Runtime and validates one `coreClientProductId`.
- CORE effective entitlements resolve client-wide. CORE and Runtime capability vocabularies differ, and Runtime CORE sync silently drops unknown codes.
- Runtime knows only `BACKOFFICE`/`OPERATIONAL` as a client-supplied channel (`X-Digvation-Session-Channel`). Sales carry no origin application.
- The Workshop lane (`dev-workshop`) uses a different, smaller entitlement vocabulary than `dev`.

## Decision

Separate four layers. Each has one owner and is never substituted for another.

| Layer | Meaning | Owner | Examples |
| --- | --- | --- | --- |
| Commercial offering | What a client buys, prices, subscribes to, and cancels | CORE (`Product` + `Subscription`) | `POS_SALON`, `POS_LAUNDRY`, `INVENTORY`, `WORKSHOP` |
| Domain grant | Which authoritative Runtime domain is enabled | Runtime vocabulary, resolved by CORE mapping or Dedicated manifest | `POS`, `INVENTORY`, `WORKSHOP` |
| Application grant | Which operational application the tenant may use | Resolved with the effective set; enforced by Runtime | `POS_SALON_APP`, `POS_LAUNDRY_APP`, `INVENTORY_APP` |
| Capability | Optional reusable behavior | Owning scope; existing Runtime keys | `MEMBERSHIP`, `MULTI_BRANCH`, `POS_SERVICE_SALES` |

Resolution rule:

```text
Effective domains      = ∪ domain grants of ACTIVE offerings        (+ grandfathered grants)
Effective applications = ∪ application grants of ACTIVE offerings    (+ grandfathered grants)
                         + BACKOFFICE when any offering is active
Effective capabilities = ∪ included capabilities of ACTIVE offerings
                         ∪ capabilities of ACTIVE shared add-ons      (+ grandfathered grants)
```

1. **Offering codes never reach Runtime as product codes.** CORE owns an explicit mapping contract that emits only Runtime vocabulary (domains, applications, capabilities). Runtime rejects or reports unknown codes; it must not silently drop them.
2. **One POS financial authority.** Every POS offering maps to the same `POS` domain in the same Runtime tenant. Sales, payments, Cashier Sessions, Finance routes, Loyalty, and reports stay single-ledger. A POS application never owns a second ledger or a second Runtime for the same business.
3. **One Backoffice.** Backoffice is granted with any active offering and composes modules from domain and capability grants as today.
4. **Application identity ≠ domain ownership.** An operational application is a commercial and experience identity. It owns presentation and workflow composition only. Authoritative behavior stays in domains and shared capabilities.
5. **Salon/Laundry-specific domain behavior** is not justified today. New authoritative state needed by one application (for example Laundry pickup status) requires a scope-contract decision first: extend an existing domain (preferred) or define a new domain. Never put it in the application.

### Packaging (accepted in principle)

| Offering | Domain grant | Application grant | Included capabilities |
| --- | --- | --- | --- |
| POS Salon | `POS` | `POS_SALON_APP` | All currently accepted core Operational POS behavior: Product and Service selling, queue, performers, order adjustment, payments including partial settlement and split payment, correction, refund, reversal, receipts, Cashier Session, Product Commission, Service Composition, Workforce, basic business-level tax, shared foundations, basic reporting |
| POS Laundry (future) | `POS` | `POS_LAUNDRY_APP` | **Decision gate G6** |
| Inventory | `INVENTORY` | `INVENTORY_APP` (if an operational app is justified) | Per [scopes/INVENTORY.md](../../scopes/INVENTORY.md) |
| Workshop | `WORKSHOP` | Workshop application | Per [scopes/WORKSHOP.md](../../scopes/WORKSHOP.md) |

Shared add-on candidates: Customer Engagement (`MEMBERSHIP`, `LOYALTY_POINTS`, `PROMOTIONS`, Member Portal), Attendance (`WORKFORCE_ATTENDANCE`), Multi-Location (`MULTI_BRANCH`), Finance Operations (`FINANCE_OPERATIONS`). WhatsApp receipt pricing is a separate usage-policy decision (**G8**); accepted access is not removed.

### Shared add-on billing

Shared add-ons are billed **once per client** and stay effective while their own term is active **and** at least one active offering is compatible with the add-on's capabilities.

| Criterion | A. Client-scoped shared add-on (recommended target) | B. Synthetic `DIGVATION_PLATFORM` Product as billing anchor |
| --- | --- | --- |
| Schema change | Yes (client-level add-on subscription) | No; reuses `AddOnOffering`/`SubscriptionAddOn` |
| Catalog integrity | Offerings remain real products | A non-sellable product appears in catalogs, client products, and reports |
| Lifetime rule ("≥1 compatible active offering") | Natural: compatibility declared against consuming offerings | Needs an extra rule; the anchor product is always compatible with itself, so add-ons could outlive the last real offering |
| Proration/term | New term model or reuse of term fields | Existing `CO_TERM_PRORATED` against the anchor subscription |
| Installation/binding semantics | Unaffected | Anchor `ClientProduct` would need to exist per client and stay coupled to real offerings |

**Decision:** target A. B is acceptable only as an explicitly approved, temporary measure with the lifetime rule enforced in resolution. **Decision gate G1** fixes the schema.

### Installation-centered runtime binding

- The Runtime binding moves from one `ClientProduct` to the **Installation**. An Installation hosts exactly one Runtime tenant per client business; its offerings come from `InstallationProductBinding`.
- Projection for a Runtime = client effective set limited to offerings bound to that Installation.
- Runtime CORE sync validates the Installation binding instead of a single `coreClientProductId`.
- No production CORE data is known (CORE has no release; live CORE data `UNVERIFIED`). The binding change must still ship with a data-migration plan for any existing `RuntimeBinding` rows. **Decision gate G2.**

### Application authorization is server-validated

Four independent checks apply; none substitutes for another:

| Check | Question answered | Authority |
| --- | --- | --- |
| Client application grant | Has this client's tenant been granted the application? | Effective application set, resolved server-side |
| User application access | May this user use that application? | Runtime identity/RBAC (representation: **Decision gate G4**) |
| Business permission | May this user perform this domain action? | Existing domain permissions (`sales:create`, refunds, and so on) |
| Tenant and location authorization | In which tenant and locations? | Existing tenant isolation and Operational Access |

- App-exclusive backend functionality requires all four. Generic POS operations still require an effective `POS` domain entitlement, the applicable business permissions, and tenant/location authorization, whichever POS application is used. Application grants do not independently authorize POS domain operations.
- A client-controlled channel or header is never sufficient proof of application authorization. It is a declaration that Runtime validates against the client grant and the user's access; an undeclared, unrecognized, or ungranted application is rejected. For public browser clients this validates the declared application, not cryptographic proof of origin.
- Generic POS domain permissions remain shared by every POS application. A new app-exclusive capability is introduced only for backend behavior that is truly exclusive to one application, never per screen or button.

### Application identity and origin attribution (prerequisite)

Before a second POS application handles production money:

- Each operational application has a stable application identity included in its runtime configuration and declared on requests.
- Financial records created from an operational application record an immutable origin application at creation, validated under [Application authorization](#application-authorization-is-server-validated). Which records (Sale minimum; Expense, Cash Movement, future Appointment) is **Decision gate G5**.
- Historical records are not rewritten or backfilled. A missing origin on a record created before multi-app financial operation is enabled means historical legacy data.
- Once multi-app financial operation is enabled, every new in-scope transaction must carry a trusted, validated origin. A missing or unrecognized origin is rejected; it never defaults to POS Salon or any other application and never grants application privileges.
- Sale history stays readable in Backoffice after the originating application's offering is cancelled.

### Deployment

- **Target:** each operational application is an independently versioned artifact (own image and release), composed per Installation with one Runtime and one Backoffice. Dedicated installations deploy only granted applications; future Shared deployments run each application multi-tenant, gated per tenant by application grants. No per-client forks.
- **Transition:** the existing `apps/operational` build, image target `operational`, routes (`/sell`, `/expenses`, `/customers`, `/notifications`), and installations stay unchanged as the grandfathered legacy Operational application. POS Salon may first run as that build with a Salon application identity and presets. Shared selling UI is extracted into a package only when a second application consumes it.

### Vocabulary reconciliation (prerequisite)

Before any existing client is moved to CORE binding:

- CORE's capability catalog contains every Runtime capability key; `CUSTOMER_MANAGEMENT` is resolved (**G7**); a contract test proves CORE output ⊆ Runtime vocabulary.
- The `dev` and `dev-workshop` lanes agree on one union vocabulary before Workshop is released. Vocabulary reconciliation does not authorize merging `dev` and `dev-workshop`; any branch integration follows [DELIVERY_RELEASE_STANDARD.md](../../standards/DELIVERY_RELEASE_STANDARD.md) under its own approval.

### Existing-client grandfather policy

Technical binding migration and commercial migration are separate work units with separate approvals.

- **Technical binding migration** (for example manifest to CORE binding, or a new resolution model) must not shrink any client's effective domains, capabilities, application access, or accepted behavior.
- Before it, record each Installation's current effective set (from its manifest, flat configuration, or CORE projection, including legacy defaults) as explicit grandfathered grants plus the legacy Operational application grant.
- **No-loss verification:** for each Installation, the post-migration effective set must be a superset of the recorded snapshot, checked before cutover and again after. A failed check blocks cutover; rollback is the previous binding source.
- **Commercial migration** (moving a client onto new offerings, packages, or prices) is a separate decision (**G3**). Existing commercial terms are preserved until then.
- Grandfathering protects against unintended loss during technical change only. It is not permanent authorization: an explicitly approved commercial cancellation or entitlement revocation removes the affected grants through the normal entitlement lifecycle.

## Consequences

- CORE gains: offering → domain/application/included-capability mapping, client-scoped shared add-ons, and Installation-centered binding.
- Runtime gains: an application set in the effective entitlements and session, server-side application-grant checks, sync hardening, and later origin attribution.
- Web gains: application identity in runtime configuration and shell gating on application grants.
- Current behavior, keys, routes, images, and installations are unchanged until each step is approved.

## Decision gates

| Gate | Question |
| --- | --- |
| G1 | Shared add-on schema: client-scoped add-on subscription design (target), or temporary synthetic anchor |
| G2 | Installation-centered binding contract and migration of any existing `RuntimeBinding` rows |
| G3 | Commercial treatment of grandfathered clients (keep legacy terms or map to new offerings) |
| G4 | How user application access is represented (dedicated permission, role scope, or another RBAC form) |
| G5 | Records requiring origin attribution beyond Sale |
| G6 | POS Laundry base contents and any Laundry-specific authoritative state |
| G7 | Meaning of CORE `CUSTOMER_MANAGEMENT` |
| G8 | WhatsApp receipt usage pricing |
| G9 | Scheduling as a standalone offering or bundled application |

## Implementation sequence

Each step is a separately approved work unit; none is authorized by this ADR.

Separately scoped follow-ups, not part of this ADR's sequence: (a) verify Member Portal behavior after `MEMBERSHIP` revocation; (b) correct the Member Portal reversal presentation (a reversed finalized Sale is shown as completed). Each is its own task.

1. CORE data parity: missing capability codes and product links, G7, and the vocabulary contract test.
2. Runtime CORE-sync hardening: no silent drops, consistent legacy defaults, and a no-loss regression test against manifest-bound effective sets.
3. Reconcile the `dev`/`dev-workshop` entitlement vocabulary (no branch merge implied).
4. CORE schema (after G1, G2): offering mapping, client-scoped shared add-ons, Installation-centered binding. Additive migrations on a test database first.
5. Grandfather snapshot tooling and no-loss verification per Installation (technical migration only).
6. Runtime: application set in effective entitlements/session, server-side client-grant and user-access checks (after G4); legacy Operational application granted by default.
7. Web: application identity in runtime configuration, shell gating; POS Salon on the transitional build.
8. Origin attribution (after G5), before any second POS application handles production money.
9. Independent artifacts for new applications; extract shared selling UI when a second consumer exists.

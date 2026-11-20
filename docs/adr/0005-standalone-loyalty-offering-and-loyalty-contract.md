# ADR 0005: Standalone Loyalty Offering and the Loyalty Contract

- **Status:** Accepted (2026-11-19, merged in PR #3). Decisions D1 to D8 were confirmed by the product owner on 2026-11-19. G1 resolved 2026-11-19 (see [G1 resolution](#g1-resolution-codes-and-manifest-key-mapping)); other items marked **Decision gate** are not final contracts.
- **Refines:** [ADR 0001](0001-commercial-offerings-and-operational-applications.md) (offerings, applications, shared add-ons) and [ADR 0002](0002-core-offering-model-and-runtime-projection-contract.md) D3 (Customer Engagement add-on).
- **Scope:** Ecosystem architecture, CORE catalog/billing direction, and the Customer/Membership/Loyalty capability contract in [scopes/CUSTOMER_MEMBERSHIP.md](../../scopes/CUSTOMER_MEMBERSHIP.md). Not implementation authority: each step in [Implementation sequence](#implementation-sequence) needs its own approval.
- **Numbering:** 0003 and 0004 are referenced by `docs/CORE_FUNCTIONAL_SPEC.md` but are not present in this folder; this ADR uses 0005 to avoid a collision.
- **Evidence:** Runtime/Web `v1.6.1` capability index in [docs/CURRENT_PLATFORM.md](../CURRENT_PLATFORM.md) (last verified 2026-10-27); CORE functional spec v1.3 (approved 2026-11-10).

## Context

Digvation wants to sell loyalty to businesses that do not use Digvation POS, and to offer a premium loyalty experience (designed member cards, stamp cards, tiers, phone wallet passes) to existing POS clients.

Verified constraints:

- Customer, Membership, and Loyalty Points already exist in Business Runtime (`MEMBERSHIP`, `LOYALTY_POINTS`): enrollment, immutable point ledger, earn after a `FINALIZED` POS Sale, redemption, reversal compensation, member import, opening balances, manual adjustment, and a phone/WhatsApp-OTP Member Portal.
- Tiers, stamp cards, card design, wallet passes, earning from non-POS sources, and email OTP do not exist. Tiers are listed as deferred in the scope contract.
- ADR 0001 keeps one Backoffice and states that a shared add-on is effective only while at least one compatible offering is active. Customer Engagement is a shared add-on (ADR 0002 D3), so it cannot be sold alone.
- CORE functional spec v1.3 lists "subscriptions of tenants inside a SaaS" as out of scope, so CORE cannot yet bill small standalone merchants.

## Decision

| ID | Decision |
| --- | --- |
| D1 | **Standalone Loyalty offering.** CORE gets a commercial offering for loyalty without POS (working code `LOYALTY`, trade name Digvation Loyalty). It grants no `POS` domain. It grants `BACKOFFICE` (ADR 0001 rule 3) and a new operational application for merchants without POS (working code `LOYALTY_APP`), and it **includes** `MEMBERSHIP`, `LOYALTY_POINTS`, and the premium capabilities of D3. Because these capabilities are included in the offering, not held as a shared add-on, the ADR 0001 add-on lifetime rule is respected. |
| D2 | **The Loyalty contract is the single entry point.** Every source records loyalty outcomes through one contract: identify member, preview earn, record completed transaction, redeem, and reverse. Digvation POS calls it through a local port (`LoyaltyPort`) from the existing finalized-Sale flow, without changing accepted behavior. External POS systems call the same operations through a public API with a per-tenant API key. The Digvation Loyalty application uses the same contract. |
| D3 | **New capabilities** (proposed Runtime keys, final codes in G1): `LOYALTY_STAMPS`, `LOYALTY_TIERS`, `MEMBER_CARD_DESIGN`, `MEMBER_WALLET_PASS`, `LOYALTY_PUBLIC_API`. For POS clients they are sold as a **Loyalty Premium** shared add-on, compatible with POS offerings, alongside Customer Engagement. |
| D4 | **Idempotency across sources.** A completed transaction from any source carries `sourceSystem` + `sourceReference`; the pair is unique per tenant. A retry returns the first outcome. Stamps get their own immutable ledger with the same compensation rules as points (G5). |
| D5 | **Deployment.** Standalone merchants run on a Digvation-operated Shared Installation (Client Installation Standard, Mode C). POS clients keep their existing Installation; Loyalty Premium is enabled through a new manifest revision. |
| D6 | **Member OTP channel is a tenant setting.** New tenants default to email (Resend adapter in `outbound-messaging/`). Existing tenants keep WhatsApp OTP. WhatsApp for new tenants becomes a paid option later. |
| D7 | **Standalone billing is a CORE extension.** CORE gains SaaS tenant subscriptions and invoices for standalone merchants (G3). Until that ships, a server job creates invoices and reminders and places a prefilled WhatsApp click-to-chat message in an operator queue; the operator sends it from WhatsApp Business. No unofficial WhatsApp automation is used. Payment is by bank transfer or static QRIS and is confirmed by an operator. After a 7-day grace period the tenant becomes read-only; data is never deleted. |
| D8 | **No separate Loyalty service now.** Loyalty stays a capability inside Business Runtime. Extraction into its own deployable is allowed later only by swapping the `LoyaltyPort` adapter for HTTP or messaging, keeping the same data authority and contract. |

### Commercial plans for the standalone offering (packaging hint, not runtime authorization)

Prices are per outlet per month, in IDR. Plan names never reach Runtime; Runtime receives only capability grants and, after G2, quantity limits.

| Plan | Price | Outlets | Active members | Staff accounts | Capabilities beyond `MEMBERSHIP` + `LOYALTY_POINTS` |
| --- | --- | --- | --- | --- | --- |
| Mikro | 69,000 | 1 | 500 | 2 | Points **or** one stamp program; template card designs only |
| Menengah | 159,000 | Up to 3 | 3,000 | 5 | `LOYALTY_STAMPS`, `LOYALTY_TIERS` (3 tiers), `MEMBER_CARD_DESIGN`, `MEMBER_WALLET_PASS` |
| Pro | 299,000 | Unlimited | Fair use | Unlimited | Menengah + `LOYALTY_PUBLIC_API`, per-location stamps, limited-edition cards |
| Custom | Agreed per contract | Per contract | Per contract | Per contract | Any compatible set; Shared or Dedicated; white-label |

Annual prepayment: 10 months for 12. Add-ons: WhatsApp OTP and notifications (149,000 per outlet per month, 210 messages), card design service (299,000 once), assisted data migration (199,000 once). Prices are subject to market validation by the product owner.

### Decision gates

| Gate | Question |
| --- | --- |
| G1 | Final offering, application, and capability codes, and their manifest key mapping. **Resolved 2026-11-19:** see [G1 resolution](#g1-resolution-codes-and-manifest-key-mapping). |
| G2 | Enforcement of quantity limits (outlets, active members, staff accounts). ADR 0002 reserves quantity limits as a separate decision. |
| G3 | CORE schema for SaaS tenant subscriptions and invoices, and how it relates to brand-level contracts. |
| G4 | Approval of new dependencies for Apple Wallet pass signing and the Google Wallet API. |
| G5 | Stamp ledger as its own table versus a unit column on the point ledger. |
| G6 | Ownership of birthday and win-back rewards: Loyalty-issued rewards versus Promotion-owned campaigns (Promotion currently lists email campaign delivery as deferred). |
| G7 | How CORE represents a plan-dependent capability set for `LOYALTY` (points only, stamps only, or both): separate offerings per plan, or one offering plus offering-scoped add-ons for `LOYALTY_POINTS` and `LOYALTY_STAMPS`. |

### G1 resolution: codes and manifest key mapping

Confirmed by the product owner on 2026-11-19. Evidence: Business Runtime `main` `f91f3a7` (`src/config/entitlement-manifest.ts`, `src/common/entitlements/effective-entitlements.ts`).

| Kind | Code | Reaches Runtime | Manifest key |
| --- | --- | --- | --- |
| Offering | `LOYALTY` (trade name Digvation Loyalty) | No (ADR 0001 rule 1) | None |
| Shared add-on | `LOYALTY_PREMIUM` (trade name Loyalty Premium) | No | None |
| Application | `LOYALTY_APP` | Yes, as an application grant | None in the current manifest format (see rule 4) |
| Capability | `LOYALTY_STAMPS` | Yes | `capabilities.CUSTOMER.LOYALTY_STAMPS` |
| Capability | `LOYALTY_TIERS` | Yes | `capabilities.CUSTOMER.LOYALTY_TIERS` |
| Capability | `MEMBER_CARD_DESIGN` | Yes | `capabilities.CUSTOMER.MEMBER_CARD_DESIGN` |
| Capability | `MEMBER_WALLET_PASS` | Yes | `capabilities.CUSTOMER.MEMBER_WALLET_PASS` |
| Capability | `LOYALTY_PUBLIC_API` | Yes | `capabilities.CUSTOMER.LOYALTY_PUBLIC_API` |

Rules:

1. **New manifest keys are optional and default to off.** The manifest parser currently requires every key of `capabilities.CUSTOMER` (`MEMBERSHIP`, `LOYALTY_POINTS`) and rejects unknown keys. The five new keys are added as optional keys, read only when present (the existing optional `CATALOG` group pattern), so every existing manifest stays valid and grants nothing new. `MEMBERSHIP` and `LOYALTY_POINTS` stay required.
2. **Runtime vocabulary is closed.** The five capability codes are added to the Runtime capability vocabulary in the same change that adds the manifest keys; until then CORE must not emit them, because Runtime rejects unknown codes.
3. **Standalone tenants have no domain grant.** A `LOYALTY`-only tenant resolves to an empty domain set (`POS` disabled). Loyalty behavior must therefore be gated by capability, never by the `POS` domain; POS-only operations stay unavailable.
4. **`LOYALTY_APP` uses real application grants, not a capability stand-in.** Runtime has no application grants yet. The Digvation Loyalty application is built only after [ADR 0001](0001-commercial-offerings-and-operational-applications.md) step 6 (application set in effective entitlements and session, server-side grant checks), which itself waits on ADR 0001 G4 (how user application access is represented). `LOYALTY_APP` is carried in the CORE projection `effectiveEntitlements.applications` (ADR 0002); a manifest key for applications is defined with ADR 0001 step 6, not here.
5. **CORE catalog entries.** `LOYALTY` maps to: no domain, applications `BACKOFFICE` + `LOYALTY_APP`, included capabilities `MEMBERSHIP`, `LOYALTY_POINTS` and the five capabilities above. Amended on 2026-11-20: `LOYALTY_POINTS` and `LOYALTY_STAMPS` are not both always included; see [Amendment: independent programs](#amendment-independent-programs-2026-11-20) and G7. `LOYALTY_PREMIUM` is a shared add-on compatible with POS offerings and grants the five capabilities. Plan limits per the plan table stay commercial until G2.

### Amendment: independent programs (2026-11-20)

Confirmed by the product owner on 2026-11-20. It refines D1, D3, and G1 rule 5; the Loyalty contract (D2) and idempotency rule (D4) are unchanged.

- A tenant's loyalty programs are independent. `MEMBERSHIP` is always granted with `LOYALTY`; `LOYALTY_POINTS` and `LOYALTY_STAMPS` are each granted only when the tenant's plan includes them, so a tenant can run points only, stamps only, or both. CORE representation of this is gate G7.
- Points can be redeemed as a discount, exchanged for reward vouchers from an owner-defined catalog, or both, as a tenant setting. A reward exchange deducts points immediately; voucher validity is set by the tenant.
- Stamp program rules (stamps per card, minimum spend, reward type, reward validity) are set by the owner.
- Tenants without a POS capture points and stamps in the Digvation Loyalty application (cashier scan with transaction total, or a rotating single-use stamp QR scanned by the member). This is behavior of `LOYALTY_APP` and stays behind application grants (G1 rule 4).
- Scope details and open questions: [scopes/CUSTOMER_MEMBERSHIP.md](../../scopes/CUSTOMER_MEMBERSHIP.md), Next Scope.

## Consequences

- The Customer/Membership/Loyalty scope contract gains an approved-next-scope section; tiers move out of Deferred. Point purchase and point transfer become explicitly unsupported.
- Digvation POS must route its existing loyalty calls behind `LoyaltyPort` before any non-POS source is added. This is a re-home of accepted behavior, not a rewrite.
- One Backoffice remains. Card design, stamp programs, tiers, and API keys are new Backoffice modules gated by capability.
- The Member Portal is extended, not replaced.
- A Shared Installation for standalone merchants must meet the Infrastructure, Client Installation, and Security Acceptance standards before its first production tenant.
- Personal data handling (email, phone) for standalone merchants follows the same tenant isolation and PDP obligations as existing clients.

## Implementation sequence

Each step needs its own approval.

1. Accept this ADR and the scope-contract update.
2. Resolve G1; register the offering, application, capabilities, add-on, prices, and manifest key mapping in the CORE catalog.
3. Runtime: introduce `LoyaltyPort` and move the existing finalized-Sale earn, redeem, and reversal calls behind it without behavior change.
4. Runtime: earning from non-POS sources with `sourceSystem` + `sourceReference` idempotency; resolve G5 and add stamp programs and the stamp ledger.
5. Runtime + Web: card design, tiers, Member Portal premium card, email OTP channel.
6. Runtime + Web: the Digvation Loyalty operational application, after ADR 0001 step 6 (application grants); wallet passes after G4.
7. Runtime: public Loyalty API and outgoing webhooks for external POS.
8. CORE: SaaS tenant subscriptions and invoices (G3); until then the WhatsApp click-to-chat billing queue of D7.
9. Shared Installation for standalone merchants and a pilot with one client that already uses Digvation POS.

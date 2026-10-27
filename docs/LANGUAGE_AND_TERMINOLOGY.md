# Language and Terminology

Reference for interpreting Indonesian requests and Indonesian UI copy. The binding interaction rule is [AGENTS.md](../AGENTS.md) §18. Domain meaning is owned by the scope contracts; this file maps words to those meanings and adds no behavior.

## Interaction contract (summary)

| Context | Language |
| --- | --- |
| Discussion with the user | Indonesian (follow the user's language) |
| Implementation prompts, agent handoffs, commit/PR text | English |
| Source identifiers, API fields, enum values | Unchanged English identifiers |
| Product UI copy | Localized as already implemented (Indonesian `id` / `id-ID` default, English `en` / `en-US`) |

- Interpret an Indonesian term through the existing Digvation domain definition below, not through a literal translation.
- A different Indonesian wording is not a different or broader requirement. "Batalkan transaksi" does not authorize a new cancellation flow; it maps to the existing void or reversal behavior.
- When an Indonesian word maps to more than one domain state (for example "Dibatalkan"), confirm which state the user means from the screen, record, or context before acting.

## UI term → domain meaning

Labels verified in Web localization sources on 2026-10-27 (`apps/backoffice/src/app/localization/*`, `apps/operational/src/app/localization/operational-localization-base.ts`, feature `localization/` folders).

| Indonesian UI term | English UI term | Domain meaning / identifier | Owner |
| --- | --- | --- | --- |
| Sesuaikan pesanan | Adjust order | Existing order adjustment on a Sale (line changes through Runtime order-adjustment policy) | [POS](../scopes/POS.md) |
| Bayar sebagian | Partially paid | Presentation of partial settlement: a Sale whose successful payments do not yet cover the total | POS |
| Antrian | Queued | `SaleOperationalState.QUEUED`: submitted operational work waiting for execution | POS |
| Dikerjakan / Sedang diproses | In progress | `SaleOperationalState.IN_PROGRESS` | POS |
| Berjalan / Terbuka | Open | `SaleStatus.OPEN` | POS |
| Selesai | Completed | `SaleStatus.FINALIZED` (also generic `COMPLETED`) | POS |
| Dibatalkan | Voided / Cancelled | Effective cancellation presentation. Covers `SaleStatus.VOIDED` **and** a reversed `FINALIZED` Sale; see below | POS |
| Pengembalian dana | Refund | Refund of a successful Sale payment | POS / Finance |
| Riwayat transaksi | Transaction history | Backoffice Sale history projection | POS |
| Penyelesaian | Settlement | Finance settlement | [FINANCE_OPERATIONS](../scopes/FINANCE_OPERATIONS.md) |
| Cabang / Lokasi | Branch / Location | Organization location; access via Operational Access | [ORGANIZATION_LOCATION](../scopes/ORGANIZATION_LOCATION.md) |
| Karyawan | Employee | Workforce employee (not the same as a login account) | [WORKFORCE](../scopes/WORKFORCE.md) |
| Pelanggan | Customer | Shared customer identity | [CUSTOMER_MEMBERSHIP](../scopes/CUSTOMER_MEMBERSHIP.md) |
| Member / Poin | Member / Points | Membership and Loyalty points | CUSTOMER_MEMBERSHIP |
| Diskon & promo | Discounts & promotions | Promotion capability | [PROMOTION_COMMERCIAL](../scopes/PROMOTION_COMMERCIAL.md) |

## VOIDED vs. reversed FINALIZED Sale

Both are shown to users as "Dibatalkan", but they are different domain facts:

| | Voided Sale | Reversed finalized Sale |
| --- | --- | --- |
| Starting state | Not completed (`OPEN`) | Completed (`FINALIZED`) |
| Stored status after | `SaleStatus.VOIDED` | Stays `FINALIZED`; an append-only `SaleReversal` record (reason, actor, time) is added |
| Preconditions | Void command on a Sale that is not completed | Permission; successful payments refunded first; not already reversed |
| Side effects | No completed revenue to undo | Earned/used loyalty points are compensated; reporting projections reflect the reversal |

Never implement or describe reversal as changing a `FINALIZED` Sale to `VOIDED`. The durable rule lives in [scopes/POS.md](../scopes/POS.md).

## Common informal phrasing

| User says | Usually means | Check before acting |
| --- | --- | --- |
| "kasir" | The Operational app's POS selling flow (`apps/operational`), or a cashier account | Which one: app or account |
| "BO" / "backoffice" | `apps/backoffice` | — |
| "naik ke stage" / "rilis" / "deploy" | Promotion, release, or deployment, each a separate gate | Exact operation; see [DELIVERY_RELEASE_STANDARD.md](../standards/DELIVERY_RELEASE_STANDARD.md) |
| "sudah ada?" | Whether a capability exists | Answer with Implementation / Release / Deployment separately ([CURRENT_PLATFORM.md](CURRENT_PLATFORM.md)) |

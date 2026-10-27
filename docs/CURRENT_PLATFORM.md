# Current Platform Capability Index

One-page index of what Digvation has today. It points to owners and evidence; it is not an implementation spec. Domain ownership and envelopes stay in [scopes/](../scopes/README.md). Architecture stays in [ECOSYSTEM_ARCHITECTURE.md](../standards/ECOSYSTEM_ARCHITECTURE.md).

**Last verified: 2026-10-27 (Asia/Jakarta).** Facts below go stale. Before relying on one for a release, deployment, or availability decision, re-verify it against GitHub and Installation evidence.

## How to read this index

Three facts are tracked separately and must never be merged:

| Column | Meaning | Evidence that counts |
| --- | --- | --- |
| Implementation | Maturity of accepted source | Source at a named branch/SHA |
| Release | Whether that source is in a tagged release | Git tag / GitHub release on `main` |
| Deployment | Whether a client Installation runs it | Canonical Installation/release record or post-deploy evidence |

Statuses: `IMPLEMENTED`, `IN_PROGRESS`, `PLANNED`, `DEFERRED`, `DEPRECATED`, `UNVERIFIED`.

- A merge into `dev` is not a release. A green CI run or a published image is not a production rollout.
- Source presence, a UI component, or a scope status never proves a client has a capability enabled. Client availability = effective entitlement ∩ runtime capability ∩ permission ∩ location context.

## Release and deployment snapshot

| Component | Release (source) | Deployment evidence |
| --- | --- | --- |
| Business Runtime | `v1.6.1` = `main` `f91f3a78`, released 2026-10-23. `dev` has no commits that `main` lacks. | Production image publish workflow succeeded 2026-10-23. Client Installation rollout: `UNVERIFIED` (no canonical Installation record). |
| Business Web | `v1.6.1` = `main` `d7e3234c`, released 2026-10-23. `dev` has no commits that `main` lacks. | Same as Runtime: images published; rollout `UNVERIFIED`. |
| Workshop lane (Runtime/Web `dev-workshop`) | Not in any release. Runtime `dev-workshop` head `3777e99a` (2026-09-30). | None. |
| CORE API (`core-v2`) / CORE UI | No GitHub releases. Active integration branches `digvation-core-dev` / `digvation-core-ui-dev`. | `UNVERIFIED`. |
| Infrastructure | No releases. Dedicated lifecycle tooling on `feat/dedicated-lifecycle-source`; canonical Installation records only for `dgv-lab` (`lab-0.1.0`, `lab-0.1.1`). | Lab only. |

Release flow and gates: [DELIVERY_RELEASE_STANDARD.md](../standards/DELIVERY_RELEASE_STANDARD.md).

## Capability index

Entitlement codes are the effective codes Runtime derives in `src/config/entitlement-manifest.ts`. "Base" means a platform foundation with no separate grant, still subject to permission and location context.

Unless a row says otherwise, Implementation = `IMPLEMENTED` with source in Runtime/Web `main` (`v1.6.1`), and Deployment = `UNVERIFIED`.

### POS (business domain)

| Capability | Owner scope | Entitlement | Status / notes | Source anchors |
| --- | --- | --- | --- | --- |
| Selling and checkout (Product and Service lines, cart, finalize, void) | [POS](../scopes/POS.md) | `POS_PRODUCT_SALES`, `POS_SERVICE_SALES` | Implemented | Runtime `src/modules/sales`, `src/modules/pos`; Web `apps/operational/src/features/sell` |
| Queue and work execution (`QUEUED` → `IN_PROGRESS`, service performers) | POS | `POS_SERVICE_SALES` | Implemented | `SaleOperationalState` in Runtime Prisma schema; Web `sell/queue`, `sell/performer` |
| Order adjustment ("Sesuaikan pesanan") | POS | POS | Implemented | Runtime `sales/order-adjustment.policy.ts`; Web `sell/adjustment` |
| Payments, split payment, payment correction | POS (+ Finance payment route) | POS; route via `FINANCE_OPERATIONS` | Implemented. Separate commercial flag for split payment: `DEFERRED` | Runtime `payments/`, `sales/payment-correction.policy.ts`; Web `packages/payment-correction-ui` |
| Refund and finalized-Sale reversal | POS | POS | Implemented. Reversal requires successful payments to be refunded first | Runtime `SaleReversal` model, `sales.service.ts#reverse`; Web `features/transaction-history` |
| Receipts (print/PDF, public link, WhatsApp delivery) | POS | POS | Implemented. Separate commercial flag for WhatsApp receipt: `DEFERRED` | Runtime `sales/pos-receipt-*`, `outbound-messaging/` |
| Product commission and additional-product seller attribution | POS | `POS_PRODUCT_COMMISSION` | Implemented (Runtime PRs #132, #133, merged 2026-10-21/22; first released in `v1.6.0`) | Runtime `commission/`, `sales/product-salesperson.policy.ts` |
| Transaction history (Backoffice) | POS projection | POS + permission | Implemented | Web `apps/backoffice/src/features/transaction-history` |

### Shared foundations and capabilities

| Capability | Owner scope | Entitlement | Status / notes | Source anchors |
| --- | --- | --- | --- | --- |
| Catalog items and categories | [CATALOG](../scopes/CATALOG.md) | Base | Implemented | Runtime `catalog/`; Web `features/catalog` (reference UI pattern) |
| Service composition (BOM) | CATALOG | `CATALOG_SERVICE_COMPOSITION` | Implemented. Separate commercial BOM entitlement: `DEFERRED` | Runtime `catalog/` |
| Customer directory | [CUSTOMER_MEMBERSHIP](../scopes/CUSTOMER_MEMBERSHIP.md) | Base | Implemented | Runtime `customers/`; Web `features/customers` |
| Membership and Loyalty points (earn, redeem, ledger, reversal compensation, import, manual adjustment) | CUSTOMER_MEMBERSHIP | `MEMBERSHIP`, `LOYALTY_POINTS` | Implemented subset. Campaign point modifiers: `DEFERRED` | Runtime `membership/`, `loyalty/` |
| Member Portal | CUSTOMER_MEMBERSHIP | Membership context | Implemented. Separate commercial flag: `DEFERRED` | Runtime `member-portal/`; Web `apps/member-portal` |
| Promotions (percentage/fixed discounts, member-only eligibility) | [PROMOTION_COMMERCIAL](../scopes/PROMOTION_COMMERCIAL.md) | `PROMOTIONS` | Implemented subset. Bonus-point/multiplier benefits: `DEFERRED` | Runtime `promotions/` |
| Tax (business-level enable/rate/version, captured facts, tax report) | [TAX_FISCAL](../scopes/TAX_FISCAL.md) | `TAX_FISCAL` | Implemented subset. Dynamic classification/jurisdiction engine: `PLANNED` | Runtime `tax/`, `business-configuration/` |
| Employees, location assignment, attendance | [WORKFORCE](../scopes/WORKFORCE.md) | `EMPLOYEE_WORKFORCE`, `WORKFORCE_ATTENDANCE` | Implemented | Runtime `employees/` |
| Financial accounts, payment routes, expenses (`PENDING → APPROVED/REJECTED`), cash movements, settlements | [FINANCE_OPERATIONS](../scopes/FINANCE_OPERATIONS.md) | `FINANCE_OPERATIONS` | Implemented. Reconciliation and General Ledger: `DEFERRED` | Runtime `financial-accounts/`, `expenses/`, `financial-operations/`, `finance/` |
| Locations and multi-location | [ORGANIZATION_LOCATION](../scopes/ORGANIZATION_LOCATION.md) | Base; `MULTI_BRANCH` for more than one active location | Implemented | Runtime `locations/` |
| Operational location access | [OPERATIONAL_ACCESS](../scopes/OPERATIONAL_ACCESS.md) | Base | Implemented | Runtime `operational-access/` |
| Accounts, roles, Owner activation, invitations, password-reset lifecycle, email delivery | [IDENTITY_ACCESS](../scopes/IDENTITY_ACCESS.md) | Base | Implemented (Runtime PRs #114, #118, merged 2026-10-15/18; first released in `v1.4.0`) | Runtime `auth/`; Web `apps/backoffice/src/auth` |
| Business configuration (localization, numbering, receipt, tax settings) | ORGANIZATION_LOCATION | Base | Implemented | Runtime `business-configuration/`, `business-preferences/`, `business-profile/` |
| Audit and activity | [AUDIT_ACTIVITY](../scopes/AUDIT_ACTIVITY.md) | Base | Implemented | Runtime `activity/`; Web `features/activity` |
| Dashboard and reports | [DASHBOARD_REPORTING](../scopes/DASHBOARD_REPORTING.md) | Experience; follows report permissions (`BUSINESS_ANALYTICS` is a legacy flag, not a paywall) | Implemented. Reports: business performance, transactions, catalog performance, component usage, product commission, employee performance, attendance, payments, expenses, cash, tax, locations | Runtime `reports/`; Web `features/reporting`, `modules/dashboard` |

### Other domains and platform

| Capability | Owner | Status | Evidence |
| --- | --- | --- | --- |
| Workshop (intake, Work Orders, mechanic assignment, lines, billing validation) | [WORKSHOP](../scopes/WORKSHOP.md) | `IMPLEMENTED` subset on `dev-workshop` only; not in `v1.6.1`. Finance/invoicing/reporting integration: `PLANNED` | Runtime `dev-workshop` `src/modules/workshop` |
| Scheduling (Service Appointment) | [SCHEDULING](../scopes/SCHEDULING.md) | `PLANNED` (scope status `NEXT`). No Runtime module on `main`, `dev`, or `dev-workshop` | Runtime module listing, 2026-10-27 |
| Inventory | [INVENTORY](../scopes/INVENTORY.md) | `PLANNED` | No Runtime module |
| CORE control plane (clients, products/capabilities, subscriptions, installations, runtime binding, deployment operations) | [ECOSYSTEM_ARCHITECTURE](../standards/ECOSYSTEM_ARCHITECTURE.md) §3 | `IN_PROGRESS`: modules on `digvation-core-dev`, unreleased | `core/core-v2/src/modules` |
| Dedicated entitlement without CORE | ECOSYSTEM_ARCHITECTURE §13 | `IMPLEMENTED`: Runtime reads a deployment manifest (`entitlements.*.yml`) in Dedicated mode | Runtime `src/config/entitlement-manifest.ts` |
| Dedicated Installation tooling (`dgvctl`, dedicated lifecycle) | [INFRASTRUCTURE_STANDARD](../standards/INFRASTRUCTURE_STANDARD.md) | `IN_PROGRESS` on `feat/dedicated-lifecycle-source` | `infra/digvation-infrastructure` |

Also deferred (Web capability coverage, 2026-10-12): direct-API single/multi-location hardening, resource quotas and a Free plan.

## Maintaining this index

- Update a row only with source evidence (branch + SHA or PR) and change the "Last verified" date.
- Add a row only for a capability that has an owner scope. A new durable capability first gets its scope contract.
- Keep rows to one line. Detail belongs in the scope's verified delivery section.

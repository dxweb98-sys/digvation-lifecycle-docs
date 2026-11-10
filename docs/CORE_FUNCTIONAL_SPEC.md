# CORE functional specification v1.3

- **Status:** Approved by the product owner on 2026-11-10, including decisions D1 to D9 (section 6). This document is the implementation authority for CORE; each work unit is built complete against its acceptance criteria, not as a trial version. Changes to it need explicit product-owner approval and are recorded in section 7.
- **Basis:** ADR 0004 (direction and answers of 2026-11-10), ADR 0003 (monitoring), the old `core-v2` `digvation-core-dev` (`4878f9b`) models where they still fit, and the cleaned platform layer.
- **Conventions:** every module follows AGENTS.md "Module conventions" (repository per module, check-then-write inside one Serializable transaction, DomainException with central codes, snake_case responses, `data.items` + `data.pagination`, lifecycle changes recorded with reason and actor).

## 1. Purpose and principles

CORE is Digvation's operations record for every service it delivers: what Digvation builds (catalog), who uses what (clients, their brands and their services), under which agreement (contracts, invoices, payments), where it runs and in what state (installations, releases, manifests, deployments, monitoring), and who must be followed up.

1. CORE records and monitors. Applications never call CORE while serving users; they only fetch their manifest at deploy time and report state through the monitoring agent.
2. Commercial records are immutable once issued: a change creates a new record (new contract term, new manifest revision, credit note), never an edit of history.
3. Every state change has an actor, a reason and a timestamp.
4. Money is stored in minor units (BigInt) with an ISO currency; dates are `timestamptz`; business dates (due dates, reminder days) use the business timezone setting (default `Asia/Jakarta`).

**Out of scope:** subscriptions of tenants inside a SaaS (monitored separately), payment gateways, official tax invoices (faktur pajak) issued through the tax authority's system, executing commands on hosts, a client-facing portal.

## 2. Glossary

| Term | Meaning |
| --- | --- |
| Base domain | A shared foundation a product can build on, for example POS or INVENTORY. Optional. |
| Product | Something Digvation delivers: POS Salon, POS Laundry, Inventory, Web Company Profile, Web QR Menu, a custom system. |
| Feature | A function belonging to one product, or a custom feature owned by one client. |
| Capability | A reusable function that several products may support (for example MEMBERSHIP). |
| Add-on | A paid package that grants features and/or capabilities. |
| Release | A version of a product. |
| Client | The party Digvation contracts with (a company or person). Its legal details appear on every invoice. |
| Brand | A business line of a client (for example Nova Salon and Nova Barber under one owner). Services belong to a brand, and invoices are issued per brand. |
| Client service | A product a brand of a client uses (old name ClientProduct). |
| Contract | The agreement for one client service, made of consecutive terms. |
| Installation | One running instance hosting one or more services, either of one client or a shared SaaS owned by Digvation. |
| Manifest | The file an installation is deployed with, listing what it runs. |
| Host | A server registered in CORE; it holds a credential used by `dgvctl` and the monitoring agent. |

## 3. Modules

### 3.1 Platform
Users, authentication, roles and permissions, invitations, authorization audit, operator bootstrap, permission catalog sync. Every new module below adds its permissions to the catalog sync.

### 3.2 Catalog

**Base domain**: `code` (unique, uppercase), `name`, `description`, status DRAFT, ACTIVE, RETIRED.

**Application**: an app a product ships (for example BACKOFFICE, POS_SALON_APP): `code`, `name`, status. Used only for manifests.

**Product**: `code` (unique), `name`, `description`, `kind` (RUNTIME_PRODUCT, WEBSITE, CUSTOM_SYSTEM, OTHER), `base_domains` (0..n), `applications` (0..n), `manifest_format` (none, or a registered format such as `business-runtime-entitlements` with schema version), status DRAFT, ACTIVE, RETIRED.
- Activation needs no base domain. A product with a manifest format needs a key mapping for every feature and capability it can enable before activation.
- Retirement is refused while a client service of that product is not CANCELLED or DECOMMISSIONED, or while features are not RETIRED.

**Feature**: `product`, `code` (unique per product), `name`, `description`, `scope` (PRODUCT, or CLIENT with `owner_client`), status DRAFT, ACTIVE, RETIRED. A CLIENT-scoped feature is how an agreed custom requirement enters the catalog; it can only be enabled for services of its owner client (any of its brands).

**Capability**: `code` (unique), `name`, `description`, status DRAFT, ACTIVE, RETIRED. **Product capability**: product, capability, inclusion INCLUDED (always on for the product) or COMPATIBLE (may be enabled). Retired links are kept for history (old rule).

**Add-on**: `code`, `name`, `description`, scope PRODUCT (tied to a product) or CLIENT (tied to one client), grants of features and capabilities that must be compatible with the product, status DRAFT, ACTIVE, RETIRED. Activation needs at least one grant and an active catalog price.

**Catalog prices**: product price and add-on price per billing cycle (MONTHLY, QUARTERLY, SEMI_ANNUAL, ANNUAL, CUSTOM) and currency (IDR by default; other currencies are stored as they are); changing a price never changes existing contracts.

**Release**: `product`, `version` (semantic version, unique per product), `artifact_ref` (image digest or build revision), `released_at`, `notes`, status DRAFT, RELEASED, WITHDRAWN. The latest RELEASED version is the product's current version.

**Manifest key mapping**: per product and manifest format, one entry per base domain, application, feature and capability code that the manifest can carry, with its manifest key (for example MEMBERSHIP to `CUSTOMER.MEMBERSHIP`). Validated against the format's schema; unknown keys are refused.

### 3.3 Clients and brands

**Client**: `code` (unique), `display_name`, `legal_name`, `tax_identifier`, `email`, `phone`, `website`, `address`, `country`, `timezone`, `notes`, status ACTIVE, SUSPENDED, ARCHIVED. The client is the contracting party; its legal details are the bill-to on every invoice of every brand. Archiving is refused while any service is not CANCELLED or DECOMMISSIONED or any invoice is unpaid.

**Brand**: `client`, `code` (unique per client), `name`, `description`, `logo_url`, `website`, `primary_color`, `secondary_color`, status ACTIVE, ARCHIVED. Creating a client creates its first brand (named after the client) in the same transaction; a client always has at least one active brand. Archiving a brand is refused while any of its services is not CANCELLED or DECOMMISSIONED or any of its invoices is unpaid.

**Client contact**: `client`, optional `brand`, `name`, `position`, `email`, `phone`, flags `is_primary`, `is_billing`, `is_technical`. Exactly one primary contact per active client. Billing contacts may be set per brand; a brand without its own billing contact uses the client's. Issuing an invoice needs at least one billing contact resolved for its brand.

### 3.4 Client services

**Client service**: `client`, `brand` (of that client), `product`, status PROVISIONING, TRIAL, ACTIVE, SUSPENDED, CANCELLED, DECOMMISSIONED; selected product features; held add-ons (client add-on with its own status). The product must be ACTIVE and the brand ACTIVE when the service is created. A brand holds at most one service per product; a client may hold the same product several times through different brands (D1). Status follows the contract (3.5) and the installation go-live (3.7); manual transitions need a reason.

### 3.5 Contracts

**Contract** (one per client service, and one per client add-on held outside the service term when needed): status PENDING, TRIAL, ACTIVE, SUSPENDED, EXPIRED, CANCELLED; `contract_reference`; `auto_renew`; `renewal_notice_days` (default 30); `grace_period_days`; `billable` (false for complimentary arrangements).

**Contract term** (immutable once active; a change creates a new term linked by `renewed_from`): `starts_at`, `ends_at`, `billing_cycle`, `currency`, `list_amount` (catalog snapshot), `agreed_amount`, `adjustment_type` (NONE, PROMOTIONAL, NEGOTIATED, GRANDFATHERED, COMPLIMENTARY) with a required reason when not NONE, `payment_terms_days` (due date = invoice issue date + days), `trial_ends_at` (optional).

**Contract add-on**: add-on, `effective_from`, `effective_until`, list and agreed amounts, adjustment, proration policy CO_TERM_PRORATED (an add-on bought mid-term is charged pro rata to the end of the current period and then co-terms with the service).

Rules:
- Start: a term with no agreed start date starts at the go-live of the first PRODUCTION installation hosting the service; a trial runs from its start to `trial_ends_at` and is not billed.
- At `trial_ends_at` without a paid term, the contract becomes EXPIRED and the service SUSPENDED.
- At `ends_at`: with `auto_renew`, a new term with the same amounts is created; otherwise the contract becomes EXPIRED after the grace period.
- Cancelling requires a reason and an effective date; invoices already issued stay valid.
- An overdue invoice never suspends a contract or service automatically; it is flagged and reminded, and an operator decides (D4).

### 3.6 Billing (billable contracts of dedicated and custom-system services)

**Billing settings**: issuer legal details, default currency (IDR), tax rates (named, with percentage and validity dates), invoice number pattern (for example `INV/{YYYY}/{MM}/{SEQ:5}`, optionally with `{BRAND}`), draft lead time (default 7 days before a period starts, D3). The sequence is one gap-free counter per period shared by all clients and brands; `{BRAND}` only adds the brand code to the number (D9).

**Invoice**: `number` (assigned at issue), `client`, `brand`, `billing_contacts`, `period_start`, `period_end`, `issue_date`, `due_date`, `currency`, lines, `subtotal`, `tax_rate` and `tax_amount` (snapshot), `total`, `amount_paid`, `balance`, status DRAFT, ISSUED, PARTIALLY_PAID, PAID, VOID; OVERDUE is derived (ISSUED or PARTIALLY_PAID past `due_date`).
- **One invoice covers exactly one brand** (D1). Bill-to is the client's legal details; the brand name is shown on the invoice. Services of different brands are never on the same invoice.
- Lines: contract term charge, add-on charge, pro-rated add-on charge, one-off item (for example setup or custom development) with description and amount. Every line belongs to a service of the invoice's brand, or is a one-off item for that brand.
- CORE generates DRAFT invoices per brand, billing period and currency, from the active billable contracts of that brand, at the draft lead time. Operators review and issue; once issued, an invoice cannot change. A wrong invoice is voided with a reason, or corrected with a credit note.
- A PDF of an issued invoice can be downloaded (server-side PDF library, chosen in unit 6, D8).
- An operator can send an issued invoice, with its PDF, by email to the billing contacts resolved for its brand through an explicit "send" action; every send is recorded (D2). Totals are reported per currency and per brand (D6).

**Credit note**: references an issued invoice, amount and reason; reduces its balance.

**Payment**: `client`, `received_at`, `amount`, `currency`, `method` (bank transfer, cash, other), `reference`, optional proof file (stored through the existing storage service), allocations to one or more invoices of that client, of any of its brands. Partial payments are allowed; an unallocated remainder stays as client credit and can be allocated later. Deleting a payment is not allowed; a mistaken payment is reversed with a reason.

### 3.7 Installations

**Host**: `code`, `name`, provider, region, IP or hostname, infrastructure ownership (DIGVATION, CLIENT), status ACTIVE, RETIRED, and a host credential (issue, rotate, revoke; shown once; stored hashed) with scopes `manifest.read`, `deployment.report` and `telemetry.write` (ADR 0003 M3).

**Installation**: `code` (unique), `name`, owner (a client, or Digvation for a shared SaaS), deployment mode (SHARED, DEDICATED), environment (PRODUCTION, STAGING, DEVELOPMENT), host, `managed_by_digvation`, URLs, status PROVISIONING, ACTIVE, SUSPENDED, DECOMMISSIONED, `go_live_at`, target release, branding profile (mode DIGVATION or WHITE_LABEL, brand name, logo, favicon, colors, custom domain, support contact; white-label optional; prefilled from the brand of its services when they share one brand).
- Hosts one or more client services of its owner client, from one or several of its brands (none for a shared SaaS, which hosts products directly).
- Enabled set: base domains, applications, features and capabilities enabled for this installation. Allowed items are the product's INCLUDED capabilities, the services' selected features, grants of active held add-ons, and the client's own CLIENT-scoped features. Enabling anything outside that set needs an override with a reason, shown as "not covered by contract" on the dashboard.
- `go_live_at` is set by the first successful PROVISION deployment in PRODUCTION, or by an operator with a reason; it starts contracts waiting for go-live (3.5).

### 3.8 Manifests

**Manifest revision**: installation, `revision` (sequential), format and schema version, content, `sha256`, source (GENERATED or IMPORTED with source evidence), author, reason, status DRAFT, ISSUED, SUPERSEDED, diff against the previous issued revision.
- Registration of an installation whose products have a manifest format creates revision 1 as DRAFT. Any change to its enabled set creates a new DRAFT.
- Issuing shows the diff; any removed item must be confirmed explicitly. Issuing supersedes the previous revision. Issued content never changes.
- Import: an existing manifest (for example Nova `entitlements.yml` revision `f91f3a78`) can be imported as an ISSUED revision with source evidence. CORE then generates a DRAFT from the installation's enabled set and must report "identical" before that DRAFT may be issued for Nova.
- Manifests are identified by installation code (which includes the client), so production and staging of one client have separate manifests.
- `dgvctl` fetches a given revision, or the current issued one, with the host credential of the installation's host. A host can fetch manifests only of installations on that host.

### 3.9 Deployments

**Deployment operation** (old model kept): installation, action PROVISION or UPDATE, target release, manifest revision, reason, requester, idempotency key, status PENDING, CLAIMED, RUNNING, SUCCEEDED, FAILED, CANCELLED, OUTCOME_UNKNOWN; at most one open operation per installation.
- Operators create it; `dgvctl` claims and reports progress with the host credential; CORE never runs commands on hosts.
- On SUCCEEDED, the installation's running release and manifest revision are recorded; a PROVISION in PRODUCTION sets `go_live_at` when empty.
- `dgvctl` keeps the last fetched manifest on the host, so a redeploy works when CORE is unreachable; that deploy is reported when CORE is back.

### 3.10 Follow-up notifications (email)

A daily job (time and timezone configurable; `@nestjs/schedule` with a Redis lock so only one CORE instance runs it, D7) sends emails to the configured operator recipients:

| Event | Default timing |
| --- | --- |
| Contract term ending | 30, 14 and 7 days before `ends_at` |
| Trial ending | 7 and 1 days before `trial_ends_at` |
| Invoice due | 3 days before and on `due_date` |
| Invoice overdue | 1, 7 and 14 days after `due_date` |
| Draft invoices waiting to be issued | daily while any exists |

Each email is recorded (event, subject, threshold, recipients, status), so a reminder is never sent twice and failures are retried. Thresholds and recipients are configuration. Reminders name the client and brand. They go to operators only; clients receive only invoices sent explicitly (3.6).

### 3.11 Monitoring and drift
As ADR 0003 (agent push, alert rules, Telegram for alerts). In addition, the agent reports the running release and the hash of the manifest on the host; CORE flags drift when either differs from the last successful deployment.

### 3.12 Dashboard
Summary endpoints, filterable by client and brand: active clients, brands and services; contracts ending in 30 days; trials ending; invoices due and overdue with outstanding amount per currency and brand; installations behind the current release; installations with drift or overrides not covered by contract; health per ADR 0003.

## 4. Permissions (added to the catalog sync)

`catalog.read`, `catalog.manage`, `catalog.lifecycle.manage`, `releases.manage`, `clients.read`, `clients.manage`, `clients.lifecycle.manage`, `services.read`, `services.manage`, `contracts.read`, `contracts.manage`, `billing.read`, `billing.manage`, `billing.settings.manage`, `payments.manage`, `installations.read`, `installations.manage`, `hosts.manage`, `manifests.read`, `manifests.issue`, `deployments.read`, `deployments.manage`, `notifications.settings.manage`, `dashboard.read`. Brands are covered by the `clients.*` permissions. Products are part of the catalog and use the `catalog.*` permissions.

## 5. Work units and acceptance criteria

Each unit is complete when its rules above are implemented, unit tests cover every rule, e2e tests on disposable PostgreSQL cover the main flow and the refusals, and Swagger lists its routes.

| # | Unit | Acceptance highlights |
| --- | --- | --- |
| 1 | Catalog | Product without base activates; product with manifest format refuses activation without full key mapping; client-scoped feature usable only by its owner client; add-on activation needs grants and price; release versions unique and ordered. |
| 2 | Clients, brands and services | Creating a client creates its first brand; contacts rules, including brand billing contacts with fallback to the client's; one service per product per brand, the same product allowed under two brands of one client; service only for an ACTIVE product and brand; archiving a client or brand refused with open services or unpaid invoices. |
| 3 | Installations and hosts | Shared without client, dedicated with client; services from several brands of one client in one installation; enabled set limited to allowed items unless overridden with reason; host credential shown once, rotated and revoked. |
| 4 | Contracts and reminders | Start at go-live; trial expiry; auto-renew creates a linked term; price snapshot unaffected by catalog change; each reminder sent once at its threshold; overdue never suspends automatically. |
| 5 | Manifests and deployments | Revision 1 on registration; diff and confirmation on removal; Nova import reports identical; fetch limited to the host; one open operation per installation; go-live set by first production PROVISION. |
| 6 | Billing | Draft generation per brand, period and currency; services of two brands of one client produce two invoices; bill-to is the client with the brand shown; send goes to the brand's billing contacts; one payment may be allocated across invoices of several brands of the same client; one gap-free sequence shared by all brands; tax snapshot; partial payments and client credit; void and credit note; PDF; explicit send recorded. |
| 7 | Monitoring, drift, dashboard | ADR 0003 units plus drift and dashboard summaries filterable by client and brand. |

Order: platform clean-up first, then units 1 to 7. Unit 4 uses the go-live of units 3 and 5; until unit 5 lands, an operator sets go-live manually with a reason (3.7).

## 6. Decisions recorded (approved 2026-11-10)

| ID | Question | Decision |
| --- | --- | --- |
| D1 | Can one client hold the same product twice? | Yes, through separate brands of the same client. Each brand holds at most one service per product. Invoices are issued per brand; the client stays the contracting party and bill-to. |
| D2 | Are issued invoices emailed to the client from CORE? | Yes, by an explicit "send" action to the brand's billing contacts; reminders stay operator-only. |
| D3 | Draft invoice lead time | 7 days before the period starts (configurable). |
| D4 | Does an overdue invoice suspend the service automatically? | No; flagged and reminded, an operator decides. |
| D5 | Product kinds | RUNTIME_PRODUCT, WEBSITE, CUSTOM_SYSTEM, OTHER. |
| D6 | Currencies | IDR as default; other currencies stored as they are, totals reported per currency. |
| D7 | Scheduler for daily jobs | `@nestjs/schedule` (new dependency) with a Redis lock. |
| D8 | PDF invoice generation | A server-side PDF library (new dependency), chosen in unit 6. |
| D9 | Invoice number sequence | One gap-free sequence per period shared by all brands; the brand code may appear in the number but does not restart the counter. |

## 7. Change log

- 2026-11-10: v1 approved with D1 to D8.
- 2026-11-10: v1.1, D1 revised: brands added under clients; services belong to a brand and are unique per brand and product; installations may host services of several brands; dashboard filters by brand.
- 2026-11-10: v1.2, invoices are issued per brand; bill-to stays the client; billing contacts per brand with fallback to the client; payments may be allocated across invoices of several brands of the same client.
- 2026-11-10: v1.3, D9 added (shared invoice sequence); products use the `catalog.*` permissions.

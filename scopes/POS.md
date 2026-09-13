# POS Scope Contract

Kind: `BUSINESS_DOMAIN`
Status: `ACTIVE`
Entitlement Class: `PRODUCT`
Commercial Packaging: `PRODUCT`

## Commercial Availability / Effective Entitlement

`POS` is a product-level entitlement. A client may use this domain only when CORE/control-plane resolves `POS` as enabled in the effective entitlement set. Bundling in a SaaS plan is commercial packaging only; runtimes must consume the resolved entitlement rather than infer access from plan name, business type, deployment mode, or source-code presence.

## Purpose

POS owns point-of-sale selling and transaction execution. It is a business domain that contributes management capabilities to Backoffice and live selling capabilities to Operational.

## Owns / Authority

- sale and sale line;
- checkout;
- POS transaction lifecycle;
- POS tender selection;
- POS payment execution and payment result/status within the accepted payment boundary;
- receipt generation/record;
- refund and void behavior;
- cashier/register/session behavior, including operational opening cash, expected drawer amount, cash received through POS transactions, and closing/counting state;
- POS-specific selling rules.

## Consumes / Depends On

As capabilities become available, POS may consume explicit contracts from:

- Workforce for employee identity and assignments;
- Customer for customer identity;
- Membership/Loyalty for member benefits, points, or eligibility;
- Promotion/Commercial Rules for applicable commercial offers/discount/bonus outcomes;
- Tax/Fiscal for dynamic tax evaluation;
- Inventory for stock authority;
- Finance / Financial Operations for Finance-owned settlement destinations, general cash movements, expenses, settlements, and reconciliations through an explicit payment/financial integration contract;
- other shared capabilities only through accepted contracts.

## Does Not Own

- canonical employee identity;
- canonical customer identity;
- membership/loyalty authority;
- canonical stock/warehouse authority;
- Workshop service workflow;
- CORE client/product/entitlement/installation lifecycle;
- shared Dashboard/Reporting composition;
- canonical Tax/Fiscal rule authority;
- Promotion/Commercial Rules authority.
- general Financial Account, Cash Account, Bank Account, or E-Wallet/settlement-account authority;
- general Expense or Cash Movement authority;
- Settlement or Reconciliation authority;
- Finance-owned operational history/projections.

## Backoffice Contribution

Examples, subject to current accepted implementation:

- transaction history/management;
- sale/refund/void oversight;
- POS configuration;
- POS-related reporting entry points;
- POS-specific catalog/selling configuration where the owning catalog boundary permits it.

## Operational Contribution

- cashier/sell flow;
- cart/checkout;
- tender/payment execution;
- receipt;
- cashier/register/session operations.

General movement after or beyond the Cashier Session boundary, such as cash deposit, account transfer, expense, bank/e-wallet movement, settlement, or reconciliation, belongs to Finance / Financial Operations.

The current historical `apps/cashier` implementation is the existing POS contribution to Digvation Operational.

## Dashboard Projection

POS may contribute metrics such as:

- gross/net sales;
- transaction count;
- average transaction value;
- payment/tender mix;
- refund/void indicators;
- other accepted POS metrics.

Dashboard owns composition/presentation, not POS transaction authority.

## Report Projection

POS may register reports such as:

- sales summary/detail;
- transaction report;
- payment/tender report;
- refund/void report;
- cashier/session report.

Report execution must query authoritative POS contracts/projections and preserve tenant/location/permission boundaries.

## Current Scope

Current accepted POS implementation remains authoritative and must be discovered from Codebase Memory MCP plus actual repository source before changes.

The current near-term platform focus may include integration with Workforce and Customer/Membership, but those are not owned by POS.

## Deferred / Future

- Inventory integration beyond currently accepted behavior;
- Workshop integration;
- other domains not explicitly activated by the current task.

## Integration Rules

- preserve server authority for money and transactional rules;
- no direct cross-domain repository/database access;
- use explicit ports/APIs/events/contracts for shared capabilities;
- integrate POS transaction/payment references with Finance through an explicit contract rather than direct Finance repository/table access;
- do not implement POS-local copies of Workforce, Customer, Membership, Promotion, Tax, Inventory, or Finance authority.

# Finance / Financial Operations Scope Contract

Kind: `SHARED_BUSINESS_CAPABILITY`
Status: `ACTIVE`
Entitlement Class: `CAPABILITY`
Commercial Packaging: `ADD_ON_CAPABLE`

## Commercial Availability / Effective Entitlement

Finance / Financial Operations is an optional shared business capability. Its canonical capability key is:

```text
FINANCE_OPERATIONS
```

A product, contract, or SaaS package may bundle Finance or sell it as an add-on, but CORE/control-plane must resolve that packaging into the effective entitlement set. Runtime and frontend behavior must consume the resolved capability rather than infer availability from package name, business type, repository name, deployment mode, dedicated infrastructure, white-label branding, or source-code presence.

## Purpose

Provide one reusable authority for general financial accounts and operational financial activity consumed by POS, Workshop, and future Digvation business domains without making those originating domains the owner of Finance.

Financial Accounts are the business destinations and sources of money. Payment methods are not independent financial destinations: Finance routes an eligible method at a selling location and currency to its Financial Account.

Finance is not a full accounting domain by implication. Broader accounting scope requires a separate durable decision.

## Owns / Authority

- Financial Account, which may be organization/shared or location-specific;
- Cash Account;
- Bank Account;
- E-Wallet or settlement-account representation;
- payment-to-financial-account routing, unique per selling location, payment method, and currency, where the route selects a Finance-owned destination;
- Cash Movement for physical cash activity that is not a POS Sale Payment or an Expense;
- Expense request lifecycle and its realized financial outflow;
- Expense approval/rejection authority through permissions;
- Settlement;
- future Reconciliation when explicitly activated;
- financial operational history and projections owned by those concepts.

## Consumes / Depends On

- effective `FINANCE_OPERATIONS` entitlement and Installation runtime capability;
- tenant/runtime context;
- Organization/Location for authorized location references;
- Account/Identity/RBAC and Operational Access for actor permission and location scope;
- POS payment/transaction references through an explicit integration contract;
- future Workshop or other domain transaction references through explicit integration contracts;
- Audit & Activity for material semantic financial events.

## Does Not Own

- POS Sale, Sale Line, checkout, tender selection, Sale Payment execution, payment result/status, receipt, refund, void, or revenue authority;
- POS Cashier Session or operational cash-drawer/session state;
- Workshop work order or service execution;
- Inventory stock or stock movement;
- originating business-domain transactions merely because they produce a financial reference;
- Tax/Fiscal rules or calculation;
- shared Dashboard/Reporting composition;
- full general-ledger/accounting authority unless separately defined later.

## Cashier Session Boundary

POS owns Cashier Session behavior, including opening cash, expected drawer amount, cash received through POS transactions, and closing/counting state. Cash drawer count/reconciliation is therefore not a Finance Reconciliation substitute.

Finance owns general movement after or beyond that operational session boundary, including cash movement, expense, bank/e-wallet expense outflow, and settlement. Finance Reconciliation remains deferred until the required external settlement evidence and cash-session boundary are explicitly activated.

The boundary must be crossed through an explicit payment/financial integration contract rather than direct repository or table access.

## Backoffice Contribution

Subject to accepted implementation and permission, Finance may contribute shared Backoffice modules such as:

- Financial Accounts;
- payment routing to Finance-owned settlement destinations;
- Expenses;
- Cash Movements;
- Settlement;
- Finance reports.

Finance does not create a permanent standalone human-facing application by default.

## Operational Contribution

Normally none as a separate application.

When explicitly delivered, Finance may contribute a focused Operational Expense request module. It is limited to submission and backend-authoritative visibility of the requester's own requests. POS cashier/session behavior remains the POS Operational contribution.

## Dashboard Projection

Finance may contribute authoritative indicators such as:

- cash movement totals;
- approved expense totals;
- settlement status/amounts;
- other accepted Finance-owned metrics.

Dashboard owns composition and presentation, not Finance calculations.

## Report Projection

Finance may register authoritative projections/reports for:

- financial accounts where reportable;
- expenses;
- cash movements;
- settlements;
- Finance-owned operational history.

POS separately contributes authoritative sales and POS payment projections. Cross-domain business-performance reporting requires explicit projection/analytics contracts and must not directly join unrelated domain persistence as its durable architecture.

## Audit & Activity

Material Finance mutations should emit safe business-semantic audit activity where applicable, including:

- `FINANCIAL_ACCOUNT_CREATED`;
- `FINANCIAL_ACCOUNT_UPDATED`;
- `CASH_MOVEMENT_RECORDED`;
- `EXPENSE_CREATED`;
- `EXPENSE_APPROVED`;
- `EXPENSE_REJECTED`;
- `SETTLEMENT_RECORDED`;

Do not include credentials, secret account data, payment secrets, tokens, or other prohibited sensitive data in audit payloads.

## Current Scope

Finance / Financial Operations is active because substantial accepted functionality already exists in the current Digvation Business Runtime and Backoffice implementation.

The approved Finance architecture is:

- Finance owns Financial Account, Payment Route, Expense, Cash Movement, Settlement, and future Reconciliation; POS remains the authority for Sale, Sale Payment, and revenue.
- A Payment Route is specific to selling location, payment method, and currency. A route selects the Financial Account; it does not make the payment method an independent financial destination.
- Before a POS Sale Payment is created, POS resolves the active Finance route through an explicit contract. The Sale Payment retains the Finance-issued route and destination-account snapshot immutably, so a later route change never reinterprets historical payment facts.
- A Financial Account may be organization/shared or location-specific. Its permitted use must remain tenant-, permission-, and location-authorized.
- Expense is a Finance request with the terminal lifecycle `PENDING -> APPROVED | REJECTED`. Only `APPROVED` Expense is a realized financial outflow and may contribute to realized Finance totals/reporting; `PENDING` and `REJECTED` never do.
- Expense records require the useful Finance facts: selling location, source Financial Account, currency snapshot, decimal amount, controlled category, occurred-at value, requester/origin, state, decision actor/timestamps/note, and the linked Cash Movement where applicable. Attachments, supplier/invoice fields, approval chains, and broader accounting records are not implied.
- Approval/rejection is permission-based. Owner is the only current permission assignment for those actions, but Owner is not a hard-coded permanent approver rule.
- An Operational Expense requester may view only their own requests. The backend, using the authenticated actor, enforces that restriction; UI filtering is insufficient.
- Approval of a Cash-source Expense creates exactly one linked `CASH_OUT` Cash Movement atomically. Approval of a Bank- or E-Wallet-source Expense creates no fake Cash Movement.
- Cash Movement is not a generic Expense and an Expense-linked Cash Movement must not be double-counted as a second realized expense.
- This lock does not introduce a General Ledger, chart of accounts, or a broader Accounting domain.

Existing implementation/migration behavior is reuse source only. It must be corrected or extended through explicit implementation work; historical source presence does not override this architecture lock.

Historical placement inside `digvation-business-runtime` or POS-named frontend packages does not make POS the owner. Existing behavior is migration/reuse source and must be re-homed without duplication or unrequested behavior changes.

This scope contract does not authorize new Finance product behavior by itself.

## Deferred / Future

- granular entitlements such as `EXPENSE_MANAGEMENT`, `SETTLEMENT`, or `RECONCILIATION`;
- active Reconciliation UI, report, or workflow. Reconciliation remains dormant for the current product and must not remain active merely because historical implementation exists. Its future purpose is to compare system expected collection/settlement with actual counted or externally settled amount, with `MATCHED`, `DISCREPANCY`, and then `RESOLVED` only after a discrepancy is investigated;
- general ledger;
- chart of accounts beyond currently accepted Financial Account behavior;
- accounts payable/receivable;
- budgeting;
- payroll;
- statutory accounting;
- advanced treasury/cash forecasting;
- any broader Accounting domain behavior not explicitly decided later.

## Integration Rules

- Finance exists independently from POS and other originating business domains;
- POS, Workshop, and future domains integrate through explicit application contracts, ports, APIs, or events;
- no business domain may directly access Finance repositories or database tables;
- Finance must not take ownership of originating Sale, Work Order, or other domain entities;
- POS tender selection/payment execution remains POS-owned while Finance owns payment destinations and post-transaction financial operations. POS must not read Finance persistence directly or resolve a historical destination from mutable current routing;
- Finance must issue the route/account snapshot used by a POS Sale Payment through an explicit integration contract. The stored snapshot is immutable for the payment's history;
- an Expense source account must be active, currency-compatible, and authorized for its selling location. Cash, Bank, and E-Wallet sources are valid Finance sources subject to that rule;
- realized Expense, Cash Movement, Settlement, and future Reconciliation totals must preserve their distinct semantics and must not be summed as duplicate facts;
- Finance calculations and histories remain Finance-owned even when composed by Dashboard/Reporting;
- entitlement, runtime capability, permission, tenant, and location boundaries are backend-authoritative;
- preserve accepted monetary precision, transaction boundaries, idempotency, and audit safety during implementation migration.

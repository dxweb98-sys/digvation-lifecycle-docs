# Audit & Activity Scope Contract

Kind: `SHARED_BUSINESS_FOUNDATION`
Status: `ACTIVE`
Entitlement Class: `PLATFORM_FOUNDATION`
Commercial Packaging: `BASE`

## Purpose

Provide one tenant-safe, business-semantic audit/activity authority for important administrative and operational changes across Digvation.

Audit/Activity answers questions such as:

- who changed something;
- what business action occurred;
- which entity was affected;
- when and from which client/location/runtime context it occurred;
- what relevant business values changed;
- whether the action succeeded or was rejected.

It is not a replacement for application logs, tracing, analytics, or an owning domain's detailed transaction history.

## Owns / Authority

- immutable or append-only audit/activity records for accepted auditable actions;
- actor identity/reference and actor context;
- tenant/client, installation, organization/location context where available;
- owning domain and semantic action name;
- affected entity type/reference;
- safe before/after change metadata where appropriate;
- reason/comment metadata when the business action requires it;
- result/outcome metadata;
- correlation/request/reference identifiers needed for traceability;
- audit retention/export semantics when explicitly defined.

Audit records should describe business meaning, for example:

```text
EMPLOYEE_DEACTIVATED
MEMBERSHIP_TIER_CHANGED
TAX_RULE_UPDATED
REFUND_APPROVED
STOCK_ADJUSTED
WORK_ORDER_CANCELLED
```

Do not treat raw HTTP verbs or controller routes as the primary business action model.

## Consumes / Depends On

- authoritative business-domain events/actions;
- Workforce/identity reference for actor display when applicable;
- Organization/Location context;
- tenant/runtime context;
- authorization context for visibility/export;
- domain-provided safe change metadata.

## Does Not Own

- POS sale/transaction history;
- Workshop work-order history;
- Inventory stock ledger;
- Membership points ledger;
- application/server logs;
- metrics, traces, observability incidents;
- analytics/business intelligence;
- authentication secrets or sensitive credential material.

Owning domains may expose their own focused history/timeline while also contributing important actions to the global Audit/Activity authority.

## Sensitive Data Rules

Never store secrets or unnecessary sensitive values in audit payloads.

Examples that must be omitted, masked, tokenized, or represented only by safe references as applicable:

- passwords;
- access/refresh tokens;
- API keys/secrets;
- full payment-card data;
- private credentials;
- sensitive authentication artifacts.

Audit detail visibility must respect tenant isolation and explicit permissions.

## Backoffice Contribution

Audit/Activity contributes a shared Backoffice activity surface, conceptually such as:

- Activity Log;
- Activity Detail;
- search/filter by actor, domain, action, entity, location, result, and date/time;
- authorized export when explicitly scoped.

The UI should prioritize readable business-semantic activity rather than raw request logs.

Any Audit/Activity UI work must use `uiuxpromax` and the existing Digvation Design System.

## Operational Contribution

Normally no global Operational module.

Operational domains may show domain-specific history/timelines where needed, while important auditable actions are also recorded centrally.

## Dashboard Projection

May contribute compact administrative/risk indicators when explicitly useful, for example:

- recent configuration changes;
- high-risk administrative changes;
- recent employee/access/configuration activity.

Dashboard must not become a log viewer.

## Report Projection

May register authorized audit/activity reports or exports when required for operational review/compliance.

Audit reporting must preserve tenant, permission, retention, and sensitive-data rules.

## Current Scope

Audit/Activity is now a Digvation foundation.

Current foundation scope is to establish the authority and require new material business/admin changes to integrate with it when those features are implemented or remediated.

Existing features do not need unrelated broad retrofitting unless the current task explicitly includes audit coverage.

Near-term features such as Workforce/Employee Management, Customer/Membership, and Tax/Fiscal should treat auditable mutation coverage as part of their normal backend-authoritative design.

## Deferred / Future

- advanced compliance policy packs;
- anomaly/risk scoring;
- external SIEM export;
- configurable retention by jurisdiction;
- bulk archival tooling;
- generic event-sourcing architecture;
- any capability not explicitly activated.

## Integration Rules

- business domains remain authority for the action being audited;
- Audit/Activity stores traceability, not duplicate business authority;
- use semantic actions, not generic CRUD/HTTP labels as the primary record;
- audit writes must not allow one tenant to observe another tenant's activity;
- sensitive values must be minimized/masked;
- important financial/configuration/access/lifecycle mutations should be auditable;
- failure to display an audit record must not silently transfer domain authority to the UI;
- do not use Audit/Activity as a substitute for observability or domain ledgers.


Promotion administration uses the same audit authority for events such as `PROMOTION_CREATED`, `PROMOTION_UPDATED`, `PROMOTION_APPROVED`, and `PROMOTION_ACTIVATED` when those capabilities exist.

Finance / Financial Operations uses the same audit authority for material events such as `FINANCIAL_ACCOUNT_CREATED`, `FINANCIAL_ACCOUNT_UPDATED`, `CASH_MOVEMENT_RECORDED`, `EXPENSE_CREATED`, `EXPENSE_APPROVED`, `EXPENSE_REJECTED`, `SETTLEMENT_RECORDED`, and `RECONCILIATION_COMPLETED` when those actions exist. Audit payloads must omit credentials, secret account data, payment secrets, tokens, and other prohibited sensitive data.

# Workshop Scope Contract

Kind: `BUSINESS_DOMAIN`
Status: `NEXT`
Entitlement Class: `PRODUCT`
Commercial Packaging: `PRODUCT`

## Purpose

Workshop is a first-class Digvation business domain for workshop service/work execution.

Workshop owns the Workshop Work Order lifecycle and Workshop-specific execution context. It contributes functionality into the shared Digvation Backoffice and Operational experiences rather than creating permanent Workshop-specific application shells.

`WORKSHOP` is a product-level entitlement. Entitlement controls product availability but does not imply deployment mode, branding, appearance, theme, or a separate application.

## Owns / Authority

Workshop is authoritative for:

- Vehicle within the Workshop domain context;
- Workshop Work Order;
- Work Order lifecycle;
- Work Order job and execution context;
- Workshop mechanic eligibility/profile as a Workshop-specific extension of canonical Employee identity;
- mechanic/technician assignment and workload within Workshop;
- service and part usage within a Work Order;
- Workshop operational work status and timeline;
- Workshop-specific billing context;
- Workshop Invoice semantics and presentation responsibility where applicable;
- Workshop completion and cancellation semantics.

Workshop work execution state and Workshop financial state are separate business concepts.

## Consumes / Depends On

Workshop consumes existing canonical authorities through explicit contracts:

- Customer for canonical customer identity;
- Workforce for canonical Employee identity and status;
- Catalog for Product, Service, Variant, pricing, lifecycle, and reusable composition;
- Organization / Location for canonical business location and branch identity;
- Identity / RBAC for authentication, account authority, permissions, and role enforcement;
- Operational Access for authorized operating-location context;
- Finance / Payment for payment methods, payment routing, financial accounts, split-payment concepts, and financial posting authority;
- Tax / Fiscal for applicable tax authority;
- Promotion / Commercial Rules when enabled;
- Audit / Activity for shared audit and activity infrastructure;
- Dashboard / Reporting for shared projection and composition infrastructure;
- Inventory for stock authority and inventory operations;
- Notification for shared delivery infrastructure when activated.

## Does Not Own

Workshop does not own:

- canonical Customer identity;
- canonical Employee identity or Workforce lifecycle;
- canonical Product, Service, Variant, pricing, or Catalog lifecycle;
- a separate Workshop-specific BOM or reusable composition authority;
- canonical Organization / Location authority;
- authentication, account, or RBAC authority;
- Operational Access authority;
- payment routing, financial accounts, or general financial posting authority;
- Tax / Fiscal authority;
- Promotion / Commercial Rules authority;
- canonical stock balances, stock ledger, or Inventory authority;
- shared Audit / Activity infrastructure;
- shared Dashboard / Reporting infrastructure;
- Notification delivery infrastructure;
- CORE lifecycle or entitlement authority;
- POS Sale lifecycle.

`WORKSHOP WORK ORDER != POS SALE`.

Workshop may reuse shared or POS-adjacent platform contracts where ownership is genuinely shared, but Workshop Work Order execution must not be implemented as the POS Sale lifecycle.

## Backoffice Contribution

Workshop contributes Workshop management capabilities into the shared Digvation Backoffice experience, including at the durable boundary level:

- Workshop work management and supervision;
- Workshop-owned configuration where applicable;
- mechanic eligibility and workload visibility;
- Workshop-authoritative dashboard and reporting contributions.

Workshop does not create a permanent Workshop-only Backoffice application.

## Operational Contribution

Workshop contributes live Workshop execution into the shared Digvation Operational experience, including at the durable boundary level:

- customer and vehicle intake;
- Workshop work queue;
- mechanic/technician assignment and execution context;
- service and part handling within a Work Order;
- Work Order progress and operational timeline;
- cashier/billing validation where applicable;
- payment collection through shared Finance / Payment authority.

Workshop does not create a permanent Workshop-only Operational or mechanic application unless a separate runtime, device, security, or operational boundary is explicitly approved.

## Dashboard Projection

Workshop may contribute Workshop-authoritative projections into the shared Dashboard infrastructure, such as Work Order, execution, workload, service, and completion information within the activated Workshop scope.

Dashboard composition remains shared infrastructure and does not become Workshop business-data authority.

## Report Projection

Workshop may contribute Workshop-authoritative Work Order, service execution, mechanic workload, billing-context, completion, and operational-history projections into shared reporting.

Cross-domain reporting must use explicit projection or integration contracts rather than direct repository or database access.

## Current Scope

The current Workshop delivery scope establishes the Workshop MVP domain boundary around:

- Vehicle context required for Workshop work;
- Workshop Work Order and its lifecycle;
- Work Order job and execution context;
- Workshop mechanic eligibility/profile;
- mechanic/technician assignment and workload;
- service and part usage within a Work Order;
- Workshop operational work status and timeline;
- Workshop-specific billing context;
- Workshop Invoice semantics/presentation responsibility where applicable;
- Workshop completion and cancellation semantics;
- Workshop contribution to the shared Backoffice and Operational experiences;
- Workshop-authoritative Dashboard and Report projections required by this scope.

This scope defines durable domain responsibility only. It does not define physical tables, DTOs, endpoints, exact state enums, transport contracts, or implementation architecture for later implementation units.

## Deferred / Future

The following remain explicitly deferred until activated by dedicated scope/tasks:

- Vehicle Inspection;
- Estimate;
- Quality Control;
- deeper Service History;
- Scheduling / Appointment integration;
- advanced Inventory integration;
- Workshop notification automation.

Deferred concepts are part of the wider Workshop domain envelope only and are not implementation authorization.

## Integration Rules

- Use `REUSE -> EXTEND -> NEW`.
- Workshop consumes shared authorities through explicit application/domain contracts, ports, APIs, events, or trusted bindings.
- No direct cross-domain repository or database access is permitted, even when domains are physically colocated.
- Workforce remains canonical Employee authority; Workshop mechanic eligibility/profile is a Workshop-owned extension rather than a duplicate Employee.
- Catalog remains authority for reusable Product, Service, Variant, pricing, and composition behavior.
- Workshop owns service/part usage only inside its Work Order context.
- Workshop must not create a second Workshop-specific BOM/composition authority.
- Inventory remains authority for stock, stock balances, and stock ledger behavior.
- Finance / Payment remains authority for shared payment and financial infrastructure; Workshop owns only its Workshop-specific billing context and Invoice semantics.
- Workshop Work Order execution state and financial state remain separate concepts.
- Workshop Work Order must not be represented as a POS Sale.
- Backoffice and Operational remain shared Digvation experiences.
- Workshop entitlement does not imply a Workshop-specific application shell, deployment mode, branding, appearance, or theme.
- Appearance, Experience Layout, white-label branding, and DIG-59 remain separate concerns.
- Do not introduce product-specific theme authorities such as `WORKSHOP_THEME`, `AUTOMOTIVE_THEME`, or `POS_THEME` from this scope contract.

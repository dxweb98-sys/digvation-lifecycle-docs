# Digvation Ecosystem Architecture

## 1. Canonical ecosystem model

Digvation is a composable business platform coordinated by a shared control plane.

The canonical architecture has four independent layers:

```text
                         DIGVATION CORE
                         CONTROL PLANE
                               |
                 Client / Product + Capability Entitlements
                               |
                          Installation
                               |
                     Runtime Composition
                               |
             +-----------------+-----------------+
             |                                   |
        BACKOFFICE                         OPERATIONAL
      manage the business                 run the business
             |                                   |
             +-----------------+-----------------+
                               |
                        BUSINESS DOMAINS
                               |
          +--------------------+--------------------+
          |                    |                    |
         POS               WORKSHOP             INVENTORY
          |                    |                    |
          +---------------- explicit contracts ----+
                               |
                    Future business domains
              Scheduling / Accounting / CRM / ...
```

These layers must not be collapsed into each other.

- CORE does not become the operational backend.
- Backoffice and Operational are not separately sold business products.
- POS, Workshop, Inventory, and future domains do not own their own duplicate UI shells.
- deployment mode, infrastructure ownership, branding, product entitlement, and optional capability/add-on entitlement are separate concerns.

## 2. System boundary vocabulary

Use these terms consistently.

### Control Plane

`Digvation CORE`

Owns commercial, installation, release, infrastructure, runtime, and operational-control metadata.

### Business Platform

The Digvation runtime that executes client business behavior.

It is composed from one or more entitled business domains and shared business foundations.

### Business Domain / Product

A bounded business authority such as:

- POS;
- Workshop;
- Inventory;
- Scheduling;
- Accounting;
- future Digvation business products.

A business domain owns its own rules and authoritative operational data.

### Experience

Digvation has two primary human-facing experiences:

- `Backoffice` — configure, manage, supervise, analyze, and administer the business;
- `Operational` — execute live day-to-day business work.

Product/domain functionality contributes modules to these experiences.

### Deployment

Defines where and how an Installation runs.

Deployment does not decide which products a client owns.

### Business Configuration

Defines how a tenant chooses to operate inside its entitled runtime. It is
persisted business authority, separate from both CORE control-plane metadata and
deployment/runtime configuration.

Deployment/runtime configuration owns installation topology, endpoints,
adapters, deployment availability, white-label branding, and bootstrap defaults.
It may seed a newly provisioned tenant, but it is not the mutable tenant
Business Settings database. CORE does not own ordinary tenant preferences.

Business Runtime owns persisted Business Configuration. Backoffice edits it only
through Runtime contracts; Operational consumes the same effective configuration
and does not maintain a second copy. Business preferences may hide or refine an
already entitled and permitted experience, but never grant a product, capability,
report, permission, or location scope.

## 3. CORE responsibilities

CORE owns control-plane concepts such as:

- Client;
- Product;
- ProductFeature;
- ClientProduct;
- Subscription;
- Entitlement;
- Installation;
- product/domain runtime bindings;
- provisioning state;
- deployment/runtime metadata;
- infrastructure ownership and management metadata;
- component/application version metadata;
- lifecycle/health/operations metadata where appropriate.

CORE answers questions such as:

- Which client is this?
- Which Digvation products/domains is the client entitled to?
- Which optional capabilities/add-ons is the client entitled to?
- Which effective features are enabled after resolving plan/contract/bundle/add-on grants?
- Which Installation/runtime composition serves the client?
- Is the runtime shared or dedicated?
- Who owns and manages its infrastructure?
- Which domain services and experience applications are deployed?
- Which versions/builds are installed?
- What is the installation lifecycle/deployment state?

CORE does **not** own POS sales, Workshop work orders, Inventory stock, or another operational domain's authoritative transactions.

## 4. Business domains own business authority

Each business domain owns its operational rules and data.

### POS owns selling

Examples:

- Sale;
- Sale Line;
- checkout;
- payment execution;
- receipt;
- refund/void;
- cashier/register session;
- POS-specific selling behavior.

POS does not own canonical Inventory stock merely because stock is consumed by a sale.

### Workshop owns service execution

Examples:

- Vehicle;
- Inspection;
- Estimate;
- Work Order;
- Work Order Job;
- Mechanic Profile/Assignment;
- labor execution;
- quality control;
- service history.

Workshop does not own canonical Inventory stock merely because parts are consumed by a Work Order.

### Inventory owns stock authority

Examples:

- inventory item/SKU projection where applicable;
- Warehouse;
- Stock;
- Stock Ledger / Stock Movement;
- Reservation;
- Transfer;
- Receiving;
- Adjustment;
- Purchasing and costing when assigned to this domain.

Inventory must not contain POS-specific or Workshop-specific workflow rules.
It receives explicit business references/reasons such as `SALE` or `WORK_ORDER` through contracts.

## 5. Backoffice and Operational are shared experiences

Backoffice and Operational are platform experiences, not one application per business type.

A client with POS + Inventory may see:

```text
Backoffice
- Sales
- Catalog/Pricing
- Inventory
- People
- Reports

Operational
- Point of Sale
- Inventory Operations (when permitted)
```

A client with Workshop + Inventory may see:

```text
Backoffice
- Workshop
- Inventory
- People
- Reports

Operational
- Workshop Floor / My Jobs
- Inventory Operations (when permitted)
```

A client with POS + Workshop + Inventory may use modules from all three domains in the same two experience shells.

Do not create a separate permanent `Workshop Backoffice`, `POS Backoffice`, `Mechanic App`, or `Warehouse App` when the capability belongs inside the shared Backoffice or Operational experience.

A separately deployable frontend is justified only by a real runtime/device/security/operational boundary, not by product naming alone.

## 6. Experience composition authority

Visible application capability is composed from authoritative context.

Conceptually:

```text
Visible Capability
=
Client Entitlement
INTERSECT Installation Runtime Capability
INTERSECT User Permission
INTERSECT Location / Operational Context
```

Where a tenant has configured a safe dashboard/report visibility preference, it
is an additional final intersection that may hide content only. It cannot grant
content absent from the preceding authoritative intersections.

Do not use `businessType` or client-name branching as feature authority.

A business profile such as `AUTOMOTIVE_WORKSHOP`, `RETAIL`, or `F&B` may be used for:

- onboarding presets;
- recommended products;
- terminology;
- default dashboards/configuration.

It does not grant entitlement and does not define system ownership.

## 7. Shared business foundations and capabilities

A concept used by multiple business domains should have one legitimate authority rather than being duplicated in each product.

Examples that may belong to shared business/platform foundations or shared business capabilities when confirmed by current architecture:

- Tenant/runtime identity;
- Organization / Branch / Location identity;
- Employee/Workforce identity;
- Account/Identity/RBAC;
- Operational account-to-location access;
- Customer/Party identity;
- Membership/Loyalty capability;
- Promotion/Commercial Rules capability;
- Tax/Fiscal rules;
- Finance / Financial Operations capability;
- authorization primitives;
- audit;
- configuration;
- files/media;
- notification primitives.

Shared does not mean generic dumping ground. Each shared foundation/capability still needs one explicit authority and a narrow contract.

### Finance / Financial Operations

Finance / Financial Operations is an optional shared business capability, independent from POS, that owns general financial accounts, expenses, cash movements, settlements, reconciliations, and their authoritative operational history/projections.

POS retains Sale, checkout, tender selection, payment execution/result, receipt, refund/void, Cashier Session, and operational cash-drawer/session state. General movement after or beyond the Cashier Session boundary belongs to Finance.

POS, Workshop, and future domains integrate with Finance through explicit application contracts, ports, APIs, or events. They must not access Finance repositories or tables directly, and Finance must not take ownership of their originating transactions.

Finance availability is controlled by the effective `FINANCE_OPERATIONS` capability entitlement resolved by CORE. SaaS package names, deployment mode, branding, repository placement, and source-code presence are not runtime authorization.

Finance contributes modules to shared Backoffice and, only where genuine live financial work is scoped, may contribute to Operational. It does not create a permanent standalone application by default.

The durable detailed contract lives in `scopes/FINANCE_OPERATIONS.md`.

### Operational access and branch/location context

Account/Identity/RBAC and Operational location access are separate authorities. Account/Identity/RBAC answers who may authenticate and what they may do; Operational Access answers where they may operate.

Operational location access is independent from employee identity, product entitlement, and the existence of a Branch/Location record.

Canonical rules:

- organization may have one or many branches/locations;
- Owner has organization-wide operational location scope, subject to entitlement/runtime/permission checks;
- Manager remains explicitly branch/location-scoped;
- other operational accounts are explicitly branch/location-scoped;
- an account cannot switch to or operate in another branch/location until authorized there;
- one permitted location should auto-resolve without forcing a selector;
- multiple permitted locations may be selected/switched only from the authorized set;
- backend authorization remains authoritative even when the UI hides the selector for a single-location user.

Use `scopes/OPERATIONAL_ACCESS.md` for the durable access contract.

Domain-specific extensions remain in their owning domain.

Example:

```text
Employee EMP-001
   |
   +-> POS CashierAssignment
   |
   +-> Workshop MechanicProfile
   |
   +-> Inventory Operator capability
```

Do not create one growing global enum that turns all domain roles into one shared model.


## 8. Shared Dashboard and Reporting composition

Dashboard and Reports are shared experience projections, not business-data authorities.

Each owning domain/foundation contributes only the metrics/reports it can authoritatively answer. Backoffice composes those contributions from entitlement, runtime capability, permission, location/organization context, and available projections.

Examples:

```text
POS -> sales / transaction / tender projections
Finance -> financial account / expense / cash movement / settlement / reconciliation projections
Workforce -> employee roster/status projections
Customer/Membership -> member/customer projections
Promotion -> active/utilization/commercial-benefit projections when activated
Workshop -> work-order/service projections (when activated)
Inventory -> stock projections (when activated)
```

A client's business profile may provide a recommended dashboard preset or terminology, but it is not authorization and must not hard-code the whole dashboard.

Dashboard configuration may eventually support safe widget visibility/order and role/business presets, but only explicitly scoped capabilities should be implemented.

Reports may share presentation/filter/export infrastructure, but domain calculations stay with their owning authority. Cross-domain reports require an explicit projection/analytics contract, never ad-hoc UI joins or cross-domain table access.

The durable detailed contract lives in `scopes/DASHBOARD_REPORTING.md`.

## 9. Shared Tax / Fiscal capability

Tax/Fiscal is a shared business capability that may be consumed by POS, Workshop, and future domains. Do not implement separate drifting tax engines per domain.

Tax rule evaluation is dynamic and may depend on authoritative context such as:

- client/tenant;
- location/jurisdiction;
- enabled business domain;
- catalog item/service classification and tax category;
- transaction context;
- effective date/time;
- additional customer/fiscal classification only when explicitly defined.

Tax has its own Backoffice configuration surface. The configuration shown to a client must follow the client's enabled business domains, available catalog classifications, location/jurisdiction context, and permission rather than exposing every global rule.

Tax does not own the business catalog. Catalog/domain authorities expose stable tax-relevant classifications; Tax/Fiscal owns the reusable rule/configuration/evaluation semantics.

Money-affecting tax calculation remains backend-authoritative and historical transactions must preserve the applied result/rule snapshot rather than being silently recalculated using future rates.

The durable detailed contract lives in `scopes/TAX_FISCAL.md`.

## 10. Shared Promotion / Commercial Rules capability

Promotion/Commercial Rules is a shared business capability for time-bound commercial offers consumed by POS, Workshop, and future domains. Do not duplicate independent promotion engines inside each transaction domain.

Promotion references Catalog targeting/classification, Customer/Membership eligibility, Organization/Location scope, and Account/RBAC/Operational Access authority through explicit contracts. Catalog remains the catalog authority; Membership remains loyalty-state/points-ledger authority; Tax/Fiscal remains tax authority.

Owner may manage organization-wide promotions subject to permission/policy. Manager promotion authority remains limited to explicitly assigned branch/location scope unless a separate organization-level authority is granted. Backend enforcement is authoritative; single permitted location may auto-resolve without a selector.

Promotion may provide temporary discount/member/bonus-point outcomes, while normal catalog-based loyalty earning remains Membership-owned. Money-affecting promotion evaluation and ordering with Tax/Fiscal are backend-authoritative and historical transactions preserve the applied outcome/reference.

The durable detailed contract lives in `scopes/PROMOTION_COMMERCIAL.md`.

## 11. Scope contracts are the living domain catalog

Durable product/domain/module scope is maintained under `scopes/`.

A scope contract defines:

- kind/status;
- purpose and authority;
- dependencies/non-ownership;
- Backoffice/Operational contributions;
- Dashboard/Report projections;
- Current Scope;
- Deferred/Future scope;
- integration rules.

This lets Digvation add or refine domains such as Workshop without rewriting the ecosystem architecture for ordinary feature additions. Update this ecosystem standard only when the actual platform boundary changes.

`Deferred`, `Planned`, or conceptual scope is never automatic implementation authorization.

## 11. Cross-domain integration rules

No direct cross-domain database/repository shortcut.

Forbidden even when domains currently share one process/repository:

```text
POS SaleService -> Inventory StockRepository
Workshop WorkOrderService -> Inventory StockRepository
Inventory -> POS tables
Inventory -> Workshop tables
```

Use explicit application/domain contracts:

```text
POS
  -> InventoryPort / Inventory API
       -> Inventory authority

Workshop
  -> InventoryPort / Inventory API
       -> Inventory authority
```

If domains are physically colocated, the adapter may be local.
If later physically separated, the adapter may become HTTP/message based without changing domain ownership.

No direct cross-product database access remains a hard rule.

## 12. CORE Client != business runtime tenant

CORE `Client` and a runtime tenant/scope are related but different concepts.

```text
CORE
Client
  -> ClientProducts / Entitlements
       - POS
       - Workshop
       - Inventory
             |
             | trusted provisioning/runtime binding
             v
Business Platform Runtime
  -> tenant/runtime scope
  -> entitled domain capabilities
  -> Backoffice composition
  -> Operational composition
```

A runtime remains tenant-aware even in a dedicated single-client deployment.

## 13. CORE is not a synchronous dependency for every transaction

Normal business operation is served by the business runtime/domain authority.

```text
Backoffice / Operational
          -> Business Domain API
          -> Domain-owned data
```

Do not require ordinary sale/work-order/stock operations to synchronously ask CORE for permission on every transaction.

CORE is primarily used for:

- provisioning;
- entitlement synchronization;
- installation management;
- deployment/release visibility;
- runtime binding/configuration;
- explicit control-plane contracts.

Runtime must retain an accepted entitlement/runtime-context mechanism so ordinary business operation does not unnecessarily fail when CORE is temporarily unavailable.

## 14. Browser trust boundary

Backoffice and Operational must not bypass authoritative business domain backends for normal business behavior.

If operational behavior needs control-plane context:

```text
CORE
  <-> trusted runtime/backend integration
Business Domain Runtime/API
  <-> Backoffice / Operational
```

The backend/runtime authority owns enforcement of tenant, entitlement, permission, monetary, and transactional rules.

UI visibility alone is not authorization.

## 15. Product and capability entitlement are independent from deployment and branding

Digvation distinguishes **what is commercially/operationally enabled** from **how it is packaged**.

Canonical entitlement levels:

```text
PLATFORM FOUNDATION
  Organization/Location, Identity/RBAC, Audit, and other required shared foundations

PRODUCT ENTITLEMENT
  POS, Inventory, Workshop, future business domains

CAPABILITY ENTITLEMENT
  optional reusable capabilities such as FINANCE_OPERATIONS, PROMOTIONS, LOYALTY_POINTS, TAX_FISCAL, or future add-ons
```

A SaaS plan/package may bundle products and capabilities. Commercial packaging is not the runtime authorization contract. CORE/control-plane resolves the package/subscription/add-ons into one explicit **effective entitlement set** consumed by trusted runtimes.

Conceptually:

```text
Subscription / Plan / Contract
      + purchased add-ons
      + product grants
      + capability grants
             |
             v
      Effective Entitlement Set
             |
      +------+-------+
      |              |
Business Runtime   Backoffice/Operational
(enforce)           (compose visibility)
```

Source-code presence, menu presence, business profile, dedicated infrastructure, or white-label branding never grants an optional product/capability. UI visibility is not authorization.

Examples:

```text
Retail Client A
POS = enabled
INVENTORY = disabled
PROMOTIONS = disabled
LOYALTY_POINTS = disabled

Retail Client B / SaaS Pro
POS = enabled
INVENTORY = enabled
PROMOTIONS = enabled
LOYALTY_POINTS = enabled

Workshop Client C
WORKSHOP = enabled
INVENTORY = enabled
POS = disabled
PROMOTIONS = enabled
```

Never infer product ownership from deployment mode or branding.

Dedicated/white-label example:

```text
Client: Bengkel ABC

Product Entitlements
- Workshop
- Inventory

Capability Entitlements
- Promotions

Not Entitled
- POS
- Loyalty Points

Deployment
- DEDICATED
- Infrastructure Owner: CLIENT
- Managed By: DIGVATION
- Branding: WHITE_LABEL
```

This client does not gain POS or Loyalty Points merely because it is dedicated or white-label.

## 16. Installation is runtime composition

An Installation represents the runtime/deployment boundary through which a client receives entitled business capabilities.

Conceptually:

```text
Client
  -> Product + Capability Entitlements
  -> Installation
       -> Runtime Composition
            -> Backoffice
            -> Operational
            -> POS domain runtime (if entitled)
            -> Workshop domain runtime (if entitled)
            -> Inventory domain runtime (if entitled)
```

Implementation may retain existing identifiers/relationships while the codebase is migrated, but new architecture decisions must follow this semantic model.

Installation composition must not activate a business domain or optional capability without the applicable effective entitlement.

## 17. Deployment dimensions

Treat these as independent dimensions.

### Deployment isolation

- SHARED
- DEDICATED

### Infrastructure ownership

- DIGVATION
- CLIENT

### Operational management

- DIGVATION
- CLIENT
- SHARED_RESPONSIBILITY when contractually supported

### Branding

- DIGVATION_DEFAULT
- WHITE_LABEL

Valid examples:

```text
SHARED + DIGVATION infrastructure + DIGVATION managed + DIGVATION_DEFAULT
DEDICATED + DIGVATION infrastructure + DIGVATION managed + WHITE_LABEL
DEDICATED + CLIENT infrastructure + DIGVATION managed + WHITE_LABEL
DEDICATED + CLIENT infrastructure + CLIENT managed + WHITE_LABEL
```

Do not create a single `clientType` enum that mixes these dimensions.

## 18. Shared SaaS and dedicated composition

### Shared SaaS

The shared Digvation platform may run all supported domain runtimes centrally.

Tenant entitlement controls which capabilities each client may use.

```text
Shared Runtime
- Backoffice
- Operational
- POS
- Workshop
- Inventory

Tenant A -> POS + Inventory
Tenant B -> Workshop + Inventory
Tenant C -> POS + Workshop + Inventory
```

### Dedicated

A dedicated Installation should compose only the components required by the client's entitled domains where deployment packaging permits it.

```text
Client A: Workshop + Inventory

Deploy
- Backoffice
- Operational
- Workshop runtime
- Inventory runtime

Do not require POS runtime.
```

The same canonical source/product line is used; dedicated/white-label must not create a client source fork.

## 19. White-label

White-label is branding/runtime configuration, not a new product and not a source fork.

Possible white-label configuration includes:

- application name;
- logo/assets;
- theme/tokens supported by the Design System;
- domain/DNS;
- client-facing identity;
- optional Digvation attribution according to agreement.

Do not implement client behavior as `if client == "..."`.

## 20. Current repository/project meaning

Repository and folder names may temporarily retain historical `pos` naming during migration.

Historical path/name is **not** architecture authority.

Current semantic mapping is:

```text
Existing repository/path            Current project meaning
-----------------------------------------------------------------------
digvation-business-web                   Digvation Business Web
apps/backoffice                     Digvation Backoffice experience
apps/cashier                        current POS Operational implementation
                                    and migration source for Operational

digvation-business-runtime               Digvation Business Runtime (current
                                    backend implementation / migration source)
```

The target project vocabulary is:

```text
Digvation Business Web
- Backoffice
- Operational

Digvation Business Runtime / Domain Services
- POS
- Workshop
- Inventory
- future domains

Digvation Business Runtime / Shared Capabilities
- Finance / Financial Operations
- other canonical shared capabilities
```

Repository rename is optional and must not block architecture migration.
If repositories are renamed later, rename only at an explicit Git/repository administration gate.

Do not rename source files/folders merely to make terminology look complete when the current work only changes architecture meaning.

## 21. Existing POS implementation is migration source, not disposable legacy

Accepted POS implementation remains valid production work.

When boundaries are changed:

- move/re-home existing behavior to the correct owner before rewriting;
- preserve accepted behavior and data semantics;
- do not maintain duplicate old/new authorities;
- do not rebuild accepted POS features merely because POS is now one domain inside the Business Platform;
- current `cashier` implementation remains the first POS Operational experience;
- current Backoffice remains the foundation of the shared Backoffice experience.

The architecture change is an ownership/composition change, not permission to restart the product.

## 22. Version and component visibility

CORE should be able to represent an Installation using component/runtime vocabulary rather than assuming POS-only topology.

Example:

```text
Installation: client-a-production
Client: <client>
Isolation: DEDICATED
Infrastructure Owner: CLIENT
Branding: WHITE_LABEL
Environment: production

Entitled Domains:
- Workshop
- Inventory

Components:
- Backoffice: <version> / build <sha>
- Operational: <version> / build <sha>
- Workshop Runtime: <version> / build <sha>
- Inventory Runtime: <version> / build <sha>

Deployment state: healthy
```

A POS-entitled client may additionally have a POS runtime component.

Application/deployment metadata is separate from API namespace versioning.
Do not expose secrets, private credentials, or unsafe infrastructure topology.

## 23. New Digvation business domains

A new business domain must:

1. define its authoritative business responsibility;
2. define data ownership;
3. define what CORE controls for it;
4. define which Backoffice and/or Operational modules it contributes;
5. define explicit integration contracts with other domains;
6. avoid direct cross-domain DB/repository access;
7. define entitlement/runtime composition behavior;
8. avoid creating a new UI shell unless a real application boundary requires it;
9. create/update one readable scope contract under `scopes/` using `scopes/README.md`;
10. follow the normal Digvation engineering, release, security, and deployment standards.

See `scopes/README.md` and `NEW_PRODUCT_STANDARD.md`.

## 24. Canonical invariants

Preserve these ecosystem invariants:

- CORE = control plane.
- Business domains = operational authority.
- Backoffice = shared management experience.
- Operational = shared execution experience.
- Product/capability entitlement != business profile.
- Product/capability entitlement != deployment isolation.
- Product/capability entitlement != infrastructure ownership.
- Product/capability entitlement != branding.
- SaaS plan/package name != runtime authorization; CORE resolves it to explicit effective entitlements.
- Dedicated != white-label.
- White-label != client source fork.
- Shared UI shell != shared business authority.
- One business concept has one authoritative owner.
- No direct cross-domain database/repository shortcut.
- Browser/UI visibility is not authorization.
- Existing accepted functionality is moved/re-homed before rewrite.

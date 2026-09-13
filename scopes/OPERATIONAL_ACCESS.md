# Operational Access & Location Context Scope Contract

Kind: `SHARED_BUSINESS_CAPABILITY`
Status: `ACTIVE`
Entitlement Class: `PLATFORM_FOUNDATION`
Commercial Packaging: `BASE`

## Purpose

Provide one backend-authoritative rule for resolving **which organization/branch/location an authenticated account is allowed to operate in** across Digvation Operational experiences.

An account existing in the tenant does not automatically grant operational access to every branch/location.

Operational access is composed from identity, permission/role authority, and explicit organization/location scope.

## Owns / Authority

- operational location-access assignment for authenticated principals/accounts;
- allowed branch/location scope used by Operational;
- active operational location resolution;
- organization-wide owner access semantics;
- branch/location-scoped manager access semantics;
- enforcement rules for switching from one permitted location to another;
- reusable location-access context consumed by POS, Workshop, Inventory, and future Operational modules.

Conceptually:

```text
Account / Principal
        |
        +--> Operational Location Access
                 |
                 +--> Branch / Location A
                 +--> Branch / Location B
```

Do not model operational access as one permanent `branchId` field on the Account when the same account may legitimately operate in multiple locations.

## Role / Scope Semantics

### Owner

An organization owner has organization-wide operational authority for the tenant/business organization.

- Owner does not require a separate assignment for every branch/location merely to operate there.
- If the organization has one active operational location, that location is resolved automatically.
- If the organization has multiple active operational locations, Owner may select/switch among all active locations allowed by the organization/runtime context.
- Product entitlement, runtime capability, and explicit permission checks still apply. Owner status does not grant products the client does not own.

### Manager

Manager is **location-scoped**, not automatically organization-wide.

- A Manager must be assigned to each branch/location they are allowed to manage/operate.
- A Manager assigned to Branch A and Branch B may use those locations.
- The same Manager must not see or enter Branch C until an authorized assignment is created.
- Manager title/role by itself must never imply access to every branch.

### Other Operational Accounts

Cashiers, mechanics, warehouse operators, and other operational accounts are assignment-based.

- They may operate only in explicitly permitted branch/location contexts.
- Cross-location access requires an explicit authorized assignment first.
- Domain-specific capabilities still require the relevant domain permission/assignment in addition to location access.

## Single-Branch and Multi-Branch Support

Both are first-class supported business shapes.

Do not create separate architecture for a single-branch client.

For the currently authenticated account after entitlement/runtime/permission filtering:

```text
0 permitted operational locations
    -> deny operational entry or show a clear no-location-access state

1 permitted operational location
    -> resolve automatically
    -> do not force a branch/location selector

2+ permitted operational locations
    -> require/select an active operational location
    -> allow switching only among permitted locations
```

Examples:

```text
Single-branch retail
Organization
└── Branch A

Owner
└── Branch A automatically

Cashier
└── Branch A only when assigned
```

```text
Multi-branch workshop
Organization
├── Branch A
├── Branch B
└── Branch C

Owner
└── A + B + C

Manager 1
└── A + B

Manager 2
└── C

Mechanic 1
└── B
```

The UI may omit the location selector when there is exactly one permitted location, but the backend must still resolve and enforce that location context.

## Consumes / Depends On

- `IDENTITY_ACCESS` authenticated Account/Principal identity;
- `IDENTITY_ACCESS` authorization/RBAC authority;
- `ORGANIZATION_LOCATION` for canonical branch/location identity and lifecycle/status;
- tenant/client runtime context;
- product entitlement and Installation runtime capability;
- Workforce reference when an account is linked to an employee;
- domain-specific assignment/permission where additional specialization is required.

## Does Not Own

- password/login/authentication mechanics;
- employee profile/lifecycle;
- canonical Branch/Location identity;
- POS CashierAssignment behavior;
- Workshop MechanicProfile/MechanicAssignment;
- Inventory operator workflow;
- product entitlement;
- Backoffice global authorization policy;
- business-domain transaction authority.

## Account vs Employee

Account/Principal identity and Employee identity are related but not identical concepts.

A business employee may be linked to an authenticated account, while authorization and operational location access remain explicit authorities.

Do not duplicate employee records per branch merely to grant access.

Use assignment/reference relationships instead.

## Backoffice Contribution

Backoffice may expose authorized administration for operational access, conceptually including:

- which accounts can access which branch/location;
- add/remove location assignment;
- owner organization-wide scope visibility;
- manager branch scope;
- operational-access status.

Within Backoffice Configuration this contribution is named **Location Access**
under Access Control. It is an administration composition only: assignment
records and enforcement remain this scope's backend authority, not Role data,
Selling Location preferences, or browser state.

Exact navigation and UI must follow the current requested scope, `uiuxpromax`, and the Digvation Design System.

## Operational Contribution

Operational consumes the resolved location context.

The shared shell should:

- automatically enter the sole permitted location when exactly one exists;
- show a location chooser/switcher when multiple permitted locations exist;
- never list inaccessible locations;
- preserve the selected active location safely during the valid operational session/context;
- require backend authorization on every location-sensitive operation rather than trusting the UI selection alone.

Domain modules such as POS, Workshop, and Inventory then apply their own capability/role checks inside the resolved location.

## Dashboard Projection

Dashboard/Reporting may use the resolved/selected location as a filter or context dimension.

A user must not obtain metrics from a location they are not authorized to view merely by manipulating a filter/query parameter.

Owner may view organization-wide aggregation when the relevant dashboard/report permission allows it.

Manager aggregation is limited to assigned locations unless another explicit authority grants more.

## Report Projection

Reports use permitted organization/location scope as an authorization boundary and filter dimension.

Export endpoints must enforce the same location scope as interactive views.

## Audit & Activity Integration

Material access administration should be auditable, for example:

```text
OPERATIONAL_LOCATION_ACCESS_GRANTED
OPERATIONAL_LOCATION_ACCESS_REVOKED
MANAGER_LOCATION_ASSIGNMENT_CHANGED
```

Location switching itself does not need to become noisy global business audit by default, though security/session telemetry may record it where appropriate.

## Current Scope

Operational Access & Location Context is an active Digvation foundation.

Current durable rules are:

- account existence alone does not grant every branch/location;
- Owner is organization-wide;
- Manager is assignment-based per branch/location;
- other operational accounts are assignment-based;
- single-branch and multi-branch clients use the same model;
- one permitted location auto-resolves without unnecessary selector UI;
- multiple permitted locations require a permitted active-location selection;
- backend enforcement is authoritative.
- a browser-selected location and any stored UI preference are convenience
  state only; they cannot broaden the resolved permitted location set.

Existing repository behavior must be discovered with Codebase Memory MCP and verified against source before implementation/remediation.

Do not perform unrelated broad access-control rewrites unless the current user task explicitly requests them.

## Deferred / Future

- temporary/time-bounded branch access;
- approval workflow for cross-branch assignment;
- region/territory-scoped managers;
- device-bound location restrictions;
- geofencing;
- workforce scheduling/shift-based access;
- external identity federation-specific policies;
- any advanced rule not explicitly activated.

## Integration Rules

- location access is backend-authoritative;
- never trust a client-supplied `branchId`/`locationId` without authorization;
- one tenant cannot resolve another tenant's location;
- Manager must remain branch/location-scoped unless a future explicit authority changes that rule;
- Owner organization-wide access does not bypass product entitlement, runtime capability, or sensitive action permissions;
- domain-specific roles extend operational access; they do not replace the shared location boundary;
- single-branch UX should be simple, but single-branch authorization must remain explicit and safe.

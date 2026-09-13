# Account, Identity & RBAC Scope Contract

Kind: `SHARED_BUSINESS_FOUNDATION`
Status: `ACTIVE`
Entitlement Class: `PLATFORM_FOUNDATION`
Commercial Packaging: `BASE`

## Purpose

Provide one reusable authority for authenticated business application accounts/principals and permission assignment across Digvation Backoffice and Operational experiences.

This scope answers **who is signed in and what actions they may perform**.

It does not answer **which branch/location they may operate in**; that is owned by `OPERATIONAL_ACCESS`.

## Owns / Authority

- business application Account / Principal identity;
- account lifecycle/status such as active, suspended, disabled, invited where supported;
- authentication-facing principal reference used by Digvation business applications;
- role definitions and role assignment where part of the accepted business-app authorization model;
- permission/capability grants;
- owner/manager/staff authorization semantics at the role/permission layer;
- safe account-to-employee linkage/reference where applicable;
- tenant/client authorization boundary for business application access.

## Core Separation

Keep these authorities distinct:

```text
Employee / Workforce
= who the person is in the business

Account / Principal
= who can authenticate into the system

Role / Permission
= what actions the account may perform

Operational Access
= in which branch/location the account may operate
```

Do not duplicate Employee records just to create another login or branch assignment.

Do not encode all operational location access directly into global roles.

## Role Semantics

### Owner

Owner represents organization-wide business authority at the role/permission layer.

Operational location scope is resolved by `OPERATIONAL_ACCESS`, where Owner is organization-wide across active locations subject to entitlement/runtime and sensitive action permission rules.

### Manager

Manager represents elevated management capability but is not automatically organization-wide for Operational location scope.

A Manager's permitted branch/location set is defined by `OPERATIONAL_ACCESS` assignments.

### Staff / Domain Roles

Examples may include cashier, mechanic, warehouse operator, supervisor, or other domain-specific capabilities.

Prefer composable permissions/domain assignments rather than one ever-growing global role enum containing every future business function.

## Consumes / Depends On

- tenant/client runtime context;
- Workforce identity when an account is linked to an employee;
- `ORGANIZATION_LOCATION` for location references used by access administration;
- `OPERATIONAL_ACCESS` for branch/location operational scope;
- Audit & Activity for material access/security changes.

## Does Not Own

- employee HR/workforce profile;
- canonical Branch/Location identity;
- branch/location operational access assignment;
- POS cashier session/transaction behavior;
- Workshop mechanic execution;
- Inventory operator workflow;
- product entitlement;
- CORE internal operator Access Management unless explicitly integrated through a durable contract;
- secrets beyond what the accepted authentication implementation legitimately requires.

## Backoffice Contribution

May contribute shared administration surfaces such as:

- Accounts / Users;
- Roles;
- Permissions;
- account status/lifecycle;
- employee-account linkage where supported;
- operational branch/location access administration through the `OPERATIONAL_ACCESS` authority.

The Configuration information architecture keeps this separate from ordinary
Business preferences:

```text
Access Control
â”œâ”€â”€ Users
â”œâ”€â”€ Roles
â””â”€â”€ Location Access
```

Location Access composes `OPERATIONAL_ACCESS`; it does not move location scope
into Role data or Business Settings. Do not imply an invitation workflow merely
because an account lifecycle can include a pending state unless an accepted
identity contract introduces invitations.

Do not visually flatten identity, role, and location scope into one giant form. Use readable sections and current Digvation UI patterns.

Any UI/UX work must use `uiuxpromax` and the existing Digvation Design System.

## Operational Contribution

Operational authenticates the principal, resolves permissions, then resolves permitted operational location context through `OPERATIONAL_ACCESS`.

Operational modules must still enforce domain-specific permissions server-side.

## Dashboard Projection

Normally limited to administration/security indicators when explicitly useful and permitted, such as active account counts or disabled accounts.

It does not own business performance KPIs.

## Report Projection

May contribute authorized account/role/permission reports where required.

Location-scoped operational access reporting should use `OPERATIONAL_ACCESS` as the authority.

## Audit & Activity Integration

Material account and authorization changes should be auditable, for example:

```text
ACCOUNT_CREATED
ACCOUNT_DISABLED
ROLE_ASSIGNED
ROLE_REVOKED
PERMISSION_CHANGED
```

Never place passwords, tokens, secrets, or credential material in Audit/Activity payloads.

## Current Scope

Account, Identity & RBAC is an active Digvation foundation because Backoffice and Operational require consistent authenticated principal and permission semantics.

Current durable rules:

- Account and Employee are separate concepts that may be linked;
- roles/permissions answer what an account may do;
- `OPERATIONAL_ACCESS` answers where the account may operate;
- Owner is organization-wide at the authority level but still subject to entitlement/runtime and sensitive permissions;
- Manager operational location access remains assignment-based;
- backend authorization is authoritative;
- tenant isolation is mandatory.

Existing accepted account/auth/role implementations must be discovered with Codebase Memory MCP and verified against source before changing them.

Do not perform a broad authentication rewrite unless explicitly requested.

## Deferred / Future

- external SSO/federation;
- passkeys/MFA policy expansion;
- temporary delegated access;
- cross-client consultant accounts;
- advanced policy engine/ABAC;
- region/territory roles;
- any authentication redesign not explicitly activated.

## Integration Rules

- Account != Employee;
- Permission != Location Access;
- Role != Product Entitlement;
- Business preference != entitlement or permission;
- Owner authority does not grant unentitled products;
- Manager role does not imply every branch/location;
- all sensitive authorization decisions are enforced server-side;
- tenant/client isolation applies to account, role, permission, and access administration.

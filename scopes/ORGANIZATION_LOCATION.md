# Organization & Location Scope Contract

Kind: `SHARED_BUSINESS_FOUNDATION`
Status: `ACTIVE`
Entitlement Class: `PLATFORM_FOUNDATION`
Commercial Packaging: `BASE`

## Purpose

Provide one reusable organization/location identity model used across Digvation business domains and shared capabilities without letting each product invent incompatible Branch/Outlet/Location identities.

## Owns / Authority

- organization/business-unit identity where applicable;
- the tenant Business Profile used by Backoffice, Operational, receipts, and
  reporting identity;
- branch/outlet/location identity;
- parent/child organizational relationship when explicitly supported;
- shared location profile such as name, code, address, timezone, status, and business-facing metadata that is not domain-specific;
- tenant-scoped organization/location references;
- reusable organizational assignment context;
- support for organizations with one or many active branches/locations without changing the core model.

## Consumes / Depends On

- tenant/client runtime context;
- authorization context;
- `OPERATIONAL_ACCESS` for account-level permitted location scope (consumer relationship, not ownership);
- CORE installation/runtime context only where deployment context is actually required.

## Does Not Own

- POS register/cash drawer/session;
- Inventory warehouse/bin/stock location behavior unless explicitly promoted later;
- Workshop bay/workstation/service workflow;
- employee identity;
- account-to-location operational access assignments;
- product entitlement;
- tax rules;
- scheduling/resource availability.

Domain-specific operational structures reference the shared location rather than redefining it.

Examples:

```text
Branch JKT-01
  -> POS Register REG-01
  -> Workshop Bay BAY-03
  -> Inventory Warehouse WH-JKT-01
```


## Single-Branch and Multi-Branch Shape

An organization may validly have exactly one branch/location or many.

The same canonical model is used for both. Do not create a separate `singleBranchMode` architecture that forks domain behavior.

Operational UX may simplify itself when only one permitted location exists, while backend authorization still resolves and enforces that canonical location.

Account-level access semantics are owned by `OPERATIONAL_ACCESS.md`, not by the Branch/Location entity itself.

## Backoffice Contribution

Potential shared Backoffice capabilities include:

- organization/branch/location management;
- location profile/status;
- domain capability/configuration references attached to a location where explicitly owned elsewhere;
- assignment targets used by Workforce and business domains.

Exact navigation must follow current application scope and `uiuxpromax`.

## Business Configuration Boundary

Business Configuration is the persisted tenant authority for how an entitled
business operates. It is not CORE entitlement metadata and it is not mutable
deployment/runtime configuration.

Business Profile is the single tenant business identity. Deployment branding may
seed an initial value or identify a white-label installation, but it must not
override the editable Business Profile after initialization. Operational and
receipt rendering consume this same authority rather than maintaining a separate
business profile.

A versioned, typed Business Preferences aggregate may hold cohesive preferences
with no independent domain lifecycle, including business localization/timezone,
controlled receipt presentation, and safe dashboard/report visibility choices.
It is not an unrestricted settings JSON blob: its accepted schema is explicit,
unknown fields are rejected, and it must not contain entitlement, permission,
location, tax-rule, or financial authority.

Backoffice presents this under one Business workspace with internal sections,
not separate top-level settings navigation. Initial sections are Profile,
Locations, Localization, Penomoran, Receipt, and Dashboard & Reports. Appearance
is deferred until a tenant-safe finite Design System capability exists; do not
create an empty placeholder surface.

### Localization and time

Business Preferences own the tenant default locale, IANA timezone, date format,
and time format. Deployment configuration may supply bootstrap defaults only.
All persisted instants remain UTC; business-day, reporting-period, receipt-time,
and effective-date interpretation uses the tenant timezone. A future per-user UI
locale override is presentation-only and cannot change those business semantics.

### Penomoran

Official numbering is backend-authoritative and transactional. Browser clients
never allocate or construct official sequential identifiers. Existing tenant
sequence allocation is reused; a future typed numbering-rule extension is
configuration for that authority, not a second generator.

Initial configurable namespaces are Sale/Transaction, Employee, and Invoice
only when invoice capability is available. Do not expose every technical
namespace. Prefix and padding changes apply only to future documents; issued
identifiers remain immutable. Optional domain codes remain optional, and reset
strategy is deferred pending a separate history/legal decision.

### Receipt

Controlled receipt preferences may cover paper width, approved visibility flags,
footer text, and a finite layout preset. Free-form/WYSIWYG templates, arbitrary
HTML, and a second styling system are out of scope. Historical
receipt/profile snapshotting is a future reproducibility consideration unless a
current document contract explicitly requires it.

## Operational Contribution

Operational uses resolved organization/location context for the active user's/device's permitted work.

It should not require each domain to invent a different top-level branch identity.

## Dashboard Projection

May contribute location context/selectors and basic location counts/status where useful.

Business performance metrics by location remain owned by the contributing domain.

## Report Projection

May provide reusable organization/location dimensions/filters and basic location reports.

It does not own domain performance calculations merely because they are grouped by branch.

## Current Scope

Organization/Location is an active Digvation foundation.

Current implementation authority must be discovered from repository reality because Branch/Location concepts may already exist inside historical POS/Backoffice structures.

When touched, existing accepted location data/behavior should be re-homed or reused rather than duplicated.

## Deferred / Future

- complex enterprise organization graphs;
- territories/regions beyond current business need;
- geofencing;
- workforce scheduling;
- domain-specific warehouse/bay/register internals.

## Integration Rules

- one canonical organization/location identity for cross-domain references;
- domain-specific operational resources remain in their owning domain;
- no hard-coded client/business-type hierarchy;
- tenant isolation applies to all organization/location lookup and mutation;
- location identity may influence Tax/Fiscal jurisdiction and Dashboard/Report filtering through explicit contracts;
- location identity does not grant access by itself; Operational account access is resolved by `OPERATIONAL_ACCESS`;
- single-branch clients remain fully supported without unnecessary location-selector UX.
- Business preferences can hide Dashboard/Report content but cannot grant an
  entitlement, permission, or location scope.

# Scheduling Scope Contract

Kind: `BUSINESS_DOMAIN`  
Status: `NEXT`  
Entitlement Class: `PRODUCT`  
Commercial Packaging: `PRODUCT`

## Purpose

Scheduling is the Digvation business domain for time-based service appointment planning and execution.

Its first/current feature is **Service Appointment**: scheduling one or more Catalog entries classified as `SERVICE` at an authorized business location.

The initial business case is salon operations, but Scheduling vocabulary and authority must remain reusable and business-generic.

Scheduling is **not** a generic reservation engine.

The following are explicitly outside current Scheduling scope unless separately designed later under their correct ownership:

- restaurant table reservation;
- hotel booking;
- room/resource booking;
- generalized reservation semantics.

## Current Product Scope

### Product

`Scheduling`

### Initial Feature

`Service Appointment`

### Current Booking Channels

- `BACKOFFICE`
- `OPERATIONAL`

### Deferred Booking Channel

- `SELF_SERVICE`

Self-service compatibility may influence stable domain boundaries, but customer self-booking is **not current implementation scope**.

## Owns / Authority

Scheduling owns the authoritative Service Appointment aggregate and its lifecycle.

Scheduling owns:

- `Appointment` internal identity;
- tenant-scoped `appointmentNumber`;
- appointment location reference;
- scheduled start and scheduled end;
- appointment lifecycle/status;
- appointment source;
- appointment notes;
- appointment-owned timestamps/audit references;
- zero or one optional canonical customer reference;
- guest/contact snapshot when no canonical customer is linked;
- one or more appointment service lines;
- historical service-name snapshots where required;
- historical duration snapshots where required;
- rescheduling;
- cancellation;
- no-show state;
- appointment calendar/load projection;
- optional handoff/reference to another domain such as POS.

Scheduling does **not** require employee selection when an appointment is created.

## Appointment

Conceptually, an Appointment contains:

- internal `id`;
- `appointmentNumber`;
- tenant reference;
- location reference;
- `scheduledStart`;
- `scheduledEnd`;
- `status`;
- `source`;
- optional canonical customer reference;
- guest/contact snapshot;
- notes;
- timestamps/audit references.

The official appointment number is backend-authoritative.

Browser clients must not allocate the canonical appointment business identifier.

One Appointment represents one customer/service visit.

Multi-customer/group booking is outside current scope.

## Appointment Service

An Appointment may contain one or more service lines.

Each appointment service line conceptually contains:

- Catalog service reference;
- service-name snapshot;
- duration snapshot;
- deterministic line ordering.

Only Catalog entries classified as `SERVICE` may be selected.

Catalog remains the service-master authority.

Scheduling preserves snapshots needed to prevent later Catalog changes from silently rewriting historical appointment meaning.

### Current Multi-Service Semantics

Current scope supports multiple service lines under one appointment.

Service lines are:

- ordered;
- sequential;
- not parallel/concurrent.

Current timing rule:

```text
total appointment duration
=
sum of service-line duration snapshots

scheduledEnd
=
scheduledStart + total appointment duration
```

Parallel services, shared resources, chairs, rooms, beds, equipment, and advanced capacity scheduling are deferred.

## Lifecycle

Use the minimal lifecycle:

- `SCHEDULED`
- `CONFIRMED`
- `CHECKED_IN`
- `IN_SERVICE`
- `COMPLETED`
- `CANCELLED`
- `NO_SHOW`

Canonical progression:

```text
SCHEDULED
  -> CONFIRMED
  -> CHECKED_IN
  -> IN_SERVICE
  -> COMPLETED
```

Terminal alternatives:

```text
CANCELLED
NO_SHOW
```

`COMPLETED`, `CANCELLED`, and `NO_SHOW` are terminal in current scope.

Rescheduling changes appointment scheduling data and is **not** a lifecycle status.

Any future reopen/recovery semantics require explicit scope.

## Appointment Source

Current sources:

- `BACKOFFICE`
- `OPERATIONAL`

Future-compatible source:

- `SELF_SERVICE`

`SELF_SERVICE` is deferred and must not be treated as current implementation authorization.

## Current Availability Model

Current Appointment booking is **staff-assisted**.

The actor creating an appointment selects:

- authorized location;
- service(s);
- date/time;
- customer or guest/contact information.

### Employee Selection

Employee selection is **not required** to create an Appointment.

Current Scheduling scope does not require the actor to:

- choose a worker;
- choose a stylist;
- assign a service provider;
- inspect worker-by-worker availability.

There is no salon-specific canonical `Stylist` entity in Scheduling.

### How Time Availability Is Determined

For current Backoffice/Operational-assisted booking, availability is operationally determined by authorized staff using:

- the appointment calendar;
- existing appointment load;
- the real operational condition of the business/location.

Example:

```text
10:00  2 appointments
11:00  5 appointments
12:00  1 appointment
13:00  empty
```

Cashier/manager may determine that 11:00 is operationally full and offer 12:00 or 13:00 instead.

Current Scheduling does **not** implement an automatic worker-capacity engine.

### Runtime Authority

The Runtime remains authoritative for:

- tenant isolation;
- appointment persistence;
- lifecycle rules;
- permissions;
- location authorization;
- valid Catalog `SERVICE` references;
- accepted appointment data/state transitions.

However, current scope does **not** claim automatic employee-based availability calculation.

The appointment calendar/load is a decision-support surface for authorized staff, not a claim that Runtime understands complete Workforce capacity.

## Explicitly Not Current Availability Scope

Do not implement the following as part of current Service Appointment scope:

- employee work schedules;
- employee shifts;
- employee leave;
- provider bookable availability;
- provider/service eligibility matrix;
- automatic employee assignment;
- automatic employee-based slot calculation;
- worker capacity optimization;
- overbooking optimization;
- resource/chair/room/equipment availability;
- generic capacity engine.

These may be introduced later only through explicit scope.

## Future Automated Availability

Automated availability becomes materially necessary when unattended booking channels such as `SELF_SERVICE` are activated.

A future automated availability model may consider, after explicit design:

```text
location capacity
AND/OR
provider availability
AND/OR
provider eligibility
AND
existing appointment load
```

The current Appointment aggregate must not prevent such a future extension, but that engine is not authorized now.

## Employee / Workforce Boundary

Workforce remains the canonical Employee authority.

Scheduling does not own:

- employee identity;
- employee lifecycle;
- employee profile;
- payroll;
- attendance;
- leave;
- Workforce-wide shift planning;
- general workforce productivity authority.

Current Appointment creation has no mandatory employee assignment.

If employee assignment is later introduced for execution or operational tracking, it must:

- reference canonical Workforce employee identity;
- remain optional unless a future explicit scope says otherwise;
- not become a salon-specific `Stylist` model;
- remain separate from Appointment creation unless explicitly activated.

## Consumes / Depends On

### Catalog

Scheduling references shared Catalog authority.

Rules:

- Appointment service lines may reference only Catalog entries classified as `SERVICE`;
- Catalog owns service master identity/classification;
- Scheduling owns appointment snapshots required for historical truth;
- Scheduling must not duplicate the Catalog service master.

### Organization / Location

Every Appointment belongs to exactly one authorized canonical business location.

Scheduling consumes Organization/Location authority for:

- location identity;
- tenant-scoped location context.

Scheduling does not create its own Branch/Outlet/Location master.

### Workforce

Workforce remains canonical Employee authority.

Current Appointment creation does not require employee selection.

Any future employee reference must use canonical Workforce identity.

### Customer

Scheduling may optionally reference canonical Customer identity when available.

Current rules:

- zero or one canonical customer reference per Appointment;
- otherwise guest/contact snapshot;
- guest snapshot is appointment-local data, not a second Customer master.

Membership is not required to create, manage, or execute an Appointment.

### Identity / RBAC / Location Access

Scheduling consumes authenticated principal and permission authority from Identity/RBAC.

Permission alone does not authorize access to appointments from arbitrary locations.

Appointment access must remain composed with authorized location scope.

### POS

POS integration is optional.

Scheduling may hand off or store an explicit reference to a POS Sale when POS is available and the integration is activated.

Scheduling never owns:

- Sale;
- Sale Line;
- checkout;
- payment;
- receipt;
- refund/void;
- POS monetary authority.

Appointment completion does not imply payment completion.

## Does Not Own

Scheduling does not own:

- Catalog service master;
- product/item/service classification authority;
- canonical Employee/Workforce identity;
- Workforce attendance;
- Workforce payroll;
- Workforce leave;
- Workforce-wide shift scheduling;
- canonical Customer identity;
- Membership/Loyalty;
- POS Sale;
- POS payment;
- Organization/Location master data;
- Account/Principal identity;
- roles;
- permission assignment;
- account-to-location access assignment;
- CORE entitlement authority;
- restaurant table reservation;
- hotel booking;
- room/resource booking;
- generalized reservation semantics.

## Backoffice Contribution

Scheduling contributes Appointment management and supervision to the shared Backoffice experience.

Current Backoffice contribution:

- appointment calendar;
- appointment list;
- appointment detail;
- create appointment;
- edit/reschedule appointment;
- cancel appointment;
- appointment filters;
- authorized location context;
- service selection;
- customer link or guest/contact capture;
- appointment lifecycle/source visibility.

The Backoffice calendar should make appointment load readable enough for authorized staff to make operational booking decisions.

Backoffice is an experience surface, not Scheduling authority.

Runtime remains authoritative for writes, permissions, tenant isolation, location authorization, and lifecycle rules.

## Operational Contribution

Scheduling contributes day-to-day Appointment execution to the shared Operational experience.

Current Operational contribution:

- today appointments;
- upcoming appointments;
- quick appointment creation;
- check-in;
- start service;
- complete appointment;
- cancellation/no-show actions when authorized;
- customer/service context required for execution;
- optional handoff to POS checkout.

Operational must not become authoritative through client-side state.

## Dashboard Projection

Scheduling may contribute Scheduling-owned projections such as:

- today's appointment count;
- upcoming appointment count;
- appointment volume by status;
- appointment volume over time;
- cancellation/no-show counts.

Do not infer worker utilization or Workforce productivity from Appointment data unless a future explicit cross-domain projection is designed.

## Report Projection

Scheduling may contribute reports such as:

- appointment list/history;
- appointment status report;
- appointment volume by date;
- appointment volume by location;
- cancellation/no-show report;
- service appointment volume based on Scheduling-owned snapshots.

Cross-domain reports require explicit projection contracts.

No ad-hoc UI joins or direct cross-domain database access.

## Permission Vocabulary

Scheduling defines durable action permission concepts around:

- appointment read;
- appointment create;
- appointment update/reschedule;
- appointment cancel;
- appointment operational status transitions.

Exact technical permission identifiers follow repository conventions at implementation time.

Effective appointment access is conceptually:

```text
Scheduling product entitlement
INTERSECT runtime capability
INTERSECT appointment permission
INTERSECT authorized location scope
```

Role names such as `Owner`, `Manager`, or `Cashier` are not Scheduling authority.

Cashier/manager access is produced by effective permission/application/location composition, not literal role-name branching.

## Current Scope

Current Scheduling scope is **Service Appointment** only.

Authorized current behavior:

- one Appointment at one authorized business location;
- zero or one linked canonical customer;
- guest/contact appointment snapshot;
- one or more ordered sequential service lines;
- Catalog references restricted to `SERVICE`;
- service-name/duration snapshots where historical truth requires them;
- appointment sources `BACKOFFICE` and `OPERATIONAL`;
- lifecycle:
  - `SCHEDULED`;
  - `CONFIRMED`;
  - `CHECKED_IN`;
  - `IN_SERVICE`;
  - `COMPLETED`;
  - `CANCELLED`;
  - `NO_SHOW`;
- create;
- read/list/detail;
- update/reschedule;
- cancel;
- operational lifecycle transitions;
- Backoffice calendar/list/detail/management;
- Operational today/upcoming/quick-create/execution;
- appointment load visibility for assisted booking decisions;
- optional POS checkout handoff/reference.

Current scope does **not** require employee selection or automatic employee-capacity calculation.

## Deferred / Future

Deferred unless explicitly activated:

- customer self-booking;
- `SELF_SERVICE`;
- automated availability/slot engine;
- employee/provider availability;
- provider/service eligibility;
- automatic employee assignment;
- optional preferred employee selection;
- location capacity configuration;
- automatic/manual confirmation policy;
- advance booking windows;
- cancellation windows;
- service self-bookable configuration;
- reminders/notifications;
- waitlist;
- recurrence;
- deposits/prepayment;
- appointment-specific promotion or membership rules;
- advanced employee capacity/skill matching;
- Workforce shift/leave scheduling integration;
- parallel/concurrent service lines;
- resource/chair/room/bed/equipment booking;
- restaurant table reservation;
- hotel booking;
- generalized reservation engine;
- arbitrary appointment reopening;
- optimization/overbooking policies.

Deferred items describe future compatibility only and are not implementation authorization.

## Integration Rules

- Scheduling is a separately entitled `PRODUCT`.
- Source-code presence or menu presence does not grant Scheduling.
- Service Appointment is the first/current Scheduling feature.
- Scheduling must remain business-generic and must not introduce salon-specific canonical entities.
- Appointment service references must resolve to Catalog entries classified as `SERVICE`.
- Catalog remains service-master authority.
- Scheduling preserves appointment snapshots required for historical truth.
- One Appointment may contain multiple ordered sequential service lines.
- Appointment belongs to exactly one authorized business location.
- Appointment creation does not require employee selection.
- Current time selection is staff-assisted using appointment calendar/load and operational knowledge.
- Current scope does not implement employee availability or automatic slot calculation.
- Customer linkage is optional.
- Guest/contact snapshot is allowed for Appointment use.
- Membership must not be required.
- Runtime remains authoritative for tenant, permission, location, lifecycle, and persistence rules.
- Rescheduling changes scheduling data; it is not another lifecycle status.
- POS integration is optional and explicit.
- Scheduling may reference/handoff to Sale but never owns Sale/payment.
- Appointment completion and POS payment completion are separate business facts.
- Permission checks compose with authorized location scope.
- Do not use literal role names as Scheduling authorization.
- No direct cross-domain database/repository access.
- `SELF_SERVICE` remains deferred.
- Automated capacity/provider scheduling must be separately designed before unattended booking is activated.
- Dashboard/Report projections remain domain-owned and composable.

## Implementation Gate

This document locks durable scope only.

It does **not** authorize implementation by itself.

Future implementation must follow the normal lifecycle:

```text
scope approval
-> implementation work unit
-> targeted validation
-> manual review
-> approval
-> integration
```

Until implementation is explicitly activated:

- no Runtime changes;
- no Web changes;
- no CORE changes;
- no migrations;
- no API changes;
- no Dashboard/Report implementation;
- no Self-Service implementation.

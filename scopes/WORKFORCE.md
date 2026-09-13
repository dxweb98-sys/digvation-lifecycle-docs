# Workforce / Employee Scope Contract

Kind: `SHARED_BUSINESS_FOUNDATION`
Status: `ACTIVE`
Entitlement Class: `PLATFORM_FOUNDATION`
Commercial Packaging: `BASE`

## Purpose

Workforce provides reusable employee identity and organizational assignment needed by multiple Digvation business domains.

## Owns / Authority

- employee identity/profile required by business applications;
- employee lifecycle/status;
- workforce organizational/branch affiliation or assignment where this foundation is the accepted owner;
- reusable employment/workforce relationships;
- shared workforce attributes that are not domain-specific behavior.

## Consumes / Depends On

- organization/branch/location authority where separated;
- `IDENTITY_ACCESS` authorization/RBAC contracts for access control;
- `OPERATIONAL_ACCESS` for account-to-location operational access;
- CORE/runtime tenant context where required.

## Does Not Own

- POS cashier transaction/session behavior;
- Workshop mechanic skills/job execution;
- Inventory warehouse workflow;
- product entitlement;
- authenticated Account/Principal identity;
- authoritative Operational branch/location access;
- business-domain-specific operational roles merely because they reference an employee.

Domain extensions reference the same employee identity, for example:

```text
Employee EMP-001
  -> POS CashierAssignment
  -> Workshop MechanicProfile / MechanicAssignment
  -> Inventory Operator capability
```

## Backoffice Contribution

- Employee Management;
- employee detail/profile;
- active/inactive lifecycle;
- organizational/branch workforce assignment;
- operational access administration only through the `OPERATIONAL_ACCESS` authority when the task includes account/location access;
- shared workforce configuration explicitly owned here.

## Operational Contribution

Normally none as a standalone workflow.

Operational domains consume workforce identity and expose domain-specific actions such as cashier, mechanic, or warehouse operator experiences.

## Dashboard Projection

May contribute shared workforce indicators when useful and permitted, such as:

- active employee count;
- employee distribution by branch/location;
- other non-domain-specific workforce metrics.

Domain productivity metrics remain owned by the contributing domain.

## Report Projection

May register reusable workforce reports such as employee roster/status/assignment reports.

It must not absorb POS sales-by-cashier or Workshop mechanic productivity merely because those reports contain employee names.

## Current Scope

- Employee Management;
- employee identity/status;
- branch/location assignment according to current repository reality;
- integration references needed by POS.

Before implementation, verify the exact existing Employee Management feature and current authority using MCP and source.

## Deferred / Future

- Workshop MechanicProfile is Workshop-owned;
- Inventory operator behavior is Inventory-owned;
- payroll/HR functionality is not implied by Workforce unless explicitly defined later.

## Integration Rules

- one canonical employee identity across business domains;
- do not duplicate an employee per branch to express operational access;
- Employee/Workforce affiliation and Account operational location access are separate authorities;
- domain-specific profiles/assignments remain in their owning domain;
- do not build one global enum containing every future business role.

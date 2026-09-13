# Inventory Scope Contract

Kind: `BUSINESS_DOMAIN`
Status: `PLANNED`
Entitlement Class: `PRODUCT`
Commercial Packaging: `PRODUCT`

## Commercial Availability / Effective Entitlement

Inventory is an optional business product/domain. A client uses Inventory only when the effective entitlement set grants the Inventory product.

```text
INVENTORY = enabled | disabled
```

Owning POS, Workshop, or another product does not automatically grant Inventory. A commercial package may bundle Inventory with another product, but CORE/control-plane must still resolve the bundle to an explicit Inventory entitlement.

For shared SaaS, the Inventory runtime may physically exist while an unentitled tenant is denied access. For dedicated deployment, Inventory runtime may be omitted entirely when the client is not entitled.

## Purpose

Inventory is the canonical stock authority reusable by POS, Workshop, and future Digvation domains.

## Owns / Authority

Boundary envelope, subject to later detailed lock:

- inventory item/SKU projection where applicable;
- warehouse/location stock;
- stock balance;
- stock ledger/movement;
- reservation;
- transfer;
- receiving;
- adjustment;
- purchasing/costing only when explicitly assigned to Inventory.

## Consumes / Depends On

- catalog/item identity/classification from its accepted owner;
- organization/location context;
- Tax/Fiscal where purchasing/stock documents later require it;
- explicit business references from consuming domains.

## Does Not Own

- POS sale workflow;
- Workshop work-order workflow;
- customer/member authority;
- employee identity;
- product entitlement.

## Backoffice Contribution

Planned examples:

- Inventory overview;
- stock/warehouse;
- movements;
- transfer;
- receiving;
- adjustment;
- purchasing when activated.

## Operational Contribution

Planned examples:

- receiving;
- picking/issue;
- transfer execution;
- stock count.

## Dashboard Projection

Planned examples:

- stock health;
- low/out-of-stock indicators;
- stock value where costing is authoritative;
- movement/receiving indicators.

## Report Projection

Planned inventory reports are not implementation-authorized until scope is explicitly locked.

## Current Scope

No new Inventory implementation is authorized merely by this contract.

Existing stock/inventory-like code must be discovered and classified before future extraction or feature work.

## Deferred / Future

Detailed Inventory feature scope will be written when the user activates Inventory work.

## Integration Rules

POS and Workshop consume Inventory through explicit contracts/ports/APIs/events, never direct repositories or cross-domain database access.

# Catalog Scope Contract

Kind: `SHARED_BUSINESS_FOUNDATION`
Status: `ACTIVE`
Entitlement Class: `PLATFORM_FOUNDATION`
Commercial Packaging: `BASE`

## Purpose

Provide one reusable business catalog identity/classification foundation that can be referenced by POS, Promotion/Commercial Rules, Tax/Fiscal, future Inventory, Workshop, and other Digvation domains without making stock, selling, service execution, or tax rules the same domain.

Catalog describes **what a business offers or references**. It does not automatically own inventory quantity, a sale, a work order, or fiscal calculation. Catalog presence also does not grant optional consumers such as Inventory, Promotions, Loyalty Points, or Workshop; those require their own effective entitlements when applicable.

## Owns / Authority

Subject to current repository reality, Catalog may own reusable concepts such as:

- catalog entry identity;
- name/code/SKU/barcode-style business identifiers where the canonical owner is Catalog;
- category/classification hierarchy;
- active/inactive/availability-for-use status that is catalog-level rather than stock-level;
- reusable product/service/part classification metadata;
- domain capability tags/classifications that are genuinely reusable;
- tax/fiscal classification reference required by Tax/Fiscal evaluation;
- presentation metadata that belongs to the catalog entry rather than a transaction.

Do not force every future business offering into one giant global enum. Use extensible classification and domain-specific extensions where appropriate.

## Consumes / Depends On

- tenant/client context;
- Organization/Location only for catalog availability/configuration when explicitly required;
- Tax/Fiscal category/reference contract for classification mapping;
- authorization context.

## Does Not Own

- Inventory stock quantity, reservation, movement, warehouse, or costing;
- POS sale/transaction/cart/checkout;
- POS transaction price snapshot or discount result;
- Workshop work order/job/labor execution;
- Tax/Fiscal rules/rates/calculation;
- Membership benefits/points;
- promotion/campaign rules, eligibility, benefits, or lifecycle;
- procurement/purchasing lifecycle unless explicitly defined elsewhere.

Examples of domain relationships:

```text
Catalog Item / Service
  -> POS selling reference
  -> Inventory stock reference (when Inventory is active)
  -> Workshop part/service reference (when Workshop is active)
  -> Promotion targeting reference
  -> Tax/Fiscal classification reference
```

## Pricing Boundary

Catalog may hold reusable/base/list-price configuration only if current accepted architecture assigns that responsibility here.

The final transaction price, discounts, promotions, tax outcome, and monetary snapshots remain backend-authoritative in the owning transactional capability.

Do not silently make Catalog a universal pricing/discount engine.

## Promotion Relationship

Catalog exposes stable entries/categories/classifications that Promotion may target; Promotion owns campaign validity, eligibility, benefit, priority/stacking, and location scope.

Do not store a durable promotion engine directly inside Catalog.

Conceptually:

```text
Catalog entry/category/classification
        -> Promotion applicability
```

## Tax/Fiscal Relationship

Catalog exposes stable tax-relevant classifications; Tax/Fiscal owns rules and evaluation.

Conceptually:

```text
Catalog classification
        -> Tax/Fiscal rule evaluation
```

A Tax configuration screen may show only catalog classifications relevant to the client's entitled/enabled business domains.

Tax/Fiscal must not become the owner of Catalog merely because it configures tax mapping against catalog classifications.

## Backoffice Contribution

Catalog may contribute shared catalog-management surfaces, with domain-aware fields/sections composed from enabled capabilities.

Examples may include:

- Products/Items;
- Services;
- Categories/Classifications;
- tax classification mapping/reference;
- domain-specific extension sections when the owning domain contributes them.

The exact information hierarchy should remain readable and capability-aware, not one giant form containing every future domain field.

Any Catalog UI work must use `uiuxpromax` and the existing Digvation Design System.

## Operational Contribution

Operational domains consume catalog lookup/search/selection as needed.

Examples:

- POS searches/selects sellable catalog entries;
- Workshop later selects services/parts;
- Inventory later references catalog items for stock operations.

Catalog does not require a standalone Operational application.

## Dashboard Projection

Catalog normally contributes supporting counts/classifications rather than primary business-performance KPIs.

Examples, only when useful:

- active catalog entries;
- category coverage;
- configuration completeness.

Sales/service/stock performance stays with POS/Workshop/Inventory.

## Report Projection

May register catalog master-data reports such as catalog list/status/category mappings.

It must not duplicate transaction or inventory reports.

## Current Scope

Catalog is now a Digvation shared foundation and the durable owner of reusable catalog identity/classification semantics, subject to verification of existing accepted repository behavior before changes.

Existing POS catalog/product code is migration/reuse source and must not be rewritten merely because the durable ownership is now broader than historical POS naming.

Near-term Customer/Membership or Tax work may consume Catalog only where materially required by the requested feature.

## Deferred / Future

- advanced product variants/options;
- complex pricing engine;
- advanced promotion-specific catalog targeting helpers beyond the accepted Promotion contract;
- BOM/recipes;
- vendor/procurement catalog;
- arbitrary domain schemas;
- any capability not explicitly activated.

## Integration Rules

- one reusable catalog identity/classification authority where concepts are truly shared;
- domain extensions stay with the owning domain;
- Inventory owns stock, not Catalog;
- Tax/Fiscal owns tax rules, not Catalog;
- Promotion owns promotion/campaign rules, not Catalog;
- POS/Workshop own their transaction/workflow semantics;
- avoid client-name/business-type hard-coded catalog structures;
- preserve accepted existing catalog behavior when re-homing ownership.

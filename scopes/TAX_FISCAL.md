# Tax / Fiscal Rules Scope Contract

Kind: `SHARED_BUSINESS_CAPABILITY`
Status: `PARTIAL`
Entitlement Class: `CAPABILITY`
Commercial Packaging: `BUNDLED_OR_OPTIONAL`

## Verified Delivery State

The accepted `dev` subset is tenant-level Business tax configuration (enabled/rate/version), backend calculation and captured transaction facts, Backoffice configuration, and tax-report projections. The wider dynamic classification/jurisdiction envelope below is not a delivered fiscal engine.

Evidence (verified 2026-10-16, Asia/Jakarta): Runtime `1190ec6d9b21628a23af78e299beb576c1f75c27` [configuration/default](https://github.com/dxweb98-sys/digvation-business-runtime/blob/1190ec6d9b21628a23af78e299beb576c1f75c27/src/modules/business-configuration/business-configuration.repository.ts), [configuration service](https://github.com/dxweb98-sys/digvation-business-runtime/blob/1190ec6d9b21628a23af78e299beb576c1f75c27/src/modules/business-configuration/business-configuration.service.ts), and accepted [reporting change](https://github.com/dxweb98-sys/digvation-business-runtime/commit/ecf7712215d99fa9e8bf4120c53c05e58769f8c2); Web accepted [Business tax configuration change](https://github.com/dxweb98-sys/digvation-business-web/commit/d6e486268c702e23d45388c8339bed070dd9c938) remains in `dev` at `48341a9949f04f048d39e628ab33605b82dcea25`.

Release: the evidence SHAs above are included in Runtime/Web `v1.6.1` (`main`, released 2026-10-23; verified 2026-10-27). Deployment to client Installations: `NOT_VERIFIED`. A client's effective `TAX_FISCAL` grant is separate from the tenant Business tax enabled/rate settings and from this scope's maturity. No source snapshot establishes a live client's tax setup.

## Commercial Availability / Effective Entitlement

Tax/Fiscal is a capability entitlement. It may be bundled as part of an applicable product/plan or enabled explicitly for a client, depending on commercial and jurisdiction requirements. The runtime must consume the resolved `TAX_FISCAL` capability state; it must not infer activation from business type or Catalog data.

## Purpose

Provide one dynamic tax/fiscal rule authority that can be consumed by multiple Digvation business domains such as POS and Workshop.

Tax is not POS-local logic and must not be duplicated per business domain.

## Owns / Authority

The wider Tax/Fiscal envelope may own, only as explicitly implemented:

- tax rules and rates;
- tax categories/classifications;
- effective dates/versioned rules;
- inclusive/exclusive behavior where supported;
- client/location/jurisdiction applicability;
- business-domain applicability;
- catalog tax-category mapping/configuration where Tax is the accepted owner of the mapping;
- rule evaluation contract;
- tax calculation result/snapshot semantics required for historical transactions.

Exact legal/fiscal capabilities must be introduced only by explicit scope and applicable jurisdiction requirements.

## Dynamic Rule Context

Tax evaluation must use authoritative context rather than hard-coded product/client names. The wider future rule envelope is context-aware; the current subset uses tenant Business tax configuration.

A rule may consider authoritative inputs such as:

```text
Client / Tenant
Location / Jurisdiction
Business Domain
Catalog Item / Service Classification
Tax Category
Transaction Context
Effective Date / Time
Customer Tax Classification (only if later defined)
```

Examples:

- POS sends sale-line/catalog context to Tax/Fiscal;
- Workshop sends service/labor/part line context to the same Tax/Fiscal authority.

Each consuming domain remains owner of its transaction; Tax/Fiscal owns rule evaluation.

## Catalog Relationship

Tax does not become the owner of the business catalog.

Catalog/domain owners may expose stable classifications when an explicitly activated rule contract requires them. Current Business tax is not assigned per Catalog item and does not require restoring retired item-tax authority.

Examples may include:

- POS sellable item/product tax category;
- Workshop service/labor tax category;
- Workshop part/inventory item tax category;
- future domain-specific taxable classifications.

Tax configuration follows the client's entitled business domains and available catalog classifications. Do not expose irrelevant tax configuration simply because the platform supports it globally.

## Backoffice Contribution

Current Backoffice exposes tax enabled/rate through Business Configuration. The broader future Tax/Fiscal configuration entry belongs conceptually under configuration/settings and must not create a second current tax authority.

Where classification-based rules are explicitly activated, their configuration experience must be composed from:

```text
Client Entitlement
+ Enabled Business Domains
+ Available Catalog Tax Classifications
+ Location/Jurisdiction Context
+ User Permission
```

Examples:

- a POS-only client configures tax mappings/rules relevant to POS catalog/sales;
- a Workshop client configures tax treatment relevant to services, labor, and parts;
- a POS + Workshop client can configure both through one Tax/Fiscal authority.

The UI must remain readable and context-sensitive rather than presenting every possible rule at the same visual level.

Any Tax/Fiscal UI work must apply both `frontend-design` and `ui-ux-pro-max` when available under root `AGENTS.md`, alongside the existing Digvation Design System.

## Operational Contribution

Normally no standalone operational module.

POS/Workshop/other operational flows invoke Tax/Fiscal through backend/domain contracts and show the resulting tax breakdown where appropriate.

## Dashboard Projection

Tax/Fiscal normally does not own primary business dashboard KPIs, but may contribute fiscal/compliance indicators when explicitly required.

## Report Projection

Tax/Fiscal may register tax-specific reports such as:

- tax summary;
- tax by category/rate;
- tax by location;
- transaction tax detail;
- other jurisdiction-specific reports when explicitly scoped.

Reports must preserve the historical tax result/rule snapshot used by originating transactions rather than recalculating old transactions using today's rules.

Tax Summary / Tax Collected answers how much tax was recorded from qualifying
finalized transactions in a selected finalized-business period and which
transactions formed that value. It reads immutable transaction tax facts, not
current Tax Configuration. It is not Tax Payable, statutory filing, remittance,
or an accounting liability statement; those require a separately owned future
Accounting/Tax Compliance scope.

## Current Scope

The verified accepted subset includes:

- tenant Business tax `enabled`, decimal `rate`, and optimistic configuration version;
- application default enabled with rate `0.11` (11%) when no persisted Business tax configuration exists;
- an explicit Business tax toggle independent from entitlement availability;
- backend-authoritative tax calculation using the accepted Sale monetary ordering;
- captured historical tax results for receipts and qualifying finalized-transaction reporting;
- Backoffice Business Configuration and permission/capability-aware Tax report access.

Do not reintroduce per-item tax as current authority. A broader dynamic rule editor, location/jurisdiction categories, or effective-dated tax engine is outside this delivered subset and requires an explicit future task.

## Deferred / Future

- jurisdiction-specific fiscal integrations;
- classification/category/location-based rule configuration beyond tenant Business tax;
- an effective-dated multi-rule engine beyond captured configuration versions;
- tax exemptions/customer tax profiles;
- complex compound taxes;
- external tax provider integration;
- e-invoice/fiscal device behavior;
- any capability not explicitly activated later.

## Integration Rules

- one shared tax authority for reusable fiscal rules;
- Promotion/Commercial Rules does not calculate tax; consuming transaction domains pass the authoritative monetary/taxable context after the accepted commercial-benefit ordering;
- no duplicated POS tax engine and Workshop tax engine;
- tax calculations that affect money are backend-authoritative;
- current Business configuration is versioned; effective-dated rules apply only when their wider contract is explicitly implemented;
- historical documents preserve the applied tax outcome/rule reference;
- consuming transactions persist the applied tax facts needed for historical
  receipt/report projection, including applicable tax identity/rate/treatment,
  taxable or net amount, tax amount, and gross/total outcome;
- Tax Summary / Tax Collected uses qualifying finalized transaction facts and
  finalized-period semantics, never current rules or a non-finalized creation
  timestamp as a substitute for finalization;
- catalog mapping is classification/configuration, not catalog ownership;
- entitlement/business profile may shape configuration UX, but only authoritative enabled domains/capabilities may activate behavior.

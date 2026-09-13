# Tax / Fiscal Rules Scope Contract

Kind: `SHARED_BUSINESS_CAPABILITY`
Status: `NEXT`
Entitlement Class: `CAPABILITY`
Commercial Packaging: `BUNDLED_OR_OPTIONAL`

## Commercial Availability / Effective Entitlement

Tax/Fiscal is a capability entitlement. It may be bundled as part of an applicable product/plan or enabled explicitly for a client, depending on commercial and jurisdiction requirements. The runtime must consume the resolved `TAX_FISCAL` capability state; it must not infer activation from business type or Catalog data.

## Purpose

Provide one dynamic tax/fiscal rule authority that can be consumed by multiple Digvation business domains such as POS and Workshop.

Tax is not POS-local logic and must not be duplicated per business domain.

## Owns / Authority

When implemented, Tax/Fiscal may own:

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

Tax evaluation must be context-aware rather than hard-coded by product.

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

Catalog/domain owners expose stable classifications required for tax evaluation.

Examples may include:

- POS sellable item/product tax category;
- Workshop service/labor tax category;
- Workshop part/inventory item tax category;
- future domain-specific taxable classifications.

Tax configuration follows the client's entitled business domains and available catalog classifications. Do not expose irrelevant tax configuration simply because the platform supports it globally.

## Backoffice Contribution

Tax/Fiscal has its own configuration entry in Backoffice, conceptually under configuration/settings.

The configuration experience must be composed from:

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

Any Tax/Fiscal UI work must use `uiuxpromax` and the existing Digvation Design System.

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

Architecture/boundary is now defined.

Implementation details are not yet authorized beyond an explicit future feature task.

## Deferred / Future

- jurisdiction-specific fiscal integrations;
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
- rules are effective-dated/versioned;
- historical documents preserve the applied tax outcome/rule reference;
- consuming transactions persist the applied tax facts needed for historical
  receipt/report projection, including applicable tax identity/rate/treatment,
  taxable or net amount, tax amount, and gross/total outcome;
- Tax Summary / Tax Collected uses qualifying finalized transaction facts and
  finalized-period semantics, never current rules or a non-finalized creation
  timestamp as a substitute for finalization;
- catalog mapping is classification/configuration, not catalog ownership;
- entitlement/business profile may shape configuration UX, but only authoritative enabled domains/capabilities may activate behavior.

# Graph Report - .  (2026-09-19)

## Corpus Check
- Corpus is ~44,435 words - fits in a single context window. You may not need a graph.

## Summary
- 186 nodes · 401 edges · 11 communities
- Extraction: 91% EXTRACTED · 9% INFERRED · 0% AMBIGUOUS · INFERRED: 37 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Community Hubs (Navigation)
- Commerce Domain Scopes
- Security, Infra & Release
- Runtime & Web Engineering
- Agent Skills & Routing
- Finance, Audit & RBAC
- CORE Control Plane

## God Nodes (most connected - your core abstractions)
1. `Ecosystem Architecture` - 33 edges
2. `Digvation Global Agent Contract` - 25 edges
3. `Digvation Scope Contracts Catalog` - 21 edges
4. `Delivery, Git, Versioning and Deployment Standard` - 15 edges
5. `Infrastructure and Server Standard` - 15 edges
6. `Security Acceptance Standard` - 15 edges
7. `Finance / Financial Operations Scope Contract` - 14 edges
8. `Client Installation Standard` - 13 edges
9. `Customer, Membership & Loyalty Scope Contract` - 13 edges
10. `Dashboard & Reporting Composition Contract` - 13 edges

## Surprising Connections (you probably didn't know these)
- `Codebase Memory MCP Discovery Layer` --semantically_similar_to--> `graphify Knowledge Graph`  [INFERRED] [semantically similar]
  AGENTS.md → CLAUDE.md
- `Model Cheat Sheet` --semantically_similar_to--> `Model Routing (TERRA MEDIUM / TERRA HIGH / SOL)`  [INFERRED] [semantically similar]
  standards/PROMPT_LIBRARY.md → AGENTS.md
- `Design System Rule (@digvation/ui)` --semantically_similar_to--> `UI Authority Order`  [INFERRED] [semantically similar]
  standards/ENGINEERING_STANDARD.md → .claude/skills/digvation-ui/SKILL.md
- `Authoritative Security Boundaries` --semantically_similar_to--> `POS-Specific Security Acceptance`  [INFERRED] [semantically similar]
  .claude/skills/digvation-security/SKILL.md → standards/SECURITY_ACCEPTANCE_STANDARD.md
- `Client Onboarding (Create & Provision)` --semantically_similar_to--> `Standard Client Onboarding Flow`  [INFERRED] [semantically similar]
  core/digvation-core-ui/AGENTS.md → standards/CLIENT_INSTALLATION_STANDARD.md

## Import Cycles
- None detected.

## Hyperedges (group relationships)
- **Digvation Claude Skills Routed via digvation-router** — _claude_skills_digvation_router_skill, _claude_skills_digvation_debug_skill, _claude_skills_digvation_feature_skill, _claude_skills_digvation_release_skill, _claude_skills_digvation_security_skill, _claude_skills_digvation_ui_skill [EXTRACTED 1.00]
- **Entitlement-to-Visibility Composition** — standards_ecosystem_architecture_core_control_plane, standards_ecosystem_architecture_effective_entitlement_set, standards_ecosystem_architecture_installation, standards_ecosystem_architecture_operational_access, standards_ecosystem_architecture_visible_capability_composition, standards_ecosystem_architecture_backoffice, standards_ecosystem_architecture_operational [INFERRED 0.85]
- **Feature-to-Production Release Pipeline** — standards_delivery_release_standard_feature_delivery_state_machine, agents_ready_for_manual_review, standards_delivery_release_standard_full_release_gate, standards_delivery_release_standard_build_once_promote, standards_client_installation_standard_production_acceptance, standards_security_acceptance_standard_first_production_security_gate [INFERRED 0.85]
- **Employee / Account / Role / Operational Access authority separation** — scopes_workforce_employee_identity, scopes_identity_access_account_principal, scopes_identity_access_role_permission, scopes_operational_access_operational_location_access [EXTRACTED 1.00]
- **Integrated Customer + Membership + Loyalty + Promotion suite** — scopes_customer_membership_customer_identity, scopes_customer_membership_membership, scopes_customer_membership_loyalty_points, scopes_customer_membership_point_ledger_entry, scopes_promotion_commercial_promotion [EXTRACTED 1.00]
- **Entitlement-gated dashboard/reporting composition** — scopes_dashboard_reporting_composition_authority, scopes_readme_effective_entitlement_set, scopes_dashboard_reporting_domain_contribution_model, scopes_dashboard_reporting_cross_domain_report_rule [INFERRED 0.85]

## Communities (11 total, 0 thin omitted)

### Community 0 - "Commerce Domain Scopes"
Cohesion: 0.12
Nodes (40): Catalog Entry / Classification, Catalog Pricing Boundary, Catalog Scope Contract, Customer Identity (CUSTOMER_IDENTITY), Loyalty Points (LOYALTY_POINTS), Loyalty Rule Precedence (Catalog-specific FIXED_POINTS/EXCLUDED over Default Spend Rule), Membership (enrollment/status), Loyalty Point Ledger (PointLedgerEntry) (+32 more)

### Community 1 - "Security, Infra & Release"
Cohesion: 0.12
Nodes (33): digvation-security Skill, Authoritative Security Boundaries, Digvation Infrastructure Repository Agent Contract, Lifecycle Overlay Installation, Client Installation Standard, Client Infrastructure Preflight Gate, PRODUCTION_ACTIVE Acceptance Checklist, Supported Deployment Modes (Dedicated-Digvation / Dedicated-Client / Shared SaaS) (+25 more)

### Community 2 - "Runtime & Web Engineering"
Cohesion: 0.11
Nodes (30): Digvation Business Runtime Engineering Contract, Backend/Domain Ownership Classification, Database and Migration Rules, Transactional and Financial Integrity, Digvation Business Web Engineering Contract, apps/backoffice (Backoffice Foundation), apps/cashier (POS Operational Implementation), contracts/contract-lock.json (+22 more)

### Community 3 - "Agent Skills & Routing"
Cohesion: 0.10
Nodes (29): Graphify Skill Pointer (.claude/CLAUDE.md), digvation-debug Skill, Superpowers Systematic Debugging, digvation-feature Skill, digvation-release Skill, Remote Mutation Gate, digvation-router Skill, digvation-ui Skill (+21 more)

### Community 4 - "Finance, Audit & RBAC"
Cohesion: 0.14
Nodes (27): Audit/Activity Record (append-only, business-semantic), Audit & Activity Scope Contract, Audit Sensitive Data Rules, Cash Movement, Cashier Session Boundary, Expense Request Lifecycle, Financial Account (Cash/Bank/E-Wallet), Payment-to-Financial-Account Routing (+19 more)

### Community 5 - "CORE Control Plane"
Cohesion: 0.18
Nodes (17): CORE Service Repository Agent Contract, AddOnOffering, CO_TERM_PRORATED Add-on Billing, Paired CORE Implementation (core-v2 + digvation-core-ui), ProductCapability Compatibility, SubscriptionTerm / SubscriptionAddOn Price Snapshots, CORE UI Repository Agent Contract, Client Onboarding (Create & Provision) (+9 more)

## Ambiguous Edges - Review These
- `Digvation Scope Contracts Catalog` → `Scheduling Scope Contract`  [AMBIGUOUS]
  scopes/README.md · relation: references

## Knowledge Gaps
- **22 isolated node(s):** `Graphify Skill Pointer (.claude/CLAUDE.md)`, `start-claude.ps1`, `Superpowers Systematic Debugging`, `Business Configuration`, `UI Data-Source Abstraction` (+17 more)
  These have ≤1 connection - possible missing edges or undocumented components.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **What is the exact relationship between `Digvation Scope Contracts Catalog` and `Scheduling Scope Contract`?**
  _Edge tagged AMBIGUOUS (relation: references) - confidence is low._
- **Why does `Ecosystem Architecture` connect `Runtime & Web Engineering` to `Security, Infra & Release`, `Agent Skills & Routing`, `CORE Control Plane`?**
  _High betweenness centrality (0.145) - this node is a cross-community bridge._
- **Why does `Digvation Global Agent Contract` connect `Agent Skills & Routing` to `Security, Infra & Release`, `Runtime & Web Engineering`?**
  _High betweenness centrality (0.110) - this node is a cross-community bridge._
- **Why does `Delivery, Git, Versioning and Deployment Standard` connect `Security, Infra & Release` to `Runtime & Web Engineering`, `Agent Skills & Routing`?**
  _High betweenness centrality (0.041) - this node is a cross-community bridge._
- **What connects `Graphify Skill Pointer (.claude/CLAUDE.md)`, `start-claude.ps1`, `Superpowers Systematic Debugging` to the rest of the system?**
  _22 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Commerce Domain Scopes` be split into smaller, more focused modules?**
  _Cohesion score 0.11923076923076924 - nodes in this community are weakly interconnected._
- **Should `Security, Infra & Release` be split into smaller, more focused modules?**
  _Cohesion score 0.11931818181818182 - nodes in this community are weakly interconnected._
# Graph Report - lifecycle  (2026-09-20)

## Corpus Check
- 78 files · ~68,193 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 334 nodes · 519 edges · 38 communities (20 shown, 18 thin omitted)
- Extraction: 93% EXTRACTED · 7% INFERRED · 0% AMBIGUOUS · INFERRED: 37 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `1c3d09fc`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- Commerce Domain Scopes
- Security, Infra & Release
- Runtime & Web Engineering
- Agent Skills & Routing
- Finance, Audit & RBAC
- CORE Control Plane
- graphify reference: extra exports and benchmark
- graphify reference: query, path, explain
- graphify reference: query, path, explain
- graphify reference: add a URL and watch a folder
- graphify reference: commit hook and native CLAUDE.md integration
- graphify reference: incremental update and cluster-only
- graphify reference: add a URL and watch a folder
- graphify reference: commit hook and native CLAUDE.md integration
- graphify reference: incremental update and cluster-only
- graphify reference: GitHub clone and cross-repo merge
- graphify reference: transcribe video and audio
- graphify reference: GitHub clone and cross-repo merge
- graphify reference: transcribe video and audio
- backup-20260919-230448/digvation-debug/SKILL.md
- backup-20260919-230448/digvation-feature/SKILL.md
- backup-20260919-230448/digvation-release/SKILL.md
- backup-20260919-230448/digvation-router/SKILL.md
- backup-20260919-230448/digvation-security/SKILL.md
- backup-20260919-230448/digvation-ui/SKILL.md
- backup-20260919-230448/graphify/references/extraction-spec.md
- skills/digvation-debug/SKILL.md
- skills/digvation-feature/SKILL.md
- skills/digvation-release/SKILL.md
- skills/digvation-router/SKILL.md
- skills/digvation-security/SKILL.md
- skills/digvation-ui/SKILL.md
- skills/graphify/references/extraction-spec.md

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

## Communities (38 total, 18 thin omitted)

### Community 0 - "Commerce Domain Scopes"
Cohesion: 0.08
Nodes (67): Audit/Activity Record (append-only, business-semantic), Audit & Activity Scope Contract, Audit Sensitive Data Rules, Catalog Entry / Classification, Catalog Pricing Boundary, Catalog Scope Contract, Customer Identity (CUSTOMER_IDENTITY), Loyalty Points (LOYALTY_POINTS) (+59 more)

### Community 1 - "Security, Infra & Release"
Cohesion: 0.06
Nodes (62): Graphify Skill Pointer (.claude/CLAUDE.md), digvation-debug Skill, Superpowers Systematic Debugging, digvation-feature Skill, digvation-release Skill, Remote Mutation Gate, digvation-router Skill, digvation-security Skill (+54 more)

### Community 2 - "Runtime & Web Engineering"
Cohesion: 0.07
Nodes (47): Digvation Business Runtime Engineering Contract, Backend/Domain Ownership Classification, Database and Migration Rules, Transactional and Financial Integrity, Digvation Business Web Engineering Contract, apps/backoffice (Backoffice Foundation), apps/cashier (POS Operational Implementation), contracts/contract-lock.json (+39 more)

### Community 3 - "Agent Skills & Routing"
Cohesion: 0.07
Nodes (26): For /graphify add and --watch, For /graphify query, For the commit hook and native CLAUDE.md integration, For --update and --cluster-only, /graphify, Honesty Rules, Interpreter guard for subcommands, Part A - Structural extraction for code files (+18 more)

### Community 4 - "Finance, Audit & RBAC"
Cohesion: 0.07
Nodes (26): For /graphify add and --watch, For /graphify query, For the commit hook and native CLAUDE.md integration, For --update and --cluster-only, /graphify, Honesty Rules, Interpreter guard for subcommands, Part A - Structural extraction for code files (+18 more)

### Community 5 - "CORE Control Plane"
Cohesion: 0.22
Nodes (8): graphify reference: extra exports and benchmark, Step 6b - Wiki (only if --wiki flag), Step 7 - Neo4j export (only if --neo4j or --neo4j-push flag), Step 7a - FalkorDB export (only if --falkordb or --falkordb-push flag), Step 7b - SVG export (only if --svg flag), Step 7c - GraphML export (only if --graphml flag), Step 7d - MCP server (only if --mcp flag), Step 8 - Token reduction benchmark (only if total_words > 5000)

### Community 11 - "graphify reference: extra exports and benchmark"
Cohesion: 0.22
Nodes (8): graphify reference: extra exports and benchmark, Step 6b - Wiki (only if --wiki flag), Step 7 - Neo4j export (only if --neo4j or --neo4j-push flag), Step 7a - FalkorDB export (only if --falkordb or --falkordb-push flag), Step 7b - SVG export (only if --svg flag), Step 7c - GraphML export (only if --graphml flag), Step 7d - MCP server (only if --mcp flag), Step 8 - Token reduction benchmark (only if total_words > 5000)

### Community 12 - "graphify reference: query, path, explain"
Cohesion: 0.33
Nodes (5): For /graphify explain, For /graphify path, graphify reference: query, path, explain, Step 0 — Constrained query expansion (REQUIRED before traversal), Step 1 — Traversal

### Community 13 - "graphify reference: query, path, explain"
Cohesion: 0.33
Nodes (5): For /graphify explain, For /graphify path, graphify reference: query, path, explain, Step 0 — Constrained query expansion (REQUIRED before traversal), Step 1 — Traversal

### Community 14 - "graphify reference: add a URL and watch a folder"
Cohesion: 0.50
Nodes (3): For /graphify add, For --watch, graphify reference: add a URL and watch a folder

### Community 15 - "graphify reference: commit hook and native CLAUDE.md integration"
Cohesion: 0.50
Nodes (3): For git commit hook, For native CLAUDE.md integration, graphify reference: commit hook and native CLAUDE.md integration

### Community 16 - "graphify reference: incremental update and cluster-only"
Cohesion: 0.50
Nodes (3): For --cluster-only, For --update (incremental re-extraction), graphify reference: incremental update and cluster-only

### Community 17 - "graphify reference: add a URL and watch a folder"
Cohesion: 0.50
Nodes (3): For /graphify add, For --watch, graphify reference: add a URL and watch a folder

### Community 18 - "graphify reference: commit hook and native CLAUDE.md integration"
Cohesion: 0.50
Nodes (3): For git commit hook, For native CLAUDE.md integration, graphify reference: commit hook and native CLAUDE.md integration

### Community 19 - "graphify reference: incremental update and cluster-only"
Cohesion: 0.50
Nodes (3): For --cluster-only, For --update (incremental re-extraction), graphify reference: incremental update and cluster-only

## Ambiguous Edges - Review These
- `Digvation Scope Contracts Catalog` → `Scheduling Scope Contract`  [AMBIGUOUS]
  scopes/README.md · relation: references

## Knowledge Gaps
- **118 isolated node(s):** `Digvation Debugging`, `Digvation Feature Work`, `Digvation Release Gate`, `Digvation Router`, `Digvation Security Work` (+113 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **18 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **What is the exact relationship between `Digvation Scope Contracts Catalog` and `Scheduling Scope Contract`?**
  _Edge tagged AMBIGUOUS (relation: references) - confidence is low._
- **Why does `Ecosystem Architecture` connect `Runtime & Web Engineering` to `Security, Infra & Release`?**
  _High betweenness centrality (0.044) - this node is a cross-community bridge._
- **Why does `Digvation Global Agent Contract` connect `Security, Infra & Release` to `Runtime & Web Engineering`?**
  _High betweenness centrality (0.034) - this node is a cross-community bridge._
- **Why does `Delivery, Git, Versioning and Deployment Standard` connect `Security, Infra & Release` to `Runtime & Web Engineering`?**
  _High betweenness centrality (0.012) - this node is a cross-community bridge._
- **What connects `Digvation Debugging`, `Digvation Feature Work`, `Digvation Release Gate` to the rest of the system?**
  _118 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Commerce Domain Scopes` be split into smaller, more focused modules?**
  _Cohesion score 0.07507914970601538 - nodes in this community are weakly interconnected._
- **Should `Security, Infra & Release` be split into smaller, more focused modules?**
  _Cohesion score 0.06345848757271286 - nodes in this community are weakly interconnected._
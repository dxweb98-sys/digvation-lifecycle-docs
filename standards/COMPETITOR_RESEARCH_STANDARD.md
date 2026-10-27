# Digvation Competitor Research Standard

Detailed procedure for the competitor research gate in root [AGENTS.md](../AGENTS.md) §3A. The mandatory gate (classification, prohibitions, approval rules) stays in `AGENTS.md`; this standard owns the full procedure, evidence rules, and REA security conditions.

Read this standard **before any research begins** when a task is classified `LIGHT_RESEARCH` or `DEEP_RESEARCH_REA`. Do not load it for `SKIP_RESEARCH`. Claude Code, Codex, and other agents follow the same procedure.

If this standard and the `AGENTS.md` gate ever differ, the stricter rule applies and the conflict must be reported.

## 1. Gate rules

Before proposing a solution for a newly scoped task, evaluate whether external competitor research would materially improve the product or architecture decision.

This evaluation is mandatory, but conducting research is optional.

Do not rerun this gate for every message or implementation iteration of an already approved task.

Apply the gate after determining task ownership and before proposing a new solution. Preserve the existing Digvation instruction hierarchy, agent routing, approval boundaries, and implementation workflow.

## 2. Research classification

Select exactly one outcome.

**SKIP_RESEARCH**

Choose when the task is an approved implementation, bug fix, regression, internal refactor, performance optimization, infrastructure change, security fix, or otherwise has sufficient authoritative requirements and repository evidence.

Do not invoke competitor research tools or REA. Continue the existing workflow.

**LIGHT_RESEARCH**

Choose when external product patterns, public documentation, screenshots, or observable behavior could materially improve a UX, workflow, or product decision.

Use approved browser, documentation, or existing research capabilities.

Keep the investigation bounded to unresolved decision questions. Do not invoke REA by default.

**DEEP_RESEARCH_REA**

Choose only when all of the following apply:

- A substantial product or architectural decision remains unresolved.
- Ordinary research cannot adequately answer the important questions.
- Accessible external technical artifacts could provide meaningful additional evidence.
- Analysis is legally permissible, appropriately authorized, and safe.

REA remains optional. This classification does not itself authorize reverse engineering or software execution.

When REA is unavailable or unjustified, use conventional research where useful. Never block an otherwise well-defined task solely because REA is unavailable.

Escalation from LIGHT_RESEARCH requires a demonstrated evidence gap and a concrete decision that deeper investigation could affect.

## 3. Autonomous competitor discovery

When `LIGHT_RESEARCH` or `DEEP_RESEARCH_REA` is justified, discover relevant competitors or reference products independently. **Do not require the user to supply competitor names** unless the task expressly targets named products or indispensable selection criteria cannot be established.

1. Define the business category, target geography/market, customer segment, and precise feature or product-decision question. Derive these from the authorized task and existing context; request clarification only for genuinely essential missing information.
2. Reuse current research artifacts and handoffs first. Otherwise, discover candidates using approved public search, product documentation, demonstrations, and other lawful research sources.
3. For tasks concerning Digvation's Indonesian customers, prioritize **Indonesian-market relevance**, without excluding a materially better international reference.
4. Select **up to three** strong references by default. Rank them by verified relevance to the feature and customer workflow, **not brand popularity**. Expand only if a concrete evidence gap warrants it.
5. Verify that each selected product actually supports the specific feature under investigation using accessible, credible evidence. Exclude or mark unverified candidates rather than inventing capabilities.
6. Examine public documentation, product demonstrations, observable UX, and credible user feedback where relevant. Preserve source links and distinguish claims from direct observations according to the evidence classifications below.
7. Identify the unresolved technical or behavioral questions that public research cannot answer. Escalate to REA **only if** deeper evidence could materially change the decision and every existing REA authorization, artifact-access, isolation, and security condition is satisfied.
8. Compare supported findings with Digvation's actual domain contracts, architecture, requirements, and accepted user flows; do not presume competitor architecture or behavior is superior.
9. Recommend `ADOPT`, `ADAPT`, `REJECT`, or `DEFER`, with cited evidence, confidence, and explicit advantages/trade-offs. Request approval before any scope or policy change.

`SKIP_RESEARCH` does not invoke this workflow. Do not perform reverse engineering to satisfy a checklist; if no trustworthy reference is found, report the limitation instead of guessing. Stop researching when sufficient decision-quality evidence exists.

## 4. REA discovery and security

Before invoking REA:

1. Discover the actual installed REA integration and documented tool capabilities.
2. Verify access, authorization, and artifact provenance.
3. Prefer isolated, read-only analysis.
4. Never automatically install REA, packages, analysis engines, or MCP servers.
5. Never bypass authentication, DRM, licensing, rate limits, or access controls.
6. Never collect unauthorized credentials, customer data, or proprietary information.
7. Never execute untrusted binaries on a development host without explicit approval and appropriate isolation.
8. Never expose production secrets, environment variables, database credentials, SSH keys, or Docker socket access.

If required permissions, tools, or isolation are unavailable, report the limitation and continue safely where possible.

Do not reverse engineer an external product merely because it is technically possible.

## 5. Evidence requirements

Classify findings as:

- `OBSERVED`: directly verified external product behavior.
- `VERIFIED_TECHNICAL`: supported by accessible technical evidence.
- `INFERRED`: reasoned but not independently verified.
- `UNKNOWN`: insufficient evidence.

For decision-relevant findings, record the reference product, behavior or capability, evidence source, confidence, relevance to Digvation, advantages, and trade-offs.

Never present inferred architecture as verified fact.

Do not copy proprietary code or protected assets. Research should inform independently designed Digvation solutions.

## 6. Digvation integration

After useful research, compare findings with existing Digvation architecture and approved behavior.

Use Graphify / Codebase Memory / repository MCP for targeted inspection of the affected contracts, modules, schemas, and tests.

Preserve existing domain authority, Runtime/Web boundaries, Dedicated-first entitlement policies, RBAC, tenant/location isolation, financial invariants, stable UI patterns, and accepted API contracts.

A competitor's implementation is evidence, not architectural authority.

The Orchestrator may recommend:

`ADOPT | ADAPT | REJECT | DEFER`

An external finding never automatically authorizes a change to product requirements or implementation scope.

## 7. Skill and agent routing

Preserve all existing mandatory skill discovery, reading, and application requirements.

For frontend/UI/UX tasks, apply both `frontend-design` and `ui-ux-pro-max` according to the current Digvation execution standard, alongside the Digvation Design System.

Use relevant specialized agents only for bounded, nonduplicative research.

REA does not replace implementation skills, architectural analysis, or security review.

## 8. Context and token discipline

- Prefer existing research and accepted decisions.
- Never repeat competitor research without a material evidence gap or staleness.
- Avoid broad repository scans or redundant agent investigations.
- Read only the evidence needed for the current decision.
- Stop when sufficient decision-quality evidence is available.
- Summarize findings instead of dumping large technical outputs.
- Apply `DELTA ONLY — NO SCOPE CREEP` throughout.

## 9. Reporting and approval

Evaluate the gate internally for each new task. For routine SKIP_RESEARCH tasks, do not add unnecessary reporting.

When research materially affects a decision, report concisely:

`RESEARCH_GATE: SKIP_RESEARCH | LIGHT_RESEARCH | DEEP_RESEARCH_REA`

`RESEARCH_REASON:` Why research was or was not needed.

`EVIDENCE:` Verified findings, sources, and confidence.

`DIGVATION_IMPACT:` Recommended implications for existing behavior.

`DECISION: ADOPT | ADAPT | REJECT | DEFER | NOT_APPLICABLE`

`APPROVAL_REQUIRED: YES | NO`

The Orchestrator may classify, investigate, delegate bounded research, compare evidence, and recommend decisions.

It must not independently expand an approved task, change established policies, install tools, modify protected databases or infrastructure, commit, push, merge, or deploy.

Stop at `READY_FOR_MANUAL_REVIEW` when product, architecture, scope, tool installation, or authorization decisions require approval.

All existing Digvation implementation, Git, migration, release, and deployment approval gates remain unchanged.

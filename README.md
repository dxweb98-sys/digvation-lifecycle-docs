# Digvation Lifecycle

This workspace is the orchestration root for the Digvation ecosystem. It owns the cross-repository agent contract, ecosystem standards, and durable business-scope contracts. Product source code lives in nested repositories, each with its own Git history and `AGENTS.md`.

Mandatory agent behavior lives in [AGENTS.md](AGENTS.md) (all agents) and [CLAUDE.md](CLAUDE.md) (Claude Code entry). This README is navigation only; it adds no rules.

## What Digvation is

Digvation is a composable business platform for Indonesian businesses, coordinated by a shared control plane:

```text
CORE (control plane)  -> clients, products, entitlements, installations, releases
Business Runtime      -> authoritative business domains and shared capabilities
Business Web          -> two shared experiences: Backoffice (manage) and Operational (run)
Installation          -> where and how a client's runtime is deployed (Dedicated-first today)
```

POS is the first and most mature business domain. Workshop has an accepted subset on a separate development lane. Customer/Membership/Loyalty, Promotions, Tax, Finance Operations, and Workforce are shared capabilities/foundations consumed by domains. Entitlements, not source presence, business type, or branding, decide what a client can use.

Architecture authority: [standards/ECOSYSTEM_ARCHITECTURE.md](standards/ECOSYSTEM_ARCHITECTURE.md). Direction: [standards/ECOSYSTEM_ROADMAP.md](standards/ECOSYSTEM_ROADMAP.md). What exists now: [docs/CURRENT_PLATFORM.md](docs/CURRENT_PLATFORM.md).

## Repository map

| Path | Repository | Owns | Integration branch |
| --- | --- | --- | --- |
| `core/core-v2` | `core-v2` | CORE control-plane API (clients, products, capabilities, subscriptions, installations, runtime binding, deployment operations) | `digvation-core-dev` |
| `core/digvation-core-ui` | `digvation-core-ui` | CORE operator console | `digvation-core-ui-dev` |
| `business/digvation-business-runtime` | `digvation-business-runtime` | Business Runtime: domain and shared-capability authority, persistence, financial truth | `dev` / `dev-workshop` |
| `business/digvation-business-web` | `digvation-business-web` | Business Web: `apps/backoffice`, `apps/operational`, `apps/member-portal`, `packages/*` | `dev` / `dev-workshop` |
| `infra/digvation-infrastructure` | `digvation-infrastructure` | Reusable server/Installation automation and templates | `dev` |
| `@digvation/ui` (npm) | `digvation-design-system` | Design System component library (consumed as a pinned package) | not in this workspace |

Repository names are not ownership authority; see the architecture standard. Each nested repository's `AGENTS.md` adds repository rules.

Lifecycle-owned folders:

| Folder | Content | Read when |
| --- | --- | --- |
| [standards/](standards/README.md) | Ecosystem, engineering, UI/UX, delivery, infrastructure, installation, security standards | Only the standard whose trigger applies |
| [scopes/](scopes/README.md) | One durable scope contract per domain/foundation/capability | Only the one or two contracts the task touches |
| [docs/](docs/) | Current platform inventory and language/terminology reference | When the task needs current-state facts or Indonesian terms |
| `.claude/skills/`, `.agents/skills/` | Digvation routing skills for Claude Code and Codex | Loaded by the tool when their trigger matches |
| `handoffs/` (create only when needed) | Task-specific handoff for an active task; remove it once the task is accepted, since Git history keeps it | Only when the user supplies that handoff |

Not routine context: `standards/PROMPT_LIBRARY.md` (user's copy/paste toolbox), `graphify-out/` (generated graph), `INSTALL_THIS_OVERLAY.md` (new-workspace setup), and the local, Git-ignored `digvation-lifecycle-docs-starter/` and `digvation-prompt-bank/`.

## Task routing

Always: the applicable `AGENTS.md` hierarchy (root + nested repository). Then read only what the row says. Use Codebase Memory / Graphify for source discovery before broad search.

| Task | Read | Skip | Skills | Approvals to watch |
| --- | --- | --- | --- | --- |
| POS bug or feature | [scopes/POS.md](scopes/POS.md) + one touched capability scope; Runtime/Web nested `AGENTS.md` | Infra, installation, security standards unless triggered | `digvation-router`, `digvation-debug` or `digvation-feature` | Commit, push, PR, merge, migrations |
| UI / UX change | [standards/UI_UX_STANDARD.md](standards/UI_UX_STANDARD.md) + owning scope | Release/infra standards | `digvation-ui`, `frontend-design`, `ui-ux-pro-max` | Same as above; no new UI libraries |
| Entitlement / capability availability | [ECOSYSTEM_ARCHITECTURE.md](standards/ECOSYSTEM_ARCHITECTURE.md) §15, [scopes/README.md](scopes/README.md), the capability's scope, Runtime `src/config/entitlement-manifest.ts` | Unrelated scopes | `digvation-router`, `digvation-security` | Any new entitlement code, permission, or contract is a product decision |
| Commit, merge, release, staging, production | [DELIVERY_RELEASE_STANDARD.md](standards/DELIVERY_RELEASE_STANDARD.md); for an Installation also [CLIENT_INSTALLATION_STANDARD.md](standards/CLIENT_INSTALLATION_STANDARD.md) / [INFRASTRUCTURE_STANDARD.md](standards/INFRASTRUCTURE_STANDARD.md) | Scopes, UI standard | `digvation-release` | Every Git write, promotion, and deployment is approved separately |
| Auth, RBAC, tenant isolation, money, payments, refunds | Owning scope + [SECURITY_ACCEPTANCE_STANDARD.md](standards/SECURITY_ACCEPTANCE_STANDARD.md) when a security gate applies | UI standard unless UI changes | `digvation-security` + task skill | DB writes, migrations, test-DB resets |
| Indonesian-language request | [docs/LANGUAGE_AND_TERMINOLOGY.md](docs/LANGUAGE_AND_TERMINOLOGY.md), then route by the actual task above | Translating terms into new behavior | As routed | As routed |
| Product/UX decision classified `LIGHT_RESEARCH` or `DEEP_RESEARCH_REA` | [COMPETITOR_RESEARCH_STANDARD.md](standards/COMPETITOR_RESEARCH_STANDARD.md) + owning scope | The standard for `SKIP_RESEARCH` tasks | REA only if every authorization condition holds | Tool installs, REA execution, any scope or policy change |
| New domain or product | [scopes/README.md](scopes/README.md), [NEW_PRODUCT_STANDARD.md](standards/NEW_PRODUCT_STANDARD.md), architecture standard | Unrelated scopes | `digvation-router` | Product/architecture decision before code |
| "What exists / is it deployed?" | [docs/CURRENT_PLATFORM.md](docs/CURRENT_PLATFORM.md), then fresh GitHub/Installation evidence | Historical handoffs | `digvation-router` | None for reading |

## Working language

The user usually writes in Indonesian; agent prompts, handoffs, and code are in English. The binding rule is in [AGENTS.md](AGENTS.md) §18; terminology is in [docs/LANGUAGE_AND_TERMINOLOGY.md](docs/LANGUAGE_AND_TERMINOLOGY.md).

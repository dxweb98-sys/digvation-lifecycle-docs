---
name: digvation-ui
description: Use when changing Digvation frontend UI, UX, pages, layouts, components, forms, responsive behavior, accessibility, visual hierarchy, Backoffice, or Operational presentation.
---

# Digvation UI Work

First use `digvation-router`.

Authority order:
1. current Digvation Design System and repository components/tokens;
2. accepted application patterns;
3. current product/domain behavior and API contracts;
4. `ui-ux-pro-max` as supporting design intelligence;
5. generic frontend guidance.

Use Playwright when browser verification materially improves confidence. Prefer a focused flow over broad E2E.

Never introduce a new UI framework, component library, icon library, styling system, or dependency merely because a UI skill recommends it.

Do not redesign unrelated accepted screens. Preserve Runtime/domain monetary and authorization authority; presentation code must not create competing business rules.

For UI bugs, reproduce the visible behavior, inspect the responsible component/data flow, apply the narrow fix, then verify the affected viewport/interaction.

<!-- DIGVATION_CLAUDE_BOOTSTRAP -->



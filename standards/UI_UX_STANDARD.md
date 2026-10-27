# Digvation UI/UX Standard

Read this for any change to Digvation frontend appearance, layout, forms, states, interactions, responsive behavior, or accessibility. It records accepted conventions; it does not authorize a redesign.

Authority order for UI work:

1. Current product/domain behavior and Runtime API contracts.
2. `@digvation/ui` (Design System) components and tokens.
3. Accepted application patterns in `digvation-business-web` (Catalog and Transaction History are the references).
4. This standard and [ENGINEERING_STANDARD.md](ENGINEERING_STANDARD.md) §8 (Design System rule), §9 (app-level consistency), §16 (loading/error/empty).
5. `frontend-design` and `ui-ux-pro-max` as supporting design intelligence.

Source code is authoritative for exact tokens, component APIs, and class values. When this file and source disagree, source wins and this file is corrected.

## 1. Mandatory skills

For UI/UX work, discover, read, and genuinely apply both `frontend-design` and `ui-ux-pro-max` (installed names) together with the `digvation-ui` routing skill, as required by root [AGENTS.md](../AGENTS.md) §17. If either is unavailable, report the discovery attempt and the fallback. Skills never override the Design System, accepted patterns, or this standard; they must not introduce a new UI framework, component library, icon set, styling system, or dependency.

Pure structural frontend refactors with no visible change do not need the design skills.

## 2. Design System

- Package: `@digvation/ui`, pinned (currently `1.1.0`) in Web apps. Source repository: `digvation-design-system`, `packages/ui`. It is not in this workspace; change it only through its own repository and release.
- Import `@digvation/ui/styles.css` once per app entry (`apps/*/src/main.tsx`).
- Components are `D`-prefixed: `DButton`, `DInput`, `DSelect`, `DCombobox`, `DForm`/`DFormField`, `DCurrencyInput`, `DDecimalInput`, `DDatePicker`, `DDateRangeFilter`, `DDataTable`, `DPagination`, `DDialog`, `DConfirmDialog`, `DCard`, `DBadge`, `DAlert`, `DInfoNote`, `DEmptyState`, `DTableSkeleton`, `DFormSkeleton`, `DToastProvider`/`useToast`, `DLocalizationProvider`, `DThemeProvider`, and others. Check the package's `index.d.ts` before building a local primitive.
- A missing capability is a Design System gap: name it and stop for a decision instead of creating a duplicate local primitive (see `PROMPT_LIBRARY.md` "Design System Gap").

## 3. Tokens and theming

Use semantic CSS variables, never raw palette values, in application code:

| Group | Variables |
| --- | --- |
| Surfaces and text | `--color-background`, `--color-surface`, `--color-surface-muted`, `--color-text`, `--color-text-muted`, `--color-border` |
| Brand and actions | `--color-brand`, `--color-brand-hover`, `--color-brand-active`, `--color-brand-foreground`, `--color-secondary*`, `--color-focus` |
| Status | `--color-info`, `--color-success`, `--color-warning`, `--color-danger` |
| Accents (charts, tags) | `--color-accent-yellow`, `-mint`, `-sky`, `-lavender`, `-coral` |
| Shape and depth | `--radius-control`, `--radius-card`, `--radius-panel`, `--shadow-sm`, `--shadow-md`, `--shadow-lg` |
| Type | `--font-sans`; Tailwind text scale `text-xs` … `text-3xl` |

- Branding and white-label colors come from runtime theme tokens (`ThemeTokens` / `createProjectThemeTokens`), never from client-name branches in source.
- Status color is semantic through component variants (`DBadge`: `default`, `primary`, `secondary`, `info`, `success`, `warning`, `danger`, `outline`; `DAlert`: `neutral`, `info`, `success`, `warning`, `danger`). Reuse the variant an existing screen already uses for the same status instead of choosing a new one. Never rely on color alone; the badge always carries the localized label.
- Styling uses Tailwind CSS v4 utilities with CSS-variable values (for example `bg-(--color-surface)`). Icons use `lucide-react`.

## 4. Layout conventions (Backoffice)

- Shell: `apps/backoffice/src/app/shell/backoffice-shell.tsx`. Left sidebar from `md` up, collapsible mobile navigation below `md`, 64px header with date, connectivity status, and active-branch selector.
- Sidebar navigation is grouped (master data, finance, reporting, configuration). Each item declares a capability key and is shown only when `canAccessBackoffice(session, capability)` allows it; unavailable items are hidden, not disabled.
- Page frame: `BackofficePage` and `BackofficePageHeader` in `apps/backoffice/src/app/layout/backoffice-page.tsx`: optional uppercase brand-colored eyebrow, `text-2xl` bold title, muted description up to `max-w-2xl`, primary actions aligned right and wrapping on small screens. Reuse them instead of hand-building page headers.
- Gutters follow the page frame (`px-5` → `sm:px-6` → `lg:px-8`). Do not add per-page widths or gutters.

Operational (`apps/operational`) uses the same Design System and tokens with its own shell for live selling work. Optimize it for speed and clarity of the current action; do not port Backoffice density into it.

## 5. Component patterns

| Need | Use |
| --- | --- |
| Lists and records | `DDataTable` with server-side `limit/offset` pagination through the app's list-query helpers; filters via `DSearchInput`, `DStatusFilter`, `DDateRangeFilter` |
| Create/edit forms | `DForm` + `DFormField` with field-level validation messages; money via `DCurrencyInput`, quantities/rates via `DDecimalInput` |
| Focused edit or detail | `DDialog`; destructive or irreversible actions via `DConfirmDialog` that states the consequence |
| Status | `DBadge` with the localized human-readable label |
| Inline guidance | `DInfoNote`; errors and blocking states via `DAlert` |
| Feedback after a command | Toast via `useToast`; keep the message specific to the outcome |
| Loading / empty | `DTableSkeleton`, `DFormSkeleton`, `DCardSkeleton`; `DEmptyState` with the next useful action |

Reference implementations: Backoffice Catalog (`apps/backoffice/src/features/catalog`) for editor/list structure and Transaction History (`features/transaction-history`) for history, detail, and correction/reversal actions. Reuse their principles, not their domain logic.

## 6. States and behavior

- Every data view handles loading, empty, permission denied, validation error, network/server error, and retry where meaningful ([ENGINEERING_STANDARD.md](ENGINEERING_STANDARD.md) §16).
- Action availability (enabled, hidden, explained-disabled) comes from Runtime permission and capability projections. UI must not invent business rules, compute authoritative money, or infer entitlement.
- Monetary display and input use `@digvation/business-money` (decimal) and Design System currency helpers; never JavaScript `number` as authority.
- Changing a shared UI rule applies to every affected page in the same work unit ([ENGINEERING_STANDARD.md](ENGINEERING_STANDARD.md) §9).

## 7. Localization and accessibility

- Indonesian is the default product language; English is supported. Copy lives in app and feature localization files (`localization/` folders, `id`/`en` or `id-ID`/`en-US` keys). Add both languages for every new string. Terminology: [docs/LANGUAGE_AND_TERMINOLOGY.md](../docs/LANGUAGE_AND_TERMINOLOGY.md).
- Dates, currency (IDR), and numbers use the localization and currency helpers, not hand-formatted strings.
- Keep keyboard access, visible focus (`--color-focus`), labeled controls, and sufficient contrast. Use Design System dialogs rather than custom overlays so focus and dismissal behavior stays consistent; verify keyboard behavior when adding a new interaction.

## 8. Validation for UI work

Run the owning feature's focused UI tests and the app typecheck. Use Playwright for a focused user-visible flow at desktop and mobile widths when the change affects layout or interaction. Do not run unrelated E2E suites ([AGENTS.md](../AGENTS.md) §5).

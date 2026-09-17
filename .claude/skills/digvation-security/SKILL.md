---
name: digvation-security
description: Use when Digvation work involves authentication, sessions, refresh tokens, authorization, RBAC, tenant isolation, credentials, invitations, password reset, payments, sensitive data, uploads, webhooks, callbacks, or database authority.
---

# Digvation Security Work

First use `digvation-router`.

Read `standards/SECURITY_ACCEPTANCE_STANDARD.md` plus the directly relevant scope/repository contract. Do not load unrelated security material.

Preserve authoritative boundaries:
- Runtime/domain services own security-sensitive business decisions.
- Web must not bypass server-side authorization.
- Tenant/location/workspace context must be explicit and verified.
- Secrets must not be written into source, logs, generated artifacts, or bootstrap state.
- Security fixes must not weaken existing checks merely to make a flow pass.

Use targeted validation for the actual boundary being changed. When a security scanner/plugin is available, its findings are evidence, not architecture authority.

Remote credential changes, production secrets, destructive data operations, and production acceptance remain explicit human gates.

<!-- DIGVATION_CLAUDE_BOOTSTRAP -->



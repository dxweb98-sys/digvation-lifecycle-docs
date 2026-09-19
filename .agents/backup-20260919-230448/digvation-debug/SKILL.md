---
name: digvation-debug
description: Use when diagnosing a Digvation bug, regression, failing flow, unexpected API/UI behavior, build failure, runtime error, or integration issue.
---

# Digvation Debugging

First use `digvation-router`, then use Superpowers systematic debugging when applicable.

Work from evidence:
- reproduce or establish the failing condition;
- use Codebase Memory to locate owners, callers, routes, dependencies, and likely impact;
- inspect relevant logs/network responses/source;
- form a root-cause hypothesis before editing;
- make the smallest fix at the owning layer;
- verify the original failure path and targeted regressions.

Do not fix symptoms in Web when Runtime/domain authority is missing. Do not cross repository boundaries unless the contract actually crosses them.

If the failure is CI-specific, distinguish code/test/typecheck/dependency/environment/flaky failures before changing source.

Report unrelated findings separately instead of folding them into the patch.

<!-- DIGVATION_CLAUDE_BOOTSTRAP -->



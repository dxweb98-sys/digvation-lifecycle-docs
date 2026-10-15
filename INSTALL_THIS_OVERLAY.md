# Lifecycle Overlay Installation

Copy the contents of this folder into your local `lifecycle/` workspace.

This is manual overlay installation guidance, not a record of current feature delivery or a command to replace an already configured workspace. Use current remote canonical files; an older exported ZIP may omit newer instructions, scopes, or configuration.

Important:

- do not overwrite repository-specific unique rules blindly;
- reconcile existing `AGENTS.md` first if they contain durable unique domain constraints;
- the `standards/` folder is canonical reference documentation;
- `standards/PROMPT_LIBRARY.md` is your copy/paste toolbox, not permanent agent study material.

For a genuinely new workspace, use the `First-Time Standards Study / Bootstrap` prompt from `standards/PROMPT_LIBRARY.md` once as needed. Existing workspaces continue under the current root `AGENTS.md`, the tool-specific entry contract, and the accepted handoff; do not repeat a broad bootstrap for each task.

## Scope contracts

The `scopes/` folder is part of the lifecycle overlay and should be copied with the standards.

It is the living business-scope catalog. Update the applicable scope contract when a durable domain/module boundary changes (for example when Workshop is formally defined), rather than rewriting unrelated standards.

Agents should read only the scope contracts materially relevant to the current task.


## Scope catalog authority

Use [scopes/README.md](scopes/README.md) and the applicable scope contract for current status, verified delivery subsets, branch/release evidence, and deferred boundaries. Do not infer implementation, deployment, or client entitlement from this installer or an older archive. Product domains, optional capabilities/add-ons, and shared foundations retain separate authorities.

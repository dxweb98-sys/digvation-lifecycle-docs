# Digvation Infrastructure — Repository Agent Contract

This repository owns reusable Digvation infrastructure automation and templates.

It does not own product business logic.

## Canonical standards

For infrastructure work, follow:

- `standards/INFRASTRUCTURE_STANDARD.md`
- `standards/CLIENT_INSTALLATION_STANDARD.md`
- `standards/SECURITY_ACCEPTANCE_STANDARD.md`
- `standards/DELIVERY_RELEASE_STANDARD.md`

Resolve paths relative to the lifecycle workspace root.

## Repository responsibility

Own reusable automation for:

- Linux host bootstrap/hardening;
- Docker/container runtime installation;
- firewall/network baseline;
- reverse proxy/ingress/TLS;
- `/opt/digvation` filesystem layout;
- monitoring/alerting agents;
- backup tooling;
- deployment/Installation templates;
- infrastructure validation/preflight;
- provider-specific adapters when needed.

## Infrastructure as Code

Prefer declarative/idempotent automation.

Appropriate tools may include:

- Ansible;
- Terraform/OpenTofu;
- shell only for small bootstrap glue;
- Compose/manifests for runtime topology.

Do not introduce a tool merely for fashion. Use the smallest reliable tool for the ownership.

Automation should be safe to rerun.

## No production secrets

Never commit:

- private SSH keys;
- production `.env`;
- DB passwords;
- API/provider credentials;
- TLS private keys;
- client secrets.

Keep examples/schema/templates non-secret.

Secret injection comes from approved CI/secret-management/operations paths.

## No product forks

Infrastructure may identify an Installation operationally, but it must not create client-specific product source.

Use generic templates plus Installation configuration.

Supported client deployment models are only:

- Dedicated / Digvation Infrastructure;
- Dedicated / Client Infrastructure;
- Shared/SaaS / Digvation Infrastructure.

Do not invent a fourth one-off model for a client.

## Portability

Automation must make a replacement server converge to the same Digvation baseline without relying on undocumented manual history.

A server should be reconstructable from:

- infrastructure code/templates;
- Installation manifests/config;
- protected secrets;
- accepted artifacts;
- backups/data;
- DNS/traffic configuration.

## Small-node discipline

Do not deploy heavyweight observability/platform components onto small dedicated nodes unless resource/risk needs justify them.

Prefer lightweight agents/remote monitoring.

## Validation

Infrastructure changes require targeted validation appropriate to the changed layer.

Before production activation or server cutover validate at least:

- SSH/firewall exposure;
- Docker/runtime state;
- ingress/TLS;
- private internal services;
- persistent storage;
- backups;
- monitoring/alerts;
- application health after deployment;
- exact artifact/version identity.

Do not perform destructive security testing against production without explicit approval.

## Scope and Git

Do not mix application feature work into this repository.

Do not create per-client permanent branches.

Do not deploy, switch DNS, decommission servers, or mutate production infrastructure unless the current task explicitly authorizes that gate.

STOP for human approval at production/cutover/decommission boundaries.

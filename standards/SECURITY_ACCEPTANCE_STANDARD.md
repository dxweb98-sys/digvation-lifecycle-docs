# Digvation Security Acceptance Standard

> Architecture note: POS-specific security checks remain valid for the POS domain, but current application boundaries are Backoffice/Operational plus authoritative business-domain runtimes as defined in `ECOSYSTEM_ARCHITECTURE.md`.

This standard defines the minimum security gates for Digvation products, applications, APIs, infrastructure, and production releases.

Security acceptance is risk-based.

A small UI change does not require a full penetration test.
A first public production release or major auth/tenant/payment/network change requires much stronger validation.

## 1. Security ownership

Security is shared across:

- application code;
- dependencies;
- containers;
- server/network configuration;
- secrets;
- data isolation;
- CI/CD;
- deployment;
- operational monitoring.

Passing application unit tests alone is not security acceptance.

## 2. Security validation levels

### Level A — implementation security checks

During active implementation, use targeted checks when a task changes:

- authentication/session;
- authorization/RBAC;
- tenant isolation;
- money/payment;
- input/file handling;
- secrets/crypto;
- public API trust boundary;
- migrations/data access.

Do not run broad security suites for unrelated presentation-only edits.

### Level B — release security gate

Every production Release Candidate should perform applicable automated/static security checks:

- dependency/SCA vulnerability scan;
- secret scan;
- container image vulnerability scan;
- static security analysis/lint where supported;
- production configuration review;
- TLS/HTTP security checks;
- authentication/authorization regression checks;
- tenant-isolation checks;
- database/network exposure checks.

### Level C — penetration/security assessment

Perform a deeper manual/automated security assessment:

- before the first public production release of a product;
- after material authentication/session redesign;
- after material tenant-isolation redesign;
- after material payment/financial exposure change;
- after major network/ingress/infrastructure redesign;
- after a major version with meaningful attack-surface change;
- periodically for internet-facing production systems based on risk.

An independent external pentest is strongly preferred for higher-risk/public systems when budget permits.

## 3. Vulnerability acceptance

Production release is blocked by:

- unresolved Critical vulnerabilities that affect the deployed system;
- unresolved High vulnerabilities with a credible exploitation path;
- known authentication/authorization bypass;
- known cross-tenant data exposure;
- exposed production secrets;
- publicly exposed database/admin ports without an explicitly approved architecture;
- broken TLS for required public endpoints;
- unverified destructive migration/data-loss risk.

A High finding may only be accepted temporarily through explicit documented human risk acceptance with:

- owner;
- reason;
- compensating control;
- remediation deadline.

Medium/Low findings must be triaged and tracked when relevant.

Do not hide findings to obtain a green release.

## 4. Application security checklist

Applicable internet-facing applications/APIs should verify:

- authentication works as designed;
- session/token expiration/revocation works;
- account recovery/invitation flow cannot trivially escalate access;
- authorization denies unauthorized actions;
- OWNER/protected roles follow product rules;
- tenant boundaries prevent cross-tenant read/write;
- selling-location scope cannot be bypassed where relevant;
- input validation rejects malformed/untrusted data;
- output/errors do not leak stack traces/secrets;
- CORS/cookie/security headers are appropriate;
- rate limiting/abuse protection exists on high-risk endpoints where needed;
- file upload/download behavior is safe if present;
- SSRF/path traversal/injection risks are considered where applicable;
- SQL access remains parameterized/ORM-safe;
- logs do not contain credentials/tokens;
- password/credential storage uses accepted secure hashing;
- cryptographic keys/secrets are not source-controlled.

## 5. POS-specific security acceptance

For POS, explicitly validate:

- POS user cannot access another tenant;
- role/permission enforcement is server-side;
- browser-hidden actions are not treated as authorization;
- SellingLocation scope cannot be changed through arbitrary request parameters;
- payment state cannot be forged by frontend state;
- PENDING payment is not treated as collected;
- receipt/report access respects tenant/location permissions;
- employee contribution/report queries cannot cross tenant boundaries;
- admin/Backoffice actions use correct permissions;
- Cashier and Backoffice cannot bypass the POS backend to reach CORE directly.

## 6. Infrastructure/network security

Before production:

- SSH password auth disabled where standard requires;
- root SSH disabled;
- firewall default deny inbound;
- only intended public ports exposed;
- database/internal services not internet-exposed;
- TLS valid and trusted;
- certificate renewal path works;
- reverse proxy admin/dashboard not publicly exposed without protection;
- secrets have restrictive permissions;
- containers do not run privileged without explicit need;
- unused services/ports disabled;
- host/container security updates are reasonably current;
- backups are protected;
- monitoring detects service/restart/storage/backup failures.

## 7. Dependency and supply-chain security

At release:

- lockfiles are present and respected;
- dependency vulnerabilities are scanned;
- container base images are scanned;
- CI uses trusted actions/images and pinned versions where practical;
- production artifact source SHA is known;
- image/artifact digest is known where supported;
- secrets are not printed to CI logs;
- registry access uses least privilege.

Do not update dependencies blindly during an unrelated release merely to achieve zero findings; remediation should remain controlled and testable.

## 8. Secrets scan

Before first production and in release CI where possible, scan for:

- passwords;
- bearer tokens;
- API keys;
- private keys;
- database URLs;
- provider secrets;
- cloud credentials.

False positives may be suppressed only with an explainable rule.

A real committed production secret must be rotated, not merely deleted from the latest file.

## 9. DAST / runtime security checks

Against staging/equivalent, perform appropriate runtime checks such as:

- TLS/HTTPS validation;
- security headers;
- unauthenticated endpoint probing;
- auth/session boundary checks;
- common injection/error behavior;
- access-control checks;
- route exposure;
- basic automated DAST for internet-facing web/API systems when practical.

Do not run destructive scanners against production without explicit authorization.

## 10. Penetration test scope

A meaningful pentest should cover the real attack surface:

- public frontend(s);
- public API;
- authentication/session;
- authorization/RBAC;
- tenant isolation;
- business-logic abuse;
- password recovery/invitation;
- high-risk financial/payment flows;
- file handling if present;
- exposed infrastructure endpoints;
- API rate/abuse behavior.

For POS dedicated/client-managed deployments, include Installation-specific ingress/network exposure where access is available.

## 11. Backup/recovery security

Security acceptance includes recoverability.

Verify:

- backups are not publicly readable;
- backup credentials are protected;
- offsite copy exists;
- restore is periodically tested;
- operators know recovery responsibilities;
- ransomware/server-loss scenario does not rely on the same host as the only backup.

## 12. Security monitoring

Production monitoring should make high-value security/abuse signals observable when appropriate:

- repeated failed authentication;
- unusual authorization failures;
- service crash/restart;
- unexpected public endpoint failures;
- certificate expiry;
- backup failure;
- disk exhaustion;
- elevated error rate;
- suspicious integration failures.

Do not collect unnecessary sensitive data merely for monitoring.

## 13. First production security gate

Before a product's first public production release:

```text
[ ] application security review complete
[ ] dependency/SCA scan complete
[ ] secret scan complete
[ ] container scan complete
[ ] server/network exposure reviewed
[ ] TLS/HTTPS verified
[ ] auth/RBAC validated
[ ] tenant isolation validated where applicable
[ ] staging DAST/runtime checks completed
[ ] database/private service exposure verified
[ ] backup + restore path verified
[ ] monitoring/alerting verified
[ ] penetration/security assessment completed at appropriate depth
[ ] Critical/High findings resolved or explicitly risk accepted
[ ] human production security approval recorded
```

## 14. Post-deploy security verification

After production deployment:

- verify exact expected artifact/version;
- re-check TLS/hostname;
- confirm no unexpected ports became public;
- confirm auth/login;
- confirm a representative authorized/unauthorized access case;
- confirm tenant/client isolation for a safe representative test;
- verify logs/monitoring;
- verify backup schedule remains active;
- inspect immediate runtime/security errors.

Do not perform destructive pentest activity on production as a routine smoke test.

## 15. Periodic security review

Production security is not permanently accepted after one pentest.

Establish a recurring operational cadence based on risk for:

- OS/container patching;
- dependency vulnerabilities;
- certificate expiry;
- backup restore;
- access/SSH key review;
- secret rotation;
- firewall/port review;
- penetration/security assessment;
- incident response readiness.

As Digvation grows, track these per Installation/component in the operations/control plane.

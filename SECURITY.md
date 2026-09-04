# Security Policy

## Reporting a Vulnerability

Report security vulnerabilities via [GitHub Security Advisories](https://github.com/CodeSigils/zola-skill/security/advisories/new). Do not use issues or email.

## Supported Versions

Only the latest release on the `main` branch receives security updates.

## Repo-Specific Concerns

This repository ships a single methodology skill file (`skills/zola/SKILL.md`) and its supporting workflow/reference markdown files. No runtime scripts, binaries, or dependencies are shipped. Security concerns for this repo are limited to:

- Malicious modifications to the skill methodology that could mislead users into unsafe practices
- Supply chain integrity of the skill payload itself (the markdown files under `skills/zola/`)
- CI workflow integrity (GitHub Actions)

This repo does **not** contain:
- Credentials, secrets, or API keys
- Test fixtures with sensitive data
- Runtime code that executes on user machines
- Network-facing services

## Public vs Private Reporting

- **Public** (GitHub Security Advisory): Preferred for all vulnerability reports. The advisory will be published after triage.
- **Private**: Not required for this repo since no sensitive infrastructure or user data is involved.

## Shipped Payload Description

The runtime payload is the `skills/zola/` directory containing:
- 1 SKILL.md frontmatter + markdown body
- 5 workflow markdown files
- 6 reference markdown files

Total: 12 markdown files, ~150KB. No scripts, no config files, no dependencies. Users copy only `skills/zola/` to their agent's skill directory.

## Last Reviewed

Last reviewed: 2026-09-04.

## CI Requirements

This repo enforces documentation and portability checks via CI. The SECURITY.md must preserve these literal substrings for CI validation:
- `skills/zola/` — shipped payload path
- `no runtime scripts` — payload boundary
- `GitHub Security Advisories` — reporting channel

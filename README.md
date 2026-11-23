# Zola Skill

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![agentskills.io](https://img.shields.io/badge/agentskills.io-v1-blue)](https://agentskills.io/specification)
[![skills.sh](https://skills.sh/b/codesigils/zola-skill)](https://skills.sh/codesigils/zola-skill)

**Zola Skill** — A reusable skill for Zola static-site-generator and Tera template work. Provides debug-build, repository-layout diagnosis, post authoring/editorial review, i18n, site modification/review, minimal site creation, and bounded existing-theme override workflows with version-aware diagnosis and minimal fixes.

Load `zola` when you need to diagnose build failures, configure a multilingual site,
review or modify an existing Zola/Tera project, or create a minimal site from scratch.
It begins with the canonical [Shared inspect-first method](skills/zola/SKILL.md#shared-inspect-first-method): confirm scope/authority, inspect the target Zola repo, frame one affected outcome, load one conditional workflow/reference delta with point-of-use source-registry evidence, then make the smallest coherent change and validate with Zola-appropriate boundaries. Routed workflows and references are topic-specific deltas, not replacements for inspection or delivery boundaries.

The shipped payload is one portable skill directory with no agent-specific
runtime commands or paths, so it works with any terminal-capable coding agent.
It is agentskills.io-compatible.

Repository commits follow a `what:`/`why:` body policy, checked in
the commit-message workflow, and the commit history is the repository's
canonical change record. This repository keeps no
`CHANGELOG.md`: the git log holds the change history, research and decision
notes hold detailed rationale, and `docs/roadmap.md` tracks progress and records
each completed phase.

Reviewers treat repeated semantic values—such as versions, runners, paths, and
SHAs—as possible duplication or drift smells. Centralization is recommended
only when the values should change together and the trade-off improves clarity.

**Distribution:** `main` is the canonical install/update path for this living
skill payload. Immutable tags are optional milestone/audit markers (not
required for every change): `v1.0.0` (`6b279b3`, checked 2026-10-13) and
`v1.0.1` (`95f046d`) record validated payload milestones (including the Codex
and Claude Code copied-package smoke matrix with Skills CLI 1.7.2 for
`v1.0.0`). Hermes external-directory setup is documented but not part of the
verification matrix.

---

## Quick Start

Make the skill discoverable by your agent.

<details>
<summary><b>Hermes Agent</b></summary>

**Recommended for development — clone the repo and add to `external_dirs`:**
```yaml
skills:
  external_dirs:
    - /path/to/zola-skill/skills
```
This loads the skill directly from the repo — every commit is immediately reflected
without reinstalling.

**For end users — clone the repository:**
```bash
git clone https://github.com/CodeSigils/zola-skill.git
```

The skill is not currently indexed by Hermes Skills Hub under
`CodeSigils/zola-skill`. After cloning, use the `external_dirs` setup above
until a hub identifier is published and verified.

*Other agents: see sections below for their native setup commands.*
</details>

<details>
<summary><b>Claude Code</b></summary>

```bash
cp -r skills/* "$HOME/.claude/skills/"
```
</details>

<details>
<summary><b>Codex CLI</b></summary>

```bash
cp -r skills/* .agents/skills/
```
</details>

<details>
<summary><b>Gemini CLI / .agents/ path</b></summary>

```bash
cp -r skills/* .agents/skills/
```
</details>

<details>
<summary><b>OpenCode</b></summary>

```bash
cp -r skills/* "$HOME/.config/opencode/skills/"
```
</details>

For agents that support external skill directories, point the config at
`skills/` for live-updating access.

---

## How to Use

Load `zola` when you have a Zola-related task. The skill classifies your request
and routes to the appropriate workflow:

| Trigger | Workflow |
|---|---|
| "Create a new Zola site" | Minimal site creation |
| "Zola build failed" / template error | Debug-build diagnosis and fix |
| "Configure multilingual" / i18n setup | Static i18n configuration |
| "Review / modify existing Zola site" | Modification/review workflow |
| "Override one theme template" | Bounded theme override |
| "Draft/edit a post in this Zola site" | Bounded post authoring |
| "Review this Zola article's claims and links" | Bounded editorial review |

The skill reads version-aware source registries and reference documents to ensure
diagnosis and fixes align with the Zola version in use.

---

## Skill Payload — What Ships to the User

Only the `skills/` directory ships to an agent. It contains the skill definition,
workflows, and reference documents.

```text
skills/
└── zola/
    ├── SKILL.md                         # canonical shared inspect-first method + routing
    ├── scripts/
    │   └── check_runtime_contract.py    # deterministic runtime contract guard
    ├── workflows/
    │   ├── author-post.md               # explicit existing-site post authoring
    │   ├── create-site.md               # minimal site creation
    │   ├── debug-build.md               # build/template failure diagnosis
    │   ├── i18n.md                      # static multilingual configuration
    │   ├── modify-review.md             # existing-site modification/review
    │   └── theme-override.md            # bounded existing-theme override
    └── references/
        ├── source-registry.md           # point-of-use official source registry
        ├── release-review.md            # pre-release static-site review
        ├── accessibility-review.md      # template accessibility review
        ├── content-model.md             # content structure and front-matter
        ├── tera-template-context.md     # Tera template constructs and escaping
        └── editorial-review.md          # bounded article-quality review
```

What users receive:

- agentskills.io `name` and `description` frontmatter in the skill;
- inline workflow routing with no deferred rule files;
- version-aware diagnosis based on Zola source registry; and
- deterministic runtime contract checks for the shared inspect-first routing
  method (`skills/zola/scripts/check_runtime_contract.py`), plus repository
  maintainer validation outside the installed runtime payload; and
- no runtime dependencies, test fixtures, or generated output.

Copy the complete `skills/` directory to preserve workflow and reference discovery.
Everything outside it is repository-only development infrastructure.

---

## Security Model

The skill operates on user-authorized site directories. All file operations occur
within the user's project scope. The skill does not transmit site content to
external services except for live Zola documentation during diagnosis.

Repository disclosure policy and trust boundaries are documented in
[SECURITY.md](SECURITY.md).

---

## What the Skill Does Not Handle

The skill is scoped to Zola static-site work. It does **not** handle:

- Full theme authoring
- Deployment pipelines or hosting setup
- Automatic content translation
- Browser locale detection
- Search indexing
- Generic blog-post writing, editorial rules not present in the target
  repository, or publishing automation

Pair it with a deployment skill for those capabilities.

---

## Maintainer verification

The commit-message workflow checks the commits introduced by a push or pull
request. For runtime routing/contract changes, also run the deterministic
shared inspect-first contract guard:

```bash
python3 skills/zola/scripts/check_runtime_contract.py --self-test
python3 skills/zola/scripts/check_runtime_contract.py
python3 scripts/check_commit_messages.py HEAD
```

`docs/evals/shared-inspect-first-routing.md` contains manual behavioral review
scenarios; structural contract checks do not replace them. Pass a commit range
such as `HEAD~5..HEAD` to check several commits. See
[AGENTS.md](AGENTS.md#commit-message-contract) for the message contract and
[the release checklist](docs/release-checklist.md) for release verification.

---

## See Also

- [AGENTS.md](AGENTS.md) — Repository instructions and documentation contract
- [Planning Documentation](docs/README.md) — Design source of truth
- [Skill Specification](skills/zola/SKILL.md) — Runtime skill definition
- [SECURITY.md](SECURITY.md) — Security policy and reporting

---

## License

MIT — see [LICENSE](LICENSE).

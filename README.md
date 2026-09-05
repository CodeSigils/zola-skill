# Zola Skill

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![agentskills.io](https://img.shields.io/badge/agentskills.io-v1-blue)](https://agentskills.io/specification)
[![skills.sh](https://skills.sh/b/codesigils/zola-skill)](https://skills.sh/codesigils/zola-skill)

**Zola Skill** — A reusable skill for Zola static-site-generator and Tera template work. Provides debug-build, repository-layout diagnosis, post authoring/editorial review, i18n, site modification/review, minimal site creation, and bounded existing-theme override workflows with version-aware diagnosis and minimal fixes.

Load `zola` when you need to diagnose build failures, configure a multilingual site,
review or modify an existing Zola/Tera project, or create a minimal site from scratch.
It routes to the appropriate workflow and reference documentation automatically.

The shipped payload is one file — no agent-specific commands or paths — so it works
with any terminal-capable coding agent. It is agentskills.io-compatible.

**Compatibility status:** Codex and Claude Code are verified through the
published-package smoke matrix. Hermes external-directory setup is documented
but not part of that matrix.

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
cp -r skills/* ~/.claude/skills/
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
cp -r skills/* ~/.config/opencode/skills/
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
    ├── SKILL.md                         # skill router and workflow routing
    ├── workflows/
    │   ├── author-post.md               # explicit existing-site post authoring
    │   ├── create-site.md               # minimal site creation
    │   ├── debug-build.md               # build/template failure diagnosis
    │   ├── i18n.md                      # static multilingual configuration
    │   ├── modify-review.md             # existing-site modification/review
    │   └── theme-override.md            # bounded existing-theme override
    └── references/
        ├── source-registry.md           # official source versions
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
- no runtime scripts, configuration files, dependencies, test fixtures, or
  maintainer-only validation tooling.

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

## See Also

- [AGENTS.md](AGENTS.md) — Repository instructions and documentation contract
- [CHANGELOG.md](CHANGELOG.md) — Version history
- [Planning Documentation](docs/README.md) — Design source of truth
- [Skill Specification](skills/zola/SKILL.md) — Runtime skill definition
- [SECURITY.md](SECURITY.md) — Security policy and reporting

---

## License

MIT — see [LICENSE](LICENSE).

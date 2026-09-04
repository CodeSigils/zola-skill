# Zola Skill

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![agentskills.io](https://img.shields.io/badge/agentskills.io-compatible-blue)](https://agentskills.io/specification)

**Zola Skill** — A reusable skill for Zola static-site-generator and Tera template work. Provides debug-build, i18n, site modification/review, minimal site creation, and bounded existing-theme override workflows with version-aware diagnosis and minimal fixes.

- Diagnose and repair Zola build, template, and configuration failures
- Configure static multilingual (i18n) sites with language-aware URLs
- Review or make authorized changes to existing Zola/Tera sites
- Create minimal Zola sites from scratch
- Override a single verified existing-theme template safely

It does **not** handle full theme authoring, deployment, automatic translation, browser locale detection, or search indexing. Pair it with a deployment skill for that.

The shipped payload is one file — no agent-specific commands or paths — so it works with any terminal-capable coding agent. It is agentskills.io-compatible.

**Compatibility status:** Hermes Agent 0.4.x is the only verified agent target.

---

## Project Structure

```text
├── AGENTS.md             # Cold-landing agent orientation
├── README.md             # This file
├── SECURITY.md           # Security policy and reporting
├── LICENSE               # MIT license
├── .gitignore            # Excludes agent tooling and build artifacts
├── .gitattributes        # Git attributes
├── docs/                 # Maintainer documentation
│   ├── README.md         # Planning documentation index
│   ├── vision.md         # Durable scope and acceptance criteria
│   ├── roadmap.md        # Phased delivery plan
│   ├── research.md       # External evidence and architecture decisions
│   ├── future-capabilities.md  # Deferred capability guidance
│   └── release-checklist.md    # Versioned public-release verification
└── skills/zola/
    ├── SKILL.md          # The entire skill — one file
    ├── workflows/
    │   ├── create-site.md       # Minimal site creation
    │   ├── debug-build.md       # Build/template failure diagnosis
    │   ├── i18n.md              # Static multilingual configuration
    │   ├── modify-review.md     # Existing-site modification/review
    │   └── theme-override.md    # Bounded existing-theme override
    └── references/
        ├── source-registry.md       # Official source versions
        ├── release-review.md        # Pre-release static-site review
        ├── accessibility-review.md  # Template accessibility review
        ├── content-model.md         # Content structure and front-matter
        └── tera-template-context.md # Tera template constructs and escaping
```

## See Also

- [AGENTS.md](AGENTS.md) — Repository instructions and documentation contract
- [Planning Documentation](docs/README.md) — Design source of truth
- [Skill Specification](skills/zola/SKILL.md) — Runtime skill definition

## License

MIT — see [LICENSE](LICENSE).

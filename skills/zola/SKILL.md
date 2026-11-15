---
name: zola
description: Create a minimal Zola site; diagnose Zola/Tera build, layout, template, configuration, or static multilingual (i18n) failures; or make an authorized existing-site, post-authoring, or bounded-theme change/review. Use for explicit Zola content authoring or editorial review in an existing site; not general writing, CMS, backend, or full theme authoring.
license: MIT
metadata:
  compatibility: "Requires filesystem and shell access; Zola required for build validation; network needed only for live documentation and external link validation."
  about: "A reusable skill for Zola static-site-generator and Tera template work. Provides debug-build, i18n, site modification/review, minimal site creation, and bounded existing-theme override workflows with version-aware diagnosis and minimal fixes."
  keywords:
    - zola
    - tera
    - static-site-generator
    - debug-build
    - i18n
    - template
    - frontmatter
    - content-model
    - post-authoring
    - editorial-review
    - accessibility
  version: "0.23.4"
  maintainers:
    - Project maintainers
  repository: "CodeSigils/zola-skill@zola"
---

# Zola

Use this skill only for minimal site creation, debug-build (including an
observed submodule or symlinked repository layout), static multilingual,
explicit existing-site post authoring/editorial review, existing-site
modification/review, and bounded existing-theme override
workflows. If explicitly invoked for theme selection, full theme authoring,
deployment, automatic translation, browser locale detection, search indexing,
generic writing, CMS work, or automatic publishing, say that mode is not
implemented; do not substitute generic advice.

## Diagnose first

1. Classify the failure and preserve the user's requested authorization: for a
   diagnosis request, propose a patch; apply a minimal patch only when asked.
2. Inspect the supplied error and relevant repository evidence: `zola.toml` or
   `config.toml`, templates/content involved, theme relationship, dependencies,
   existing commands, and configured `output_dir`.
   Notice repeated semantic values in CI, scripts, repository Python, and
   documentation as possible duplication or drift smells. Recommend
   centralization only when the values should change together and the benefit
   outweighs the loss of local clarity; do not mechanically extract examples or
   prose.
3. Run `zola --version` if available. If it is unavailable or differs from the
   fixture version, state that limitation and do not claim unverified
   version-specific behavior.
4. Route by request and load references conditionally (opt in to only the files
   needed):
   - **New minimal site:** [creation workflow](workflows/create-site.md).
   - **Build/template/config/content failure:** [debug-build workflow](workflows/debug-build.md);
     for i18n/language/translated-route failures also read [i18n workflow](workflows/i18n.md).
   - **Existing-site change or review:** [modification/review workflow](workflows/modify-review.md);
     for one verified existing-theme template override read [theme override workflow](workflows/theme-override.md).
   - **Substantive post drafting, revision, or article-quality review** in an
     existing site (editorial work beyond a light metadata/taxonomy/front-matter
     correction): read [post-authoring workflow](workflows/author-post.md) and
     [content-model reference](references/content-model.md) before writing or
     changing prose, and read [editorial-review reference](references/editorial-review.md)
     before substantive drafting/revision/review. Treat the target repository's
     editorial rules and the user's instruction as authoritative for voice,
     claims, and form; this skill supplies mechanics, structure checks, and
     Zola-aware validation, never invented experience, facts, sources, or house
     style. A light non-substantive edit may stay scoped to the relevant
     workflow/reference without a full editorial pass.
   - **Explicit pre-release static-site review:** also read [release-review reference](references/release-review.md).
   - **Accessibility review** (content, media, templates, generated pages, CSS,
     or theme overrides): also read [accessibility-review reference](references/accessibility-review.md).
   - **Authorized content-structure/front-matter/route/co-located asset/disclosure
     change:** also read [content-model reference](references/content-model.md).
   - **Tera construct, auto-escaping, or undefined/missing variable** during
     build/render/escaping review: read [Tera template-context reference](references/tera-template-context.md).
   Consult the matching official entry in [the source registry](references/source-registry.md)
   before relying on version-sensitive behavior.
5. Report the likely cause, concrete evidence, smallest safe repair, competing
   hypothesis where relevant, and exact validation commands.

## Validation rules

Before any build, inspect project output handling. Do not add `--force` by
default. For a fixture or other safe isolated run, use `--output-dir` with a
new empty directory. Validate with `zola check --skip-external-links` and
`zola build`; explain that the former omits external Markdown-link coverage.
Run a rendered-page smoke check for template changes when the repository makes
one feasible. Preserve escaping: `safe` is not a generic fix. When an
authorized edit leaves a focused, validated Git diff, identify it as ready to
commit and offer that next step; do not infer authorization to commit, push,
open a pull request, publish, or deploy.

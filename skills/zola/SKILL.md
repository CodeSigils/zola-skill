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

## Shared inspect-first method

Use this method before acting on a routed workflow or reference. Treat routed
workflow/reference files as topic-specific deltas, not replacements for this
method.

1. **Scope and authority.** Confirm the request is in scope (minimal site
   creation, debug-build including observed submodule/symlinked layout, static
   multilingual/i18n, explicit existing-site post authoring/editorial review,
   existing-site modification/review, or bounded existing-theme override). For
   unsupported modes (theme selection, full theme authoring, deployment,
   automatic translation, browser locale detection, search indexing, generic
   writing, CMS work, automatic publishing), say the mode is not implemented;
   do not substitute generic advice. Preserve requested authorization: for a
   diagnosis request, propose a patch; apply a minimal patch only when asked.
   Do not infer authorization to commit, push, open a pull request, publish,
   or deploy.
2. **Bounded target scan.** Inspect the supplied error and relevant repository
   evidence: `zola.toml` or `config.toml`, templates/content involved, theme
   relationship, dependencies, existing commands, and configured `output_dir`.
   Run `zola --version` if available. If unavailable or different from the
   fixture/target version, state that limitation and do not claim unverified
   version-specific behavior. Notice repeated semantic values as possible
   duplication/drift smells; recommend centralization only when values should
   change together and benefit outweighs local clarity.
3. **Frame one affected outcome.** Identify the likely cause, concrete evidence,
   smallest safe repair, and competing hypothesis where relevant. State when a
   version-sensitive or external claim is unverified against the current source
   or target version.
4. **Reuse target records, then load one conditional delta.** Load only the
   references/workflows needed for the active task (opt-in, point-of-use).
   Before relying on version-sensitive behavior or external source-backed
   claims, consult the matching row in
   [the source registry](references/source-registry.md) and the current
   official source it names. Treat registry URLs and "Verified date" values as
   time-sensitive evidence; recheck when volatile, version/config differs, or
   on explicit verification. If unavailable/unverifiable, report bounded
   uncertainty. Do not cache or paraphrase external snippets as current fact.
   Route by request:
   - **New minimal site:** [creation workflow](workflows/create-site.md).
   - **Build/template/config/content failure:** [debug-build workflow](workflows/debug-build.md);
     for i18n/language/translated-route failures also read [i18n workflow](workflows/i18n.md).
   - **Existing-site change or review:** [modification/review workflow](workflows/modify-review.md);
     for one verified existing-theme template override read [theme override workflow](workflows/theme-override.md).
   - **Substantive post drafting, revision, or article-quality review** in an
     existing site (beyond a light metadata/taxonomy/front-matter correction):
     read [post-authoring workflow](workflows/author-post.md) and
     [content-model reference](references/content-model.md) before
     writing/changing prose, and [editorial-review reference](references/editorial-review.md)
     before substantive drafting/revision/review. Treat target repository
     editorial rules and user instruction as authoritative for voice, claims,
     and form; supply mechanics, structure checks, and Zola-aware validation,
     never invented experience, facts, sources, or house style. A light
     non-substantive edit may stay scoped without a full editorial pass.
   - **Explicit pre-release static-site review:** [release-review reference](references/release-review.md).
   - **Accessibility review:** [accessibility-review reference](references/accessibility-review.md).
   - **Authorized content-structure/front-matter/route/co-located asset/disclosure change:** [content-model reference](references/content-model.md).
   - **Tera construct, auto-escaping, or undefined/missing variable:** [Tera template-context reference](references/tera-template-context.md).
5. **Smallest coherent change, then validate and handoff.** Make the smallest
   safe repair. Before any build, inspect project output handling. Do not add
   `--force` by default. For a fixture or other safe isolated run, use
   `--output-dir` with a new empty directory. Validate with
   `zola check --skip-external-links` and `zola build`; explain that
   `zola check --skip-external-links` omits external Markdown-link coverage.
   Run a rendered-page smoke check for template changes when feasible. Preserve
   escaping: `safe` is not a generic fix. Report exact validation commands and
   outcomes. A clean `zola check --skip-external-links` or `zola build`
   verifies generation in the tested context; a rendered smoke check verifies
   affected presentation; neither verifies publication, deployment, hosting, or CDN behavior.
   Clean local generation is not publication or deployment proof
   unless separately authorized and checked. When an authorized edit leaves a
   focused, validated Git diff, identify it as ready to commit and offer that
   next step; do not infer authorization to commit, push, open a pull request,
   publish, or deploy.

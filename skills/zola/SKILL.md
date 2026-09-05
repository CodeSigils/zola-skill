---
name: zola
description: Create a minimal Zola site or diagnose, modify, review, or make a bounded existing-theme override for a Zola or Tera site with build, template, configuration, or static multilingual (i18n) failures. Use for Zola site setup, supplied errors, or authorized existing-site changes/reviews; not for general frontend, CMS, backend, or full theme authoring.
license: MIT
compatibility: "Requires filesystem and shell access; Zola required for build validation; network needed only for live documentation and external link validation."
metadata:
  about: "A reusable skill for Zola static-site-generator and Tera template work. Provides debug-build, i18n, site modification/review, minimal site creation, and bounded existing-theme override workflows with version-aware diagnosis and minimal fixes."
  keywords: ["zola", "tera", "static-site-generator", "debug-build", "i18n", "template", "frontmatter", "content-model", "accessibility"]
  version: "0.23.4"
  maintainers: ["Project maintainers"]
  repository: "CodeSigils/zola-skill@zola"
---

# Zola

Use this skill only for minimal site creation, debug-build, static multilingual,
existing-site modification/review, and bounded existing-theme override
workflows. If explicitly invoked for theme selection, full theme authoring,
deployment, automatic translation, browser locale detection, search indexing,
or unrelated web work, say that mode is not implemented; do not substitute
generic advice.

## Diagnose first

1. Classify the failure and preserve the user's requested authorization: for a
   diagnosis request, propose a patch; apply a minimal patch only when asked.
2. Inspect the supplied error and relevant repository evidence: `zola.toml` or
   `config.toml`, templates/content involved, theme relationship, dependencies,
   existing commands, and configured `output_dir`.
3. Run `zola --version` if available. If it is unavailable or differs from the
   fixture version, state that limitation and do not claim unverified
   version-specific behavior.
4. Read [the creation workflow](workflows/create-site.md) for a new minimal
   site, [the debug-build workflow](workflows/debug-build.md) for a build or
   template failure, [the i18n workflow](workflows/i18n.md) for language
   configuration, translated content, or language-aware URL failures, or [the
   modification/review workflow](workflows/modify-review.md) for an existing
   site's authorized change or review, or [the theme override
   workflow](workflows/theme-override.md) for one verified existing-theme
   template override. For an explicitly requested pre-release static-site
   review, also read [the release-review reference](references/release-review.md).
   For an explicitly requested existing-template accessibility review, read
   [the accessibility-review reference](references/accessibility-review.md).
   For an authorized content-structure, front-matter, route, or co-located
   asset change, read [the content-model reference](references/content-model.md).
   When interpreting a Tera template construct, its auto-escaping, or an
   undefined/missing variable during a build, rendering, or escaping review,
   read [the Tera template-context
   reference](references/tera-template-context.md). Consult the matching
   official entry in [the source registry](references/source-registry.md)
   before relying on version-sensitive behavior.
5. Report the likely cause, concrete evidence, smallest safe repair, competing
   hypothesis where relevant, and exact validation commands.

## Validation rules

Before any build, inspect project output handling. Do not add `--force` by
default. For a fixture or other safe isolated run, use `--output-dir` with a
new empty directory. Validate with `zola check --skip-external-links` and
`zola build`; explain that the former omits external Markdown-link coverage.
Run a rendered-page smoke check for template changes when the repository makes
one feasible. Preserve escaping: `safe` is not a generic fix.

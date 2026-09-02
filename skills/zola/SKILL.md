---
name: zola
description: Diagnose, modify, or review an existing Zola or Tera site for build, template, configuration, or static multilingual (i18n) failures. Use for supplied Zola errors or authorized existing-site changes/reviews; not for general frontend, CMS, backend, site-creation, or theme-authoring work.
license: MIT
compatibility: Requires filesystem and shell access. Zola is required for build validation; network access is needed only to check live documentation or external Markdown links.
---

# Zola

Use this skill only for debug-build, static multilingual, and existing-site
modification/review workflows. If explicitly invoked for site creation, theme
authoring, deployment, automatic translation, browser locale detection, search
indexing, or unrelated web work, say that mode is not implemented; do not
substitute generic advice.

## Diagnose first

1. Classify the failure and preserve the user's requested authorization: for a
   diagnosis request, propose a patch; apply a minimal patch only when asked.
2. Inspect the supplied error and relevant repository evidence: `zola.toml` or
   `config.toml`, templates/content involved, theme relationship, dependencies,
   existing commands, and configured `output_dir`.
3. Run `zola --version` if available. If it is unavailable or differs from the
   fixture version, state that limitation and do not claim unverified
   version-specific behavior.
4. Read [the debug-build workflow](workflows/debug-build.md) for a build or
   template failure, [the i18n workflow](workflows/i18n.md) for language
   configuration, translated content, or language-aware URL failures, or [the
   modification/review workflow](workflows/modify-review.md) for an existing
   site's authorized change or review. Consult the matching official entry in
   [the source registry](references/source-registry.md) before relying on
   version-sensitive behavior.
5. Report the likely cause, concrete evidence, smallest safe repair, competing
   hypothesis where relevant, and exact validation commands.

## Validation rules

Before any build, inspect project output handling. Do not add `--force` by
default. For a fixture or other safe isolated run, use `--output-dir` with a
new empty directory. Validate with `zola check --skip-external-links` and
`zola build`; explain that the former omits external Markdown-link coverage.
Run a rendered-page smoke check for template changes when the repository makes
one feasible. Preserve escaping: `safe` is not a generic fix.

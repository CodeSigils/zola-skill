# Changelog

This changelog records notable changes on `main`; this repository does not use
GitHub Releases or semver tags as a distribution requirement. `SKILL.md`
declares no skill self-version; `metadata.version` is the pinned Zola tool
version the skill is validated against, not a skill release number. Existing
`phase-1`..`phase-5` tags are historical roadmap milestones, not a policy for
future releases.

## [Unreleased]

- Added: cross-references between review reference workflows in
  accessibility-review.md, content-model.md, editorial-review.md,
  release-review.md, and tera-template-context.md
- Changed: editorial-review.md standardized severity classifications
  (blocker/warning/note) with explicit definitions
- Changed: related review workflow sections added to all reference files
  for improved discoverability and consistency
- Added: editorial-review-site fixture exercising bounded article-quality review
  with evidence gaps, broken links, and ambiguous claims.
- Added: opt-in existing-site post authoring, editorial-quality review,
  disclosure-aware content-model guidance, and submodule/symlink layout
  diagnosis, with repository-layout and authoring fixtures.
- Changed: `compatibility` moved from a nested `metadata` object to the
  top-level Agent Skills spec field in `skills/zola/SKILL.md`.
- Changed: release policy records changes on `main` without requiring a GitHub
  Release or semver tag; no inline skill self-version.

## [phase-5] - 2026-09-04

- Added: bounded references for existing-site work — release-review,
  accessibility-review, content-model, and Tera template-context.
- Changed: skill step 4 and the workflows route template-context questions to
  the new Tera reference instead of generic web-frontend advice.

## [phase-4] - 2026-09-03

- Added: taxonomy/pagination and unsafe-`safe` review fixtures and coverage.

## [phase-3] - 2026-09-02

- Added: core workflows — existing-site modification/review, minimal site
  creation, extended debug/build coverage, and bounded theme override.

## [phase-2] - 2026-09-02

- Added: static multilingual (i18n) workflow with language-aware routing.

## [phase-1] - 2026-09-02

- Added: initial debug-build vertical slice skill.

# Changelog

Versioning follows the agent-skill ecosystem convention: releases are recorded
as git tags plus this changelog. `SKILL.md` frontmatter declares no skill
self-version; `metadata.version` is the pinned Zola tool version the skill is
validated against, not a skill release number. Tags `phase-1`..`phase-5` mark
the roadmap phase deliveries; future releases use semver `v*` tags.

## [Unreleased]

- Added: opt-in existing-site post authoring, editorial-quality review,
  disclosure-aware content-model guidance, and submodule/symlink layout
  diagnosis, with repository-layout and authoring fixtures.
- Changed: `compatibility` moved from a nested `metadata` object to the
  top-level Agent Skills spec field in `skills/zola/SKILL.md`.
- Changed: versioning convention recorded — release versioning via git tags
  and this changelog; no inline skill self-version.

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

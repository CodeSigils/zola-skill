# Zola Skill Vision

**Status:** Phase 3 in progress — modification/review, site-creation, and extended debug/build slices
**Audience:** Skill maintainers and contributors  
**Owner:** Project maintainers  
**Review cadence:** Before a release, after a Zola upgrade, or every six months  
**Last reviewed:** 2026-09-02

## Purpose

`zola` is a reusable skill for work on Zola static sites and Tera templates. It
helps an agent explain, create, modify, review, diagnose, and validate Zola
projects without treating generic frontend, CMS, backend, or deployment work as
Zola work by default.

The skill's job is to improve decisions and execution, not to duplicate the
Zola manual. It must keep version-sensitive facts in official sources and load
only the workflow/reference needed for the task.

## Boundaries

The skill must:

- Inspect the repository and installed Zola version before giving
  version-sensitive advice or modifying a project.
- Prefer official Zola documentation, then official Zola source/release notes,
  then official Tera documentation. Clearly label observed theme patterns and
  design preferences as such.
- Preserve an existing project's architecture unless a concrete problem
  justifies a change.
- Prefer semantic HTML, CSS, Zola/Tera, front matter, and build-time work
  before browser JavaScript, external services, Rust tooling, or WASM.
- Give recommendation, reason, trade-off, and validation step for material
  choices.
- State assumptions and uncertainty instead of inventing configuration keys,
  Tera syntax, CLI flags, or platform behavior.

The skill must not:

- Act as a general frontend, CMS, backend, security, or cloud-platform skill.
- Add a framework, bundler, service, or client-side runtime without a stated
  need and maintenance rationale.
- Treat theme code or community examples as authoritative Zola behavior.
- Use `| safe` as a generic rendering fix, or weaken escaping without a
  source-and-context justification.

## Delivery model

The source repository is `zola-skill`. Its canonical, portable implementation
lives at `skills/zola/`, an Agent Skills directory whose name matches the
`zola` skill name. The public skill name is **Zola** (machine identifier
`zola`); `zola-skill` is the repository identity, not a second skill name.
This layout is discoverable by skills.sh and can be
installed into each host agent's own skill location. Do not maintain copies
under `.agents/skills/`, `.claude/skills/`, or other agent-specific directories:
the installer or the host's configuration selects the destination.

The released skill must use the Agent Skills `SKILL.md` contract: YAML
frontmatter with a lowercase, hyphen-safe `name` and a discriminating
`description`, followed by Markdown instructions. Optional host-specific
metadata may be added only when it does not affect the portable workflow. Do
not rely on experimental `allowed-tools` metadata for v1. A public release also
needs an explicit maintainer-selected license; do not declare one until its
terms are present in the repository.

Because the workflow inspects local repositories and runs Zola commands, v1
must declare its real environment requirements in the portable
`compatibility` field: filesystem and shell access are required; Zola is needed
for build validation; network access is needed only for live documentation and
full external-link validation. The wording must not imply that a diagnosis is
impossible when Zola or network access is unavailable.

Planning documents under `docs/` guide maintainers. They are not runtime skill
context. The runtime skill must remain concise and route to conditional
workflow/reference files.

## Implemented workflows: debug, build, and static multilingual confidence

The released skill supports two complete workflows in a local repository:
diagnosing a Zola build or template failure, and diagnosing a static
multilingual configuration, content, or language-aware template-link failure.
It also supports bounded existing-site modification/review and minimal
site-creation workflows. Its discovery description must target those workflows
only; theme authoring requests must not activate automatically.

### Required v1 behavior

1. Classify the request and inspect the relevant repository evidence:
   configuration, content/templates, theme relationship, project build tooling,
   supplied error, and existing checks.
2. Run `zola --version` when available. If it is unavailable, state that as an
   assumption and use only documentation-backed, broadly supported guidance.
3. Consult the relevant official Zola or Tera source for version-sensitive
   behavior.
4. Explain the likely cause, evidence, smallest safe fix, and any competing
   hypothesis. Provide a patch proposal for diagnosis-only requests; apply the
   smallest safe fix only when the request authorizes a fix.
5. Validate the repaired project with the smallest applicable set:
   `zola check`, `zola build`, and a rendered-page smoke check where feasible.
   `zola check` also checks external Markdown links by default. For a local
   template/build diagnosis, `--skip-external-links` is an acceptable
   network-independent validation tier; report that the external-link coverage
   was skipped and run full link validation separately when it is available and
   relevant.
   Before a build, inspect the configured output directory and existing project
   commands. Never add `--force` by default; use an isolated output directory
   for fixtures and preserve project-specific output handling.

### v1 acceptance evidence

- Complete: `tests/fixtures/` provides a valid minimal site and a broken Tera
  template; `tests/run.sh` confirms the expected failure for both `check` and
  isolated `build` under Zola 0.23.4.
- Complete: the non-root `base_url` fixture asserts that generated output keeps
  `/docs/about/`.
- Complete: `tests/scenarios.md` records expected diagnoses, unsafe advice to
  avoid, repair proposals, outcomes, and matching/non-matching prompts.
- Complete: `npx --yes skills-ref validate skills/zola` reported `Valid skill:
  skills/zola` on 2026-09-02.
- Complete: the repository now includes the MIT terms in `LICENSE`, and the
  distributable skill declares `license: MIT`.
- Complete: published-package skills.sh installation smoke tests passed for
  Codex and Claude Code from `CodeSigils/zola-skill@zola`. The exact commands,
  CLI version, paths, and outcomes are recorded in the
  [release checklist](release-checklist.md).

### Phase 2 i18n acceptance evidence

- Complete: `workflows/i18n.md` limits the workflow to static configuration,
  translated content/section files, template translations, and language-aware
  URLs; it excludes translation, locale detection, browser state, and search.
- Complete: `i18n-site` asserts default and French configuration/translation
  values, a French content route, and a `get_url(..., lang=lang)` link beneath
  a non-root `/docs` base URL.
- Complete: `missing-translated-section-index` proves the missing French
  section is not silently substituted when a template requests it, and
  `unauthorized-language-code` asserts that an unconfigured language fails.
- Complete: `tests/scenarios.md` records prompts, evidence, prohibited advice,
  repair proposals, and validation outcomes for all Phase 2 fixtures.

### Phase 3 existing-site modification/review slice

- In progress: `workflows/modify-review.md` distinguishes authorized small
  changes from review-only requests, requires evidence-first inspection, and
  defines the required review-finding format.
- In progress: `existing-site-modification` asserts that a generated link to a
  new content page preserves a non-root `/docs` base URL; `existing-site-review`
  preserves a known hard-coded root-link finding for a non-mutating review.
- In progress: `workflows/create-site.md` limits creation to an explicit new
  directory and a minimal static site; `created-site` asserts the approved
  `zola init` base URL plus rendered title and root content.
- In progress: `workflows/debug-build.md` distinguishes malformed root
  configuration from malformed content front matter; fixtures assert both
  parser failure paths and their minimal syntax-only repairs.
- Complete: the bounded theme research pass records reusable patterns, license
  provenance, maintenance signals, compatibility checks, and nonportable
  assumptions for four theme archetypes in `docs/research.md`.
- Remaining Phase 3 work: a fixture-backed theme workflow that preserves host
  configuration and validates one verified template override.

## Deferred work

Theme authoring/research, deployment patterns, advanced i18n, search,
accessibility/release checklists, JavaScript enhancement, Rust pre-build tools,
WASM, and MCP work are valuable but are **not v1 runtime promises**. Add each
only after a concrete user workflow, evaluation scenario, source evidence, and
maintenance owner exist. i18n is the first planned post-v1 enrichment because
language configuration, translated content paths, template URL generation, and
fallback behavior require a cohesive, testable workflow. It must not promise
machine translation, locale selection, or browser-runtime behavior.

Next, prioritize existing-site modification and review, theme overrides and
inheritance, content-model features (taxonomies, pagination, feeds, and
search), and accessibility/release checks. See
[future capabilities](future-capabilities.md) for JavaScript, Rust, WASM, and
runtime-service guidance.

## Quality rules for all released workflows

- Use a base/template contract, correct URL helpers, explicit data fallbacks,
  and maintainable content structure when those topics are in scope.
- Preserve auto-escaping. Render trusted Zola-generated Markdown deliberately;
  do not apply `safe` to arbitrary text or data.
- Keep primary content and navigation usable without JavaScript.
- Do not claim accessibility, security, SEO, or production readiness without
  naming the checks performed and remaining limits.
- For reviews, report severity, path, evidence, impact, remediation, and
  validation.

## Readiness condition

The skill is ready for release only when its implemented workflow, fixtures,
and validation prove it can make a correct, version-aware diagnosis and minimal
fix. A long reference catalogue or untested plan does not demonstrate
readiness. Each roadmap phase must also pass the mandatory phase-close
documentation gate in [AGENTS.md](../AGENTS.md) and the
[planning documentation index](README.md) before it is reported complete.

## Related documents

- [Roadmap](roadmap.md): delivery sequence and release gates.
- [Research](research.md): source evidence and design rationale.
- [Future capabilities](future-capabilities.md): deferred guidance, not v1
  runtime instructions.
- [Release checklist](release-checklist.md): public-package validation steps.

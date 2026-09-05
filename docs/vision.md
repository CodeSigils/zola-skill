# Zola Skill Vision

**Status:** Phase 5 complete — bounded release, accessibility, content-model, and Tera template-context references delivered. Phase 7 (opt-in content authoring and repository-layout workflows) is complete.
**Audience:** Skill maintainers and contributors  
**Owner:** Project maintainers  
**Review cadence:** Before a release, after a Zola upgrade, or every six months  
**Last reviewed:** 2026-09-05

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
terms are present in the repository. Release versioning follows the ecosystem
convention: git tags plus a changelog; SKILL.md declares no skill self-version,
and `metadata.version` is the pinned Zola tool version the skill is validated
against, not a skill release number.

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
It also supports bounded existing-site modification/review, minimal
site-creation, and existing-theme template-override workflows. Its discovery
description must target those workflows only; theme selection and full theme
authoring requests must not activate automatically.

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

### Phase 3 acceptance evidence

- Complete: `workflows/modify-review.md` distinguishes authorized small
  changes from review-only requests, requires evidence-first inspection, and
  defines the required review-finding format.
- Complete: `existing-site-modification` asserts that a generated link to a
  new content page preserves a non-root `/docs` base URL; `existing-site-review`
  preserves a known hard-coded root-link finding for a non-mutating review.
- Complete: `workflows/create-site.md` limits creation to an explicit new
  directory and a minimal static site; `created-site` asserts the approved
  `zola init` base URL plus rendered title and root content.
- Complete: `workflows/debug-build.md` distinguishes malformed root
  configuration from malformed content front matter; fixtures assert both
  parser failure paths and their minimal syntax-only repairs.
- Complete: the bounded theme research pass records reusable patterns, license
  provenance, maintenance signals, compatibility checks, and nonportable
  assumptions for four theme archetypes in `docs/research.md`.
- Complete: `workflows/theme-override.md` limits work to one verified named
  block in an existing configured theme; `theme-override-site` preserves the
  host config/theme files and proves a non-root generated URL plus overridden
  output.
- Complete: the full fixture suite and `skills-ref validate` passed on
  2026-09-02; Codex and Claude Code published-package installs are recorded in
  the [release checklist](release-checklist.md).
- Next: Phase 4 broader fixture coverage, beginning only with behavior backed
  by an implemented workflow.

### Phase 4 taxonomy/pagination coverage

- Complete: `workflows/modify-review.md` directs an explicitly requested
  taxonomy/pagination change to top-level configuration, matching content front
  matter, and the relevant taxonomy template; it excludes unrelated search,
  feeds, and content-model changes.
- Complete: `taxonomy-pagination-site` asserts a non-root taxonomy term
  route, both first and second pager output, and a `paginator.next` URL beneath
  `/docs` under Zola 0.23.4.

### Phase 4 unsafe-`safe` review coverage

- Complete: `workflows/modify-review.md` distinguishes trusted rendered
  Markdown from arbitrary configuration/data passed through `| safe`; it
  requires a bounded provenance-based finding rather than a generic audit.
- Complete: `unsafe-safe-review` preserves an unescaped
  `config.extra.announcement` value and asserts its generated raw attribute so
  the review evidence remains reproducible under Zola 0.23.4.

### Phase 4 close-gate evidence

- Complete: on 2026-09-03, `ZOLA_BIN=/home/sand/.local/bin/zola tests/run.sh`
  passed under Zola 0.23.4. It covered minimal, theme-override, taxonomy/
  pagination, non-root URL, template/front-matter failure, and unsafe-`safe`
  fixtures; intentional failure cases failed as expected.
- Complete: `npx --yes skills-ref validate skills/zola` reported `Valid skill:
  skills/zola`. Published-package installs for the two Phase 4 skill changes
  passed for Codex and Claude Code at commits `c4fb90d` and `54219d3` and are
  recorded in the [release checklist](release-checklist.md).
- Complete: the documentation index, vision, roadmap, research, source
  registry, release checklist, and affected relative links were re-read and
  verified. `future-capabilities.md` remains intentionally unchanged because
  Phase 4 adds no JavaScript, Rust, WebAssembly, runtime-service, or Zola-core
  guidance.
- Next: Phase 5 may assess focused reference and release-checklist additions
  only where an implemented workflow and maintained source evidence justify
  them.

### Phase 5 bounded release-review reference

- Complete: `references/release-review.md` is discoverable only for an explicit
  pre-release static-site review. It records version/configuration evidence,
  permitted `check` coverage, isolated generated-output inspection, and
  provenance-based `safe` review without claiming deployment, accessibility
  compliance, or a full security audit.
- Complete: the source registry records the official internal-link behavior
  needed by this reference; the matching discovery scenario confirms the skill
  remains scoped to an existing Zola-site review.
- Complete: the published package at commit `e42c5d9` installed successfully
  for Codex and Claude Code with the new reference present; exact commands and
  outcomes are recorded in the [release checklist](release-checklist.md).
- Next: audit only other reference/checklist gaps that support implemented
  workflows and can be backed by maintained sources.

### Phase 5 bounded template accessibility-review reference

- Complete: `references/accessibility-review.md` is discoverable only for an
  explicit existing-template accessibility review. It limits findings to
  observable page regions, headings, image alternatives, and link purpose.
- Complete: the source registry records the W3C WAI evidence used by the
  reference. The matching discovery scenario preserves the no-compliance-claim
  boundary.
- Complete: the published package at commit `38917ef` installed successfully
  for Codex and Claude Code with the accessibility reference present; exact
  commands and outcomes are recorded in the
  [release checklist](release-checklist.md).
- Next: consider only remaining focused troubleshooting or reference gaps backed
  by implemented workflows.

### Phase 5 bounded content-model reference

- Complete: `references/content-model.md` is discoverable only for authorized
  existing-site content-structure, front-matter, route, or co-located asset
  changes. It preserves page/section roles and existing route behavior.
- Complete: the source registry records official Zola content overview, page,
  and section evidence; the matching discovery scenario covers a route-preserving
  co-located asset change.
- Complete: the published package at commit `a1b87af` installed successfully
  for Codex and Claude Code with the content-model reference present; exact
  commands and outcomes are recorded in the
  [release checklist](release-checklist.md).
- Next: consider only remaining focused troubleshooting gaps backed by an
  implemented workflow.

### Phase 5 bounded Tera template-context reference

- Complete: `references/tera-template-context.md` gives authorized existing-site
  Tera template work a progressive-disclosure guide to the template context
  (`config`, `page`, `section`, `term`, `taxonomy`, `lang`, and `current_url` /
  `current_path`) available to templates, and to the selectable base templates
  a `base.html` and template `extends` provide.
- Complete: skill step 4 and the debug-build, modify-review, and theme-override
  workflows now route Tera template-context questions to the reference, so a
  maintenance request does not default to generic web-frontend work.
- Complete: a Tera discovery-check scenario is recorded in
  `tests/scenarios.md`; the full test suite passes under Zola 0.23.4.
- Complete: `docs/research.md` theme research pass now includes
  `thomasweitzel/zolarwind` (fifth row), which passes both `check` and isolated
  `build` under the pinned Zola version.

### Phase 7 local implementation evidence

- Complete locally: `workflows/author-post.md` is selected only for an explicit
  draft/edit request in an existing Zola repository. It discovers local content
  and metadata conventions before changing authorized content; it neither
  invents provenance fields nor performs remote Git/publishing actions.
- Complete locally: `workflows/debug-build.md` checks `.gitmodules` and
  symlinked content/configuration as evidence before diagnosing an empty-content
  build; `references/editorial-review.md` and the disclosure guidance in
  `references/content-model.md` keep review and authorship claims bounded.
- Complete locally: `layout-submodule-site` and `authoring-site` fixtures,
  their scenarios, and the full runner passed under Zola 0.23.4 on 2026-09-05.
  The authoring fixture proves a non-root generated route, description, and
  explicit disclosure; the layout fixture proves a zero-page build without a
  state-changing repair.
- Complete: `npx --yes skills-ref validate skills/zola` reported `Valid skill:
  skills/zola`. Commit `ffdc3ae` was pushed to `main`; clean Codex and Claude
  Code installs from `CodeSigils/zola-skill@zola` each contained all thirteen
  payload files, including `author-post.md` and `editorial-review.md`, and
  listed `zola`.
- Complete: the reproducible Codex/Claude Code package-install matrix is the
  distribution gate because it retrieves and verifies the public payload in its
  target hosts. The unauthenticated skills.sh file-snapshot endpoint returned
  HTTP 401 and page HTML exposed no searchable tree; this is recorded as an
  observability limitation, not a release blocker. The layout fixture also has
  a tracked dangling `content` symlink.
- Complete: three isolated forward tests on 2026-09-05 passed: authoring
  preserved a site's section, front matter, explicit disclosure, and non-root
  route; editorial review identified an unsupported absolute claim and suspect
  source URL without changing content; layout diagnosis detected `.gitmodules`
  plus a dangling `content` link before treating the zero-page build as Zola
  behavior.

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

## Planned Phase 7: opt-in content authoring and repository layouts

Phase 7 extends the existing routed `zola` skill; it does not create a
publishing-specific skill or turn ordinary technical requests into editorial
work. It is selected only for an explicit request to prepare, edit, review, or
publish content in an existing Zola repository, or to diagnose a repository
whose content/configuration is demonstrably supplied by a submodule or
symlinked site layout.

The planned workflow will inspect the repository's section, naming,
front-matter, taxonomy, language, shortcode, and validation conventions before
creating or changing a post. It may prepare a draft, preserve established
metadata and disclosure fields, perform a bounded source/evidence/readability
review, and run the smallest applicable Zola validation. Git commits, pushes,
pull requests, publishing, and changes outside the authorized repository remain
separate, explicitly authorized actions.

It must not inherit site-specific voice rules, mandated languages, rhetorical
quotas, custom shortcode catalogs, author identities, SEO formulas, branch
names, signoffs, remote repositories, or bootstrap/clone instructions from an
example site. It must not fabricate dates, authorship, AI-use disclosures,
licenses, taxonomy values, source citations, or layout policy. A missing
submodule or dangling symlink is evidence to diagnose, not permission to
initialize, switch, or update repository state.

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

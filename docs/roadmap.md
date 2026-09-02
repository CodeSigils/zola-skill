# Zola Skill Roadmap

**Status:** Phase 3 complete — four fixture-backed core workflows published and validated
**Audience:** Skill maintainers and contributors  
**Owner:** Project maintainers  
**Last reviewed:** 2026-09-02

This roadmap turns the [vision](vision.md) into a small, demonstrated skill.
Do not implement advanced guidance merely because it appears in a planning
document.

## Related planning documents

- [vision.md](vision.md) defines the durable scope and acceptance criteria that
  guide this plan.
- [research.md](research.md) records evidence and decisions that may change
  implementation priorities.

## Mandatory phase-close gate

Before marking any phase complete or beginning its successor, re-read the
[documentation index](README.md), apply its reading matrix, and update every
affected planning document. The phase handoff must record: the roadmap status;
acceptance evidence; exact validation commands and observed outcomes; new or
rechecked source-registry/research facts and review dates; verified affected
Markdown links; and the reason for every planning document intentionally left
unchanged. A phase remains in progress until this gate is complete.

## v1 non-goals

The first release does not include deployment automation, broad, open-ended
theme research, advanced i18n, search, JavaScript/Rust/WASM guidance, or a
dedicated MCP. These capabilities remain in the vision and are considered only
after the operational core has demonstrated a concrete need.

The v1 description must not automatically select the skill for these requests.
If a user explicitly invokes it for one, the skill should state that the
workflow is not implemented rather than implying it can automate the work.

## Packaging and compatibility contract

Package the skill once at `skills/zola/`; do not keep agent-specific copies.
The directory and frontmatter name must both be `zola`. Follow the Agent Skills
specification: include `name` and `description`, keep optional metadata
portable, use relative one-level-deep links to supporting files, and keep
`SKILL.md` concise through progressive disclosure. Do not use experimental
`allowed-tools` metadata as a v1 dependency.

Use **Zola** as the public display name and `zola` as the machine identifier.
The source repository remains `zola-skill`; do not name the packaged skill
`zola-skill` or create a second alias.

Include a concise portable `compatibility` field because this workflow has real
environment requirements: filesystem and shell access; Zola for build
validation; and network access only for live documentation or full external-link
checking. Do not add host-specific tool names or make network access a blanket
requirement.

This `skills/` layout is discoverable by skills.sh. Validate the published
repository with its intended install form, such as
`npx skills add <owner>/zola-skill@zola --agent <host>`, rather than documenting
manual copies into a particular host's directory. A Codex-only
`agents/openai.yaml` may be added later as optional UI metadata; the skill must
remain correct when a host ignores it.

The release matrix is **Codex** and **Claude Code**. Run published-package
installation checks with the skills.sh agent identifiers `codex` and
`claude-code` in isolated temporary projects, verify that the installed skill
is discoverable and its referenced files are present, then remove the temporary
installation. Keep the matrix and commands versioned in the
[release checklist](release-checklist.md).

Before public release, select and add a repository license, then declare the
same license (or a reference to it) in `SKILL.md`. The repository uses MIT:
the full terms are in [`LICENSE`](../LICENSE), and `skills/zola/SKILL.md`
declares `license: MIT`.

## Phase 1 — Debug-build vertical slice

First decide and record the fixture version policy: a pinned Zola release for
the fixtures, plus the supported behavior when a user's installed version is
different or unavailable. Do not describe broad compatibility without evidence.
Record the binary source, exact version, checksum or immutable image reference,
and the condition that requires a fixture upgrade.

**Fixture version policy (2026-09-02):** fixtures are pinned to Zola `0.23.4`.
The validation runner accepts only that reported version and uses the local
binary selected by `ZOLA_BIN` (or `zola`). The implementation binary used for
the initial evidence is `/home/sand/.local/bin/zola`, SHA-256
`3043f86c7bd2872cd8ac3acd5fa006fea9711fa6b6d51a12f750313aa717e3f1`;
its intended upstream source is the official
[v0.23.4 release](https://github.com/getzola/zola/releases/tag/v0.23.4), whose
artifacts are Sigstore-signed. This local checksum identifies the binary used
for the evidence; a release installer must independently verify the downloaded
asset before treating it as interchangeable. Upgrade fixtures only when an
official Zola release changes behavior covered by a fixture, a security/support
decision requires it, or an explicit compatibility decision is recorded. For a
user repository on another version or with no Zola binary, the skill inspects
the reported version, verifies version-sensitive claims in official sources,
and labels unvalidated behavior instead of claiming fixture compatibility.

Create the portable implementation at `skills/zola/`:

- `SKILL.md` with the required `name: zola` and a concise description that
  front-loads Zola/Tera **build, template, rendering, and configuration
  failure** terms. Exclude general frontend, CMS, backend, site-creation,
  theme-authoring, and general-review work.
- Scope, boundaries, and explicit triggers.
- A short task boundary: debug/build is the only implemented v1 workflow;
  explicitly invoked out-of-scope modes are deferred without generic advice.
- Determine the installed Zola version (prefer `zola --version`), inspect
  relevant project configuration and dependencies, and verify version-sensitive
  behavior against official documentation.
- When official Zola/Tera documentation must be checked.
- Required validation, including output-directory preflight and a compact
  reference/workflow index.
- A minimal source registry for the official Zola and Tera facts used by the
  debug-build workflow.

Each source-registry row records: `URL | topic | verified Zola version |
verified date | caveat`.

**Done when:** the skill can route a request to the appropriate workflow and
give a short, reliable plan without loading a large reference catalog. It must
also support one complete vertical slice: diagnose a Zola template or build
failure by inspecting the repository, determining the installed Zola version,
inspecting relevant configuration and dependencies, verifying version-sensitive
behavior against official documentation, and producing a minimal validated fix.

**Vertical-slice contract:**

- **Input:** a local Zola repository and a build or template error.
- **Output:** an evidence-based diagnosis, assumptions, a minimal patch
  proposal for diagnosis-only requests or an authorized minimal patch, and
  exact validation commands.
- **Proof:** a fixture reproduces the failure, and the proposed fix passes the
  declared validation.

For template changes, add a representative rendered-page smoke check when the
available site commands make that feasible; a successful static build may not
exercise every template and data path. Use `zola check` and `zola build`; do
not assume a `zola fmt` command exists. For a local template/build diagnosis,
treat `zola check --skip-external-links`
as a valid network-independent tier; run full external-link validation
separately when it is available and relevant. Inspect `output_dir` before a
build, never add `--force` by default, and use an isolated output directory for
fixture builds.

Validate the skill with `skills-ref validate skills/zola` and test its
description against representative matching and non-matching prompts. At
release, smoke-test skills.sh installation for Codex and Claude Code. Keep this
test independent of agent-specific metadata. Separate checks that can run before
publishing (frontmatter, links, fixtures, and scenario assertions) from the
published-package installation checks.

**Initial implementation tree:**

```text
skills/zola/
├── SKILL.md
├── workflows/
│   └── debug-build.md
└── references/
    └── source-registry.md
tests/
├── fixtures/
│   ├── valid-site/
│   ├── broken-template/
│   └── non-root-base-url/
├── scenarios.md
└── run.sh
```

**Done when:** the implementation tree exists, the source registry records the
official sources actually used, and `tests/run.sh` passes the Phase 1 fixtures:
a valid minimal site, an intentional template/build failure with a known repair,
and a non-root `base_url` case with generated-link assertions. The runner must
pin or verify its Zola version, build into isolated output, distinguish expected
failure from unexpected failure, and record its exact commands and results.
`tests/scenarios.md` must bind each fixture to a realistic prompt, repository
evidence, expected diagnosis, prohibited unsafe advice, expected patch or
proposal, and validation outcome. This is the Phase 1 release gate, not a later
phase.

### Phase 1 completion evidence — 2026-09-02

The implementation tree, source registry, fixtures, runner, and scenario
manifest are present. The runner was executed as `bash -n tests/run.sh &&
tests/run.sh` using Zola `0.23.4` and reported:

- `valid-site`: `zola check --skip-external-links` and an isolated build passed.
- `broken-template`: both check and isolated build failed as expected with a
  recognizable Tera template diagnostic; the scenario's minimal repair is to
  close the `{% if %}` block with `{% endif %}`.
- `non-root-base-url`: check and isolated build passed, and generated
  `index.html` contained `href="https://example.test/docs/about/"`.

The runner preflights through each fixture's isolated output directory, never
uses `--force`, verifies the exact pinned version, and removes its temporary
directory at exit. The network-independent checks intentionally use
`--skip-external-links`; there are no external Markdown links in these
fixtures, and a live-link check remains a separate, environment-dependent
validation tier.

Skill validation passed: `npx --yes skills-ref validate skills/zola` reported
`Valid skill: skills/zola`. `tests/scenarios.md` also records two matching and
two non-matching discovery prompts. The public repository now resolves as
`CodeSigils/zola-skill@zola`; the Codex and Claude Code installation matrix
passed with skills CLI 1.5.23, as recorded in the
[release checklist](release-checklist.md). The repository license is complete:
MIT terms are in `LICENSE` and declared in the skill frontmatter.

Phase-close documentation gate: `docs/README.md`, `vision.md`, `roadmap.md`,
`research.md`, and `release-checklist.md` were re-read and updated as
applicable. `future-capabilities.md` is intentionally unchanged because this
phase adds no JavaScript, Rust, WebAssembly, runtime-service, or Zola-core
guidance.

## Phase 2 — Multilingual (i18n) workflow

After Phase 1 is released, add `workflows/i18n.md` as the first enrichment.
It must handle only Zola's static multilingual configuration, translated content
and section files, template translations, and language-aware URL generation.
It must not promise automatic translation, locale detection, language switching
through browser state, or CJK search-index builds.

The workflow must inspect `default_language`, configured language tables,
translation tables, language-suffixed content and `_index` files, relevant
templates, and `base_url`. It must verify version-sensitive behavior against
the official multilingual and template documentation before changing a project.
Record those sources in the registry.

Add fixtures and scenario assertions for:

- Default-language and translated configuration values and template
  translations.
- A translated content file whose generated route includes the language prefix.
- A translated section requiring its own `_index.{language}.md`, proving that
  missing section fallback is diagnosed rather than invented.
- `get_url` or equivalent language-aware URL generation under a non-root
  `base_url`.
- A malformed or unauthorized language code with the expected Zola failure.

Validate each fixture with the pinned Zola version, isolated output, generated
route/link assertions, and the scenario manifest. Do not add search-index
fixtures until search is its own proven workflow; Chinese and Japanese indexing
may require a specially built Zola binary and are explicitly deferred.

**Done when:** the skill can diagnose and make a minimal authorized repair to a
Zola multilingual configuration, content, or language-aware template-link
failure without changing the site's language policy; all listed scenarios pass
and the source registry records the official facts used.

### Phase 2 completion evidence — 2026-09-02

`skills/zola/workflows/i18n.md` now provides the bounded static i18n workflow,
and the source registry records the official multilingual and template facts it
uses. `tests/run.sh` was executed with Zola `0.23.4` and passed the existing
debug-build fixtures plus these Phase 2 assertions:

- `i18n-site` passed check and isolated build; generated output contained
  default/French titles and translations, `/fr/about/`, and the generated link
  `https://example.test/docs/fr/about/`.
- `missing-translated-section-index` passed `check` with an orphan-page warning
  but failed isolated build as expected when `get_section(..., lang="fr")`
  required the absent French section. This distinction is documented rather
  than being misrepresented as a fallback or a successful repair.
- `unauthorized-language-code` failed both check and isolated build as expected
  because `de` was absent from the configured language table.

The runner retains the Phase 1 pinned-version, isolated-output, and no-force
rules. `tests/scenarios.md` now binds each i18n fixture to a realistic prompt,
evidence, expected diagnosis, prohibited advice, repair proposal, and outcome.
`SKILL.md` includes matching i18n discovery terms while retaining the existing
exclusions for unrelated web work.

The updated published package was also installed successfully for Codex and
Claude Code from commit `c1bab39`; both copies included the i18n workflow. The
exact commands, paths, and results are recorded in the
[release checklist](release-checklist.md).

Phase-close documentation gate: `docs/README.md`, `vision.md`, `roadmap.md`,
and `research.md` were re-read and updated as applicable. The source registry
was updated with official i18n/template entries. `future-capabilities.md` is
intentionally unchanged because Phase 2 adds no JavaScript, Rust, WebAssembly,
runtime-service, or Zola-core guidance. The release checklist remains valid
and records the fresh published-package smoke test for this updated skill.

## Phase 3 — Core workflows (complete)

Implement focused workflows for the highest-value jobs. Start with
existing-site modification/review because it reuses the proven inspection,
version, source, and validation contract while adding immediate value without
the broader design surface of site creation or theme authoring:

1. Modify or review an existing site.
2. Create a Zola site.
3. Extend the debug-build workflow beyond the Phase 1 vertical slice.
4. Create or review a theme.

The first Phase 3 vertical slice must support an authorized small content or
template change and a non-mutating review. Its fixture must assert the rendered
result of the authorized change and retain at least one intentional finding for
the review scenario. Review findings must include severity, path, evidence,
impact, remediation, and validation; do not modify a site during a review-only
request.

### Phase 3 existing-site modification/review slice — complete

`skills/zola/workflows/modify-review.md` implements the first slice. It routes
authorized small content/template/configuration changes separately from
review-only requests, requires repository/version/source inspection, preserves
the existing architecture, and requires each finding to state severity, path,
evidence, impact, remediation, and validation.

The `existing-site-modification` fixture asserts a new content page and a
`get_url`-generated `/docs/updates/` link. The `existing-site-review` fixture
intentionally retains `href="/about/"` beneath a `/docs` base URL so the
scenario can prove a non-mutating warning report rather than a silent repair.
Both pass `zola check --skip-external-links`, isolated build, and generated
output assertions under Zola 0.23.4. At this implementation checkpoint, site
creation, expanded debug/build coverage, and the theme workflow/research were
still outstanding; all later slices are now covered by the close-gate evidence
below.

The published package at commit `b5fb0c1` was installed successfully for both
Codex and Claude Code with the new workflow present; see the
[release checklist](release-checklist.md) for the commands and outcomes.

### Phase 3 minimal site-creation slice — complete

`skills/zola/workflows/create-site.md` now covers only an explicit new target
directory, brief-driven `zola init`, minimal root content/template creation,
and isolated validation. It requires explicit authorization before `--force`,
does not add a theme/framework/runtime/deployment service, and labels
provisional values rather than inventing them.

The runner creates an isolated scaffold through `zola init` with the approved
`https://example.test/docs` base URL, then validates `created-site` with check,
isolated build, and generated title/content assertions. The scenario manifest
prohibits initialization of an existing directory and deployment claims. At
this implementation checkpoint, expanded debug/build coverage and theme
workflow/research were still outstanding; all later slices are now covered by
the close-gate evidence below.

The published package at commit `d898c88` was installed successfully for both
Codex and Claude Code with the creation workflow present; see the
[release checklist](release-checklist.md) for the commands and outcomes.

### Phase 3 extended debug/build slice — complete

`skills/zola/workflows/debug-build.md` now requires the diagnosis to separate
a malformed root `zola.toml`/`config.toml` from malformed content front matter.
It directs the repair to the parser-reported file and line, limits it to the
malformed syntax or value, and prohibits unrelated configuration replacement or
`base_url` changes.

The runner keeps `malformed-config` and `malformed-front-matter` intentionally
broken. Under Zola 0.23.4, both `zola check --skip-external-links` and isolated
`zola build` fail as expected: the former reports a TOML parse error at the
invalid root-config line, and the latter names the content page whose front
matter cannot parse. `tests/scenarios.md` records the evidence, forbidden
advice, and minimal repair for each case. At this implementation checkpoint,
only the theme workflow/research remained; the close-gate evidence below covers
that final slice.

The published package at commit `f6a2295` was installed successfully for both
Codex and Claude Code with the updated debug/build workflow present; see the
[release checklist](release-checklist.md) for the commands and outcomes.

The bounded theme research pass is complete. It compares four non-archived
themes across documentation, blog, multilingual/accessibility, and portfolio
archetypes; records MIT license provenance, repository activity signals,
version-check results, and nonportable assumptions in
[research.md](research.md). It confirms that theme manifests and recent
activity do not establish compatibility with the pinned Zola version.

### Phase 3 bounded theme-override slice — complete

`skills/zola/workflows/theme-override.md` implements one authorized host-side
override of a verified named block in an already configured theme, with a
separate review-only path. It requires inspection of the host configuration,
installed theme manifest, exact upstream template/block, revision when
available, and installed Zola version. It excludes theme selection, third-party
theme adoption, full theme authoring, copied example configurations, and new
CSS/JavaScript tooling.

The fixture-owned `theme-override-site` selects `starter-theme`, whose
`base.html` defines `site_banner`. Its host `templates/index.html` extends the
theme-qualified template and overrides only that block. Under Zola 0.23.4,
`zola check --skip-external-links` and isolated `zola build` pass; generated
output proves the host banner, the configured `/docs/` URL, and host content.
The published package at commit `134fb05` was installed successfully for both
Codex and Claude Code with the new workflow present; see the
[release checklist](release-checklist.md) for the commands and outcomes. The
mandatory phase-close gate is recorded below.

### Phase 3 close-gate evidence — complete

The documentation index, vision, roadmap, research, source registry, and
release checklist were re-read on 2026-09-02. `tests/run.sh` passed under Zola
0.23.4: valid, non-root URL, i18n, authorized modification/review, site
creation, parser-failure, and theme-override assertions passed; intentional
broken-template, malformed-configuration/front-matter, untranslated-section,
and unauthorized-language cases failed as expected. `npx --yes skills-ref
validate skills/zola` reported `Valid skill: skills/zola`.

The release checklist records successful copied installs of each published
workflow for Codex and Claude Code, most recently the theme-override workflow
at commit `134fb05`. The source registry contains the official CLI,
configuration, Tera, i18n/template, and theme sources used by the workflows;
research records the theme comparison and fixture result. Affected relative
documentation links were verified. `future-capabilities.md` remains unchanged
because Phase 3 added no JavaScript, Rust, WebAssembly, runtime-service, or
Zola-core guidance. Phase 4 may now begin.

Each workflow should define inputs, inspection steps, expected output, and
validation commands.

**Done when:** each workflow can be followed end-to-end against a fixture
site, including `zola check` and `zola build` where supported. The theme
workflow is not complete until its research findings are recorded.

**Dependency:** Phase 3 uses the triage, inspection, version, and validation
contract established in Phase 1.

## Phase 4 — Broader fixture coverage

Create small fixture repositories or directories for:

- A minimal site.
- Theme overrides and template inheritance.
- Taxonomies and pagination.
- A non-root `base_url`.
- Intentional template and front-matter failures.
- An unsafe `safe`-filter usage.

Write scenario-based checks with expected diagnoses or generated output.

**Done when:** regressions in advice, template handling, URL construction, and
security guidance are detectable without manual review.

**Dependency:** Phase 4 evaluates the workflows delivered in Phase 3; fixtures
are not created merely to demonstrate unimplemented guidance.

## Phase 5 — Focused references and checklists

Add only the references needed by the proven workflows first:

- Zola configuration and content model.
- Tera language and template context.
- Theme authoring.
- Troubleshooting.
- Accessibility, security, and release checks.
- Expand the source registry with each official URL, topic, verification date,
  verified Zola version, and caveats needed by the proven workflows.

For version-sensitive facts, record the authoritative URL and the Zola version
against which it was verified.

**Done when:** detailed guidance is discoverable on demand rather than making
the primary skill monolithic.

**Dependency:** Phase 5 documents and supports behavior already exercised by
the earlier workflows and evaluation scenarios.

## Phase 6 — Optional capabilities

Add deployment templates, theme-research guidance, i18n depth, search,
JavaScript enhancement, Rust tooling, and WASM guidance only when a concrete
workflow or evaluation scenario needs them.

Reconsider a dedicated MCP only after repeated, demonstrated friction with
ordinary repository access, shell commands, and documentation lookup.

**Done when:** each addition has a user need, ownership model, validation plan,
and maintenance rationale.

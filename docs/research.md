# Comparable Skills Research

**Status:** Exploratory research  
**Audience:** Skill maintainers and contributors  
**Owner:** Project maintainers  
**Review cadence:** Before a release, after a Zola upgrade, or every six months  
**Last reviewed:** 2026-09-02
**Purpose:** Inform the design of the Zola skill before implementation. This is
not a specification or a source of runtime instructions.

## Related planning documents

- [vision.md](vision.md) defines the scope and operating principles this
  evidence informs.
- [roadmap.md](roadmap.md) sequences the implementation work supported by this
  research.

## Method and limits

This review examined official OpenAI/Codex skill guidance and publicly
discoverable examples of Hugo, Zola, documentation, and review skills. Sources
are linked so that their current contents and licenses can be checked before
adopting an idea.

The specific Hugo pages linked from the original vision on learn-skills.dev
could not be fetched by the research browser: the site returned a safety/cache
error for the direct pages and a 403 for its home page. Their design is
therefore not described as evidence here. The directory remains useful for
discovery, but any candidate skill should be inspected from its source
repository before reuse.

## Current Zola CLI evidence

**Checked:** 2026-09-02 (against Zola 0.23.4)

The official Zola CLI documentation states that Zola has four commands:
`init`, `build`, `serve`, and `check`. It does not document `zola fmt`.
Accordingly, the skill's baseline validation is `zola check` and `zola build`;
formatting is a project-specific tool choice, not a Zola requirement.

`zola check` builds without writing output and checks external links in
Markdown by default. The `--skip-external-links` flag is useful in constrained
environments, but it removes that coverage and must be reported.

Source: [Zola CLI usage](https://www.getzola.org/documentation/getting-started/cli-usage/).

**Phase 3 site-creation validation (2026-09-02, Zola 0.23.4):** In an isolated
temporary parent directory, `zola init created-with-init` accepted the supplied
base URL and the Sass/search prompt answers, then created `zola.toml`. The
fixture runner separately validates a minimal content/template site using that
base URL. This supports a workflow that initializes only an explicit new
directory and treats `--force` as an authorization boundary, rather than a
default convenience flag.

**Phase 3 extended debug/build validation (2026-09-02, Zola 0.23.4):** A
malformed root `zola.toml` failed both `zola check --skip-external-links` and
isolated `zola build` with a TOML parser line/column diagnostic. With a valid
root configuration but malformed `+++` TOML front matter, both commands named
the affected content page and reported a front-matter parsing failure. The
debug workflow therefore distinguishes the parser-reported file class and
limits a repair to the malformed syntax/value rather than treating either case
as a template failure or rebuilding configuration unnecessarily.

## Phase 1 fixture-version evidence

**Checked:** 2026-09-02

The local Phase 1 validation environment reports Zola `0.23.4`; the executable
used for initial evidence has SHA-256
`3043f86c7bd2872cd8ac3acd5fa006fea9711fa6b6d51a12f750313aa717e3f1`.
The official [v0.23.4 release](https://github.com/getzola/zola/releases/tag/v0.23.4)
identifies that release and states its artifacts are Sigstore-signed. The local
digest is an evidence identifier, not a substituted official artifact checksum:
any fresh binary acquisition must verify its downloaded asset or attestation.

This is intentionally a single-version fixture contract. It does not claim
that the workflow's syntax or diagnostics are identical on every Zola release;
the runtime skill requires installed-version inspection and source verification
before version-sensitive advice.

## Multilingual workflow evidence

**Checked:** 2026-09-02

Zola configures non-default languages in `zola.toml`; translations for the
default language live under `[translations]`, while other language translations
live under `[languages.<code>.translations]`. It detects translated content from
the filename, such as `article.fr.md`, and emits translated content under a
`/{language-code}/` base path unless translated front matter explicitly sets a
path. A translated section needs its own `_index.{code}.md`: there is no
fallback from the default-language section file. Zola reports an error when a
filename language code is not configured.

Template context exposes `lang`, and `get_url` accepts a `lang` parameter for
language-aware generated URLs. These facts make i18n a cohesive workflow rather
than a general best-practices reference. The first i18n scope should therefore
cover configuration, content and section files, template translation data, and
language-aware URLs; it should defer automatic translation, browser locale
detection, and Chinese/Japanese search indexing, which requires specially built
Zola binaries.

Sources: [Zola multilingual sites](https://www.getzola.org/documentation/content/multilingual/)
and [Zola template overview](https://www.getzola.org/documentation/templates/overview/).

**Phase 2 validation (2026-09-02, Zola 0.23.4):** A fixture with default and
French configuration/translation values emitted language-aware content and
links beneath a non-root base URL. A translated page under a section without
`_index.fr.md` was accepted by `zola check` with an orphan warning, but a
template `get_section(..., lang="fr")` lookup failed during `zola build` with
the expected absent-section error. This proves that `check` and `build` cover
different parts of this workflow and that missing section fallback must be
diagnosed from repository/template evidence rather than assumed. An
unauthorized `about.de.md` failed both commands.

## Distribution and portability evidence

**Checked:** 2026-09-02

The Agent Skills specification requires a `SKILL.md` file with YAML frontmatter
and Markdown instructions. `name` and `description` are required; the name must
match the parent directory and use lowercase letters, digits, and hyphens.
`license`, `compatibility`, and `metadata` are optional. `allowed-tools` is
experimental and support varies, so it is not suitable as a portability
requirement. The specification recommends concise entrypoints, progressive
disclosure, relative file references, and `skills-ref validate` for frontmatter
validation.

skills.sh discovers skill directories in standard locations, including
`skills/<name>/SKILL.md` and `.agents/skills/<name>/SKILL.md`, and installs them
into the selected agent's own location. A single `skills/zola/` source directory
therefore avoids duplicated, drifting agent-specific copies. Its documented
install form supports selecting a host agent with `--agent`. Distribution
verification should distinguish local Agent Skills validation from a
published-package installation smoke test, since the latter requires a public,
resolvable repository and a specific host integration.

**Release-checklist update (2026-09-02):** The current skills CLI documentation
lists `codex` and `claude-code` as agent identifiers; their project-scoped
locations are `.agents/skills/` and `.claude/skills/`, respectively. The
versioned [release checklist](release-checklist.md) uses those paths and
non-interactive copied installs in isolated temporary directories. Recheck the
CLI documentation before a public release because these integration details can
change.

**Published-package validation (2026-09-02):** `CodeSigils/zola-skill@zola`
was installed successfully into separate temporary projects for both Codex and
Claude Code with skills CLI `1.5.23`. The copied skills appeared at
`.agents/skills/zola` and `.claude/skills/zola`, respectively; each contained
the entrypoint, debug-build workflow, and source registry, and `skills ls`
listed the skill. Exact commands and outcomes are maintained in the
[release checklist](release-checklist.md).

**Phase 2 published-package validation (2026-09-02):** The Phase 2 package at
commit `c1bab39` was installed successfully for Codex and Claude Code with
skills CLI `1.5.23`. Each copied installation included `SKILL.md`, both
debug-build and i18n workflows, and the source registry. The skill was listed
for the requested host in each isolated project; details are in the
[release checklist](release-checklist.md).

**Phase 3 slice published-package validation (2026-09-02):** The package at
commit `b5fb0c1` was installed successfully for Codex and Claude Code with
skills CLI `1.5.23`. Both installed copies included the modification/review
workflow alongside the existing workflows and source registry. Details are in
the [release checklist](release-checklist.md).

**Phase 3 site-creation published-package validation (2026-09-02):** The
package at commit `d898c88` was installed successfully for Codex and Claude
Code with skills CLI `1.5.23`. Both installed copies included the creation
workflow with the existing workflows and source registry. Details are in the
[release checklist](release-checklist.md).

**Naming decision:** publish the skill as **Zola** with the machine identifier
`zola`; retain `zola-skill` only as the source repository name. This gives the
skill a concise domain-specific discovery name while preserving an unambiguous
repository identity. The expected skills.sh form is
`<owner>/zola-skill@zola`.

Sources: [Agent Skills specification](https://agentskills.io/specification),
[skills.sh CLI documentation](https://www.skills.sh/docs/cli), and
[skills CLI discovery documentation](https://github.com/vercel-labs/skills/blob/main/README.md).

**License decision (2026-09-02):** The repository is licensed under MIT. Its
full terms are in [`LICENSE`](../LICENSE), and the distributed skill declares
the matching `license: MIT` frontmatter value. This records a maintainer choice
for this repository; it is not provenance for third-party material.

### Evidence labels

- **Direct source inspected:** the source instructions were read during this
  research pass.
- **Registry or repository summary:** only a listing, README, or search result
  was available; treat workflow details as unverified.
- **Unavailable:** the candidate was discovered but its source could not be
  retrieved; do not use it as design evidence.

## Comparable examples

| Example                                                                                                                           | Evidence                | Observed approach                                                                                                                                   | Useful lesson                                                                                                          | Caveat                                                                                                                                                |
| --------------------------------------------------------------------------------------------------------------------------------- | ----------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------- |
| [OpenAI: Build skills](https://learn.chatgpt.com/docs/build-skills)                                                               | Direct source inspected | Skills use concise metadata for discovery, a `SKILL.md` for shared instructions, and optional resources loaded only when needed.                    | Keep the Zola entrypoint brief; make its description explicit about trigger terms and boundaries.                      | This is platform guidance, not a Zola workflow.                                                                                                       |
| [OpenAI skill creator](https://github.com/openai/skills/blob/main/skills/.system/skill-creator/SKILL.md)                          | Direct source inspected | Emphasizes one job, progressive disclosure, imperative workflows, and scripts only for repeatable deterministic work.                               | Treat references and scripts as earned additions, not initial boilerplate.                                             | It is a meta-skill rather than an SSG skill.                                                                                                          |
| [OpenAI security best practices](https://github.com/openai/skills/blob/main/skills/.curated/security-best-practices/SKILL.md)     | Direct source inspected | Uses a strongly bounded trigger description, repository inspection, and conditional reference loading.                                              | The Zola description should name Zola/Tera work and exclude general frontend, CMS, and backend work.                   | Its very prescriptive security workflow is not a model for every Zola task.                                                                           |
| [InfluxData Hugo template-dev skill](https://github.com/influxdata/docs-v2/blob/master/.agents/skills/hugo-template-dev/SKILL.md) | Direct source inspected | Requires runtime server testing after template changes because a build can miss page-rendering failures; gives exact commands and success criteria. | Pair Zola's static validation with a rendered-page check whenever template behavior could depend on runtime page data. | Its extensive product-specific rules and custom tooling must not be copied into a general Zola skill.                                                 |
| [jackspace/ClaudeSkillz Hugo skill](https://www.skills.sh/jackspace/claudeskillz/hugo)                                            | Registry summary        | Offers a broad Hugo setup guide with quick-start instructions and version claims.                                                                   | A static-site skill should give users a fast path to a verified build.                                                 | The collection is archived and its own README warns that version-pinned information has drifted; do not copy versions or claims without revalidation. |
| [Zola Blog Publisher](https://eliteai.tools/agent-skills/zola-blog)                                                               | Registry summary        | Narrows Zola use to one publishing pipeline: translating and publishing Obsidian content.                                                           | A separate specialized skill can be appropriate for a recurring, opinionated workflow.                                 | This is a third-party registry entry; inspect its upstream source and security model before adopting it.                                              |

## Comparison scorecard

The scorecard evaluates reusable design patterns rather than judging the
quality of the underlying products. `—` means the source did not establish the
criterion.

| Example                        | Trigger precision | Repository evidence | Conditional references | Executable validation | Reuse outside its source repo |
| ------------------------------ | ----------------- | ------------------- | ---------------------- | --------------------- | ----------------------------- |
| OpenAI Build skills            | High              | —                   | High                   | —                     | High                          |
| OpenAI skill creator           | High              | —                   | High                   | Medium                | High                          |
| OpenAI security best practices | High              | High                | High                   | Medium                | Medium                        |
| InfluxData Hugo template-dev   | High              | High                | Medium                 | High                  | Low                           |
| jackspace Hugo                 | Unverified        | Unverified          | Unverified             | Unverified            | Unverified                    |
| Zola Blog Publisher            | High              | Unverified          | Unverified             | Unverified            | Low                           |

## Patterns that recur

### 1. Narrow discovery, broad enough execution

Strong examples make their trigger conditions concrete and explicitly state
nearby work they do not cover. Once selected, they can still inspect a project,
choose a relevant workflow, and use references conditionally.

**Implication:** describe the skill as Zola/Tera static-site work, not generic
web development. Keep site creation, debugging, review, and theme work as
routed operating modes under that shared domain.

### 2. Repository evidence precedes advice

The Hugo documentation example separates reusable agent guidance from
repository-specific commands and conventions. The security example begins by
identifying the actual technologies in scope.

**Implication:** before a version-sensitive recommendation, determine the
installed Zola version, inspect relevant configuration, dependencies, the
content/template hierarchy, theme relationship, and existing validation
commands, then verify the behavior against official documentation. Do not
substitute a generic folder tree for repository evidence.

### 3. References are selected, not bulk-loaded

OpenAI’s guidance and the reviewed skills use a small entrypoint that links to
more detailed material only when the task requires it.

**Implication:** begin with the debugging reference required by the first
vertical slice. Add content-model, theme, deployment, i18n, and extension
references after a workflow or evaluation fixture demonstrates their value.

### 4. Validation belongs to the workflow

The strongest repository-oriented example ties a task to exact commands rather
than merely advising “test it.”

**Implication:** every Zola workflow should finish with the smallest relevant
validation set, normally `zola check` and `zola build` when available, plus a
task-specific inspection such as generated URL verification or template-error
reproduction. For template changes, add a rendered-page smoke test when the
site's available commands make that possible; do not assume a successful build
exercises every page/data path.

### 5. Version claims decay quickly

The archived Hugo collection is a useful warning: static-site tools, themes,
and deployment platforms evolve even when their core concepts remain stable.

**Implication:** keep current facts in a source registry with the authoritative
URL, verification date, Zola version, and caveat. Prefer official Zola and Tera
documentation over copied catalogues.

## Design options

| Option                       | Shape                                                                                          | Benefits                                                                     | Costs                                                                                 | Initial assessment                                                         |
| ---------------------------- | ---------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------- | ------------------------------------------------------------------------------------- | -------------------------------------------------------------------------- |
| One routed `zola` skill      | One concise entrypoint; modes for create, modify/review, debug, and theme work.                | Simple discovery; shared Zola/Tera/version rules; least initial duplication. | Must prevent the entrypoint from becoming a large manual.                             | Recommended for v1.                                                        |
| Several specialized skills   | Separate site, template-debug, theme-review, and deployment skills.                            | Very precise triggering and smaller per-skill context.                       | Duplicates shared rules; requires deliberate orchestration and naming.                | Revisit when one mode becomes materially larger or independently reusable. |
| Zola skill plus MCP          | A skill that relies on a dedicated Zola service/tool surface.                                  | Could help with fleet inventory, route analysis, or governance.              | Higher build and maintenance cost; normal file/shell/docs workflows already cover v1. | Defer, consistent with the vision.                                         |
| Opinionated publishing skill | A narrow companion for a specific CMS, Obsidian pipeline, or organization’s publishing policy. | Highly effective for repeated constrained work.                              | Not generalizable; embeds product and policy choices.                                 | Add only after a recurring workflow exists.                                |

## Recommendations for this project

1. Implement one routed, portable repository skill first at `skills/zola/`.
2. Make its frontmatter description discriminate between Zola/Tera work and
   unrelated general web work; test both positive and negative prompts.
3. Ship the debug-build vertical slice before site creation or theme authoring.
   It best proves repository inspection, version handling, source lookup, a
   minimal-change policy, and validation in one workflow.
4. Keep the canonical runtime instructions in `skills/zola/`. Keep
   this research, the vision, and the roadmap under `docs/` as maintainers’
   material rather than agent runtime context. Use an installed or linked copy
   only for cross-project discovery; do not edit that copy as a second source
   of truth.
5. Add a source registry before accumulating Zola/Tera details, and refresh
   facts rather than copying version-specific community guidance.
6. Re-evaluate splitting the skill only after use shows that a mode needs a
   distinct trigger, tool set, or reference corpus.

## Decision record

**Decision:** Start with one routed `zola` repository skill, not a collection
of specialized skills or a Zola MCP.

**Rationale:** It preserves one clear discovery point while keeping shared
version, documentation, and validation rules in one place. The initial
debug-build vertical slice demonstrates the most important behavior with the
least implementation surface. It can later split only where real use reveals
a distinct trigger or reference corpus.

**Revisit when:** theme work, deployment, or a publishing pipeline regularly
needs independent discovery, different tools, or a large body of guidance.

## Adoption and provenance rule

Treat third-party skills as pattern evidence, not copy sources. Before adopting
any text, script, or example, record its upstream URL, license, evidence label,
and adaptation rationale in the source registry. Revalidate version-specific
claims against official Zola or Tera sources, and do not execute third-party
scripts or inherit their permissions without an explicit safety review.

## Follow-up research questions

- Which Zola versions should the first fixtures cover?
- Is theme authoring common enough to remain in v1, or should it follow the
  debugging workflow?
- Which build/link/accessibility checks are reliably available without adding
  a JavaScript toolchain?
- Which three to five real user prompts best measure trigger precision and
  workflow quality?
- Are there maintained, source-accessible Hugo or Zola skills worth revisiting
  once their repositories can be inspected directly?

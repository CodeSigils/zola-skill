# Workflow scenarios

| Fixture | Realistic prompt | Repository evidence | Expected diagnosis | Prohibited unsafe advice | Expected patch or proposal | Validation outcome |
| --- | --- | --- | --- | --- | --- | --- |
| `valid-site` | “My Zola build suddenly fails; can you check the smallest local reproduction?” | `zola.toml`, root section, and `index.html`; no supplied failure | The fixture is valid under the pinned version; ask for the actual error rather than inventing one. | Claim a failure or add a framework. | No patch. | `check` and isolated build pass. |
| `broken-template` | “Fix the template parsing error from `zola build`.” | `templates/index.html` opens `{% if config.title %}` without `endif`. | An unclosed Tera control block prevents template parsing. | Add `safe`, remove the conditional without evidence, or claim output was rendered. | Add `{% endif %}` after the title; preserve the conditional. | `check` and isolated build fail before the repair; the error is expected. |
| `non-root-base-url` | “Why does my About link lose `/docs` when deployed below a subpath?” | `base_url` ends in `/docs`; index uses `get_url` for `@/about.md`. | The generated link must retain the configured base path. | Hard-code `/about/` or strip `base_url`. | Keep/use Zola URL generation. | Isolated build passes and generated `index.html` contains `https://example.test/docs/about/`. |

The runner intentionally leaves `broken-template` broken so the failure path
remains reproducible. The scenario documents its minimal repair proposal.

## Phase 3 extended debug/build scenarios

| Fixture | Realistic prompt | Repository evidence | Expected diagnosis | Prohibited unsafe advice | Expected patch or proposal | Validation outcome |
| --- | --- | --- | --- | --- | --- | --- |
| `malformed-config` | “Zola stopped before building after I edited `zola.toml`; what is the smallest repair?” | `zola.toml` has `this is not valid TOML` on line 2. | Root configuration TOML cannot parse; this is not a template or content failure. | Regenerate the site, change `base_url`, or move unrelated settings. | Replace or remove the malformed line while preserving the intended configuration. | `check` and isolated build fail with a TOML parse diagnostic, as expected. |
| `malformed-front-matter` | “This page now fails after I changed its metadata. Which file should I fix?” | `content/about.md` has `title =` inside `+++` front matter. | The named content page has malformed TOML front matter; root config remains valid. | Edit `zola.toml`, delete the page, or suppress the error in the template. | Give `title` a valid TOML value, such as `title = "About"`. | `check` and isolated build fail with a page front-matter diagnostic, as expected. |

## Phase 2 i18n scenarios

| Fixture | Realistic prompt | Repository evidence | Expected diagnosis | Prohibited unsafe advice | Expected patch or proposal | Validation outcome |
| --- | --- | --- | --- | --- | --- | --- |
| `i18n-site` | “My French About link must work under `/docs`, and the French navigation label is wrong.” | `languages.fr`, default/French translations, `about.fr.md`, and `get_url(..., lang=lang)`. | The French route and link retain `/docs/fr/`; `trans` selects the French value. | Hard-code `/about/`, remove `/docs`, or change the language policy. | Keep language-aware `get_url` and `trans` with the active `lang`. | Isolated build emits French route, French title/translation, and `https://example.test/docs/fr/about/`. |
| `missing-translated-section-index` | “Why does my `blog/article.fr.md` build fail when the English blog section works?” | `blog/_index.md` exists but `blog/_index.fr.md` does not; `page.html` calls `get_section(..., lang="fr")`. | A translated section needs its own language-suffixed index; no fallback is available. | Invent a fallback or remove the translated page without authorization. | Add `blog/_index.fr.md` with the intended French section front matter. | Check succeeds with an orphan warning; isolated build fails as expected when rendering the French section lookup. |
| `unauthorized-language-code` | “Zola rejects `about.de.md`; can I make it work?” | `languages.fr` is configured; `about.de.md` is present. | `de` is not an authorized language code. | Rename config/languages without confirming site policy. | Configure `de` only if authorized, otherwise rename/remove the invalid translation with approval. | Check and isolated build fail as expected. |

## Phase 3 existing-site modification/review scenarios

| Fixture | Realistic prompt | Repository evidence | Expected diagnosis or outcome | Prohibited advice | Expected patch or report | Validation outcome |
| --- | --- | --- | --- | --- | --- | --- |
| `existing-site-modification` | “Add an Updates page and link it from the existing home page under `/docs`.” | Existing `zola.toml`, home template, and new `updates.md`. | An authorized content/template change should preserve Zola-generated URLs and the configured base path. | Hard-code `/updates/`, add a frontend router, or change unrelated project structure. | Add the content and use `get_url(path="@/updates.md")` in the existing template. | Isolated output contains the `/docs/updates/` link and rendered update content. |
| `existing-site-review` | “Review the navigation for deployment under `/docs`; do not modify files.” | `base_url` contains `/docs`, while `index.html` hard-codes `href="/about/"`. | `warning | templates/index.html | hard-coded root-relative link | deploys outside /docs | use get_url(path="@/about.md") | rebuild and inspect index.html`. | Apply the fix, report a generic style preference, or claim the site was modified. | A finding with all required review fields; no patch. | Isolated build intentionally preserves the evidence for review. |

## Phase 3 minimal site-creation scenario

| Fixture | Realistic prompt | Repository evidence | Expected outcome | Prohibited advice | Expected result | Validation outcome |
| --- | --- | --- | --- | --- | --- | --- |
| `created-site` | “Create a simple Zola starter site at `https://example.test/docs` with a Welcome page.” | Explicit target, URL, title, and initial page brief. | Initialize only the new target, add minimal root content/template, and retain the non-root base URL. | Use `--force` on an existing directory, add a theme/framework, or claim deployment is configured. | `zola.toml`, root content, and `index.html` template; provisional values stated if supplied. | `zola init` scaffold uses the approved URL; fixture check and isolated build render the title and Welcome content. |

## Phase 3 theme-override scenario

| Fixture | Realistic prompt | Repository evidence | Expected outcome | Prohibited advice | Expected patch or report | Validation outcome |
| --- | --- | --- | --- | --- | --- | --- |
| `theme-override-site` | “Change only the banner in my already configured theme; keep the `/docs` deployment path.” | Host `zola.toml` selects `starter-theme`; the installed manifest and `base.html` define `site_banner`; host `templates/index.html` extends the theme template. | An authorized host-side named-block override preserves the theme files, configuration, and generated base URL. | Install a new theme, replace `zola.toml` with an example, edit theme files, or add CSS/JavaScript tooling. | Override only `site_banner` through `starter-theme/templates/index.html`. | Check and isolated build pass; output contains the host banner, generated `/docs/` home URL, and host content. |

## Phase 4 taxonomy-pagination scenario

| Fixture | Realistic prompt | Repository evidence | Expected outcome | Prohibited advice | Expected patch or report | Validation outcome |
| --- | --- | --- | --- | --- | --- | --- |
| `taxonomy-pagination-site` | “Add one post per Rust tag page, while preserving deployment under `/docs`.” | Top-level `taxonomies` declares `tags` with `paginate_by = 1`; two pages assign `Rust`; taxonomy templates consume `terms` and `paginator`. | The existing content model emits a taxonomy list, a canonical Rust term route, and paginated term output. | Put `taxonomies` under `[extra]`, add search/feed/browser tooling, or hard-code a root-relative pager URL. | Keep the top-level declaration; render only verified `paginator` fields in the taxonomy-term template. | Check and isolated build pass; output has `/tags/rust/`, `page/1`, `page/2`, a generated next URL under `/docs`, and one expected post on each pager. |

## Discovery checks

| Prompt | Expected selection result | Observed result |
| --- | --- | --- |
| “Zola says my `index.html` has an unclosed Tera block during build; diagnose it.” | Match `zola`: it names a Zola template build failure in an existing site. | Match. |
| “My Zola configuration makes the build fail after I changed `output_dir`.” | Match `zola`: it names a Zola configuration/build failure. | Match. |
| “My French Zola page is missing its `/fr/` route and translated navigation label.” | Match `zola`: it names static Zola i18n behavior in an existing site. | Match. |
| “Review this existing Zola site's templates for broken routes; do not edit anything.” | Match `zola`: it requests an existing Zola-site review. | Match. |
| “Create a small Zola documentation site in this new directory.” | Match `zola`: it requests a minimal Zola site creation workflow. | Match. |
| “Create a polished marketing site in React.” | Do not match: general site creation and frontend work are outside v1. | Do not match. |
| “Audit this CMS deployment pipeline.” | Do not match: CMS/deployment review is outside v1. | Do not match. |

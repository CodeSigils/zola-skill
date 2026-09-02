# Workflow scenarios

| Fixture | Realistic prompt | Repository evidence | Expected diagnosis | Prohibited unsafe advice | Expected patch or proposal | Validation outcome |
| --- | --- | --- | --- | --- | --- | --- |
| `valid-site` | “My Zola build suddenly fails; can you check the smallest local reproduction?” | `zola.toml`, root section, and `index.html`; no supplied failure | The fixture is valid under the pinned version; ask for the actual error rather than inventing one. | Claim a failure or add a framework. | No patch. | `check` and isolated build pass. |
| `broken-template` | “Fix the template parsing error from `zola build`.” | `templates/index.html` opens `{% if config.title %}` without `endif`. | An unclosed Tera control block prevents template parsing. | Add `safe`, remove the conditional without evidence, or claim output was rendered. | Add `{% endif %}` after the title; preserve the conditional. | `check` and isolated build fail before the repair; the error is expected. |
| `non-root-base-url` | “Why does my About link lose `/docs` when deployed below a subpath?” | `base_url` ends in `/docs`; index uses `get_url` for `@/about.md`. | The generated link must retain the configured base path. | Hard-code `/about/` or strip `base_url`. | Keep/use Zola URL generation. | Isolated build passes and generated `index.html` contains `https://example.test/docs/about/`. |

The runner intentionally leaves `broken-template` broken so the failure path
remains reproducible. The scenario documents its minimal repair proposal.

## Phase 2 i18n scenarios

| Fixture | Realistic prompt | Repository evidence | Expected diagnosis | Prohibited unsafe advice | Expected patch or proposal | Validation outcome |
| --- | --- | --- | --- | --- | --- | --- |
| `i18n-site` | “My French About link must work under `/docs`, and the French navigation label is wrong.” | `languages.fr`, default/French translations, `about.fr.md`, and `get_url(..., lang=lang)`. | The French route and link retain `/docs/fr/`; `trans` selects the French value. | Hard-code `/about/`, remove `/docs`, or change the language policy. | Keep language-aware `get_url` and `trans` with the active `lang`. | Isolated build emits French route, French title/translation, and `https://example.test/docs/fr/about/`. |
| `missing-translated-section-index` | “Why does my `blog/article.fr.md` build fail when the English blog section works?” | `blog/_index.md` exists but `blog/_index.fr.md` does not; `page.html` calls `get_section(..., lang="fr")`. | A translated section needs its own language-suffixed index; no fallback is available. | Invent a fallback or remove the translated page without authorization. | Add `blog/_index.fr.md` with the intended French section front matter. | Check succeeds with an orphan warning; isolated build fails as expected when rendering the French section lookup. |
| `unauthorized-language-code` | “Zola rejects `about.de.md`; can I make it work?” | `languages.fr` is configured; `about.de.md` is present. | `de` is not an authorized language code. | Rename config/languages without confirming site policy. | Configure `de` only if authorized, otherwise rename/remove the invalid translation with approval. | Check and isolated build fail as expected. |

## Discovery checks

| Prompt | Expected selection result | Observed result |
| --- | --- | --- |
| “Zola says my `index.html` has an unclosed Tera block during build; diagnose it.” | Match `zola`: it names a Zola template build failure in an existing site. | Match. |
| “My Zola configuration makes the build fail after I changed `output_dir`.” | Match `zola`: it names a Zola configuration/build failure. | Match. |
| “My French Zola page is missing its `/fr/` route and translated navigation label.” | Match `zola`: it names static Zola i18n behavior in an existing site. | Match. |
| “Create a polished marketing site in React.” | Do not match: general site creation and frontend work are outside v1. | Do not match. |
| “Audit this CMS deployment pipeline.” | Do not match: CMS/deployment review is outside v1. | Do not match. |

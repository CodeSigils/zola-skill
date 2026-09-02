# Phase 1 scenarios

| Fixture | Realistic prompt | Repository evidence | Expected diagnosis | Prohibited unsafe advice | Expected patch or proposal | Validation outcome |
| --- | --- | --- | --- | --- | --- | --- |
| `valid-site` | “My Zola build suddenly fails; can you check the smallest local reproduction?” | `zola.toml`, root section, and `index.html`; no supplied failure | The fixture is valid under the pinned version; ask for the actual error rather than inventing one. | Claim a failure or add a framework. | No patch. | `check` and isolated build pass. |
| `broken-template` | “Fix the template parsing error from `zola build`.” | `templates/index.html` opens `{% if config.title %}` without `endif`. | An unclosed Tera control block prevents template parsing. | Add `safe`, remove the conditional without evidence, or claim output was rendered. | Add `{% endif %}` after the title; preserve the conditional. | `check` and isolated build fail before the repair; the error is expected. |
| `non-root-base-url` | “Why does my About link lose `/docs` when deployed below a subpath?” | `base_url` ends in `/docs`; index uses `get_url` for `@/about.md`. | The generated link must retain the configured base path. | Hard-code `/about/` or strip `base_url`. | Keep/use Zola URL generation. | Isolated build passes and generated `index.html` contains `https://example.test/docs/about/`. |

The runner intentionally leaves `broken-template` broken so the failure path
remains reproducible. The scenario documents its minimal repair proposal.

## Discovery checks

| Prompt | Expected selection result | Observed result |
| --- | --- | --- |
| “Zola says my `index.html` has an unclosed Tera block during build; diagnose it.” | Match `zola`: it names a Zola template build failure in an existing site. | Match. |
| “My Zola configuration makes the build fail after I changed `output_dir`.” | Match `zola`: it names a Zola configuration/build failure. | Match. |
| “Create a polished marketing site in React.” | Do not match: general site creation and frontend work are outside v1. | Do not match. |
| “Audit this CMS deployment pipeline.” | Do not match: CMS/deployment review is outside v1. | Do not match. |

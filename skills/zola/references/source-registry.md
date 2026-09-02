# Official source registry

Consult only the row needed for the observed failure. These sources support the
debug-build workflow; they are not a copied reference manual.

| URL | Topic | Verified Zola version | Verified date | Caveat |
| --- | --- | --- | --- | --- |
| https://www.getzola.org/documentation/getting-started/cli-usage/ | `init`, `check`, and `build`; `--output-dir` and `--force` semantics | 0.23.4 | 2026-09-02 | `init` prompts for initial choices; use `--force` only with explicit authorization for the exact non-empty target. `check` fetches external Markdown links unless `--skip-external-links` is supplied. |
| https://www.getzola.org/documentation/getting-started/configuration/ | `zola.toml`, legacy `config.toml` fallback, `base_url`, and `output_dir` | 0.23.4 | 2026-09-02 | Configuration options are version-sensitive; inspect the project's file before changing it. |
| https://keats.github.io/tera/docs/ | Tera syntax and error interpretation | 0.23.4 | 2026-09-02 | Zola embeds Tera; verify the construct against the version/documentation relevant to the installed Zola binary. |
| https://www.getzola.org/documentation/content/multilingual/ | Language tables, translated filenames and routes, and translated-section index requirement | 0.23.4 | 2026-09-02 | A translated content language must be configured; a translated section has no fallback from `_index.md`. |
| https://www.getzola.org/documentation/templates/overview/ | Active `lang`, `trans`, and language-aware `get_url` | 0.23.4 | 2026-09-02 | Use the active language or an authorized explicit code; generated URLs retain the configured `base_url`. |

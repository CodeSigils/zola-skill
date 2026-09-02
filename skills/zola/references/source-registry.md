# Official source registry

Consult only the row needed for the observed failure. These sources support the
debug-build workflow; they are not a copied reference manual.

| URL | Topic | Verified Zola version | Verified date | Caveat |
| --- | --- | --- | --- | --- |
| https://www.getzola.org/documentation/getting-started/cli-usage/ | `check` behavior; `build`, `--output-dir`, and `--force` semantics | 0.23.4 | 2026-09-02 | `check` fetches external Markdown links unless `--skip-external-links` is supplied. |
| https://www.getzola.org/documentation/getting-started/configuration/ | `zola.toml`, legacy `config.toml` fallback, `base_url`, and `output_dir` | 0.23.4 | 2026-09-02 | Configuration options are version-sensitive; inspect the project's file before changing it. |
| https://keats.github.io/tera/docs/ | Tera syntax and error interpretation | 0.23.4 | 2026-09-02 | Zola embeds Tera; verify the construct against the version/documentation relevant to the installed Zola binary. |

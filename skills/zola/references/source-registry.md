# Official source registry

Consult only the row needed for the active workflow. These sources support the
implemented Zola workflows; they are not a copied reference manual.

| URL | Topic | Verified Zola version | Verified date | Caveat |
| --- | --- | --- | --- | --- |
| https://www.getzola.org/documentation/getting-started/cli-usage/ | `init`, `check`, and `build`; `--output-dir` and `--force` semantics | 0.23.4 | 2026-09-02 | `init` prompts for initial choices; use `--force` only with explicit authorization for the exact non-empty target. `check` fetches external Markdown links unless `--skip-external-links` is supplied. |
| https://www.getzola.org/documentation/getting-started/configuration/ | `zola.toml`, legacy `config.toml` fallback, `base_url`, and `output_dir` | 0.23.4 | 2026-09-02 | Configuration options are version-sensitive; inspect the project's file before changing it. |
| https://www.getzola.org/documentation/content/linking/ | Markdown internal-link checking, `@/` links, and `link_checker.internal_level` | 0.23.4 | 2026-09-03 | Broken internal Markdown links are errors by default; lowering the level to `warn` can leave a broken link in generated output. |
| https://keats.github.io/tera/docs/ | Tera syntax, auto-escaping, `safe`, and error interpretation | 0.23.4 | 2026-09-03 | `.html`, `.htm`, and `.xml` templates auto-escape by default; `safe` marks an expression unescaped, so inspect provenance before recommending it. |
| https://www.w3.org/WAI/tutorials/page-structure/ | WAI page regions, meaningful elements, and logical heading structure | N/A | 2026-09-03 | Use for source/output observations only; it does not establish WCAG conformance or prescribe ARIA where semantic HTML suffices. |
| https://www.w3.org/WAI/tutorials/images/ | Purpose-based text alternatives for informative, decorative, and functional images | N/A | 2026-09-03 | Alternative text depends on the image's purpose in its rendered context; do not infer an alt text without inspecting it. |
| https://www.w3.org/WAI/WCAG22/Understanding/link-purpose-in-context.html | Link purpose from link text or programmatically determined context | N/A | 2026-09-03 | A short link is not necessarily a defect when directly associated context supplies its purpose. |
| https://www.getzola.org/documentation/content/multilingual/ | Language tables, translated filenames and routes, and translated-section index requirement | 0.23.4 | 2026-09-02 | A translated content language must be configured; a translated section has no fallback from `_index.md`. |
| https://www.getzola.org/documentation/templates/overview/ | Active `lang`, `trans`, and language-aware `get_url` | 0.23.4 | 2026-09-02 | Use the active language or an authorized explicit code; generated URLs retain the configured `base_url`. |
| https://www.getzola.org/documentation/themes/installing-and-using-themes/ | Theme directory naming, top-level `theme` configuration, and theme-specific setup | 0.23.4 | 2026-09-02 | Inspect the installed theme's manifest and documentation; do not copy an example configuration wholesale. |
| https://www.getzola.org/documentation/themes/creating-a-theme/ | `theme.toml`, a buildable default site, and Tera blocks for customization | 0.23.4 | 2026-09-02 | A declared minimum version does not replace validation against the installed Zola version and selected theme revision. |
| https://www.getzola.org/documentation/content/taxonomies/ | Top-level taxonomy configuration, content terms, rendered term routes, and term pagination | 0.23.4 | 2026-09-03 | Taxonomy names must match content front matter; a configured `paginate_by` affects individual term pages. |
| https://www.getzola.org/documentation/templates/pagination/ | `paginator` context for paginated taxonomy terms and pager URLs | 0.23.4 | 2026-09-03 | `paginator` is undefined unless `paginate_by` is positive; inspect the relevant taxonomy term template. |

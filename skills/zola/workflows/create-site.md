# Create a minimal Zola site

Use this workflow only when the user asks to create a new Zola site and has
identified a target directory. It creates a small static starting point, not a
theme, deployment pipeline, frontend application, or content-management system.

## Confirm the brief and target

Collect the site URL (or explicitly mark a provisional local value), title,
target directory, and the initial page/content request. Inspect the target:
use `zola init <new-directory>` only for a new directory. Do not use `--force`
unless the user explicitly authorizes initialization of that exact non-empty
directory.

Run `zola --version`, then consult the CLI and configuration entries in the
source registry before relying on version-sensitive setup behavior.

## Build the smallest useful site

Run `zola init` and answer the prompts from the approved brief. Add only the
minimal configuration, root content, and templates needed to render the initial
page. Set `base_url` deliberately and use Zola URL helpers for links to site
content. Prefer semantic HTML and CSS; do not introduce a theme, framework,
bundler, JavaScript runtime, or deployment service without a separate need and
authorization.

State which values are provisional. Preserve auto-escaping; use `safe` only for
trusted Zola-rendered Markdown content.

## Validate and hand off

Inspect `output_dir`, run `zola check --skip-external-links`, then use a fresh
isolated output directory for `zola build`. Inspect the generated home page.
Report that external Markdown links were skipped, list the created files, and
give the commands needed to continue local development. Do not imply deployment
or production readiness without separate checks.

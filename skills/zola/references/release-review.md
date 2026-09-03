# Bounded static-site release review

Read this only for an explicitly requested pre-release, quality, or release
review of an existing Zola site. It supports a static build review; it does not
authorize deployment, promise accessibility compliance, or replace a security
assessment.

## Evidence to collect

1. Record the Zola version, selected configuration file, configured `base_url`,
   output handling, and the repository's established validation commands.
2. Run `zola check` when network access and the project's link-checking policy
   permit it. It builds pages without writing output and checks external
   Markdown links. If that check is intentionally skipped or replaced with
   `zola check --skip-external-links`, state that external Markdown links were
   not covered.
3. Build to a new empty output directory without `--force`, then inspect the
   requested generated pages. Check configured non-root URLs, navigation, and
   any changed taxonomy, pagination, language, or theme output in scope.
4. For templates handling untrusted or configuration/data values, inspect each
   `| safe` use and its provenance. Do not treat rendered Zola Markdown and
   arbitrary values as equivalent.

## Report limits precisely

Report passing commands, the inspected output paths, findings, and remaining
limits. Broken internal Markdown links are normally build/check errors; do not
lower their configured severity merely to obtain a passing release result.
Distinguish a concrete output or escaping defect from an unverified
accessibility, security, external-link, browser, or deployment claim.

## Source boundary

Use the CLI, linking, configuration, and Tera rows in the
[source registry](source-registry.md). Recheck those official sources when the
installed Zola version differs from the verified version.

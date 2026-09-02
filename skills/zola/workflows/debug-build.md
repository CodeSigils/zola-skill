# Debug a Zola build or template failure

Use this workflow after the Zola skill has been selected for an existing local
site with a build, rendering, template, or configuration failure.

## Inspect

- Capture the exact error and command. Reproduce only with a command that does
  not risk overwriting the project's configured output.
- Read the applicable configuration (`zola.toml` takes precedence over the
  legacy `config.toml`), the failing template or content file, templates it
  extends/includes, and the theme configuration or local override relationship.
- Check `zola --version`; identify project scripts or CI commands before
  proposing a replacement command.

## Verify and repair

Use the source registry to open the official Zola CLI/configuration page or
the official Tera documentation that matches the observed construct. Treat a
theme or copied snippet as project evidence, not authority. Make the smallest
change supported by the error and source. Do not add JavaScript, a framework,
or `| safe` merely to suppress a rendering problem.

### Configuration and front matter parser failures

First distinguish a root configuration parse failure from a content front
matter parse failure: the former names `zola.toml` or `config.toml`; the latter
names a content file and its front matter. Inspect the reported file and line
before editing. Repair only the malformed TOML syntax or value that explains
the diagnostic; do not move unrelated settings, change `base_url`, or replace
project configuration with a new scaffold merely to make parsing succeed.

If evidence is incomplete, separate the leading diagnosis from a competing
hypothesis and name the next inspection that would distinguish them.

## Validate

1. Confirm `output_dir` and existing project commands. For an isolated run,
   choose a fresh directory outside the project output and pass it with
   `zola build --output-dir <fresh-dir>`; never default to `--force`.
2. Run `zola check --skip-external-links` for a network-independent template or
   build check. State that external Markdown links were not checked.
3. Run `zola build` using the safe output arrangement. If the project has an
   established full external-link check and network access, run `zola check`
   separately.
4. For a template fix, inspect the relevant generated page or use the site's
   existing smoke command. A successful build alone may not exercise all data
   paths.

Return the diagnosis, evidence, patch/proposal, validation commands and their
outcomes, plus any unresolved assumption.

#!/usr/bin/env bash
set -euo pipefail

expected_version="0.23.4"
zola_bin="${ZOLA_BIN:-zola}"
repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
fixture_root="$repo_root/tests/fixtures"
run_root="$(mktemp -d "${TMPDIR:-/tmp}/zola-skill-tests.XXXXXX")"

cleanup() {
  rm -rf "$run_root"
}
trap cleanup EXIT

actual_version="$($zola_bin --version | awk 'NR == 1 { print $2 }')"
if [[ "$actual_version" != "$expected_version" ]]; then
  printf 'Expected Zola %s; found %s from %s\n' "$expected_version" "${actual_version:-unknown}" "$zola_bin" >&2
  exit 1
fi

run_check_and_build() {
  local fixture="$1"
  local output="$run_root/${fixture}-output"
  "$zola_bin" --root "$fixture_root/$fixture" check --skip-external-links
  "$zola_bin" --root "$fixture_root/$fixture" build --output-dir "$output"
}

expect_check_and_build_failure() {
  local fixture="$1"
  local pattern="$2"
  local mode
  for mode in check build; do
    if [[ "$mode" == "check" ]]; then
      failure_command=("$zola_bin" --root "$fixture_root/$fixture" check --skip-external-links)
    else
      failure_command=("$zola_bin" --root "$fixture_root/$fixture" build --output-dir "$run_root/${fixture}-output")
    fi
    if "${failure_command[@]}" >"$run_root/${fixture}-${mode}.stdout" 2>"$run_root/${fixture}-${mode}.stderr"; then
      printf '%s unexpectedly passed zola %s\n' "$fixture" "$mode" >&2
      exit 1
    fi
    if ! rg -qi "$pattern" "$run_root/${fixture}-${mode}.stdout" "$run_root/${fixture}-${mode}.stderr"; then
      printf '%s %s failed without the expected diagnostic\n' "$fixture" "$mode" >&2
      exit 1
    fi
  done
}

expect_build_failure_after_check() {
  local fixture="$1"
  local pattern="$2"
  "$zola_bin" --root "$fixture_root/$fixture" check --skip-external-links
  if "$zola_bin" --root "$fixture_root/$fixture" build --output-dir "$run_root/${fixture}-output" >"$run_root/${fixture}-build.stdout" 2>"$run_root/${fixture}-build.stderr"; then
    printf '%s unexpectedly passed zola build\n' "$fixture" >&2
    exit 1
  fi
  if ! rg -qi "$pattern" "$run_root/${fixture}-build.stdout" "$run_root/${fixture}-build.stderr"; then
    printf '%s build failed without the expected diagnostic\n' "$fixture" >&2
    exit 1
  fi
}

printf 'Zola %s\n' "$actual_version"
printf 'valid-site: check and isolated build\n'
run_check_and_build valid-site
test -f "$run_root/valid-site-output/index.html"

printf 'layout-submodule-site: empty content is observable without state-changing repair\n'
run_check_and_build layout-submodule-site
test -f "$fixture_root/layout-submodule-site/.gitmodules"
[[ -L "$fixture_root/layout-submodule-site/content" ]]
[[ ! -e "$fixture_root/layout-submodule-site/content" ]]
[[ ! -d "$run_root/layout-submodule-site-output/blog" ]]

printf 'authoring-site: authored page preserves route, metadata, and explicit disclosure\n'
run_check_and_build authoring-site
rg -F 'href="https://example.test/docs/blog/new-post/">New post</a>' "$run_root/authoring-site-output/index.html"
rg -F '<meta name="description" content="A checked Zola authoring fixture.">' "$run_root/authoring-site-output/blog/new-post/index.html"
rg -F 'AI assistance was factually disclosed by the editor.' "$run_root/authoring-site-output/blog/new-post/index.html"

printf 'broken-template: expected template failure\n'
expect_check_and_build_failure broken-template 'template|parse|endif|unexpected'

printf 'malformed-config: expected configuration parsing failure\n'
expect_check_and_build_failure malformed-config 'config|toml|parse'

printf 'malformed-front-matter: expected front-matter parsing failure\n'
expect_check_and_build_failure malformed-front-matter 'front.?matter|page|toml|parse'

printf 'non-root-base-url: check, isolated build, and generated-link assertion\n'
run_check_and_build non-root-base-url
rg -F 'href="https://example.test/docs/about/"' "$run_root/non-root-base-url-output/index.html"

printf 'i18n-site: translated configuration, routes, and language-aware links\n'
run_check_and_build i18n-site
test -f "$run_root/i18n-site-output/fr/about/index.html"
rg -F '<html lang="en">' "$run_root/i18n-site-output/index.html"
rg -F '<title>English title</title>' "$run_root/i18n-site-output/index.html"
rg -F 'href="https://example.test/docs/about/">About</a>' "$run_root/i18n-site-output/index.html"
rg -F '<html lang="fr">' "$run_root/i18n-site-output/fr/index.html"
rg -F '<title>Titre français</title>' "$run_root/i18n-site-output/fr/index.html"
rg -F 'href="https://example.test/docs/fr/about/">À propos</a>' "$run_root/i18n-site-output/fr/index.html"

printf 'missing-translated-section-index: expected no-fallback failure\n'
expect_build_failure_after_check missing-translated-section-index 'section.*not found.*language.*fr'

printf 'unauthorized-language-code: expected unauthorized-language failure\n'
expect_check_and_build_failure unauthorized-language-code 'authorized language|language'

printf 'existing-site-modification: generated route after authorized content change\n'
run_check_and_build existing-site-modification
rg -F 'href="https://example.test/docs/updates/">Updates</a>' "$run_root/existing-site-modification-output/index.html"
rg -F 'Added release notes for the latest update.' "$run_root/existing-site-modification-output/updates/index.html"

printf 'existing-site-review: intentional non-root base_url finding remains visible\n'
run_check_and_build existing-site-review
rg -F 'href="/about/">About</a>' "$run_root/existing-site-review-output/index.html"

printf 'theme-override-site: named host override and non-root generated URL\n'
run_check_and_build theme-override-site
rg -F '<p>Host banner override</p>' "$run_root/theme-override-site-output/index.html"
rg -F 'href="https://example.test/docs/">Home</a>' "$run_root/theme-override-site-output/index.html"
rg -F '<main><p>Theme host content.</p>' "$run_root/theme-override-site-output/index.html"

printf 'taxonomy-pagination-site: term routes and paginated output\n'
run_check_and_build taxonomy-pagination-site
test -f "$run_root/taxonomy-pagination-site-output/tags/rust/page/1/index.html"
rg -F 'href="https://example.test/docs/tags/rust/">Rust</a>' "$run_root/taxonomy-pagination-site-output/tags/index.html"
rg -F 'href="https://example.test/docs/tags/rust/page/2/">Next</a>' "$run_root/taxonomy-pagination-site-output/tags/rust/index.html"
rg -F '<a href="https://example.test/docs/post-two/">Post two</a>' "$run_root/taxonomy-pagination-site-output/tags/rust/index.html"
rg -F '<a href="https://example.test/docs/post-one/">Post one</a>' "$run_root/taxonomy-pagination-site-output/tags/rust/page/2/index.html"

printf 'unsafe-safe-review: preserved unsafe template evidence for review\n'
run_check_and_build unsafe-safe-review
rg -F '{{ config.extra.announcement | safe }}' "$fixture_root/unsafe-safe-review/templates/index.html"
rg -F '<img src="x" onerror="alert(1)">' "$run_root/unsafe-safe-review-output/index.html"

printf 'editorial-review-site: article with evidence gaps, broken links, and ambiguous claims\n'
run_check_and_build editorial-review-site
rg -F 'The architecture is widely regarded as the fastest available' "$run_root/editorial-review-site-output/articles/first-post/index.html"
rg -F 'https://example.test/missing-page/' "$run_root/editorial-review-site-output/articles/first-post/index.html"
rg -F 'Recent studies show a 90% improvement' "$run_root/editorial-review-site-output/articles/first-post/index.html"
rg -F 'Zola is a static site generator written in Rust' "$run_root/editorial-review-site-output/articles/first-post/index.html"
rg -F 'This article was reviewed for factual accuracy' "$run_root/editorial-review-site-output/articles/first-post/index.html"

printf 'created-site: init scaffold and minimal-site output\n'
(cd "$run_root" && printf 'https://example.test/docs\nn\nn\n' | "$zola_bin" init created-with-init)
test -f "$run_root/created-with-init/zola.toml"
rg -F 'base_url = "https://example.test/docs"' "$run_root/created-with-init/zola.toml"
run_check_and_build created-site
rg -F '<title>Starter site</title>' "$run_root/created-site-output/index.html"
rg -F '<p>Welcome to the starter site.</p>' "$run_root/created-site-output/index.html"

printf 'PASS: debug-build, repository-layout, authoring, i18n, existing-site, theme override, taxonomy pagination, unsafe-review, editorial review, and creation fixtures passed expected assertions.\n'

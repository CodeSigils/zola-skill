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

printf 'broken-template: expected template failure\n'
expect_check_and_build_failure broken-template 'template|parse|endif|unexpected'

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

printf 'PASS: debug-build, i18n, and existing-site fixtures passed expected assertions.\n'

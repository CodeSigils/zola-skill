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

printf 'Zola %s\n' "$actual_version"
printf 'valid-site: check and isolated build\n'
run_check_and_build valid-site
test -f "$run_root/valid-site-output/index.html"

printf 'broken-template: expected template failure\n'
for mode in check build; do
  if [[ "$mode" == "check" ]]; then
    broken_command=("$zola_bin" --root "$fixture_root/broken-template" check --skip-external-links)
  else
    broken_command=("$zola_bin" --root "$fixture_root/broken-template" build --output-dir "$run_root/broken-template-output")
  fi
  if "${broken_command[@]}" >"$run_root/broken-$mode.stdout" 2>"$run_root/broken-$mode.stderr"; then
    printf 'broken-template unexpectedly passed zola %s\n' "$mode" >&2
    exit 1
  fi
  if ! rg -qi 'template|parse|endif|unexpected' "$run_root/broken-$mode.stdout" "$run_root/broken-$mode.stderr"; then
    printf 'broken-template %s failed without a recognizable template diagnostic\n' "$mode" >&2
    exit 1
  fi
done

printf 'non-root-base-url: check, isolated build, and generated-link assertion\n'
run_check_and_build non-root-base-url
rg -F 'href="https://example.test/docs/about/"' "$run_root/non-root-base-url-output/index.html"

printf 'PASS: valid build, expected template failure, and non-root base_url link.\n'

# Release Checklist

Use this checklist only after the `zola-skill` repository is publicly
resolvable at its final owner/repository path. It records the Phase 1 release
checks that cannot be meaningfully run against the local source tree.

## Pre-publish

- [x] Published source resolves as `CodeSigils/zola-skill@zola`.
- [x] Confirmed [`LICENSE`](../LICENSE) contains MIT terms and
  `skills/zola/SKILL.md` declares `license: MIT`.
- [x] `npx --yes skills-ref validate skills/zola` reported `Valid skill:
  skills/zola`.
- [x] `tests/run.sh` passed with Zola 0.23.4: valid site and non-root URL
  checks passed; the broken-template check and build failed as expected.
- [x] `CHANGELOG.md` records the published change on `main`; no GitHub Release
  or semver tag is required. Existing `phase-1`..`phase-5` tags are historical
  roadmap milestones.

## Published-package smoke matrix

Run each row from a separate empty temporary directory. The commands use
`--copy` so each agent receives a complete independent copy for inspection;
the temporary directory may then be removed safely. `skills.sh` documents
`codex` and `claude-code` as the corresponding agent identifiers and installs
project-scoped skills under `.agents/skills/` and `.claude/skills/`.

| Host | Install and verify | Pass condition |
| --- | --- | --- |
| Codex | `release_dir="$(mktemp -d)" && cd "$release_dir" && npx skills add CodeSigils/zola-skill@zola --agent codex --copy --yes && test "$(find .agents/skills/zola -type f -name '*.md' | wc -l)" -eq 13 && test -f .agents/skills/zola/workflows/author-post.md && test -f .agents/skills/zola/references/editorial-review.md && npx skills ls -a codex` | The installed `zola` skill is listed and all thirteen payload files exist. |
| Claude Code | `release_dir="$(mktemp -d)" && cd "$release_dir" && npx skills add CodeSigils/zola-skill@zola --agent claude-code --copy --yes && test "$(find .claude/skills/zola -type f -name '*.md' | wc -l)" -eq 13 && test -f .claude/skills/zola/workflows/author-post.md && test -f .claude/skills/zola/references/editorial-review.md && npx skills ls -a claude-code` | The installed `zola` skill is listed and all thirteen payload files exist. |

After recording each result, remove the exact temporary directory created for
that row, for example `rm -rf "$release_dir"`. Do not run the command from a
working repository and do not use a global install: the intent is a clean,
project-scoped published-package check.

### Phase 7 package additions

For the Phase 7 release candidate, extend each matching matrix command with
the host-specific checks for `workflows/author-post.md` and
`references/editorial-review.md`, and require all thirteen payload files
(`SKILL.md`, six workflows, and six references). This reproducible package
install is the release gate. A live skills.sh file-tree check is supplemental
only: the unauthenticated file-snapshot endpoint may be unavailable. This check
cannot run against an uncommitted local payload. The current matrix above
already includes these Phase 7 assertions.

### 2026-09-05 Phase 7 published-package results

Source: `CodeSigils/zola-skill@zola` on `main`, commit `ffdc3ae`. Skills CLI:
`1.5.23`.

| Host | Observed install path | Result |
| --- | --- | --- |
| Codex | `.agents/skills/zola` | Passed: all thirteen payload files existed, including `workflows/author-post.md` and `references/editorial-review.md`; `npx skills ls -a codex` listed `zola`. |
| Claude Code | `.claude/skills/zola` | Passed: all thirteen payload files existed, including `workflows/author-post.md` and `references/editorial-review.md`; `npx skills ls -a claude-code` listed `zola`. |

Each row ran in a fresh temporary directory that was removed after
verification. The public page returned no searchable file-tree text, and the
unauthenticated catalog file-snapshot endpoint returned HTTP 401; direct
live-page file-tree verification is pending.

## Record

For each host, record the date, published source/ref, `skills` CLI version,
command output, discovered install path, and pass/fail result. If a CLI update
changes an agent identifier, install path, or command syntax, update this
checklist and the distribution evidence in [research.md](research.md) before
releasing.

### 2026-09-02 published-package results

Source: `CodeSigils/zola-skill@zola` on the `main` branch, commit `0a4bf18`.
Skills CLI: `1.5.23`.

| Host | Observed install path | Result |
| --- | --- | --- |
| Codex | `.agents/skills/zola` | Passed: `SKILL.md`, `workflows/debug-build.md`, and `references/source-registry.md` existed; `npx skills ls -a codex` listed `zola`. |
| Claude Code | `.claude/skills/zola` | Passed: `SKILL.md`, `workflows/debug-build.md`, and `references/source-registry.md` existed; `npx skills ls -a claude-code` listed `zola`. |

Each check ran in a separately created `/tmp/zola-skill-*` directory and the
directory was removed after the command completed.

### 2026-09-02 Phase 2 published-package results

Source: `CodeSigils/zola-skill@zola` on the `main` branch, commit `c1bab39`.
Skills CLI: `1.5.23`.

| Host | Observed install path | Result |
| --- | --- | --- |
| Codex | `.agents/skills/zola` | Passed: entrypoint, debug-build workflow, i18n workflow, and source registry existed; `npx skills ls -a codex` listed `zola`. |
| Claude Code | `.claude/skills/zola` | Passed: entrypoint, debug-build workflow, i18n workflow, and source registry existed; `npx skills ls -a claude-code` listed `zola`. |

Each check ran in a separately created `/tmp/zola-skill-i18n-*` directory and
the directory was removed after the command completed.

### 2026-09-02 Phase 3 slice published-package results

Source: `CodeSigils/zola-skill@zola` on the `main` branch, commit `b5fb0c1`.
Skills CLI: `1.5.23`.

| Host | Observed install path | Result |
| --- | --- | --- |
| Codex | `.agents/skills/zola` | Passed: entrypoint, debug-build, i18n, and modification/review workflows plus source registry existed; `npx skills ls -a codex` listed `zola`. |
| Claude Code | `.claude/skills/zola` | Passed: entrypoint, debug-build, i18n, and modification/review workflows plus source registry existed; `npx skills ls -a claude-code` listed `zola`. |

Each check ran in a separately created `/tmp/zola-skill-modify-*` directory and
the directory was removed after the command completed.

### 2026-09-02 Phase 3 site-creation published-package results

Source: `CodeSigils/zola-skill@zola` on the `main` branch, commit `d898c88`.
Skills CLI: `1.5.23`.

| Host | Observed install path | Result |
| --- | --- | --- |
| Codex | `.agents/skills/zola` | Passed: entrypoint, debug-build, i18n, modification/review, and creation workflows plus source registry existed; `npx skills ls -a codex` listed `zola`. |
| Claude Code | `.claude/skills/zola` | Passed: entrypoint, debug-build, i18n, modification/review, and creation workflows plus source registry existed; `npx skills ls -a claude-code` listed `zola`. |

Each check ran in a separately created `/tmp/zola-skill-create-*` directory and
the directory was removed after the command completed.

### 2026-09-02 Phase 3 extended debug/build published-package results

Source: `CodeSigils/zola-skill@zola` on the `main` branch, commit `f6a2295`.
Skills CLI: `1.5.23`.

| Host | Observed install path | Result |
| --- | --- | --- |
| Codex | `.agents/skills/zola` | Passed: entrypoint, debug-build, i18n, modification/review, and creation workflows plus source registry existed; `npx skills ls -a codex` listed `zola`. |
| Claude Code | `.claude/skills/zola` | Passed: entrypoint, debug-build, i18n, modification/review, and creation workflows plus source registry existed; `npx skills ls -a claude-code` listed `zola`. |

Each check ran in a separately created `/tmp/zola-skill-debug-*` directory and
the directory was removed after the command completed.

### 2026-09-02 Phase 3 bounded theme-override published-package results

Source: `CodeSigils/zola-skill@zola` on the `main` branch, commit `134fb05`.
Skills CLI: `1.5.23`.

| Host | Observed install path | Result |
| --- | --- | --- |
| Codex | `.agents/skills/zola` | Passed: entrypoint, debug-build, i18n, modification/review, creation, and theme-override workflows plus source registry existed; `npx skills ls -a codex` listed `zola`. |
| Claude Code | `.claude/skills/zola` | Passed: entrypoint, debug-build, i18n, modification/review, creation, and theme-override workflows plus source registry existed; `npx skills ls -a claude-code` listed `zola`. |

Each check ran in a separately created `/tmp/zola-skill-theme-*` directory and
the directory was removed after the command completed.

### 2026-09-03 Phase 4 taxonomy/pagination published-package results

Source: `CodeSigils/zola-skill@zola` on the `main` branch, commit `c4fb90d`.
Skills CLI: `1.5.23`.

| Host | Observed install path | Result |
| --- | --- | --- |
| Codex | `.agents/skills/zola` | Passed: entrypoint, debug-build, i18n, modification/review, creation, and theme-override workflows plus source registry existed; `npx skills ls -a codex` listed `zola`. |
| Claude Code | `.claude/skills/zola` | Passed: entrypoint, debug-build, i18n, modification/review, creation, and theme-override workflows plus source registry existed; `npx skills ls -a claude-code` listed `zola`. |

Each check ran in a separately created `/tmp/zola-skill-taxonomy-*` directory
and the directory was removed after the command completed.

### 2026-09-03 Phase 4 unsafe-`safe` review published-package results

Source: `CodeSigils/zola-skill@zola` on the `main` branch, commit `54219d3`.
Skills CLI: `1.5.23`.

| Host | Observed install path | Result |
| --- | --- | --- |
| Codex | `.agents/skills/zola` | Passed: entrypoint, debug-build, i18n, modification/review, creation, and theme-override workflows plus source registry existed; `npx skills ls -a codex` listed `zola`. |
| Claude Code | `.claude/skills/zola` | Passed: entrypoint, debug-build, i18n, modification/review, creation, and theme-override workflows plus source registry existed; `npx skills ls -a claude-code` listed `zola`. |

Each check ran in a separately created `/tmp/zola-skill-safe-*` directory and
the directory was removed after the command completed.

### 2026-09-03 Phase 5 bounded release-review published-package results

Source: `CodeSigils/zola-skill@zola` on the `main` branch, commit `e42c5d9`.
Skills CLI: `1.5.23`.

| Host | Observed install path | Result |
| --- | --- | --- |
| Codex | `.agents/skills/zola` | Passed: `SKILL.md`, `workflows/modify-review.md`, `references/release-review.md`, and `references/source-registry.md` existed; `npx skills ls -a codex` listed `zola`. |
| Claude Code | `.claude/skills/zola` | Passed: `SKILL.md`, `workflows/modify-review.md`, `references/release-review.md`, and `references/source-registry.md` existed; `npx skills ls -a claude-code` listed `zola`. |

Each check ran in a separately created `/tmp/zola-skill-phase5-*` directory and
the directory was removed after the command completed.

### 2026-09-03 Phase 5 bounded accessibility-review published-package results

Source: `CodeSigils/zola-skill@zola` on the `main` branch, commit `38917ef`.
Skills CLI: `1.5.23`.

| Host | Observed install path | Result |
| --- | --- | --- |
| Codex | `.agents/skills/zola` | Passed: `SKILL.md`, `workflows/modify-review.md`, `references/accessibility-review.md`, and `references/source-registry.md` existed; `npx skills ls -a codex` listed `zola`. |
| Claude Code | `.claude/skills/zola` | Passed: `SKILL.md`, `workflows/modify-review.md`, `references/accessibility-review.md`, and `references/source-registry.md` existed; `npx skills ls -a claude-code` listed `zola`. |

Each check ran in a separately created `/tmp/zola-skill-accessibility-*`
directory and the directory was removed after the command completed.

### 2026-09-03 Phase 5 bounded content-model published-package results

Source: `CodeSigils/zola-skill@zola` on the `main` branch, commit `a1b87af`.
Skills CLI: `1.5.23`.

| Host | Observed install path | Result |
| --- | --- | --- |
| Codex | `.agents/skills/zola` | Passed: `SKILL.md`, `workflows/modify-review.md`, `references/content-model.md`, and `references/source-registry.md` existed; `npx skills ls -a codex` listed `zola`. |
| Claude Code | `.claude/skills/zola` | Passed: `SKILL.md`, `workflows/modify-review.md`, `references/content-model.md`, and `references/source-registry.md` existed; `npx skills ls -a claude-code` listed `zola`. |

Each check ran in a separately created `/tmp/zola-skill-content-*` directory and
the directory was removed after the command completed.

### 2026-09-04 Phase 5 bounded Tera template-context reference status

Package install not yet smoke-tested; see the note below.

Reference: `references/tera-template-context.md` was added at commit `9197fcd`
with its validation record at `0c10bde` (the matched reference/validation commit
pair recorded by the Phase 5 close-gate). It is one of the eleven files in the
smoke matrix above.

Result: local validation passed under Zola 0.23.4 (full test suite plus the
Tera discovery-check scenario recorded in `tests/scenarios.md`); the phase-close
gate in `docs/roadmap.md` and `docs/vision.md` records the work as complete.

The published-package install for this reference was not separately run: the
matrix rows require the package to be publicly resolvable. Run the matching
matrix row for `references/tera-template-context.md` during the public-release
smoke pass and record the observed install path and pass/fail result here.

### 2026-09-05 published-package smoke-matrix results

The package is publicly resolvable at `CodeSigils/zola-skill@zola` (branch
`main`, commit `37c0488`). The full eleven-file smoke matrix above was run for
both hosts from fresh temporary directories; the `tera-template-context` gap
recorded on 2026-09-04 is now closed. Skills CLI: `1.5.23`.

| Host | Observed install path | Result |
| --- | --- | --- |
| Codex | `.agents/skills/zola` | Passed: all eleven files existed (`SKILL.md`, all five workflows, all five references including `tera-template-context.md`); `npx skills ls -a codex` listed `zola`; security scans: Gen Safe, Socket 0 alerts, Snyk Low Risk (https://skills.sh/CodeSigils/zola-skill). |
| Claude Code | `.claude/skills/zola` | Passed: all eleven files existed (`SKILL.md`, all five workflows, all five references including `tera-template-context.md`); `npx skills ls -a claude-code` listed `zola`; security scans: Gen Safe, Socket 0 alerts, Snyk Low Risk (https://skills.sh/CodeSigils/zola-skill). |

Each row ran in a separately created `mktemp -d` directory, and the directory
was removed after verification.

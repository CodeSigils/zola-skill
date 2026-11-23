# Release & Milestone Validation Checklist

Use this checklist when you need recorded validation evidence for the
`zola-skill` repository (for example before announcing an updated payload or
when cutting an optional milestone tag). `main` is the canonical distribution
and install/update path; immutable tags are optional milestone/audit markers,
not required for every change.

## Release and milestone policy (hybrid)

1. **`main` is canonical.** Merge reviewed changes to `main`; the merge commit
   body (with `what:` and `why:`) is the change record. The `Commit messages`
   workflow checks this contract on pull requests and pushes to `main`. This
   repository keeps no `CHANGELOG.md`.
2. **Validate as needed.** Before announcing an updated published payload or
   creating a milestone tag, run the relevant manual checks in this document
   (for example `bash tests/run.sh` with Zola 0.23.4, `skills-ref` validation,
   and/or clean published-package installs for Codex and Claude Code) and record
   source commit, tool versions, commands, and results.
3. **Tags are optional milestones.** Create an annotated immutable semver tag
   only when you want a durable reference point for reproducibility/auditability,
   consumer pinning/rollback, or a clear validated payload boundary. Suggested
   increments when tagging: major for a breaking scope/routing removal, minor
   for a backward-compatible workflow expansion, patch for a compatible
   correction. Do not tag routine docs/CI-only changes unless you intentionally
   need to pin them. GitHub Releases are not required.
4. **No release ceremony overhead by default.** Do not add a skill self-version,
   version-consistency gate, or release automation at the current maintenance
   scale. Existing tags (`phase-1`..`phase-5`, `v1.0.0`, `v1.0.1`) are historical
   milestones and remain as-is.
5. **Before announcing/tagging, review for drift.** Check repeated semantic
   values (versions, runners, OS names, paths, SHAs, ports, and feature flags)
   as possible duplication/drift smells. Centralize only when values should
   change together and the trade-off improves clarity; document intentional
   copies.

To make the workflow a merge requirement, repository administrators must mark
the `Commit messages` check as required in `main` branch protection or rulesets.

If the default UV cache is not writable, set `UV_CACHE_DIR` to a writable
temporary directory for the pinned `skills-ref` command. The cache is local
tool state, not a repository artifact: do not commit or publish it, and remove
the exact temporary directory after validation. This changes only where `uvx`
stores downloads and temporary files; it does not change the pinned validator
source or the payload being checked.

## Pre-publish

- [x] Published source resolves as `CodeSigils/zola-skill@zola`.
- [x] Confirmed [`LICENSE`](../LICENSE) contains MIT terms and
  `skills/zola/SKILL.md` declares `license: MIT`.
- [x] `uvx --from git+https://github.com/agentskills/agentskills.git@69ef37e9424c0a7ea9dd2293b559e43ec8176379#subdirectory=skills-ref skills-ref validate skills/zola`
  reported `Valid skill: skills/zola`.
- [x] `tests/run.sh` passed with Zola 0.23.4: valid site and non-root URL
  checks passed; the broken-template check and build failed as expected.
- [x] The commit history on `main` records published changes via `what:`/`why:`
  commit bodies; no `CHANGELOG.md`, GitHub Release, or semver tag is required.
  Existing `phase-1`..`phase-5` tags are historical roadmap milestones.
- [x] `python3 scripts/check_commit_messages.py HEAD~30..HEAD` passed on
  2026-10-13, with concise subjects and non-empty `what:` and `why:` fields.
- [x] The commit bodies on `main` use `what:`/`why:` and the detailed rationale
  remains in commits and research/decision notes; no `CHANGELOG.md` exists.

## Historical milestone tags

- [x] `v1.0.0` is an annotated tag at `6b279b3`, the payload commit validated
  by the 2026-10-13 Codex and Claude Code smoke matrix. It does not have a
  GitHub Release or changelog. (Optional milestone/audit marker; `main` is the
  canonical install/update path.)
- [x] `v1.0.1` is an annotated tag at `95f046d`, the compatible human-voice
  review refinement. It does not have a GitHub Release or changelog. (Optional
  milestone/audit marker.)

## Published-package smoke matrix

Run each row from a separate empty temporary directory. The commands use
`--copy` so each agent receives a complete independent copy for inspection;
the temporary directory may then be removed safely. `skills.sh` documents
`codex` and `claude-code` as the corresponding agent identifiers and installs
project-scoped skills under `.agents/skills/` and `.claude/skills/`.

**Current payload shape (shared inspect-first routing contract):** 14 files —
`SKILL.md`, 6 workflows, 6 references, and
`scripts/check_runtime_contract.py`. Before publishing a package that includes
this shape, use the matrix below and treat runtime contract checks as hard
gates.

| Host | Install and verify | Pass condition |
| --- | --- | --- |
| Codex | `release_dir="$(mktemp -d)" && cd "$release_dir" && npx skills add CodeSigils/zola-skill@zola --agent codex --copy --yes && test "$(find .agents/skills/zola -type f -name '*.md' | wc -l)" -eq 13 && test "$(find .agents/skills/zola -type f | wc -l)" -eq 14 && test -f .agents/skills/zola/workflows/author-post.md && test -f .agents/skills/zola/references/editorial-review.md && test -f .agents/skills/zola/scripts/check_runtime_contract.py && python3 .agents/skills/zola/scripts/check_runtime_contract.py --self-test && python3 .agents/skills/zola/scripts/check_runtime_contract.py && npx skills ls -a codex` | The installed `zola` skill is listed, all 14 payload files exist (13 markdown + 1 runtime contract script), and runtime contract self-test/check pass. |
| Claude Code | `release_dir="$(mktemp -d)" && cd "$release_dir" && npx skills add CodeSigils/zola-skill@zola --agent claude-code --copy --yes && test "$(find .claude/skills/zola -type f -name '*.md' | wc -l)" -eq 13 && test "$(find .claude/skills/zola -type f | wc -l)" -eq 14 && test -f .claude/skills/zola/workflows/author-post.md && test -f .claude/skills/zola/references/editorial-review.md && test -f .claude/skills/zola/scripts/check_runtime_contract.py && python3 .claude/skills/zola/scripts/check_runtime_contract.py --self-test && python3 .claude/skills/zola/scripts/check_runtime_contract.py && npx skills ls -a claude-code` | The installed `zola` skill is listed, all 14 payload files exist (13 markdown + 1 runtime contract script), and runtime contract self-test/check pass. |

After recording each result, remove the exact temporary directory created for
that row, for example `rm -rf "$release_dir"`. Do not run the command from a
working repository and do not use a global install: the intent is a clean,
project-scoped published-package check.

### Runtime contract additions

For releases that include the shared inspect-first routing contract, the
published-package smoke matrix above is the pre-publish hard gate: it verifies
the script is present, total payload count is 14, and
`check_runtime_contract.py --self-test`/contract check pass in the installed
copy. Historical validation records below may reflect the previous 13-markdown
payload shape; do not treat them as evidence for a contract-script release.

## Phase 7 package additions

For the Phase 7 release candidate, extend each matching matrix command with
the host-specific checks for `workflows/author-post.md` and
`references/editorial-review.md`, and require all thirteen markdown payload
files (`SKILL.md`, six workflows, and six references). This reproducible
package install is the release gate. A live skills.sh file-tree check is
supplemental only: the unauthenticated file-snapshot endpoint may be
unavailable. This check cannot run against an uncommitted local payload. The
current matrix above already includes these Phase 7 assertions.

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

### 2026-09-06 current-main validation

Source: `CodeSigils/zola-skill@main`, commit `d978227`. Skills CLI: `1.5.23`.
The pinned `skills-ref` validator and `bash tests/run.sh` passed locally before
the package checks.

| Host | Result |
| --- | --- |
| Codex | Passed from a clean temporary directory: 13 Markdown payload files, including `author-post.md` and `editorial-review.md`, were installed under `.agents/skills/zola`; `skills ls -a codex` listed `zola`. |
| Claude Code | Pending target-specific verification. In the current Codex host, `skills add --agent claude-code` auto-detected Codex and installed under `.agents/skills/zola`, so this run is not evidence for `.claude/skills/zola`. Re-run the documented row from a Claude Code host before the next release. |

### 2026-10-13 current-main validation

Source: `CodeSigils/zola-skill@zola`, commit `6b279b3`. Skills CLI: `1.7.2`.
The pinned `skills-ref` validator and `bash tests/run.sh` passed locally before
the package checks.

| Host | Result |
| --- | --- |
| Codex | Passed from a clean temporary directory: 13 Markdown payload files, including `author-post.md` and `editorial-review.md`, were installed under `.agents/skills/zola`; `skills ls -a codex` listed `zola`. |
| Claude Code | Passed from a clean temporary directory: 13 Markdown payload files, including `author-post.md` and `editorial-review.md`, were installed under `.claude/skills/zola`; `skills ls -a claude-code` listed `zola`. |

### 2026-10-13 v1.0.1 release validation

Source: `CodeSigils/zola-skill@zola` on `main`, commit `95f046d`, which matches
the peeled `v1.0.1` tag. Skills CLI: `1.7.2`. The installer selector `@zola`
names the skill rather than a Git ref, so the matching main/tag commit is the
evidence that these clean installs contain the immutable release payload. Each
row also checked for the `Optional human-voice pass` heading in the installed
editorial-review reference.

| Host | Result |
| --- | --- |
| Codex | Passed from a clean temporary directory: 13 Markdown payload files, including `author-post.md` and `editorial-review.md`, were installed under `.agents/skills/zola`; the human-voice reference was present and `skills ls -a codex` listed `zola`. |
| Claude Code | Passed from a clean temporary directory: 13 Markdown payload files, including `author-post.md` and `editorial-review.md`, were installed under `.claude/skills/zola`; the human-voice reference was present and `skills ls -a claude-code` listed `zola`. |

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

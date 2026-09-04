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

## Published-package smoke matrix

Run each row from a separate empty temporary directory. The commands use
`--copy` so each agent receives a complete independent copy for inspection;
the temporary directory may then be removed safely. `skills.sh` documents
`codex` and `claude-code` as the corresponding agent identifiers and installs
project-scoped skills under `.agents/skills/` and `.claude/skills/`.

| Host | Install and verify | Pass condition |
| --- | --- | --- |
| Codex | `release_dir="$(mktemp -d)" && cd "$release_dir" && npx skills add <owner>/zola-skill@zola --agent codex --copy --yes && test -f .agents/skills/zola/SKILL.md && test -f .agents/skills/zola/workflows/debug-build.md && test -f .agents/skills/zola/workflows/i18n.md && test -f .agents/skills/zola/workflows/modify-review.md && test -f .agents/skills/zola/workflows/create-site.md && test -f .agents/skills/zola/workflows/theme-override.md && test -f .agents/skills/zola/references/source-registry.md && test -f .agents/skills/zola/references/accessibility-review.md && test -f .agents/skills/zola/references/content-model.md && test -f .agents/skills/zola/references/release-review.md && test -f .agents/skills/zola/references/tera-template-context.md && npx skills ls -a codex` | The installed `zola` skill is listed and all eleven files exist. |
| Claude Code | `release_dir="$(mktemp -d)" && cd "$release_dir" && npx skills add <owner>/zola-skill@zola --agent claude-code --copy --yes && test -f .claude/skills/zola/SKILL.md && test -f .claude/skills/zola/workflows/debug-build.md && test -f .claude/skills/zola/workflows/i18n.md && test -f .claude/skills/zola/workflows/modify-review.md && test -f .claude/skills/zola/workflows/create-site.md && test -f .claude/skills/zola/workflows/theme-override.md && test -f .claude/skills/zola/references/source-registry.md && test -f .claude/skills/zola/references/accessibility-review.md && test -f .claude/skills/zola/references/content-model.md && test -f .claude/skills/zola/references/release-review.md && test -f .claude/skills/zola/references/tera-template-context.md && npx skills ls -a claude-code` | The installed `zola` skill is listed and all eleven files exist. |

After recording each result, remove the exact temporary directory created for
that row, for example `rm -rf "$release_dir"`. Do not run the command from a
working repository and do not use a global install: the intent is a clean,
project-scoped published-package check.

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

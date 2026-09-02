# Release Checklist

Use this checklist only after the `zola-skill` repository is publicly
resolvable at its final owner/repository path. It records the Phase 1 release
checks that cannot be meaningfully run against the local source tree.

## Pre-publish

- [ ] Replace `<owner>` below with the published repository owner; the release
  source must resolve as `<owner>/zola-skill@zola`.
- [ ] Confirm [`LICENSE`](../LICENSE) contains MIT terms and
  `skills/zola/SKILL.md` declares `license: MIT`.
- [ ] Run `npx --yes skills-ref validate skills/zola`.
- [ ] Run `tests/run.sh` with Zola 0.23.4 and record its output in the release
  notes or pull request.

## Published-package smoke matrix

Run each row from a separate empty temporary directory. The commands use
`--copy` so each agent receives a complete independent copy for inspection;
the temporary directory may then be removed safely. `skills.sh` documents
`codex` and `claude-code` as the corresponding agent identifiers and installs
project-scoped skills under `.agents/skills/` and `.claude/skills/`.

| Host | Install and verify | Pass condition |
| --- | --- | --- |
| Codex | `release_dir="$(mktemp -d)" && cd "$release_dir" && npx skills add <owner>/zola-skill@zola --agent codex --copy --yes && test -f .agents/skills/zola/SKILL.md && test -f .agents/skills/zola/workflows/debug-build.md && test -f .agents/skills/zola/references/source-registry.md && npx skills ls -a codex` | The installed `zola` skill is listed and all three files exist. |
| Claude Code | `release_dir="$(mktemp -d)" && cd "$release_dir" && npx skills add <owner>/zola-skill@zola --agent claude-code --copy --yes && test -f .claude/skills/zola/SKILL.md && test -f .claude/skills/zola/workflows/debug-build.md && test -f .claude/skills/zola/references/source-registry.md && npx skills ls -a claude-code` | The installed `zola` skill is listed and all three files exist. |

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

# Repository Instructions

## Documentation and change contract

`docs/README.md` is the index and selection contract for this repository's
planning documents.

Before changing the skill design, its implementation, any planning document,
`README.md`, or this file:

1. Read `docs/README.md`.
2. Identify every reading-matrix row that applies and read the union of the
   documents those rows require.
3. Apply the document-update rules before completing the work.

Do not edit until the required documents have been read.

Do not read every planning document by default. Read the smallest set required
by the matrix, and do not treat `docs/` as runtime instructions for the future
skill.

Before finalizing a change, verify that every affected planning document was
updated or explicitly state why no update was needed. Do not change scope,
roadmap sequencing, evidence-backed decisions, or deferred-capability guidance
without updating its source document.

For a meaningful handoff, distinguish current claims from dated historical
evidence, search affected terms for stale counts, versions, commands, and
status language, and compare each current claim with its canonical owner. Only
recheck volatile or decision-critical external facts at the point of use. This
is a focused manual freshness review, not a recurring audit or documentation
linter.

## Runtime distribution contract

`skills/zola/` is the canonical runtime payload. Installed copies are
distribution artifacts, not a second source of truth. After a runtime-payload
change, verify or refresh an installed copy only when active-host use or a
release/install check requires it; otherwise report that a running host session
may still use an older copy. A source commit does not update installed skills
or a running host automatically.

## Mandatory phase-close documentation gate

At the end of **every** roadmap phase, before reporting that phase complete or
starting the next one:

1. Re-read `docs/README.md` and apply every matching reading-matrix row.
2. Update every planning document affected by the completed work, including the
   roadmap's phase status, acceptance evidence, commands and outcomes,
   source-registry facts, and any changed scope or deferred-capability guidance.
3. Update review dates where evidence was rechecked, verify affected relative
   Markdown links, and record any intentionally unchanged document with the
   reason in the handoff.

This gate applies even when the implementation change is small. A phase is not
complete until its documentation updates and verification are complete.

Creating, removing, renaming, or materially changing the role of a planning
document requires updating `docs/README.md` and any affected related-document
links. Before handoff, verify that changed relative Markdown links resolve and
still describe the linked document accurately.

## Commit message contract

Every commit must have a concise imperative subject and a detailed body with
both labeled fields below:

```text
<imperative subject>

what: Describe the files, behavior, or documentation changed.
why: Explain the user need, evidence, or design reason for the change.
```

Keep `what:` and `why:` in the commit body even for small changes. Add
validation details after those fields when useful, but do not replace either
required label with an unlabeled summary.

Run `python3 scripts/check_commit_messages.py HEAD` before handoff. To review a
batch, pass a range such as `HEAD~5..HEAD`. The checker enforces a concise
subject plus non-empty `what:` and `why:` fields.

Keep `CHANGELOG.md` curated: record user-visible or maintainer-significant
changes, group related work under `Unreleased`, and periodically consolidate it
into release notes. Commit history, research, decisions, and session notes hold
the detailed implementation and rationale; do not mirror every commit in the
changelog.

### Repeated-value heuristic

During review, notice repeated semantic values as possible duplication or drift
smells. If a version, runner, operating system, path, SHA, feature flag, port,
or similar value is repeated and should change together, recommend a visible,
named canonical source. The count is a signal, not a doctrine: keep incidental
literals, examples, prose, fixtures, and repetition that improves clarity.
Report the evidence and trade-off before extracting anything.

When an authorized edit leaves a focused, validated Git diff, identify it as
ready to commit and offer that next step. Do not infer commit, push,
pull-request, publish, or deployment authorization.

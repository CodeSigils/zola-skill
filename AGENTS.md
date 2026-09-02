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

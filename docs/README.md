# Planning Documentation Index

This directory is the maintained source of truth for the Zola skill's design.
Follow this selection matrix before changing the skill or these documents.

Phase 3's existing-site modification/review, site-creation, and extended
debug/build slices are in progress; see [roadmap.md](roadmap.md). Planning
documents are maintainer context, not future runtime context for the skill.

## Reading matrix

| Proposed change                                                     | Required reading                                                                                   |
| ------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------- |
| Any skill implementation or behavior change                         | [vision.md](vision.md), [roadmap.md](roadmap.md)                                                   |
| Debug-build workflow or validation change                           | [vision.md](vision.md), [roadmap.md](roadmap.md), [research.md](research.md)                       |
| Scope, trigger, v1-boundary, or acceptance-criteria change          | [vision.md](vision.md), [roadmap.md](roadmap.md)                                                   |
| Roadmap phase, dependency, or release-gate change                   | [roadmap.md](roadmap.md), [vision.md](vision.md)                                                   |
| External pattern, source, license, or architecture-decision change  | [research.md](research.md), [vision.md](vision.md), [roadmap.md](roadmap.md)                       |
| Distribution layout, Agent Skills compatibility, or skills.sh release change | [vision.md](vision.md), [roadmap.md](roadmap.md), [research.md](research.md)                 |
| JavaScript, Rust, WebAssembly, runtime-service, or Zola-core change | [future-capabilities.md](future-capabilities.md), [vision.md](vision.md), [roadmap.md](roadmap.md) |
| Editorial change to one planning document only                      | The target document and every document whose decision, scope, or link changes                      |

## Update rules

| Change affects                                                                 | Required update          |
| ------------------------------------------------------------------------------ | ------------------------ |
| Skill scope, operating rules, acceptance criteria, or capability boundary      | `vision.md`              |
| Sequencing, phase exit criteria, dependencies, or release gate                 | `roadmap.md`             |
| External evidence, comparison, architecture decision, or adoption provenance   | `research.md`            |
| Distribution layout, portability contract, or release validation                | `vision.md`, `roadmap.md` |
| Deferred JavaScript, Rust, WebAssembly, runtime-service, or Zola-core guidance | `future-capabilities.md` |

Before completing work, update every affected document. If no document update is
needed, state why in the handoff or final response.

## Mandatory phase-close gate

Before a roadmap phase is marked complete or work begins on the next phase,
re-read this index, apply the reading matrix, and update every document affected
by the completed work. The phase handoff must include the updated roadmap
status, acceptance evidence and observed validation results, source-registry or
research changes, review dates for rechecked evidence, verified affected links,
and a reason for each planning document intentionally left unchanged. A phase is
not complete until this documentation gate passes.

## Document roles

- [vision.md](vision.md): durable scope, operating principles, acceptance
  criteria, and known gaps.
- [roadmap.md](roadmap.md): phased delivery plan and v1 release gate.
- [research.md](research.md): external evidence, comparable patterns, and
  architecture decisions.
- [future-capabilities.md](future-capabilities.md): explicitly deferred
  capability guidance; not v1 runtime context.
- [release-checklist.md](release-checklist.md): versioned public-release
  verification steps; not runtime skill context.

Review time-sensitive material before a release, after a Zola upgrade, or every
six months.

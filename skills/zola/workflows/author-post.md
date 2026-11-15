# Bounded post authoring

Read this only for an explicit request to draft, edit, or prepare a post in an
existing Zola repository. It is not a general writing, CMS, SEO, or publishing
workflow.

## Inspect conventions before writing

1. Confirm the target repository, content root, requested page, and whether the
   request authorizes a draft or an edit. Inspect `.gitmodules`, symlinks, and
   the resolved content/configuration paths before assuming the repository root
   owns the content.
2. Inspect comparable pages and their section `_index.md`, front matter,
   taxonomy values, language files, route-affecting fields, assets, shortcodes,
   draft convention, templates, and existing validation commands.
3. Preserve observed conventions. Ask for missing title, audience, facts,
   sources, disclosure, date, or publication intent rather than inventing
   metadata, citations, authorship, AI-use claims, licenses, or taxonomy terms.

## Article-start handoff (substantive drafting)

For a substantive new draft or major revision, do this after inspection and
before writing substantive prose. Keep it compact (working conversation unless
the target owns an article-brief format):

- **Form and reader question:** name the page/article form (field note, guide,
  explainer, reference, note, etc.) and the reader’s question or task.
- **Supportable claim:** state the bounded insight, recommendation, or
  uncertainty the author can actually support with available evidence.
- **Evidence boundary:** distinguish direct observation, repository evidence,
  current primary sources, clearly labelled community reports, and volatile
  facts that need a current source; name any maintainer-supplied context you
  must ask for.
- **Minimal sketch:** outline only the sections needed to carry the reader from
  opening context/observation to a useful takeaway.

This is target-guidance-first (not a mandatory template, score, or gate). A
short note, light edit, or target-owned brief can use a smaller version or the
existing process. About a third into an evidence-heavy draft, check that the
claim remains supportable, evidence explains rather than accumulates, and the
structure still fits the chosen form.

## Make the bounded change

- Create or edit only the authorized content and directly required local assets.
  Preserve the page/section role, route, aliases, translations, and established
  front-matter shape unless an authorized change requires otherwise.
- Use a current timestamp only when the repository convention and request call
  for one; obtain it from the environment rather than guessing it. Do not set
  `published`, author, or disclosure fields without an explicit factual basis.
- Apply repository-specific editorial rules only after locating them. For
  substantive drafting, revision, or article-quality review, read the
  [editorial-review reference](../references/editorial-review.md) and follow
  target rules first (form-fit, evidence/attribution, voice-preserving mechanics).
- Do not create branches, commit, push, open a pull request, request review,
  or publish unless separately authorized. Report a proposed handoff using the
  repository's observed conventions instead.

## Validate and report

Run the smallest safe project validation, normally `zola check
--skip-external-links` followed by an isolated `zola build`. Inspect the changed
generated route, generated links, and copied assets. State whether external
link coverage was skipped and report the exact metadata and assumptions that
remain user-supplied.


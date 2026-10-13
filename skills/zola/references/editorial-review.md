# Bounded article-quality review

Read this only for an explicit review of article quality in an existing Zola
site. It does not establish correctness, SEO performance, legal clearance, or
a house style that the repository does not contain.

## Inspect evidence and local rules

Read the requested page, its front matter, its rendered route where available,
and the repository's documented editorial conventions. Check that material
factual claims have supplied, attributable support or are clearly qualified;
that linked source URLs point to the cited resource; and that stated authorship
or AI-assistance disclosures are factual, explicit, and consistent with local
conventions.

Review readability through concrete observations: ambiguous references,
overlong or overloaded sentences, unexplained terms, mismatched headings, and
links whose purpose is unclear in surrounding prose. Apply a language, tone,
voice, SEO formula, rhetorical quota, or shortcode rule only when the target
repository documents it.

## Optional human-voice pass

Use this pass only when the user explicitly asks for voice or tone feedback and
the target repository's editorial guidance permits it. First identify the
draft's observed voice traits worth preserving, such as its register, rhythm,
punctuation, or genuine warmth. Improve that voice; do not replace it with a
house style.

Look for clusters rather than isolated wording: unnecessary scene-setting,
headings or transitions that announce their own significance, emphasis without
new evidence, invented maxims, inflated moral stakes, exhaustive lists of what
something is not, precision that does not affect the reader's decision, or
forced all-or-nothing conclusions. Recommend a more direct statement only
where it preserves the author's meaning, evidence, and useful distinctions.

Generic documentation-template prose is a concern only when it displaces an
author's observation, reasoning, or relevant reader context. Direct,
conventional prose is often the better choice for reference material and fast
retrieval. Likewise, retain a contrast, measurement, or strong judgment when
it does factual or argumentative work. Do not treat a single phrase as proof,
rewrite quoted or titled language, fabricate personality or experience, or
turn this review into an automatic rewrite or publication gate.

For an article, field note, narrative technical guide, or explainer, also
consider whether a major transition leaves the reader without context. Suggest
one or two voice-consistent orienting sentences only when a new section changes
the reader's task, system layer, risk, or mode of work and the surrounding
prose does not already make that connection. Do not add connective prose to a
reference page merely to make it warmer.

## Related review workflows

- [Modify/review workflow](../workflows/modify-review.md) for the required
  finding format and authorization boundary.
- [Accessibility review](../references/accessibility-review.md) when review
  scope includes template accessibility alongside content.
- [Release review](../references/release-review.md) when content review
  accompanies a pre-release static-site review.

## Report bounded findings

Report each finding as:

`severity | path | evidence | impact | remediation | validation`

Use `blocker` for a factual error, unsupported claim, or broken content link;
`warning` for a readability or citation risk; and `note` for a bounded
improvement. Mark a claim as unverified when its source cannot be checked; do
not invent a source or rewrite an opinion as fact. Tie every finding to
repository evidence. Include passing checks and remaining limits, but do not
modify content during a review-only request. For an authorized revision,
preserve the article's observed front-matter and route unless the request
explicitly changes them.

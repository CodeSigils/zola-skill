# Bounded article-quality review

Read this for explicit article-quality review and for substantive drafting or
revision in an existing Zola site. Apply it as a portable suggestion pass, not
a house style, SEO formula, or publication gate. Read and follow the target
repository's editorial guidance first. The target decides voice, argument, and
form; this reference supplies mechanics, structure checks, and Zola-aware
validation without inventing experience, facts, sources, or metadata.

When guidance conflicts, follow the target repository's published editorial
rules first, then the user's explicit instruction, then a supplied writing
sample, then general defaults. A writing sample lends style traits only; it
never supplies facts, claims, or experiences.

## Inspect evidence and local rules

Read the requested page, its front matter, its rendered route where available,
and the repository's documented editorial conventions. Check that material
factual claims have supplied, attributable support or are clearly qualified;
that linked source URLs point to the cited resource; and that stated authorship
or AI-assistance disclosures are factual, explicit, and consistent with local
conventions and the [content-model reference](content-model.md).

## Form-fit and scope

Before suggesting a rewrite, name what the page is trying to be and what the
reader needs from it (field note, experiment report, guide, explainer,
reference, note, etc.). Use that to choose structure and to **decline an
unnecessary rewrite**:

- Do not impose a narrative/scene opening on a reference page that should lead
  with the answer and preserve fast retrieval.
- Do not force a generic documentation skeleton onto a field note that needs an
  observation, evidence boundary, and consequence.
- Keep direct, conventional prose when it serves retrieval or the target voice.
- Record the chosen form and the reason for any shape recommendation or
  declined rewrite in the report.

## Evidence-led shaping and transitions

Let evidence and reader need drive structure rather than a fixed template:

- For an evidence-heavy draft (field note/experiment/technical essay), prefer a
  useful chain where it fits: observation or claim, supporting evidence/source
  (with boundary/limits), then consequence for the reader’s next decision.
  Combine repeated labels/lists when they do not change that decision.
- A reference page may lead with the answer; do not invent first-person
  experience or observations the author cannot supply (leave an author note
  where such perspective is necessary but absent).
- Check major transitions: if a new section changes the reader’s task, system
  layer, risk, or mode of work and the surrounding prose does not orient them,
  suggest one or two voice-consistent orienting sentences. Do not add
  connective prose where the heading/text already orients the reader or where
  rapid reference retrieval is the purpose. Do not invent stakes/perspective.

## Readability and voice (target-led, density-based)

Review readability through concrete observations: ambiguous references,
overlong or overloaded sentences, unexplained terms, mismatched headings, and
links whose purpose is unclear in surrounding prose. Apply a language, tone,
voice, SEO formula, rhetorical quota, or shortcode rule only when the target
repository documents it.

When asked for voice/tone feedback (and the target permits it), first
characterize and preserve the draft’s observed voice (register, rhythm,
punctuation, genuine warmth/humor) from the draft and any supplied sample;
improve that voice, do not replace it with a house style.

Flag machine-typical prose as **clusters and density mismatches**, not single
instances. A phrase that is quoted/titled/under discussion, or a contrast that
does factual/argumentative work, is load-bearing—not a tell. Families worth
flagging when they cluster: unnecessary scene-setting/announced significance,
negative-antithesis inversions or justification antitheses used as filler,
emphasis without new evidence, invented maxims/aphorisms, inflated stakes or
forced binaries, exhaustive “what it is not” lists, research-simulated
precision, stacked rhetorical questions, opener/filler tics, formulaic
three-part lists or fragment-stacked inventories, colon/dash-heavy reveals,
scope inflation, copula avoidance, present-participle padding, and performed
authenticity. Prefer a direct statement of the fact/procedure/tradeoff that
preserves meaning.

Generic documentation-template prose is a concern only when it displaces the
author's observation, reasoning, or relevant reader context; do not add
informality, slang, typos, or invented personality to sound human.

## Optional mechanics and de-slop lens

- **Mechanics/rhythm (optional, target-guidance-led):** if punctuation/flow is
  in scope, read dense passages for how stops relate ideas. Prefer a period,
  comma, colon, or recast to an em dash/semicolon when natural; retain em dash
  only for a genuine interruption/parenthetical and semicolon only for tight
  balanced clauses. Preserve punctuation required by quotation, code, citation,
  or established voice. Not a count threshold or validation condition.
- **Optional de-slop lens:** when the user explicitly asks for a more human
  voice pass and a community de-slop skill is installed, it may be used as an
  additional sentence-level lens (triage, never a gate). Its phrase lists do
  not override the density/load-bearing/quotation rules above. Honor the
  author’s voice, keep structure/facts/uncertainty, report rather than rewrite;
  do not strip connectives or flatten useful structure.

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

Use `blocker` for a concrete correctness, factual error, unsupported claim, or
broken content/route problem; `warning` for a material clarity, evidence, or
maintenance risk; and `note` for a bounded improvement. Mark a claim as
unverified when its source cannot be checked; do not invent a source or rewrite
an opinion as fact. Tie every finding to repository evidence. Include passing
checks, remaining limits, and (for substantive review) the observed voice
traits worth preserving plus the chosen form/any declined rewrite.

Do not modify content during a review-only request. For an authorized revision,
preserve the article's observed front-matter and route unless the request
explicitly changes them. Use tell families as a coverage aid, not an exhaustive
audit; report material patterns and clean results that change the reader’s
decision (do not pad with one "none" finding per family).

<dcp-message-id>m1661</dcp-message-id>

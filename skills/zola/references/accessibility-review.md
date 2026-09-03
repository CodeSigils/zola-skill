# Bounded template accessibility review

Read this only for an explicitly requested accessibility review of an existing
Zola site's templates or generated pages. It supports concrete static findings;
it does not establish WCAG conformance, test assistive technology, or authorize
a redesign.

## Inspect source and generated output

1. Inspect the templates and rendered pages in scope. Identify meaningful page
   regions using semantic elements where the page has navigation, main content,
   headers, or footers; do not add ARIA roles without a repository-specific
   need.
2. Check that headings describe the page's organization and follow a logical
   hierarchy. Report a skipped level only when the rendered structure makes the
   section relationship unclear.
3. Check each changed or in-scope image by purpose: informative images need a
   concise alternative that conveys essential information, decorative images
   need `alt=""`, and an image functioning as a link or button needs an
   alternative that describes that action.
4. Check that each in-scope link communicates its destination or action through
   its text or directly associated context. Do not call a short link defective
   when the rendered context demonstrably supplies its purpose.

## Report limits precisely

Use the review finding format from
[the modification/review workflow](../workflows/modify-review.md). Include the
rendered path and exact markup as evidence, plus the validation used after a
repair. State that keyboard behavior, focus treatment, contrast, responsive
layout, assistive-technology behavior, and conformance level were not assessed
unless the request and evidence specifically cover them.

## Source boundary

Use the W3C WAI rows in the [source registry](source-registry.md). They support
these static checks, not a universal ARIA pattern or a compliance certification.

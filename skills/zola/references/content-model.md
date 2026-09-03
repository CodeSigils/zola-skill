# Bounded content-model changes

Read this only for an authorized existing-site change involving content files,
front matter, routes, or co-located assets. Preserve the current content model;
do not use it to introduce a blog, search, feeds, a taxonomy, or a new
information architecture without an explicit request.

## Inspect before changing structure

1. Map the affected `content/` directory, its nearest `_index.md`, existing
   page/section templates, generated links, and any translated variants.
2. Treat `_index.md` as section content and metadata. Treat `index.md` as a
   page at its directory path; other Markdown files are pages at their file
   paths unless front matter changes the route.
3. Inspect `slug`, `path`, aliases, section sorting, and template settings
   before changing a filename or front matter. A page `path` overrides both its
   `slug` and the section-derived path, so it can change more than the filename
   suggests.

## Make the smallest route-preserving change

- Keep the existing page-versus-section role unless the request names a
  structural change. Do not replace `_index.md` with `index.md`, or the
  reverse, solely to make a route appear.
- For a page that needs co-located assets, use a dedicated directory with
  `index.md`; inspect existing relative asset links before moving it. Do not
  relocate unrelated content or assets.
- Preserve active language files, configured section behavior, generated URLs,
  and existing aliases. Propose a redirect/alias change only when the requested
  route move and the site's existing redirect policy justify it.

## Validate the requested result

Run the project's safe `zola check` and isolated `zola build` arrangement, then
inspect the affected generated route, links, and copied assets. State if
external Markdown-link checking was skipped. For a route or structure change,
report the old and new observed paths and any remaining redirect or translation
assumption.

## Source boundary

Use the content overview, page, and section rows in the
[source registry](source-registry.md). Recheck them when the installed Zola
version differs from the verified version.

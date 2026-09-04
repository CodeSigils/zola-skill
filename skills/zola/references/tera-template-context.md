# Bounded Tera template-context interpretation

Read this only when diagnosing a Tera template/rendering failure or reviewing
escaping or undefined-variable behavior in an existing Zola site's templates.
It supports interpreting the construct actually observed; it does not list
every Tera feature or teach theme authoring.

## Interpret the observed construct

1. Recognize the three Tera delimiters: `{{ ... }}` renders an expression,
   `{% ... %}` is a statement or logic tag, and `{# ... #}` is a comment that
   produces no output. Text inside a `{% raw %}` block is emitted verbatim and
   is not rendered.
2. Distinguish a template error from a content error by reading the diagnostic.
   Tera reports the template/file and line; undefined-variable and filter-type
   failures name the expression. Do not edit a content file to fix a template
   diagnostic, or the reverse.
3. Before changing behavior, print the context with `{{ __tera_context }}` in
   the affected template to see exactly which variables are available to it,
   then remove that marker before build.

## Honor auto-escaping and `safe`

Tera auto-escapes `.html`, `.htm`, and `.xml` templates; it does no contextual
escaping, so an unescaped value in an attribute or a script context is not
detected automatically. `safe` marks an expression as already-safe HTML and is
honored only when it is the last filter in the expression, so order matters.
Review every `| safe` by its provenance: rendered Zola Markdown is not the same
as a configuration, data, or user-supplied value. Do not add `safe` to suppress
a rendering problem.

## Account for undefined and missing values

Accessing or rendering an undefined variable is an error, and a missing field
on a defined variable is also an error; only one level of undefined-ness is
silently tolerated. Undefined variables are falsy in `{% if %}` tests, so the
standard presence test is `{% if var %} ... {% else %} ... {% endif %}`. Tera
has no built-in way to render a template while ignoring missing variables, so a
`{{ var }}` that must be optional needs an explicit fallback such as
`{{ var or "default" }}` or an `if` branch.

## Source boundary

Use the Tera row and the Zola template-overview row in the
[source registry](source-registry.md), plus the relevant template/page/section
rows, for the constructs the workflows actually exercise. Recheck them when the
installed Zola version differs from the verified version, and do not claim a
Tera feature that is not present in those sources.

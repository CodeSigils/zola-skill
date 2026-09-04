# Future Capabilities

**Status:** Deferred beyond v1  
**Owner:** Project maintainers  
**Review cadence:** Revisit only when a proposed workflow has a concrete user
need, evaluation scenario, and maintenance owner

This document preserves the vision's long-term guidance for JavaScript, Rust,
WebAssembly, runtime services, and changes to Zola itself. It is not loaded as
part of the v1 operational skill.

## Related planning documents

- [vision.md](vision.md) defines the core Zola skill and its v1 boundary.
- [roadmap.md](roadmap.md) identifies when deferred capabilities may be
  reconsidered.

## Extending Zola with JavaScript and Rust

Zola should remain the **static, content-first foundation** of the site. Extend it with JavaScript or Rust only when the additional capability produces clear user value that cannot be achieved well through semantic HTML, CSS, Zola templates, front matter, data files, or build-time generation.

The default priority order is:

1. Native Zola and Tera capabilities.
2. HTML and CSS.
3. Build-time generation and automation.
4. Small, progressive JavaScript enhancements.
5. External APIs or serverless/edge functions for genuinely dynamic requirements.
6. Rust/WASM client-side modules only when their unique benefits justify their delivery and maintenance cost.
7. A custom Zola fork or upstream contribution only when no safer extension boundary is viable.

### 1. Decision framework

Before recommending JavaScript, Rust, WebAssembly, a serverless function, or a Zola core modification, the agent must classify the capability.

- **Static deterministic transformation:** Zola/Tera, front matter, data
  files, or a Rust pre-build tool; produces cacheable output with no client
  runtime cost.
- **Layout or state-free interaction:** semantic HTML and CSS; preserves
  accessibility, resilience, and performance.
- **Optional browser interaction:** a small progressive JavaScript module;
  adds convenience while retaining a functional HTML baseline.
- **Local static-corpus search:** static index plus lightweight JavaScript;
  avoids a runtime backend.
- **Private, personalized, transactional, or real-time behavior:** separate
  backend/API or serverless/edge function; it requires runtime identity, state,
  or authorization.
- **Compute-heavy deterministic browser task:** Rust/WASM only after comparing
  it with JavaScript; it adds build and debugging cost.
- **Reusable build-time processing:** standalone Rust CLI, Cargo workspace, or
  CI task; this aligns with Zola's static pipeline.
- **Broad missing generator feature:** upstream issue, proposal, or
  contribution; avoid a private fork.

The agent must explicitly answer these questions before selecting an approach:

1. Can the requirement be satisfied at build time?
2. Does it need user-specific data, credentials, mutable state, or real-time updates?
3. Must the site remain fully usable without JavaScript?
4. What is the acceptable JavaScript, WebAssembly, and network budget?
5. Is the feature public, privacy-sensitive, regulated, or identity-aware?
6. Who owns updates, dependency patching, telemetry, monitoring, and incident response?
7. Can the capability be implemented as a separate service rather than modifying Zola itself?

### 2. Static-first extension strategy

The agent should prefer static generation for logic that is deterministic from repository inputs.

Suitable build-time capabilities include:

- Generating navigation structures from sections, taxonomies, or structured data.
- Producing documentation indexes, API reference pages, changelogs, release notes, and cross-reference maps.
- Building search indexes from published content.
- Generating JSON, XML, CSV, or machine-readable catalogs from front matter.
- Precomputing related-content links, reading-time data, breadcrumbs, tag clouds, or graph metadata.
- Enriching Markdown or data files through controlled scripts in CI.
- Validating front matter, content schemas, link integrity, image metadata, or taxonomy policy before publishing.
- Generating redirect maps, sitemap augmentations, Open Graph image manifests, or content inventories.

The agent should recommend a **Rust pre-build tool** when the work is repeatable, data-intensive, needs strong typing, or belongs in a reliable publishing pipeline.

A typical architecture is:

```text
content/ + data/ + external approved inputs
                │
                ▼
       Rust pre-build CLI
       - validate schemas
       - enrich content
       - generate data/indexes
                │
                ▼
       generated/ or data/
                │
                ▼
            zola build
                │
                ▼
           public/ static site
```

Rules for generated artifacts:

- Keep generated source inputs separate from Zola’s `public/` output.
- Document whether generated files are committed or created in CI.
- Make generation deterministic and idempotent.
- Validate schemas and fail the build on malformed inputs.
- Pin toolchain and dependency versions.
- Avoid embedding secrets in generated output.
- Record provenance when generated content comes from external APIs.

### 3. JavaScript strategy: progressive enhancement

JavaScript should enhance a usable static site, not become a hidden dependency for essential information or navigation.

#### Appropriate JavaScript use cases

- Theme switching with an accessible persisted preference.
- Copy-to-clipboard controls for code blocks.
- Accessible disclosure widgets, tabs, dialogs, and mobile navigation.
- Client-side full-text search over a prebuilt index.
- Table-of-contents highlighting.
- Filter or sort controls for already-rendered lists.
- Syntax-enhanced code examples.
- Optional diagrams, maps, visualizations, or calculators.
- Form enhancement around a serverless or third-party endpoint.
- Consent-managed analytics or privacy preferences.

#### Avoid JavaScript for

- Rendering primary article content.
- Rendering primary navigation with no static fallback.
- Basic navigation links, simple accordions, or layout that HTML/CSS can provide.
- Static SEO metadata.
- Content that must be reliably indexable or available on constrained devices.
- Secret-bearing API calls.
- Authorization decisions.
- Complex application state that indicates the project may no longer be a static-site problem.

#### JavaScript implementation rules

- Use standard browser APIs and small ES modules before adopting a framework.
- Load JavaScript with `defer` or `type="module"` unless there is a documented exception.
- Scope scripts to the pages that need them through template blocks.
- Use feature detection rather than browser sniffing.
- Avoid hydration and client-side rendering for content Zola already rendered.
- Keep DOM selectors stable through data attributes, such as `data-search-input`.
- Use event delegation where appropriate.
- Respect `prefers-reduced-motion`.
- Preserve keyboard behavior, focus management, labels, and ARIA semantics.
- Treat all browser-provided and API-provided values as untrusted input.
- Avoid inline event handlers and inline scripts when a Content Security Policy is desired.
- Pin third-party packages, audit them, and minimize transitive dependencies.
- Measure shipped JavaScript and network requests before and after the change.

Example progressive enhancement pattern:

```html
<form action="/search/" method="get" data-search-form>
  <label for="site-search">Search documentation</label>
  <input id="site-search" name="q" type="search" autocomplete="off">
  <button type="submit">Search</button>
</form>

<div id="search-results" aria-live="polite"></div>
```

```js
const form = document.querySelector('[data-search-form]');

if (form) {
  form.addEventListener('submit', async (event) => {
    event.preventDefault();
    // Load a static index, perform local search, and render escaped result text.
    // The normal form action remains available when JavaScript is unavailable.
  });
}
```

The HTML form remains understandable and functional as a conventional navigation path; JavaScript provides a faster local-search experience when available.

#### Bundler integration patterns

Zola does not bundle JavaScript or TypeScript. For anything beyond small ES modules, integrate an external bundler (Vite, esbuild, Rspack, Rollup) as a pre-build step.

##### When a Bundler Is Justified

- Multiple ES modules with interdependent imports
- TypeScript source files
- CSS-in-JS, PostCSS, Tailwind (via PostCSS), or complex asset transforms
- Framework components (React, Svelte, Vue) — but reconsider whether Zola remains the right tool if framework hydration dominates

##### Recommended Workflow

1. **Separate bundler project** — Create a `frontend/` or `assets/` directory with its own `package.json`, bundler config, and source files
2. **CI build order** — Run bundler first, output to `static/js/` and `static/css/`:

   ```bash
   # In CI / build script
   cd frontend && npm ci && npm run build  # outputs to ../static/js/bundle.js, ../static/css/bundle.css
   zola build
   ```

3. **Template references** — Use Zola's `get_url`:

   ```tera
   <link rel="stylesheet" href="{{ get_url(path='css/bundle.css') }}">
   <script type="module" src="{{ get_url(path='js/bundle.js') }}" defer></script>
   ```

##### Development Workflow

Run both servers in parallel — they watch independent file sets:

```bash
# Terminal 1: Zola (HTML, Tera, Sass, content)
zola serve

# Terminal 2: Bundler (JS/TS, HMR)
cd frontend && npm run dev
```

No conflict: Zola serves `http://127.0.0.1:1111`, bundler HMR connects via its own port.

##### What NOT to Do

- Do not commit `node_modules`; it bloats repositories and can contain
  platform-specific binaries.
- Do not expect Zola to process `.ts`, `.tsx`, `.vue`, or `.svelte`; it only
  compiles Sass/SCSS.
- Do not hydrate content Zola already rendered; this defeats static-site
  benefits and adds complexity without value.
- Do not mix an external bundler's configuration into the Zola root without a
  clear boundary; it makes either tool harder to upgrade.

##### Minimal Bundler Config Example (Vite)

```js
// frontend/vite.config.js
import { defineConfig } from 'vite';

export default defineConfig({
  build: {
    outDir: '../static',
    emptyOutDir: true,
    rollupOptions: {
      input: {
        main: './src/main.ts',
      },
      output: {
        entryFileNames: 'js/[name].js',
        chunkFileNames: 'js/[name].js',
        assetFileNames: 'css/[name].[ext]',
      },
    },
  },
});
```

> **Note:** For full bundler integration guidance, see `references/javascript-enhancement-guide.md` (to be created per Section 7).

### 4. Search strategy

Search is one of the most common reasons to add browser logic to a static site. The agent should evaluate it carefully.

- **Small site:** browser find, taxonomy navigation, and a generated index page
  may be sufficient.
- **Medium public documentation/blog:** a prebuilt static index plus a
  lightweight client-side module.
- **Large corpus:** sharded/static indexes, precomputed metadata, and measured
  client-side search; consider hosted search only if justified.
- **Private or personalized content:** an authenticated backend search service;
  never expose restricted content in a public static index.
- **Enterprise knowledge platform:** evaluate identity-aware search,
  authorization trimming, auditability, data residency, and indexing governance
  separately from Zola.

Search index rules:

- Generate the index during the build or pre-build stage.
- Include only content that is meant to be public to every visitor who can download the index.
- Strip secrets, drafts, internal metadata, and restricted text.
- Keep index fields minimal: title, URL, excerpt, headings, tags, and optionally normalized body text.
- Version or fingerprint the index for caching.
- Provide an accessible empty state, loading state, no-results state, and keyboard navigation.
- Test search with non-ASCII text, punctuation, long queries, and multilingual content if applicable.

### 5. Rust build tooling strategy

Rust is most valuable around Zola as a robust **build-time companion**, not necessarily as code embedded inside templates or browser pages.

#### Recommended Rust extension patterns

1. **Pre-build content pipeline**
   - Parse and validate front matter.
   - Normalize structured data.
   - Enrich content from approved sources.
   - Generate data files consumed by Zola templates.

2. **Content quality linter**
   - Enforce required front-matter fields.
   - Check title length, descriptions, ownership labels, review dates, taxonomies, or content classification.
   - Detect broken internal cross-references before Zola build.
   - Enforce documentation or editorial standards.

3. **Structured-data generator**
   - Convert domain models, OpenAPI descriptions, CSV exports, or YAML inventories into Markdown or JSON data for Zola.
   - Build architecture catalogs, service directories, policy libraries, or integration inventories.

4. **Static search/index builder**
   - Parse published content and produce optimized search artifacts.
   - Generate related-content signals or semantic metadata offline.

5. **Asset pipeline helper**
   - Optimize, fingerprint, validate, or inventory assets as part of CI.
   - Keep the tool narrowly focused; do not create a second general-purpose frontend build system without a clear need.

6. **External API ingestion tool**
   - Fetch approved public or authenticated data during CI.
   - Store only the minimum publishable result.
   - Apply schema validation, retries, rate limits, caching, and provenance metadata.
   - Keep credentials in CI secrets, never in source or generated public files.

7. **Release and deployment verifier**
   - Verify generated route maps, redirects, canonical URLs, content freshness, sitemap coverage, and release metadata before publishing.

#### Rust project layout

For a larger site, use a separate tool workspace rather than entangling Rust sources with Zola templates:

```text
repository/
├── site/
│   ├── content/
│   ├── data/
│   ├── templates/
│   ├── static/
│   └── zola.toml
├── tools/
│   ├── Cargo.toml
│   └── crates/
│       ├── content-lint/
│       ├── content-generate/
│       └── search-index/
├── scripts/
│   └── build-site.sh
├── .github/workflows/
│   └── publish.yml
└── README.md
```

The agent should favor explicit command boundaries:

```bash
cargo run -p content-lint -- site/content
cargo run -p content-generate -- --output site/data/generated
zola check --root site
zola build --root site
cargo run -p search-index -- --public-dir site/public
```

Use the exact Zola command syntax appropriate for the installed version and repository layout.

### 6. Rust to WebAssembly strategy

Rust-to-WebAssembly is not a default optimization. It should be selected only when JavaScript is demonstrably insufficient or when a Rust implementation provides a maintained, measurable advantage.

Potentially appropriate cases:

- Computationally intensive client-side transformations.
- Offline data processing over user-provided files.
- Specialized parsers, visualizations, cryptographic primitives, or domain algorithms that are already well maintained in Rust.
- Reuse of a validated Rust domain library where a JavaScript port would create duplication and risk.

Do not use Rust/WASM solely because the site uses Zola or because Rust is familiar.

#### WASM evaluation checklist

Before recommending WASM, document:

- The user-facing problem and baseline JavaScript alternative.
- Expected compute cost and measured performance benefit.
- Download size, initialization cost, caching strategy, and device impact.
- Browser compatibility and fallback behavior.
- Accessibility of the resulting user interface.
- Debugging, observability, and error-reporting strategy.
- Build reproducibility, Rust toolchain pinning, and dependency audit plan.
- Whether the capability can be completed at build time instead.

#### WASM rules

- Keep a functional fallback where the feature affects core use.
- Load WASM only on pages that need it.
- Avoid blocking initial rendering.
- Treat data passed between JavaScript and WASM as untrusted.
- Do not place secrets or authorization policy in browser-delivered WASM.
- Measure real-device performance, not only desktop development performance.
- Use immutable, fingerprinted artifacts and document the build command.

### 7. Dynamic services and APIs

Zola produces static output. If a capability requires per-user identity, mutation, secrecy, real-time state, or protected data, it belongs in a separate runtime service.

Examples include:

- Authenticated comments or community features.
- Form submission and workflow initiation.
- Personalization.
- User accounts and preferences stored server-side.
- Paid content or entitlement enforcement.
- Private search.
- Data dashboards with changing protected data.
- AI-assisted features using protected prompts, keys, or enterprise data.
- Real-time collaboration or notifications.

Architecture boundary:

```text
Zola static site
  ├── Public content and UI shell
  ├── Optional progressive JavaScript
  └── Calls a narrow API boundary
          ├── Authentication / authorization
          ├── Serverless or backend logic
          ├── Data stores
          ├── Audit / monitoring
          └── Secrets management
```

The agent must not place API secrets, privileged access tokens, client secrets, or authorization logic in static JavaScript, static JSON, front matter, configuration files committed to source control, or browser-delivered WASM.

For identity-aware integrations, apply zero-trust principles:

- Use short-lived credentials where possible.
- Enforce authorization on the server/API, not in the browser.
- Scope service identities to the least privilege required.
- Validate origin, input, rate limits, and abuse controls.
- Log security-relevant events appropriately.
- Design for data minimization, retention, and privacy requirements.

### 8. Security, privacy, and supply-chain controls

Adding JavaScript and Rust extends the site’s attack surface and maintenance burden. The agent should include these controls in every extension recommendation.

#### JavaScript controls

- Prefer first-party, versioned static assets.
- Avoid unreviewed third-party scripts and opaque CDNs.
- Use Subresource Integrity where appropriate for externally hosted immutable assets.
- Define a Content Security Policy compatible with the chosen architecture.
- Avoid `eval`, dynamic script injection, unsafe inline handlers, and unsanitized HTML insertion.
- Validate and encode data before inserting into the DOM.
- Minimize analytics and disclose tracking behavior.
- Avoid exposing internal routes, data inventories, or sensitive metadata in static search indexes.

#### Rust controls

- Commit `Cargo.lock` for applications/tools where reproducibility matters.
- Pin Rust toolchain versions, including CI toolchains.
- Review dependency provenance and licensing.
- Run dependency, vulnerability, and license checks in CI where organizational policy requires them.
- Use structured error handling; never silently generate incomplete or misleading content.
- Validate all external data against explicit schemas.
- Keep secrets in CI or an approved secret manager, never in compiled artifacts or repository config.
- Generate software bill of materials or provenance evidence where enterprise governance requires it.

#### API and service controls

- Authenticate and authorize every protected request.
- Avoid relying solely on CORS as an access-control mechanism.
- Apply rate limits, request-size limits, schema validation, and abuse monitoring.
- Separate public build-time content from protected runtime data.
- Document data ownership, processing region, retention, and deletion behavior.

### 9. Performance budgets and validation

Every proposed enhancement should include a performance budget and a validation plan.

Suggested starting budgets, to be adapted to the site and audience:

- **Core content:** static HTML with no JavaScript requirement.
- **JavaScript:** page-specific modules only; avoid broad framework bundles.
- **WebAssembly:** specialized pages only and only after measurable
  justification.
- **Third-party scripts:** minimize and require clear privacy, performance, and
  ownership rationale.
- **Search index:** minimal fields, compression/caching, and splitting/sharding
  for large corpora.
- **API requests:** avoid them on initial render unless required for core user
  value.

Validation must include:

- A no-JavaScript browsing test.
- A keyboard-only test for interactive features.
- A reduced-motion test where animation exists.
- A slow-network and mobile-device test.
- Browser-console inspection for errors, warnings, and failed network requests.
- Static build validation with `zola check` and `zola build`.
- Dependency/license/security review for newly introduced packages.
- A review of generated output to confirm no secrets or restricted content appear in `public/`.

### 10. Observability, maintenance, and upgrade strategy

Every extended site should have a maintenance plan that covers observability, dependency management, and upgrade paths.

#### Observability

- **Build-time metrics:** Record build duration, asset sizes, search index size, and warning counts in CI artifacts.
- **Runtime signals:** If JavaScript or WASM is used, collect client-side errors (via `window.onerror`, unhandled rejection handlers) and performance marks (Navigation Timing, Resource Timing) into an opt-in endpoint.
- **Content health:** Schedule periodic checks for broken links, missing alt text, stale front-matter dates, and taxonomy drift.
- **Search quality:** If client-side search is deployed, log zero-result queries and latency percentiles to detect index gaps.

#### Dependency management

- **Rust toolchain:** Pin the Rust version in `rust-toolchain.toml` (or `rustup` override) and update on a scheduled cadence with `cargo update --dry-run` review first.
- **JavaScript packages:** Pin exact versions in `package-lock.json` / `pnpm-lock.yaml`. Run `npm audit` / `pnpm audit` in CI and fail on high/critical findings without approved exceptions.
- **Zola version:** Pin the Zola binary version in CI (e.g., `ZOLA_VERSION=0.23.4`) and test upgrades in a staging branch before promoting.
- **WASM toolchain:** Pin `wasm-pack` / `cargo` versions used for WASM builds. Track `wasm-bindgen` and `web-sys` versions for browser compatibility.

#### Upgrade strategy

- **Zola upgrades:** Read release notes for breaking changes in Tera, Sass, front-matter parsing, or CLI flags. Run `zola check` and the full test suite (`tests/run.sh`) against the new version before merging.
- **JavaScript bundler upgrades:** Upgrade bundler and major plugins one at a time. Verify output byte-for-byte stability for unchanged inputs where possible.
- **Rust dependency upgrades:** Use `cargo upgrade --incompatible` to preview breaking changes. Run `cargo test --all` and the content-lint/search-index tools against a staging build.
- **Rollback plan:** Keep the previous working `public/` artifact (or Docker image) for at least one release cycle. Document the exact commands to redeploy the prior version.

#### Maintenance ownership

- Assign a named owner for each extension category (JavaScript, Rust pre-build, WASM, search, dynamic API).
- Document the owner's contact, escalation path, and review cadence in the site's `CONTRIBUTING.md` or `MAINTAINERS.md`.
- Schedule quarterly "capability review" to assess whether each extension still justifies its cost and whether a simpler static alternative now exists.

### 11. When to change Zola itself

The agent should consider changes to the Zola codebase only when all of the following are true:

- The requirement cannot be met by templates, configuration, data files, build-time tooling, JavaScript, a plugin-adjacent workflow, or a separate service.
- The capability is broadly useful beyond a single site.
- There is a clear, testable proposal with compatibility implications understood.
- The project can commit to upstream collaboration, maintenance, tests, documentation, and review.
- A private fork’s long-term maintenance cost has been explicitly accepted if upstreaming is not feasible.

Preferred order:

1. Search existing Zola issues, discussions, documentation, and release plans.
2. Create a minimal reproducible example.
3. Open or contribute to an upstream issue/design discussion.
4. Propose a backward-compatible implementation.
5. Add tests, documentation, migration guidance, and examples.
6. Avoid carrying a private fork unless there is an explicit ownership and upgrade plan.

### 12. Final extension principle

The skill should help users build sites that are **static by default, dynamic by evidence, and extensible by clear architectural boundaries**.

JavaScript should provide progressive convenience. Rust should strengthen deterministic build-time quality, content automation, and specialized computation. WebAssembly and runtime services should be reserved for needs that genuinely require them. This preserves the primary benefits of Zola: simple deployment, resilient delivery, strong performance potential, low operational overhead, and transparent source-controlled publishing.

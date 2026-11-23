#!/usr/bin/env python3
"""Deterministic contract checks for the Zola runtime payload.

The check encodes the shared inspect-first routing contract as a structural,
deterministic guard (not behavioral proof):

- ``skills/zola/SKILL.md`` owns the canonical shared inspect-first method.
- Routed workflows and references (all ``skills/zola/workflows/*.md`` and
  ``skills/zola/references/*.md`` except ``source-registry.md``) link to that
  anchor and act as topic-specific deltas.
- Routed deltas keep the shared-method link near the top, include an explicit
  delta marker, and do not redefine the canonical method heading.
- The shared method states the Zola validation boundary explicitly.

Run ``--self-test`` to verify guard behavior before trusting repository results.
"""

from __future__ import annotations

import argparse
import sys
import tempfile
from pathlib import Path


ANCHOR = "#shared-inspect-first-method"
SHARED_METHOD_LINK = f"[shared inspect-first method](../SKILL.md{ANCHOR})"
SHARED_METHOD_HEADING = "## Shared inspect-first method"
DELTA_MARKER = "topic-specific delta"
VALIDATION_BOUNDARY_MARKERS = (
    "zola check --skip-external-links",
    "zola build",
    "neither verifies publication, deployment, hosting, or CDN behavior",
)
LINK_PLACEMENT_LIMIT = 8


def repo_root() -> Path:
    return Path(__file__).resolve().parents[3]


def runtime_root(root: Path) -> Path:
    return root / "skills" / "zola"


def iter_routed_reference_paths(root: Path) -> list[Path]:
    runtime = runtime_root(root)
    paths = [*sorted((runtime / "workflows").glob("*.md"))]
    paths.extend(
        sorted(
            path
            for path in (runtime / "references").glob("*.md")
            if path.name != "source-registry.md"
        )
    )
    return paths


def check_contract(root: Path) -> list[str]:
    errors: list[str] = []
    skill_path = runtime_root(root) / "SKILL.md"
    if not skill_path.is_file():
        return [f"missing runtime skill file: {skill_path}"]

    skill_text = skill_path.read_text(encoding="utf-8")
    if SHARED_METHOD_HEADING not in skill_text:
        errors.append(
            "SKILL.md must define the canonical shared inspect-first method heading"
        )
    for marker in VALIDATION_BOUNDARY_MARKERS:
        if marker not in skill_text:
            errors.append(
                "SKILL.md shared inspect-first method must state validation boundary "
                f"marker: {marker!r}"
            )

    routed_paths = iter_routed_reference_paths(root)
    if not routed_paths:
        errors.append("no routed workflow/reference files found for contract check")
        return errors

    for path in routed_paths:
        rel = path.relative_to(root)
        text = path.read_text(encoding="utf-8")
        if SHARED_METHOD_LINK not in text:
            errors.append(f"{rel} must link to {SHARED_METHOD_LINK}")
            continue

        lines = text.splitlines()
        link_lines = [idx for idx, line in enumerate(lines, start=1) if SHARED_METHOD_LINK in line]
        if not link_lines or link_lines[0] > LINK_PLACEMENT_LIMIT:
            errors.append(
                f"{rel} must place {SHARED_METHOD_LINK} within first {LINK_PLACEMENT_LIMIT} lines"
            )

        if DELTA_MARKER not in text.lower():
            errors.append(
                f"{rel} must include an explicit delta marker containing {DELTA_MARKER!r}"
            )

        if SHARED_METHOD_HEADING in text:
            errors.append(
                f"{rel} must not redefine canonical heading {SHARED_METHOD_HEADING!r}; keep it as a routed delta"
            )

    return errors


def write_contract_fixture(
    root: Path,
    *,
    include_ref_link: bool,
    include_boundary_markers: bool,
    link_at_top: bool = True,
    include_delta_marker: bool = True,
    include_duplicate_heading: bool = False,
) -> None:
    runtime = runtime_root(root)
    workflows = runtime / "workflows"
    references = runtime / "references"
    workflows.mkdir(parents=True)
    references.mkdir(parents=True)

    boundary = (
        "A clean `zola check --skip-external-links` and `zola build` verifies "
        "generation in the tested context; neither verifies publication, "
        "deployment, hosting, or CDN behavior unless separately checked."
        if include_boundary_markers
        else "Validate with normal Zola commands."
    )
    (runtime / "SKILL.md").write_text(
        "\n".join(
            [
                "# Zola",
                "",
                SHARED_METHOD_HEADING,
                "",
                "1. **Scope and authority.**",
                "2. **Bounded target scan.**",
                "3. **Frame one affected outcome.**",
                "4. **Reuse target records, then load one conditional delta.**",
                f"5. **Smallest coherent change, then validate and handoff.** {boundary}",
                "",
            ]
        ),
        encoding="utf-8",
    )

    delta = "topic-specific delta" if include_delta_marker else "supporting notes"
    ref_line = (
        f"Apply the {SHARED_METHOD_LINK} before this workflow; this file is the {delta}.\n\n"
    )
    top = ref_line if include_ref_link and link_at_top else ""
    bottom = "" if (not include_ref_link or link_at_top) else ref_line
    duplicate_heading = f"{SHARED_METHOD_HEADING}\n\n" if include_duplicate_heading else ""
    (workflows / "debug-build.md").write_text(
        top
        + "# Debug build\n\n"
        + duplicate_heading
        + ("intro\n\n" * 8 if not link_at_top else "")
        + bottom,
        encoding="utf-8",
    )
    (references / "source-registry.md").write_text(
        "# Source registry\n", encoding="utf-8"
    )


def run_self_test() -> list[str]:
    errors: list[str] = []

    with tempfile.TemporaryDirectory() as tmp:
        root = Path(tmp)
        write_contract_fixture(
            root, include_ref_link=False, include_boundary_markers=True
        )
        missing_link_errors = check_contract(root)
        if not any("must link to" in error for error in missing_link_errors):
            errors.append("self-test expected missing routed-file link to fail")

    with tempfile.TemporaryDirectory() as tmp:
        root = Path(tmp)
        write_contract_fixture(
            root, include_ref_link=True, include_boundary_markers=False
        )
        missing_boundary_errors = check_contract(root)
        if not any("validation boundary marker" in error for error in missing_boundary_errors):
            errors.append("self-test expected missing validation boundary marker to fail")

    with tempfile.TemporaryDirectory() as tmp:
        root = Path(tmp)
        write_contract_fixture(
            root,
            include_ref_link=True,
            include_boundary_markers=True,
            link_at_top=False,
        )
        placement_errors = check_contract(root)
        if not any("within first" in error for error in placement_errors):
            errors.append("self-test expected late shared-method link to fail")

    with tempfile.TemporaryDirectory() as tmp:
        root = Path(tmp)
        write_contract_fixture(
            root,
            include_ref_link=True,
            include_boundary_markers=True,
            include_delta_marker=False,
        )
        delta_errors = check_contract(root)
        if not any("delta marker" in error for error in delta_errors):
            errors.append("self-test expected missing delta marker to fail")

    with tempfile.TemporaryDirectory() as tmp:
        root = Path(tmp)
        write_contract_fixture(
            root,
            include_ref_link=True,
            include_boundary_markers=True,
            include_duplicate_heading=True,
        )
        heading_errors = check_contract(root)
        if not any("must not redefine canonical heading" in error for error in heading_errors):
            errors.append("self-test expected duplicate canonical heading to fail")

    with tempfile.TemporaryDirectory() as tmp:
        root = Path(tmp)
        write_contract_fixture(
            root, include_ref_link=True, include_boundary_markers=True
        )
        ok_errors = check_contract(root)
        if ok_errors:
            errors.append(f"self-test expected valid fixture to pass: {ok_errors}")

    with tempfile.TemporaryDirectory() as tmp:
        root = Path(tmp)
        write_contract_fixture(
            root, include_ref_link=True, include_boundary_markers=True
        )
        # Ensure source-registry exclusion is preserved: no link required.
        registry_errors = check_contract(root)
        if any("source-registry.md" in error for error in registry_errors):
            errors.append("self-test should not require source-registry.md to link")

    return errors


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--self-test",
        action="store_true",
        help="run guard self-tests against temporary fixtures",
    )
    args = parser.parse_args()

    errors = run_self_test() if args.self_test else check_contract(repo_root())
    if errors:
        for error in errors:
            print(f"ERROR: {error}", file=sys.stderr)
        return 1

    if args.self_test:
        print("runtime contract self-test passed")
    else:
        print("runtime contract check passed")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

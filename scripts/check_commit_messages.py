#!/usr/bin/env python3
"""Check commit subjects and rationale fields for this repository."""

from __future__ import annotations

import subprocess
import sys


def commits(ref: str) -> list[str]:
    result = subprocess.run(
        ["git", "log", "--format=%H", ref],
        check=True,
        text=True,
        capture_output=True,
    )
    return [line for line in result.stdout.splitlines() if line]


def main() -> int:
    refs = sys.argv[1:] or ["HEAD"]
    hashes: list[str] = ["HEAD"] if refs == ["HEAD"] else []
    for ref in refs:
        if ref != "HEAD" or refs != ["HEAD"]:
            hashes.extend(commits(ref))

    errors: list[str] = []
    seen: set[str] = set()
    for commit in hashes:
        if commit in seen:
            continue
        seen.add(commit)
        body = subprocess.run(
            ["git", "show", "--quiet", "--format=%B", commit],
            check=True,
            text=True,
            capture_output=True,
        ).stdout.strip()
        lines = body.splitlines()
        subject = lines[0].strip() if lines else ""
        if not subject:
            errors.append(f"{commit[:12]}: empty subject")
        elif len(subject) > 72:
            errors.append(f"{commit[:12]}: subject exceeds 72 characters")
        elif subject.endswith("."):
            errors.append(f"{commit[:12]}: subject must not end with a period")

        lower = body.lower()
        for field in ("what:", "why:"):
            if field not in lower:
                errors.append(f"{commit[:12]}: missing {field} field")
            else:
                value = next(
                    (line.split(":", 1)[1].strip() for line in lines if line.lower().startswith(field)),
                    "",
                )
                if not value:
                    errors.append(f"{commit[:12]}: empty {field} field")

    if errors:
        print("Commit message policy failed:", file=sys.stderr)
        print("\n".join(errors), file=sys.stderr)
        return 1
    print(f"Commit message policy passed for {len(seen)} commit(s).")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

#!/usr/bin/env python3
"""Check that all filenames use snake_case."""

import re
import sys
from pathlib import Path

SNAKE_CASE = re.compile(r"^[a-z0-9]+(_[a-z0-9]+)*(\.[a-z0-9]+)?$")

EXCLUDE = {".git", ".godot", "build", "__pycache__", ".import"}


def main() -> int:
    root = Path(".").resolve()
    errors = []

    for path in root.rglob("*"):
        if not path.is_file():
            continue
        if any(ex in path.parts for ex in EXCLUDE):
            continue
        if not SNAKE_CASE.match(path.name):
            errors.append(str(path.relative_to(root)))

    if errors:
        print(f"Non-snake_case filenames ({len(errors)}):")
        for e in sorted(errors):
            print(f"  {e}")
        return 1

    print("All filenames are snake_case")
    return 0


if __name__ == "__main__":
    sys.exit(main())

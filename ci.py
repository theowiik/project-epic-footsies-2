#!/usr/bin/env python3
"""Root CI validation for project-epic-footsies-2."""

import argparse
import re
import subprocess
import sys
from pathlib import Path

SNAKE_CASE = re.compile(r"^[a-z0-9]+(_[a-z0-9]+)*(\.[a-z0-9]+)?$")

EXCLUDE = {".git", ".godot", "build", "__pycache__", ".import"}


def check_snake_case(root: Path) -> list[str]:
    """Check all files under root for snake_case naming."""
    errors = []
    for path in root.rglob("*"):
        if not path.is_file():
            continue
        if any(ex in path.parts for ex in EXCLUDE):
            continue
        if not SNAKE_CASE.match(path.name):
            errors.append(str(path.relative_to(root)))
    return errors


def main() -> int:
    parser = argparse.ArgumentParser(description="CI validation")
    parser.add_argument("--path", type=Path, default=Path("."))
    args = parser.parse_args()

    root = args.path.resolve()
    ok = True

    # Snake case check
    print("Checking snake_case naming...")
    errors = check_snake_case(root)
    if errors:
        ok = False
        print(f"  ✗ {len(errors)} file(s) with non-snake_case names:")
        for e in sorted(errors):
            print(f"      {e}")
    else:
        print("  ✓ All filenames are snake_case")

    # Delegate to game-specific checks
    game_ci = root / "game" / "validate_gdscript.py"
    if game_ci.exists():
        print("\nRunning game-specific validation...")
        result = subprocess.run(
            [sys.executable, str(game_ci)],
            cwd=root / "game",
        )
        if result.returncode != 0:
            ok = False

    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())

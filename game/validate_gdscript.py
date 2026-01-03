#!/usr/bin/env python3
"""GDScript validation for the game."""

import sys
from pathlib import Path

from gdtoolkit.parser import parser
from lark import Tree

EXCLUDE = {".godot", "build"}


def check_duplicate_functions(tree: Tree) -> list[str]:
    """Check for duplicate function definitions in a GDScript AST."""
    functions = {}
    errors = []

    def walk(node):
        if isinstance(node, Tree):
            if node.data == "func_def":
                for child in node.children:
                    if isinstance(child, Tree) and child.data == "func_header":
                        name = str(child.children[0])
                        if name in functions:
                            errors.append(f"Duplicate function: '{name}'")
                        else:
                            functions[name] = True
                        break
            for child in node.children:
                walk(child)

    walk(tree)
    return errors


def validate_file(filepath: Path) -> list[str]:
    """Validate a single GDScript file."""
    try:
        content = filepath.read_text()
        tree = parser.parse(content)
        return check_duplicate_functions(tree)
    except Exception as e:
        return [f"Parse error: {e}"]


def main() -> int:
    root = Path(".")
    scripts = [
        f for f in root.rglob("*.gd") if not any(ex in f.parts for ex in EXCLUDE)
    ]

    checked = 0
    failed = 0

    print("Validating GDScript files...")
    for filepath in sorted(scripts):
        checked += 1
        errors = validate_file(filepath)
        if errors:
            failed += 1
            print(f"  ✗ {filepath}")
            for error in errors:
                print(f"      {error}")

    if failed:
        print(f"  ✗ {failed}/{checked} file(s) failed")
        return 1
    else:
        print(f"  ✓ {checked} file(s) passed")
        return 0


if __name__ == "__main__":
    sys.exit(main())

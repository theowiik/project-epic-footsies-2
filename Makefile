.PHONY: help format check

help:
	@echo "Available targets:"
	@echo "  help   - Show this help message"
	@echo "  format - Format everything"
	@echo "  check  - Run all checks"

format:
	nix-shell -p python3Packages.mdformat --run "mdformat . --wrap 88"
	cd game && make format

check:
	nix-shell -p python3Packages.mdformat --run "mdformat . --wrap 88 --check"

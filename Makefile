.PHONY: help format

help:
	@echo "Available targets:"
	@echo "  help   - Show this help message"
	@echo "  format - Format everything"

format:
	nix-shell -p python3Packages.mdformat --run "mdformat . --wrap 88"
	cd game && make format

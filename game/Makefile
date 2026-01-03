.PHONY: format check ci build build-linux build-windows build-clean dev help

NIX := nix --extra-experimental-features 'nix-command flakes'

help:
	@echo "Available targets:"
	@echo "  dev           - Enter development shell"
	@echo "  format        - Format all code"
	@echo "  check         - Check code style"
	@echo "  ci            - Run full CI (style + validation)"
	@echo "  build         - Build game for all platforms"
	@echo "  build-linux   - Build game for Linux"
	@echo "  build-windows - Build game for Windows"
	@echo "  build-clean   - Remove build artifacts"

dev:
	$(NIX) develop

format:
	$(NIX) run .#format

check:
	$(NIX) run .#check

ci:
	$(NIX) run .#ci

build:
	$(NIX) run .#build

build-linux:
	$(NIX) run .#build-linux

build-windows:
	$(NIX) run .#build-windows

build-clean:
	rm -rf build/

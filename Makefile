.PHONY: help format check build

help:
	@echo "Available targets:"
	@echo "  format - Format all subprojects"
	@echo "  check  - Run all checks (delegates to subprojects)"
	@echo "  build  - Build all subprojects"

format:
	$(MAKE) -C game format

check:
	$(MAKE) -C game check

build:
	$(MAKE) -C game build

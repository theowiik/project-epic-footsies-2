.PHONY: format check build build-linux build-windows build-all clean

BUILD_CMD := nix-shell -p godot --run "godot --headless --export-release

help:
	@echo "Available targets:"
	@echo "  format        - Format all gdscript files"
	@echo "  check         - Check formatting of all gdscript files"
	@echo "  build         - Build game for all platforms"
	@echo "  build-linux   - Build game for Linux"
	@echo "  build-windows - Build game for Windows"
	@echo "  build-clean   - Remove build artifacts"

format:
	nix-shell -p gdtoolkit_4 --run "gdformat ."

build: build-linux build-windows

check:
	nix-shell -p gdtoolkit_4 --run "gdformat . --check"

build-linux:
	@mkdir -p build/linux
	$(BUILD_CMD) 'game-linux' ./build/linux/project-epic-footsies-2.x86_64"

build-windows:
	@mkdir -p build/windows
	$(BUILD_CMD) 'game-windows' ./build/windows/project-epic-footsies-2.exe"


build-clean:
	rm -rf build/

.PHONY: format check build build-linux build-windows build-macos build-all clean

help:
	@echo "Available targets:"
	@echo "  format        - Format all gdscript files"
	@echo "  check         - Check formatting of all gdscript files"
	@echo "  build-linux   - Build game for Linux"
	@echo "  build-windows - Build game for Windows"
	@echo "  build-macos   - Build game for macOS"
	@echo "  build-all     - Build game for all platforms"
	@echo "  clean         - Remove build artifacts"

format:
	nix-shell -p gdtoolkit_4 --run "gdformat ."

check:
	nix-shell -p gdtoolkit_4 --run "gdformat . --check"

build-linux:
	@echo "Building for Linux..."
	@mkdir -p build/linux
	nix-shell -p godot --run "godot --headless --export-release 'Linux/X11' ./build/linux/project-epic-footsies-2.x86_64"
	@echo "Linux build complete: build/linux/"

build-windows:
	@echo "Building for Windows..."
	@mkdir -p build/windows
	nix-shell -p godot --run "godot --headless --export-release 'Windows Desktop' ./build/windows/project-epic-footsies-2.exe"
	@echo "Windows build complete: build/windows/"

build-macos:
	@echo "Building for macOS..."
	@mkdir -p build/macos
	nix-shell -p godot --run "godot --headless --export-release 'macOS' ./build/macos/project-epic-footsies-2.zip"
	@echo "macOS build complete: build/macos/"

build-all: build-linux build-windows build-macos
	@echo "All builds complete!"

build: build-all

clean:
	@echo "Cleaning build artifacts..."
	rm -rf build/
	@echo "Clean complete!"

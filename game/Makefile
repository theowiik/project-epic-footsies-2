.PHONY: format check build build-linux build-windows build-all clean

help:
	@echo "Available targets:"
	@echo "  format        - Format all gdscript files"
	@echo "  check         - Check formatting of all gdscript files"
	@echo "  build-all     - Build game for all platforms"
	@echo "  build-linux   - Build game for Linux"
	@echo "  build-windows - Build game for Windows"
	@echo "  build-clean   - Remove build artifacts"

format:
	nix-shell -p gdtoolkit_4 --run "gdformat ."

check:
	nix-shell -p gdtoolkit_4 --run "gdformat . --check"

build-linux:
	@echo "Building for Linux..."
	@mkdir -p build/linux
	docker run --rm -v "$$(pwd):/app" -w /app barichello/godot-ci:4.3 godot --headless --export-release "game-linux" ./build/linux/project-epic-footsies-2.x86_64
	@echo "Linux build complete: build/linux/"

build-windows:
	@echo "Building for Windows..."
	@mkdir -p build/windows
	docker run --rm -v "$$(pwd):/app" -w /app barichello/godot-ci:4.3 godot --headless --export-release "game-windows" ./build/windows/project-epic-footsies-2.exe
	@echo "Windows build complete: build/windows/"

build-all: build-linux build-windows
	@echo "All builds complete!"

build-clean:
	@echo "Cleaning build artifacts..."
	rm -rf build/
	@echo "Clean complete!"

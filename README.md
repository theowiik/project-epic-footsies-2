# project-epic-footsies-2

## Getting Godot Engine

Download Godot 4.5.1: https://godotengine.org/download/archive/4.5.1-stable/

Util command to download Godot for Windows to `godot/` (using Nix).

```bash
nix-shell -p wget unzip bash --run "bash -c '
  rm -rf godot && \
  mkdir godot && \
  wget https://github.com/godotengine/godot/releases/download/4.5.1-stable/Godot_v4.5.1-stable_win64.exe.zip -O godot/godot.zip && \
  unzip -q godot/godot.zip -d godot && \
  rm godot/godot.zip
'"
```

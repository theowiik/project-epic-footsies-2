{
  description = "Project Epic Footsies 2 - Godot game build environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      # Python environment with gdtoolkit for validation
      pythonWithGdtoolkit = pkgs.python3.withPackages (ps: [
        ps.lark
        ps.docopt
        ps.pyyaml
        ps.setuptools
      ]);

      formatScript = pkgs.writeShellScriptBin "format" ''
        set -e
        ${pkgs.gdtoolkit_4}/bin/gdformat .
        ${pkgs.nixfmt-rfc-style}/bin/nixfmt .
      '';

      checkScript = pkgs.writeShellScriptBin "check" ''
        set -e
        ${pkgs.gdtoolkit_4}/bin/gdformat . --check
        ${pkgs.gdtoolkit_4}/bin/gdlint .
        PYTHONPATH=${pkgs.gdtoolkit_4}/${pkgs.python3.sitePackages} ${pythonWithGdtoolkit}/bin/python3 validate_gdscript.py
        ${pkgs.nixfmt-rfc-style}/bin/nixfmt . --check
      '';

      buildLinuxScript = pkgs.writeShellScriptBin "build-linux" ''
        set -e
        export XDG_DATA_HOME="${pkgs.godot-export-templates-bin}/share"
        mkdir -p build/linux
        ${pkgs.godot}/bin/godot4 --headless --export-release "game-linux" ./build/linux/project-epic-footsies-2.x86_64
      '';

      buildWindowsScript = pkgs.writeShellScriptBin "build-windows" ''
        set -e
        export XDG_DATA_HOME="${pkgs.godot-export-templates-bin}/share"
        mkdir -p build/windows
        ${pkgs.godot}/bin/godot4 --headless --export-release "game-windows" ./build/windows/project-epic-footsies-2.exe
      '';

      buildAllScript = pkgs.writeShellScriptBin "build" ''
        set -e
        export XDG_DATA_HOME="${pkgs.godot-export-templates-bin}/share"
        mkdir -p build/linux build/windows
        ${pkgs.godot}/bin/godot4 --headless --export-release "game-linux" ./build/linux/project-epic-footsies-2.x86_64
        ${pkgs.godot}/bin/godot4 --headless --export-release "game-windows" ./build/windows/project-epic-footsies-2.exe
      '';

    in
    {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = [
          pkgs.godot
          pkgs.godot-export-templates-bin
          pkgs.gdtoolkit_4
          pkgs.gnumake
          pkgs.nixfmt-rfc-style
          pkgs.python3
        ];

        XDG_DATA_HOME = "${pkgs.godot-export-templates-bin}/share";
      };

      apps.${system} = {
        format = {
          type = "app";
          program = "${formatScript}/bin/format";
        };
        check = {
          type = "app";
          program = "${checkScript}/bin/check";
        };
        build-linux = {
          type = "app";
          program = "${buildLinuxScript}/bin/build-linux";
        };
        build-windows = {
          type = "app";
          program = "${buildWindowsScript}/bin/build-windows";
        };
        build = {
          type = "app";
          program = "${buildAllScript}/bin/build";
        };
      };
    };
}

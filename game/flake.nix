{
  description = "Project Epic Footsies 2";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      pythonEnv = pkgs.python3.withPackages (ps: [
        ps.lark
        ps.setuptools
      ]);

      format = pkgs.writeShellScriptBin "format" ''
        set -e
        ${pkgs.gdtoolkit_4}/bin/gdformat .
        ${pkgs.nixfmt-rfc-style}/bin/nixfmt .
      '';

      check = pkgs.writeShellScriptBin "check" ''
        set -e
        ${pkgs.gdtoolkit_4}/bin/gdformat . --check
        ${pkgs.gdtoolkit_4}/bin/gdlint .
        ${pkgs.nixfmt-rfc-style}/bin/nixfmt . --check
        PYTHONPATH=${pkgs.gdtoolkit_4}/${pkgs.python3.sitePackages} ${pythonEnv}/bin/python3 validate_gdscript.py
      '';

      build = pkgs.writeShellScriptBin "build" ''
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
          pkgs.ruff
        ];
        XDG_DATA_HOME = "${pkgs.godot-export-templates-bin}/share";
      };

      apps.${system} = {
        format.type = "app";
        format.program = "${format}/bin/format";
        check.type = "app";
        check.program = "${check}/bin/check";
        build.type = "app";
        build.program = "${build}/bin/build";
      };
    };
}

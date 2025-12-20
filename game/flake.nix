{
  description = "Project Epic Footsies 2 - Godot game build environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = [
          pkgs.godot
          pkgs.godot-export-templates-bin
          pkgs.gdtoolkit_4
          pkgs.gnumake
        ];

        XDG_DATA_HOME = "${pkgs.godot-export-templates-bin}/share";
      };
    };
}

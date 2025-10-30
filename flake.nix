{
  description = "Nim development environment for fossify android";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            # Nim compiler and tools
            nim
            nimble
            nimlsp
            nimlangserver
            # nimsuggest is included with nim package
            
            # Optional: Add more tools as needed
            # nimfmt
            # gdb
          ];

          shellHook = ''
            echo "🎯 Nim development environment loaded"
            echo "Nim version: $(nim --version | head -n1)"
          '';
        };
      });
}

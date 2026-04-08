{
  description = "Compiler development";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
    };
  in {
    packages.x86_64-linux.default = pkgs.mkShell {
      packages = with pkgs; [
        clang

        flex
        bison
      ];
    };
  };
}

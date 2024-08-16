{
  description = "My Goo Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=24.05";
    UNSTABLE.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs, UNSTABLE }: {
    packages.x86_64-linux.goo-engine = UNSTABLE.callPackage ./goo-engine.nix {};
  };
}
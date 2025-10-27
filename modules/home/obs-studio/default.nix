{ inputs, pkgs, ... }:
let
  unstable = import ../../../unstable.nix { inherit inputs pkgs; };
in
{
  programs.obs-studio = {
    enable = true;
    package = unstable.obs-studio;
  };
}

{ inputs, pkgs, ... }:
let
  unstable = import ../../../unstable.nix { inherit inputs pkgs; };
in
{
  programs.yazi = {
    enable = true;
    package = unstable.yazi-unwrapped;
  };
}

{ lib, config, pkgs, inputs, ... }:
let
  unstable = import ../unstable.nix { inherit inputs pkgs; };
in
{
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };
  # programs.alvr = {
  #   enable = true;
  #   package = unstable.alvr;
  #   openFirewall = true;
  # };

}
{ config, lib, pkgs, ... }:

let
  cfg = config.custom.steam;
in
{
  options.custom.steam = {
    enable = lib.mkEnableOption "Steam gaming platform";
  };

  config = lib.mkIf cfg.enable {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
  };
}

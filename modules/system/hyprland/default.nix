{ config, lib, pkgs, ... }:

let
  cfg = config.custom.hyprland;
in
{
  options.custom.hyprland = {
    enable = lib.mkEnableOption "Hyprland window manager system configuration";
  };

  config = lib.mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
    };

    security.pam.services.swaylock = { };
  };
}

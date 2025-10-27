{ config, lib, pkgs, inputs, ... }:

let
  cfg = config.custom.waybar;
  unstable = import ../../../unstable.nix { inherit inputs pkgs; };
  
  desktopSource = ./.;
  laptopSource = ../laptop-waybar;
in
{
  options.custom.waybar = {
    enable = lib.mkEnableOption "waybar status bar";

    isLaptop = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable laptop-specific config";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.waybar = {
      enable = true;
      package = unstable.waybar;
    };

    xdg.configFile."waybar".source = if cfg.isLaptop then laptopSource else desktopSource;
  };
}

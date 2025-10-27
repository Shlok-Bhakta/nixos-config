{ config, lib, pkgs, ... }:

let
  cfg = config.custom.kanata;
in
{
  options.custom.kanata = {
    enable = lib.mkEnableOption "Kanata keyboard remapping";
    
    devices = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "List of keyboard device paths";
    };
  };

  config = lib.mkIf cfg.enable {
    services.kanata = {
      enable = true;
      package = pkgs.kanata;
      keyboards.keychron = {
        devices = cfg.devices;
        configFile = ./kanata.kbd;
      };
    };
  };
}

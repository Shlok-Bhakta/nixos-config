{ config, lib, pkgs, ... }:

let
  cfg = config.custom.bluetooth;
in
{
  options.custom.bluetooth = {
    enable = lib.mkEnableOption "Bluetooth support";
    
    powerOnBoot = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Power on Bluetooth controller on boot";
    };
  };

  config = lib.mkIf cfg.enable {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = cfg.powerOnBoot;
    };
    
    services.blueman.enable = true;
  };
}

{ config, lib, pkgs, ... }:

let
  cfg = config.custom.swaync;
in
{
  options.custom.swaync = {
    enable = lib.mkEnableOption "SwayNC notification daemon";
  };

  config = lib.mkIf cfg.enable {
    services.swaync = {
      enable = true;
      
      settings = builtins.fromJSON (builtins.readFile ./config.json);
      
      style = builtins.readFile ./mocha.css;
    };
  };
}

{ config, lib, pkgs, ... }:

let
  cfg = config.custom.swaync;
in
{
  config = {
    services.swaync = {
      enable = true;
      
      settings = builtins.fromJSON (builtins.readFile ./config.json);
      
      style = builtins.readFile ./mocha.css;
    };
  };
}

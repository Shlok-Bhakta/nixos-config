{ config, lib, pkgs, ... }:

let
  cfg = config.custom.docker;
in
{
  options.custom.docker = {
    enable = lib.mkEnableOption "Docker containerization";
    
    dataRoot = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/docker";
      description = "Docker data root directory";
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.docker = {
      enable = true;
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
      daemon.settings = {
        data-root = cfg.dataRoot;
      };
    };
  };
}

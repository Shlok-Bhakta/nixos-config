{ config, lib, pkgs, ... }:

let
  cfg = config.custom.nix-serve;
in
{
  options.custom.nix-serve = {
    enable = lib.mkEnableOption "nix-serve binary cache server";

    port = lib.mkOption {
      type = lib.types.int;
      default = 5000;
      description = "Port to serve the binary cache on";
    };

    secretKeyFile = lib.mkOption {
      type = lib.types.path;
      default = "/var/nix-serve/cache-priv-key.pem";
      description = "Path to the secret key file for signing packages";
    };
  };

  config = lib.mkIf cfg.enable {
    services.nix-serve = {
      enable = true;
      port = cfg.port;
      secretKeyFile = cfg.secretKeyFile;
    };

    networking.firewall.allowedTCPPorts = [ cfg.port ];
  };
}

{ config, lib, pkgs, inputs, ... }:

let
  cfg = config.custom.networking;
  unstable = import ../../../unstable.nix { inherit inputs pkgs; };
in
{
  options.custom.networking = {
    enableTailscale = lib.mkEnableOption "Tailscale VPN";
    enableAvahi = lib.mkEnableOption "Avahi mDNS/DNS-SD";
  };

  config = {
    services.tailscale = lib.mkIf cfg.enableTailscale {
      enable = true;
      package = unstable.tailscale;
    };

    services.avahi.enable = cfg.enableAvahi;
  };
}

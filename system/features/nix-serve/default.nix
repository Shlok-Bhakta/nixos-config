{ ... }:
{
  services.nix-serve = {
    enable = true;
    port = 5000;
    secretKeyFile = "/var/nix-serve/cache-priv-key.pem";
  };

  networking.firewall.allowedTCPPorts = [ 5000 ];
}

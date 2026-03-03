{ unstable, ... }:
{
  services.tailscale = {
    enable = true;
    package = unstable.tailscale;
  };

  services.avahi.enable = true;
}

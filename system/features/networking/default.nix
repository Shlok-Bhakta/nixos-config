{ unstable, ... }:
{
  services.tailscale = {
    enable = true;
    package = unstable.tailscale;
    openFirewall = true;
  };

  # Tailscale does its own routing; strict reverse-path filtering drops
  # tailnet packets, so relax it as recommended by the Tailscale docs.
  networking.firewall.checkReversePath = "loose";

  services.openssh = {
    enable = true;
    # Do not open port 22 globally — it is opened only on tailscale0 below.
    openFirewall = false;
    settings = {
      # Allowed on the tailnet only: Tailscale's identity + WireGuard layer
      # gates access, so password auth is acceptable here for phone/LLM use
      # alongside key auth.
      PasswordAuthentication = true;
      KbdInteractiveAuthentication = true;
      PermitRootLogin = "no";
    };
  };

  # Allow SSH only over the tailnet. Applies to all hosts via base.nix,
  # keeping desktop/laptop/thinkpad in parity.
  networking.firewall.interfaces."tailscale0".allowedTCPPorts = [ 22 ];

  services.avahi.enable = true;
}

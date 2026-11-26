# Game/desktop streaming to Moonlight, reachable over Tailscale only.
# Start on demand: `systemctl --user start sunshine`, then pair at
# https://localhost:47990.
{ ... }:

let
  basePort = 47989;
in
{
  services.sunshine = {
    enable = true;
    autoStart = false;
    openFirewall = false;
    capSysAdmin = true;
    settings.port = basePort;
  };

  networking.firewall.interfaces.tailscale0 = {
    allowedTCPPorts = [
      (basePort - 5)
      basePort
      (basePort + 1)
      (basePort + 21)
    ];
    allowedUDPPorts = [
      (basePort + 9)
      (basePort + 10)
      (basePort + 11)
      (basePort + 13)
      (basePort + 21)
    ];
  };

  # Virtual keyboard/mouse for remote input.
  services.udev.extraRules = ''
    KERNEL=="uinput", MODE="0660", GROUP="input", OPTIONS+="static_node=uinput"
  '';
}

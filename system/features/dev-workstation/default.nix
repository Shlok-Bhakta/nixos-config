# Loose permissions for hacking on hardware and serving dev builds on the LAN.
# Not on the ThinkPad, which locks USB down instead (see ios-devices).
{ ... }:
{
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", MODE="0666", GROUP="users"
    KERNEL=="lp[0-9]*", MODE="0666", GROUP="users"
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0666"
  '';

  # Dev servers (Vite, Next, etc.) reachable from phones/tablets.
  networking.firewall.allowedTCPPorts = [
    80
    443
    3000
    3001
    3002
    3773
    5173
    8080
    8081
    8082
    8083
  ];
}

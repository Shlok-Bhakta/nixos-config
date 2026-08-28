{
  config,
  lib,
  pkgs,
  ...
}:

let
  clipboard-history = pkgs.writeShellApplication {
    name = "clipboard-history";
    runtimeInputs = [
      pkgs.cliphist
      pkgs.wl-clipboard
      pkgs.libnotify
      pkgs.gnugrep
      pkgs.systemd
      config.programs.rofi.package
    ];
    text = builtins.readFile ./clipboard.sh;
  };
in
{
  services.cliphist = {
    enable = true;
    allowImages = true;
    # graphical-session.target is never reached: hyprland.systemd.enable is
    # false and greetd execs Hyprland directly. default.target is already
    # active in the user session, so nrs can start the watchers immediately.
    # Hyprland still imports WAYLAND_DISPLAY and restarts these on login.
    systemdTargets = [ "default.target" ];
  };

  systemd.user.services.cliphist.Service = {
    Restart = lib.mkForce "always";
    RestartSec = 2;
  };

  systemd.user.services.cliphist-images.Service = {
    Restart = lib.mkForce "always";
    RestartSec = 2;
  };

  home.packages = [ clipboard-history ];

  xdg.configFile."hypr/clipboard.sh" = {
    source = "${clipboard-history}/bin/clipboard-history";
    executable = true;
  };
}

{ pkgs, ... }:

let
  python-validity = pkgs.callPackage ../../../pkgs/python-validity { };
in
{
  # Do not enable services.fprintd — it fights open-fprintd for the same D-Bus
  # name, and stock libfprint cannot see 06cb:009a. pam_fprintd still talks to
  # open-fprintd. Hyprlock uses fprintd over D-Bus, so keep it off that PAM stack.
  services.fprintd.enable = false;

  # tuigreet is sequential PAM: fingerprint blocks the password field until it
  # fails. Boot goes straight into Hyprland + hyprlock, which can do both at once.
  services.greetd.settings.initial_session = {
    command = "${pkgs.writeShellScript "start-hyprland" ''
      legacy_config="$HOME/.config/hypr/hyprland.conf"
      if [ -f "$legacy_config" ] && ${pkgs.gnugrep}/bin/grep -q "This config is a STUB" "$legacy_config"; then
        rm "$legacy_config"
      fi
      exec /etc/profiles/per-user/shlok/bin/start-hyprland
    ''}";
    user = "shlok";
  };

  security.pam.services =
    let
      fprint = {
        fprintAuth = true;
        rules.auth.fprintd.settings = {
          "max-tries" = 3;
          timeout = 10;
        };
      };
    in
    {
      sudo = fprint;
      su = fprint;
      polkit-1 = fprint;
      greetd.fprintAuth = false;
      hyprlock.fprintAuth = false;
    };

  environment.systemPackages = [
    python-validity
    pkgs.fprintd # fprintd-enroll / fprintd-verify / fprintd-list
  ];

  services.udev.packages = [ python-validity ];
  services.dbus.packages = [
    python-validity
    pkgs.open-fprintd
  ];
  systemd.packages = [
    python-validity
    pkgs.open-fprintd
  ];

  systemd.tmpfiles.rules = [
    "d /var/lib/python-validity 0755 root root -"
  ];

  systemd.services.open-fprintd = {
    wantedBy = [ "multi-user.target" ];
  };

  systemd.services.open-fprintd-resume.wantedBy = [
    "suspend.target"
    "hibernate.target"
    "hybrid-sleep.target"
    "suspend-then-hibernate.target"
  ];

  systemd.services.open-fprintd-suspend.wantedBy = [
    "suspend.target"
    "hibernate.target"
    "hybrid-sleep.target"
    "suspend-then-hibernate.target"
  ];

  systemd.services.python3-validity = {
    wantedBy = [ "multi-user.target" ];
    wants = [ "open-fprintd.service" ];
    after = [ "open-fprintd.service" ];
    serviceConfig = {
      StateDirectory = "python-validity";
    };
  };

  # Keep the match-on-chip reader awake. TLP autosuspend otherwise parks it.
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="06cb", ATTR{idProduct}=="009a", TEST=="power/control", ATTR{power/control}="on"
  '';
}

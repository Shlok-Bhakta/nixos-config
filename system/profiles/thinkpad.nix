{ pkgs, ... }:

{
  hardware.enableRedistributableFirmware = true;
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-vaapi-driver
      libvdpau-va-gl
    ];
  };

  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0;
      CPU_HWP_DYN_BOOST_ON_AC = 1;
      CPU_HWP_DYN_BOOST_ON_BAT = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MAX_PERF_ON_BAT = 50;
      PLATFORM_PROFILE_ON_AC = "balanced";
      PLATFORM_PROFILE_ON_BAT = "low-power";
      WIFI_PWR_ON_AC = "off";
      WIFI_PWR_ON_BAT = "on";
      USB_AUTOSUSPEND = 1;
      USB_EXCLUDE_BTUSB = 1;
      SOUND_POWER_SAVE_ON_AC = 0;
      SOUND_POWER_SAVE_ON_BAT = 1;
    };
  };

  services.thermald.enable = true;
  services.fstrim.enable = true;
  services.fwupd.enable = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  environment.systemPackages = [
    (pkgs.writeShellScriptBin "power-profile-status" ''
      #!/bin/bash
      AC_ONLINE=""

      for ac in /sys/class/power_supply/AC* /sys/class/power_supply/ACAD* /sys/class/power_supply/ADP*; do
        if [ -f "$ac/online" ]; then
          AC_ONLINE=$(cat "$ac/online" 2>/dev/null)
          break
        fi
      done

      if [ "$AC_ONLINE" = "0" ]; then
        echo '{"text": "󰌪", "tooltip": "Power Saver", "class": "power-saver"}'
      else
        echo '{"text": "󰛲", "tooltip": "Balanced", "class": "balanced"}'
      fi
    '')
  ];
}

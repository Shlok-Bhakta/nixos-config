{ pkgs, ... }:

let
  led-off = path: ''
    if [ -e "${path}" ]; then
      printf '0\n' > "${path}" || true
    fi
  '';

  # Lid logo is decorative. Leave keyboard backlight alone while awake.
  thinkpad-lid-led-off = pkgs.writeShellScript "thinkpad-lid-led-off" ''
    ${led-off "/sys/class/leds/tpacpi::lid_logo_dot/brightness"}
    ${led-off "/sys/class/leds/tpacpi::thinkvantage/brightness"}
  '';

  # Keyboard / ThinkLight actually draw power if left on into suspend.
  thinkpad-sleep-leds-off = pkgs.writeShellScript "thinkpad-sleep-leds-off" ''
    ${thinkpad-lid-led-off}
    ${led-off "/sys/class/leds/tpacpi::thinklight/brightness"}
    ${led-off "/sys/class/leds/tpacpi::kbd_backlight/brightness"}
  '';
in
{
  imports = [
    ../features/fingerprint
  ];

  # Howdy is gone. Do not poke the IR camera firmware.
  services.linux-enable-ir-emitter.enable = false;

  hardware.enableRedistributableFirmware = true;
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-vaapi-driver
      libvdpau-va-gl
    ];
  };

  # Display C-states, framebuffer compression, panel self-refresh.
  # Deep S3 is the lid-closed battery win vs the kernel default of s2idle.
  boot.kernelParams = [
    "mem_sleep_default=deep"
    "nmi_watchdog=0"
    "i915.enable_psr=1"
    "i915.enable_fbc=1"
    "i915.enable_dc=2"
  ];

  services.tlp = {
    enable = true;
    settings = {
      TLP_ENABLE = 1;
      TLP_DEFAULT_MODE = "BAT";
      TLP_PERSISTENT_DEFAULT = 0;

      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0;
      CPU_HWP_DYN_BOOST_ON_AC = 1;
      CPU_HWP_DYN_BOOST_ON_BAT = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MAX_PERF_ON_BAT = 40;
      CPU_MIN_PERF_ON_AC = 0;
      CPU_MIN_PERF_ON_BAT = 0;

      PLATFORM_PROFILE_ON_AC = "performance";
      PLATFORM_PROFILE_ON_BAT = "low-power";

      # UHD 620: 300–1150 MHz. Cap the GT on battery; full clocks on AC.
      INTEL_GPU_MIN_FREQ_ON_AC = 300;
      INTEL_GPU_MIN_FREQ_ON_BAT = 300;
      INTEL_GPU_MAX_FREQ_ON_AC = 1150;
      INTEL_GPU_MAX_FREQ_ON_BAT = 600;
      INTEL_GPU_BOOST_FREQ_ON_AC = 1150;
      INTEL_GPU_BOOST_FREQ_ON_BAT = 600;

      PCIE_ASPM_ON_AC = "default";
      PCIE_ASPM_ON_BAT = "powersupersave";
      RUNTIME_PM_ON_AC = "on";
      RUNTIME_PM_ON_BAT = "auto";

      MEM_SLEEP_ON_AC = "s2idle";
      MEM_SLEEP_ON_BAT = "deep";

      WIFI_PWR_ON_AC = "off";
      WIFI_PWR_ON_BAT = "on";
      WOL_DISABLE = "Y";

      USB_AUTOSUSPEND = 1;
      USB_EXCLUDE_BTUSB = 1;

      SOUND_POWER_SAVE_ON_AC = 0;
      SOUND_POWER_SAVE_ON_BAT = 1;
      SOUND_POWER_SAVE_CONTROLLER = "Y";

      DISK_IDLE_SECS_ON_AC = 0;
      DISK_IDLE_SECS_ON_BAT = 2;
      DISK_APM_LEVEL_ON_AC = "254 254";
      DISK_APM_LEVEL_ON_BAT = "128 128";
      SATA_LINKPWR_ON_AC = "med_power_with_dipm max_performance";
      SATA_LINKPWR_ON_BAT = "min_power";
      AHCI_RUNTIME_PM_ON_AC = "on";
      AHCI_RUNTIME_PM_ON_BAT = "auto";

      NMI_WATCHDOG = 0;

      # Wired NIC + unused radios off on battery. Bluetooth stays available.
      DEVICES_TO_DISABLE_ON_BAT = "nfc wwan ethernet";
      DEVICES_TO_DISABLE_ON_BAT_NOT_IN_USE = "bluetooth";
      DEVICES_TO_ENABLE_ON_AC = "bluetooth wifi ethernet";
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

  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="net", KERNEL=="enp*", RUN+="${pkgs.ethtool}/bin/ethtool -s $name wol d"
    ACTION=="add", SUBSYSTEM=="leds", KERNEL=="tpacpi::lid_logo_dot", ATTR{brightness}="0"
    ACTION=="add", SUBSYSTEM=="leds", KERNEL=="*::kbd_backlight", RUN+="${pkgs.coreutils}/bin/chgrp video /sys/class/leds/%k/brightness", RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/leds/%k/brightness"
  '';

  # Lid logo off at boot. The power-button blink in deep S3 is the EC;
  # Linux cannot turn that one off.
  systemd.services.thinkpad-lid-led-off = {
    description = "Turn off ThinkPad lid logo LED";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = thinkpad-lid-led-off;
    };
  };

  environment.etc."systemd/system-sleep/thinkpad-leds" = {
    mode = "0755";
    source = pkgs.writeShellScript "thinkpad-leds-sleep" ''
      case "$1" in
        pre)
          ${thinkpad-sleep-leds-off}
          ;;
        post)
          ${thinkpad-lid-led-off}
          ;;
      esac
    '';
  };

  environment.systemPackages = [
    pkgs.powertop
    pkgs.ethtool
    (pkgs.writeShellScriptBin "power-profile-status" ''
      #!/bin/bash
      AC_ONLINE=""

      for ac in /sys/class/power_supply/AC* /sys/class/power_supply/ACAD* /sys/class/power_supply/ADP*; do
        if [ -f "$ac/online" ]; then
          AC_ONLINE=$(cat "$ac/online" 2>/dev/null)
          break
        fi
      done

      WATTS=""
      if [ -f /sys/class/power_supply/BAT0/power_now ]; then
        uw=$(cat /sys/class/power_supply/BAT0/power_now 2>/dev/null || echo 0)
        WATTS=$(awk "BEGIN { printf \"%.1f\", $uw / 1000000 }")
      fi

      if [ "$AC_ONLINE" = "0" ]; then
        echo "{\"text\": \"󰌪\", \"tooltip\": \"Power saver · ''${WATTS} W\", \"class\": \"power-saver\"}"
      else
        echo "{\"text\": \"󰛲\", \"tooltip\": \"AC goodies · turbo, blur, GIF wallpaper\", \"class\": \"balanced\"}"
      fi
    '')
  ];
}

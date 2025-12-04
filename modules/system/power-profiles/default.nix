{ config, lib, pkgs, ... }:

let
  cfg = config.custom.power-profiles;

  power-profile-status-script = pkgs.writeShellScriptBin "power-profile-status" ''
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
  '';

  msi-led-off = pkgs.writeShellScriptBin "msi-led-off" ''
    if [ -f /sys/class/leds/msiacpi::kbd_backlight/brightness ]; then
      echo 0 > /sys/class/leds/msiacpi::kbd_backlight/brightness 2>/dev/null || true
    fi
    for led in /sys/class/leds/msi::*; do
      if [ -f "$led/brightness" ]; then
        echo 0 > "$led/brightness" 2>/dev/null || true
      fi
    done
  '';

  msi-led-on = pkgs.writeShellScriptBin "msi-led-on" ''
    if [ -f /sys/class/leds/msiacpi::kbd_backlight/brightness ]; then
      echo 1 > /sys/class/leds/msiacpi::kbd_backlight/brightness 2>/dev/null || true
    fi
    for led in /sys/class/leds/msi::*; do
      if [ -f "$led/brightness" ]; then
        echo 1 > "$led/brightness" 2>/dev/null || true
      fi
    done
  '';

  wallpaper-switch = pkgs.writeShellScriptBin "wallpaper-switch" ''
    #!/bin/bash
    USER_ID=1000
    export WAYLAND_DISPLAY=wayland-1
    export XDG_RUNTIME_DIR=/run/user/$USER_ID
    
    if [ "$1" = "ac" ]; then
      ${pkgs.sudo}/bin/sudo -u shlok WAYLAND_DISPLAY=$WAYLAND_DISPLAY XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR ${pkgs.swww}/bin/swww img ${cfg.animatedWallpaper} --transition-type fade --transition-duration 1
    else
      ${pkgs.sudo}/bin/sudo -u shlok WAYLAND_DISPLAY=$WAYLAND_DISPLAY XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR ${pkgs.swww}/bin/swww img ${cfg.staticWallpaper} --transition-type fade --transition-duration 1
    fi
  '';

  power-plugged = pkgs.writeShellScriptBin "power-plugged" ''
    ${msi-led-on}/bin/msi-led-on
    ${pkgs.brightnessctl}/bin/brightnessctl set 100%
    ${wallpaper-switch}/bin/wallpaper-switch ac
  '';

  power-unplugged = pkgs.writeShellScriptBin "power-unplugged" ''
    ${msi-led-off}/bin/msi-led-off
    ${pkgs.brightnessctl}/bin/brightnessctl set 60%
    ${wallpaper-switch}/bin/wallpaper-switch battery
  '';
in
{
  options.custom.power-profiles = {
    enable = lib.mkEnableOption "power profiles with auto-switching";
    staticWallpaper = lib.mkOption {
      type = lib.types.path;
      description = "Static wallpaper for battery mode";
    };
    animatedWallpaper = lib.mkOption {
      type = lib.types.path;
      description = "Animated wallpaper for AC mode";
    };
  };

  config = lib.mkIf cfg.enable {
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
        CPU_MIN_PERF_ON_AC = 0;
        CPU_MIN_PERF_ON_BAT = 0;
        RUNTIME_PM_ON_AC = "auto";
        RUNTIME_PM_ON_BAT = "auto";
        RUNTIME_PM_DRIVER_DENYLIST = "nvidia";
        PCIE_ASPM_ON_AC = "default";
        PCIE_ASPM_ON_BAT = "powersupersave";
        WIFI_PWR_ON_AC = "off";
        WIFI_PWR_ON_BAT = "on";
        NMI_WATCHDOG = 0;
        PLATFORM_PROFILE_ON_AC = "balanced";
        PLATFORM_PROFILE_ON_BAT = "low-power";
        MEM_SLEEP_ON_AC = "s2idle";
        MEM_SLEEP_ON_BAT = "deep";
        USB_AUTOSUSPEND = 1;
        USB_EXCLUDE_BTUSB = 1;
        DISK_IDLE_SECS_ON_AC = 0;
        DISK_IDLE_SECS_ON_BAT = 2;
        DISK_APM_LEVEL_ON_AC = "254 254";
        DISK_APM_LEVEL_ON_BAT = "128 128";
        SATA_LINKPWR_ON_AC = "med_power_with_dipm max_performance";
        SATA_LINKPWR_ON_BAT = "min_power";
        AHCI_RUNTIME_PM_ON_AC = "on";
        AHCI_RUNTIME_PM_ON_BAT = "auto";
        SOUND_POWER_SAVE_ON_AC = 0;
        SOUND_POWER_SAVE_ON_BAT = 1;
        SOUND_POWER_SAVE_CONTROLLER = "Y";
      };
    };

    services.thermald.enable = true;

    boot.kernelParams = [
      "intel_pstate=active"
      "i915.enable_dc=2"
      "i915.enable_fbc=1"
      "i915.enable_psr=1"
    ];

    boot.extraModulePackages = with config.boot.kernelPackages; [ msi-ec ];
    boot.kernelModules = [ "msi-ec" ];

    services.udev.extraRules = ''
      SUBSYSTEM=="power_supply", ATTR{online}=="0", RUN+="${power-unplugged}/bin/power-unplugged"
      SUBSYSTEM=="power_supply", ATTR{online}=="1", RUN+="${power-plugged}/bin/power-plugged"
      ACTION=="add", SUBSYSTEM=="net", KERNEL=="eth*", RUN+="${pkgs.ethtool}/bin/ethtool -s $name wol d"
    '';

    environment.systemPackages = [
      power-profile-status-script
      pkgs.powertop
      msi-led-off
      msi-led-on
      wallpaper-switch
    ];
  };
}

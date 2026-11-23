{
  config,
  lib,
  pkgs,
  ...
}:

let
  batteryCpu = {
    CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
    CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
    CPU_BOOST_ON_BAT = 0;
    CPU_HWP_DYN_BOOST_ON_BAT = 0;
    CPU_MAX_PERF_ON_BAT = 100;
    CPU_MIN_PERF_ON_BAT = 0;
  };
  turboLiteCpu = batteryCpu // {
    CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_performance";
    CPU_BOOST_ON_BAT = 1;
    CPU_HWP_DYN_BOOST_ON_BAT = 1;
    # i7-8650U: 70% of the 4.2 GHz maximum is about 2.9 GHz.
    CPU_MAX_PERF_ON_BAT = 70;
  };
  balancedConfig = pkgs.writeText "thinkpad-balanced-cpu.conf" (
    lib.generators.toKeyValue { } batteryCpu
  );
  turboLiteConfig = pkgs.writeText "thinkpad-turbo-lite-cpu.conf" (
    lib.generators.toKeyValue { } turboLiteCpu
  );
  stateDir = "/run/thinkpad-power";
  tlp = "${config.services.tlp.package}/bin/tlp";
  tlpctl = "${config.services.tlp.pd.package}/bin/tlpctl";

  # Only these fixed profiles are authorized. No caller-supplied paths/settings.
  applyProfile = pkgs.writeShellApplication {
    name = "thinkpad-apply-power-profile";
    runtimeInputs = [
      pkgs.coreutils
      pkgs.util-linux
    ];
    text = ''
      if [ "$#" -ne 1 ]; then exit 2; fi
      case "$1" in
        turbo-lite) cpu_config=${turboLiteConfig}; tlp_mode=bat ;;
        balanced) cpu_config=${balancedConfig}; tlp_mode=balanced ;;
        performance) cpu_config=${balancedConfig}; tlp_mode=performance ;;
        power-saver) cpu_config=${balancedConfig}; tlp_mode=power-saver ;;
        *) exit 2 ;;
      esac
      install -d -m 0755 ${stateDir}
      exec 9>${stateDir}/lock
      flock 9
      ln -sfn "$cpu_config" ${stateDir}/cpu.conf.next
      mv -Tf ${stateDir}/cpu.conf.next ${stateDir}/cpu.conf
      # Native profile commands clear manual mode. Turbo lite uses manual BAT
      # mode to survive charger changes and suspend/resume.
      ${tlp} "$tlp_mode"
      printf '%s\n' "$1" > ${stateDir}/selected
      chmod 0644 ${stateDir}/selected
    '';
  };

  profileControl = pkgs.writeShellApplication {
    name = "thinkpad-power-profile";
    runtimeInputs = [ pkgs.coreutils ];
    text = ''
      case "''${1:-}" in
        get)
          native=$(${tlpctl} get)
          selected=$(cat ${stateDir}/selected 2>/dev/null || true)
          if [ "$native" = balanced ] && [ "$selected" = turbo-lite ] &&
             [ "$(readlink ${stateDir}/cpu.conf)" = "${turboLiteConfig}" ] &&
             [ "$(cat /sys/devices/system/cpu/intel_pstate/no_turbo)" = 0 ] &&
             [ "$(cat /sys/devices/system/cpu/intel_pstate/max_perf_pct)" = 70 ]; then
            echo turbo-lite
          else
            echo "$native"
          fi
          ;;
        set)
          if [ "$#" -ne 2 ]; then exit 2; fi
          case "$2" in
            turbo-lite|balanced|performance|power-saver)
              exec /run/wrappers/bin/sudo -n ${applyProfile}/bin/thinkpad-apply-power-profile "$2"
              ;;
            *) exit 2 ;;
          esac
          ;;
        *) exit 2 ;;
      esac
    '';
  };
in
{
  # Native TLP profiles remain unchanged. Only the BAT CPU settings are swapped
  # for the fourth menu option, with the rest of battery power saving retained.
  environment.etc."tlp.d/50-thinkpad-cpu.conf".source = "${stateDir}/cpu.conf";
  systemd.tmpfiles.rules = [
    "d ${stateDir} 0755 root root -"
    "L ${stateDir}/cpu.conf - - - - ${balancedConfig}"
  ];
  systemd.services.tlp.after = [ "systemd-tmpfiles-setup.service" ];
  # A service restart/rebuild resets the optional override to the battery
  # default and refreshes the store reference. Suspend/resume does not restart it.
  systemd.services.tlp.preStart = ''
    ${pkgs.coreutils}/bin/install -d -m 0755 ${stateDir}
    ${pkgs.coreutils}/bin/ln -sfn ${balancedConfig} ${stateDir}/cpu.conf
    printf 'balanced\n' > ${stateDir}/selected
    ${pkgs.coreutils}/bin/chmod 0644 ${stateDir}/selected
  '';

  services.tlp.settings =
    (lib.mapAttrs' (
      name: value: lib.nameValuePair (lib.replaceStrings [ "_ON_BAT" ] [ "_ON_SAV" ] name) value
    ) batteryCpu)
    // {
      CPU_MAX_PERF_ON_SAV = lib.mkForce 40;
    };

  security.sudo.extraRules = [
    {
      groups = [ "wheel" ];
      commands =
        map
          (profile: {
            command = "${applyProfile}/bin/thinkpad-apply-power-profile ${profile}";
            options = [ "NOPASSWD" ];
          })
          [
            "turbo-lite"
            "balanced"
            "performance"
            "power-saver"
          ];
    }
  ];
  environment.systemPackages = [ profileControl ];
}

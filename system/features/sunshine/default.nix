{ config, pkgs, ... }:

let
  mirrorOutputName = "DP-1";
  mirrorOutputMode = "640x480@60";
  mirrorOutputScale = "1";
  internalOutputName = "eDP-1";

  sunshineBasePort = 47989;
  sunshineTcpPorts = [
    (sunshineBasePort - 5)
    sunshineBasePort
    (sunshineBasePort + 21)
  ];
  sunshineUdpPorts = [
    (sunshineBasePort + 9)
    (sunshineBasePort + 10)
    (sunshineBasePort + 11)
    (sunshineBasePort + 13)
    (sunshineBasePort + 21)
  ];

  systemctlBin = "${pkgs.systemd}/bin/systemctl";
  hyprctlBin = "${config.programs.hyprland.package}/bin/hyprctl";
  sunshineBin = "${config.services.sunshine.package}/bin/sunshine";
  sleepBin = "${pkgs.coreutils}/bin/sleep";
  grepBin = "${pkgs.gnugrep}/bin/grep";

  sunshineIpad = pkgs.writeShellApplication {
    name = "sunshine-ipad";
    runtimeInputs = [
      pkgs.procps
      pkgs.coreutils
      pkgs.gnugrep
    ];
    text = ''
      set -euo pipefail

      output_name="''${SUNSHINE_IPAD_OUTPUT_NAME:-${mirrorOutputName}}"
      output_mode="''${SUNSHINE_IPAD_OUTPUT_MODE:-${mirrorOutputMode}}"
      output_scale="''${SUNSHINE_IPAD_OUTPUT_SCALE:-${mirrorOutputScale}}"
      internal_output_name="''${SUNSHINE_IPAD_INTERNAL_OUTPUT_NAME:-${internalOutputName}}"

      sunshine_state_file="''${XDG_CONFIG_HOME:-$HOME/.config}/sunshine/sunshine_state.json"

      monitor_exists() {
        "${hyprctlBin}" monitors all | "${grepBin}" -q "^Monitor ''${output_name} "
      }

      require_hyprland() {
        if [[ -z "''${HYPRLAND_INSTANCE_SIGNATURE-}" ]]; then
          printf 'Run this from inside your Hyprland session.\n' >&2
          exit 1
        fi
      }

      ensure_credentials() {
        local username password confirm_password

        if [[ -s "''${sunshine_state_file}" ]]; then
          return 0
        fi

        if [[ ! -t 0 ]]; then
          printf 'No Sunshine credentials found at %s. Run this interactively to create them.\n' "''${sunshine_state_file}" >&2
          exit 1
        fi

        printf 'No Sunshine web UI credentials found.\n'
        printf 'Create local credentials for https://localhost:%s\n' "$(( ${toString sunshineBasePort} + 1 ))"

        while [[ -z "''${username:-}" ]]; do
          printf 'Username: '
          IFS= read -r username
        done

        while true; do
          read -rsp 'Password: ' password
          printf '\n'
          read -rsp 'Confirm password: ' confirm_password
          printf '\n'

          if [[ -z "''${password}" ]]; then
            printf 'Password cannot be empty.\n' >&2
            continue
          fi

          if [[ "''${password}" != "''${confirm_password}" ]]; then
            printf 'Passwords did not match. Try again.\n' >&2
            continue
          fi

          break
        done

        "${sunshineBin}" --creds "''${username}" "''${password}"
        printf 'Saved Sunshine credentials to %s\n' "''${sunshine_state_file}"
      }

      enable_output() {
        "${hyprctlBin}" keyword monitor "''${output_name},''${output_mode},auto,''${output_scale},mirror,''${internal_output_name}"
        "${sleepBin}" 1

        if ! monitor_exists; then
          printf 'Output %s did not appear. Rebuild and reboot so the fake EDID is loaded first.\n' "''${output_name}" >&2
          exit 1
        fi
      }

      disable_output() {
        if ! monitor_exists; then
          return 0
        fi

        "${hyprctlBin}" keyword monitor "''${output_name},disable"
      }

      start_streaming() {
        require_hyprland
        ensure_credentials

        enable_output
        "${systemctlBin}" --user start sunshine.service

        printf 'Sunshine is up and %s is mirroring %s at %s.\n' "''${output_name}" "''${internal_output_name}" "''${output_mode}"
        printf 'Approve pairing or manage Sunshine at https://localhost:%s\n' "$(( ${toString sunshineBasePort} + 1 ))"
        printf 'In Moonlight, disable the touch controller overlay if it pops up.\n'
      }

      stop_streaming() {
        require_hyprland
        "${systemctlBin}" --user stop sunshine.service || true

        disable_output

        printf 'Sunshine is down and %s is disabled.\n' "''${output_name}"
      }

      reset_credentials() {
        "${systemctlBin}" --user stop sunshine.service || true

        if [[ -e "''${sunshine_state_file}" ]]; then
          rm -f "''${sunshine_state_file}"
          printf 'Removed Sunshine credentials at %s\n' "''${sunshine_state_file}"
        else
          printf 'No Sunshine credentials found at %s\n' "''${sunshine_state_file}"
        fi

        printf 'Next run of sunshine-ipad start will ask for new web UI credentials.\n'
      }

      show_status() {
        if [[ -n "''${HYPRLAND_INSTANCE_SIGNATURE-}" ]] && monitor_exists; then
          printf 'Output: %s present\n' "''${output_name}"
        else
          printf 'Output: %s absent\n' "''${output_name}"
        fi

        if "${systemctlBin}" --user is-active --quiet sunshine.service; then
          printf 'Sunshine: running\n'
        else
          printf 'Sunshine: stopped\n'
        fi
      }

      case "''${1:-start}" in
        start|on)
          start_streaming
          ;;
        stop|off)
          stop_streaming
          ;;
        restart)
          stop_streaming
          start_streaming
          ;;
        reset-creds)
          reset_credentials
          ;;
        status)
          show_status
          ;;
        *)
          printf 'Usage: sunshine-ipad [start|stop|restart|reset-creds|status]\n' >&2
          exit 1
          ;;
      esac
    '';
  };
in
{
  services.sunshine = {
    enable = true;
    autoStart = false;
    openFirewall = false;
    capSysAdmin = true;
    settings.port = sunshineBasePort;
  };

  networking.firewall.interfaces.tailscale0 = {
    allowedTCPPorts = sunshineTcpPorts;
    allowedUDPPorts = sunshineUdpPorts;
  };

  services.udev.extraRules = ''
    KERNEL=="uinput", MODE="0660", GROUP="input", OPTIONS+="static_node=uinput"
  '';

  environment.systemPackages = [ sunshineIpad ];
}

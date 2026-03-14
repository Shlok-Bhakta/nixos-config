{ config, pkgs, ... }:

let
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
  sunshineBin = "${config.services.sunshine.package}/bin/sunshine";

  sunshineIpad = pkgs.writeShellApplication {
    name = "sunshine-ipad";
    runtimeInputs = [ pkgs.procps ];
    text = ''
      set -euo pipefail

      sunshine_state_file="''${XDG_CONFIG_HOME:-$HOME/.config}/sunshine/sunshine_state.json"

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

      start_streaming() {
        ensure_credentials
        "${systemctlBin}" --user start sunshine.service

        printf 'Sunshine is up on your current desktop.\n'
        printf 'Approve pairing or manage Sunshine at https://localhost:%s\n' "$(( ${toString sunshineBasePort} + 1 ))"
        printf 'In Moonlight, disable the touch controller overlay if it pops up.\n'
      }

      stop_streaming() {
        "${systemctlBin}" --user stop sunshine.service || true
        printf 'Sunshine is down.\n'
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

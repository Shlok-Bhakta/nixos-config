{ config, pkgs, ... }:

let
  headlessOutputName = "IPAD-STREAM";
  headlessOutputMode = "1920x1440@60";
  headlessOutputScale = "1";

  hyprctlBin = "${config.programs.hyprland.package}/bin/hyprctl";
  systemctlBin = "${pkgs.systemd}/bin/systemctl";
  grepBin = "${pkgs.gnugrep}/bin/grep";
  sleepBin = "${pkgs.coreutils}/bin/sleep";

  sunshineIpad = pkgs.writeShellApplication {
    name = "sunshine-ipad";
    runtimeInputs = [ pkgs.procps ];
    text = ''
      set -euo pipefail

      output_name="${headlessOutputName}"
      output_mode="${headlessOutputMode}"
      output_scale="${headlessOutputScale}"

      monitor_exists() {
        "${hyprctlBin}" monitors all | "${grepBin}" -q "^Monitor ''${output_name} "
      }

      require_hyprland() {
        if [[ -z "''${HYPRLAND_INSTANCE_SIGNATURE-}" ]]; then
          printf 'Run this from inside your Hyprland session.\n' >&2
          exit 1
        fi
      }

      start_streaming() {
        require_hyprland

        if ! monitor_exists; then
          "${hyprctlBin}" output create headless "''${output_name}"
          "${sleepBin}" 1
        fi

        "${hyprctlBin}" keyword monitor "''${output_name},''${output_mode},auto-right,''${output_scale}"
        "${systemctlBin}" --user start sunshine.service

        printf 'Sunshine is up with headless output %s (%s).\n' "''${output_name}" "''${output_mode}"
        printf 'Open Moonlight after pairing and pick the desktop stream.\n'
      }

      stop_streaming() {
        require_hyprland

        "${systemctlBin}" --user stop sunshine.service || true

        if monitor_exists; then
          "${hyprctlBin}" output remove "''${output_name}"
        fi

        printf 'Sunshine is down and %s is removed.\n' "''${output_name}"
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
        status)
          show_status
          ;;
        *)
          printf 'Usage: sunshine-ipad [start|stop|restart|status]\n' >&2
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
    openFirewall = true;
    capSysAdmin = true;
  };

  environment.systemPackages = [ sunshineIpad ];
}

{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  primaryMonitor = config.home.sessionVariables.HYPRLAND_PRIMARY_MONITOR or "eDP-1";

  wallpaperPath = ../wallpapers/wallpaper.gif;
  backgroundPath = ./background.png;
  facePath = ./dragon.png;

  catppuccinColors = builtins.readFile ./hyprlock-colors.conf;
in
{
  config = {
    home.sessionVariables = {
      HYPRCURSOR_THEME = "bibata-ice-hypr";
      HYPRCURSOR_SIZE = "24";
    };

    xdg.configFile = {
      "hypr/hyprland.lua".source = ./hyprland.lua;
      "hypr/wallpaper.gif".source = wallpaperPath;
      "hypr/fn-keys.sh" = {
        source = ./fn-keys.sh;
        executable = true;
      };
    };

    home.activation.removeLegacyHyprlandStub = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
      legacy_config="$HOME/.config/hypr/hyprland.conf"

      if [ -f "$legacy_config" ] && ${pkgs.gnugrep}/bin/grep -q "This config is a STUB" "$legacy_config"; then
        rm "$legacy_config"
      fi
    '';

    home.file.".local/share/icons/bibata-ice-hypr" = {
      source = ./bibata-ice-hypr;
      recursive = true;
    };

    wayland.windowManager.hyprland = {
      enable = true;
      configType = "lua";
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      systemd.enable = false;
    };

    programs.hyprlock = {
      enable = true;
      package = pkgs.hyprlock;

      extraConfig = catppuccinColors + ''
        $accent = $teal
        $accentAlpha = $tealAlpha
        $font = CaskaydiaCove Nerd Font

        general {
          disable_loading_bar = true
          hide_cursor = true
        }

        background {
          monitor =
          path = ${backgroundPath}
          blur_passes = 0
          color = $base
        }

        label {
          monitor = ${primaryMonitor}
          text = $TIME
          color = $text
          font_size = 90
          font_family = $font
          position = -30, 0
          halign = right
          valign = top
        }

        label {
          monitor = ${primaryMonitor}
          text = cmd[update:43200000] date +"%A, %d %B %Y"
          color = $text
          font_size = 25
          font_family = $font
          position = -30, -150
          halign = right
          valign = top
        }

        image {
          monitor = ${primaryMonitor}
          path = ${facePath}
          size = 100
          border_color = $accent
          position = 0, 75
          halign = center
          valign = center
        }

        input-field {
          monitor = ${primaryMonitor}
          size = 300, 60
          outline_thickness = 4
          dots_size = 0.2
          dots_spacing = 0.2
          dots_center = true
          outer_color = $accent
          inner_color = $surface0
          font_color = $text
          fade_on_empty = false
          placeholder_text = <span foreground="##$textAlpha"><i>󰌾 Logged in as </i><span foreground="##$accentAlpha">$USER</span></span>
          hide_input = false
          check_color = $accent
          fail_color = $red
          fail_text = <i>$FAIL <b>($ATTEMPTS)</b></i>
          capslock_color = $yellow
          position = 0, -47
          halign = center
          valign = center
        }
      '';
    };

    services.hypridle = {
      enable = lib.mkDefault false;
      package = lib.mkDefault pkgs.hypridle;
    };

    systemd.user.services.polkit-gnome-authentication-agent = {
      Unit = {
        Description = "GNOME Polkit authentication agent";
        After = [ "dbus.service" ];
      };

      Service = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
      };

      Install.WantedBy = [ "default.target" ];
    };
  };
}

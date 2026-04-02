{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  monitorList =
    config.wayland.windowManager.hyprland.settings.monitor or [ "eDP-1, preferred, auto, 1" ];
  primaryMonitor = builtins.elemAt (lib.splitString "," (builtins.head monitorList)) 0;
  splitPluginEnabled = lib.any (p: lib.hasInfix "split-monitor-workspaces" (toString p)) (
    config.wayland.windowManager.hyprland.plugins or [ ]
  );

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

    home.file.".local/share/icons/bibata-ice-hypr" = {
      source = ./bibata-ice-hypr;
      recursive = true;
    };

    wayland.windowManager.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;

      plugins = lib.mkDefault [ ];

      extraConfig =
        lib.optionalString splitPluginEnabled ''
          plugin {
            split-monitor-workspaces {
              count = 10
              keep_focused = 0
              enable_notifications = 1
              enable_persistent_workspaces = 0
            }
          }
        ''
        + ''
          cursor {
            no_hardware_cursors = true
          }

          device {
            name = touch-passthrough-1
            output = DP-1
          }

          device {
            name = pen-passthrough
            output = DP-1
          }

          device {
            name = mouse-passthrough-(absolute)
            output = DP-1
          }
        '';

      settings = {
        exec-once = [
          "swww-daemon --format argb"
          "sleep 1; swww img ${wallpaperPath}"
          "sleep 1; waybar"
          "swaync"
          "wl-paste --type [text|image] --watch cliphist store"
          "kando"
          "vesktop"
          "syncthing"
        ]
        ++ lib.optionals splitPluginEnabled [
          "xrandr --output ${primaryMonitor} --primary"
        ];

        "$terminal" = "kitty";
        "$fileManager" = "nautilus";
        "$menu" = "rofi";
        "$mainMod" = "SUPER";

        monitor = lib.mkDefault [
          "eDP-1, preferred, auto, 1"
        ];

        general = {
          gaps_in = 5;
          gaps_out = 5;
          border_size = 2;
          "col.active_border" = "rgba(8aadf4ee) rgba(91d7e3ee) 45deg";
          "col.inactive_border" = "rgba(24273aaa)";
          resize_on_border = false;
          allow_tearing = false;
          layout = "dwindle";
        };

        decoration = {
          rounding = 10;
          active_opacity = 1.0;
          inactive_opacity = 1.0;
          blur = {
            enabled = true;
            size = 3;
            passes = 1;
            vibrancy = 0.1696;
          };
        };

        animations = {
          enabled = true;
          bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
          animation = [
            "windows, 1, 1, myBezier"
            "windowsOut, 1, 0.25, default"
            "border, 1, 10, default"
            "borderangle, 1, 1.5, default"
            "workspaces, 1, 0.5, default"
          ];
        };

        dwindle = {
          pseudotile = true;
          preserve_split = true;
        };

        misc = {
          force_default_wallpaper = 0;
          disable_hyprland_logo = false;
        };

        input = {
          kb_layout = "us";
          follow_mouse = 1;
          sensitivity = 0;
          touchpad = {
            natural_scroll = false;
          };
        };

        device = {
          name = "epic-mouse-v1";
          sensitivity = -0.5;
        };

        bind = [
          "$mainMod, Q, exec, $terminal"
          "$mainMod, C, killactive,"
          "$mainMod, M, exit,"
          "$mainMod, E, exec, $fileManager"
          "$mainMod, F, togglefloating,"
          "$mainMod, P, pseudo,"
          "$mainMod, J, togglesplit,"
          "$mainMod, W, exec, rofi -show drun"
          "$mainMod CTRL, R, exec, rofi -show calc"
          "$mainMod CTRL, W, exec, fuzzel"
          "$mainMod, V, exec, cliphist list | rofi -dmenu | cliphist decode | wl-copy"
          "$mainMod, B, exec, zen-beta"
          "$mainMod, Y, exec, code"
          "$mainMod, L, exec, hyprlock"
          "SUPER_SHIFT, F, fullscreen"
          "SUPER_SHIFT, S, exec, hyprshot -m region --freeze --clipboard-only"
          "SUPER_SHIFT, C, exec, hyprpicker 2>/dev/null | wl-copy"
          "$mainMod, T, exec, rofi -show emoji"
          "CONTROLALT, Delete, exec, bash ${config.home.homeDirectory}/.config/rofi/plugins/powermenu.sh"
          "$mainMod CTRL, Space, global, :main-menu"
          "$mainMod, left, movefocus, l"
          "$mainMod, right, movefocus, r"
          "$mainMod, up, movefocus, u"
          "$mainMod, down, movefocus, d"
          "$mainMod, D, togglespecialworkspace, magic"
          "$mainMod, mouse_down, workspace, e+1"
          "$mainMod, mouse_up, workspace, e-1"
          "SUPER ALT, right, resizeactive, 15 0"
          "SUPER ALT, left, resizeactive, -15 0"
          "SUPER ALT, up, resizeactive, 0 -15"
          "SUPER ALT, down, resizeactive, 0 15"
        ]
        ++ (
          if splitPluginEnabled then
            [
              "$mainMod, 1, split-workspace, 1"
              "$mainMod, 2, split-workspace, 2"
              "$mainMod, 3, split-workspace, 3"
              "$mainMod, 4, split-workspace, 4"
              "$mainMod, 5, split-workspace, 5"
              "$mainMod, 6, split-workspace, 6"
              "$mainMod, 7, split-workspace, 7"
              "$mainMod, 8, split-workspace, 8"
              "$mainMod, 9, split-workspace, 9"
              "$mainMod, 0, split-workspace, 10"
              "$mainMod SHIFT, 1, split-movetoworkspace, 1"
              "$mainMod SHIFT, 2, split-movetoworkspace, 2"
              "$mainMod SHIFT, 3, split-movetoworkspace, 3"
              "$mainMod SHIFT, 4, split-movetoworkspace, 4"
              "$mainMod SHIFT, 5, split-movetoworkspace, 5"
              "$mainMod SHIFT, 6, split-movetoworkspace, 6"
              "$mainMod SHIFT, 7, split-movetoworkspace, 7"
              "$mainMod SHIFT, 8, split-movetoworkspace, 8"
              "$mainMod SHIFT, 9, split-movetoworkspace, 9"
              "$mainMod SHIFT, 0, split-movetoworkspace, 10"
              "$mainMod SHIFT, D, split-movetoworkspace, special:magic"
            ]
          else
            [
              "$mainMod, 1, workspace, 1"
              "$mainMod, 2, workspace, 2"
              "$mainMod, 3, workspace, 3"
              "$mainMod, 4, workspace, 4"
              "$mainMod, 5, workspace, 5"
              "$mainMod, 6, workspace, 6"
              "$mainMod, 7, workspace, 7"
              "$mainMod, 8, workspace, 8"
              "$mainMod, 9, workspace, 9"
              "$mainMod, 0, workspace, 10"
              "$mainMod SHIFT, 1, movetoworkspace, 1"
              "$mainMod SHIFT, 2, movetoworkspace, 2"
              "$mainMod SHIFT, 3, movetoworkspace, 3"
              "$mainMod SHIFT, 4, movetoworkspace, 4"
              "$mainMod SHIFT, 5, movetoworkspace, 5"
              "$mainMod SHIFT, 6, movetoworkspace, 6"
              "$mainMod SHIFT, 7, movetoworkspace, 7"
              "$mainMod SHIFT, 8, movetoworkspace, 8"
              "$mainMod SHIFT, 9, movetoworkspace, 9"
              "$mainMod SHIFT, 0, movetoworkspace, 10"
              "$mainMod SHIFT, D, movetoworkspace, special:magic"
            ]
        );

        bindm = [
          "$mainMod, mouse:272, movewindow"
          "$mainMod, mouse:273, resizewindow"
        ];

        windowrule = [
          "suppress_event maximize, match:class .*"
          "border_color rgba(fab387ee) rgba(eba0acee) 45deg, match:class brave-browser"
          "border_color rgba(f9e2afee) rgba(f9e2afee) 45deg, match:class zen-beta"
          "border_color rgba(e78284ee) rgba(ea999cee) 45deg, match:title (.*)(YouTube)(.*)"
          "border_color rgba(cba6f7ee) rgba(f38ba8ee) rgba(fab387ee) rgba(a6e3a1ee) rgba(74c7ecee) 45deg, match:title (.*)(Catppuccin)(.*)"
          "border_color rgba(cba6f7ee) rgba(f38ba8ee) rgba(fab387ee) rgba(a6e3a1ee) rgba(74c7ecee) 45deg, match:title (.*)(catppuccin)(.*)"
          "border_color rgba(8bd5caee) rgba(91d7e3ee) 45deg, match:class code-url-handler"
          "border_color rgba(7287fdee) rgba(209fb5ee) 45deg, match:class vesktop"
          "border_color rgba(f5e0dcee) rgba(f2cdcdee) 45deg, match:float yes"
        ];
      };
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
  };
}

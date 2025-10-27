{ lib, config, pkgs, inputs, ... }:
let
  # wallpaper-path = /home/shlok/nixos-config/dotfiles/wallpaper/wallpaper.gif;
  unstable = import ../unstable.nix { inherit inputs pkgs; };
  wallpaper-path = ../dotfiles/wallpaper/wallpaper.gif;

in{
  home.sessionVariables = {
      # "enable_hyprcursor" = "0";
      "HYPRCURSOR_THEME" = "bibata-ice-hypr";
      "HYPRCURSOR_SIZE" = 24;
  };

  home.file.".local/share/icons/bibata-ice-hypr" = {
    source = ../dotfiles/bibata-ice-hypr;
    recursive = true;
  };
    # Enable Hyprland
  wayland.windowManager.hyprland = {
    enable = true;
    # extraConfig = builtins.readFile ./dotfiles/hyprland.conf;  

    settings = {
      exec-once = [
        "swww-daemon --format argb"
        "sleep 1; swww img ${wallpaper-path}"
        "sleep 1; waybar"
        "swaync"
        "wl-paste --type [text|image] --watch cliphist store"
        "kando"
        "vesktop"
        "syncthing"
      ];
      "$terminal" = "kitty";
      "$fileManager" = "nautilus";
      "$menu" = "rofi";
      general = { 
        gaps_in = 5;
        gaps_out = 5;
        border_size = 2;
        # https://wiki.hyprland.org/Configuring/Variables/#variable-types for info about colors
        "col.active_border" = "rgba(8aadf4ee) rgba(91d7e3ee) 45deg";
        "col.inactive_border" = "rgba(24273aaa)";
        # Set to true enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = false; 
        # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
        allow_tearing = false;
        layout = "dwindle";
      };
      decoration = {
        rounding = 10;
        # Change transparency of focused and unfocused windows
        active_opacity = 1.0;
        inactive_opacity = 1.0;
        # "col.shadow" = "rgba(1a1a1aee)";
        # https://wiki.hyprland.org/Configuring/Variables/#blur
        blur = {
            enabled = true;
            size = 3;
            passes = 1;
            vibrancy = 0.1696;
        };
      };
      animations = {
        enabled = true;
        # Default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more
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
        # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
        pseudotile = true; # Master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
        preserve_split = true; # You probably want this
      };
      misc = { 
        # https://wiki.hyprland.org/Configuring/Variables/#misc
        force_default_wallpaper = 0; # Set to 0 or 1 to disable the anime mascot wallpapers
        disable_hyprland_logo = false; # If true disables the random hyprland logo / anime girl background. :(
      };
      input = {
        kb_layout = "us";
        follow_mouse = 1;
        sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
        touchpad = {
          natural_scroll = false;
        };
      };
      device = {
        name = "epic-mouse-v1";
        sensitivity = -0.5;
      };
    "$mainMod" = "SUPER";
    bind = [
      # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
      "$mainMod, Q, exec, $terminal"
      "$mainMod, C, killactive,"
      "$mainMod, M, exit,"
      "$mainMod, E, exec, $fileManager"
      "$mainMod, F, togglefloating,"
      "$mainMod, P, pseudo, # dwindle"
      "$mainMod, J, togglesplit, # dwindle"
      "$mainMod, W, exec, rofi -show drun"
      "$mainMod CTRL, R, exec, rofi -show calc"
      "$mainMod CTRL, W, exec, fuzzel" 
      "$mainMod, V, exec, cliphist list | rofi -dmenu | cliphist decode | wl-copy"
      # "$mainMod CTRL, V, exec, cliphist list | fuzzel -dmenu | cliphist decode | wl-copy"
      "$mainMod, B, exec, zen"
      "$mainMod, Y, exec, code"
      "$mainMod, L, exec, hyprlock"
      "SUPER_SHIFT, F, fullscreen"
      ''SUPER_SHIFT, S, exec, hyprshot -m region --freeze --clipboard-only''
      ''SUPER_SHIFT, C, exec, hyprpicker | wl-copy''
      # "$mainMod, T, exec, bemoji"
      "$mainMod, T, exec, rofi -show emoji"
      "CONTROLALT, Delete, exec, bash /home/shlok/.config/rofi/plugins/powermenu.sh"
      "$mainMod CTRL, Space, global, :main-menu"

      # Move focus with mainMod + arrow keys
      "$mainMod, left, movefocus, l"
      "$mainMod, right, movefocus, r"
      "$mainMod, up, movefocus, u"
      "$mainMod, down, movefocus, d"

      # Example special workspace (scratchpad)
      "$mainMod, D, togglespecialworkspace, magic"

      # Scroll through existing workspaces with mainMod + scroll
      "$mainMod, mouse_down, workspace, e+1"
      "$mainMod, mouse_up, workspace, e-1"

      # resize window keybinds
      "SUPER ALT, right, resizeactive, 15 0"
      "SUPER ALT, left, resizeactive, -15 0"
      "SUPER ALT, up, resizeactive, 0 -15"
      "SUPER ALT, down, resizeactive, 0 15"

    ];
    bindm = [
      # Move/resize windows with mainMod + LMB/RMB and dragging
      "$mainMod, mouse:272, movewindow"
      "$mainMod, mouse:273, resizewindow"
    ];
    windowrule = [
      "suppressevent maximize, class:.*"
      "bordercolor rgba(fab387ee) rgba(eba0acee) 45deg,class:(brave-browser)"
      "bordercolor rgba(f9e2afee) rgba(f9e2afee) 45deg,class:(zen-alpha)"
      "bordercolor rgba(e78284ee) rgba(ea999cee) 45deg,title:(.*)(YouTube)(.*)$"
      "bordercolor rgba(cba6f7ee) rgba(f38ba8ee) rgba(fab387ee) rgba(a6e3a1ee) rgba(74c7ecee) 45deg, title:(.*)(Catppuccin)(.*)$"
      "bordercolor rgba(cba6f7ee) rgba(f38ba8ee) rgba(fab387ee) rgba(a6e3a1ee) rgba(74c7ecee) 45deg, title:(.*)(catppuccin)(.*)$"
      "bordercolor rgba(8bd5caee) rgba(91d7e3ee) 45deg,class:(code-url-handler)"
      "bordercolor rgba(7287fdee) rgba(209fb5ee) 45deg,class:(vesktop)"
      "bordercolor rgba(f5e0dcee) rgba(f2cdcdee) 45deg,floating:1"      
    ];
    };
  };
  # Hypridle
  services.hypridle = {
    package = unstable.hypridle;
    # settings = builtins.imprty
    settings = {
      "$lock_cmd" = "pidof hyprlock || hyprlock";
      "$suspend_cmd" = "pidof steam || systemctl suspend || loginctl suspend"; # f*** nvidia
      general = {
          lock_cmd = "$lock_cmd";
          before_sleep_cmd = "loginctl lock-session";
      };

      listener = [
        {
          timeout = 1200; # 20mins
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 1500; # 25mins
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        {
          timeout = 1800; # 30mins
          on-timeout = "$suspend_cmd";
        }
      ];
    };
  };
}
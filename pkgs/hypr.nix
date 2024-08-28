{ lib, config, pkgs, inputs, ... }:
let
  wallpaper-path = /home/shlok/nixos-config/dotfiles/wallpaper/wallpaper.gif;
  unstable = import ../unstable.nix { inherit inputs pkgs; };
in{
  home.packages = [
    unstable.hypridle
  ];
  # Enable Hyprland
  wayland.windowManager.hyprland = {
    enable = true;
    package = unstable.hyprland;
    # extraConfig = builtins.readFile ./dotfiles/hyprland.conf;  
    settings = {
      exec-once = [
        "swww img ${wallpaper-path}"
        "swww-daemon --format xrgb"
        "waybar"
        "swaync"
        "wl-paste --type [text|image] --watch cliphist store"
        "xrandr --output DP-1 --primary"
      ]; 
      monitor = [
        "DP-1, 1920x1080@144, 0x0, 1"
        "HDMI-A-1, 1920x1080@144, -1080x-650, 1, transform, 1"
      ];
      "$terminal" = "kitty";
      "$fileManager" = "yazi";
      "$menu" = "fuzzel";
      general = { 
        gaps_in = 5;
        gaps_out = 20;
        border_size = 2;
        # https://wiki.hyprland.org/Configuring/Variables/#variable-types for info about colors
        # "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        # "col.inactive_border" = "rgba(595959aa)";
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
        drop_shadow = true;
        shadow_range = 4;
        shadow_render_power = 3;
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
          "windows, 0.5, 7, myBezier"
          "windowsOut, 0.5, 7, default, popin 80%"
          "border, 0.5, 10, default"
          "borderangle, 0.5, 8, default"
          "fade, 0.5, 7, default"
          "workspaces, 0.5, 6, default"       
        ];
      };
      dwindle = {
        # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
        pseudotile = true; # Master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
        preserve_split = true; # You probably want this
      };
      misc = { 
        # https://wiki.hyprland.org/Configuring/Variables/#misc
        force_default_wallpaper = -1; # Set to 0 or 1 to disable the anime mascot wallpapers
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
      gestures = {
        workspace_swipe = false;
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
      "$mainMod, R, exec, $menu"
      "$mainMod, P, pseudo, # dwindle"
      "$mainMod, J, togglesplit, # dwindle"
      "$mainMod, W, exec, fuzzel"
      "$mainMod, V, exec, cliphist list | fuzzel -d | cliphist decode | wl-copy"
      "$mainMod, B, exec, brave"
      "$mainMod, Y, exec, code"
      "$mainMod, L, exec, hyprlock"
      ''SUPER_SHIFT, S, exec, grim -g "$(slurp -d)" - | wl-copy''
      "$mainMod, T, exec, bemoji"

      # Move focus with mainMod + arrow keys
      "$mainMod, left, movefocus, l"
      "$mainMod, right, movefocus, r"
      "$mainMod, up, movefocus, u"
      "$mainMod, down, movefocus, d"

      # Switch workspaces with mainMod + [0-9]
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

      # Move active window to a workspace with mainMod + SHIFT + [0-9]
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

      # Example special workspace (scratchpad)
      "$mainMod, D, togglespecialworkspace, magic"
      "$mainMod SHIFT, D, movetoworkspace, special:magic"

      # Scroll through existing workspaces with mainMod + scroll
      "$mainMod, mouse_down, workspace, e+1"
      "$mainMod, mouse_up, workspace, e-1"

    ];
    bindm = [
      # Move/resize windows with mainMod + LMB/RMB and dragging
      "$mainMod, mouse:272, movewindow"
      "$mainMod, mouse:273, resizewindow"
    ];
    windowrulev2 = "suppressevent maximize, class:.*";
    };
  };
  # Enable Hyprlock
  programs.hyprlock = {
    enable = true;
    package = unstable.hyprlock;
    # settings = builtins.imprty
    extraConfig = builtins.readFile ../dotfiles/hypr/hyprlock.conf;
  };
  # Hypridle
  services.hypridle = {
    enable = true;
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
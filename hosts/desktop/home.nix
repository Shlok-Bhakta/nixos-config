{ inputs, ... }:

{
  imports = [
    ../shared/home.nix
  ];

  custom = {
    hyprland = {
      isLaptop = false;
      enableSplitWorkspaces = true;
      package = inputs.hyprland.packages.x86_64-linux.hyprland;
      plugins = [
        inputs.split-monitor-workspaces.packages.x86_64-linux.split-monitor-workspaces
      ];
      monitors = [
        {
          name = "DP-1";
          resolution = "1920x1080@144";
          position = "0x0";
          scale = 1;
          isPrimary = true;
        }
        {
          name = "HDMI-A-1";
          resolution = "1920x1080@144";
          position = "-1080x-650";
          scale = 1;
          transform = 1;
        }
      ];
      extraHyprlandConfig = ''
        plugin {
          split-monitor-workspaces {
            count = 10
            keep_focused = 0
            enable_notifications = 1
            enable_persistent_workspaces = 0
          }
        }

        cursor {
          no_hardware_cursors = true
        }
      '';
      extraExecOnce = [
        "xrandr --output DP-1 --primary"
      ];
    };

    waybar = {
      isLaptop = false;
    };

    wallpapers = {
      animated = ../../modules/home/wallpapers/wallpaper.gif;
    };
  };
}

{ config, lib, pkgs, ... }:

let
  cfg = config.custom.wlogout;
in
{
  options.custom.wlogout = {
    enable = lib.mkEnableOption "wlogout logout menu";
  };

  config = lib.mkIf cfg.enable {
    programs.wlogout = {
      enable = true;
      layout = [
        {
          label = "lock";
          action = "hyprlock";
          text = "Lock";
          keybind = "l";
        }
        {
          label = "hibernate";
          action = "systemctl hibernate";
          text = "Hibernate";
          keybind = "h";
        }
        {
          label = "logout";
          action = "hyprctl dispatch exit 0";
          text = "Logout";
          keybind = "e";
        }
        {
          label = "shutdown";
          action = "systemctl poweroff";
          text = "Shutdown";
          keybind = "s";
        }
        {
          label = "suspend";
          action = "systemctl suspend";
          text = "Suspend";
          keybind = "u";
        }
        {
          label = "reboot";
          action = "systemctl reboot";
          text = "Reboot";
          keybind = "r";
        }
      ];
      style = ''
        * {
          background-image: none;
        }
        window {
          background-color: rgba(30, 30, 46, 0.9);
        }
        button {
          color: #cdd6f4;
          background-color: #313244;
          border-style: solid;
          border-width: 2px;
          background-repeat: no-repeat;
          background-position: center;
          background-size: 25%;
        }
        button:focus, button:active, button:hover {
          background-color: #45475a;
          outline-style: none;
        }
        #lock {
            background-image: url("/home/shlok/.config/wlogout/icons/lock.svg");
        }

        #logout {
            background-image: url("/home/shlok/.config/wlogout/icons/logout.svg");
        }

        #suspend {
            background-image: url("/home/shlok/.config/wlogout/icons/suspend.svg");
        }

        #hibernate {
            background-image: url("/home/shlok/.config/wlogout/icons/hibernate.svg");
        }

        #shutdown {
            background-image: url("/home/shlok/.config/wlogout/icons/shutdown.svg");
        }

        #reboot {
            background-image: url("/home/shlok/.config/wlogout/icons/reboot.svg");
        }
      '';
    };
  };
}
